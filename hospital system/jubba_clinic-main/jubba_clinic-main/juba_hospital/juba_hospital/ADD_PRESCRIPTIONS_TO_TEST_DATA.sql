-- Add prescriptions to test patients
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'ADDING PRESCRIPTIONS TO TEST PATIENTS';
PRINT '========================================';
PRINT '';

-- Check current patients
PRINT 'Current patients without prescriptions:';
SELECT p.patientid, p.full_name, p.patient_type
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE pr.prescid IS NULL AND p.patient_status = 0;
PRINT '';

-- Add prescriptions for patients who don't have one
DECLARE @patientId INT;
DECLARE @newPrescId INT;

-- Cursor to loop through patients without prescriptions
DECLARE patient_cursor CURSOR FOR
SELECT patientid
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE pr.prescid IS NULL AND p.patient_status = 0;

OPEN patient_cursor;
FETCH NEXT FROM patient_cursor INTO @patientId;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Insert prescription
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
    VALUES (@patientId, 1, 0, 0);
    
    SET @newPrescId = SCOPE_IDENTITY();
    
    PRINT 'Added prescription ' + CAST(@newPrescId AS VARCHAR) + ' for patient ' + CAST(@patientId AS VARCHAR);
    
    -- Add a sample medication
    INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
    VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', 'Take after meals', @newPrescId, GETDATE());
    
    FETCH NEXT FROM patient_cursor INTO @patientId;
END;

CLOSE patient_cursor;
DEALLOCATE patient_cursor;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Show all patients with their prescriptions
SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    pr.prescid,
    CASE WHEN pr.prescid IS NOT NULL THEN 'Has Prescription' ELSE 'NO PRESCRIPTION' END as prescription_status
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0
ORDER BY p.patientid;

PRINT '';
PRINT 'Total active patients: ' + CAST((SELECT COUNT(*) FROM patient WHERE patient_status = 0) AS VARCHAR);
PRINT 'Patients with prescriptions: ' + CAST((SELECT COUNT(DISTINCT patientid) FROM prescribtion pr INNER JOIN patient p ON pr.patientid = p.patientid WHERE p.patient_status = 0) AS VARCHAR);
PRINT '';
PRINT '========================================';
PRINT 'COMPLETE! All patients now have prescriptions.';
PRINT 'Refresh your browser and try Print Summary again.';
PRINT '========================================';
GO
