# ⚡ QUICK FIX - Get Inpatients Showing Now!

## 🎯 Your Problem
Page says: **"No active inpatients found."**

## ✅ Your Solution (2 Minutes)

---

## 📋 Step-by-Step Fix

### Step 1: Open SQL Server Management Studio
1. Click Start menu
2. Type "SQL Server Management Studio"
3. Open it
4. Connect to your server

---

### Step 2: Select Your Database
1. In Object Explorer, expand "Databases"
2. Right-click on **`juba_clinick1`**
3. Click "New Query"

---

### Step 3: Run the Fix Script
1. Copy the script below
2. Paste into the query window
3. Click **Execute** (or press F5)
4. Wait for completion message

```sql
-- INSTANT FIX FOR INPATIENTS PAGE
USE juba_clinick1;
GO

-- Create 3 test inpatients
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date)
VALUES 
    ('Ahmed Hassan Ibrahim', '1985-03-15', 'male', '252615123456', 'Mogadishu', DATEADD(DAY, -5, GETDATE()), 'inpatient', 0, DATEADD(DAY, -5, GETDATE())),
    ('Fatima Mohamed Ali', '1992-07-22', 'female', '252617654321', 'Kismayo', DATEADD(DAY, -3, GETDATE()), 'inpatient', 0, DATEADD(DAY, -3, GETDATE())),
    ('Omar Yusuf Abdi', '1978-11-05', 'male', '252618987654', 'Hargeisa', DATEADD(DAY, -7, GETDATE()), 'inpatient', 0, DATEADD(DAY, -7, GETDATE()));

-- Add charges for them
DECLARE @patient1 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Ahmed Hassan Ibrahim');
DECLARE @patient2 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Fatima Mohamed Ali');
DECLARE @patient3 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Omar Yusuf Abdi');

INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number)
VALUES 
    (@patient1, 'Registration', 'Registration Fee', 50, 1, DATEADD(DAY, -5, GETDATE()), 'REG-' + CAST(@patient1 AS VARCHAR)),
    (@patient1, 'Bed', 'Bed Charge', 150, 0, GETDATE(), 'BED-' + CAST(@patient1 AS VARCHAR)),
    (@patient2, 'Registration', 'Registration Fee', 50, 1, DATEADD(DAY, -3, GETDATE()), 'REG-' + CAST(@patient2 AS VARCHAR)),
    (@patient2, 'Bed', 'Bed Charge', 90, 0, GETDATE(), 'BED-' + CAST(@patient2 AS VARCHAR)),
    (@patient2, 'Delivery', 'Delivery Service', 200, 1, DATEADD(DAY, -3, GETDATE()), 'DEL-' + CAST(@patient2 AS VARCHAR)),
    (@patient3, 'Registration', 'Registration Fee', 50, 1, DATEADD(DAY, -7, GETDATE()), 'REG-' + CAST(@patient3 AS VARCHAR)),
    (@patient3, 'Bed', 'Bed Charge', 210, 0, GETDATE(), 'BED-' + CAST(@patient3 AS VARCHAR)),
    (@patient3, 'Lab', 'Lab Tests', 75, 1, DATEADD(DAY, -6, GETDATE()), 'LAB-' + CAST(@patient3 AS VARCHAR));

PRINT 'SUCCESS! 3 test inpatients created.';
PRINT '';
PRINT 'Patient 1: Ahmed Hassan Ibrahim (5 days admitted) - $200 charges';
PRINT 'Patient 2: Fatima Mohamed Ali (3 days admitted) - $340 charges';  
PRINT 'Patient 3: Omar Yusuf Abdi (7 days admitted) - $335 charges';
PRINT '';
PRINT 'Now refresh your browser page!';
GO
```

---

### Step 4: Refresh Your Browser
1. Go back to the inpatients page
2. Press **F5** or **Ctrl+R**
3. ✅ **Done! You should see 3 patients!**

---

## 🎉 What You Should See Now

After refreshing, the page should show:

**Ahmed Hassan Ibrahim**
- ID: (generated)
- Status: Inpatient
- Days admitted: 5
- Total charges: $200.00
- Paid: $50.00
- Unpaid: $150.00

**Fatima Mohamed Ali**
- ID: (generated)
- Status: Inpatient
- Days admitted: 3
- Total charges: $340.00
- Paid: $250.00
- Unpaid: $90.00

**Omar Yusuf Abdi**
- ID: (generated)
- Status: Inpatient
- Days admitted: 7
- Total charges: $335.00
- Paid: $125.00
- Unpaid: $210.00

---

## 🧪 Test the Features

Now try these:

### 1. Search
- Type "Ahmed" in search box
- Should filter to show only Ahmed

### 2. Filter
- Select "Has Unpaid" from payment filter
- Should show all 3 (they all have unpaid bed charges)

### 3. View Details
- Click "View Details" on any patient
- Should expand and show:
  - Charges breakdown table
  - Medications section (may be empty)
  - Lab tests section
  - X-rays section

### 4. Print
- Click "Print Summary" - opens new window
- Click "Print Invoice" - shows invoice
- Click "Print All" - prints all patient cards

---

## 🔄 Do the Same for Outpatients

Want to test the outpatients page too? Run this:

```sql
USE juba_clinick1;
GO

-- Create 3 test outpatients
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
VALUES 
    ('Amina Abdi Hassan', '1995-02-18', 'female', '252619876543', 'Baidoa', DATEADD(DAY, -2, GETDATE()), 'outpatient', 0),
    ('Hassan Ibrahim Mohamed', '1988-09-30', 'male', '252610111222', 'Garowe', DATEADD(DAY, -1, GETDATE()), 'outpatient', 0),
    ('Maryam Ahmed Ali', '1990-06-12', 'female', '252614555666', 'Mogadishu', GETDATE(), 'outpatient', 0);

-- Add charges
DECLARE @out1 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Amina Abdi Hassan');
DECLARE @out2 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Hassan Ibrahim Mohamed');
DECLARE @out3 INT = (SELECT TOP 1 patientid FROM patient WHERE full_name = 'Maryam Ahmed Ali');

INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, date_added, invoice_number, payment_method)
VALUES 
    (@out1, 'Registration', 'Registration Fee', 50, 1, DATEADD(DAY, -2, GETDATE()), 'REG-' + CAST(@out1 AS VARCHAR), 'Cash'),
    (@out1, 'Lab', 'Lab Tests', 75, 1, DATEADD(DAY, -2, GETDATE()), 'LAB-' + CAST(@out1 AS VARCHAR), 'Cash'),
    (@out2, 'Registration', 'Registration Fee', 50, 0, DATEADD(DAY, -1, GETDATE()), 'REG-' + CAST(@out2 AS VARCHAR)),
    (@out2, 'Xray', 'Chest X-Ray', 100, 0, DATEADD(DAY, -1, GETDATE()), 'XRAY-' + CAST(@out2 AS VARCHAR)),
    (@out3, 'Registration', 'Registration Fee', 50, 1, GETDATE(), 'REG-' + CAST(@out3 AS VARCHAR), 'Cash');

PRINT 'SUCCESS! 3 test outpatients created.';
GO
```

Then go to **Patient → Outpatients List** and refresh!

---

## 🔄 Do the Same for Discharged

Want to test the discharged page too? Run this:

```sql
USE juba_clinick1;
GO

-- Create 2 test discharged patients
INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status, bed_admission_date)
VALUES 
    ('Discharged Inpatient', '1980-06-12', 'male', '252614555777', 'Mogadishu', DATEADD(DAY, -15, GETDATE()), 'inpatient', 1, DATEADD(DAY, -15, GETDATE()));

INSERT INTO patient (full_name, dob, sex, phone, location, date_registered, patient_type, patient_status)
VALUES 
    ('Discharged Outpatient', '1990-04-25', 'female', '252615777888', 'Hargeisa', DATEADD(DAY, -10, GETDATE()), 'outpatient', 1);

PRINT 'SUCCESS! 2 test discharged patients created.';
GO
```

Then go to **Patient → Discharged Patients** and refresh!

---

## ❓ Still Not Working?

### Check these:

**1. Database Name in Web.config**
- Open: `juba_hospital/Web.config`
- Find line with: `Initial Catalog=`
- Should say: `Initial Catalog=juba_clinick1`

**2. Rebuild Application**
- Visual Studio → Build → Rebuild Solution
- Wait for completion
- Run again (F5)

**3. Check Browser Console**
- Press F12 in browser
- Click Console tab
- Look for any red errors
- Share them if you see any

**4. Verify Script Ran Successfully**
- In SSMS, run:
```sql
SELECT COUNT(*) as inpatient_count 
FROM patient 
WHERE patient_type = 'inpatient' AND patient_status = 0;
```
- Should return: 3 or more

---

## 📊 Verify Your Data

Run this to see what the page should show:

```sql
USE juba_clinick1;

SELECT 
    p.patientid,
    p.full_name,
    p.bed_admission_date,
    DATEDIFF(DAY, p.bed_admission_date, GETDATE()) as days_admitted,
    ISNULL(SUM(pc.amount), 0) as total_charges,
    ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid,
    ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid
FROM patient p
LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
WHERE p.patient_type = 'inpatient' AND p.patient_status = 0
GROUP BY p.patientid, p.full_name, p.bed_admission_date
ORDER BY p.bed_admission_date DESC;
```

If this shows 3 rows with data, your page will work!

---

## ✅ Success Checklist

After running the script:

- [x] SQL script executed successfully
- [x] "SUCCESS!" message appeared
- [x] Browser page refreshed (F5)
- [x] 3 patient cards visible
- [x] Patient names showing
- [x] Days admitted calculated
- [x] Charges showing correctly
- [x] Search box works
- [x] "View Details" expands
- [x] Print buttons work

**All checked? Perfect! Your page is working!** 🎉

---

## 🎓 What This Script Does

The quick fix script:
1. ✅ Creates 3 inpatient records
2. ✅ Sets proper patient_type ('inpatient')
3. ✅ Sets patient_status (0 = active)
4. ✅ Adds bed_admission_date (different dates)
5. ✅ Creates charges (registration, bed, lab, delivery)
6. ✅ Mixes paid and unpaid charges
7. ✅ Creates realistic test data

**Now your page has real data to display!**

---

*Copy the SQL script, run it, refresh your browser - Done in 2 minutes!* ⚡
