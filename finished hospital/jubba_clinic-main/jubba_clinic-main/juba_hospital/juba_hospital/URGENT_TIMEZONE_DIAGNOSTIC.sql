-- ========================================
-- URGENT: Timezone Diagnostic for SmarterASP Deployment
-- Run this on your DEPLOYED database in SQL Server Management Studio
-- ========================================

PRINT '========================================';
PRINT 'TIMEZONE DIAGNOSTIC REPORT';
PRINT '========================================';
PRINT '';

-- 1. Current Time Information
PRINT '1. CURRENT TIME INFORMATION:';
PRINT '----------------------------';
SELECT 
    GETDATE() as 'Server Time (SmarterASP)',
    GETUTCDATE() as 'UTC Time',
    DATEADD(HOUR, 3, GETUTCDATE()) as 'Expected East Africa Time (UTC+3)',
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) as 'Server Offset from UTC (Hours)',
    DATEDIFF(HOUR, DATEADD(HOUR, 3, GETUTCDATE()), GETDATE()) as 'Difference from EAT (Hours)';

PRINT '';

-- 2. Recent Patient Registrations
PRINT '2. RECENT PATIENT REGISTRATIONS:';
PRINT '--------------------------------';
SELECT TOP 5
    patientid,
    full_name,
    date_registered as 'Registration Time (as stored)',
    DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), DATEADD(HOUR, 3, GETUTCDATE())), date_registered) as 'Corrected EAT Time',
    DATEDIFF(HOUR, date_registered, GETDATE()) as 'Hours Ago (server time)'
FROM patient
ORDER BY date_registered DESC;

PRINT '';

-- 3. Recent Lab Orders
PRINT '3. RECENT LAB ORDERS:';
PRINT '--------------------';
SELECT TOP 5
    med_id,
    prescid,
    date_taken as 'Order Time (as stored)',
    DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), DATEADD(HOUR, 3, GETUTCDATE())), date_taken) as 'Corrected EAT Time',
    DATEDIFF(HOUR, date_taken, GETDATE()) as 'Hours Ago (server time)'
FROM lab_test
ORDER BY date_taken DESC;

PRINT '';

-- 4. Recent Pharmacy Sales
PRINT '4. RECENT PHARMACY SALES:';
PRINT '------------------------';
SELECT TOP 5
    saleid,
    sale_date as 'Sale Time (as stored)',
    DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), DATEADD(HOUR, 3, GETUTCDATE())), sale_date) as 'Corrected EAT Time',
    total_amount,
    DATEDIFF(HOUR, sale_date, GETDATE()) as 'Hours Ago (server time)'
FROM pharmacy_sales
WHERE sale_date IS NOT NULL
ORDER BY sale_date DESC;

PRINT '';

-- 5. Recent Patient Charges
PRINT '5. RECENT PATIENT CHARGES:';
PRINT '-------------------------';
SELECT TOP 5
    charge_id,
    charge_type,
    charge_name,
    date_added as 'Charge Time (as stored)',
    DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), DATEADD(HOUR, 3, GETUTCDATE())), date_added) as 'Corrected EAT Time',
    amount,
    DATEDIFF(HOUR, date_added, GETDATE()) as 'Hours Ago (server time)'
FROM patient_charges
ORDER BY date_added DESC;

PRINT '';

-- 6. Time Difference Analysis
PRINT '6. TIME DIFFERENCE ANALYSIS:';
PRINT '---------------------------';
DECLARE @ServerOffset INT = DATEDIFF(HOUR, GETUTCDATE(), GETDATE());
DECLARE @EATOffset INT = 3; -- East Africa is UTC+3
DECLARE @Difference INT = @ServerOffset - @EATOffset;

SELECT 
    @ServerOffset as 'Server UTC Offset (Hours)',
    @EATOffset as 'East Africa UTC Offset (Hours)',
    @Difference as 'Time Difference (Hours)',
    CASE 
        WHEN @Difference = 0 THEN '✓ Server is already in EAT timezone'
        WHEN @Difference > 0 THEN '⚠ Server is ' + CAST(@Difference as varchar) + ' hours AHEAD of EAT'
        WHEN @Difference < 0 THEN '⚠ Server is ' + CAST(ABS(@Difference) as varchar) + ' hours BEHIND EAT'
    END as 'Status';

PRINT '';
PRINT '========================================';
PRINT 'RECOMMENDATIONS:';
PRINT '========================================';
PRINT '';

IF @Difference = 0
BEGIN
    PRINT '✓ Good news! Server is already in East Africa Time.';
    PRINT '  No timezone conversion needed.';
    PRINT '  You can use DateTime.Now directly.';
END
ELSE IF @Difference > 0
BEGIN
    PRINT '⚠ Server is ' + CAST(@Difference as varchar) + ' hours ahead of East Africa Time.';
    PRINT '  Examples:';
    PRINT '    - When it''s 12:00 PM in Somalia, server shows ' + CAST(12 + @Difference as varchar) + ':00 PM';
    PRINT '  ';
    PRINT '  SOLUTION: Use DateTimeHelper.Now in your C# code';
    PRINT '  This will automatically adjust to East Africa Time.';
END
ELSE
BEGIN
    PRINT '⚠ Server is ' + CAST(ABS(@Difference) as varchar) + ' hours behind East Africa Time.';
    PRINT '  Examples:';
    PRINT '    - When it''s 12:00 PM in Somalia, server shows ' + CAST(12 + @Difference as varchar) + ':00 AM';
    PRINT '  ';
    PRINT '  SOLUTION: Use DateTimeHelper.Now in your C# code';
    PRINT '  This will automatically adjust to East Africa Time.';
END

PRINT '';
PRINT '========================================';
PRINT 'DIAGNOSTIC COMPLETE';
PRINT '========================================';
