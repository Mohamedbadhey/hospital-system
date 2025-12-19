# Debug Guide: Apply Button Not Working

## Issue
The Apply button isn't working when you click it after selecting filters.

## What I Fixed
1. **JavaScript Date Bug** - Fixed the `getDateRange()` function where the `today` variable was being mutated incorrectly
2. **Server-Side Filtering** - Backend now properly accepts and processes date parameters

## How to Debug

### Step 1: Open Browser Console
1. Open the Charge History page
2. Press `F12` to open Developer Tools
3. Go to the **Console** tab

### Step 2: Test the Apply Button
1. Select a charge type (e.g., "Registration")
2. Select a date range (e.g., "This Month")
3. Click the **"Apply"** button
4. Watch the Console for any errors

### Step 3: Check What's Being Sent
Add this temporarily to see what's being sent:

In the browser console, type:
```javascript
// Check if jQuery is loaded
typeof $ !== 'undefined'

// Check if the button exists
document.querySelector('[onclick="applyFilters()"]') !== null

// Manually call the function
applyFilters()
```

### Common Issues & Solutions

#### Issue 1: "applyFilters is not defined"
**Cause:** JavaScript error preventing function from loading  
**Solution:** Check console for syntax errors

#### Issue 2: "$.ajax is not a function"
**Cause:** jQuery not loaded  
**Solution:** Check if Scripts/jquery-3.4.1.min.js exists

#### Issue 3: AJAX call fails with 500 error
**Cause:** Backend error (wrong parameters)  
**Solution:** Check the backend response in Network tab

#### Issue 4: No data returned but no error
**Cause:** Database has no matching records  
**Solution:** Check if your database has charges with recent dates

## Testing Steps

### Test 1: All Time (Should Show All Data)
```
1. Charge Type: "All Types"
2. Date Range: "All Time"
3. Click "Apply"
Expected: Shows all charges in database
```

### Test 2: Today
```
1. Charge Type: "Registration"
2. Date Range: "Today"
3. Click "Apply"
Expected: Shows only Registration charges from today
```

### Test 3: Custom Range
```
1. Charge Type: "Lab"
2. Date Range: "Custom Range"
3. Set start date: 2025-11-01
4. Set end date: 2025-12-31
5. Click "Apply"
Expected: Shows only Lab charges from Nov-Dec 2025
```

## Check Backend Logs

Open your backend code and add logging:

In `charge_history.aspx.cs`, at the start of `GetChargeHistory`:

```csharp
[WebMethod]
public static List<ChargeHistoryRow> GetChargeHistory(string chargeType, string startDate, string endDate)
{
    // ADD THIS FOR DEBUGGING
    System.Diagnostics.Debug.WriteLine($"GetChargeHistory called: type={chargeType}, start={startDate}, end={endDate}");
    
    var list = new List<ChargeHistoryRow>();
    // ... rest of code
}
```

Then check Visual Studio's Output window for the debug messages.

## Quick Fix Script

Run this in browser console to test manually:

```javascript
// Test the AJAX call directly
$.ajax({
    url: 'charge_history.aspx/GetChargeHistory',
    data: JSON.stringify({ 
        chargeType: 'All',
        startDate: '',
        endDate: ''
    }),
    type: 'POST',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    success: function (response) {
        console.log('Success! Data received:', response.d.length, 'records');
        console.log('First record:', response.d[0]);
    },
    error: function (xhr, status, error) {
        console.error('Error:', xhr.status, xhr.responseText);
    }
});
```

## What to Check in Database

Run this SQL to see if you have recent data:

```sql
-- Check charges from last 30 days
SELECT 
    charge_type,
    COUNT(*) as count,
    MIN(date_added) as earliest,
    MAX(date_added) as latest
FROM patient_charges
WHERE date_added >= DATEADD(DAY, -30, GETDATE())
GROUP BY charge_type
ORDER BY charge_type;

-- If no results, check ALL data
SELECT 
    charge_type,
    COUNT(*) as count,
    MIN(date_added) as earliest,
    MAX(date_added) as latest
FROM patient_charges
GROUP BY charge_type
ORDER BY charge_type;
```

## Expected Behavior

When you click "Apply":
1. ✅ Table clears
2. ✅ Loading indicator (implicit)
3. ✅ AJAX call sent to backend
4. ✅ Backend filters data by charge type + dates
5. ✅ Frontend receives filtered data
6. ✅ Table populates with filtered data
7. ✅ Print button uses same filters

If any step fails, check the console for errors!

## Status
✅ JavaScript date bug fixed  
✅ Server-side filtering implemented  
⏳ Needs testing in your environment  
