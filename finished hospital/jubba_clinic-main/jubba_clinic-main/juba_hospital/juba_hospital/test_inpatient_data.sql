-- Test script to check inpatient data
-- Run this in SQL Server Management Studio to diagnose issues

-- 1. Check if there are any patients with patient_status = 1
SELECT COUNT(*) as 'Total Inpatients'
FROM patient 
WHERE patient_status = 1;

-- 2. Check if patients have prescriptions
SELECT 
    p.patientid,
    p.full_name,
    p.patient_status,
    p.bed_admission_date,
    pr.prescid,
    d.doctorid,
    d.fullname as doctor_name
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patient_status = 1;

-- 3. Check all doctors
SELECT doctorid, fullname, username FROM doctor;

-- 4. If no inpatients exist, create a test patient
-- Uncomment and run if needed:
/*
-- First, check available patient and doctor IDs
SELECT TOP 1 patientid FROM patient ORDER BY patientid DESC;
SELECT TOP 1 doctorid FROM doctor ORDER BY doctorid;

-- Then manually update a patient to be inpatient:
UPDATE patient 
SET patient_status = 1, 
    bed_admission_date = GETDATE()
WHERE patientid = 1; -- Replace with actual patient ID

-- Make sure patient has a prescription
SELECT * FROM prescribtion WHERE patientid = 1; -- Check if exists
*/
