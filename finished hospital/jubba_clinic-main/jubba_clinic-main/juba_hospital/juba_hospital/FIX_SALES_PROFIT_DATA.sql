-- =====================================================
-- FIX SALES PROFIT DATA
-- =====================================================
-- This will recalculate and update profit for all existing sales
-- =====================================================

USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'FIXING SALES PROFIT DATA'
PRINT '====================================================='
PRINT ''

-- Show current state
PRINT 'BEFORE FIX:'
PRINT '-----------------------------------------------------'
SELECT 
    saleid,
    invoice_number,
    total_amount,
    ISNULL(total_cost, 0) as total_cost,
    ISNULL(total_profit, 0) as total_profit
FROM pharmacy_sales
ORDER BY saleid

PRINT ''
PRINT 'Updating sales with calculated profit...'
PRINT ''

-- Run the fix
UPDATE pharmacy_sales
SET 
    total_cost = (
        SELECT ISNULL(SUM(cost_price * quantity), 0)
        FROM pharmacy_sales_items
        WHERE saleid = pharmacy_sales.saleid
    ),
    total_profit = (
        SELECT ISNULL(SUM(profit), 0)
        FROM pharmacy_sales_items
        WHERE saleid = pharmacy_sales.saleid
    )
WHERE saleid IN (SELECT saleid FROM pharmacy_sales)

PRINT 'Update complete!'
PRINT ''

-- Show after state
PRINT 'AFTER FIX:'
PRINT '-----------------------------------------------------'
SELECT 
    saleid,
    invoice_number,
    total_amount,
    ISNULL(total_cost, 0) as total_cost,
    ISNULL(total_profit, 0) as total_profit
FROM pharmacy_sales
ORDER BY saleid

PRINT ''
PRINT '====================================================='
PRINT '✅ SALES PROFIT DATA FIXED!'
PRINT '====================================================='
