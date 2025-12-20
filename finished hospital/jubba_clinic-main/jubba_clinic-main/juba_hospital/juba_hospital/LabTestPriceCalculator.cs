using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace juba_hospital
{
    /// <summary>
    /// Helper class to calculate lab test charges based on individual test prices
    /// </summary>
    public static class LabTestPriceCalculator
    {
        /// <summary>
        /// Gets the price for a single test
        /// </summary>
        public static decimal GetTestPrice(string testName)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = @"
                    SELECT test_price 
                    FROM lab_test_prices 
                    WHERE test_name = @testName AND is_active = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@testName", testName);
                    object result = cmd.ExecuteScalar();
                    
                    if (result != null && result != DBNull.Value)
                    {
                        return Convert.ToDecimal(result);
                    }
                    
                    // Return default price if test not found
                    return 5.00m;
                }
            }
        }

        /// <summary>
        /// Calculates total charge for all ordered tests in a lab order
        /// </summary>
        public static LabOrderChargeBreakdown CalculateLabOrderTotal(int labOrderId)
        {
            LabOrderChargeBreakdown breakdown = new LabOrderChargeBreakdown
            {
                LabOrderId = labOrderId,
                TestCharges = new List<TestCharge>()
            };

            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get all ordered tests from lab_test table
                string query = @"
                    SELECT * FROM lab_test WHERE med_id = @labOrderId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@labOrderId", labOrderId);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            // List of all possible test columns
                            string[] testColumns = GetAllTestColumns();

                            foreach (string testColumn in testColumns)
                            {
                                if (dr[testColumn] != DBNull.Value)
                                {
                                    string testValue = dr[testColumn].ToString().Trim().ToLower();
                                    
                                    // Check if test is actually ordered
                                    // Only count as ordered if value contains actual data or "ordered" keyword
                                    // Ignore "not checked", "0", empty, null
                                    bool isOrdered = !string.IsNullOrEmpty(testValue) && 
                                                     testValue != "0" && 
                                                     testValue != "not checked" &&
                                                     !testValue.StartsWith("not ");
                                    
                                    if (isOrdered)
                                    {
                                        decimal testPrice = GetTestPrice(testColumn);
                                        
                                        breakdown.TestCharges.Add(new TestCharge
                                        {
                                            TestName = testColumn,
                                            TestDisplayName = GetTestDisplayName(testColumn),
                                            Price = testPrice
                                        });
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Calculate total
            breakdown.TotalAmount = breakdown.TestCharges.Sum(t => t.Price);

            return breakdown;
        }

        /// <summary>
        /// Gets display name for a test from lab_test_prices table
        /// </summary>
        private static string GetTestDisplayName(string testName)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = @"
                    SELECT test_display_name 
                    FROM lab_test_prices 
                    WHERE test_name = @testName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@testName", testName);
                    object result = cmd.ExecuteScalar();
                    
                    if (result != null && result != DBNull.Value)
                    {
                        return result.ToString();
                    }
                    
                    return testName; // Return column name if display name not found
                }
            }
        }

        /// <summary>
        /// Returns all test column names from lab_test table
        /// </summary>
        private static string[] GetAllTestColumns()
        {
            return new string[]
            {
                // Hematology
                "Hemoglobin", "Malaria", "ESR", "Blood_grouping", "Blood_sugar", "CBC", "Cross_matching",
                
                // Biochemistry - Lipid Profile
                "Lipid_profile", "Low_density_lipoprotein_LDL", "High_density_lipoprotein_HDL", 
                "Total_cholesterol", "Triglycerides",
                
                // Biochemistry - Liver Function
                "Liver_function_test", "SGPT_ALT", "SGOT_AST", "Alkaline_phosphates_ALP", 
                "Total_bilirubin", "Direct_bilirubin", "Albumin", "JGlobulin",
                
                // Biochemistry - Renal Function
                "Renal_profile", "Urea", "Creatinine", "Uric_acid",
                
                // Biochemistry - Electrolytes
                "Electrolytes", "Sodium", "Potassium", "Chloride", "Calcium", "Phosphorous", "Magnesium",
                
                // Biochemistry - Pancreatic
                "Pancreases", "Amylase",
                
                // Immunology/Virology
                "Immunology_Virology", "TPHA", "Human_immune_deficiency_HIV", "Hepatitis_B_virus_HBV",
                "Hepatitis_C_virus_HCV", "Brucella_melitensis", "Brucella_abortus", "C_reactive_protein_CRP",
                "Rheumatoid_factor_RF", "Antistreptolysin_O_ASO", "Toxoplasmosis", "Typhoid_hCG",
                "Hpylori_antibody", "VDRL", "Dengue_Fever_IgG_IgM", "Gonorrhea_Ag",
                
                // Parasitology
                "Parasitology", "Stool_occult_blood", "General_stool_examination",
                
                // Hormones - Thyroid
                "Hormones", "Thyroid_profile", "Triiodothyronine_T3", "Thyroxine_T4", "Thyroid_stimulating_hormone_TSH",
                
                // Hormones - Fertility
                "Fertility_profile", "Progesterone_Female", "Follicle_stimulating_hormone_FSH",
                "Estradiol", "Luteinizing_hormone_LH", "Testosterone_Male", "Prolactin",
                "Seminal_Fluid_Analysis_Male_B_HCG", "AMH",
                
                // New Tests
                "Electrolyte_Test", "CRP_Titer", "Ultra", "Typhoid_IgG", "Typhoid_Ag",
                
                // Clinical Pathology
                "Clinical_path", "Urine_examination", "Stool_examination", "Sperm_examination",
                "Virginal_swab_trichomonas_virginals", "Human_chorionic_gonadotropin_hCG",
                "Hpylori_Ag_stool", "General_urine_examination",
                
                // Diabetes
                "Diabetes", "Fasting_blood_sugar", "Hemoglobin_A1c",
                
                // Cardiac Markers
                "Troponin_I", "CK_MB",
                
                // Coagulation
                "aPTT", "INR", "D_Dimer",
                
                // Vitamins
                "Vitamin_D", "Vitamin_B12", "Ferritin",
                
                // Tumor Markers
                "AFP", "Total_PSA",
                
                // Other
                "Biochemistry", "Hematology"
            };
        }

        /// <summary>
        /// Creates itemized charges in patient_charges table for a lab order
        /// </summary>
        public static bool CreateLabCharges(int patientId, int prescId, int labOrderId)
        {
            try
            {
                LabOrderChargeBreakdown breakdown = CalculateLabOrderTotal(labOrderId);

                if (breakdown.TestCharges.Count == 0)
                {
                    return false; // No tests ordered
                }

                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Create individual charge entry for each test
                    foreach (TestCharge testCharge in breakdown.TestCharges)
                    {
                        string invoiceNumber = "LAB-" + DateTime.Now.ToString("yyyyMMdd") + "-" + prescId;
                        string chargeName = testCharge.TestDisplayName;

                        string insertQuery = @"
                            INSERT INTO patient_charges 
                            (patientid, prescid, charge_type, charge_name, amount, is_paid, 
                             invoice_number, date_added, last_updated, reference_id)
                            VALUES 
                            (@patientid, @prescid, 'Lab', @charge_name, @amount, 0, 
                             @invoice_number, GETDATE(), GETDATE(), @reference_id)";

                        using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@patientid", patientId);
                            cmd.Parameters.AddWithValue("@prescid", prescId);
                            cmd.Parameters.AddWithValue("@charge_name", chargeName);
                            cmd.Parameters.AddWithValue("@amount", testCharge.Price);
                            cmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                            cmd.Parameters.AddWithValue("@reference_id", labOrderId);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }

    /// <summary>
    /// Represents the charge breakdown for a lab order
    /// </summary>
    public class LabOrderChargeBreakdown
    {
        public int LabOrderId { get; set; }
        public List<TestCharge> TestCharges { get; set; }
        public decimal TotalAmount { get; set; }
    }

    /// <summary>
    /// Represents a single test charge
    /// </summary>
    public class TestCharge
    {
        public string TestName { get; set; }
        public string TestDisplayName { get; set; }
        public decimal Price { get; set; }
    }
}
