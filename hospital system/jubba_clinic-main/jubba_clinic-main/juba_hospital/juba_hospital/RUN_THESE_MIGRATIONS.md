# ⚡ Quick Migration Guide

## Run These 2 SQL Scripts in Order:

### 1️⃣ **First Migration: ADD_LAB_REORDER_TRACKING.sql**
**What it does:** Adds tracking for follow-up orders

**How to run:**
1. Open SQL Server Management Studio
2. Open file: `ADD_LAB_REORDER_TRACKING.sql`
3. Select database: `juba_clinick`
4. Press F5 (Execute)

**Expected message:**
```
Lab test reorder tracking columns added successfully
```

---

### 2️⃣ **Second Migration: ADD_LAB_ORDER_LINK.sql**
**What it does:** Links results to specific orders

**How to run:**
1. In SQL Server Management Studio
2. Open file: `ADD_LAB_ORDER_LINK.sql`
3. Database should still be `juba_clinick`
4. Press F5 (Execute)

**Expected message:**
```
Added lab_test_id column to lab_results table
Added foreign key constraint FK_lab_results_lab_test
Created index IX_lab_results_lab_test_id
```

---

## ✅ That's It!

After running both scripts:
- Build your Visual Studio project
- Test the "Order Lab Tests" feature
- Lab staff will see orders with follow-up indicators

---

## 📖 Need Details?

See `DATABASE_MIGRATION_GUIDE.md` for:
- Detailed instructions
- Verification queries
- Troubleshooting
- Rollback procedures

---

**Time needed:** 2 minutes  
**Safe:** Yes, all columns allow NULL  
**Reversible:** Yes, see full guide
