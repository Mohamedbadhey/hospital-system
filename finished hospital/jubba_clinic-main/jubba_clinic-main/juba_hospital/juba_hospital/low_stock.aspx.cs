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
    public partial class low_stock : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static low_stock_item[] getLowStock()
        {
            List<low_stock_item> list = new List<low_stock_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT mi.primary_quantity, mi.secondary_quantity, mi.reorder_level_strips, mi.expiry_date, m.medicine_name
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE ISNULL(mi.primary_quantity, 0) <= ISNULL(mi.reorder_level_strips, 0)
                    AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                    ORDER BY (ISNULL(mi.primary_quantity, 0) - ISNULL(mi.reorder_level_strips, 0)) ASC
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    low_stock_item item = new low_stock_item();
                    item.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    item.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    item.reorder_level_strips = dr["reorder_level_strips"] == DBNull.Value ? "10" : dr["reorder_level_strips"].ToString();
                    item.expiry_date = dr["expiry_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["expiry_date"]).ToString("yyyy-MM-dd");
                    item.medicine_name = dr["medicine_name"].ToString();
                    list.Add(item);
                }
            }
            return list.ToArray();
        }

        public class low_stock_item
        {
            public string primary_quantity;
            public string secondary_quantity;
            public string reorder_level_strips;
            public string expiry_date;
            public string medicine_name;
        }
    }
}

