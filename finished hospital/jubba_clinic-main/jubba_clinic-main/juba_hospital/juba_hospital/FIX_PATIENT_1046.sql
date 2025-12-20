-- Fix patient 1046 prescription issue
USE juba_clinick1;
GO

PRINT 'Checking patient 1046...';

-- Check if patient exists
IF EXISTS (SELECT 1 FROM patient WHERE patientid = 1046)
BEGIN
    PRINT 'Patient 1046 exists.';
    
    SELECT patientid, full_name, patient_type, patient_status FROM patient WHERE patientid = 1046;
    
    -- Check if prescription exists
    IF EXISTS (SELECT 1 FROM prescribtion WHERE patientid = 1046)
    BEGIN
        PRINT 'Patient 1046 already has a prescription:';
        SELECT prescid, patientid, doctorid FROM prescribtion WHERE patientid = 1046;
    END
    ELSE
    BEGIN
        PRINT 'Patient 1046 has NO prescription. Creating one...';
        
        -- Get or create doctor
        DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);
        
        IF @doctorId IS NULL
        BEGIN
            INSERT INTO doctor (doctorname, doctortitle, specialization, username, password)
            VALUES ('Dr. Ahmed', 'General Practitioner', 'General Medicine', 'doctor1', 'doctor123');
            SET @doctorId = SCOPE_IDENTITY();
            PRINT 'Created doctor with ID: ' + CAST(@doctorId AS VARCHAR);
        END
        
        -- Create prescription for patient 1046
        INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
        VALUES (1046, @doctorId, 0, 0);
        
        DECLARE @prescId INT = SCOPE_IDENTITY();
        PRINT 'Created prescription ' + CAST(@prescId AS VARCHAR) + ' for patient 1046';
        
        -- Add sample medication
        INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
        VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', 'Take after meals', @prescId, GETDATE());
        
        PRINT 'Added medication to prescription.';
    END
END
ELSE
BEGIN
    PRINT 'ERROR: Patient 1046 does NOT exist in the database!';
    PRINT 'Available patients:';
    SELECT TOP 10 patientid, full_name, patient_type FROM patient WHERE patient_status = 0 ORDER BY patientid DESC;
END

PRINT '';
PRINT '========================================';
PRINT 'FINAL CHECK - Patient 1046:';
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    COUNT(m.medid) as medication_count
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN medication m ON pr.prescid = m.prescid
WHERE p.patientid = 1046
GROUP BY p.patientid, p.full_name, pr.prescid;

PRINT 'If prescid is NOT NULL above, the discharge summary should now work!';
GO
