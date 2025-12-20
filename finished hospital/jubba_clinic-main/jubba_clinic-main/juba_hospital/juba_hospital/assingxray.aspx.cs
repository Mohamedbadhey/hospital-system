using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace juba_hospital
{
    public partial class assingxray : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string submitxray(string xrname, string xrydescribtion, string id, string typeimg)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert X-ray order
                    string medicationQuery = @"
                        INSERT INTO xray (xryname, xrydescribtion, prescid, type) 
                        VALUES (@xryname, @xrydescribtion, @prescid, @typeimg)";

                    using (SqlCommand cmd = new SqlCommand(medicationQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@xryname", xrname);
                        cmd.Parameters.AddWithValue("@xrydescribtion", xrydescribtion);
                        cmd.Parameters.AddWithValue("@typeimg", typeimg);
                        cmd.Parameters.AddWithValue("@prescid", id);
                        cmd.ExecuteNonQuery();
                    }

                    // Update prescribtion
                    string patientUpdateQuery = "UPDATE prescribtion SET xray_status = 1 WHERE prescid = @id";

                    using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, con))
                    {
                        cmd1.Parameters.AddWithValue("@id", id);
                        cmd1.ExecuteNonQuery();
                    }

                    return "true";
                }
            }
            catch (Exception ex)
            {
                return "Error in submitxray method: " + ex.Message + " - " + ex.StackTrace;
            }
        }








        [WebMethod]
        public static string updatepatient(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update patient table
                    string patientUpdateQuery = "UPDATE [prescribtion] SET " +
                                                "[status] = 2 " +
                                              "WHERE [prescid] = @id";

                    using (SqlCommand cmd = new SqlCommand(patientUpdateQuery, con))
                    {

                        cmd.Parameters.AddWithValue("@id", id);


                        cmd.ExecuteNonQuery();
                    }


                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error updating patient", ex);
            }
        }



        [WebMethod]
        public static string submitdata(

    string id, string presc,
    string flexCheckGeneralUrineExamination, string flexCheckProgesteroneFemale, string flexCheckAmylase, string flexCheckMagnesium,
    string flexCheckPhosphorous, string flexCheckCalcium, string flexCheckChloride, string flexCheckPotassium,
    string flexCheckSodium, string flexCheckUricAcid, string flexCheckCreatinine, string flexCheckUrea,
    string flexCheckJGlobulin, string flexCheckAlbumin, string flexCheckTotalBilirubin, string flexCheckAlkalinePhosphatesALP,
    string flexCheckSGOTAST, string flexCheckSGPTALT, string flexCheckLiverFunctionTest, string flexCheckTriglycerides,
    string flexCheckTotalCholesterol, string flexCheckHemoglobinA1c, string flexCheckHDL, string flexCheckLDL,
 string flexCheckFSH, string flexCheckEstradiol, string flexCheckLH,
    string flexCheckTestosteroneMale, string flexCheckProlactin, string flexCheckSeminalFluidAnalysis, string flexCheckBHCG,
    string flexCheckUrineExamination, string flexCheckStoolExamination, string flexCheckHemoglobin, string flexCheckMalaria,
    string flexCheckESR, string flexCheckBloodGrouping, string flexCheckBloodSugar, string flexCheckCBC,
    string flexCheckCrossMatching, string flexCheckTPHA, string flexCheckHIV, string flexCheckHBV,
    string flexCheckHCV, string flexCheckBrucellaMelitensis, string flexCheckBrucellaAbortus, string flexCheckCRP,
    string flexCheckRF, string flexCheckASO, string flexCheckToxoplasmosis, string flexCheckTyphoid,
    string flexCheckHpyloriAntibody, string flexCheckStoolOccultBlood, string flexCheckGeneralStoolExamination, string flexCheckThyroidProfile,
    string flexCheckT3, string flexCheckT4, string flexCheckTSH, string flexCheckSpermExamination,
    string flexCheckVirginalSwab, string flexCheckTrichomonasVirginals, string flexCheckHCG, string flexCheckHpyloriAgStool,
    string flexCheckFastingBloodSugar ,  string flexCheckDirectBilirubin)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // Get patientid from prescription
                        SqlCommand getPatientCmd = new SqlCommand("SELECT patientid FROM prescribtion WHERE prescid = @prescid", con, transaction);
                        getPatientCmd.Parameters.AddWithValue("@prescid", presc);
                        object patientIdResult = getPatientCmd.ExecuteScalar();
                        
                        if (patientIdResult == null)
                        {
                            transaction.Rollback();
                            return "Error: Patient not found for this prescription";
                        }
                        
                        string patientId = patientIdResult.ToString();

                        // Insert lab test order
                        string medicationQuery = @"
                            INSERT INTO lab_test (
                                prescid, General_urine_examination, Progesterone_Female, Amylase, Magnesium, Phosphorous,
                                Calcium, Chloride, Potassium, Sodium, Uric_acid, Creatinine, Urea, JGlobulin, Albumin,
                                Total_bilirubin, Alkaline_phosphates_ALP, SGOT_AST, SGPT_ALT, Triglycerides,
                                Total_cholesterol, Hemoglobin_A1c, High_density_lipoprotein_HDL, Low_density_lipoprotein_LDL,
                                Follicle_stimulating_hormone_FSH, Estradiol, Luteinizing_hormone_LH, Testosterone_Male,
                                Prolactin, Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination, Stool_examination, Hemoglobin, Malaria,
                                ESR, Blood_grouping, Blood_sugar, CBC, Cross_matching, TPHA, Human_immune_deficiency_HIV,
                                Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV, Brucella_melitensis, Brucella_abortus, C_reactive_protein_CRP,
                                Rheumatoid_factor_RF, Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG, Hpylori_antibody, Stool_occult_blood,
                                General_stool_examination, Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4, Thyroid_stimulating_hormone_TSH,
                                Sperm_examination, Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG, Hpylori_Ag_stool,
                                Fasting_blood_sugar, Direct_bilirubin
                            ) OUTPUT INSERTED.med_id VALUES (
                                @prescid, @General_urine_examination, @Progesterone_Female, @Amylase, @Magnesium, @Phosphorous,
                                @Calcium, @Chloride, @Potassium, @Sodium, @Uric_acid, @Creatinine, @Urea, @JGlobulin, @Albumin,
                                @Total_bilirubin, @Alkaline_phosphates_ALP, @SGOT_AST, @SGPT_ALT, @Triglycerides,
                                @Total_cholesterol, @Hemoglobin_A1c, @High_density_lipoprotein_HDL, @Low_density_lipoprotein_LDL,
                                @Follicle_stimulating_hormone_FSH, @Estradiol, @Luteinizing_hormone_LH, @Testosterone_Male,
                                @Prolactin, @Seminal_Fluid_Analysis_Male_B_HCG, @Urine_examination, @Stool_examination, @Hemoglobin, @Malaria,
                                @ESR, @Blood_grouping, @Blood_sugar, @CBC, @Cross_matching, @TPHA, @Human_immune_deficiency_HIV,
                                @Hepatitis_B_virus_HBV, @Hepatitis_C_virus_HCV, @Brucella_melitensis, @Brucella_abortus, @C_reactive_protein_CRP,
                                @Rheumatoid_factor_RF, @Antistreptolysin_O_ASO, @Toxoplasmosis, @Typhoid_hCG, @Hpylori_antibody, @Stool_occult_blood,
                                @General_stool_examination, @Thyroid_profile, @Triiodothyronine_T3, @Thyroxine_T4, @Thyroid_stimulating_hormone_TSH,
                                @Sperm_examination, @Virginal_swab_trichomonas_virginals, @Human_chorionic_gonadotropin_hCG, @Hpylori_Ag_stool,
                                @Fasting_blood_sugar, @Direct_bilirubin
                            )";

                        int newOrderId;
                        using (SqlCommand cmd = new SqlCommand(medicationQuery, con, transaction))
                        {
                        cmd.Parameters.AddWithValue("@Direct_bilirubin", flexCheckDirectBilirubin);

                        cmd.Parameters.AddWithValue("@prescid", presc);
                        cmd.Parameters.AddWithValue("@General_urine_examination", flexCheckGeneralUrineExamination);
                        cmd.Parameters.AddWithValue("@Progesterone_Female", flexCheckProgesteroneFemale);
                        cmd.Parameters.AddWithValue("@Amylase", flexCheckAmylase);
                        cmd.Parameters.AddWithValue("@Magnesium", flexCheckMagnesium);
                        cmd.Parameters.AddWithValue("@Phosphorous", flexCheckPhosphorous);
                        cmd.Parameters.AddWithValue("@Calcium", flexCheckCalcium);
                        cmd.Parameters.AddWithValue("@Chloride", flexCheckChloride);
                        cmd.Parameters.AddWithValue("@Potassium", flexCheckPotassium);
                        cmd.Parameters.AddWithValue("@Sodium", flexCheckSodium);
                        cmd.Parameters.AddWithValue("@Uric_acid", flexCheckUricAcid);
                        cmd.Parameters.AddWithValue("@Creatinine", flexCheckCreatinine);
                        cmd.Parameters.AddWithValue("@Urea", flexCheckUrea);
                        cmd.Parameters.AddWithValue("@JGlobulin", flexCheckJGlobulin);
                        cmd.Parameters.AddWithValue("@Albumin", flexCheckAlbumin);
                        cmd.Parameters.AddWithValue("@Total_bilirubin", flexCheckTotalBilirubin);
                        cmd.Parameters.AddWithValue("@Alkaline_phosphates_ALP", flexCheckAlkalinePhosphatesALP);
                        cmd.Parameters.AddWithValue("@SGOT_AST", flexCheckSGOTAST);
                        cmd.Parameters.AddWithValue("@SGPT_ALT", flexCheckSGPTALT);
                 
                        cmd.Parameters.AddWithValue("@Triglycerides", flexCheckTriglycerides);
                        cmd.Parameters.AddWithValue("@Total_cholesterol", flexCheckTotalCholesterol);
                        cmd.Parameters.AddWithValue("@Hemoglobin_A1c", flexCheckHemoglobinA1c);
                        cmd.Parameters.AddWithValue("@High_density_lipoprotein_HDL", flexCheckHDL);
                        cmd.Parameters.AddWithValue("@Low_density_lipoprotein_LDL", flexCheckLDL);
                 
                        cmd.Parameters.AddWithValue("@Follicle_stimulating_hormone_FSH", flexCheckFSH);
                        cmd.Parameters.AddWithValue("@Estradiol", flexCheckEstradiol);
                        cmd.Parameters.AddWithValue("@Luteinizing_hormone_LH", flexCheckLH);
                        cmd.Parameters.AddWithValue("@Testosterone_Male", flexCheckTestosteroneMale);
                        cmd.Parameters.AddWithValue("@Prolactin", flexCheckProlactin);
                        cmd.Parameters.AddWithValue("@Seminal_Fluid_Analysis_Male_B_HCG", flexCheckSeminalFluidAnalysis);
                        cmd.Parameters.AddWithValue("@Urine_examination", flexCheckUrineExamination);
                        cmd.Parameters.AddWithValue("@Stool_examination", flexCheckStoolExamination);
                        cmd.Parameters.AddWithValue("@Hemoglobin", flexCheckHemoglobin);
                        cmd.Parameters.AddWithValue("@Malaria", flexCheckMalaria);
                        cmd.Parameters.AddWithValue("@ESR", flexCheckESR);
                        cmd.Parameters.AddWithValue("@Blood_grouping", flexCheckBloodGrouping);
                        cmd.Parameters.AddWithValue("@Blood_sugar", flexCheckBloodSugar);
                        cmd.Parameters.AddWithValue("@CBC", flexCheckCBC);
                        cmd.Parameters.AddWithValue("@Cross_matching", flexCheckCrossMatching);
                        cmd.Parameters.AddWithValue("@TPHA", flexCheckTPHA);
                        cmd.Parameters.AddWithValue("@Human_immune_deficiency_HIV", flexCheckHIV);
                        cmd.Parameters.AddWithValue("@Hepatitis_B_virus_HBV", flexCheckHBV);
                        cmd.Parameters.AddWithValue("@Hepatitis_C_virus_HCV", flexCheckHCV);
                        cmd.Parameters.AddWithValue("@Brucella_melitensis", flexCheckBrucellaMelitensis);
                        cmd.Parameters.AddWithValue("@Brucella_abortus", flexCheckBrucellaAbortus);
                        cmd.Parameters.AddWithValue("@C_reactive_protein_CRP", flexCheckCRP);
                        cmd.Parameters.AddWithValue("@Rheumatoid_factor_RF", flexCheckRF);
                        cmd.Parameters.AddWithValue("@Antistreptolysin_O_ASO", flexCheckASO);
                        cmd.Parameters.AddWithValue("@Toxoplasmosis", flexCheckToxoplasmosis);
                        cmd.Parameters.AddWithValue("@Typhoid_hCG", flexCheckTyphoid);
                        cmd.Parameters.AddWithValue("@Hpylori_antibody", flexCheckHpyloriAntibody);
                        cmd.Parameters.AddWithValue("@Stool_occult_blood", flexCheckStoolOccultBlood);
                        cmd.Parameters.AddWithValue("@General_stool_examination", flexCheckGeneralStoolExamination);
                        cmd.Parameters.AddWithValue("@Thyroid_profile", flexCheckThyroidProfile);
                        cmd.Parameters.AddWithValue("@Triiodothyronine_T3", flexCheckT3);
                        cmd.Parameters.AddWithValue("@Thyroxine_T4", flexCheckT4);
                        cmd.Parameters.AddWithValue("@Thyroid_stimulating_hormone_TSH", flexCheckTSH);
                        cmd.Parameters.AddWithValue("@Sperm_examination", flexCheckSpermExamination);
                        cmd.Parameters.AddWithValue("@Virginal_swab_trichomonas_virginals", flexCheckVirginalSwab);
                        cmd.Parameters.AddWithValue("@Human_chorionic_gonadotropin_hCG", flexCheckHCG);
                        cmd.Parameters.AddWithValue("@Hpylori_Ag_stool", flexCheckHpyloriAgStool);
                        cmd.Parameters.AddWithValue("@Fasting_blood_sugar", flexCheckFastingBloodSugar);

                            newOrderId = (int)cmd.ExecuteScalar();
                        }

                        // Check if this is a follow-up order
                        SqlCommand checkPrevCmd = new SqlCommand("SELECT COUNT(*) FROM lab_test WHERE prescid = @prescid AND med_id != @currentOrderId", con, transaction);
                        checkPrevCmd.Parameters.AddWithValue("@prescid", presc);
                        checkPrevCmd.Parameters.AddWithValue("@currentOrderId", newOrderId);
                        int previousOrders = (int)checkPrevCmd.ExecuteScalar();
                        bool isFollowup = previousOrders > 0;

                        // Helper method to check if test is actually ordered
                        bool IsTestOrdered(string testValue)
                        {
                            if (string.IsNullOrEmpty(testValue)) return false;
                            string lower = testValue.ToLower().Trim();
                            return lower != "0" && lower != "not checked" && !lower.StartsWith("not ");
                        }

                        // Create INDIVIDUAL charges for each ordered test using the new pricing system
                        var orderedTests = new System.Collections.Generic.Dictionary<string, string>();
                        
                        // Check each test parameter - only add if actually ordered
                        if (IsTestOrdered(flexCheckHemoglobin)) orderedTests.Add("Hemoglobin", flexCheckHemoglobin);
                        if (IsTestOrdered(flexCheckMalaria)) orderedTests.Add("Malaria", flexCheckMalaria);
                        if (IsTestOrdered(flexCheckCBC)) orderedTests.Add("CBC", flexCheckCBC);
                        if (IsTestOrdered(flexCheckBloodGrouping)) orderedTests.Add("Blood_grouping", flexCheckBloodGrouping);
                        if (IsTestOrdered(flexCheckBloodSugar)) orderedTests.Add("Blood_sugar", flexCheckBloodSugar);
                        if (IsTestOrdered(flexCheckESR)) orderedTests.Add("ESR", flexCheckESR);
                        if (IsTestOrdered(flexCheckCrossMatching)) orderedTests.Add("Cross_matching", flexCheckCrossMatching);
                        if (IsTestOrdered(flexCheckHIV)) orderedTests.Add("Human_immune_deficiency_HIV", flexCheckHIV);
                        if (IsTestOrdered(flexCheckHBV)) orderedTests.Add("Hepatitis_B_virus_HBV", flexCheckHBV);
                        if (IsTestOrdered(flexCheckHCV)) orderedTests.Add("Hepatitis_C_virus_HCV", flexCheckHCV);
                        if (IsTestOrdered(flexCheckCreatinine)) orderedTests.Add("Creatinine", flexCheckCreatinine);
                        if (IsTestOrdered(flexCheckUrea)) orderedTests.Add("Urea", flexCheckUrea);
                        if (IsTestOrdered(flexCheckSGPTALT)) orderedTests.Add("SGPT_ALT", flexCheckSGPTALT);
                        if (IsTestOrdered(flexCheckSGOTAST)) orderedTests.Add("SGOT_AST", flexCheckSGOTAST);
                        if (IsTestOrdered(flexCheckTSH)) orderedTests.Add("Thyroid_stimulating_hormone_TSH", flexCheckTSH);
                        if (IsTestOrdered(flexCheckFastingBloodSugar)) orderedTests.Add("Fasting_blood_sugar", flexCheckFastingBloodSugar);
                        if (IsTestOrdered(flexCheckHemoglobinA1c)) orderedTests.Add("Hemoglobin_A1c", flexCheckHemoglobinA1c);
                        if (IsTestOrdered(flexCheckTPHA)) orderedTests.Add("TPHA", flexCheckTPHA);
                        if (IsTestOrdered(flexCheckUrineExamination)) orderedTests.Add("Urine_examination", flexCheckUrineExamination);
                        if (IsTestOrdered(flexCheckStoolExamination)) orderedTests.Add("Stool_examination", flexCheckStoolExamination);
                        if (IsTestOrdered(flexCheckTotalCholesterol)) orderedTests.Add("Total_cholesterol", flexCheckTotalCholesterol);
                        if (IsTestOrdered(flexCheckHDL)) orderedTests.Add("High_density_lipoprotein_HDL", flexCheckHDL);
                        if (IsTestOrdered(flexCheckLDL)) orderedTests.Add("Low_density_lipoprotein_LDL", flexCheckLDL);
                        if (IsTestOrdered(flexCheckTriglycerides)) orderedTests.Add("Triglycerides", flexCheckTriglycerides);

                        // Create individual charge for each ordered test
                        foreach (var test in orderedTests)
                        {
                            string testName = test.Key;
                            decimal testPrice = LabTestPriceCalculator.GetTestPrice(testName);
                            
                            // Get display name
                            string testDisplayName = testName;
                            SqlCommand getDisplayNameCmd = new SqlCommand(
                                "SELECT test_display_name FROM lab_test_prices WHERE test_name = @testName", con, transaction);
                            getDisplayNameCmd.Parameters.AddWithValue("@testName", testName);
                            object displayNameResult = getDisplayNameCmd.ExecuteScalar();
                            if (displayNameResult != null)
                            {
                                testDisplayName = displayNameResult.ToString();
                            }

                            string chargeDescription = isFollowup ? 
                                $"{testDisplayName} - Follow-up" : 
                                testDisplayName;

                            // Insert individual charge
                            SqlCommand insertChargeCmd = new SqlCommand(@"
                                INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, reference_id)
                                VALUES (@patientid, @prescid, 'Lab', @chargeName, @amount, 0, @date_added, @orderId)
                            ", con, transaction);
                            
                            insertChargeCmd.Parameters.AddWithValue("@patientid", patientId);
                            insertChargeCmd.Parameters.AddWithValue("@prescid", presc);
                            insertChargeCmd.Parameters.AddWithValue("@chargeName", chargeDescription);
                            insertChargeCmd.Parameters.AddWithValue("@amount", testPrice);
                            insertChargeCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                            insertChargeCmd.Parameters.AddWithValue("@orderId", newOrderId);
                            insertChargeCmd.ExecuteNonQuery();
                        }

                        // Update prescribtion
                        string patientUpdateQuery = "UPDATE prescribtion SET status = 2, lab_charge_paid = 0 WHERE prescid = @presc";

                        using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, con, transaction))
                        {
                            cmd1.Parameters.AddWithValue("@id", id);
                            cmd1.Parameters.AddWithValue("@presc", presc);
                            cmd1.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        return "true";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error in submitdata method: " + ex.Message + " - " + ex.StackTrace;
            }
        }


    }
}