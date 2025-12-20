using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class pharmacy_sales_history : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static medicine_item[] getMedicineList()
        {
            List<medicine_item> list = new List<medicine_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT m.medicineid, m.medicine_name
                    FROM medicine m
                    INNER JOIN pharmacy_sales_items si ON m.medicineid = si.medicineid
                    ORDER BY m.medicine_name
                ", con);
                
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    medicine_item item = new medicine_item();
                    item.medicineid = dr["medicineid"].ToString();
                    item.medicine_name = dr["medicine_name"].ToString();
                    list.Add(item);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static sales_history_item[] getSalesHistory(string fromDate, string toDate, string medicineId)
        {
            List<sales_history_item> list = new List<sales_history_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = @"
                    SELECT 
                        s.invoice_number,
                        CONVERT(VARCHAR, s.sale_date, 103) as sale_date,
                        s.customer_name,
                        s.total_amount,
                        s.discount,
                        s.final_amount,
                        s.payment_method,
                        (SELECT COUNT(*) FROM pharmacy_sales_items WHERE saleid = s.saleid) as item_count
                    FROM pharmacy_sales s
                    WHERE s.status = 1
                ";

                // Filter by medicine if specified
                if (!string.IsNullOrEmpty(medicineId))
                {
                    query += @" AND EXISTS (
                        SELECT 1 FROM pharmacy_sales_items si 
                        WHERE si.saleid = s.saleid 
                        AND si.medicineid = @medicineId
                    )";
                }

                if (!string.IsNullOrEmpty(fromDate))
                {
                    query += " AND CAST(s.sale_date AS DATE) >= @fromDate";
                }
                if (!string.IsNullOrEmpty(toDate))
                {
                    query += " AND CAST(s.sale_date AS DATE) <= @toDate";
                }
                query += " ORDER BY s.sale_date DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                
                if (!string.IsNullOrEmpty(medicineId))
                {
                    cmd.Parameters.AddWithValue("@medicineId", medicineId);
                }
                if (!string.IsNullOrEmpty(fromDate))
                {
                    cmd.Parameters.AddWithValue("@fromDate", fromDate);
                }
                if (!string.IsNullOrEmpty(toDate))
                {
                    cmd.Parameters.AddWithValue("@toDate", toDate);
                }

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    sales_history_item item = new sales_history_item();
                    item.invoice_number = dr["invoice_number"].ToString();
                    item.sale_date = dr["sale_date"].ToString();
                    item.customer_name = dr["customer_name"].ToString();
                    item.total_amount = dr["total_amount"].ToString();
                    item.discount = dr["discount"].ToString();
                    item.final_amount = dr["final_amount"].ToString();
                    item.payment_method = dr["payment_method"].ToString();
                    item.item_count = dr["item_count"].ToString();
                    list.Add(item);
                }
            }
            return list.ToArray();
        }

        public class sales_history_item
        {
            public string invoice_number;
            public string sale_date;
            public string customer_name;
            public string total_amount;
            public string discount;
            public string final_amount;
            public string payment_method;
            public string item_count;
        }

        public class medicine_item
        {
            public string medicineid;
            public string medicine_name;
        }
    }
}

