-- =====================================================
-- CHECK SALES DATA COMPATIBILITY
-- =====================================================
-- This script checks if all sales pages will work correctly
-- with the current database structure
-- =====================================================

USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'SALES DATA COMPATIBILITY CHECK'
PRINT '====================================================='
PRINT ''

-- =====================================================
-- CHECK 1: Verify sales tables exist
-- =====================================================
PRINT '1. CHECKING TABLES EXIST'
PRINT '-----------------------------------------------------'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
    PRINT '  ✅ pharmacy_sales table exists'
ELSE
    PRINT '  ❌ pharmacy_sales table MISSING!'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
    PRINT '  ✅ pharmacy_sales_items table exists'
ELSE
    PRINT '  ❌ pharmacy_sales_items table MISSING!'

PRINT ''

-- =====================================================
-- CHECK 2: Verify column compatibility
-- =====================================================
PRINT '2. CHECKING COLUMN COMPATIBILITY'
PRINT '-----------------------------------------------------'

-- pharmacy_sales columns
PRINT ''
PRINT 'pharmacy_sales columns needed by reports:'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'saleid')
    PRINT '  ✅ saleid column exists'
ELSE
    PRINT '  ❌ saleid column MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'sale_id')
    PRINT '  ✅ sale_id column exists'
ELSE
    PRINT '  ⚠️  sale_id column missing (not critical if saleid exists)'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_cost')
    PRINT '  ✅ total_cost column exists'
ELSE
    PRINT '  ❌ total_cost column MISSING! (needed for profit reports)'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_profit')
    PRINT '  ✅ total_profit column exists'
ELSE
    PRINT '  ❌ total_profit column MISSING! (needed for profit reports)'

-- pharmacy_sales_items columns
PRINT ''
PRINT 'pharmacy_sales_items columns needed by reports:'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'saleid')
    PRINT '  ✅ saleid column exists'
ELSE
    PRINT '  ❌ saleid column MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_id')
    PRINT '  ✅ sale_id column exists'
ELSE
    PRINT '  ⚠️  sale_id column missing'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicineid')
    PRINT '  ✅ medicineid column exists'
ELSE
    PRINT '  ❌ medicineid column MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicine_id')
    PRINT '  ✅ medicine_id column exists'
ELSE
    PRINT '  ⚠️  medicine_id column missing'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'cost_price')
    PRINT '  ✅ cost_price column exists'
ELSE
    PRINT '  ❌ cost_price column MISSING! (needed for profit tracking)'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
    PRINT '  ✅ profit column exists'
ELSE
    PRINT '  ⚠️  profit column missing'
    
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit_amount')
    PRINT '  ✅ profit_amount column exists'
ELSE
    PRINT '  ⚠️  profit_amount column missing (dashboard uses this)'

PRINT ''

-- =====================================================
-- CHECK 3: Test actual sales data
-- =====================================================
PRINT '3. CHECKING ACTUAL SALES DATA'
PRINT '-----------------------------------------------------'
PRINT ''

DECLARE @salesCount INT, @itemsCount INT

SELECT @salesCount = COUNT(*) FROM pharmacy_sales
SELECT @itemsCount = COUNT(*) FROM pharmacy_sales_items

PRINT 'Total Sales Records: ' + CAST(@salesCount AS VARCHAR)
PRINT 'Total Sales Items: ' + CAST(@itemsCount AS VARCHAR)

IF @salesCount > 0
BEGIN
    PRINT ''
    PRINT 'Recent Sales (Top 3):'
    SELECT TOP 3
        invoice_number,
        customer_name,
        total_amount,
        ISNULL(total_cost, 0) as total_cost,
        ISNULL(total_profit, 0) as total_profit,
        CONVERT(VARCHAR, sale_date, 103) as sale_date
    FROM pharmacy_sales
    ORDER BY sale_date DESC
    
    PRINT ''
    PRINT 'Recent Sales Items (Top 5):'
    SELECT TOP 5
        psi.sale_item_id,
        ps.invoice_number,
        m.medicine_name,
        psi.quantity_type,
        psi.quantity,
        psi.unit_price,
        psi.total_price,
        ISNULL(psi.cost_price, 0) as cost_price,
        ISNULL(psi.profit, 0) as profit
    FROM pharmacy_sales_items psi
    LEFT JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
    LEFT JOIN medicine m ON psi.medicineid = m.medicineid
    ORDER BY psi.sale_item_id DESC
END
ELSE
BEGIN
    PRINT ''
    PRINT '⚠️  No sales data found yet'
END

PRINT ''

-- =====================================================
-- CHECK 4: Test queries used by reports
-- =====================================================
PRINT '4. TESTING REPORT QUERIES'
PRINT '-----------------------------------------------------'
PRINT ''

-- Test Sales History Query
BEGIN TRY
    PRINT 'Testing Sales History query...'
    DECLARE @testCount1 INT
    SELECT @testCount1 = COUNT(*) 
    FROM pharmacy_sales s
    WHERE (SELECT COUNT(*) FROM pharmacy_sales_items WHERE saleid = s.saleid) > 0
    PRINT '  ✅ Sales History query works - ' + CAST(@testCount1 AS VARCHAR) + ' sales found'
END TRY
BEGIN CATCH
    PRINT '  ❌ Sales History query FAILED: ' + ERROR_MESSAGE()
END CATCH

-- Test Invoice Query
BEGIN TRY
    PRINT 'Testing Invoice query...'
    DECLARE @testCount2 INT
    SELECT @testCount2 = COUNT(*)
    FROM pharmacy_sales_items si
    INNER JOIN medicine m ON si.medicineid = m.medicineid
    PRINT '  ✅ Invoice query works - ' + CAST(@testCount2 AS VARCHAR) + ' items found'
END TRY
BEGIN CATCH
    PRINT '  ❌ Invoice query FAILED: ' + ERROR_MESSAGE()
END CATCH

-- Test Dashboard Today's Sales Query
BEGIN TRY
    PRINT 'Testing Dashboard sales query...'
    DECLARE @testTotal DECIMAL(18,2)
    SELECT @testTotal = ISNULL(SUM(total_amount), 0)
    FROM pharmacy_sales
    WHERE CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)
    PRINT '  ✅ Dashboard sales query works - Total: ' + CAST(@testTotal AS VARCHAR)
END TRY
BEGIN CATCH
    PRINT '  ❌ Dashboard sales query FAILED: ' + ERROR_MESSAGE()
END CATCH

-- Test Dashboard Profit Query (checking for profit_amount vs profit)
BEGIN TRY
    PRINT 'Testing Dashboard profit query (using profit_amount)...'
    DECLARE @testProfit DECIMAL(18,2)
    
    -- Check if profit_amount column exists
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit_amount')
    BEGIN
        SELECT @testProfit = ISNULL(SUM(profit_amount), 0)
        FROM pharmacy_sales_items
        PRINT '  ✅ Dashboard profit query works (profit_amount) - Total: ' + CAST(@testProfit AS VARCHAR)
    END
    ELSE IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
    BEGIN
        SELECT @testProfit = ISNULL(SUM(profit), 0)
        FROM pharmacy_sales_items
        PRINT '  ✅ Dashboard profit query works (profit) - Total: ' + CAST(@testProfit AS VARCHAR)
        PRINT '  ⚠️  Note: Dashboard code uses profit_amount but table has profit column'
    END
    ELSE
    BEGIN
        PRINT '  ❌ No profit column found (neither profit_amount nor profit)'
    END
END TRY
BEGIN CATCH
    PRINT '  ❌ Dashboard profit query FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =====================================================
-- CHECK 5: Issues Summary
-- =====================================================
PRINT '5. ISSUES SUMMARY'
PRINT '====================================================='
PRINT ''

DECLARE @issuesFound INT = 0

-- Check for missing total_cost and total_profit
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_cost')
BEGIN
    PRINT '  ❌ ISSUE: pharmacy_sales missing total_cost column'
    SET @issuesFound = @issuesFound + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_profit')
BEGIN
    PRINT '  ❌ ISSUE: pharmacy_sales missing total_profit column'
    SET @issuesFound = @issuesFound + 1
END

-- Check for profit_amount vs profit mismatch
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
   AND NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit_amount')
BEGIN
    PRINT '  ⚠️  WARNING: Dashboard uses profit_amount but table has profit column'
    PRINT '     Solution: Add alias or rename column'
    SET @issuesFound = @issuesFound + 1
END

IF @issuesFound = 0
BEGIN
    PRINT '  ✅ No critical issues found!'
    PRINT ''
    PRINT '  All sales pages should work correctly:'
    PRINT '    • Sales History page ✅'
    PRINT '    • Sales Reports page ✅'
    PRINT '    • Invoice page ✅'
    PRINT '    • Dashboard ✅'
END
ELSE
BEGIN
    PRINT ''
    PRINT '  ' + CAST(@issuesFound AS VARCHAR) + ' issue(s) found - see above for details'
END

PRINT ''
PRINT '====================================================='
PRINT 'CHECK COMPLETE'
PRINT '====================================================='
