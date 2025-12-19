# Troubleshooting: Zero Cost in Sales Reports

## 🔍 **Issue**

Sale appears in report but shows:
- `total_cost: 0`
- `profit: 0`

## 📊 **Your Console Output Analysis**

```javascript
sale_id: "14"
total_amount: "2"      // Sale was $2
total_cost: "0"        // ❌ Cost is 0
profit: "0"            // ❌ Profit is 0
```

---

## 🎯 **Root Causes**

### **Cause 1: Sale Made Before Fix Applied** (Most Likely)

**Timeline:**
1. ❌ You made sale #14 BEFORE we fixed the cost calculation
2. ✅ We then fixed the POS code to calculate costs correctly
3. 📊 Now viewing old sale #14 - it still has zero cost

**Solution:** Make a NEW sale now (after the fix) to test!

---

### **Cause 2: Medicine Has No Cost Prices**

The medicine might not have cost prices entered in the master data.

**Check Database:**
```sql
-- Check if medicine has cost prices
SELECT 
    m.medicineid,
    m.medicine_name,
    m.cost_per_tablet,
    m.cost_per_strip,
    m.cost_per_box,
    m.price_per_tablet,
    m.price_per_strip,
    m.price_per_box
FROM medicine m
INNER JOIN pharmacy_sales_items si ON m.medicineid = si.medicine_id OR m.medicineid = si.medicineid
WHERE si.saleid = 14
```

**Expected Result:**
```
medicineid | medicine_name | cost_per_tablet | cost_per_strip | cost_per_box
-----------|---------------|-----------------|----------------|-------------
5          | Paracetamol   | 0.30           | 3.00           | 30.00
```

**If All Are 0 or NULL:**
You need to add cost prices to the medicine!

---

### **Cause 3: Wrong Column Names in Database**

Check which column names exist in your medicine table:

```sql
-- Check column names
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'medicine' 
AND COLUMN_NAME LIKE '%cost%'
```

**Should Return:**
- `cost_per_tablet`
- `cost_per_strip`
- `cost_per_box`

**If Missing:** You need to add these columns!

---

## ✅ **SOLUTION STEPS**

### **Step 1: Verify Medicine Has Cost Prices**

1. Go to `add_medicine.aspx`
2. Find the medicine you sold
3. Click Edit
4. Check if these fields have values:
   - Cost per Tablet/Piece: **Should NOT be 0**
   - Cost per Strip/Bottle: **Should NOT be 0**
   - Cost per Box: **Should NOT be 0**

**If They're All 0:**
```
Cost per Tablet: 0.30
Cost per Strip: 3.00
Cost per Box: 30.00
```
Save and try again!

---

### **Step 2: Make a NEW Sale (Test the Fix)**

1. ✅ Go to `pharmacy_pos.aspx`
2. ✅ Select a medicine that has cost prices
3. ✅ Add to cart
4. ✅ Process sale
5. ✅ Go to sales reports
6. ✅ Check the NEW sale - should show correct cost and profit!

**Expected NEW Sale:**
```
sale_id: 15 (new)
total_amount: "25.00"
total_cost: "15.00"    // ✅ Should NOT be 0!
profit: "10.00"        // ✅ Should show profit!
```

---

### **Step 3: Verify Database**

**Check the NEW sale in database:**
```sql
-- Check new sale
SELECT 
    ps.saleid,
    ps.invoice_number,
    ps.total_amount,
    ps.total_cost,
    ps.total_profit,
    si.medicine_id,
    si.quantity_type,
    si.quantity,
    si.unit_price,
    si.total_price,
    si.cost_price,    -- Should NOT be 0
    si.profit         -- Should NOT be 0
FROM pharmacy_sales ps
INNER JOIN pharmacy_sales_items si ON ps.saleid = si.saleid
WHERE ps.saleid = (SELECT MAX(saleid) FROM pharmacy_sales)
```

**Expected Result:**
```
saleid: 15
total_amount: 25.00
total_cost: 15.00        // ✅ NOT zero!
total_profit: 10.00      // ✅ NOT zero!
cost_price: 3.00         // ✅ From medicine.cost_per_strip
profit: 10.00            // ✅ Calculated correctly
```

---

## 🔧 **If NEW Sale Still Shows Zero Cost**

### **Debug Checklist:**

1. **Check Medicine Table:**
```sql
SELECT medicineid, medicine_name, cost_per_tablet, cost_per_strip, cost_per_box
FROM medicine
WHERE medicineid = [YOUR_MEDICINE_ID]
```
   - [ ] cost_per_tablet has a value > 0
   - [ ] cost_per_strip has a value > 0
   - [ ] cost_per_box has a value > 0

2. **Check Sale Items Table:**
```sql
SELECT * FROM pharmacy_sales_items WHERE saleid = [NEW_SALE_ID]
```
   - [ ] cost_price column has a value > 0
   - [ ] profit column has a value (can be positive or negative)

3. **Check Code Execution:**
   - [ ] Build the solution
   - [ ] Refresh the browser (clear cache: Ctrl+F5)
   - [ ] Make a completely new sale
   - [ ] Check console for any JavaScript errors

4. **Check Database Column Names:**
```sql
-- Verify column names match code
SELECT TOP 1 
    cost_per_tablet,  -- Must exist
    cost_per_strip,   -- Must exist
    cost_per_box      -- Must exist
FROM medicine
```

---

## 🎯 **Most Common Issues**

### **Issue 1: Medicine Never Had Cost Prices Added**

**Solution:**
1. Go to `add_medicine.aspx`
2. Edit each medicine
3. Add cost prices:
   ```
   Cost per Tablet: 0.30
   Cost per Strip: 3.00
   Cost per Box: 30.00
   ```
4. Save
5. Make new sale

---

### **Issue 2: Browser Cache**

**Solution:**
1. Press Ctrl+F5 (hard refresh)
2. Or clear browser cache
3. Reload the POS page
4. Make new sale

---

### **Issue 3: Code Not Compiled**

**Solution:**
1. In Visual Studio: Build → Rebuild Solution
2. Wait for build to complete
3. Refresh browser
4. Make new sale

---

## 📊 **Understanding the Console Output**

```javascript
total_amount: "2"      // $2 sold
total_cost: "0"        // Cost was $0 (WRONG!)
profit: "0"            // $2 - $0 = $2 profit, but showing 0
```

This means:
- ✅ Sale was recorded
- ✅ Amount is correct
- ❌ Cost calculation didn't work
- ❌ Either medicine has no cost prices OR sale was made before fix

---

## ✅ **FINAL TEST**

### **Complete Test Procedure:**

1. **Prepare Medicine:**
   ```
   Go to: add_medicine.aspx
   Medicine: Paracetamol 500mg
   Edit and set:
   - Cost per Tablet: 0.30
   - Cost per Strip: 3.00
   - Cost per Box: 30.00
   - Price per Tablet: 0.50
   - Price per Strip: 5.00
   - Price per Box: 50.00
   Save
   ```

2. **Make Sale:**
   ```
   Go to: pharmacy_pos.aspx
   Search: Paracetamol
   Select: Strip
   Quantity: 5
   Add to Cart
   Total should be: 5 × $5.00 = $25.00
   Process Sale
   ```

3. **Check Report:**
   ```
   Go to: pharmacy_sales_reports.aspx
   Set date to today
   Find the sale you just made
   
   Should show:
   - Total Amount: $25.00
   - Cost: $15.00 (5 strips × $3.00)
   - Profit: $10.00 ($25.00 - $15.00)
   ```

4. **Click View Items:**
   ```
   Click "View" button
   Should show:
   - Medicine: Paracetamol 500mg
   - Unit Type: Tablet (Tab)
   - Quantity Sold: 5 Strips
   - Unit Price: $5.00
   - Total: $25.00
   - Cost: $15.00
   - Profit: $10.00 ✅
   ```

---

## 💡 **Key Takeaway**

**Old Sale (ID 14):** 
- Made BEFORE fix
- Will always show zero cost
- Can't be recalculated (data already saved)

**New Sales (After Fix):**
- Should show correct cost
- Should show correct profit
- Must have cost prices in medicine master data

**Make a NEW sale to test the fix!** 🚀

---

**Status:** Awaiting new sale test  
**Action Required:** Make a new sale with medicine that has cost prices  
**Expected Result:** Cost and profit should calculate correctly