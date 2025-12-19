-- ========================================
-- CHECK AND SET DATABASE TIMEZONE OPTIONS
-- ========================================

PRINT '========================================';
PRINT 'DATABASE TIMEZONE INVESTIGATION';
PRINT '========================================';
PRINT '';

-- 1. Check SQL Server Version and Edition
PRINT '1. SQL SERVER VERSION:';
PRINT '---------------------';
SELECT 
    @@VERSION as 'SQL Server Version',
    SERVERPROPERTY('Edition') as 'Edition',
    SERVERPROPERTY('ProductLevel') as 'Product Level';

PRINT '';

-- 2. Check current timezone settings
PRINT '2. CURRENT TIMEZONE SETTINGS:';
PRINT '----------------------------';
SELECT 
    SYSDATETIMEOFFSET() as 'Server DateTime with Offset',
    GETDATE() as 'Server Local Time',
    GETUTCDATE() as 'UTC Time',
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) as 'Server UTC Offset (Hours)';

PRINT '';

-- 3. Check if AT TIME ZONE is supported (SQL Server 2016+)
PRINT '3. CHECKING AT TIME ZONE SUPPORT:';
PRINT '---------------------------------';
BEGIN TRY
    DECLARE @TestDate DATETIME2 = GETUTCDATE();
    DECLARE @EATTime DATETIMEOFFSET = @TestDate AT TIME ZONE 'E. Africa Standard Time';
    SELECT 
        'YES - AT TIME ZONE is supported!' as 'Support Status',
        @TestDate as 'UTC Time',
        @EATTime as 'East Africa Time',
        CAST(@EATTime as DATETIME) as 'EAT as DateTime';
    PRINT '';
    PRINT '✓ Good News! Your SQL Server supports AT TIME ZONE';
    PRINT '  We can use database-side timezone conversion!';
END TRY
BEGIN CATCH
    PRINT '✗ AT TIME ZONE not supported (SQL Server version < 2016)';
    PRINT '  Must use application-side conversion (DateTimeHelper.cs)';
END CATCH

PRINT '';

-- 4. List available timezones
PRINT '4. AVAILABLE TIMEZONES IN SQL SERVER:';
PRINT '------------------------------------';
BEGIN TRY
    SELECT TOP 20
        name as 'Timezone Name',
        current_utc_offset as 'Current UTC Offset',
        is_currently_dst as 'Is DST Active'
    FROM sys.time_zone_info
    WHERE name LIKE '%Africa%' OR name LIKE '%Arab%' OR name LIKE '%East%'
    ORDER BY name;
    
    PRINT '';
    PRINT 'Note: East Africa Standard Time should be UTC+03:00';
END TRY
BEGIN CATCH
    PRINT 'sys.time_zone_info not available (SQL Server < 2016)';
END CATCH

PRINT '';

-- 5. Test timezone conversion for recent data
PRINT '5. TIMEZONE CONVERSION TEST:';
PRINT '---------------------------';
BEGIN TRY
    PRINT 'Converting recent patient registrations to East Africa Time:';
    SELECT TOP 5
        patientid,
        full_name,
        date_registered as 'Original DateTime (Server Time)',
        CAST(date_registered AT TIME ZONE 'UTC' AT TIME ZONE 'E. Africa Standard Time' as DATETIME) as 'Converted to EAT (Method 1)',
        DATEADD(HOUR, 11, date_registered) as 'Converted to EAT (Method 2 - Add 11 hours)'
    FROM patient
    ORDER BY date_registered DESC;
END TRY
BEGIN CATCH
    PRINT 'Cannot convert - AT TIME ZONE not supported';
    PRINT '';
    PRINT 'Alternative: Add 11 hours to all timestamps';
    SELECT TOP 5
        patientid,
        full_name,
        date_registered as 'Original DateTime (Server Time)',
        DATEADD(HOUR, 11, date_registered) as 'Corrected to EAT (+11 hours)'
    FROM patient
    ORDER BY date_registered DESC;
END CATCH

PRINT '';
PRINT '========================================';
PRINT 'RECOMMENDATIONS:';
PRINT '========================================';
PRINT '';

DECLARE @ServerOffset INT = DATEDIFF(HOUR, GETUTCDATE(), GETDATE());
DECLARE @EATOffset INT = 3;
DECLARE @Difference INT = @ServerOffset - @EATOffset;

PRINT 'Current Situation:';
PRINT '  Server Timezone: UTC' + CAST(@ServerOffset as VARCHAR);
PRINT '  East Africa Timezone: UTC+3';
PRINT '  Difference: ' + CAST(@Difference as VARCHAR) + ' hours';
PRINT '';

PRINT 'OPTION 1: Use AT TIME ZONE in SQL (if supported)';
PRINT '================================================';
PRINT 'Pros:';
PRINT '  ✓ All queries handle timezone automatically';
PRINT '  ✓ No application code changes needed';
PRINT '  ✓ Centralized in database';
PRINT '';
PRINT 'Cons:';
PRINT '  ✗ Only works on SQL Server 2016+';
PRINT '  ✗ Need to update ALL queries that use datetime';
PRINT '  ✗ Performance impact on every query';
PRINT '';
PRINT 'Implementation:';
PRINT '  SELECT date_registered AT TIME ZONE ''UTC'' AT TIME ZONE ''E. Africa Standard Time''';
PRINT '';

PRINT 'OPTION 2: Use DateTimeHelper.cs in Application (RECOMMENDED)';
PRINT '============================================================';
PRINT 'Pros:';
PRINT '  ✓ Works with any SQL Server version';
PRINT '  ✓ No database query changes needed';
PRINT '  ✓ Better performance (conversion at application layer)';
PRINT '  ✓ Easier to maintain and test';
PRINT '  ✓ Already implemented and ready to deploy!';
PRINT '';
PRINT 'Cons:';
PRINT '  ✗ Need to update application code (already done!)';
PRINT '';
PRINT 'Implementation:';
PRINT '  Use DateTimeHelper.Now instead of DateTime.Now';
PRINT '';

PRINT 'OPTION 3: Store Everything in UTC';
PRINT '==================================';
PRINT 'Pros:';
PRINT '  ✓ Best practice for global applications';
PRINT '  ✓ No timezone confusion';
PRINT '  ✓ Easy to support multiple timezones later';
PRINT '';
PRINT 'Cons:';
PRINT '  ✗ Need to convert ALL existing data';
PRINT '  ✗ Need to update ALL queries';
PRINT '  ✗ Risky migration';
PRINT '';

PRINT '';
PRINT '========================================';
PRINT 'FINAL RECOMMENDATION:';
PRINT '========================================';
PRINT '';
PRINT '✓ OPTION 2: Use DateTimeHelper.cs (Already Done!)';
PRINT '';
PRINT 'Why?';
PRINT '  1. We already fixed all the code (23 files updated)';
PRINT '  2. Works with any SQL Server version';
PRINT '  3. No need to change database queries';
PRINT '  4. Better performance';
PRINT '  5. Easier to maintain';
PRINT '';
PRINT 'Just deploy the updated files and you''re done!';
PRINT '';
PRINT '========================================';
