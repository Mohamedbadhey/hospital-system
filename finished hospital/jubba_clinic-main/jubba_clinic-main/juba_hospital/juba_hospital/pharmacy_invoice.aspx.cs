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
    public partial class pharmacy_invoice : System.Web.UI.Page
    {
        protected Literal PrintHeaderLiteral;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add hospital print header
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
            }
        }

        [WebMethod]
        public static invoice_data[] getInvoiceData(string invoiceNumber)
        {
            List<invoice_data> list = new List<invoice_data>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT saleid, invoice_number, customer_name, 
                           CONVERT(VARCHAR, sale_date, 103) as sale_date,
                           total_amount, discount, final_amount, payment_method,
                           (SELECT phone FROM pharmacy_customer WHERE customerid = s.customerid) as customer_phone
                    FROM pharmacy_sales s
                    WHERE invoice_number = @invoice
                ", con);
                cmd.Parameters.AddWithValue("@invoice", invoiceNumber);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    invoice_data inv = new invoice_data();
                    inv.saleid = dr["saleid"].ToString();
                    inv.invoice_number = dr["invoice_number"].ToString();
                    inv.customer_name = dr["customer_name"].ToString();
                    inv.sale_date = dr["sale_date"].ToString();
                    inv.total_amount = dr["total_amount"].ToString();
                    inv.discount = dr["discount"].ToString();
                    inv.final_amount = dr["final_amount"].ToString();
                    inv.payment_method = dr["payment_method"].ToString();
                    inv.customer_phone = dr["customer_phone"] == DBNull.Value ? "" : dr["customer_phone"].ToString();
                    list.Add(inv);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static invoice_item[] getInvoiceItems(string saleid)
        {
            List<invoice_item> list = new List<invoice_item>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        ISNULL(m.medicine_name, 'Unknown Medicine') as medicine_name, 
                        ISNULL(si.quantity_type, 'piece') as quantity_type, 
                        ISNULL(si.quantity, 0) as quantity, 
                        ISNULL(si.unit_price, 0) as unit_price, 
                        ISNULL(si.total_price, 0) as total_price
                    FROM pharmacy_sales_items si
                    LEFT JOIN medicine m ON si.medicineid = m.medicineid
                    WHERE si.saleid = @saleid
                    ORDER BY si.sale_item_id
                ", con);
                cmd.Parameters.AddWithValue("@saleid", saleid);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    invoice_item item = new invoice_item();
                    item.medicine_name = dr["medicine_name"].ToString();
                    item.quantity_type = dr["quantity_type"].ToString();
                    item.quantity = dr["quantity"].ToString();
                    item.unit_price = dr["unit_price"].ToString();
                    item.total_price = dr["total_price"].ToString();
                    list.Add(item);
                }
            }
            return list.ToArray();
        }

        public class invoice_data
        {
            public string saleid;
            public string invoice_number;
            public string customer_name;
            public string sale_date;
            public string total_amount;
            public string discount;
            public string final_amount;
            public string payment_method;
            public string customer_phone;
        }

        public class invoice_item
        {
            public string medicine_name;
            public string quantity_type;
            public string quantity;
            public string unit_price;
            public string total_price;
        }
    }
}

