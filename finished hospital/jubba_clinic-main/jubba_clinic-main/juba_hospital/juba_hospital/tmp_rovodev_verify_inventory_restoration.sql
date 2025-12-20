-- Verify Inventory Restoration After Return
USE [juba_clinick]
GO

PRINT '========================================='
PRINT 'Inventory Restoration Verification'
PRINT '========================================='
PRINT ''

-- Show all returns
PRINT '1. RECENT RETURNS:'
PRINT '-----------------'
SELECT TOP 5
    pr.return_invoice,
    pr.original_invoice,
    pr.customer_name,
    pr.return_date,
    pr.total_return_amount,
    pr.return_reason
FROM pharmacy_returns pr
ORDER BY pr.return_date DESC
GO

PRINT ''
PRINT '2. RETURN ITEMS DETAIL:'
PRINT '-----------------------'
SELECT 
    pr.return_invoice,
    m.medicine_name,
    pri.quantity_type,
    pri.quantity_returned,
    pri.return_amount
FROM pharmacy_return_items pri
INNER JOIN pharmacy_returns pr ON pri.returnid = pr.returnid
INNER JOIN medicine m ON pri.medicineid = m.medicineid
ORDER BY pr.return_date DESC
GO

PRINT ''
PRINT '3. CURRENT INVENTORY LEVELS:'
PRINT '----------------------------'
-- Show inventory for medicines that were returned
SELECT 
    m.medicine_name,
    mi.primary_quantity as 'Boxes',
    mi.total_strips as 'Strips',
    mi.loose_tablets as 'Loose Tablets',
    mi.secondary_quantity as 'Secondary Qty',
    mi.last_updated
FROM medicine m
INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
WHERE m.medicineid IN (
    SELECT DISTINCT medicineid FROM pharmacy_return_items
)
ORDER BY m.medicine_name
GO

PRINT ''
PRINT '4. DETAILED INVENTORY CHECK:'
PRINT '----------------------------'
-- Compare before and after for specific medicine
SELECT 
    pr.return_invoice,
    pr.return_date,
    m.medicine_name,
    pri.quantity_type,
    pri.quantity_returned,
    CASE 
        WHEN pri.quantity_type IN ('box', 'boxes') THEN mi.primary_quantity
        WHEN pri.quantity_type IN ('strip', 'strips', 'bottle', 'bottles', 'vial', 'vials') THEN mi.total_strips
        ELSE mi.loose_tablets
    END as 'Current Stock in Inventory'
FROM pharmacy_return_items pri
INNER JOIN pharmacy_returns pr ON pri.returnid = pr.returnid
INNER JOIN medicine m ON pri.medicineid = m.medicineid
INNER JOIN medicine_inventory mi ON pri.inventoryid = mi.inventoryid
ORDER BY pr.return_date DESC
GO

PRINT ''
PRINT '5. VERIFY RESTORATION LOGIC:'
PRINT '----------------------------'
-- Show what should have been restored
SELECT 
    pr.return_invoice,
    m.medicine_name,
    pri.quantity_type,
    pri.quantity_returned as 'Qty Returned',
    CASE 
        WHEN pri.quantity_type IN ('box', 'boxes') THEN 'Should be added to primary_quantity (boxes)'
        WHEN pri.quantity_type IN ('strip', 'strips', 'bottle', 'bottles', 'vial', 'vials', 'tube', 'tubes', 'inhaler', 'sachet') 
            THEN 'Should be added to total_strips'
        ELSE 'Should be added to loose_tablets and secondary_quantity'
    END as 'Expected Restoration'
FROM pharmacy_return_items pri
INNER JOIN pharmacy_returns pr ON pri.returnid = pr.returnid
INNER JOIN medicine m ON pri.medicineid = m.medicineid
ORDER BY pr.return_date DESC
GO

PRINT ''
PRINT '========================================='
PRINT 'HOW TO VERIFY:'
PRINT '========================================='
PRINT '1. Note the medicine name and quantity returned'
PRINT '2. Check the "Current Stock in Inventory" column'
PRINT '3. Verify the stock increased by the returned amount'
PRINT ''
PRINT 'If stock did NOT increase:'
PRINT '  - Check quantity_type matches expected restoration'
PRINT '  - Review RestoreInventory function in code'
PRINT '  - Check for transaction errors in logs'
PRINT '========================================='
