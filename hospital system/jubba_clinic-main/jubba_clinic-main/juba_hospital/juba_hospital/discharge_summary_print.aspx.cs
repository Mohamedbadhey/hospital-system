using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class discharge_summary_print : System.Web.UI.Page
    {
        protected Literal PrintHeaderLiteral;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add hospital print header
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
            }
        }

        [WebMethod]
        public static string GetPrintHeader()
        {
            return HospitalSettingsHelper.GetPrintHeaderHTML();
        }

        [WebMethod]
        public static DischargeSummaryData GetDischargeSummary(string patientId, string prescid)
        {
            DateTime eatNow = DateTimeHelper.Now;

            try
            {
                System.Diagnostics.Debug.WriteLine("=== GetDischargeSummary Called ===");
                System.Diagnostics.Debug.WriteLine($"PatientId: {patientId}");
                System.Diagnostics.Debug.WriteLine($"PrescId: {prescid}");

                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                System.Diagnostics.Debug.WriteLine($"Connection String: {cs}");

                DischargeSummaryData data = new DischargeSummaryData();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    System.Diagnostics.Debug.WriteLine("Opening connection...");
                    con.Open();
                    System.Diagnostics.Debug.WriteLine("Connection opened successfully");

                // Get patient and admission details
                string patientQuery = @"
                    SELECT 
                        p.patientid,
                        p.full_name,
                        p.dob,
                        p.sex,
                        p.phone,
                        p.location,
                        p.bed_admission_date,
                        @EatNow AS bed_discharge_date,
        CASE
            WHEN p.bed_admission_date IS NULL THEN 0
            WHEN CAST(@EatNow AS DATE) < CAST(p.bed_admission_date AS DATE) THEN 1
            ELSE DATEDIFF(
                    DAY,
                    CAST(p.bed_admission_date AS DATE),
                    CAST(@EatNow AS DATE)
                 ) + 1
        END AS days_admitted,
                        ISNULL(d.doctorname, 'Unknown Doctor') as doctor_name,
                        ISNULL(d.doctortitle, '') as doctortitle
                    FROM patient p
                    INNER JOIN prescribtion pr ON p.patientid = pr.patientid
                    LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                    WHERE p.patientid = @patientId AND pr.prescid = @prescid";

                using (SqlCommand cmd = new SqlCommand(patientQuery, con))
                {
                    System.Diagnostics.Debug.WriteLine("Executing patient query...");
                    cmd.Parameters.AddWithValue("@patientId", patientId);
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                        cmd.Parameters.Add("@EatNow", SqlDbType.DateTime).Value = eatNow;
                        using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        System.Diagnostics.Debug.WriteLine("Patient query executed");
                        if (dr.Read())
                        {
                            System.Diagnostics.Debug.WriteLine("Patient data found");
                            data.patientId = dr["patientid"].ToString();
                            data.patientName = dr["full_name"] != DBNull.Value ? dr["full_name"].ToString() : "Unknown";
                            data.dob = dr["dob"] != DBNull.Value ? Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd") : "N/A";
                            data.sex = dr["sex"] != DBNull.Value ? dr["sex"].ToString() : "N/A";
                            data.phone = dr["phone"] != DBNull.Value ? dr["phone"].ToString() : "N/A";
                            data.location = dr["location"] != DBNull.Value ? dr["location"].ToString() : "N/A";
                            data.admissionDate = dr["bed_admission_date"] != DBNull.Value ? Convert.ToDateTime(dr["bed_admission_date"]).ToString("yyyy-MM-dd HH:mm") : DateTimeHelper.Now.ToString("yyyy-MM-dd HH:mm");
                            data.dischargeDate = dr["bed_discharge_date"] != DBNull.Value ? Convert.ToDateTime(dr["bed_discharge_date"]).ToString("yyyy-MM-dd HH:mm") : DateTimeHelper.Now.ToString("yyyy-MM-dd HH:mm");
                            data.lengthOfStay = dr["days_admitted"] != DBNull.Value ? dr["days_admitted"].ToString() : "0";
                            
                            string doctorTitle = dr["doctortitle"] != DBNull.Value ? dr["doctortitle"].ToString() : "";
                            string doctorName = dr["doctor_name"] != DBNull.Value ? dr["doctor_name"].ToString() : "Unknown Doctor";
                            data.doctorName = string.IsNullOrWhiteSpace(doctorTitle) ? doctorName : doctorTitle + " " + doctorName;
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine("WARNING: No patient data found for given patientId and prescid");
                            // If no data found, set default values
                            data.patientId = patientId;
                            data.patientName = "Unknown Patient";
                            data.dob = "N/A";
                            data.sex = "N/A";
                            data.phone = "N/A";
                            data.location = "N/A";
                            data.admissionDate = DateTimeHelper.Now.ToString("yyyy-MM-dd HH:mm");
                            data.dischargeDate = DateTimeHelper.Now.ToString("yyyy-MM-dd HH:mm");
                            data.lengthOfStay = "0";
                            data.doctorName = "Unknown Doctor";
                        }
                    }
                }

                // Get hospital settings
                try
                {
                    var settings = HospitalSettingsHelper.GetHospitalSettings();
                    data.hospitalName = settings.HospitalName;
                    data.hospitalAddress = settings.HospitalAddress;
                    data.hospitalPhone = settings.HospitalPhone;
                }
                catch
                {
                    data.hospitalName = "Jubba Hospital";
                    data.hospitalAddress = "Kismayo, Somalia";
                    data.hospitalPhone = "+252-XXX-XXXX";
                }

                // Get medications
                data.medications = new List<MedicationItem>();
                System.Diagnostics.Debug.WriteLine("Fetching medications...");
                string medQuery = "SELECT med_name, dosage, frequency, duration, special_inst FROM medication WHERE prescid = @prescid";
                using (SqlCommand cmd = new SqlCommand(medQuery, con))
                {
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        int medCount = 0;
                        while (dr.Read())
                        {
                            medCount++;
                            data.medications.Add(new MedicationItem
                            {
                                med_name = dr["med_name"].ToString(),
                                dosage = dr["dosage"].ToString(),
                                frequency = dr["frequency"].ToString(),
                                duration = dr["duration"].ToString(),
                                special_inst = dr["special_inst"].ToString()
                            });
                        }
                        System.Diagnostics.Debug.WriteLine($"Found {medCount} medications");
                    }
                }

                // Get lab results
                System.Diagnostics.Debug.WriteLine("Fetching lab results...");
                data.labResults = new List<LabResultItem>();
                string labQuery = @"
                    SELECT TestName, TestValue
                    FROM (
                        SELECT 
                            lab_result_id,
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Urea, Creatinine
                        FROM lab_results
                        WHERE prescid = @prescid
                    ) src
                    UNPIVOT (
                        TestValue FOR TestName IN (
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Urea, Creatinine
                        )
                    ) unpvt
                    WHERE TestValue IS NOT NULL AND TestValue != ''";
                
                try
                {
                    using (SqlCommand cmd = new SqlCommand(labQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            int labCount = 0;
                            while (dr.Read())
                            {
                                labCount++;
                                data.labResults.Add(new LabResultItem
                            {
                                TestName = dr["TestName"].ToString().Replace("_", " "),
                                TestValue = dr["TestValue"].ToString()
                            });
                        }
                        System.Diagnostics.Debug.WriteLine($"Found {labCount} lab results");
                    }
                }
                }
                catch (Exception labEx)
                {
                    System.Diagnostics.Debug.WriteLine($"Error fetching lab results: {labEx.Message}");
                    // Continue without lab results
                }

                // Get charges
                System.Diagnostics.Debug.WriteLine("Fetching charges...");
                data.charges = new List<ChargeItem>();
                string chargeQuery = @"
                    SELECT charge_type, charge_name, amount, is_paid
                    FROM patient_charges
                    WHERE patientid = @patientId
                    ORDER BY date_added";
                
                using (SqlCommand cmd = new SqlCommand(chargeQuery, con))
                {
                    cmd.Parameters.AddWithValue("@patientId", patientId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        int chargeCount = 0;
                        while (dr.Read())
                        {
                            chargeCount++;
                            data.charges.Add(new ChargeItem
                            {
                                charge_type = dr["charge_type"].ToString(),
                                charge_name = dr["charge_name"].ToString(),
                                amount = dr["amount"].ToString(),
                                is_paid = dr["is_paid"].ToString()
                            });
                        }
                        System.Diagnostics.Debug.WriteLine($"Found {chargeCount} charges");
                    }
                }
                
                // Get Lab Tests - ALL ORDERS with individual results
                System.Diagnostics.Debug.WriteLine("Fetching lab tests...");
                data.labTests = GetLabTestsForPatient(con, patientId);
                System.Diagnostics.Debug.WriteLine($"Found {data.labTests.Count} lab orders");
            }

            System.Diagnostics.Debug.WriteLine("=== GetDischargeSummary Completed Successfully ===");
            return data;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("=== FATAL ERROR in GetDischargeSummary ===");
                System.Diagnostics.Debug.WriteLine($"Error Type: {ex.GetType().Name}");
                System.Diagnostics.Debug.WriteLine($"Error Message: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                
                if (ex.InnerException != null)
                {
                    System.Diagnostics.Debug.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                }
                
                // Re-throw to let client see the error
                throw new Exception($"Error loading discharge summary: {ex.Message}. Check VS Output window for details.", ex);
            }
        }

        private static List<LabOrderData> GetLabTestsForPatient(SqlConnection con, string patientId)
            {
                List<LabOrderData> labOrders = new List<LabOrderData>();

                // Get all LAB ORDERS (each med_id is a separate order)
                string query = @"
                    SELECT 
                        lt.med_id as order_id,
                        lt.prescid,
                        pr.status,
                        lt.date_taken as ordered_date,
                        CASE WHEN lr.lab_result_id IS NOT NULL THEN 'Completed' ELSE 'Pending' END as order_status,
                        lr.lab_result_id
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                    WHERE pr.patientid = @patientId AND pr.status >= 4
                    ORDER BY lt.date_taken DESC, lt.med_id DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@patientId", patientId);
                    
                    // Use DataAdapter to load all data at once (avoids nested reader issues)
                    System.Data.DataTable dt = new System.Data.DataTable();
                    using (System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }

                    // Now process each row
                    foreach (System.Data.DataRow row in dt.Rows)
                    {
                        LabOrderData order = new LabOrderData
                        {
                            order_id = row["order_id"].ToString(),
                            prescid = row["prescid"].ToString(),
                            order_status = row["order_status"].ToString(),
                            ordered_date = row["ordered_date"] != DBNull.Value ? 
                                Convert.ToDateTime(row["ordered_date"]).ToString("MMMM dd, yyyy hh:mm tt") : "",
                            ordered_tests = new List<string>(),
                            test_results = new Dictionary<string, string>()
                        };

                        // Get ordered tests from lab_test table
                        order.ordered_tests = GetOrderedTests(con, order.prescid, order.order_id);

                        // Get results from lab_results table (only if completed)
                        if (order.order_status == "Completed")
                        {
                            order.test_results = GetLabResults(con, order.order_id);
                        }

                        if (order.ordered_tests.Count > 0)
                        {
                            labOrders.Add(order);
                        }
                    }
                }

                return labOrders;
            }

            private static List<string> GetOrderedTests(SqlConnection con, string prescId, string orderId)
            {
                var tests = new List<string>();

                string query = @"
                    SELECT *
                    FROM lab_test
                    WHERE prescid = @prescid AND med_id = @orderid";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@prescid", prescId);
                    cmd.Parameters.AddWithValue("@orderid", orderId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Loop through all columns to find ordered tests
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                string columnName = reader.GetName(i);

                                // Skip system columns
                                if (columnName.Equals("med_id", StringComparison.OrdinalIgnoreCase) ||
                                    columnName.Equals("prescid", StringComparison.OrdinalIgnoreCase) ||
                                    columnName.Equals("date_taken", StringComparison.OrdinalIgnoreCase) ||
                                    columnName.Equals("type", StringComparison.OrdinalIgnoreCase) ||
                                    columnName.Equals("is_reorder", StringComparison.OrdinalIgnoreCase) ||
                                    columnName.Equals("reorder_reason", StringComparison.OrdinalIgnoreCase))
                                    continue;

                                if (reader[columnName] != DBNull.Value)
                                {
                                    string value = reader[columnName].ToString().Trim();

                                    // Check if test is ordered
                                    // lab_test stores: "on", "1", "true", "checked", OR the test name itself
                                    // "not checked" = not ordered
                                    if (!string.IsNullOrEmpty(value) &&
                                        !value.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                        !value.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                                        !value.Equals("false", StringComparison.OrdinalIgnoreCase))
                                    {
                                        // Format column name to readable test name
                                        string testName = columnName.Replace("_", " ");
                                        tests.Add(testName);
                                    }
                                }
                            }
                        }
                    }
                }

                return tests;
            }

            private static Dictionary<string, string> GetLabResults(SqlConnection con, string orderId)
            {
                var results = new Dictionary<string, string>();

                // Query lab_results by lab_test_id (the order ID)
                string query = @"
                    SELECT *
                    FROM lab_results
                    WHERE lab_test_id = @orderid";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@orderid", orderId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Exclude system columns AND category columns
                            var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                            {
                                "lab_result_id", "prescid", "date_taken", "date_added", "last_updated", "lab_test_id",
                                // Category columns (contain headings, not actual results)
                                "Biochemistry", "Lipid_profile", "Liver_function_test", "Renal_profile", 
                                "Electrolytes", "Pancreases", "Hematology", "Immunology", "Serology",
                                "Microbiology", "Parasitology", "Hormone_test", "Tumor_markers"
                            };

                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                string columnName = reader.GetName(i);
                                if (excludedColumns.Contains(columnName))
                                    continue;

                                object value = reader.GetValue(i);
                                if (value == null || value == DBNull.Value)
                                    continue;

                                string stringValue = value.ToString().Trim();
                                
                                // Skip invalid/placeholder values
                                if (string.IsNullOrWhiteSpace(stringValue) || 
                                    stringValue.Equals("not checked", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("on", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("checked", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("1", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("true", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("0", StringComparison.OrdinalIgnoreCase) ||
                                    stringValue.Equals("false", StringComparison.OrdinalIgnoreCase))
                                    continue;

                                // Skip if the value is exactly the test name/label (not an actual result)
                                // Only skip if it's an exact match or very close match, not just contains
                                string testName = columnName.Replace("_", " ");
                                string testNameNormalized = testName.ToLower().Replace(" ", "");
                                string valueNormalized = stringValue.ToLower().Replace(" ", "").Replace("-", "").Replace("(", "").Replace(")", "").Replace(",", "");
                                
                                // Only skip if the value is essentially the same as the column name
                                // But allow actual test result values that might contain test keywords
                                if (testNameNormalized == valueNormalized || 
                                    (valueNormalized.Length > 10 && testNameNormalized.Contains(valueNormalized) && valueNormalized.Contains(testNameNormalized)))
                                    continue;

                                // Only add if it looks like a real result value
                                results[testName] = stringValue;
                            }
                        }
                    }
                }

                return results;
            }

        public class LabOrderData
        {
            public string order_id { get; set; }
            public string prescid { get; set; }
            public string order_status { get; set; }
            public string ordered_date { get; set; }
            public List<string> ordered_tests { get; set; }
            public Dictionary<string, string> test_results { get; set; }
        }

        public class DischargeSummaryData
        {
            public string patientId { get; set; }
            public string patientName { get; set; }
            public string dob { get; set; }
            public string sex { get; set; }
            public string phone { get; set; }
            public string location { get; set; }
            public string admissionDate { get; set; }
            public string dischargeDate { get; set; }
            public string lengthOfStay { get; set; }
            public string doctorName { get; set; }
            public string hospitalName { get; set; }
            public string hospitalAddress { get; set; }
            public string hospitalPhone { get; set; }
            public List<MedicationItem> medications { get; set; }
            public List<LabResultItem> labResults { get; set; }
            public List<ChargeItem> charges { get; set; }
            public List<LabOrderData> labTests { get; set; }
        }

        public class MedicationItem
        {
            public string med_name { get; set; }
            public string dosage { get; set; }
            public string frequency { get; set; }
            public string duration { get; set; }
            public string special_inst { get; set; }
        }

        public class LabResultItem
        {
            public string TestName { get; set; }
            public string TestValue { get; set; }
        }

        public class ChargeItem
        {
            public string charge_type { get; set; }
            public string charge_name { get; set; }
            public string amount { get; set; }
            public string is_paid { get; set; }
        }
    }
}
