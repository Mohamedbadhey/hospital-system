-- ============================================
-- Pharmacy Enhancement Database Schema - CORRECTED
-- Adds support for custom medicine units and profit tracking
-- ============================================

USE [juba_clinick]
GO

PRINT '============================================';
PRINT 'Starting Pharmacy Enhancement Schema Update';
PRINT '============================================';
GO

-- ============================================
-- 1. Create medicine_units table
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_units')
BEGIN
    CREATE TABLE [dbo].[medicine_units](
        [unit_id] [int] IDENTITY(1,1) NOT NULL,
        [unit_name] [varchar](50) NOT NULL,
        [unit_abbreviation] [varchar](10) NULL,
        [is_active] [bit] NOT NULL DEFAULT 1,
        [created_date] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_medicine_units] PRIMARY KEY CLUSTERED ([unit_id] ASC)
    )

    -- Insert common medicine units
    INSERT INTO [dbo].[medicine_units] ([unit_name], [unit_abbreviation], [is_active])
    VALUES 
        ('Tablet', 'Tab', 1),
        ('Capsule', 'Cap', 1),
        ('Bottle', 'Btl', 1),
        ('Ointment', 'Oint', 1),
        ('Syrup', 'Syr', 1),
        ('Injection', 'Inj', 1),
        ('Drops', 'Drp', 1),
        ('Inhaler', 'Inh', 1),
        ('Cream', 'Crm', 1),
        ('Gel', 'Gel', 1),
        ('Powder', 'Pwd', 1),
        ('Sachet', 'Sach', 1),
        ('Suppository', 'Supp', 1),
        ('Patch', 'Ptch', 1),
        ('Spray', 'Spr', 1);

    PRINT 'medicine_units table created and populated successfully.';
END
ELSE
BEGIN
    PRINT 'medicine_units table already exists.';
END
GO

-- ============================================
-- 2. Add unit_id to medicine table (if not exists)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'unit_id')
BEGIN
    ALTER TABLE [dbo].[medicine]
    ADD [unit_id] [int] NULL;

    PRINT 'unit_id column added to medicine table.';
END
ELSE
BEGIN
    PRINT 'unit_id column already exists in medicine table.';
END
GO

-- ============================================
-- 3. Migrate existing data to use unit_id
-- ============================================
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'unit_id')
AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'unit')
BEGIN
    -- Update existing records to use 'Tablet' unit (unit_id = 1) if unit column contains 'tablet'
    UPDATE [dbo].[medicine]
    SET [unit_id] = 1
    WHERE ([unit] LIKE '%tablet%' OR [unit] LIKE '%tab%') AND [unit_id] IS NULL;

    -- Update existing records to use 'Capsule' unit (unit_id = 2) if unit column contains 'capsule'
    UPDATE [dbo].[medicine]
    SET [unit_id] = 2
    WHERE ([unit] LIKE '%capsule%' OR [unit] LIKE '%cap%') AND [unit_id] IS NULL;

    -- Update existing records to use 'Bottle' unit (unit_id = 3) if unit column contains 'bottle'
    UPDATE [dbo].[medicine]
    SET [unit_id] = 3
    WHERE ([unit] LIKE '%bottle%' OR [unit] LIKE '%btl%') AND [unit_id] IS NULL;

    -- Set default unit_id to 1 (Tablet) for any remaining NULL values
    UPDATE [dbo].[medicine]
    SET [unit_id] = 1
    WHERE [unit_id] IS NULL;

    PRINT 'Existing medicine data migrated to use unit_id.';
END
GO

-- ============================================
-- 4. Add quantity_per_unit to medicine table (if not exists)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'quantity_per_unit')
BEGIN
    ALTER TABLE [dbo].[medicine]
    ADD [quantity_per_unit] [int] NULL DEFAULT 1;

    PRINT 'quantity_per_unit column added to medicine table.';
END
ELSE
BEGIN
    PRINT 'quantity_per_unit column already exists in medicine table.';
END
GO

-- ============================================
-- 5. Set quantity_per_unit for existing records
-- ============================================
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'quantity_per_unit')
AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'tablets_per_strip')
BEGIN
    -- Set quantity_per_unit based on tablets_per_strip for existing records
    UPDATE [dbo].[medicine]
    SET [quantity_per_unit] = ISNULL([tablets_per_strip], 1)
    WHERE [quantity_per_unit] IS NULL;

    PRINT 'quantity_per_unit values set for existing records.';
END
GO

-- ============================================
-- 6. Add profit tracking columns to pharmacy_sales_items
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'purchase_price')
BEGIN
    ALTER TABLE [dbo].[pharmacy_sales_items]
    ADD [purchase_price] [float] NULL DEFAULT 0;

    PRINT 'purchase_price column added to pharmacy_sales_items table.';
END
ELSE
BEGIN
    PRINT 'purchase_price column already exists in pharmacy_sales_items table.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('pharmacy_sales_items') AND name = 'profit_amount')
BEGIN
    ALTER TABLE [dbo].[pharmacy_sales_items]
    ADD [profit_amount] AS ([total_price] - ([purchase_price] * [quantity])) PERSISTED;

    PRINT 'profit_amount computed column added to pharmacy_sales_items table.';
END
ELSE
BEGIN
    PRINT 'profit_amount column already exists in pharmacy_sales_items table.';
END
GO

-- ============================================
-- 7. Create indexes for better performance
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_unit_id' AND object_id = OBJECT_ID('medicine'))
BEGIN
    CREATE INDEX IX_medicine_unit_id ON [dbo].[medicine]([unit_id]);
    PRINT 'Index IX_medicine_unit_id created.';
END
ELSE
BEGIN
    PRINT 'Index IX_medicine_unit_id already exists.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_status_date' AND object_id = OBJECT_ID('pharmacy_sales'))
BEGIN
    CREATE INDEX IX_pharmacy_sales_status_date ON [dbo].[pharmacy_sales]([status], [sale_date]);
    PRINT 'Index IX_pharmacy_sales_status_date created.';
END
ELSE
BEGIN
    PRINT 'Index IX_pharmacy_sales_status_date already exists.';
END
GO

-- ============================================
-- 8. Create view for sales with profit
-- ============================================
IF OBJECT_ID('vw_pharmacy_sales_with_profit', 'V') IS NOT NULL
    DROP VIEW [dbo].[vw_pharmacy_sales_with_profit];
GO

CREATE VIEW [dbo].[vw_pharmacy_sales_with_profit]
AS
SELECT 
    ps.saleid,
    ps.invoice_number,
    ps.customer_name,
    ps.sale_date,
    ps.total_amount,
    ps.discount,
    ps.final_amount,
    ps.payment_method,
    ps.sold_by,
    ps.status,
    ISNULL(SUM(psi.profit_amount), 0) AS total_profit,
    ISNULL(SUM(psi.purchase_price * psi.quantity), 0) AS total_cost
FROM pharmacy_sales ps
LEFT JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
GROUP BY 
    ps.saleid, ps.invoice_number, ps.customer_name, ps.sale_date,
    ps.total_amount, ps.discount, ps.final_amount, ps.payment_method,
    ps.sold_by, ps.status;
GO

PRINT 'View vw_pharmacy_sales_with_profit created successfully.';
GO

PRINT '============================================';
PRINT 'Pharmacy Enhancement Schema Update Complete!';
PRINT '============================================';
PRINT 'Next steps:';
PRINT '1. Verify medicine_units table has 15 rows';
PRINT '2. Verify medicine table has unit_id and quantity_per_unit columns';
PRINT '3. Test the pharmacy system';
PRINT '============================================';
