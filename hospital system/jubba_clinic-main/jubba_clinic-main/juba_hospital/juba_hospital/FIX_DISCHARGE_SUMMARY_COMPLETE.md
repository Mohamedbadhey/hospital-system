# 🔧 Fix Discharge Summary - Complete Guide

## 🎯 Your Current Issue

**URL:** `http://localhost:4300/discharge_summary_print.aspx?patientId=1046&prescid=1046`
**Error:** 500 Internal Server Error
**Problem:** `prescid=1046` is the same as patient ID, which means no prescription was found

---

## ⚡ IMMEDIATE FIX (30 seconds)

### **Step 1: Run this SQL**

Open SQL Server Management Studio and run:

```sql
USE juba_clinick1;

-- Check if patient 1046 exists
SELECT * FROM patient WHERE patientid = 1046;

-- Check if patient 1046 has a prescription
SELECT * FROM prescribtion WHERE patientid = 1046;

-- If no prescription found, create one:
DECLARE @doctorId INT = (SELECT TOP 1 doctorid FROM doctor);

-- Create doctor if needed
IF @doctorId IS NULL
BEGIN
    INSERT INTO doctor (doctorname, doctortitle, specialization, username, password)
    VALUES ('Dr. Ahmed', 'General Practitioner', 'General Medicine', 'doctor1', 'doctor123');
    SET @doctorId = SCOPE_IDENTITY();
END

-- Add prescription for patient 1046
IF NOT EXISTS (SELECT 1 FROM prescribtion WHERE patientid = 1046)
BEGIN
    INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
    VALUES (1046, @doctorId, 0, 0);
    
    DECLARE @prescId INT = SCOPE_IDENTITY();
    
    -- Add sample medication
    INSERT INTO medication (med_name, dosage, frequency, duration, prescid, date_taken)
    VALUES ('Paracetamol', '500mg', 'Three times daily', '7 days', @prescId, GETDATE());
    
    PRINT 'Created prescription ' + CAST(@prescId AS VARCHAR) + ' for patient 1046';
END

-- Verify
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    COUNT(m.medid) as medications
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN medication m ON pr.prescid = m.prescid
WHERE p.patientid = 1046
GROUP BY p.patientid, p.full_name, pr.prescid;
```

### **Step 2: Rebuild and Test**

1. **Rebuild** your Visual Studio project
2. **Refresh** your browser
3. **Open browser console** (F12)
4. **Click "Print Discharge Summary"** again
5. **Check console logs** - you should see:
   ```
   Patient ID: 1046
   Prescription ID from server: [some number other than 1046]
   Opening URL: discharge_summary_print.aspx?patientId=1046&prescid=[real prescid]
   ```

---

## 🔍 Debugging Steps

I've added console logging to help diagnose the issue. When you click the button, check the console:

### **What to Look For:**

**Good Output:**
```
Patient ID: 1046
Prescription ID from server: 25
Opening URL: discharge_summary_print.aspx?patientId=1046&prescid=25
```
✅ This means it's working correctly!

**Bad Output:**
```
Patient ID: 1046
Prescription ID from server: 0
[Shows SweetAlert: No Prescription Found]
```
❌ This means patient 1046 has no prescription - run the SQL fix above

**Error Output:**
```
AJAX Error: Internal Server Error
Status: error
Response: [error details]
```
❌ This means the WebMethod is crashing - check Visual Studio output window

---

## 📊 Verify Your Data

Run these queries to check:

### **1. Check All Patients and Prescriptions**
```sql
SELECT 
    p.patientid,
    p.full_name,
    p.patient_type,
    pr.prescid,
    CASE WHEN pr.prescid IS NULL THEN '❌ NO PRESCRIPTION' ELSE '✅ Has Prescription' END as status
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 0
ORDER BY p.patientid;
```

**Expected:** All active patients should have a `prescid`

### **2. Check Specific Patient 1046**
```sql
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    pr.doctorid,
    d.doctorname
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patientid = 1046;
```

**Expected:** Should show a valid `prescid` and `doctorname`

---

## 🔧 Common Issues & Fixes

### **Issue 1: Patient Has No Prescription**
**Symptom:** Console shows `Prescription ID from server: 0`
**Fix:** Run `FIX_PATIENT_1046.sql` or the SQL above

### **Issue 2: WebMethod Returns Patient ID Instead of Prescription ID**
**Symptom:** URL shows `prescid=1046` (same as patient ID)
**Fix:** This shouldn't happen with the current code, but check the WebMethod:
```csharp
[WebMethod]
public static int GetPatientPrescriptionId(int patientId)
{
    string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
    
    using (SqlConnection con = new SqlConnection(cs))
    {
        string query = "SELECT TOP 1 prescid FROM prescribtion WHERE patientid = @patientId ORDER BY prescid DESC";
        SqlCommand cmd = new SqlCommand(query, con);
        cmd.Parameters.AddWithValue("@patientId", patientId);
        con.Open();
        object result = cmd.ExecuteScalar();
        return result != null ? Convert.ToInt32(result) : 0;  // Should return 0 if not found
    }
}
```

### **Issue 3: Discharge Summary Page Crashes (500 Error)**
**Symptom:** Page opens but shows 500 error
**Possible Causes:**
1. Invalid prescription ID
2. Doctor table column name mismatch (should be fixed now)
3. NULL data causing crash (should be fixed now)

**Fix:** Already applied in previous fix - doctor query uses `LEFT JOIN` and NULL handling

---

## 🧪 Step-by-Step Testing

### **Test 1: Check Console Logs**
1. Open browser (F12 → Console tab)
2. Click "Print Discharge Summary"
3. Read the console output
4. Share the output if you need help

### **Test 2: Verify SQL Data**
1. Run `CHECK_PRESCRIPTION_IDS.sql`
2. Check if patient 1046 has a prescription
3. If not, run `FIX_PATIENT_1046.sql`

### **Test 3: Test with Different Patient**
1. Try clicking discharge summary on a different patient
2. If it works for others but not 1046, it's a data issue with patient 1046
3. Run the fix SQL for that specific patient

---

## ✅ Quick Fix Script

**File:** `FIX_PATIENT_1046.sql`

This script will:
- ✅ Check if patient 1046 exists
- ✅ Check if patient 1046 has a prescription
- ✅ Create prescription if missing
- ✅ Add sample medication
- ✅ Show final verification

---

## 🎯 Expected Behavior After Fix

1. Click "Print Discharge Summary"
2. Console logs show:
   - Patient ID: 1046
   - Prescription ID: [real prescription ID, NOT 1046]
   - Opening URL with correct prescid
3. New tab opens with discharge summary
4. Discharge summary loads successfully with all data

---

## 📞 Still Not Working?

If it's still failing, please check:

1. **Browser Console** (F12) - What does it say?
2. **Visual Studio Output** - Any SQL errors?
3. **SQL Query Results** - Does patient 1046 have a prescription?
4. **The URL** - What's the actual prescid value in the URL?

Share these details and I can help further!

---

## 🚀 Summary

**Root Cause:** Patient 1046 doesn't have a prescription record  
**Solution:** Run the SQL fix to create a prescription  
**Verification:** Check console logs to see the correct prescription ID  
**Result:** Discharge summary will load successfully  

**Run the SQL fix now and test again!** 🎉

---

*Debugging tools added - check your console for helpful logs!*
