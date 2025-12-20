# Medicine Examples: Topical & Special Forms

## 🎯 **Complete Examples for Topical & Specialized Medicines**

This guide covers:
- Topical medicines (Ointments, Creams, Gels)
- Special forms (Suppositories, Patches, Inhalers)
- Powders and Sprays

---

## 📚 **EXAMPLE 8: OINTMENT (Topical Semi-Solid)**

### **Scenario:** Register Betadine Ointment 30gm

---

### **STEP 1: CREATE UNIT TYPE**

**Page:** `add_medicine_units.aspx`

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE UNIT                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Unit Name: [Ointment________]                      │
│                                                     │
│  Unit Abbreviation: [Oint]                         │
│                                                     │
│  Selling Method: [weight ▼]                        │
│                                                     │
│  Base Unit Name: [gm___________]                    │
│                                                     │
│  Subdivision Unit: [tube_________]                  │
│                                                     │
│  Allows Subdivision: [☑] Yes                       │
│                                                     │
│  Unit Size Label: [grams per tube]                  │
│                                                     │
│  Is Active: [☑] Yes                                │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Configuration Explained:**

```yaml
Unit Name: Ointment
  - General category for topical semi-solid medications

Unit Abbreviation: Oint
  - Short form for labeling and reports

Selling Method: weight
  - Ointments are measured by weight (grams)
  - Not countable (not discrete units)
  - Not volume (not liquid)

Base Unit Name: gm
  - Individual grams
  - Can sell by gram if needed
  - Smallest sellable unit

Subdivision Unit: tube
  - Ointments come in tubes
  - One tube contains X grams
  - Primary selling unit

Allows Subdivision: YES
  - Can sell by tube OR by gram
  - Flexibility for different quantities

Unit Size Label: grams per tube
  - Describes the relationship
  - Example: "30 grams per tube"
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

**Page:** `add_medicine.aspx`

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE                               │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Medicine Name: [Betadine Ointment 10%_______]     │
│                                                     │
│  Generic Name: [Povidone-iodine______________]      │
│                                                     │
│  Manufacturer: [Mundipharma_________________]       │
│                                                     │
│  Unit Type: [Ointment ▼]                           │
│                                                     │
│  ┌─ Packaging Details ─────────────────┐           │
│  │  Grams per Tube: [30___]            │           │
│  │  Tubes per Box: [20___]             │           │
│  └─────────────────────────────────────┘           │
│                                                     │
│  ┌─ Cost Prices ──────────────────────┐            │
│  │  Cost per Gram: [0.40___]          │            │
│  │  Cost per Tube: [12.00___]         │            │
│  │  Cost per Box: [240.00___]         │            │
│  └────────────────────────────────────┘            │
│                                                     │
│  ┌─ Selling Prices ───────────────────┐            │
│  │  Price per Gram: [0.50___]         │            │
│  │  Price per Tube: [15.00___]        │            │
│  │  Price per Box: [300.00___]        │            │
│  └────────────────────────────────────┘            │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Pricing Breakdown:**

```
Grams per Tube: 30
└─ Each tube contains 30 grams of ointment

Tubes per Box: 20
└─ Each box contains 20 tubes

Cost per Gram: $0.40
└─ Purchase price per gram

Cost per Tube: $12.00
├─ Should equal: 30 gm × $0.40 = $12.00
└─ ✅ Consistent

Cost per Box: $240.00
├─ Should equal: 20 tubes × $12.00 = $240.00
└─ ✅ Consistent

Price per Gram: $0.50
├─ Selling price per gram
└─ Profit: $0.50 - $0.40 = $0.10 per gram (25% markup)

Price per Tube: $15.00
├─ Should equal: 30 gm × $0.50 = $15.00
├─ ✅ Consistent
└─ Profit per tube: $15.00 - $12.00 = $3.00

Price per Box: $300.00
├─ Should equal: 20 tubes × $15.00 = $300.00
├─ ✅ Consistent
└─ Profit per box: $300.00 - $240.00 = $60.00
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

**Page:** `medicine_inventory.aspx`

```
┌─────────────────────────────────────────────────────┐
│          ADD INVENTORY                              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Select Medicine: [Betadine Ointment 10% ▼]        │
│                                                     │
│  Primary Quantity (Tubes): [40____]                 │
│                                                     │
│  Secondary Quantity (Loose Grams): [0____]          │
│                                                     │
│  Unit Size: [30___] (grams per tube)                │
│                                                     │
│  Batch Number: [OINT-2024-001_________]             │
│                                                     │
│  Expiry Date: [31/12/2026_________]                 │
│                                                     │
│  Purchase Price: [12.00___]                         │
│                                                     │
│  Reorder Level: [10___] tubes                       │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Stock Calculation:**

```
Primary Quantity: 40 tubes
Secondary Quantity: 0 grams (no loose grams)
Unit Size: 30 grams per tube

Total Stock:
= (Primary × Unit Size) + Secondary
= (40 × 30) + 0
= 1200 grams

Box Display:
= 40 tubes ÷ 20 tubes per box
= 2 boxes + 0 remaining tubes

Display in POS: "2 boxes + 0 tubes + 0 loose gms"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

**Page:** `pharmacy_pos.aspx`

```
Search: Betadine

Results:
┌─────────────────────────────────────────────────────┐
│  🧴 Betadine Ointment 10%                           │
│  Generic: Povidone-iodine                           │
│  Manufacturer: Mundipharma                          │
│                                                     │
│  📦 Stock: 2 boxes + 0 tubes + 0 loose gms         │
│            ↑ Bold                                   │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Gm - $0.50 each                               │
│    • Tube (30 gms) - $15.00                        │
│    • Boxes (20 tubes = 600 gms) - $300.00          │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Selling Scenarios:**

### **Scenario A: Sell by Tube (Most Common)**

```
Customer: "I need 1 tube of Betadine ointment"

Select: "Tube (30 gms) - $15.00"
Quantity: 1
Total: $15.00

After Sale:
Stock: 40 - 1 = 39 tubes
Display: "1 boxes + 19 tubes + 0 loose gms"
```

### **Scenario B: Sell by Gram (Rare - Custom Amount)**

```
Hospital ward: "Need 90 grams for burn treatment"

Select: "Gm - $0.50 each"
Quantity: 90
Total: 90 × $0.50 = $45.00

Inventory Deduction:
Need 90 grams, tube contains 30 grams
Calculate: 90 ÷ 30 = 3 tubes needed
Deduct 3 tubes from primary quantity

After Sale:
Stock: 40 - 3 = 37 tubes
Display: "1 boxes + 17 tubes + 0 loose gms"
```

### **Scenario C: Sell by Box (Wholesale)**

```
Private clinic: "Need 1 box"

Select: "Boxes (20 tubes = 600 gms) - $300.00"
Quantity: 1
Total: $300.00

After Sale:
Stock: 40 - 20 = 20 tubes
Display: "1 boxes + 0 tubes + 0 loose gms"
```

---

## 📚 **EXAMPLE 9: CREAM (Similar to Ointment)**

### **Scenario:** Register Clotrimazole Cream 1% 20gm

---

### **Quick Setup:**

```
STEP 1: Create Unit "Cream"
├─ Selling Method: weight
├─ Base Unit: gm
├─ Subdivision: tube
└─ Same as Ointment!

STEP 2: Register Medicine
├─ Name: Clotrimazole Cream 1%
├─ Generic: Clotrimazole
├─ Grams per Tube: 20
├─ Tubes per Box: 20
├─ Price per Gram: $0.80
├─ Price per Tube: $16.00
└─ Price per Box: $320.00

STEP 3: Add Inventory
├─ 60 tubes (3 boxes)
└─ Total: 1200 grams

STEP 4: POS Display
├─ Stock: "3 boxes + 0 tubes + 0 loose gms"
└─ Sell Options:
    • Gm - $0.80 each
    • Tube (20 gms) - $16.00
    • Boxes (20 tubes = 400 gms) - $320.00
```

**Difference: Ointment vs Cream**

```
OINTMENT:
- Oil-based
- Greasy texture
- Better for dry skin
- Example: Betadine, Zinc oxide

CREAM:
- Water-based
- Non-greasy
- Better for moist areas
- Example: Antifungal, Steroid creams

System Treatment: IDENTICAL!
- Both use "weight" selling method
- Both measured in grams
- Both packaged in tubes
```

---

## 📚 **EXAMPLE 10: SUPPOSITORY**

### **Scenario:** Register Paracetamol Suppository 250mg

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Suppository
Unit Abbreviation: Supp
Selling Method: countable ← Different from ointment!
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES
Unit Size Label: pieces per pack
Is Active: YES
```

**Why "countable"?**
```
Suppositories are discrete units:
- Each suppository is one piece
- Can't divide a suppository
- Sold by count, not weight
- Similar to tablets, but different shape
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Paracetamol Suppository 250mg
Generic Name: Acetaminophen
Manufacturer: GSK
Unit Type: Suppository

Pieces per Pack: 5
Packs per Box: 10

Cost per Piece: $1.50
Cost per Pack: $7.50 (5 × $1.50)
Cost per Box: $75.00 (10 × $7.50)

Price per Piece: $2.00
Price per Pack: $10.00
Price per Box: $100.00
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Select Medicine: Paracetamol Suppository 250mg
Primary Quantity: 30 packs
Secondary Quantity: 3 pieces (loose)
Unit Size: 5 pieces per pack
Batch Number: SUPP-2024-001
Expiry Date: 30/06/2026
Purchase Price: $7.50
Reorder Level: 10 packs
```

**Stock Calculation:**

```
Total: (30 × 5) + 3 = 153 pieces
Boxes: 30 ÷ 10 = 3 boxes
Display: "3 boxes + 0 packs + 3 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Paracetamol Suppository

Results:
┌─────────────────────────────────────────────────────┐
│  💊 Paracetamol Suppository 250mg                   │
│  Generic: Acetaminophen                             │
│                                                     │
│  📦 Stock: 3 boxes + 0 packs + 3 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $2.00 each                            │
│    • Pack (5 pieces) - $10.00                      │
│    • Boxes (10 packs = 50 pieces) - $100.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Typical Sale:**

```
Parent needs suppositories for child

Select: "Pack (5 pieces) - $10.00"
Quantity: 1
Total: $10.00

Note: Usually sold by pack (5 pieces) for convenience

After Sale:
Stock: 2 boxes + 9 packs + 3 loose pieces
```

---

## 📚 **EXAMPLE 11: TRANSDERMAL PATCH**

### **Scenario:** Register Nicotine Patch 21mg

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Patch
Unit Abbreviation: Pch
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES
Unit Size Label: patches per pack
Is Active: YES
```

**Patch Characteristics:**
```
- Adhesive patches applied to skin
- Releases medication over time
- Each patch is one piece
- Usually sold by the piece or small pack
- Common types: Nicotine, Pain relief, Hormone
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Nicotine Patch 21mg (Step 1)
Generic Name: Nicotine
Manufacturer: Novartis
Unit Type: Patch

Pieces per Pack: 7
  (Usually weekly supply - 7 days)

Packs per Box: 4
  (4 weeks supply per box)

Cost per Piece: $4.00
Cost per Pack: $28.00 (7 × $4.00)
Cost per Box: $112.00 (4 × $28.00)

Price per Piece: $5.00
Price per Pack: $35.00
Price per Box: $140.00
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 12 packs
Secondary Quantity: 2 pieces
Total: (12 × 7) + 2 = 86 pieces
Boxes: 12 ÷ 4 = 3 boxes
Display: "3 boxes + 0 packs + 2 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Customer wants to quit smoking

Select: "Pack (7 pieces) - $35.00"
Quantity: 1
Total: $35.00

Note: One week supply
Customer applies 1 patch per day for 7 days

After Sale:
Stock: 2 boxes + 7 packs + 2 loose pieces
```

---

## 📚 **EXAMPLE 12: INHALER**

### **Scenario:** Register Ventolin Inhaler 100mcg

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Inhaler
Unit Abbreviation: Inh
Selling Method: countable
Base Unit Name: unit
Subdivision Unit: (leave empty)
Allows Subdivision: NO ← Important!
Unit Size Label: (leave empty)
Is Active: YES
```

**Why NO subdivision?**
```
Inhalers are complete devices:
- Can't break into smaller parts
- Sold as individual units only
- No strips, packs, or boxes for selling
- Each inhaler = 1 unit
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Ventolin Inhaler 100mcg
Generic Name: Salbutamol
Manufacturer: GSK
Unit Type: Inhaler

Units per Pack: 1 ← Only 1!
Packs per Box: 1 ← Only 1!

Cost per Unit: $20.00
Cost per Pack: $20.00 (no subdivision)
Cost per Box: $20.00 (no subdivision)

Price per Unit: $25.00
Price per Pack: $25.00
Price per Box: $25.00
```

**Note:** All three prices are the same because there's no subdivision!

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 0 ← Not used for single units
Secondary Quantity: 20 units ← Use this!
Unit Size: 1
Total: 20 units
```

**Alternative (Better):**
```
Primary Quantity: 20 units
Secondary Quantity: 0
Display: "20 units" (no boxes shown)
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Ventolin

Results:
┌─────────────────────────────────────────────────────┐
│  🫁 Ventolin Inhaler 100mcg                         │
│  Generic: Salbutamol                                │
│                                                     │
│  📦 Stock: 20 units                                 │
│          (No boxes - sold individually)             │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Unit - $25.00 each                            │
│    (Only one option!)                              │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Sale:**

```
Patient needs inhaler for asthma

Select: "Unit - $25.00 each"
Quantity: 1
Total: $25.00

After Sale:
Stock: 19 units
```

---

## 📊 **COMPARISON: TOPICAL & SPECIAL FORMS**

| Type | Method | Base Unit | Subdivision | Package | Example |
|------|--------|-----------|-------------|---------|---------|
| **Ointment** | weight | gm | tube | boxes | Betadine |
| **Cream** | weight | gm | tube | boxes | Antifungal |
| **Gel** | weight | gm | tube | boxes | Pain gel |
| **Suppository** | countable | piece | pack | boxes | Paracetamol |
| **Patch** | countable | piece | pack | boxes | Nicotine |
| **Inhaler** | countable | unit | none | none | Ventolin |

---

## 💡 **KEY LEARNINGS**

### **Weight-Based (Ointments, Creams, Gels)**

```
Characteristics:
✅ Measured in grams
✅ Come in tubes
✅ Can sell by gram or tube
✅ Usually have boxes

Setup:
- Selling Method: weight
- Base Unit: gm
- Subdivision: tube
- Allows Subdivision: YES
```

### **Countable Special Forms (Suppositories, Patches)**

```
Characteristics:
✅ Discrete units (can count them)
✅ Come in packs
✅ Can sell by piece or pack
✅ Have boxes

Setup:
- Selling Method: countable
- Base Unit: piece
- Subdivision: pack
- Allows Subdivision: YES
```

### **Single Units (Inhalers, Large Items)**

```
Characteristics:
✅ Sold as complete devices
✅ No subdivision
✅ Can't break into smaller parts
✅ Each is one unit

Setup:
- Selling Method: countable
- Base Unit: unit
- Subdivision: (none)
- Allows Subdivision: NO
```

---

**Guide Version:** 1.0  
**Examples Covered:** 5 topical & special types  
**Last Updated:** December 2024