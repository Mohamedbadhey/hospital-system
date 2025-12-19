# 🚀 MEDICINE ENTRY - QUICK REFERENCE CARD

---

## 📋 STEP 1: CREATE UNIT (One-Time Setup)
**Page:** Add Medicine Units

### Common Unit Templates (Copy & Fill)

#### 🔷 TABLETS
```
Unit Name: Tablet
Abbreviation: Tab
Selling Method: countable
Base Unit: piece
Subdivision: strip
Allows Subdivision: ✓
Unit Size Label: pieces per strip
```

#### 🔷 SYRUP
```
Unit Name: Syrup
Abbreviation: Syr
Selling Method: volume
Base Unit: ml
Subdivision: bottle
Allows Subdivision: ✓
Unit Size Label: ml per bottle
```

#### 🔷 INJECTION
```
Unit Name: Injection
Abbreviation: Inj
Selling Method: countable
Base Unit: vial
Subdivision: box
Allows Subdivision: ✓
Unit Size Label: vials per box
```

#### 🔷 OINTMENT
```
Unit Name: Ointment
Abbreviation: Oint
Selling Method: countable
Base Unit: tube
Subdivision: box
Allows Subdivision: ✓
Unit Size Label: tubes per box
```

#### 🔷 CAPSULE
```
Unit Name: Capsule
Abbreviation: Cap
Selling Method: countable
Base Unit: piece
Subdivision: strip
Allows Subdivision: ✓
Unit Size Label: pieces per strip
```

---

## 📋 STEP 2: ADD MEDICINE
**Page:** Add Medicine

### Fill These Fields (Top to Bottom):

```
┌─────────────────────────────────────────┐
│ BASIC INFORMATION                       │
├─────────────────────────────────────────┤
│ Medicine Name: [Brand + Strength]      │
│   Example: Paracetamol 500mg           │
│                                         │
│ Generic Name: [Scientific name]        │
│   Example: Acetaminophen               │
│                                         │
│ Manufacturer: [Company name]           │
│   Example: GSK Pharmaceuticals         │
│                                         │
│ Barcode: [Scan or type] (optional)     │
│                                         │
│ Unit Type: [Select from dropdown]      │
│   Select: Tablet, Syrup, etc.          │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ PACKAGING (Auto-appears after Unit)    │
├─────────────────────────────────────────┤
│ For TABLETS:                            │
│ • Pieces per Strip: [Number]           │
│ • Strips per Box: [Number]             │
│                                         │
│ For SYRUP:                              │
│ • ML per Bottle: [Number]              │
│ • Bottles per Box: [Number]            │
│                                         │
│ For INJECTION:                          │
│ • Vials per Box: [Number]              │
│ • ML per Vial: [Number]                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ COST PRICES (What YOU paid)            │
├─────────────────────────────────────────┤
│ Cost per Piece/ML/Vial: [$___]         │
│ Cost per Strip/Bottle: [$___]          │
│ Cost per Box: [$___]                   │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ SELLING PRICES (What customers pay)    │
├─────────────────────────────────────────┤
│ Price per Piece/ML/Vial: [$___]        │
│ Price per Strip/Bottle: [$___]         │
│ Price per Box: [$___]                  │
└─────────────────────────────────────────┘

         [CLICK SAVE BUTTON]
```

---

## 💰 QUICK PRICE CALCULATOR

### Formula:
```
Total Cost ÷ Total Quantity = Cost per Unit
Cost per Unit × (1 + Markup%) = Selling Price
```

### Example:
```
You bought 100 tablets for $10.00

Step 1: Cost per tablet
$10.00 ÷ 100 = $0.10 per tablet

Step 2: Add 50% markup
$0.10 × 1.50 = $0.15 selling price

Step 3: Calculate strip price (10 tablets)
$0.15 × 10 = $1.50 per strip

Step 4: Calculate box price (100 tablets)
$0.15 × 100 = $15.00 per box
```

### Common Markup Rates:
- **Essential medicines:** 20-50%
- **Regular medicines:** 50-100%
- **Specialty medicines:** 100-200%

---

## 🎯 REAL EXAMPLES (Copy These!)

### Example 1: Paracetamol Tablets
```
Medicine Name: Paracetamol 500mg
Generic Name: Acetaminophen
Manufacturer: GSK
Unit: Tablet
Pieces per Strip: 10
Strips per Box: 10
Cost per Piece: $0.05
Cost per Strip: $0.50
Cost per Box: $5.00
Price per Piece: $0.10
Price per Strip: $1.00
Price per Box: $9.00
```

### Example 2: Amoxicillin Syrup
```
Medicine Name: Amoxicillin 250mg/5ml
Generic Name: Amoxicillin
Manufacturer: Cipla
Unit: Syrup
ML per Bottle: 100
Bottles per Box: 1
Cost per ML: $0.03
Cost per Bottle: $3.00
Cost per Box: $3.00
Price per ML: $0.05
Price per Bottle: $5.00
Price per Box: $5.00
```

### Example 3: Insulin Injection
```
Medicine Name: Insulin Glargine 100IU
Generic Name: Insulin Glargine
Manufacturer: Novo Nordisk
Unit: Injection
Vials per Box: 5
ML per Vial: 10
Cost per Vial: $10.00
Cost per Box: $50.00
Price per Vial: $15.00
Price per Box: $70.00
```

### Example 4: Hydrocortisone Ointment
```
Medicine Name: Hydrocortisone 1%
Generic Name: Hydrocortisone
Manufacturer: Abbott
Unit: Ointment
Tubes per Box: 1
Grams per Tube: 30
Cost per Tube: $2.00
Cost per Box: $2.00
Price per Tube: $4.00
Price per Box: $4.00
```

---

## ✅ CHECKLIST: Before Clicking Save

- [ ] Medicine name includes strength (e.g., 500mg)
- [ ] Generic name is correct
- [ ] Unit type is selected
- [ ] Packaging numbers make sense
- [ ] Cost prices are calculated correctly
- [ ] Selling prices include markup
- [ ] Prices for strip/box match quantity × price per piece

---

## 🚨 COMMON MISTAKES TO AVOID

❌ **Wrong:** Entering box price in piece field  
✅ **Right:** Calculate piece price first, then multiply

❌ **Wrong:** Forgetting to select unit type  
✅ **Right:** Always select unit before filling packaging

❌ **Wrong:** Setting selling price = cost price  
✅ **Right:** Add markup for profit

❌ **Wrong:** Inconsistent pricing (strip ≠ 10 × piece)  
✅ **Right:** Ensure math is correct across all levels

---

## 📊 UNITS DECISION TREE

```
Is it a solid pill/tablet?
  ├─ YES → Use "Tablet" or "Capsule" unit
  └─ NO ↓

Is it a liquid?
  ├─ YES → Is it drinkable medicine?
  │   ├─ YES → Use "Syrup" unit
  │   └─ NO → Is it injectable?
  │       ├─ YES → Use "Injection" unit
  │       └─ NO → Use "Drops" unit (eye/ear)
  └─ NO ↓

Is it a cream/gel/paste?
  ├─ YES → Use "Ointment" unit
  └─ NO ↓

Is it a powder?
  └─ YES → Use "Powder" unit
```

---

## 🔑 FIELD MEANINGS AT A GLANCE

| Field | Means | Example |
|-------|-------|---------|
| **Pieces per Strip** | How many tablets in one blister pack | 10 |
| **Strips per Box** | How many blister packs in one box | 10 |
| **ML per Bottle** | Size of syrup bottle | 100ml |
| **Bottles per Box** | How many bottles in shipping box | 1 |
| **Vials per Box** | How many injection vials in box | 5 |
| **Grams per Tube** | Size of ointment tube | 30g |
| **Cost per X** | What you paid per unit | $0.05 |
| **Price per X** | What customer pays per unit | $0.10 |

---

## 💡 PRO TIPS

1. **Create units FIRST** - Set up all your unit types before adding medicines
2. **Use consistent naming** - "Tablet" not "Tablets", "Syrup" not "Syrups"
3. **Double-check math** - Strip price should = pieces × piece price
4. **Keep it simple** - Don't create too many unit variations
5. **Test one medicine** - Add one, sell it in POS, make sure it works

---

## 🆘 TROUBLESHOOTING

**Problem:** Unit not showing in dropdown  
**Solution:** Go to Add Medicine Units, make sure it's set to "Active"

**Problem:** Can't save medicine  
**Solution:** Check that all required fields are filled (Medicine Name, Unit)

**Problem:** Prices don't make sense in POS  
**Solution:** Recalculate: piece price × quantity should = total

**Problem:** Medicine shows $0.00 price  
**Solution:** Edit medicine, fill in all price fields

---

## 📍 NAVIGATION

**Add Medicine Units:** Pharmacy Menu → Add Medicine Units  
**Add Medicine:** Pharmacy Menu → Add Medicine  
**View Medicines:** Pharmacy Menu → Medicine Management

---

**PRINT THIS PAGE AND KEEP AT YOUR DESK!** 📌

---

*Quick Reference Card v1.0 - Juba Hospital Pharmacy System*
