# Unit-Based Selling System - Complete Guide

## Overview

The Juba Hospital Management System now supports **dynamic, unit-specific selling methods** for pharmacy medicines. Each medicine unit (Tablet, Syrup, Injection, etc.) can have its own way of being sold, stored, and priced.

---

## Problem Solved

**Before:** The system was hardcoded for tablets only, with fixed options:
- Sell by tablets (individual pieces)
- Sell by strips 
- Sell by boxes

**Issue:** This didn't work for:
- Syrups (sold by ml or bottles)
- Injections (sold by vials)
- Creams/Ointments (sold by tubes)
- Inhalers (sold as whole units)
- And many other medicine types

**After:** Each unit type now has its own selling configuration that automatically adapts the POS system!

---

## How It Works

### 1. Medicine Units Configuration

Each unit in the `medicine_units` table has:

| Field | Description | Example (Tablet) | Example (Syrup) |
|-------|-------------|------------------|-----------------|
| `selling_method` | How to count/measure | 'countable' | 'volume' |
| `base_unit_name` | Smallest unit | 'piece' | 'ml' |
| `subdivision_unit` | Container/package | 'strip' | 'bottle' |
| `allows_subdivision` | Can sell subdivisions? | Yes (1) | Yes (1) |
| `unit_size_label` | What to configure | 'pieces per strip' | 'ml per bottle' |

### 2. Selling Methods

Three selling methods are supported:

#### A. **Countable** (for tablets, capsules, vials, tubes)
- Base unit: piece, vial, tube, inhaler, etc.
- Can have subdivisions: strips, boxes
- Example: Paracetamol Tablet
  - Sell by: pieces (individual tablets)
  - Sell by: strips (10 tablets per strip)
  - Sell by: boxes (10 strips per box)

#### B. **Volume** (for liquids like syrups, drops)
- Base unit: ml
- Subdivision: bottle
- Example: Cough Syrup
  - Sell by: ml (individual milliliters)
  - Sell by: bottle (120ml per bottle)

#### C. **Weight** (for powders - future support)
- Base unit: gram or mg
- Subdivision: sachet, container

### 3. Pre-Configured Unit Types

The system comes with 15 pre-configured unit types:

| Unit Name | Selling Method | Base Unit | Subdivision | Allows Subdivision |
|-----------|----------------|-----------|-------------|-------------------|
| Tablet | countable | piece | strip | Yes |
| Capsule | countable | piece | strip | Yes |
| Syrup | volume | ml | bottle | Yes |
| Bottle | volume | ml | bottle | Yes |
| Injection | countable | vial | - | No |
| Drops | volume | ml | bottle | Yes |
| Cream | countable | tube | - | No |
| Ointment | countable | tube | - | No |
| Gel | countable | tube | - | No |
| Inhaler | countable | inhaler | - | No |
| Powder | countable | sachet | - | No |
| Sachet | countable | sachet | - | No |
| Suppository | countable | piece | - | No |
| Patch | countable | piece | - | No |
| Spray | countable | bottle | - | No |

---

## Database Schema Changes

### Updated Tables

#### 1. `medicine_units` Table
```sql
ALTER TABLE medicine_units ADD
    selling_method VARCHAR(50),        -- 'countable', 'volume', 'weight'
    base_unit_name VARCHAR(20),        -- 'piece', 'ml', 'mg', 'vial'
    subdivision_unit VARCHAR(20),      -- 'strip', 'bottle', 'box', NULL
    allows_subdivision BIT,            -- 1 or 0
    unit_size_label VARCHAR(50);       -- 'pieces per strip', 'ml per bottle'
```

#### 2. `medicine` Table
Already has:
- `unit_id` - Links to medicine_units
- `tablets_per_strip` - Number of base units per subdivision
- `strips_per_box` - Number of subdivisions per box
- `price_per_tablet` - Price of base unit
- `price_per_strip` - Price of subdivision
- `price_per_box` - Price of box

#### 3. `medicine_inventory` Table
Already has flexible storage:
- `primary_quantity` - Number of subdivisions (strips, bottles, etc.)
- `secondary_quantity` - Loose base units (pieces, ml, etc.)
- `unit_size` - Size of each subdivision (10 tablets per strip, 120ml per bottle)

---

## How The POS System Works Now

### Step-by-Step Flow

1. **User selects a medicine**
   - System loads medicine details including unit configuration

2. **System populates "Sell Type" dropdown dynamically**
   
   **Example for Paracetamol Tablet:**
   ```
   Sell Type: 
   - Piece (base unit)
   - Strip (subdivision) 
   - Boxes (if configured)
   ```
   
   **Example for Cough Syrup:**
   ```
   Sell Type:
   - By Volume (ml) (base unit)
   - Bottle (subdivision)
   ```
   
   **Example for Insulin Injection:**
   ```
   Sell Type:
   - Vial (no subdivisions - sold as whole units only)
   ```

3. **User selects quantity and sell type**
   - System calculates price based on selected type
   - Shows unit price and total price

4. **System checks stock availability**
   - For subdivisions: Checks `primary_quantity`
   - For base units: Checks `(primary_quantity × unit_size) + secondary_quantity`

5. **On sale completion**
   - Deducts from appropriate inventory fields
   - Records sale with correct quantity_type

---

## Examples

### Example 1: Selling Tablets

**Medicine:** Paracetamol 500mg Tablet
- Unit: Tablet
- Configuration: 10 pieces per strip, 10 strips per box
- Prices: 5 SDG/piece, 45 SDG/strip, 400 SDG/box
- Stock: 50 strips + 8 loose pieces

**Selling Options:**
1. Sell 25 pieces → Price: 125 SDG (uses 2 strips + 5 loose pieces)
2. Sell 10 strips → Price: 450 SDG (uses 10 strips)
3. Sell 2 boxes → Price: 800 SDG (uses 20 strips)

### Example 2: Selling Syrup

**Medicine:** Amoxicillin Syrup
- Unit: Syrup
- Configuration: 120ml per bottle
- Prices: 0.5 SDG/ml, 55 SDG/bottle
- Stock: 15 bottles + 50ml loose

**Selling Options:**
1. Sell 200ml → Price: 100 SDG (uses 1 bottle + 80ml loose, or 2 bottles)
2. Sell 3 bottles → Price: 165 SDG (uses 3 bottles)

### Example 3: Selling Injections

**Medicine:** Insulin Injection 10ml
- Unit: Injection
- Configuration: No subdivision (whole vials only)
- Price: 85 SDG/vial
- Stock: 30 vials

**Selling Options:**
1. Sell 5 vials → Price: 425 SDG (uses 5 vials)
   - Note: Cannot sell partial vials

---

## Frontend Implementation

### Dynamic Sell Type Population

```javascript
function populateSellTypes(med) {
    var sellTypeSelect = $('#sellType');
    sellTypeSelect.empty();
    
    var baseUnit = med.base_unit_name || 'piece';
    var subdivisionUnit = med.subdivision_unit || '';
    var allowsSubdivision = med.allows_subdivision === 'True';
    
    // Always add base unit option
    sellTypeSelect.append('<option value="' + baseUnit + '">' + baseUnit + '</option>');
    
    // Add subdivision if allowed
    if (allowsSubdivision && subdivisionUnit) {
        sellTypeSelect.append('<option value="' + subdivisionUnit + '">' + subdivisionUnit + '</option>');
    }
    
    // Add box option for tablets/capsules
    if ((med.unit_name === 'Tablet' || med.unit_name === 'Capsule') && med.strips_per_box > 0) {
        sellTypeSelect.append('<option value="boxes">Boxes</option>');
    }
}
```

### Dynamic Price Calculation

```javascript
function updatePrice() {
    var sellType = $('#sellType').val();
    var quantity = parseInt($('#quantity').val());
    var unitPrice = 0;
    
    if (sellType === 'boxes') {
        unitPrice = parseFloat(currentMedicine.price_per_box);
    } else if (sellType === 'strip' || sellType === 'bottle') {
        unitPrice = parseFloat(currentMedicine.price_per_strip);
    } else {
        unitPrice = parseFloat(currentMedicine.price_per_tablet);
    }
    
    var totalPrice = unitPrice * quantity;
    $('#unitPrice').val(unitPrice.toFixed(2));
    $('#totalPrice').val(totalPrice.toFixed(2));
}
```

### Stock Availability Check

```javascript
function checkStockAvailability(med, sellType, quantity) {
    var primaryQty = parseInt(med.primary_quantity || 0);
    var secondaryQty = parseFloat(med.secondary_quantity || 0);
    var unitSize = parseFloat(med.unit_size || 10);
    
    if (sellType === 'boxes') {
        var stripsPerBox = parseInt(med.strips_per_box || 10);
        var requiredStrips = quantity * stripsPerBox;
        return primaryQty >= requiredStrips;
    } else if (sellType === 'strip' || sellType === 'bottle' || sellType === 'vial') {
        return primaryQty >= quantity;
    } else {
        // Base unit (pieces, ml, etc.)
        var totalAvailable = (primaryQty * unitSize) + secondaryQty;
        return totalAvailable >= quantity;
    }
}
```

---

## Backend Implementation

### Get Medicine with Unit Details

```csharp
[WebMethod]
public static medicine_info[] getMedicineDetails(string medicineid)
{
    // Query joins medicine, medicine_inventory, and medicine_units tables
    SqlCommand cmd = new SqlCommand(@"
        SELECT 
            m.medicineid, m.medicine_name,
            u.unit_name, u.selling_method, u.base_unit_name, 
            u.subdivision_unit, u.allows_subdivision, u.unit_size_label,
            m.price_per_tablet, m.price_per_strip, m.price_per_box,
            m.tablets_per_strip, m.strips_per_box,
            mi.primary_quantity, mi.secondary_quantity, mi.unit_size
        FROM medicine m
        INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
        LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
        WHERE m.medicineid = @medicineid
    ", con);
    // ... return results
}
```

### Process Sale with Dynamic Inventory Update

```csharp
[WebMethod]
public static sale_result processSale(sale_request request)
{
    foreach (var item in request.items)
    {
        if (item.quantity_type == "boxes") {
            // Deduct strips equivalent to boxes
            int stripsToDeduct = item.quantity * stripsPerBox;
            // UPDATE primary_quantity
        }
        else if (item.quantity_type == "strip" || item.quantity_type == "bottle" || item.quantity_type == "vial") {
            // Deduct from primary_quantity
        }
        else {
            // Deduct from secondary_quantity and primary_quantity if needed
        }
    }
}
```

---

## Setup Instructions

### 1. Run Database Migration

Execute the SQL script to add unit-specific selling configuration:

```sql
-- File: unit_selling_methods_schema.sql
USE [juba_clinick]
GO

-- This will:
-- 1. Add selling configuration columns to medicine_units
-- 2. Configure all 15 unit types
-- 3. Add flexible storage to medicine_inventory
-- 4. Migrate existing data
```

### 2. Update Existing Medicines

After running the migration, your existing medicines will automatically be configured:
- Tablets → countable with strip subdivisions
- Capsules → countable with strip subdivisions  
- Other units → appropriate configurations

### 3. Test the System

1. Go to **Medicine Management** (`add_medicine.aspx`)
2. Add or edit a medicine
3. Select different unit types and observe label changes
4. Go to **POS System** (`pharmacy_pos.aspx`)
5. Select medicines with different units
6. Observe how sell type options change dynamically

---

## Benefits

✅ **Flexible:** Supports any type of medicine unit  
✅ **Automatic:** POS adapts automatically to unit type  
✅ **Accurate:** Prevents selling partial units for non-divisible items  
✅ **Extendable:** Easy to add new unit types  
✅ **User-Friendly:** Clear labels and options based on medicine type  
✅ **Stock-Safe:** Validates availability before sale  

---

## Adding New Unit Types

To add a new unit type (e.g., "Sachet"):

1. **Insert into medicine_units:**
```sql
INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, allows_subdivision, unit_size_label)
VALUES ('Sachet', 'Sach', 'countable', 'sachet', 0, 'grams per sachet');
```

2. **Configure selling options:**
- `selling_method`: 'countable', 'volume', or 'weight'
- `base_unit_name`: What to call the individual unit
- `allows_subdivision`: 1 if can be packaged, 0 if sold as whole units
- `subdivision_unit`: Name of the package (if applicable)

3. **System automatically adapts!**

---

## Troubleshooting

### Issue: Sell type dropdown is empty
**Solution:** Check that the medicine has a valid `unit_id` and the unit exists in `medicine_units`

### Issue: Price shows 0.00
**Solution:** Ensure price fields are filled (price_per_tablet, price_per_strip, etc.)

### Issue: Stock check fails incorrectly
**Solution:** Verify `primary_quantity`, `secondary_quantity`, and `unit_size` in inventory

### Issue: Old medicines don't work
**Solution:** Run the migration script to update existing data

---

## Technical Files Modified

1. **pharmacy_pos.aspx** - Dynamic sell type population, stock checks
2. **pharmacy_pos.aspx.cs** - Unit-aware inventory queries
3. **add_medicine.aspx** - Dynamic label updates based on unit
4. **add_medicine.aspx.cs** - Added `getUnitDetails` WebMethod
5. **unit_selling_methods_schema.sql** - Database migration script

---

## Future Enhancements

- 🔲 Support for weight-based selling (grams, kg)
- 🔲 Batch-specific pricing
- 🔲 Bulk discounts based on quantity
- 🔲 Unit conversion calculator in POS
- 🔲 Custom unit types defined by user

---

## Conclusion

The unit-based selling system makes your pharmacy truly flexible and accurate. Each medicine type is sold in the way that makes sense for it, automatically!

**Questions?** Check the code comments or contact the development team.

---

**Last Updated:** December 2024  
**Version:** 2.0  
**Status:** Production Ready ✅
