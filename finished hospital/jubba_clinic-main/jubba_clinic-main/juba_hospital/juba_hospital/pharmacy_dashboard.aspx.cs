using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static juba_hospital.pharmacy_dashboard;

namespace juba_hospital
{
    public partial class pharmacy_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class total_med
        {
            public string total { get; set; }
        }

        public class low_stock_count
        {
            public string total { get; set; }
        }

        public class expired_count
        {
            public string total { get; set; }
        }

        public class todays_sales_amount
        {
            public string total { get; set; }
        }

        public class expiry_item
        {
            public string medicine_name { get; set; }
            public string batch_number { get; set; }
            public string expiry_date { get; set; }
            public string days_remaining { get; set; }
            public string primary_quantity { get; set; }
        }

        [WebMethod]
        public static total_med[] total_medicines()
        {
            List<total_med> details = new List<total_med>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*) as total FROM medicine
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    total_med field = new total_med();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static low_stock_count[] low_stock()
        {
            List<low_stock_count> details = new List<low_stock_count>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT mi.medicineid) as total 
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE mi.primary_quantity <= mi.reorder_level_strips
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    low_stock_count field = new low_stock_count();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static expired_count[] expired_medicines()
        {
            List<expired_count> details = new List<expired_count>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*) as total 
                    FROM medicine_inventory mi
                    WHERE mi.expiry_date IS NOT NULL 
                    AND (mi.expiry_date < GETDATE() OR mi.expiry_date <= DATEADD(DAY, 30, GETDATE()))
                    AND (mi.primary_quantity > 0 OR mi.secondary_quantity > 0)
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    expired_count field = new expired_count();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static todays_sales_amount[] todays_sales(string currentDate)
        {
            List<todays_sales_amount> details = new List<todays_sales_amount>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT ISNULL(SUM(final_amount), 0) as total 
                    FROM pharmacy_sales
                    WHERE CAST(sale_date AS DATE) = @currentDate
                    AND status = 1
                    AND saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                ", con);
                
                cmd.Parameters.AddWithValue("@currentDate", currentDate);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    todays_sales_amount field = new todays_sales_amount();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static expiry_item[] getExpiryList()
        {
            List<expiry_item> details = new List<expiry_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 20
                        m.medicine_name,
                        mi.batch_number,
                        CONVERT(VARCHAR, mi.expiry_date, 103) as expiry_date,
                        DATEDIFF(DAY, GETDATE(), mi.expiry_date) as days_remaining,
                        mi.primary_quantity
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE mi.expiry_date IS NOT NULL 
                    AND (mi.expiry_date < GETDATE() OR mi.expiry_date <= DATEADD(DAY, 30, GETDATE()))
                    AND (mi.primary_quantity > 0 OR mi.secondary_quantity > 0)
                    ORDER BY mi.expiry_date ASC
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    expiry_item field = new expiry_item();
                    field.medicine_name = dr["medicine_name"].ToString();
                    field.batch_number = dr["batch_number"].ToString();
                    field.expiry_date = dr["expiry_date"].ToString();
                    field.days_remaining = dr["days_remaining"].ToString();
                    field.primary_quantity = dr["primary_quantity"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static todays_sales_amount[] todays_profit(string currentDate)
        {
            List<todays_sales_amount> details = new List<todays_sales_amount>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT ISNULL(SUM(si.profit), 0) as total
                    FROM pharmacy_sales_items si
                    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                    WHERE CAST(s.sale_date AS DATE) = @currentDate
                    AND s.status = 1
                    AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                ", con);
                
                cmd.Parameters.AddWithValue("@currentDate", currentDate);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    todays_sales_amount field = new todays_sales_amount();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        public class profit_margin
        {
            public string margin { get; set; }
        }

        [WebMethod]
        public static profit_margin[] todays_profit_margin()
        {
            List<profit_margin> details = new List<profit_margin>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        CASE 
                            WHEN SUM(s.total_amount) > 0 
                            THEN ROUND((SUM(ISNULL(si.profit, 0)) / SUM(s.total_amount)) * 100, 2)
                            ELSE 0 
                        END as margin
                    FROM pharmacy_sales_items si
                    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                    WHERE CAST(s.sale_date AS DATE) = CAST(GETDATE() AS DATE)
                    AND s.status = 1
                    AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    profit_margin field = new profit_margin();
                    field.margin = dr["margin"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static todays_sales_amount[] month_sales()
        {
            List<todays_sales_amount> details = new List<todays_sales_amount>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT ISNULL(SUM(final_amount), 0) as total
                    FROM pharmacy_sales
                    WHERE YEAR(sale_date) = YEAR(GETDATE())
                    AND MONTH(sale_date) = MONTH(GETDATE())
                    AND status = 1
                    AND saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    todays_sales_amount field = new todays_sales_amount();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static todays_sales_amount[] month_profit()
        {
            List<todays_sales_amount> details = new List<todays_sales_amount>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT ISNULL(SUM(si.profit), 0) as total
                    FROM pharmacy_sales_items si
                    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
                    WHERE YEAR(s.sale_date) = YEAR(GETDATE())
                    AND MONTH(s.sale_date) = MONTH(GETDATE())
                    AND s.status = 1
                    AND s.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    todays_sales_amount field = new todays_sales_amount();
                    field.total = dr["total"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }
    }
}
