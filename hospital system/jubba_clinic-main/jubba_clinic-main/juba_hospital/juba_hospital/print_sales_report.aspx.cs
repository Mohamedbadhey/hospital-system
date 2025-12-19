using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class print_sales_report : System.Web.UI.Page
    {
        protected Literal PrintHeaderLiteral;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add hospital print header with logo
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
            }
        }

        [WebMethod]
        public static string GetPrintHeader()
        {
            return HospitalSettingsHelper.GetPrintHeaderHTML();
        }

        [WebMethod]
        public static List<SalesReport> getSalesReport(string fromDate, string toDate)
        {
            List<SalesReport> reports = new List<SalesReport>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        SELECT 
                            s.saleid as sale_id,
                            s.invoice_number,
                            CONVERT(VARCHAR, s.sale_date, 23) as sale_date,
                            s.customer_name,
                            ISNULL(s.final_amount, s.total_amount) as total_amount,
                            s.status,
                            ISNULL(SUM(ISNULL(si.quantity, 0)), 0) as total_items,
                            ISNULL(SUM(ISNULL(si.cost_price, 0) * ISNULL(si.quantity, 0)), 0) as total_cost,
                            ISNULL(SUM(ISNULL(si.profit, 0)), 0) as profit,
                            STUFF((
                                SELECT ', ' + m.medicine_name
                                FROM pharmacy_sales_items si2
                                INNER JOIN medicine m ON si2.medicine_id = m.medicineid
                                WHERE si2.saleid = s.saleid
                                FOR XML PATH(''), TYPE
                            ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') as medicine_names,
                            (
                                SELECT COUNT(DISTINCT medicine_id)
                                FROM pharmacy_sales_items si3
                                WHERE si3.saleid = s.saleid
                            ) as medicine_count
                        FROM pharmacy_sales s
                        LEFT JOIN pharmacy_sales_items si ON s.saleid = si.saleid
                        WHERE CAST(s.sale_date AS DATE) BETWEEN @fromDate AND @toDate
                        AND s.status = 1
                        AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        GROUP BY s.saleid, s.invoice_number, s.sale_date, s.customer_name, s.total_amount, s.final_amount, s.status
                        ORDER BY s.sale_date DESC, s.saleid DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@toDate", toDate);

                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            SalesReport report = new SalesReport();
                            report.sale_id = dr["sale_id"].ToString();
                            report.invoice_number = dr["invoice_number"].ToString();
                            report.sale_date = dr["sale_date"].ToString();
                            report.customer_name = dr["customer_name"] == DBNull.Value ? "" : dr["customer_name"].ToString();
                            report.total_items = dr["total_items"].ToString();
                            report.total_amount = dr["total_amount"].ToString();
                            report.total_cost = dr["total_cost"].ToString();
                            report.profit = dr["profit"].ToString();
                            report.status = dr["status"].ToString();
                            report.medicine_names = dr["medicine_names"] == DBNull.Value ? "" : dr["medicine_names"].ToString();
                            report.medicine_count = dr["medicine_count"].ToString();
                            reports.Add(report);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting sales report: " + ex.Message, ex);
            }

            return reports;
        }

        [WebMethod]
        public static List<TopMedicine> getTopMedicines(string fromDate, string toDate)
        {
            List<TopMedicine> medicines = new List<TopMedicine>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        SELECT TOP 10
                            m.medicine_name,
                            SUM(si.quantity) as total_quantity,
                            SUM(si.total_price) as total_revenue,
                            ISNULL(SUM(si.profit), 0) as total_profit
                        FROM pharmacy_sales_items si
                        INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                        LEFT JOIN medicine m ON si.medicine_id = m.medicineid
                        WHERE CAST(s.sale_date AS DATE) BETWEEN @fromDate AND @toDate
                        AND s.status = 1
                        AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        AND m.medicineid IS NOT NULL
                        GROUP BY m.medicine_name
                        ORDER BY SUM(si.total_price) DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@toDate", toDate);

                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            TopMedicine med = new TopMedicine();
                            med.medicine_name = dr["medicine_name"].ToString();
                            med.total_quantity = dr["total_quantity"].ToString();
                            med.total_revenue = dr["total_revenue"].ToString();
                            med.total_profit = dr["total_profit"].ToString();
                            medicines.Add(med);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting top medicines: " + ex.Message, ex);
            }

            return medicines;
        }

        public class SalesReport
        {
            public string sale_id;
            public string invoice_number;
            public string sale_date;
            public string customer_name;
            public string total_items;
            public string total_amount;
            public string total_cost;
            public string profit;
            public string status;
            public string medicine_names;
            public string medicine_count;
        }

        public class TopMedicine
        {
            public string medicine_name;
            public string total_quantity;
            public string total_revenue;
            public string total_profit;
        }
    }
}
