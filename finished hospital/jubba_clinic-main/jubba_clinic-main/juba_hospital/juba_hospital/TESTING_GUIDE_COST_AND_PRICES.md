# Cost and Selling Price System - Testing Guide

## 🎯 Purpose
This guide provides step-by-step testing procedures to verify that all cost and selling price functionality works correctly after the fixes.

---

## ⚙️ PRE-TESTING SETUP

### 1. Backup Database
```sql
-- Create backup before testing
BACKUP DATABASE [juba_clinick] 
TO DISK = 'C:\Backups\juba_clinick_before_cost_testing.bak'
WITH FORMAT, NAME = 'Pre-Cost-Test Backup';
```

### 2. Verify Database Schema
Run the verification script first:
```sql
-- Open and execute: VERIFY_COST_PRICE_DATA.sql
-- Check the health score - should show current state
```

### 3. Compile Application
- Open solution in Visual Studio
- Build → Rebuild Solution
- Verify no compilation errors

---

## 🧪 TEST SUITE 1: MEDICINE MASTER DATA

### Test 1.1: Add New Medicine with All Prices

**Objective:** Verify cost and selling prices save correctly for countable items

**Steps:**
1. Navigate to Medicine Management page
2. Click "Add Medicine" button
3. Fill in medicine details:
   - Medicine Name: `Test Paracetamol 500mg`
   - Generic Name: `Paracetamol`
   - Manufacturer: `Test Pharma`
   - Unit Type: Select `Tablet`
   
4. Enter unit configuration:
   - Tablets per Strip: `10`
   - Strips per Box: `10`

5. Enter **COST PRICES**:
   - Cost per Piece: `1.00`
   - Cost per Strip: `9.00`
   - Cost per Box: `85.00`

6. Enter **SELLING PRICES**:
   - Price per Piece: `1.50`
   - Price per Strip: `14.00`
   - Price per Box: `130.00`

7. **VERIFY:** Profit margins display automatically:
   - ✅ Per Piece: 0.50 SDG (50%) - Should show GREEN badge
   - ✅ Per Strip: 5.00 SDG (55.6%) - Should show GREEN badge
   - ✅ Per Box: 45.00 SDG (52.9%) - Should show GREEN badge

8. **VERIFY:** Profit Summary panel appears below with all margins

9. Click "Save"

10. **VERIFY:** Success message appears

**Database Verification:**
```sql
SELECT 
    medicine_name,
    cost_per_tablet, price_per_tablet,
    cost_per_strip, price_per_strip,
    cost_per_box, price_per_box
FROM medicine 
WHERE medicine_name = 'Test Paracetamol 500mg';
```

**Expected Result:**
- All cost and selling prices should be saved
- Values should match what you entered

**✅ PASS CRITERIA:**
- Profit margins calculate correctly
- Color coding works (green for >30%)
- Data saves to database
- No errors occur

---

### Test 1.2: Edit Existing Medicine Prices

**Objective:** Verify editing cost/selling prices works correctly

**Steps:**
1. In Medicine Management, find `Test Paracetamol 500mg`
2. Click Edit button
3. Modify prices:
   - Change Cost per Piece to: `0.80`
   - Change Price per Piece to: `1.20`

4. **VERIFY:** Profit margin updates to 0.40 SDG (50%)

5. Click "Update"

6. **VERIFY:** Success message appears

**Database Verification:**
```sql
SELECT cost_per_tablet, price_per_tablet
FROM medicine 
WHERE medicine_name = 'Test Paracetamol 500mg';
```

**Expected Result:**
- cost_per_tablet = 0.80
- price_per_tablet = 1.20

**✅ PASS CRITERIA:**
- Edit loads existing prices
- Profit recalculates on change
- Updated prices save correctly

---

### Test 1.3: Low Profit Margin Warning

**Objective:** Verify color coding for low margins

**Steps:**
1. Add new medicine: `Test Low Margin Item`
2. Enter costs and prices with LOW margin:
   - Cost per Strip: `10.00`
   - Price per Strip: `11.00` (only 10% profit)

3. **VERIFY:** Badge shows YELLOW (warning) or RED (danger)

4. Try even lower margin:
   - Cost per Strip: `10.00`
   - Price per Strip: `10.50` (only 5% profit)

5. **VERIFY:** Badge shows RED (danger)

**✅ PASS CRITERIA:**
- Yellow badge for 15-30% margin
- Red badge for <15% margin
- Visual warning helps identify low-margin items

---

## 🧪 TEST SUITE 2: MEDICINE INVENTORY (CRITICAL FIXES)

### Test 2.1: Add Inventory with Purchase Price

**Objective:** Verify NEW purchase_price field works correctly

**Steps:**
1. Navigate to Medicine Inventory page
2. Click "Add Stock" button
3. **VERIFY:** Modal form appears with NEW "Purchase Price (per unit)" field
4. Fill in details:
   - Medicine: Select `Test Paracetamol 500mg`
   - Primary Quantity: `50` (strips)
   - Secondary Quantity: `5` (loose pieces)
   - Unit Size: `10`
   - Reorder Level: `10`
   - Expiry Date: Select future date
   - Batch Number: `BATCH-TEST-001`
   - **Purchase Price: `8.50`** ← NEW FIELD

5. Click "Save"

6. **VERIFY:** Success message appears

7. **VERIFY:** New row appears in inventory table
8. **VERIFY:** Purchase Price column shows `8.50`

**Database Verification:**
```sql
SELECT 
    mi.inventoryid,
    m.medicine_name,
    mi.primary_quantity,
    mi.secondary_quantity,
    mi.purchase_price,
    mi.batch_number
FROM medicine_inventory mi
INNER JOIN medicine m ON mi.medicineid = m.medicineid
WHERE mi.batch_number = 'BATCH-TEST-001';
```

**Expected Result:**
- purchase_price = 8.50
- All other fields saved correctly

**✅ PASS CRITERIA:** (CRITICAL)
- Purchase price field is visible
- Purchase price saves to database
- Purchase price displays in table
- **This is the PRIMARY FIX - must work!**

---

### Test 2.2: Edit Inventory Purchase Price

**Objective:** Verify purchase price can be edited

**Steps:**
1. In Medicine Inventory table, find `BATCH-TEST-001`
2. Click "Edit" button
3. **VERIFY:** Modal loads with Purchase Price = `8.50`
4. Change Purchase Price to: `9.00`
5. Click "Save"
6. **VERIFY:** Table updates to show `9.00`

**Database Verification:**
```sql
SELECT purchase_price
FROM medicine_inventory
WHERE batch_number = 'BATCH-TEST-001';
```

**Expected Result:**
- purchase_price = 9.00

**✅ PASS CRITERIA:**
- Edit loads existing purchase price
- Changed value saves correctly
- Table displays updated value

---

### Test 2.3: Add Inventory Without Purchase Price

**Objective:** Verify system handles empty purchase price

**Steps:**
1. Click "Add Stock"
2. Fill in all fields EXCEPT Purchase Price (leave as 0)
3. Save

4. **VERIFY:** Saves successfully
5. **VERIFY:** Purchase Price shows `0.00` in table

**Expected Result:**
- Should save with purchase_price = 0 or NULL
- No errors occur

**✅ PASS CRITERIA:**
- System handles missing purchase price gracefully
- Doesn't block saving

---

## 🧪 TEST SUITE 3: POS COST CALCULATION

### Test 3.1: Sell Item with Medicine-Level Cost

**Objective:** Verify POS uses medicine.cost_per_[type] for cost calculation

**Steps:**
1. Navigate to Pharmacy POS
2. Search for `Test Paracetamol 500mg`
3. Add to cart:
   - Quantity Type: `pieces`
   - Quantity: `10`

4. **VERIFY:** Unit price shows `1.50` (from price_per_tablet)

5. Complete sale:
   - Customer Name: `Test Customer 1`
   - Payment Method: `Cash`

6. Confirm sale

**Database Verification:**
```sql
-- Get the latest sale
SELECT TOP 1 
    psi.quantity_type,
    psi.quantity,
    psi.unit_price,
    psi.cost_price,
    psi.total_price,
    psi.profit,
    CASE 
        WHEN psi.cost_price > 0 
        THEN ((psi.profit / (psi.cost_price * psi.quantity)) * 100)
        ELSE 0 
    END AS profit_margin_pct
FROM pharmacy_sales_items psi
INNER JOIN pharmacy_sales ps ON psi.sale_id = ps.saleid
ORDER BY psi.sale_item_id DESC;
```

**Expected Result:**
- unit_price = 1.50 (selling price)
- cost_price = 1.00 (from medicine.cost_per_tablet)
- total_price = 15.00 (10 × 1.50)
- profit = 5.00 (15.00 - 10.00)
- profit_margin_pct ≈ 50%

**✅ PASS CRITERIA:**
- Correct selling price selected
- Cost price calculated from medicine table
- Profit tracked accurately

---

### Test 3.2: Sell Item with Inventory Purchase Price Fallback

**Objective:** Verify POS falls back to inventory.purchase_price when medicine cost is 0

**Steps:**
1. Add new medicine with NO cost prices:
   - Medicine Name: `Test Simple Item`
   - Unit Type: `Injection`
   - Leave all cost_per fields = 0
   - Set price_per_strip = `5.00`

2. Add inventory for this medicine:
   - Quantity: `20`
   - **Purchase Price: `3.50`** ← Should be used as fallback

3. In POS, sell this item:
   - Quantity: `1`

4. Complete sale

**Database Verification:**
```sql
SELECT TOP 1 
    m.medicine_name,
    psi.unit_price,
    psi.cost_price,
    psi.profit
FROM pharmacy_sales_items psi
INNER JOIN medicine m ON psi.medicine_id = m.medicineid
WHERE m.medicine_name = 'Test Simple Item'
ORDER BY psi.sale_item_id DESC;
```

**Expected Result:**
- unit_price = 5.00 (selling price)
- cost_price = 3.50 (from inventory.purchase_price) ← FALLBACK WORKED
- profit = 1.50

**✅ PASS CRITERIA:** (CRITICAL)
- System uses purchase_price when medicine cost is 0
- Profit calculation works with fallback
- **This verifies the fix is working!**

---

### Test 3.3: Sell by Different Unit Types

**Objective:** Verify correct cost/price selection by unit type

**Steps:**
1. Sell `Test Paracetamol 500mg` by STRIPS:
   - Quantity Type: `strips`
   - Quantity: `2`
   - Expected Price: 14.00 per strip
   - Expected Cost: 9.00 per strip

2. Sell by BOXES:
   - Quantity Type: `boxes`
   - Quantity: `1`
   - Expected Price: 130.00 per box
   - Expected Cost: 85.00 per box

**Database Verification:**
```sql
SELECT TOP 2
    psi.quantity_type,
    psi.quantity,
    psi.unit_price,
    psi.cost_price,
    psi.profit
FROM pharmacy_sales_items psi
INNER JOIN medicine m ON psi.medicine_id = m.medicineid
WHERE m.medicine_name = 'Test Paracetamol 500mg'
ORDER BY psi.sale_item_id DESC;
```

**Expected Results:**

**Strip Sale:**
- unit_price = 14.00
- cost_price = 9.00
- profit = 10.00 (2 strips × 5.00 profit each)

**Box Sale:**
- unit_price = 130.00
- cost_price = 85.00
- profit = 45.00

**✅ PASS CRITERIA:**
- Correct price selected based on quantity_type
- Correct cost selected based on quantity_type
- Profit calculated accurately for each type

---

## 🧪 TEST SUITE 4: SALES REPORTS & PROFIT TRACKING

### Test 4.1: Verify Sale Totals

**Objective:** Verify total_cost and total_profit aggregate correctly

**Steps:**
1. Make a multi-item sale:
   - Item 1: Test Paracetamol (10 pieces) = 15.00 revenue, 10.00 cost
   - Item 2: Test Simple Item (2 units) = 10.00 revenue, 7.00 cost
   - Total Expected Revenue: 25.00
   - Total Expected Cost: 17.00
   - Total Expected Profit: 8.00

**Database Verification:**
```sql
SELECT TOP 1
    ps.invoice_number,
    ps.total_amount,
    ps.total_cost,
    ps.total_profit,
    CASE 
        WHEN ps.total_cost > 0 
        THEN ((ps.total_profit / ps.total_cost) * 100)
        ELSE 0 
    END AS profit_margin_pct
FROM pharmacy_sales ps
ORDER BY ps.saleid DESC;
```

**Expected Result:**
- total_amount = 25.00
- total_cost = 17.00
- total_profit = 8.00
- profit_margin_pct ≈ 47%

**✅ PASS CRITERIA:**
- Sale totals aggregate correctly
- Profit tracked at sale level
- Profit margin calculates correctly

---

## 🧪 TEST SUITE 5: DATABASE VERIFICATION

### Test 5.1: Run Verification Script

**Objective:** Use automated script to verify entire system

**Steps:**
1. Open SQL Server Management Studio
2. Connect to `juba_clinick` database
3. Open file: `VERIFY_COST_PRICE_DATA.sql`
4. Execute script (F5)

5. **REVIEW OUTPUT:**
   - Check Schema Verification section
   - Check Medicine Cost/Price coverage
   - Check Inventory Purchase Price coverage
   - Check Sales Cost Tracking
   - **Check Health Score** (should be high after testing)

**Expected Health Score:**
- After adding test data: 70-100%
- Recommendations should list any gaps

**✅ PASS CRITERIA:**
- Script runs without errors
- All columns exist in schema
- Test data appears in results
- Health score reflects improvements

---

## 📋 SUMMARY CHECKLIST

### Critical Functionality (Must All Pass)

- [ ] **Medicine Master:** Cost and selling prices save correctly
- [ ] **Medicine Master:** Profit margins calculate in real-time
- [ ] **Medicine Master:** Color coding works (green/yellow/red)
- [ ] **Inventory:** Purchase price field is visible and functional
- [ ] **Inventory:** Purchase price saves to database
- [ ] **Inventory:** Purchase price loads in edit mode
- [ ] **Inventory:** Purchase price displays in table
- [ ] **POS:** Selects correct selling price by quantity_type
- [ ] **POS:** Calculates cost from medicine.cost_per_[type]
- [ ] **POS:** Falls back to inventory.purchase_price when needed
- [ ] **POS:** Saves cost_price per item
- [ ] **POS:** Calculates profit per item
- [ ] **POS:** Aggregates total_cost and total_profit per sale
- [ ] **Database:** Verification script runs successfully
- [ ] **Database:** All test data verifiable in database

### Enhancement Features (Nice to Have)

- [ ] Profit summary panel displays
- [ ] Badge colors indicate margin levels
- [ ] Emoji indicators show (💰)
- [ ] Purchase price formats as currency (0.00)

---

## 🐛 TROUBLESHOOTING

### Issue: Purchase Price Not Saving

**Symptoms:**
- Field is visible but data doesn't save
- Edit shows 0.00 instead of saved value

**Check:**
1. Open browser developer console (F12)
2. Look for JavaScript errors
3. Check Network tab for AJAX errors

**Verify Backend:**
```sql
-- Check if column exists
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'medicine_inventory' 
  AND COLUMN_NAME = 'purchase_price';

-- Check parameter binding in code
-- Review: medicine_inventory.aspx.cs line 175 and 197
```

---

### Issue: Profit Not Calculating

**Symptoms:**
- cost_price = 0 in sales_items
- profit = 0 or incorrect

**Check:**
1. Verify medicine has cost prices:
```sql
SELECT cost_per_tablet, cost_per_strip, cost_per_box
FROM medicine 
WHERE medicineid = [your_medicine_id];
```

2. Verify inventory has purchase_price:
```sql
SELECT purchase_price 
FROM medicine_inventory 
WHERE inventoryid = [your_inventory_id];
```

3. Check POS backend logic (pharmacy_pos.aspx.cs lines 240-273)

---

### Issue: Color Coding Not Working

**Symptoms:**
- All badges show same color
- Colors don't update when values change

**Check:**
1. Browser console for JavaScript errors
2. Verify calculateProfitMargins() function exists
3. Check if Bootstrap CSS is loaded
4. Verify badge classes: bg-success, bg-warning, bg-danger

---

## 📞 SUPPORT

If tests fail:

1. **Check Documentation:**
   - COST_AND_SELLING_PRICE_ANALYSIS.md
   - FIXES_IMPLEMENTED_SUMMARY.md

2. **Review Code Changes:**
   - medicine_inventory.aspx.cs (lines 175, 197, 225, 50, 68, 92, 112)
   - medicine_inventory.aspx (lines added for purchase_price)
   - add_medicine.aspx (profit calculation enhancements)

3. **Database Check:**
   - Run VERIFY_COST_PRICE_DATA.sql
   - Review health score and recommendations

4. **Rollback Option:**
   - Restore from backup if needed
   - Re-apply fixes one by one
   - Test after each fix

---

## ✅ TEST COMPLETION SIGN-OFF

**Tester Name:** ________________  
**Date:** ________________  
**Test Environment:** ________________

**Results:**
- [ ] All critical tests passed
- [ ] Enhancement features working
- [ ] Database verification successful
- [ ] Health score: ____%
- [ ] Ready for production: YES / NO

**Notes:**
_____________________________________________
_____________________________________________
_____________________________________________

---

**Document Version:** 1.0  
**Last Updated:** [Current Date]  
**System:** Juba Hospital Management System v2.0
