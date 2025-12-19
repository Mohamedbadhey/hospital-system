# 🔍 Debug Prescription ID Issue - Step by Step

## 🎯 What We're Debugging

You're seeing:
```
Patient ID: 1048
Prescription ID: 1048  ← Same as patient ID!
```

We need to find out **where** the prescid is getting set to the patient ID.

---

## 📋 Step 1: Test SQL Query Directly

**Run this SQL in SSMS:**

Open file: **`TEST_PRESCID_QUERY_DIRECTLY.sql`**

Or run this:
```sql
USE juba_clinick1;

-- Test the exact query
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    CASE 
        WHEN p.patientid = pr.prescid THEN '❌ Database has same IDs'
        WHEN pr.prescid IS NULL THEN '⚠️ No prescription in database'
        ELSE '✅ Database has different IDs'
    END as database_status
FROM patient p
LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr 
ON p.patientid = pr.patientid
WHERE p.patientid IN (1047, 1048);
```

**Check the result:**
- If `prescid = patientid` in SQL → **Problem is in the database**
- If `prescid IS NULL` in SQL → **No prescription exists**
- If `prescid ≠ patientid` in SQL → **Problem is in C# code or JavaScript**

---

## 📋 Step 2: Check Visual Studio Output

I've added debug logging to the C# code.

1. **Rebuild** your Visual Studio project
2. **Run** the application (F5)
3. **Open Visual Studio Output window** (View → Output)
4. **Load the discharged page**
5. **Look for lines like:**
   ```
   DEBUG - PatientID: 1048, PrescID: 1048
   DEBUG - PatientID: 1047, PrescID: 1047
   ```

**This tells us what the C# code is reading from the database.**

---

## 📋 Step 3: Check Browser Console

The JavaScript already has console logging:

1. **Open browser console** (F12)
2. **Click "Print Discharge Summary"**
3. **Look for:**
   ```
   Patient ID: 1048
   Prescription ID: 1048
   ```

**This tells us what JavaScript is receiving from the C# code.**

---

## 🎯 Three Possible Scenarios

### **Scenario A: Database has same IDs**
**SQL shows:** `prescid = patientid`  
**VS Output shows:** `DEBUG - PatientID: 1048, PrescID: 1048`  
**Console shows:** `Prescription ID: 1048`

**Solution:** Run the prescription fix SQL to create proper prescription IDs

---

### **Scenario B: Database is NULL**
**SQL shows:** `prescid IS NULL`  
**VS Output shows:** `DEBUG - PatientID: 1048, PrescID: <null>`  
**Console shows:** `Prescription ID: 1048` (falls back to patient ID)

**Solution:** Create prescriptions for these patients

---

### **Scenario C: C# code issue**
**SQL shows:** `prescid = 5001` (different!)  
**VS Output shows:** `DEBUG - PatientID: 1048, PrescID: 5001`  
**Console shows:** `Prescription ID: 1048` (wrong!)

**Solution:** JavaScript is using wrong value - check the button binding

---

## 🔧 Quick Fixes Based on Scenario

### **Fix for Scenario A or B:**
```sql
USE juba_clinick1;

-- Delete and recreate prescriptions with proper IDs
DELETE FROM medication;
DELETE FROM prescribtion;

-- Reseed to 5000
DBCC CHECKIDENT ('prescribtion', RESEED, 5000);

-- Create prescriptions
DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);

INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
SELECT patientid, @doctorId, 0, 0
FROM patient WHERE patient_status IN (0, 1);

-- Add medications
INSERT INTO medication (med_name, dosage, frequency, duration, prescid, date_taken)
SELECT 'Paracetamol', '500mg', 'Three times daily', '7 days', prescid, GETDATE()
FROM prescribtion;

-- Verify
SELECT p.patientid, pr.prescid
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patientid IN (1047, 1048);
```

---

### **Fix for Scenario C:**

Check the button binding in the ASPX file. The button should look like:
```html
<button onclick="printDischarge(<%# Eval("patientid") %>, <%# Eval("prescid") ?? "0" %>)">
```

Not:
```html
<button onclick="printDischarge(<%# Eval("patientid") %>, <%# Eval("patientid") %>)">
```

---

## 📊 Debug Checklist

Run through these steps and note what you find:

- [ ] **Step 1:** Ran SQL query - Result: ___________________
- [ ] **Step 2:** Checked VS Output - Result: ___________________
- [ ] **Step 3:** Checked Browser Console - Result: ___________________
- [ ] **Scenario:** A / B / C (circle one)
- [ ] **Fix Applied:** ___________________
- [ ] **Tested Again:** Working ✅ / Still failing ❌

---

## 🚀 What to Do Now

1. **Run** `TEST_PRESCID_QUERY_DIRECTLY.sql` in SSMS
2. **Tell me** what the SQL shows for patients 1047 and 1048
3. **Rebuild** and run the application
4. **Check** Visual Studio Output window
5. **Share** what the DEBUG lines show

Then I can tell you exactly which fix to apply!

---

## 💡 Expected Results After Fix

**SQL Query:**
```
patientid | prescid | status
1047      | 5001    | ✅ Database has different IDs
1048      | 5002    | ✅ Database has different IDs
```

**VS Output:**
```
DEBUG - PatientID: 1047, PrescID: 5001
DEBUG - PatientID: 1048, PrescID: 5002
```

**Browser Console:**
```
Patient ID: 1047
Prescription ID: 5001
Opening URL: discharge_summary_print.aspx?patientId=1047&prescid=5001
```

---

**Run Step 1 now and let me know what you see!** 🔍
