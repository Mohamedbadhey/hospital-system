-- Add barcode column to medicine table
-- Run this script to add barcode functionality

USE juba_clinick;
GO

-- Check if column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'medicine' AND COLUMN_NAME = 'barcode')
BEGIN
    -- Add barcode column
    ALTER TABLE medicine
    ADD barcode VARCHAR(100) NULL;
    
    PRINT 'Barcode column added successfully!';
END
ELSE
BEGIN
    PRINT 'Barcode column already exists!';
END
GO

-- Create unique index on barcode (allow nulls, but ensure uniqueness when set)
IF NOT EXISTS (SELECT * FROM sys.indexes 
               WHERE name = 'IX_medicine_barcode' AND object_id = OBJECT_ID('medicine'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_medicine_barcode
    ON medicine(barcode)
    WHERE barcode IS NOT NULL;
    
    PRINT 'Unique index on barcode created successfully!';
END
ELSE
BEGIN
    PRINT 'Barcode index already exists!';
END
GO

PRINT 'Barcode setup complete! You can now add barcodes to medicines.';
