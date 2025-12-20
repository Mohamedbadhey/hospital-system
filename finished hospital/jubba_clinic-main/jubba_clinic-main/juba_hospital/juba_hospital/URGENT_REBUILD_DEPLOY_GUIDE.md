# 🚨 URGENT: Rebuild & Deploy Guide

## ⚠️ CRITICAL ISSUE:

You're seeing dates that are **11 hours behind** because:
- ✅ All code fixes are complete (22 files fixed)
- ❌ But you haven't rebuilt the solution
- ❌ And you haven't deployed to the server

**The server is still running OLD compiled code from before the fixes!**

---

## 📊 Evidence You Need to Deploy:

### Issue 1: Patient Registration
```
Your time:     12:30 AM Dec 14, 2025
System shows:  12:56 PM Dec 13, 2025  ❌ 11 hours 34 minutes behind
```

### Issue 2: Charges
```
Your time:     12:30 AM Dec 14, 2025
System shows:  1:30 PM Dec 13, 2025   ❌ 11 hours behind
```

**Both wrong by ~11 hours = Code changes NOT deployed yet**

---

## 🚀 HOW TO FIX THIS NOW:

### OPTION A: Using Visual Studio (Recommended)

#### Step 1: Open Solution
```
1. Open Visual Studio
2. File > Open > Project/Solution
3. Navigate to: juba_hospital/juba_hospital.sln
4. Click Open
```

#### Step 2: Rebuild
```
1. Build menu > Clean Solution (wait to finish)
2. Build menu > Rebuild Solution (Ctrl+Shift+B)
3. Wait for completion
4. Check Output window should show:
   "========== Rebuild All: 1 succeeded, 0 failed =========="
```

#### Step 3: Deploy
```
Option 3A - Publish Profile:
1. Right-click project > Publish
2. Select your publish profile
3. Click Publish
4. Wait for "Publish succeeded"

Option 3B - Manual Copy:
1. Navigate to: juba_hospital/bin/
2. Copy ALL files from bin folder
3. Paste to server's bin folder (overwrite all)
4. Go to server IIS Manager
5. Find your application pool
6. Right-click > Recycle (or Stop then Start)
```

---

### OPTION B: Using MSBuild Command Line

```powershell
# Navigate to project folder
cd path\to\juba_hospital

# Clean and rebuild
msbuild juba_hospital.csproj /t:Clean
msbuild juba_hospital.csproj /t:Rebuild /p:Configuration=Release

# Copy to server
xcopy /Y /E /I bin\Release\* \\server\path\to\site\bin\

# Restart IIS (on server)
iisreset
```

---

## ✅ How to Verify Deployment Worked:

### Verification 1: Check DLL Date
```
1. Go to server: C:\inetpub\wwwroot\yoursite\bin\
2. Find: juba_hospital.dll
3. Right-click > Properties
4. Check "Date modified"
5. Should be TODAY and recent (within last hour)
```

### Verification 2: Test Patient Registration
```
1. Register a new test patient
2. Check registration time
3. Should match your current time (12:30 AM)
4. NOT 11 hours behind
```

### Verification 3: Test Charge Creation
```
1. Create a registration charge
2. Check charge date
3. Should be current time
4. NOT 11 hours behind
```

### Verification 4: Database Check
```sql
-- Register new patient, then check:
SELECT TOP 1 
    patientid, 
    full_name,
    date_registered,
    DATEADD(HOUR, 3, GETUTCDATE()) AS CorrectTime
FROM patient
ORDER BY patientid DESC

-- date_registered should match CorrectTime (within 1-2 minutes)

-- Create a charge, then check:
SELECT TOP 1 
    charge_id,
    charge_type,
    date_added,
    DATEADD(HOUR, 3, GETUTCDATE()) AS CorrectTime
FROM patient_charges
ORDER BY charge_id DESC

-- date_added should match CorrectTime (within 1-2 minutes)
```

---

## 🎯 Expected Results After Deploy:

| Operation | Before Deploy | After Deploy |
|-----------|---------------|--------------|
| Patient Registration | 12:56 PM Dec 13 ❌ | 12:30 AM Dec 14 ✅ |
| Charges Created | 1:30 PM Dec 13 ❌ | 12:30 AM Dec 14 ✅ |
| Lab Results | 11 hours behind ❌ | Correct time ✅ |
| Pharmacy Sales | 11 hours behind ❌ | Correct time ✅ |
| All Timestamps | Wrong ❌ | Correct ✅ |

---

## 📋 Deployment Checklist:

- [ ] Visual Studio opened
- [ ] Solution loaded (juba_hospital.sln)
- [ ] Build > Clean Solution completed
- [ ] Build > Rebuild Solution completed
- [ ] No errors in build output
- [ ] Files published to server OR manually copied
- [ ] IIS application pool restarted
- [ ] Browser cache cleared (Ctrl+Shift+Delete)
- [ ] Test patient registration - time correct?
- [ ] Test charge creation - time correct?
- [ ] Verified DLL date on server is recent

---

## ⚠️ Common Deployment Mistakes:

### Mistake 1: Only copying some files
❌ Don't copy just juba_hospital.dll
✅ Copy ALL files from bin folder

### Mistake 2: Not restarting IIS
❌ Old DLL stays in memory
✅ Always recycle app pool or iisreset

### Mistake 3: Deploying to wrong server
❌ Deploying to local/test instead of production
✅ Verify server name/path before copying

### Mistake 4: Not clearing browser cache
❌ Browser shows old cached data
✅ Hard refresh (Ctrl+F5) or clear cache

---

## 🆘 Troubleshooting:

### Issue: Build fails with errors
**Solution:**
1. Check Output window for specific error
2. Most likely: DateTimeHelper not recognized
3. Make sure DateTimeHelper.cs is in project
4. Build > Clean, then Rebuild again

### Issue: After deploy, still showing wrong time
**Solution:**
1. Verify DLL date on server is recent
2. Restart IIS: Run `iisreset` on server
3. Clear browser cache completely
4. Try different browser
5. Check you deployed to correct server/path

### Issue: Can't publish from Visual Studio
**Solution:**
1. Use manual copy method instead
2. Copy entire bin folder contents
3. Paste to server, overwrite all
4. Restart IIS

---

## 📞 Quick Help:

**If deployment seems successful but times still wrong:**

Run this SQL to verify if new code is running:
```sql
-- This will show if DateTimeHelper.Now is being used
SELECT TOP 5 
    patientid,
    date_registered,
    DATEADD(HOUR, 3, GETUTCDATE()) AS CorrectTime,
    DATEDIFF(HOUR, date_registered, DATEADD(HOUR, 3, GETUTCDATE())) AS HoursDifference
FROM patient
ORDER BY patientid DESC

-- If HoursDifference is ~11 for newest patient: Old code still running
-- If HoursDifference is 0-1 for newest patient: New code is running!
```

---

## 🎯 BOTTOM LINE:

**All 22 files are fixed in the code.**

**You just need to:**
1. Rebuild the solution (5 minutes)
2. Deploy to server (5 minutes)
3. Test (2 minutes)

**Then everything will work correctly!**

---

## 💡 After Successful Deploy:

Once deployed and tested, you should also run the SQL fix to correct old data:
```sql
FIX_TIMEZONE_COMPLETE.sql
```

This will fix the timestamps for patients 1001, 1002, 1003, and 1006 (the ones with wrong dates).

---

**NOW: Go rebuild and deploy! The code is ready, just needs to be deployed!** 🚀
