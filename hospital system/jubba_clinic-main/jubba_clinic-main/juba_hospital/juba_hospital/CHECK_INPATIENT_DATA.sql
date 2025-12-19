-- Check for inpatient data in juba_clinick1 database
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'CHECKING INPATIENT DATA';
PRINT '========================================';
PRINT '';

-- 1. Check all patients
PRINT '1. TOTAL PATIENTS IN DATABASE:';
SELECT COUNT(*) as total_patients FROM patient;
PRINT '';

-- 2. Check patient_type values
PRINT '2. PATIENT TYPES:';
SELECT 
    ISNULL(patient_type, 'NULL') as patient_type,
    COUNT(*) as count
FROM patient
GROUP BY patient_type;
PRINT '';

-- 3. Check patient_status values
PRINT '3. PATIENT STATUS:';
SELECT 
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Active'
        WHEN patient_status = 1 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    COUNT(*) as count
FROM patient
GROUP BY patient_status;
PRINT '';

-- 4. Check patients with bed_admission_date
PRINT '4. PATIENTS WITH BED ADMISSION DATE:';
SELECT 
    patientid,
    full_name,
    patient_type,
    patient_status,
    bed_admission_date,
    DATEDIFF(DAY, bed_admission_date, GETDATE()) as days_ago
FROM patient
WHERE bed_admission_date IS NOT NULL
ORDER BY bed_admission_date DESC;
PRINT '';

-- 5. Check what the query should return
PRINT '5. WHAT THE INPATIENTS PAGE QUERY RETURNS:';
SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    p.patient_status,
    p.bed_admission_date,
    CASE 
        WHEN p.patient_type = 'inpatient' THEN 'Matches inpatient type'
        WHEN p.bed_admission_date IS NOT NULL THEN 'Has bed admission'
        ELSE 'Does not match'
    END as matches_criteria,
    CASE 
        WHEN p.patient_status = 0 THEN 'Active (will show)'
        WHEN p.patient_status = 1 THEN 'Discharged (will NOT show)'
        ELSE 'Unknown status'
    END as status_meaning
FROM patient p
WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
      AND p.patient_status = 0;
PRINT '';

-- 6. Check all patients details
PRINT '6. ALL PATIENTS DETAILS:';
SELECT 
    patientid,
    full_name,
    patient_type,
    patient_status,
    bed_admission_date,
    date_registered
FROM patient
ORDER BY patientid DESC;
PRINT '';

PRINT '========================================';
PRINT 'DIAGNOSIS COMPLETE';
PRINT '========================================';
