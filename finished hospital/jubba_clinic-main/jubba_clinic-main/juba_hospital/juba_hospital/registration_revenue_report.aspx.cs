using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class registration_revenue_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static RegistrationReportData GetRegistrationReport(string dateRange, string startDate, string endDate, string paymentStatus, string patientSearch)
        {
            RegistrationReportData report = new RegistrationReportData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            string dateCondition = GetDateCondition(dateRange, startDate, endDate);
            string paymentCondition = GetPaymentCondition(paymentStatus);
            string searchCondition = GetSearchCondition(patientSearch);

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get statistics
                report.statistics = GetStatistics(con, dateCondition, paymentCondition, searchCondition);

                // Get detailed records
                report.details = GetDetails(con, dateCondition, paymentCondition, searchCondition);

                // Get daily breakdown
                report.dailyBreakdown = GetDailyBreakdown(con, dateCondition, paymentCondition, searchCondition);
            }

            return report;
        }

        private static string GetDateCondition(string dateRange, string startDate, string endDate)
        {
            switch (dateRange.ToLower())
            {
                case "today":
                    return "CAST(pc.date_added AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday":
                    return "CAST(pc.date_added AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek":
                    return "DATEPART(week, pc.date_added) = DATEPART(week, GETDATE()) AND DATEPART(year, pc.date_added) = DATEPART(year, GETDATE())";
                case "thismonth":
                    return "DATEPART(month, pc.date_added) = DATEPART(month, GETDATE()) AND DATEPART(year, pc.date_added) = DATEPART(year, GETDATE())";
                case "lastmonth":
                    return "DATEPART(month, pc.date_added) = DATEPART(month, DATEADD(month, -1, GETDATE())) AND DATEPART(year, pc.date_added) = DATEPART(year, DATEADD(month, -1, GETDATE()))";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        return $"CAST(pc.date_added AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    }
                    return "CAST(pc.date_added AS DATE) = CAST(GETDATE() AS DATE)";
                default:
                    return "CAST(pc.date_added AS DATE) = CAST(GETDATE() AS DATE)";
            }
        }

        private static string GetPaymentCondition(string paymentStatus)
        {
            switch (paymentStatus.ToLower())
            {
                case "paid":
                    return "AND pc.is_paid = 1";
                case "unpaid":
                    return "AND pc.is_paid = 0";
                default:
                    return "";
            }
        }

        private static string GetSearchCondition(string patientSearch)
        {
            if (!string.IsNullOrEmpty(patientSearch))
            {
                return $"AND p.full_name LIKE '%{patientSearch}%'";
            }
            return "";
        }

        private static RegistrationStatistics GetStatistics(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            RegistrationStatistics stats = new RegistrationStatistics();

            string query = $@"
                SELECT 
                    ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) AS total_revenue,
                    COUNT(*) AS total_count,
                    ISNULL(AVG(pc.amount), 0) AS average_fee,
                    SUM(CASE WHEN pc.is_paid = 0 THEN 1 ELSE 0 END) AS pending_count
                FROM patient_charges pc
                INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = 'Registration'
                AND {dateCondition}
                {paymentCondition}
                {searchCondition}
            ";

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

        private static List<RegistrationDetail> GetDetails(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<RegistrationDetail> details = new List<RegistrationDetail>();

            string query = $@"
                SELECT 
                    pc.charge_id,
                    pc.invoice_number,
                    pc.charge_name,
                    pc.amount,
                    pc.is_paid,
                    pc.date_added,
                    pc.paid_date,
                    pc.patientid,
                    p.full_name AS patient_name,
                    p.phone
                FROM patient_charges pc
                INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = 'Registration'
                AND {dateCondition}
                {paymentCondition}
                {searchCondition}
                ORDER BY pc.date_added DESC
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        RegistrationDetail detail = new RegistrationDetail();
                        detail.charge_id = dr["charge_id"].ToString();
                        detail.invoice_number = dr["invoice_number"].ToString();
                        detail.patientid = dr["patientid"].ToString();
                        detail.patient_name = dr["patient_name"].ToString();
                        detail.phone = dr["phone"].ToString();
                        detail.charge_name = dr["charge_name"].ToString();
                        detail.amount = dr["amount"].ToString();
                        // Convert bit field to "1" or "0" string explicitly
                        detail.is_paid = (dr["is_paid"] != DBNull.Value && Convert.ToBoolean(dr["is_paid"])) ? "1" : "0";
                        detail.date_registered = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd");
                        // Use date_added as paid_date (when charge was registered/created)
                        detail.paid_date = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd HH:mm");
                        details.Add(detail);
                    }
                }
            }

            return details;
        }

        private static List<DailyBreakdown> GetDailyBreakdown(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<DailyBreakdown> breakdown = new List<DailyBreakdown>();

            string query = $@"
                SELECT 
                    CAST(pc.date_added AS DATE) AS date,
                    SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END) AS revenue
                FROM patient_charges pc
                INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = 'Registration'
                AND {dateCondition}
                {paymentCondition}
                {searchCondition}
                GROUP BY CAST(pc.date_added AS DATE)
                ORDER BY CAST(pc.date_added AS DATE)
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        DailyBreakdown daily = new DailyBreakdown();
                        daily.date = Convert.ToDateTime(dr["date"]).ToString("MMM dd");
                        daily.revenue = dr["revenue"].ToString();
                        breakdown.Add(daily);
                    }
                }
            }

            return breakdown;
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
            catch (Exception ex)
            {
                return "false";
            }
        }

        // Data classes
        public class RegistrationReportData
        {
            public RegistrationStatistics statistics { get; set; }
            public List<RegistrationDetail> details { get; set; }
            public List<DailyBreakdown> dailyBreakdown { get; set; }
        }

        public class RegistrationStatistics
        {
            public string total_revenue { get; set; }
            public string total_count { get; set; }
            public string average_fee { get; set; }
            public string pending_count { get; set; }
        }

        public class RegistrationDetail
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
    }
}
