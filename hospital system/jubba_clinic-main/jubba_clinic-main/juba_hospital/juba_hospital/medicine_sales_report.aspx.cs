using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class medicine_sales_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static ReportData GetMedicineSalesReport(string startDate, string endDate)
        {
            ReportData reportData = new ReportData();
            reportData.medicines = new List<MedicineSalesData>();
            reportData.summary = new SummaryData();

            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Query to get medicine-wise sales data
                    string query = @"
                        SELECT 
                            m.medicineid,
                            m.medicine_name,
                            m.generic_name,
                            SUM(psi.quantity) as total_quantity_sold,
                            SUM(psi.total_price) as total_revenue,
                            SUM(psi.quantity * psi.cost_price) as total_cost,
                            ISNULL(SUM(psi.profit), 0) as total_profit,
                            COUNT(DISTINCT ps.saleid) as transaction_count,
                            STUFF((SELECT DISTINCT ', ' + quantity_type 
                                   FROM pharmacy_sales_items psi2 
                                   INNER JOIN pharmacy_sales ps2 ON psi2.saleid = ps2.saleid
                                   WHERE psi2.medicineid = m.medicineid 
                                   AND CAST(ps2.sale_date AS DATE) BETWEEN @startDate AND @endDate
                                   AND ps2.status = 1
                                   AND ps2.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                                   FOR XML PATH('')), 1, 2, '') as unit_types
                        FROM pharmacy_sales ps
                        INNER JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
                        INNER JOIN medicine m ON psi.medicineid = m.medicineid
                        WHERE CAST(ps.sale_date AS DATE) BETWEEN @startDate AND @endDate
                        AND ps.status = 1
                        AND ps.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        GROUP BY m.medicineid, m.medicine_name, m.generic_name
                        ORDER BY total_revenue DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@startDate", startDate);
                        cmd.Parameters.AddWithValue("@endDate", endDate);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                MedicineSalesData med = new MedicineSalesData();
                                med.medicineid = Convert.ToInt32(dr["medicineid"]);
                                med.medicine_name = dr["medicine_name"].ToString();
                                med.generic_name = dr["generic_name"] == DBNull.Value ? "" : dr["generic_name"].ToString();
                                med.total_quantity_sold = Convert.ToDecimal(dr["total_quantity_sold"]);
                                med.total_revenue = Convert.ToDecimal(dr["total_revenue"]);
                                med.total_cost = Convert.ToDecimal(dr["total_cost"]);
                                med.total_profit = Convert.ToDecimal(dr["total_profit"]);
                                med.transaction_count = Convert.ToInt32(dr["transaction_count"]);
                                med.unit_types = dr["unit_types"] == DBNull.Value ? "" : dr["unit_types"].ToString();

                                reportData.medicines.Add(med);

                                // Update summary
                                reportData.summary.total_revenue += med.total_revenue;
                                reportData.summary.total_cost += med.total_cost;
                                reportData.summary.total_profit += med.total_profit;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetMedicineSalesReport: " + ex.Message);
                throw;
            }

            return reportData;
        }

        [WebMethod]
        public static MedicineDetailsData GetMedicineDetails(int medicineid, string startDate, string endDate)
        {
            MedicineDetailsData detailsData = new MedicineDetailsData();
            detailsData.breakdown = new List<UnitTypeBreakdown>();
            detailsData.transactions = new List<TransactionData>();

            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get summary for this medicine
                    string summaryQuery = @"
                        SELECT 
                            SUM(psi.quantity) as total_quantity_sold,
                            SUM(psi.total_price) as total_revenue,
                            SUM(psi.quantity * psi.cost_price) as total_cost,
                            ISNULL(SUM(psi.profit), 0) as total_profit
                        FROM pharmacy_sales ps
                        INNER JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
                        WHERE psi.medicineid = @medicineid
                        AND CAST(ps.sale_date AS DATE) BETWEEN @startDate AND @endDate
                        AND ps.status = 1
                        AND ps.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)";

                    using (SqlCommand cmd = new SqlCommand(summaryQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medicineid", medicineid);
                        cmd.Parameters.AddWithValue("@startDate", startDate);
                        cmd.Parameters.AddWithValue("@endDate", endDate);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                detailsData.total_quantity_sold = dr["total_quantity_sold"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["total_quantity_sold"]);
                                detailsData.total_revenue = dr["total_revenue"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["total_revenue"]);
                                detailsData.total_cost = dr["total_cost"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["total_cost"]);
                                detailsData.total_profit = dr["total_profit"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["total_profit"]);
                            }
                        }
                    }

                    // Get breakdown by unit type
                    string breakdownQuery = @"
                        SELECT 
                            psi.quantity_type,
                            SUM(psi.quantity) as quantity_sold,
                            SUM(psi.total_price) as revenue,
                            SUM(psi.quantity * psi.cost_price) as cost,
                            ISNULL(SUM(psi.profit), 0) as profit
                        FROM pharmacy_sales ps
                        INNER JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
                        WHERE psi.medicineid = @medicineid
                        AND CAST(ps.sale_date AS DATE) BETWEEN @startDate AND @endDate
                        AND ps.status = 1
                        AND ps.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        GROUP BY psi.quantity_type
                        ORDER BY revenue DESC";

                    using (SqlCommand cmd = new SqlCommand(breakdownQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medicineid", medicineid);
                        cmd.Parameters.AddWithValue("@startDate", startDate);
                        cmd.Parameters.AddWithValue("@endDate", endDate);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                UnitTypeBreakdown breakdown = new UnitTypeBreakdown();
                                breakdown.quantity_type = dr["quantity_type"].ToString();
                                breakdown.quantity_sold = Convert.ToDecimal(dr["quantity_sold"]);
                                breakdown.revenue = Convert.ToDecimal(dr["revenue"]);
                                breakdown.cost = Convert.ToDecimal(dr["cost"]);
                                breakdown.profit = Convert.ToDecimal(dr["profit"]);
                                detailsData.breakdown.Add(breakdown);
                            }
                        }
                    }

                    // Get recent transactions (limit to last 20)
                    string transactionsQuery = @"
                        SELECT TOP 20
                            ps.sale_date,
                            ps.invoice_number,
                            psi.quantity,
                            psi.quantity_type,
                            psi.unit_price,
                            psi.total_price,
                            ISNULL(psi.profit, 0) as profit
                        FROM pharmacy_sales ps
                        INNER JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
                        WHERE psi.medicineid = @medicineid
                        AND CAST(ps.sale_date AS DATE) BETWEEN @startDate AND @endDate
                        AND ps.status = 1
                        AND ps.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        ORDER BY ps.sale_date DESC";

                    using (SqlCommand cmd = new SqlCommand(transactionsQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medicineid", medicineid);
                        cmd.Parameters.AddWithValue("@startDate", startDate);
                        cmd.Parameters.AddWithValue("@endDate", endDate);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                TransactionData trans = new TransactionData();
                                trans.sale_date = Convert.ToDateTime(dr["sale_date"]);
                                trans.invoice_number = dr["invoice_number"].ToString();
                                trans.quantity = Convert.ToDecimal(dr["quantity"]);
                                trans.quantity_type = dr["quantity_type"].ToString();
                                trans.unit_price = Convert.ToDecimal(dr["unit_price"]);
                                trans.total_price = Convert.ToDecimal(dr["total_price"]);
                                trans.profit = Convert.ToDecimal(dr["profit"]);
                                detailsData.transactions.Add(trans);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetMedicineDetails: " + ex.Message);
                throw;
            }

            return detailsData;
        }

        public class ReportData
        {
            public List<MedicineSalesData> medicines { get; set; }
            public SummaryData summary { get; set; }
        }

        public class MedicineSalesData
        {
            public int medicineid { get; set; }
            public string medicine_name { get; set; }
            public string generic_name { get; set; }
            public decimal total_quantity_sold { get; set; }
            public decimal total_revenue { get; set; }
            public decimal total_cost { get; set; }
            public decimal total_profit { get; set; }
            public int transaction_count { get; set; }
            public string unit_types { get; set; }
        }

        public class SummaryData
        {
            public decimal total_revenue { get; set; }
            public decimal total_cost { get; set; }
            public decimal total_profit { get; set; }

            public SummaryData()
            {
                total_revenue = 0;
                total_cost = 0;
                total_profit = 0;
            }
        }

        public class MedicineDetailsData
        {
            public decimal total_quantity_sold { get; set; }
            public decimal total_revenue { get; set; }
            public decimal total_cost { get; set; }
            public decimal total_profit { get; set; }
            public List<UnitTypeBreakdown> breakdown { get; set; }
            public List<TransactionData> transactions { get; set; }
        }

        public class UnitTypeBreakdown
        {
            public string quantity_type { get; set; }
            public decimal quantity_sold { get; set; }
            public decimal revenue { get; set; }
            public decimal cost { get; set; }
            public decimal profit { get; set; }
        }

        public class TransactionData
        {
            public DateTime sale_date { get; set; }
            public string invoice_number { get; set; }
            public decimal quantity { get; set; }
            public string quantity_type { get; set; }
            public decimal unit_price { get; set; }
            public decimal total_price { get; set; }
            public decimal profit { get; set; }
        }
    }
}
