# C# Code Changes for Timezone Fix

## Overview
After running `FIX_TIMEZONE_COMPLETE.sql`, you need to update your C# code to always use the correct time.

---

## ✅ The Solution: Use UTC + 3 Hours

Replace all instances of `DateTime.Now` with `DateTime.UtcNow.AddHours(3)`

---

## 📋 Files to Update:

### 1. Add_patients.aspx.cs
**Location:** Patient registration date

**FIND:**
```csharp
cmd.Parameters.AddWithValue("@date_registered", DateTime.Now);
```

**REPLACE WITH:**
```csharp
// Use UTC+3 for East Africa Time (Somalia)
cmd.Parameters.AddWithValue("@date_registered", DateTime.UtcNow.AddHours(3));
```

---

### 2. assignmed.aspx.cs
**Location:** Prescription creation date

**FIND:**
```csharp
cmd.Parameters.AddWithValue("@date", DateTime.Now);
// or
cmd1.Parameters.AddWithValue("@date", DateTime.Now);
```

**REPLACE WITH:**
```csharp
// Use UTC+3 for East Africa Time
cmd.Parameters.AddWithValue("@date", DateTime.UtcNow.AddHours(3));
```

---

### 3. pharmacy_pos.aspx.cs
**Location:** Sale date

**FIND:**
```csharp
cmd.Parameters.AddWithValue("@sale_date", DateTime.Now);
```

**REPLACE WITH:**
```csharp
// Use UTC+3 for East Africa Time
cmd.Parameters.AddWithValue("@sale_date", DateTime.UtcNow.AddHours(3));
```

---

### 4. medicine_inventory.aspx.cs (or related file)
**Location:** Inventory added date

**FIND:**
```csharp
cmd.Parameters.AddWithValue("@added_date", DateTime.Now);
```

**REPLACE WITH:**
```csharp
// Use UTC+3 for East Africa Time
cmd.Parameters.AddWithValue("@added_date", DateTime.UtcNow.AddHours(3));
```

---

### 5. Any Lab/Xray Result Files
**Location:** Result entry dates

**FIND:**
```csharp
DateTime.Now
```

**REPLACE WITH:**
```csharp
DateTime.UtcNow.AddHours(3)
```

---

## 🔍 How to Find All Instances:

### In Visual Studio:
1. Press **Ctrl + Shift + F** (Find in Files)
2. Search for: `DateTime.Now`
3. Look in: Entire Solution
4. Replace each with: `DateTime.UtcNow.AddHours(3)`
5. **BUT:** Check context first! Don't replace display formatting

### What to Replace:
✅ **YES - Replace these:**
```csharp
cmd.Parameters.AddWithValue("@date", DateTime.Now);
var registrationDate = DateTime.Now;
prescribtion.date = DateTime.Now;
```

❌ **NO - Don't replace these:**
```csharp
// Display formatting
Label1.Text = DateTime.Now.ToString("dd/MM/yyyy");  // Leave as-is for display

// Calculations (may need review)
if (expiryDate < DateTime.Now)  // Review case-by-case
```

---

## 💡 Alternative: Create a Helper Property

Create a static helper to avoid repeating the same code:

**Add to a utility class (e.g., DateTimeHelper.cs):**

```csharp
public static class DateTimeHelper
{
    /// <summary>
    /// Gets the current time in East Africa Time (UTC+3)
    /// </summary>
    public static DateTime EATNow
    {
        get { return DateTime.UtcNow.AddHours(3); }
    }
}
```

**Then use everywhere:**
```csharp
cmd.Parameters.AddWithValue("@date_registered", DateTimeHelper.EATNow);
cmd.Parameters.AddWithValue("@sale_date", DateTimeHelper.EATNow);
```

---

## 📝 Specific File Changes:

### Add_patients.aspx.cs - Registration Method

**Search for method that inserts patient:**
```csharp
protected void RegisterPatient_Click(object sender, EventArgs e)
{
    // ... existing code ...
    
    SqlCommand cmd = new SqlCommand("INSERT INTO patient (..., date_registered, ...) VALUES (..., @date_registered, ...)", con);
    
    // CHANGE THIS LINE:
    cmd.Parameters.AddWithValue("@date_registered", DateTime.Now);
    
    // TO THIS:
    cmd.Parameters.AddWithValue("@date_registered", DateTime.UtcNow.AddHours(3));
}
```

---

### assignmed.aspx.cs - Prescription Save

**Find the save/insert method:**
```csharp
[WebMethod]
public static string save(...)
{
    // ... existing code ...
    
    SqlCommand cmd = new SqlCommand("INSERT INTO prescribtion (..., date, ...) VALUES (..., @date, ...)", con);
    
    // CHANGE THIS:
    cmd.Parameters.AddWithValue("@date", DateTime.Now);
    
    // TO THIS:
    cmd.Parameters.AddWithValue("@date", DateTime.UtcNow.AddHours(3));
}
```

---

### pharmacy_pos.aspx.cs - Sale Transaction

**Find the sale completion method:**
```csharp
private void CompleteSale()
{
    // ... existing code ...
    
    SqlCommand cmd = new SqlCommand("INSERT INTO pharmacy_sales (..., sale_date, ...) VALUES (..., @sale_date, ...)", con);
    
    // CHANGE THIS:
    cmd.Parameters.AddWithValue("@sale_date", DateTime.Now);
    
    // TO THIS:
    cmd.Parameters.AddWithValue("@sale_date", DateTime.UtcNow.AddHours(3));
}
```

---

## ⚠️ Important Notes:

### 1. Don't Change Default Values in SQL
Keep these as-is:
```sql
CREATE TABLE patient (
    date_registered DATETIME DEFAULT GETDATE()  -- Leave this
)
```
We'll handle it in C# code instead.

### 2. Review Date Comparisons
Check any date comparison logic:
```csharp
// OLD - May be comparing wrong timezone
if (expiryDate < DateTime.Now)

// NEW - Use consistent timezone
if (expiryDate < DateTime.UtcNow.AddHours(3))
```

### 3. Display Formatting Can Stay
Date display formatting doesn't need to change:
```csharp
// This is fine - just displaying to user
lblDate.Text = someDate.ToString("dd/MM/yyyy");
```

---

## ✅ Testing After Changes:

1. **Register a new patient**
   - Check date_registered in database
   - Should show current Somalia time (not yesterday!)

2. **Create a prescription**
   - Check date in prescribtion table
   - Should be current time

3. **Make a pharmacy sale**
   - Check sale_date
   - Should be current time

4. **Run verification query:**
```sql
-- Check newest records
SELECT TOP 5 patientid, full_name, date_registered, dbo.GetEATTime() AS CurrentTime
FROM patient
ORDER BY date_registered DESC
-- date_registered should be within last few minutes of CurrentTime
```

---

## 🎯 Summary:

**Replace:** `DateTime.Now`  
**With:** `DateTime.UtcNow.AddHours(3)`  
**In:** All database insert/update operations

**Result:** All dates will be stored correctly in Somalia timezone!

---

## Files You Need:

1. ✅ `FIX_TIMEZONE_COMPLETE.sql` - Run on database (fixes existing data)
2. ✅ `CSHARP_TIMEZONE_FIXES.md` - This file (reference for code changes)

**Order:**
1. Run SQL script first
2. Then update C# code
3. Rebuild and deploy
4. Test!
