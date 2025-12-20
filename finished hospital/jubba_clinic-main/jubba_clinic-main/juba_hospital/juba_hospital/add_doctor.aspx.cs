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
    public partial class add_doctor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string deleteJob(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Delete job from jobs table
                    string jobQuery = "DELETE FROM [doctor] WHERE [doctorid] = @id";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);

                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error deleting job", ex);
            }
        }



        [WebMethod]
        public static string updateJob( string id ,string name, string title, string pass, string phone, string username)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update jobs table
                    string jobQuery = "UPDATE [doctor] SET " +
                          "[doctorname] = @doctorname," +
                            "[doctortitle] = @doctortitle," +
                            "[doctornumber] = @doctornumber," +
                        "[username] = @username," +
                           "[password] = @password" +
                        " WHERE [doctorid] = @id";





                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@doctorname", name);
                        cmd.Parameters.AddWithValue("@doctortitle", title);
                        cmd.Parameters.AddWithValue("@password", pass);
                        cmd.Parameters.AddWithValue("@doctornumber", phone);
                        cmd.Parameters.AddWithValue("@username", username);

                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error updating job information", ex);
            }
        }
        [WebMethod]
        public static ct[] datadisplay()
        {
            List<ct> details = new List<ct>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"  
           select doctorid, doctorname,doctortitle,doctornumber,username,password from doctor
        ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ct field = new ct();
                    field.full_name = dr["doctorname"].ToString();
                    field.doctortitle = dr["doctortitle"].ToString();
                    field.doctornumber = dr["doctornumber"].ToString();
                    field.username = dr["username"].ToString();
                    field.password = dr["password"].ToString();
                    field.doctorid = dr["doctorid"].ToString();

                    details.Add(field);
                }
            } // Connection will be automatically closed here

            return details.ToArray();
        }
        public class ct
        {
                public string full_name;
            public string doctortitle;
            public string username;
            public string password;
            public string doctornumber;
            public string doctorid;

        }

        [WebMethod]
        public static string submitdata(string name, string title, string pass, string phone, string username)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert into patient table
                    string patientquery = "INSERT INTO doctor (doctorname, doctortitle, doctornumber, username, password) VALUES (@name, @title,@phone,@username, @pass );";
                    using (SqlCommand cmd = new SqlCommand(patientquery, con))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@title", title);
                        cmd.Parameters.AddWithValue("@pass", pass);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@username", username);

                        cmd.ExecuteNonQuery();

                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions and return the error message
                return "Error in submitdata method: " + ex.Message;
            }
        }
    }
}