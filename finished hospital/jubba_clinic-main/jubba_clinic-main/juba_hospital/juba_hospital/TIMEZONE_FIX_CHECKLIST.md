# ✅ Timezone Fix Checklist

## 🎯 Problem Summary:
- Server time is 11 hours behind correct Somalia time
- All dates stored are wrong (yesterday instead of today)
- Need to fix existing data + prevent future issues

---

## 📋 Complete Fix Steps:

### Step 1: Backup Database ⏳
```sql
BACKUP DATABASE [jubba_clinick] 
TO DISK = 'C:\Backup\jubba_clinick_before_timezone_fix.bak'
```
- [ ] Database backup completed

---

### Step 2: Fix Existing Data ⏳
Run: `FIX_TIMEZONE_COMPLETE.sql` on deployed server

This will:
- Add 11 hours to all patient registration dates
- Add 11 hours to all prescription dates
- Add 11 hours to all pharmacy sales dates
- Create helper functions: `GetEATTime()` and `ConvertToEAT()`

**Expected Result:**
- All 3 patients will show correct registration time
- All dates will be 11 hours ahead (correct Somalia time)

- [ ] SQL script executed successfully
- [ ] Verified patient dates are now correct

---

### Step 3: Update C# Code ⏳

**Files to Update:**

#### A. Add_patients.aspx.cs
Find and replace:
```csharp
// OLD:
cmd.Parameters.AddWithValue("@date_registered", DateTime.Now);

// NEW:
cmd.Parameters.AddWithValue("@date_registered", DateTime.UtcNow.AddHours(3));
```
- [ ] Updated Add_patients.aspx.cs

#### B. assignmed.aspx.cs
Find and replace:
```csharp
// OLD:
cmd.Parameters.AddWithValue("@date", DateTime.Now);

// NEW:
cmd.Parameters.AddWithValue("@date", DateTime.UtcNow.AddHours(3));
```
- [ ] Updated assignmed.aspx.cs

#### C. pharmacy_pos.aspx.cs
Find and replace:
```csharp
// OLD:
cmd.Parameters.AddWithValue("@sale_date", DateTime.Now);

// NEW:
cmd.Parameters.AddWithValue("@sale_date", DateTime.UtcNow.AddHours(3));
```
- [ ] Updated pharmacy_pos.aspx.cs

#### D. Any other files with DateTime.Now
Use Visual Studio Find in Files (Ctrl+Shift+F):
- Search: `DateTime.Now`
- Replace with: `DateTime.UtcNow.AddHours(3)`
- [ ] Searched and updated all other files

---

### Step 4: Rebuild and Deploy ⏳
- [ ] Rebuild solution in Visual Studio
- [ ] No compilation errors
- [ ] Deploy to server
- [ ] Application starts without errors

---

### Step 5: Test Everything ⏳

#### Test 1: Register New Patient
- [ ] Register a new patient
- [ ] Check database: date_registered should be current Somalia time
- [ ] Run: `SELECT TOP 1 patientid, full_name, date_registered, dbo.GetEATTime() AS CurrentTime FROM patient ORDER BY patientid DESC`
- [ ] Dates should be within a few minutes of each other

#### Test 2: Create Prescription
- [ ] Create a prescription for a patient
- [ ] Check database: date should be current time
- [ ] Run: `SELECT TOP 1 presid, date, dbo.GetEATTime() AS CurrentTime FROM prescribtion ORDER BY presid DESC`
- [ ] Dates should match

#### Test 3: Pharmacy Sale
- [ ] Make a pharmacy sale
- [ ] Check database: sale_date should be current time
- [ ] Dates should be correct

#### Test 4: Verify Old Data
- [ ] Check the 3 existing patients (IDs 1001, 1002, 1003)
- [ ] Their dates should now show December 13 (not December 12)
- [ ] Times should be around 10:08, 09:49, 09:43

---

### Step 6: Final Verification ⏳

Run this query on deployed server:
```sql
-- Should show all correct times
SELECT 
    'Server Time (WRONG - Ignore)' AS TimeType,
    GETDATE() AS Time
UNION ALL
SELECT 
    'UTC Time',
    GETUTCDATE()
UNION ALL
SELECT 
    'Correct Somalia Time (EAT)',
    dbo.GetEATTime()
UNION ALL
SELECT
    'Latest Patient Registration',
    (SELECT TOP 1 date_registered FROM patient ORDER BY date_registered DESC)
UNION ALL
SELECT
    'Latest Prescription',
    (SELECT TOP 1 date FROM prescribtion ORDER BY date DESC)
```

Expected result:
- Correct Somalia Time should match your wall clock
- Latest Patient/Prescription should be recent

- [ ] All times verified and correct

---

## 🎉 Success Criteria:

✅ All existing dates corrected (11 hours added)  
✅ New patients register with correct time  
✅ New prescriptions have correct time  
✅ Pharmacy sales have correct time  
✅ No more "yesterday" dates for today's transactions  

---

## 📊 Summary:

| Item | Before Fix | After Fix |
|------|------------|-----------|
| Server Offset | -8 hours (WRONG) | Still -8, but we handle in code |
| Patient 1003 | Dec 12, 23:08 ❌ | Dec 13, 10:08 ✅ |
| Patient 1002 | Dec 12, 22:49 ❌ | Dec 13, 09:49 ✅ |
| Patient 1001 | Dec 12, 22:43 ❌ | Dec 13, 09:43 ✅ |
| New Patients | Wrong date ❌ | Correct date ✅ |
| Code Uses | DateTime.Now ❌ | DateTime.UtcNow.AddHours(3) ✅ |

---

## 🆘 If Something Goes Wrong:

### Issue: SQL script fails
- Restore from backup
- Check error message
- Ask for help

### Issue: Dates still wrong after fix
- Check C# code was updated and deployed
- Verify you're testing on deployed server (not local)
- Run verification query

### Issue: Some dates correct, others wrong
- Check if all files were updated
- Search for remaining DateTime.Now instances
- Rebuild and redeploy

---

## 📞 Need Help?

Share:
1. Which step you're on
2. What error occurred
3. Output of verification queries

---

## 🚀 Ready to Start?

1. ✅ Backup database
2. ✅ Run FIX_TIMEZONE_COMPLETE.sql
3. ✅ Update C# code (3-4 files)
4. ✅ Rebuild and deploy
5. ✅ Test thoroughly

**Estimated time: 30 minutes**

Go ahead and start with Step 1 (Backup), then Step 2 (Run SQL script)!
