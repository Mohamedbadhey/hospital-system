-- =====================================================
-- TIMEZONE STATUS CHECK - CUSTOM FOR YOUR DATABASE
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'TIMEZONE DIAGNOSTIC - SIMPLIFIED'
PRINT '======================================='
GO

-- 1. Check server timezone offset
PRINT ''
PRINT '------- SERVER TIMEZONE -------'
SELECT 
    GETDATE() AS ServerLocalTime,
    GETUTCDATE() AS UTCTime,
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS TimezoneOffsetHours,
    CASE 
        WHEN DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) = 3 THEN 'Server is EAT (UTC+3) - CORRECT for Somalia'
        WHEN DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) = 0 THEN 'Server is UTC - Need to handle in code'
        ELSE 'Server is at UTC+' + CAST(DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS VARCHAR)
    END AS Status
GO

-- 2. Check patient table (if exists and has data)
PRINT ''
PRINT '------- PATIENT TABLE - CHECK DATES -------'
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient')
BEGIN
    IF EXISTS (SELECT TOP 1 * FROM patient)
    BEGIN
        SELECT TOP 5
            patientid,
            full_name,
            date_registered,
            GETDATE() AS CurrentServerTime,
            DATEDIFF(HOUR, date_registered, GETDATE()) AS HoursAgo,
            CASE 
                WHEN date_registered > GETDATE() THEN '*** FUTURE DATE - PROBLEM! ***'
                WHEN DATEDIFF(HOUR, date_registered, GETDATE()) < 0 THEN '*** FUTURE DATE - PROBLEM! ***'
                WHEN DATEDIFF(DAY, date_registered, GETDATE()) = 0 THEN 'Registered today - OK'
                ELSE 'OK'
            END AS Status
        FROM patient
        ORDER BY date_registered DESC
    END
    ELSE
    BEGIN
        PRINT 'Patient table exists but is empty'
    END
END
ELSE
BEGIN
    PRINT 'Patient table does not exist'
END
GO

-- 3. Check prescription table
PRINT ''
PRINT '------- PRESCRIBTION TABLE - CHECK DATES -------'
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'prescribtion')
BEGIN
    IF EXISTS (SELECT TOP 1 * FROM prescribtion)
    BEGIN
        SELECT TOP 5
            presid,
            patientid,
            date,
            GETDATE() AS CurrentServerTime,
            DATEDIFF(HOUR, date, GETDATE()) AS HoursAgo,
            CASE 
                WHEN date > GETDATE() THEN '*** FUTURE DATE - PROBLEM! ***'
                WHEN DATEDIFF(HOUR, date, GETDATE()) < 0 THEN '*** FUTURE DATE - PROBLEM! ***'
                WHEN DATEDIFF(DAY, date, GETDATE()) = 0 THEN 'Created today - OK'
                ELSE 'OK'
            END AS Status
        FROM prescribtion
        ORDER BY date DESC
    END
    ELSE
    BEGIN
        PRINT 'Prescribtion table exists but is empty'
    END
END
ELSE
BEGIN
    PRINT 'Prescribtion table does not exist'
END
GO

-- 4. Check medicine inventory expiry dates
PRINT ''
PRINT '------- MEDICINE INVENTORY - EXPIRY DATES -------'
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
BEGIN
    IF EXISTS (SELECT TOP 1 * FROM medicine_inventory)
    BEGIN
        SELECT TOP 5
            id,
            medicine_name,
            expiry_date,
            GETDATE() AS CurrentServerTime,
            DATEDIFF(DAY, GETDATE(), expiry_date) AS DaysUntilExpiry,
            CASE 
                WHEN expiry_date < GETDATE() THEN 'EXPIRED'
                WHEN DATEDIFF(DAY, GETDATE(), expiry_date) <= 30 THEN 'EXPIRING SOON'
                ELSE 'OK'
            END AS Status
        FROM medicine_inventory
        ORDER BY expiry_date
    END
    ELSE
    BEGIN
        PRINT 'Medicine inventory table exists but is empty'
    END
END
GO

-- 5. Test date insertion
PRINT ''
PRINT '------- TEST: INSERT CURRENT DATE -------'
DECLARE @TestDateTime DATETIME = GETDATE()
PRINT 'Current Server Time: ' + CONVERT(VARCHAR, @TestDateTime, 120)
PRINT 'UTC Time: ' + CONVERT(VARCHAR, GETUTCDATE(), 120)
PRINT 'Difference (hours): ' + CAST(DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS VARCHAR)
GO

PRINT ''
PRINT '======================================='
PRINT 'SUMMARY'
PRINT '======================================='
PRINT 'Based on completion time showing +03:00,'
PRINT 'your server is correctly set to EAT timezone.'
PRINT ''
PRINT 'If dates appear wrong in the application:'
PRINT '  - Check if future dates exist in tables'
PRINT '  - Application may be adding timezone offset'
PRINT '  - Use DateTime.Now (not DateTime.UtcNow)'
PRINT '======================================='
GO
