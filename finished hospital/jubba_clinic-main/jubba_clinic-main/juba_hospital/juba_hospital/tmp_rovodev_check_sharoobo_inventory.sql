-- Check sharoobo qufac inventory status
USE [juba_clinick]
GO

PRINT '========================================='
PRINT 'Sharoobo Qufac Inventory Analysis'
PRINT '========================================='
PRINT ''

-- Get medicine and inventory details
PRINT '1. CURRENT INVENTORY STATUS:'
PRINT '----------------------------'
SELECT 
    m.medicineid,
    m.medicine_name,
    mi.inventoryid,
    mi.primary_quantity as 'Boxes',
    mi.total_strips as 'Bottles/Strips',
    mi.loose_tablets as 'Loose Items',
    mi.secondary_quantity as 'Secondary Qty',
    mi.purchase_price as 'Cost per Box',
    mi.last_updated
FROM medicine m
INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
WHERE m.medicine_name LIKE '%sharoobo%'
GO

PRINT ''
PRINT '2. SALES HISTORY (Last 10 sales):'
PRINT '----------------------------------'
SELECT TOP 10
    ps.invoice_number,
    ps.sale_date,
    psi.quantity_type,
    psi.quantity as 'Qty Sold',
    psi.total_price
FROM pharmacy_sales_items psi
INNER JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
INNER JOIN medicine m ON psi.medicineid = m.medicineid
WHERE m.medicine_name LIKE '%sharoobo%'
ORDER BY ps.sale_date DESC
GO

PRINT ''
PRINT '3. RETURN HISTORY:'
PRINT '------------------'
SELECT 
    pr.return_invoice,
    pr.return_date,
    pri.quantity_type,
    pri.quantity_returned as 'Qty Returned'
FROM pharmacy_return_items pri
INNER JOIN pharmacy_returns pr ON pri.returnid = pr.returnid
INNER JOIN medicine m ON pri.medicineid = m.medicineid
WHERE m.medicine_name LIKE '%sharoobo%'
ORDER BY pr.return_date DESC
GO

PRINT ''
PRINT '4. NET CALCULATION:'
PRINT '-------------------'
-- Calculate net sales vs returns
SELECT 
    m.medicine_name,
    (SELECT ISNULL(SUM(psi.quantity), 0) 
     FROM pharmacy_sales_items psi 
     INNER JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
     WHERE psi.medicineid = m.medicineid 
     AND psi.quantity_type IN ('bottle', 'bottles')
     AND ps.status = 1) as 'Total Bottles Sold',
    (SELECT ISNULL(SUM(pri.quantity_returned), 0) 
     FROM pharmacy_return_items pri 
     WHERE pri.medicineid = m.medicineid 
     AND pri.quantity_type IN ('bottle', 'bottles')) as 'Total Bottles Returned',
    (SELECT ISNULL(SUM(psi.quantity), 0) 
     FROM pharmacy_sales_items psi 
     INNER JOIN pharmacy_sales ps ON psi.saleid = ps.saleid
     WHERE psi.medicineid = m.medicineid 
     AND psi.quantity_type IN ('bottle', 'bottles')
     AND ps.status = 1) - 
    (SELECT ISNULL(SUM(pri.quantity_returned), 0) 
     FROM pharmacy_return_items pri 
     WHERE pri.medicineid = m.medicineid 
     AND pri.quantity_type IN ('bottle', 'bottles')) as 'Net Bottles Sold',
    mi.total_strips as 'Current Inventory'
FROM medicine m
INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
WHERE m.medicine_name LIKE '%sharoobo%'
GO

PRINT ''
PRINT '5. FIX NEGATIVE INVENTORY:'
PRINT '-------------------------'
PRINT 'If inventory is negative, you need to add stock.'
PRINT ''
PRINT 'To add 20 bottles to sharoobo qufac inventory:'
PRINT '  UPDATE medicine_inventory'
PRINT '  SET total_strips = total_strips + 20'
PRINT '  WHERE inventoryid = (SELECT TOP 1 inventoryid FROM medicine_inventory mi'
PRINT '                       INNER JOIN medicine m ON mi.medicineid = m.medicineid'
PRINT '                       WHERE m.medicine_name LIKE ''%sharoobo%'')'
PRINT ''
PRINT '========================================='
