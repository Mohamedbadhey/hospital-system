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
    public partial class medication_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static medication[] medicdata(string prescid)
        {
            List<medication> details = new List<medication>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
      select * from medication where prescid = @search;
 ", con);
                cmd.Parameters.AddWithValue("@search", prescid);


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

        }

        [WebMethod]
        public static ptclass[] medic(string search)
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
    doctor.doctortitle,
    patient.amount,
    CONVERT(date, patient.dob) AS dob,
    CASE 
        WHEN prescribtion.status = 0 THEN 'waiting'
        WHEN prescribtion.status = 1 THEN 'processed'
        WHEN prescribtion.status = 2 THEN 'pending-xray'
        WHEN prescribtion.status = 3 THEN 'X-ray-Processed'
		 WHEN prescribtion.status = 4 THEN 'pending-lap'
	     WHEN prescribtion.status = 5 THEN 'lap-processed'
    END AS status
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
WHERE 
    doctor.doctorid = @search
    AND prescribtion.status  in (0,3,5);

 ", con);
                cmd.Parameters.AddWithValue("@search", search);


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
                        field.doctortitle = dr["doctortitle"].ToString();
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