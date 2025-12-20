-- ================================================================
-- COMPLETE FIX FOR INPATIENT MANAGEMENT SYSTEM
-- Run this script in SSMS to add missing columns and test data
-- ================================================================

USE [juba_clinick]
GO

PRINT 'Starting inpatient system setup...'
PRINT ''

-- ================================================================
-- STEP 1: Add missing columns to patient table
-- ================================================================

PRINT 'Step 1: Adding missing columns to patient table...'

-- Add patient_type column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'patient_type')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [patient_type] VARCHAR(20) NULL DEFAULT 'outpatient'
    PRINT '  ✓ Added patient_type column'
END
ELSE
BEGIN
    PRINT '  - patient_type column already exists'
END

-- Add bed_admission_date column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'bed_admission_date')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [bed_admission_date] DATETIME NULL
    PRINT '  ✓ Added bed_admission_date column'
END
ELSE
BEGIN
    PRINT '  - bed_admission_date column already exists'
END

-- Add bed_discharge_date column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'bed_discharge_date')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [bed_discharge_date] DATETIME NULL
    PRINT '  ✓ Added bed_discharge_date column'
END
ELSE
BEGIN
    PRINT '  - bed_discharge_date column already exists'
END

PRINT ''

-- ================================================================
-- STEP 2: Verify patient_charges table exists
-- ================================================================

PRINT 'Step 2: Verifying patient_charges table...'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'patient_charges')
BEGIN
    PRINT '  ✓ patient_charges table exists'
    
    -- Check column count
    DECLARE @colCount INT
    SELECT @colCount = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'patient_charges'
    PRINT '  - Table has ' + CAST(@colCount AS VARCHAR) + ' columns'
END
ELSE
BEGIN
    PRINT '  ✗ ERROR: patient_charges table does NOT exist!'
    PRINT '  Please run: charges_management_database.sql first'
END

PRINT ''

-- ================================================================
-- STEP 3: Check existing patients
-- ================================================================

PRINT 'Step 3: Checking existing patients...'

DECLARE @totalPatients INT
DECLARE @inpatients INT

SELECT @totalPatients = COUNT(*) FROM patient
SELECT @inpatients = COUNT(*) FROM patient WHERE patient_status = 1

PRINT '  - Total patients: ' + CAST(@totalPatients AS VARCHAR)
PRINT '  - Current inpatients: ' + CAST(@inpatients AS VARCHAR)

PRINT ''

-- ================================================================
-- STEP 4: Create test inpatient (if none exist)
-- ================================================================

IF @inpatients = 0
BEGIN
    PRINT 'Step 4: Creating test inpatient...'
    
    -- Find a patient with a prescription
    DECLARE @testPatientId INT
    DECLARE @testPrescId INT
    DECLARE @doctorId INT
    
    SELECT TOP 1 
        @testPatientId = p.patientid,
        @testPrescId = pr.prescid,
        @doctorId = pr.doctorid
    FROM patient p
    INNER JOIN prescribtion pr ON p.patientid = pr.patientid
    WHERE p.patient_status = 0
    ORDER BY p.patientid DESC
    
    IF @testPatientId IS NOT NULL
    BEGIN
        -- Update patient to be inpatient
        UPDATE patient
        SET patient_status = 1,
            patient_type = 'inpatient',
            bed_admission_date = GETDATE()
        WHERE patientid = @testPatientId
        
        PRINT '  ✓ Created test inpatient:'
        PRINT '    - Patient ID: ' + CAST(@testPatientId AS VARCHAR)
        PRINT '    - Prescription ID: ' + CAST(@testPrescId AS VARCHAR)
        PRINT '    - Doctor ID: ' + CAST(@doctorId AS VARCHAR)
        PRINT '    - Admission Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
        
        -- Add a sample bed charge
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'patient_charges')
        BEGIN
            INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, last_updated)
            VALUES (@testPatientId, @testPrescId, 'Bed', 'Bed Charges (Day 1)', 10, 0, GETDATE(), GETDATE())
            
            PRINT '  ✓ Added sample bed charge ($10)'
        END
    END
    ELSE
    BEGIN
        PRINT '  ✗ No patients with prescriptions found!'
        PRINT '  Please create a patient and prescription first.'
    END
END
ELSE
BEGIN
    PRINT 'Step 4: Inpatients already exist - skipping test data creation'
END

PRINT ''

-- ================================================================
-- STEP 5: Verification Query
-- ================================================================

PRINT 'Step 5: Running verification query...'
PRINT ''

SELECT 
    p.patientid,
    p.full_name,
    p.patient_status,
    p.patient_type,
    p.bed_admission_date,
    CASE WHEN p.bed_admission_date IS NOT NULL 
        THEN DATEDIFF(DAY, p.bed_admission_date, GETDATE()) 
        ELSE 0 END AS days_admitted,
    pr.prescid,
    d.doctorid,
    d.fullname as doctor_name,
    (SELECT COUNT(*) FROM patient_charges pc WHERE pc.patientid = p.patientid) as charge_count
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patient_status = 1

PRINT ''
PRINT '================================================================'
PRINT 'SETUP COMPLETE!'
PRINT '================================================================'
PRINT ''
PRINT 'Next steps:'
PRINT '1. Rebuild your Visual Studio project'
PRINT '2. Press F5 to run the application'
PRINT '3. Login as a doctor (doctor ID shown above)'
PRINT '4. Navigate to "Inpatient Management"'
PRINT '5. You should see the test patient(s)'
PRINT ''
PRINT '================================================================'
