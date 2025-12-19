-- Verify that prescription IDs are loaded correctly
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'CHECKING PRESCRIPTION ID LOADING';
PRINT '========================================';
PRINT '';

-- Test the query for discharged patients
PRINT '1. Discharged Patients with PrescID:';
SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    pr.prescid as prescid_from_join,
    (SELECT TOP 1 prescid FROM prescribtion WHERE patientid = p.patientid ORDER BY prescid DESC) as prescid_from_subquery
FROM patient p
LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
WHERE p.patient_status = 1
ORDER BY p.patientid;

PRINT '';
PRINT '2. Active Inpatients with PrescID:';
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid
FROM patient p
LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
      AND p.patient_status = 0
ORDER BY p.patientid;

PRINT '';
PRINT '3. Check if prescid matches patientid (PROBLEM):';
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    CASE 
        WHEN p.patientid = pr.prescid THEN '❌ SAME (PROBLEM!)'
        WHEN pr.prescid IS NULL THEN '⚠️ NULL (No prescription)'
        ELSE '✅ DIFFERENT (Correct)'
    END as status
FROM patient p
LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0
ORDER BY p.patientid;

PRINT '';
PRINT '4. Raw prescription data:';
SELECT patientid, prescid, doctorid FROM prescribtion ORDER BY patientid, prescid;

PRINT '';
PRINT '========================================';
PRINT 'If prescid = patientid, prescriptions are missing!';
PRINT 'Run QUICK_FIX_PRESCRIPTIONS.sql to fix.';
PRINT '========================================';
