# Medicine Examples: Injections, IV Solutions & Drops

## 🎯 **Complete Examples for Injectable & Liquid Medicines**

This guide provides detailed step-by-step examples for:
- Injectable medicines (Injections, Vials, Ampoules)
- IV Solutions (Large volume parenterals)
- Topical drops (Eye, Ear, Nasal)

---

## 📚 **EXAMPLE 4: INJECTABLE MEDICINE (Vials)**

### **Scenario:** Register Diclofenac Injection 75mg/3ml

---

### **STEP 1: CREATE UNIT TYPE**

**Page:** `add_medicine_units.aspx`

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE UNIT                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Unit Name: [Injection_______]                      │
│                                                     │
│  Unit Abbreviation: [Inj]                          │
│                                                     │
│  Selling Method: [volume ▼]                        │
│                                                     │
│  Base Unit Name: [ml__________]                     │
│                                                     │
│  Subdivision Unit: [vial________]                   │
│                                                     │
│  Allows Subdivision: [☑] Yes                       │
│                                                     │
│  Unit Size Label: [ml per vial]                     │
│                                                     │
│  Is Active: [☑] Yes                                │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Configuration Details:**

```yaml
Unit Name: Injection
Unit Abbreviation: Inj
Selling Method: volume
  Why: Injectable liquids are measured by volume (ml)

Base Unit Name: ml
  Why: Can sell by individual ml if needed

Subdivision Unit: vial
  Why: Injections come in vials (small bottles)

Allows Subdivision: YES
  Why: Can sell by ml OR by vial

Unit Size Label: ml per vial
  Example: "3 ml per vial" for Diclofenac
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
│  Medicine Name: [Diclofenac Injection 75mg/3ml__]  │
│                                                     │
│  Generic Name: [Diclofenac Sodium_____________]     │
│                                                     │
│  Manufacturer: [Novartis Pharma______________]      │
│                                                     │
│  Unit Type: [Injection ▼]                          │
│                                                     │
│  ┌─ Packaging Details ─────────────────┐           │
│  │  ML per Vial: [3____]               │           │
│  │  Vials per Box: [50__]              │           │
│  └─────────────────────────────────────┘           │
│                                                     │
│  ┌─ Cost Prices ──────────────────────┐            │
│  │  Cost per ML: [0.50___]            │            │
│  │  Cost per Vial: [1.50___]          │            │
│  │  Cost per Box: [75.00___]          │            │
│  └────────────────────────────────────┘            │
│                                                     │
│  ┌─ Selling Prices ───────────────────┐            │
│  │  Price per ML: [0.70___]           │            │
│  │  Price per Vial: [2.10___]         │            │
│  │  Price per Box: [105.00___]        │            │
│  └────────────────────────────────────┘            │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Entry Breakdown:**

```
Medicine Name: Diclofenac Injection 75mg/3ml
├─ "75mg" = Drug strength
└─ "3ml" = Volume per vial

Generic Name: Diclofenac Sodium
└─ Active pharmaceutical ingredient

Unit Type: Injection
└─ Select from dropdown (created in Step 1)

ML per Vial: 3
└─ Each vial contains 3ml

Vials per Box: 50
└─ One box contains 50 vials

Cost per ML: $0.50
├─ Purchase price per milliliter
└─ Total cost per vial: 3ml × $0.50 = $1.50

Cost per Vial: $1.50
└─ Should equal: ML per Vial × Cost per ML

Cost per Box: $75.00
└─ Should equal: Vials per Box × Cost per Vial
└─ Calculation: 50 × $1.50 = $75.00

Price per ML: $0.70
├─ Selling price per milliliter
├─ Markup: ($0.70 - $0.50) = $0.20 per ml
└─ Markup %: ($0.20 / $0.50) × 100 = 40%

Price per Vial: $2.10
└─ Should equal: 3ml × $0.70 = $2.10

Price per Box: $105.00
└─ Should equal: 50 × $2.10 = $105.00
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
│  Select Medicine: [Diclofenac Injection 75mg/3ml ▼]│
│                                                     │
│  Primary Quantity (Vials): [150___]                 │
│                                                     │
│  Secondary Quantity (Loose ML): [0___]              │
│                                                     │
│  Unit Size: [3___] (ml per vial)                    │
│                                                     │
│  Batch Number: [INJ-2024-001______]                 │
│                                                     │
│  Expiry Date: [31/12/2026________]                  │
│                                                     │
│  Purchase Price: [1.50___]                          │
│                                                     │
│  Reorder Level: [20___] vials                       │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Stock Calculation:**

```
Primary Quantity: 150 vials
Secondary Quantity: 0 ml (no loose ml)
Unit Size: 3 ml per vial

Total Stock:
= (Primary × Unit Size) + Secondary
= (150 × 3) + 0
= 450 ml

Box Display:
= 150 vials ÷ 50 vials per box
= 3 boxes + 0 remaining vials

Display: "3 boxes + 0 vials + 0 loose mls"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

**Page:** `pharmacy_pos.aspx`

**Search Medicine:**

```
Search Box: [Diclofenac____] [🔍 Search]

Results:
┌─────────────────────────────────────────────────────┐
│  💉 Diclofenac Injection 75mg/3ml                   │
│  Generic: Diclofenac Sodium                         │
│  Manufacturer: Novartis Pharma                      │
│                                                     │
│  📦 Stock: 3 boxes + 0 vials + 0 loose mls         │
│            ↑ Bold                                   │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • By Volume (ml) - $0.70 each                   │
│    • Vial (3 mls) - $2.10                          │
│    • Boxes (50 vials = 150 mls) - $105.00          │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Selling Options:**

### **Option A: Sell by Vial (Most Common)**

```
Select: "Vial (3 mls) - $2.10"
Quantity: 10 vials
Total: 10 × $2.10 = $21.00

Add to Cart → $21.00

After Sale:
Stock: 150 - 10 = 140 vials
Display: "2 boxes + 40 vials + 0 loose mls"
```

### **Option B: Sell by ML (Rare)**

```
Select: "By Volume (ml) - $0.70 each"
Quantity: 15 ml
Total: 15 × $0.70 = $10.50

Inventory Deduction:
Need 15ml, vial contains 3ml
Break vials: 15ml ÷ 3ml = 5 vials
Deduct 5 vials from primary quantity

After Sale:
Stock: 150 - 5 = 145 vials
```

### **Option C: Sell by Box (Wholesale)**

```
Select: "Boxes (50 vials = 150 mls) - $105.00"
Quantity: 1 box
Total: 1 × $105.00 = $105.00

After Sale:
Stock: 150 - 50 = 100 vials
Display: "2 boxes + 0 vials + 0 loose mls"
```

---

## 📚 **EXAMPLE 5: IV SOLUTION (Large Volume)**

### **Scenario:** Register Normal Saline 0.9% 500ml

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: IV Solution
Unit Abbreviation: IV
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bag
Allows Subdivision: YES
Unit Size Label: ml per bag
Is Active: YES
```

**Why "bag" instead of "bottle"?**
- IV solutions typically come in flexible plastic bags
- Bags are designed for intravenous infusion
- Common sizes: 250ml, 500ml, 1000ml bags

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Normal Saline 0.9% 500ml
Generic Name: Sodium Chloride 0.9%
Manufacturer: Baxter Healthcare
Unit Type: IV Solution

ML per Bag: 500
Bags per Box: 20

Cost per ML: $0.01
Cost per Bag: $5.00 (500ml × $0.01)
Cost per Box: $100.00 (20 bags × $5.00)

Price per ML: $0.015
Price per Bag: $7.50 (500ml × $0.015)
Price per Box: $150.00 (20 bags × $7.50)
```

**Pricing Note:**
```
IV solutions have low per-ml pricing because:
- Large volumes (500ml-1000ml per bag)
- But total per bag is still significant
- Example: $0.015/ml × 500ml = $7.50 per bag
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Select Medicine: Normal Saline 0.9% 500ml
Primary Quantity: 60 bags
Secondary Quantity: 0 ml
Unit Size: 500 ml per bag
Batch Number: IV-NS-2024-001
Expiry Date: 31/12/2026
Purchase Price: $5.00
Reorder Level: 20 bags
```

**Stock Calculation:**

```
Total Stock: 60 bags × 500ml = 30,000 ml
Box Display: 60 bags ÷ 20 bags per box = 3 boxes
Display: "3 boxes + 0 bags + 0 loose mls"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Normal Saline

Results:
┌─────────────────────────────────────────────────────┐
│  💧 Normal Saline 0.9% 500ml                        │
│  Generic: Sodium Chloride 0.9%                      │
│                                                     │
│  📦 Stock: 3 boxes + 0 bags + 0 loose mls          │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • By Volume (ml) - $0.015 each                  │
│    • Bag (500 mls) - $7.50                         │
│    • Boxes (20 bags = 10000 mls) - $150.00         │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Common Sale:**

```
Hospital ward needs 10 bags

Select: "Bag (500 mls) - $7.50"
Quantity: 10
Total: 10 × $7.50 = $75.00

After Sale:
Stock: 60 - 10 = 50 bags
Display: "2 boxes + 10 bags + 0 loose mls"
```

---

## 📚 **EXAMPLE 6: EYE DROPS**

### **Scenario:** Register Antibiotic Eye Drops 5ml

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Drops
Unit Abbreviation: Drop
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES
Unit Size Label: ml per bottle
Is Active: YES
```

**Why Drops are Special:**
- Very small volumes (3ml, 5ml, 10ml bottles)
- High price per ml (concentrated medication)
- Usually dispensed as complete bottles, not loose ml

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Antibiotic Eye Drops 5ml
Generic Name: Chloramphenicol 0.5%
Manufacturer: Allergan
Unit Type: Drops

ML per Bottle: 5
Bottles per Box: 10

Cost per ML: $2.00
Cost per Bottle: $10.00 (5ml × $2.00)
Cost per Box: $100.00 (10 bottles × $10.00)

Price per ML: $3.00
Price per Bottle: $15.00 (5ml × $3.00)
Price per Box: $150.00 (10 bottles × $15.00)
```

**Pricing Note:**
```
Eye drops are expensive per ml because:
- Sterile preparation
- Small volumes
- Specific concentration
- Special packaging

Example: $3.00/ml for eye drops vs $0.10/ml for syrup
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Select Medicine: Antibiotic Eye Drops 5ml
Primary Quantity: 30 bottles
Secondary Quantity: 0 ml
Unit Size: 5 ml per bottle
Batch Number: ED-2024-001
Expiry Date: 30/06/2026
Purchase Price: $10.00
Reorder Level: 10 bottles
```

**Stock Calculation:**

```
Total: 30 bottles × 5ml = 150 ml
Boxes: 30 ÷ 10 = 3 boxes
Display: "3 boxes + 0 bottles + 0 loose mls"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Eye Drops

Results:
┌─────────────────────────────────────────────────────┐
│  👁️ Antibiotic Eye Drops 5ml                        │
│  Generic: Chloramphenicol 0.5%                      │
│                                                     │
│  📦 Stock: 3 boxes + 0 bottles + 0 loose mls       │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • By Volume (ml) - $3.00 each                   │
│    • Bottle (5 mls) - $15.00                       │
│    • Boxes (10 bottles = 50 mls) - $150.00         │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Typical Sale:**

```
Patient needs eye drops

Select: "Bottle (5 mls) - $15.00"
Quantity: 1
Total: $15.00

Note: Rarely sell by ml for drops - always sell complete bottles!

After Sale:
Stock: 30 - 1 = 29 bottles
Display: "2 boxes + 9 bottles + 0 loose mls"
```

---

## 📚 **EXAMPLE 7: AMPOULES (Glass Injectables)**

### **Scenario:** Register Adrenaline 1mg/ml Ampoule

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Ampoule
Unit Abbreviation: Amp
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES
Unit Size Label: ampoules per pack
Is Active: YES
```

**Ampoule vs Vial:**
```
AMPOULE:
- Glass sealed container
- Single-use (must break to open)
- Usually 1ml, 2ml, 5ml
- Counted as pieces, not volume
- Example: Adrenaline, Vitamins

VIAL:
- Rubber-stoppered bottle
- Multi-dose possible
- Usually larger volumes (3ml, 5ml, 10ml)
- Can be measured by volume
- Example: Insulin, Antibiotics
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Adrenaline 1mg/ml Ampoule
Generic Name: Epinephrine
Manufacturer: Pfizer
Unit Type: Ampoule

Pieces per Pack: 10
Packs per Box: 10

Cost per Piece: $2.00
Cost per Pack: $20.00 (10 × $2.00)
Cost per Box: $200.00 (10 × $20.00)

Price per Piece: $3.00
Price per Pack: $30.00
Price per Box: $300.00
```

**Note:** Ampoules are sold by piece count, not by ml!

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Select Medicine: Adrenaline 1mg/ml Ampoule
Primary Quantity: 50 packs
Secondary Quantity: 5 pieces (loose ampoules)
Unit Size: 10 ampoules per pack
Batch Number: AMP-ADR-2024
Expiry Date: 31/03/2026
Purchase Price: $20.00
Reorder Level: 10 packs
```

**Stock Calculation:**

```
Total: (50 × 10) + 5 = 505 ampoules
Boxes: 50 ÷ 10 = 5 boxes
Display: "5 boxes + 0 packs + 5 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Adrenaline

Results:
┌─────────────────────────────────────────────────────┐
│  💉 Adrenaline 1mg/ml Ampoule                       │
│  Generic: Epinephrine                               │
│                                                     │
│  📦 Stock: 5 boxes + 0 packs + 5 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $3.00 each                            │
│    • Pack (10 pieces) - $30.00                     │
│    • Boxes (10 packs = 100 pieces) - $300.00       │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Emergency Department Order:**

```
Need 3 ampoules for emergency use

Select: "Piece - $3.00 each"
Quantity: 3
Total: $9.00

After Sale:
Stock: 5 boxes + 0 packs + 2 loose pieces
Total: 502 ampoules
```

---

## 📊 **COMPARISON TABLE: Injectable Types**

| Type | Selling Method | Typical Volume | Container | Common Uses |
|------|---------------|----------------|-----------|-------------|
| **Injection (Vial)** | volume | 3ml, 5ml, 10ml | Rubber-stopped bottle | Antibiotics, Pain relief |
| **IV Solution** | volume | 500ml, 1000ml | Plastic bag | Hydration, Electrolytes |
| **Drops** | volume | 3ml, 5ml, 10ml | Dropper bottle | Eye, Ear, Nose |
| **Ampoule** | countable | 1ml, 2ml, 5ml | Sealed glass | Emergency drugs |

---

## 💡 **PRACTICAL USE CASES**

### **Hospital Pharmacy Scenario:**

```
Morning Stock Check:
───────────────────

1. Diclofenac Injection
   Stock: 140 vials (2 boxes + 40 vials)
   Status: ✅ Good (above 20 reorder level)

2. Normal Saline 500ml
   Stock: 50 bags (2 boxes + 10 bags)
   Status: ⚠️ Medium (near 20 reorder level)
   Action: Consider reordering

3. Eye Drops
   Stock: 29 bottles (2 boxes + 9 bottles)
   Status: ✅ Good

4. Adrenaline Ampoules
   Stock: 502 pieces (5 boxes + 2 loose)
   Status: ✅ Excellent (emergency stock maintained)
```

### **Ward Request Fulfillment:**

```
Request from ICU:
─────────────────
• 5 Diclofenac Injection vials
• 10 Normal Saline 500ml bags
• 2 Adrenaline ampoules

Process in POS:
1. Select Diclofenac → 5 vials × $2.10 = $10.50
2. Select Normal Saline → 10 bags × $7.50 = $75.00
3. Select Adrenaline → 2 pieces × $3.00 = $6.00

Total: $91.50
Generate internal transfer invoice
```

---

## 🎓 **KEY LEARNINGS**

### **Injectable Medicines:**

1. **Vials** - Use "volume" selling method
   - Sold by vial or ml
   - Multi-dose possible
   - Common for antibiotics

2. **IV Solutions** - Use "volume" selling method
   - Large volumes (500ml-1000ml)
   - Low price per ml
   - High total per bag

3. **Drops** - Use "volume" selling method
   - Small volumes (3ml-10ml)
   - High price per ml
   - Usually sold as complete bottles

4. **Ampoules** - Use "countable" selling method
   - Counted as pieces
   - Single-use glass containers
   - Broken to access contents

---

## 📋 **QUICK SETUP REFERENCE**

### **Injectable Vial:**
```
Unit: Injection | Method: volume | Base: ml | Sub: vial
Example: Diclofenac 75mg/3ml
```

### **IV Solution:**
```
Unit: IV Solution | Method: volume | Base: ml | Sub: bag
Example: Normal Saline 500ml
```

### **Eye/Ear Drops:**
```
Unit: Drops | Method: volume | Base: ml | Sub: bottle
Example: Antibiotic Eye Drops 5ml
```

### **Ampoule:**
```
Unit: Ampoule | Method: countable | Base: piece | Sub: pack
Example: Adrenaline 1mg/ml
```

---

**Guide Version:** 1.0  
**Examples Covered:** 4 injectable types  
**Target Users:** Hospital pharmacies, Clinics  
**Last Updated:** December 2024