-- Add columns to lab_test table to track re-orders
-- This allows the system to identify when tests are being re-ordered and why

-- Check if columns exist before adding them
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('lab_test') AND name = 'is_reorder')
BEGIN
    ALTER TABLE lab_test ADD is_reorder BIT DEFAULT 0;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('lab_test') AND name = 'reorder_reason')
BEGIN
    ALTER TABLE lab_test ADD reorder_reason NVARCHAR(500) NULL;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('lab_test') AND name = 'original_order_id')
BEGIN
    ALTER TABLE lab_test ADD original_order_id INT NULL;
END

-- Add index for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_test_reorder' AND object_id = OBJECT_ID('lab_test'))
BEGIN
    CREATE INDEX IX_lab_test_reorder ON lab_test(is_reorder, prescid);
END

PRINT 'Lab test reorder tracking columns added successfully';
