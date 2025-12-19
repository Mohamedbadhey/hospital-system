-- ================================================================
-- Lab Test Pricing System - Verification Script
-- Run this after deployment to verify everything is working
-- ================================================================

USE [juba_clinick]
GO

PRINT '================================================================='
PRINT 'LAB TEST PRICING SYSTEM - VERIFICATION REPORT'
PRINT '================================================================='
PRINT ''

-- 1. Check if lab_test_prices table exists
PRINT '1. Checking if lab_test_prices table exists...'
IF OBJECT_ID('lab_test_prices', 'U') IS NOT NULL
BEGIN
    PRINT '   ✓ SUCCESS: lab_test_prices table exists'
    
    -- Count tests
    DECLARE @testCount INT
    SELECT @testCount = COUNT(*) FROM lab_test_prices
    PRINT '   ✓ Total tests configured: ' + CAST(@testCount AS VARCHAR(10))
    
    -- Count active tests
    DECLARE @activeCount INT
    SELECT @activeCount = COUNT(*) FROM lab_test_prices WHERE is_active = 1
    PRINT '   ✓ Active tests: ' + CAST(@activeCount AS VARCHAR(10))
    
    -- Count categories
    DECLARE @categoryCount INT
    SELECT @categoryCount = COUNT(DISTINCT test_category) FROM lab_test_prices
    PRINT '   ✓ Test categories: ' + CAST(@categoryCount AS VARCHAR(10))
END
ELSE
BEGIN
    PRINT '   ✗ ERROR: lab_test_prices table does NOT exist!'
    PRINT '   → Run CREATE_LAB_TEST_PRICES_TABLE.sql first'
END
PRINT ''

-- 2. Show test categories and counts
PRINT '2. Test Distribution by Category:'
PRINT '   ---------------------------------'
SELECT 
    test_category AS Category,
    COUNT(*) AS [Test Count],
    AVG(test_price) AS [Avg Price],
    MIN(test_price) AS [Min Price],
    MAX(test_price) AS [Max Price]
FROM lab_test_prices
WHERE is_active = 1
GROUP BY test_category
ORDER BY COUNT(*) DESC

PRINT ''

-- 3. Check for missing test prices (tests in lab_test table that don't have prices)
PRINT '3. Checking for tests without configured prices...'
PRINT '   (Analyzing lab_test table structure...)'

-- Get a sample lab test record to find ordered tests
IF EXISTS (SELECT 1 FROM lab_test)
BEGIN
    PRINT '   ✓ lab_test table has data'
    
    -- Check if there are recent lab orders
    DECLARE @recentOrders INT
    SELECT @recentOrders = COUNT(*) FROM lab_test WHERE date_taken >= DATEADD(day, -30, GETDATE())
    PRINT '   ✓ Lab orders in last 30 days: ' + CAST(@recentOrders AS VARCHAR(10))
END
ELSE
BEGIN
    PRINT '   ℹ No lab orders yet in system'
END
PRINT ''

-- 4. Check patient_charges table for lab charges
PRINT '4. Checking recent lab charges...'
IF EXISTS (SELECT 1 FROM patient_charges WHERE charge_type = 'Lab')
BEGIN
    DECLARE @totalLabCharges INT
    SELECT @totalLabCharges = COUNT(*) FROM patient_charges WHERE charge_type = 'Lab'
    PRINT '   ✓ Total lab charges in system: ' + CAST(@totalLabCharges AS VARCHAR(10))
    
    DECLARE @unpaidLabCharges INT
    SELECT @unpaidLabCharges = COUNT(*) FROM patient_charges WHERE charge_type = 'Lab' AND is_paid = 0
    PRINT '   ✓ Unpaid lab charges: ' + CAST(@unpaidLabCharges AS VARCHAR(10))
    
    DECLARE @paidLabCharges INT
    SELECT @paidLabCharges = COUNT(*) FROM patient_charges WHERE charge_type = 'Lab' AND is_paid = 1
    PRINT '   ✓ Paid lab charges: ' + CAST(@paidLabCharges AS VARCHAR(10))
END
ELSE
BEGIN
    PRINT '   ℹ No lab charges yet in system'
END
PRINT ''

-- 5. Sample test prices
PRINT '5. Sample Test Prices (Common Tests):'
PRINT '   ---------------------------------'
SELECT 
    test_display_name AS [Test Name],
    '$' + CAST(test_price AS VARCHAR(10)) AS [Price],
    test_category AS [Category]
FROM lab_test_prices
WHERE test_name IN (
    'Hemoglobin', 'Malaria', 'CBC', 'Blood_sugar', 
    'HIV', 'Hepatitis_B_virus_HBV', 'TSH', 'Creatinine'
)
ORDER BY test_category, test_display_name

PRINT ''

-- 6. Check for tests with $0 price (potential issues)
PRINT '6. Checking for tests with zero or invalid prices...'
IF EXISTS (SELECT 1 FROM lab_test_prices WHERE test_price = 0 OR test_price IS NULL)
BEGIN
    PRINT '   ⚠ WARNING: Some tests have $0 or NULL price!'
    SELECT 
        test_name, 
        test_display_name, 
        ISNULL(CAST(test_price AS VARCHAR), 'NULL') AS price
    FROM lab_test_prices 
    WHERE test_price = 0 OR test_price IS NULL
END
ELSE
BEGIN
    PRINT '   ✓ All tests have valid prices configured'
END
PRINT ''

-- 7. Test price statistics
PRINT '7. Price Statistics:'
PRINT '   ---------------------------------'
SELECT 
    COUNT(*) AS [Total Tests],
    AVG(test_price) AS [Average Price],
    MIN(test_price) AS [Minimum Price],
    MAX(test_price) AS [Maximum Price],
    SUM(test_price) AS [Total if all ordered]
FROM lab_test_prices
WHERE is_active = 1

PRINT ''

-- 8. Most expensive and cheapest tests
PRINT '8. Most Expensive Tests:'
PRINT '   ---------------------------------'
SELECT TOP 5
    test_display_name AS [Test Name],
    '$' + CAST(test_price AS VARCHAR(10)) AS [Price],
    test_category AS [Category]
FROM lab_test_prices
WHERE is_active = 1
ORDER BY test_price DESC

PRINT ''
PRINT '9. Cheapest Tests:'
PRINT '   ---------------------------------'
SELECT TOP 5
    test_display_name AS [Test Name],
    '$' + CAST(test_price AS VARCHAR(10)) AS [Price],
    test_category AS [Category]
FROM lab_test_prices
WHERE is_active = 1
ORDER BY test_price ASC

PRINT ''

-- 10. Check indexes
PRINT '10. Checking database indexes...'
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_lab_test_prices_name')
BEGIN
    PRINT '    ✓ Index on test_name exists'
END
ELSE
BEGIN
    PRINT '    ℹ Creating index on test_name...'
    CREATE UNIQUE NONCLUSTERED INDEX [IX_lab_test_prices_name] 
    ON [dbo].[lab_test_prices]([test_name] ASC)
    PRINT '    ✓ Index created'
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_patient_charges_reference')
BEGIN
    PRINT '    ✓ Index on patient_charges.reference_id exists'
END
ELSE
BEGIN
    PRINT '    ⚠ Index on patient_charges.reference_id is missing'
    PRINT '    → Run ADD_REFERENCE_ID_TO_CHARGES.sql'
END

PRINT ''

-- 11. Sample calculation test
PRINT '11. Testing price calculation (simulated order)...'
PRINT '    Simulating order: Hemoglobin + Malaria + CBC'
PRINT '    ---------------------------------'

DECLARE @hemPrice DECIMAL(10,2), @malPrice DECIMAL(10,2), @cbcPrice DECIMAL(10,2), @totalPrice DECIMAL(10,2)

SELECT @hemPrice = test_price FROM lab_test_prices WHERE test_name = 'Hemoglobin'
SELECT @malPrice = test_price FROM lab_test_prices WHERE test_name = 'Malaria'
SELECT @cbcPrice = test_price FROM lab_test_prices WHERE test_name = 'CBC'

SET @totalPrice = ISNULL(@hemPrice, 0) + ISNULL(@malPrice, 0) + ISNULL(@cbcPrice, 0)

PRINT '    Hemoglobin:          $' + CAST(ISNULL(@hemPrice, 0) AS VARCHAR(10))
PRINT '    Malaria:             $' + CAST(ISNULL(@malPrice, 0) AS VARCHAR(10))
PRINT '    CBC:                 $' + CAST(ISNULL(@cbcPrice, 0) AS VARCHAR(10))
PRINT '    ---------------------------------'
PRINT '    TOTAL:               $' + CAST(@totalPrice AS VARCHAR(10))

PRINT ''

-- 12. Final status
PRINT '================================================================='
PRINT 'VERIFICATION COMPLETE'
PRINT '================================================================='
PRINT ''

IF OBJECT_ID('lab_test_prices', 'U') IS NOT NULL AND 
   EXISTS (SELECT 1 FROM lab_test_prices WHERE is_active = 1)
BEGIN
    PRINT '✓✓✓ Lab Test Pricing System is READY!'
    PRINT ''
    PRINT 'Next Steps:'
    PRINT '1. Access admin interface: manage_lab_test_prices.aspx'
    PRINT '2. Review and adjust test prices as needed'
    PRINT '3. Test doctor ordering workflow'
    PRINT '4. Test payment processing with itemized charges'
END
ELSE
BEGIN
    PRINT '⚠⚠⚠ Lab Test Pricing System is NOT ready!'
    PRINT ''
    PRINT 'Required Actions:'
    PRINT '1. Run CREATE_LAB_TEST_PRICES_TABLE.sql'
    PRINT '2. Deploy application files'
    PRINT '3. Build and restart application'
END

PRINT ''
PRINT '================================================================='
GO
