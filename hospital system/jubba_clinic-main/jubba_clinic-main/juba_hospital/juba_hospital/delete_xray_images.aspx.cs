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
    public partial class delete_xray_images : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static xrimg[] xryimage1(string prescid)
        {
            List<xrimg> details = new List<xrimg>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                int weeks;
                if (!int.TryParse(prescid, out weeks))
                {
                    // Handle invalid input by returning an empty array
                    return new xrimg[0];
                }

                SqlCommand cmd = new SqlCommand(@"
            SELECT * FROM xray_results
            WHERE date_taken < DATEADD(WEEK, @Weeks, GETDATE());", con);
                cmd.Parameters.AddWithValue("@Weeks", -weeks); // Using negative weeks to subtract

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        xrimg field = new xrimg();

                        // Retrieve binary data as byte array
                        byte[] imageData = (byte[])dr["xryimage"];

                        // Convert byte array to base64 string
                        field.image = Convert.ToBase64String(imageData);

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }


        public class xrimg
        {
            public string image;
        }

        [WebMethod]
        public static xrimg[] xryimage()
        {
            List<xrimg> details = new List<xrimg>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
            SELECT xryimage FROM xray_results 
        ", con);
             

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        xrimg field = new xrimg();

                        // Retrieve binary data as byte array
                        byte[] imageData = (byte[])dr["xryimage"];

                        // Convert byte array to base64 string
                        field.image = Convert.ToBase64String(imageData);

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
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

                    // Convert id parameter to integer
                    int weeks;
                    if (!int.TryParse(id, out weeks))
                    {
                        // Handle invalid input
                        return "Invalid weeks parameter";
                    }

                    // Delete job from jobs table
                    string jobQuery = @"
     
         	     DELETE FROM xray_results
  WHERE date_taken < DATEADD(WEEK, @Weeks, GETDATE());";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Weeks", -weeks);

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
        public static medication[] medicdata1(string search)
        {
            List<medication> details = new List<medication>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Convert search parameter to integer
                int weeks;
                if (!int.TryParse(search, out weeks))
                {
                    // Handle invalid input
                    return details.ToArray();
                }

                SqlCommand cmd = new SqlCommand(@"
          select * from xray
     WHERE date_taken < DATEADD(WEEK, @Weeks, GETDATE());
        ", con);
                cmd.Parameters.AddWithValue("@Weeks", -weeks);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        medication field = new medication();

                        field.xrayid = dr["xrayid"].ToString();
                        field.xryname = dr["xryname"].ToString();
                        field.xrydescribtion = dr["xrydescribtion"].ToString();

                        field.date_taken = dr["date_taken"].ToString();

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        public class medication
        {
            public string xrayid;
            public string xryname;
            public string xrydescribtion;
            public string xryimage;
            
            public string date_taken;
        }
        [WebMethod]
        public static medication[] medicdata()
        {
            List<medication> details = new List<medication>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
 
  select * from  xray_results
 ", con);


                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        medication field = new medication();


                        field.xryimage = dr["xryimage"].ToString();
                    

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

    }
}
