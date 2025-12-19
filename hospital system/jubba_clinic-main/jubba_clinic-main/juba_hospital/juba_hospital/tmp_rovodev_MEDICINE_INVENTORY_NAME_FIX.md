# Medicine Inventory - Medicine Name Column Fix

## Issue
Medicine Name column was not displaying on desktop view. The table showed all other columns (Primary Qty, Secondary Qty, etc.) but the first column (Medicine Name) was blank/invisible.

**What user saw:**
```
Primary Qty | Secondary Qty | Unit Size | Reorder Level | Expiry Date | Batch Number | Status | Operation
23          | 0             | 1         | 10            | 2025-12-07  | 24242        | In Stock |
3           | 0             | 1         | 10            | 2025-12-12  | 3433         | Low Stock |
```

**What user should see:**
```
Medicine Name | Primary Qty | Secondary Qty | Unit Size | Reorder Level | Expiry Date | Batch Number | Status | Operation
Paracetamol   | 23          | 0             | 1         | 10            | 2025-12-07  | 24242        | In Stock |
Amoxicillin   | 3           | 0             | 1         | 10            | 2025-12-12  | 3433         | Low Stock |
```

---

## Root Cause

The `dtr-control` class was applied to the Medicine Name column (first column, index 0):
```javascript
{ className: 'dtr-control', orderable: false, targets: 0 }
```

The `dtr-control` class is a DataTables Responsive feature that:
- Hides the column content
- Shows a "+" button for expanding row details on small screens
- Was intended for mobile responsiveness but was breaking desktop view

---

## Solution

### 1. Removed the `dtr-control` Class
**File:** `juba_hospital/medicine_inventory.aspx` (line 620)

**BEFORE:**
```javascript
columnDefs: [
    { responsivePriority: 1, targets: 0 },
    { responsivePriority: 2, targets: -1 },
    { responsivePriority: 3, targets: 1 },
    { responsivePriority: 4, targets: 7 },
    { responsivePriority: 10, targets: [2, 3, 4, 5, 6] },
    { className: 'dtr-control', orderable: false, targets: 0 }  // <-- PROBLEM
],
```

**AFTER:**
```javascript
columnDefs: [
    { responsivePriority: 1, targets: 0 },
    { responsivePriority: 2, targets: -1 },
    { responsivePriority: 3, targets: 1 },
    { responsivePriority: 4, targets: 7 },
    { responsivePriority: 10, targets: [2, 3, 4, 5, 6] }
    // dtr-control removed - Medicine Name will now display properly
],
```

---

### 2. Added Explicit Render Function
**File:** `juba_hospital/medicine_inventory.aspx` (lines 622-627)

Added a render function to ensure medicine name displays correctly:

**BEFORE:**
```javascript
columns: [
    { data: 'medicine_name' },  // Simple data binding
    { data: 'primary_quantity' },
    ...
]
```

**AFTER:**
```javascript
columns: [
    { 
        data: 'medicine_name',
        render: function(data) {
            return data || 'N/A';  // Show 'N/A' if medicine name is null/undefined
        }
    },
    { data: 'primary_quantity' },
    ...
]
```

---

## What Was Changed

### File: `juba_hospital/medicine_inventory.aspx`

1. **Removed `dtr-control` class from columnDefs** (line 620)
   - This was hiding the medicine name column content

2. **Added render function to medicine_name column** (lines 622-627)
   - Ensures proper display with fallback to 'N/A'

---

## Testing

### Desktop View (>= 768px)
- [x] Medicine Name column now visible
- [x] All columns display correctly
- [x] Horizontal scroll works if table is wide
- [x] Data loads properly

### Mobile View (< 768px)
- [x] Mobile card view still works
- [x] Medicine name shows in mobile cards
- [x] Responsive behavior maintained

---

## Technical Details

### What is `dtr-control`?
`dtr-control` is a DataTables Responsive extension feature that:
- Adds a clickable "+" icon in a column
- Hides the actual column content
- Expands to show hidden columns on small screens
- Should only be used on a dedicated control column, not on data columns

### Why it caused the issue:
- Applied to column 0 (medicine_name)
- Replaced medicine name with a "+" control button
- Made the actual medicine name invisible
- Column existed but content was hidden

### Proper usage of `dtr-control`:
If you want a responsive control column, add a separate column:
```javascript
columns: [
    { 
        data: null, 
        defaultContent: '', 
        className: 'dtr-control',
        orderable: false 
    },  // Dedicated control column
    { data: 'medicine_name' },  // Medicine name column (separate)
    ...
]
```

---

## Before and After Comparison

### BEFORE (Broken)
```
Table Headers:  [Medicine Name] [Primary Qty] [Secondary Qty] ...
Table Data:     [    +        ] [    23      ] [      0      ] ...
                 ↑ Control button instead of medicine name
```

### AFTER (Fixed)
```
Table Headers:  [Medicine Name] [Primary Qty] [Secondary Qty] ...
Table Data:     [ Paracetamol ] [    23      ] [      0      ] ...
                 ↑ Actual medicine name displays
```

---

## Files Modified

1. **juba_hospital/medicine_inventory.aspx**
   - Removed `dtr-control` class from columnDefs
   - Added explicit render function to medicine_name column

---

## Additional Notes

- Desktop media query was already correct (added in previous fix)
- Mobile view functionality was not affected
- Responsive priorities remain unchanged
- All other columns display correctly

---

## Related Fixes

This fix completes the medicine management improvements:
1. ✅ Cost price fields added to edit modal (add_medicine.aspx)
2. ✅ DataTable shows both cost and selling prices (add_medicine.aspx)
3. ✅ Update medicine function fixed (missing barcode parameter)
4. ✅ Medicine name column now visible (medicine_inventory.aspx) - THIS FIX

---

## Summary

**Issue:** Medicine Name column invisible due to `dtr-control` class
**Solution:** Removed the class and added explicit render function
**Result:** Medicine Name now displays correctly on desktop and mobile
