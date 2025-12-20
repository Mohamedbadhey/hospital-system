# Lab Test Pricing System - Deployment Checklist

## 📋 Pre-Deployment

### Database Preparation
- [ ] Backup current database
- [ ] Verify SQL Server connection
- [ ] Confirm you have admin rights on database

### File Preparation
- [ ] All new files downloaded/copied to project folder
- [ ] Visual Studio project accessible
- [ ] Server deployment access confirmed

---

## 🗄️ Step 1: Database Setup (5 minutes)

### Run SQL Scripts:
- [ ] Open SQL Server Management Studio
- [ ] Connect to `juba_clinick` database
- [ ] Open `CREATE_LAB_TEST_PRICES_TABLE.sql`
- [ ] Execute script (F5)
- [ ] Verify success message in output

### Verification:
- [ ] Run query: `SELECT COUNT(*) FROM lab_test_prices`
- [ ] Expected result: 90+ rows
- [ ] Run `VERIFY_LAB_PRICING_SYSTEM.sql`
- [ ] Review verification report - should show all green checkmarks

---

## 💻 Step 2: Visual Studio Integration (10 minutes)

### Add Files to Project:
- [ ] Open `juba_hospital.sln` in Visual Studio
- [ ] Right-click project in Solution Explorer
- [ ] Add → Existing Item
- [ ] Select and add these files:
  - [ ] `LabTestPriceCalculator.cs`
  - [ ] `manage_lab_test_prices.aspx`
  - [ ] `manage_lab_test_prices.aspx.cs`
  - [ ] `manage_lab_test_prices.aspx.designer.cs`

### Build Solution:
- [ ] Click Build → Build Solution (Ctrl+Shift+B)
- [ ] Verify: 0 errors (warnings are OK)
- [ ] Check Output window for success message
- [ ] Verify bin folder has updated DLL files

---

## 🚀 Step 3: Server Deployment (10 minutes)

### Deploy Files:
- [ ] Copy `bin` folder to server (overwrite existing)
- [ ] Copy these ASPX files to server root:
  - [ ] `manage_lab_test_prices.aspx`
- [ ] Ensure file permissions are correct (IIS user has read access)
- [ ] Restart IIS/Application Pool (optional but recommended)

### Test Deployment:
- [ ] Browse to: `http://yourserver/juba_hospital/`
- [ ] Verify application loads without errors
- [ ] Check browser console for JavaScript errors (F12)

---

## ✅ Step 4: Functionality Testing (15 minutes)

### Test 1: Admin Interface
- [ ] Login as Admin user
- [ ] Navigate to: `manage_lab_test_prices.aspx`
- [ ] Page loads successfully
- [ ] Statistics display correctly
- [ ] Can see list of tests organized by category
- [ ] Search box works (type "hemoglobin")
- [ ] Edit a test price (change and save)
- [ ] Verify price saved (refresh page, check if price persists)

### Test 2: Doctor Workflow
- [ ] Login as Doctor
- [ ] Open an inpatient record
- [ ] Click "Order Lab Tests"
- [ ] Select 2-3 tests (e.g., Hemoglobin, Malaria, CBC)
- [ ] Submit order
- [ ] Check database:
  ```sql
  SELECT * FROM patient_charges 
  WHERE charge_type = 'Lab' 
  ORDER BY charge_id DESC
  ```
- [ ] Verify: One charge entry per test (not flat fee)
- [ ] Verify: Each charge has correct price
- [ ] Verify: reference_id links to lab_test.med_id

### Test 3: Payment Processing
- [ ] Login as Registration/Cashier
- [ ] Navigate to pending lab charges
- [ ] Click on patient with recent lab order
- [ ] Verify: See itemized breakdown of tests
- [ ] Verify: Each test shows individual price
- [ ] Verify: Total amount = sum of all tests
- [ ] Process payment (select payment method)
- [ ] Verify: All charges marked as paid
- [ ] Verify: Invoice shows itemized list

---

## 🎉 Completion Sign-Off

**Deployment completed successfully:**

- [ ] All database scripts executed
- [ ] All files deployed
- [ ] All tests passed
- [ ] Users can use the system

**Signed:**
- Deployed by: _______________ Date: _______________

---

## 📚 Reference Documents

- Technical Guide: `LAB_TEST_PRICING_IMPLEMENTATION_GUIDE.md`
- Summary: `LAB_PRICING_SYSTEM_SUMMARY.md`
- Verification Script: `VERIFY_LAB_PRICING_SYSTEM.sql`
- Database Script: `CREATE_LAB_TEST_PRICES_TABLE.sql`
