-- ============================================
-- Medicine Return/Revert Transaction System
-- ============================================

USE [juba_clinick]
GO

-- 1. Create pharmacy_returns table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pharmacy_returns]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[pharmacy_returns](
        [returnid] [int] IDENTITY(1,1) NOT NULL,
        [return_invoice] [varchar](50) NOT NULL,
        [original_saleid] [int] NOT NULL,
        [original_invoice] [varchar](50) NULL,
        [customer_name] [varchar](100) NULL,
        [return_date] [datetime] NOT NULL DEFAULT (GETDATE()),
        [total_return_amount] [float] NOT NULL DEFAULT (0),
        [return_reason] [varchar](500) NULL,
        [processed_by] [int] NULL,
        [status] [int] NOT NULL DEFAULT (1), -- 1=completed, 0=cancelled
        [refund_method] [varchar](50) NULL, -- Cash, Credit, Exchange
        CONSTRAINT [PK_pharmacy_returns] PRIMARY KEY CLUSTERED ([returnid] ASC)
    )
    PRINT 'Table pharmacy_returns created successfully'
END
ELSE
BEGIN
    PRINT 'Table pharmacy_returns already exists'
END
GO

-- 2. Create pharmacy_return_items table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pharmacy_return_items]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[pharmacy_return_items](
        [return_item_id] [int] IDENTITY(1,1) NOT NULL,
        [returnid] [int] NOT NULL,
        [original_sale_item_id] [int] NOT NULL,
        [medicineid] [int] NOT NULL,
        [inventoryid] [int] NOT NULL,
        [quantity_type] [varchar](50) NOT NULL,
        [quantity_returned] [float] NOT NULL,
        [original_unit_price] [float] NOT NULL,
        [return_amount] [float] NOT NULL,
        [original_cost_price] [float] NOT NULL DEFAULT (0),
        [profit_reversed] [float] NOT NULL DEFAULT (0),
        CONSTRAINT [PK_pharmacy_return_items] PRIMARY KEY CLUSTERED ([return_item_id] ASC),
        CONSTRAINT [FK_return_items_returns] FOREIGN KEY([returnid]) REFERENCES [dbo].[pharmacy_returns]([returnid])
    )
    PRINT 'Table pharmacy_return_items created successfully'
END
ELSE
BEGIN
    PRINT 'Table pharmacy_return_items already exists'
END
GO

-- 3. Add indexes for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_returns_original_saleid')
BEGIN
    CREATE INDEX IX_returns_original_saleid ON pharmacy_returns(original_saleid)
    PRINT 'Index IX_returns_original_saleid created'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_returns_invoice')
BEGIN
    CREATE INDEX IX_returns_invoice ON pharmacy_returns(return_invoice)
    PRINT 'Index IX_returns_invoice created'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_return_items_medicineid')
BEGIN
    CREATE INDEX IX_return_items_medicineid ON pharmacy_return_items(medicineid)
    PRINT 'Index IX_return_items_medicineid created'
END
GO

-- 4. Create view for returns with details
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_pharmacy_returns_detail')
BEGIN
    DROP VIEW vw_pharmacy_returns_detail
END
GO

CREATE VIEW vw_pharmacy_returns_detail
AS
SELECT 
    pr.returnid,
    pr.return_invoice,
    pr.original_saleid,
    pr.original_invoice,
    ps.customer_name,
    pr.return_date,
    pr.total_return_amount,
    pr.return_reason,
    pr.refund_method,
    pr.processed_by,
    pu.fullname as processed_by_name,
    pr.status,
    COUNT(pri.return_item_id) as items_returned,
    SUM(pri.quantity_returned) as total_quantity_returned,
    SUM(pri.profit_reversed) as total_profit_reversed
FROM pharmacy_returns pr
LEFT JOIN pharmacy_return_items pri ON pr.returnid = pri.returnid
LEFT JOIN pharmacy_sales ps ON pr.original_saleid = ps.saleid
LEFT JOIN pharmacy_user pu ON pr.processed_by = pu.userid
GROUP BY 
    pr.returnid, pr.return_invoice, pr.original_saleid, pr.original_invoice,
    ps.customer_name, pr.return_date, pr.total_return_amount, pr.return_reason,
    pr.refund_method, pr.processed_by, pu.fullname, pr.status
GO

PRINT 'View vw_pharmacy_returns_detail created successfully'
GO

-- 5. Create stored procedure to process return
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ProcessMedicineReturn')
BEGIN
    DROP PROCEDURE sp_ProcessMedicineReturn
END
GO

CREATE PROCEDURE sp_ProcessMedicineReturn
    @original_saleid INT,
    @return_reason VARCHAR(500),
    @refund_method VARCHAR(50),
    @processed_by INT,
    @return_items NVARCHAR(MAX), -- JSON array of items to return
    @returnid INT OUTPUT,
    @return_invoice VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Generate return invoice number
        SET @return_invoice = 'RET-' + CONVERT(VARCHAR(8), GETDATE(), 112) + '-' + 
                             RIGHT('00000' + CAST(ISNULL((SELECT MAX(returnid) FROM pharmacy_returns), 0) + 1 AS VARCHAR), 5)
        
        -- Get original sale details
        DECLARE @original_invoice VARCHAR(50)
        DECLARE @customer_name VARCHAR(100)
        DECLARE @total_return_amount FLOAT = 0
        
        SELECT @original_invoice = invoice_number, @customer_name = customer_name
        FROM pharmacy_sales WHERE saleid = @original_saleid
        
        IF @original_invoice IS NULL
        BEGIN
            RAISERROR('Original sale not found', 16, 1)
            RETURN
        END
        
        -- Insert return header
        INSERT INTO pharmacy_returns (return_invoice, original_saleid, original_invoice, customer_name, 
                                     return_reason, processed_by, refund_method)
        VALUES (@return_invoice, @original_saleid, @original_invoice, @customer_name,
               @return_reason, @processed_by, @refund_method)
        
        SET @returnid = SCOPE_IDENTITY()
        
        -- Process return items (this will be called from C# code which parses JSON)
        -- The actual item processing will be done in the C# code
        
        COMMIT TRANSACTION
        
        SELECT @returnid as returnid, @return_invoice as return_invoice
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'Stored procedure sp_ProcessMedicineReturn created successfully'
GO

PRINT ''
PRINT '========================================='
PRINT 'Medicine Return System Setup Complete!'
PRINT '========================================='
PRINT 'Created:'
PRINT '  - pharmacy_returns table'
PRINT '  - pharmacy_return_items table'
PRINT '  - Indexes for performance'
PRINT '  - vw_pharmacy_returns_detail view'
PRINT '  - sp_ProcessMedicineReturn stored procedure'
PRINT ''
PRINT 'Next: Run this script on your database'
PRINT '========================================='
