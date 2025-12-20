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
    public partial class patient_amount : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static ptclass[] medic()
        {
            List<ptclass> details = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
     
     
	SELECT 
    patient.patientid,
    patient.full_name, 
    patient.sex,
    patient.location,
    patient.phone,
    patient.date_registered,
    doctor.doctortitle,
    patient.patientid,
    prescribtion.prescid,
    doctor.doctorid,
    doctor.doctortitle,
    xray.xrayid,
    CONVERT(date, patient.dob) AS dob,
    CASE 
        WHEN prescribtion.status = 0 THEN 'waiting'
        WHEN prescribtion.status = 1 THEN 'processed'
        WHEN prescribtion.status = 2 THEN 'pending-lap'
        WHEN prescribtion.status = 3 THEN 'lap-processed'
    END AS status,
	    CASE 
    WHEN patient.patient_status = 0 THEN 'Out Patient'
       WHEN patient.patient_status = 1 THEN 'In Patient'
       WHEN patient.patient_status = 2 THEN 'Discharged'
	     WHEN patient.patient_status = 3 THEN 'Discharged'
END AS patient_status,
    CASE 
        WHEN prescribtion.xray_status = 0 THEN 'waiting'
        WHEN prescribtion.xray_status = 1 THEN 'pending_image'
        WHEN prescribtion.xray_status = 2 THEN 'image_processed'
    END AS status_xray
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
	
LEFT JOIN 
    xray ON prescribtion.prescid = xray.prescid

ORDER BY 
    patient.date_registered DESC;

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
                        field.date_registered = dr["date_registered"].ToString();
                        field.doctortitle = dr["doctortitle"].ToString();
                        field.doctorid = dr["doctorid"].ToString();
                        field.patientid = dr["patientid"].ToString();
                        field.doctortitle = dr["doctortitle"].ToString();
                        field.prescid = dr["prescid"].ToString();
                        field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        field.status = dr["status"].ToString();
                        field.xray_status = dr["status_xray"].ToString();
                        field.xrayid = dr["xrayid"].ToString();
                        field.patient_status = dr["patient_status"].ToString();
                        

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }
    }
}