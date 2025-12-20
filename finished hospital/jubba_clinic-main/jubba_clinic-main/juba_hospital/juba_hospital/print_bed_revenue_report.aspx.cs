using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace juba_hospital
{
    public partial class print_bed_revenue_report : System.Web.UI.Page
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
                string paymentStatus = Request.QueryString["paymentStatus"] ?? "all";
                string patientSearch = Request.QueryString["patientSearch"] ?? "";

                // Set report information
                SetReportInfo(dateRange, startDate, endDate, paymentStatus, patientSearch);

                // Load report data
                LoadReportData(dateRange, startDate, endDate, paymentStatus, patientSearch);
            }
        }

        private void SetReportInfo(string dateRange, string startDate, string endDate, string paymentStatus, string patientSearch)
        {
            litDateRange.Text = GetDateRangeText(dateRange, startDate, endDate);

            List<string> filters = new List<string>();
            
            if (paymentStatus.ToLower() == "paid")
                filters.Add("Paid Only");
            else if (paymentStatus.ToLower() == "unpaid")
                filters.Add("Unpaid Only");
            else
                filters.Add("All Payments");

            if (!string.IsNullOrEmpty(patientSearch))
                filters.Add($"Patient: {patientSearch}");

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
                default:
                    return "Today - " + DateTime.Now.ToString("MMMM dd, yyyy");
            }
        }

        private void LoadReportData(string dateRange, string startDate, string endDate, string paymentStatus, string patientSearch)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            string dateCondition = GetDateCondition(dateRange, startDate, endDate);
            string paymentCondition = GetPaymentCondition(paymentStatus);
            string searchCondition = GetSearchCondition(patientSearch);

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                LoadStatistics(con, dateCondition, paymentCondition, searchCondition);
                LoadCharges(con, dateCondition, paymentCondition, searchCondition);
                LoadDailyBreakdown(con, dateCondition, paymentCondition, searchCondition);
            }
        }

        private void LoadStatistics(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            string query = $@"
                SELECT 
                    ISNULL(SUM(CASE WHEN pbc.is_paid = 1 THEN pbc.bed_charge_amount ELSE 0 END), 0) AS total_revenue,
                    COUNT(*) AS total_count,
                    ISNULL(AVG(pbc.bed_charge_amount), 0) AS average_fee,
                    SUM(CASE WHEN pbc.is_paid = 0 THEN 1 ELSE 0 END) AS pending_count
                FROM patient_bed_charges pbc
                INNER JOIN patient p ON pbc.patientid = p.patientid
                WHERE {dateCondition}
                {paymentCondition}
                {searchCondition}
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        decimal totalRevenue = Convert.ToDecimal(dr["total_revenue"]);
                        litTotalRevenue.Text = totalRevenue.ToString("N2");
                        litTotalCount.Text = dr["total_count"].ToString();
                        litAvgFee.Text = Convert.ToDecimal(dr["average_fee"]).ToString("N2");
                        litPendingCount.Text = dr["pending_count"].ToString();
                        litFooterTotal.Text = totalRevenue.ToString("N2");
                    }
                }
            }
        }

        private void LoadCharges(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            string query = $@"
                SELECT 
                    pbc.bed_charge_id,
                    pbc.bed_charge_amount AS amount,
                    pbc.charge_date,
                    pbc.is_paid,
                    pbc.created_at AS charge_date,
                    pbc.patientid,
                    p.full_name AS patient_name,
                    p.phone
                FROM patient_bed_charges pbc
                INNER JOIN patient p ON pbc.patientid = p.patientid
                WHERE {dateCondition}
                {paymentCondition}
                {searchCondition}
                ORDER BY pbc.created_at DESC
            ";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptBedCharges.DataSource = dt;
                    rptBedCharges.DataBind();
                }
            }
        }

        private void LoadDailyBreakdown(SqlConnection con, string dateCondition, string paymentCondition, string searchCondition)
        {
            string query = $@"
                SELECT 
                    CAST(pbc.created_at AS DATE) AS date,
                    SUM(CASE WHEN pbc.is_paid = 1 THEN pbc.bed_charge_amount ELSE 0 END) AS revenue
                FROM patient_bed_charges pbc
                INNER JOIN patient p ON pbc.patientid = p.patientid
                WHERE {dateCondition}
                {paymentCondition}
                {searchCondition}
                GROUP BY CAST(pbc.created_at AS DATE)
                ORDER BY CAST(pbc.created_at AS DATE)
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
                    return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
                case "yesterday":
                    return "CAST(pbc.created_at AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)";
                case "thisweek":
                    return "DATEPART(week, pbc.created_at) = DATEPART(week, GETDATE()) AND DATEPART(year, pbc.created_at) = DATEPART(year, GETDATE())";
                case "thismonth":
                    return "DATEPART(month, pbc.created_at) = DATEPART(month, GETDATE()) AND DATEPART(year, pbc.created_at) = DATEPART(year, GETDATE())";
                case "lastmonth":
                    return "DATEPART(month, pbc.created_at) = DATEPART(month, DATEADD(month, -1, GETDATE())) AND DATEPART(year, pbc.created_at) = DATEPART(year, DATEADD(month, -1, GETDATE()))";
                case "custom":
                    if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                    {
                        return $"CAST(pbc.created_at AS DATE) BETWEEN '{startDate}' AND '{endDate}'";
                    }
                    return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
                default:
                    return "CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)";
            }
        }

        private string GetPaymentCondition(string paymentStatus)
        {
            switch (paymentStatus.ToLower())
            {
                case "paid":
                    return "AND pbc.is_paid = 1";
                case "unpaid":
                    return "AND pbc.is_paid = 0";
                default:
                    return "";
            }
        }

        private string GetSearchCondition(string patientSearch)
        {
            if (!string.IsNullOrEmpty(patientSearch))
            {
                return $"AND p.full_name LIKE '%{patientSearch.Replace("'", "''")}%'";
            }
            return "";
        }
    }
}
