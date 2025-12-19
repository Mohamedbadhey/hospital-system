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
    public partial class patient_status : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static ptclass[] inoutpatient( string search)
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
       CONVERT(date, patient.dob) AS dob,
	     CASE 
      WHEN patient.patient_status = 0 THEN 'Out Patient'
         WHEN patient.patient_status = 1 THEN 'In Patient'
         WHEN patient.patient_status = 2 THEN 'Discharged'
  END AS patient_status
   FROM 
       patient
   INNER JOIN 
       prescribtion ON patient.patientid = prescribtion.patientid
   INNER JOIN 
       doctor ON prescribtion.doctorid = doctor.doctorid
where patient.patient_status = @search;
        ", con);

                cmd.Parameters.AddWithValue("@search", search);

                SqlDataReader dr = cmd.ExecuteReader();
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
                    field.patient_status = dr["patient_status"].ToString();
                    field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                    details.Add(field);
                }
            } // Connection will be automatically closed here

            return details.ToArray();
        }
    }
}