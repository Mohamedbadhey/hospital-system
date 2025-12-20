# POS System - Box Selling Issue & Fix

## Problem Identified

**Issue:** When selling tablets, the POS only shows "Strips" option but NOT "Boxes" option.

**Location:** `pharmacy_pos.aspx` line 286-288

**Current Code:**
```javascript
// For tablets/capsules, also add box option if we have strips per box data
if ((med.unit_name === 'Tablet' || med.unit_name === 'Capsule') && parseFloat(med.strips_per_box || 0) > 0) {
    sellTypeSelect.append('<option value="boxes">Boxes</option>');
}
```

**Problem:** This HARDCODED check only shows boxes for medicines with unit_name EXACTLY "Tablet" or "Capsule".

---

## Root Cause Analysis

### Current Logic:
1. ✅ Shows base unit (piece/tablet)
2. ✅ Shows subdivision unit (strip) - if `allows_subdivision = true`
3. ❌ Shows "boxes" ONLY if:
   - Unit name is exactly "Tablet" OR "Capsule" (case-sensitive!)
   - AND `strips_per_box > 0`

### Why This is Wrong:
- ❌ Hardcoded unit name check
- ❌ Doesn't work for other countable units (Suppository, Patch, etc.)
- ❌ Doesn't leverage the flexible unit system
- ❌ Ignores `price_per_box` field which indicates box support

---

## The Fix

### Solution 1: Check if Box Pricing Exists (RECOMMENDED)

**Logic:** If medicine has `price_per_box > 0` and `strips_per_box > 0`, show box option.

**Fixed Code:**
```javascript
function populateSellTypes(med) {
    var sellTypeSelect = $('#sellType');
    sellTypeSelect.empty();

    var sellingMethod = med.selling_method || 'countable';
    var baseUnit = med.base_unit_name || 'piece';
    var subdivisionUnit = med.subdivision_unit || '';
    var allowsSubdivision = med.allows_subdivision === 'True' || med.allows_subdivision === '1' || med.allows_subdivision === true;
    var stripsPerBox = parseFloat(med.strips_per_box || med.tablets_per_strip || 0);
    var pricePerBox = parseFloat(med.price_per_box || 0);

    // Always add base unit (individual pieces, ml, mg, etc.)
    var baseLabel = baseUnit.charAt(0).toUpperCase() + baseUnit.slice(1);
    if (sellingMethod === 'volume') {
        baseLabel = 'By Volume (ml)';
    }
    sellTypeSelect.append('<option value="' + baseUnit + '">' + baseLabel + '</option>');

    // Add subdivision if allowed (strips, boxes, bottles, etc.)
    if (allowsSubdivision && subdivisionUnit) {
        var subdivLabel = subdivisionUnit.charAt(0).toUpperCase() + subdivisionUnit.slice(1);
        sellTypeSelect.append('<option value="' + subdivisionUnit + '">' + subdivLabel + '</option>');
    }

    // ✅ FIXED: Show boxes for ANY medicine that has box pricing and packaging
    if (stripsPerBox > 0 && pricePerBox > 0) {
        sellTypeSelect.append('<option value="boxes">Boxes</option>');
    }
}
```

**Benefits:**
- ✅ Works for ALL medicine types (not just Tablet/Capsule)
- ✅ No hardcoded unit names
- ✅ Uses existing data (price_per_box, strips_per_box)
- ✅ More flexible and maintainable

---

### Solution 2: Add Box as Third Subdivision Level

**Logic:** Extend unit system to support 3-tier packaging (base → subdivision → container).

**Database Enhancement:**
```sql
ALTER TABLE medicine_units ADD container_unit VARCHAR(50) NULL;
ALTER TABLE medicine_units ADD container_size_label VARCHAR(100) NULL;
```

**Example:**
```
Tablet Unit:
- base_unit_name: "piece"
- subdivision_unit: "strip"
- container_unit: "box"
- unit_size_label: "pieces per strip"
- container_size_label: "strips per box"
```

**Benefit:** More formal architecture, but requires schema changes.

---

## Implementation Steps

### Quick Fix (5 minutes):

**File:** `pharmacy_pos.aspx`  
**Line:** 286-288

**Replace:**
```javascript
// OLD CODE (REMOVE):
if ((med.unit_name === 'Tablet' || med.unit_name === 'Capsule') && parseFloat(med.strips_per_box || 0) > 0) {
    sellTypeSelect.append('<option value="boxes">Boxes</option>');
}
```

**With:**
```javascript
// NEW CODE (ADD):
// Show boxes option if medicine has box pricing and packaging configured
var stripsPerBox = parseFloat(med.strips_per_box || 0);
var pricePerBox = parseFloat(med.price_per_box || 0);
if (stripsPerBox > 0 && pricePerBox > 0) {
    sellTypeSelect.append('<option value="boxes">Boxes</option>');
}
```

---

## Verification

### Test Case 1: Paracetamol Tablets
```
Medicine: Paracetamol
Unit: Tablet
Tablets per Strip: 10
Strips per Box: 10
Price per Tablet: $0.50
Price per Strip: $5.00
Price per Box: $50.00

Expected Sell Types:
✅ Piece ($0.50)
✅ Strip ($5.00)
✅ Boxes ($50.00) ← Should NOW appear!
```

### Test Case 2: Medicine Without Box Pricing
```
Medicine: Sample Medicine
Price per Tablet: $1.00
Price per Strip: $10.00
Price per Box: $0.00 (not configured)
Strips per Box: 0 (not configured)

Expected Sell Types:
✅ Piece ($1.00)
✅ Strip ($10.00)
❌ Boxes ← Should NOT appear (correctly)
```

---

## Backend Support Verification

The backend ALREADY supports selling by boxes:

**File:** `pharmacy_pos.aspx.cs` Line 277-300

```csharp
if (item.quantity_type == "boxes")
{
    // Get strips per box
    SqlCommand cmdMed = new SqlCommand("SELECT strips_per_box FROM medicine WHERE medicineid = @medid", con, trans);
    cmdMed.Parameters.AddWithValue("@medid", item.medicineid);
    int stripsPerBox = Convert.ToInt32(cmdMed.ExecuteScalar() ?? 10);
    int stripsToDeduct = item.quantity * stripsPerBox;

    // Update inventory
    SqlCommand cmdInv = new SqlCommand(@"
        UPDATE medicine_inventory 
        SET total_boxes = ISNULL(total_boxes, 0) - @qty,
            primary_quantity = primary_quantity - @strips,
            total_strips = ISNULL(total_strips, 0) - @strips,
            last_updated = GETDATE()
        WHERE inventoryid = @invid
    ", con, trans);
    cmdInv.Parameters.AddWithValue("@qty", item.quantity);
    cmdInv.Parameters.AddWithValue("@strips", stripsToDeduct);
    cmdInv.Parameters.AddWithValue("@invid", item.inventoryid);
    cmdInv.ExecuteNonQuery();
}
```

✅ **Backend is READY** - just needs frontend to show the option!

---

## Additional Enhancement (Optional)

### Show Available Box Count

**Current Display:**
```
Stock: 50 strips + 15 pieces
```

**Enhanced Display:**
```
Stock: 5 boxes + 0 strips + 15 pieces
(Calculated: 50 strips ÷ 10 strips/box = 5 boxes)
```

**Implementation:**
```javascript
function calculateStockDisplay(med) {
    var stockParts = [];
    var primaryQty = parseInt(med.primary_quantity || med.total_strips || 0);
    var stripsPerBox = parseInt(med.strips_per_box || 0);
    
    // Calculate boxes
    if (stripsPerBox > 0 && primaryQty >= stripsPerBox) {
        var fullBoxes = Math.floor(primaryQty / stripsPerBox);
        var looseStrips = primaryQty % stripsPerBox;
        
        if (fullBoxes > 0) {
            stockParts.push(fullBoxes + ' boxes');
        }
        if (looseStrips > 0) {
            stockParts.push(looseStrips + ' ' + (med.subdivision_unit || 'strips'));
        }
    } else if (primaryQty > 0) {
        stockParts.push(primaryQty + ' ' + (med.subdivision_unit || 'strips'));
    }

    // Secondary quantity
    var secondaryQty = parseFloat(med.secondary_quantity || med.loose_tablets || 0);
    if (secondaryQty > 0) {
        var secondaryUnit = med.base_unit_name || 'pieces';
        stockParts.push(secondaryQty + ' ' + secondaryUnit);
    }

    return stockParts.length > 0 ? stockParts.join(' + ') : '0';
}
```

---

## Summary

**Problem:** Box selling option hidden due to hardcoded unit name check  
**Root Cause:** Line 286 checks `if (med.unit_name === 'Tablet' || med.unit_name === 'Capsule')`  
**Solution:** Check if box pricing exists instead: `if (strips_per_box > 0 && price_per_box > 0)`  
**Impact:** Works for ALL medicine types, not just Tablet/Capsule  
**Effort:** 5 minutes to fix  
**Backend:** Already supports boxes - no changes needed  

---

**Fix Applied:** Waiting for confirmation to implement