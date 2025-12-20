# Medicine Units - Complete Sample Data Guide

## Overview

This guide provides **real-world examples** of different medicine unit types you can register in your system. Each example includes complete configuration details and practical use cases.

---

## 🔢 **COUNTABLE UNITS** (Discrete Items)

### 1. Tablet
**Most Common Unit Type**

```
Unit Name: Tablet
Unit Abbreviation: Tab
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: strip
Allows Subdivision: YES ✓
Unit Size Label: pieces per strip
Is Active: YES ✓
```

**Example Medicines:**
- Paracetamol 500mg: 10 tablets per strip, 10 strips per box
- Amoxicillin 500mg: 8 tablets per strip, 12 strips per box
- Metformin 500mg: 10 tablets per strip, 10 strips per box

**POS Display:**
- Piece - $0.50 each
- Strip (10 pieces) - $5.00
- Boxes (10 strips = 100 pieces) - $50.00

---

### 2. Capsule
**Similar to Tablet**

```
Unit Name: Capsule
Unit Abbreviation: Cap
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: strip
Allows Subdivision: YES ✓
Unit Size Label: pieces per strip
Is Active: YES ✓
```

**Example Medicines:**
- Omeprazole 20mg: 10 capsules per strip, 10 strips per box
- Amoxicillin 250mg: 8 capsules per strip, 12 strips per box
- Vitamin E 400IU: 10 capsules per strip, 5 strips per box

---

### 3. Suppository
**Rectal/Vaginal Medications**

```
Unit Name: Suppository
Unit Abbreviation: Supp
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: pieces per pack
Is Active: YES ✓
```

**Example Medicines:**
- Paracetamol Suppository 250mg: 5 pieces per pack, 10 packs per box
- Glycerin Suppository: 12 pieces per pack, 5 packs per box
- Diclofenac Suppository 100mg: 5 pieces per pack, 10 packs per box

**POS Display:**
- Piece - $2.00 each
- Pack (5 pieces) - $10.00
- Boxes (10 packs = 50 pieces) - $100.00

---

### 4. Patch (Transdermal)
**Skin Patches**

```
Unit Name: Patch
Unit Abbreviation: Pch
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: pieces per pack
Is Active: YES ✓
```

**Example Medicines:**
- Nicotine Patch 21mg: 7 pieces per pack, 4 packs per box
- Pain Relief Patch: 5 pieces per pack, 10 packs per box
- Hormone Patch: 4 pieces per pack, 3 packs per box

**POS Display:**
- Piece - $5.00 each
- Pack (7 pieces) - $35.00
- Boxes (4 packs = 28 pieces) - $140.00

---

### 5. Vial (Injectable - Countable)
**Small Injectable Containers**

```
Unit Name: Vial
Unit Abbreviation: Vial
Selling Method: countable
Base Unit Name: vial
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: vials per pack
Is Active: YES ✓
```

**Example Medicines:**
- Insulin Vial 10ml: 1 vial per pack, 10 packs per box
- Vaccine Vial: 10 vials per pack, 5 packs per box
- Antibiotic Vial: 5 vials per pack, 20 packs per box

**POS Display:**
- Vial - $15.00 each
- Pack (5 vials) - $75.00
- Boxes (20 packs = 100 vials) - $1,500.00

---

### 6. Sachet (Powder Packets)
**Individual Powder Packets**

```
Unit Name: Sachet
Unit Abbreviation: Sach
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: sachets per pack
Is Active: YES ✓
```

**Example Medicines:**
- ORS (Oral Rehydration Salt): 10 sachets per pack, 10 packs per box
- Vitamin C Powder 1000mg: 20 sachets per pack, 5 packs per box
- Paracetamol Sachet: 10 sachets per pack, 10 packs per box

**POS Display:**
- Piece - $0.30 each
- Pack (10 pieces) - $3.00
- Boxes (10 packs = 100 pieces) - $30.00

---

### 7. Inhaler
**Respiratory Inhalers**

```
Unit Name: Inhaler
Unit Abbreviation: Inh
Selling Method: countable
Base Unit Name: unit
Subdivision Unit: (leave empty)
Allows Subdivision: NO ✗
Unit Size Label: (leave empty)
Is Active: YES ✓
```

**Example Medicines:**
- Ventolin Inhaler 100mcg: Sold per unit (no subdivision)
- Symbicort Inhaler: Sold per unit
- Seretide Inhaler: Sold per unit

**POS Display:**
- Unit - $25.00 each
(No strips or boxes - sold individually)

---

### 8. Ampoule
**Glass Injectable Containers**

```
Unit Name: Ampoule
Unit Abbreviation: Amp
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: ampoules per pack
Is Active: YES ✓
```

**Example Medicines:**
- Diclofenac Injection 75mg/3ml: 5 ampoules per pack, 10 packs per box
- Vitamin B Complex Injection: 6 ampoules per pack, 10 packs per box
- Adrenaline 1mg/ml: 10 ampoules per pack, 10 packs per box

**POS Display:**
- Piece - $1.50 each
- Pack (5 pieces) - $7.50
- Boxes (10 packs = 50 pieces) - $75.00

---

## 💧 **VOLUME UNITS** (Liquid Measurements)

### 9. Syrup (Oral Liquid)
**Most Common Liquid Form**

```
Unit Name: Syrup
Unit Abbreviation: Syr
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: ml per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Paracetamol Syrup 120mg/5ml: 100ml per bottle, 12 bottles per box
- Cough Syrup: 120ml per bottle, 12 bottles per box
- Multivitamin Syrup: 200ml per bottle, 10 bottles per box

**Medicine Configuration:**
```
ML per Bottle: 100
Bottles per Box: 12
Price per ML: $0.10
Price per Bottle: $10.00
Price per Box: $120.00
```

**POS Display:**
- By Volume (ml) - $0.10 each
- Bottle (100 mls) - $10.00
- Boxes (12 bottles = 1200 mls) - $120.00

---

### 10. Suspension (Liquid Medicine)
**Similar to Syrup but Different Formulation**

```
Unit Name: Suspension
Unit Abbreviation: Susp
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: ml per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Amoxicillin Suspension 250mg/5ml: 100ml per bottle, 10 bottles per box
- Antacid Suspension: 200ml per bottle, 12 bottles per box
- Zinc Suspension: 100ml per bottle, 10 bottles per box

---

### 11. Injection (Injectable Liquid)
**Injectable Solutions**

```
Unit Name: Injection
Unit Abbreviation: Inj
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: vial
Allows Subdivision: YES ✓
Unit Size Label: ml per vial
Is Active: YES ✓
```

**Example Medicines:**
- Normal Saline 0.9%: 10ml per vial, 50 vials per box
- Dextrose 5%: 10ml per vial, 50 vials per box
- Lidocaine 2%: 5ml per vial, 100 vials per box

**Medicine Configuration:**
```
ML per Vial: 10
Vials per Box: 50
Price per ML: $0.50
Price per Vial: $5.00
Price per Box: $250.00
```

**POS Display:**
- By Volume (ml) - $0.50 each
- Vial (10 mls) - $5.00
- Boxes (50 vials = 500 mls) - $250.00

---

### 12. IV Solution (Large Volume Parenterals)
**Intravenous Fluids**

```
Unit Name: IV Solution
Unit Abbreviation: IV
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bag
Allows Subdivision: YES ✓
Unit Size Label: ml per bag
Is Active: YES ✓
```

**Example Medicines:**
- Normal Saline 0.9% 500ml: 500ml per bag, 20 bags per box
- Dextrose 5% 1000ml: 1000ml per bag, 12 bags per box
- Ringer's Lactate 500ml: 500ml per bag, 20 bags per box

**Medicine Configuration:**
```
ML per Bag: 500
Bags per Box: 20
Price per ML: $0.01
Price per Bag: $5.00
Price per Box: $100.00
```

**POS Display:**
- By Volume (ml) - $0.01 each
- Bag (500 mls) - $5.00
- Boxes (20 bags = 10000 mls) - $100.00

---

### 13. Drops (Eye/Ear/Nose Drops)
**Topical Liquid Drops**

```
Unit Name: Drops
Unit Abbreviation: Drop
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: ml per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Eye Drops (Antibiotic): 5ml per bottle, 10 bottles per box
- Ear Drops: 10ml per bottle, 10 bottles per box
- Nasal Drops: 15ml per bottle, 10 bottles per box

**Medicine Configuration:**
```
ML per Bottle: 5
Bottles per Box: 10
Price per ML: $2.00
Price per Bottle: $10.00
Price per Box: $100.00
```

---

### 14. Solution (General Liquid)
**Various Liquid Medicines**

```
Unit Name: Solution
Unit Abbreviation: Sol
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: ml per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Antiseptic Solution: 100ml per bottle, 20 bottles per box
- Mouthwash Solution: 250ml per bottle, 12 bottles per box
- Hydrogen Peroxide 3%: 100ml per bottle, 20 bottles per box

---

## ⚖️ **WEIGHT UNITS** (Measured by Weight)

### 15. Ointment (Topical Semi-Solid)
**External Use Preparations**

```
Unit Name: Ointment
Unit Abbreviation: Oint
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: tube
Allows Subdivision: YES ✓
Unit Size Label: grams per tube
Is Active: YES ✓
```

**Example Medicines:**
- Betadine Ointment: 30gm per tube, 20 tubes per box
- Diclofenac Gel: 50gm per tube, 10 tubes per box
- Hydrocortisone Ointment 1%: 15gm per tube, 20 tubes per box

**Medicine Configuration:**
```
Grams per Tube: 30
Tubes per Box: 20
Price per Gram: $0.50
Price per Tube: $15.00
Price per Box: $300.00
```

**POS Display:**
- Gm - $0.50 each
- Tube (30 gms) - $15.00
- Boxes (20 tubes = 600 gms) - $300.00

---

### 16. Cream (Topical Semi-Solid)
**Similar to Ointment but Different Base**

```
Unit Name: Cream
Unit Abbreviation: Crm
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: tube
Allows Subdivision: YES ✓
Unit Size Label: grams per tube
Is Active: YES ✓
```

**Example Medicines:**
- Clotrimazole Cream 1%: 20gm per tube, 20 tubes per box
- Moisturizing Cream: 50gm per tube, 10 tubes per box
- Steroid Cream: 15gm per tube, 20 tubes per box

---

### 17. Gel (Semi-Solid)
**Topical Gel Formulations**

```
Unit Name: Gel
Unit Abbreviation: Gel
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: tube
Allows Subdivision: YES ✓
Unit Size Label: grams per tube
Is Active: YES ✓
```

**Example Medicines:**
- Diclofenac Gel 1%: 30gm per tube, 10 tubes per box
- Aloe Vera Gel: 100gm per tube, 12 tubes per box
- Antiseptic Gel: 50gm per tube, 20 tubes per box

---

### 18. Powder (Dry Powder)
**Bulk Powder Medications**

```
Unit Name: Powder
Unit Abbreviation: Pwd
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: grams per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Antibiotic Powder for Suspension: 30gm per bottle, 10 bottles per box
- Antacid Powder: 100gm per bottle, 10 bottles per box
- Protein Powder: 500gm per bottle, 6 bottles per box

**Medicine Configuration:**
```
Grams per Bottle: 100
Bottles per Box: 10
Price per Gram: $0.10
Price per Bottle: $10.00
Price per Box: $100.00
```

---

### 19. Spray (Aerosol/Pump)
**Spray Medications**

```
Unit Name: Spray
Unit Abbreviation: Spr
Selling Method: weight
Base Unit Name: gm
Subdivision Unit: bottle
Allows Subdivision: YES ✓
Unit Size Label: grams per bottle
Is Active: YES ✓
```

**Example Medicines:**
- Nasal Spray: 15gm per bottle, 10 bottles per box
- Throat Spray: 30gm per bottle, 12 bottles per box
- Topical Anesthetic Spray: 50gm per bottle, 10 bottles per box

---

## 🎯 **SPECIALIZED UNITS**

### 20. Effervescent Tablet
**Dissolving Tablets**

```
Unit Name: Effervescent
Unit Abbreviation: Eff
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: tube
Allows Subdivision: YES ✓
Unit Size Label: tablets per tube
Is Active: YES ✓
```

**Example Medicines:**
- Vitamin C Effervescent 1000mg: 10 tablets per tube, 10 tubes per box
- Paracetamol Effervescent: 10 tablets per tube, 10 tubes per box
- Calcium Effervescent: 20 tablets per tube, 5 tubes per box

---

### 21. Lozenge/Pastille
**Throat Lozenges**

```
Unit Name: Lozenge
Unit Abbreviation: Loz
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: lozenges per pack
Is Active: YES ✓
```

**Example Medicines:**
- Throat Lozenges: 12 pieces per pack, 10 packs per box
- Vitamin C Lozenges: 20 pieces per pack, 10 packs per box
- Cough Lozenges: 10 pieces per pack, 20 packs per box

---

### 22. Pessary (Vaginal Tablet)
**Vaginal Medications**

```
Unit Name: Pessary
Unit Abbreviation: Pess
Selling Method: countable
Base Unit Name: piece
Subdivision Unit: pack
Allows Subdivision: YES ✓
Unit Size Label: pessaries per pack
Is Active: YES ✓
```

**Example Medicines:**
- Clotrimazole Pessary 500mg: 1 piece per pack, 10 packs per box
- Progesterone Pessary: 15 pieces per pack, 4 packs per box

---

### 23. Implant
**Subcutaneous Implants**

```
Unit Name: Implant
Unit Abbreviation: Imp
Selling Method: countable
Base Unit Name: unit
Subdivision Unit: (leave empty)
Allows Subdivision: NO ✗
Unit Size Label: (leave empty)
Is Active: YES ✓
```

**Example Medicines:**
- Contraceptive Implant: Sold individually
- Hormone Pellet: Sold individually

---

### 24. Device (Medical Devices)
**Medical Devices/Equipment**

```
Unit Name: Device
Unit Abbreviation: Dev
Selling Method: countable
Base Unit Name: unit
Subdivision Unit: (leave empty)
Allows Subdivision: NO ✗
Unit Size Label: (leave empty)
Is Active: YES ✓
```

**Example Medicines:**
- Blood Glucose Test Strips: Sold per unit/box
- Insulin Pen: Sold individually
- Nebulizer Mask: Sold individually

---

## 📋 **QUICK REFERENCE TABLE**

| Unit Type | Selling Method | Base Unit | Subdivision | Common Examples |
|-----------|---------------|-----------|-------------|-----------------|
| Tablet | countable | piece | strip | Paracetamol, Aspirin |
| Capsule | countable | piece | strip | Omeprazole, Amoxicillin |
| Suppository | countable | piece | pack | Paracetamol Supp, Glycerin |
| Patch | countable | piece | pack | Nicotine Patch, Pain Patch |
| Vial | countable | vial | pack | Insulin, Vaccines |
| Sachet | countable | piece | pack | ORS, Vitamin Powder |
| Inhaler | countable | unit | - | Ventolin, Symbicort |
| Ampoule | countable | piece | pack | Injectable Ampoules |
| Syrup | volume | ml | bottle | Cough Syrup, Paracetamol Syrup |
| Suspension | volume | ml | bottle | Antibiotic Suspension |
| Injection | volume | ml | vial | Injectable Solutions |
| IV Solution | volume | ml | bag | Saline, Dextrose |
| Drops | volume | ml | bottle | Eye/Ear Drops |
| Solution | volume | ml | bottle | Antiseptic, Mouthwash |
| Ointment | weight | gm | tube | Betadine, Diclofenac Gel |
| Cream | weight | gm | tube | Antifungal, Moisturizer |
| Gel | weight | gm | tube | Aloe Vera, Pain Gel |
| Powder | weight | gm | bottle | Antibiotic Powder |
| Spray | weight | gm | bottle | Nasal Spray, Throat Spray |
| Effervescent | countable | piece | tube | Vitamin C, Paracetamol |
| Lozenge | countable | piece | pack | Throat Lozenges |
| Pessary | countable | piece | pack | Vaginal Tablets |
| Implant | countable | unit | - | Contraceptive Implant |
| Device | countable | unit | - | Test Strips, Equipment |

---

## 🎓 **HOW TO USE THIS GUIDE**

### Step 1: Choose the Right Unit Type
Look at your medicine and determine:
- Is it countable (tablets, capsules)?
- Is it measured by volume (syrups, injections)?
- Is it measured by weight (ointments, creams)?

### Step 2: Configure the Unit
Go to `add_medicine_units.aspx` and enter:
- Unit name
- Abbreviation
- Selling method (countable/volume/weight)
- Base unit name
- Whether it allows subdivision
- Subdivision unit name

### Step 3: Register the Medicine
Go to `add_medicine.aspx` and:
- Select the unit you created
- Enter packaging details (items per strip/bottle/tube)
- Enter pricing for each level
- Save

### Step 4: Add Inventory
Go to `medicine_inventory.aspx` and:
- Select the medicine
- Enter stock quantities
- Add batch and expiry information
- Save

### Step 5: Sell in POS
Go to `pharmacy_pos.aspx` and:
- Select the medicine
- Choose sell type (piece, strip, bottle, tube, box)
- Enter quantity
- Complete sale

---

## 💡 **PRO TIPS**

1. **Consistent Naming**: Use standard medical terminology
2. **Clear Abbreviations**: Keep them short but recognizable
3. **Logical Subdivision**: Choose subdivisions that make sense (strips for tablets, bottles for syrups)
4. **Pricing Consistency**: Ensure pricing is consistent across levels
5. **Active Status**: Deactivate obsolete units instead of deleting

---

## 📞 **NEED A CUSTOM UNIT?**

If your medicine doesn't fit any of these categories:

1. Identify the selling method (countable/volume/weight)
2. Choose appropriate base unit name
3. Decide if subdivision is needed
4. Create custom unit with clear naming
5. Test in POS before full rollout

**Example Custom Unit:**
```
Unit Name: Nebulizer Solution
Unit Abbreviation: Neb
Selling Method: volume
Base Unit Name: ml
Subdivision Unit: vial
Allows Subdivision: YES
Unit Size Label: ml per vial
```

---

**Guide Version:** 1.0  
**Last Updated:** December 2024  
**Total Unit Types:** 24+ examples  
**Coverage:** Comprehensive for most pharmacy needs