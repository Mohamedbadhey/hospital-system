using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class pharmacy_revenue_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null) Response.Redirect("login.aspx");
        }

        [WebMethod]
        public static PharmacyReportData GetPharmacyReport(string dateRange, string startDate, string endDate, string paymentMethod, string customerSearch)
        {
            PharmacyReportData report = new PharmacyReportData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            string dateCondition = GetDateCondition(dateRange, startDate, endDate);
            string paymentCondition = paymentMethod.ToLower() != "all" ? $"AND ps.payment_method = '{paymentMethod}'" : "";
            string searchCondition = !string.IsNullOrEmpty(customerSearch) ? $"AND ps.customer_name LIKE '%{customerSearch}%'" : "";

            System.Diagnostics.Debug.WriteLine("=== PharmacyReport DEBUG ===");
            System.Diagnostics.Debug.WriteLine($"dateRange={dateRange}, start={startDate}, end={endDate}, payment={paymentMethod}, search='{customerSearch}'");
            System.Diagnostics.Debug.WriteLine($"dateCondition: {dateCondition}");
            System.Diagnostics.Debug.WriteLine($"paymentCondition: {paymentCondition}");
            System.Diagnostics.Debug.WriteLine($"searchCondition: {searchCondition}");

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    report.statistics = GetStatistics(con, dateCondition, paymentCondition, searchCondition);
                    report.details = GetDetails(con, dateCondition, paymentCondition, searchCondition);
                    report.dailyBreakdown = GetDailyBreakdown(con, dateCondition, paymentCondition, searchCondition);
                    report.paymentDistribution = GetPaymentDistribution(con, dateCondition, paymentCondition, searchCondition);
                    report.topMedicines = GetTopMedicines(con, dateCondition, paymentCondition, searchCondition);
                }
                return report;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"GetPharmacyReport ERROR: {ex.Message}\n{ex.StackTrace}");
                throw;
            }
        }

        private static string GetDateCondition(string dateRange, string startDate, string endDate)
        {
            switch ((dateRange ?? "all").ToLower())
            {
                case "today": return "CAST(ps.sale_date AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday": return "CAST(ps.sale_date AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek": return "DATEPART(week, ps.sale_date) = DATEPART(week, GETDATE()) AND DATEPART(year, ps.sale_date) = DATEPART(year, GETDATE())";
                case "thismonth": return "DATEPART(month, ps.sale_date) = DATEPART(month, GETDATE()) AND DATEPART(year, ps.sale_date) = DATEPART(year, GETDATE())";
                case "lastmonth": return "DATEPART(month, ps.sale_date) = DATEPART(month, DATEADD(month, -1, GETDATE())) AND DATEPART(year, ps.sale_date) = DATEPART(year, DATEADD(month, -1, GETDATE()))";
                case "custom": return !string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate) ? $"CAST(ps.sale_date AS DATE) BETWEEN '{startDate}' AND '{endDate}'" : "CAST(ps.sale_date AS DATE) = CAST(GETDATE() AS DATE)";
                case "all": return "1=1";
                default: return "1=1";
            }
        }

        private static PharmacyStatistics GetStatistics(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            PharmacyStatistics stats = new PharmacyStatistics();

            // First: header-level aggregates only (no subqueries to avoid alias/grouping issues)
            string headerQuery = $@"SELECT ISNULL(SUM(ps.total_amount), 0) AS total_revenue,
                COUNT(*) AS total_sales,
                ISNULL(AVG(ps.total_amount), 0) AS average_sale
                FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition}";
            System.Diagnostics.Debug.WriteLine("[DEBUG] headerQuery: " + headerQuery);
            using (SqlCommand cmd = new SqlCommand(headerQuery, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        stats.total_revenue = dr["total_revenue"].ToString();
                        stats.total_sales = dr["total_sales"].ToString();
                        stats.average_sale = dr["average_sale"].ToString();
                    }
                }
            }

            // Second: compute total items via a separate query scoped to the same filters
            string itemsQuery = $@"SELECT ISNULL(SUM(ISNULL(psi.quantity,0)), 0) AS total_items
                FROM pharmacy_sales_items psi
                INNER JOIN pharmacy_sales ps ON COALESCE(psi.sale_id, psi.saleid) = COALESCE(ps.sale_id, ps.saleid)
                WHERE {dateCondition} {paymentCondition} {searchCondition}";
            System.Diagnostics.Debug.WriteLine("[DEBUG] itemsQuery: " + itemsQuery);
            using (SqlCommand cmdItems = new SqlCommand(itemsQuery, con))
            {
                object result = cmdItems.ExecuteScalar();
                stats.total_items = (result == null || result == DBNull.Value) ? "0" : result.ToString();
            }
            return stats;
        }

        private static List<PharmacyDetail> GetDetails(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<PharmacyDetail> details = new List<PharmacyDetail>();
            string query = $@"SELECT COALESCE(CAST(ps.sale_id AS VARCHAR(20)), CAST(ps.saleid AS VARCHAR(20))) AS sale_id, ps.customer_name, ps.total_amount, ps.payment_method, ps.sale_date,
                (SELECT COUNT(*) FROM pharmacy_sales_items psi WHERE COALESCE(psi.sale_id, psi.saleid) = COALESCE(ps.sale_id, ps.saleid)) AS item_count
                FROM pharmacy_sales ps WHERE {dateCondition} {paymentCondition} {searchCondition} ORDER BY ps.sale_date DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        details.Add(new PharmacyDetail
                        {
                            sale_id = dr["sale_id"].ToString(),
                            customer_name = dr["customer_name"].ToString(),
                            customer_phone = "",
                            total_amount = dr["total_amount"].ToString(),
                            payment_method = dr["payment_method"].ToString(),
                            sale_date = Convert.ToDateTime(dr["sale_date"]).ToString("yyyy-MM-dd HH:mm"),
                            item_count = dr["item_count"].ToString()
                        });
                    }
                }
            }
            return details;
        }

        private static List<DailyBreakdown> GetDailyBreakdown(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<DailyBreakdown> breakdown = new List<DailyBreakdown>();
            string query = $@"SELECT CAST(ps.sale_date AS DATE) AS date, SUM(ps.total_amount) AS revenue FROM pharmacy_sales ps";
            System.Diagnostics.Debug.WriteLine("[DEBUG] dailyBreakdown base: " + query);
            query = $@"SELECT CAST(ps.sale_date AS DATE) AS date, SUM(ps.total_amount) AS revenue FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition} GROUP BY CAST(ps.sale_date AS DATE) ORDER BY CAST(ps.sale_date AS DATE)";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read()) breakdown.Add(new DailyBreakdown { date = Convert.ToDateTime(dr["date"]).ToString("MMM dd"), revenue = dr["revenue"].ToString() });
                }
            }
            return breakdown;
        }

        private static List<PaymentDistribution> GetPaymentDistribution(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<PaymentDistribution> distribution = new List<PaymentDistribution>();
            string query = $@"SELECT ps.payment_method, SUM(ps.total_amount) AS amount FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition} GROUP BY ps.payment_method ORDER BY amount DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read()) distribution.Add(new PaymentDistribution { payment_method = dr["payment_method"].ToString(), amount = dr["amount"].ToString() });
                }
            }
            return distribution;
        }

        private static List<TopMedicine> GetTopMedicines(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            List<TopMedicine> topMedicines = new List<TopMedicine>();
            string query = $@"SELECT TOP 5 m.medicine_name, SUM(ISNULL(psi.quantity,0)) AS quantity FROM pharmacy_sales_items psi
                INNER JOIN pharmacy_sales ps ON COALESCE(psi.sale_id, psi.saleid) = COALESCE(ps.sale_id, ps.saleid)
                INNER JOIN medicine m ON COALESCE(psi.medicine_id, psi.medicineid) = m.medicineid
                WHERE {dateCondition} {paymentCondition} {searchCondition} GROUP BY m.medicine_name ORDER BY quantity DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read()) topMedicines.Add(new TopMedicine { medicine_name = dr["medicine_name"].ToString(), quantity = dr["quantity"].ToString() });
                }
            }
            return topMedicines;
        }

        public class PharmacyReportData { public PharmacyStatistics statistics { get; set; } public List<PharmacyDetail> details { get; set; } public List<DailyBreakdown> dailyBreakdown { get; set; } public List<PaymentDistribution> paymentDistribution { get; set; } public List<TopMedicine> topMedicines { get; set; } }
        public class PharmacyStatistics { public string total_revenue { get; set; } public string total_sales { get; set; } public string average_sale { get; set; } public string total_items { get; set; } }
        public class PharmacyDetail { public string sale_id { get; set; } public string customer_name { get; set; } public string customer_phone { get; set; } public string total_amount { get; set; } public string payment_method { get; set; } public string sale_date { get; set; } public string item_count { get; set; } }
        public class DailyBreakdown { public string date { get; set; } public string revenue { get; set; } }
        public class PaymentDistribution { public string payment_method { get; set; } public string amount { get; set; } }
        public class TopMedicine { public string medicine_name { get; set; } public string quantity { get; set; } }
    }
}
