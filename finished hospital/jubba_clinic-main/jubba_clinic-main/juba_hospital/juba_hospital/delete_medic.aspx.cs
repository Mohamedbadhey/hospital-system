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
    public partial class delete_medic : System.Web.UI.Page
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

                    // Convert id parameter to integer
                    int weeks;
                    if (!int.TryParse(id, out weeks))
                    {
                        // Handle invalid input
                        return "Invalid weeks parameter";
                    }

                    // Delete job from jobs table
                    string jobQuery = @"
                DELETE FROM [medication]
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
            SELECT medid, med_name, dosage, frequency, duration, special_inst, prescid, date_taken
            FROM [medication]
            WHERE date_taken < DATEADD(WEEK, @Weeks, GETDATE());
        ", con);
                cmd.Parameters.AddWithValue("@Weeks", -weeks);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        medication field = new medication();

                        field.med_name = dr["med_name"].ToString();
                        field.dosage = dr["dosage"].ToString();
                        field.frequency = dr["frequency"].ToString();
                        field.duration = dr["duration"].ToString();
                        field.special_inst = dr["special_inst"].ToString();
                        field.medid = dr["medid"].ToString();
                        field.date_taken = dr["date_taken"].ToString();

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
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
   SELECT TOP (1000) [medid]
      ,[med_name]
      ,[dosage]
      ,[frequency]
      ,[duration]
      ,[special_inst]
      ,[prescid]
      ,[date_taken]
  FROM [medication]
 ", con);


                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        medication field = new medication();


                        field.med_name = dr["med_name"].ToString();
                        field.dosage = dr["dosage"].ToString();
                        field.frequency = dr["frequency"].ToString();
                        field.duration = dr["duration"].ToString();
                        field.special_inst = dr["special_inst"].ToString();
                        field.medid = dr["medid"].ToString();
                        field.date_taken = dr["date_taken"].ToString();


                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        public class medication
        {
            public string med_name;
            public string dosage;
            public string frequency;
            public string duration;
            public string special_inst;
            public string medid;
            public string date_taken;

        }
    }
}