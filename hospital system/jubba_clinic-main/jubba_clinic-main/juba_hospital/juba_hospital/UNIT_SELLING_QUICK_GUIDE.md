# Unit-Based Selling - Quick Reference Guide

## 🎯 Quick Summary

**Problem Fixed:** The pharmacy POS was hardcoded for tablets only (pieces/strips/boxes). Now it dynamically adapts to ANY medicine unit type!

**Solution:** Each medicine unit (Tablet, Syrup, Injection, etc.) has its own selling configuration that automatically changes how the POS works.

---

## 📋 How Each Unit Type Works

| Unit | Sell By | Example |
|------|---------|---------|
| **Tablet/Capsule** | Pieces, Strips, Boxes | "Sell 5 pieces" or "Sell 2 strips" or "Sell 1 box" |
| **Syrup/Drops** | ml, Bottles | "Sell 50ml" or "Sell 2 bottles" |
| **Injection** | Vials (whole only) | "Sell 3 vials" |
| **Cream/Ointment** | Tubes (whole only) | "Sell 2 tubes" |
| **Inhaler** | Inhalers (whole only) | "Sell 1 inhaler" |
| **Powder/Sachet** | Sachets (whole only) | "Sell 5 sachets" |
| **Spray** | Bottles (whole only) | "Sell 1 bottle" |

---

## 🚀 User Guide (For Pharmacy Staff)

### Adding a Medicine

1. Go to **Medicine Management**
2. Click **Add Medicine**
3. Select the **Unit Type** from dropdown
4. **Notice:** The pricing labels change automatically!
   - For Tablets: "Price per piece", "Price per strip"
   - For Syrups: "Price per ml", "Price per bottle"
   - For Injections: "Price per vial"

### Selling at POS

1. Go to **Pharmacy POS**
2. Select a medicine from dropdown
3. **Notice:** The "Sell Type" dropdown changes based on unit!
   - Tablets show: Piece, Strip, Boxes
   - Syrups show: By Volume (ml), Bottle
   - Injections show: Vial only
4. Select quantity and add to cart
5. Complete sale as normal

---

## 🔧 Admin Setup (One-Time)

### Step 1: Run Database Update

Execute this SQL script **once** on your database:

```sql
-- File: unit_selling_methods_schema.sql
-- Location: juba_hospital folder
-- Run this in SQL Server Management Studio
```

This adds the unit configuration columns and sets up all 15 unit types.

### Step 2: Verify Unit Configuration

Check that units are configured:

```sql
SELECT unit_name, selling_method, base_unit_name, subdivision_unit, allows_subdivision
FROM medicine_units
ORDER BY unit_name;
```

You should see 15 rows with proper configuration.

### Step 3: Update Existing Medicines (If Any)

If you have existing medicines without unit_id:

```sql
-- Assign default unit (Tablet) to medicines without unit_id
UPDATE medicine 
SET unit_id = 1 
WHERE unit_id IS NULL;
```

---

## 💡 Common Scenarios

### Scenario 1: Adding Paracetamol Tablets

```
Medicine Name: Paracetamol 500mg
Unit: Tablet
Pieces per Strip: 10
Strips per Box: 10
Price per Piece: 5 SDG
Price per Strip: 45 SDG
Price per Box: 400 SDG
```

**At POS, user can sell:**
- 15 pieces → 75 SDG
- 3 strips → 135 SDG
- 1 box → 400 SDG

### Scenario 2: Adding Cough Syrup

```
Medicine Name: Amoxil Syrup
Unit: Syrup
ml per Bottle: 120
Price per ml: 0.5 SDG
Price per Bottle: 55 SDG
```

**At POS, user can sell:**
- 50ml → 25 SDG
- 2 bottles → 110 SDG

### Scenario 3: Adding Insulin Injection

```
Medicine Name: Insulin Regular
Unit: Injection
Price per Vial: 85 SDG
```

**At POS, user can sell:**
- 1 vial → 85 SDG
- 5 vials → 425 SDG
- ❌ Cannot sell partial vials (e.g., 0.5 vial)

---

## 🎨 Visual Changes in POS

### Before (Old System - Hardcoded for Tablets)
```
Medicine: Cough Syrup
Sell Type: [Tablets ▼] [Strips ▼] [Boxes ▼]  ❌ Wrong!
```

### After (New System - Dynamic)
```
Medicine: Paracetamol Tablet
Sell Type: [Piece ▼] [Strip ▼] [Boxes ▼]  ✅ Correct!

Medicine: Cough Syrup  
Sell Type: [By Volume (ml) ▼] [Bottle ▼]  ✅ Correct!

Medicine: Insulin Injection
Sell Type: [Vial ▼]  ✅ Correct!
```

---

## 📊 Inventory Management

### How Stock is Stored

Each medicine in inventory has:

| Field | For Tablets | For Syrups | For Injections |
|-------|-------------|------------|----------------|
| `primary_quantity` | Number of strips | Number of bottles | Number of vials |
| `secondary_quantity` | Loose tablets | Loose ml | Not used |
| `unit_size` | 10 (tablets per strip) | 120 (ml per bottle) | 1 (whole vials) |

### Stock Display Examples

**Tablets:**
```
Stock: 50 strips + 8 pieces
Total Available: (50 × 10) + 8 = 508 tablets
```

**Syrups:**
```
Stock: 15 bottles + 50ml
Total Available: (15 × 120) + 50 = 1850ml
```

**Injections:**
```
Stock: 30 vials
Total Available: 30 vials (no partials)
```

---

## ⚠️ Important Notes

### Pricing Rules

1. **Always set price for base unit** (piece, ml, vial)
2. **Set price for subdivision** if applicable (strip, bottle)
3. **Set price for box** if selling by boxes

### Stock Validation

- System checks stock before allowing sale
- Prevents overselling
- Automatically deducts from correct fields

### Unit Conversion

System automatically converts:
- Boxes → Strips → Pieces
- Bottles → ml
- Maintains accurate inventory

---

## 🐛 Troubleshooting

### Problem: "Sell Type" dropdown is empty

**Cause:** Medicine doesn't have a unit assigned  
**Fix:** Edit the medicine and select a unit type

### Problem: Price shows 0.00

**Cause:** Price fields not filled  
**Fix:** Edit medicine and enter prices for all sell types you want to support

### Problem: "Insufficient stock" error but stock exists

**Cause:** Stock might be in wrong fields  
**Fix:** Check inventory - ensure `primary_quantity` and `unit_size` are set correctly

### Problem: Old medicines not working

**Cause:** Created before system update  
**Fix:** Run the database migration script (step 1 above)

---

## 🔮 Advanced: Adding Custom Units

Want to add a new unit type? Here's how:

```sql
-- Example: Adding "Ampoule" unit
INSERT INTO medicine_units (
    unit_name, 
    unit_abbreviation,
    selling_method,
    base_unit_name,
    subdivision_unit,
    allows_subdivision,
    unit_size_label
) VALUES (
    'Ampoule',      -- Unit name
    'Amp',          -- Short form
    'countable',    -- Method
    'ampoule',      -- Base unit
    NULL,           -- No subdivision
    0,              -- Cannot subdivide
    'ml per ampoule' -- Size label
);
```

Then create medicines using this new unit type!

---

## 📞 Support

If you encounter issues:

1. Check this guide first
2. Verify database migration was run
3. Check browser console for JavaScript errors
4. Verify medicine has all required fields filled

---

## ✅ Checklist for Implementation

- [ ] Database migration script executed
- [ ] Verified 15 unit types exist in `medicine_units`
- [ ] Updated existing medicines with unit_id
- [ ] Tested adding new medicine with different units
- [ ] Tested POS with tablets
- [ ] Tested POS with syrups
- [ ] Tested POS with injections
- [ ] Verified inventory updates correctly
- [ ] Trained pharmacy staff on new features

---

**System Version:** 2.0  
**Last Updated:** December 2024  
**Status:** ✅ Production Ready

---

## 🎓 Training Tips for Staff

### 5-Minute Training Script

1. **Show them the medicine management:**
   - "When you select different units, the labels change automatically"
   - "This helps you enter the right prices for each medicine type"

2. **Show them the POS:**
   - "The sell type options now match the medicine type"
   - "You can't make mistakes like selling 'strips' of syrup anymore"

3. **Do a live demo:**
   - Add a tablet medicine
   - Add a syrup medicine  
   - Sell both at POS
   - Show how stock updates correctly

**That's it!** The system does the rest automatically.

---

## 🌟 Benefits Summary

| Before | After |
|--------|-------|
| ❌ Only works for tablets | ✅ Works for ALL medicine types |
| ❌ Confusing for non-tablet items | ✅ Clear and appropriate for each type |
| ❌ Staff make errors | ✅ System prevents mistakes |
| ❌ Hardcoded, inflexible | ✅ Flexible, extensible |
| ❌ Manual label changes needed | ✅ Automatic adaptation |

---

**Congratulations!** Your pharmacy system is now professional-grade and flexible! 🎉
