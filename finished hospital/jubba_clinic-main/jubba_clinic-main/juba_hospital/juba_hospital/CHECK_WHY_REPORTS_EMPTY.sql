-- =====================================================
-- CHECK WHY REPORTS ARE EMPTY
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'CHECKING WHY REPORTS SHOW NO DATA'
PRINT '====================================================='
PRINT ''

-- Check actual sales with all details
PRINT '1. ALL SALES IN DATABASE:'
PRINT '-----------------------------------------------------'
SELECT 
    saleid,
    invoice_number,
    customer_name,
    CONVERT(VARCHAR, sale_date, 103) as sale_date_formatted,
    CAST(sale_date AS DATE) as sale_date_only,
    total_amount,
    ISNULL(total_cost, 0) as total_cost,
    ISNULL(total_profit, 0) as total_profit,
    status,
    CASE 
        WHEN status = 1 THEN 'Completed'
        WHEN status = 0 THEN 'Pending'
        ELSE 'Unknown (' + CAST(status AS VARCHAR) + ')'
    END as status_text
FROM pharmacy_sales
ORDER BY sale_date DESC

PRINT ''
PRINT '2. TODAY''S DATE INFO:'
PRINT '-----------------------------------------------------'
PRINT 'Today''s date (GETDATE()): ' + CONVERT(VARCHAR, GETDATE(), 103)
PRINT 'Today''s date (DATE only): ' + CONVERT(VARCHAR, CAST(GETDATE() AS DATE), 103)

PRINT ''
PRINT '3. CHECK IF TODAY''S SALES EXIST:'
PRINT '-----------------------------------------------------'
SELECT COUNT(*) as todays_sales_count
FROM pharmacy_sales
WHERE CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)
AND status = 1

PRINT ''
PRINT '4. THIS MONTH''S SALES:'
PRINT '-----------------------------------------------------'
SELECT COUNT(*) as this_month_sales_count
FROM pharmacy_sales
WHERE YEAR(sale_date) = YEAR(GETDATE())
AND MONTH(sale_date) = MONTH(GETDATE())
AND status = 1

PRINT ''
PRINT '5. TEST TODAY''S PROFIT QUERY:'
PRINT '-----------------------------------------------------'
SELECT ISNULL(SUM(si.profit), 0) as today_profit
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
WHERE CAST(s.sale_date AS DATE) = CAST(GETDATE() AS DATE)
AND s.status = 1

PRINT ''
PRINT '6. TEST SALES REPORT QUERY (LAST 30 DAYS):'
PRINT '-----------------------------------------------------'
SELECT 
    s.saleid,
    s.invoice_number,
    s.sale_date,
    s.customer_name,
    s.total_amount,
    s.status,
    ISNULL(SUM(si.cost_price * si.quantity), 0) as total_cost,
    ISNULL(SUM(si.profit), 0) as profit
FROM pharmacy_sales s
LEFT JOIN pharmacy_sales_items si ON s.saleid = si.saleid
WHERE CAST(s.sale_date AS DATE) BETWEEN DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)
AND s.status = 1
GROUP BY s.saleid, s.invoice_number, s.sale_date, s.customer_name, s.total_amount, s.status
ORDER BY s.sale_date DESC

PRINT ''
PRINT '7. TEST TOP MEDICINES QUERY:'
PRINT '-----------------------------------------------------'
SELECT TOP 10
    m.medicine_name,
    SUM(si.quantity) as total_quantity,
    SUM(si.total_price) as total_revenue,
    ISNULL(SUM(si.profit), 0) as total_profit
FROM pharmacy_sales_items si
INNER JOIN pharmacy_sales s ON si.saleid = s.saleid
LEFT JOIN medicine m ON si.medicineid = m.medicineid
WHERE s.status = 1
AND m.medicineid IS NOT NULL
GROUP BY m.medicine_name
ORDER BY SUM(si.total_price) DESC

PRINT ''
PRINT '8. CHECK SALES ITEMS DETAILS:'
PRINT '-----------------------------------------------------'
SELECT 
    psi.sale_item_id,
    psi.saleid,
    ps.invoice_number,
    ps.sale_date,
    psi.medicineid,
    m.medicine_name,
    psi.quantity,
    psi.unit_price,
    psi.total_price,
    psi.cost_price,
    psi.profit
FROM pharmacy_sales_items psi
LEFT JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
LEFT JOIN medicine m ON psi.medicineid = m.medicineid
ORDER BY psi.sale_item_id DESC

PRINT ''
PRINT '====================================================='
PRINT 'DIAGNOSIS SUMMARY'
PRINT '====================================================='
