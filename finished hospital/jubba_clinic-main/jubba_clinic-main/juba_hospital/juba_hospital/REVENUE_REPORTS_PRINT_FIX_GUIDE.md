# Revenue Reports Print Functionality - Fix Guide

## Status: 2/6 Complete

### ✅ Completed:
1. pharmacy_revenue_report.aspx - Already had print styling
2. lab_revenue_report.aspx - **FIXED** with professional headers

### ⚠️ Remaining:
3. xray_revenue_report.aspx
4. bed_revenue_report.aspx
5. delivery_revenue_report.aspx
6. registration_revenue_report.aspx

---

## What Was Added to Lab Revenue Report:

### 1. Print-Only Header CSS (Add to `<style>` section):

```css
.print-only-header {
    display: none;
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 3px solid #333;
}
.print-only-header h1 {
    margin: 10px 0;
    font-size: 28px;
    color: #2c3e50;
}
.print-only-header h3 {
    margin: 15px 0 5px;
    font-size: 20px;
    color: #e74c3c;
}
.print-only-header p {
    margin: 5px 0;
    color: #666;
}

@media print {
    .no-print { display: none !important; }
    .print-only-header { display: block !important; }
    body { padding: 20px; }
    table { page-break-inside: auto; }
    tr { page-break-inside: avoid; page-break-after: auto; }
    thead { display: table-header-group; }
    tfoot { display: table-footer-group; }
}
```

### 2. Print Header HTML (Add at beginning of `<div class="card-body">`):

```html
<!-- Print-Only Header -->
<div class="print-only-header">
    <h1>JUBA CLINIC</h1>
    <p>Mogadishu, Somalia | Tel: +252 XXX XXX XXX</p>
    <h3>[REPORT NAME] REVENUE REPORT</h3>
    <p>Report Period: <span id="printStartDate"></span> to <span id="printEndDate"></span></p>
    <p>Generated: <span id="printGeneratedDate"></span></p>
</div>
```

### 3. Print Report JavaScript Function:

```javascript
function printReport() {
    // Update print header with current dates
    $('#printStartDate').text($('#startDate').val() || 'N/A');
    $('#printEndDate').text($('#endDate').val() || 'N/A');
    $('#printGeneratedDate').text(new Date().toLocaleString());
    window.print();
}
```

### 4. Update Print Button:

Change from:
```html
<button onclick="window.print()">
```

To:
```html
<button onclick="printReport()">
```

---

## Quick Copy-Paste for Each Report:

### For X-Ray Revenue Report:
Replace `[REPORT NAME]` with: **X-RAY**

### For Bed Revenue Report:
Replace `[REPORT NAME]` with: **BED CHARGES**

### For Delivery Revenue Report:
Replace `[REPORT NAME]` with: **DELIVERY**

### For Registration Revenue Report:
Replace `[REPORT NAME]` with: **REGISTRATION**

---

## Benefits of This Fix:

✅ **Professional Headers**: Hospital name, address, contact info
✅ **Report Title**: Clear identification of report type
✅ **Date Range**: Shows the period being reported
✅ **Timestamp**: When the report was generated
✅ **Clean Print**: Filters, buttons hidden automatically
✅ **Proper Pagination**: Tables break correctly across pages
✅ **No Screen Impact**: Header only appears when printing

---

## Testing:

1. Open the report page
2. Select a date range
3. Click "Print Report" button
4. Check print preview shows:
   - Hospital header at top
   - Report title
   - Date range
   - Clean table without buttons/filters

---

## Notes:

- All reports already have `.no-print` classes on filters/buttons
- All reports already have `@media print` CSS
- This fix just adds the professional header
- Watermark div already exists in most reports

---

## Next Steps:

Apply the same pattern to remaining 4 reports:
1. Copy CSS to `<style>` section
2. Add HTML header after `<div class="card-body">`
3. Add `printReport()` function to JavaScript
4. Change button from `window.print()` to `printReport()`

Each report takes about 2 minutes to fix following this pattern.
