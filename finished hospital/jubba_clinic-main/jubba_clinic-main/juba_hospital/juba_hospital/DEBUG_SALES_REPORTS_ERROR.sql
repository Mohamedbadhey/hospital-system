-- =====================================================
-- DEBUG SALES REPORTS ERROR
-- =====================================================
USE [juba_clinick]
GO

PRINT 'Checking pharmacy_sales table structure and data...'
PRINT ''

-- Check status column data type
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales' 
  AND COLUMN_NAME = 'status'

PRINT ''
PRINT 'Sample status values in pharmacy_sales:'
SELECT DISTINCT status, COUNT(*) as count
FROM pharmacy_sales
GROUP BY status

PRINT ''
PRINT 'Sample sales records:'
SELECT TOP 3
    saleid,
    invoice_number,
    sale_date,
    customer_name,
    total_amount,
    status
FROM pharmacy_sales
ORDER BY saleid DESC

PRINT ''
PRINT 'Test Query 1: Today Sales (no status filter)'
SELECT ISNULL(SUM(total_amount), 0) as total
FROM pharmacy_sales
WHERE CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)

PRINT ''
PRINT 'Test Query 2: Join pharmacy_sales with pharmacy_sales_items'
SELECT COUNT(*) as matching_records
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid

PRINT ''
PRINT 'Test Query 3: Profit calculation'
SELECT ISNULL(SUM(si.profit), 0) as total
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
WHERE CAST(s.sale_date AS DATE) = CAST(GETDATE() AS DATE)
