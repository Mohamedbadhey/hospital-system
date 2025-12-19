-- Check which column names exist in pharmacy_sales_items table
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'PHARMACY_SALES_ITEMS COLUMN CHECK'
PRINT '====================================================='
PRINT ''

-- Check if table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    PRINT 'Table pharmacy_sales_items EXISTS'
    PRINT ''
    PRINT 'All columns in pharmacy_sales_items:'
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'pharmacy_sales_items'
    ORDER BY ORDINAL_POSITION;
    
    PRINT ''
    PRINT 'Checking for specific column variations:'
    PRINT ''
    
    -- Check for saleid vs sale_id
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'saleid')
        PRINT '✅ Found: saleid (without underscore)'
    ELSE
        PRINT '❌ NOT Found: saleid'
        
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_id')
        PRINT '✅ Found: sale_id (with underscore)'
    ELSE
        PRINT '❌ NOT Found: sale_id'
    
    PRINT ''
    
    -- Check for medicineid vs medicine_id
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicineid')
        PRINT '✅ Found: medicineid (without underscore)'
    ELSE
        PRINT '❌ NOT Found: medicineid'
        
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicine_id')
        PRINT '✅ Found: medicine_id (with underscore)'
    ELSE
        PRINT '❌ NOT Found: medicine_id'
    
    PRINT ''
    
    -- Check for inventoryid vs inventory_id
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventoryid')
        PRINT '✅ Found: inventoryid (without underscore)'
    ELSE
        PRINT '❌ NOT Found: inventoryid'
        
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventory_id')
        PRINT '✅ Found: inventory_id (with underscore)'
    ELSE
        PRINT '❌ NOT Found: inventory_id'
    
    PRINT ''
    
    -- Check for cost tracking columns
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'cost_price')
        PRINT '✅ Found: cost_price'
    ELSE
        PRINT '❌ NOT Found: cost_price'
        
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
        PRINT '✅ Found: profit'
    ELSE
        PRINT '❌ NOT Found: profit'
        
    PRINT ''
    PRINT 'Sample data (if any):'
    SELECT TOP 5 * FROM pharmacy_sales_items;
    
END
ELSE
BEGIN
    PRINT '❌ Table pharmacy_sales_items DOES NOT EXIST!'
END

PRINT ''
PRINT '====================================================='
