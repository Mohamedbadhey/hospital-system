# 📋 Complete Guide: How to Enter Medicines in the Pharmacy System

This guide will walk you through **EXACTLY** how to add different types of medicines to your pharmacy system, step by step.

---

## 🎯 OVERVIEW: The 2-Step Process

### Step 1: Create a Unit Type (One-Time Setup)
First, you need to define what kind of medicine unit it is (Tablet, Syrup, Injection, etc.)

### Step 2: Add the Medicine
Then you can add specific medicines using that unit type.

---

# 📚 PART 1: CREATING MEDICINE UNITS

## Where to Go
**Navigate to:** Pharmacy → **Add Medicine Units** (`add_medicine_units.aspx`)

## The Form Fields Explained

When you click "Add Unit", you'll see a modal with these fields:

### 1. **Unit Name** (Required)
- **What it is:** The main category name for this type of medicine
- **Examples:** Tablet, Syrup, Injection, Ointment, Capsule, Drops

### 2. **Unit Abbreviation**
- **What it is:** Short form (max 10 characters)
- **Examples:** Tab, Syr, Inj, Oint, Cap, Drp

### 3. **Selling Method** (Required)
Choose one of three options:
- **Countable:** For items you count (tablets, bottles, vials, tubes)
- **Volume:** For liquids measured in ml/liters (syrups, IV fluids)
- **Weight:** For items measured by weight (powders, ointments)

### 4. **Base Unit Name**
- **What it is:** The smallest individual item you sell
- **For Tablets:** piece
- **For Syrup:** bottle or ml
- **For Injections:** vial or ampoule
- **For Ointment:** tube
- **For Capsules:** piece

### 5. **Allows Subdivision** (Checkbox)
- **Check YES if:** The medicine can be packaged in groups
- **Example:** Tablets come in strips, strips come in boxes
- **Check NO if:** You only sell individual items

### 6. **Subdivision Unit** (Appears if you checked "Allows Subdivision")
- **What it is:** The packaging/grouping name
- **For Tablets:** strip (tablets come in strips)
- **For Syrup:** bottle (if selling by ml)
- **For Injections:** box or pack

### 7. **Unit Size Label**
- **What it is:** Describes the relationship between base unit and subdivision
- **Examples:**
  - "pieces per strip"
  - "ml per bottle"
  - "vials per box"
  - "tablets per blister"

### 8. **Is Active** (Checkbox)
- **Keep checked** to make this unit available for use
- **Uncheck** to deactivate (for old/obsolete units)

---

## 🔥 COMMON EXAMPLES: How to Fill the Form

### Example 1: TABLETS (Most Common)

```
✓ Unit Name: Tablet
✓ Abbreviation: Tab
✓ Selling Method: countable
✓ Base Unit Name: piece
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: strip
✓ Unit Size Label: pieces per strip
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 2: SYRUP (Liquid Medicine)

```
✓ Unit Name: Syrup
✓ Abbreviation: Syr
✓ Selling Method: volume
✓ Base Unit Name: ml
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: bottle
✓ Unit Size Label: ml per bottle
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 3: INJECTION

```
✓ Unit Name: Injection
✓ Abbreviation: Inj
✓ Selling Method: countable
✓ Base Unit Name: vial
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: box
✓ Unit Size Label: vials per box
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 4: OINTMENT/CREAM

```
✓ Unit Name: Ointment
✓ Abbreviation: Oint
✓ Selling Method: countable
✓ Base Unit Name: tube
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: box
✓ Unit Size Label: tubes per box
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 5: CAPSULES

```
✓ Unit Name: Capsule
✓ Abbreviation: Cap
✓ Selling Method: countable
✓ Base Unit Name: piece
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: strip
✓ Unit Size Label: pieces per strip
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 6: EYE/EAR DROPS

```
✓ Unit Name: Drops
✓ Abbreviation: Drp
✓ Selling Method: volume
✓ Base Unit Name: ml
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: bottle
✓ Unit Size Label: ml per bottle
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 7: IV FLUIDS

```
✓ Unit Name: IV Fluid
✓ Abbreviation: IV
✓ Selling Method: volume
✓ Base Unit Name: ml
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: bag
✓ Unit Size Label: ml per bag
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

### Example 8: POWDER (e.g., Oral Rehydration Salts)

```
✓ Unit Name: Powder
✓ Abbreviation: Pwd
✓ Selling Method: weight
✓ Base Unit Name: gram
✓ Allows Subdivision: ✓ YES
✓ Subdivision Unit: sachet
✓ Unit Size Label: grams per sachet
✓ Is Active: ✓ YES
```

**Click SAVE** ✅

---

# 📚 PART 2: ADDING MEDICINES

## Where to Go
**Navigate to:** Pharmacy → **Add Medicine** (`add_medicine.aspx`)

## The Form Fields Explained

When you click "Add Medicine", you'll see a modal with these sections:

### SECTION 1: Basic Information

#### 1. **Medicine Name** (Required)
- **What it is:** Brand name or common name with strength
- **Examples:**
  - Paracetamol 500mg
  - Amoxicillin 250mg
  - Augmentin 625mg
  - Panadol Extra

#### 2. **Generic Name**
- **What it is:** The scientific/generic name
- **Examples:**
  - Paracetamol → Acetaminophen
  - Amoxicillin → Amoxicillin
  - Augmentin → Amoxicillin + Clavulanic Acid

#### 3. **Manufacturer**
- **What it is:** Company that makes the medicine
- **Examples:**
  - GSK Pharmaceuticals
  - Pfizer
  - Cipla
  - Abbott

#### 4. **Barcode** (Optional)
- **What it is:** Product barcode for scanning
- **How to use:** Scan with barcode scanner or type manually
- Leave blank if not available

#### 5. **Unit Type** (Required - Dropdown)
- **What it is:** Select the unit you created in Part 1
- **Examples:** Tablet, Syrup, Injection, Ointment, etc.

### SECTION 2: Packaging Details (Appears after selecting Unit)

The fields you see here **depend on the unit type** you selected:

#### For Tablets/Capsules:
- **Pieces per Strip:** How many tablets in one strip (e.g., 10)
- **Strips per Box:** How many strips in one box (e.g., 10)

#### For Syrups:
- **ML per Bottle:** Size of bottle (e.g., 100ml)
- **Bottles per Box:** How many bottles in a box (e.g., 1)

#### For Injections:
- **Vials per Box:** How many vials in one box (e.g., 5)
- **ML per Vial:** Size of each vial (e.g., 2ml)

#### For Ointments:
- **Tubes per Box:** How many tubes in a box (e.g., 1)
- **Grams per Tube:** Size of tube (e.g., 30g)

### SECTION 3: Cost Prices (What you paid)

#### 1. **Cost per [Base Unit]** (e.g., Cost per Piece)
- **What it is:** How much ONE piece costs you from supplier
- **Example:** If you bought 100 tablets for $10, cost per piece = $0.10

#### 2. **Cost per [Subdivision]** (e.g., Cost per Strip)
- **What it is:** Cost for one strip/bottle/box
- **Example:** If strip has 10 pieces at $0.10 each, cost per strip = $1.00

#### 3. **Cost per Box**
- **What it is:** Cost for full box
- **Example:** If box has 10 strips at $1.00 each, cost per box = $10.00

### SECTION 4: Selling Prices (What customers pay)

#### 1. **Price per [Base Unit]** (e.g., Price per Piece)
- **What it is:** Selling price for ONE piece
- **Example:** You sell one tablet for $0.20 (profit = $0.10)

#### 2. **Price per [Subdivision]** (e.g., Price per Strip)
- **What it is:** Selling price for one strip
- **Example:** You sell one strip for $2.50 (profit = $1.50)

#### 3. **Price per Box**
- **What it is:** Selling price for full box
- **Example:** You sell full box for $20.00 (profit = $10.00)

---

## 🔥 COMPLETE EXAMPLES: Step-by-Step Medicine Entry

### Example 1: PARACETAMOL TABLETS

**STEP 1: Fill Basic Info**
```
Medicine Name: Paracetamol 500mg
Generic Name: Acetaminophen
Manufacturer: GSK Pharmaceuticals
Barcode: (leave blank or scan)
Unit Type: Select "Tablet" from dropdown
```

**STEP 2: Fill Packaging Details**
```
Pieces per Strip: 10
Strips per Box: 10
```

**STEP 3: Fill Cost Prices**
```
Scenario: You bought a box of 100 tablets (10 strips × 10 pieces) for $5.00

Cost per Piece: $0.05
Cost per Strip: $0.50 (10 pieces × $0.05)
Cost per Box: $5.00 (10 strips × $0.50)
```

**STEP 4: Fill Selling Prices**
```
Price per Piece: $0.10 (50% markup)
Price per Strip: $1.00 (customers save when buying strip)
Price per Box: $9.00 (best deal for bulk buyers)
```

**CLICK SAVE** ✅

---

### Example 2: AMOXICILLIN SYRUP

**STEP 1: Fill Basic Info**
```
Medicine Name: Amoxicillin 250mg/5ml Syrup
Generic Name: Amoxicillin
Manufacturer: Cipla
Barcode: (optional)
Unit Type: Select "Syrup" from dropdown
```

**STEP 2: Fill Packaging Details**
```
ML per Bottle: 100
Bottles per Box: 1
```

**STEP 3: Fill Cost Prices**
```
Scenario: You bought one 100ml bottle for $3.00

Cost per ML: $0.03
Cost per Bottle: $3.00 (100ml × $0.03)
Cost per Box: $3.00 (1 bottle)
```

**STEP 4: Fill Selling Prices**
```
Price per ML: $0.05 (if selling by ml - rare)
Price per Bottle: $5.00 (most common)
Price per Box: $5.00 (same as bottle)
```

**CLICK SAVE** ✅

---

### Example 3: INSULIN INJECTION

**STEP 1: Fill Basic Info**
```
Medicine Name: Insulin Glargine 100IU
Generic Name: Insulin Glargine
Manufacturer: Novo Nordisk
Barcode: (scan if available)
Unit Type: Select "Injection" from dropdown
```

**STEP 2: Fill Packaging Details**
```
Vials per Box: 5
ML per Vial: 10
```

**STEP 3: Fill Cost Prices**
```
Scenario: Box of 5 vials costs $50.00

Cost per Vial: $10.00
Cost per Box: $50.00 (5 vials × $10.00)
```

**STEP 4: Fill Selling Prices**
```
Price per Vial: $15.00
Price per Box: $70.00 (slight discount for box)
```

**CLICK SAVE** ✅

---

### Example 4: HYDROCORTISONE OINTMENT

**STEP 1: Fill Basic Info**
```
Medicine Name: Hydrocortisone 1% Ointment
Generic Name: Hydrocortisone
Manufacturer: Abbott
Barcode: (optional)
Unit Type: Select "Ointment" from dropdown
```

**STEP 2: Fill Packaging Details**
```
Tubes per Box: 1
Grams per Tube: 30
```

**STEP 3: Fill Cost Prices**
```
Scenario: One 30g tube costs $2.00

Cost per Tube: $2.00
Cost per Box: $2.00 (1 tube)
```

**STEP 4: Fill Selling Prices**
```
Price per Tube: $4.00
Price per Box: $4.00 (same as tube)
```

**CLICK SAVE** ✅

---

## 💡 PRICING TIPS

### How to Calculate Prices:

1. **Know Your Cost:** Total amount you paid ÷ Total quantity = Cost per unit
2. **Add Markup:** Cost × (1 + markup %) = Selling price
3. **Common Markups:**
   - Essential medicines: 20-50% markup
   - Regular medicines: 50-100% markup
   - Specialty medicines: 100-200% markup

### Example Calculation:
```
You bought: Box of 100 tablets for $10.00

Cost per Piece = $10.00 ÷ 100 = $0.10

Selling Prices (50% markup):
- Per Piece: $0.10 × 1.50 = $0.15
- Per Strip (10 pieces): $0.15 × 10 = $1.50
- Per Box (100 pieces): $0.15 × 100 = $15.00
```

---

## ✅ QUICK REFERENCE: Unit Types to Create

Before you start adding medicines, create these common units:

| Unit Name | Base Unit | Subdivision | Use For |
|-----------|-----------|-------------|---------|
| Tablet | piece | strip | Pills, tablets |
| Capsule | piece | strip | Capsules |
| Syrup | ml | bottle | Liquid medicines |
| Injection | vial | box | Injectable drugs |
| Ointment | tube | box | Creams, gels |
| Drops | ml | bottle | Eye/ear drops |
| IV Fluid | ml | bag | IV solutions |
| Powder | gram | sachet | ORS, powders |

---

## 🎯 WORKFLOW SUMMARY

### First Time Setup:
1. Go to **Add Medicine Units**
2. Create all unit types you need (Tablet, Syrup, etc.)
3. Now you're ready to add medicines!

### Adding Each Medicine:
1. Go to **Add Medicine**
2. Fill in medicine details
3. Select the appropriate unit type
4. Enter packaging details
5. Enter cost and selling prices
6. Save

### After Adding Medicine:
- Medicine appears in the medicines list
- You can now add inventory stock
- You can sell it in POS

---

## 📞 NEED HELP?

**Common Issues:**
- **Unit not showing in dropdown?** Make sure it's set to "Active" in Add Medicine Units
- **Prices seem wrong?** Double-check your calculations, especially pieces per strip/box
- **Can't save?** Make sure all required fields (marked with *) are filled

---

**Guide Created:** December 2024  
**System:** Juba Hospital Management System  
**Module:** Pharmacy Management
