# 🔍 Troubleshooting: "Failed to Load Inpatients" Error

## Issue
When clicking on "Inpatient Management" as a doctor, you see the error: **"Failed to load inpatients"**

---

## 🎯 Common Causes & Solutions

### **Cause 1: No Inpatient Data in Database**

**Check:**
Run this SQL query in SSMS:
```sql
SELECT COUNT(*) FROM patient WHERE patient_status = 1;
```

**If result is 0:**
You have no inpatients in the system!

**Solution: Create a Test Inpatient**
```sql
-- Step 1: Find a patient ID
SELECT TOP 5 patientid, full_name FROM patient;

-- Step 2: Update a patient to be inpatient
UPDATE patient 
SET patient_status = 1,
    bed_admission_date = GETDATE()
WHERE patientid = 1; -- Use actual patient ID

-- Step 3: Make sure patient has a prescription
-- Check if prescription exists
SELECT * FROM prescribtion WHERE patientid = 1;

-- If no prescription, create one
INSERT INTO prescribtion (patientid, doctorid, status, xray_status)
VALUES (1, 5, 1, 0); -- Use actual patient and doctor IDs
```

---

### **Cause 2: Session["id"] is Empty**

**Check:**
The doctor's session ID might not be set correctly.

**Solution:**
1. Logout completely
2. Login again as a doctor
3. Check the URL after login - it should redirect to doctor pages
4. Try accessing inpatient management again

---

### **Cause 3: Doctor ID Not Matching**

**Check:**
The query filters by `doctor.doctorid = @doctorId`

**Solution:**
Run this SQL to see which doctor the inpatients are assigned to:
```sql
SELECT 
    p.patientid,
    p.full_name,
    p.patient_status,
    d.doctorid,
    d.fullname as doctor_name
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
INNER JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patient_status = 1;
```

Make sure you're logged in as the doctor who has inpatients assigned.

---

### **Cause 4: Browser Console Errors**

**Check:**
1. Press **F12** in your browser
2. Go to **Console** tab
3. Refresh the page
4. Look for any red error messages

**Common errors:**
- `404 Not Found` - Page/WebMethod not found
- `500 Internal Server Error` - Server-side error
- `Swal is not defined` - SweetAlert library not loaded

**Solution:**
- For 404: Make sure `doctor_inpatient.aspx.cs` exists and is compiled
- For 500: Check Visual Studio Output window for compilation errors
- For Swal: Add SweetAlert2 script reference

---

### **Cause 5: Missing bed_admission_date**

**Check:**
```sql
SELECT patientid, full_name, patient_status, bed_admission_date
FROM patient
WHERE patient_status = 1;
```

If `bed_admission_date` is NULL, the query might fail.

**Solution:**
```sql
UPDATE patient
SET bed_admission_date = GETDATE()
WHERE patient_status = 1 AND bed_admission_date IS NULL;
```

---

## 🛠️ Quick Fix Steps

### **Step 1: Verify Database Has Inpatients**
```sql
-- Run in SSMS
USE juba_clinick; -- Or your database name

SELECT 
    p.patientid,
    p.full_name,
    p.patient_status,
    p.bed_admission_date,
    pr.prescid,
    d.doctorid,
    d.fullname as doctor_name
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
LEFT JOIN doctor d ON pr.doctorid = d.doctorid
WHERE p.patient_status = 1;
```

**Expected Result:** At least one row showing an inpatient

### **Step 2: If No Data, Create Test Patient**
```sql
-- Use the test_inpatient_data.sql file provided
-- Or manually:

-- 1. Find available IDs
SELECT TOP 1 p.patientid, p.full_name FROM patient p
WHERE NOT EXISTS (SELECT 1 FROM prescribtion pr WHERE pr.patientid = p.patientid);

-- 2. Get a doctor ID
SELECT TOP 1 doctorid, fullname FROM doctor;

-- 3. Update patient
UPDATE patient SET patient_status = 1, bed_admission_date = GETDATE() WHERE patientid = 1;

-- 4. Create prescription if needed
INSERT INTO prescribtion (patientid, doctorid, status, xray_status, lab_charge_paid, xray_charge_paid)
VALUES (1, 5, 1, 0, 0, 0);
```

### **Step 3: Check Browser Console**
1. Open page: `doctor_inpatient.aspx`
2. Press **F12**
3. Go to **Console** tab
4. Look for errors
5. Copy any error messages

### **Step 4: Test the WebMethod Directly**
You can test if the WebMethod works by opening browser console and running:
```javascript
$.ajax({
    url: 'doctor_inpatient.aspx/GetInpatients',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ doctorId: '5' }), // Use actual doctor ID
    success: function(response) {
        console.log('Success:', response);
    },
    error: function(xhr) {
        console.log('Error:', xhr.responseText);
    }
});
```

---

## 📊 Expected Data Structure

For the page to work, you need:

1. **Patient with patient_status = 1:**
```sql
patientid | full_name     | patient_status | bed_admission_date
1         | John Doe      | 1              | 2025-01-20 10:00:00
```

2. **Prescription linking patient to doctor:**
```sql
prescid | patientid | doctorid | status
1       | 1         | 5        | 1
```

3. **Doctor record:**
```sql
doctorid | fullname      | username
5        | Dr. Smith     | drsmith
```

---

## 🎯 Testing Checklist

- [ ] Run `test_inpatient_data.sql` to check database
- [ ] Verify at least one patient has `patient_status = 1`
- [ ] Verify patient has `bed_admission_date` set
- [ ] Verify patient has a prescription record
- [ ] Verify prescription is linked to a doctor
- [ ] Login as that specific doctor
- [ ] Check browser console for errors (F12)
- [ ] Verify SweetAlert2 is loaded
- [ ] Check Visual Studio for compilation errors

---

## 💡 Still Not Working?

### Get More Details:

1. **Check Visual Studio Output:**
   - View → Output
   - Look for any exceptions or errors when the page loads

2. **Enable Detailed Errors in Web.config:**
```xml
<system.web>
    <customErrors mode="Off"/>
</system.web>
```

3. **Check IIS Express Output:**
   - When running with F5, check the console window
   - Look for any 500 errors or exceptions

4. **Use Browser Network Tab:**
   - F12 → Network tab
   - Refresh page
   - Find the AJAX call to `GetInpatients`
   - Click on it to see request/response details

---

## 📞 Quick Commands Reference

**Check inpatients:**
```sql
SELECT COUNT(*) FROM patient WHERE patient_status = 1;
```

**Make a patient inpatient:**
```sql
UPDATE patient SET patient_status = 1, bed_admission_date = GETDATE() WHERE patientid = 1;
```

**Check doctor's inpatients:**
```sql
SELECT p.* FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE pr.doctorid = 5 AND p.patient_status = 1;
```

---

**Most Common Fix:** Run `test_inpatient_data.sql` and create test data if none exists!
