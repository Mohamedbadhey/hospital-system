-- =============================================
-- Add transaction_status column to prescribtion table
-- Database: jubba_clinick
-- This allows doctors to manually mark if patient transaction is completed or pending
-- =============================================

USE [jubba_clinick]
GO

-- Check if column already exists and add if not
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'transaction_status'
)
BEGIN
    ALTER TABLE [dbo].[prescribtion]
    ADD [transaction_status] VARCHAR(20) NULL DEFAULT 'pending';
    
    PRINT '✓ transaction_status column added successfully to prescribtion table';
END
ELSE
BEGIN
    PRINT '! transaction_status column already exists in prescribtion table';
END
GO

-- Set default value for existing records
UPDATE [dbo].[prescribtion] 
SET [transaction_status] = 'pending' 
WHERE [transaction_status] IS NULL;

PRINT '✓ Existing records updated with default value: pending';
PRINT '';
PRINT '========================================';
PRINT 'Transaction Status Column Setup Complete';
PRINT '========================================';
PRINT '';
PRINT 'Table: [dbo].[prescribtion]';
PRINT 'Column: [transaction_status]';
PRINT 'Type: VARCHAR(20)';
PRINT 'Default: pending';
PRINT '';
PRINT 'Possible Values:';
PRINT '  - pending   : Patient work still in progress';
PRINT '  - completed : Patient work finished';
PRINT '';
PRINT '✓ Ready to use!';
GO
