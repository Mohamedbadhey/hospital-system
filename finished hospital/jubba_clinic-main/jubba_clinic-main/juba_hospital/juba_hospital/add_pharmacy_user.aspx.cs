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
    public partial class add_pharmacy_user : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string deleteUser(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "DELETE FROM [pharmacy_user] WHERE [userid] = @id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting user", ex);
            }
        }

        [WebMethod]
        public static string updateUser(string id, string fullname, string phone, string username, string password)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "UPDATE [pharmacy_user] SET " +
                          "[fullname] = @fullname," +
                          "[phone] = @phone," +
                          "[username] = @username," +
                          "[password] = @password" +
                          " WHERE [userid] = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@fullname", fullname);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", password);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating user", ex);
            }
        }

        [WebMethod]
        public static pharm_user[] datadisplay()
        {
            List<pharm_user> details = new List<pharm_user>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"  
                    SELECT userid, fullname, phone, username, password FROM pharmacy_user
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    pharm_user field = new pharm_user();
                    field.userid = dr["userid"].ToString();
                    field.fullname = dr["fullname"].ToString();
                    field.phone = dr["phone"].ToString();
                    field.username = dr["username"].ToString();
                    field.password = dr["password"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        public class pharm_user
        {
            public string userid;
            public string fullname;
            public string phone;
            public string username;
            public string password;
        }

        [WebMethod]
        public static string submitdata(string fullname, string phone, string username, string password)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "INSERT INTO pharmacy_user (fullname, phone, username, password) VALUES (@fullname, @phone, @username, @password);";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@fullname", fullname);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", password);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                return "Error in submitdata method: " + ex.Message;
            }
        }
    }
}

