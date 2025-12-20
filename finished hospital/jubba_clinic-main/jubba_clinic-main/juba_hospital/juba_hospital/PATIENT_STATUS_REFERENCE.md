# 📊 Patient Status and Type Reference

## Database Schema

### `patient` table columns:
- **`patient_type`**: 'inpatient' or 'outpatient'
- **`patient_status`**: 0 = Active, 1 = Discharged

---

## Page Filtering Logic

### 1. **Inpatients List** (`registre_inpatients.aspx`)
**Should show:** Active inpatients only
```sql
WHERE (patient_type = 'inpatient' OR bed_admission_date IS NOT NULL) 
  AND patient_status = 0
```
**Current implementation:** ✅ Correct

---

### 2. **Outpatients List** (`registre_outpatients.aspx`)
**Should show:** Active outpatients only
```sql
WHERE (patient_type = 'outpatient' OR (patient_type IS NULL AND bed_admission_date IS NULL))
  AND patient_status = 0
```
**Current implementation:** ✅ Correct

---

### 3. **Discharged Patients** (`registre_discharged.aspx`)
**Should show:** All discharged patients (both inpatient and outpatient)
```sql
WHERE patient_status = 1
```
**Current implementation:** ✅ Correct

---

## Summary

All three pages are correctly filtering by:
- **Patient Type** (inpatient vs outpatient)
- **Patient Status** (0 = active, 1 = discharged)

### Current Queries:

**Inpatients:**
```sql
WHERE (p.patient_type = 'inpatient' OR p.bed_admission_date IS NOT NULL) 
      AND p.patient_status = 0
```
✅ Shows only active inpatients

**Outpatients:**
```sql
WHERE (p.patient_type = 'outpatient' OR (p.patient_type IS NULL AND p.bed_admission_date IS NULL))
      AND p.patient_status = 0
```
✅ Shows only active outpatients

**Discharged:**
```sql
WHERE p.patient_status = 1
```
✅ Shows all discharged patients regardless of type

---

## Patient Lifecycle

```
Registration → Active (status = 0) → Patient Type (inpatient/outpatient)
                ↓
        Inpatients List (if inpatient + status 0)
                OR
        Outpatients List (if outpatient + status 0)
                ↓
            Treatment/Care
                ↓
        Discharge (status = 1)
                ↓
        Discharged Patients List (status = 1, any type)
```

---

## Verification Query

Run this to see patient distribution:

```sql
SELECT 
    patient_type,
    patient_status,
    CASE patient_status 
        WHEN 0 THEN 'Active'
        WHEN 1 THEN 'Discharged'
        ELSE 'Unknown'
    END as status_label,
    COUNT(*) as count
FROM patient
GROUP BY patient_type, patient_status
ORDER BY patient_status, patient_type;
```

Expected output:
```
patient_type | patient_status | status_label | count
inpatient    | 0              | Active       | X
outpatient   | 0              | Active       | Y
inpatient    | 1              | Discharged   | A
outpatient   | 1              | Discharged   | B
```

---

✅ **All filtering logic is correct!**
