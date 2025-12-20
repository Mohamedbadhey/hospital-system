using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class financial_reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static ReportData GetRevenueReport(string reportType, string startDate, string endDate)
        {
            ReportData report = new ReportData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            // Determine date range based on report type
            string dateCondition = GetDateCondition(reportType, startDate, endDate);
            string pharmacyDateCondition = GetDateConditionForPharmacy(reportType, startDate, endDate);

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get summary data
                report.summary = GetSummaryData(con, dateCondition, pharmacyDateCondition);

                // Get detailed data for each category
                report.registration_details = GetChargeDetails(con, "Registration", dateCondition);
                report.lab_details = GetChargeDetails(con, "Lab", dateCondition);
                report.xray_details = GetChargeDetails(con, "Xray", dateCondition);
                report.bed_details = GetChargeDetails(con, "Bed", dateCondition);
                report.delivery_details = GetChargeDetails(con, "Delivery", dateCondition);
                report.pharmacy_details = GetPharmacyDetails(con, pharmacyDateCondition);
            }

            return report;
        }

        private static string GetDateCondition(string reportType, string startDate, string endDate)
        {
            switch (reportType.ToLower())
            {
                case "today":
                    return "CAST(date_added AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday":
                    return "CAST(date_added AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek":
                    return "DATEPART(week, date_added) = DATEPART(week, GETDATE()) AND DATEPART(year, date_added) = DATEPART(year, GETDATE())";
                case "thismonth":
                    return "DATEPART(month, date_added) = DATEPART(month, GETDATE()) AND DATEPART(year, date_added) = DATEPART(year, GETDATE())";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        return $"CAST(date_added AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    }
                    return "CAST(date_added AS DATE) = CAST(GETDATE() AS DATE)";
                default:
                    return "CAST(date_added AS DATE) = CAST(GETDATE() AS DATE)";
            }
        }

        private static string GetDateConditionForPharmacy(string reportType, string startDate, string endDate)
        {
            switch (reportType.ToLower())
            {
                case "today":
                    return "CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday":
                    return "CAST(sale_date AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek":
                    return "DATEPART(week, sale_date) = DATEPART(week, GETDATE()) AND DATEPART(year, sale_date) = DATEPART(year, GETDATE())";
                case "thismonth":
                    return "DATEPART(month, sale_date) = DATEPART(month, GETDATE()) AND DATEPART(year, sale_date) = DATEPART(year, GETDATE())";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        return $"CAST(sale_date AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    }
                    return "CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)";
                default:
                    return "CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)";
            }
        }

        private static RevenueSummary GetSummaryData(SqlConnection con, string dateCondition, string pharmacyDateCondition)
        {
            RevenueSummary summary = new RevenueSummary();

            string query = $@"
                DECLARE @RegistrationRevenue FLOAT = 0;
                DECLARE @LabRevenue FLOAT = 0;
                DECLARE @XrayRevenue FLOAT = 0;
                DECLARE @BedRevenue FLOAT = 0;
                DECLARE @DeliveryRevenue FLOAT = 0;
                DECLARE @PharmacyRevenue FLOAT = 0;

                -- Get charges revenue
                SELECT 
                    @RegistrationRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Registration' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                    @LabRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Lab' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                    @XrayRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Xray' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                    @BedRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Bed' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                    @DeliveryRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Delivery' AND is_paid = 1 THEN amount ELSE 0 END), 0)
                FROM patient_charges
                WHERE {dateCondition};

                -- Get pharmacy revenue
                SELECT @PharmacyRevenue = ISNULL(SUM(total_amount), 0)
                FROM pharmacy_sales
                WHERE {pharmacyDateCondition};

                SELECT 
                    (@RegistrationRevenue + @LabRevenue + @XrayRevenue + @BedRevenue + @DeliveryRevenue + @PharmacyRevenue) AS total_revenue,
                    @RegistrationRevenue AS registration_revenue,
                    @LabRevenue AS lab_revenue,
                    @XrayRevenue AS xray_revenue,
                    @BedRevenue AS bed_revenue,
                    @DeliveryRevenue AS delivery_revenue,
                    @PharmacyRevenue AS pharmacy_revenue
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        summary.total_revenue = dr["total_revenue"].ToString();
                        summary.registration_revenue = dr["registration_revenue"].ToString();
                        summary.lab_revenue = dr["lab_revenue"].ToString();
                        summary.xray_revenue = dr["xray_revenue"].ToString();
                        summary.bed_revenue = dr["bed_revenue"].ToString();
                        summary.delivery_revenue = dr["delivery_revenue"].ToString();
                        summary.pharmacy_revenue = dr["pharmacy_revenue"].ToString();
                    }
                }
            }

            return summary;
        }

        private static List<ChargeDetail> GetChargeDetails(SqlConnection con, string chargeType, string dateCondition)
        {
            List<ChargeDetail> details = new List<ChargeDetail>();

            string query = $@"
                SELECT 
                    pc.charge_name,
                    pc.amount,
                    pc.paid_date,
                    pc.invoice_number,
                    p.full_name AS patient_name
                FROM patient_charges pc
                INNER JOIN patient p ON pc.patientid = p.patientid
                WHERE pc.charge_type = @chargeType 
                AND pc.is_paid = 1
                AND {dateCondition}
                ORDER BY pc.date_added DESC
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@chargeType", chargeType);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ChargeDetail detail = new ChargeDetail();
                        detail.patient_name = dr["patient_name"].ToString();
                        detail.charge_name = dr["charge_name"].ToString();
                        detail.amount = dr["amount"].ToString();
                        detail.paid_date = (dr["paid_date"] != DBNull.Value)
                            ? Convert.ToDateTime(dr["paid_date"]).ToString("yyyy-MM-dd HH:mm")
                            : string.Empty;
                        detail.invoice_number = dr["invoice_number"].ToString();
                        details.Add(detail);
                    }
                }
            }

            return details;
        }

        private static List<PharmacyDetail> GetPharmacyDetails(SqlConnection con, string pharmacyDateCondition)
        {
            List<PharmacyDetail> details = new List<PharmacyDetail>();

            string query = $@"
                SELECT 
                    ps.sale_id,
                    ps.customer_name,
                    ps.total_amount,
                    ps.payment_method,
                    ps.sale_date
                FROM pharmacy_sales ps
                WHERE {pharmacyDateCondition}
                ORDER BY ps.sale_date DESC
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        PharmacyDetail detail = new PharmacyDetail();
                        detail.sale_id = dr["sale_id"].ToString();
                        detail.customer_name = dr["customer_name"].ToString();
                        detail.total_amount = dr["total_amount"].ToString();
                        detail.payment_method = dr["payment_method"].ToString();
                        detail.sale_date = Convert.ToDateTime(dr["sale_date"]).ToString("yyyy-MM-dd HH:mm");
                        details.Add(detail);
                    }
                }
            }

            return details;
        }

        // Data classes
        public class ReportData
        {
            public RevenueSummary summary { get; set; }
            public List<ChargeDetail> registration_details { get; set; }
            public List<ChargeDetail> lab_details { get; set; }
            public List<ChargeDetail> xray_details { get; set; }
            public List<ChargeDetail> bed_details { get; set; }
            public List<ChargeDetail> delivery_details { get; set; }
            public List<PharmacyDetail> pharmacy_details { get; set; }
        }

        public class RevenueSummary
        {
            public string total_revenue { get; set; }
            public string registration_revenue { get; set; }
            public string lab_revenue { get; set; }
            public string xray_revenue { get; set; }
            public string bed_revenue { get; set; }
            public string delivery_revenue { get; set; }
            public string pharmacy_revenue { get; set; }
        }

        public class ChargeDetail
        {
            public string patient_name { get; set; }
            public string charge_name { get; set; }
            public string amount { get; set; }
            public string paid_date { get; set; }
            public string invoice_number { get; set; }
        }

        public class PharmacyDetail
        {
            public string sale_id { get; set; }
            public string customer_name { get; set; }
            public string total_amount { get; set; }
            public string payment_method { get; set; }
            public string sale_date { get; set; }
        }
    }
}
