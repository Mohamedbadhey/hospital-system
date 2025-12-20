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
    public partial class pharmacy_customers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static customer_info[] getCustomers()
        {
            List<customer_info> list = new List<customer_info>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT customerid, customer_name, phone, email, address, 
                           CONVERT(VARCHAR, date_registered, 103) as date_registered
                    FROM pharmacy_customer
                    ORDER BY date_registered DESC
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    customer_info cust = new customer_info();
                    cust.customerid = dr["customerid"].ToString();
                    cust.customer_name = dr["customer_name"].ToString();
                    cust.phone = dr["phone"].ToString();
                    cust.email = dr["email"].ToString();
                    cust.address = dr["address"].ToString();
                    cust.date_registered = dr["date_registered"].ToString();
                    list.Add(cust);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static customer_info[] getCustomerById(string id)
        {
            List<customer_info> list = new List<customer_info>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT customerid, customer_name, phone, email, address
                    FROM pharmacy_customer
                    WHERE customerid = @id
                ", con);
                cmd.Parameters.AddWithValue("@id", id);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    customer_info cust = new customer_info();
                    cust.customerid = dr["customerid"].ToString();
                    cust.customer_name = dr["customer_name"].ToString();
                    cust.phone = dr["phone"].ToString();
                    cust.email = dr["email"].ToString();
                    cust.address = dr["address"].ToString();
                    list.Add(cust);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static string saveCustomer(string customerid, string customerName, string phone, string email, string address)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    if (customerid == "0" || string.IsNullOrEmpty(customerid))
                    {
                        SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO pharmacy_customer (customer_name, phone, email, address)
                            VALUES (@name, @phone, @email, @address)
                        ", con);
                        cmd.Parameters.AddWithValue("@name", customerName);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@email", email);
                        cmd.Parameters.AddWithValue("@address", address);
                        cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        SqlCommand cmd = new SqlCommand(@"
                            UPDATE pharmacy_customer 
                            SET customer_name = @name, phone = @phone, email = @email, address = @address
                            WHERE customerid = @id
                        ", con);
                        cmd.Parameters.AddWithValue("@id", customerid);
                        cmd.Parameters.AddWithValue("@name", customerName);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@email", email);
                        cmd.Parameters.AddWithValue("@address", address);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        public class customer_info
        {
            public string customerid;
            public string customer_name;
            public string phone;
            public string email;
            public string address;
            public string date_registered;
        }
    }
}

