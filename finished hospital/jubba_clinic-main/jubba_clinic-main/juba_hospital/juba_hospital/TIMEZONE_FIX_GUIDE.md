# Timezone Fix Guide - Deployed Server

## Step-by-Step Process

### Step 1: Run Diagnostic Script
1. Open SQL Server Management Studio
2. Connect to your **DEPLOYED** server
3. Open and run: `CHECK_DEPLOYED_SERVER_TIMEZONE.sql`
4. Review the output carefully

---

## Step 2: Identify Your Issue

### Common Scenarios:

#### Scenario A: Dates are 3 hours in the FUTURE
**Symptoms:**
- Patients registered "today" show tomorrow's date
- Prescriptions show future times
- Reports show future dates

**Cause:** Server is UTC, but application is adding EAT offset

**Solution:** Run OPTION 1 in `FIX_TIMEZONE_ISSUES.sql`

---

#### Scenario B: Dates are 3 hours in the PAST
**Symptoms:**
- Current time shows 3 hours behind
- Today's patients show yesterday's date
- Reports are 3 hours behind

**Cause:** Server is EAT, but application is subtracting offset

**Solution:** Run OPTION 2 in `FIX_TIMEZONE_ISSUES.sql`

---

#### Scenario C: Server is UTC (Offset = 0)
**Symptoms:**
- `ActualOffsetHours = 0` in diagnostic report
- Server time matches UTC, not local time

**Solution:** 
1. Accept server is UTC
2. Use timezone helper functions in queries
3. OR: Configure Windows Server timezone to EAT

---

#### Scenario D: Server is EAT (Offset = +3)
**Symptoms:**
- `ActualOffsetHours = 3` in diagnostic report
- Server time matches local Somalia/Kenya time

**Solution:** Server timezone is correct! Check application code.

---

## Step 3: Apply the Fix

### For Scenario A (Future Dates):

```sql
-- 1. Backup first!
BACKUP DATABASE [jubba_clinick] 
TO DISK = 'C:\Backup\jubba_clinick_before_timezone_fix.bak'
GO

-- 2. Run OPTION 1 from FIX_TIMEZONE_ISSUES.sql
USE [jubba_clinick]
GO

-- Fix patient dates
UPDATE patient
SET registration_date = DATEADD(HOUR, -3, registration_date)
WHERE registration_date > GETDATE()

-- Fix prescription dates  
UPDATE prescribtion
SET created_date = DATEADD(HOUR, -3, created_date)
WHERE created_date > GETDATE()

-- Fix pharmacy sales
UPDATE pharmacy_sales
SET sale_date = DATEADD(HOUR, -3, sale_date)
WHERE sale_date > GETDATE()

-- Verify
SELECT COUNT(*) AS FutureDates FROM patient WHERE registration_date > GETDATE()
-- Should return 0
```

---

### For Scenario B (Past Dates):

```sql
-- Run OPTION 2 from FIX_TIMEZONE_ISSUES.sql
UPDATE patient
SET registration_date = DATEADD(HOUR, 3, registration_date)

UPDATE prescribtion
SET created_date = DATEADD(HOUR, 3, created_date)

UPDATE pharmacy_sales
SET sale_date = DATEADD(HOUR, 3, sale_date)
```

---

## Step 4: Test on Deployed Server

### Test Checklist:

1. **Register a new patient**
   - Check registration date matches current date/time
   - Should NOT be in future or past

2. **Create a prescription**
   - Check created_date is current
   - Should match your wall clock

3. **Make a pharmacy sale**
   - Check sale_date is correct
   - Should be "now"

4. **View reports**
   - Today's report should show today's data
   - Date filters should work correctly

---

## Quick Reference: Timezone Offsets

| Timezone | UTC Offset | Example |
|----------|-----------|---------|
| UTC (Universal) | +0:00 | 12:00 PM |
| EAT (East Africa - Somalia/Kenya) | +3:00 | 3:00 PM |

**Somalia uses EAT (UTC+3) - No daylight saving time**

---

## Files Provided

1. **CHECK_DEPLOYED_SERVER_TIMEZONE.sql** - Diagnostic script (run first)
2. **FIX_TIMEZONE_ISSUES.sql** - Fix script with multiple options
3. **TIMEZONE_FIX_GUIDE.md** - This guide

Run them in order: Diagnose → Fix → Verify
