-- Check patient and prescription IDs to debug the issue
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'CHECKING PATIENT AND PRESCRIPTION IDS';
PRINT '========================================';
PRINT '';

-- Show all patients with their prescriptions
SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    pr.prescid,
    CASE WHEN pr.prescid IS NULL THEN 'NO PRESCRIPTION' ELSE 'Has Prescription' END as status
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0
ORDER BY p.patientid;

PRINT '';
PRINT 'Checking specific patient ID 1046:';

SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    pr.doctorid
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patientid = 1046;

PRINT '';
PRINT 'All prescriptions in database:';
SELECT prescid, patientid, doctorid FROM prescribtion ORDER BY prescid;
