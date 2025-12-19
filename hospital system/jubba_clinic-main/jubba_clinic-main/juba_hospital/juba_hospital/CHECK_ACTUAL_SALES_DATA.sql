-- =====================================================
-- CHECK ACTUAL SALES DATA
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'CHECKING ACTUAL SALES DATA'
PRINT '====================================================='
PRINT ''

-- Check pharmacy_sales table
PRINT '1. PHARMACY_SALES TABLE:'
PRINT '-----------------------------------------------------'
SELECT TOP 5
    saleid,
    invoice_number,
    sale_date,
    customer_name,
    total_amount,
    ISNULL(total_cost, 0) as total_cost,
    ISNULL(total_profit, 0) as total_profit,
    status
FROM pharmacy_sales
ORDER BY saleid DESC

PRINT ''
PRINT '2. PHARMACY_SALES_ITEMS TABLE:'
PRINT '-----------------------------------------------------'
SELECT TOP 10
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

PRINT ''
PRINT '3. CHECK IF COLUMNS EXIST:'
PRINT '-----------------------------------------------------'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_cost')
    PRINT '✅ pharmacy_sales.total_cost exists'
ELSE
    PRINT '❌ pharmacy_sales.total_cost MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'total_profit')
    PRINT '✅ pharmacy_sales.total_profit exists'
ELSE
    PRINT '❌ pharmacy_sales.total_profit MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'cost_price')
    PRINT '✅ pharmacy_sales_items.cost_price exists'
ELSE
    PRINT '❌ pharmacy_sales_items.cost_price MISSING!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
    PRINT '✅ pharmacy_sales_items.profit exists'
ELSE
    PRINT '❌ pharmacy_sales_items.profit MISSING!'

PRINT ''
PRINT '4. TEST QUERIES:'
PRINT '-----------------------------------------------------'

-- Test if profit calculation works
PRINT 'Total items with profit > 0:'
SELECT COUNT(*) as items_with_profit
FROM pharmacy_sales_items
WHERE profit > 0

PRINT ''
PRINT 'Total items with cost_price > 0:'
SELECT COUNT(*) as items_with_cost
FROM pharmacy_sales_items
WHERE cost_price > 0

PRINT ''
PRINT '5. CHECK MEDICINE COSTS:'
PRINT '-----------------------------------------------------'
SELECT TOP 5
    m.medicineid,
    m.medicine_name,
    ISNULL(m.cost_per_tablet, 0) as cost_per_tablet,
    ISNULL(m.cost_per_strip, 0) as cost_per_strip,
    ISNULL(m.cost_per_box, 0) as cost_per_box,
    ISNULL(m.price_per_tablet, 0) as price_per_tablet,
    ISNULL(m.price_per_strip, 0) as price_per_strip,
    ISNULL(m.price_per_box, 0) as price_per_box
FROM medicine m
ORDER BY m.medicineid DESC

PRINT ''
PRINT '====================================================='
PRINT 'CHECK COMPLETE'
PRINT '====================================================='
