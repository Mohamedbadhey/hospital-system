# Patient Status Migration - COMPLETE GUIDE

## ✅ New Patient Status System

### Status Values:
- **0** = Outpatient
- **1** = Inpatient (Active/Admitted)
- **2** = Discharged

---

## 📝 Files Updated

### 1. **registre_inpatients.aspx.cs** ✅
- Changed: `patient_status = 0` → `patient_status = 1`
- Now shows: Active inpatients only

### 2. **registre_discharged.aspx.cs** ✅
- Changed: `patient_status = 1` → `patient_status = 2`
- Now shows: Discharged patients only

### 3. **admin_dashbourd.aspx.cs** ✅
- Changed: `patient_status = 0` → `patient_status = 0 OR patient_status = 1`
- Now shows: Both outpatients AND active inpatients

### 4. **patient_amount.aspx.cs** ✅
- Added status 2 = 'Discharged' to CASE statement

### 5. **patient_in.aspx.cs** ✅
- Added status 2 = 'Discharged' to CASE statement

### 6. **patient_status.aspx.cs** ✅
- Added status 2 = 'Discharged' to CASE statement

### 7. **register_inpatient.aspx.cs** ✅
- Already correct (patient_status = 1 for inpatients)

### 8. **admin_inpatient.aspx.cs** ✅
- Already correct (patient_status = 1 for inpatients)

### 9. **doctor_inpatient.aspx.cs** ✅
- Already correct (patient_status = 1 for inpatients)

---

## 🗄️ Database Migration Steps

### STEP 1: Run the SQL Migration Script
Execute: **`tmp_rovodev_update_patient_status_system.sql`**

This will:
1. Update all active inpatients from status 0 → 1
2. Update all discharged patients from status 1 → 2
3. Ensure all outpatients have status 0
4. Show before/after statistics

### STEP 2: Verify the Changes
After running the SQL script, you should see:

```sql
-- Check distribution
SELECT 
    patient_status,
    CASE 
        WHEN patient_status = 0 THEN 'Outpatient'
        WHEN patient_status = 1 THEN 'Inpatient (Active)'
        WHEN patient_status = 2 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_meaning,
    COUNT(*) as count
FROM patient
GROUP BY patient_status
ORDER BY patient_status;
```

### STEP 3: Rebuild and Deploy
1. Open solution in Visual Studio
2. Build solution (Ctrl+Shift+B)
3. Run application (F5)
4. Test all pages

---

## 🧪 Testing Checklist

### Test registre_inpatients.aspx
- [ ] Login as registration staff
- [ ] Navigate to Inpatients page
- [ ] Should show only active inpatients (status = 1)
- [ ] Should NOT show outpatients (status = 0)
- [ ] Should NOT show discharged patients (status = 2)

### Test registre_discharged.aspx
- [ ] Navigate to Discharged Patients page
- [ ] Should show only discharged patients (status = 2)
- [ ] Should NOT show active patients (status = 0 or 1)

### Test registre_outpatients.aspx
- [ ] Navigate to Outpatients page
- [ ] Should show only outpatients (status = 0)
- [ ] Should NOT show inpatients (status = 1 or 2)

### Test admin_dashbourd.aspx
- [ ] Login as admin
- [ ] Dashboard should show count of active patients (status 0 + 1)
- [ ] Should show both outpatients and active inpatients

---

## 📊 Page Behavior Summary

| Page | Status Filter | Shows |
|------|--------------|-------|
| `registre_outpatients.aspx` | `status = 0` | Outpatients only |
| `registre_inpatients.aspx` | `status = 1` | Active inpatients only |
| `registre_discharged.aspx` | `status = 2` | Discharged patients only |
| `admin_dashbourd.aspx` | `status = 0 OR 1` | All active patients |
| `doctor_inpatient.aspx` | `status = 1` | Active inpatients only |
| `register_inpatient.aspx` | `status = 1` | Active inpatients only |
| `admin_inpatient.aspx` | `status = 1` | Active inpatients only |

---

## 🔄 Patient Lifecycle

```
1. Registration
   ↓
   status = 0 (Outpatient)
   patient_type = 'outpatient'
   
2. If Admitted to Bed
   ↓
   status = 1 (Active Inpatient)
   patient_type = 'inpatient'
   bed_admission_date = [date]
   
3. Upon Discharge
   ↓
   status = 2 (Discharged)
   patient_type remains 'inpatient'
   bed_admission_date remains set
```

---

## 💡 When Updating Patient Status

### Admitting a Patient (Outpatient → Inpatient)
```sql
UPDATE patient 
SET patient_status = 1,
    patient_type = 'inpatient',
    bed_admission_date = GETDATE()
WHERE patientid = @patientId;
```

### Discharging a Patient (Inpatient → Discharged)
```sql
UPDATE patient 
SET patient_status = 2
WHERE patientid = @patientId;
```

### Re-admitting a Patient (if needed)
```sql
UPDATE patient 
SET patient_status = 1,
    bed_admission_date = GETDATE()
WHERE patientid = @patientId;
```

---

## 🚨 Important Notes

1. **Always use the new status values** in any new code:
   - 0 = Outpatient
   - 1 = Inpatient (Active)
   - 2 = Discharged

2. **Don't mix old and new status values** - run the migration script first

3. **Update any reports or queries** that reference patient_status

4. **Test thoroughly** before deploying to production

5. **Backup your database** before running the migration script

---

## 📞 Quick Reference

### Show Active Patients
```sql
WHERE patient_status IN (0, 1)  -- Outpatients + Active Inpatients
```

### Show Only Inpatients
```sql
WHERE patient_status = 1  -- Active Inpatients only
```

### Show All Inpatient Records (including discharged)
```sql
WHERE patient_type = 'inpatient'  -- All inpatient records
-- OR
WHERE patient_status IN (1, 2)  -- Active + Discharged inpatients
```

---

## ✅ Migration Checklist

- [x] Create SQL migration script
- [x] Update registre_inpatients.aspx.cs
- [x] Update registre_discharged.aspx.cs
- [x] Update admin_dashbourd.aspx.cs
- [x] Update patient_amount.aspx.cs
- [x] Update patient_in.aspx.cs
- [x] Update patient_status.aspx.cs
- [ ] Run SQL migration on database
- [ ] Test all registration pages
- [ ] Test all admin pages
- [ ] Test all doctor pages
- [ ] Verify reports work correctly
- [ ] Deploy to production

---

## 🎉 Next Steps

1. **Run the SQL script**: `tmp_rovodev_update_patient_status_system.sql`
2. **Rebuild the solution** in Visual Studio
3. **Test the application** using the checklist above
4. **Patient 1046 should now appear** on registre_inpatients.aspx after changing their status to 1

---

*Migration Guide Created: December 2025*
