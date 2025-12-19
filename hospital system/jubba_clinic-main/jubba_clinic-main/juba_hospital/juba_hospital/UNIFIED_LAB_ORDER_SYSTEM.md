# 🎯 Unified Lab Order System - Requirements & Implementation

## 📋 Current Situation

### **Two Systems for Ordering Lab Tests:**

1. **assingxray.aspx** (Outpatient)
   - Doctor selects all tests at once
   - Submits to lab
   - Old system

2. **doctor_inpatient.aspx** (Inpatient)
   - Doctor can order tests multiple times
   - Each order creates separate charge
   - New system with follow-up tracking

## 🎯 Requirements

### **1. Both Systems Should Work the Same Way**
- Unified workflow regardless of inpatient/outpatient
- Same charge creation logic
- Same payment control
- Same edit capabilities

### **2. Edit Capability Before Payment**
- **Before Payment:** Doctor can add/edit tests
- **After Payment:** No editing allowed (lab is processing)

### **3. Workflow:**

```
┌─────────────────────────────────────────────────────┐
│ Stage 1: Doctor Orders Tests (UNPAID)              │
├─────────────────────────────────────────────────────┤
│ • Doctor orders initial tests                       │
│ • System creates UNPAID charge                      │
│ • Status: EDITABLE ✏️                              │
│ • Can add more tests ✅                             │
│ • Can edit order ✅                                 │
│ • Lab CANNOT see yet ❌                             │
└─────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────┐
│ Doctor Can Add More Tests                          │
├─────────────────────────────────────────────────────┤
│ • Doctor: "Add Blood Sugar to existing order"      │
│ • System: Updates lab_test record                  │
│ • Charge: Still UNPAID (no new charge)             │
│ • Status: Still EDITABLE ✏️                        │
└─────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────┐
│ Stage 2: Payment Processed                         │
├─────────────────────────────────────────────────────┤
│ • Registrar marks charge as PAID                    │
│ • Status: LOCKED 🔒                                │
│ • Cannot edit anymore ❌                            │
│ • Cannot add more tests ❌                          │
│ • Lab CAN NOW see ✅                                │
└─────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────┐
│ Stage 3: Lab Processes                             │
├─────────────────────────────────────────────────────┤
│ • Lab enters results                                │
│ • Doctor can only VIEW ✅                           │
│ • Doctor CANNOT edit or add ❌                      │
└─────────────────────────────────────────────────────┘
```

## 🔧 Implementation Plan

### **1. Unified Order System**

**Single lab_test record per prescription (until paid)**
```sql
-- One order per prescription
-- Can update/add tests until paid
SELECT * FROM lab_test 
WHERE prescid = 123 
AND lab_charge_paid = 0  -- Unpaid = Editable
```

**Once paid, cannot edit:**
```sql
SELECT * FROM lab_test 
WHERE prescid = 123 
AND lab_charge_paid = 1  -- Paid = Locked
```

### **2. Doctor UI Changes**

**Show Current Order Status:**
```
┌─────────────────────────────────────────────────────┐
│ Current Lab Order: #1234                            │
├─────────────────────────────────────────────────────┤
│ Status: UNPAID - Editable ✏️                       │
│                                                     │
│ Ordered Tests:                                      │
│ • Hemoglobin                                        │
│ • Blood Sugar                                       │
│                                                     │
│ [✏️ Edit Order] [➕ Add Tests] [❌ Cancel Order]   │
└─────────────────────────────────────────────────────┘
```

**After Payment:**
```
┌─────────────────────────────────────────────────────┐
│ Lab Order #1234                                     │
├─────────────────────────────────────────────────────┤
│ Status: PAID - Awaiting Results 🔒                 │
│                                                     │
│ Ordered Tests:                                      │
│ • Hemoglobin                                        │
│ • Blood Sugar                                       │
│                                                     │
│ [👁️ View Only] - Cannot edit after payment         │
└─────────────────────────────────────────────────────┘
```

### **3. Technical Implementation**

**Check if editable:**
```csharp
public static bool CanEditOrder(string prescid)
{
    // Check if order exists and is unpaid
    string query = @"
        SELECT lab_charge_paid 
        FROM prescribtion 
        WHERE prescid = @prescid";
    
    // If lab_charge_paid = 0, can edit
    // If lab_charge_paid = 1, cannot edit
}
```

**Update existing order (add tests):**
```csharp
public static string AddTestsToOrder(string prescid, List<string> newTests)
{
    // 1. Check if order is editable
    if (!CanEditOrder(prescid))
        return "Error: Cannot edit paid orders";
    
    // 2. Update existing lab_test record
    //    Set new test columns to 'on'
    
    // 3. No new charge created (uses existing unpaid charge)
}
```

## 💡 Benefits

### **For Doctors:**
- ✅ Can add tests as needed (before payment)
- ✅ Don't have to order everything at once
- ✅ Can fix mistakes before payment
- ✅ Clear status indicators (editable vs locked)

### **For Patients:**
- ✅ One charge for all tests (not multiple)
- ✅ Pay once for all tests ordered so far
- ✅ No surprise charges

### **For Registration:**
- ✅ Simple: One charge per order
- ✅ Clear: Unpaid = still being edited
- ✅ After payment: No changes allowed

### **For Lab:**
- ✅ Only sees finalized orders (paid)
- ✅ No confusion about incomplete orders
- ✅ Clear what to process

## 🚀 Next Steps

1. **Unify doctor_inpatient.aspx and assingxray.aspx logic**
2. **Add "Edit Order" functionality**
3. **Add "Add Tests" functionality**
4. **Lock orders after payment**
5. **Show status indicators to doctor**
6. **Test complete workflow**

---

## ❓ Questions for Confirmation

1. **Should there be ONE lab order per prescription?** (Can add tests to it until paid)
2. **Or multiple orders per prescription?** (Separate follow-up orders with separate charges)
3. **Can doctor create new order after first is paid?** (For follow-up tests)

---

**Recommended Approach:**
- **One active order per prescription** (unpaid = editable)
- **After payment:** Can create NEW order for follow-up (separate charge)
- **Each paid order is independent** with its own results

This gives flexibility while keeping things simple and controlled.
