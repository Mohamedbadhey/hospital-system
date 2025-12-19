using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;

namespace juba_hospital
{
    public partial class pharmacy_sales_reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static SummaryStats getSummaryStats(string fromDate, string toDate)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SummaryStats stats = new SummaryStats();

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Selected Period Sales
                    string periodSalesQuery = @"
                        SELECT ISNULL(SUM(ISNULL(final_amount, total_amount)), 0) as total
                        FROM pharmacy_sales
                        WHERE CAST(sale_date AS DATE) BETWEEN @fromDate AND @toDate
                        AND status = 1
                        AND saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(periodSalesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@toDate", toDate);
                        stats.todaySales = cmd.ExecuteScalar().ToString();
                    }

                    // Selected Period Profit
                    string periodProfitQuery = @"
                        SELECT ISNULL(SUM(si.profit), 0) as total
                        FROM pharmacy_sales_items si
                        INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                        WHERE CAST(s.sale_date AS DATE) BETWEEN @fromDate AND @toDate
                        AND s.status = 1
                        AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(periodProfitQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@toDate", toDate);
                        stats.todayProfit = cmd.ExecuteScalar().ToString();
                    }

                    // This Month's Sales (kept for reference)
                    string monthSalesQuery = @"
                        SELECT ISNULL(SUM(ISNULL(final_amount, total_amount)), 0) as total
                        FROM pharmacy_sales
                        WHERE YEAR(sale_date) = YEAR(GETDATE())
                        AND MONTH(sale_date) = MONTH(GETDATE())
                        AND status = 1
                        AND saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(monthSalesQuery, con))
                    {
                        stats.monthSales = cmd.ExecuteScalar().ToString();
                    }

                    // This Month's Profit (kept for reference)
                    string monthProfitQuery = @"
                        SELECT ISNULL(SUM(si.profit), 0) as total
                        FROM pharmacy_sales_items si
                        INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                        WHERE YEAR(s.sale_date) = YEAR(GETDATE())
                        AND MONTH(s.sale_date) = MONTH(GETDATE())
                        AND s.status = 1
                        AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(monthProfitQuery, con))
                    {
                        stats.monthProfit = cmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting summary stats", ex);
            }

            return stats;
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
                            s.sale_date,
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
                        ORDER BY s.sale_date DESC";

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
                            report.sale_date = Convert.ToDateTime(dr["sale_date"]).ToString("yyyy-MM-dd HH:mm:ss");
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
                throw new Exception("Error getting sales report: " + ex.Message + " - InnerException: " + (ex.InnerException != null ? ex.InnerException.Message : "None"), ex);
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
                throw new Exception("Error getting top medicines", ex);
            }

            return medicines;
        }

        public class SummaryStats
        {
            public string todaySales;
            public string todayProfit;
            public string monthSales;
            public string monthProfit;
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

        [WebMethod]
        public static List<SalesItemDetail> getSalesItems(string saleId)
        {
            List<SalesItemDetail> items = new List<SalesItemDetail>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        SELECT 
                            si.sale_item_id,
                            si.saleid,
                            si.quantity_type,
                            si.quantity,
                            si.unit_price,
                            si.total_price,
                            si.cost_price,
                            si.profit,
                            m.medicine_name,
                            m.generic_name,
                            m.manufacturer,
                            mu.unit_name,
                            mu.unit_abbreviation,
                            mu.base_unit_name,
                            mu.subdivision_unit
                        FROM pharmacy_sales_items si
                        INNER JOIN medicine m ON si.medicine_id = m.medicineid
                        LEFT JOIN medicine_units mu ON m.unit_id = mu.unit_id
                        WHERE si.saleid = @saleId
                        ORDER BY si.sale_item_id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@saleId", saleId);

                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            SalesItemDetail item = new SalesItemDetail();
                            item.sale_item_id = dr["sale_item_id"].ToString();
                            item.medicine_name = dr["medicine_name"].ToString();
                            item.generic_name = dr["generic_name"] == DBNull.Value ? "" : dr["generic_name"].ToString();
                            item.manufacturer = dr["manufacturer"] == DBNull.Value ? "" : dr["manufacturer"].ToString();
                            item.unit_name = dr["unit_name"] == DBNull.Value ? "" : dr["unit_name"].ToString();
                            item.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                            item.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "piece" : dr["base_unit_name"].ToString();
                            item.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                            item.quantity_type = dr["quantity_type"] == DBNull.Value ? "" : dr["quantity_type"].ToString();
                            item.quantity = dr["quantity"].ToString();
                            item.unit_price = dr["unit_price"].ToString();
                            item.total_price = dr["total_price"].ToString();
                            item.cost_price = dr["cost_price"].ToString();
                            item.profit = dr["profit"].ToString();
                            items.Add(item);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting sales items", ex);
            }

            return items;
        }

        public class SalesItemDetail
        {
            public string sale_item_id;
            public string medicine_name;
            public string generic_name;
            public string manufacturer;
            public string unit_name;
            public string unit_abbreviation;
            public string base_unit_name;
            public string subdivision_unit;
            public string quantity_type;
            public string quantity;
            public string unit_price;
            public string total_price;
            public string cost_price;
            public string profit;
        }
    }
}
