-- Diagnostic SQL to check patient data
-- Run this in SQL Server Management Studio to see what data you have

-- 1. Check all patients and their types
SELECT 
    patientid,
    full_name,
    patient_type,
    patient_status,
    bed_admission_date,
    date_registered
FROM patient
ORDER BY patientid DESC;

-- 2. Count patients by type and status
SELECT 
    ISNULL(patient_type, 'NULL') as patient_type,
    patient_status,
    COUNT(*) as count
FROM patient
GROUP BY patient_type, patient_status
ORDER BY patient_type, patient_status;

-- 3. Check for patients with bed_admission_date (likely inpatients)
SELECT 
    patientid,
    full_name,
    patient_type,
    patient_status,
    bed_admission_date
FROM patient
WHERE bed_admission_date IS NOT NULL
ORDER BY bed_admission_date DESC;

-- 4. Check patient_charges to see what's there
SELECT TOP 20
    pc.patientid,
    p.full_name,
    p.patient_type,
    pc.charge_type,
    pc.amount,
    pc.is_paid
FROM patient_charges pc
INNER JOIN patient p ON pc.patientid = p.patientid
ORDER BY pc.patientid DESC;
