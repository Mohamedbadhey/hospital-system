-- Timezone Diagnostic Script
-- Run this on both local and SmarterASP databases to compare

-- 1. Check current database time
SELECT 
    'Current Database Time' as Info,
    GETDATE() as ServerTime,
    GETUTCDATE() as UTCTime,
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) as ServerOffsetHours;

-- 2. Check recent patient registration times
SELECT TOP 10
    'Recent Registrations' as Info,
    patientid,
    full_name,
    date_registered,
    DATEADD(HOUR, 3, CAST(date_registered as datetime)) as EAT_Time_If_UTC_Stored,
    DATEDIFF(HOUR, date_registered, GETDATE()) as HoursAgo
FROM patient
ORDER BY date_registered DESC;

-- 3. Check recent lab orders
SELECT TOP 10
    'Recent Lab Orders' as Info,
    med_id,
    prescid,
    date_taken,
    DATEDIFF(HOUR, date_taken, GETDATE()) as HoursAgo
FROM lab_test
ORDER BY date_taken DESC;

-- 4. Check recent pharmacy sales
SELECT TOP 10
    'Recent Pharmacy Sales' as Info,
    saleid,
    sale_date,
    DATEDIFF(HOUR, sale_date, GETDATE()) as HoursAgo
FROM pharmacy_sales
ORDER BY sale_date DESC;

-- 5. Check recent charges
SELECT TOP 10
    'Recent Charges' as Info,
    charge_id,
    charge_type,
    date_added,
    DATEDIFF(HOUR, date_added, GETDATE()) as HoursAgo
FROM patient_charges
ORDER BY date_added DESC;

-- 6. Expected vs Actual Time Comparison
SELECT 
    'Time Comparison' as Info,
    GETDATE() as CurrentServerTime,
    GETUTCDATE() as CurrentUTCTime,
    DATEADD(HOUR, 3, GETUTCDATE()) as ExpectedEATTime,
    CASE 
        WHEN DATEDIFF(HOUR, DATEADD(HOUR, 3, GETUTCDATE()), GETDATE()) = 0 
        THEN 'Server is in EAT (UTC+3) ✓'
        ELSE 'Server timezone is different! Offset: ' + 
             CAST(DATEDIFF(HOUR, DATEADD(HOUR, 3, GETUTCDATE()), GETDATE()) as varchar) + ' hours'
    END as TimezoneStatus;
