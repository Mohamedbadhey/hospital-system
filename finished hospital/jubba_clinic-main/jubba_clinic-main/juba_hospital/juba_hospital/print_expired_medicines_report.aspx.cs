using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class print_expired_medicines_report : System.Web.UI.Page
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
        public static expired_item[] getExpiredMedicines()
        {
            List<expired_item> list = new List<expired_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        m.medicine_name,
                        mi.batch_number,
                        CONVERT(VARCHAR, mi.expiry_date, 103) as expiry_date,
                        DATEDIFF(DAY, GETDATE(), mi.expiry_date) as days_remaining,
                        mi.primary_quantity,
                        mi.secondary_quantity,
                        mi.unit_size
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE mi.expiry_date IS NOT NULL 
                    AND (mi.expiry_date < GETDATE() OR mi.expiry_date <= DATEADD(DAY, 30, GETDATE()))
                    AND (ISNULL(mi.primary_quantity, 0) > 0 OR ISNULL(mi.secondary_quantity, 0) > 0)
                    ORDER BY mi.expiry_date ASC, m.medicine_name ASC
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    expired_item item = new expired_item();
                    item.medicine_name = dr["medicine_name"].ToString();
                    item.batch_number = dr["batch_number"] == DBNull.Value ? "" : dr["batch_number"].ToString();
                    item.expiry_date = dr["expiry_date"].ToString();
                    item.days_remaining = dr["days_remaining"].ToString();
                    item.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    item.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    item.unit_size = dr["unit_size"] == DBNull.Value ? "0" : dr["unit_size"].ToString();
                    list.Add(item);
                }
            }
            return list.ToArray();
        }

        public class expired_item
        {
            public string medicine_name;
            public string batch_number;
            public string expiry_date;
            public string days_remaining;
            public string primary_quantity;
            public string secondary_quantity;
            public string unit_size;
        }
    }
}
