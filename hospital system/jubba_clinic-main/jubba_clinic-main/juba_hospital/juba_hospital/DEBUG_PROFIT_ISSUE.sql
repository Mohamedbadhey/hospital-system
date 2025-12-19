-- =====================================================
-- DEBUG PROFIT ISSUE FOR SPECIFIC SALE
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'DEBUGGING PROFIT CALCULATION'
PRINT '====================================================='
PRINT ''

-- Find the sale
DECLARE @invoiceNumber VARCHAR(50) = 'INV-20251129-013908'

PRINT 'SALE DETAILS:'
PRINT '-----------------------------------------------------'
SELECT 
    s.saleid,
    s.invoice_number,
    s.total_amount,
    s.total_cost,
    s.total_profit,
    s.sale_date
FROM pharmacy_sales s
WHERE s.invoice_number = @invoiceNumber

PRINT ''
PRINT 'SALE ITEMS:'
PRINT '-----------------------------------------------------'
SELECT 
    si.sale_item_id,
    m.medicine_name,
    si.quantity_type,
    si.quantity,
    si.unit_price,
    si.total_price,
    si.cost_price,
    si.profit
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
INNER JOIN medicine m ON si.medicineid = m.medicineid
WHERE s.invoice_number = @invoiceNumber

PRINT ''
PRINT 'MEDICINE COST PRICES:'
PRINT '-----------------------------------------------------'
SELECT 
    m.medicineid,
    m.medicine_name,
    m.cost_per_tablet,
    m.cost_per_strip,
    m.cost_per_box,
    m.price_per_tablet,
    m.price_per_strip,
    m.price_per_box
FROM medicine m
WHERE m.medicineid IN (
    SELECT si.medicineid 
    FROM pharmacy_sales_items si
    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
    WHERE s.invoice_number = @invoiceNumber
)

PRINT ''
PRINT 'INVENTORY PURCHASE PRICES:'
PRINT '-----------------------------------------------------'
SELECT 
    mi.inventoryid,
    m.medicine_name,
    mi.purchase_price,
    mi.batch_number
FROM medicine_inventory mi
INNER JOIN medicine m ON mi.medicineid = m.medicineid
WHERE mi.inventoryid IN (
    SELECT si.inventoryid 
    FROM pharmacy_sales_items si
    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
    WHERE s.invoice_number = @invoiceNumber
)

PRINT ''
PRINT 'DIAGNOSIS:'
PRINT '====================================================='
PRINT ''

-- Check if medicine has cost prices
DECLARE @hasCostPrices BIT = 0
SELECT @hasCostPrices = CASE 
    WHEN SUM(ISNULL(cost_per_tablet, 0) + ISNULL(cost_per_strip, 0) + ISNULL(cost_per_box, 0)) > 0 
    THEN 1 ELSE 0 
END
FROM medicine m
WHERE m.medicineid IN (
    SELECT si.medicineid 
    FROM pharmacy_sales_items si
    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
    WHERE s.invoice_number = @invoiceNumber
)

IF @hasCostPrices = 0
BEGIN
    PRINT '❌ PROBLEM: Medicine has NO cost prices set!'
    PRINT ''
    PRINT 'SOLUTION:'
    PRINT '  1. Go to Medicine Management'
    PRINT '  2. Find this medicine and click Edit'
    PRINT '  3. Add cost prices:'
    PRINT '     - Cost per Tablet/Piece'
    PRINT '     - Cost per Strip'
    PRINT '     - Cost per Box'
    PRINT '  4. Save'
    PRINT '  5. Make a NEW sale to test'
END
ELSE
BEGIN
    PRINT '✅ Medicine has cost prices'
    PRINT ''
    PRINT 'Checking why profit is still 0...'
    PRINT ''
    
    -- Check if cost_price was saved in sale items
    DECLARE @itemHasCost BIT = 0
    SELECT @itemHasCost = CASE WHEN SUM(ISNULL(cost_price, 0)) > 0 THEN 1 ELSE 0 END
    FROM pharmacy_sales_items si
    INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
    WHERE s.invoice_number = @invoiceNumber
    
    IF @itemHasCost = 0
    BEGIN
        PRINT '❌ PROBLEM: Cost price not calculated during sale'
        PRINT '   This means POS cost calculation failed'
        PRINT ''
        PRINT 'Possible causes:'
        PRINT '  1. Application not redeployed after fixes'
        PRINT '  2. POS cost calculation logic has bug'
        PRINT '  3. Medicine sold by type that has no cost (e.g., box cost = 0)'
    END
    ELSE
    BEGIN
        PRINT '✅ Cost price was saved'
        PRINT '   But profit not updated in pharmacy_sales table'
        PRINT ''
        PRINT 'Run this to fix:'
        PRINT 'UPDATE pharmacy_sales SET'
        PRINT '  total_cost = (SELECT SUM(cost_price * quantity) FROM pharmacy_sales_items WHERE saleid = pharmacy_sales.saleid),'
        PRINT '  total_profit = (SELECT SUM(profit) FROM pharmacy_sales_items WHERE saleid = pharmacy_sales.saleid)'
        PRINT 'WHERE invoice_number = ''' + @invoiceNumber + ''''
    END
END

PRINT ''
PRINT '====================================================='
