# Database Migration Guide - Lab Order System

## Overview
This guide will help you run the database migrations needed for the lab order tracking system.

---

## 📋 **Prerequisites**

- SQL Server Management Studio (SSMS) installed
- Access to your `juba_clinick` database
- Database backup created (for safety)

---

## 🔒 **Step 0: Backup Your Database (IMPORTANT!)**

Before running any migration, always backup your database:

```sql
-- In SQL Server Management Studio
-- Right-click on juba_clinick database → Tasks → Back Up...
-- Or run this:
BACKUP DATABASE juba_clinick 
TO DISK = 'C:\Backup\juba_clinick_backup_before_lab_migration.bak'
WITH FORMAT, INIT, NAME = 'Full Backup Before Lab Migration';
```

---

## 🚀 **Migration Steps**

### **Migration 1: Add Lab Reorder Tracking**

This adds columns to track which orders are follow-ups.

**File:** `ADD_LAB_REORDER_TRACKING.sql`

**Steps:**
1. Open SQL Server Management Studio
2. Connect to your SQL Server
3. Click **File → Open → File**
4. Navigate to: `juba_hospital\ADD_LAB_REORDER_TRACKING.sql`
5. Make sure `juba_clinick` database is selected in the dropdown
6. Press **F5** or click **Execute**

**Expected Output:**
```
Lab test reorder tracking columns added successfully
```

**What This Does:**
- Adds `is_reorder` column (BIT) - marks follow-up orders
- Adds `reorder_reason` column (NVARCHAR) - stores notes
- Adds `original_order_id` column (INT) - for future use
- Creates performance indexes

---

### **Migration 2: Add Lab Order Link**

This links results to specific orders.

**File:** `ADD_LAB_ORDER_LINK.sql`

**Steps:**
1. In SQL Server Management Studio
2. Click **File → Open → File**
3. Navigate to: `juba_hospital\ADD_LAB_ORDER_LINK.sql`
4. Make sure `juba_clinick` database is selected
5. Press **F5** or click **Execute**

**Expected Output:**
```
Added lab_test_id column to lab_results table
Added foreign key constraint FK_lab_results_lab_test
Created index IX_lab_results_lab_test_id

=================================================================
IMPORTANT: Update lab entry pages to include lab_test_id
When lab staff enters results, they should specify which order
the results are for by including the lab_test_id value.
=================================================================
```

**What This Does:**
- Adds `lab_test_id` column to `lab_results` table
- Creates foreign key to `lab_test` table
- Creates index for performance
- Allows linking each result to its specific order

---

## ✅ **Verify Migrations**

After running both migrations, verify they worked:

```sql
-- Check lab_test table has new columns
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'lab_test'
AND COLUMN_NAME IN ('is_reorder', 'reorder_reason', 'original_order_id')
ORDER BY COLUMN_NAME;

-- Should return 3 rows

-- Check lab_results table has new column
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'lab_results'
AND COLUMN_NAME = 'lab_test_id';

-- Should return 1 row

-- Check foreign key exists
SELECT name, OBJECT_NAME(parent_object_id) AS table_name
FROM sys.foreign_keys
WHERE name = 'FK_lab_results_lab_test';

-- Should return 1 row
```

**Expected Results:**

**lab_test columns:**
| COLUMN_NAME | DATA_TYPE | IS_NULLABLE |
|-------------|-----------|-------------|
| is_reorder | bit | YES |
| original_order_id | int | YES |
| reorder_reason | nvarchar | YES |

**lab_results column:**
| COLUMN_NAME | DATA_TYPE | IS_NULLABLE |
|-------------|-----------|-------------|
| lab_test_id | int | YES |

**Foreign key:**
| name | table_name |
|------|------------|
| FK_lab_results_lab_test | lab_results |

---

## 🔄 **What Happens to Existing Data?**

### **Safe for Existing Data:**
- ✅ All new columns allow NULL values
- ✅ Existing rows will have NULL in new columns
- ✅ No data is deleted or modified
- ✅ Existing functionality continues to work

### **For Old Lab Results:**
- Old results (before migration) won't be linked to specific orders
- They'll still show up in the system
- Only new results (after migration) will be linked

### **For Old Lab Orders:**
- Old orders will show `is_reorder = 0` (not a follow-up)
- No reason/notes saved (NULL)
- Still visible and functional

---

## 🔧 **Post-Migration Updates**

After running migrations, you need to update the lab entry pages to save the `lab_test_id` when entering results.

### **Files to Update:**

1. **`lap_operation.aspx.cs`** - Lab result entry page
2. **`take_lab_test.aspx.cs`** - Lab test taking page

### **What to Add:**

When lab staff enters results, they need to know which order they're entering results for.

**Example change needed:**
```csharp
// OLD - just saves prescid
INSERT INTO lab_results (prescid, Hemoglobin, Blood_sugar, ...)
VALUES (@prescid, @hemoglobin, @bloodsugar, ...)

// NEW - also saves lab_test_id
INSERT INTO lab_results (prescid, lab_test_id, Hemoglobin, Blood_sugar, ...)
VALUES (@prescid, @labTestId, @hemoglobin, @bloodsugar, ...)
```

**The lab staff needs to select which order** from a dropdown when entering results.

---

## 📊 **Testing After Migration**

### **Test 1: Doctor Orders Tests**
1. Login as doctor
2. Go to Inpatient Management
3. View a patient
4. Click "Order Lab Tests"
5. Select some tests, add notes
6. Submit

**Verify in Database:**
```sql
SELECT lab_test_id, prescid, is_reorder, reorder_reason, date_taken
FROM lab_test
WHERE prescid = [your_test_prescid]
ORDER BY date_taken DESC;
```

Should show the new order with `is_reorder = 0` for first order.

### **Test 2: Doctor Orders Again (Follow-up)**
1. Same patient, order more tests
2. Submit

**Verify:**
```sql
SELECT lab_test_id, prescid, is_reorder, reorder_reason, date_taken
FROM lab_test
WHERE prescid = [your_test_prescid]
ORDER BY date_taken DESC;
```

Should show second order with `is_reorder = 1`.

### **Test 3: Lab Enters Results**
1. Login as lab staff
2. Enter results for one of the orders
3. (After lab pages are updated) Select which order from dropdown

**Verify:**
```sql
SELECT lr.lab_result_id, lr.prescid, lr.lab_test_id, lt.date_taken
FROM lab_results lr
LEFT JOIN lab_test lt ON lr.lab_test_id = lt.lab_test_id
WHERE lr.prescid = [your_test_prescid];
```

Should show results linked to specific order.

---

## ⚠️ **Troubleshooting**

### **Error: "Column already exists"**
```
Msg 2705: Column names in each table must be unique.
```
**Solution:** The column already exists. Skip that migration or check if it was run before.

### **Error: "Foreign key conflict"**
```
The ALTER TABLE statement conflicted with the FOREIGN KEY constraint
```
**Solution:** There's data that doesn't match. Check for orphaned records:
```sql
-- Find lab_results with invalid lab_test_id
SELECT lr.*
FROM lab_results lr
LEFT JOIN lab_test lt ON lr.lab_test_id = lt.lab_test_id
WHERE lr.lab_test_id IS NOT NULL 
AND lt.lab_test_id IS NULL;
```

### **Error: "Permission denied"**
```
The user does not have permission to perform this action.
```
**Solution:** You need ALTER TABLE permissions. Contact your DBA or login as `sa`.

---

## 🔙 **Rollback (If Needed)**

If something goes wrong, you can rollback the migrations:

```sql
-- Remove from lab_results
ALTER TABLE lab_results DROP CONSTRAINT FK_lab_results_lab_test;
ALTER TABLE lab_results DROP COLUMN lab_test_id;

-- Remove from lab_test
ALTER TABLE lab_test DROP COLUMN is_reorder;
ALTER TABLE lab_test DROP COLUMN reorder_reason;
ALTER TABLE lab_test DROP COLUMN original_order_id;
```

Or restore from your backup:
```sql
RESTORE DATABASE juba_clinick 
FROM DISK = 'C:\Backup\juba_clinick_backup_before_lab_migration.bak'
WITH REPLACE;
```

---

## 📝 **Migration Log**

Keep a record of when you ran migrations:

| Date | Migration | Status | Run By | Notes |
|------|-----------|--------|--------|-------|
| ________ | ADD_LAB_REORDER_TRACKING.sql | ⬜ | ________ | ____________ |
| ________ | ADD_LAB_ORDER_LINK.sql | ⬜ | ________ | ____________ |

---

## ✅ **Completion Checklist**

- [ ] Database backed up
- [ ] Migration 1 run successfully (reorder tracking)
- [ ] Migration 2 run successfully (order link)
- [ ] Verification queries run and passed
- [ ] Test order created by doctor
- [ ] Test follow-up order created
- [ ] Database structure verified
- [ ] Lab entry pages identified for update
- [ ] Migration logged

---

## 🎯 **Next Steps After Migration**

1. ✅ **Migrations complete** - Database ready
2. ⏳ **Update lab entry pages** - Add lab_test_id dropdown
3. ⏳ **Test complete workflow** - Order → Enter Results → View
4. ⏳ **Train staff** - Show new features

---

## 📞 **Need Help?**

If you encounter issues:
1. Check the troubleshooting section above
2. Verify your SQL Server version (should be 2012+)
3. Make sure you have necessary permissions
4. Check error messages in SSMS
5. Verify database backup exists before making changes

---

**Last Updated:** December 2024  
**Status:** Ready to Run  
**Estimated Time:** 5 minutes
