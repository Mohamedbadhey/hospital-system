-- Create Test Data for Registration Pages
-- Run this script in SQL Server Management Studio against juba_clinick1 database

USE juba_clinick1;
GO

-- =============================================
-- 1. FIX EXISTING DATA (if patient_type is NULL)
-- =============================================

-- Set patient_type based on bed_admission_date
UPDATE patient 
SET patient_type = 'inpatient'
WHERE bed_admission_date IS NOT NULL AND (patient_type IS NULL OR patient_type = '');

UPDATE patient 
SET patient_type = 'outpatient'
WHERE bed_admission_date IS NULL AND (patient_type IS NULL OR patient_type = '');

-- Set default patient_status if NULL
UPDATE patient 
SET patient_status = 0 
WHERE patient_status IS NULL;

PRINT 'Existing data updated!';
GO

-- =============================================
-- 2. CREATE TEST INPATIENTS (if needed)
-- =============================================

-- Check if we need test data
IF (SELECT COUNT(*) FROM patient WHERE patient_type = 'inpatient' AND patient_status = 0) < 2
BEGIN
    PRINT 'Creating test inpatients...';
    
    -- Test Inpatient 1
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date)
    VALUES ('Ahmed Hassan', '1985-03-15', 'male', '252615123456', 'Mogadishu', DATEADD(DAY, -5, GETDATE()), 'inpatient', 0, DATEADD(DAY, -5, GETDATE()));
    
    DECLARE @inpatient1 INT = SCOPE_IDENTITY();
    
    -- Add charges for inpatient 1
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number)
    VALUES 
        (@inpatient1, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -5, GETDATE()), 'REG-TEST-' + CAST(@inpatient1 AS VARCHAR)),
        (@inpatient1, 'Bed', 'Bed Charge - Day 1-5', 150, 0, DATEADD(DAY, -1, GETDATE()), 'BED-TEST-' + CAST(@inpatient1 AS VARCHAR));
    
    -- Add prescription
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
    VALUES (@inpatient1, 1, 1, 0);
    
    DECLARE @presc1 INT = SCOPE_IDENTITY();
    
    -- Add medication
    INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
    VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', 'Take after meals', @presc1, DATEADD(DAY, -5, GETDATE()));
    
    PRINT 'Test Inpatient 1 created with ID: ' + CAST(@inpatient1 AS VARCHAR);
    
    -- Test Inpatient 2
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date, delivery_charge)
    VALUES ('Fatima Mohamed', '1992-07-22', 'female', '252617654321', 'Kismayo', DATEADD(DAY, -3, GETDATE()), 'inpatient', 0, DATEADD(DAY, -3, GETDATE()), 200);
    
    DECLARE @inpatient2 INT = SCOPE_IDENTITY();
    
    -- Add charges for inpatient 2
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
    VALUES 
        (@inpatient2, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -3, GETDATE()), 'REG-TEST-' + CAST(@inpatient2 AS VARCHAR), 'Cash'),
        (@inpatient2, 'Delivery', 'Delivery Service Charge', 200, 1, DATEADD(DAY, -3, GETDATE()), 'DEL-TEST-' + CAST(@inpatient2 AS VARCHAR), 'Cash'),
        (@inpatient2, 'Bed', 'Bed Charge - Day 1-3', 90, 0, GETDATE(), 'BED-TEST-' + CAST(@inpatient2 AS VARCHAR));
    
    PRINT 'Test Inpatient 2 created with ID: ' + CAST(@inpatient2 AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Sufficient inpatient test data exists.';
END
GO

-- =============================================
-- 3. CREATE TEST OUTPATIENTS (if needed)
-- =============================================

IF (SELECT COUNT(*) FROM patient WHERE patient_type = 'outpatient' AND patient_status = 0) < 3
BEGIN
    PRINT 'Creating test outpatients...';
    
    -- Test Outpatient 1
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
    VALUES ('Omar Ali', '1978-11-05', 'male', '252618987654', 'Hargeisa', DATEADD(DAY, -2, GETDATE()), 'outpatient', 0);
    
    DECLARE @outpatient1 INT = SCOPE_IDENTITY();
    
    -- Add charges
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
    VALUES 
        (@outpatient1, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -2, GETDATE()), 'REG-TEST-' + CAST(@outpatient1 AS VARCHAR), 'Cash'),
        (@outpatient1, 'Lab', 'Lab Test Charges', 75, 1, DATEADD(DAY, -2, GETDATE()), 'LAB-TEST-' + CAST(@outpatient1 AS VARCHAR), 'Cash');
    
    -- Add prescription with lab test
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status, lab_charge_paid)
    VALUES (@outpatient1, 1, 3, 0, 1);
    
    DECLARE @presc2 INT = SCOPE_IDENTITY();
    
    -- Add medication
    INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
    VALUES ('Amoxicillin', '250mg', 'Twice daily', '5 days', 'Complete full course', @presc2, DATEADD(DAY, -2, GETDATE()));
    
    PRINT 'Test Outpatient 1 created with ID: ' + CAST(@outpatient1 AS VARCHAR);
    
    -- Test Outpatient 2
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
    VALUES ('Amina Abdi', '1995-02-18', 'female', '252619876543', 'Baidoa', DATEADD(DAY, -1, GETDATE()), 'outpatient', 0);
    
    DECLARE @outpatient2 INT = SCOPE_IDENTITY();
    
    -- Add charges (unpaid)
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number)
    VALUES 
        (@outpatient2, 'Registration', 'Patient Registration Fee', 50, 0, DATEADD(DAY, -1, GETDATE()), 'REG-TEST-' + CAST(@outpatient2 AS VARCHAR)),
        (@outpatient2, 'Xray', 'Chest X-Ray', 100, 0, DATEADD(DAY, -1, GETDATE()), 'XRAY-TEST-' + CAST(@outpatient2 AS VARCHAR));
    
    -- Add prescription with x-ray
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
    VALUES (@outpatient2, 1, 0, 1);
    
    PRINT 'Test Outpatient 2 created with ID: ' + CAST(@outpatient2 AS VARCHAR);
    
    -- Test Outpatient 3
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
    VALUES ('Hassan Ibrahim', '1988-09-30', 'male', '252610111222', 'Garowe', GETDATE(), 'outpatient', 0);
    
    DECLARE @outpatient3 INT = SCOPE_IDENTITY();
    
    -- Add charges (mixed paid/unpaid)
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
    VALUES 
        (@outpatient3, 'Registration', 'Patient Registration Fee', 50, 1, GETDATE(), 'REG-TEST-' + CAST(@outpatient3 AS VARCHAR), 'Cash'),
        (@outpatient3, 'Lab', 'Lab Test Charges', 60, 0, GETDATE(), 'LAB-TEST-' + CAST(@outpatient3 AS VARCHAR));
    
    PRINT 'Test Outpatient 3 created with ID: ' + CAST(@outpatient3 AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Sufficient outpatient test data exists.';
END
GO

-- =============================================
-- 4. CREATE TEST DISCHARGED PATIENTS (if needed)
-- =============================================

IF (SELECT COUNT(*) FROM patient WHERE patient_status = 1) < 2
BEGIN
    PRINT 'Creating test discharged patients...';
    
    -- Discharged Inpatient
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date)
    VALUES ('Yusuf Ahmed', '1980-06-12', 'male', '252614555666', 'Mogadishu', DATEADD(DAY, -15, GETDATE()), 'inpatient', 1, DATEADD(DAY, -15, GETDATE()));
    
    DECLARE @discharged1 INT = SCOPE_IDENTITY();
    
    -- Add charges (all paid)
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method, paid_date)
    VALUES 
        (@discharged1, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -15, GETDATE()), 'REG-TEST-' + CAST(@discharged1 AS VARCHAR), 'Cash', DATEADD(DAY, -15, GETDATE())),
        (@discharged1, 'Bed', 'Bed Charge - 7 days', 210, 1, DATEADD(DAY, -8, GETDATE()), 'BED-TEST-' + CAST(@discharged1 AS VARCHAR), 'Cash', DATEADD(DAY, -8, GETDATE())),
        (@discharged1, 'Lab', 'Lab Test Charges', 80, 1, DATEADD(DAY, -14, GETDATE()), 'LAB-TEST-' + CAST(@discharged1 AS VARCHAR), 'Cash', DATEADD(DAY, -14, GETDATE()));
    
    PRINT 'Discharged Inpatient created with ID: ' + CAST(@discharged1 AS VARCHAR);
    
    -- Discharged Outpatient
    INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
    VALUES ('Mariam Hassan', '1990-04-25', 'female', '252615777888', 'Hargeisa', DATEADD(DAY, -10, GETDATE()), 'outpatient', 1);
    
    DECLARE @discharged2 INT = SCOPE_IDENTITY();
    
    -- Add charges
    INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method, paid_date)
    VALUES 
        (@discharged2, 'Registration', 'Patient Registration Fee', 50, 1, DATEADD(DAY, -10, GETDATE()), 'REG-TEST-' + CAST(@discharged2 AS VARCHAR), 'Cash', DATEADD(DAY, -10, GETDATE())),
        (@discharged2, 'Lab', 'Lab Test Charges', 65, 1, DATEADD(DAY, -10, GETDATE()), 'LAB-TEST-' + CAST(@discharged2 AS VARCHAR), 'Cash', DATEADD(DAY, -10, GETDATE()));
    
    PRINT 'Discharged Outpatient created with ID: ' + CAST(@discharged2 AS VARCHAR);
END
ELSE
BEGIN
    PRINT 'Sufficient discharged patient test data exists.';
END
GO

-- =============================================
-- 5. VERIFY DATA
-- =============================================

PRINT '';
PRINT '========================================';
PRINT 'DATA SUMMARY';
PRINT '========================================';

PRINT 'Active Inpatients: ' + CAST((SELECT COUNT(*) FROM patient WHERE patient_type = 'inpatient' AND patient_status = 0) AS VARCHAR);
PRINT 'Active Outpatients: ' + CAST((SELECT COUNT(*) FROM patient WHERE patient_type = 'outpatient' AND patient_status = 0) AS VARCHAR);
PRINT 'Discharged Patients: ' + CAST((SELECT COUNT(*) FROM patient WHERE patient_status = 1) AS VARCHAR);
PRINT '';

-- Show sample of each type
PRINT 'Sample Active Inpatients:';
SELECT TOP 3 patientid, full_name, bed_admission_date, DATEDIFF(DAY, bed_admission_date, GETDATE()) as days_admitted
FROM patient 
WHERE patient_type = 'inpatient' AND patient_status = 0
ORDER BY bed_admission_date DESC;

PRINT '';
PRINT 'Sample Active Outpatients:';
SELECT TOP 3 patientid, full_name, date_registered
FROM patient 
WHERE patient_type = 'outpatient' AND patient_status = 0
ORDER BY date_registered DESC;

PRINT '';
PRINT 'Sample Discharged Patients:';
SELECT TOP 3 patientid, full_name, patient_type, date_registered
FROM patient 
WHERE patient_status = 1
ORDER BY date_registered DESC;

PRINT '';
PRINT '========================================';
PRINT 'Test data creation complete!';
PRINT 'Now test the registration pages.';
PRINT '========================================';
GO
