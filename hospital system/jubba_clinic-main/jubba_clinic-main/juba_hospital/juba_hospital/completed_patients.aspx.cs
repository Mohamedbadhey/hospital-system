using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class completed_patients : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication is handled by the Master page (doctor.Master)
            // No additional session check needed here
        }

        [WebMethod]
        public static CompletedPatientInfo[] GetCompletedPatients(string doctorid)
        {
            List<CompletedPatientInfo> patients = new List<CompletedPatientInfo>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT 
                            patient.patientid,
                            patient.full_name, 
                            patient.sex,
                            patient.location,
                            patient.phone,
                            patient.amount,
                            CONVERT(date, patient.dob) AS dob,
                            patient.date_registered,
                            prescribtion.prescid,
                            prescribtion.doctorid,
                            prescribtion.transaction_status,
                            CASE 
                                WHEN prescribtion.status = 0 THEN 'waiting'
                                WHEN prescribtion.status = 1 THEN 'processed'
                                WHEN prescribtion.status = 2 THEN 'pending-xray'
                                WHEN prescribtion.status = 3 THEN 'xray-processed'
                                WHEN prescribtion.status = 4 THEN 'pending-lab'
                                WHEN prescribtion.status = 5 THEN 'lab-processed'
                                ELSE 'N/A'
                            END AS status,
                            CASE 
                                WHEN prescribtion.xray_status = 0 THEN 'waiting'
                                WHEN prescribtion.xray_status = 1 THEN 'pending_image'
                                WHEN prescribtion.xray_status = 2 THEN 'image_processed'
                                ELSE 'N/A'
                            END AS xray_status,
                            prescribtion.completed_date
                        FROM 
                            patient
                        INNER JOIN 
                            prescribtion ON patient.patientid = prescribtion.patientid
                        INNER JOIN 
                            doctor ON prescribtion.doctorid = doctor.doctorid
                        WHERE 
                            doctor.doctorid = @doctorid
                            AND prescribtion.transaction_status = 'completed'
                            AND (patient.patient_type = 'outpatient' OR patient.patient_type IS NULL)
                        ORDER BY 
                            ISNULL(prescribtion.completed_date, patient.date_registered) DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@doctorid", doctorid);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                CompletedPatientInfo patient = new CompletedPatientInfo
                                {
                                    patientid = dr["patientid"].ToString(),
                                    full_name = dr["full_name"].ToString(),
                                    sex = dr["sex"].ToString(),
                                    location = dr["location"].ToString(),
                                    phone = dr["phone"].ToString(),
                                    amount = dr["amount"].ToString(),
                                    dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd"),
                                    date_registered = dr["date_registered"].ToString(),
                                    prescid = dr["prescid"].ToString(),
                                    doctorid = dr["doctorid"].ToString(),
                                    status = dr["status"].ToString(),
                                    xray_status = dr["xray_status"].ToString(),
                                    transaction_status = dr["transaction_status"].ToString(),
                                    completed_date = dr["completed_date"] != DBNull.Value ? 
                                        Convert.ToDateTime(dr["completed_date"]).ToString("yyyy-MM-dd HH:mm") : ""
                                };

                                patients.Add(patient);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Error in GetCompletedPatients: " + ex.Message);
            }

            return patients.ToArray();
        }

        [WebMethod]
        public static CompletedPatientInfo GetPatientDetails(int prescid)
        {
            CompletedPatientInfo patient = null;
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = @"
                        SELECT 
                            patient.patientid,
                            patient.full_name, 
                            patient.sex,
                            patient.location,
                            patient.phone,
                            patient.amount,
                            CONVERT(date, patient.dob) AS dob,
                            patient.date_registered,
                            prescribtion.prescid,
                            prescribtion.doctorid,
                            prescribtion.transaction_status,
                            CASE 
                                WHEN prescribtion.status = 0 THEN 'waiting'
                                WHEN prescribtion.status = 1 THEN 'processed'
                                WHEN prescribtion.status = 2 THEN 'pending-xray'
                                WHEN prescribtion.status = 3 THEN 'xray-processed'
                                WHEN prescribtion.status = 4 THEN 'pending-lab'
                                WHEN prescribtion.status = 5 THEN 'lab-processed'
                                ELSE 'N/A'
                            END AS status,
                            CASE 
                                WHEN prescribtion.xray_status = 0 THEN 'waiting'
                                WHEN prescribtion.xray_status = 1 THEN 'pending_image'
                                WHEN prescribtion.xray_status = 2 THEN 'image_processed'
                                ELSE 'N/A'
                            END AS xray_status,
                            prescribtion.completed_date
                        FROM 
                            patient
                        INNER JOIN 
                            prescribtion ON patient.patientid = prescribtion.patientid
                        WHERE 
                            prescribtion.prescid = @prescid";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                patient = new CompletedPatientInfo
                                {
                                    patientid = dr["patientid"].ToString(),
                                    full_name = dr["full_name"].ToString(),
                                    sex = dr["sex"].ToString(),
                                    location = dr["location"].ToString(),
                                    phone = dr["phone"].ToString(),
                                    amount = dr["amount"].ToString(),
                                    dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd"),
                                    date_registered = dr["date_registered"].ToString(),
                                    prescid = dr["prescid"].ToString(),
                                    doctorid = dr["doctorid"].ToString(),
                                    status = dr["status"].ToString(),
                                    xray_status = dr["xray_status"].ToString(),
                                    transaction_status = dr["transaction_status"].ToString(),
                                    completed_date = dr["completed_date"] != DBNull.Value ?
                                        Convert.ToDateTime(dr["completed_date"]).ToString("yyyy-MM-dd HH:mm") : ""
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetPatientDetails: " + ex.Message);
            }

            return patient;
        }
    }

    public class CompletedPatientInfo
    {
        public string patientid { get; set; }
        public string full_name { get; set; }
        public string sex { get; set; }
        public string location { get; set; }
        public string phone { get; set; }
        public string amount { get; set; }
        public string dob { get; set; }
        public string date_registered { get; set; }
        public string prescid { get; set; }
        public string doctorid { get; set; }
        public string status { get; set; }
        public string xray_status { get; set; }
        public string transaction_status { get; set; }
        public string completed_date { get; set; }
    }
}
