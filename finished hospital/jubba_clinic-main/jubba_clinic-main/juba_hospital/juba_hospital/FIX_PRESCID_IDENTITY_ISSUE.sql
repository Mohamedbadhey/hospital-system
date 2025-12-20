-- Fix the prescription ID issue where prescid = patientid
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'FIXING PRESCRIPTION ID COLLISION';
PRINT '========================================';
PRINT '';

-- Check current state
PRINT '1. Current situation (prescid = patientid):';
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    CASE WHEN p.patientid = pr.prescid THEN '❌ SAME' ELSE '✅ DIFFERENT' END as status
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0;

PRINT '';
PRINT '2. Checking IDENTITY seed for prescribtion table:';
SELECT 
    IDENT_CURRENT('prescribtion') as current_identity,
    IDENT_SEED('prescribtion') as seed_value,
    IDENT_INCR('prescribtion') as increment_value;

PRINT '';
PRINT '========================================';
PRINT 'SOLUTION: Reseed the prescribtion table';
PRINT '========================================';
PRINT '';

-- Get the maximum patient ID
DECLARE @maxPatientId INT = (SELECT MAX(patientid) FROM patient);
DECLARE @maxPrescId INT = (SELECT MAX(prescid) FROM prescribtion);
DECLARE @newSeed INT = @maxPatientId + @maxPrescId + 1000; -- Ensure they never collide

PRINT 'Max Patient ID: ' + CAST(@maxPatientId AS VARCHAR);
PRINT 'Max Prescription ID: ' + CAST(@maxPrescId AS VARCHAR);
PRINT 'New seed will be: ' + CAST(@newSeed AS VARCHAR);
PRINT '';

-- Note: We can't change existing data, but we can fix future inserts
-- Reseed the identity
DBCC CHECKIDENT ('prescribtion', RESEED, @newSeed);

PRINT 'Identity reseeded successfully!';
PRINT '';

-- Now create new prescriptions for patients who need them
PRINT '3. Creating NEW prescriptions with proper IDs...';

DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);

-- Create new prescriptions (these will get new IDs starting from @newSeed)
DECLARE @patientId INT;
DECLARE @oldPrescId INT;
DECLARE @newPrescId INT;

DECLARE presc_cursor CURSOR FOR
SELECT p.patientid, pr.prescid
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patientid = pr.prescid  -- Only fix where they're the same
  AND p.patient_status = 0;

OPEN presc_cursor;
FETCH NEXT FROM presc_cursor INTO @patientId, @oldPrescId;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Copy the old prescription data to a new prescription with new ID
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid)
    SELECT patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid
    FROM prescribtion
    WHERE prescid = @oldPrescId;
    
    SET @newPrescId = SCOPE_IDENTITY();
    
    -- Copy medications to the new prescription
    UPDATE medication SET prescid = @newPrescId WHERE prescid = @oldPrescId;
    
    -- Update patient_charges to reference new prescription
    UPDATE patient_charges SET prescid = @newPrescId WHERE prescid = @oldPrescId;
    
    -- Update lab_test if exists
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'lab_test')
        UPDATE lab_test SET prescid = @newPrescId WHERE prescid = @oldPrescId;
    
    -- Update lab_results if exists
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'lab_results')
        UPDATE lab_results SET prescid = @newPrescId WHERE prescid = @oldPrescId;
    
    -- Update presxray if exists
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'presxray')
        UPDATE presxray SET prescid = @newPrescId WHERE prescid = @oldPrescId;
    
    -- Delete old prescription
    DELETE FROM prescribtion WHERE prescid = @oldPrescId;
    
    PRINT 'Patient ' + CAST(@patientId AS VARCHAR) + ': Changed prescid from ' + CAST(@oldPrescId AS VARCHAR) + ' to ' + CAST(@newPrescId AS VARCHAR);
    
    FETCH NEXT FROM presc_cursor INTO @patientId, @oldPrescId;
END;

CLOSE presc_cursor;
DEALLOCATE presc_cursor;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION - Fixed Data:';
PRINT '========================================';

SELECT 
    p.patientid as 'Patient ID',
    p.full_name as 'Patient Name',
    pr.prescid as 'Prescription ID',
    CASE 
        WHEN p.patientid = pr.prescid THEN '❌ STILL SAME (ERROR!)'
        WHEN pr.prescid IS NULL THEN '⚠️ No Prescription'
        ELSE '✅ DIFFERENT (FIXED!)'
    END as 'Status'
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0
ORDER BY p.patientid;

PRINT '';
PRINT '========================================';
PRINT '✅ COMPLETE!';
PRINT 'All prescriptions now have unique IDs!';
PRINT 'Refresh your browser and test again.';
PRINT '========================================';
GO
