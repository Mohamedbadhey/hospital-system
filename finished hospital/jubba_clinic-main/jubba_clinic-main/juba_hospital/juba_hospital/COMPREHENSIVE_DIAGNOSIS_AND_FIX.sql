-- =====================================================
-- COMPREHENSIVE DIAGNOSIS AND FIX
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'COMPREHENSIVE SALES SYSTEM DIAGNOSIS'
PRINT '====================================================='
PRINT ''

-- =====================================================
-- STEP 1: Check what sales exist
-- =====================================================
PRINT '1. CHECKING SALES DATA'
PRINT '-----------------------------------------------------'

DECLARE @salesCount INT, @itemsCount INT
SELECT @salesCount = COUNT(*) FROM pharmacy_sales
SELECT @itemsCount = COUNT(*) FROM pharmacy_sales_items

PRINT 'Total Sales: ' + CAST(@salesCount AS VARCHAR)
PRINT 'Total Sale Items: ' + CAST(@itemsCount AS VARCHAR)
PRINT ''

IF @salesCount > 0
BEGIN
    PRINT 'Recent Sales (Top 3):'
    SELECT TOP 3
        saleid,
        invoice_number,
        customer_name,
        total_amount,
        ISNULL(total_cost, 0) as total_cost,
        ISNULL(total_profit, 0) as total_profit,
        status,
        sale_date
    FROM pharmacy_sales
    ORDER BY saleid DESC
    
    PRINT ''
    PRINT 'Recent Sale Items (Top 5):'
    SELECT TOP 5
        psi.sale_item_id,
        psi.saleid,
        psi.medicineid,
        m.medicine_name,
        psi.quantity_type,
        psi.quantity,
        psi.unit_price,
        psi.total_price,
        ISNULL(psi.cost_price, 0) as cost_price,
        ISNULL(psi.profit, 0) as profit
    FROM pharmacy_sales_items psi
    LEFT JOIN medicine m ON psi.medicineid = m.medicineid
    ORDER BY psi.sale_item_id DESC
END
ELSE
BEGIN
    PRINT '⚠️  No sales found in database!'
END

PRINT ''

-- =====================================================
-- STEP 2: Check medicine cost prices
-- =====================================================
PRINT '2. CHECKING MEDICINE COST PRICES'
PRINT '-----------------------------------------------------'

DECLARE @medsWithCost INT
SELECT @medsWithCost = COUNT(*) 
FROM medicine 
WHERE ISNULL(cost_per_tablet, 0) > 0 
   OR ISNULL(cost_per_strip, 0) > 0 
   OR ISNULL(cost_per_box, 0) > 0

PRINT 'Medicines with cost prices: ' + CAST(@medsWithCost AS VARCHAR)
PRINT ''

IF @medsWithCost > 0
BEGIN
    PRINT 'Medicines with costs (Top 5):'
    SELECT TOP 5
        medicineid,
        medicine_name,
        ISNULL(cost_per_tablet, 0) as cost_per_tablet,
        ISNULL(cost_per_strip, 0) as cost_per_strip,
        ISNULL(cost_per_box, 0) as cost_per_box,
        ISNULL(price_per_tablet, 0) as price_per_tablet,
        ISNULL(price_per_strip, 0) as price_per_strip,
        ISNULL(price_per_box, 0) as price_per_box
    FROM medicine
    WHERE ISNULL(cost_per_tablet, 0) > 0 
       OR ISNULL(cost_per_strip, 0) > 0 
       OR ISNULL(cost_per_box, 0) > 0
END
ELSE
BEGIN
    PRINT '❌ NO MEDICINES HAVE COST PRICES!'
    PRINT '   This is why profit is 0.00'
    PRINT ''
    PRINT 'All medicines in system:'
    SELECT 
        medicineid,
        medicine_name,
        ISNULL(cost_per_tablet, 0) as cost_per_tablet,
        ISNULL(price_per_tablet, 0) as price_per_tablet
    FROM medicine
END

PRINT ''

-- =====================================================
-- STEP 3: Test report queries
-- =====================================================
PRINT '3. TESTING REPORT QUERIES'
PRINT '-----------------------------------------------------'

-- Today's profit
DECLARE @todayProfit DECIMAL(18,2)
SELECT @todayProfit = ISNULL(SUM(si.profit), 0)
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
WHERE CAST(s.sale_date AS DATE) = CAST(GETDATE() AS DATE)
AND s.status = 1

PRINT 'Today''s Profit Query Result: ' + CAST(@todayProfit AS VARCHAR)

-- Sales report test
DECLARE @reportCount INT
SELECT @reportCount = COUNT(*)
FROM pharmacy_sales s
LEFT JOIN pharmacy_sales_items si ON s.saleid = si.saleid
WHERE s.status = 1

PRINT 'Sales Report Record Count: ' + CAST(@reportCount AS VARCHAR)

-- Top medicines test
DECLARE @topMedCount INT
SELECT @topMedCount = COUNT(*)
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
INNER JOIN medicine m ON si.medicineid = m.medicineid
WHERE s.status = 1

PRINT 'Top Medicines Record Count: ' + CAST(@topMedCount AS VARCHAR)

PRINT ''

-- =====================================================
-- STEP 4: Diagnose the problem
-- =====================================================
PRINT '4. DIAGNOSIS'
PRINT '====================================================='
PRINT ''

IF @salesCount = 0
BEGIN
    PRINT '❌ PROBLEM: No sales in database'
    PRINT '   SOLUTION: Make a test sale in POS'
END
ELSE IF @medsWithCost = 0
BEGIN
    PRINT '❌ PROBLEM: Medicines have NO cost prices'
    PRINT '   SOLUTION: Go to Medicine Management and add cost prices'
    PRINT ''
    PRINT '   Example:'
    PRINT '   1. Edit a medicine'
    PRINT '   2. Enter Cost per Tablet: 1.00'
    PRINT '   3. Enter Cost per Strip: 9.00'
    PRINT '   4. Enter Price per Tablet: 1.50'
    PRINT '   5. Enter Price per Strip: 14.00'
    PRINT '   6. Save'
END
ELSE IF @todayProfit = 0 AND @salesCount > 0
BEGIN
    PRINT '⚠️  PROBLEM: Sales exist but profit is 0'
    PRINT '   Checking why...'
    PRINT ''
    
    -- Check if cost_price is being saved
    DECLARE @itemsWithCost INT
    SELECT @itemsWithCost = COUNT(*) FROM pharmacy_sales_items WHERE cost_price > 0
    
    IF @itemsWithCost = 0
    BEGIN
        PRINT '   ❌ cost_price not being saved in pharmacy_sales_items'
        PRINT '   SOLUTION: Cost calculation might be failing in POS'
        PRINT '   Check if medicines sold have cost prices set'
    END
    ELSE
    BEGIN
        PRINT '   ⚠️  cost_price IS saved in items table'
        PRINT '   But total_profit in sales table might be 0'
        PRINT ''
        
        -- Check sales table
        DECLARE @salesWithProfit INT
        SELECT @salesWithProfit = COUNT(*) FROM pharmacy_sales WHERE total_profit > 0
        
        IF @salesWithProfit = 0
        BEGIN
            PRINT '   ❌ total_profit NOT saved in pharmacy_sales table'
            PRINT '   SOLUTION: POS UPDATE query might be failing'
            PRINT ''
            PRINT '   FIX: Run the update below to calculate from items'
        END
    END
END
ELSE
BEGIN
    PRINT '✅ System appears to be working!'
    PRINT '   Profit: ' + CAST(@todayProfit AS VARCHAR)
END

PRINT ''

-- =====================================================
-- STEP 5: Offer to fix old sales data
-- =====================================================
PRINT '5. FIX OLD SALES DATA (OPTIONAL)'
PRINT '====================================================='
PRINT ''

IF @salesCount > 0 AND EXISTS (SELECT * FROM pharmacy_sales WHERE ISNULL(total_profit, 0) = 0)
BEGIN
    PRINT 'Found sales with missing profit data.'
    PRINT 'To fix, run this UPDATE:'
    PRINT ''
    PRINT '-- Recalculate total_cost and total_profit for all sales'
    PRINT 'UPDATE pharmacy_sales'
    PRINT 'SET '
    PRINT '    total_cost = ('
    PRINT '        SELECT ISNULL(SUM(cost_price * quantity), 0)'
    PRINT '        FROM pharmacy_sales_items'
    PRINT '        WHERE saleid = pharmacy_sales.saleid'
    PRINT '    ),'
    PRINT '    total_profit = ('
    PRINT '        SELECT ISNULL(SUM(profit), 0)'
    PRINT '        FROM pharmacy_sales_items'
    PRINT '        WHERE saleid = pharmacy_sales.saleid'
    PRINT '    )'
    PRINT 'WHERE saleid IN (SELECT saleid FROM pharmacy_sales)'
    PRINT ''
    PRINT 'Do you want to run this fix? (Y/N)'
    PRINT ''
    PRINT '-- UNCOMMENT THE LINES BELOW TO RUN THE FIX --'
    PRINT '/*'
    PRINT ''
    
    -- The actual fix (commented out - user needs to uncomment)
    /*
    UPDATE pharmacy_sales
    SET 
        total_cost = (
            SELECT ISNULL(SUM(cost_price * quantity), 0)
            FROM pharmacy_sales_items
            WHERE saleid = pharmacy_sales.saleid
        ),
        total_profit = (
            SELECT ISNULL(SUM(profit), 0)
            FROM pharmacy_sales_items
            WHERE saleid = pharmacy_sales.saleid
        )
    WHERE saleid IN (SELECT saleid FROM pharmacy_sales)
    
    PRINT 'Sales data updated!'
    */
    
    PRINT '*/'
END
ELSE
BEGIN
    PRINT 'No old sales data needs fixing.'
END

PRINT ''
PRINT '====================================================='
PRINT 'DIAGNOSIS COMPLETE'
PRINT '====================================================='
PRINT ''
PRINT 'SUMMARY:'
PRINT '  • Sales in system: ' + CAST(@salesCount AS VARCHAR)
PRINT '  • Medicines with costs: ' + CAST(@medsWithCost AS VARCHAR)
PRINT '  • Today''s profit: ' + CAST(@todayProfit AS VARCHAR)
PRINT ''
