-- ============================================================================
-- UPDATE PATIENT STATUS SYSTEM
-- ============================================================================
-- New patient_status values:
--   0 = Outpatient
--   1 = Inpatient (Active/Admitted)
--   2 = Discharged
-- ============================================================================

PRINT '========================================';
PRINT 'UPDATING PATIENT STATUS SYSTEM';
PRINT '========================================';
PRINT '';

-- Step 1: Show current data BEFORE changes
PRINT 'STEP 1: Current patient status distribution';
PRINT '----------------------------------------';
SELECT 
    patient_status,
    patient_type,
    COUNT(*) as count
FROM patient
GROUP BY patient_status, patient_type
ORDER BY patient_status, patient_type;
PRINT '';

-- Step 2: Update the status values
PRINT 'STEP 2: Updating patient_status values...';
PRINT '----------------------------------------';

-- First, set all inpatients who are currently status=0 to status=1 (active inpatient)
UPDATE patient
SET patient_status = 1
WHERE patient_type = 'inpatient' 
  AND patient_status = 0;
PRINT 'Updated active inpatients from status 0 to status 1';

-- Set all discharged patients from status=1 to status=2
UPDATE patient
SET patient_status = 2
WHERE patient_status = 1 
  AND patient_type = 'inpatient';
PRINT 'Updated discharged inpatients from status 1 to status 2';

-- Ensure all outpatients have status=0
UPDATE patient
SET patient_status = 0
WHERE patient_type = 'outpatient';
PRINT 'Ensured all outpatients have status 0';

PRINT '';

-- Step 3: Show data AFTER changes
PRINT 'STEP 3: New patient status distribution';
PRINT '----------------------------------------';
SELECT 
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Outpatient'
        WHEN patient_status = 1 THEN 'Inpatient (Active)'
        WHEN patient_status = 2 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    patient_type,
    COUNT(*) as count
FROM patient
GROUP BY patient_status, patient_type
ORDER BY patient_status, patient_type;
PRINT '';

-- Step 4: Verify specific patients
PRINT 'STEP 4: Sample patients by status';
PRINT '----------------------------------------';
SELECT TOP 5
    patientid,
    full_name,
    patient_type,
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Outpatient'
        WHEN patient_status = 1 THEN 'Inpatient (Active)'
        WHEN patient_status = 2 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    bed_admission_date,
    date_registered
FROM patient
WHERE patient_status = 0
ORDER BY patientid DESC;

SELECT TOP 5
    patientid,
    full_name,
    patient_type,
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Outpatient'
        WHEN patient_status = 1 THEN 'Inpatient (Active)'
        WHEN patient_status = 2 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    bed_admission_date,
    date_registered
FROM patient
WHERE patient_status = 1
ORDER BY patientid DESC;

SELECT TOP 5
    patientid,
    full_name,
    patient_type,
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Outpatient'
        WHEN patient_status = 1 THEN 'Inpatient (Active)'
        WHEN patient_status = 2 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    bed_admission_date,
    date_registered
FROM patient
WHERE patient_status = 2
ORDER BY patientid DESC;

PRINT '';
PRINT '========================================';
PRINT 'UPDATE COMPLETE!';
PRINT '========================================';
PRINT '';
PRINT 'New patient_status values:';
PRINT '  0 = Outpatient';
PRINT '  1 = Inpatient (Active/Admitted)';
PRINT '  2 = Discharged';
PRINT '';
PRINT 'Next: Update the ASP.NET pages to use new status values';
