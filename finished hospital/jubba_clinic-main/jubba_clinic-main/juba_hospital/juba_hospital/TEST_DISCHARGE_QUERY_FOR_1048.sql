-- Test the exact SQL queries used in discharge_summary_print.aspx.cs
-- For patientId=1048, prescid=1048
USE juba_clinick1;
GO

DECLARE @patientId INT = 1048;
DECLARE @prescid INT = 1048;

PRINT '========================================';
PRINT 'TESTING DISCHARGE SUMMARY QUERIES';
PRINT 'PatientId: ' + CAST(@patientId AS VARCHAR);
PRINT 'PrescId: ' + CAST(@prescid AS VARCHAR);
PRINT '========================================';
PRINT '';

-- Query 1: Patient and Admission Details
PRINT '1. PATIENT AND ADMISSION DETAILS:';
PRINT '-----------------------------------';
SELECT 
    p.patientid,
    p.full_name,
    p.dob,
    p.sex,
    p.phone,
    p.location,
    p.bed_admission_date,
    GETDATE() as bed_discharge_date,
    DATEDIFF(DAY, p.bed_admission_date, GETDATE()) as days_admitted,
    ISNULL(d.doctorname, 'Unknown Doctor') as doctor_name,
    ISNULL(d.doctortitle, '') as doctortitle
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patientid = @patientId AND pr.prescid = @prescid;

PRINT '';
PRINT 'If no results above, the patient/prescription combination does not exist!';
PRINT '';

-- Query 2: Medications
PRINT '2. MEDICATIONS:';
PRINT '-----------------------------------';
SELECT 
    med_name, 
    dosage, 
    frequency, 
    duration, 
    special_inst 
FROM medication 
WHERE prescid = @prescid;

PRINT '';
PRINT 'If no results, no medications prescribed.';
PRINT '';

-- Query 3: Lab Results
PRINT '3. LAB RESULTS:';
PRINT '-----------------------------------';
-- Note: This query might fail if lab_results table doesn't exist
BEGIN TRY
    DECLARE @labQuery NVARCHAR(MAX) = N'
        SELECT TestName, TestValue 
        FROM lab_results 
        WHERE prescid = @prescid';
    
    EXEC sp_executesql @labQuery, N'@prescid INT', @prescid;
END TRY
BEGIN CATCH
    PRINT 'Lab results query failed or table does not exist:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

-- Query 4: Charges
PRINT '4. CHARGES:';
PRINT '-----------------------------------';
SELECT 
    charge_type,
    charge_name,
    amount,
    is_paid,
    date_added
FROM patient_charges
WHERE patientid = @patientId
ORDER BY date_added;

PRINT '';

-- Summary
PRINT '========================================';
PRINT 'SUMMARY:';
PRINT '========================================';

-- Check if patient exists
IF EXISTS (SELECT 1 FROM patient WHERE patientid = @patientId)
    PRINT '✓ Patient ' + CAST(@patientId AS VARCHAR) + ' exists'
ELSE
    PRINT '✗ Patient ' + CAST(@patientId AS VARCHAR) + ' does NOT exist'

-- Check if prescription exists
IF EXISTS (SELECT 1 FROM prescribtion WHERE prescid = @prescid)
    PRINT '✓ Prescription ' + CAST(@prescid AS VARCHAR) + ' exists'
ELSE
    PRINT '✗ Prescription ' + CAST(@prescid AS VARCHAR) + ' does NOT exist'

-- Check if they are linked
IF EXISTS (SELECT 1 FROM prescribtion WHERE prescid = @prescid AND patientid = @patientId)
    PRINT '✓ Prescription ' + CAST(@prescid AS VARCHAR) + ' is linked to Patient ' + CAST(@patientId AS VARCHAR)
ELSE
    PRINT '✗ Prescription ' + CAST(@prescid AS VARCHAR) + ' is NOT linked to Patient ' + CAST(@patientId AS VARCHAR)

-- Check doctor
DECLARE @doctorId INT = (SELECT doctorid FROM prescribtion WHERE prescid = @prescid);
IF @doctorId IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM doctor WHERE doctorid = @doctorId)
        PRINT '✓ Doctor exists (ID: ' + CAST(@doctorId AS VARCHAR) + ')'
    ELSE
        PRINT '✗ Doctor does NOT exist (ID: ' + CAST(@doctorId AS VARCHAR) + ')'
END
ELSE
    PRINT '⚠ No doctor assigned to prescription'

PRINT '';

-- Medication count
DECLARE @medCount INT = (SELECT COUNT(*) FROM medication WHERE prescid = @prescid);
PRINT 'Medications: ' + CAST(@medCount AS VARCHAR);

-- Charge count
DECLARE @chargeCount INT = (SELECT COUNT(*) FROM patient_charges WHERE patientid = @patientId);
PRINT 'Charges: ' + CAST(@chargeCount AS VARCHAR);

PRINT '';
PRINT '========================================';
PRINT 'END OF TEST';
PRINT '========================================';
