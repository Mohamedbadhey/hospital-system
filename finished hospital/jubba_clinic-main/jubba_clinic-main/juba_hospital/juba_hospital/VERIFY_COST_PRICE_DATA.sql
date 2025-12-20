-- =====================================================
-- VERIFY COST AND SELLING PRICE DATA
-- =====================================================
-- This script verifies that cost and selling prices are
-- properly saved and retrieved in the database

USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'COST AND SELLING PRICE VERIFICATION REPORT'
PRINT '====================================================='
PRINT ''

-- =====================================================
-- 1. CHECK DATABASE SCHEMA
-- =====================================================
PRINT '1. DATABASE SCHEMA CHECK'
PRINT '-----------------------------------------------------'
PRINT ''

PRINT 'Medicine Table Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine' 
  AND (COLUMN_NAME LIKE '%cost%' OR COLUMN_NAME LIKE '%price%')
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT 'Medicine Inventory Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_inventory' 
  AND (COLUMN_NAME LIKE '%purchase%' OR COLUMN_NAME LIKE '%price%')
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT 'Pharmacy Sales Items Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales_items' 
  AND (COLUMN_NAME LIKE '%cost%' OR COLUMN_NAME LIKE '%price%' OR COLUMN_NAME LIKE '%profit%')
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT '-----------------------------------------------------'
PRINT ''

-- =====================================================
-- 2. CHECK MEDICINE COST AND SELLING PRICES
-- =====================================================
PRINT '2. MEDICINE MASTER DATA - COST & SELLING PRICES'
PRINT '-----------------------------------------------------'
PRINT ''

-- Count medicines with cost prices set
DECLARE @totalMeds INT, @medsWithCost INT, @medsWithPrices INT;

SELECT @totalMeds = COUNT(*) FROM medicine;
SELECT @medsWithCost = COUNT(*) FROM medicine 
WHERE cost_per_tablet > 0 OR cost_per_strip > 0 OR cost_per_box > 0;
SELECT @medsWithPrices = COUNT(*) FROM medicine 
WHERE price_per_tablet > 0 OR price_per_strip > 0 OR price_per_box > 0;

PRINT 'Total Medicines: ' + CAST(@totalMeds AS VARCHAR);
PRINT 'Medicines with Cost Prices: ' + CAST(@medsWithCost AS VARCHAR) + 
      ' (' + CAST((@medsWithCost * 100.0 / NULLIF(@totalMeds, 0)) AS VARCHAR(10)) + '%)';
PRINT 'Medicines with Selling Prices: ' + CAST(@medsWithPrices AS VARCHAR) + 
      ' (' + CAST((@medsWithPrices * 100.0 / NULLIF(@totalMeds, 0)) AS VARCHAR(10)) + '%)';

PRINT ''
PRINT 'Sample Medicines with Cost & Selling Prices (Top 10):'
SELECT TOP 10
    m.medicineid,
    m.medicine_name,
    u.unit_name,
    m.cost_per_tablet,
    m.price_per_tablet,
    CASE 
        WHEN m.cost_per_tablet > 0 AND m.price_per_tablet > 0 
        THEN CAST((((m.price_per_tablet - m.cost_per_tablet) / m.cost_per_tablet) * 100) AS DECIMAL(10,2))
        ELSE 0 
    END AS profit_margin_pct,
    m.cost_per_strip,
    m.price_per_strip,
    m.cost_per_box,
    m.price_per_box
FROM medicine m
LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
WHERE (m.cost_per_tablet > 0 OR m.cost_per_strip > 0 OR m.cost_per_box > 0)
  AND (m.price_per_tablet > 0 OR m.price_per_strip > 0 OR m.price_per_box > 0)
ORDER BY m.medicine_name;

PRINT ''
PRINT '-----------------------------------------------------'
PRINT ''

-- =====================================================
-- 3. CHECK INVENTORY PURCHASE PRICES
-- =====================================================
PRINT '3. INVENTORY PURCHASE PRICES'
PRINT '-----------------------------------------------------'
PRINT ''

DECLARE @totalInv INT, @invWithPurchasePrice INT;

SELECT @totalInv = COUNT(*) FROM medicine_inventory;
SELECT @invWithPurchasePrice = COUNT(*) FROM medicine_inventory WHERE purchase_price > 0;

PRINT 'Total Inventory Records: ' + CAST(@totalInv AS VARCHAR);
PRINT 'Inventory with Purchase Price: ' + CAST(@invWithPurchasePrice AS VARCHAR) + 
      ' (' + CAST((@invWithPurchasePrice * 100.0 / NULLIF(@totalInv, 0)) AS VARCHAR(10)) + '%)';

PRINT ''
PRINT 'Sample Inventory with Purchase Prices (Top 10):'
SELECT TOP 10
    mi.inventoryid,
    m.medicine_name,
    mi.primary_quantity,
    mi.secondary_quantity,
    mi.purchase_price,
    mi.batch_number,
    mi.expiry_date
FROM medicine_inventory mi
INNER JOIN medicine m ON mi.medicineid = m.medicineid
WHERE mi.purchase_price > 0
ORDER BY mi.inventoryid DESC;

PRINT ''
PRINT '-----------------------------------------------------'
PRINT ''

-- =====================================================
-- 4. CHECK SALES WITH COST AND PROFIT TRACKING
-- =====================================================
PRINT '4. SALES COST AND PROFIT TRACKING'
PRINT '-----------------------------------------------------'
PRINT ''

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    DECLARE @totalSalesItems INT, @itemsWithCost INT, @itemsWithProfit INT;
    
    SELECT @totalSalesItems = COUNT(*) FROM pharmacy_sales_items;
    SELECT @itemsWithCost = COUNT(*) FROM pharmacy_sales_items WHERE cost_price > 0;
    SELECT @itemsWithProfit = COUNT(*) FROM pharmacy_sales_items WHERE profit > 0;
    
    PRINT 'Total Sales Items: ' + CAST(@totalSalesItems AS VARCHAR);
    PRINT 'Items with Cost Tracking: ' + CAST(@itemsWithCost AS VARCHAR) + 
          ' (' + CAST((@itemsWithCost * 100.0 / NULLIF(@totalSalesItems, 0)) AS VARCHAR(10)) + '%)';
    PRINT 'Items with Profit Tracking: ' + CAST(@itemsWithProfit AS VARCHAR) + 
          ' (' + CAST((@itemsWithProfit * 100.0 / NULLIF(@totalSalesItems, 0)) AS VARCHAR(10)) + '%)';
    
    PRINT ''
    PRINT 'Recent Sales with Cost & Profit (Top 10):'
    SELECT TOP 10
        psi.sale_item_id,
        ps.invoice_number,
        m.medicine_name,
        psi.quantity_type,
        psi.quantity,
        psi.unit_price,
        psi.total_price,
        psi.cost_price,
        psi.profit,
        CASE 
            WHEN psi.cost_price > 0 
            THEN CAST(((psi.profit / (psi.cost_price * psi.quantity)) * 100) AS DECIMAL(10,2))
            ELSE 0 
        END AS profit_margin_pct
    FROM pharmacy_sales_items psi
    INNER JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
    INNER JOIN medicine m ON psi.medicineid = m.medicineid
    WHERE psi.cost_price > 0
    ORDER BY psi.sale_item_id DESC;
    
    PRINT ''
    PRINT 'Sales Summary with Profit:'
    SELECT TOP 10
        ps.invoice_number,
        ps.sale_date,
        ps.total_amount AS revenue,
        ps.total_cost,
        ps.total_profit,
        CASE 
            WHEN ps.total_cost > 0 
            THEN CAST(((ps.total_profit / ps.total_cost) * 100) AS DECIMAL(10,2))
            ELSE 0 
        END AS profit_margin_pct
    FROM pharmacy_sales ps
    WHERE ps.total_cost > 0 AND ps.total_profit > 0
    ORDER BY ps.sale_date DESC;
END
ELSE
BEGIN
    PRINT '⚠ pharmacy_sales_items table does not exist!'
END

PRINT ''
PRINT '-----------------------------------------------------'
PRINT ''

-- =====================================================
-- 5. IDENTIFY ISSUES
-- =====================================================
PRINT '5. POTENTIAL ISSUES'
PRINT '-----------------------------------------------------'
PRINT ''

-- Medicines without cost prices
PRINT 'Medicines WITHOUT Cost Prices:'
SELECT COUNT(*) AS count
FROM medicine 
WHERE (cost_per_tablet IS NULL OR cost_per_tablet = 0)
  AND (cost_per_strip IS NULL OR cost_per_strip = 0)
  AND (cost_per_box IS NULL OR cost_per_box = 0);

-- Medicines without selling prices
PRINT ''
PRINT 'Medicines WITHOUT Selling Prices:'
SELECT COUNT(*) AS count
FROM medicine 
WHERE (price_per_tablet IS NULL OR price_per_tablet = 0)
  AND (price_per_strip IS NULL OR price_per_strip = 0)
  AND (price_per_box IS NULL OR price_per_box = 0);

-- Inventory without purchase prices
PRINT ''
PRINT 'Inventory Records WITHOUT Purchase Price:'
SELECT COUNT(*) AS count
FROM medicine_inventory 
WHERE purchase_price IS NULL OR purchase_price = 0;

-- Sales items without cost tracking
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    PRINT ''
    PRINT 'Sales Items WITHOUT Cost Tracking:'
    SELECT COUNT(*) AS count
    FROM pharmacy_sales_items 
    WHERE cost_price IS NULL OR cost_price = 0;
END

PRINT ''
PRINT '-----------------------------------------------------'
PRINT ''

-- =====================================================
-- 6. SUMMARY AND RECOMMENDATIONS
-- =====================================================
PRINT '6. SUMMARY'
PRINT '====================================================='
PRINT ''

-- Calculate overall system health score
DECLARE @healthScore INT = 0;

-- Medicine cost prices (25 points)
IF @medsWithCost > 0
    SET @healthScore = @healthScore + CAST((25.0 * @medsWithCost / @totalMeds) AS INT);

-- Medicine selling prices (25 points)
IF @medsWithPrices > 0
    SET @healthScore = @healthScore + CAST((25.0 * @medsWithPrices / @totalMeds) AS INT);

-- Inventory purchase prices (25 points)
IF @invWithPurchasePrice > 0 AND @totalInv > 0
    SET @healthScore = @healthScore + CAST((25.0 * @invWithPurchasePrice / @totalInv) AS INT);

-- Sales cost tracking (25 points)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    IF @itemsWithCost > 0 AND @totalSalesItems > 0
        SET @healthScore = @healthScore + CAST((25.0 * @itemsWithCost / @totalSalesItems) AS INT);
END

PRINT '📊 SYSTEM HEALTH SCORE: ' + CAST(@healthScore AS VARCHAR) + '%'
PRINT ''

IF @healthScore >= 90
    PRINT '✅ EXCELLENT - Cost and selling price system is fully operational!'
ELSE IF @healthScore >= 70
    PRINT '✅ GOOD - System is working well with minor gaps'
ELSE IF @healthScore >= 50
    PRINT '⚠️  FAIR - System needs some data population'
ELSE
    PRINT '❌ POOR - System needs immediate attention'

PRINT ''
PRINT 'RECOMMENDATIONS:'

IF @medsWithCost < @totalMeds
    PRINT '  • Add cost prices to medicines without them (' + CAST(@totalMeds - @medsWithCost AS VARCHAR) + ' medicines)'

IF @medsWithPrices < @totalMeds
    PRINT '  • Add selling prices to medicines without them (' + CAST(@totalMeds - @medsWithPrices AS VARCHAR) + ' medicines)'

IF @invWithPurchasePrice < @totalInv AND @totalInv > 0
    PRINT '  • Add purchase prices to inventory batches (' + CAST(@totalInv - @invWithPurchasePrice AS VARCHAR) + ' batches)'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    IF @itemsWithCost < @totalSalesItems AND @totalSalesItems > 0
        PRINT '  • Historic sales may lack cost tracking - future sales will track properly'
END

PRINT ''
PRINT '====================================================='
PRINT 'VERIFICATION COMPLETE'
PRINT '====================================================='
