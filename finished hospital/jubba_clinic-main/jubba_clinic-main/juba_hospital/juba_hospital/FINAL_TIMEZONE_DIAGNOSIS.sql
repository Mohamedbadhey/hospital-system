-- =====================================================
-- FINAL TIMEZONE DIAGNOSIS
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'CRITICAL TIMEZONE CHECK'
PRINT '======================================='
GO

-- Show all time information
SELECT 
    'Server Local Time' AS TimeType,
    GETDATE() AS DateTime,
    'This is what SQL Server thinks is local time' AS Description
UNION ALL
SELECT 
    'UTC Time',
    GETUTCDATE(),
    'This is Universal Coordinated Time (UTC)'
UNION ALL
SELECT
    'Expected EAT Time',
    DATEADD(HOUR, 3, GETUTCDATE()),
    'This is what time it SHOULD be in Somalia (UTC+3)'
GO

-- Calculate the difference
DECLARE @ServerTime DATETIME = GETDATE()
DECLARE @UTCTime DATETIME = GETUTCDATE()
DECLARE @ExpectedEAT DATETIME = DATEADD(HOUR, 3, GETUTCDATE())

PRINT ''
PRINT '------- TIME COMPARISON -------'
PRINT 'Server Local Time: ' + CONVERT(VARCHAR, @ServerTime, 120)
PRINT 'UTC Time: ' + CONVERT(VARCHAR, @UTCTime, 120)
PRINT 'Expected Somalia Time (EAT): ' + CONVERT(VARCHAR, @ExpectedEAT, 120)
PRINT ''

DECLARE @OffsetHours INT = DATEDIFF(HOUR, @UTCTime, @ServerTime)
PRINT 'Current Offset: ' + CAST(@OffsetHours AS VARCHAR) + ' hours'

IF @OffsetHours = 3
BEGIN
    PRINT 'STATUS: ✓ CORRECT - Server is in EAT timezone'
END
ELSE IF @OffsetHours = 0
BEGIN
    PRINT 'STATUS: ✗ WRONG - Server is in UTC timezone (should be EAT)'
    PRINT 'FIX: Need to add 3 hours in application OR configure Windows Server timezone'
END
ELSE IF @OffsetHours < 0
BEGIN
    PRINT 'STATUS: ✗✗ CRITICAL ERROR - Server time is BEHIND UTC!'
    PRINT 'This should be impossible! Server is ' + CAST(ABS(@OffsetHours) AS VARCHAR) + ' hours behind UTC'
    PRINT 'FIX: Check Windows Server date/time settings immediately'
END
ELSE
BEGIN
    PRINT 'STATUS: ✗ WRONG - Server offset is ' + CAST(@OffsetHours AS VARCHAR) + ' hours'
    PRINT 'Expected: +3 hours (EAT)'
END

PRINT ''
PRINT '------- WHAT TIME IS IT REALLY? -------'
PRINT 'According to SQL Server:'
PRINT '  Local Time: ' + CONVERT(VARCHAR, @ServerTime, 120)
PRINT ''
PRINT 'What it SHOULD be in Somalia right now:'
PRINT '  EAT Time: ' + CONVERT(VARCHAR, @ExpectedEAT, 120)
PRINT ''
PRINT 'Difference: ' + CAST(DATEDIFF(HOUR, @ServerTime, @ExpectedEAT) AS VARCHAR) + ' hours'

GO

-- Check actual data
PRINT ''
PRINT '------- CHECK PATIENT DATA -------'
IF EXISTS (SELECT TOP 1 * FROM patient)
BEGIN
    SELECT TOP 3
        patientid,
        full_name,
        date_registered AS RegisteredDate,
        GETDATE() AS ServerTimeNow,
        DATEADD(HOUR, 3, GETUTCDATE()) AS CorrectEATTime,
        CASE 
            WHEN date_registered > DATEADD(HOUR, 3, GETUTCDATE()) THEN '✗ FUTURE - TOO FAR AHEAD'
            WHEN date_registered > GETDATE() THEN '✗ FUTURE DATE'
            WHEN DATEDIFF(DAY, date_registered, GETDATE()) = 0 THEN '✓ Today'
            ELSE '✓ Past date - OK'
        END AS Status
    FROM patient
    ORDER BY date_registered DESC
END
ELSE
BEGIN
    PRINT 'No patients in database'
END
GO

PRINT ''
PRINT '======================================='
PRINT 'RECOMMENDATION'
PRINT '======================================='
PRINT 'If offset is -8 hours: Server Windows timezone needs to be changed'
PRINT 'If offset is 0 hours: Add 3 hours in application code'
PRINT 'If offset is +3 hours: Everything is correct!'
PRINT '======================================='
GO
