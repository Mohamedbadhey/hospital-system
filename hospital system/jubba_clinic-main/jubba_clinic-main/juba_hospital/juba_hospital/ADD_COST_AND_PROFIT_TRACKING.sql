-- ========================================
-- ADD COST & PROFIT TRACKING TO PHARMACY
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'ADDING COST & PROFIT TRACKING';
PRINT '========================================';
PRINT '';

-- ========================================
-- STEP 1: Add cost fields to medicine table
-- ========================================
PRINT 'Step 1: Updating medicine table...';

-- Add cost price per tablet/piece
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'cost_per_tablet')
BEGIN
    PRINT 'Adding cost_per_tablet column...';
    ALTER TABLE medicine ADD cost_per_tablet FLOAT DEFAULT 0;
END

-- Add cost price per strip/container
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'cost_per_strip')
BEGIN
    PRINT 'Adding cost_per_strip column...';
    ALTER TABLE medicine ADD cost_per_strip FLOAT DEFAULT 0;
END

-- Add cost price per box
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'cost_per_box')
BEGIN
    PRINT 'Adding cost_per_box column...';
    ALTER TABLE medicine ADD cost_per_box FLOAT DEFAULT 0;
END

-- Rename existing price columns to be clear they are selling prices
-- (Already named correctly: price_per_tablet, price_per_strip, price_per_box)
-- These are SELLING prices

PRINT '✓ Medicine table updated with cost columns';
PRINT '';

-- ========================================
-- STEP 2: Update medicine_inventory table
-- ========================================
PRINT 'Step 2: Checking medicine_inventory table...';

-- purchase_price already exists in your table
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'purchase_price')
BEGIN
    PRINT '✓ purchase_price column already exists';
END
ELSE
BEGIN
    PRINT 'Adding purchase_price column...';
    ALTER TABLE medicine_inventory ADD purchase_price FLOAT DEFAULT 0;
END

PRINT '';

-- ========================================
-- STEP 3: Update pharmacy_sales_items for profit tracking
-- ========================================
PRINT 'Step 3: Updating pharmacy_sales_items table...';

-- Add cost_price to track cost at time of sale
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'cost_price')
BEGIN
    PRINT 'Adding cost_price column...';
    ALTER TABLE pharmacy_sales_items ADD cost_price FLOAT DEFAULT 0;
END

-- Add profit column (calculated: selling - cost)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'profit')
BEGIN
    PRINT 'Adding profit column...';
    ALTER TABLE pharmacy_sales_items ADD profit FLOAT DEFAULT 0;
END

PRINT '✓ pharmacy_sales_items updated';
PRINT '';

-- ========================================
-- STEP 4: Update pharmacy_sales for totals
-- ========================================
PRINT 'Step 4: Updating pharmacy_sales table...';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
BEGIN
    -- Add total cost
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales') AND name = 'total_cost')
    BEGIN
        PRINT 'Adding total_cost column...';
        ALTER TABLE pharmacy_sales ADD total_cost FLOAT DEFAULT 0;
    END
    
    -- Add total profit
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales') AND name = 'total_profit')
    BEGIN
        PRINT 'Adding total_profit column...';
        ALTER TABLE pharmacy_sales ADD total_profit FLOAT DEFAULT 0;
    END
    
    PRINT '✓ pharmacy_sales updated';
END
ELSE
BEGIN
    PRINT '⚠ pharmacy_sales table does not exist';
END

PRINT '';

-- ========================================
-- STEP 5: Create profit calculation view (optional)
-- ========================================
PRINT 'Step 5: Creating profit calculation view...';

IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_pharmacy_profit_report')
    DROP VIEW v_pharmacy_profit_report;
GO

CREATE VIEW v_pharmacy_profit_report AS
SELECT 
    ps.sale_id,
    ps.invoice_number,
    ps.sale_date,
    ps.customer_name,
    ps.total_amount as total_selling_price,
    ps.total_cost,
    ps.total_profit,
    CASE 
        WHEN ps.total_cost > 0 THEN ((ps.total_profit / ps.total_cost) * 100)
        ELSE 0 
    END as profit_percentage,
    ps.payment_method,
    ps.served_by
FROM pharmacy_sales ps;
GO

PRINT '✓ Profit report view created';
PRINT '';

-- ========================================
-- VERIFICATION
-- ========================================
PRINT '========================================';
PRINT 'VERIFICATION - NEW COLUMNS ADDED:';
PRINT '========================================';
PRINT '';

PRINT '1. MEDICINE TABLE (Cost fields):';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine' 
  AND COLUMN_NAME LIKE '%cost%' OR COLUMN_NAME LIKE '%price%'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '2. MEDICINE_INVENTORY TABLE:';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_inventory' 
  AND COLUMN_NAME LIKE '%price%'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '3. PHARMACY_SALES_ITEMS TABLE (Profit tracking):';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales_items' 
  AND (COLUMN_NAME LIKE '%price%' OR COLUMN_NAME LIKE '%cost%' OR COLUMN_NAME LIKE '%profit%')
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT '✓✓✓ COST & PROFIT TRACKING COMPLETE! ✓✓✓';
PRINT '========================================';
PRINT '';
PRINT 'Summary:';
PRINT '  ✓ Medicine table has cost columns';
PRINT '  ✓ Inventory tracks purchase price';
PRINT '  ✓ Sales items track cost and profit';
PRINT '  ✓ Sales table has total cost and profit';
PRINT '  ✓ Profit report view created';
PRINT '';
PRINT 'Next: Update frontend forms to include cost fields';
PRINT '';
