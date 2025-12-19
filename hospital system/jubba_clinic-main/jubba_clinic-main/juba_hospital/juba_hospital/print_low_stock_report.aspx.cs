using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class print_low_stock_report : System.Web.UI.Page
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
        public static low_stock_item[] getLowStockMedicines()
        {
            List<low_stock_item> list = new List<low_stock_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            m.medicine_name,
                            ISNULL(m.generic_name, '') as generic_name,
                            ISNULL(m.manufacturer, '') as manufacturer,
                            '' as unit_name,
                            'units' as subdivision_unit,
                            ISNULL(mi.primary_quantity, 0) as primary_quantity,
                            ISNULL(mi.secondary_quantity, 0) as secondary_quantity,
                            ISNULL(mi.reorder_level_strips, 10) as reorder_level_strips,
                            mi.expiry_date
                        FROM medicine_inventory mi
                        INNER JOIN medicine m ON mi.medicineid = m.medicineid
                        WHERE ISNULL(mi.primary_quantity, 0) <= ISNULL(mi.reorder_level_strips, 10)
                        AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                        ORDER BY ISNULL(mi.primary_quantity, 0) ASC, m.medicine_name ASC
                    ", con);
                    
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        low_stock_item item = new low_stock_item();
                        item.medicine_name = dr["medicine_name"].ToString();
                        item.generic_name = dr["generic_name"].ToString();
                        item.manufacturer = dr["manufacturer"].ToString();
                        item.unit_name = dr["unit_name"].ToString();
                        item.subdivision_unit = dr["subdivision_unit"].ToString();
                        item.primary_quantity = dr["primary_quantity"].ToString();
                        item.secondary_quantity = dr["secondary_quantity"].ToString();
                        item.reorder_level_strips = dr["reorder_level_strips"].ToString();
                        item.expiry_date = dr["expiry_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["expiry_date"]).ToString("yyyy-MM-dd");
                        list.Add(item);
                    }
                    dr.Close();
                }
            }
            catch (Exception ex)
            {
                // Log error for debugging - in production you'd use proper logging
                throw new Exception("Error getting low stock medicines: " + ex.Message, ex);
            }
            
            return list.ToArray();
        }

        public class low_stock_item
        {
            public string medicine_name;
            public string generic_name;
            public string manufacturer;
            public string unit_name;
            public string subdivision_unit;
            public string primary_quantity;
            public string secondary_quantity;
            public string reorder_level_strips;
            public string expiry_date;
        }
    }
}