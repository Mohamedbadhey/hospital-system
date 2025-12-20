-- Add reference_id column to patient_charges table
-- Links charges to specific lab/xray orders

-- Check if column exists before adding
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('patient_charges') AND name = 'reference_id')
BEGIN
    ALTER TABLE patient_charges ADD reference_id INT NULL;
    PRINT 'Added reference_id column to patient_charges table';
END
ELSE
BEGIN
    PRINT 'reference_id column already exists in patient_charges table';
END

-- Add index for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_reference' AND object_id = OBJECT_ID('patient_charges'))
BEGIN
    CREATE INDEX IX_patient_charges_reference ON patient_charges(reference_id, charge_type);
    PRINT 'Created index IX_patient_charges_reference';
END
ELSE
BEGIN
    PRINT 'Index IX_patient_charges_reference already exists';
END

PRINT '';
PRINT '=================================================================';
PRINT 'SUCCESS: patient_charges table updated';
PRINT '';
PRINT 'reference_id will store:';
PRINT '  - med_id (for Lab charges from lab_test table)';
PRINT '  - xryid (for Xray charges from xray table)';
PRINT '  - NULL (for other charge types like Registration, Bed, etc.)';
PRINT '=================================================================';
