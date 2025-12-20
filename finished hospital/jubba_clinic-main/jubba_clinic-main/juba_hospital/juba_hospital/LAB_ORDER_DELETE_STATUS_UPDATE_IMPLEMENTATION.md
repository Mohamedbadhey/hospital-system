# Lab Order Deletion with Automatic Status Update - Implementation

## Overview
Implemented automatic lab status update functionality when lab orders are deleted and no lab orders remain for a prescription.

## Problem Solved
Previously, when deleting lab orders, the prescription's lab status would remain as "pending-lab" (status = 4) or "lab-processed" (status = 5) even when all lab orders were removed. This created inconsistent state where patients showed lab status but had no actual lab orders.

## Solution Implemented

### Logic Flow
1. **Before Deletion**: Get the prescription ID from the lab order being deleted
2. **Delete Order**: Remove the lab order, associated charges, and results as before
3. **Check Remaining Orders**: Count how many lab orders remain for this prescription
4. **Update Status**: If no lab orders remain (count = 0), update the prescription status back to "waiting" (status = 0)

### Status Transitions
When the last lab order is deleted:
- `status = 4` (pending-lab) → `status = 0` (waiting)
- `status = 5` (lab-processed) → `status = 0` (waiting)
- Other statuses remain unchanged

## Files Modified

### 1. assignmed.aspx.cs
**Method**: `DeleteLabOrder(int orderId)`
**Lines**: ~1087-1140

### 2. doctor_inpatient.aspx.cs  
**Method**: `DeleteLabOrder(int orderId)`
**Lines**: ~903-956

## Code Implementation

```csharp
// Get the prescription ID before deleting the lab order
string prescriptionId = "";
string getPrescidQuery = "SELECT prescid FROM lab_test WHERE med_id = @orderId";
using (SqlCommand cmd = new SqlCommand(getPrescidQuery, con))
{
    cmd.Parameters.AddWithValue("@orderId", orderId);
    object result = cmd.ExecuteScalar();
    if (result != null)
    {
        prescriptionId = result.ToString();
    }
}

// Delete the lab test order (existing logic)
string deleteOrderQuery = "DELETE FROM lab_test WHERE med_id = @orderId";
using (SqlCommand cmd = new SqlCommand(deleteOrderQuery, con))
{
    cmd.Parameters.AddWithValue("@orderId", orderId);
    cmd.ExecuteNonQuery();
}

// Check if there are any remaining lab orders for this prescription
if (!string.IsNullOrEmpty(prescriptionId))
{
    string checkRemainingQuery = "SELECT COUNT(*) FROM lab_test WHERE prescid = @prescid";
    using (SqlCommand cmd = new SqlCommand(checkRemainingQuery, con))
    {
        cmd.Parameters.AddWithValue("@prescid", prescriptionId);
        int remainingOrders = Convert.ToInt32(cmd.ExecuteScalar());
        
        // If no lab orders remain, set status back to pending
        if (remainingOrders == 0)
        {
            string updateStatusQuery = @"
                UPDATE prescribtion 
                SET status = CASE 
                    WHEN status = 4 THEN 0  -- pending-lab becomes waiting
                    WHEN status = 5 THEN 0  -- lab-processed becomes waiting  
                    ELSE status 
                END
                WHERE prescid = @prescid";
            
            using (SqlCommand updateCmd = new SqlCommand(updateStatusQuery, con))
            {
                updateCmd.Parameters.AddWithValue("@prescid", prescriptionId);
                updateCmd.ExecuteNonQuery();
            }
        }
    }
}
```

## Benefits

1. **Data Consistency**: Prescription status accurately reflects whether lab orders exist
2. **User Experience**: Patients won't show lab status when no lab orders are present
3. **Workflow Clarity**: Medical staff can easily see which patients actually need lab work
4. **System Integrity**: Prevents orphaned lab statuses without corresponding orders

## Testing Scenarios

### Test Case 1: Delete Last Lab Order
- **Setup**: Patient has 1 lab order with status "pending-lab" (4)
- **Action**: Delete the lab order
- **Expected**: Status changes to "waiting" (0)

### Test Case 2: Delete One of Multiple Lab Orders
- **Setup**: Patient has 3 lab orders with status "pending-lab" (4)
- **Action**: Delete 1 lab order
- **Expected**: Status remains "pending-lab" (4), 2 orders remain

### Test Case 3: Delete from Different Status
- **Setup**: Patient has 1 lab order with status "lab-processed" (5)
- **Action**: Delete the lab order
- **Expected**: Status changes to "waiting" (0)

## Database Tables Affected

1. **lab_test**: Lab orders are deleted
2. **patient_charges**: Associated charges are deleted
3. **lab_results**: Associated results are deleted
4. **prescribtion**: Status field is updated when no orders remain

## Error Handling

The implementation includes proper error handling:
- Validates that prescription ID exists before attempting updates
- Uses parameterized queries to prevent SQL injection
- Maintains transaction integrity within existing connection scope
- Returns appropriate success/error messages to client

This implementation ensures that when users delete lab orders and there are no lab orders remaining, the lab status automatically reverts to "pending" (waiting status), maintaining system consistency and improving user experience.