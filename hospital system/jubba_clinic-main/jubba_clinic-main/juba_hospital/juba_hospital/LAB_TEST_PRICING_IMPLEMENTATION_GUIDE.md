# Lab Test Pricing System - Implementation Guide

## Overview
This document provides step-by-step instructions to implement the new per-test lab pricing system.

## What's New
- ✅ Each lab test has its own individual price
- ✅ Patients pay ONE total amount (sum of all ordered tests)
- ✅ Invoice displays itemized list with individual test prices
- ✅ Admin page to manage/update test prices
- ✅ 90+ tests with default prices pre-configured

---

## Files Created/Modified

### NEW FILES CREATED:
1. **CREATE_LAB_TEST_PRICES_TABLE.sql** - Database table and default prices
2. **manage_lab_test_prices.aspx** - Admin interface (frontend)
3. **manage_lab_test_prices.aspx.cs** - Admin interface (backend)
4. **manage_lab_test_prices.aspx.designer.cs** - Designer file
5. **LabTestPriceCalculator.cs** - Helper class for price calculations

### MODIFIED FILES:
1. **add_lab_charges.aspx.cs** - Updated payment processing
2. **doctor_inpatient.aspx.cs** - Updated to create individual charges per test

---

## Step-by-Step Deployment

### Step 1: Database Setup
Run the SQL script to create the pricing table with default prices:

```sql
-- Execute this file in SQL Server Management Studio
-- File: CREATE_LAB_TEST_PRICES_TABLE.sql
```

**What this does:**
- Creates `lab_test_prices` table
- Inserts default prices for 90+ lab tests
- Organizes tests by category (Hematology, Biochemistry, Immunology, etc.)

**Verify:**
```sql
-- Check that table was created with data
SELECT COUNT(*) FROM lab_test_prices;
-- Should return 90+ rows

-- View sample data
SELECT TOP 10 * FROM lab_test_prices ORDER BY test_category, test_display_name;
```

---

### Step 2: Add Files to Visual Studio Project

**Option A: Using Visual Studio**
1. Open `juba_hospital.sln` in Visual Studio
2. Right-click on the project in Solution Explorer
3. Add → Existing Item
4. Add these files:
   - `manage_lab_test_prices.aspx`
   - `manage_lab_test_prices.aspx.cs`
   - `manage_lab_test_prices.aspx.designer.cs`
   - `LabTestPriceCalculator.cs`

**Option B: Manual (if VS not available)**
1. Copy the 5 new files to `juba_hospital/` folder
2. Edit `juba_hospital.csproj` and add:
```xml
<Compile Include="manage_lab_test_prices.aspx.cs">
  <DependentUpon>manage_lab_test_prices.aspx</DependentUpon>
  <SubType>ASPXCodeBehind</SubType>
</Compile>
<Compile Include="LabTestPriceCalculator.cs" />
<Content Include="manage_lab_test_prices.aspx" />
```

---

### Step 3: Build and Deploy

1. **Build the project:**
   ```
   - In Visual Studio: Build → Build Solution (Ctrl+Shift+B)
   - Or use MSBuild from command line
   ```

2. **Deploy to server:**
   - Copy all files from `bin/` folder to server
   - Copy all `.aspx` files to server
   - Ensure web.config is updated

3. **Verify deployment:**
   - Browse to: `http://yourserver/juba_hospital/manage_lab_test_prices.aspx`
   - Should see the price management interface

---

## Step 4: Configure Admin Menu

Add link to Admin Master page for easy access:

**File: `Admin.Master`**

Find the menu section and add:
```html
<li>
    <a href="manage_lab_test_prices.aspx">
        <i class="fa fa-money"></i>
        <span>Lab Test Prices</span>
    </a>
</li>
```

---

## How It Works

### OLD SYSTEM (Before):
```
Doctor orders: Hemoglobin, Malaria, CBC
↓
System creates: 1 charge = $5 (flat rate)
↓
Patient pays: $5 total
```

### NEW SYSTEM (After):
```
Doctor orders: Hemoglobin, Malaria, CBC
↓
System creates:
  - Hemoglobin charge = $5.00
  - Malaria charge = $5.00
  - CBC charge = $15.00
↓
Patient pays: $25.00 total (sum of all tests)
↓
Invoice shows itemized breakdown
```

---

## Usage Guide

### For Administrators:

**1. Access Price Management**
- Login as Admin
- Go to: Menu → Lab Test Prices (or navigate to `manage_lab_test_prices.aspx`)

**2. Update Test Prices**
- Browse tests by category
- Click on any price field to edit
- Enter new price
- Click "Save" button next to the field
- System updates immediately

**3. Search for Tests**
- Use search box at top
- Type test name (e.g., "Hemoglobin", "CBC", "HIV")
- Results filter in real-time

---

### For Doctors:

**No Change Required!**
- Order lab tests as usual
- System automatically calculates total based on selected tests
- Each test is charged individually behind the scenes

---

### For Registration/Cashier:

**Enhanced Payment Process:**

1. Patient comes to pay for lab tests
2. Click on pending lab charge
3. **NEW:** System shows itemized breakdown:
   ```
   Lab Tests for Patient: John Doe
   --------------------------------
   ✓ Hemoglobin (Hb).............$5.00
   ✓ Malaria Test................$5.00
   ✓ Complete Blood Count.......$15.00
   --------------------------------
   Total Amount:................$25.00
   ```
4. Collect payment
5. Select payment method (Cash/Card/etc.)
6. Process payment
7. **NEW:** Receipt shows all individual tests

---

## Default Test Prices

### Hematology ($5-$15):
- Hemoglobin: $5
- Malaria: $5
- CBC: $15
- Blood Grouping: $10
- ESR: $5

### Biochemistry ($6-$30):
- Lipid Profile (Complete): $25
- Liver Function Test: $30
- Renal Profile: $25
- Electrolytes Panel: $20

### Immunology ($10-$20):
- HIV Test: $15
- Hepatitis B: $15
- Hepatitis C: $15
- Dengue Fever: $20

### Hormones ($12-$60):
- Thyroid Profile: $30
- Fertility Profile: $60
- TSH: $15
- T3/T4: $12 each

### Specialized ($15-$25):
- Troponin I: $25
- PSA: $25
- AFP: $25
- Vitamin D: $20

**Full list:** See `lab_test_prices` table in database

---

## Customization

### To Add New Tests:
```sql
INSERT INTO lab_test_prices 
(test_name, test_display_name, test_category, test_price, is_active)
VALUES 
('New_Test_Name', 'Display Name for Test', 'Category', 10.00, 1);
```

### To Disable Tests:
```sql
UPDATE lab_test_prices 
SET is_active = 0 
WHERE test_name = 'Test_Name';
```

### To Update Prices in Bulk:
```sql
-- Increase all Hematology tests by 10%
UPDATE lab_test_prices 
SET test_price = test_price * 1.10 
WHERE test_category = 'Hematology';
```

---

## Testing Checklist

### ✅ After Deployment, Test:

1. **Admin Interface:**
   - [ ] Can access `manage_lab_test_prices.aspx`
   - [ ] Can view all test prices
   - [ ] Can edit individual prices
   - [ ] Can search for tests
   - [ ] Statistics display correctly

2. **Doctor Ordering:**
   - [ ] Order multiple lab tests for a patient
   - [ ] Verify charges are created for each test
   - [ ] Check database: `SELECT * FROM patient_charges WHERE charge_type = 'Lab'`

3. **Payment Processing:**
   - [ ] View itemized breakdown in payment page
   - [ ] Process payment for multiple tests
   - [ ] Verify all charges marked as paid
   - [ ] Check invoice shows all tests

4. **Lab Workflow:**
   - [ ] Lab can see orders after payment
   - [ ] Lab can enter results
   - [ ] Results display correctly

---

## Troubleshooting

### Issue: "Table 'lab_test_prices' does not exist"
**Solution:** Run `CREATE_LAB_TEST_PRICES_TABLE.sql` script

### Issue: "Method 'GetTestPrice' not found"
**Solution:** Ensure `LabTestPriceCalculator.cs` is added to project and compiled

### Issue: All tests showing $5.00 price
**Solution:** Check if `lab_test_prices` table has data:
```sql
SELECT COUNT(*) FROM lab_test_prices;
```
If empty, re-run the SQL script.

### Issue: Compilation error in doctor_inpatient.aspx.cs
**Solution:** Ensure you have the latest modified version of the file

---

## Benefits of New System

### ✅ For Hospital:
- Accurate revenue tracking per test type
- Flexible pricing - adjust any test independently
- Better financial reporting
- Can offer discounts on specific tests

### ✅ For Patients:
- Transparent itemized billing
- Know exactly what they're paying for
- Receipt shows all tests performed

### ✅ For Staff:
- Easy price management via admin interface
- No manual calculations needed
- Automatic total calculation

---

## Database Schema

```sql
CREATE TABLE lab_test_prices (
    test_price_id INT IDENTITY(1,1) PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,           -- Column name in lab_test table
    test_display_name VARCHAR(150) NOT NULL,   -- Friendly name for display
    test_category VARCHAR(50),                 -- Category (Hematology, etc.)
    test_price DECIMAL(10,2) NOT NULL,         -- Price for this test
    is_active BIT DEFAULT 1,                   -- Active/Inactive
    date_added DATETIME DEFAULT GETDATE(),
    last_updated DATETIME DEFAULT GETDATE()
);
```

---

## Support & Questions

If you encounter any issues:
1. Check this guide's Troubleshooting section
2. Verify all files are deployed correctly
3. Check database for `lab_test_prices` table
4. Ensure project is built successfully

---

## Next Steps (Future Enhancements)

Possible future improvements:
- [ ] Bulk price import/export via Excel
- [ ] Price history tracking
- [ ] Discounts and package deals
- [ ] Insurance integration
- [ ] Test bundling (order multiple tests as package)

---

## Summary

✅ **Database:** 1 new table with 90+ test prices
✅ **Backend:** 2 modified files, 1 new helper class
✅ **Frontend:** 1 new admin page for price management
✅ **Impact:** Accurate per-test billing with itemized invoices
✅ **Effort:** ~30 minutes to deploy and test

---

**Deployment Date:** _______________
**Deployed By:** _______________
**Version:** 1.0
