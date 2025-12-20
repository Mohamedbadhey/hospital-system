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
    public partial class waitingpatients : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class rempay
        {


            public string custid { get; set; }

            public string FullName { get; set; }
            public string Location { get; set; }
            public string Number { get; set; }

            public string MeterName { get; set; }





        }
        [WebMethod]
        public static ptclass[] patientwait(string search)
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
    CASE 
        WHEN prescribtion.status = 0 THEN 'waiting'
        WHEN prescribtion.status = 1 THEN 'processed'
        WHEN prescribtion.status = 2 THEN 'pending-xray'
        WHEN prescribtion.status = 3 THEN 'X-ray-Processed'
    END AS status
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
WHERE 
    doctor.doctorid = @search
    AND prescribtion.status = 0
    AND (patient.patient_type = 'outpatient' OR patient.patient_type IS NULL);

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
            public string xray_result_id { get; set; }
            public string xrayid { get; set; }
            
            public string lab_result_id { get; set; }
            public string xray_status { get; set; }

            public string patient_status { get; set; }
            public string amount { get; set; }
            public string dob { get; set; }
            public string doctortitle { get; set; }
            public string status { get; set; }
            
            // Lab reorder tracking properties
            public string is_reorder { get; set; }
            public string reorder_reason { get; set; }
            public string last_order_date { get; set; }
            
            // Lab charge tracking properties
            public string lab_charge_paid { get; set; }
            public string unpaid_lab_charges { get; set; }
            
            // Lab order tracking properties
            public string order_id { get; set; }
            public string charge_name { get; set; }
            public string charge_amount { get; set; }
            
            // Transaction status property
            public string transaction_status { get; set; }
            
            // Lab order ID (med_id from lab_test table)
            public string lab_order_id { get; set; }
            public string lab_order_date { get; set; }
        }
        [WebMethod]
        public static ptclass[] datadisplay1()
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
                CONVERT(date, patient.dob) AS dob
            FROM 
                patient
            INNER JOIN 
                prescribtion ON patient.patientid = prescribtion.patientid
            INNER JOIN 
                doctor ON prescribtion.doctorid = doctor.doctorid;
        ", con);

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
                    field.amount = dr["amount"].ToString();
                    field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                    details.Add(field);
                }
            } // Connection will be automatically closed here

            return details.ToArray();
        }
    }
}