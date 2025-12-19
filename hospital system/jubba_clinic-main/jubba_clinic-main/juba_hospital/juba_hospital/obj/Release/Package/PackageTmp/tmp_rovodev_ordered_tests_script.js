// Function to display ordered tests and create dynamic input fields (GLOBAL SCOPE)
window.displayOrderedTestsAndInputs = function(data) {
    var orderedTestsList = $('#orderedTestsList');
    var orderedTestsInputs = $('#orderedTestsInputs');
    
    orderedTestsList.empty();
    orderedTestsInputs.empty();
    
    var orderedTests = [];
    var testLabels = getTestLabelsMap();
    
    // Find all ordered tests (where value is not "not checked")
    for (var key in data) {
        if (data.hasOwnProperty(key) && key !== 'med_id' && key !== 'prescid' && key !== 'date_taken') {
            if (data[key] !== "not checked") {
                var testName = testLabels[key] || key.replace(/_/g, ' ');
                orderedTests.push({
                    key: key,
                    name: testName
                });
            }
        }
    }
    
    // Display ordered tests badges
    if (orderedTests.length > 0) {
        orderedTests.forEach(function(test) {
            orderedTestsList.append('<span class="ordered-test-badge"><i class="fa fa-check-circle"></i> ' + test.name + '</span>');
        });
        
        // Create input fields for each ordered test
        orderedTests.forEach(function(test, index) {
            var inputId = 'input_' + test.key;
            var colClass = 'col-md-6';
            
            var inputHtml = '<div class="' + colClass + '">' +
                '<div class="test-input-group">' +
                '<label for="' + inputId + '">' +
                '<i class="fa fa-flask text-info"></i> ' + test.name +
                '</label>' +
                '<input type="text" class="form-control" id="' + inputId + '" ' +
                'data-test-key="' + test.key + '" placeholder="Enter result value">' +
                '</div>' +
                '</div>';
            
            orderedTestsInputs.append(inputHtml);
        });
    } else {
        orderedTestsList.html('<div class="alert alert-warning"><i class="fa fa-exclamation-triangle"></i> No lab tests were ordered for this patient.</div>');
        orderedTestsInputs.html('<div class="alert alert-info">No tests to enter results for.</div>');
    }
}

// Function to get test labels mapping (GLOBAL SCOPE)
window.getTestLabelsMap = function() {
    return {
        "Low_density_lipoprotein_LDL": "Low-density lipoprotein (LDL)",
        "High_density_lipoprotein_HDL": "High-density lipoprotein (HDL)",
        "Total_cholesterol": "Total Cholesterol",
        "Triglycerides": "Triglycerides",
        "SGPT_ALT": "SGPT (ALT)",
        "SGOT_AST": "SGOT (AST)",
        "Alkaline_phosphates_ALP": "Alkaline Phosphatase (ALP)",
        "Total_bilirubin": "Total Bilirubin",
        "Direct_bilirubin": "Direct Bilirubin",
        "Albumin": "Albumin",
        "JGlobulin": "Globulin",
        "Urea": "Urea",
        "Creatinine": "Creatinine",
        "Uric_acid": "Uric Acid",
        "Sodium": "Sodium (Na+)",
        "Potassium": "Potassium (K+)",
        "Chloride": "Chloride (Cl-)",
        "Calcium": "Calcium",
        "Phosphorous": "Phosphorous",
        "Magnesium": "Magnesium",
        "Amylase": "Amylase",
        "Hemoglobin": "Hemoglobin",
        "Malaria": "Malaria Test",
        "ESR": "ESR (Erythrocyte Sedimentation Rate)",
        "Blood_grouping": "Blood Grouping",
        "Blood_sugar": "Blood Sugar",
        "CBC": "CBC (Complete Blood Count)",
        "Cross_matching": "Cross Matching",
        "TPHA": "TPHA",
        "Human_immune_deficiency_HIV": "HIV Test",
        "Hepatitis_B_virus_HBV": "Hepatitis B (HBV)",
        "Hepatitis_C_virus_HCV": "Hepatitis C (HCV)",
        "Brucella_melitensis": "Brucella Melitensis",
        "Brucella_abortus": "Brucella Abortus",
        "C_reactive_protein_CRP": "C-Reactive Protein (CRP)",
        "Rheumatoid_factor_RF": "Rheumatoid Factor (RF)",
        "Antistreptolysin_O_ASO": "ASO (Antistreptolysin O)",
        "Toxoplasmosis": "Toxoplasmosis",
        "Typhoid_hCG": "Typhoid",
        "Hpylori_antibody": "H. Pylori Antibody",
        "Stool_occult_blood": "Stool Occult Blood",
        "General_stool_examination": "General Stool Examination",
        "Thyroid_profile": "Thyroid Profile",
        "Triiodothyronine_T3": "T3 (Triiodothyronine)",
        "Thyroxine_T4": "T4 (Thyroxine)",
        "Thyroid_stimulating_hormone_TSH": "TSH (Thyroid Stimulating Hormone)",
        "Progesterone_Female": "Progesterone (Female)",
        "Follicle_stimulating_hormone_FSH": "FSH (Follicle Stimulating Hormone)",
        "Estradiol": "Estradiol",
        "Luteinizing_hormone_LH": "LH (Luteinizing Hormone)",
        "Testosterone_Male": "Testosterone (Male)",
        "Prolactin": "Prolactin",
        "Seminal_Fluid_Analysis_Male_B_HCG": "Seminal Fluid Analysis",
        "Urine_examination": "Urine Examination",
        "Stool_examination": "Stool Examination",
        "Sperm_examination": "Sperm Examination",
        "Virginal_swab_trichomonas_virginals": "Vaginal Swab",
        "Human_chorionic_gonadotropin_hCG": "hCG (Pregnancy Test)",
        "Hpylori_Ag_stool": "H. Pylori Antigen (Stool)",
        "Fasting_blood_sugar": "Fasting Blood Sugar",
        "Hemoglobin_A1c": "Hemoglobin A1c (HbA1c)",
        "General_urine_examination": "General Urine Examination",
        "Clinical_path": "Clinical Pathology"
    };
}

// Save button handler for ordered tests
$(document).ready(function() {
    $('#saveOrderedResults').click(function() {
        var prescid = $('#id111').val();
        var medid = $('#medid').val();
        
        if (!prescid || !medid) {
            Swal.fire('Error', 'Please select a patient first', 'error');
            return;
        }
        
        // Collect all input values
        var testResults = {};
        $('#orderedTestsInputs input[data-test-key]').each(function() {
            var key = $(this).data('test-key');
            var value = $(this).val().trim();
            testResults[key] = value || '';
        });
        
        // Prepare data for submission (all 60+ fields)
        var submitData = {
            id: medid,
            flexCheckGeneralUrineExamination1: testResults.General_urine_examination || '',
            flexCheckProgesteroneFemale1: testResults.Progesterone_Female || '',
            flexCheckAmylase1: testResults.Amylase || '',
            flexCheckMagnesium1: testResults.Magnesium || '',
            flexCheckPhosphorous1: testResults.Phosphorous || '',
            flexCheckCalcium1: testResults.Calcium || '',
            flexCheckChloride1: testResults.Chloride || '',
            flexCheckPotassium1: testResults.Potassium || '',
            flexCheckSodium1: testResults.Sodium || '',
            flexCheckUricAcid1: testResults.Uric_acid || '',
            flexCheckCreatinine1: testResults.Creatinine || '',
            flexCheckUrea1: testResults.Urea || '',
            flexCheckJGlobulin1: testResults.JGlobulin || '',
            flexCheckAlbumin1: testResults.Albumin || '',
            flexCheckTotalBilirubin1: testResults.Total_bilirubin || '',
            flexCheckAlkalinePhosphatesALP1: testResults.Alkaline_phosphates_ALP || '',
            flexCheckSGOTAST1: testResults.SGOT_AST || '',
            flexCheckSGPTALT1: testResults.SGPT_ALT || '',
            flexCheckLiverFunctionTest1: testResults.Liver_function_test || '',
            flexCheckTriglycerides1: testResults.Triglycerides || '',
            flexCheckTotalCholesterol1: testResults.Total_cholesterol || '',
            flexCheckHemoglobinA1c1: testResults.Hemoglobin_A1c || '',
            flexCheckHDL1: testResults.High_density_lipoprotein_HDL || '',
            flexCheckLDL1: testResults.Low_density_lipoprotein_LDL || '',
            flexCheckFSH1: testResults.Follicle_stimulating_hormone_FSH || '',
            flexCheckEstradiol1: testResults.Estradiol || '',
            flexCheckLH1: testResults.Luteinizing_hormone_LH || '',
            flexCheckTestosteroneMale1: testResults.Testosterone_Male || '',
            flexCheckProlactin1: testResults.Prolactin || '',
            flexCheckSeminalFluidAnalysis1: testResults.Seminal_Fluid_Analysis_Male_B_HCG || '',
            flexCheckBHCG1: testResults.Clinical_path || '',
            flexCheckUrineExamination1: testResults.Urine_examination || '',
            flexCheckStoolExamination1: testResults.Stool_examination || '',
            flexCheckHemoglobin1: testResults.Hemoglobin || '',
            flexCheckMalaria1: testResults.Malaria || '',
            flexCheckESR1: testResults.ESR || '',
            flexCheckBloodGrouping1: testResults.Blood_grouping || '',
            flexCheckBloodSugar1: testResults.Blood_sugar || '',
            flexCheckCBC1: testResults.CBC || '',
            flexCheckCrossMatching1: testResults.Cross_matching || '',
            flexCheckTPHA1: testResults.TPHA || '',
            flexCheckHIV1: testResults.Human_immune_deficiency_HIV || '',
            flexCheckHBV1: testResults.Hepatitis_B_virus_HBV || '',
            flexCheckHCV1: testResults.Hepatitis_C_virus_HCV || '',
            flexCheckBrucellaMelitensis1: testResults.Brucella_melitensis || '',
            flexCheckBrucellaAbortus1: testResults.Brucella_abortus || '',
            flexCheckCRP1: testResults.C_reactive_protein_CRP || '',
            flexCheckRF1: testResults.Rheumatoid_factor_RF || '',
            flexCheckASO1: testResults.Antistreptolysin_O_ASO || '',
            flexCheckToxoplasmosis1: testResults.Toxoplasmosis || '',
            flexCheckTyphoid1: testResults.Typhoid_hCG || '',
            flexCheckHpyloriAntibody1: testResults.Hpylori_antibody || '',
            flexCheckStoolOccultBlood1: testResults.Stool_occult_blood || '',
            flexCheckGeneralStoolExamination1: testResults.General_stool_examination || '',
            flexCheckThyroidProfile1: testResults.Thyroid_profile || '',
            flexCheckT31: testResults.Triiodothyronine_T3 || '',
            flexCheckT41: testResults.Thyroxine_T4 || '',
            flexCheckTSH1: testResults.Thyroid_stimulating_hormone_TSH || '',
            flexCheckSpermExamination1: testResults.Sperm_examination || '',
            flexCheckVirginalSwab1: testResults.Virginal_swab_trichomonas_virginals || '',
            flexCheckTrichomonasVirginals1: '',
            flexCheckHCG1: testResults.Human_chorionic_gonadotropin_hCG || '',
            flexCheckHpyloriAgStool1: testResults.Hpylori_Ag_stool || '',
            flexCheckFastingBloodSugar1: testResults.Fasting_blood_sugar || '',
            flexCheckDirectBilirubin1: testResults.Direct_bilirubin || ''
        };
        
        // Submit via AJAX
        $.ajax({
            type: "POST",
            url: "test_details.aspx/updatetest",
            data: JSON.stringify(submitData),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(response) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: 'Lab test results saved successfully',
                    confirmButtonText: 'OK'
                }).then(function() {
                    location.reload();
                });
            },
            error: function(response) {
                Swal.fire('Error', 'Failed to save results: ' + response.responseText, 'error');
            }
        });
    });
});
