# Complete DateTime Fix Guide

## Summary of Changes Made

### ✅ COMPLETED:

1. **DateTimeHelper.cs** - Updated to use simple UTC+3 calculation
2. **discharge_summary_print.aspx.cs** - Fixed 4 DateTime.Now occurrences
3. **assignmed.aspx.cs** - Already using DateTimeHelper.Now ✅
4. **Add_patients.aspx.cs** - No DateTime.Now found ✅
5. **pharmacy_pos.aspx.cs** - No DateTime.Now found ✅

### 📋 SQL GETDATE() Approach:

Since your SQL Server has timezone issues, we have two options:

---

## Option 1: Use SQL Helper Function (RECOMMENDED)

Run the SQL fix first (FIX_TIMEZONE_COMPLETE.sql), which creates:
- `dbo.GetEATTime()` - Returns correct Somalia time
- `dbo.ConvertToEAT(@datetime)` - Converts any datetime to EAT

### How to Use:

**In SQL queries, replace:**
```sql
-- OLD
INSERT INTO patient (..., date_registered) VALUES (..., GETDATE())
WHERE date_registered > GETDATE()

-- NEW
INSERT INTO patient (..., date_registered) VALUES (..., dbo.GetEATTime())
WHERE date_registered > dbo.GetEATTime()
```

---

## Option 2: Pass DateTime from C# (SIMPLER)

Don't use GETDATE() in SQL at all. Always pass dates from C#:

### Example Fixes:

#### pharmacy_pos.aspx.cs - Line 367
**BEFORE:**
```csharp
string query = @"INSERT INTO pharmacy_sales 
    (invoice_no, customer_name, sale_date, ...) 
    VALUES (@invoice, @customer, GETDATE(), @subtotal, ...)";
```

**AFTER:**
```csharp
string query = @"INSERT INTO pharmacy_sales 
    (invoice_no, customer_name, sale_date, ...) 
    VALUES (@invoice, @customer, @saleDate, @subtotal, ...)";
    
cmd.Parameters.AddWithValue("@saleDate", DateTimeHelper.Now);
```

#### assignmed.aspx.cs - Line 857
**BEFORE:**
```csharp
query = "UPDATE prescribtion SET transaction_status = @transactionStatus, 
         completed_date = GETDATE() WHERE prescid = @prescid";
```

**AFTER:**
```csharp
query = "UPDATE prescribtion SET transaction_status = @transactionStatus, 
         completed_date = @completedDate WHERE prescid = @prescid";
         
cmd.Parameters.AddWithValue("@completedDate", DateTimeHelper.Now);
```

---

## Files That Need GETDATE() Replacement:

Based on the search, these files use GETDATE() in SQL:

### High Priority (User-facing operations):
1. **pharmacy_pos.aspx.cs** - Sales transactions
2. **assignmed.aspx.cs** - Prescription completion
3. **medicine_inventory.aspx.cs** - Inventory dates
4. **lab_completed_orders.aspx.cs** - Lab completion dates
5. **take_xray.aspx.cs** - X-ray completion dates

### Medium Priority (Reports - mostly for filtering):
6. **bed_revenue_report.aspx.cs** - Date filtering
7. **lab_revenue_report.aspx.cs** - Date filtering
8. **pharmacy_revenue_report.aspx.cs** - Date filtering
9. **charge_history.aspx.cs** - Date filtering
10. **admin_dashbourd.aspx.cs** - Dashboard stats

### Low Priority (Display/Comparisons):
11. **expired_medicines.aspx.cs** - Expiry checks
12. **low_stock.aspx.cs** - Reorder checks
13. **BedChargeCalculator.cs** - Charge calculations

---

## Quick Fix Strategy:

### Step 1: Run SQL Script First
```sql
-- This creates helper functions and fixes existing data
RUN: FIX_TIMEZONE_COMPLETE.sql
```

### Step 2: Fix High Priority Files

I'll create individual fixes for each critical file. Here are the most important ones:

---

## CRITICAL FILE FIXES:

### 1. pharmacy_pos.aspx.cs

**Find (around line 367):**
```csharp
(@invoice, @customer, GETDATE(), @subtotal, @discount, @final, @userid, @payment, 1);
```

**Replace with:**
```csharp
(@invoice, @customer, @saleDate, @subtotal, @discount, @final, @userid, @payment, 1);
```

**Add before the query:**
```csharp
cmd.Parameters.AddWithValue("@saleDate", DateTimeHelper.Now);
```

---

### 2. assignmed.aspx.cs

**Find (around line 857):**
```csharp
query = "UPDATE prescribtion SET transaction_status = @transactionStatus, completed_date = GETDATE() WHERE prescid = @prescid";
```

**Replace with:**
```csharp
query = "UPDATE prescribtion SET transaction_status = @transactionStatus, completed_date = @completedDate WHERE prescid = @prescid";
cmd.Parameters.AddWithValue("@completedDate", DateTimeHelper.Now);
```

---

### 3. For WHERE clauses (date comparisons)

Most GETDATE() in WHERE clauses are for filtering/comparisons. These can stay as-is IF:
- They're comparing with dates already in the database
- They're just checking if something expired

Example - This is OK to leave:
```csharp
WHERE expiry_date > GETDATE()  // Comparing dates, relative check
```

But this needs fixing:
```csharp
INSERT ... VALUES (GETDATE())  // Inserting a date - needs DateTimeHelper.Now
```

---

## Testing After Fixes:

### Test 1: Pharmacy Sale
```csharp
// Make a sale, then check database
SELECT TOP 1 sale_id, sale_date, dbo.GetEATTime() AS CurrentTime
FROM pharmacy_sales
ORDER BY sale_id DESC
-- sale_date should be within minutes of CurrentTime
```

### Test 2: Complete Prescription
```csharp
// Complete a prescription, check database
SELECT TOP 1 prescid, completed_date, dbo.GetEATTime() AS CurrentTime
FROM prescribtion
WHERE completed_date IS NOT NULL
ORDER BY prescid DESC
-- completed_date should be current time
```

### Test 3: Add Medicine Inventory
```csharp
// Add inventory, check date
SELECT TOP 1 id, medicine_name, added_date, dbo.GetEATTime() AS CurrentTime
FROM medicine_inventory
ORDER BY id DESC
-- added_date should match current time
```

---

## Automated Approach:

I can create a PowerShell script to replace all GETDATE() with parameterized dates, but it's risky because:
- Some GETDATE() are in WHERE clauses (OK to keep)
- Some are in INSERT/UPDATE (need to replace)
- Need to add parameters for each replacement

**Recommendation:** Fix the 5 high-priority files manually, then test thoroughly.

---

## Current Status:

✅ **DateTimeHelper.cs** - Fixed (uses UTC+3)  
✅ **discharge_summary_print.aspx.cs** - Fixed (4 occurrences)  
✅ **SQL Helper Functions** - Created (FIX_TIMEZONE_COMPLETE.sql)  
⏳ **pharmacy_pos.aspx.cs** - Needs manual fix (1 occurrence)  
⏳ **assignmed.aspx.cs** - Needs manual fix (1 occurrence)  
⏳ **Other files** - Review needed  

---

## Next Steps:

1. **Option A: I fix the 5 critical files for you**
   - pharmacy_pos.aspx.cs
   - assignmed.aspx.cs  
   - medicine_inventory.aspx.cs
   - lab_completed_orders.aspx.cs
   - take_xray.aspx.cs

2. **Option B: You run the PowerShell automation script**
   - Backup created automatically
   - Replaces all DateTime.Now
   - Review changes manually

3. **Option C: Use SQL helper functions**
   - Keep GETDATE() in SQL
   - Replace with dbo.GetEATTime()
   - No C# code changes needed

---

## Which approach do you prefer?

Let me know and I'll proceed with the fixes!
