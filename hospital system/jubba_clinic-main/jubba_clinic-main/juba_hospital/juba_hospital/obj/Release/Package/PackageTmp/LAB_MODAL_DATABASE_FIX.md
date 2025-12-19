# Lab Modal Database Structure Fix

## Issue
The modal implementation was failing with errors because it was looking for a `test_name` column that doesn't exist in the database.

## Root Cause
The `lab_test` table in your database stores tests differently than expected:
- **Actual Structure:** Each test type is a COLUMN (Hemoglobin, Malaria, CBC, etc.) with values like "checked" or "not checked"
- **Assumed Structure:** A single `test_name` column with test names (incorrect assumption)

## Database Structure

### lab_test Table (Actual):
```sql
CREATE TABLE [dbo].[lab_test](
    [med_id] [int] IDENTITY(1,1) NOT NULL,
    [Low_density_lipoprotein_LDL] [varchar](255) NULL,
    [High_density_lipoprotein_HDL] [varchar](255) NULL,
    [Total_cholesterol] [varchar](255) NULL,
    ...
    [Hemoglobin] [varchar](255) NULL,
    [Malaria] [varchar](255) NULL,
    [CBC] [varchar](255) NULL,
    [Blood_sugar] [varchar](255) NULL,
    ...
    [prescid] [int] NULL,
    [date_taken] [datetime] NULL,
    [is_reorder] [bit] NULL,
    [reorder_reason] [nvarchar](500) NULL,
    PRIMARY KEY ([med_id])
)
```

### How Tests are Stored:
- Each test type has its own column
- If a test is ordered: column value = "checked" or similar
- If test NOT ordered: column value = NULL or "not checked"

Example row:
```
med_id=1, Hemoglobin='checked', Malaria='checked', CBC=NULL, Blood_sugar='not checked', ...
```

## Solution Applied

### Fixed GetOrderedTests WebMethod:
**Before (Incorrect):**
```csharp
SELECT lt.test_name, p.full_name, lt.date_taken
FROM lab_test lt ...
```

**After (Correct):**
```csharp
SELECT lt.*, p.full_name, lt.date_taken
FROM lab_test lt ...

// Then iterate through all columns
for (int i = 0; i < dr.FieldCount; i++)
{
    string columnName = dr.GetName(i);
    string value = dr.GetValue(i).ToString();
    
    // If value is NOT null, empty, or "not checked", it's an ordered test
    if (!string.IsNullOrWhiteSpace(value) && 
        !value.Equals("not checked", StringComparison.OrdinalIgnoreCase))
    {
        tests.Add(new OrderedTest {
            TestName = FormatLabel(columnName) // e.g., "Hemoglobin"
        });
    }
}
```

### Fixed GetPatientLabHistory WebMethod:
Same approach - iterate through all columns to find which tests were ordered.

## Files Modified

### 1. lab_waiting_list.aspx.cs
**Changes:**
- Updated `GetOrderedTests()` WebMethod to read all columns
- Updated `GetPatientLabHistory()` WebMethod to read all columns
- Added logic to iterate through columns and identify ordered tests
- Excluded system columns (med_id, prescid, date_taken, etc.)
- Format column names to readable labels (e.g., "Hemoglobin_Test" → "Hemoglobin Test")

## How It Works Now

### 1. User Clicks "Tests" Button:
```
1. AJAX call to GetOrderedTests(prescid, orderId)
2. Query: SELECT lt.*, patient_name FROM lab_test...
3. Read ONE row for that order
4. Iterate through ALL columns:
   - Skip: med_id, prescid, date_taken (system columns)
   - Check each test column (Hemoglobin, Malaria, etc.)
   - If value is NOT null/empty/"not checked" → Test was ordered
   - Add to list with formatted name
5. Return array of ordered tests
6. Display in modal
```

### 2. User Clicks "History" Button:
```
1. AJAX call to GetPatientLabHistory(patientId)
2. Query: SELECT lt.*, ... FROM lab_test WHERE patientid=X
3. For EACH lab order:
   - Iterate through columns to find ordered tests
   - Check if results exist (lab_results table)
   - Build complete history
4. Return history data with statistics
5. Display in modal
```

## Column Exclusion Logic

### Excluded from Test List:
```csharp
var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
{
    "med_id",           // Order ID
    "prescid",          // Prescription ID
    "date_taken",       // Order date
    "is_reorder",       // Reorder flag
    "reorder_reason",   // Reorder reason
    "original_order_id",// Original order reference
    "patient_name",     // Patient name (from JOIN)
    "order_date",       // Order date (alias)
    "is_completed",     // Completion status
    "doctortitle"       // Doctor name (from JOIN)
};
```

## Test Detection Logic

### A test is considered "ordered" if:
1. Column value is NOT null
2. Column value is NOT DBNull
3. Column value is NOT empty/whitespace
4. Column value is NOT "not checked" (case-insensitive)

### Examples:
```
Hemoglobin = "checked"      → ORDERED ✓
Malaria = "yes"             → ORDERED ✓
CBC = NULL                  → NOT ORDERED ✗
Blood_sugar = ""            → NOT ORDERED ✗
ESR = "not checked"         → NOT ORDERED ✗
```

## Label Formatting

### FormatLabel() Method:
Converts database column names to readable labels:

```csharp
"Hemoglobin" → "Hemoglobin"
"Blood_sugar" → "Blood Sugar"
"Low_density_lipoprotein_LDL" → "Low Density Lipoprotein Ldl"
"Human_immune_deficiency_HIV" → "Human Immune Deficiency Hiv"
```

## Testing the Fix

### Test "Tests" Modal:
1. Open Lab Waiting List
2. Click "Tests" button on any order
3. **Expected:** Modal shows list of ordered tests
4. **Previously:** Error - "test_name not found"

### Test "History" Modal:
1. Open Lab Waiting List
2. Click "History" button
3. **Expected:** Modal shows all lab orders with tests
4. **Previously:** Error - "test_name not found"

## Benefits of This Approach

### ✅ Advantages:
- Works with your actual database structure
- No database schema changes needed
- Handles any number of test columns
- Future-proof (new test columns automatically work)
- Filters out system columns correctly

### ✅ Flexibility:
- If you add new test columns to lab_test, they'll automatically appear
- If you rename columns, labels auto-format
- No hard-coded test names

## Technical Notes

### Performance:
- **Good:** Only one query per order
- **Good:** Column iteration is fast
- **Good:** No multiple round-trips to database

### Maintainability:
- **Good:** Generic solution works with any columns
- **Good:** Easy to add exclusions if needed
- **Good:** Clear separation of concerns

## Compatibility

### Works With:
✅ Your current database structure  
✅ All existing lab orders  
✅ Any test column names  
✅ Future database additions

### Requires:
- lab_test table with test columns
- prescribtion table with patientid
- patient table with patient info
- lab_results table for completed tests (optional)

## Status

✅ **FIXED AND READY TO TEST**

The modal implementation now correctly:
- Reads test data from column values
- Identifies which tests were ordered
- Displays test names in readable format
- Shows complete patient history

## Next Steps

1. **Rebuild** the solution in Visual Studio
2. **Test** the "Tests" modal
3. **Test** the "History" modal
4. **Verify** data displays correctly

## Troubleshooting

### If modal still shows errors:
1. Check browser console for JavaScript errors
2. Check IIS logs for server errors
3. Verify database connection string
4. Test query directly in SQL Server Management Studio

### Common Issues:
- **Empty modal:** No tests were ordered (all columns NULL/"not checked")
- **Wrong tests:** Check column values in database
- **Missing tests:** Column might be in exclusion list

---

**Fixed:** 2024  
**Issue:** Database structure mismatch  
**Resolution:** Updated queries to match actual table structure  
**Status:** ✅ Complete and ready to test
