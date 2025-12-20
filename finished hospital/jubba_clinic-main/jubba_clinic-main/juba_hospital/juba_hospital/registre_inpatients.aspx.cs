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
    public partial class registre_inpatients : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadInpatients();
            }
        }

        private void LoadInpatients()
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
                        p.bed_admission_date,
                        p.date_registered,
                        ISNULL(DATEDIFF(DAY, p.bed_admission_date, GETDATE()), 0) as days_admitted,
                        pr.prescid,
                        ISNULL(SUM(pc.amount), 0) as total_charges,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
                    FROM patient p
                    LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
                    LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
                    WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
                          AND p.patient_status = 1
                    GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, 
                             p.bed_admission_date, p.date_registered, pr.prescid
                    ORDER BY ISNULL(p.bed_admission_date, p.date_registered) DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                
                try
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    
                    if (reader.HasRows)
                    {
                        // DEBUG: Check what data is being read
                        var dataList = new List<object>();
                        while (reader.Read())
                        {
                            var patientid = reader["patientid"];
                            var prescid = reader["prescid"];
                            System.Diagnostics.Debug.WriteLine($"DEBUG - PatientID: {patientid}, PrescID: {prescid}");
                            
                            dataList.Add(new
                            {
                                patientid = patientid,
                                full_name = reader["full_name"],
                                dob = reader["dob"],
                                sex = reader["sex"],
                                phone = reader["phone"],
                                location = reader["location"],
                                bed_admission_date = reader["bed_admission_date"],
                                date_registered = reader["date_registered"],
                                days_admitted = reader["days_admitted"],
                                prescid = prescid,
                                total_charges = reader["total_charges"],
                                paid_amount = reader["paid_amount"],
                                unpaid_amount = reader["unpaid_amount"]
                            });
                        }
                        
                        reader.Close();
                        
                        rptInpatients.DataSource = dataList;
                        rptInpatients.DataBind();
                        noData.Visible = false;
                    }
                    else
                    {
                        noData.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    // Log error for debugging
                    System.Diagnostics.Debug.WriteLine("LoadInpatients Error: " + ex.Message);
                    System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
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
                // Get all LAB ORDERS (each med_id is a separate order)
                string query = @"
                    SELECT 
                        lt.med_id as order_id,
                        lt.prescid,
                        pr.status,
                        lt.date_taken as ordered_date,
                        CASE WHEN lr.lab_result_id IS NOT NULL THEN 'Completed' ELSE 'Pending' END as order_status,
                        lt.*, lr.*
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                    WHERE pr.patientid = @patientId AND pr.status >= 4
                    ORDER BY lt.date_taken DESC, lt.med_id DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@patientId", patientId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    // Get all test columns
                    var orderedTests = new List<string>();
                    var testResults = new System.Collections.Generic.Dictionary<string, string>();

                    // Exclude these columns
                    var excludedColumns = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase) 
                    { "med_id", "prescid", "date_taken", "type", "is_reorder", "reorder_reason", "lab_result_id", "lab_test_id", "order_id", "status", "ordered_date", "order_status" };

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        string columnName = reader.GetName(i);
                        if (excludedColumns.Contains(columnName))
                            continue;

                        var orderValue = reader[columnName];
                        if (orderValue != DBNull.Value)
                        {
                            string orderValueStr = orderValue.ToString().Trim();
                            if (!string.IsNullOrEmpty(orderValueStr) && 
                                !orderValueStr.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                !orderValueStr.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                                !orderValueStr.Equals("false", StringComparison.OrdinalIgnoreCase))
                            {
                                string testLabel = columnName.Replace("_", " ");
                                orderedTests.Add(testLabel);
                                
                                // Check if it's a result (non-"1" values are results)
                                if (orderValueStr != "1" && orderValueStr.ToLower() != "true")
                                {
                                    testResults[testLabel] = orderValueStr;
                                }
                            }
                        }
                    }

                    labTests.Add(new
                    {
                        order_id = reader["order_id"],
                        prescid = reader["prescid"],
                        status = reader["order_status"].ToString(),
                        ordered_date = reader["ordered_date"] != DBNull.Value ? reader["ordered_date"] : null,
                        ordered_tests = orderedTests,
                        test_results = testResults
                    });
                }
            }

            return JsonConvert.SerializeObject(labTests);
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
                case "admitted":
                case "stable":
                    return "success";
                case "critical":
                case "ready for discharge":
                    return "warning";
                case "discharged":
                    return "info";
                default:
                    return "secondary";
            }
        }
    }
}
