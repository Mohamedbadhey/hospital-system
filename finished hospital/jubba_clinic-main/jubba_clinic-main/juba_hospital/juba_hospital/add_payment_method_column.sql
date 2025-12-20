USE [juba_clinick]
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[patient_charges]') AND name = 'payment_method')
BEGIN
    ALTER TABLE [dbo].[patient_charges]
    ADD [payment_method] [varchar](50) NULL;
    
    PRINT 'Column payment_method added to patient_charges table.';
END
ELSE
BEGIN
    PRINT 'Column payment_method already exists in patient_charges table.';
END
GO
