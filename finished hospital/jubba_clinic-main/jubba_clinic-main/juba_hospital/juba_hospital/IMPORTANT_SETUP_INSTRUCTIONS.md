# ⚠️ CRITICAL: Setup Instructions for Unit-Based Selling

## Issues Found & How to Fix

### Issue 1: pharmacy_pos.aspx has duplicate content
**Problem:** The file contains the same page twice, which causes errors.

**Solution:** 
1. In Visual Studio, open `pharmacy_pos.aspx`
2. **Delete the entire content** of the file
3. Open `pharmacy_pos_CLEAN.aspx` (created for you)
4. **Copy all content** from pharmacy_pos_CLEAN.aspx
5. **Paste** into pharmacy_pos.aspx
6. Save the file
7. Delete pharmacy_pos_CLEAN.aspx (it was just a backup)

### Issue 2: Database columns might not exist
**Problem:** The `medicine_units` table needs new columns for unit-based selling to work.

**Solution:** Run this SQL script on your database:

```sql
-- File: unit_selling_methods_schema.sql (already exists in your project)
-- Location: juba_hospital folder
-- Run this in SQL Server Management Studio
```

## Step-by-Step Fix Instructions

### Step 1: Fix pharmacy_pos.aspx File

1. Open Visual Studio
2. Open `juba_hospital/pharmacy_pos.aspx`
3. You'll see it has duplicate content (same page appears twice)
4. **Select All** (Ctrl+A) and **Delete**
5. Open `juba_hospital/pharmacy_pos_CLEAN.aspx`
6. **Select All** (Ctrl+A) and **Copy** (Ctrl+C)
7. Go back to `pharmacy_pos.aspx`
8. **Paste** (Ctrl+V)
9. **Save** (Ctrl+S)
10. Delete `pharmacy_pos_CLEAN.aspx` from project

### Step 2: Check Database Columns

1. Open SQL Server Management Studio
2. Connect to your database (`juba_clinick`)
3. Run this query to check if columns exist:

```sql
-- Run this to check
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'medicine_units' 
AND COLUMN_NAME IN ('selling_method', 'base_unit_name', 'subdivision_unit', 'allows_subdivision');
```

**If it returns 0 rows:** You need to run Step 3  
**If it returns 4 rows:** Skip to Step 4

### Step 3: Add Database Columns (ONLY if Step 2 returned 0 rows)

Run the `unit_selling_methods_schema.sql` file:

1. In SQL Server Management Studio
2. File → Open → File
3. Navigate to `juba_hospital/unit_selling_methods_schema.sql`
4. Click **Execute** (F5)
5. Wait for "Command(s) completed successfully"

### Step 4: Check if Units Exist

```sql
SELECT * FROM medicine_units;
```

**If table is empty or has only "Strip" and "Tablet":**

You need to insert all 15 unit types. Run this:

```sql
-- Insert all 15 unit types with configurations
INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
VALUES 
('Tablet', 'Tab', 'countable', 'piece', 'strip', 1, 'pieces per strip'),
('Capsule', 'Cap', 'countable', 'piece', 'strip', 1, 'pieces per strip'),
('Syrup', 'Syr', 'volume', 'ml', 'bottle', 1, 'ml per bottle'),
('Bottle', 'Btl', 'volume', 'ml', 'bottle', 1, 'ml per bottle'),
('Injection', 'Inj', 'countable', 'vial', NULL, 0, 'ml per vial'),
('Drops', 'Drp', 'volume', 'ml', 'bottle', 1, 'ml per bottle'),
('Cream', 'Crm', 'countable', 'tube', NULL, 0, 'grams per tube'),
('Ointment', 'Oint', 'countable', 'tube', NULL, 0, 'grams per tube'),
('Gel', 'Gel', 'countable', 'tube', NULL, 0, 'grams per tube'),
('Inhaler', 'Inh', 'countable', 'inhaler', NULL, 0, 'doses per inhaler'),
('Powder', 'Pwd', 'countable', 'sachet', NULL, 0, 'grams per sachet'),
('Sachet', 'Sach', 'countable', 'sachet', NULL, 0, 'grams per sachet'),
('Suppository', 'Supp', 'countable', 'piece', NULL, 0, 'suppositories'),
('Patch', 'Ptch', 'countable', 'piece', NULL, 0, 'patches'),
('Spray', 'Spry', 'countable', 'bottle', NULL, 0, 'ml per bottle');
```

### Step 5: Update Existing Medicines (if you have any)

If you already have medicines in your database without `unit_id`:

```sql
-- Assign default unit (Tablet) to medicines without unit_id
UPDATE medicine 
SET unit_id = (SELECT unit_id FROM medicine_units WHERE unit_name = 'Tablet')
WHERE unit_id IS NULL;
```

### Step 6: Build and Test

1. In Visual Studio, **Build Solution** (Ctrl+Shift+B)
2. Check for any compilation errors
3. Run the project (F5)
4. Navigate to Pharmacy POS
5. Try to select a medicine
6. Check if "Sell Type" dropdown changes based on medicine unit

## Verification Checklist

- [ ] pharmacy_pos.aspx file fixed (no duplicate content)
- [ ] Database has 4 new columns in medicine_units table
- [ ] medicine_units table has 15 rows (unit types)
- [ ] Existing medicines have valid unit_id values
- [ ] Project builds without errors
- [ ] POS page loads without errors
- [ ] Selecting a medicine shows sell type options
- [ ] Can add items to cart and complete sale

## Common Errors & Solutions

### Error: "Invalid column name 'selling_method'"
**Cause:** Database columns don't exist  
**Fix:** Run Step 3 above

### Error: "Cannot find WebMethod"
**Cause:** Backend .cs file not compiled  
**Fix:** Rebuild solution in Visual Studio

### Error: POS page shows blank dropdown
**Cause:** No medicines in inventory OR no stock available  
**Fix:** Add medicines and inventory stock

### Error: "Sell Type" shows nothing
**Cause:** Medicine doesn't have unit_id set OR unit doesn't have configuration  
**Fix:** Run Step 4 and Step 5 above

## Testing Scenarios

### Test 1: Tablet Medicine
1. Add a medicine with Unit = "Tablet"
2. Set: 10 pieces per strip, 45 SDG per strip
3. Add inventory: 50 strips
4. Go to POS
5. Select the medicine
6. **Expected:** Sell Type shows "Piece", "Strip", "Boxes"

### Test 2: Syrup Medicine
1. Add a medicine with Unit = "Syrup"
2. Set: 120ml per bottle, 55 SDG per bottle
3. Add inventory: 15 bottles
4. Go to POS
5. Select the medicine
6. **Expected:** Sell Type shows "By Volume (ml)", "Bottle"

### Test 3: Injection Medicine
1. Add a medicine with Unit = "Injection"
2. Set: 85 SDG per vial
3. Add inventory: 30 vials
4. Go to POS
5. Select the medicine
6. **Expected:** Sell Type shows "Vial" only (no subdivisions)

## Need Help?

If you still have issues after following these steps:

1. Check browser console (F12) for JavaScript errors
2. Check SQL Server error log
3. Check Visual Studio Output window for compilation errors
4. Take a screenshot of the error message

## Quick Summary

**What was changed:**
- pharmacy_pos.aspx → Now dynamically adapts to unit types
- pharmacy_pos.aspx.cs → Already had unit support (no changes needed)
- Database → Needs new columns in medicine_units table

**What you need to do:**
1. Fix pharmacy_pos.aspx file (remove duplicate)
2. Run database migration script (add columns)
3. Insert 15 unit types (if not exists)
4. Rebuild and test

**Result:**
✅ POS system adapts to each medicine unit type automatically!
