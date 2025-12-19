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
    public partial class Patient_details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public class ptclass
        {
            public string full_name { get; set; }
            public string sex { get; set; }
            public string location { get; set; }
            public string phone { get; set; }
            public string date_registered { get; set; }
            public string doctorid { get; set; }
            public string patientid { get; set; }
            public string prescid { get; set; }
            public string dob { get; set; }
            public string doctortitle { get; set; }
            public string registrationChargeId { get; set; }
            public string deliveryChargeId { get; set; }
        }
        [WebMethod]
        public static ptclass[] datadisplay()
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
                patient.date_registered AS date_registered,
                doctor.doctortitle,
                patient.patientid,
               prescribtion.prescid,
                doctor.doctorid,
                CONVERT(date, patient.dob) AS dob,
                -- Get Registration Charge ID (most recent)
                (SELECT TOP 1 cc.charge_config_id 
                 FROM patient_charges pc
                 INNER JOIN charges_config cc ON pc.charge_name = cc.charge_name AND pc.charge_type = cc.charge_type
                 WHERE pc.patientid = patient.patientid AND pc.charge_type = 'Registration'
                 ORDER BY pc.date_added DESC) AS registrationChargeId,
                -- Get Delivery Charge ID (most recent)
                (SELECT TOP 1 cc.charge_config_id 
                 FROM patient_charges pc
                 INNER JOIN charges_config cc ON pc.charge_name = cc.charge_name AND pc.charge_type = cc.charge_type
                 WHERE pc.patientid = patient.patientid AND pc.charge_type = 'Delivery'
                 ORDER BY pc.date_added DESC) AS deliveryChargeId
            FROM 
                patient
            INNER JOIN 
                prescribtion ON patient.patientid = prescribtion.patientid
            INNER JOIN 
                doctor ON prescribtion.doctorid = doctor.doctorid
order by patient.date_registered;
        ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ptclass field = new ptclass();
                    field.full_name = dr["full_name"].ToString();
                    field.sex = dr["sex"].ToString();
                    field.location = dr["location"].ToString();
                    field.phone = dr["phone"].ToString();
                    field.date_registered = Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd HH:mm");
                    field.doctortitle = dr["doctortitle"].ToString();
                    field.doctorid = dr["doctorid"].ToString();
                    field.patientid = dr["patientid"].ToString();
                    field.prescid = dr["prescid"].ToString();
                    field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                    field.registrationChargeId = dr["registrationChargeId"] != DBNull.Value ? dr["registrationChargeId"].ToString() : "0";
                    field.deliveryChargeId = dr["deliveryChargeId"] != DBNull.Value ? dr["deliveryChargeId"].ToString() : "0";
                    details.Add(field);
                }
            } // Connection will be automatically closed here

            return details.ToArray();
        }

    }
}