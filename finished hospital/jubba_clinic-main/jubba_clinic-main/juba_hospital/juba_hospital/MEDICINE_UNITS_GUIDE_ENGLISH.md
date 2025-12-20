# 📚 Complete Guide - How to Save Each Medicine Unit Type

## English Version

---

# **15 Unit Types - Step-by-Step Examples**

---

## **1. TABLET** 💊

### **Medicine Configuration:**
```
Medicine Name: Paracetamol 500mg
Unit: Tablet
pieces per strip: 10
Strips per box: 10
Price per piece: 5 SDG
Price per strip: 45 SDG
Price per box: 400 SDG
```

### **Inventory:**
```
Primary Quantity: 50 (strips)
Secondary Quantity: 8 (loose tablets)
Unit Size: 10 (tablets per strip)
```

### **POS Selling:**
```
Sell Type: [Piece ▼] [Strip ▼] [Boxes ▼]

Example 1: Sell 25 pieces → 125 SDG
Example 2: Sell 5 strips → 225 SDG
Example 3: Sell 2 boxes → 800 SDG
```

---

## **2. CAPSULE** 💊

### **Medicine Configuration:**
```
Medicine Name: Amoxicillin 500mg Capsule
Unit: Capsule
pieces per strip: 10
Strips per box: 10
Price per piece: 8 SDG
Price per strip: 75 SDG
Price per box: 700 SDG
```

### **Inventory:**
```
Primary Quantity: 30 (strips)
Secondary Quantity: 5 (loose capsules)
Unit Size: 10 (capsules per strip)
```

### **POS Selling:**
```
Sell Type: [Piece ▼] [Strip ▼] [Boxes ▼]

Example: Customer needs 15 capsules → 120 SDG
```

---

## **3. SYRUP** 🍶

### **Medicine Configuration:**
```
Medicine Name: Amoxil Syrup 250mg/5ml
Unit: Syrup
ml per bottle: 120
Bottles per box: 1
Price per ml: 0.50 SDG
Price per bottle: 55 SDG
Price per box: 55 SDG
```

### **Inventory:**
```
Primary Quantity: 50 (bottles)
Secondary Quantity: 30 (loose ml from opened bottle)
Unit Size: 120 (ml per bottle)
```

### **POS Selling:**
```
Sell Type: [By Volume (ml) ▼] [Bottle ▼]

Example 1: Sell 80ml → 40 SDG
Example 2: Sell 3 bottles → 165 SDG
```

---

## **4. INJECTION** 💉

### **Medicine Configuration:**
```
Medicine Name: Insulin Regular 10ml
Unit: Injection
ml per vial: 10
Bottles per box: 1
Price per vial: 85 SDG
Price per container: 85 SDG (same as vial)
Price per box: 85 SDG
```

### **Inventory:**
```
Primary Quantity: 30 (vials)
Secondary Quantity: 0 (cannot open vials)
Unit Size: 10 (ml per vial - informational only)
```

### **POS Selling:**
```
Sell Type: [Vial ▼] (only option - cannot subdivide)

Example: Sell 5 vials → 425 SDG
Note: Cannot sell 2.5 vials or loose ml
```

---

## **5. DROPS** 💧

### **Medicine Configuration:**
```
Medicine Name: Eye Drops Refresh
Unit: Drops
ml per bottle: 15
Bottles per box: 1
Price per ml: 2 SDG
Price per bottle: 25 SDG
Price per box: 25 SDG
```

### **Inventory:**
```
Primary Quantity: 100 (bottles)
Secondary Quantity: 10 (loose ml)
Unit Size: 15 (ml per bottle)
```

### **POS Selling:**
```
Sell Type: [By Volume (ml) ▼] [Bottle ▼]

Example 1: Sell 10ml → 20 SDG
Example 2: Sell 2 bottles → 50 SDG
```

---

## **6. CREAM** 🧴

### **Medicine Configuration:**
```
Medicine Name: Betnovate Cream
Unit: Cream
grams per tube: 30
Tubes per box: 1
Price per tube: 45 SDG
Price per container: 45 SDG (same as tube)
Price per box: 45 SDG
```

### **Inventory:**
```
Primary Quantity: 50 (tubes)
Secondary Quantity: 0 (cannot open tubes)
Unit Size: 30 (grams per tube - informational)
```

### **POS Selling:**
```
Sell Type: [Tube ▼] (only option - cannot subdivide)

Example: Sell 3 tubes → 135 SDG
Note: Cannot sell half a tube
```

---

## **7. OINTMENT** 🧴

### **Medicine Configuration:**
```
Medicine Name: Antibiotic Ointment
Unit: Ointment
grams per tube: 15
Tubes per box: 1
Price per tube: 35 SDG
Price per container: 35 SDG
Price per box: 35 SDG
```

### **Inventory:**
```
Primary Quantity: 40 (tubes)
Secondary Quantity: 0
Unit Size: 15
```

### **POS Selling:**
```
Sell Type: [Tube ▼] (only option)

Example: Sell 2 tubes → 70 SDG
```

---

## **8. GEL** 🧴

### **Medicine Configuration:**
```
Medicine Name: Voltaren Gel
Unit: Gel
grams per tube: 50
Tubes per box: 1
Price per tube: 65 SDG
Price per container: 65 SDG
Price per box: 65 SDG
```

### **Inventory:**
```
Primary Quantity: 25 (tubes)
Secondary Quantity: 0
Unit Size: 50
```

### **POS Selling:**
```
Sell Type: [Tube ▼] (only option)

Example: Sell 1 tube → 65 SDG
```

---

## **9. INHALER** 💨

### **Medicine Configuration:**
```
Medicine Name: Ventolin Inhaler
Unit: Inhaler
doses per inhaler: 200
Inhalers per box: 1
Price per inhaler: 120 SDG
Price per container: 120 SDG
Price per box: 120 SDG
```

### **Inventory:**
```
Primary Quantity: 20 (inhalers)
Secondary Quantity: 0 (cannot open)
Unit Size: 200 (doses - informational)
```

### **POS Selling:**
```
Sell Type: [Inhaler ▼] (only option)

Example: Sell 2 inhalers → 240 SDG
Note: Cannot sell half inhaler
```

---

## **10. POWDER** 🥄

### **Medicine Configuration:**
```
Medicine Name: ORS Powder
Unit: Powder
grams per sachet: 20
Sachets per box: 10
Price per sachet: 5 SDG
Price per container: 5 SDG
Price per box: 45 SDG
```

### **Inventory:**
```
Primary Quantity: 100 (sachets)
Secondary Quantity: 0
Unit Size: 20
```

### **POS Selling:**
```
Sell Type: [Sachet ▼] (only option)

Example: Sell 5 sachets → 25 SDG
```

---

## **11. SACHET** 📦

### **Medicine Configuration:**
```
Medicine Name: Pain Relief Sachet
Unit: Sachet
grams per sachet: 10
Sachets per box: 20
Price per sachet: 8 SDG
Price per container: 8 SDG
Price per box: 150 SDG
```

### **Inventory:**
```
Primary Quantity: 200 (sachets)
Secondary Quantity: 0
Unit Size: 10
```

### **POS Selling:**
```
Sell Type: [Sachet ▼] (only option)

Example: Sell 10 sachets → 80 SDG
```

---

## **12. SUPPOSITORY** 🔴

### **Medicine Configuration:**
```
Medicine Name: Glycerin Suppository
Unit: Suppository
pieces per strip: 5
Strips per box: 4
Price per piece: 10 SDG
Price per strip: 45 SDG
Price per box: 170 SDG
```

### **Inventory:**
```
Primary Quantity: 30 (strips)
Secondary Quantity: 0
Unit Size: 5
```

### **POS Selling:**
```
Sell Type: [Piece ▼] (usually sold as whole pieces)

Example: Sell 6 pieces → 60 SDG
```

---

## **13. PATCH** 🩹

### **Medicine Configuration:**
```
Medicine Name: Nicotine Patch 21mg
Unit: Patch
pieces per strip: 7
Strips per box: 4
Price per piece: 15 SDG
Price per strip: 100 SDG
Price per box: 380 SDG
```

### **Inventory:**
```
Primary Quantity: 20 (strips)
Secondary Quantity: 0
Unit Size: 7
```

### **POS Selling:**
```
Sell Type: [Piece ▼] [Strip ▼] (patches sold by piece or strip)

Example: Sell 14 patches → 210 SDG
```

---

## **14. SPRAY** 🌬️

### **Medicine Configuration:**
```
Medicine Name: Nasal Spray
Unit: Spray
ml per bottle: 20
Bottles per box: 1
Price per bottle: 55 SDG
Price per container: 55 SDG
Price per box: 55 SDG
```

### **Inventory:**
```
Primary Quantity: 35 (bottles)
Secondary Quantity: 0
Unit Size: 20
```

### **POS Selling:**
```
Sell Type: [Bottle ▼] (only option)

Example: Sell 2 bottles → 110 SDG
```

---

## **15. BOTTLE** 🍼

### **Medicine Configuration:**
```
Medicine Name: Oral Rehydration Solution
Unit: Bottle
ml per bottle: 500
Bottles per box: 12
Price per ml: 0.10 SDG
Price per bottle: 45 SDG
Price per box: 520 SDG
```

### **Inventory:**
```
Primary Quantity: 60 (bottles)
Secondary Quantity: 100 (loose ml)
Unit Size: 500
```

### **POS Selling:**
```
Sell Type: [By Volume (ml) ▼] [Bottle ▼]

Example 1: Sell 250ml → 25 SDG
Example 2: Sell 4 bottles → 180 SDG
```

---

# **🔑 KEY RULES TO REMEMBER**

## **📊 Unit Categories**

### **Category 1: COUNTABLE with SUBDIVISIONS** (Can sell pieces, packs, boxes)
- **Units:** Tablet, Capsule, Suppository, Patch
- **Inventory:** Primary = strips/packs, Secondary = loose pieces
- **POS:** Can sell by piece, strip, or box

### **Category 2: VOLUME-BASED** (Can sell by ml, bottles)
- **Units:** Syrup, Drops, Bottle
- **Inventory:** Primary = bottles, Secondary = loose ml
- **POS:** Can sell by ml or bottle

### **Category 3: WHOLE UNITS ONLY** (Cannot subdivide)
- **Units:** Injection, Cream, Ointment, Gel, Inhaler, Powder, Sachet, Spray
- **Inventory:** Primary = units, Secondary = 0 (cannot open)
- **POS:** Can only sell whole units

---

## **💡 QUICK REFERENCE TABLE**

| Unit | Can Subdivide? | Primary Unit | Secondary Unit | Sell Options |
|------|----------------|--------------|----------------|--------------|
| Tablet | ✅ Yes | Strips | Loose pieces | Piece, Strip, Box |
| Capsule | ✅ Yes | Strips | Loose pieces | Piece, Strip, Box |
| Syrup | ✅ Yes | Bottles | Loose ml | ml, Bottle |
| Drops | ✅ Yes | Bottles | Loose ml | ml, Bottle |
| Bottle | ✅ Yes | Bottles | Loose ml | ml, Bottle |
| Injection | ❌ No | Vials | N/A | Vial only |
| Cream | ❌ No | Tubes | N/A | Tube only |
| Ointment | ❌ No | Tubes | N/A | Tube only |
| Gel | ❌ No | Tubes | N/A | Tube only |
| Inhaler | ❌ No | Inhalers | N/A | Inhaler only |
| Powder | ❌ No | Sachets | N/A | Sachet only |
| Sachet | ❌ No | Sachets | N/A | Sachet only |
| Suppository | ✅ Yes | Strips | Loose pieces | Piece, Strip |
| Patch | ✅ Yes | Strips | Loose pieces | Piece, Strip |
| Spray | ❌ No | Bottles | N/A | Bottle only |

---

## **🎯 HOW TO USE THIS GUIDE**

### **Step 1: Identify Your Medicine Type**
Look at the physical form of the medicine and find the matching unit type above.

### **Step 2: Follow the Example**
Use the exact format shown in the examples for that unit type.

### **Step 3: Add to System**
1. Add Medicine in Medicine Management
2. Add Stock in Inventory Management
3. Test selling at POS

### **Step 4: Verify**
Check that:
- Medicine saves correctly
- Inventory shows proper stock
- POS shows correct sell options
- Prices calculate correctly

---

## **⚠️ COMMON MISTAKES TO AVOID**

1. ❌ **Don't mix unit types**
   - Don't use "Tablet" for liquids
   - Don't use "Syrup" for solid medicines

2. ❌ **Don't leave fields empty**
   - Fill all price fields (even if same value)
   - Set proper unit sizes

3. ❌ **Don't add loose items to non-subdividable units**
   - Injections, Creams, Inhalers cannot have Secondary Quantity
   - Only use Primary Quantity for these

4. ❌ **Don't forget to set unit_size**
   - This is critical for stock calculations
   - Must match "pieces per strip" or "ml per bottle"

---

## **📞 SUPPORT**

If you have questions about any unit type:
1. Check this guide first
2. Look at the examples for similar medicines
3. Test with small quantities first
4. Verify at POS before large inventory entry

---

**Last Updated:** December 2024  
**Version:** 2.0  
**Language:** English  
**Status:** ✅ Complete Guide

---

**END OF ENGLISH GUIDE**
