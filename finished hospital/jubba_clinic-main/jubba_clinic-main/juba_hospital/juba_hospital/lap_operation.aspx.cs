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
    public partial class lap_operation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string updateLabTest(
    string id, 
    string flexCheckGeneralUrineExamination, string flexCheckProgesteroneFemale, string flexCheckAmylase, string flexCheckMagnesium,
    string flexCheckPhosphorous, string flexCheckCalcium, string flexCheckChloride, string flexCheckPotassium,
    string flexCheckSodium, string flexCheckUricAcid, string flexCheckCreatinine, string flexCheckUrea,
    string flexCheckJGlobulin, string flexCheckAlbumin, string flexCheckTotalBilirubin, string flexCheckAlkalinePhosphatesALP,
    string flexCheckSGOTAST, string flexCheckSGPTALT, string flexCheckTriglycerides,
    string flexCheckTotalCholesterol, string flexCheckHemoglobinA1c, string flexCheckHDL, string flexCheckLDL,
    string flexCheckFSH, string flexCheckEstradiol, string flexCheckLH,
    string flexCheckTestosteroneMale, string flexCheckProlactin, string flexCheckSeminalFluidAnalysis,
    string flexCheckUrineExamination, string flexCheckStoolExamination, string flexCheckHemoglobin, string flexCheckMalaria,
    string flexCheckESR, string flexCheckBloodGrouping, string flexCheckBloodSugar, string flexCheckCBC,
    string flexCheckCrossMatching, string flexCheckTPHA, string flexCheckHIV, string flexCheckHBV,
    string flexCheckHCV, string flexCheckBrucellaMelitensis, string flexCheckBrucellaAbortus, string flexCheckCRP,
    string flexCheckRF, string flexCheckASO, string flexCheckToxoplasmosis, string flexCheckTyphoid,
    string flexCheckHpyloriAntibody, string flexCheckStoolOccultBlood, string flexCheckGeneralStoolExamination, string flexCheckThyroidProfile,
    string flexCheckT3, string flexCheckT4, string flexCheckTSH, string flexCheckSpermExamination,
     string flexCheckTrichomonasVirginals, string flexCheckHCG, string flexCheckHpyloriAgStool,
    string flexCheckFastingBloodSugar, string flexCheckDirectBilirubin,
    string flexCheckTroponinI, string flexCheckCKMB, string flexCheckAPTT, string flexCheckINR, string flexCheckDDimer,
    string flexCheckVitaminD, string flexCheckVitaminB12, string flexCheckFerritin, string flexCheckVDRL,
    string flexCheckDengueFever, string flexCheckGonorrheaAg, string flexCheckAFP, string flexCheckTotalPSA, string flexCheckAMH,
    string flexCheckElectrolyteTest, string flexCheckCRPTiter, string flexCheckUltra, string flexCheckTyphoidIgG, string flexCheckTyphoidAg)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update lab_test table
                    string labTestUpdateQuery = "UPDATE [lab_test] SET " +
                                                "[General_urine_examination] = @General_urine_examination, " +
                                                "[Progesterone_Female] = @Progesterone_Female, " +
                                                "[Amylase] = @Amylase, " +
                                                "[Magnesium] = @Magnesium, " +
                                                "[Phosphorous] = @Phosphorous, " +
                                                "[Calcium] = @Calcium, " +
                                                "[Chloride] = @Chloride, " +
                                                "[Potassium] = @Potassium, " +
                                                "[Sodium] = @Sodium, " +
                                                "[Uric_acid] = @Uric_acid, " +
                                                "[Creatinine] = @Creatinine, " +
                                                "[Urea] = @Urea, " +
                                                "[JGlobulin] = @JGlobulin, " +
                                                "[Albumin] = @Albumin, " +
                                                "[Total_bilirubin] = @Total_bilirubin, " +
                                                "[Alkaline_phosphates_ALP] = @Alkaline_phosphates_ALP, " +
                                                "[SGOT_AST] = @SGOT_AST, " +
                                                "[SGPT_ALT] = @SGPT_ALT, " +
                                                "[Triglycerides] = @Triglycerides, " +
                                                "[Total_cholesterol] = @Total_cholesterol, " +
                                                "[Hemoglobin_A1c] = @Hemoglobin_A1c, " +
                                                "[High_density_lipoprotein_HDL] = @High_density_lipoprotein_HDL, " +
                                                "[Low_density_lipoprotein_LDL] = @Low_density_lipoprotein_LDL, " +
                                                "[Follicle_stimulating_hormone_FSH] = @Follicle_stimulating_hormone_FSH, " +
                                                "[Estradiol] = @Estradiol, " +
                                                "[Luteinizing_hormone_LH] = @Luteinizing_hormone_LH, " +
                                                "[Testosterone_Male] = @Testosterone_Male, " +
                                                "[Prolactin] = @Prolactin, " +
                                                "[Seminal_Fluid_Analysis_Male_B_HCG] = @Seminal_Fluid_Analysis_Male_B_HCG, " +
                                                "[Urine_examination] = @Urine_examination, " +
                                                "[Stool_examination] = @Stool_examination, " +
                                                "[Hemoglobin] = @Hemoglobin, " +
                                                "[Malaria] = @Malaria, " +
                                                "[ESR] = @ESR, " +
                                                "[Blood_grouping] = @Blood_grouping, " +
                                                "[Blood_sugar] = @Blood_sugar, " +
                                                "[CBC] = @CBC, " +
                                                "[Cross_matching] = @Cross_matching, " +
                                                "[TPHA] = @TPHA, " +
                                                "[Human_immune_deficiency_HIV] = @Human_immune_deficiency_HIV, " +
                                                "[Hepatitis_B_virus_HBV] = @Hepatitis_B_virus_HBV, " +
                                                "[Hepatitis_C_virus_HCV] = @Hepatitis_C_virus_HCV, " +
                                                "[Brucella_melitensis] = @Brucella_melitensis, " +
                                                "[Brucella_abortus] = @Brucella_abortus, " +
                                                "[C_reactive_protein_CRP] = @C_reactive_protein_CRP, " +
                                                "[Rheumatoid_factor_RF] = @Rheumatoid_factor_RF, " +
                                                "[Antistreptolysin_O_ASO] = @Antistreptolysin_O_ASO, " +
                                                "[Toxoplasmosis] = @Toxoplasmosis, " +
                                                "[Typhoid_hCG] = @Typhoid_hCG, " +
                                                "[Hpylori_antibody] = @Hpylori_antibody, " +
                                                "[Stool_occult_blood] = @Stool_occult_blood, " +
                                                "[General_stool_examination] = @General_stool_examination, " +
                                                "[Thyroid_profile] = @Thyroid_profile, " +
                                                "[Triiodothyronine_T3] = @Triiodothyronine_T3, " +
                                                "[Thyroxine_T4] = @Thyroxine_T4, " +
                                                "[Thyroid_stimulating_hormone_TSH] = @Thyroid_stimulating_hormone_TSH, " +
                                                "[Sperm_examination] = @Sperm_examination, " +
                                                "[Virginal_swab_trichomonas_virginals] = @Virginal_swab_trichomonas_virginals, " +
                                                "[Human_chorionic_gonadotropin_hCG] = @Human_chorionic_gonadotropin_hCG, " +
                                                "[Hpylori_Ag_stool] = @Hpylori_Ag_stool, " +
                                                "[Fasting_blood_sugar] = @Fasting_blood_sugar, " +
                                                "[Direct_bilirubin] = @Direct_bilirubin, " +
                                                "[Troponin_I] = @Troponin_I, " +
                                                "[CK_MB] = @CK_MB, " +
                                                "[aPTT] = @aPTT, " +
                                                "[INR] = @INR, " +
                                                "[D_Dimer] = @D_Dimer, " +
                                                "[Vitamin_D] = @Vitamin_D, " +
                                                "[Vitamin_B12] = @Vitamin_B12, " +
                                                "[Ferritin] = @Ferritin, " +
                                                "[VDRL] = @VDRL, " +
                                                "[Dengue_Fever_IgG_IgM] = @Dengue_Fever_IgG_IgM, " +
                                                "[Gonorrhea_Ag] = @Gonorrhea_Ag, " +
                                                "[AFP] = @AFP, " +
                                                "[Total_PSA] = @Total_PSA, " +
                                                "[AMH] = @AMH, " +
                                                "[Electrolyte_Test] = @Electrolyte_Test, " +
                                                "[CRP_Titer] = @CRP_Titer, " +
                                                "[Ultra] = @Ultra, " +
                                                "[Typhoid_IgG] = @Typhoid_IgG, " +
                                                "[Typhoid_Ag] = @Typhoid_Ag " +
                                                "WHERE [med_id] = @id";

                    using (SqlCommand cmd = new SqlCommand(labTestUpdateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
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
                        
                        cmd.Parameters.AddWithValue("@Virginal_swab_trichomonas_virginals", flexCheckTrichomonasVirginals);
                        cmd.Parameters.AddWithValue("@Human_chorionic_gonadotropin_hCG", flexCheckHCG);
                        cmd.Parameters.AddWithValue("@Hpylori_Ag_stool", flexCheckHpyloriAgStool);
                        cmd.Parameters.AddWithValue("@Fasting_blood_sugar", flexCheckFastingBloodSugar);
                        cmd.Parameters.AddWithValue("@Direct_bilirubin", flexCheckDirectBilirubin);
                        cmd.Parameters.AddWithValue("@Troponin_I", flexCheckTroponinI);
                        cmd.Parameters.AddWithValue("@CK_MB", flexCheckCKMB);
                        cmd.Parameters.AddWithValue("@aPTT", flexCheckAPTT);
                        cmd.Parameters.AddWithValue("@INR", flexCheckINR);
                        cmd.Parameters.AddWithValue("@D_Dimer", flexCheckDDimer);
                        cmd.Parameters.AddWithValue("@Vitamin_D", flexCheckVitaminD);
                        cmd.Parameters.AddWithValue("@Vitamin_B12", flexCheckVitaminB12);
                        cmd.Parameters.AddWithValue("@Ferritin", flexCheckFerritin);
                        cmd.Parameters.AddWithValue("@VDRL", flexCheckVDRL);
                        cmd.Parameters.AddWithValue("@Dengue_Fever_IgG_IgM", flexCheckDengueFever);
                        cmd.Parameters.AddWithValue("@Gonorrhea_Ag", flexCheckGonorrheaAg);
                        cmd.Parameters.AddWithValue("@AFP", flexCheckAFP);
                        cmd.Parameters.AddWithValue("@Total_PSA", flexCheckTotalPSA);
                        cmd.Parameters.AddWithValue("@AMH", flexCheckAMH);
                        cmd.Parameters.AddWithValue("@Electrolyte_Test", flexCheckElectrolyteTest);
                        cmd.Parameters.AddWithValue("@CRP_Titer", flexCheckCRPTiter);
                        cmd.Parameters.AddWithValue("@Ultra", flexCheckUltra);
                        cmd.Parameters.AddWithValue("@Typhoid_IgG", flexCheckTyphoidIgG);
                        cmd.Parameters.AddWithValue("@Typhoid_Ag", flexCheckTyphoidAg);

                        cmd.ExecuteNonQuery();
                    }

                    // NOW: Manage charges for added/removed tests
                    // Get existing charges for this lab order (with display names)
                    var existingCharges = new System.Collections.Generic.Dictionary<string, int>(); // charge_name -> charge_id
                    string getExistingChargesQuery = @"
                        SELECT charge_id, charge_name FROM patient_charges 
                        WHERE reference_id = @medId AND charge_type = 'Lab' AND is_paid = 0";
                    
                    using (SqlCommand getChargesCmd = new SqlCommand(getExistingChargesQuery, con))
                    {
                        getChargesCmd.Parameters.AddWithValue("@medId", id);
                        using (SqlDataReader dr = getChargesCmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                existingCharges.Add(dr["charge_name"].ToString(), Convert.ToInt32(dr["charge_id"]));
                            }
                        }
                    }

                    // Get patientid and prescid
                    int patientId = 0;
                    int prescId = 0;
                    string getInfoQuery = @"
                        SELECT p.patientid, lt.prescid 
                        FROM lab_test lt
                        INNER JOIN prescribtion p ON lt.prescid = p.prescid
                        WHERE lt.med_id = @medId";
                    
                    using (SqlCommand getInfoCmd = new SqlCommand(getInfoQuery, con))
                    {
                        getInfoCmd.Parameters.AddWithValue("@medId", id);
                        using (SqlDataReader dr = getInfoCmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                patientId = Convert.ToInt32(dr["patientid"]);
                                prescId = Convert.ToInt32(dr["prescid"]);
                            }
                        }
                    }

                    // Helper to check if test is ordered - FIXED VERSION
                    bool IsTestOrdered(string testValue)
                    {
                        if (string.IsNullOrEmpty(testValue)) return false;
                        string lower = testValue.ToLower().Trim();
                        
                        // Explicitly check for "not checked" value from frontend
                        if (lower == "not checked" || lower == "0" || lower.StartsWith("not ")) return false;
                        
                        // IMPORTANT: The frontend should only send values for CHECKED tests
                        // But if we're here, we need to differentiate between:
                        // 1. Checked tests: have values like "AFP (Alpha-fetoprotein)", "Blood grouping", etc.
                        // 2. Database column names that got sent by mistake: single words
                        
                        // The issue: ALL tests in your database have display names stored, even unchecked ones
                        // This means the data in lab_test table already has values for all columns
                        
                        // Since we can't reliably detect from the database values alone,
                        // we MUST rely on the frontend sending ONLY "not checked" for unchecked tests
                        
                        return true;
                    }

                    // Build list of ordered tests from parameters
                    var orderedTests = new System.Collections.Generic.Dictionary<string, string>();
                    var orderedTestDisplayNames = new System.Collections.Generic.HashSet<string>(); // Track display names of ordered tests
                    
                    // Check ALL test parameters (must match all parameters in the method signature)
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
                    if (IsTestOrdered(flexCheckUricAcid)) orderedTests.Add("Uric_acid", flexCheckUricAcid);
                    if (IsTestOrdered(flexCheckSodium)) orderedTests.Add("Sodium", flexCheckSodium);
                    if (IsTestOrdered(flexCheckPotassium)) orderedTests.Add("Potassium", flexCheckPotassium);
                    if (IsTestOrdered(flexCheckChloride)) orderedTests.Add("Chloride", flexCheckChloride);
                    if (IsTestOrdered(flexCheckCalcium)) orderedTests.Add("Calcium", flexCheckCalcium);
                    if (IsTestOrdered(flexCheckPhosphorous)) orderedTests.Add("Phosphorous", flexCheckPhosphorous);
                    if (IsTestOrdered(flexCheckMagnesium)) orderedTests.Add("Magnesium", flexCheckMagnesium);
                    if (IsTestOrdered(flexCheckSGPTALT)) orderedTests.Add("SGPT_ALT", flexCheckSGPTALT);
                    if (IsTestOrdered(flexCheckSGOTAST)) orderedTests.Add("SGOT_AST", flexCheckSGOTAST);
                
                    if (IsTestOrdered(flexCheckAlkalinePhosphatesALP)) orderedTests.Add("Alkaline_phosphates_ALP", flexCheckAlkalinePhosphatesALP);
                    if (IsTestOrdered(flexCheckTotalBilirubin)) orderedTests.Add("Total_bilirubin", flexCheckTotalBilirubin);
                    if (IsTestOrdered(flexCheckDirectBilirubin)) orderedTests.Add("Direct_bilirubin", flexCheckDirectBilirubin);
                    if (IsTestOrdered(flexCheckAlbumin)) orderedTests.Add("Albumin", flexCheckAlbumin);
                    if (IsTestOrdered(flexCheckJGlobulin)) orderedTests.Add("JGlobulin", flexCheckJGlobulin);
                    if (IsTestOrdered(flexCheckTSH)) orderedTests.Add("Thyroid_stimulating_hormone_TSH", flexCheckTSH);
                    if (IsTestOrdered(flexCheckT3)) orderedTests.Add("Triiodothyronine_T3", flexCheckT3);
                    if (IsTestOrdered(flexCheckT4)) orderedTests.Add("Thyroxine_T4", flexCheckT4);
                    if (IsTestOrdered(flexCheckThyroidProfile)) orderedTests.Add("Thyroid_profile", flexCheckThyroidProfile);
                    if (IsTestOrdered(flexCheckFastingBloodSugar)) orderedTests.Add("Fasting_blood_sugar", flexCheckFastingBloodSugar);
                    if (IsTestOrdered(flexCheckHemoglobinA1c)) orderedTests.Add("Hemoglobin_A1c", flexCheckHemoglobinA1c);
                    if (IsTestOrdered(flexCheckTPHA)) orderedTests.Add("TPHA", flexCheckTPHA);
                    if (IsTestOrdered(flexCheckUrineExamination)) orderedTests.Add("Urine_examination", flexCheckUrineExamination);
                    if (IsTestOrdered(flexCheckGeneralUrineExamination)) orderedTests.Add("General_urine_examination", flexCheckGeneralUrineExamination);
                    if (IsTestOrdered(flexCheckStoolExamination)) orderedTests.Add("Stool_examination", flexCheckStoolExamination);
                    if (IsTestOrdered(flexCheckStoolOccultBlood)) orderedTests.Add("Stool_occult_blood", flexCheckStoolOccultBlood);
                    if (IsTestOrdered(flexCheckGeneralStoolExamination)) orderedTests.Add("General_stool_examination", flexCheckGeneralStoolExamination);
                    if (IsTestOrdered(flexCheckTotalCholesterol)) orderedTests.Add("Total_cholesterol", flexCheckTotalCholesterol);
                    if (IsTestOrdered(flexCheckHDL)) orderedTests.Add("High_density_lipoprotein_HDL", flexCheckHDL);
                    if (IsTestOrdered(flexCheckLDL)) orderedTests.Add("Low_density_lipoprotein_LDL", flexCheckLDL);
                    if (IsTestOrdered(flexCheckTriglycerides)) orderedTests.Add("Triglycerides", flexCheckTriglycerides);
                    if (IsTestOrdered(flexCheckProgesteroneFemale)) orderedTests.Add("Progesterone_Female", flexCheckProgesteroneFemale);
                    if (IsTestOrdered(flexCheckFSH)) orderedTests.Add("Follicle_stimulating_hormone_FSH", flexCheckFSH);
                    if (IsTestOrdered(flexCheckEstradiol)) orderedTests.Add("Estradiol", flexCheckEstradiol);
                    if (IsTestOrdered(flexCheckLH)) orderedTests.Add("Luteinizing_hormone_LH", flexCheckLH);
                    if (IsTestOrdered(flexCheckTestosteroneMale)) orderedTests.Add("Testosterone_Male", flexCheckTestosteroneMale);
                    if (IsTestOrdered(flexCheckProlactin)) orderedTests.Add("Prolactin", flexCheckProlactin);
                    if (IsTestOrdered(flexCheckSeminalFluidAnalysis)) orderedTests.Add("Seminal_Fluid_Analysis_Male_B_HCG", flexCheckSeminalFluidAnalysis);
                
                    if (IsTestOrdered(flexCheckSpermExamination)) orderedTests.Add("Sperm_examination", flexCheckSpermExamination);
             
                    if (IsTestOrdered(flexCheckTrichomonasVirginals)) orderedTests.Add("Virginal_swab_trichomonas_virginals", flexCheckTrichomonasVirginals);
                    if (IsTestOrdered(flexCheckHCG)) orderedTests.Add("Human_chorionic_gonadotropin_hCG", flexCheckHCG);
                    if (IsTestOrdered(flexCheckAmylase)) orderedTests.Add("Amylase", flexCheckAmylase);
                    if (IsTestOrdered(flexCheckBrucellaMelitensis)) orderedTests.Add("Brucella_melitensis", flexCheckBrucellaMelitensis);
                    if (IsTestOrdered(flexCheckBrucellaAbortus)) orderedTests.Add("Brucella_abortus", flexCheckBrucellaAbortus);
                    if (IsTestOrdered(flexCheckCRP)) orderedTests.Add("C_reactive_protein_CRP", flexCheckCRP);
                    if (IsTestOrdered(flexCheckRF)) orderedTests.Add("Rheumatoid_factor_RF", flexCheckRF);
                    if (IsTestOrdered(flexCheckASO)) orderedTests.Add("Antistreptolysin_O_ASO", flexCheckASO);
                    if (IsTestOrdered(flexCheckToxoplasmosis)) orderedTests.Add("Toxoplasmosis", flexCheckToxoplasmosis);
                    if (IsTestOrdered(flexCheckTyphoid)) orderedTests.Add("Typhoid_hCG", flexCheckTyphoid);
                    if (IsTestOrdered(flexCheckHpyloriAntibody)) orderedTests.Add("Hpylori_antibody", flexCheckHpyloriAntibody);
                    if (IsTestOrdered(flexCheckHpyloriAgStool)) orderedTests.Add("Hpylori_Ag_stool", flexCheckHpyloriAgStool);
                    if (IsTestOrdered(flexCheckTroponinI)) orderedTests.Add("Troponin_I", flexCheckTroponinI);
                    if (IsTestOrdered(flexCheckCKMB)) orderedTests.Add("CK_MB", flexCheckCKMB);
                    if (IsTestOrdered(flexCheckAPTT)) orderedTests.Add("aPTT", flexCheckAPTT);
                    if (IsTestOrdered(flexCheckINR)) orderedTests.Add("INR", flexCheckINR);
                    if (IsTestOrdered(flexCheckDDimer)) orderedTests.Add("D_Dimer", flexCheckDDimer);
                    if (IsTestOrdered(flexCheckVitaminD)) orderedTests.Add("Vitamin_D", flexCheckVitaminD);
                    if (IsTestOrdered(flexCheckVitaminB12)) orderedTests.Add("Vitamin_B12", flexCheckVitaminB12);
                    if (IsTestOrdered(flexCheckFerritin)) orderedTests.Add("Ferritin", flexCheckFerritin);
                    if (IsTestOrdered(flexCheckVDRL)) orderedTests.Add("VDRL", flexCheckVDRL);
                    if (IsTestOrdered(flexCheckDengueFever)) orderedTests.Add("Dengue_Fever_IgG_IgM", flexCheckDengueFever);
                    if (IsTestOrdered(flexCheckGonorrheaAg)) orderedTests.Add("Gonorrhea_Ag", flexCheckGonorrheaAg);
                    if (IsTestOrdered(flexCheckAFP)) orderedTests.Add("AFP", flexCheckAFP);
                    if (IsTestOrdered(flexCheckTotalPSA)) orderedTests.Add("Total_PSA", flexCheckTotalPSA);
                    if (IsTestOrdered(flexCheckAMH)) orderedTests.Add("AMH", flexCheckAMH);
                    if (IsTestOrdered(flexCheckElectrolyteTest)) orderedTests.Add("Electrolyte_Test", flexCheckElectrolyteTest);
                    if (IsTestOrdered(flexCheckCRPTiter)) orderedTests.Add("CRP_Titer", flexCheckCRPTiter);
                    if (IsTestOrdered(flexCheckUltra)) orderedTests.Add("Ultra", flexCheckUltra);
                    if (IsTestOrdered(flexCheckTyphoidIgG)) orderedTests.Add("Typhoid_IgG", flexCheckTyphoidIgG);
                    if (IsTestOrdered(flexCheckTyphoidAg)) orderedTests.Add("Typhoid_Ag", flexCheckTyphoidAg);

                    // Process ordered tests: create charges for new ones, track display names
                    foreach (var test in orderedTests)
                    {
                        string testName = test.Key;
                        decimal testPrice = LabTestPriceCalculator.GetTestPrice(testName);
                        
                        // Get display name
                        string testDisplayName = testName;
                        SqlCommand getDisplayNameCmd = new SqlCommand(
                            "SELECT test_display_name FROM lab_test_prices WHERE test_name = @testName", con);
                        getDisplayNameCmd.Parameters.AddWithValue("@testName", testName);
                        object displayNameResult = getDisplayNameCmd.ExecuteScalar();
                        if (displayNameResult != null)
                        {
                            testDisplayName = displayNameResult.ToString();
                        }

                        // Track this test as ordered
                        orderedTestDisplayNames.Add(testDisplayName);

                        // Only create charge if it doesn't already exist
                        if (!existingCharges.ContainsKey(testDisplayName))
                        {
                            SqlCommand insertChargeCmd = new SqlCommand(@"
                                INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, reference_id)
                                VALUES (@patientid, @prescid, 'Lab', @chargeName, @amount, 0, @date_added, @orderId)
                            ", con);
                            
                            insertChargeCmd.Parameters.AddWithValue("@patientid", patientId);
                            insertChargeCmd.Parameters.AddWithValue("@prescid", prescId);
                            insertChargeCmd.Parameters.AddWithValue("@chargeName", testDisplayName);
                            insertChargeCmd.Parameters.AddWithValue("@amount", testPrice);
                            insertChargeCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                            insertChargeCmd.Parameters.AddWithValue("@orderId", id);
                            insertChargeCmd.ExecuteNonQuery();
                        }
                    }

                    // Delete charges for tests that were REMOVED (only unpaid charges)
                    foreach (var existingCharge in existingCharges)
                    {
                        string chargeName = existingCharge.Key;
                        int chargeId = existingCharge.Value;

                        // If this charge's test is NOT in the current ordered tests, delete it
                        if (!orderedTestDisplayNames.Contains(chargeName))
                        {
                            SqlCommand deleteChargeCmd = new SqlCommand(@"
                                DELETE FROM patient_charges 
                                WHERE charge_id = @chargeId AND is_paid = 0
                            ", con);
                            
                            deleteChargeCmd.Parameters.AddWithValue("@chargeId", chargeId);
                            deleteChargeCmd.ExecuteNonQuery();

                            System.Diagnostics.Debug.WriteLine($"Deleted charge for removed test: {chargeName}");
                        }
                    }

                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                return "Error in updateLabTest method: " + ex.Message + " - " + ex.StackTrace;
            }
        }


        [WebMethod]
        public static string submitdata(

   string id, string presc,
   string flexCheckGeneralUrineExamination, string flexCheckProgesteroneFemale, string flexCheckAmylase, string flexCheckMagnesium,
   string flexCheckPhosphorous, string flexCheckCalcium, string flexCheckChloride, string flexCheckPotassium,
   string flexCheckSodium, string flexCheckUricAcid, string flexCheckCreatinine, string flexCheckUrea,
   string flexCheckJGlobulin, string flexCheckAlbumin, string flexCheckTotalBilirubin, string flexCheckAlkalinePhosphatesALP,
   string flexCheckSGOTAST, string flexCheckSGPTALT, string flexCheckTriglycerides,
   string flexCheckTotalCholesterol, string flexCheckHemoglobinA1c, string flexCheckHDL, string flexCheckLDL,
string flexCheckFSH, string flexCheckEstradiol, string flexCheckLH,
   string flexCheckTestosteroneMale, string flexCheckProlactin, string flexCheckSeminalFluidAnalysis,
   string flexCheckUrineExamination, string flexCheckStoolExamination, string flexCheckHemoglobin, string flexCheckMalaria,
   string flexCheckESR, string flexCheckBloodGrouping, string flexCheckBloodSugar, string flexCheckCBC,
   string flexCheckCrossMatching, string flexCheckTPHA, string flexCheckHIV, string flexCheckHBV,
   string flexCheckHCV, string flexCheckBrucellaMelitensis, string flexCheckBrucellaAbortus, string flexCheckCRP,
   string flexCheckRF, string flexCheckASO, string flexCheckToxoplasmosis, string flexCheckTyphoid,
   string flexCheckHpyloriAntibody, string flexCheckStoolOccultBlood, string flexCheckGeneralStoolExamination, string flexCheckThyroidProfile,
   string flexCheckT3, string flexCheckT4, string flexCheckTSH, string flexCheckSpermExamination,
    string flexCheckTrichomonasVirginals, string flexCheckHCG, string flexCheckHpyloriAgStool,
   string flexCheckFastingBloodSugar, string flexCheckDirectBilirubin,
   string flexCheckTroponinI, string flexCheckCKMB, string flexCheckAPTT, string flexCheckINR, string flexCheckDDimer,
   string flexCheckVitaminD, string flexCheckVitaminB12, string flexCheckFerritin, string flexCheckVDRL,
   string flexCheckDengueFever, string flexCheckGonorrheaAg, string flexCheckAFP, string flexCheckTotalPSA, string flexCheckAMH,
   string flexCheckElectrolyteTest, string flexCheckCRPTiter, string flexCheckUltra, string flexCheckTyphoidIgG, string flexCheckTyphoidAg)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert into medication table
                    string medicationQuery = @"
                INSERT INTO lab_test (
                    prescid, date_taken, General_urine_examination, Progesterone_Female, Amylase, Magnesium, Phosphorous,
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
                    Fasting_blood_sugar, Direct_bilirubin, Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, 
                    Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                    Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                ) 
                OUTPUT INSERTED.med_id
                VALUES (
                    @prescid, @date_taken, @General_urine_examination, @Progesterone_Female, @Amylase, @Magnesium, @Phosphorous,
                    @Calcium, @Chloride, @Potassium, @Sodium, @Uric_acid, @Creatinine, @Urea, @JGlobulin, @Albumin,
                    @Total_bilirubin, @Alkaline_phosphates_ALP, @SGOT_AST, @SGPT_ALT,  @Triglycerides,
                    @Total_cholesterol, @Hemoglobin_A1c, @High_density_lipoprotein_HDL, @Low_density_lipoprotein_LDL,
      @Follicle_stimulating_hormone_FSH, @Estradiol, @Luteinizing_hormone_LH, @Testosterone_Male,
                    @Prolactin, @Seminal_Fluid_Analysis_Male_B_HCG, @Urine_examination, @Stool_examination, @Hemoglobin, @Malaria,
                    @ESR, @Blood_grouping, @Blood_sugar, @CBC, @Cross_matching, @TPHA, @Human_immune_deficiency_HIV,
                    @Hepatitis_B_virus_HBV, @Hepatitis_C_virus_HCV, @Brucella_melitensis, @Brucella_abortus, @C_reactive_protein_CRP,
                    @Rheumatoid_factor_RF, @Antistreptolysin_O_ASO, @Toxoplasmosis, @Typhoid_hCG, @Hpylori_antibody, @Stool_occult_blood,
                    @General_stool_examination, @Thyroid_profile, @Triiodothyronine_T3, @Thyroxine_T4, @Thyroid_stimulating_hormone_TSH,
                    @Sperm_examination, @Virginal_swab_trichomonas_virginals, @Human_chorionic_gonadotropin_hCG, @Hpylori_Ag_stool,
                    @Fasting_blood_sugar, @Direct_bilirubin, @Troponin_I, @CK_MB, @aPTT, @INR, @D_Dimer, @Vitamin_D, @Vitamin_B12,
                    @Ferritin, @VDRL, @Dengue_Fever_IgG_IgM, @Gonorrhea_Ag, @AFP, @Total_PSA, @AMH,
                    @Electrolyte_Test, @CRP_Titer, @Ultra, @Typhoid_IgG, @Typhoid_Ag
                );";

                    string patientUpdateQuery = "UPDATE [prescribtion] SET " +
                                                "[status] = 4 " +
                                              "WHERE [prescid] = @presc";

                    int newLabOrderId;
                    using (SqlCommand cmd = new SqlCommand(medicationQuery, con))
                    {


                        cmd.Parameters.AddWithValue("@Direct_bilirubin", flexCheckDirectBilirubin);

                        cmd.Parameters.AddWithValue("@prescid", id);
                        cmd.Parameters.AddWithValue("@date_taken", DateTimeHelper.Now);
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
                        cmd.Parameters.AddWithValue(
                          "@Virginal_swab_trichomonas_virginals",
                 flexCheckTrichomonasVirginals
             );

                        cmd.Parameters.AddWithValue("@Human_chorionic_gonadotropin_hCG", flexCheckHCG);
                        cmd.Parameters.AddWithValue("@Hpylori_Ag_stool", flexCheckHpyloriAgStool);
                        cmd.Parameters.AddWithValue("@Fasting_blood_sugar", flexCheckFastingBloodSugar);
                        cmd.Parameters.AddWithValue("@Troponin_I", flexCheckTroponinI);
                        cmd.Parameters.AddWithValue("@CK_MB", flexCheckCKMB);
                        cmd.Parameters.AddWithValue("@aPTT", flexCheckAPTT);
                        cmd.Parameters.AddWithValue("@INR", flexCheckINR);
                        cmd.Parameters.AddWithValue("@D_Dimer", flexCheckDDimer);
                        cmd.Parameters.AddWithValue("@Vitamin_D", flexCheckVitaminD);
                        cmd.Parameters.AddWithValue("@Vitamin_B12", flexCheckVitaminB12);
                        cmd.Parameters.AddWithValue("@Ferritin", flexCheckFerritin);
                        cmd.Parameters.AddWithValue("@VDRL", flexCheckVDRL);
                        cmd.Parameters.AddWithValue("@Dengue_Fever_IgG_IgM", flexCheckDengueFever);
                        cmd.Parameters.AddWithValue("@Gonorrhea_Ag", flexCheckGonorrheaAg);
                        cmd.Parameters.AddWithValue("@AFP", flexCheckAFP);
                        cmd.Parameters.AddWithValue("@Total_PSA", flexCheckTotalPSA);
                        cmd.Parameters.AddWithValue("@AMH", flexCheckAMH);
                        cmd.Parameters.AddWithValue("@Electrolyte_Test", flexCheckElectrolyteTest);
                        cmd.Parameters.AddWithValue("@CRP_Titer", flexCheckCRPTiter);
                        cmd.Parameters.AddWithValue("@Ultra", flexCheckUltra);
                        cmd.Parameters.AddWithValue("@Typhoid_IgG", flexCheckTyphoidIgG);
                        cmd.Parameters.AddWithValue("@Typhoid_Ag", flexCheckTyphoidAg);

                        // Execute and get the new med_id
                        newLabOrderId = (int)cmd.ExecuteScalar();
                    }

                    // Get patient ID from prescription
                    int patientId = 0;
                    SqlCommand getPatientCmd = new SqlCommand(
                        "SELECT patientid FROM prescribtion WHERE prescid = @prescid", con);
                    getPatientCmd.Parameters.AddWithValue("@prescid", id);
                    object patientResult = getPatientCmd.ExecuteScalar();
                    if (patientResult != null)
                    {
                        patientId = Convert.ToInt32(patientResult);
                    }

                    // Helper method to check if test is actually ordered
                    bool IsTestOrdered(string testValue)
                    {
                        if (string.IsNullOrEmpty(testValue)) return false;
                        string lower = testValue.ToLower().Trim();
                        return lower != "0" && lower != "not checked" && !lower.StartsWith("not ");
                    }

                    // Create INDIVIDUAL charges for each ordered test using the new pricing system
                    // Build a dictionary of test parameters and their values
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
                    if (IsTestOrdered(flexCheckUricAcid)) orderedTests.Add("Uric_acid", flexCheckUricAcid);
                    if (IsTestOrdered(flexCheckSodium)) orderedTests.Add("Sodium", flexCheckSodium);
                    if (IsTestOrdered(flexCheckPotassium)) orderedTests.Add("Potassium", flexCheckPotassium);
                    if (IsTestOrdered(flexCheckChloride)) orderedTests.Add("Chloride", flexCheckChloride);
                    if (IsTestOrdered(flexCheckCalcium)) orderedTests.Add("Calcium", flexCheckCalcium);
                    if (IsTestOrdered(flexCheckPhosphorous)) orderedTests.Add("Phosphorous", flexCheckPhosphorous);
                    if (IsTestOrdered(flexCheckMagnesium)) orderedTests.Add("Magnesium", flexCheckMagnesium);
                    if (IsTestOrdered(flexCheckAlbumin)) orderedTests.Add("Albumin", flexCheckAlbumin);
                    if (IsTestOrdered(flexCheckJGlobulin)) orderedTests.Add("JGlobulin", flexCheckJGlobulin);
                    if (IsTestOrdered(flexCheckTotalBilirubin)) orderedTests.Add("Total_bilirubin", flexCheckTotalBilirubin);
                    if (IsTestOrdered(flexCheckDirectBilirubin)) orderedTests.Add("Direct_bilirubin", flexCheckDirectBilirubin);
                    if (IsTestOrdered(flexCheckAlkalinePhosphatesALP)) orderedTests.Add("Alkaline_phosphates_ALP", flexCheckAlkalinePhosphatesALP);
                    if (IsTestOrdered(flexCheckAmylase)) orderedTests.Add("Amylase", flexCheckAmylase);
                    if (IsTestOrdered(flexCheckSGPTALT)) orderedTests.Add("SGPT_ALT", flexCheckSGPTALT);
                    if (IsTestOrdered(flexCheckSGOTAST)) orderedTests.Add("SGOT_AST", flexCheckSGOTAST);
                    if (IsTestOrdered(flexCheckTSH)) orderedTests.Add("Thyroid_stimulating_hormone_TSH", flexCheckTSH);
                    if (IsTestOrdered(flexCheckT3)) orderedTests.Add("Triiodothyronine_T3", flexCheckT3);
                    if (IsTestOrdered(flexCheckT4)) orderedTests.Add("Thyroxine_T4", flexCheckT4);
                    if (IsTestOrdered(flexCheckProgesteroneFemale)) orderedTests.Add("Progesterone_Female", flexCheckProgesteroneFemale);
                    if (IsTestOrdered(flexCheckFSH)) orderedTests.Add("Follicle_stimulating_hormone_FSH", flexCheckFSH);
                    if (IsTestOrdered(flexCheckEstradiol)) orderedTests.Add("Estradiol", flexCheckEstradiol);
                    if (IsTestOrdered(flexCheckLH)) orderedTests.Add("Luteinizing_hormone_LH", flexCheckLH);
                    if (IsTestOrdered(flexCheckTestosteroneMale)) orderedTests.Add("Testosterone_Male", flexCheckTestosteroneMale);
                    if (IsTestOrdered(flexCheckProlactin)) orderedTests.Add("Prolactin", flexCheckProlactin);
                    if (IsTestOrdered(flexCheckBrucellaMelitensis)) orderedTests.Add("Brucella_melitensis", flexCheckBrucellaMelitensis);
                    if (IsTestOrdered(flexCheckBrucellaAbortus)) orderedTests.Add("Brucella_abortus", flexCheckBrucellaAbortus);
                    if (IsTestOrdered(flexCheckCRP)) orderedTests.Add("C_reactive_protein_CRP", flexCheckCRP);
                    if (IsTestOrdered(flexCheckRF)) orderedTests.Add("Rheumatoid_factor_RF", flexCheckRF);
                    if (IsTestOrdered(flexCheckASO)) orderedTests.Add("Antistreptolysin_O_ASO", flexCheckASO);
                    if (IsTestOrdered(flexCheckToxoplasmosis)) orderedTests.Add("Toxoplasmosis", flexCheckToxoplasmosis);
                    if (IsTestOrdered(flexCheckHpyloriAntibody)) orderedTests.Add("Hpylori_antibody", flexCheckHpyloriAntibody);
                    if (IsTestOrdered(flexCheckStoolOccultBlood)) orderedTests.Add("Stool_occult_blood", flexCheckStoolOccultBlood);
                    if (IsTestOrdered(flexCheckGeneralStoolExamination)) orderedTests.Add("General_stool_examination", flexCheckGeneralStoolExamination);
                    if (IsTestOrdered(flexCheckGeneralUrineExamination)) orderedTests.Add("General_urine_examination", flexCheckGeneralUrineExamination);
                    if (IsTestOrdered(flexCheckFastingBloodSugar)) orderedTests.Add("Fasting_blood_sugar", flexCheckFastingBloodSugar);
                    if (IsTestOrdered(flexCheckHemoglobinA1c)) orderedTests.Add("Hemoglobin_A1c", flexCheckHemoglobinA1c);
                    if (IsTestOrdered(flexCheckTPHA)) orderedTests.Add("TPHA", flexCheckTPHA);
                    if (IsTestOrdered(flexCheckUrineExamination)) orderedTests.Add("Urine_examination", flexCheckUrineExamination);
                    if (IsTestOrdered(flexCheckStoolExamination)) orderedTests.Add("Stool_examination", flexCheckStoolExamination);
                    if (IsTestOrdered(flexCheckTotalCholesterol)) orderedTests.Add("Total_cholesterol", flexCheckTotalCholesterol);
                    if (IsTestOrdered(flexCheckHDL)) orderedTests.Add("High_density_lipoprotein_HDL", flexCheckHDL);
                    if (IsTestOrdered(flexCheckLDL)) orderedTests.Add("Low_density_lipoprotein_LDL", flexCheckLDL);
                    if (IsTestOrdered(flexCheckTriglycerides)) orderedTests.Add("Triglycerides", flexCheckTriglycerides);
                    if (IsTestOrdered(flexCheckTroponinI)) orderedTests.Add("Troponin_I", flexCheckTroponinI);
                    if (IsTestOrdered(flexCheckCKMB)) orderedTests.Add("CK_MB", flexCheckCKMB);
                    if (IsTestOrdered(flexCheckVitaminD)) orderedTests.Add("Vitamin_D", flexCheckVitaminD);
                    if (IsTestOrdered(flexCheckVitaminB12)) orderedTests.Add("Vitamin_B12", flexCheckVitaminB12);
                    if (IsTestOrdered(flexCheckFerritin)) orderedTests.Add("Ferritin", flexCheckFerritin);
                    if (IsTestOrdered(flexCheckElectrolyteTest)) orderedTests.Add("Electrolyte_Test", flexCheckElectrolyteTest);
                    if (IsTestOrdered(flexCheckCRPTiter)) orderedTests.Add("CRP_Titer", flexCheckCRPTiter);
                    if (IsTestOrdered(flexCheckUltra)) orderedTests.Add("Ultra", flexCheckUltra);
                    if (IsTestOrdered(flexCheckTyphoidIgG)) orderedTests.Add("Typhoid_IgG", flexCheckTyphoidIgG);
                    if (IsTestOrdered(flexCheckTyphoidAg)) orderedTests.Add("Typhoid_Ag", flexCheckTyphoidAg);
          
                    if (IsTestOrdered(flexCheckThyroidProfile)) orderedTests.Add("Thyroid_profile", flexCheckThyroidProfile);
                
                    if (IsTestOrdered(flexCheckTyphoid)) orderedTests.Add("Typhoid_hCG", flexCheckTyphoid);
                    if (IsTestOrdered(flexCheckTrichomonasVirginals)) orderedTests.Add("Virginal_swab_trichomonas_virginals", flexCheckTrichomonasVirginals);
                    if (IsTestOrdered(flexCheckAPTT)) orderedTests.Add("aPTT", flexCheckAPTT);
                    if (IsTestOrdered(flexCheckINR)) orderedTests.Add("INR", flexCheckINR);
                    if (IsTestOrdered(flexCheckDDimer)) orderedTests.Add("D_Dimer", flexCheckDDimer);
                    if (IsTestOrdered(flexCheckSeminalFluidAnalysis)) orderedTests.Add("Seminal_Fluid_Analysis_Male_B_HCG", flexCheckSeminalFluidAnalysis);
                    if (IsTestOrdered(flexCheckSpermExamination)) orderedTests.Add("Sperm_examination", flexCheckSpermExamination);
                    if (IsTestOrdered(flexCheckHCG)) orderedTests.Add("Human_chorionic_gonadotropin_hCG", flexCheckHCG);
                    if (IsTestOrdered(flexCheckHpyloriAgStool)) orderedTests.Add("Hpylori_Ag_stool", flexCheckHpyloriAgStool);
                    if (IsTestOrdered(flexCheckVDRL)) orderedTests.Add("VDRL", flexCheckVDRL);
                    if (IsTestOrdered(flexCheckDengueFever)) orderedTests.Add("Dengue_Fever_IgG_IgM", flexCheckDengueFever);
                    if (IsTestOrdered(flexCheckGonorrheaAg)) orderedTests.Add("Gonorrhea_Ag", flexCheckGonorrheaAg);
                    if (IsTestOrdered(flexCheckAFP)) orderedTests.Add("AFP", flexCheckAFP);
                    if (IsTestOrdered(flexCheckTotalPSA)) orderedTests.Add("Total_PSA", flexCheckTotalPSA);
                    if (IsTestOrdered(flexCheckAMH)) orderedTests.Add("AMH", flexCheckAMH);
                   
                    // Create individual charge for each ordered test
                    foreach (var test in orderedTests)
                    {
                        string testName = test.Key;
                        decimal testPrice = LabTestPriceCalculator.GetTestPrice(testName);
                        
                        // Get display name
                        string testDisplayName = testName;
                        SqlCommand getDisplayNameCmd = new SqlCommand(
                            "SELECT test_display_name FROM lab_test_prices WHERE test_name = @testName", con);
                        getDisplayNameCmd.Parameters.AddWithValue("@testName", testName);
                        object displayNameResult = getDisplayNameCmd.ExecuteScalar();
                        if (displayNameResult != null)
                        {
                            testDisplayName = displayNameResult.ToString();
                        }

                        // Insert individual charge
                        SqlCommand insertChargeCmd = new SqlCommand(@"
                            INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, reference_id)
                            VALUES (@patientid, @prescid, 'Lab', @chargeName, @amount, 0, @date_added, @orderId)
                        ", con);
                        
                        insertChargeCmd.Parameters.AddWithValue("@patientid", patientId);
                        insertChargeCmd.Parameters.AddWithValue("@prescid", id);
                        insertChargeCmd.Parameters.AddWithValue("@chargeName", testDisplayName);
                        insertChargeCmd.Parameters.AddWithValue("@amount", testPrice);
                        insertChargeCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                        insertChargeCmd.Parameters.AddWithValue("@orderId", newLabOrderId);
                        insertChargeCmd.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, con))
                    {

                        cmd1.Parameters.AddWithValue("@id", id);
                        cmd1.Parameters.AddWithValue("@presc", presc);

                        cmd1.ExecuteNonQuery();
                    }



                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions and return the error message with detailed information
                return "Error in submitdata method: " + ex.Message + " - " + ex.StackTrace;
            }
        }














        public class ptclass1
        {
          

            // Additional lab test properties
            public string med_id { get; set; }
            public string Low_density_lipoprotein_LDL { get; set; }
            public string High_density_lipoprotein_HDL { get; set; }
            public string Total_cholesterol { get; set; }
            public string Triglycerides { get; set; }
            public string SGPT_ALT { get; set; }
            public string SGOT_AST { get; set; }
            public string Alkaline_phosphates_ALP { get; set; }
            public string Total_bilirubin { get; set; }
            public string Direct_bilirubin { get; set; }
            public string Albumin { get; set; }
            public string JGlobulin { get; set; }
            public string Urea { get; set; }
            public string Creatinine { get; set; }
            public string Uric_acid { get; set; }
            public string Sodium { get; set; }
            public string Potassium { get; set; }
            public string Chloride { get; set; }
            public string Calcium { get; set; }
            public string Phosphorous { get; set; }
            public string Magnesium { get; set; }
            public string Amylase { get; set; }
            public string Hemoglobin { get; set; }
            public string Malaria { get; set; }
            public string ESR { get; set; }
            public string Blood_grouping { get; set; }
            public string Blood_sugar { get; set; }
            public string CBC { get; set; }
            public string Cross_matching { get; set; }
            public string TPHA { get; set; }
            public string Human_immune_deficiency_HIV { get; set; }
            public string Hepatitis_B_virus_HBV { get; set; }
            public string Hepatitis_C_virus_HCV { get; set; }
            public string Brucella_melitensis { get; set; }
            public string Brucella_abortus { get; set; }
            public string C_reactive_protein_CRP { get; set; }
            public string Rheumatoid_factor_RF { get; set; }
            public string Antistreptolysin_O_ASO { get; set; }
            public string Toxoplasmosis { get; set; }
            public string Typhoid_hCG { get; set; }
            public string Hpylori_antibody { get; set; }
            public string Stool_occult_blood { get; set; }
            public string General_stool_examination { get; set; }
            public string Thyroid_profile { get; set; }
            public string Triiodothyronine_T3 { get; set; }
            public string Thyroxine_T4 { get; set; }
            public string Thyroid_stimulating_hormone_TSH { get; set; }
            public string Progesterone_Female { get; set; }
            public string Follicle_stimulating_hormone_FSH { get; set; }
            public string Estradiol { get; set; }
            public string Luteinizing_hormone_LH { get; set; }
            public string Testosterone_Male { get; set; }
            public string Prolactin { get; set; }
            public string Seminal_Fluid_Analysis_Male_B_HCG { get; set; }
            public string Urine_examination { get; set; }
            public string Stool_examination { get; set; }
            public string Sperm_examination { get; set; }
            public string Virginal_swab_trichomonas_virginals { get; set; }
            public string Human_chorionic_gonadotropin_hCG { get; set; }
            public string Hpylori_Ag_stool { get; set; }
            public string Fasting_blood_sugar { get; set; }
            public string Hemoglobin_A1c { get; set; }
            public string General_urine_examination { get; set; }
            public string Troponin_I { get; set; }
            public string CK_MB { get; set; }
            public string aPTT { get; set; }
            public string INR { get; set; }
            public string D_Dimer { get; set; }
            public string Vitamin_D { get; set; }
            public string Vitamin_B12 { get; set; }
            public string Ferritin { get; set; }
            public string VDRL { get; set; }
            public string Dengue_Fever_IgG_IgM { get; set; }
            public string Gonorrhea_Ag { get; set; }
            public string AFP { get; set; }
            public string Total_PSA { get; set; }
            public string AMH { get; set; }
            public string Electrolyte_Test { get; set; }
            public string CRP_Titer { get; set; }
            public string Ultra { get; set; }
            public string Typhoid_IgG { get; set; }
            public string Typhoid_Ag { get; set; }
        }


        [WebMethod]
        public static ptclass1[] getlapprocessed(string search , string prescid)
        {
            List<ptclass1> details = new List<ptclass1>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"

	  
	SELECT 
    lab_test.med_id,
    lab_test.Low_density_lipoprotein_LDL,
    lab_test.High_density_lipoprotein_HDL,
    lab_test.Total_cholesterol,
    lab_test.Triglycerides,
    lab_test.SGPT_ALT,
    lab_test.SGOT_AST,
    lab_test.Alkaline_phosphates_ALP,
    lab_test.Total_bilirubin,
    lab_test.Direct_bilirubin,
    lab_test.Albumin,
    lab_test.JGlobulin,
    lab_test.Urea,
    lab_test.Creatinine,
    lab_test.Uric_acid,
    lab_test.Sodium,
    lab_test.Potassium,
    lab_test.Chloride,
    lab_test.Calcium,
    lab_test.Phosphorous,
    lab_test.Magnesium,
    lab_test.Amylase,
    lab_test.Hemoglobin,
    lab_test.Malaria,
    lab_test.ESR,
    lab_test.Blood_grouping,
    lab_test.Blood_sugar,
    lab_test.CBC,
    lab_test.Cross_matching,
    lab_test.TPHA,
    lab_test.Human_immune_deficiency_HIV,
    lab_test.Hepatitis_B_virus_HBV,
    lab_test.Hepatitis_C_virus_HCV,
    lab_test.Brucella_melitensis,
    lab_test.Brucella_abortus,
    lab_test.C_reactive_protein_CRP,
    lab_test.Rheumatoid_factor_RF,
    lab_test.Antistreptolysin_O_ASO,
    lab_test.Toxoplasmosis,
    lab_test.Typhoid_hCG,
    lab_test.Hpylori_antibody,
    lab_test.Stool_occult_blood,
    lab_test.General_stool_examination,
    lab_test.Thyroid_profile,
    lab_test.Triiodothyronine_T3,
    lab_test.Thyroxine_T4,
    lab_test.Thyroid_stimulating_hormone_TSH,
    lab_test.Progesterone_Female,
    lab_test.Follicle_stimulating_hormone_FSH,
    lab_test.Estradiol,
    lab_test.Luteinizing_hormone_LH,
    lab_test.Testosterone_Male,
    lab_test.Prolactin,
    lab_test.Seminal_Fluid_Analysis_Male_B_HCG,
    lab_test.Urine_examination,
    lab_test.Stool_examination,
    lab_test.Sperm_examination,
    lab_test.Virginal_swab_trichomonas_virginals,
    lab_test.Human_chorionic_gonadotropin_hCG,
    lab_test.Hpylori_Ag_stool,
    lab_test.Fasting_blood_sugar,
    lab_test.Hemoglobin_A1c,
    lab_test.General_urine_examination,
    lab_test.Troponin_I,
    lab_test.CK_MB,
    lab_test.aPTT,
    lab_test.INR,
    lab_test.D_Dimer,
    lab_test.Vitamin_D,
    lab_test.Vitamin_B12,
    lab_test.Ferritin,
    lab_test.VDRL,
    lab_test.Dengue_Fever_IgG_IgM,
    lab_test.Gonorrhea_Ag,
    lab_test.AFP,
    lab_test.Total_PSA,
    lab_test.AMH,
    lab_test.Electrolyte_Test,
    lab_test.CRP_Titer,
    lab_test.Ultra,
    lab_test.Typhoid_IgG,
    lab_test.Typhoid_Ag,
    lab_test.prescid,
    lab_test.date_taken
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
LEFT JOIN 
    lab_test ON prescribtion.prescid = lab_test.prescid
WHERE 
    doctor.doctorid = @search
    AND lab_test.prescid = @prescid
ORDER BY 
    lab_test.date_taken DESC;



 ", con);
                cmd.Parameters.AddWithValue("@search", search);

                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ptclass1 field = new ptclass1();


                        field.med_id = dr["med_id"].ToString();
                        field.Low_density_lipoprotein_LDL = dr["Low_density_lipoprotein_LDL"].ToString();
                        field.High_density_lipoprotein_HDL = dr["High_density_lipoprotein_HDL"].ToString();
                        field.Total_cholesterol = dr["Total_cholesterol"].ToString();
                        field.Triglycerides = dr["Triglycerides"].ToString();
                        field.SGPT_ALT = dr["SGPT_ALT"].ToString();
                        field.SGOT_AST = dr["SGOT_AST"].ToString();
                        field.Alkaline_phosphates_ALP = dr["Alkaline_phosphates_ALP"].ToString();
                        field.Total_bilirubin = dr["Total_bilirubin"].ToString();
                        field.Direct_bilirubin = dr["Direct_bilirubin"].ToString();
                        field.Albumin = dr["Albumin"].ToString();
                        field.JGlobulin = dr["JGlobulin"].ToString();
                        field.Urea = dr["Urea"].ToString();
                        field.Creatinine = dr["Creatinine"].ToString();
                        field.Uric_acid = dr["Uric_acid"].ToString();
                        field.Sodium = dr["Sodium"].ToString();
                        field.Potassium = dr["Potassium"].ToString();
                        field.Chloride = dr["Chloride"].ToString();
                        field.Calcium = dr["Calcium"].ToString();
                        field.Phosphorous = dr["Phosphorous"].ToString();
                        field.Magnesium = dr["Magnesium"].ToString();
                        field.Amylase = dr["Amylase"].ToString();
                        field.Hemoglobin = dr["Hemoglobin"].ToString();
                        field.Malaria = dr["Malaria"].ToString();
                        field.ESR = dr["ESR"].ToString();
                        field.Blood_grouping = dr["Blood_grouping"].ToString();
                        field.Blood_sugar = dr["Blood_sugar"].ToString();
                        field.CBC = dr["CBC"].ToString();
                        field.Cross_matching = dr["Cross_matching"].ToString();
                        field.TPHA = dr["TPHA"].ToString();
                        field.Human_immune_deficiency_HIV = dr["Human_immune_deficiency_HIV"].ToString();
                        field.Hepatitis_B_virus_HBV = dr["Hepatitis_B_virus_HBV"].ToString();
                        field.Hepatitis_C_virus_HCV = dr["Hepatitis_C_virus_HCV"].ToString();
                        field.Brucella_melitensis = dr["Brucella_melitensis"].ToString();
                        field.Brucella_abortus = dr["Brucella_abortus"].ToString();
                        field.C_reactive_protein_CRP = dr["C_reactive_protein_CRP"].ToString();
                        field.Rheumatoid_factor_RF = dr["Rheumatoid_factor_RF"].ToString();
                        field.Antistreptolysin_O_ASO = dr["Antistreptolysin_O_ASO"].ToString();
                        field.Toxoplasmosis = dr["Toxoplasmosis"].ToString();
                        field.Typhoid_hCG = dr["Typhoid_hCG"].ToString();
                        field.Hpylori_antibody = dr["Hpylori_antibody"].ToString();
                        field.Stool_occult_blood = dr["Stool_occult_blood"].ToString();
                        field.General_stool_examination = dr["General_stool_examination"].ToString();
                        field.Thyroid_profile = dr["Thyroid_profile"].ToString();
                        field.Triiodothyronine_T3 = dr["Triiodothyronine_T3"].ToString();
                        field.Thyroxine_T4 = dr["Thyroxine_T4"].ToString();
                        field.Thyroid_stimulating_hormone_TSH = dr["Thyroid_stimulating_hormone_TSH"].ToString();
                        field.Progesterone_Female = dr["Progesterone_Female"].ToString();
                        field.Follicle_stimulating_hormone_FSH = dr["Follicle_stimulating_hormone_FSH"].ToString();
                        field.Estradiol = dr["Estradiol"].ToString();
                        field.Luteinizing_hormone_LH = dr["Luteinizing_hormone_LH"].ToString();
                        field.Testosterone_Male = dr["Testosterone_Male"].ToString();
                        field.Prolactin = dr["Prolactin"].ToString();
                        field.Seminal_Fluid_Analysis_Male_B_HCG = dr["Seminal_Fluid_Analysis_Male_B_HCG"].ToString();
                        field.Urine_examination = dr["Urine_examination"].ToString();
                        field.Stool_examination = dr["Stool_examination"].ToString();
                        field.Sperm_examination = dr["Sperm_examination"].ToString();
                        field.Virginal_swab_trichomonas_virginals = dr["Virginal_swab_trichomonas_virginals"].ToString();
                        field.Human_chorionic_gonadotropin_hCG = dr["Human_chorionic_gonadotropin_hCG"].ToString();
                        field.Hpylori_Ag_stool = dr["Hpylori_Ag_stool"].ToString();
                        field.Fasting_blood_sugar = dr["Fasting_blood_sugar"].ToString();
                        field.Hemoglobin_A1c = dr["Hemoglobin_A1c"].ToString();
                        field.General_urine_examination = dr["General_urine_examination"].ToString();
                        field.Troponin_I = dr["Troponin_I"].ToString();
                        field.CK_MB = dr["CK_MB"].ToString();
                        field.aPTT = dr["aPTT"].ToString();
                        field.INR = dr["INR"].ToString();
                        field.D_Dimer = dr["D_Dimer"].ToString();
                        field.Vitamin_D = dr["Vitamin_D"].ToString();
                        field.Vitamin_B12 = dr["Vitamin_B12"].ToString();
                        field.Ferritin = dr["Ferritin"].ToString();
                        field.VDRL = dr["VDRL"].ToString();
                        field.Dengue_Fever_IgG_IgM = dr["Dengue_Fever_IgG_IgM"].ToString();
                        field.Gonorrhea_Ag = dr["Gonorrhea_Ag"].ToString();
                        field.AFP = dr["AFP"].ToString();
                        field.Total_PSA = dr["Total_PSA"].ToString();
                        field.AMH = dr["AMH"].ToString();
                        field.Electrolyte_Test = dr["Electrolyte_Test"].ToString();
                        field.CRP_Titer = dr["CRP_Titer"].ToString();
                        field.Ultra = dr["Ultra"].ToString();
                        field.Typhoid_IgG = dr["Typhoid_IgG"].ToString();
                        field.Typhoid_Ag = dr["Typhoid_Ag"].ToString();

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }
    }
}