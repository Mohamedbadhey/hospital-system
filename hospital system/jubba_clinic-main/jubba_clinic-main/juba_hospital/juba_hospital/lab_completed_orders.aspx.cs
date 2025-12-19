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
    public partial class lab_completed_orders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ptclass[] GetCompletedOrders()
        {
            List<ptclass> details = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                // Get only completed lab orders (those that have results) - one row per order
                SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    lt.med_id as order_id,
                    patient.full_name, 
                    patient.sex,
                    patient.location,
                    patient.phone,
                    patient.date_registered,
                    doctor.doctortitle,
                    patient.patientid,
                    lt.prescid,
                    doctor.doctorid,
                    patient.amount,
                    CONVERT(date, patient.dob) AS dob,
                    lt.date_taken as order_date,
                    ISNULL(lt.is_reorder, 0) as is_reorder,
                    lt.reorder_reason,
                    lr.lab_result_id,
                    lr.date_taken as result_date,
                    CASE 
                        WHEN EXISTS (
                            SELECT 1 FROM patient_charges pc 
                            WHERE (pc.reference_id = lt.med_id OR pc.prescid = lt.prescid) 
                            AND pc.charge_type = 'Lab' AND pc.is_paid = 1
                        ) THEN 1
                        WHEN prescribtion.lab_charge_paid = 1 THEN 1
                        ELSE 0
                    END as charge_paid
                FROM 
                    lab_test lt
                INNER JOIN 
                    prescribtion ON lt.prescid = prescribtion.prescid
                INNER JOIN
                    patient ON prescribtion.patientid = patient.patientid
                INNER JOIN 
                    doctor ON prescribtion.doctorid = doctor.doctorid
                INNER JOIN 
                    lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                WHERE 
                    prescribtion.status IN (4, 5)
                    AND lr.lab_result_id IS NOT NULL
                ORDER BY 
                    lr.date_taken DESC,
                    lt.is_reorder DESC,
                    lt.date_taken DESC;
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
                        field.prescid = dr["prescid"].ToString();
                        field.amount = dr["amount"].ToString();
                        field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        field.status = "Completed";
                        field.lab_result_id = dr["lab_result_id"]?.ToString() ?? "";
                        field.is_reorder = dr["is_reorder"].ToString();
                        field.reorder_reason = dr["reorder_reason"]?.ToString() ?? "";
                        field.last_order_date = dr["result_date"] != DBNull.Value ? Convert.ToDateTime(dr["result_date"]).ToString("yyyy-MM-dd HH:mm") : "";
                        field.lab_charge_paid = dr["charge_paid"].ToString();
                        field.unpaid_lab_charges = "0";
                        field.order_id = dr["order_id"].ToString();
                        
                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        [WebMethod]
        public static OrderedTest[] GetOrderedTests(string prescid, string orderId)
        {
            List<OrderedTest> tests = new List<OrderedTest>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        lt.*,
                        p.full_name as patient_name,
                        lt.date_taken as order_date
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    WHERE lt.prescid = @prescid AND lt.med_id = @orderId", con);
                
                cmd.Parameters.AddWithValue("@prescid", prescid);
                cmd.Parameters.AddWithValue("@orderId", orderId);

                string patientName = "";
                string orderDate = "";

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        patientName = dr["patient_name"].ToString();
                        orderDate = dr["order_date"] != DBNull.Value ? 
                            Convert.ToDateTime(dr["order_date"]).ToString("dd MMM yyyy HH:mm") : "";

                        // Exclude these columns from test list
                        var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                        {
                            "med_id", "prescid", "date_taken", "is_reorder", "reorder_reason", 
                            "original_order_id", "patient_name", "order_date"
                        };

                        // Go through all columns and find which tests are checked
                        for (int i = 0; i < dr.FieldCount; i++)
                        {
                            string columnName = dr.GetName(i);
                            if (excludedColumns.Contains(columnName))
                                continue;

                            object value = dr.GetValue(i);
                            if (value == null || value == DBNull.Value)
                                continue;

                            string stringValue = value.ToString().Trim();
                            // If the test is checked, add it to the list
                            if (!string.IsNullOrWhiteSpace(stringValue) && 
                                !string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                            {
                                tests.Add(new OrderedTest
                                {
                                    TestName = FormatLabel(columnName),
                                    PatientName = patientName,
                                    OrderDate = orderDate
                                });
                            }
                        }
                    }
                }
            }

            return tests.ToArray();
        }

        [WebMethod]
        public static TestResultData GetTestResults(string prescid, string orderId)
        {
            TestResultData resultData = new TestResultData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                
                // Get patient and order info
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        p.full_name,
                        p.patientid,
                        lt.date_taken as order_date,
                        d.doctortitle
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                    WHERE lt.prescid = @prescid AND lt.med_id = @orderId", con);
                
                cmd.Parameters.AddWithValue("@prescid", prescid);
                cmd.Parameters.AddWithValue("@orderId", orderId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        resultData.PatientName = dr["full_name"].ToString();
                        resultData.PatientId = dr["patientid"].ToString();
                        resultData.OrderDate = dr["order_date"] != DBNull.Value ? 
                            Convert.ToDateTime(dr["order_date"]).ToString("dd MMM yyyy HH:mm") : "";
                        resultData.Doctor = dr["doctortitle"]?.ToString();
                    }
                }

                // Get results
                cmd = new SqlCommand(@"
                    SELECT *
                    FROM lab_results
                    WHERE prescid = @prescid
                    ORDER BY date_taken DESC", con);
                
                cmd.Parameters.AddWithValue("@prescid", prescid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                        {
                            "lab_result_id", "prescid", "date_taken", "date_added", "last_updated", "lab_test_id"
                        };

                        for (int i = 0; i < dr.FieldCount; i++)
                        {
                            string columnName = dr.GetName(i);
                            if (excludedColumns.Contains(columnName))
                                continue;

                            object value = dr.GetValue(i);
                            if (value == null || value == DBNull.Value)
                                continue;

                            string stringValue = value.ToString();
                            if (string.IsNullOrWhiteSpace(stringValue) || 
                                string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                                continue;

                            resultData.Results.Add(new TestResult
                            {
                                Parameter = FormatLabel(columnName),
                                Value = stringValue
                            });
                        }
                    }
                }
            }

            return resultData;
        }

        [WebMethod]
        public static PatientHistoryData GetPatientLabHistory(string patientId)
        {
            PatientHistoryData historyData = new PatientHistoryData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get all lab orders for patient
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        lt.med_id as order_id,
                        lt.prescid,
                        lt.date_taken as order_date,
                        CASE WHEN lr.lab_result_id IS NOT NULL THEN 1 ELSE 0 END as is_completed,
                        d.doctortitle
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                    LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                    WHERE p.patientid = @patientid
                    ORDER BY lt.date_taken DESC", con);
                
                cmd.Parameters.AddWithValue("@patientid", patientId);

                List<LabOrderInfo> ordersList = new List<LabOrderInfo>();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        LabOrderInfo order = new LabOrderInfo
                        {
                            OrderId = dr["order_id"].ToString(),
                            PrescId = dr["prescid"].ToString(),
                            OrderDate = dr["order_date"] != DBNull.Value ? 
                                Convert.ToDateTime(dr["order_date"]).ToString("dd MMM yyyy HH:mm") : "",
                            IsCompleted = Convert.ToInt32(dr["is_completed"]) == 1,
                            Doctor = dr["doctortitle"]?.ToString(),
                            Tests = new List<string>(),
                            Results = new List<TestResult>()
                        };

                        ordersList.Add(order);
                    }
                }

                // For each order, get ordered tests and results separately
                foreach (var order in ordersList)
                {
                    // Get ordered tests from lab_test table
                    order.Tests = GetOrderedTestsForHistory(con, order.PrescId, order.OrderId);

                    // Get results from lab_results table (only if completed)
                    if (order.IsCompleted)
                    {
                        order.Results = GetLabResultsForHistory(con, order.OrderId);
                    }
                }

                historyData.Orders = ordersList;
                historyData.TotalOrders = historyData.Orders.Count;
                historyData.CompletedOrders = historyData.Orders.Count(o => o.IsCompleted);
                historyData.PendingOrders = historyData.Orders.Count(o => !o.IsCompleted);
            }

            return historyData;
        }

        private static List<string> GetOrderedTestsForHistory(SqlConnection con, string prescId, string orderId)
        {
            var tests = new List<string>();

            SqlCommand cmd = new SqlCommand("SELECT * FROM lab_test WHERE prescid = @prescid AND med_id = @orderid", con);
            cmd.Parameters.AddWithValue("@prescid", prescId);
            cmd.Parameters.AddWithValue("@orderid", orderId);

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                    {
                        "med_id", "prescid", "date_taken", "type", "is_reorder", "reorder_reason", "original_order_id"
                    };

                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        string columnName = dr.GetName(i);
                        if (excludedColumns.Contains(columnName))
                            continue;

                        object value = dr.GetValue(i);
                        if (value == null || value == DBNull.Value)
                            continue;

                        string stringValue = value.ToString().Trim();

                        // Check if test is ordered
                        // lab_test stores: "on", "1", "true", "checked", OR the test name itself
                        // "not checked" = not ordered
                        if (!string.IsNullOrEmpty(stringValue) &&
                            !stringValue.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                            !stringValue.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                            !stringValue.Equals("false", StringComparison.OrdinalIgnoreCase))
                        {
                            tests.Add(FormatLabel(columnName));
                        }
                    }
                }
            }

            return tests;
        }

        private static List<TestResult> GetLabResultsForHistory(SqlConnection con, string orderId)
        {
            var results = new List<TestResult>();

            SqlCommand cmd = new SqlCommand("SELECT * FROM lab_results WHERE lab_test_id = @orderid", con);
            cmd.Parameters.AddWithValue("@orderid", orderId);

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                if (dr.Read())
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

                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        string columnName = dr.GetName(i);
                        if (excludedColumns.Contains(columnName))
                            continue;

                        object value = dr.GetValue(i);
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
                        results.Add(new TestResult
                        {
                            Parameter = FormatLabel(columnName),
                            Value = stringValue
                        });
                    }
                }
            }

            return results;
        }

        [WebMethod]
        public static EditResultData GetResultsForEdit(string prescid, string labResultId)
        {
            EditResultData editData = new EditResultData();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get patient info - labResultId is actually order_id (med_id/lab_test_id)
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        p.full_name,
                        lr.date_taken,
                        lt.prescid
                    FROM lab_results lr
                    INNER JOIN lab_test lt ON lr.lab_test_id = lt.med_id
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    WHERE lr.lab_test_id = @labTestId", con);

                cmd.Parameters.AddWithValue("@labTestId", labResultId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        editData.PatientName = dr["full_name"].ToString();
                        editData.TestDate = dr["date_taken"] != DBNull.Value ?
                            Convert.ToDateTime(dr["date_taken"]).ToString("dd MMM yyyy HH:mm") : "";
                        editData.LabResultId = labResultId; // This is actually order_id
                        editData.PrescId = dr["prescid"].ToString();
                    }
                }

                // Get ordered tests from lab_test table
                cmd = new SqlCommand(@"
                    SELECT *
                    FROM lab_test
                    WHERE med_id = @labTestId", con);

                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@labTestId", labResultId);

                List<string> orderedTests = new List<string>();
                var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                {
                    "med_id", "prescid", "date_taken", "is_reorder", "reorder_reason", "original_order_id"
                };

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        for (int i = 0; i < dr.FieldCount; i++)
                        {
                            string columnName = dr.GetName(i);
                            if (excludedColumns.Contains(columnName))
                                continue;

                            object value = dr.GetValue(i);
                            if (value == null || value == DBNull.Value)
                                continue;

                            string stringValue = value.ToString().Trim();
                            // Check if test was ordered (value is "checked" or any non-empty value)
                            if (!string.IsNullOrWhiteSpace(stringValue) && 
                                !string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                            {
                                orderedTests.Add(columnName);
                                editData.OrderedTests.Add(FormatLabel(columnName)); // Add formatted name for display
                            }
                        }
                    }
                }

                // Get results - only for ordered tests
                cmd = new SqlCommand(@"
                    SELECT *
                    FROM lab_results
                    WHERE lab_test_id = @labTestId", con);

                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@labTestId", labResultId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        var excludedResultColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                        {
                            "lab_result_id", "prescid", "date_taken", "date_added", "last_updated", "lab_test_id"
                        };

                        for (int i = 0; i < dr.FieldCount; i++)
                        {
                            string columnName = dr.GetName(i);
                            if (excludedResultColumns.Contains(columnName))
                                continue;

                            // Only include fields that were in the ordered tests
                            if (!orderedTests.Contains(columnName))
                                continue;

                            object value = dr.GetValue(i);
                            string stringValue = value == null || value == DBNull.Value ? "" : value.ToString();

                            editData.Results.Add(new EditableResult
                            {
                                ColumnName = columnName,
                                Parameter = FormatLabel(columnName),
                                Value = stringValue
                            });
                        }
                    }
                }
            }

            return editData;
        }

        [WebMethod]
        public static UpdateResponse UpdateLabResults(string labTestId, Dictionary<string, string> results)
        {
            UpdateResponse response = new UpdateResponse();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Build UPDATE query with all possible lab result fields
                    string updateQuery = @"UPDATE lab_results SET 
                        General_urine_examination = @General_urine_examination,
                        Progesterone_Female = @Progesterone_Female,
                        Amylase = @Amylase,
                        Magnesium = @Magnesium,
                        Phosphorous = @Phosphorous,
                        Calcium = @Calcium,
                        Chloride = @Chloride,
                        Potassium = @Potassium,
                        Sodium = @Sodium,
                        Uric_acid = @Uric_acid,
                        Creatinine = @Creatinine,
                        Urea = @Urea,
                        JGlobulin = @JGlobulin,
                        Albumin = @Albumin,
                        Total_bilirubin = @Total_bilirubin,
                        Alkaline_phosphates_ALP = @Alkaline_phosphates_ALP,
                        SGOT_AST = @SGOT_AST,
                        SGPT_ALT = @SGPT_ALT,
                        Liver_function_test = @Liver_function_test,
                        Triglycerides = @Triglycerides,
                        Total_cholesterol = @Total_cholesterol,
                        Hemoglobin_A1c = @Hemoglobin_A1c,
                        High_density_lipoprotein_HDL = @High_density_lipoprotein_HDL,
                        Low_density_lipoprotein_LDL = @Low_density_lipoprotein_LDL,
                        Follicle_stimulating_hormone_FSH = @Follicle_stimulating_hormone_FSH,
                        Estradiol = @Estradiol,
                        Luteinizing_hormone_LH = @Luteinizing_hormone_LH,
                        Testosterone_Male = @Testosterone_Male,
                        Prolactin = @Prolactin,
                        Seminal_Fluid_Analysis_Male_B_HCG = @Seminal_Fluid_Analysis_Male_B_HCG,
                        Clinical_path = @Clinical_path,
                        Urine_examination = @Urine_examination,
                        Stool_examination = @Stool_examination,
                        Hemoglobin = @Hemoglobin,
                        Malaria = @Malaria,
                        ESR = @ESR,
                        Blood_grouping = @Blood_grouping,
                        Blood_sugar = @Blood_sugar,
                        CBC = @CBC,
                        Cross_matching = @Cross_matching,
                        TPHA = @TPHA,
                        Human_immune_deficiency_HIV = @Human_immune_deficiency_HIV,
                        Hepatitis_B_virus_HBV = @Hepatitis_B_virus_HBV,
                        Hepatitis_C_virus_HCV = @Hepatitis_C_virus_HCV,
                        Brucella_melitensis = @Brucella_melitensis,
                        Brucella_abortus = @Brucella_abortus,
                        C_reactive_protein_CRP = @C_reactive_protein_CRP,
                        Rheumatoid_factor_RF = @Rheumatoid_factor_RF,
                        Antistreptolysin_O_ASO = @Antistreptolysin_O_ASO,
                        Toxoplasmosis = @Toxoplasmosis,
                        Typhoid_hCG = @Typhoid_hCG,
                        Hpylori_antibody = @Hpylori_antibody,
                        Stool_occult_blood = @Stool_occult_blood,
                        General_stool_examination = @General_stool_examination,
                        Thyroid_profile = @Thyroid_profile,
                        Triiodothyronine_T3 = @Triiodothyronine_T3,
                        Thyroxine_T4 = @Thyroxine_T4,
                        Thyroid_stimulating_hormone_TSH = @Thyroid_stimulating_hormone_TSH,
                        Sperm_examination = @Sperm_examination,
                        Virginal_swab_trichomonas_virginals = @Virginal_swab_trichomonas_virginals,
                        Human_chorionic_gonadotropin_hCG = @Human_chorionic_gonadotropin_hCG,
                        Hpylori_Ag_stool = @Hpylori_Ag_stool,
                        Fasting_blood_sugar = @Fasting_blood_sugar,
                        Direct_bilirubin = @Direct_bilirubin,
                        Troponin_I = @Troponin_I,
                        CK_MB = @CK_MB,
                        aPTT = @aPTT,
                        INR = @INR,
                        D_Dimer = @D_Dimer,
                        Vitamin_D = @Vitamin_D,
                        Vitamin_B12 = @Vitamin_B12,
                        Ferritin = @Ferritin,
                        VDRL = @VDRL,
                        Dengue_Fever_IgG_IgM = @Dengue_Fever_IgG_IgM,
                        Gonorrhea_Ag = @Gonorrhea_Ag,
                        AFP = @AFP,
                        Total_PSA = @Total_PSA,
                        AMH = @AMH,
                        Electrolyte_Test = @Electrolyte_Test,
                        CRP_Titer = @CRP_Titer,
                        Ultra = @Ultra,
                        Typhoid_IgG = @Typhoid_IgG,
                        Typhoid_Ag = @Typhoid_Ag
                        WHERE lab_test_id = @labTestId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@labTestId", labTestId);

                        // Add all parameters with values from dictionary or empty string
                        cmd.Parameters.AddWithValue("@General_urine_examination", GetValue(results, "General_urine_examination"));
                        cmd.Parameters.AddWithValue("@Progesterone_Female", GetValue(results, "Progesterone_Female"));
                        cmd.Parameters.AddWithValue("@Amylase", GetValue(results, "Amylase"));
                        cmd.Parameters.AddWithValue("@Magnesium", GetValue(results, "Magnesium"));
                        cmd.Parameters.AddWithValue("@Phosphorous", GetValue(results, "Phosphorous"));
                        cmd.Parameters.AddWithValue("@Calcium", GetValue(results, "Calcium"));
                        cmd.Parameters.AddWithValue("@Chloride", GetValue(results, "Chloride"));
                        cmd.Parameters.AddWithValue("@Potassium", GetValue(results, "Potassium"));
                        cmd.Parameters.AddWithValue("@Sodium", GetValue(results, "Sodium"));
                        cmd.Parameters.AddWithValue("@Uric_acid", GetValue(results, "Uric_acid"));
                        cmd.Parameters.AddWithValue("@Creatinine", GetValue(results, "Creatinine"));
                        cmd.Parameters.AddWithValue("@Urea", GetValue(results, "Urea"));
                        cmd.Parameters.AddWithValue("@JGlobulin", GetValue(results, "JGlobulin"));
                        cmd.Parameters.AddWithValue("@Albumin", GetValue(results, "Albumin"));
                        cmd.Parameters.AddWithValue("@Total_bilirubin", GetValue(results, "Total_bilirubin"));
                        cmd.Parameters.AddWithValue("@Alkaline_phosphates_ALP", GetValue(results, "Alkaline_phosphates_ALP"));
                        cmd.Parameters.AddWithValue("@SGOT_AST", GetValue(results, "SGOT_AST"));
                        cmd.Parameters.AddWithValue("@SGPT_ALT", GetValue(results, "SGPT_ALT"));
                        cmd.Parameters.AddWithValue("@Liver_function_test", GetValue(results, "Liver_function_test"));
                        cmd.Parameters.AddWithValue("@Triglycerides", GetValue(results, "Triglycerides"));
                        cmd.Parameters.AddWithValue("@Total_cholesterol", GetValue(results, "Total_cholesterol"));
                        cmd.Parameters.AddWithValue("@Hemoglobin_A1c", GetValue(results, "Hemoglobin_A1c"));
                        cmd.Parameters.AddWithValue("@High_density_lipoprotein_HDL", GetValue(results, "High_density_lipoprotein_HDL"));
                        cmd.Parameters.AddWithValue("@Low_density_lipoprotein_LDL", GetValue(results, "Low_density_lipoprotein_LDL"));
                        cmd.Parameters.AddWithValue("@Follicle_stimulating_hormone_FSH", GetValue(results, "Follicle_stimulating_hormone_FSH"));
                        cmd.Parameters.AddWithValue("@Estradiol", GetValue(results, "Estradiol"));
                        cmd.Parameters.AddWithValue("@Luteinizing_hormone_LH", GetValue(results, "Luteinizing_hormone_LH"));
                        cmd.Parameters.AddWithValue("@Testosterone_Male", GetValue(results, "Testosterone_Male"));
                        cmd.Parameters.AddWithValue("@Prolactin", GetValue(results, "Prolactin"));
                        cmd.Parameters.AddWithValue("@Seminal_Fluid_Analysis_Male_B_HCG", GetValue(results, "Seminal_Fluid_Analysis_Male_B_HCG"));
                        cmd.Parameters.AddWithValue("@Clinical_path", GetValue(results, "Clinical_path"));
                        cmd.Parameters.AddWithValue("@Urine_examination", GetValue(results, "Urine_examination"));
                        cmd.Parameters.AddWithValue("@Stool_examination", GetValue(results, "Stool_examination"));
                        cmd.Parameters.AddWithValue("@Hemoglobin", GetValue(results, "Hemoglobin"));
                        cmd.Parameters.AddWithValue("@Malaria", GetValue(results, "Malaria"));
                        cmd.Parameters.AddWithValue("@ESR", GetValue(results, "ESR"));
                        cmd.Parameters.AddWithValue("@Blood_grouping", GetValue(results, "Blood_grouping"));
                        cmd.Parameters.AddWithValue("@Blood_sugar", GetValue(results, "Blood_sugar"));
                        cmd.Parameters.AddWithValue("@CBC", GetValue(results, "CBC"));
                        cmd.Parameters.AddWithValue("@Cross_matching", GetValue(results, "Cross_matching"));
                        cmd.Parameters.AddWithValue("@TPHA", GetValue(results, "TPHA"));
                        cmd.Parameters.AddWithValue("@Human_immune_deficiency_HIV", GetValue(results, "Human_immune_deficiency_HIV"));
                        cmd.Parameters.AddWithValue("@Hepatitis_B_virus_HBV", GetValue(results, "Hepatitis_B_virus_HBV"));
                        cmd.Parameters.AddWithValue("@Hepatitis_C_virus_HCV", GetValue(results, "Hepatitis_C_virus_HCV"));
                        cmd.Parameters.AddWithValue("@Brucella_melitensis", GetValue(results, "Brucella_melitensis"));
                        cmd.Parameters.AddWithValue("@Brucella_abortus", GetValue(results, "Brucella_abortus"));
                        cmd.Parameters.AddWithValue("@C_reactive_protein_CRP", GetValue(results, "C_reactive_protein_CRP"));
                        cmd.Parameters.AddWithValue("@Rheumatoid_factor_RF", GetValue(results, "Rheumatoid_factor_RF"));
                        cmd.Parameters.AddWithValue("@Antistreptolysin_O_ASO", GetValue(results, "Antistreptolysin_O_ASO"));
                        cmd.Parameters.AddWithValue("@Toxoplasmosis", GetValue(results, "Toxoplasmosis"));
                        cmd.Parameters.AddWithValue("@Typhoid_hCG", GetValue(results, "Typhoid_hCG"));
                        cmd.Parameters.AddWithValue("@Hpylori_antibody", GetValue(results, "Hpylori_antibody"));
                        cmd.Parameters.AddWithValue("@Stool_occult_blood", GetValue(results, "Stool_occult_blood"));
                        cmd.Parameters.AddWithValue("@General_stool_examination", GetValue(results, "General_stool_examination"));
                        cmd.Parameters.AddWithValue("@Thyroid_profile", GetValue(results, "Thyroid_profile"));
                        cmd.Parameters.AddWithValue("@Triiodothyronine_T3", GetValue(results, "Triiodothyronine_T3"));
                        cmd.Parameters.AddWithValue("@Thyroxine_T4", GetValue(results, "Thyroxine_T4"));
                        cmd.Parameters.AddWithValue("@Thyroid_stimulating_hormone_TSH", GetValue(results, "Thyroid_stimulating_hormone_TSH"));
                        cmd.Parameters.AddWithValue("@Sperm_examination", GetValue(results, "Sperm_examination"));
                        cmd.Parameters.AddWithValue("@Virginal_swab_trichomonas_virginals", GetValue(results, "Virginal_swab_trichomonas_virginals"));
                        cmd.Parameters.AddWithValue("@Human_chorionic_gonadotropin_hCG", GetValue(results, "Human_chorionic_gonadotropin_hCG"));
                        cmd.Parameters.AddWithValue("@Hpylori_Ag_stool", GetValue(results, "Hpylori_Ag_stool"));
                        cmd.Parameters.AddWithValue("@Fasting_blood_sugar", GetValue(results, "Fasting_blood_sugar"));
                        cmd.Parameters.AddWithValue("@Direct_bilirubin", GetValue(results, "Direct_bilirubin"));
                        cmd.Parameters.AddWithValue("@Troponin_I", GetValue(results, "Troponin_I"));
                        cmd.Parameters.AddWithValue("@CK_MB", GetValue(results, "CK_MB"));
                        cmd.Parameters.AddWithValue("@aPTT", GetValue(results, "aPTT"));
                        cmd.Parameters.AddWithValue("@INR", GetValue(results, "INR"));
                        cmd.Parameters.AddWithValue("@D_Dimer", GetValue(results, "D_Dimer"));
                        cmd.Parameters.AddWithValue("@Vitamin_D", GetValue(results, "Vitamin_D"));
                        cmd.Parameters.AddWithValue("@Vitamin_B12", GetValue(results, "Vitamin_B12"));
                        cmd.Parameters.AddWithValue("@Ferritin", GetValue(results, "Ferritin"));
                        cmd.Parameters.AddWithValue("@VDRL", GetValue(results, "VDRL"));
                        cmd.Parameters.AddWithValue("@Dengue_Fever_IgG_IgM", GetValue(results, "Dengue_Fever_IgG_IgM"));
                        cmd.Parameters.AddWithValue("@Gonorrhea_Ag", GetValue(results, "Gonorrhea_Ag"));
                        cmd.Parameters.AddWithValue("@AFP", GetValue(results, "AFP"));
                        cmd.Parameters.AddWithValue("@Total_PSA", GetValue(results, "Total_PSA"));
                        cmd.Parameters.AddWithValue("@AMH", GetValue(results, "AMH"));
                        cmd.Parameters.AddWithValue("@Electrolyte_Test", GetValue(results, "Electrolyte_Test"));
                        cmd.Parameters.AddWithValue("@CRP_Titer", GetValue(results, "CRP_Titer"));
                        cmd.Parameters.AddWithValue("@Ultra", GetValue(results, "Ultra"));
                        cmd.Parameters.AddWithValue("@Typhoid_IgG", GetValue(results, "Typhoid_IgG"));
                        cmd.Parameters.AddWithValue("@Typhoid_Ag", GetValue(results, "Typhoid_Ag"));

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update prescription status to 'lab-processed' (status = 5)
                            string updateStatusQuery = @"
                                UPDATE prescribtion 
                                SET [status] = 5 
                                WHERE prescid = (SELECT prescid FROM lab_test WHERE med_id = @labTestId)";
                            
                            using (SqlCommand statusCmd = new SqlCommand(updateStatusQuery, con))
                            {
                                statusCmd.Parameters.AddWithValue("@labTestId", labTestId);
                                statusCmd.ExecuteNonQuery();
                            }

                            response.success = true;
                            response.message = "Lab results updated successfully";
                        }
                        else
                        {
                            response.success = false;
                            response.message = "No records were updated";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        private static string GetValue(Dictionary<string, string> dict, string key)
        {
            return dict.ContainsKey(key) ? dict[key] : "";
        }

        private static string FormatLabel(string columnName)
        {
            string label = columnName.Replace("_", " ");
            return System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(label.ToLowerInvariant());
        }

        // Helper classes
        public class OrderedTest
        {
            public string TestName { get; set; }
            public string PatientName { get; set; }
            public string OrderDate { get; set; }
        }

        public class TestResultData
        {
            public string PatientName { get; set; }
            public string PatientId { get; set; }
            public string OrderDate { get; set; }
            public string Doctor { get; set; }
            public List<TestResult> Results { get; set; }

            public TestResultData()
            {
                Results = new List<TestResult>();
            }
        }

        public class TestResult
        {
            public string Parameter { get; set; }
            public string Value { get; set; }
        }

        public class PatientHistoryData
        {
            public int TotalOrders { get; set; }
            public int CompletedOrders { get; set; }
            public int PendingOrders { get; set; }
            public List<LabOrderInfo> Orders { get; set; }

            public PatientHistoryData()
            {
                Orders = new List<LabOrderInfo>();
            }
        }

        public class LabOrderInfo
        {
            public string OrderId { get; set; }
            public string PrescId { get; set; }
            public string OrderDate { get; set; }
            public bool IsCompleted { get; set; }
            public string Doctor { get; set; }
            public List<string> Tests { get; set; }
            public List<TestResult> Results { get; set; }
        }

        public class EditResultData
        {
            public string LabResultId { get; set; }
            public string PrescId { get; set; }
            public string PatientName { get; set; }
            public string TestDate { get; set; }
            public List<string> OrderedTests { get; set; }
            public List<EditableResult> Results { get; set; }

            public EditResultData()
            {
                OrderedTests = new List<string>();
                Results = new List<EditableResult>();
            }
        }

        public class EditableResult
        {
            public string ColumnName { get; set; }
            public string Parameter { get; set; }
            public string Value { get; set; }
        }

        public class UpdateResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
        }
    }
}
