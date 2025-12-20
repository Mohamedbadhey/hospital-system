# Column Name Mismatch - Fix Instructions

## 🔴 ISSUE DETECTED

You encountered an error when running `VERIFY_COST_PRICE_DATA.sql`:

```
Msg 207, Level 16, State 1, Line 172
Invalid column name 'sale_id'.
Msg 207, Level 16, State 1, Line 173
Invalid column name 'medicine_id'.
```

This means your database has column names **WITHOUT underscores** (`saleid`, `medicineid`, `inventoryid`), but:
- The backend code uses names **WITH underscores** (`sale_id`, `medicine_id`, `inventory_id`)
- The verification script was using names WITH underscores

---

## ✅ SOLUTION

Follow these steps IN ORDER:

### Step 1: Check Your Current Column Names

Run this script to see what columns you actually have:

```sql
-- File: CHECK_PHARMACY_SALES_ITEMS_COLUMNS.sql
```

This will show you:
- Which column naming convention your database uses
- Whether cost_price and profit columns exist
- Any sample data in the table

**Expected Output:**
```
✅ Found: saleid (without underscore)
❌ NOT Found: sale_id
✅ Found: medicineid (without underscore)
❌ NOT Found: medicine_id
...
```

---

### Step 2: Choose Your Fix Strategy

Based on what you found, choose ONE option:

#### **Option A: Add Columns WITH Underscores (RECOMMENDED)**

This keeps backward compatibility - both old and new column names will work.

**Run this script:**
```sql
-- File: FIX_COLUMN_NAMES_PHARMACY_SALES_ITEMS.sql
```

**What it does:**
- Adds `sale_id`, `medicine_id`, `inventory_id` columns
- Copies data from existing `saleid`, `medicineid`, `inventoryid`
- Ensures `cost_price` and `profit` columns exist
- Keeps original columns intact (safe)

**Pros:**
- ✅ No data loss
- ✅ Backward compatible
- ✅ Backend code works without changes
- ✅ Safe to run multiple times

**Cons:**
- ⚠️ Slight storage overhead (duplicate columns)

---

#### **Option B: Fix Backend Code (ALTERNATIVE)**

Update the backend code to use column names WITHOUT underscores.

**Files to fix:**
- `pharmacy_pos.aspx.cs` (line 283)

**Change FROM:**
```csharp
INSERT INTO pharmacy_sales_items (sale_id, medicine_id, inventory_id, ...)
VALUES (@saleid, @medid, @invid, ...)
```

**Change TO:**
```csharp
INSERT INTO pharmacy_sales_items (saleid, medicineid, inventoryid, ...)
VALUES (@saleid, @medid, @invid, ...)
```

**Pros:**
- ✅ Clean database schema
- ✅ Matches original design

**Cons:**
- ❌ Requires code changes and recompilation
- ❌ Need to redeploy application

---

## 📋 RECOMMENDED STEPS (Option A)

### 1. Check Current State
```sql
-- Run in SQL Server Management Studio
USE [juba_clinick]
GO

-- Execute:
-- CHECK_PHARMACY_SALES_ITEMS_COLUMNS.sql
```

### 2. Fix Column Names
```sql
-- Execute:
-- FIX_COLUMN_NAMES_PHARMACY_SALES_ITEMS.sql
```

**Expected Output:**
```
✅ Table pharmacy_sales_items exists
✅ sale_id column added
✅ medicine_id column added
✅ inventory_id column added
✅ cost_price column already exists
✅ profit column already exists
✅ All required columns exist!
✅ SUCCESS - pharmacy_sales_items is ready!
```

### 3. Re-run Verification Script
```sql
-- Now this should work without errors:
-- VERIFY_COST_PRICE_DATA.sql
```

**Expected Output:**
```
===================================================
COST AND SELLING PRICE VERIFICATION REPORT
===================================================

✅ All queries run successfully
📊 System Health Score: XX%
```

---

## 🧪 TESTING AFTER FIX

### Test 1: Verify Columns Exist
```sql
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'pharmacy_sales_items'
  AND COLUMN_NAME IN ('sale_id', 'medicine_id', 'inventory_id', 'cost_price', 'profit')
ORDER BY COLUMN_NAME;
```

**Should return 5 rows:**
- cost_price
- inventory_id
- medicine_id
- profit
- sale_id

### Test 2: Try a Test Sale

1. Go to Pharmacy POS
2. Add an item to cart
3. Complete a sale
4. Check if data saves:

```sql
SELECT TOP 1 
    sale_id,
    medicine_id,
    inventory_id,
    quantity,
    unit_price,
    cost_price,
    profit
FROM pharmacy_sales_items
ORDER BY sale_item_id DESC;
```

**Should show:**
- sale_id with a value (not NULL)
- medicine_id with a value
- cost_price calculated
- profit calculated

---

## ⚠️ TROUBLESHOOTING

### Issue: Script says columns already exist but still get errors

**Solution:** The columns might have wrong data types. Check:
```sql
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales_items'
  AND COLUMN_NAME IN ('sale_id', 'medicine_id', 'inventory_id');
```

All should be `int` and `YES` (nullable).

---

### Issue: Old sales data missing new columns

**Solution:** This is normal. Old sales were saved before the fix. Run:
```sql
-- Backfill sale_id from saleid
UPDATE pharmacy_sales_items 
SET sale_id = saleid 
WHERE sale_id IS NULL AND saleid IS NOT NULL;

-- Backfill medicine_id from medicineid
UPDATE pharmacy_sales_items 
SET medicine_id = medicineid 
WHERE medicine_id IS NULL AND medicineid IS NOT NULL;

-- Backfill inventory_id from inventoryid
UPDATE pharmacy_sales_items 
SET inventory_id = inventoryid 
WHERE inventory_id IS NULL AND inventoryid IS NOT NULL;
```

---

### Issue: Backend still throws errors after column fix

**Check:**
1. Did you restart IIS / Application pool?
2. Are there compilation errors?
3. Check Web.config connection string is correct

**Restart Application:**
```powershell
# In IIS Manager
# Or restart the application pool
iisreset
```

---

## 📊 SUMMARY

| Task | File | Action |
|------|------|--------|
| 1. Check columns | `CHECK_PHARMACY_SALES_ITEMS_COLUMNS.sql` | Run to see current state |
| 2. Fix columns | `FIX_COLUMN_NAMES_PHARMACY_SALES_ITEMS.sql` | Run to add missing columns |
| 3. Verify system | `VERIFY_COST_PRICE_DATA.sql` | Run to check everything works |

---

## 📞 ADDITIONAL HELP

If you still have issues after running these scripts:

1. **Share the output** of `CHECK_PHARMACY_SALES_ITEMS_COLUMNS.sql`
2. **Share any error messages** you still get
3. **Check if sales are working** in the POS system

---

**Document Version:** 1.0  
**Created:** [Current Date]  
**Issue:** Column name mismatch in pharmacy_sales_items  
**Status:** Fixable with provided scripts
