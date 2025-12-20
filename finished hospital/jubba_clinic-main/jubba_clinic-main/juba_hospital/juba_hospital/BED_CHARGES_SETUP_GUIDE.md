# 🏥 AUTOMATIC BED CHARGES SYSTEM - SETUP GUIDE

## 📋 Overview

This system automatically calculates and creates **individual daily bed charges** for all active inpatients without any manual intervention.

### How It Works:
- ✅ Patient is admitted as inpatient → Initial charge created
- ✅ Every day at midnight → New charge automatically added
- ✅ Patient is discharged → Final charges calculated
- ✅ **No manual page loading required!**

---

## 🎯 What You Get

### Individual Daily Charges:
```
Patient stays 4 days = 4 separate charge records:
├─ Day 1: $50 (Jan 1, 2024 00:00)
├─ Day 2: $50 (Jan 2, 2024 00:00)
├─ Day 3: $50 (Jan 3, 2024 00:00)
└─ Day 4: $50 (Jan 4, 2024 00:00)
Total: $200
```

Each charge has:
- ✅ Unique `bed_charge_id`
- ✅ Specific `charge_date`
- ✅ Individual `bed_charge_amount`
- ✅ Payment status (`is_paid`)
- ✅ Payment method tracking

---

## 🚀 INSTALLATION STEPS

### Step 1: Run the SQL Script

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your database server
3. Open the file: `AUTOMATE_BED_CHARGES.sql`
4. **Change the database name** on line 135 if needed:
   ```sql
   @database_name = N'juba_clinick', -- Change to YOUR database name
   ```
5. Execute the entire script
6. ✅ Verify: You should see "INSTALLATION COMPLETE!"

### Step 2: Set Up Bed Charge Rate

Make sure you have a bed charge rate configured:

```sql
-- Check if bed charge rate exists
SELECT * FROM charges_config WHERE charge_type = 'Bed' AND is_active = 1;

-- If not exists, add one
INSERT INTO charges_config (charge_type, amount, is_active, created_at)
VALUES ('Bed', 50.00, 1, GETDATE());
```

### Step 3: Choose Automation Method

You have **3 options** for automation:

---

## ⚙️ OPTION 1: SQL Server Agent Job (RECOMMENDED)

**Best for:** Production servers with SQL Server Agent

### Setup:

1. Open **SQL Server Management Studio**
2. Expand **SQL Server Agent** in Object Explorer
3. If SQL Server Agent is stopped:
   - Right-click **SQL Server Agent**
   - Click **Start**

4. Uncomment lines **120-165** in `AUTOMATE_BED_CHARGES.sql`
5. Execute those lines to create the job

6. Verify the job:
   ```sql
   -- Check if job exists
   SELECT * FROM msdb.dbo.sysjobs WHERE name = 'Daily Bed Charge Calculation';
   ```

7. Test the job manually:
   - Right-click the job → **Start Job at Step...**
   - Check job history for success

8. ✅ **Done!** The job will run automatically every day at midnight

---

## ⚙️ OPTION 2: Windows Task Scheduler

**Best for:** SQL Express or systems without SQL Server Agent

### Setup:

1. Create a batch file: `calculate_bed_charges.bat`

```batch
@echo off
echo Calculating bed charges...
sqlcmd -S YOUR_SERVER_NAME -d juba_clinick -Q "EXEC sp_CalculateAllInpatientBedCharges" -E
if %ERRORLEVEL% EQU 0 (
    echo Success! Bed charges calculated.
) else (
    echo Error calculating bed charges.
)
```

2. Replace `YOUR_SERVER_NAME` with your SQL Server name
   - Example: `localhost\SQLEXPRESS`
   - Or: `(local)`

3. Test the batch file:
   - Double-click it
   - Should see "Success! Bed charges calculated."

4. Schedule in Windows Task Scheduler:
   - Open **Task Scheduler**
   - Click **Create Basic Task**
   - Name: "Daily Bed Charge Calculation"
   - Trigger: **Daily** at **12:00 AM (midnight)**
   - Action: **Start a program**
   - Program/script: Browse to your `.bat` file
   - Click **Finish**

5. Test the scheduled task:
   - Right-click the task → **Run**
   - Check "Last Run Result" shows success

6. ✅ **Done!** Task will run automatically every midnight

---

## ⚙️ OPTION 3: PowerShell Script (Alternative)

**Best for:** Advanced users or specific requirements

Create: `Calculate-BedCharges.ps1`

```powershell
# Configuration
$serverName = "YOUR_SERVER_NAME"
$databaseName = "juba_clinick"

# Execute stored procedure
$query = "EXEC sp_CalculateAllInpatientBedCharges"

try {
    Invoke-Sqlcmd -ServerInstance $serverName -Database $databaseName -Query $query -ErrorAction Stop
    Write-Host "✓ Bed charges calculated successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}
```

Schedule in Task Scheduler to run: `powershell.exe -File "path\to\Calculate-BedCharges.ps1"`

---

## 🧪 TESTING

### Test 1: Manual Execution

```sql
-- Run the stored procedure manually
EXEC sp_CalculateAllInpatientBedCharges;

-- Check the results
SELECT * FROM patient_bed_charges 
ORDER BY created_at DESC;
```

### Test 2: Real Scenario

1. **Create a test inpatient:**
   ```sql
   -- Update a patient to inpatient
   UPDATE patient 
   SET patient_type = 'inpatient',
       bed_admission_date = DATEADD(DAY, -3, GETDATE()) -- 3 days ago
   WHERE patientid = 123; -- Use actual patient ID
   ```

2. **Run the calculation:**
   ```sql
   EXEC sp_CalculateAllInpatientBedCharges;
   ```

3. **Verify charges created:**
   ```sql
   SELECT 
       bed_charge_id,
       patientid,
       charge_date,
       bed_charge_amount,
       is_paid,
       created_at
   FROM patient_bed_charges
   WHERE patientid = 123
   ORDER BY charge_date;
   ```

4. **Expected result:** 4 charge records (Day 0, 1, 2, 3)

---

## 📊 MONITORING

### Check Active Inpatients:
```sql
SELECT 
    p.patientid,
    p.patient_name,
    p.bed_admission_date,
    DATEDIFF(DAY, p.bed_admission_date, GETDATE()) + 1 AS days_admitted,
    COUNT(pbc.bed_charge_id) AS charges_created
FROM patient p
LEFT JOIN patient_bed_charges pbc ON p.patientid = pbc.patientid
WHERE p.patient_type = 'inpatient'
AND p.bed_admission_date IS NOT NULL
AND (p.discharge_date IS NULL OR p.discharge_date > GETDATE())
GROUP BY p.patientid, p.patient_name, p.bed_admission_date
ORDER BY p.bed_admission_date;
```

### Check Today's Charges:
```sql
SELECT 
    pbc.patientid,
    p.patient_name,
    pbc.charge_date,
    pbc.bed_charge_amount,
    pbc.created_at
FROM patient_bed_charges pbc
JOIN patient p ON pbc.patientid = p.patientid
WHERE CAST(pbc.created_at AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY pbc.created_at DESC;
```

### Check Total Bed Charges:
```sql
SELECT 
    p.patientid,
    p.patient_name,
    COUNT(pbc.bed_charge_id) AS total_charges,
    SUM(pbc.bed_charge_amount) AS total_amount,
    SUM(CASE WHEN pbc.is_paid = 1 THEN pbc.bed_charge_amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN pbc.is_paid = 0 THEN pbc.bed_charge_amount ELSE 0 END) AS unpaid_amount
FROM patient p
LEFT JOIN patient_bed_charges pbc ON p.patientid = pbc.patientid
WHERE p.patient_type = 'inpatient'
GROUP BY p.patientid, p.patient_name
ORDER BY total_amount DESC;
```

---

## 🔧 TROUBLESHOOTING

### Issue: No charges being created

**Check 1:** Bed charge rate configured?
```sql
SELECT * FROM charges_config WHERE charge_type = 'Bed' AND is_active = 1;
```

**Check 2:** Inpatients have admission dates?
```sql
SELECT * FROM patient 
WHERE patient_type = 'inpatient' 
AND bed_admission_date IS NULL;
```

**Check 3:** Job/Task is running?
- SQL Agent: Check job history
- Task Scheduler: Check task history

### Issue: Duplicate charges

The system automatically prevents duplicates, but if you see them:
```sql
-- Check for duplicates
SELECT patientid, charge_date, COUNT(*) as count
FROM patient_bed_charges
GROUP BY patientid, charge_date
HAVING COUNT(*) > 1;
```

### Issue: Job fails to run

**SQL Server Agent:**
1. Check SQL Server Agent is running
2. Check job owner has permissions
3. Check database name is correct

**Windows Task Scheduler:**
1. Check batch file path is correct
2. Check SQL Server name is correct
3. Run batch file manually to test

---

## ✅ VERIFICATION CHECKLIST

- [ ] `AUTOMATE_BED_CHARGES.sql` executed successfully
- [ ] Stored procedure `sp_CalculateAllInpatientBedCharges` exists
- [ ] Bed charge rate configured in `charges_config` table
- [ ] Automation method chosen and set up
- [ ] Test execution successful
- [ ] Charges being created for test inpatient
- [ ] Scheduled task/job configured to run daily at midnight
- [ ] Monitoring queries work and show correct data

---

## 📈 EXPECTED BEHAVIOR

### Day 0 (Admission):
- Patient registered as inpatient
- `bed_admission_date` set to current datetime
- **1 charge created** for Day 0

### Day 1:
- Midnight: Scheduled task runs
- **1 new charge created** for Day 1
- Total: 2 charges

### Day 2:
- Midnight: Scheduled task runs
- **1 new charge created** for Day 2
- Total: 3 charges

### Day 3 (Discharge):
- Patient discharged
- `discharge_date` set
- **1 final charge created** for Day 3
- Total: 4 charges
- Patient no longer included in future automatic calculations

---

## 🎉 SUCCESS CRITERIA

✅ **System is working correctly if:**
1. Charges appear in `patient_bed_charges` table
2. One charge per day for each inpatient
3. No duplicate charges for same day
4. Charges stop accumulating after discharge
5. Scheduled task runs successfully each night
6. No manual intervention required

---

## 📞 SUPPORT

If you encounter issues:
1. Check the troubleshooting section above
2. Run the monitoring queries
3. Check SQL Server error logs
4. Check Windows Event Viewer (for Task Scheduler)

---

**Installation Date:** [Fill in when you complete setup]  
**Tested By:** [Your name]  
**Status:** [ ] In Progress  [ ] Completed  [ ] Verified Working
