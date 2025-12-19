-- QUICK FIX: Add prescriptions to all test patients
USE juba_clinick1;
GO

-- First, make sure we have a doctor (needed for prescriptions)
IF NOT EXISTS (SELECT 1 FROM doctor WHERE doctorid = 1)
BEGIN
    PRINT 'Creating default doctor...';
    INSERT INTO doctor (doctorname, doctortitle, specialization, username, password)
    VALUES ('Dr. Ahmed', 'General Practitioner', 'General Medicine', 'doctor1', 'doctor123');
    PRINT 'Doctor created with ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Doctor already exists.';
END
GO

-- Add prescriptions for ALL active patients who don't have one
DECLARE @patientId INT;
DECLARE @prescId INT;
DECLARE @count INT = 0;

-- Get the doctor ID
DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);

PRINT '';
PRINT 'Adding prescriptions...';

-- Loop through all active patients without prescriptions
DECLARE @patientsToFix TABLE (patientid INT);
INSERT INTO @patientsToFix
SELECT p.patientid
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE pr.prescid IS NULL AND p.patient_status = 0;

SELECT @count = COUNT(*) FROM @patientsToFix;
PRINT 'Found ' + CAST(@count AS VARCHAR) + ' patients needing prescriptions.';
PRINT '';

DECLARE fix_cursor CURSOR FOR
SELECT patientid FROM @patientsToFix;

OPEN fix_cursor;
FETCH NEXT FROM fix_cursor INTO @patientId;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Add prescription
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid)
    VALUES (@patientId, @doctorId, 0, 0, 0, 0);
    
    SET @prescId = SCOPE_IDENTITY();
    
    -- Add sample medication
    INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
    VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', 'Take after meals', @prescId, GETDATE());
    
    PRINT 'Patient ' + CAST(@patientId AS VARCHAR) + ' → Prescription ' + CAST(@prescId AS VARCHAR) + ' ✓';
    
    FETCH NEXT FROM fix_cursor INTO @patientId;
END;

CLOSE fix_cursor;
DEALLOCATE fix_cursor;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION - Patients and Prescriptions:';
PRINT '========================================';

SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    pr.prescid,
    COUNT(m.medid) as medication_count
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN medication m ON pr.prescid = m.prescid
WHERE p.patient_status = 0
GROUP BY p.patientid, p.full_name, p.patient_type, pr.prescid
ORDER BY p.patientid;

PRINT '';
PRINT '✓ All active patients now have prescriptions!';
PRINT '✓ Refresh browser and try Print Summary again.';
GO
