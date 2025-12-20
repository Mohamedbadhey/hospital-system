using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace juba_hospital
{
    public partial class print_pharmacy_revenue_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check authentication
                if (Session["admin_id"] == null)
                {
                    Response.Redirect("login.aspx");
                    return;
                }

                // Load hospital header using the standard helper
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();

                // Get query parameters
                string dateRange = Request.QueryString["dateRange"] ?? "today";
                string startDate = Request.QueryString["startDate"] ?? "";
                string endDate = Request.QueryString["endDate"] ?? "";
                string paymentMethod = Request.QueryString["paymentMethod"] ?? "all";
                string customerSearch = Request.QueryString["customerSearch"] ?? "";

                // Set report information
                SetReportInfo(dateRange, startDate, endDate, paymentMethod, customerSearch);

                // Load report data
                LoadReportData(dateRange, startDate, endDate, paymentMethod, customerSearch);
            }
        }

        private void SetReportInfo(string dateRange, string startDate, string endDate, string paymentMethod, string customerSearch)
        {
            litDateRange.Text = GetDateRangeText(dateRange, startDate, endDate);

            List<string> filters = new List<string>();
            
            if (paymentMethod.ToLower() != "all")
                filters.Add($"Payment: {paymentMethod}");
            else
                filters.Add("All Payment Methods");

            if (!string.IsNullOrEmpty(customerSearch))
                filters.Add($"Customer: {customerSearch}");

            litFilter.Text = string.Join(", ", filters);
            litGeneratedDate.Text = DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt");
            
            string generatedBy = "Administrator";
            if (Session["admin_name"] != null)
                generatedBy = Session["admin_name"].ToString();
            else if (Session["username"] != null)
                generatedBy = Session["username"].ToString();
            
            litGeneratedBy.Text = generatedBy;

            // Load footer hospital name from settings
            LoadFooterInfo();
        }

        private void LoadFooterInfo()
        {
            try
            {
                HospitalSettings settings = HospitalSettingsHelper.GetHospitalSettings();
                string hospitalName = !string.IsNullOrEmpty(settings.HospitalName) 
                    ? settings.HospitalName 
                    : "Jubba Hospital";
                
                litFooterHospital.Text = hospitalName;
                litFooterHospitalCopyright.Text = hospitalName;
            }
            catch (Exception)
            {
                litFooterHospital.Text = "Jubba Hospital";
                litFooterHospitalCopyright.Text = "Jubba Hospital";
            }
        }

        private string GetDateRangeText(string dateRange, string startDate, string endDate)
        {
            switch (dateRange.ToLower())
            {
                case "today":
                    return "Today - " + DateTime.Now.ToString("MMMM dd, yyyy");
                case "yesterday":
                    return "Yesterday - " + DateTime.Now.AddDays(-1).ToString("MMMM dd, yyyy");
                case "thisweek":
                    return "This Week";
                case "thismonth":
                    return DateTime.Now.ToString("MMMM yyyy");
                case "lastmonth":
                    return DateTime.Now.AddMonths(-1).ToString("MMMM yyyy");
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        DateTime start = DateTime.Parse(startDate);
                        DateTime end = DateTime.Parse(endDate);
                        return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
                    }
                    return "Custom Range";
                case "all":
                    return "All Time";
                default:
                    return "All Time";
            }
        }

        private void LoadReportData(string dateRange, string startDate, string endDate, string paymentMethod, string customerSearch)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            string dateCondition = GetDateCondition(dateRange, startDate, endDate);
            string paymentCondition = paymentMethod.ToLower() != "all" ? $"AND ps.payment_method = '{paymentMethod}'" : "";
            string searchCondition = !string.IsNullOrEmpty(customerSearch) ? $"AND ps.customer_name LIKE '%{customerSearch.Replace("'", "''")}%'" : "";

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                LoadStatistics(con, dateCondition, paymentCondition, searchCondition);
                LoadSales(con, dateCondition, paymentCondition, searchCondition);
                LoadDailyBreakdown(con, dateCondition, paymentCondition, searchCondition);
            }
        }

        private void LoadStatistics(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            // Get header-level statistics
            string headerQuery = $@"
                SELECT 
                    ISNULL(SUM(ps.total_amount), 0) AS total_revenue,
                    COUNT(*) AS total_sales,
                    ISNULL(AVG(ps.total_amount), 0) AS average_sale
                FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition}
            ";

            using (SqlCommand cmd = new SqlCommand(headerQuery, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        decimal totalRevenue = Convert.ToDecimal(dr["total_revenue"]);
                        litTotalRevenue.Text = totalRevenue.ToString("N2");
                        litTotalSales.Text = dr["total_sales"].ToString();
                        litAvgSale.Text = Convert.ToDecimal(dr["average_sale"]).ToString("N2");
                        litFooterTotal.Text = totalRevenue.ToString("N2");
                    }
                }
            }

            // Get total items
            string itemsQuery = $@"
                SELECT ISNULL(SUM(ISNULL(psi.quantity,0)), 0) AS total_items
                FROM pharmacy_sales_items psi
                INNER JOIN pharmacy_sales ps ON COALESCE(psi.sale_id, psi.saleid) = COALESCE(ps.sale_id, ps.saleid)
                WHERE {dateCondition} {paymentCondition} {searchCondition}
            ";

            using (SqlCommand cmdItems = new SqlCommand(itemsQuery, con))
            {
                object result = cmdItems.ExecuteScalar();
                litTotalItems.Text = (result == null || result == DBNull.Value) ? "0" : result.ToString();
            }
        }

        private void LoadSales(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            string query = $@"
                SELECT 
                    COALESCE(CAST(ps.sale_id AS VARCHAR(20)), CAST(ps.saleid AS VARCHAR(20))) AS sale_id,
                    ps.customer_name,
                    ps.total_amount,
                    ps.payment_method,
                    ps.sale_date,
                    (SELECT COUNT(*) FROM pharmacy_sales_items psi 
                     WHERE COALESCE(psi.sale_id, psi.saleid) = COALESCE(ps.sale_id, ps.saleid)) AS item_count
                FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition}
                ORDER BY ps.sale_date DESC
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptPharmacySales.DataSource = dt;
                    rptPharmacySales.DataBind();
                }
            }
        }

        private void LoadDailyBreakdown(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            string query = $@"
                SELECT 
                    CAST(ps.sale_date AS DATE) AS date,
                    SUM(ps.total_amount) AS revenue
                FROM pharmacy_sales ps
                WHERE {dateCondition} {paymentCondition} {searchCondition}
                GROUP BY CAST(ps.sale_date AS DATE)
                ORDER BY CAST(ps.sale_date AS DATE)
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    
                    if (dt.Rows.Count > 0)
                    {
                        rptDailyBreakdown.DataSource = dt;
                        rptDailyBreakdown.DataBind();
                        pnlDailyBreakdown.Visible = true;
                    }
                    else
                    {
                        pnlDailyBreakdown.Visible = false;
                    }
                }
            }
        }

        private string GetDateCondition(string dateRange, string startDate, string endDate)
        {
            switch (dateRange.ToLower())
            {
                case "today":
                    return "CAST(ps.sale_date AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday":
                    return "CAST(ps.sale_date AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek":
                    return "DATEPART(week, ps.sale_date) = DATEPART(week, GETDATE()) AND DATEPART(year, ps.sale_date) = DATEPART(year, GETDATE())";
                case "thismonth":
                    return "DATEPART(month, ps.sale_date) = DATEPART(month, GETDATE()) AND DATEPART(year, ps.sale_date) = DATEPART(year, GETDATE())";
                case "lastmonth":
                    return "DATEPART(month, ps.sale_date) = DATEPART(month, DATEADD(month, -1, GETDATE())) AND DATEPART(year, ps.sale_date) = DATEPART(year, DATEADD(month, -1, GETDATE()))";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        return $"CAST(ps.sale_date AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    }
                    return "1=1";
                case "all":
                    return "1=1";
                default:
                    return "1=1";
            }
        }
    }
}
