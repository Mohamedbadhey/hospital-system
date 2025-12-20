using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace juba_hospital
{
    public partial class registre_outpatients : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOutpatients();
            }
        }

        private void LoadOutpatients()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT 
                        p.patientid,
                        p.full_name,
                        p.dob,
                        p.sex,
                        p.phone,
                        p.location,
                        p.date_registered,
                        pr.prescid,
                        ISNULL(SUM(pc.amount), 0) as total_charges,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
                    FROM patient p
                    LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
                    LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
                    WHERE (p.patient_type = 'outpatient' OR (p.patient_type IS NULL AND p.bed_admission_date IS NULL))
                          AND p.patient_status = 0
                    GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, p.date_registered, pr.prescid
                    ORDER BY p.date_registered DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                
                try
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    
                    if (reader.HasRows)
                    {
                        rptOutpatients.DataSource = reader;
                        rptOutpatients.DataBind();
                        noData.Visible = false;
                    }
                    else
                    {
                        noData.Visible = true;
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Log error for debugging
                    System.Diagnostics.Debug.WriteLine("LoadOutpatients Error: " + ex.Message);
                    noData.Visible = true;
                }
            }
        }

        [WebMethod]
        public static string GetPatientCharges(int patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            List<object> charges = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT charge_id, charge_type, charge_name, amount, is_paid, 
                           payment_method, date_added, paid_date
                    FROM patient_charges
                    WHERE patientid = @patientId
                    ORDER BY date_added DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    charges.Add(new
                    {
                        charge_id = reader["charge_id"],
                        charge_type = reader["charge_type"].ToString(),
                        charge_name = reader["charge_name"].ToString(),
                        amount = reader["amount"],
                        is_paid = reader["is_paid"],
                        payment_method = reader["payment_method"] != DBNull.Value ? reader["payment_method"].ToString() : "",
                        date_added = reader["date_added"],
                        paid_date = reader["paid_date"] != DBNull.Value ? reader["paid_date"] : null
                    });
                }
            }

            return JsonConvert.SerializeObject(charges);
        }

        [WebMethod]
        public static string GetPatientMedications(int patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            List<object> medications = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT m.medid, m.med_name, m.dosage, m.frequency, m.duration, 
                           m.special_inst, m.date_taken
                    FROM medication m
                    INNER JOIN prescribtion pr ON m.prescid = pr.prescid
                    WHERE pr.patientid = @patientId
                    ORDER BY m.date_taken DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    medications.Add(new
                    {
                        medid = reader["medid"],
                        med_name = reader["med_name"].ToString(),
                        dosage = reader["dosage"].ToString(),
                        frequency = reader["frequency"].ToString(),
                        duration = reader["duration"].ToString(),
                        special_inst = reader["special_inst"] != DBNull.Value ? reader["special_inst"].ToString() : "",
                        date_taken = reader["date_taken"] != DBNull.Value ? reader["date_taken"] : null
                    });
                }
            }

            return JsonConvert.SerializeObject(medications);
        }

        [WebMethod]
        public static string GetPatientLabTests(int patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            List<object> labTests = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT 
                        lt.med_id,
                        pr.prescid, 
                        pr.status, 
                        pr.patientid,
                        lt.date_taken as ordered_date,
                        lr.date_taken as result_date
                    FROM prescribtion pr
                    INNER JOIN lab_test lt ON pr.prescid = lt.prescid
                    LEFT JOIN lab_results lr ON pr.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                    WHERE pr.patientid = @patientId AND pr.status >= 4
                    ORDER BY lt.date_taken DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    int medId = Convert.ToInt32(reader["med_id"]);
                    
                    // Get test names for this order
                    string testNames = GetTestNamesForOrder(cs, medId);
                    
                    labTests.Add(new
                    {
                        prescid = reader["prescid"],
                        status = reader["status"],
                        test_names = !string.IsNullOrEmpty(testNames) ? testNames : "Lab Tests Ordered",
                        ordered_date = reader["ordered_date"] != DBNull.Value ? reader["ordered_date"] : null,
                        result_date = reader["result_date"] != DBNull.Value ? reader["result_date"] : null
                    });
                }
            }

            return JsonConvert.SerializeObject(labTests);
        }

        private static string GetTestNamesForOrder(string connectionString, int medId)
        {
            List<string> testNames = new List<string>();
            
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM lab_test WHERE med_id = @medId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@medId", medId);
                
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                
                if (reader.Read())
                {
                    // Loop through all columns dynamically
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        string columnName = reader.GetName(i);
                        
                        // Skip system columns
                        if (columnName.Equals("med_id", StringComparison.OrdinalIgnoreCase) ||
                            columnName.Equals("prescid", StringComparison.OrdinalIgnoreCase) ||
                            columnName.Equals("date_taken", StringComparison.OrdinalIgnoreCase) ||
                            columnName.Equals("is_reorder", StringComparison.OrdinalIgnoreCase) ||
                            columnName.Equals("reorder_reason", StringComparison.OrdinalIgnoreCase) ||
                            columnName.Equals("original_order_id", StringComparison.OrdinalIgnoreCase))
                            continue;
                        
                        // Check if column has a value
                        if (reader[columnName] != DBNull.Value)
                        {
                            string value = reader[columnName].ToString().Trim();
                            
                            // Include test if it's not "not checked" and not empty
                            if (!string.IsNullOrEmpty(value) && 
                                !value.Equals("not checked", StringComparison.OrdinalIgnoreCase))
                            {
                                // The value IS the test name (e.g., "Typhoid IgG", "Electrolyte Test")
                                testNames.Add(value);
                            }
                        }
                    }
                }
                
                reader.Close();
            }
            
            return string.Join(", ", testNames);
        }

        [WebMethod]
        public static int GetPatientPrescriptionId(int patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT TOP 1 prescid FROM prescribtion WHERE patientid = @patientId ORDER BY prescid DESC";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        [WebMethod]
        public static string GetPatientXrays(int patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            List<object> xrays = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT pr.prescid, pr.xray_status, x.xray_name,
                           xr.xray_result_id, xr.result_date as completed_date,
                           (SELECT TOP 1 date_added FROM patient_charges 
                            WHERE patientid = pr.patientid AND prescid = pr.prescid 
                            AND charge_type = 'Xray') as ordered_date
                    FROM prescribtion pr
                    INNER JOIN presxray px ON pr.prescid = px.prescid
                    LEFT JOIN xray x ON px.xrayid = x.xrayid
                    LEFT JOIN xray_results xr ON pr.prescid = xr.prescid
                    WHERE pr.patientid = @patientId AND pr.xray_status > 0
                    ORDER BY pr.prescid DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    xrays.Add(new
                    {
                        prescid = reader["prescid"],
                        xray_status = reader["xray_status"],
                        xray_name = reader["xray_name"] != DBNull.Value ? reader["xray_name"].ToString() : "X-ray",
                        xray_result_id = reader["xray_result_id"] != DBNull.Value ? reader["xray_result_id"] : 0,
                        ordered_date = reader["ordered_date"] != DBNull.Value ? reader["ordered_date"] : null,
                        completed_date = reader["completed_date"] != DBNull.Value ? reader["completed_date"] : null
                    });
                }
            }

            return JsonConvert.SerializeObject(xrays);
        }

        // Helper method for status badge colors
        protected string GetStatusClass(object status)
        {
            if (status == null || status == DBNull.Value)
                return "secondary";

            string statusStr = status.ToString().ToLower();

            switch (statusStr)
            {
                case "completed":
                    return "success";
                case "waiting":
                    return "warning";
                case "in consultation":
                    return "info";
                case "lab tests ordered":
                    return "primary";
                default:
                    return "secondary";
            }
        }

        // Helper method for lab status badge colors
        protected string GetLabStatusClass(object labStatus)
        {
            if (labStatus == null || labStatus == DBNull.Value)
                return "secondary";

            string statusStr = labStatus.ToString().ToLower();

            switch (statusStr)
            {
                case "completed":
                    return "success";
                case "in progress":
                    return "info";
                case "ordered":
                    return "warning";
                case "none":
                    return "secondary";
                default:
                    return "secondary";
            }
        }
    }
}
