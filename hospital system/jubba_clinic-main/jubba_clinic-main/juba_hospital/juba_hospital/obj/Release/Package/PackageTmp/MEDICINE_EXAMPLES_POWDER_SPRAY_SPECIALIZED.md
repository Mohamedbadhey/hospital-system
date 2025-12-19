# Medicine Examples: Powders, Sprays & Specialized Forms

## 🎯 **Complete Examples for Powders, Sprays & Special Medications**

This guide covers:
- Powder medicines (Sachets, Bottles)
- Spray medications (Nasal, Throat, Topical)
- Specialized forms (Lozenges, Effervescent, Pessaries)

---

## 📚 **EXAMPLE 13: SACHET (Powder Packets)**

### **Scenario:** Register ORS (Oral Rehydration Salt) Sachets

---

### **STEP 1: CREATE UNIT TYPE**

**Page:** `add_medicine_units.aspx`

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE UNIT                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Unit Name: [Sachet_________]                       │
│                                                     │
│  Unit Abbreviation: [Sach]                         │
│                                                     │
│  Selling Method: [countable ▼]                     │
│                                                     │
│  Base Unit Name: [piece________]                    │
│                                                     │
│  Subdivision Unit: [pack_________]                  │
│                                                     │
│  Allows Subdivision: [☑] Yes                       │
│                                                     │
│  Unit Size Label: [sachets per pack]                │
│                                                     │
│  Is Active: [☑] Yes                                │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Configuration Explained:**

```yaml
Unit Name: Sachet
  - Individual powder packets
  - Common for ORS, vitamins, supplements

Unit Abbreviation: Sach
  - Standard medical abbreviation

Selling Method: countable
  - Each sachet is one discrete unit
  - Count individual packets
  - Not measured by weight or volume

Base Unit Name: piece
  - Individual sachet = 1 piece
  - Can sell single sachets

Subdivision Unit: pack
  - Multiple sachets bundled together
  - Example: 10 sachets per pack

Allows Subdivision: YES
  - Can sell by piece (individual sachet)
  - Or by pack (multiple sachets)

Unit Size Label: sachets per pack
  - Clear description
  - Example: "10 sachets per pack"
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
│  Medicine Name: [ORS Oral Rehydration Salt____]    │
│                                                     │
│  Generic Name: [Electrolyte Solution_________]      │
│                                                     │
│  Manufacturer: [WHO Formula_________________]       │
│                                                     │
│  Unit Type: [Sachet ▼]                             │
│                                                     │
│  ┌─ Packaging Details ─────────────────┐           │
│  │  Pieces per Pack: [10__]            │           │
│  │  Packs per Box: [10__]              │           │
│  └─────────────────────────────────────┘           │
│                                                     │
│  ┌─ Cost Prices ──────────────────────┐            │
│  │  Cost per Piece: [0.25___]         │            │
│  │  Cost per Pack: [2.50___]          │            │
│  │  Cost per Box: [25.00___]          │            │
│  └────────────────────────────────────┘            │
│                                                     │
│  ┌─ Selling Prices ───────────────────┐            │
│  │  Price per Piece: [0.30___]        │            │
│  │  Price per Pack: [3.00___]         │            │
│  │  Price per Box: [30.00___]         │            │
│  └────────────────────────────────────┘            │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

**Pricing Breakdown:**

```
Pieces per Pack: 10 sachets
Packs per Box: 10 packs

Cost per Piece: $0.25
└─ Purchase price per sachet

Cost per Pack: $2.50
├─ 10 sachets × $0.25 = $2.50
└─ ✅ Consistent

Cost per Box: $25.00
├─ 10 packs × $2.50 = $25.00
└─ ✅ Consistent

Price per Piece: $0.30
└─ Markup: $0.05 per sachet (20%)

Price per Pack: $3.00
├─ 10 × $0.30 = $3.00
└─ ✅ Consistent

Price per Box: $30.00
├─ 10 × $3.00 = $30.00
└─ ✅ Consistent
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Select Medicine: ORS Oral Rehydration Salt
Primary Quantity: 50 packs
Secondary Quantity: 8 pieces (loose sachets)
Unit Size: 10 sachets per pack
Batch Number: ORS-2024-001
Expiry Date: 31/12/2025
Purchase Price: $2.50
Reorder Level: 20 packs
```

**Stock Calculation:**

```
Total: (50 × 10) + 8 = 508 sachets
Boxes: 50 ÷ 10 = 5 boxes
Display: "5 boxes + 0 packs + 8 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: ORS

Results:
┌─────────────────────────────────────────────────────┐
│  💧 ORS Oral Rehydration Salt                       │
│  Generic: Electrolyte Solution                      │
│                                                     │
│  📦 Stock: 5 boxes + 0 packs + 8 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $0.30 each                            │
│    • Pack (10 pieces) - $3.00                      │
│    • Boxes (10 packs = 100 pieces) - $30.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Selling Scenarios:**

### **Scenario A: Individual Sachets**

```
Parent: "My child has diarrhea, I need 5 ORS sachets"

Select: "Piece - $0.30 each"
Quantity: 5
Total: $1.50

After Sale:
Stock: 5 boxes + 0 packs + 3 loose pieces
```

### **Scenario B: By Pack**

```
Clinic: "Need 3 packs for stock"

Select: "Pack (10 pieces) - $3.00"
Quantity: 3
Total: $9.00

After Sale:
Stock: 4 boxes + 7 packs + 8 loose pieces
```

---

## 📚 **EXAMPLE 14: POWDER IN BOTTLES**

### **Scenario:** Register Antibiotic Powder for Suspension

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Powder
Unit Abbreviation: Pwd
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: bottle
Allows Subdivision: YES
Unit Size Label: grams per bottle
Is Active: YES
```

**Why "weight" for powder?**
```
- Powder measured by weight (grams)
- Not countable (not discrete units)
- Comes in bottles of specific gram amounts
- Example: 30gm bottle, 50gm bottle
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Amoxicillin Powder for Suspension
Generic Name: Amoxicillin 125mg/5ml
Manufacturer: GSK
Unit Type: Powder

Grams per Bottle: 30
  (Makes 100ml suspension when reconstituted)

Bottles per Box: 10

Cost per Gram: $0.50
Cost per Bottle: $15.00 (30 × $0.50)
Cost per Box: $150.00 (10 × $15.00)

Price per Gram: $0.70
Price per Bottle: $21.00 (30 × $0.70)
Price per Box: $210.00 (10 × $21.00)
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 30 bottles
Secondary Quantity: 0 grams
Total: 30 × 30 = 900 grams
Boxes: 30 ÷ 10 = 3 boxes
Display: "3 boxes + 0 bottles + 0 loose gms"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Amoxicillin Powder

Results:
┌─────────────────────────────────────────────────────┐
│  🧪 Amoxicillin Powder for Suspension               │
│  Generic: Amoxicillin 125mg/5ml                     │
│                                                     │
│  📦 Stock: 3 boxes + 0 bottles + 0 loose gms       │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Gm - $0.70 each                               │
│    • Bottle (30 gms) - $21.00                      │
│    • Boxes (10 bottles = 300 gms) - $210.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Typical Sale:**

```
Patient with prescription

Select: "Bottle (30 gms) - $21.00"
Quantity: 1
Total: $21.00

Note: Always sold by complete bottle
Pharmacist adds water to make 100ml suspension

After Sale:
Stock: 2 boxes + 9 bottles + 0 loose gms
```

---

## 📚 **EXAMPLE 15: NASAL SPRAY**

### **Scenario:** Register Nasal Decongestant Spray

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Spray
Unit Abbreviation: Spr
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES
Unit Size Label: ml per bottle
Is Active: YES
```

**Spray Characteristics:**
```
- Liquid medication in spray bottle
- Measured by volume (ml)
- Each spray delivers fixed dose
- Common types: Nasal, Throat, Topical
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Nasal Decongestant Spray
Generic Name: Oxymetazoline 0.05%
Manufacturer: Reckitt Benckiser
Unit Type: Spray

ML per Bottle: 15
  (Approximately 100 sprays per bottle)

Bottles per Box: 12

Cost per ML: $1.00
Cost per Bottle: $15.00 (15 × $1.00)
Cost per Box: $180.00 (12 × $15.00)

Price per ML: $1.50
Price per Bottle: $22.50 (15 × $1.50)
Price per Box: $270.00 (12 × $22.50)
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 36 bottles
Secondary Quantity: 0 ml
Total: 36 × 15 = 540 ml
Boxes: 36 ÷ 12 = 3 boxes
Display: "3 boxes + 0 bottles + 0 loose mls"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Nasal Spray

Results:
┌─────────────────────────────────────────────────────┐
│  👃 Nasal Decongestant Spray                        │
│  Generic: Oxymetazoline 0.05%                       │
│                                                     │
│  📦 Stock: 3 boxes + 0 bottles + 0 loose mls       │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • By Volume (ml) - $1.50 each                   │
│    • Bottle (15 mls) - $22.50                      │
│    • Boxes (12 bottles = 180 mls) - $270.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Typical Sale:**

```
Patient: "I have nasal congestion"

Select: "Bottle (15 mls) - $22.50"
Quantity: 1
Total: $22.50

Note: NEVER sell by ml for sprays
Always sell complete bottle (spray mechanism)

After Sale:
Stock: 2 boxes + 11 bottles + 0 loose mls
```

---

## 📚 **EXAMPLE 16: THROAT LOZENGES**

### **Scenario:** Register Throat Lozenges

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Lozenge
Unit Abbreviation: Loz
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES
Unit Size Label: lozenges per pack
Is Active: YES
```

**Lozenge vs Tablet:**
```
LOZENGE:
- Slowly dissolves in mouth
- For throat/mouth conditions
- Larger than tablets
- Often flavored

TABLET:
- Swallowed whole
- Systemic effect
- Smaller
- Less flavoring

System: Both use "countable" method!
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Throat Lozenges Honey Lemon
Generic Name: Benzocaine 5mg
Manufacturer: Halls
Unit Type: Lozenge

Pieces per Pack: 12
Packs per Box: 20

Cost per Piece: $0.20
Cost per Pack: $2.40 (12 × $0.20)
Cost per Box: $48.00 (20 × $2.40)

Price per Piece: $0.30
Price per Pack: $3.60 (12 × $0.30)
Price per Box: $72.00 (20 × $3.60)
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 60 packs
Secondary Quantity: 5 pieces
Total: (60 × 12) + 5 = 725 lozenges
Boxes: 60 ÷ 20 = 3 boxes
Display: "3 boxes + 0 packs + 5 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Throat Lozenges

Results:
┌─────────────────────────────────────────────────────┐
│  🍬 Throat Lozenges Honey Lemon                     │
│  Generic: Benzocaine 5mg                            │
│                                                     │
│  📦 Stock: 3 boxes + 0 packs + 5 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $0.30 each                            │
│    • Pack (12 pieces) - $3.60                      │
│    • Boxes (20 packs = 240 pieces) - $72.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Sales:**

```
Customer: "I have a sore throat"

Select: "Pack (12 pieces) - $3.60"
Quantity: 1
Total: $3.60

After Sale:
Stock: 2 boxes + 19 packs + 5 loose pieces
```

---

## 📚 **EXAMPLE 17: EFFERVESCENT TABLETS**

### **Scenario:** Register Vitamin C Effervescent 1000mg

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Effervescent
Unit Abbreviation: Eff
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: tube
Allows Subdivision: YES
Unit Size Label: tablets per tube
Is Active: YES
```

**Effervescent vs Regular Tablet:**
```
EFFERVESCENT:
- Dissolves in water
- Creates fizzy drink
- Larger tablets
- Comes in tubes (not strips)
- Better absorption

REGULAR TABLET:
- Swallowed with water
- Solid form
- Smaller
- Comes in strips
- Standard absorption
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Vitamin C Effervescent 1000mg
Generic Name: Ascorbic Acid
Manufacturer: Bayer
Unit Type: Effervescent

Pieces per Tube: 10
Tubes per Box: 10

Cost per Piece: $0.80
Cost per Tube: $8.00 (10 × $0.80)
Cost per Box: $80.00 (10 × $8.00)

Price per Piece: $1.00
Price per Tube: $10.00
Price per Box: $100.00
```

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 30 tubes
Secondary Quantity: 4 pieces
Total: (30 × 10) + 4 = 304 tablets
Boxes: 30 ÷ 10 = 3 boxes
Display: "3 boxes + 0 tubes + 4 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Vitamin C Effervescent

Results:
┌─────────────────────────────────────────────────────┐
│  🧪 Vitamin C Effervescent 1000mg                   │
│  Generic: Ascorbic Acid                             │
│                                                     │
│  📦 Stock: 3 boxes + 0 tubes + 4 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $1.00 each                            │
│    • Tube (10 pieces) - $10.00                     │
│    • Boxes (10 tubes = 100 pieces) - $100.00       │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Sales:**

```
Customer: "Need vitamin C for immunity"

Select: "Tube (10 pieces) - $10.00"
Quantity: 1
Total: $10.00

Usage: 1 tablet daily = 10 days supply

After Sale:
Stock: 2 boxes + 9 tubes + 4 loose pieces
```

---

## 📚 **EXAMPLE 18: PESSARY (Vaginal Tablet)**

### **Scenario:** Register Clotrimazole Pessary 500mg

---

### **STEP 1: CREATE UNIT TYPE**

```
Unit Name: Pessary
Unit Abbreviation: Pess
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES
Unit Size Label: pessaries per pack
Is Active: YES
```

**Pessary Characteristics:**
```
- Vaginal medication
- Inserted vaginally
- Similar shape to suppository
- Usually 1-3 per treatment course
- Comes in individual packs
```

**Click SAVE** ✅

---

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Clotrimazole Pessary 500mg
Generic Name: Clotrimazole
Manufacturer: Bayer
Unit Type: Pessary

Pieces per Pack: 1
  (Single dose treatment)

Packs per Box: 10

Cost per Piece: $8.00
Cost per Pack: $8.00 (1 × $8.00)
Cost per Box: $80.00 (10 × $8.00)

Price per Piece: $10.00
Price per Pack: $10.00
Price per Box: $100.00
```

**Note:** 1 piece per pack because it's a single-dose treatment!

**Click SAVE** ✅

---

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 30 packs
Secondary Quantity: 0 pieces
Total: 30 × 1 = 30 pessaries
Boxes: 30 ÷ 10 = 3 boxes
Display: "3 boxes + 0 packs + 0 loose pieces"
```

**Click SAVE** ✅

---

### **STEP 4: SELL IN POS**

```
Search: Clotrimazole Pessary

Results:
┌─────────────────────────────────────────────────────┐
│  💊 Clotrimazole Pessary 500mg                      │
│  Generic: Clotrimazole                              │
│                                                     │
│  📦 Stock: 3 boxes + 0 packs + 0 loose pieces      │
│                                                     │
│  Sell Type: [Select ▼]                             │
│    • Piece - $10.00 each                           │
│    • Pack (1 piece) - $10.00                       │
│    • Boxes (10 packs = 10 pieces) - $100.00        │
│                                                     │
│  Quantity: [____]                                   │
│                                                     │
│           [Add to Cart 🛒]                          │
└─────────────────────────────────────────────────────┘
```

**Sales:**

```
Female patient with prescription

Select: "Pack (1 piece) - $10.00"
Quantity: 1
Total: $10.00

Note: Single-dose treatment for vaginal yeast infection

After Sale:
Stock: 2 boxes + 9 packs + 0 loose pieces
```

---

## 📊 **COMPLETE COMPARISON TABLE**

| Type | Method | Base Unit | Subdivision | Typical Use | Sold By |
|------|--------|-----------|-------------|-------------|---------|
| **Sachet** | countable | piece | pack | ORS, Vitamins | Individual or pack |
| **Powder** | weight | gm | bottle | Antibiotics | Bottle |
| **Spray** | volume | ml | bottle | Nasal, Throat | Bottle only |
| **Lozenge** | countable | piece | pack | Throat relief | Pack |
| **Effervescent** | countable | piece | tube | Vitamins | Tube |
| **Pessary** | countable | piece | pack | Vaginal | Individual |

---

## 💡 **PRACTICAL SCENARIOS**

### **Pharmacy Stock Take:**

```
Morning Inventory Check:
────────────────────────

1. ORS Sachets
   Stock: 508 sachets (5 boxes + 8 loose)
   Status: ✅ Good (above 200 reorder)

2. Antibiotic Powder
   Stock: 29 bottles (2 boxes + 9 bottles)
   Status: ✅ Good

3. Nasal Spray
   Stock: 35 bottles (2 boxes + 11 bottles)
   Status: ✅ Good

4. Throat Lozenges
   Stock: 725 pieces (3 boxes + 5 loose)
   Status: ✅ Excellent

5. Vitamin C Effervescent
   Stock: 304 tablets (3 boxes + 4 loose)
   Status: ✅ Good

6. Pessary
   Stock: 29 pieces (2 boxes + 9 packs)
   Status: ⚠️ Medium (consider reorder)
```

---

## 🎓 **KEY TAKEAWAYS**

### **Powder Medications:**

```
Sachets (ORS, Vitamins):
✓ Countable - sold by piece or pack
✓ Individually wrapped
✓ Mix with water before use

Bottled Powder (Antibiotics):
✓ Weight-based - sold by bottle
✓ Reconstitute entire bottle
✓ Makes liquid suspension
```

### **Spray Medications:**

```
Always volume-based (ml)
Always sold by complete bottle
Never sell loose ml
Spray mechanism = one unit
```

### **Special Forms:**

```
Lozenges: Countable, like tablets
Effervescent: Countable, come in tubes
Pessaries: Countable, often single-dose
```

---

## 📋 **SETUP QUICK REFERENCE**

### **For Sachets:**
```
Method: countable | Base: piece | Sub: pack
Example: ORS 10 per pack
```

### **For Bottled Powder:**
```
Method: weight | Base: gm | Sub: bottle
Example: Antibiotic 30gm bottle
```

### **For Sprays:**
```
Method: volume | Base: ml | Sub: bottle
Example: Nasal Spray 15ml
```

### **For Lozenges:**
```
Method: countable | Base: piece | Sub: pack
Example: 12 lozenges per pack
```

### **For Effervescent:**
```
Method: countable | Base: piece | Sub: tube
Example: 10 tablets per tube
```

### **For Pessaries:**
```
Method: countable | Base: piece | Sub: pack
Example: 1 pessary per pack
```

---

**Guide Version:** 1.0  
**Examples Covered:** 6 specialized types  
**Last Updated:** December 2024  
**Total Medicine Examples in All Guides:** 18+ types