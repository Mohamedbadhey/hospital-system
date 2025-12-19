-- =====================================================
-- FIX TIMEZONE ISSUES - DEPLOYED SERVER
-- =====================================================
-- Run this AFTER running CHECK_DEPLOYED_SERVER_TIMEZONE.sql
-- and identifying your timezone issue
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'TIMEZONE FIX SCRIPT'
PRINT '======================================='
GO

-- =====================================================
-- OPTION 1: Fix dates that are 3 hours in the future
-- (If your server is UTC but data was inserted as EAT)
-- =====================================================

PRINT ''
PRINT '------- OPTION 1: Remove 3 hours from future dates -------'
PRINT 'Uncomment and run if dates are 3 hours in the future'
PRINT ''

/*
-- Backup first!
-- Fix patient registration dates
UPDATE patient
SET registration_date = DATEADD(HOUR, -3, registration_date)
WHERE registration_date > GETDATE()

-- Fix prescription dates
UPDATE prescribtion
SET created_date = DATEADD(HOUR, -3, created_date)
WHERE created_date > GETDATE()

-- Fix pharmacy sales dates
UPDATE pharmacy_sales
SET sale_date = DATEADD(HOUR, -3, sale_date)
WHERE sale_date > GETDATE()

-- Fix medicine inventory dates
UPDATE medicine_inventory
SET added_date = DATEADD(HOUR, -3, added_date)
WHERE added_date > GETDATE()

PRINT 'Dates adjusted: Removed 3 hours from future dates'
*/

-- =====================================================
-- OPTION 2: Fix dates that are 3 hours in the past
-- (If your server is EAT but data was inserted as UTC)
-- =====================================================

PRINT ''
PRINT '------- OPTION 2: Add 3 hours to past dates -------'
PRINT 'Uncomment and run if dates are 3 hours in the past'
PRINT ''

/*
-- Fix patient registration dates
UPDATE patient
SET registration_date = DATEADD(HOUR, 3, registration_date)

-- Fix prescription dates
UPDATE prescribtion
SET created_date = DATEADD(HOUR, 3, created_date)

-- Fix pharmacy sales dates
UPDATE pharmacy_sales
SET sale_date = DATEADD(HOUR, 3, sale_date)

-- Fix medicine inventory dates
UPDATE medicine_inventory
SET added_date = DATEADD(HOUR, 3, added_date)

PRINT 'Dates adjusted: Added 3 hours to dates'
*/

-- =====================================================
-- OPTION 3: Create helper functions for timezone conversion
-- =====================================================

PRINT ''
PRINT '------- Creating timezone helper functions -------'

-- Function to convert UTC to EAT
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_UTC_to_EAT')
    DROP FUNCTION fn_UTC_to_EAT
GO

CREATE FUNCTION dbo.fn_UTC_to_EAT (@UTCDateTime DATETIME)
RETURNS DATETIME
AS
BEGIN
    RETURN DATEADD(HOUR, 3, @UTCDateTime)
END
GO

-- Function to convert EAT to UTC
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_EAT_to_UTC')
    DROP FUNCTION fn_EAT_to_UTC
GO

CREATE FUNCTION dbo.fn_EAT_to_UTC (@EATDateTime DATETIME)
RETURNS DATETIME
AS
BEGIN
    RETURN DATEADD(HOUR, -3, @EATDateTime)
END
GO

PRINT 'Timezone conversion functions created successfully'
PRINT 'Usage: SELECT dbo.fn_UTC_to_EAT(GETUTCDATE()) AS EAT_Time'
PRINT 'Usage: SELECT dbo.fn_EAT_to_UTC(GETDATE()) AS UTC_Time'
GO

-- =====================================================
-- TEST THE FUNCTIONS
-- =====================================================

PRINT ''
PRINT '------- Testing timezone functions -------'

SELECT 
    'Current UTC Time' AS Description,
    GETUTCDATE() AS Time
UNION ALL
SELECT 
    'Current Server Time',
    GETDATE()
UNION ALL
SELECT 
    'UTC converted to EAT',
    dbo.fn_UTC_to_EAT(GETUTCDATE())
UNION ALL
SELECT 
    'Server Time converted to UTC',
    dbo.fn_EAT_to_UTC(GETDATE())
GO

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

PRINT ''
PRINT '------- Verification: Check for future dates -------'

SELECT 
    'Patients with future dates' AS CheckType,
    COUNT(*) AS Count
FROM patient
WHERE registration_date > GETDATE()

UNION ALL

SELECT 
    'Prescriptions with future dates',
    COUNT(*)
FROM prescribtion
WHERE created_date > GETDATE()

UNION ALL

SELECT 
    'Pharmacy sales with future dates',
    COUNT(*)
FROM pharmacy_sales
WHERE sale_date > GETDATE()
GO

PRINT ''
PRINT '======================================='
PRINT 'NEXT STEPS:'
PRINT '======================================='
PRINT '1. Review the CHECK_DEPLOYED_SERVER_TIMEZONE.sql results'
PRINT '2. Uncomment the appropriate FIX option above'
PRINT '3. Test on a few records first'
PRINT '4. Apply fix to all data'
PRINT '5. Update Web.config connection string if needed'
PRINT '======================================='
GO
