-- =====================================================
-- FINAL COMPLETE FIX - ALL ISSUES
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'FINAL COMPLETE FIX FOR SALES SYSTEM'
PRINT '====================================================='
PRINT ''

-- =====================================================
-- STEP 1: Show current data state
-- =====================================================
PRINT '1. CURRENT DATA STATE'
PRINT '-----------------------------------------------------'

SELECT 
    'Sales' as table_name,
    COUNT(*) as record_count,
    SUM(CASE WHEN ISNULL(total_profit, 0) > 0 THEN 1 ELSE 0 END) as records_with_profit
FROM pharmacy_sales

UNION ALL

SELECT 
    'Sales Items' as table_name,
    COUNT(*) as record_count,
    SUM(CASE WHEN ISNULL(profit, 0) > 0 THEN 1 ELSE 0 END) as records_with_profit
FROM pharmacy_sales_items

PRINT ''
PRINT 'Actual sales data:'
SELECT 
    s.saleid,
    s.invoice_number,
    CONVERT(VARCHAR, s.sale_date, 103) as sale_date,
    s.total_amount,
    ISNULL(s.total_cost, 0) as total_cost,
    ISNULL(s.total_profit, 0) as total_profit,
    (SELECT COUNT(*) FROM pharmacy_sales_items WHERE saleid = s.saleid) as item_count
FROM pharmacy_sales s
ORDER BY s.saleid DESC

PRINT ''

-- =====================================================
-- STEP 2: Recalculate profit from items
-- =====================================================
PRINT '2. RECALCULATING PROFIT'
PRINT '-----------------------------------------------------'

UPDATE pharmacy_sales
SET 
    total_cost = (
        SELECT ISNULL(SUM(ISNULL(cost_price, 0) * ISNULL(quantity, 0)), 0)
        FROM pharmacy_sales_items
        WHERE saleid = pharmacy_sales.saleid
    ),
    total_profit = (
        SELECT ISNULL(SUM(ISNULL(profit, 0)), 0)
        FROM pharmacy_sales_items
        WHERE saleid = pharmacy_sales.saleid
    )
WHERE saleid IN (SELECT saleid FROM pharmacy_sales)

PRINT 'Profit recalculated for all sales'
PRINT ''

-- =====================================================
-- STEP 3: Check if medicines have cost prices
-- =====================================================
PRINT '3. CHECKING MEDICINES'
PRINT '-----------------------------------------------------'

DECLARE @medsWithCosts INT, @totalMeds INT
SELECT @totalMeds = COUNT(*) FROM medicine
SELECT @medsWithCosts = COUNT(*) FROM medicine 
WHERE ISNULL(cost_per_tablet, 0) > 0 
   OR ISNULL(cost_per_strip, 0) > 0 
   OR ISNULL(cost_per_box, 0) > 0

PRINT 'Total medicines: ' + CAST(@totalMeds AS VARCHAR)
PRINT 'Medicines with cost prices: ' + CAST(@medsWithCosts AS VARCHAR)

IF @medsWithCosts = 0
BEGIN
    PRINT ''
    PRINT '❌ WARNING: No medicines have cost prices!'
    PRINT '   This is why profit is still 0'
    PRINT '   You need to add cost prices to medicines'
END

PRINT ''

-- =====================================================
-- STEP 4: Show updated data
-- =====================================================
PRINT '4. UPDATED DATA'
PRINT '-----------------------------------------------------'

SELECT 
    s.saleid,
    s.invoice_number,
    CONVERT(VARCHAR, s.sale_date, 103) as sale_date,
    s.total_amount,
    ISNULL(s.total_cost, 0) as total_cost,
    ISNULL(s.total_profit, 0) as total_profit,
    CASE 
        WHEN ISNULL(s.total_profit, 0) > 0 THEN '✓ Has Profit'
        ELSE '✗ No Profit (need medicine costs)'
    END as status
FROM pharmacy_sales s
ORDER BY s.saleid DESC

PRINT ''

-- =====================================================
-- STEP 5: Test queries used by reports
-- =====================================================
PRINT '5. TESTING REPORT QUERIES'
PRINT '-----------------------------------------------------'

-- Today's profit
DECLARE @todayProfit DECIMAL(18,2)
SELECT @todayProfit = ISNULL(SUM(si.profit), 0)
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
WHERE CAST(s.sale_date AS DATE) = CAST(GETDATE() AS DATE)
AND s.status = 1

PRINT 'Today''s Profit Query: ' + CAST(@todayProfit AS VARCHAR)

-- Last 30 days sales
DECLARE @last30DaysSales INT
SELECT @last30DaysSales = COUNT(*)
FROM pharmacy_sales s
WHERE CAST(s.sale_date AS DATE) BETWEEN DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)
AND s.status = 1

PRINT 'Sales in last 30 days: ' + CAST(@last30DaysSales AS VARCHAR)

-- Top medicines
DECLARE @topMedicinesCount INT
SELECT @topMedicinesCount = COUNT(DISTINCT m.medicine_name)
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
LEFT JOIN medicine m ON si.medicineid = m.medicineid
WHERE s.status = 1
AND m.medicineid IS NOT NULL

PRINT 'Unique medicines sold: ' + CAST(@topMedicinesCount AS VARCHAR)

PRINT ''

-- =====================================================
-- STEP 6: Recommendations
-- =====================================================
PRINT '6. RECOMMENDATIONS'
PRINT '====================================================='
PRINT ''

IF @medsWithCosts = 0
BEGIN
    PRINT '🎯 ACTION REQUIRED:'
    PRINT ''
    PRINT '  1. Go to Medicine Management page'
    PRINT '  2. Edit each medicine you sell'
    PRINT '  3. Add cost prices:'
    PRINT '     - Cost per Tablet: (what you pay per piece)'
    PRINT '     - Cost per Strip: (what you pay per strip)'
    PRINT '     - Cost per Box: (what you pay per box)'
    PRINT '  4. Add selling prices:'
    PRINT '     - Price per Tablet: (what customers pay per piece)'
    PRINT '     - Price per Strip: (what customers pay per strip)'
    PRINT '     - Price per Box: (what customers pay per box)'
    PRINT '  5. Save'
    PRINT ''
    PRINT '  After adding costs, make a NEW sale to test profit tracking'
END
ELSE
BEGIN
    PRINT '✅ Medicines have cost prices'
    PRINT ''
    PRINT '   If profit is still 0, check:'
    PRINT '   1. Did you sell medicines that have cost prices?'
    PRINT '   2. Did you rebuild and deploy the application?'
    PRINT '   3. Make a NEW sale after deployment'
END

PRINT ''
PRINT '====================================================='
PRINT 'FIX COMPLETE'
PRINT '====================================================='
