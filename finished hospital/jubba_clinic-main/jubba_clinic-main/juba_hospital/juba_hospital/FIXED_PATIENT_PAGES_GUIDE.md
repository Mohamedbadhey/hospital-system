# ✅ Fixed Patient Pages - Testing & Troubleshooting Guide

## 🔧 What Was Fixed

I've updated the queries to handle cases where `patient_type` might be NULL or not properly set in the database.

### Changes Made:

#### 1. **Inpatients Page** (`registre_inpatients.aspx.cs`)
**Old Query:**
```sql
WHERE p.patient_type = 'inpatient' AND p.patient_status = 0
```

**New Query:**
```sql
WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
      AND p.patient_status = 0
```

**Logic:** Now shows patients who either:
- Have `patient_type = 'inpatient'`, OR
- Have a `bed_admission_date` set (indicates they were admitted)

---

#### 2. **Outpatients Page** (`registre_outpatients.aspx.cs`)
**Old Query:**
```sql
WHERE p.patient_type = 'outpatient' AND p.patient_status = 0
```

**New Query:**
```sql
WHERE (p.patient_type = 'outpatient' OR (p.patient_type IS NULL AND p.bed_admission_date IS NULL))
      AND p.patient_status = 0
```

**Logic:** Now shows patients who either:
- Have `patient_type = 'outpatient'`, OR
- Have `patient_type` is NULL AND no bed admission date (defaults to outpatient)

---

#### 3. **Discharged Page** (`registre_discharged.aspx.cs`)
**Old Query:**
```sql
p.patient_type,
CASE WHEN p.patient_type = 'inpatient' THEN ...
```

**New Query:**
```sql
ISNULL(p.patient_type, 
    CASE WHEN p.bed_admission_date IS NOT NULL THEN 'inpatient' ELSE 'outpatient' END
) as patient_type,
CASE WHEN p.bed_admission_date IS NOT NULL THEN ...
```

**Logic:** Automatically determines patient type based on bed admission if not set

---

## 🧪 How to Test

### Step 1: Run the Diagnostic SQL
1. Open **SQL Server Management Studio**
2. Connect to your database `juba_clinick1`
3. Open the file: `DIAGNOSE_PATIENT_DATA.sql`
4. Execute all queries
5. Check the results to see:
   - How many patients you have
   - What their `patient_type` values are
   - Which have `bed_admission_date` set

### Step 2: Test the Pages

#### A. Test Inpatients Page
1. Login as registration user
2. Go to **Patient** → **Inpatients List**
3. **Expected Results:**
   - Should show patients with `bed_admission_date` set
   - Should show `patient_status = 0` (active)
   - Should display days admitted

**If No Data Shows:**
Run this SQL to check:
```sql
SELECT patientid, full_name, bed_admission_date, patient_type, patient_status
FROM patient
WHERE (patient_type = 'inpatient' OR bed_admission_date IS NOT NULL) 
      AND patient_status = 0
```

#### B. Test Outpatients Page
1. Go to **Patient** → **Outpatients List**
2. **Expected Results:**
   - Should show patients WITHOUT `bed_admission_date`
   - Should show `patient_status = 0` (active)
   - Should display registration date

**If No Data Shows:**
Run this SQL to check:
```sql
SELECT patientid, full_name, date_registered, patient_type, bed_admission_date, patient_status
FROM patient
WHERE (patient_type = 'outpatient' OR (patient_type IS NULL AND bed_admission_date IS NULL))
      AND patient_status = 0
```

#### C. Test Discharged Page
1. Go to **Patient** → **Discharged Patients**
2. **Expected Results:**
   - Should show all patients with `patient_status = 1`
   - Should display both inpatient and outpatient types

**If No Data Shows:**
Run this SQL to check:
```sql
SELECT patientid, full_name, patient_type, patient_status
FROM patient
WHERE patient_status = 1
```

---

## 📊 Understanding Your Data

### Check Patient Type Distribution
```sql
-- See how many of each type you have
SELECT 
    CASE 
        WHEN patient_type = 'inpatient' THEN 'Inpatient (type set)'
        WHEN patient_type = 'outpatient' THEN 'Outpatient (type set)'
        WHEN bed_admission_date IS NOT NULL THEN 'Inpatient (by bed date)'
        WHEN patient_type IS NULL THEN 'Unknown (assumed outpatient)'
        ELSE 'Other'
    END as category,
    patient_status,
    COUNT(*) as count
FROM patient
GROUP BY 
    CASE 
        WHEN patient_type = 'inpatient' THEN 'Inpatient (type set)'
        WHEN patient_type = 'outpatient' THEN 'Outpatient (type set)'
        WHEN bed_admission_date IS NOT NULL THEN 'Inpatient (by bed date)'
        WHEN patient_type IS NULL THEN 'Unknown (assumed outpatient)'
        ELSE 'Other'
    END,
    patient_status
ORDER BY patient_status, category
```

---

## 🖨️ Testing Print Functionality

### 1. Print Patient Summary
**Button:** "Print Summary"
**Opens:** `visit_summary_print.aspx?id=PATIENTID`

**Test:**
1. Click "Print Summary" on any patient
2. New window/tab should open
3. Should show patient details, medications, lab tests
4. Use browser print (Ctrl+P) to print

**If Doesn't Work:**
- Check browser pop-up blocker
- Check that `visit_summary_print.aspx.cs` loads patient data by ID
- Verify patient ID is being passed correctly

### 2. Print Invoice
**Button:** "Print Invoice"
**Opens:** `patient_invoice_print.aspx?id=PATIENTID`

**Test:**
1. Click "Print Invoice" on any patient
2. New window/tab should open
3. Should show itemized charges with amounts
4. Should show total, paid, and unpaid amounts

**If Doesn't Work:**
- Verify patient has charges in `patient_charges` table
- Check SQL query in `patient_invoice_print.aspx.cs`

### 3. Print Discharge Summary
**Button:** "Print Discharge Summary" (Inpatients only)
**Opens:** `discharge_summary_print.aspx?id=PATIENTID`

**Test:**
1. Click "Print Discharge Summary" on inpatient
2. Should show admission/discharge details
3. Should show complete care summary

### 4. Print Lab Results
**Button:** "Print" in Lab Tests section
**Opens:** `lab_result_print.aspx?id=PRESCID`

**Test:**
1. Expand patient details
2. Find lab test with status "Completed"
3. Click "Print" button
4. Should show lab test results

### 5. Print All
**Button:** "Print All" at top of page
**Uses:** Browser's print function

**Test:**
1. Apply filters if desired
2. Click "Print All"
3. All visible patient cards should be formatted for printing

---

## 🔍 Troubleshooting Common Issues

### Issue 1: "No patients found" message

**Possible Causes:**
1. Database has no patients with the correct criteria
2. `patient_status` is not set correctly
3. Connection string issue

**Solutions:**
```sql
-- Check if ANY patients exist
SELECT COUNT(*) as total_patients FROM patient;

-- Check patient statuses
SELECT patient_status, COUNT(*) as count FROM patient GROUP BY patient_status;

-- Set correct status for testing
UPDATE patient SET patient_status = 0 WHERE patientid IN (1, 2, 3); -- Active
UPDATE patient SET patient_status = 1 WHERE patientid IN (4, 5); -- Discharged
```

---

### Issue 2: No charges showing in expanded details

**Possible Causes:**
1. Patient has no charges recorded
2. WebMethod not being called
3. JavaScript error

**Solutions:**
```sql
-- Check if patient has charges
SELECT * FROM patient_charges WHERE patientid = YOUR_PATIENT_ID;

-- Add test charges
INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added)
VALUES (YOUR_PATIENT_ID, 'Registration', 'Patient Registration Fee', 50, 1, GETDATE());
```

**Check browser console:**
1. Press F12 in browser
2. Go to Console tab
3. Click "View Details" on a patient
4. Look for JavaScript errors

---

### Issue 3: No medications/lab tests showing

**Possible Causes:**
1. Patient has no prescriptions
2. No medications/lab tests ordered

**Solutions:**
```sql
-- Check if patient has prescriptions
SELECT * FROM prescribtion WHERE patientid = YOUR_PATIENT_ID;

-- Check medications
SELECT m.* 
FROM medication m
INNER JOIN prescribtion pr ON m.prescid = pr.prescid
WHERE pr.patientid = YOUR_PATIENT_ID;

-- Check lab tests
SELECT * FROM prescribtion 
WHERE patientid = YOUR_PATIENT_ID AND status > 0;
```

---

### Issue 4: Print pages open but show no data

**Possible Causes:**
1. Patient ID not being passed correctly
2. Print page query issue

**Solutions:**
1. Check URL in address bar - should have `?id=123`
2. Test the print page directly:
   - Navigate to: `visit_summary_print.aspx?id=1`
   - Replace `1` with valid patient ID
3. Check browser console for errors

---

### Issue 5: "View Details" button does nothing

**Possible Causes:**
1. JavaScript not loading
2. jQuery not loaded
3. Function name conflict

**Solutions:**
1. Check browser console (F12)
2. Verify jQuery is loaded:
   ```javascript
   // In browser console, type:
   typeof jQuery
   // Should return "function", not "undefined"
   ```
3. Check network tab for failed AJAX requests

---

## 🛠️ Quick Fixes

### Fix 1: Populate Test Data
If you have no patients showing, create test data:

```sql
-- Create test inpatient
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date)
VALUES ('Test Inpatient', '1990-01-01', 'male', '1234567890', 'Test Location', GETDATE(), 'inpatient', 0, GETDATE());

-- Create test outpatient
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
VALUES ('Test Outpatient', '1985-05-15', 'female', '0987654321', 'Test Location', GETDATE(), 'outpatient', 0);

-- Create test discharged patient
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
VALUES ('Test Discharged', '1975-03-20', 'male', '5555555555', 'Test Location', GETDATE(), 'outpatient', 1);
```

### Fix 2: Set Patient Types for Existing Data
If your existing patients don't have `patient_type` set:

```sql
-- Set inpatient type for patients with bed admission
UPDATE patient 
SET patient_type = 'inpatient'
WHERE bed_admission_date IS NOT NULL AND patient_type IS NULL;

-- Set outpatient type for others
UPDATE patient 
SET patient_type = 'outpatient'
WHERE bed_admission_date IS NULL AND patient_type IS NULL;
```

### Fix 3: Add Default Status
If `patient_status` is NULL:

```sql
-- Set all NULL status to active (0)
UPDATE patient SET patient_status = 0 WHERE patient_status IS NULL;
```

---

## ✅ Verification Checklist

After fixes, verify:

- [ ] Inpatients page shows patients with bed admission dates
- [ ] Outpatients page shows patients without bed admission
- [ ] Discharged page shows both types when status = 1
- [ ] Search function works on all pages
- [ ] Filters work correctly
- [ ] "View Details" expands and loads data
- [ ] Charges section shows itemized charges
- [ ] Medications section shows prescribed meds
- [ ] Lab tests section shows ordered tests
- [ ] X-rays section shows ordered X-rays
- [ ] "Print Summary" opens new window with data
- [ ] "Print Invoice" shows charges correctly
- [ ] "Print Discharge" works for inpatients
- [ ] "Print All" prints visible patients
- [ ] No JavaScript errors in browser console
- [ ] No SQL errors in Visual Studio output

---

## 📞 Still Having Issues?

If problems persist:

1. **Check Connection String:** Verify `Web.config` points to `juba_clinick1`
2. **Check Database:** Make sure database has data
3. **Check Permissions:** Ensure SQL user has SELECT permissions
4. **Check Browser:** Try different browser (Chrome, Edge, Firefox)
5. **Clear Cache:** Clear browser cache and reload
6. **Check IIS:** If using IIS, restart application pool
7. **Rebuild Solution:** Clean and rebuild in Visual Studio

---

## 📝 Summary of Improvements

✅ **Flexible patient type detection** - Works even if `patient_type` is NULL  
✅ **Better error handling** - Try-catch blocks with debug logging  
✅ **Smart filtering** - Uses bed admission date as fallback  
✅ **Diagnostic tools** - SQL scripts to check your data  
✅ **Comprehensive testing guide** - Step-by-step verification  

**Your pages should now work correctly regardless of how patient types are stored!** 🎉

---

*Run the diagnostic SQL first to understand your data, then test each page systematically.*
