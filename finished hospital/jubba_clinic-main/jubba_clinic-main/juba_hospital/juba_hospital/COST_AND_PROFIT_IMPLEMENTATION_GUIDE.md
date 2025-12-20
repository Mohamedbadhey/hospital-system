# 💰 Cost & Profit Tracking Implementation Guide

## Overview

Adding **cost price** and **selling price** tracking throughout the pharmacy system to calculate **profit and loss**.

---

# 🎯 **COMPLETE IMPLEMENTATION**

## **What Gets Added**

### **1. Medicine Master Data**
```
COST (What you pay):
  - Cost per piece/tablet: 3 SDG
  - Cost per strip: 28 SDG
  - Cost per box: 250 SDG

SELLING PRICE (What customer pays):
  - Price per piece: 5 SDG
  - Price per strip: 45 SDG
  - Price per box: 400 SDG

PROFIT PER UNIT:
  - Piece: 5 - 3 = 2 SDG (66% profit)
  - Strip: 45 - 28 = 17 SDG (60% profit)
  - Box: 400 - 250 = 150 SDG (60% profit)
```

### **2. Inventory Purchase**
```
When adding stock:
  - Quantity: 50 strips
  - Purchase Price: 28 SDG per strip
  - Total Cost: 50 × 28 = 1,400 SDG
  - (This is your investment)
```

### **3. Sales Tracking**
```
When selling:
  - Customer buys 5 strips
  - Selling Price: 5 × 45 = 225 SDG
  - Cost Price: 5 × 28 = 140 SDG
  - PROFIT: 225 - 140 = 85 SDG
```

### **4. Reports**
```
Daily/Monthly Reports show:
  - Total Sales: 10,000 SDG
  - Total Cost: 6,000 SDG
  - Total Profit: 4,000 SDG
  - Profit %: 66%
```

---

# 📋 **IMPLEMENTATION STEPS**

## **STEP 1: Database (SQL Script)**

📄 **Run:** `ADD_COST_AND_PROFIT_TRACKING.sql`

**What it adds:**

### **medicine table:**
```sql
cost_per_tablet FLOAT    -- Your cost for 1 piece
cost_per_strip FLOAT     -- Your cost for 1 strip
cost_per_box FLOAT       -- Your cost for 1 box
```

### **medicine_inventory table:**
```sql
purchase_price FLOAT     -- Actual price you paid when buying this batch
```

### **pharmacy_sales_items table:**
```sql
cost_price FLOAT         -- Cost at time of sale
profit FLOAT             -- Calculated: selling - cost
```

### **pharmacy_sales table:**
```sql
total_cost FLOAT         -- Total cost of all items in sale
total_profit FLOAT       -- Total profit for entire sale
```

### **View created:**
```sql
v_pharmacy_profit_report -- Easy profit reporting
```

---

## **STEP 2: Update Add Medicine Form**

### **Current Form:**
```
Medicine Name: [_______________]
Unit: [Tablet ▼]
Pieces per strip: [10]
Price per strip: [45]      ← Selling price
```

### **Enhanced Form:**
```
Medicine Name: [_______________]
Unit: [Tablet ▼]
Pieces per strip: [10]

COST PRICES (What you pay supplier):
  Cost per piece: [3]
  Cost per strip: [28]
  Cost per box: [250]

SELLING PRICES (What customer pays):
  Price per piece: [5]      ← Shows profit: 66%
  Price per strip: [45]     ← Shows profit: 60%
  Price per box: [400]      ← Shows profit: 60%
```

---

## **STEP 3: Update Medicine Inventory Form**

### **Current Form:**
```
Medicine: [Paracetamol ▼]
Quantity: [50]
Expiry: [2026-12-31]
```

### **Enhanced Form:**
```
Medicine: [Paracetamol ▼]
Quantity: [50] strips

Purchase Details:
  Purchase Price per strip: [28] SDG
  Total Cost: 1,400 SDG     ← Auto-calculated
  Supplier: [_______________]
  Invoice #: [_______________]

Expiry: [2026-12-31]
Batch: [BATCH-001]
```

---

## **STEP 4: Update POS System**

### **Current Display:**
```
Item: Paracetamol - 5 strips
Price: 5 × 45 = 225 SDG
```

### **Enhanced Display (Staff View):**
```
Item: Paracetamol - 5 strips
Selling Price: 5 × 45 = 225 SDG
Cost: 5 × 28 = 140 SDG
Profit: 85 SDG (60%)      ← Shows in admin view
```

---

## **STEP 5: Add Profit Reports**

### **New Reports:**

#### **A. Daily Profit Report**
```
Date: 2024-12-15

Total Sales: 10,000 SDG
Total Cost: 6,000 SDG
Total Profit: 4,000 SDG
Profit %: 66.7%

Top Profitable Items:
  1. Paracetamol - 500 SDG profit
  2. Amoxil - 350 SDG profit
  3. Cough Syrup - 200 SDG profit
```

#### **B. Medicine Profit Analysis**
```
Medicine: Paracetamol 500mg

Average Cost: 28 SDG per strip
Average Selling: 45 SDG per strip
Average Profit: 17 SDG per strip (60%)

This Month:
  Sold: 200 strips
  Revenue: 9,000 SDG
  Cost: 5,600 SDG
  Profit: 3,400 SDG
```

#### **C. Inventory Value Report**
```
Current Inventory Value:

Total Stock Cost: 50,000 SDG    ← What you invested
Potential Revenue: 80,000 SDG   ← If sell everything
Potential Profit: 30,000 SDG (60%)
```

---

# 🎨 **UI EXAMPLES**

## **Add Medicine - Two Sections**

```
┌─────────────────────────────────────────┐
│ BASIC INFORMATION                        │
├─────────────────────────────────────────┤
│ Medicine Name: Paracetamol 500mg        │
│ Generic Name: Paracetamol               │
│ Unit: Tablet                            │
│ Pieces per strip: 10                    │
│ Strips per box: 10                      │
├─────────────────────────────────────────┤
│ COST PRICES (Your Purchase Cost)        │
├─────────────────────────────────────────┤
│ Cost per piece: 3.00 SDG                │
│ Cost per strip: 28.00 SDG               │
│ Cost per box: 250.00 SDG                │
├─────────────────────────────────────────┤
│ SELLING PRICES (Customer Pays)          │
├─────────────────────────────────────────┤
│ Price per piece: 5.00 SDG  [+66.7%] ✓  │
│ Price per strip: 45.00 SDG [+60.7%] ✓  │
│ Price per box: 400.00 SDG  [+60.0%] ✓  │
└─────────────────────────────────────────┘
```

## **POS - Profit Indicator**

```
┌─────────────────────────────────────────┐
│ CART                                     │
├─────────────────────────────────────────┤
│ Paracetamol - 5 strips                  │
│ 5 × 45 = 225 SDG                        │
│ Profit: 85 SDG (60%) 📊                 │
├─────────────────────────────────────────┤
│ Amoxil Syrup - 2 bottles                │
│ 2 × 55 = 110 SDG                        │
│ Profit: 30 SDG (37.5%) 📊              │
├─────────────────────────────────────────┤
│ TOTAL                                    │
│ Selling: 335 SDG                        │
│ Cost: 210 SDG                           │
│ Profit: 125 SDG (59.5%) 💰             │
└─────────────────────────────────────────┘
```

---

# 📊 **PROFIT CALCULATION LOGIC**

## **Per Item:**
```javascript
profit_per_unit = selling_price - cost_price
profit_percentage = (profit / cost_price) × 100

Example:
  Cost: 28 SDG
  Selling: 45 SDG
  Profit: 17 SDG
  Profit %: (17 / 28) × 100 = 60.7%
```

## **Per Sale:**
```javascript
total_selling = sum(all items selling price)
total_cost = sum(all items cost price)
total_profit = total_selling - total_cost
profit_percentage = (total_profit / total_cost) × 100
```

## **Per Period:**
```javascript
period_revenue = sum(all sales)
period_cost = sum(all costs)
period_profit = period_revenue - period_cost
profit_margin = (period_profit / period_revenue) × 100
```

---

# 🚀 **QUICK IMPLEMENTATION**

## **For Immediate Use:**

### **1. Run SQL Script** (2 minutes)
```
1. Open: ADD_COST_AND_PROFIT_TRACKING.sql
2. Execute in SQL Server
3. Verify columns added
```

### **2. Add Cost Fields to Forms** (15 minutes)
- Add medicine form: 3 cost fields
- Inventory form: 1 purchase price field

### **3. Update Backend Queries** (10 minutes)
- Save cost values when adding medicine
- Track purchase price in inventory
- Calculate profit on sale

### **4. Add Profit Display** (10 minutes)
- Show profit in POS (optional)
- Show profit in reports

**Total Time: ~40 minutes**

---

# 💡 **BUSINESS BENEFITS**

## **What You Can Do:**

✅ **Track True Profitability**
- Know which medicines make most profit
- Identify loss-making items

✅ **Inventory Valuation**
- Know how much money is tied up in stock
- Calculate inventory worth accurately

✅ **Pricing Decisions**
- Set better profit margins
- Adjust prices based on cost changes

✅ **Supplier Negotiations**
- Compare supplier costs
- Track price changes over time

✅ **Financial Reports**
- Daily/Monthly P&L reports
- Tax calculations
- Business performance tracking

---

# 📝 **EXAMPLE SCENARIOS**

## **Scenario 1: Adding New Medicine**

```
Staff adds: Paracetamol 500mg Tablet

Cost Section:
  Cost per strip: 28 SDG
  (This is what supplier charges you)

Selling Section:
  Price per strip: 45 SDG
  System shows: "Profit: 17 SDG (60.7%)" ✓

Staff sees profit margin is good → Approves
```

## **Scenario 2: Receiving Stock**

```
Delivery arrives: 100 strips Paracetamol

Purchase Price: 27 SDG per strip
(Supplier gave discount! Usually 28 SDG)

Total Investment: 100 × 27 = 2,700 SDG

System tracks: If you sell all at 45 SDG
  Revenue: 4,500 SDG
  Profit: 1,800 SDG (66%)
```

## **Scenario 3: End of Day**

```
Closing Report:

Sales Today: 25 transactions
Revenue: 12,500 SDG
Cost: 7,800 SDG
Profit: 4,700 SDG
Margin: 60%

Best Seller: Paracetamol (2,500 SDG profit)
```

---

# ✅ **NEXT STEPS**

## **Choose Implementation Level:**

### **Option A: BASIC (Recommended)**
1. Run SQL script
2. Add cost fields to add_medicine form
3. Add purchase price to inventory form
4. Done! Manual profit calculation

**Time: 30 minutes**

### **Option B: STANDARD**
1. Everything in Basic
2. Auto-calculate profit in POS
3. Show profit in sales reports
4. Basic profit report page

**Time: 2 hours**

### **Option C: ADVANCED**
1. Everything in Standard
2. Profit dashboard with charts
3. Medicine profit analysis
4. Supplier cost tracking
5. Inventory valuation report

**Time: 4-6 hours**

---

**Which level do you want? I'll implement it for you!**

Just say: **"Basic", "Standard", or "Advanced"**

Or tell me specific features you want!

