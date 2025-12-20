using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class bed_revenue_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static BedReportData GetBedReport(string dateRange, string startDate, string endDate, string paymentStatus, string patientSearch)
        {
            BedReportData report = new BedReportData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            string dateCondition = GetDateCondition(dateRange, startDate, endDate);
            string paymentCondition = GetPaymentCondition(paymentStatus);
            string searchCondition = GetSearchCondition(patientSearch);

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                report.statistics = GetStatistics(con, dateCondition, paymentCondition, searchCondition);
                report.details = GetDetails(con, dateCondition, paymentCondition, searchCondition);
                report.dailyBreakdown = GetDailyBreakdown(con, dateCondition, paymentCondition, searchCondition);
                report.chargeDistribution = GetChargeDistribution(con, dateCondition, paymentCondition, searchCondition);
            }

            return report;
        }

        private static string GetDateCondition(string dateRange, string startDate, string endDate)
        {
            switch (dateRange.ToLower())
            {
                case "today": return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday": return "CAST(pbc.created_at AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek": return "DATEPART(week, pbc.created_at) = DATEPART(week, GETDATE()) AND DATEPART(year, pbc.created_at) = DATEPART(year, GETDATE())";
                case "thismonth": return "DATEPART(month, pbc.created_at) = DATEPART(month, GETDATE()) AND DATEPART(year, pbc.created_at) = DATEPART(year, GETDATE())";
                case "lastmonth": return "DATEPART(month, pbc.created_at) = DATEPART(month, DATEADD(month, -1, GETDATE())) AND DATEPART(year, pbc.created_at) = DATEPART(year, DATEADD(month, -1, GETDATE()))";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                        return $"CAST(pbc.created_at AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
                default: return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
            }
        }

        private static string GetPaymentCondition(string paymentStatus)
        {
            return paymentStatus.ToLower() == "paid" ? "AND pbc.is_paid = 1" : paymentStatus.ToLower() == "unpaid" ? "AND pbc.is_paid = 0" : "";
        }

        private static string GetSearchCondition(string patientSearch)
        {
            return !string.IsNullOrEmpty(patientSearch) ? $"AND p.full_name LIKE '%{patientSearch}%'" : "";
        }

        private static BedStatistics GetStatistics(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            BedStatistics stats = new BedStatistics();
            string query = $@"
                SELECT 
                    ISNULL(SUM(CASE WHEN pbc.is_paid = 1 THEN pbc.bed_charge_amount ELSE 0 END), 0) AS total_revenue,
                    COUNT(*) AS total_count,
                    ISNULL(AVG(pbc.bed_charge_amount), 0) AS average_fee,
                    SUM(CASE WHEN pbc.is_paid = 0 THEN 1 ELSE 0 END) AS pending_count
                FROM patient_bed_charges pbc
                INNER JOIN patient p ON pbc.patientid = p.patientid
                WHERE {dateCondition} {paymentCondition} {searchCondition}";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        stats.total_revenue = dr["total_revenue"].ToString();
                        stats.total_count = dr["total_count"].ToString();
                        stats.average_fee = dr["average_fee"].ToString();
                        stats.pending_count = dr["pending_count"].ToString();
                    }
                }
            }
            return stats;
        }

        private static List<BedDetail> GetDetails(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<BedDetail> details = new List<BedDetail>();
            string query = $@"
                SELECT 
                    pbc.bed_charge_id as charge_id, 
                    '' as invoice_number, 
                    'Bed Charge - Day ' + CAST(DATEDIFF(DAY, ISNULL(p.bed_admission_date, pbc.charge_date), pbc.charge_date) + 1 AS VARCHAR) as charge_name, 
                    pbc.bed_charge_amount as amount, 
                    pbc.is_paid, 
                    pbc.created_at as date_added, 
                    NULL as paid_date, 
                    pbc.patientid, 
                    p.full_name AS patient_name, 
                    p.phone
                FROM patient_bed_charges pbc 
                INNER JOIN patient p ON pbc.patientid = p.patientid
                WHERE {dateCondition} {paymentCondition} {searchCondition}
                ORDER BY pbc.created_at DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        details.Add(new BedDetail
                        {
                            charge_id = dr["charge_id"].ToString(),
                            invoice_number = dr["invoice_number"].ToString(),
                            patientid = dr["patientid"].ToString(),
                            patient_name = dr["patient_name"].ToString(),
                            phone = dr["phone"].ToString(),
                            charge_name = dr["charge_name"].ToString(),
                            amount = dr["amount"].ToString(),
                            is_paid = (dr["is_paid"] != DBNull.Value && Convert.ToBoolean(dr["is_paid"])) ? "1" : "0",
                            date_registered = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd"),
                            paid_date = dr["paid_date"] != DBNull.Value ? Convert.ToDateTime(dr["paid_date"]).ToString("yyyy-MM-dd HH:mm") : ""
                        });
                    }
                }
            }
            return details;
        }

        private static List<DailyBreakdown> GetDailyBreakdown(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<DailyBreakdown> breakdown = new List<DailyBreakdown>();
            // Align aliases for patient_charges (pc) since dateCondition/paymentCondition were built for pbc
            string pcDateCondition = dateCondition.Replace("pbc.", "pc.").Replace("pc.created_at", "pc.date_added");
            string pcPaymentCondition = paymentCondition.Replace("pbc.", "pc.");
            string query = $@"
                SELECT CAST(pc.date_added AS DATE) AS date, SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END) AS revenue
                FROM patient_charges pc INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = 'Bed' AND {pcDateCondition} {pcPaymentCondition} {searchCondition}
                GROUP BY CAST(pc.date_added AS DATE) ORDER BY CAST(pc.date_added AS DATE)";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        breakdown.Add(new DailyBreakdown
                        {
                            date = Convert.ToDateTime(dr["date"]).ToString("MMM dd"),
                            revenue = dr["revenue"].ToString()
                        });
                    }
                }
            }
            return breakdown;
        }

        private static List<ChargeDistribution> GetChargeDistribution(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<ChargeDistribution> distribution = new List<ChargeDistribution>();
            // Align aliases and columns for patient_charges (pc)
            string pcDateCondition = dateCondition
                .Replace("pbc.", "pc.")
                .Replace("pc.created_at", "pc.date_added");
            string pcPaymentCondition = paymentCondition.Replace("pbc.", "pc.");
            string query = $@"
                SELECT TOP 5 pc.charge_name, SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END) AS revenue
                FROM patient_charges pc INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = 'Bed' AND {pcDateCondition} {pcPaymentCondition} {searchCondition}
                GROUP BY pc.charge_name ORDER BY revenue DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        distribution.Add(new ChargeDistribution
                        {
                            charge_name = dr["charge_name"].ToString(),
                            revenue = dr["revenue"].ToString()
                        });
                    }
                }
            }
            return distribution;
        }

        [WebMethod]
        public static string MarkAsPaid(int chargeId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "UPDATE patient_charges SET is_paid = 1, paid_date = GETDATE() WHERE charge_id = @chargeId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@chargeId", chargeId);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch { return "false"; }
        }

        public class BedReportData
        {
            public BedStatistics statistics { get; set; }
            public List<BedDetail> details { get; set; }
            public List<DailyBreakdown> dailyBreakdown { get; set; }
            public List<ChargeDistribution> chargeDistribution { get; set; }
        }

        public class BedStatistics
        {
            public string total_revenue { get; set; }
            public string total_count { get; set; }
            public string average_fee { get; set; }
            public string pending_count { get; set; }
        }

        public class BedDetail
        {
            public string charge_id { get; set; }
            public string invoice_number { get; set; }
            public string patientid { get; set; }
            public string patient_name { get; set; }
            public string phone { get; set; }
            public string charge_name { get; set; }
            public string amount { get; set; }
            public string is_paid { get; set; }
            public string date_registered { get; set; }
            public string paid_date { get; set; }
        }

        public class DailyBreakdown
        {
            public string date { get; set; }
            public string revenue { get; set; }
        }

        public class ChargeDistribution
        {
            public string charge_name { get; set; }
            public string revenue { get; set; }
        }
    }
}
