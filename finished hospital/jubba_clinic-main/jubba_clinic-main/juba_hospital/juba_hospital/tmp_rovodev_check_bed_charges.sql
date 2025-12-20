-- Check bed charges for the patient

-- Replace with your patient ID
DECLARE @patientId INT = 1007; -- Change this to your patient ID

-- 1. Check patient details
SELECT 
    patientid,
    full_name,
    patient_type,
    bed_admission_date,
    DATEDIFF(DAY, bed_admission_date, GETDATE()) as days_diff,
    DATEDIFF(DAY, bed_admission_date, GETDATE()) + 1 as days_for_charging
FROM patient
WHERE patientid = @patientId;

-- 2. Check bed charge records
SELECT * FROM patient_bed_charges
WHERE patientid = @patientId
ORDER BY charge_date;

-- 3. Check charges_config for bed rate
SELECT * FROM charges_config
WHERE charge_type = 'Bed' AND is_active = 1;

-- 4. Check patient_charges table
SELECT * FROM patient_charges
WHERE patientid = @patientId
ORDER BY charge_id DESC;
