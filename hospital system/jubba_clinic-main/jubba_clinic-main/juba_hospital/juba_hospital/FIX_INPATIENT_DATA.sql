-- Fix inpatient data for juba_clinick1 database
-- Run this AFTER checking CHECK_INPATIENT_DATA.sql

USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'FIXING INPATIENT DATA';
PRINT '========================================';
PRINT '';

-- OPTION 1: Update existing patients to be inpatients
PRINT 'OPTION 1: Converting some existing patients to inpatients...';
PRINT '';

-- Check if we have any patients at all
IF (SELECT COUNT(*) FROM patient) > 0
BEGIN
    -- Make the first 3 active patients into inpatients
    DECLARE @affected INT;
    
    UPDATE TOP (3) patient
    SET 
        patient_type = 'inpatient',
        patient_status = 0,
        bed_admission_date = DATEADD(DAY, -CAST(patientid % 10 AS INT), GETDATE())
    WHERE patient_status = 0 OR patient_status IS NULL;
    
    SET @affected = @@ROWCOUNT;
    PRINT 'Updated ' + CAST(@affected AS VARCHAR) + ' existing patients to inpatients.';
    PRINT '';
    
    -- Show what we updated
    SELECT TOP 3
        patientid,
        full_name,
        patient_type,
        patient_status,
        bed_admission_date
    FROM patient
    WHERE patient_type = 'inpatient' AND patient_status = 0
    ORDER BY patientid;
END
ELSE
BEGIN
    PRINT 'No existing patients found. Creating new test patients...';
    PRINT '';
END
GO

-- OPTION 2: Create new inpatients if no patients exist or need more
IF (SELECT COUNT(*) FROM patient WHERE patient_type = 'inpatient' AND patient_status = 0) < 2
BEGIN
    PRINT 'OPTION 2: Creating additional test inpatients...';
    PRINT '';
    
    -- Create Inpatient 1
    INSERT INTO patient (
        full_name, 
        dob, 
        sex, 
        phone, 
        location, 
        date_registered, 
        patient_type, 
        patient_status, 
        bed_admission_date
    )
    VALUES (
        'Test Inpatient Ahmed', 
        '1985-03-15', 
        'male', 
        '252615123456', 
        'Mogadishu Central Hospital', 
        DATEADD(DAY, -5, GETDATE()), 
        'inpatient', 
        0, 
        DATEADD(DAY, -5, GETDATE())
    );
    
    DECLARE @patientId1 INT = SCOPE_IDENTITY();
    PRINT 'Created Inpatient 1 - ID: ' + CAST(@patientId1 AS VARCHAR);
    
    -- Add charges for inpatient 1
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number)
    VALUES 
        (@patientId1, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -5, GETDATE()), 'REG-TEST-' + CAST(@patientId1 AS VARCHAR)),
        (@patientId1, 'Bed', 'Bed Charge (5 days)', 150, 0, GETDATE(), 'BED-TEST-' + CAST(@patientId1 AS VARCHAR));
    
    PRINT 'Added charges for Inpatient 1';
    PRINT '';
    
    -- Create Inpatient 2
    INSERT INTO patient (
        full_name, 
        dob, 
        sex, 
        phone, 
        location, 
        date_registered, 
        patient_type, 
        patient_status, 
        bed_admission_date,
        delivery_charge
    )
    VALUES (
        'Test Inpatient Fatima', 
        '1992-07-22', 
        'female', 
        '252617654321', 
        'Kismayo General Hospital', 
        DATEADD(DAY, -3, GETDATE()), 
        'inpatient', 
        0, 
        DATEADD(DAY, -3, GETDATE()),
        200.00
    );
    
    DECLARE @patientId2 INT = SCOPE_IDENTITY();
    PRINT 'Created Inpatient 2 - ID: ' + CAST(@patientId2 AS VARCHAR);
    
    -- Add charges for inpatient 2
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
    VALUES 
        (@patientId2, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -3, GETDATE()), 'REG-TEST-' + CAST(@patientId2 AS VARCHAR), 'Cash'),
        (@patientId2, 'Delivery', 'Delivery Service Charge', 200, 1, DATEADD(DAY, -3, GETDATE()), 'DEL-TEST-' + CAST(@patientId2 AS VARCHAR), 'Cash'),
        (@patientId2, 'Bed', 'Bed Charge (3 days)', 90, 0, GETDATE(), 'BED-TEST-' + CAST(@patientId2 AS VARCHAR));
    
    PRINT 'Added charges for Inpatient 2';
    PRINT '';
    
    -- Create Inpatient 3 with medication
    INSERT INTO patient (
        full_name, 
        dob, 
        sex, 
        phone, 
        location, 
        date_registered, 
        patient_type, 
        patient_status, 
        bed_admission_date
    )
    VALUES (
        'Test Inpatient Omar', 
        '1978-11-05', 
        'male', 
        '252618987654', 
        'Hargeisa Hospital', 
        DATEADD(DAY, -7, GETDATE()), 
        'inpatient', 
        0, 
        DATEADD(DAY, -7, GETDATE())
    );
    
    DECLARE @patientId3 INT = SCOPE_IDENTITY();
    PRINT 'Created Inpatient 3 - ID: ' + CAST(@patientId3 AS VARCHAR);
    
    -- Add charges
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
    VALUES 
        (@patientId3, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -7, GETDATE()), 'REG-TEST-' + CAST(@patientId3 AS VARCHAR), 'Cash'),
        (@patientId3, 'Lab', 'Lab Test Charges', 75, 1, DATEADD(DAY, -6, GETDATE()), 'LAB-TEST-' + CAST(@patientId3 AS VARCHAR), 'Cash'),
        (@patientId3, 'Bed', 'Bed Charge (7 days)', 210, 0, GETDATE(), 'BED-TEST-' + CAST(@patientId3 AS VARCHAR));
    
    -- Add prescription and medication
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
    VALUES (@patientId3, 1, 1, 0);
    
    DECLARE @prescId INT = SCOPE_IDENTITY();
    
    INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
    VALUES 
        ('Paracetamol', '500mg', 'Three times daily', '7 days', 'Take after meals', @prescId, DATEADD(DAY, -7, GETDATE())),
        ('Amoxicillin', '250mg', 'Twice daily', '5 days', 'Complete full course', @prescId, DATEADD(DAY, -7, GETDATE()));
    
    PRINT 'Added charges, prescription, and medications for Inpatient 3';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'Sufficient inpatient data already exists.';
    PRINT '';
END
GO

-- Final verification
PRINT '========================================';
PRINT 'VERIFICATION - Active Inpatients:';
PRINT '========================================';

SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    p.patient_status,
    p.bed_admission_date,
    DATEDIFF(DAY, p.bed_admission_date, GETDATE()) as days_admitted,
    ISNULL(SUM(pc.amount), 0) as total_charges,
    ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
    ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
FROM patient p
LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
      AND p.patient_status = 0
GROUP BY p.patientid, p.full_name, p.patient_type, p.patient_status, p.bed_admission_date
ORDER BY p.bed_admission_date DESC;

PRINT '';
PRINT 'Total Active Inpatients: ' + CAST((SELECT COUNT(*) FROM patient WHERE (patient_type = 'inpatient' OR bed_admission_date IS NOT NULL) AND patient_status = 0) AS VARCHAR);
PRINT '';
PRINT '========================================';
PRINT 'FIX COMPLETE! Refresh the page now.';
PRINT '========================================';
GO
