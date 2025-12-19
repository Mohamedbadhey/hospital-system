-- Check if pharmacy_returns tables exist
USE [juba_clinick]
GO

PRINT '========================================='
PRINT 'Checking Return System Tables'
PRINT '========================================='
PRINT ''

-- Check pharmacy_returns table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pharmacy_returns]') AND type in (N'U'))
BEGIN
    PRINT '✓ pharmacy_returns table EXISTS'
    SELECT COUNT(*) as 'Row Count' FROM pharmacy_returns
END
ELSE
BEGIN
    PRINT '✗ pharmacy_returns table DOES NOT EXIST'
    PRINT '  ACTION: Run pharmacy_return_system.sql script'
END
PRINT ''

-- Check pharmacy_return_items table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pharmacy_return_items]') AND type in (N'U'))
BEGIN
    PRINT '✓ pharmacy_return_items table EXISTS'
    SELECT COUNT(*) as 'Row Count' FROM pharmacy_return_items
END
ELSE
BEGIN
    PRINT '✗ pharmacy_return_items table DOES NOT EXIST'
    PRINT '  ACTION: Run pharmacy_return_system.sql script'
END
PRINT ''

-- Check view
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_pharmacy_returns_detail')
BEGIN
    PRINT '✓ vw_pharmacy_returns_detail view EXISTS'
END
ELSE
BEGIN
    PRINT '✗ vw_pharmacy_returns_detail view DOES NOT EXIST'
    PRINT '  ACTION: Run pharmacy_return_system.sql script'
END
PRINT ''

PRINT '========================================='
PRINT 'Summary:'
PRINT '========================================='
PRINT 'If any items are missing, run:'
PRINT '  pharmacy_return_system.sql'
PRINT ''
