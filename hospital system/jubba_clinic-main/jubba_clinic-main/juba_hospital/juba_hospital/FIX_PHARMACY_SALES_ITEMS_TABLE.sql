-- ========================================
-- FIX PHARMACY_SALES_ITEMS TABLE COLUMNS
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'CHECKING pharmacy_sales_items TABLE';
PRINT '========================================';
PRINT '';

-- Check if table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    PRINT '✓ Table exists';
    PRINT '';
    
    -- Show current columns
    PRINT 'Current columns:';
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'pharmacy_sales_items'
    ORDER BY ORDINAL_POSITION;
    
    PRINT '';
    PRINT 'Adding missing columns...';
    
    -- Add sale_id if missing
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'sale_id')
    BEGIN
        -- Check if there's a column like saleid or salesid
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'saleid')
        BEGIN
            PRINT 'Renaming saleid to sale_id...';
            EXEC sp_rename 'pharmacy_sales_items.saleid', 'sale_id', 'COLUMN';
        END
        ELSE IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'salesid')
        BEGIN
            PRINT 'Renaming salesid to sale_id...';
            EXEC sp_rename 'pharmacy_sales_items.salesid', 'sale_id', 'COLUMN';
        END
        ELSE
        BEGIN
            PRINT 'Adding sale_id column...';
            ALTER TABLE pharmacy_sales_items ADD sale_id INT NULL;
        END
    END
    ELSE
    BEGIN
        PRINT '✓ sale_id exists';
    END
    
    -- Add medicine_id if missing
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'medicine_id')
    BEGIN
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'medicineid')
        BEGIN
            PRINT 'Renaming medicineid to medicine_id...';
            EXEC sp_rename 'pharmacy_sales_items.medicineid', 'medicine_id', 'COLUMN';
        END
        ELSE
        BEGIN
            PRINT 'Adding medicine_id column...';
            ALTER TABLE pharmacy_sales_items ADD medicine_id INT NULL;
        END
    END
    ELSE
    BEGIN
        PRINT '✓ medicine_id exists';
    END
    
    -- Add inventory_id if missing
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'inventory_id')
    BEGIN
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'inventoryid')
        BEGIN
            PRINT 'Renaming inventoryid to inventory_id...';
            EXEC sp_rename 'pharmacy_sales_items.inventoryid', 'inventory_id', 'COLUMN';
        END
        ELSE
        BEGIN
            PRINT 'Adding inventory_id column...';
            ALTER TABLE pharmacy_sales_items ADD inventory_id INT NULL;
        END
    END
    ELSE
    BEGIN
        PRINT '✓ inventory_id exists';
    END
    
    -- Add purchase_price if missing
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'purchase_price')
    BEGIN
        PRINT 'Adding purchase_price column...';
        ALTER TABLE pharmacy_sales_items ADD purchase_price FLOAT DEFAULT 0;
    END
    ELSE
    BEGIN
        PRINT '✓ purchase_price exists';
    END
    
    -- Ensure other required columns exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'quantity_type')
    BEGIN
        PRINT 'Adding quantity_type column...';
        ALTER TABLE pharmacy_sales_items ADD quantity_type VARCHAR(50) DEFAULT 'piece';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'quantity')
    BEGIN
        PRINT 'Adding quantity column...';
        ALTER TABLE pharmacy_sales_items ADD quantity INT DEFAULT 1;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'unit_price')
    BEGIN
        PRINT 'Adding unit_price column...';
        ALTER TABLE pharmacy_sales_items ADD unit_price FLOAT DEFAULT 0;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'total_price')
    BEGIN
        PRINT 'Adding total_price column...';
        ALTER TABLE pharmacy_sales_items ADD total_price FLOAT DEFAULT 0;
    END
    
END
ELSE
BEGIN
    PRINT 'Table does not exist - creating it...';
    
    CREATE TABLE pharmacy_sales_items (
        item_id INT IDENTITY(1,1) PRIMARY KEY,
        sale_id INT NOT NULL,
        medicine_id INT NOT NULL,
        inventory_id INT NULL,
        quantity_type VARCHAR(50) DEFAULT 'piece',
        quantity INT NOT NULL,
        unit_price FLOAT NOT NULL,
        total_price FLOAT NOT NULL,
        purchase_price FLOAT DEFAULT 0,
        created_date DATETIME DEFAULT GETDATE()
    );
    
    PRINT '✓ Table created with all required columns';
END

PRINT '';
PRINT '========================================';
PRINT 'FINAL STRUCTURE:';
PRINT '========================================';

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales_items'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '✓✓✓ COMPLETE! ✓✓✓';
PRINT '';
PRINT 'Required columns:';
PRINT '  ✓ sale_id';
PRINT '  ✓ medicine_id';
PRINT '  ✓ inventory_id';
PRINT '  ✓ quantity_type';
PRINT '  ✓ quantity';
PRINT '  ✓ unit_price';
PRINT '  ✓ total_price';
PRINT '  ✓ purchase_price';
PRINT '';
PRINT 'Now test POS sale again!';
PRINT '';
