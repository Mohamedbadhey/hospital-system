using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using static juba_hospital.waitingpatients;

namespace juba_hospital
{
    public partial class take_xray : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string UpdateBook(BookData1 data1)
        {
            if (data1.Name != null)
            {
                byte[] bytes = Convert.FromBase64String(data1.Data);

                string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(constr))
                {
                    string sql = "UPDATE xray_results SET xryimage = @xryimage  WHERE xray_result_id = @id";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", data1.id);
                        cmd.Parameters.AddWithValue("@xryimage", bytes);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }

                return "Data Updated Successfully";
            }

            return "File name is null.";
        }

        public class BookData1
        {
            public string id { get; set; }
            public string Data { get; set; }
            public string Name { get; set; }
 
            
        }
        [WebMethod]
        public static string SaveImage(FileData data)
        {
            // Save image file to server
            string filePath = HttpContext.Current.Server.MapPath("~/Files/");
            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }

            string fileName = Path.GetFileName(data.Name);
            string imageFilePath = Path.Combine(filePath, fileName);
            File.WriteAllBytes(imageFilePath, Convert.FromBase64String(data.Data));

            // Insert image data into database
            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                string sql = "INSERT INTO xray_results (xryimage, prescid) VALUES (@bookImage, @prescid)";
                string patientUpdateQuery = "UPDATE [prescribtion] SET " +
                                              "[xray_status] = 2" +
                                            "WHERE [prescid] = @id";


                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@bookImage", File.ReadAllBytes(imageFilePath));
                    cmd.Parameters.AddWithValue("@prescid", data.PrescID);
              

                    // Use data.PrescID to get the prescid value
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, conn))
                {

                    cmd1.Parameters.AddWithValue("@id", data.PrescID);


                    cmd1.ExecuteNonQuery();
                }
            }

            // Optionally, delete the physical file after inserting into the database
            File.Delete(imageFilePath);

            return "Data Saved Successfully";
        }
        public class FileData
        {
            public string Data { get; set; }
            public string ContentType { get; set; }
            public string Name { get; set; }
            public string PrescID { get; set; }
       
        }



        [WebMethod]
        public static xry[] xrayresults( string prescid)
        {
            List<xry> details = new List<xry>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
   select * from xray where prescid = @search
 "
                , con);


                cmd.Parameters.AddWithValue("@search", prescid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        xry field = new xry();


                        field.xryname = dr["xryname"].ToString();
                        field.xrydescribtion = dr["xrydescribtion"].ToString();
                        field.type = dr["type"].ToString();



                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        public class xry
        {
            public string xryname;
            public string xrydescribtion;
            public string type;

        }
        [WebMethod]
        public static ptclass[] pendlap()
        {
            List<ptclass> details = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"

  SELECT 
    patient.full_name, 
    patient.sex,
    patient.location,
    patient.phone,
    CONVERT(date, patient.date_registered) AS date_registered,
    doctor.doctortitle,
    patient.patientid,
    prescribtion.prescid,
    doctor.doctorid,
    xray_results.xray_result_id,
    patient.amount,
    CONVERT(date, patient.dob) AS dob,
    CASE 
        WHEN prescribtion.xray_status = 0 THEN 'waiting'
        WHEN prescribtion.xray_status = 1 THEN 'pending_image'
        WHEN prescribtion.xray_status = 2 THEN 'image_processed'
    END AS status
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
FULL JOIN 
    xray_results ON prescribtion.prescid = xray_results.prescid
WHERE 
    prescribtion.xray_status IN (1, 2) order by patient.date_registered desc;

 ", con);



                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ptclass field = new ptclass();


                        field.full_name = dr["full_name"].ToString();
                        field.sex = dr["sex"].ToString();
                        field.location = dr["location"].ToString();
                        field.phone = dr["phone"].ToString();
                        field.date_registered = Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd");
                        field.doctortitle = dr["doctortitle"].ToString();
                        field.doctorid = dr["doctorid"].ToString();
                        field.patientid = dr["patientid"].ToString();
                        field.prescid = dr["prescid"].ToString();
                        field.amount = dr["amount"].ToString();
                        field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        field.status = dr["status"].ToString();
                        field.xray_result_id = dr["xray_result_id"].ToString();

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }
    }
}