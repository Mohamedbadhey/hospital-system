-- Test the piece deduction logic

-- Scenario: 25 strips, 0 loose pieces, tablets_per_strip = 10
-- Sell 3 pieces

DECLARE @primary INT = 0; -- primaryToDeduct = 3/10 = 0
DECLARE @loose INT = 3;   -- looseToDeduct = 3%10 = 3  
DECLARE @unitSize INT = 10; -- tablets_per_strip

-- Current values
DECLARE @current_primary INT = 25;
DECLARE @current_secondary INT = 0;

-- Test the SQL logic
SELECT 
    'Before' as Stage,
    @current_primary as primary_quantity,
    @current_secondary as secondary_quantity;

-- Simulate the UPDATE calculation
SELECT 
    'After' as Stage,
    -- primary_quantity calculation
    @current_primary - @primary - CASE WHEN @current_secondary < @loose THEN 1 ELSE 0 END as new_primary,
    -- secondary_quantity calculation
    CASE 
        WHEN @current_secondary >= @loose THEN @current_secondary - @loose
        WHEN @current_secondary < @loose AND @current_primary > 0 THEN (@current_secondary + @unitSize) - @loose
        ELSE @current_secondary - @loose
    END as new_secondary;

-- Expected result:
-- primary: 25 - 0 - 1 = 24 (broke 1 strip)
-- secondary: (0 + 10) - 3 = 7 (broke strip added 10 pieces, sold 3, left with 7)
