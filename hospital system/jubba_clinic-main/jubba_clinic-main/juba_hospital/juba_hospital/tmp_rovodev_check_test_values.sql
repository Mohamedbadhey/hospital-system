-- Check actual values stored in lab_test table for patient 1023, lab order 40
SELECT 
    'Hemoglobin' AS test_name, Hemoglobin AS test_value FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'Albumin', Albumin FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'Amylase', Amylase FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'AFP', AFP FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'AMH', AMH FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'Blood_grouping', Blood_grouping FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'Blood_sugar', Blood_sugar FROM lab_test WHERE med_id = 40
UNION ALL SELECT 'VDRL', VDRL FROM lab_test WHERE med_id = 40
ORDER BY test_name;

-- This will show us what values are stored for ORDERED tests vs NOT ORDERED tests
