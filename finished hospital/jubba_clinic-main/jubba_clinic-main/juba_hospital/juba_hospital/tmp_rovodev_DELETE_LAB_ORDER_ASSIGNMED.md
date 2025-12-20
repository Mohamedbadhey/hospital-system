# ✅ Delete Lab Order Feature Added to assignmed.aspx

## 🎯 What Was Added

### Backend Method Added
**File:** `assignmed.aspx.cs`

Added `DeleteLabOrder` WebMethod that:
1. Checks if the lab order has been paid
2. If paid, prevents deletion with error message
3. If not paid, deletes:
   - The charge from `patient_charges` table
   - Any results from `lab_results` table
   - The lab order from `lab_test` table

### Logic (Same as doctor_inpatient.aspx)
```csharp
[WebMethod]
public static object DeleteLabOrder(int orderId)
{
    // Check if charge is paid
    // If isPaid = true → Return error: "Cannot delete - payment received"
    // If isPaid = false → Delete charge, results, and order
    // Return success message
}
```

## ⚠️ Current Limitation

**assignmed.aspx** currently does NOT display lab orders in a table like **doctor_inpatient.aspx** does.

The current Lab Tests tab only has buttons:
- Send to Lab
- Edit Lab Order  
- View Laboratory Report

**It does NOT show a list of existing lab orders with delete buttons.**

## 🔧 Implementation Options

### Option 1: Add Lab Orders Table (Recommended)
Similar to doctor_inpatient.aspx, add a table showing all lab orders with:
- Order Date
- Tests Ordered
- Payment Status
- Delete Button (only if unpaid)

**This requires:**
1. Adding GetLabOrders WebMethod to assignmed.aspx.cs
2. Adding HTML table to Lab Tests tab
3. Adding JavaScript to load and display orders
4. Adding delete button with confirmation dialog

### Option 2: Add Delete to Edit Modal
Add a delete button to the existing "Edit Lab Order" modal

**This requires:**
1. Adding delete button to edit modal
2. Connecting it to DeleteLabOrder WebMethod
3. Less visible but simpler to implement

### Option 3: Keep as-is (Backend Only)
The backend method is ready, but there's no UI to call it yet. This can be added later when needed.

## 📋 To Fully Implement (Like doctor_inpatient.aspx)

### Step 1: Add GetLabOrders Method
Copy the `GetLabOrders` method from doctor_inpatient.aspx.cs to assignmed.aspx.cs

### Step 2: Add Lab Orders Table to UI
In the Lab Tests tab (line 440-466 in assignmed.aspx), add:

```html
<div class="card-body">
    <!-- Existing buttons... -->
    
    <!-- NEW: Lab Orders Table -->
    <div class="mt-4">
        <h6 class="text-muted mb-3">Existing Lab Orders</h6>
        <div class="table-responsive">
            <table class="table table-hover" id="labOrdersTable">
                <thead class="table-light">
                    <tr>
                        <th>Order Date</th>
                        <th>Tests</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Lab orders will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>
</div>
```

### Step 3: Add JavaScript to Load Orders
```javascript
function loadLabOrders(prescid) {
    $.ajax({
        url: 'assignmed.aspx/GetLabOrders',
        data: JSON.stringify({ prescid: prescid }),
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        success: function(response) {
            // Build table rows
            // Add delete button for unpaid orders
        }
    });
}
```

### Step 4: Add Delete Function with Confirmation
```javascript
function deleteLabOrder(orderId) {
    Swal.fire({
        title: 'Delete Lab Order?',
        text: 'This will permanently delete the lab order and its results.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: 'assignmed.aspx/DeleteLabOrder',
                data: JSON.stringify({ orderId: orderId }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d.success) {
                        Swal.fire('Deleted!', response.d.message, 'success');
                        loadLabOrders(currentPrescid); // Reload
                    } else {
                        Swal.fire('Error', response.d.message, 'error');
                    }
                }
            });
        }
    });
}
```

## ✅ Current Status

- [x] Backend DeleteLabOrder method added to assignmed.aspx.cs
- [x] Same logic as doctor_inpatient.aspx
- [x] Checks payment status before deletion
- [ ] UI not yet implemented (no table to display orders)
- [ ] No delete button visible yet

## 🎯 Recommendation

Since you want the delete functionality in assignmed.aspx lab test tab, I recommend **Option 1** - adding the full lab orders table like in doctor_inpatient.aspx.

This would require:
1. Copying GetLabOrders method from doctor_inpatient.aspx.cs
2. Adding the HTML table to the Lab Tests tab
3. Adding JavaScript to load and display orders
4. Adding delete button with the confirmation dialog

**Would you like me to implement Option 1 (full table with delete button)?**

---

**Last Updated:** December 4, 2025  
**Backend Status:** ✅ Complete  
**Frontend Status:** ⏳ Needs implementation  
**Estimated Time:** ~20 minutes to add full UI
