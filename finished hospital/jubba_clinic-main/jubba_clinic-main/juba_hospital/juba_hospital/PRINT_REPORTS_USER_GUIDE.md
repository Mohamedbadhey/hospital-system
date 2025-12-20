# Print Reports - User Guide

## Quick Start Guide for Pharmacy Staff

### 📊 Low Stock Alert Report

**When to Use:**
- Daily inventory checks
- Weekly/monthly procurement planning
- Management reporting
- Audit documentation

**How to Print:**
1. Go to **Pharmacy Dashboard** → **Low Stock Alerts**
2. Click the blue **"Print Report"** button (top-right corner)
3. New window opens with professional report
4. Click **"Print Report"** or press `Ctrl+P`
5. Select your printer or **"Save as PDF"**
6. Done! ✓

**What's Included in the Report:**
- Hospital name, address, and contact info (from settings)
- Report generation date and time
- Summary statistics:
  - Total items below reorder level
  - Critical items count (out of stock)
- Detailed table with:
  - Medicine name and generic name
  - Manufacturer information
  - Unit type (strips, bottles, etc.)
  - Current stock quantity
  - Reorder level threshold
  - Status (Out of Stock, Critical, or Low)
- Color-coded rows (red for urgent, yellow for warning)
- Signature sections for staff and manager

---

### 💊 Expired & Expiring Medicines Report

**When to Use:**
- Monthly expiry checks (required for compliance)
- Before conducting pharmacy audits
- Documenting disposal activities
- Quality control reporting

**How to Print:**
1. Go to **Pharmacy Dashboard** → **Expired & Expiring Soon Medicines**
2. Click the blue **"Print Report"** button (top-right corner)
3. New window opens with professional report
4. Click **"Print Report"** or press `Ctrl+P`
5. Select your printer or **"Save as PDF"**
6. Done! ✓

**What's Included in the Report:**
- Hospital name, address, and contact info
- Report generation date and time
- Summary statistics:
  - Total items (expired + expiring)
  - Already expired count
  - Expiring soon count (within 30 days)
- Detailed table with:
  - Medicine name
  - Batch number
  - Expiry date
  - Days remaining (or days since expired)
  - Primary and secondary quantities
  - Unit size
  - Status (Expired or Expiring Soon)
- Color-coded rows (red for expired, yellow for expiring)
- Disposal instructions and guidelines
- Signature sections for staff and manager

---

## 💡 Tips & Best Practices

### For Best Print Quality:
- Use **Chrome** or **Edge** browser (best print rendering)
- Set page size to **A4** or **Letter**
- Use **Portrait** orientation
- Enable **"Print backgrounds"** for color-coded rows
- Margins: **Default** or **Minimum**

### Save as PDF:
Instead of printing on paper, you can save as PDF:
1. Click Print button
2. Select **"Microsoft Print to PDF"** or **"Save as PDF"**
3. Choose location and filename
4. Click Save

**Benefits of PDF:**
- Email to management
- Attach to procurement requests
- Archive for compliance
- No paper waste!

### Regular Reporting Schedule:
**Recommended:**
- **Low Stock Report**: Daily (before ordering)
- **Expired Medicines Report**: Monthly (1st of each month)

### File Naming Convention:
When saving PDFs, use this format:
- `LowStock_YYYY-MM-DD.pdf` (e.g., `LowStock_2024-01-15.pdf`)
- `ExpiredMeds_YYYY-MM-DD.pdf` (e.g., `ExpiredMeds_2024-01-15.pdf`)

---

## 🎨 Understanding Report Colors

### Low Stock Report:
- **Red Background**: URGENT - Out of stock or critically low
- **Yellow Background**: WARNING - Below reorder level
- **Red Badge**: "OUT OF STOCK" - Zero quantity
- **Red Badge**: "CRITICAL" - Less than 50% of reorder level
- **Yellow Badge**: "LOW" - Below reorder level

### Expired Medicines Report:
- **Red Background**: Medicine is EXPIRED
- **Yellow Background**: Medicine expiring within 30 days
- **Red Badge**: "EXPIRED" - Already past expiry date
- **Yellow Badge**: "EXPIRING SOON" - Still valid but expires soon

---

## 📋 Using Reports for Action Items

### After Printing Low Stock Report:
1. **Review Critical Items** (red rows) - Order immediately
2. **Check Low Items** (yellow rows) - Plan procurement
3. **Calculate Order Quantities**:
   - Difference = Reorder Level - Current Stock
   - Order at least the difference amount
4. **Get Manager Approval** (use signature line)
5. **Submit to Procurement Department**
6. **File Report** for audit trail

### After Printing Expired Medicines Report:
1. **Segregate Expired Items** (red rows) - Remove from shelves immediately
2. **Mark Expiring Items** (yellow rows) - Use first (FEFO rule)
3. **Complete Disposal Form**:
   - List all expired medicines
   - Include batch numbers and quantities
   - Get manager signature
4. **Document Disposal**:
   - Attach report to disposal record
   - Update inventory system
   - File for compliance audit
5. **Order Replacements** if needed

---

## 🔒 Security & Compliance

**Authentication Required:**
- Only logged-in pharmacy staff can access reports
- Admin users also have access
- Session-based security

**Audit Trail:**
- Each report shows generation date/time
- Keep printed/PDF reports for audit purposes
- Recommended retention: **3 years** (or per local regulations)

**Data Accuracy:**
- Reports pull real-time data from database
- Always reflects current inventory status
- Ensure inventory is updated regularly for accurate reports

---

## ❓ Troubleshooting

### Problem: Report shows "JUBA HOSPITAL PHARMACY" instead of our hospital name
**Solution:** Update hospital settings:
1. Go to **Hospital Settings** page
2. Enter your hospital name, address, phone, email
3. Save settings
4. Refresh report - it will now show correct information

### Problem: Print button doesn't work
**Solution:** 
- Check if pop-up blocker is enabled (disable for this site)
- Try different browser (Chrome/Edge recommended)
- Refresh the page and try again

### Problem: Report is empty or shows "No data"
**Solution:**
- **Low Stock**: No medicines are below reorder level (good news!)
- **Expired**: No medicines are expired or expiring (good news!)
- Verify data entry is up to date

### Problem: Colors don't print
**Solution:**
- In print dialog, enable **"Background graphics"**
- Chrome: More settings → Check "Background graphics"
- Edge: Similar option in print settings

### Problem: Report layout looks wrong when printing
**Solution:**
- Use A4 or Letter paper size
- Select Portrait orientation
- Use Chrome or Edge browser
- Try Print Preview first

---

## 📞 Support

For technical issues or questions about the reports:
- Contact your IT department
- Reference: **Print Reports Implementation**
- Documentation: See `PRINT_REPORTS_IMPLEMENTATION.md`

---

## ✅ Quick Checklist

**Before Printing:**
- [ ] Data is up to date in system
- [ ] Hospital settings configured correctly
- [ ] Printer is connected and working
- [ ] Browser is Chrome or Edge (recommended)

**After Printing:**
- [ ] Review all flagged items
- [ ] Get manager signature
- [ ] Take appropriate action (order/dispose)
- [ ] File report for records
- [ ] Update inventory system

---

**Last Updated:** January 2024
**Version:** 1.0
