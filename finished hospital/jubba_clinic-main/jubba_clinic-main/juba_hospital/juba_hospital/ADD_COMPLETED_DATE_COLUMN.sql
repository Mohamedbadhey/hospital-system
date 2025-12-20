-- =============================================
-- Add completed_date column to prescribtion table
-- Database: jubba_clinick
-- This tracks when a patient's transaction status was marked as completed
-- =============================================

USE [jubba_clinick]
GO

-- Check if column already exists and add if not
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[prescribtion]') 
    AND name = 'completed_date'
)
BEGIN
    ALTER TABLE [dbo].[prescribtion]
    ADD [completed_date] DATETIME NULL;
    
    PRINT '✓ completed_date column added successfully to prescribtion table';
END
ELSE
BEGIN
    PRINT '! completed_date column already exists in prescribtion table';
END
GO

PRINT '========================================';
PRINT 'Completed Date Column Setup Complete';
PRINT '========================================';
PRINT '';
PRINT 'Table: [dbo].[prescribtion]';
PRINT 'Column: [completed_date]';
PRINT 'Type: DATETIME';
PRINT 'Purpose: Tracks when transaction status was marked as completed';
PRINT '';
PRINT '✓ Ready to use!';
GO
