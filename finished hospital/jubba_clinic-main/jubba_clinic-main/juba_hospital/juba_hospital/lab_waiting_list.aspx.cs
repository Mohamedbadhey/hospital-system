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
    public partial class lab_waiting_list : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static ptclass[] pendlap()
        {
            List<ptclass> details = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                // Get individual lab orders with their status
                SqlCommand cmd = new SqlCommand(@"
    SELECT 
    lt.med_id as order_id,
    patient.full_name, 
    patient.sex,
    patient.location,
    patient.phone,
    date_registered,
    doctor.doctortitle,
    patient.patientid,
    prescribtion.prescid,
    doctor.doctorid,
    patient.amount,
    CONVERT(date, patient.dob) AS dob,
    lt.date_taken as order_date,
    ISNULL(lt.is_reorder, 0) as is_reorder,
    lt.reorder_reason,
    CASE 
        WHEN lr.lab_result_id IS NOT NULL THEN 'Completed'
        ELSE 'Pending'
    END AS order_status,
    lr.lab_result_id,
    (SELECT STRING_AGG(charge_name, ', ') 
     FROM patient_charges 
     WHERE reference_id = lt.med_id AND charge_type = 'Lab' AND is_paid = 1) as charge_name,
    (SELECT SUM(amount) 
     FROM patient_charges 
     WHERE reference_id = lt.med_id AND charge_type = 'Lab' AND is_paid = 1) as charge_amount,
    CASE 
        WHEN EXISTS(SELECT 1 FROM patient_charges WHERE reference_id = lt.med_id AND charge_type = 'Lab' AND is_paid = 1) THEN 1
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
LEFT JOIN 
    lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
WHERE 
    prescribtion.status IN (4, 5)
    AND (prescribtion.lab_charge_paid = 1 OR EXISTS(SELECT 1 FROM patient_charges WHERE reference_id = lt.med_id AND charge_type = 'Lab' AND is_paid = 1))
    AND lr.lab_result_id IS NULL  -- Only show pending orders (no results yet)
ORDER BY 
    lt.is_reorder DESC,  -- Reorders/Follow-ups first
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
                        field.status = dr["order_status"].ToString();
                        field.lab_result_id = dr["lab_result_id"]?.ToString() ?? "";
                        field.is_reorder = dr["is_reorder"].ToString();
                        field.reorder_reason = dr["reorder_reason"]?.ToString() ?? "";
                        field.last_order_date = dr["order_date"] != DBNull.Value ? Convert.ToDateTime(dr["order_date"]).ToString("yyyy-MM-dd HH:mm") : "";
                        field.lab_charge_paid = dr["charge_paid"]?.ToString() ?? "0";
                        field.unpaid_lab_charges = "0";
                        field.order_id = dr["order_id"].ToString();
                        field.charge_name = dr["charge_name"]?.ToString() ?? "";
                        field.charge_amount = dr["charge_amount"]?.ToString() ?? "0";
                        
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
                                    ColumnName = columnName,
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
                        p.sex,
                        p.phone,
                        p.location,
                        CONVERT(date, p.dob) as dob,
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
                        resultData.PatientSex = dr["sex"].ToString();
                        resultData.PatientPhone = dr["phone"].ToString();
                        resultData.PatientLocation = dr["location"].ToString();
                        resultData.PatientDOB = dr["dob"] != DBNull.Value ? 
                            Convert.ToDateTime(dr["dob"]).ToString("dd MMM yyyy") : "";
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
                        d.doctortitle,
                        lt.*
                    FROM lab_test lt
                    INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                    LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                    WHERE p.patientid = @patientid
                    ORDER BY lt.date_taken DESC", con);
                
                cmd.Parameters.AddWithValue("@patientid", patientId);

                Dictionary<string, LabOrderInfo> ordersDict = new Dictionary<string, LabOrderInfo>();

                var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                {
                    "med_id", "prescid", "date_taken", "is_reorder", "reorder_reason", 
                    "original_order_id", "order_id", "order_date", "is_completed", "doctortitle"
                };

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        string orderId = dr["order_id"].ToString();
                        string prescid = dr["prescid"].ToString();
                        string key = orderId + "_" + prescid;

                        if (!ordersDict.ContainsKey(key))
                        {
                            ordersDict[key] = new LabOrderInfo
                            {
                                OrderId = orderId,
                                PrescId = prescid,
                                OrderDate = dr["order_date"] != DBNull.Value ? 
                                    Convert.ToDateTime(dr["order_date"]).ToString("dd MMM yyyy HH:mm") : "",
                                IsCompleted = Convert.ToInt32(dr["is_completed"]) == 1,
                                Doctor = dr["doctortitle"]?.ToString(),
                                Tests = new List<string>(),
                                Results = new List<TestResult>()
                            };

                            // Extract ordered tests from columns
                            for (int i = 0; i < dr.FieldCount; i++)
                            {
                                string columnName = dr.GetName(i);
                                if (excludedColumns.Contains(columnName))
                                    continue;

                                object value = dr.GetValue(i);
                                if (value == null || value == DBNull.Value)
                                    continue;

                                string stringValue = value.ToString().Trim();
                                if (!string.IsNullOrWhiteSpace(stringValue) && 
                                    !string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                                {
                                    ordersDict[key].Tests.Add(FormatLabel(columnName));
                                }
                            }
                        }
                    }
                }

                // Get results for completed orders
                foreach (var order in ordersDict.Values)
                {
                    if (order.IsCompleted)
                    {
                        cmd = new SqlCommand(@"
                            SELECT *
                            FROM lab_results
                            WHERE prescid = @prescid
                            ORDER BY date_taken DESC", con);
                        
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@prescid", order.PrescId);

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

                                    object value = dr.GetValue(i);
                                    if (value == null || value == DBNull.Value)
                                        continue;

                                    string stringValue = value.ToString();
                                    if (string.IsNullOrWhiteSpace(stringValue) || 
                                        string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                                        continue;

                                    order.Results.Add(new TestResult
                                    {
                                        Parameter = FormatLabel(columnName),
                                        Value = stringValue
                                    });
                                }
                            }
                        }
                    }
                }

                historyData.Orders = ordersDict.Values.ToList();
                historyData.TotalOrders = historyData.Orders.Count;
                historyData.CompletedOrders = historyData.Orders.Count(o => o.IsCompleted);
                historyData.PendingOrders = historyData.Orders.Count(o => !o.IsCompleted);
            }

            return historyData;
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
            public string ColumnName { get; set; }
            public string PatientName { get; set; }
            public string OrderDate { get; set; }
        }

        public class TestResultData
        {
            public string PatientName { get; set; }
            public string PatientId { get; set; }
            public string PatientSex { get; set; }
            public string PatientPhone { get; set; }
            public string PatientLocation { get; set; }
            public string PatientDOB { get; set; }
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

        // Copy the exact WebMethod from test_details.aspx.cs
        [WebMethod]
        public static string updatetest(
            string id,
            string flexCheckGeneralUrineExamination1, string flexCheckProgesteroneFemale1, string flexCheckAmylase1, string flexCheckMagnesium1,
            string flexCheckPhosphorous1, string flexCheckCalcium1, string flexCheckChloride1, string flexCheckPotassium1,
            string flexCheckSodium1, string flexCheckUricAcid1, string flexCheckCreatinine1, string flexCheckUrea1,
            string flexCheckJGlobulin1, string flexCheckAlbumin1, string flexCheckTotalBilirubin1, string flexCheckAlkalinePhosphatesALP1,
            string flexCheckSGOTAST1, string flexCheckSGPTALT1, string flexCheckLiverFunctionTest1, string flexCheckTriglycerides1,
            string flexCheckTotalCholesterol1, string flexCheckHemoglobinA1c1, string flexCheckHDL1, string flexCheckLDL1,
            string flexCheckFSH1, string flexCheckEstradiol1, string flexCheckLH1,
            string flexCheckTestosteroneMale1, string flexCheckProlactin1, string flexCheckSeminalFluidAnalysis1, string flexCheckBHCG1,
            string flexCheckUrineExamination1, string flexCheckStoolExamination1, string flexCheckHemoglobin1, string flexCheckMalaria1,
            string flexCheckESR1, string flexCheckBloodGrouping1, string flexCheckBloodSugar1, string flexCheckCBC1,
            string flexCheckCrossMatching1, string flexCheckTPHA1, string flexCheckHIV1, string flexCheckHBV1,
            string flexCheckHCV1, string flexCheckBrucellaMelitensis1, string flexCheckBrucellaAbortus1, string flexCheckCRP1,
            string flexCheckRF1, string flexCheckASO1, string flexCheckToxoplasmosis1, string flexCheckTyphoid1,
            string flexCheckHpyloriAntibody1, string flexCheckStoolOccultBlood1, string flexCheckGeneralStoolExamination1, string flexCheckThyroidProfile1,
            string flexCheckT31, string flexCheckT41, string flexCheckTSH1, string flexCheckSpermExamination1,
            string flexCheckVirginalSwab1, string flexCheckTrichomonasVirginals1, string flexCheckHCG1, string flexCheckHpyloriAgStool1,
            string flexCheckFastingBloodSugar1, string flexCheckDirectBilirubin1,
            string flexCheckTroponinI1, string flexCheckCKMB1, string flexCheckAPTT1, string flexCheckINR1, string flexCheckDDimer1,
            string flexCheckVitaminD1, string flexCheckVitaminB121, string flexCheckFerritin1, string flexCheckVDRL1,
            string flexCheckDengueFever1, string flexCheckGonorrheaAg1, string flexCheckAFP1, string flexCheckTotalPSA1, string flexCheckAMH1,
            string flexCheckElectrolyteTest1, string flexCheckCRPTiter1, string flexCheckUltra1, string flexCheckTyphoidIgG1, string flexCheckTyphoidAg1
        )
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                bool resultsExist = false;
                
                using (SqlConnection conn = new SqlConnection(cs))
                {
                    conn.Open();
                    
                    // First, check if results already exist for this lab test
                    using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM lab_results WHERE lab_test_id = @id", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@id", id);
                        int count = (int)checkCmd.ExecuteScalar();
                        resultsExist = count > 0;
                    }
                    
                    string query;
                    if (resultsExist)
                    {
                        // Update existing results
                        query = "UPDATE lab_results SET " +
                        "General_urine_examination = @flexCheckGeneralUrineExamination1, " +
                        "Progesterone_Female = @flexCheckProgesteroneFemale1, " +
                        "Amylase = @flexCheckAmylase1, " +
                        "Magnesium = @flexCheckMagnesium1, " +
                        "Phosphorous = @flexCheckPhosphorous1, " +
                        "Calcium = @flexCheckCalcium1, " +
                        "Chloride = @flexCheckChloride1, " +
                        "Potassium = @flexCheckPotassium1, " +
                        "Sodium = @flexCheckSodium1, " +
                        "Uric_acid = @flexCheckUricAcid1, " +
                        "Creatinine = @flexCheckCreatinine1, " +
                        "Urea = @flexCheckUrea1, " +
                        "JGlobulin = @flexCheckJGlobulin1, " +
                        "Albumin = @flexCheckAlbumin1, " +
                        "Total_bilirubin = @flexCheckTotalBilirubin1, " +
                        "Alkaline_phosphates_ALP = @flexCheckAlkalinePhosphatesALP1, " +
                        "SGOT_AST = @flexCheckSGOTAST1, " +
                        "SGPT_ALT = @flexCheckSGPTALT1, " +
                        "Liver_function_test = @flexCheckLiverFunctionTest1, " +
                        "Triglycerides = @flexCheckTriglycerides1, " +
                        "Total_cholesterol = @flexCheckTotalCholesterol1, " +
                        "Hemoglobin_A1c = @flexCheckHemoglobinA1c1, " +
                        "High_density_lipoprotein_HDL = @flexCheckHDL1, " +
                        "Low_density_lipoprotein_LDL = @flexCheckLDL1, " +
                        "Follicle_stimulating_hormone_FSH = @flexCheckFSH1, " +
                        "Estradiol = @flexCheckEstradiol1, " +
                        "Luteinizing_hormone_LH = @flexCheckLH1, " +
                        "Testosterone_Male = @flexCheckTestosteroneMale1, " +
                        "Prolactin = @flexCheckProlactin1, " +
                        "Seminal_Fluid_Analysis_Male_B_HCG = @flexCheckSeminalFluidAnalysis1, " +
                        "Clinical_path = @flexCheckBHCG1, " +
                        "Urine_examination = @flexCheckUrineExamination1, " +
                        "Stool_examination = @flexCheckStoolExamination1, " +
                        "Hemoglobin = @flexCheckHemoglobin1, " +
                        "Malaria = @flexCheckMalaria1, " +
                        "ESR = @flexCheckESR1, " +
                        "Blood_grouping = @flexCheckBloodGrouping1, " +
                        "Blood_sugar = @flexCheckBloodSugar1, " +
                        "CBC = @flexCheckCBC1, " +
                        "Cross_matching = @flexCheckCrossMatching1, " +
                        "TPHA = @flexCheckTPHA1, " +
                        "Human_immune_deficiency_HIV = @flexCheckHIV1, " +
                        "Hepatitis_B_virus_HBV = @flexCheckHBV1, " +
                        "Hepatitis_C_virus_HCV = @flexCheckHCV1, " +
                        "Brucella_melitensis = @flexCheckBrucellaMelitensis1, " +
                        "Brucella_abortus = @flexCheckBrucellaAbortus1, " +
                        "C_reactive_protein_CRP = @flexCheckCRP1, " +
                        "Rheumatoid_factor_RF = @flexCheckRF1, " +
                        "Antistreptolysin_O_ASO = @flexCheckASO1, " +
                        "Toxoplasmosis = @flexCheckToxoplasmosis1, " +
                        "Typhoid_hCG = @flexCheckTyphoid1, " +
                        "Hpylori_antibody = @flexCheckHpyloriAntibody1, " +
                        "Stool_occult_blood = @flexCheckStoolOccultBlood1, " +
                        "General_stool_examination = @flexCheckGeneralStoolExamination1, " +
                        "Thyroid_profile = @flexCheckThyroidProfile1, " +
                        "Triiodothyronine_T3 = @flexCheckT31, " +
                        "Thyroxine_T4 = @flexCheckT41, " +
                        "Thyroid_stimulating_hormone_TSH = @flexCheckTSH1, " +
                        "Sperm_examination = @flexCheckSpermExamination1, " +
                        "Virginal_swab_trichomonas_virginals = @flexCheckVirginalSwab1, " +
                        "Human_chorionic_gonadotropin_hCG = @flexCheckHCG1, " +
                        "Hpylori_Ag_stool = @flexCheckHpyloriAgStool1, " +
                        "Fasting_blood_sugar = @flexCheckFastingBloodSugar1, " +
                        "Direct_bilirubin = @flexCheckDirectBilirubin1, " +
                        "Troponin_I = @Troponin_I, " +
                        "CK_MB = @CK_MB, " +
                        "aPTT = @aPTT, " +
                        "INR = @INR, " +
                        "D_Dimer = @D_Dimer, " +
                        "Vitamin_D = @Vitamin_D, " +
                        "Vitamin_B12 = @Vitamin_B12, " +
                        "Ferritin = @Ferritin, " +
                        "VDRL = @VDRL, " +
                        "Dengue_Fever_IgG_IgM = @Dengue_Fever_IgG_IgM, " +
                        "Gonorrhea_Ag = @Gonorrhea_Ag, " +
                        "AFP = @AFP, " +
                        "Total_PSA = @Total_PSA, " +
                        "AMH = @AMH, " +
                        "Electrolyte_Test = @Electrolyte_Test, " +
                        "CRP_Titer = @CRP_Titer, " +
                        "Ultra = @Ultra, " +
                        "Typhoid_IgG = @Typhoid_IgG, " +
                        "Typhoid_Ag = @Typhoid_Ag " +
                        "WHERE lab_test_id = @id";
                    }
                    else
                    {
                        // Insert new results
                        query = "INSERT INTO lab_results (" +
                        "lab_test_id, prescid, " +
                        "General_urine_examination, Progesterone_Female, Amylase, Magnesium, " +
                        "Phosphorous, Calcium, Chloride, Potassium, Sodium, Uric_acid, Creatinine, Urea, " +
                        "JGlobulin, Albumin, Total_bilirubin, Alkaline_phosphates_ALP, SGOT_AST, SGPT_ALT, " +
                        "Liver_function_test, Triglycerides, Total_cholesterol, Hemoglobin_A1c, " +
                        "High_density_lipoprotein_HDL, Low_density_lipoprotein_LDL, " +
                        "Follicle_stimulating_hormone_FSH, Estradiol, Luteinizing_hormone_LH, " +
                        "Testosterone_Male, Prolactin, Seminal_Fluid_Analysis_Male_B_HCG, Clinical_path, " +
                        "Urine_examination, Stool_examination, Hemoglobin, Malaria, ESR, Blood_grouping, " +
                        "Blood_sugar, CBC, Cross_matching, TPHA, Human_immune_deficiency_HIV, " +
                        "Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV, Brucella_melitensis, Brucella_abortus, " +
                        "C_reactive_protein_CRP, Rheumatoid_factor_RF, Antistreptolysin_O_ASO, Toxoplasmosis, " +
                        "Typhoid_hCG, Hpylori_antibody, Stool_occult_blood, General_stool_examination, " +
                        "Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4, Thyroid_stimulating_hormone_TSH, Sperm_examination, Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG, " +
                        "Hpylori_Ag_stool, Fasting_blood_sugar, Direct_bilirubin, " +
                        "Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH, Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag, date_taken) " +
                        "VALUES (" +
                        "@id, (SELECT prescid FROM lab_test WHERE med_id = @id), " +
                        "@flexCheckGeneralUrineExamination1, @flexCheckProgesteroneFemale1, @flexCheckAmylase1, @flexCheckMagnesium1, " +
                        "@flexCheckPhosphorous1, @flexCheckCalcium1, @flexCheckChloride1, @flexCheckPotassium1, " +
                        "@flexCheckSodium1, @flexCheckUricAcid1, @flexCheckCreatinine1, @flexCheckUrea1, " +
                        "@flexCheckJGlobulin1, @flexCheckAlbumin1, @flexCheckTotalBilirubin1, @flexCheckAlkalinePhosphatesALP1, " +
                        "@flexCheckSGOTAST1, @flexCheckSGPTALT1, @flexCheckLiverFunctionTest1, @flexCheckTriglycerides1, " +
                        "@flexCheckTotalCholesterol1, @flexCheckHemoglobinA1c1, @flexCheckHDL1, @flexCheckLDL1, " +
                        "@flexCheckFSH1, @flexCheckEstradiol1, @flexCheckLH1, @flexCheckTestosteroneMale1, " +
                        "@flexCheckProlactin1, @flexCheckSeminalFluidAnalysis1, @flexCheckBHCG1, " +
                        "@flexCheckUrineExamination1, @flexCheckStoolExamination1, @flexCheckHemoglobin1, " +
                        "@flexCheckMalaria1, @flexCheckESR1, @flexCheckBloodGrouping1, @flexCheckBloodSugar1, " +
                        "@flexCheckCBC1, @flexCheckCrossMatching1, @flexCheckTPHA1, @flexCheckHIV1, " +
                        "@flexCheckHBV1, @flexCheckHCV1, @flexCheckBrucellaMelitensis1, @flexCheckBrucellaAbortus1, " +
                        "@flexCheckCRP1, @flexCheckRF1, @flexCheckASO1, @flexCheckToxoplasmosis1, @flexCheckTyphoid1, " +
                        "@flexCheckHpyloriAntibody1, @flexCheckStoolOccultBlood1, @flexCheckGeneralStoolExamination1, " +
                        "@flexCheckThyroidProfile1, @flexCheckT31, @flexCheckT41, @flexCheckTSH1, " +
                        "@flexCheckSpermExamination1, @flexCheckVirginalSwab1, @flexCheckHCG1, " +
                        "@flexCheckHpyloriAgStool1, @flexCheckFastingBloodSugar1, @flexCheckDirectBilirubin1, " +
                        "@Troponin_I, @CK_MB, @aPTT, @INR, @D_Dimer, @Vitamin_D, @Vitamin_B12, @Ferritin, @VDRL, @Dengue_Fever_IgG_IgM, @Gonorrhea_Ag, @AFP, @Total_PSA, @AMH, @Electrolyte_Test, @CRP_Titer, @Ultra, @Typhoid_IgG, @Typhoid_Ag, " +
                        "@date_taken)";
                    }
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@date_taken", DateTimeHelper.Now);
                        cmd.Parameters.AddWithValue("@flexCheckGeneralUrineExamination1", flexCheckGeneralUrineExamination1);
                        cmd.Parameters.AddWithValue("@flexCheckProgesteroneFemale1", flexCheckProgesteroneFemale1);
                        cmd.Parameters.AddWithValue("@flexCheckAmylase1", flexCheckAmylase1);
                        cmd.Parameters.AddWithValue("@flexCheckMagnesium1", flexCheckMagnesium1);
                        cmd.Parameters.AddWithValue("@flexCheckPhosphorous1", flexCheckPhosphorous1);
                        cmd.Parameters.AddWithValue("@flexCheckCalcium1", flexCheckCalcium1);
                        cmd.Parameters.AddWithValue("@flexCheckChloride1", flexCheckChloride1);
                        cmd.Parameters.AddWithValue("@flexCheckPotassium1", flexCheckPotassium1);
                        cmd.Parameters.AddWithValue("@flexCheckSodium1", flexCheckSodium1);
                        cmd.Parameters.AddWithValue("@flexCheckUricAcid1", flexCheckUricAcid1);
                        cmd.Parameters.AddWithValue("@flexCheckCreatinine1", flexCheckCreatinine1);
                        cmd.Parameters.AddWithValue("@flexCheckUrea1", flexCheckUrea1);
                        cmd.Parameters.AddWithValue("@flexCheckJGlobulin1", flexCheckJGlobulin1);
                        cmd.Parameters.AddWithValue("@flexCheckAlbumin1", flexCheckAlbumin1);
                        cmd.Parameters.AddWithValue("@flexCheckTotalBilirubin1", flexCheckTotalBilirubin1);
                        cmd.Parameters.AddWithValue("@flexCheckAlkalinePhosphatesALP1", flexCheckAlkalinePhosphatesALP1);
                        cmd.Parameters.AddWithValue("@flexCheckSGOTAST1", flexCheckSGOTAST1);
                        cmd.Parameters.AddWithValue("@flexCheckSGPTALT1", flexCheckSGPTALT1);
                        cmd.Parameters.AddWithValue("@flexCheckLiverFunctionTest1", flexCheckLiverFunctionTest1);
                        cmd.Parameters.AddWithValue("@flexCheckTriglycerides1", flexCheckTriglycerides1);
                        cmd.Parameters.AddWithValue("@flexCheckTotalCholesterol1", flexCheckTotalCholesterol1);
                        cmd.Parameters.AddWithValue("@flexCheckHemoglobinA1c1", flexCheckHemoglobinA1c1);
                        cmd.Parameters.AddWithValue("@flexCheckHDL1", flexCheckHDL1);
                        cmd.Parameters.AddWithValue("@flexCheckLDL1", flexCheckLDL1);
                        cmd.Parameters.AddWithValue("@flexCheckFSH1", flexCheckFSH1);
                        cmd.Parameters.AddWithValue("@flexCheckEstradiol1", flexCheckEstradiol1);
                        cmd.Parameters.AddWithValue("@flexCheckLH1", flexCheckLH1);
                        cmd.Parameters.AddWithValue("@flexCheckTestosteroneMale1", flexCheckTestosteroneMale1);
                        cmd.Parameters.AddWithValue("@flexCheckProlactin1", flexCheckProlactin1);
                        cmd.Parameters.AddWithValue("@flexCheckSeminalFluidAnalysis1", flexCheckSeminalFluidAnalysis1);
                        cmd.Parameters.AddWithValue("@flexCheckBHCG1", flexCheckBHCG1);
                        cmd.Parameters.AddWithValue("@flexCheckUrineExamination1", flexCheckUrineExamination1);
                        cmd.Parameters.AddWithValue("@flexCheckStoolExamination1", flexCheckStoolExamination1);
                        cmd.Parameters.AddWithValue("@flexCheckHemoglobin1", flexCheckHemoglobin1);
                        cmd.Parameters.AddWithValue("@flexCheckMalaria1", flexCheckMalaria1);
                        cmd.Parameters.AddWithValue("@flexCheckESR1", flexCheckESR1);
                        cmd.Parameters.AddWithValue("@flexCheckBloodGrouping1", flexCheckBloodGrouping1);
                        cmd.Parameters.AddWithValue("@flexCheckBloodSugar1", flexCheckBloodSugar1);
                        cmd.Parameters.AddWithValue("@flexCheckCBC1", flexCheckCBC1);
                        cmd.Parameters.AddWithValue("@flexCheckCrossMatching1", flexCheckCrossMatching1);
                        cmd.Parameters.AddWithValue("@flexCheckTPHA1", flexCheckTPHA1);
                        cmd.Parameters.AddWithValue("@flexCheckHIV1", flexCheckHIV1);
                        cmd.Parameters.AddWithValue("@flexCheckHBV1", flexCheckHBV1);
                        cmd.Parameters.AddWithValue("@flexCheckHCV1", flexCheckHCV1);
                        cmd.Parameters.AddWithValue("@flexCheckBrucellaMelitensis1", flexCheckBrucellaMelitensis1);
                        cmd.Parameters.AddWithValue("@flexCheckBrucellaAbortus1", flexCheckBrucellaAbortus1);
                        cmd.Parameters.AddWithValue("@flexCheckCRP1", flexCheckCRP1);
                        cmd.Parameters.AddWithValue("@flexCheckRF1", flexCheckRF1);
                        cmd.Parameters.AddWithValue("@flexCheckASO1", flexCheckASO1);
                        cmd.Parameters.AddWithValue("@flexCheckToxoplasmosis1", flexCheckToxoplasmosis1);
                        cmd.Parameters.AddWithValue("@flexCheckTyphoid1", flexCheckTyphoid1);
                        cmd.Parameters.AddWithValue("@flexCheckHpyloriAntibody1", flexCheckHpyloriAntibody1);
                        cmd.Parameters.AddWithValue("@flexCheckStoolOccultBlood1", flexCheckStoolOccultBlood1);
                        cmd.Parameters.AddWithValue("@flexCheckGeneralStoolExamination1", flexCheckGeneralStoolExamination1);
                        cmd.Parameters.AddWithValue("@flexCheckThyroidProfile1", flexCheckThyroidProfile1);
                        cmd.Parameters.AddWithValue("@flexCheckT31", flexCheckT31);
                        cmd.Parameters.AddWithValue("@flexCheckT41", flexCheckT41);
                        cmd.Parameters.AddWithValue("@flexCheckTSH1", flexCheckTSH1);
                        cmd.Parameters.AddWithValue("@flexCheckSpermExamination1", flexCheckSpermExamination1);
                        cmd.Parameters.AddWithValue("@flexCheckVirginalSwab1", flexCheckVirginalSwab1);
                        cmd.Parameters.AddWithValue("@flexCheckHCG1", flexCheckHCG1);
                        cmd.Parameters.AddWithValue("@flexCheckHpyloriAgStool1", flexCheckHpyloriAgStool1);
                        cmd.Parameters.AddWithValue("@flexCheckFastingBloodSugar1", flexCheckFastingBloodSugar1);
                        cmd.Parameters.AddWithValue("@flexCheckDirectBilirubin1", flexCheckDirectBilirubin1);
                        cmd.Parameters.AddWithValue("@Troponin_I", flexCheckTroponinI1);
                        cmd.Parameters.AddWithValue("@CK_MB", flexCheckCKMB1);
                        cmd.Parameters.AddWithValue("@aPTT", flexCheckAPTT1);
                        cmd.Parameters.AddWithValue("@INR", flexCheckINR1);
                        cmd.Parameters.AddWithValue("@D_Dimer", flexCheckDDimer1);
                        cmd.Parameters.AddWithValue("@Vitamin_D", flexCheckVitaminD1);
                        cmd.Parameters.AddWithValue("@Vitamin_B12", flexCheckVitaminB121);
                        cmd.Parameters.AddWithValue("@Ferritin", flexCheckFerritin1);
                        cmd.Parameters.AddWithValue("@VDRL", flexCheckVDRL1);
                        cmd.Parameters.AddWithValue("@Dengue_Fever_IgG_IgM", flexCheckDengueFever1);
                        cmd.Parameters.AddWithValue("@Gonorrhea_Ag", flexCheckGonorrheaAg1);
                        cmd.Parameters.AddWithValue("@AFP", flexCheckAFP1);
                        cmd.Parameters.AddWithValue("@Total_PSA", flexCheckTotalPSA1);
                        cmd.Parameters.AddWithValue("@AMH", flexCheckAMH1);
                        cmd.Parameters.AddWithValue("@Electrolyte_Test", flexCheckElectrolyteTest1);
                        cmd.Parameters.AddWithValue("@CRP_Titer", flexCheckCRPTiter1);
                        cmd.Parameters.AddWithValue("@Ultra", flexCheckUltra1);
                        cmd.Parameters.AddWithValue("@Typhoid_IgG", flexCheckTyphoidIgG1);
                        cmd.Parameters.AddWithValue("@Typhoid_Ag", flexCheckTyphoidAg1);

                        cmd.ExecuteNonQuery();
                    }

                    // Update prescription status to 'lab-processed' (status = 5)
                    string updateStatusQuery = @"
                        UPDATE prescribtion 
                        SET [status] = 5 
                        WHERE prescid = (SELECT prescid FROM lab_test WHERE med_id = @id)";
                    
                    using (SqlCommand statusCmd = new SqlCommand(updateStatusQuery, conn))
                    {
                        statusCmd.Parameters.AddWithValue("@id", id);
                        statusCmd.ExecuteNonQuery();
                    }
                }

                return resultsExist ? "Data Updated Successfully" : "Results Saved Successfully";
            }
            catch (Exception ex)
            {
                return "An error occurred: " + ex.Message;
            }
        }
    }
}