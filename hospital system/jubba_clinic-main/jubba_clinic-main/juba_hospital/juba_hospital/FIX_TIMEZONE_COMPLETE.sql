-- =====================================================
-- COMPLETE TIMEZONE FIX
-- =====================================================
-- This will fix existing data and create helper functions
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'TIMEZONE FIX - COMPLETE SOLUTION'
PRINT '======================================='
GO

-- =====================================================
-- STEP 1: FIX EXISTING DATA (Add 11 hours)
-- =====================================================

PRINT ''
PRINT '------- STEP 1: Fixing Existing Data -------'
PRINT 'Adding 11 hours to all dates to correct timezone issue'
GO

-- Backup recommendation
PRINT 'RECOMMENDATION: Backup database before running!'
PRINT 'Run: BACKUP DATABASE [jubba_clinick] TO DISK = ''C:\Backup\jubba_clinick_before_timezone_fix.bak'''
PRINT ''
GO

-- Show what will be changed
PRINT 'PREVIEW - These dates will be corrected:'
SELECT 
    'patient' AS TableName,
    COUNT(*) AS RecordsToFix,
    MIN(date_registered) AS OldestDate,
    MAX(date_registered) AS NewestDate,
    MIN(DATEADD(HOUR, 11, date_registered)) AS WillBecomeOldest,
    MAX(DATEADD(HOUR, 11, date_registered)) AS WillBecomeNewest
FROM patient
WHERE date_registered IS NOT NULL
GO

-- Fix patient dates
PRINT 'Fixing patient registration dates...'
UPDATE patient
SET date_registered = DATEADD(HOUR, 11, date_registered)
WHERE date_registered IS NOT NULL

DECLARE @PatientRows INT = @@ROWCOUNT
PRINT 'Updated ' + CAST(@PatientRows AS VARCHAR) + ' patient records'
GO

-- Fix prescription dates
PRINT 'Fixing prescription dates...'
UPDATE prescribtion
SET date = DATEADD(HOUR, 11, date)
WHERE date IS NOT NULL

DECLARE @PrescRows INT = @@ROWCOUNT
PRINT 'Updated ' + CAST(@PrescRows AS VARCHAR) + ' prescription records'
GO

-- Fix pharmacy sales dates (if any)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
BEGIN
    PRINT 'Fixing pharmacy sales dates...'
    UPDATE pharmacy_sales
    SET sale_date = DATEADD(HOUR, 11, sale_date)
    WHERE sale_date IS NOT NULL
    
    DECLARE @SalesRows INT = @@ROWCOUNT
    PRINT 'Updated ' + CAST(@SalesRows AS VARCHAR) + ' pharmacy sales records'
END
GO

-- Fix medicine inventory dates
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
BEGIN
    PRINT 'Fixing medicine inventory dates...'
    UPDATE medicine_inventory
    SET added_date = DATEADD(HOUR, 11, added_date)
    WHERE added_date IS NOT NULL
    
    DECLARE @InvRows INT = @@ROWCOUNT
    PRINT 'Updated ' + CAST(@InvRows AS VARCHAR) + ' inventory records'
    
    -- Note: Expiry dates should stay as-is (they're future dates)
    PRINT 'Note: Expiry dates left unchanged (they are future dates)'
END
GO

-- Fix lab results dates
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_results')
BEGIN
    PRINT 'Fixing lab results dates...'
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('lab_results') AND name = 'result_date')
    BEGIN
        UPDATE lab_results
        SET result_date = DATEADD(HOUR, 11, result_date)
        WHERE result_date IS NOT NULL
        
        PRINT 'Updated lab results dates'
    END
END
GO

PRINT ''
PRINT 'STEP 1 COMPLETE: All existing data corrected'
GO

-- =====================================================
-- STEP 2: CREATE HELPER FUNCTIONS
-- =====================================================

PRINT ''
PRINT '------- STEP 2: Creating Helper Functions -------'
GO

-- Function to get correct EAT time
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'GetEATTime' AND type = 'FN')
    DROP FUNCTION dbo.GetEATTime
GO

CREATE FUNCTION dbo.GetEATTime()
RETURNS DATETIME
AS
BEGIN
    -- Always calculate EAT from UTC (UTC + 3 hours)
    RETURN DATEADD(HOUR, 3, GETUTCDATE())
END
GO

PRINT 'Created function: GetEATTime()'
PRINT 'Usage: SELECT dbo.GetEATTime() -- Returns correct Somalia time'
GO

-- Function to convert any datetime to EAT
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'ConvertToEAT' AND type = 'FN')
    DROP FUNCTION dbo.ConvertToEAT
GO

CREATE FUNCTION dbo.ConvertToEAT(@InputDateTime DATETIME)
RETURNS DATETIME
AS
BEGIN
    -- Add 11 hours to server time to get EAT
    -- (Server is -8 from UTC, EAT is +3, difference is 11)
    RETURN DATEADD(HOUR, 11, @InputDateTime)
END
GO

PRINT 'Created function: ConvertToEAT(@datetime)'
PRINT 'Usage: SELECT dbo.ConvertToEAT(GETDATE()) -- Converts server time to EAT'
GO

PRINT ''
PRINT 'STEP 2 COMPLETE: Helper functions created'
GO

-- =====================================================
-- STEP 3: VERIFY FIXES
-- =====================================================

PRINT ''
PRINT '------- STEP 3: Verification -------'
GO

-- Show corrected times
PRINT 'Time Functions Test:'
SELECT 
    GETDATE() AS ServerLocalTime_Wrong,
    GETUTCDATE() AS UTC_Correct,
    dbo.GetEATTime() AS EAT_CorrectSomaliaTime,
    dbo.ConvertToEAT(GETDATE()) AS ServerTimeConvertedToEAT
GO

-- Verify patient data
PRINT ''
PRINT 'Patient Data Verification:'
IF EXISTS (SELECT TOP 1 * FROM patient)
BEGIN
    SELECT TOP 5
        patientid,
        full_name,
        date_registered,
        dbo.GetEATTime() AS CurrentEATTime,
        DATEDIFF(HOUR, date_registered, dbo.GetEATTime()) AS HoursAgo,
        CASE 
            WHEN date_registered > dbo.GetEATTime() THEN '❌ STILL FUTURE - ERROR'
            WHEN DATEDIFF(DAY, date_registered, dbo.GetEATTime()) = 0 THEN '✅ Today - CORRECT'
            WHEN DATEDIFF(DAY, date_registered, dbo.GetEATTime()) <= 7 THEN '✅ This week - CORRECT'
            ELSE '✅ Past - CORRECT'
        END AS Status
    FROM patient
    ORDER BY date_registered DESC
END
GO

PRINT ''
PRINT '======================================='
PRINT 'TIMEZONE FIX COMPLETE!'
PRINT '======================================='
PRINT ''
PRINT 'What was done:'
PRINT '1. ✅ Added 11 hours to all existing dates'
PRINT '2. ✅ Created GetEATTime() function'
PRINT '3. ✅ Created ConvertToEAT() function'
PRINT ''
PRINT 'Next steps:'
PRINT '1. Update C# code to use: DateTime.UtcNow.AddHours(3)'
PRINT '2. Or use: dbo.GetEATTime() in SQL queries'
PRINT '3. Test by registering a new patient'
PRINT '======================================='
GO
