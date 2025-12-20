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
    public partial class pharmacy_patient_medications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is authenticated and has pharmacy access
                if (Session["username"] == null)
                {
                    Response.Redirect("login.aspx");
                    return;
                }

                // You can add additional role checking here if needed
                // For example, ensure only pharmacy staff can access this page
            }
        }

        [WebMethod]
        public static List<PatientWithMedications> GetPatientsWithMedications(string search, string statusFilter, string dateFilter)
        {
            var patients = new List<PatientWithMedications>();
            
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT DISTINCT 
                            p.patientid,
                            p.full_name,
                            DATEDIFF(YEAR, p.dob, GETDATE()) as age,
                            p.sex as gender,
                            p.phone,
                            pr.prescid,
                            COUNT(m.medid) as medication_count,
                            MAX(m.date_taken) as last_visit
                        FROM patient p
                        INNER JOIN prescribtion pr ON p.patientid = pr.patientid
                        INNER JOIN medication m ON pr.prescid = m.prescid
                        WHERE 1=1";
                    
                    // Add search filter
                    if (!string.IsNullOrEmpty(search))
                    {
                        query += " AND (p.full_name LIKE @search OR p.patientid LIKE @search)";
                    }
                    
                    // Add date filter (using date_taken from medication table)
                    if (!string.IsNullOrEmpty(dateFilter))
                    {
                        switch (dateFilter.ToLower())
                        {
                            case "today":
                                query += " AND CAST(m.date_taken AS DATE) = CAST(GETDATE() AS DATE)";
                                break;
                            case "week":
                                query += " AND m.date_taken >= DATEADD(WEEK, -1, GETDATE())";
                                break;
                            case "month":
                                query += " AND m.date_taken >= DATEADD(MONTH, -1, GETDATE())";
                                break;
                        }
                    }
                    
                    query += @" 
                        GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, pr.prescid
                        ORDER BY MAX(m.date_taken) DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (!string.IsNullOrEmpty(search))
                        {
                            cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                        }
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                patients.Add(new PatientWithMedications
                                {
                                    PatientId = reader["patientid"].ToString(),
                                    PrescId = reader["prescid"].ToString(),
                                    FullName = reader["full_name"].ToString(),
                                    Age = reader["age"] != DBNull.Value ? reader["age"].ToString() : "N/A",
                                    Gender = reader["gender"].ToString(),
                                    Phone = reader["phone"] != DBNull.Value ? reader["phone"].ToString() : "N/A",
                                    MedicationCount = Convert.ToInt32(reader["medication_count"]),
                                    LastVisit = reader["last_visit"] != DBNull.Value 
                                        ? Convert.ToDateTime(reader["last_visit"]) 
                                        : (DateTime?)null
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error or handle appropriately
                // For now, return empty list
                System.Diagnostics.Debug.WriteLine($"Error in GetPatientsWithMedications: {ex.Message}");
            }
            
            return patients;
        }

        [WebMethod]
        public static List<PatientMedication> GetPatientMedications(string prescId)
        {
            var medications = new List<PatientMedication>();
            
            try
            {
                // Debug logging
                System.Diagnostics.Debug.WriteLine($"GetPatientMedications called with prescId: {prescId}");
                
                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT 
                            m.medid,
                            m.med_name as medicine_name,
                            m.dosage,
                            m.frequency,
                            m.duration,
                            'prescribed' as status,
                            m.date_taken as date_assigned,
                            NULL as date_dispensed,
                            m.special_inst as instructions,
                            pr.prescid,
                            p.full_name as patient_name,
                            d.doctorname as doctor_name
                        FROM medication m
                        INNER JOIN prescribtion pr ON m.prescid = pr.prescid
                        INNER JOIN patient p ON pr.patientid = p.patientid
                        LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                        WHERE m.prescid = @prescId
                        ORDER BY m.date_taken DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@prescId", Convert.ToInt32(prescId));
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                medications.Add(new PatientMedication
                                {
                                    MedId = reader["medid"] != DBNull.Value ? reader["medid"].ToString() : "",
                                    MedicineName = reader["medicine_name"] != DBNull.Value ? reader["medicine_name"].ToString() : "",
                                    Quantity = reader["dosage"] != DBNull.Value ? reader["dosage"].ToString() : "",
                                    Unit = reader["frequency"] != DBNull.Value ? reader["frequency"].ToString() : "",
                                    Status = reader["status"] != DBNull.Value ? reader["status"].ToString() : "prescribed",
                                    AssignedDate = reader["date_assigned"] != DBNull.Value 
                                        ? Convert.ToDateTime(reader["date_assigned"]) 
                                        : DateTimeHelper.Now,
                                    DispensedDate = reader["date_dispensed"] != DBNull.Value 
                                        ? (DateTime?)Convert.ToDateTime(reader["date_dispensed"]) 
                                        : null,
                                    Instructions = reader["instructions"] != DBNull.Value ? reader["instructions"].ToString() : "",
                                    PrescriptionId = reader["prescid"] != DBNull.Value ? reader["prescid"].ToString() : "",
                                    PatientName = reader["patient_name"] != DBNull.Value ? reader["patient_name"].ToString() : "",
                                    DoctorName = reader["doctor_name"] != DBNull.Value ? reader["doctor_name"].ToString() : "N/A"
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error or handle appropriately
                System.Diagnostics.Debug.WriteLine($"Error in GetPatientMedications: {ex.Message}");
            }
            
            return medications;
        }

        [WebMethod]
        public static object UpdateMedicationStatus(string medId, string status)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    string query = "UPDATE assignmed SET status = @status";
                    
                    if (status.ToLower() == "dispensed")
                    {
                        query += ", date_dispensed = @date_dispensed";
                    }
                    
                    query += " WHERE med_id = @medId";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@status", status);
                        if (status.ToLower() == "dispensed")
                        {
                            cmd.Parameters.AddWithValue("@date_dispensed", DateTimeHelper.Now);
                        }
                        cmd.Parameters.AddWithValue("@medId", medId);
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected > 0)
                        {
                            return new { success = true, message = "Medication status updated successfully" };
                        }
                        else
                        {
                            return new { success = false, message = "No medication found with the specified ID" };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error updating medication status: " + ex.Message };
            }
        }

        // Helper classes for JSON serialization
        public class PatientWithMedications
        {
            public string PatientId { get; set; }
            public string PrescId { get; set; }
            public string FullName { get; set; }
            public string Age { get; set; }
            public string Gender { get; set; }
            public string Phone { get; set; }
            public int MedicationCount { get; set; }
            public DateTime? LastVisit { get; set; }
        }

        public class PatientMedication
        {
            public string MedId { get; set; }
            public string MedicineName { get; set; }
            public string Quantity { get; set; }
            public string Unit { get; set; }
            public string Status { get; set; }
            public DateTime AssignedDate { get; set; }
            public DateTime? DispensedDate { get; set; }
            public string Instructions { get; set; }
            public string PrescriptionId { get; set; }
            public string PatientName { get; set; }
            public string DoctorName { get; set; }
        }
    }
}