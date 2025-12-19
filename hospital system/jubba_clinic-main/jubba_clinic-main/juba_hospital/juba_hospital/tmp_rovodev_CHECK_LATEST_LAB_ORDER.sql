-- CHECK LATEST LAB ORDER - Verify Tests Ordered vs Charges Created
-- This will show the most recent lab order and compare ordered tests with created charges

-- PART 1: Get the latest lab order details
SELECT TOP 1
    lt.med_id AS lab_order_id,
    lt.prescid,
    p.patientid,
    pt.full_name AS patient_name,
    lt.date_taken,
    lt.processed,
    lt.completed
FROM lab_test lt
INNER JOIN prescribtion p ON lt.prescid = p.prescid
INNER JOIN patient pt ON p.patientid = pt.patientid
ORDER BY lt.date_taken DESC;

-- Store the latest lab order ID for use in other queries
DECLARE @latest_lab_order_id INT = (SELECT TOP 1 med_id FROM lab_test ORDER BY date_taken DESC);

PRINT 'Latest Lab Order ID: ' + CAST(@latest_lab_order_id AS VARCHAR(10));
PRINT '';

-- PART 2: Show ALL test values from lab_test table (to see what was sent from frontend)
SELECT 
    'TEST VALUES IN DATABASE' AS section,
    'Hemoglobin' AS test_name, Hemoglobin AS test_value FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Malaria', Malaria FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'CBC', CBC FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Blood_grouping', Blood_grouping FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Blood_sugar', Blood_sugar FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'ESR', ESR FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Cross_matching', Cross_matching FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'HIV', Human_immune_deficiency_HIV FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'HBV', Hepatitis_B_virus_HBV FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'HCV', Hepatitis_C_virus_HCV FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Creatinine', Creatinine FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Urea', Urea FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Uric_acid', Uric_acid FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Sodium', Sodium FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Potassium', Potassium FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Chloride', Chloride FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Calcium', Calcium FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Phosphorous', Phosphorous FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Magnesium', Magnesium FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Albumin', Albumin FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'JGlobulin', JGlobulin FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Total_bilirubin', Total_bilirubin FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Direct_bilirubin', Direct_bilirubin FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Alkaline_phosphates_ALP', Alkaline_phosphates_ALP FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'SGPT_ALT', SGPT_ALT FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'SGOT_AST', SGOT_AST FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'TSH', Thyroid_stimulating_hormone_TSH FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'T3', Triiodothyronine_T3 FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'T4', Thyroxine_T4 FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Progesterone_Female', Progesterone_Female FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'FSH', Follicle_stimulating_hormone_FSH FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Estradiol', Estradiol FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'LH', Luteinizing_hormone_LH FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Testosterone_Male', Testosterone_Male FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Prolactin', Prolactin FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Brucella_melitensis', Brucella_melitensis FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Brucella_abortus', Brucella_abortus FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'CRP', C_reactive_protein_CRP FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'RF', Rheumatoid_factor_RF FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'ASO', Antistreptolysin_O_ASO FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Toxoplasmosis', Toxoplasmosis FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Hpylori_antibody', Hpylori_antibody FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Stool_occult_blood', Stool_occult_blood FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'General_stool_examination', General_stool_examination FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'General_urine_examination', General_urine_examination FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Fasting_blood_sugar', Fasting_blood_sugar FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Hemoglobin_A1c', Hemoglobin_A1c FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'TPHA', TPHA FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'VDRL', VDRL FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Dengue_Fever', Dengue_Fever_IgG_IgM FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Gonorrhea_Ag', Gonorrhea_Ag FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'AFP', AFP FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Total_PSA', Total_PSA FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'AMH', AMH FROM lab_test WHERE med_id = @latest_lab_order_id
UNION ALL SELECT '', 'Amylase', Amylase FROM lab_test WHERE med_id = @latest_lab_order_id
ORDER BY test_name;

-- PART 3: Show ONLY tests that are NOT "not checked" (these should be the ordered tests)
SELECT 
    'TESTS THAT APPEAR ORDERED' AS section,
    test_name,
    test_value
FROM (
    SELECT 'Hemoglobin' AS test_name, Hemoglobin AS test_value FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Malaria', Malaria FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'CBC', CBC FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Blood_grouping', Blood_grouping FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Blood_sugar', Blood_sugar FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'ESR', ESR FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Cross_matching', Cross_matching FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'HIV', Human_immune_deficiency_HIV FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'HBV', Hepatitis_B_virus_HBV FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'HCV', Hepatitis_C_virus_HCV FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Creatinine', Creatinine FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Urea', Urea FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Uric_acid', Uric_acid FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Sodium', Sodium FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Potassium', Potassium FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'VDRL', VDRL FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'AFP', AFP FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'AMH', AMH FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Total_PSA', Total_PSA FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Albumin', Albumin FROM lab_test WHERE med_id = @latest_lab_order_id
    UNION ALL SELECT 'Amylase', Amylase FROM lab_test WHERE med_id = @latest_lab_order_id
    -- Add more as needed
) AS all_tests
WHERE test_value IS NOT NULL 
  AND LOWER(LTRIM(RTRIM(test_value))) NOT IN ('not checked', '0', '')
  AND test_value NOT LIKE 'not %'
ORDER BY test_name;

-- PART 4: Show charges created for this lab order
SELECT 
    'CHARGES CREATED' AS section,
    charge_id,
    charge_name,
    amount,
    is_paid,
    date_added
FROM patient_charges
WHERE reference_id = @latest_lab_order_id
  AND charge_type = 'Lab'
ORDER BY charge_name;

-- PART 5: Summary comparison
SELECT 
    'SUMMARY' AS section,
    (SELECT COUNT(*) FROM patient_charges 
     WHERE reference_id = @latest_lab_order_id 
     AND charge_type = 'Lab') AS charges_created_count,
    (SELECT SUM(amount) FROM patient_charges 
     WHERE reference_id = @latest_lab_order_id 
     AND charge_type = 'Lab') AS total_charge_amount;
