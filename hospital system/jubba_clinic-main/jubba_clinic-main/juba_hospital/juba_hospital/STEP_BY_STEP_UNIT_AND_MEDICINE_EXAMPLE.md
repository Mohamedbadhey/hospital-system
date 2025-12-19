# Step-by-Step Example: Creating a Unit and Registering Medicine

## 🎯 **Complete Walkthrough with Screenshots Description**

Let me show you **EXACTLY** how to create a unit and then register a medicine using that unit, step by step!

---

## 📚 **EXAMPLE 1: TABLET MEDICINE (Most Common)**

### **Scenario:**
You want to register **Paracetamol 500mg Tablets** in your pharmacy.

---

## STEP 1: CREATE THE UNIT TYPE

### **Page to Open:** `add_medicine_units.aspx`

### **What You'll See:**
A form with these fields to fill:

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE UNIT                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Unit Name: [________________]                      │
│                                                     │
│  Unit Abbreviation: [_____]                        │
│                                                     │
│  Selling Method: [Select ▼]                        │
│    Options: countable / volume / weight             │
│                                                     │
│  Base Unit Name: [________________]                 │
│                                                     │
│  Subdivision Unit: [________________]               │
│                                                     │
│  Allows Subdivision: [☐] Yes                       │
│                                                     │
│  Unit Size Label: [________________]                │
│                                                     │
│  Is Active: [☑] Yes                                │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

### **What to Enter:**

```
Field 1: Unit Name
└─ Enter: Tablet

Field 2: Unit Abbreviation  
└─ Enter: Tab

Field 3: Selling Method
└─ Select: countable
   (Because tablets are counted, not measured)

Field 4: Base Unit Name
└─ Enter: piece
   (Individual tablet is called a "piece")

Field 5: Subdivision Unit
└─ Enter: strip
   (Multiple tablets come in a "strip")

Field 6: Allows Subdivision
└─ Check: ☑ Yes
   (Because tablets can be sold as strips or individual pieces)

Field 7: Unit Size Label
└─ Enter: pieces per strip
   (Description: "10 pieces per strip")

Field 8: Is Active
└─ Check: ☑ Yes
   (Unit is active and available for use)
```

### **Click SAVE**

### **Result:**
✅ Unit "Tablet" has been created successfully!

---

## STEP 2: REGISTER MEDICINE USING THE UNIT

### **Page to Open:** `add_medicine.aspx`

### **What You'll See:**
A form to register a new medicine:

```
┌─────────────────────────────────────────────────────┐
│          ADD MEDICINE                               │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Medicine Name: [_______________________]           │
│                                                     │
│  Generic Name: [_______________________]            │
│                                                     │
│  Manufacturer: [_______________________]            │
│                                                     │
│  Unit Type: [Select Unit ▼]                        │
│                                                     │
│  ┌─ Packaging Details ─────────────────┐           │
│  │  Pieces per Strip: [____]            │           │
│  │  Strips per Box: [____]              │           │
│  └──────────────────────────────────────┘           │
│                                                     │
│  ┌─ Cost Prices ─────────────────────┐             │
│  │  Cost per Piece: [____]            │             │
│  │  Cost per Strip: [____]            │             │
│  │  Cost per Box: [____]              │             │
│  └────────────────────────────────────┘             │
│                                                     │
│  ┌─ Selling Prices ─────────────────┐              │
│  │  Price per Piece: [____]          │              │
│  │  Price per Strip: [____]          │              │
│  │  Price per Box: [____]            │              │
│  └───────────────────────────────────┘              │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

### **What to Enter:**

```
Field 1: Medicine Name
└─ Enter: Paracetamol 500mg

Field 2: Generic Name
└─ Enter: Acetaminophen

Field 3: Manufacturer
└─ Enter: GSK Pharmaceuticals

Field 4: Unit Type
└─ Select: Tablet (from dropdown)
   (This is the unit we just created!)

── When you select "Tablet", the form updates to show: ──

Field 5: Pieces per Strip
└─ Enter: 10
   (1 strip contains 10 tablets)

Field 6: Strips per Box
└─ Enter: 10
   (1 box contains 10 strips)

── Cost Prices (What you paid to buy) ──

Field 7: Cost per Piece
└─ Enter: 0.30
   (You buy each tablet at $0.30)

Field 8: Cost per Strip
└─ Enter: 3.00
   (10 tablets × $0.30 = $3.00)

Field 9: Cost per Box
└─ Enter: 30.00
   (10 strips × $3.00 = $30.00)

── Selling Prices (What customers pay) ──

Field 10: Price per Piece
└─ Enter: 0.50
   (You sell each tablet at $0.50)

Field 11: Price per Strip
└─ Enter: 5.00
   (10 tablets × $0.50 = $5.00)

Field 12: Price per Box
└─ Enter: 50.00
   (10 strips × $5.00 = $50.00)
```

### **Click SAVE**

### **Result:**
✅ Medicine "Paracetamol 500mg" has been registered successfully!

---

## STEP 3: ADD INVENTORY STOCK

### **Page to Open:** `medicine_inventory.aspx`

### **What You'll See:**

```
┌─────────────────────────────────────────────────────┐
│          ADD INVENTORY                              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Select Medicine: [Select ▼]                        │
│                                                     │
│  Primary Quantity (Strips): [____]                  │
│                                                     │
│  Secondary Quantity (Loose Pieces): [____]          │
│                                                     │
│  Unit Size: [____]                                  │
│                                                     │
│  Batch Number: [________________]                   │
│                                                     │
│  Expiry Date: [____/____/____]                     │
│                                                     │
│  Purchase Price: [____]                             │
│                                                     │
│  Reorder Level: [____]                              │
│                                                     │
│              [Save Button]                          │
└─────────────────────────────────────────────────────┘
```

### **What to Enter:**

```
Field 1: Select Medicine
└─ Select: Paracetamol 500mg (from dropdown)

Field 2: Primary Quantity (Strips)
└─ Enter: 50
   (You have 50 strips in stock)

Field 3: Secondary Quantity (Loose Pieces)
└─ Enter: 15
   (You have 15 loose tablets)

Field 4: Unit Size
└─ Enter: 10
   (10 pieces per strip - auto-filled from medicine config)

Field 5: Batch Number
└─ Enter: BATCH2024001

Field 6: Expiry Date
└─ Enter: 31/12/2026

Field 7: Purchase Price
└─ Enter: 3.00
   (Cost per strip)

Field 8: Reorder Level
└─ Enter: 10
   (Alert when stock falls below 10 strips)
```

### **Click SAVE**

### **Result:**
✅ Inventory added successfully!

**Total Stock Calculation:**
- Primary: 50 strips × 10 pieces = 500 pieces
- Secondary: 15 loose pieces
- **Total Available: 515 pieces (51 strips + 5 pieces)**

---

## STEP 4: SELL IN POS SYSTEM

### **Page to Open:** `pharmacy_pos.aspx`

### **What You'll See:**

```
┌─────────────────────────────────────────────────────┐
│          PHARMACY POS                               │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Search Medicine: [________________] [Search]       │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### **Step 4.1: Search Medicine**

```
Enter in search box: Paracetamol
Click: Search Button
```

### **What You'll See After Search:**

```
┌─────────────────────────────────────────────────────┐
│  Medicine Found:                                    │
│  ┌────────────────────────────────────────────────┐│
│  │ Paracetamol 500mg                              ││
│  │ Generic: Acetaminophen                         ││
│  │ Manufacturer: GSK Pharmaceuticals              ││
│  │                                                ││
│  │ Stock: 5 boxes + 0 strips + 15 loose pieces   ││
│  │        ↑ Bold    ↑ Regular   ↑ Loose label    ││
│  │                                                ││
│  │ Sell Type: [Select ▼]                         ││
│  │   Options in dropdown:                         ││
│  │   • Piece - $0.50 each                        ││
│  │   • Strip (10 pieces) - $5.00                 ││
│  │   • Boxes (10 strips = 100 pieces) - $50.00   ││
│  │                                                ││
│  │ Quantity: [____]                               ││
│  │                                                ││
│  │           [Add to Cart]                        ││
│  └────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────┘
```

### **Step 4.2: Selling by PIECES (Individual Tablets)**

```
Select from Sell Type: "Piece - $0.50 each"
Enter Quantity: 25
Click: Add to Cart

Result:
Cart Item: 25 Pieces × $0.50 = $12.50
```

### **Step 4.3: Selling by STRIPS**

```
Select from Sell Type: "Strip (10 pieces) - $5.00"
Enter Quantity: 3
Click: Add to Cart

Result:
Cart Item: 3 Strips × $5.00 = $15.00
```

### **Step 4.4: Selling by BOXES**

```
Select from Sell Type: "Boxes (10 strips = 100 pieces) - $50.00"
Enter Quantity: 2
Click: Add to Cart

Result:
Cart Item: 2 Boxes × $50.00 = $100.00
```

### **Shopping Cart:**

```
┌─────────────────────────────────────────────────────┐
│  CART                                               │
├─────────────────────────────────────────────────────┤
│  1. Paracetamol 500mg - 25 Pieces      $12.50     │
│  2. Paracetamol 500mg - 3 Strips       $15.00     │
│  3. Paracetamol 500mg - 2 Boxes       $100.00     │
│                                                     │
│  Subtotal:                            $127.50      │
│  Discount:                              $0.00      │
│  ─────────────────────────────────────────────     │
│  TOTAL:                               $127.50      │
│                                                     │
│  Payment Method: [Cash ▼]                          │
│                                                     │
│              [Process Sale]                         │
└─────────────────────────────────────────────────────┘
```

### **Click PROCESS SALE**

### **What Happens in the Background:**

```
Inventory Deduction:
─────────────────────
Item 1: 25 pieces sold
→ Deduct from secondary_quantity: 15 - 25 = -10 (need more!)
→ Break 1 strip: 10 pieces added to loose
→ Secondary_quantity: 15 + 10 - 25 = 0
→ Primary_quantity: 50 - 1 = 49 strips

Item 2: 3 strips sold
→ Deduct from primary_quantity: 49 - 3 = 46 strips

Item 3: 2 boxes sold (2 × 10 = 20 strips)
→ Deduct from primary_quantity: 46 - 20 = 26 strips
→ Deduct from total_boxes

NEW STOCK:
──────────
Primary: 26 strips
Secondary: 0 loose pieces
Total: 260 pieces

Display: "2 boxes + 6 strips + 0 loose pieces"
```

### **Result:**
✅ Sale completed successfully!
✅ Invoice generated
✅ Inventory automatically updated
✅ Profit calculated and recorded

---

## 📊 **VISUAL SUMMARY**

### **THE COMPLETE FLOW:**

```
STEP 1: CREATE UNIT
┌─────────────┐
│   Tablet    │ ← Unit Type
│  countable  │ ← Selling Method
│   piece     │ ← Base Unit
│   strip     │ ← Subdivision
└─────────────┘

STEP 2: REGISTER MEDICINE
┌──────────────────────┐
│ Paracetamol 500mg   │ ← Medicine Name
│ Unit: Tablet        │ ← Uses unit from Step 1
│ 10 pieces/strip     │ ← Packaging
│ 10 strips/box       │ ← Packaging
│ $0.50 per piece     │ ← Pricing
│ $5.00 per strip     │ ← Pricing
│ $50.00 per box      │ ← Pricing
└──────────────────────┘

STEP 3: ADD INVENTORY
┌──────────────────────┐
│ 50 strips           │ ← Primary Quantity
│ 15 loose pieces     │ ← Secondary Quantity
│ Total: 515 pieces   │ ← Calculated
│ Batch: BATCH2024001 │
│ Expiry: 31/12/2026  │
└──────────────────────┘

STEP 4: SELL IN POS
┌──────────────────────┐
│ Stock Display:      │
│ "5 boxes +          │ ← Auto-calculated!
│  0 strips +         │
│  15 loose pieces"   │
│                     │
│ Sell Options:       │
│ • Piece ($0.50)    │ ← From price_per_piece
│ • Strip ($5.00)    │ ← From price_per_strip
│ • Boxes ($50.00)   │ ← From price_per_box
└──────────────────────┘
```

---

## 🎯 **KEY CONCEPTS EXPLAINED**

### **1. Primary Quantity = Strips (Main Units)**
- This is your main selling unit after individual pieces
- Examples: strips, bottles, tubes, packs

### **2. Secondary Quantity = Loose Pieces (Leftover Units)**
- Individual items not in strips
- Examples: loose tablets, loose ml, loose grams

### **3. Unit Size = Conversion Factor**
- How many pieces in one strip
- Example: 10 pieces per strip

### **4. Automatic Calculations:**
```
Total Available = (Primary × Unit Size) + Secondary
Total Available = (50 strips × 10) + 15 loose
Total Available = 500 + 15 = 515 pieces

Box Display = Primary ÷ Strips per Box
Box Display = 50 strips ÷ 10 = 5 boxes
Remaining = 50 % 10 = 0 strips
Display: "5 boxes + 0 strips + 15 loose pieces"
```

---

## 📚 **EXAMPLE 2: SYRUP MEDICINE (Liquid)**

Let me show you a LIQUID medicine example too!

### **STEP 1: CREATE UNIT**

```
Page: add_medicine_units.aspx

Unit Name: Syrup
Unit Abbreviation: Syr
Selling Method: volume ← Different!
Base Unit Name: ml ← Volume unit
Subdivision Unit: bottle
Allows Subdivision: ☑ Yes
Unit Size Label: ml per bottle
Is Active: ☑ Yes

Click SAVE
```

### **STEP 2: REGISTER MEDICINE**

```
Page: add_medicine.aspx

Medicine Name: Cough Syrup
Generic Name: Dextromethorphan
Manufacturer: ABC Pharma
Unit Type: Syrup ← Select the unit we created

ML per Bottle: 100 ← Not "pieces per strip"!
Bottles per Box: 12

Cost per ML: 0.08
Cost per Bottle: 8.00
Cost per Box: 96.00

Price per ML: 0.10
Price per Bottle: 10.00
Price per Box: 120.00

Click SAVE
```

### **STEP 3: ADD INVENTORY**

```
Page: medicine_inventory.aspx

Select Medicine: Cough Syrup
Primary Quantity: 36 bottles
Secondary Quantity: 50 ml (loose)
Unit Size: 100 (ml per bottle)
Batch Number: BATCH2024002
Expiry Date: 30/06/2026
Purchase Price: 8.00
Reorder Level: 10

Click SAVE

Total Stock: (36 × 100) + 50 = 3650 ml
```

### **STEP 4: SELL IN POS**

```
Page: pharmacy_pos.aspx

Search: Cough Syrup

Stock Display: "3 boxes + 0 bottles + 50 loose mls"

Sell Type Options:
• By Volume (ml) - $0.10 each
• Bottle (100 mls) - $10.00
• Boxes (12 bottles = 1200 mls) - $120.00

Example Sale:
Select: "Bottle (100 mls) - $10.00"
Quantity: 5 bottles
Total: $50.00

After Sale:
Stock: "2 boxes + 7 bottles + 50 loose mls"
```

---

## 📚 **EXAMPLE 3: OINTMENT (Weight-based)**

### **STEP 1: CREATE UNIT**

```
Unit Name: Ointment
Unit Abbreviation: Oint
Selling Method: weight ← For grams!
Base Unit Name: gm ← Weight unit
Subdivision Unit: tube
Allows Subdivision: ☑ Yes
Unit Size Label: grams per tube
```

### **STEP 2: REGISTER MEDICINE**

```
Medicine Name: Betadine Ointment
Unit Type: Ointment

Grams per Tube: 30
Tubes per Box: 20

Price per Gram: 0.50
Price per Tube: 15.00
Price per Box: 300.00
```

### **STEP 3: ADD INVENTORY**

```
Primary Quantity: 40 tubes
Secondary Quantity: 0 gm
Total: 40 × 30 = 1200 grams
```

### **STEP 4: SELL IN POS**

```
Stock: "2 boxes + 0 tubes + 0 loose gms"

Sell Options:
• Gm - $0.50 each
• Tube (30 gms) - $15.00
• Boxes (20 tubes = 600 gms) - $300.00
```

---

## ✅ **UNDERSTANDING THE RELATIONSHIP**

```
┌─────────────┐
│    UNIT     │ ← Created once
└──────┬──────┘
       │
       ├──→ Used by multiple medicines
       │
       ├──→ Medicine 1: Paracetamol 500mg
       ├──→ Medicine 2: Aspirin 300mg
       ├──→ Medicine 3: Ibuprofen 400mg
       └──→ Medicine 4: Amoxicillin 500mg
              
       All use the same "Tablet" unit!
```

### **One Unit → Many Medicines**

```
Tablet Unit can be used for:
• Paracetamol (10 per strip, 10 strips per box)
• Aspirin (10 per strip, 10 strips per box)
• Ibuprofen (10 per strip, 10 strips per box)

Syrup Unit can be used for:
• Cough Syrup (100ml bottles)
• Paracetamol Syrup (120ml bottles)
• Multivitamin Syrup (200ml bottles)
```

---

## 🎓 **PRACTICE EXERCISE**

Try creating this yourself:

### **Exercise: Register Amoxicillin Capsules**

```
STEP 1: Unit already exists (use "Capsule")
STEP 2: Medicine
  - Name: Amoxicillin 500mg
  - Unit: Capsule
  - 8 capsules per strip
  - 12 strips per box
  - Price: $1.00 per capsule

STEP 3: Inventory
  - 96 strips (= 8 boxes)
  - 5 loose capsules

STEP 4: Calculate
  - How many boxes will display? _____
  - How many strips remaining? _____
  - Total capsules available? _____

Answers:
  - Boxes: 96 ÷ 12 = 8 boxes
  - Remaining: 96 % 12 = 0 strips
  - Total: (96 × 8) + 5 = 773 capsules
  - Display: "8 boxes + 0 strips + 5 loose pieces"
```

---

## 💡 **SUMMARY**

### **The 4-Step Process:**

1. **CREATE UNIT** (Once)
   - Define how the medicine type is sold
   - Set selling method (countable/volume/weight)

2. **REGISTER MEDICINE** (For each product)
   - Select the unit
   - Configure packaging
   - Set pricing

3. **ADD INVENTORY** (When stock arrives)
   - Enter quantities
   - Add batch and expiry
   - Set purchase price

4. **SELL IN POS** (Daily operations)
   - Search medicine
   - Select sell type (piece/strip/box)
   - Add to cart and process

---

**Created:** December 2024  
**Purpose:** Complete understanding of unit and medicine relationship  
**Examples:** 3 different medicine types (Tablet, Syrup, Ointment)