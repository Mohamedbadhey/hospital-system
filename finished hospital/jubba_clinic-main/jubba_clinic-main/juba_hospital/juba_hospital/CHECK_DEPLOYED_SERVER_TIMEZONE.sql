-- =====================================================
-- COMPREHENSIVE TIMEZONE CHECK FOR DEPLOYED SERVER
-- =====================================================
-- Run this on your DEPLOYED SQL Server to diagnose
-- timezone and datetime issues
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'TIMEZONE DIAGNOSTIC REPORT'
PRINT 'Run Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '======================================='
GO

-- =====================================================
-- 1. SERVER TIME SETTINGS
-- =====================================================

PRINT ''
PRINT '------- SERVER TIME SETTINGS -------'

SELECT 
    'Current Server Time' AS CheckType,
    GETDATE() AS ServerTime,
    GETUTCDATE() AS UTCTime,
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS TimezoneOffsetHours,
    SYSDATETIMEOFFSET() AS DateTimeWithOffset
GO

-- =====================================================
-- 2. SQL SERVER CONFIGURATION
-- =====================================================

PRINT ''
PRINT '------- SQL SERVER CONFIGURATION -------'

SELECT 
    'Server Name' AS Setting,
    @@SERVERNAME AS Value
UNION ALL
SELECT 
    'SQL Server Version',
    @@VERSION
UNION ALL
SELECT 
    'Default Language',
    @@LANGUAGE
GO

-- =====================================================
-- 3. DATABASE SETTINGS
-- =====================================================

PRINT ''
PRINT '------- DATABASE SETTINGS -------'

SELECT 
    name AS DatabaseName,
    collation_name AS Collation,
    is_read_only AS IsReadOnly,
    state_desc AS State
FROM sys.databases
WHERE name = 'jubba_clinick'
GO

-- =====================================================
-- 4. CHECK DATETIME COLUMNS IN KEY TABLES
-- =====================================================

PRINT ''
PRINT '------- DATETIME COLUMNS IN DATABASE -------'

SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.is_nullable AS IsNullable
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE ty.name IN ('datetime', 'datetime2', 'date', 'time', 'datetimeoffset')
ORDER BY t.name, c.name
GO

-- =====================================================
-- 5. SAMPLE DATA FROM KEY TABLES (Check actual dates)
-- =====================================================

PRINT ''
PRINT '------- PATIENT TABLE - RECENT DATES -------'

IF EXISTS (SELECT * FROM patient)
BEGIN
    SELECT TOP 5
        patientid,
        name,
        registration_date,
        GETDATE() AS CurrentServerTime,
        DATEDIFF(HOUR, registration_date, GETDATE()) AS HoursDifference,
        CASE 
            WHEN DATEDIFF(HOUR, registration_date, GETDATE()) < 0 THEN 'FUTURE DATE - TIMEZONE ISSUE!'
            ELSE 'OK'
        END AS Status
    FROM patient
    ORDER BY registration_date DESC
END
ELSE
BEGIN
    PRINT 'No patients in database yet'
END
GO

PRINT ''
PRINT '------- PRESCRIBTION TABLE - RECENT DATES -------'

IF EXISTS (SELECT * FROM prescribtion)
BEGIN
    SELECT TOP 5
        presid,
        patientid,
        created_date,
        GETDATE() AS CurrentServerTime,
        DATEDIFF(HOUR, created_date, GETDATE()) AS HoursDifference,
        CASE 
            WHEN DATEDIFF(HOUR, created_date, GETDATE()) < 0 THEN 'FUTURE DATE - TIMEZONE ISSUE!'
            ELSE 'OK'
        END AS Status
    FROM prescribtion
    ORDER BY created_date DESC
END
ELSE
BEGIN
    PRINT 'No prescriptions in database yet'
END
GO

PRINT ''
PRINT '------- PHARMACY_SALES TABLE - RECENT DATES -------'

IF EXISTS (SELECT * FROM pharmacy_sales)
BEGIN
    SELECT TOP 5
        sale_id,
        customer_name,
        sale_date,
        GETDATE() AS CurrentServerTime,
        DATEDIFF(HOUR, sale_date, GETDATE()) AS HoursDifference,
        CASE 
            WHEN DATEDIFF(HOUR, sale_date, GETDATE()) < 0 THEN 'FUTURE DATE - TIMEZONE ISSUE!'
            ELSE 'OK'
        END AS Status
    FROM pharmacy_sales
    ORDER BY sale_date DESC
END
ELSE
BEGIN
    PRINT 'No pharmacy sales in database yet'
END
GO

PRINT ''
PRINT '------- MEDICINE_INVENTORY - EXPIRY DATES -------'

IF EXISTS (SELECT * FROM medicine_inventory)
BEGIN
    SELECT TOP 5
        inventory_id,
        medicine_name,
        expiry_date,
        GETDATE() AS CurrentServerTime,
        CASE 
            WHEN expiry_date < GETDATE() THEN 'EXPIRED'
            WHEN expiry_date < DATEADD(MONTH, 1, GETDATE()) THEN 'EXPIRING SOON'
            ELSE 'OK'
        END AS Status
    FROM medicine_inventory
    ORDER BY expiry_date
END
ELSE
BEGIN
    PRINT 'No medicine inventory in database yet'
END
GO

-- =====================================================
-- 6. TIMEZONE OFFSET COMPARISON
-- =====================================================

PRINT ''
PRINT '------- TIMEZONE CALCULATIONS -------'

SELECT 
    'East Africa Time (EAT)' AS Timezone,
    '+03:00' AS ExpectedOffset,
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS ActualOffsetHours,
    CASE 
        WHEN DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) = 3 THEN 'CORRECT - Server is in EAT timezone'
        WHEN DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) = 0 THEN 'WARNING - Server is in UTC timezone'
        ELSE 'WARNING - Server timezone offset is ' + CAST(DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS VARCHAR) + ' hours'
    END AS Status
GO

-- =====================================================
-- 7. TEST DATETIME INSERTION AND RETRIEVAL
-- =====================================================

PRINT ''
PRINT '------- DATETIME INSERTION TEST -------'

-- Create a temporary test table
CREATE TABLE #DateTimeTest (
    TestID INT IDENTITY(1,1),
    TestName VARCHAR(50),
    TestDateTime DATETIME,
    InsertedAt DATETIME DEFAULT GETDATE()
)

-- Insert test values
INSERT INTO #DateTimeTest (TestName, TestDateTime) VALUES ('Server Time', GETDATE())
INSERT INTO #DateTimeTest (TestName, TestDateTime) VALUES ('UTC Time', GETUTCDATE())
INSERT INTO #DateTimeTest (TestName, TestDateTime) VALUES ('Manual EAT Time', DATEADD(HOUR, 3, GETUTCDATE()))

-- Display results
SELECT 
    TestName,
    TestDateTime,
    InsertedAt,
    DATEDIFF(MINUTE, TestDateTime, InsertedAt) AS MinutesDifference
FROM #DateTimeTest

DROP TABLE #DateTimeTest
GO

-- =====================================================
-- 8. APPLICATION CONNECTION STRING CHECK
-- =====================================================

PRINT ''
PRINT '------- ACTIVE CONNECTIONS -------'

SELECT 
    session_id,
    login_name,
    host_name,
    program_name,
    login_time,
    last_request_start_time
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('jubba_clinick')
AND is_user_process = 1
GO

-- =====================================================
-- 9. RECOMMENDED FIXES
-- =====================================================

PRINT ''
PRINT '======================================='
PRINT 'RECOMMENDATIONS'
PRINT '======================================='
PRINT ''
PRINT 'Based on the results above:'
PRINT ''
PRINT '1. If ActualOffsetHours = 0 (UTC):'
PRINT '   - Server is in UTC timezone'
PRINT '   - Add 3 hours in your application code'
PRINT '   - Or configure server to EAT timezone'
PRINT ''
PRINT '2. If ActualOffsetHours = 3 (EAT):'
PRINT '   - Server timezone is correct'
PRINT '   - Check application connection string'
PRINT ''
PRINT '3. If dates show as FUTURE DATE:'
PRINT '   - Application is adding extra timezone offset'
PRINT '   - Remove timezone conversion in code'
PRINT ''
PRINT '4. Connection String should include:'
PRINT '   - For local time: No special settings'
PRINT '   - For UTC: Add timezone handling in code'
PRINT ''
PRINT '======================================='
GO
