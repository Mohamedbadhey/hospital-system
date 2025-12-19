-- Fix Patient 1023's Lab Order #40 - Remove Extra Charges
-- This patient has 83 charges but only ordered 19 tests

-- First, let's see what we're going to delete
SELECT 
    charge_id,
    charge_name,
    amount,
    date_added
FROM patient_charges
WHERE reference_id = 40 
  AND charge_type = 'Lab'
  AND is_paid = 0
  AND charge_name NOT IN (
    'AFP (Alpha-Fetoprotein)',
    'AMH (Anti-Mullerian Hormone)',
    'Blood Grouping',
    'Blood Sugar (Random)',
    'Complete Blood Count (CBC)',
    'Creatinine',
    'Cross Matching',
    'Erythrocyte Sedimentation Rate (ESR)',
    'Hepatitis B (HBsAg)',
    'Hepatitis C (HCV)',
    'Hemoglobin (Hb)',
    'HIV Test',
    'Malaria Test',
    'Potassium (K+)',
    'Sodium (Na+)',
    'PSA (Prostate Specific Antigen)',
    'Urea',
    'Uric Acid',
    'VDRL (Syphilis)'
);

-- Now delete the extra charges that were NOT actually ordered
DELETE FROM patient_charges
WHERE reference_id = 40 
  AND charge_type = 'Lab'
  AND is_paid = 0
  AND charge_name NOT IN (
    'AFP (Alpha-Fetoprotein)',
    'AMH (Anti-Mullerian Hormone)',
    'Blood Grouping',
    'Blood Sugar (Random)',
    'Complete Blood Count (CBC)',
    'Creatinine',
    'Cross Matching',
    'Erythrocyte Sedimentation Rate (ESR)',
    'Hepatitis B (HBsAg)',
    'Hepatitis C (HCV)',
    'Hemoglobin (Hb)',
    'HIV Test',
    'Malaria Test',
    'Potassium (K+)',
    'Sodium (Na+)',
    'PSA (Prostate Specific Antigen)',
    'Urea',
    'Uric Acid',
    'VDRL (Syphilis)'
);

-- Verify the fix
SELECT 
    'After Fix' AS status,
    COUNT(*) AS remaining_charges,
    SUM(amount) AS total_amount
FROM patient_charges
WHERE reference_id = 40 
  AND charge_type = 'Lab';

-- Show remaining charges
SELECT 
    charge_id,
    charge_name,
    amount
FROM patient_charges
WHERE reference_id = 40 
  AND charge_type = 'Lab'
ORDER BY charge_name;
