-- FINAL FIX: Recreate all prescriptions with proper IDs
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'FIXING ALL PRESCRIPTION IDs';
PRINT '========================================';
PRINT '';

-- Step 1: Backup current data
PRINT 'Step 1: Creating backups...';
SELECT * INTO prescribtion_backup_final FROM prescribtion;
SELECT * INTO medication_backup_final FROM medication;
PRINT 'Backups created: prescribtion_backup_final, medication_backup_final';
PRINT '';

-- Step 2: Get doctor
PRINT 'Step 2: Getting doctor...';
DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);
IF @doctorId IS NULL
BEGIN
    INSERT INTO doctor (doctorname, doctortitle, specialization, username, password)
    VALUES ('Dr. Ahmed', 'General Practitioner', 'General Medicine', 'doctor1', 'doctor123');
    SET @doctorId = SCOPE_IDENTITY();
    PRINT 'Created doctor with ID: ' + CAST(@doctorId AS VARCHAR);
END
ELSE
    PRINT 'Using existing doctor ID: ' + CAST(@doctorId AS VARCHAR);
PRINT '';

-- Step 3: Store old prescription mappings
PRINT 'Step 3: Saving old prescription data...';
CREATE TABLE #old_prescriptions (
    old_prescid INT,
    patientid INT,
    doctorid INT,
    status INT,
    xray_status INT,
    lab_charge_paid BIT,
    xray_charge_paid BIT
);

INSERT INTO #old_prescriptions
SELECT prescid, patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid
FROM prescribtion;

PRINT 'Saved ' + CAST(@@ROWCOUNT AS VARCHAR) + ' prescription records';
PRINT '';

-- Step 4: Delete all current prescriptions and medications
PRINT 'Step 4: Deleting current data...';
DELETE FROM medication;
PRINT 'Deleted medications';
DELETE FROM prescribtion;
PRINT 'Deleted prescriptions';
PRINT '';

-- Step 5: Reseed to 10000 (way above patient IDs)
PRINT 'Step 5: Reseeding prescription table...';
DBCC CHECKIDENT ('prescribtion', RESEED, 10000);
PRINT 'Prescription table will start from ID 10001';
PRINT '';

-- Step 6: Recreate prescriptions with new IDs
PRINT 'Step 6: Creating new prescriptions...';
CREATE TABLE #new_prescription_mapping (
    old_prescid INT,
    new_prescid INT,
    patientid INT
);

DECLARE @old_prescid INT, @patientid INT, @status INT, @xray_status INT, @lab_charge_paid BIT, @xray_charge_paid BIT, @new_prescid INT;

DECLARE presc_cursor CURSOR FOR
SELECT old_prescid, patientid, status, xray_status, lab_charge_paid, xray_charge_paid
FROM #old_prescriptions
ORDER BY patientid;

OPEN presc_cursor;
FETCH NEXT FROM presc_cursor INTO @old_prescid, @patientid, @status, @xray_status, @lab_charge_paid, @xray_charge_paid;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Insert new prescription
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid)
    VALUES (@patientid, @doctorId, @status, @xray_status, @lab_charge_paid, @xray_charge_paid);
    
    SET @new_prescid = SCOPE_IDENTITY();
    
    -- Store mapping
    INSERT INTO #new_prescription_mapping VALUES (@old_prescid, @new_prescid, @patientid);
    
    FETCH NEXT FROM presc_cursor INTO @old_prescid, @patientid, @status, @xray_status, @lab_charge_paid, @xray_charge_paid;
END;

CLOSE presc_cursor;
DEALLOCATE presc_cursor;

PRINT 'Created ' + CAST((SELECT COUNT(*) FROM prescribtion) AS VARCHAR) + ' new prescriptions';
PRINT '';

-- Step 7: Recreate medications with new prescription IDs
PRINT 'Step 7: Recreating medications...';
INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
SELECT 
    m.med_name, 
    m.dosage, 
    m.frequency, 
    m.duration, 
    m.special_inst, 
    npm.new_prescid,
    m.date_taken
FROM medication_backup_final m
INNER JOIN #new_prescription_mapping npm ON m.prescid = npm.old_prescid;

PRINT 'Recreated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' medications';
PRINT '';

-- Step 8: Update patient_charges references
PRINT 'Step 8: Updating patient_charges references...';
UPDATE pc
SET pc.prescid = npm.new_prescid
FROM patient_charges pc
INNER JOIN #new_prescription_mapping npm ON pc.prescid = npm.old_prescid;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' charge records';
PRINT '';

-- Step 9: Update other related tables if they exist
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'lab_test')
BEGIN
    UPDATE lt
    SET lt.prescid = npm.new_prescid
    FROM lab_test lt
    INNER JOIN #new_prescription_mapping npm ON lt.prescid = npm.old_prescid;
    PRINT 'Updated lab_test references';
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'lab_results')
BEGIN
    UPDATE lr
    SET lr.prescid = npm.new_prescid
    FROM lab_results lr
    INNER JOIN #new_prescription_mapping npm ON lr.prescid = npm.old_prescid;
    PRINT 'Updated lab_results references';
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'presxray')
BEGIN
    UPDATE px
    SET px.prescid = npm.new_prescid
    FROM presxray px
    INNER JOIN #new_prescription_mapping npm ON px.prescid = npm.old_prescid;
    PRINT 'Updated presxray references';
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'xray_results')
BEGIN
    UPDATE xr
    SET xr.prescid = npm.new_prescid
    FROM xray_results xr
    INNER JOIN #new_prescription_mapping npm ON xr.prescid = npm.old_prescid;
    PRINT 'Updated xray_results references';
END

PRINT '';

-- Step 10: Verification
PRINT '========================================';
PRINT 'VERIFICATION - Before vs After';
PRINT '========================================';
PRINT '';

PRINT 'Sample of new prescription IDs:';
SELECT TOP 10
    patientid as 'Patient ID',
    old_prescid as 'Old Presc ID',
    new_prescid as 'New Presc ID',
    CASE 
        WHEN patientid = old_prescid THEN '❌ Was Same'
        ELSE '✅ Was Different'
    END as 'Old Status',
    CASE 
        WHEN patientid = new_prescid THEN '❌ Still Same (ERROR!)'
        ELSE '✅ Now Different (FIXED!)'
    END as 'New Status'
FROM #new_prescription_mapping
ORDER BY patientid DESC;

PRINT '';
PRINT 'Specific patients you were testing:';
SELECT 
    p.patientid as 'Patient ID',
    p.full_name as 'Patient Name',
    pr.prescid as 'Prescription ID',
    CASE 
        WHEN p.patientid = pr.prescid THEN '❌ STILL SAME (ERROR!)'
        ELSE '✅ DIFFERENT (FIXED!)'
    END as 'Status'
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patientid IN (1046, 1047, 1048)
ORDER BY p.patientid;

PRINT '';
PRINT 'All patient/prescription mappings:';
SELECT 
    p.patientid,
    pr.prescid,
    CASE 
        WHEN p.patientid = pr.prescid THEN '❌ Problem'
        ELSE '✅ Correct'
    END as status
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
ORDER BY p.patientid;

-- Cleanup temp tables
DROP TABLE #old_prescriptions;
DROP TABLE #new_prescription_mapping;

PRINT '';
PRINT '========================================';
PRINT '✅ COMPLETE!';
PRINT 'All prescriptions now have IDs starting from 10001';
PRINT 'Patient IDs and Prescription IDs are now different!';
PRINT '';
PRINT 'Backups are in: prescribtion_backup_final, medication_backup_final';
PRINT '';
PRINT 'Now rebuild your Visual Studio project and test!';
PRINT '========================================';
GO
