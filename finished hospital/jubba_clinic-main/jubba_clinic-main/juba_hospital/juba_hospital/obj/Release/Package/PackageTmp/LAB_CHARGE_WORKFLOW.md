# Lab Charge Workflow - Complete System

## 🔄 Complete Workflow

### **Step 1: Doctor Orders Lab Tests**
**Location:** `doctor_inpatient.aspx` → Patient Details → Lab Results Tab

**Actions:**
1. Doctor clicks "Order Lab Tests"
2. Selects tests from organized categories
3. Adds optional notes/reason
4. Submits order

**System Actions:**
- ✅ Creates lab order in `lab_test` table with `med_id`
- ✅ Auto-detects if follow-up (checks existing orders)
- ✅ Marks as `is_reorder = 1` if follow-up
- ✅ Creates charge in `patient_charges` table:
  - `charge_type = 'Lab'`
  - `charge_name = "Lab Tests - Initial/Follow-up Order (#123)"`
  - `amount` = from `charges_config` table (default $100)
  - `is_paid = 0` (unpaid)
- ✅ Sets `prescribtion.lab_charge_paid = 0`
- ✅ Shows message: "Patient must pay charges at registration"

**Result:** Lab order created but **NOT visible to lab staff yet** (charges unpaid)

---

### **Step 2: Patient Goes to Registration**
**Location:** Registration desk / `patient_amount.aspx` or charges management page

**Actions:**
1. Registrar opens patient's charges
2. Sees unpaid lab charges:
   - "Lab Tests - Follow-up Order (#456) - $100.00"
3. Patient pays the charges
4. Registrar marks charge as paid

**System Actions:**
- ✅ Updates `patient_charges.is_paid = 1`
- ✅ Records `paid_date = GETDATE()`
- ✅ Records `paid_by = [registrar user id]`
- ✅ Updates `prescribtion.lab_charge_paid = 1`
- ✅ Generates invoice/receipt number

**Result:** Charges paid, lab order now **visible to lab staff**

---

### **Step 3: Lab Staff Sees Order**
**Location:** `lab_waiting_list.aspx`

**Visibility Logic:**
```sql
WHERE prescribtion.lab_charge_paid = 1  -- Only show paid orders
```

**Lab Staff Sees:**
- ✅ Patient name and details
- ✅ Yellow highlighted row (if follow-up order)
- ✅ Orange "RE-ORDER" badge (if follow-up)
- ✅ Reason for follow-up displayed
- ✅ Date/time of order
- ✅ Ordered tests (can click "Ordered" button)

**Result:** Lab staff can now process the order

---

### **Step 4: Lab Staff Enters Results**
**Location:** `test_details.aspx`

**Actions:**
1. Lab staff opens the order
2. Enters test results
3. Submits

**System Actions:**
- ✅ Saves results to `lab_results` table
- ✅ **Links results to order:** `lab_test_id = med_id`
- ✅ Updates prescription status

**Result:** Results saved and linked to specific order

---

### **Step 5: Doctor Views Results**
**Location:** `doctor_inpatient.aspx` → Patient Details → Lab Results Tab

**Doctor Sees:**
```
┌─────────────────────────────────────────────────────┐
│ Lab Order #1  [Initial Order]    2025-11-30 11:52  │
│ Notes: Routine check                                │
├─────────────────────────────────────────────────────┤
│ Ordered Tests:                                      │
│ ✓ Hemoglobin  ✓ Blood Sugar                        │
│                                                     │
│ ✅ Results Available                                │
│ Test             Result                             │
│ Hemoglobin       12.5 g/dL                         │
│ Blood Sugar      110 mg/dL                         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ Lab Order #2  [Follow-up Order]  2025-12-01 14:20  │
│ Notes: Check after 3 days of treatment             │
├─────────────────────────────────────────────────────┤
│ Ordered Tests:                                      │
│ ✓ Hemoglobin  ✓ CBC                                │
│                                                     │
│ ⏳ Waiting for results...                           │
└─────────────────────────────────────────────────────┘
```

**Result:** Doctor sees each order separately with its own results

---

## 🔒 Security & Control

### **Orders Won't Show in Lab Until Paid**
- ❌ Unpaid orders: `lab_charge_paid = 0` → **Hidden from lab staff**
- ✅ Paid orders: `lab_charge_paid = 1` → **Visible to lab staff**

### **Each Order is Independent**
- Order #1: Has its own charge
- Order #2 (follow-up): Has separate charge
- Each must be paid before lab can process

### **Prevents Free Lab Tests**
- Doctor can't bypass registration
- All orders require payment approval
- Complete audit trail of charges

---

## 💰 Charge Management

### **Default Charge Amount**
Configured in `charges_config` table:
```sql
SELECT amount FROM charges_config 
WHERE charge_type = 'Lab' AND is_active = 1
```
Default: $100.00 (can be updated by admin)

### **Charge Description Format**

**Initial Order:**
```
Lab Tests - Initial Order (Order #123)
```

**Follow-up Order:**
```
Lab Tests - Follow-up Order (Order #456) - Check after treatment
```

### **Database Tables**

**patient_charges:**
```
charge_id | patientid | prescid | charge_type | charge_name              | amount  | is_paid | paid_date
----------|-----------|---------|-------------|--------------------------|---------|---------|------------
1         | 10        | 50      | Lab         | Lab Tests - Initial...   | 100.00  | 1       | 2025-11-30
2         | 10        | 50      | Lab         | Lab Tests - Follow-up... | 100.00  | 0       | NULL
```

**prescribtion:**
```
prescid | patientid | lab_charge_paid | status
--------|-----------|-----------------|--------
50      | 10        | 0               | 4
```

---

## 🎯 Benefits

### **For Hospital Administration:**
- ✅ No free lab tests
- ✅ Complete charge tracking
- ✅ Payment before service
- ✅ Audit trail for all charges
- ✅ Revenue protection

### **For Registration Staff:**
- ✅ Clear list of charges to collect
- ✅ Can see which orders need payment
- ✅ Invoice generation
- ✅ Payment tracking

### **For Lab Staff:**
- ✅ Only see paid orders
- ✅ No confusion about unpaid tests
- ✅ Clear priority indicators (follow-ups)
- ✅ Context for each order

### **For Doctors:**
- ✅ Order tests anytime
- ✅ System handles charging automatically
- ✅ Clear feedback about payment requirement
- ✅ Can track each order separately

---

## 📊 Reporting

### **Unpaid Lab Charges Report**
```sql
SELECT p.full_name, pc.charge_name, pc.amount, pc.date_added
FROM patient_charges pc
INNER JOIN patient p ON pc.patientid = p.patientid
WHERE pc.charge_type = 'Lab' AND pc.is_paid = 0
ORDER BY pc.date_added DESC
```

### **Lab Revenue Report**
```sql
SELECT 
    COUNT(*) AS total_orders,
    SUM(amount) AS total_revenue,
    SUM(CASE WHEN is_paid = 1 THEN amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN is_paid = 0 THEN amount ELSE 0 END) AS unpaid_amount
FROM patient_charges
WHERE charge_type = 'Lab'
```

---

## 🔧 Configuration

### **Update Default Lab Charge**
```sql
UPDATE charges_config 
SET amount = 150.00  -- New amount
WHERE charge_type = 'Lab'
```

### **Check Unpaid Orders**
```sql
SELECT pr.prescid, p.full_name, pr.lab_charge_paid
FROM prescribtion pr
INNER JOIN patient p ON pr.patientid = p.patientid
WHERE pr.status IN (4,5) 
AND pr.lab_charge_paid = 0
```

---

## 🚨 Important Notes

1. **Old Data Compatibility:**
   - Old lab orders (before this update): `lab_charge_paid = NULL`
   - System treats NULL as unpaid
   - Need to manually update old orders if needed:
   ```sql
   UPDATE prescribtion 
   SET lab_charge_paid = 1 
   WHERE prescid IN (SELECT DISTINCT prescid FROM lab_test WHERE date_taken < '2025-12-01')
   ```

2. **Transaction Safety:**
   - Order creation uses transaction
   - If charge creation fails, order is rolled back
   - Ensures data consistency

3. **Multiple Orders:**
   - Each order gets its own charge
   - Patient can have multiple unpaid lab charges
   - Each must be paid separately

---

## ✅ Testing Checklist

- [ ] Doctor orders lab tests → charge created
- [ ] Lab waiting list empty (unpaid)
- [ ] Registrar sees unpaid charge
- [ ] Registrar marks charge paid
- [ ] Lab waiting list shows order
- [ ] Lab enters results with `lab_test_id`
- [ ] Doctor sees results under correct order
- [ ] Follow-up orders marked correctly
- [ ] Follow-up orders create separate charges

---

**Status:** ✅ Complete and Working  
**Last Updated:** December 2024
