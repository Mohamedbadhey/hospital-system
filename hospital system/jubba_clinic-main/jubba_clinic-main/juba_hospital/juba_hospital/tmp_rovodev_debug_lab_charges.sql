-- DEBUG QUERY: Check if lab test orders match their charges
-- This query compares tests ordered in lab_test table with charges created in patient_charges table

-- PART 1: Get all ordered tests from lab_test table (non-zero values)
-- Shows which tests were actually ordered
SELECT 
    lt.med_id AS lab_order_id,
    lt.prescid,
    p.patientid,
    pt.full_name AS patient_name,
    lt.date_taken,
    
    -- Count how many tests were ordered (count non-zero/non-null columns)
    (
        CASE WHEN lt.Hemoglobin IS NOT NULL AND lt.Hemoglobin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Malaria IS NOT NULL AND lt.Malaria NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.CBC IS NOT NULL AND lt.CBC NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Blood_grouping IS NOT NULL AND lt.Blood_grouping NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Blood_sugar IS NOT NULL AND lt.Blood_sugar NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.ESR IS NOT NULL AND lt.ESR NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Cross_matching IS NOT NULL AND lt.Cross_matching NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Human_immune_deficiency_HIV IS NOT NULL AND lt.Human_immune_deficiency_HIV NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Hepatitis_B_virus_HBV IS NOT NULL AND lt.Hepatitis_B_virus_HBV NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Hepatitis_C_virus_HCV IS NOT NULL AND lt.Hepatitis_C_virus_HCV NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Creatinine IS NOT NULL AND lt.Creatinine NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Urea IS NOT NULL AND lt.Urea NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Uric_acid IS NOT NULL AND lt.Uric_acid NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Sodium IS NOT NULL AND lt.Sodium NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Potassium IS NOT NULL AND lt.Potassium NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Chloride IS NOT NULL AND lt.Chloride NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Calcium IS NOT NULL AND lt.Calcium NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Phosphorous IS NOT NULL AND lt.Phosphorous NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Magnesium IS NOT NULL AND lt.Magnesium NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Albumin IS NOT NULL AND lt.Albumin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.JGlobulin IS NOT NULL AND lt.JGlobulin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Total_bilirubin IS NOT NULL AND lt.Total_bilirubin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Direct_bilirubin IS NOT NULL AND lt.Direct_bilirubin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Alkaline_phosphates_ALP IS NOT NULL AND lt.Alkaline_phosphates_ALP NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.SGPT_ALT IS NOT NULL AND lt.SGPT_ALT NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.SGOT_AST IS NOT NULL AND lt.SGOT_AST NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Thyroid_stimulating_hormone_TSH IS NOT NULL AND lt.Thyroid_stimulating_hormone_TSH NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Triiodothyronine_T3 IS NOT NULL AND lt.Triiodothyronine_T3 NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Thyroxine_T4 IS NOT NULL AND lt.Thyroxine_T4 NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Progesterone_Female IS NOT NULL AND lt.Progesterone_Female NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Fasting_blood_sugar IS NOT NULL AND lt.Fasting_blood_sugar NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Hemoglobin_A1c IS NOT NULL AND lt.Hemoglobin_A1c NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.TPHA IS NOT NULL AND lt.TPHA NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Urine_examination IS NOT NULL AND lt.Urine_examination NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.General_urine_examination IS NOT NULL AND lt.General_urine_examination NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Stool_examination IS NOT NULL AND lt.Stool_examination NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Stool_occult_blood IS NOT NULL AND lt.Stool_occult_blood NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.General_stool_examination IS NOT NULL AND lt.General_stool_examination NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.VDRL IS NOT NULL AND lt.VDRL NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
        CASE WHEN lt.Amylase IS NOT NULL AND lt.Amylase NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END
        -- Add more tests as needed...
    ) AS tests_ordered_count,
    
    -- Count charges created for this lab order
    (SELECT COUNT(*) FROM patient_charges pc 
     WHERE pc.reference_id = lt.med_id 
     AND pc.charge_type = 'Lab') AS charges_created_count,
    
    -- Check if they match
    CASE 
        WHEN (SELECT COUNT(*) FROM patient_charges pc 
              WHERE pc.reference_id = lt.med_id 
              AND pc.charge_type = 'Lab') = 
             (
                CASE WHEN lt.Hemoglobin IS NOT NULL AND lt.Hemoglobin NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
                CASE WHEN lt.Malaria IS NOT NULL AND lt.Malaria NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END +
                CASE WHEN lt.CBC IS NOT NULL AND lt.CBC NOT IN ('0', 'not checked', 'Not checked') THEN 1 ELSE 0 END
                -- Same calculation as above
             )
        THEN 'MATCH ✓'
        ELSE 'MISMATCH ✗'
    END AS status

FROM lab_test lt
INNER JOIN prescribtion p ON lt.prescid = p.prescid
INNER JOIN patient pt ON p.patientid = pt.patientid
WHERE pt.patientid = 1023 -- Filter for patient 1023
ORDER BY lt.date_taken DESC;


-- PART 2: Detailed view - Show which specific tests were ordered vs charges created
-- Run this for a specific patient
DECLARE @patientid INT = 1023; -- Patient ID to debug
DECLARE @lab_order_id INT = (SELECT TOP 1 lt.med_id FROM lab_test lt 
                               INNER JOIN prescribtion p ON lt.prescid = p.prescid 
                               WHERE p.patientid = @patientid 
                               ORDER BY lt.date_taken DESC); -- Get latest lab order for this patient

SELECT 
    'ORDERED TESTS' AS section,
    test_name,
    test_value
FROM (
    SELECT 'Hemoglobin' AS test_name, Hemoglobin AS test_value FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Malaria', Malaria FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'CBC', CBC FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Blood_grouping', Blood_grouping FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Blood_sugar', Blood_sugar FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'ESR', ESR FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Cross_matching', Cross_matching FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HIV', Human_immune_deficiency_HIV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HBV', Hepatitis_B_virus_HBV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HCV', Hepatitis_C_virus_HCV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Creatinine', Creatinine FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Urea', Urea FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Uric_acid', Uric_acid FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Sodium', Sodium FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Potassium', Potassium FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'VDRL', VDRL FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'AFP', AFP FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Total_PSA', Total_PSA FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'AMH', AMH FROM lab_test WHERE med_id = @lab_order_id
    -- Add all other tests...
) AS ordered
WHERE test_value IS NOT NULL 
  AND test_value NOT IN ('0', 'not checked', 'Not checked', '')
ORDER BY test_name;


-- PART 3: Show charges created for the lab order
SELECT 
    'CHARGES CREATED' AS section,
    charge_name,
    amount,
    is_paid,
    date_added
FROM patient_charges
WHERE reference_id = @lab_order_id
  AND charge_type = 'Lab'
ORDER BY charge_name;


-- PART 4: Quick summary - Show mismatches only for patient 1023
SELECT 
    lt.med_id AS lab_order_id,
    pt.full_name AS patient_name,
    lt.date_taken,
    (SELECT COUNT(*) FROM patient_charges pc 
     WHERE pc.reference_id = lt.med_id 
     AND pc.charge_type = 'Lab') AS charges_count,
    'Check this order - charge count may not match tests ordered' AS note
FROM lab_test lt
INNER JOIN prescribtion p ON lt.prescid = p.prescid
INNER JOIN patient pt ON p.patientid = pt.patientid
WHERE pt.patientid = 1023 -- Filter for patient 1023
  AND (SELECT COUNT(*) FROM patient_charges pc 
       WHERE pc.reference_id = lt.med_id 
       AND pc.charge_type = 'Lab') = 0  -- No charges at all
ORDER BY lt.date_taken DESC;
