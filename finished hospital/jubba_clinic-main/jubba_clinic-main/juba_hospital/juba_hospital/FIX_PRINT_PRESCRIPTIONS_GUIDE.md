# 🔧 Fix "Could not load patient prescription" Error

## 🎯 The Problem

When you click "Print Summary" or "Print Discharge Summary", you see:
**"Could not load patient prescription."**

**Why?** The test patients don't have prescription records yet in the database.

---

## ⚡ QUICK FIX (1 Minute)

### Run This SQL Script:

1. Open **SQL Server Management Studio**
2. Select database: `juba_clinick1`
3. Open file: **`QUICK_FIX_PRESCRIPTIONS.sql`**
4. Click **Execute** (F5)

**This script will:**
- ✅ Create a default doctor (if needed)
- ✅ Add prescriptions for all active patients
- ✅ Add sample medications to each prescription
- ✅ Show verification that it worked

---

## 📋 What the Script Does

```sql
-- Creates a doctor if none exists
INSERT INTO doctor (doctorname, doctortitle, specialization)
VALUES ('Dr. Ahmed', 'General Practitioner', 'General Medicine');

-- For each patient without prescription:
INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
VALUES (patientId, doctorId, 0, 0);

-- Adds sample medication:
INSERT INTO medication (med_name, dosage, frequency, duration, prescid)
VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', prescId);
```

---

## ✅ After Running the Script

You should see output like this:
```
Found 3 patients needing prescriptions.

Patient 1 → Prescription 1 ✓
Patient 2 → Prescription 2 ✓
Patient 3 → Prescription 3 ✓

✓ All active patients now have prescriptions!
```

---

## 🧪 Test Again

1. **Refresh your browser** (F5)
2. Go to any registration page
3. Click **"Print Summary"** on a patient
4. ✅ **Should now open the visit summary page!**
5. Click **"Print Discharge Summary"** on an inpatient
6. ✅ **Should now open the discharge summary page!**

---

## 🔍 Why This Happened

The print pages need a prescription ID to load:
- **Visit Summary** needs `prescid` to show medications and tests
- **Discharge Summary** needs `prescid` to show treatment details

Test patients created earlier didn't have prescriptions, so the print functions couldn't find a `prescid` to pass to the print pages.

---

## 📊 Verify It Worked

Run this query to check:

```sql
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    COUNT(m.medid) as medications
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN medication m ON pr.prescid = m.prescid
WHERE p.patient_status = 0
GROUP BY p.patientid, p.full_name, pr.prescid;
```

**Expected:** All patients should have a `prescid` and at least 1 medication.

---

## 🔄 For Future Test Patients

When creating test patients in the future, always add:
1. Patient record
2. Prescription record (with doctor ID)
3. At least one medication

**Complete example:**
```sql
-- 1. Create patient
INSERT INTO patient (full_name, dob, sex, phone, location, patient_type, patient_status)
VALUES ('Test Patient', '1990-01-01', 'male', '123456', 'Location', 'inpatient', 0);

DECLARE @patId INT = SCOPE_IDENTITY();

-- 2. Create prescription
INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
VALUES (@patId, 1, 0, 0);

DECLARE @prescId INT = SCOPE_IDENTITY();

-- 3. Add medication
INSERT INTO medication (med_name, dosage, frequency, duration, prescid, date_taken)
VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', @prescId, GETDATE());
```

---

## 🎯 Alternative Solution

If you want to create prescriptions manually via the UI:

1. Login as a **doctor**
2. Go to **Waiting Patients**
3. Select each patient
4. Prescribe at least one medication
5. Save the prescription

This creates the prescription record needed for printing.

---

## ✅ Summary

**Problem:** No prescriptions in database  
**Solution:** Run `QUICK_FIX_PRESCRIPTIONS.sql`  
**Result:** All print buttons now work ✅  

**Run the script now and your print functions will work!** 🎉

---

*After running the script, both Print Summary and Print Discharge Summary will work perfectly!*
