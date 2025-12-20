using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static juba_hospital.waitingpatients;

namespace juba_hospital
{
    public partial class lap_processed : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ptclass[] lapprocessed(string search)
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
        patient.amount,
        CONVERT(date, patient.dob) AS dob,
        lr.lab_result_id,
        CASE 
            WHEN prescribtion.status = 0 THEN 'waiting'
            WHEN prescribtion.status = 1 THEN 'processed'
            WHEN prescribtion.status = 2 THEN 'pending-xray'
            WHEN prescribtion.status = 3 THEN 'X-ray-Processed'
            WHEN prescribtion.status = 4 THEN 'pending-lap'
            WHEN prescribtion.status = 5 THEN 'lap-processed'
        END AS status
    FROM patient
    INNER JOIN prescribtion ON patient.patientid = prescribtion.patientid
    INNER JOIN doctor ON prescribtion.doctorid = doctor.doctorid
    OUTER APPLY (
        SELECT TOP 1 lab_result_id
        FROM lab_results lr
        WHERE lr.prescid = prescribtion.prescid
        ORDER BY lr.date_taken DESC, lr.lab_result_id DESC
    ) lr
    WHERE prescribtion.status IN (4, 5)
      AND (
            @search IS NULL 
            OR @search = '' 
            OR doctor.doctorid = @search
      );
 ", con);
                if (string.IsNullOrWhiteSpace(search))
                {
                    cmd.Parameters.AddWithValue("@search", DBNull.Value);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@search", search);
                }


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
                        field.lab_result_id = dr["lab_result_id"] == DBNull.Value ? string.Empty : dr["lab_result_id"].ToString();
                        field.patientid = dr["patientid"].ToString();
                        field.prescid = dr["prescid"].ToString();
                        field.amount = dr["amount"].ToString();
                        field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        field.status = dr["status"].ToString();

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }
    }
}