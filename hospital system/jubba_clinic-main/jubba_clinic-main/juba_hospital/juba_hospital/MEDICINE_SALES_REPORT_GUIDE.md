# Medicine Sales & Profit Report - User Guide

## Overview
The Medicine Sales & Profit Report provides detailed analysis of sales performance for each individual medicine. This report helps you identify which medicines are generating the most revenue, which are most profitable, and track sales trends over time.

## Features

### 📊 Summary Dashboard
- **Total Revenue** - Total sales revenue for the selected period
- **Total Profit** - Total profit generated (Revenue - Cost)
- **Total Cost** - Total cost of medicines sold
- **Medicines Sold** - Number of unique medicines sold

### 🔍 Filtering Options
- **Date Range** - Select custom start and end dates
- **Quick Filters** - One-click access to Today, This Week, This Month
- **Medicine Filter** - Search and filter by medicine name in real-time
- **Auto-load** - Report loads automatically with today's data

### 📈 Main Report Table
Each medicine displays:
- **Medicine Name & Generic Name** - Full identification
- **Total Qty Sold** - Total quantity across all unit types
- **Unit Types** - Shows what units were sold (piece, strip, box, etc.)
- **Total Revenue** - Total sales amount
- **Total Cost** - Total cost of goods sold
- **Total Profit** - Profit = Revenue - Cost (color-coded green/red)
- **Profit Margin %** - Percentage profit margin
- **Avg. Selling Price** - Average price per unit
- **Times Sold** - Number of transactions

### 🎯 Interactive Features
- **Sortable Columns** - Click any column header to sort
- **Clickable Rows** - Click any medicine row to view detailed breakdown
- **Top 3 Highlighting** - Top 3 medicines by revenue are highlighted
- **Real-time Search** - Filter medicines as you type

### 📋 Detailed Medicine View (Modal)
When you click a medicine, you see:

1. **Summary Cards**
   - Total Revenue
   - Total Profit
   - Quantity Sold
   - Profit Margin %

2. **Sales Breakdown by Unit Type**
   - Shows how much was sold by piece, strip, box, etc.
   - Revenue, cost, and profit for each unit type

3. **Recent Transactions**
   - Last 20 transactions for this medicine
   - Date, Invoice #, Quantity, Unit Type, Prices, Profit
   - Helps identify sales patterns

### 📄 Export Options
- **Export to Excel** - Download full report
- **Print Report** - Professional print layout

## How to Use

### Step 1: Access the Report
1. Login to pharmacy dashboard
2. Click **"Medicine Sales Report"** in the sidebar
3. Report loads automatically with today's data

### Step 2: Select Date Range
**Option A - Quick Filters:**
- Click "Today" for today's sales
- Click "This Week" for current week
- Click "This Month" for current month

**Option B - Custom Range:**
- Select Start Date
- Select End Date
- Click "Load Report"

### Step 3: Analyze Results
The report is sorted by **Total Revenue** (highest to lowest) by default.

**Key Metrics to Watch:**
- **Top Selling Medicines** - Highlighted in yellow
- **Profit Margins** - Should be positive (green)
- **Negative Profits** - Shows in red, indicates selling below cost

### Step 4: View Medicine Details
1. Click on any medicine row
2. Modal opens with detailed breakdown
3. Review:
   - Which unit types sell most (piece vs strip vs box)
   - Recent transaction history
   - Individual sale profits

### Step 5: Filter by Medicine Name
- Type medicine name in "Medicine Filter" box
- Table updates in real-time
- Useful for tracking specific medicines

## Understanding the Data

### Revenue vs Profit
- **Revenue** = Total selling price received
- **Cost** = What you paid for the medicines
- **Profit** = Revenue - Cost
- **Margin %** = (Profit / Revenue) × 100

### Example:
```
Medicine: Amoxicillin 500mg
Quantity Sold: 100 pieces
Revenue: $50.00
Cost: $30.00
Profit: $20.00
Margin: 40%
```

### Profit Margin Guidelines
- **Good**: 30-50% margin
- **Average**: 15-30% margin
- **Low**: Below 15% margin
- **Loss**: Negative margin (selling below cost)

### Unit Types Explained
Different medicines can be sold in different ways:
- **piece/tablet** - Individual pills
- **strip** - Strip containing multiple tablets
- **box** - Full box containing multiple strips
- **bottle/vial** - Liquid medications
- **tube/sachet** - Creams, ointments

## Business Insights

### What to Look For

1. **Best Performers**
   - Top 3 medicines by revenue (highlighted)
   - High profit margins
   - Consistent sales volume

2. **Underperformers**
   - Low profit margins
   - Negative profits (selling at loss)
   - Rarely sold items

3. **Sales Patterns**
   - Which unit types sell most
   - Peak sales days/periods
   - Seasonal variations

4. **Pricing Issues**
   - Medicines sold below cost (red profit)
   - Unusually low margins
   - Inconsistent pricing

## Common Scenarios

### Scenario 1: Finding Your Best-Selling Medicine
1. Load report for "This Month"
2. Table is already sorted by Revenue
3. #1 medicine is your top seller
4. Click it to see breakdown

### Scenario 2: Checking Profit on a Specific Medicine
1. Type medicine name in filter
2. View profit and margin columns
3. Click medicine for unit-type breakdown
4. Review if pricing is optimal

### Scenario 3: Monthly Performance Review
1. Set date range to full month
2. Export to Excel for records
3. Review top 10 medicines
4. Check profit margins
5. Identify any losses

### Scenario 4: Comparing Different Sale Types
1. Select a medicine
2. View breakdown by unit type
3. Compare profit for piece vs strip vs box
4. Adjust pricing if needed

## Tips for Better Profits

1. **Monitor Regularly**
   - Check daily to catch issues early
   - Review weekly trends
   - Analyze monthly performance

2. **Price Optimization**
   - Ensure all medicines show green profits
   - Check if strip/box pricing is proportional
   - Adjust prices for low-margin items

3. **Inventory Planning**
   - Stock more of high-profit medicines
   - Consider discontinuing low-profit items
   - Monitor slow-moving medicines

4. **Cost Control**
   - Compare cost prices with suppliers
   - Negotiate better rates for top sellers
   - Watch for cost increases

5. **Sales Strategy**
   - Promote high-margin medicines
   - Bundle slow-movers with fast-movers
   - Train staff on profitable items

## Troubleshooting

### No Data Showing
- **Check date range** - Ensure dates have sales
- **Try "This Month"** - Broader range
- **Verify sales data** - Check if sales were recorded

### Wrong Profit Calculations
- **Check cost prices** - Ensure medicine cost is correct
- **Verify sale prices** - Check if prices are set properly
- **Review unit types** - Ensure strip/box costs are set

### Medicine Not Appearing
- **Date range** - Medicine might not have been sold in period
- **Spelling** - Check medicine name spelling in filter
- **Sales recorded** - Verify sales were completed, not just cart

## Report Sections Explained

### Top Summary Cards
Shows overall performance at a glance. These update based on your date range filter.

### Main Table
Comprehensive list of all medicines sold. Use this for:
- Comparing medicines
- Identifying trends
- Spotting issues

### Detail Modal
Deep dive into a single medicine. Use this for:
- Understanding unit type performance
- Reviewing transaction history
- Verifying profit calculations

## Data Accuracy

The report pulls data from:
- `pharmacy_sales` table - Sale headers
- `pharmacy_sales_items` table - Individual items sold
- `medicine` table - Medicine details

**Important**: Cost accuracy depends on:
1. Correct `cost_per_tablet`, `cost_per_strip`, `cost_per_box` in medicine table
2. Proper cost recorded during sale
3. Unit type correctly selected during sale

## Best Practices

1. **Daily Review** - Check today's sales each evening
2. **Weekly Analysis** - Review top/bottom performers
3. **Monthly Reports** - Export and archive for records
4. **Quarterly Strategy** - Adjust pricing and inventory
5. **Annual Review** - Year-over-year comparison

## Need Help?

If you notice:
- Negative profits on many medicines → Check pricing
- Zero costs → Update medicine cost prices
- Wrong quantities → Verify unit conversions
- Missing medicines → Check date range and sales data

## Related Reports
- **Pharmacy Sales & Profit Reports** - Overall pharmacy performance
- **Sales History** - Transaction-level detail
- **Inventory Reports** - Stock levels and reorder needs

---

**Remember**: This report helps you make informed business decisions. Regular monitoring leads to better profitability and inventory management.
