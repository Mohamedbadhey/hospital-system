-- =============================================
-- Test Script for Completed Patients Feature
-- Database: jubba_clinick
-- =============================================

USE [jubba_clinick]
GO

-- =============================================
-- STEP 1: Check if completed_date column exists
-- =============================================
PRINT '========================================';
PRINT 'STEP 1: Checking if completed_date column exists';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'completed_date'
)
BEGIN
    PRINT '✓ completed_date column exists';
END
ELSE
BEGIN
    PRINT '✗ completed_date column DOES NOT EXIST!';
    PRINT '  Run this command:';
    PRINT '  ALTER TABLE [dbo].[prescribtion] ADD [completed_date] DATETIME NULL;';
END
GO

-- =============================================
-- STEP 2: Check if transaction_status column exists
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'STEP 2: Checking if transaction_status column exists';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'transaction_status'
)
BEGIN
    PRINT '✓ transaction_status column exists';
END
ELSE
BEGIN
    PRINT '✗ transaction_status column DOES NOT EXIST!';
    PRINT '  Run this command:';
    PRINT '  ALTER TABLE [dbo].[prescribtion] ADD [transaction_status] VARCHAR(20) DEFAULT ''pending'';';
END
GO

-- =============================================
-- STEP 3: Check current data in prescribtion table
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'STEP 3: Checking current prescription data';
PRINT '========================================';
PRINT '';

-- Check if transaction_status column exists before querying
IF EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'transaction_status'
)
BEGIN
    SELECT 
        COUNT(*) AS total_prescriptions,
        SUM(CASE WHEN transaction_status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
        SUM(CASE WHEN transaction_status = 'pending' OR transaction_status IS NULL THEN 1 ELSE 0 END) AS pending_count
    FROM prescribtion;
    
    PRINT '';
    PRINT 'Breakdown by status:';
    SELECT 
        ISNULL(transaction_status, 'NULL') AS status,
        COUNT(*) AS count
    FROM prescribtion
    GROUP BY transaction_status;
END
ELSE
BEGIN
    PRINT '⚠ Cannot check data - transaction_status column does not exist';
    PRINT 'Total prescriptions:';
    SELECT COUNT(*) AS total FROM prescribtion;
END
GO

-- =============================================
-- STEP 4: Show sample patients with prescription IDs
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'STEP 4: Sample patients available for testing';
PRINT '========================================';
PRINT '';

SELECT TOP 10
    p.patientid,
    p.full_name,
    pr.prescid,
    pr.doctorid,
    CASE 
        WHEN EXISTS (
            SELECT * FROM sys.columns 
            WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
            AND name = 'transaction_status'
        )
        THEN ISNULL(pr.transaction_status, 'NULL')
        ELSE 'COLUMN NOT EXIST'
    END AS current_status
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
ORDER BY pr.prescid DESC;

GO

-- =============================================
-- STEP 5: TEST COMMAND - Mark a patient as completed
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'STEP 5: HOW TO MARK A PATIENT AS COMPLETED';
PRINT '========================================';
PRINT '';
PRINT 'Option A: Using the Application (RECOMMENDED)';
PRINT '  1. Login as a doctor';
PRINT '  2. Go to Assign Medication page';
PRINT '  3. Click on a patient row';
PRINT '  4. Find Transaction Status dropdown';
PRINT '  5. Select "Completed"';
PRINT '  6. Wait for success message';
PRINT '';
PRINT 'Option B: Manually update in database (FOR TESTING)';
PRINT '  Run this command (replace 3002 with actual prescid):';
PRINT '';
PRINT '  UPDATE prescribtion';
PRINT '  SET transaction_status = ''completed'',';
PRINT '      completed_date = GETDATE()';
PRINT '  WHERE prescid = 3002;  -- Change this to your prescid';
PRINT '';

GO

-- =============================================
-- STEP 6: Verify completed patients query
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'STEP 6: Query that Completed Patients page uses';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'transaction_status'
)
BEGIN
    PRINT 'Patients marked as completed:';
    PRINT '';
    
    SELECT 
        p.full_name,
        pr.prescid,
        pr.doctorid,
        pr.transaction_status,
        pr.completed_date
    FROM patient p
    INNER JOIN prescribtion pr ON p.patientid = pr.patientid
    WHERE pr.transaction_status = 'completed'
    ORDER BY pr.completed_date DESC;
    
    IF NOT EXISTS (
        SELECT 1 FROM prescribtion WHERE transaction_status = 'completed'
    )
    BEGIN
        PRINT '';
        PRINT '⚠ NO COMPLETED PATIENTS FOUND!';
        PRINT '';
        PRINT 'This is why the page shows "No Completed Patients"';
        PRINT '';
        PRINT 'TO FIX: Mark at least one patient as completed using one of the methods above.';
    END
END
ELSE
BEGIN
    PRINT '⚠ Cannot run query - transaction_status column does not exist';
END

GO

PRINT '';
PRINT '========================================';
PRINT 'TEST SCRIPT COMPLETE';
PRINT '========================================';
PRINT '';
PRINT 'Summary:';
PRINT '  - If columns exist: ✓';
PRINT '  - If no completed patients: Mark one as completed using the app';
PRINT '  - Then refresh Completed Patients page';
PRINT '';

GO
