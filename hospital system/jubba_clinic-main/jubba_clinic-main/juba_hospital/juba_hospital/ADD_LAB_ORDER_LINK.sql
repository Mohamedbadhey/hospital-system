-- Add lab_test_id column to lab_results to link results with specific orders
-- This allows tracking which results belong to which lab test order

-- Check if column exists before adding it
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('lab_results') AND name = 'lab_test_id')
BEGIN
    ALTER TABLE lab_results ADD lab_test_id INT NULL;
    PRINT 'Added lab_test_id column to lab_results table';
END
ELSE
BEGIN
    PRINT 'lab_test_id column already exists in lab_results table';
END

-- Add foreign key constraint (optional but recommended)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_lab_results_lab_test')
BEGIN
    ALTER TABLE lab_results 
    ADD CONSTRAINT FK_lab_results_lab_test 
    FOREIGN KEY (lab_test_id) REFERENCES lab_test(med_id);
    PRINT 'Added foreign key constraint FK_lab_results_lab_test';
END
ELSE
BEGIN
    PRINT 'Foreign key constraint FK_lab_results_lab_test already exists';
END

-- Add index for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_results_lab_test_id' AND object_id = OBJECT_ID('lab_results'))
BEGIN
    CREATE INDEX IX_lab_results_lab_test_id ON lab_results(lab_test_id);
    PRINT 'Created index IX_lab_results_lab_test_id';
END
ELSE
BEGIN
    PRINT 'Index IX_lab_results_lab_test_id already exists';
END

PRINT '';
PRINT '=================================================================';
PRINT 'IMPORTANT: Update lab entry pages to include lab_test_id';
PRINT 'When lab staff enters results, they should specify which order';
PRINT 'the results are for by including the lab_test_id value.';
PRINT '=================================================================';
