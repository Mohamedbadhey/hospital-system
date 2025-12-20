-- Find which charges were created but tests were NOT actually checked/ordered
-- Based on lab order #41 (latest)

DECLARE @lab_order_id INT = 41;

-- Get all charges created
SELECT 
    'CHARGES CREATED' AS section,
    charge_name
FROM patient_charges
WHERE reference_id = @lab_order_id
  AND charge_type = 'Lab'
ORDER BY charge_name;

-- Get tests that appear ordered (not "not checked")
-- Map test column names to their charge names
SELECT 
    'TESTS ORDERED' AS section,
    test_name,
    charge_equivalent
FROM (
    SELECT 'Hemoglobin' AS test_name, 'Hemoglobin (Hb)' AS charge_equivalent, Hemoglobin AS test_value FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Malaria', 'Malaria Test', Malaria FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'CBC', 'Complete Blood Count (CBC)', CBC FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Blood_grouping', 'Blood Grouping', Blood_grouping FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Blood_sugar', 'Blood Sugar (Random)', Blood_sugar FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'ESR', 'Erythrocyte Sedimentation Rate (ESR)', ESR FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Cross_matching', 'Cross Matching', Cross_matching FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HIV', 'HIV Test', Human_immune_deficiency_HIV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HBV', 'Hepatitis B (HBsAg)', Hepatitis_B_virus_HBV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'HCV', 'Hepatitis C (HCV)', Hepatitis_C_virus_HCV FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Creatinine', 'Creatinine', Creatinine FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Urea', 'Urea', Urea FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Uric_acid', 'Uric Acid', Uric_acid FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Sodium', 'Sodium (Na+)', Sodium FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Potassium', 'Potassium (K+)', Potassium FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'AFP', 'AFP (Alpha-Fetoprotein)', AFP FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'AMH', 'AMH (Anti-Mullerian Hormone)', AMH FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Total_PSA', 'PSA (Prostate Specific Antigen)', Total_PSA FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'VDRL', 'VDRL (Syphilis)', VDRL FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Albumin', 'Albumin', Albumin FROM lab_test WHERE med_id = @lab_order_id
    UNION ALL SELECT 'Amylase', 'Amylase', Amylase FROM lab_test WHERE med_id = @lab_order_id
) AS tests
WHERE test_value IS NOT NULL 
  AND LOWER(LTRIM(RTRIM(test_value))) NOT IN ('not checked', '0', '')
  AND test_value NOT LIKE 'not %'
ORDER BY test_name;

-- Find charges that don't have matching ordered tests
-- These are the EXTRA charges
SELECT 
    'EXTRA CHARGES (Should not exist)' AS section,
    pc.charge_id,
    pc.charge_name,
    pc.amount,
    'This charge was created but test was NOT checked' AS issue
FROM patient_charges pc
WHERE pc.reference_id = @lab_order_id
  AND pc.charge_type = 'Lab'
  AND pc.charge_name NOT IN (
    -- List only the charges that should exist based on checked tests
    'Hemoglobin (Hb)',
    'Malaria Test',
    'Complete Blood Count (CBC)',
    'Blood Grouping',
    'Blood Sugar (Random)',
    'Erythrocyte Sedimentation Rate (ESR)',
    'Cross Matching',
    'HIV Test',
    'Hepatitis B (HBsAg)',
    'Hepatitis C (HCV)',
    'Creatinine',
    'Urea',
    'Uric Acid',
    'Sodium (Na+)',
    'Potassium (K+)',
    'AFP (Alpha-Fetoprotein)',
    'AMH (Anti-Mullerian Hormone)',
    'PSA (Prostate Specific Antigen)',
    'VDRL (Syphilis)',
    'Albumin',
    'Amylase'
)
ORDER BY pc.charge_name;

-- Summary count
SELECT 
    'SUMMARY' AS section,
    (SELECT COUNT(*) FROM patient_charges WHERE reference_id = @lab_order_id AND charge_type = 'Lab') AS total_charges_created,
    21 AS tests_actually_ordered,
    (SELECT COUNT(*) FROM patient_charges WHERE reference_id = @lab_order_id AND charge_type = 'Lab') - 21 AS extra_charges
