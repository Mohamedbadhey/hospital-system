# Watermark Testing Guide

## Quick Test Instructions

### Step 1: Test a Print Page
1. Start the application
2. Navigate to any print page, for example:
   - `print_all_outpatients.aspx`
   - `patient_invoice_print.aspx`
   - `lab_orders_print.aspx`
   - `discharge_summary_print.aspx`

### Step 2: Visual Verification

#### On Screen View:
- You should see a very faint (5% opacity) hospital logo
- Logo should be rotated at -45 degrees (diagonal)
- Logo should be centered on the page
- Logo should be behind all content (not blocking anything)

#### In Print Preview:
1. Click the Print button or press `Ctrl+P` (Windows) or `Cmd+P` (Mac)
2. In the print preview, the watermark should be:
   - Slightly more visible (8% opacity)
   - Larger (700px width)
   - Still rotated at -45 degrees
   - Centered on every page

### Step 3: Check All Page Types

#### Test these representative pages:

**Standalone Print Pages:**
- ✅ `print_all_outpatients.aspx` - Patient listings
- ✅ `print_sales_report.aspx` - Pharmacy sales
- ✅ `discharge_summary_print.aspx` - Discharge summaries

**Master Page Print Pages:**
- ✅ `lab_revenue_report.aspx` - Revenue reports
- ✅ `patient_report.aspx` - Patient reports
- ✅ `medication_report.aspx` - Medication reports

### Step 4: Verify Watermark Properties

Open browser developer tools (F12) and verify:

```css
.print-watermark {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-45deg);
    opacity: 0.05; /* Screen view */
    z-index: -1;
    pointer-events: none;
    display: block;
}
```

## Expected Results

### ✅ Correct Appearance:
- Logo is visible but very subtle
- Doesn't interfere with reading content
- Positioned diagonally across the page
- Same on all print pages

### ❌ Common Issues and Fixes:

#### Issue 1: Watermark not visible
**Fix:** Check if `Files/jubba logo.png` exists and is accessible

#### Issue 2: Watermark too dark/light
**Fix:** Adjust opacity in `Content/print-header.css`:
```css
.print-watermark {
    opacity: 0.05; /* Increase/decrease this value */
}
```

#### Issue 3: Watermark not in print preview
**Fix:** Check @media print section in CSS:
```css
@media print {
    .print-watermark {
        display: block !important;
        opacity: 0.08 !important;
    }
}
```

#### Issue 4: Watermark blocks content
**Fix:** Ensure z-index is -1:
```css
.print-watermark {
    z-index: -1;
}
```

## Quick Adjustment Guide

### Make Watermark More Visible:
1. Open `Content/print-header.css`
2. Find `.print-watermark { opacity: 0.05; }`
3. Change to `opacity: 0.08;` or higher
4. For print: Change `opacity: 0.08 !important;` to `0.12 !important;`

### Make Watermark Larger:
1. Open `Content/print-header.css`
2. Find `.print-watermark img { width: 600px; }`
3. Change to larger value (e.g., `800px`)
4. For print: Change `width: 700px;` to larger value

### Change Rotation Angle:
1. Open `Content/print-header.css`
2. Find `rotate(-45deg)`
3. Change to different angle (e.g., `-30deg` or `-60deg`)

## Browser-Specific Testing

### Chrome/Edge:
- Print Preview: Ctrl+P
- Watermark should render correctly
- Print-color-adjust is supported

### Firefox:
- Print Preview: Ctrl+P
- May need to enable "Print backgrounds" in print settings
- Watermark should render correctly

### Safari:
- Print Preview: Cmd+P
- Enable "Print backgrounds" if needed
- Watermark should render correctly

## Final Checklist

Before deploying to production:

- [ ] Watermark visible on screen view (subtle)
- [ ] Watermark visible in print preview (more visible)
- [ ] Watermark doesn't block content
- [ ] Watermark appears on all print pages
- [ ] Logo file (`Files/jubba logo.png`) is accessible
- [ ] CSS file (`Content/print-header.css`) is loaded
- [ ] Works in Chrome/Edge
- [ ] Works in Firefox
- [ ] Works in Safari (if applicable)
- [ ] Actual print test successful
- [ ] Opacity is appropriate for both screen and print
- [ ] Size is appropriate and professional

## Test Print Pages List

Quick links to test (use your application URL):

1. `/print_all_outpatients.aspx`
2. `/print_all_inpatients.aspx`
3. `/print_all_discharged.aspx`
4. `/patient_invoice_print.aspx`
5. `/discharge_summary_print.aspx`
6. `/lab_orders_print.aspx`
7. `/lab_result_print.aspx`
8. `/medication_print.aspx`
9. `/pharmacy_invoice.aspx`
10. `/print_sales_report.aspx`

## Success Criteria

The watermark implementation is successful when:

✅ Logo appears on ALL print pages
✅ Logo is subtle but visible
✅ Logo doesn't interfere with content
✅ Logo appears in print preview
✅ Logo appears on actual printed pages
✅ Works across all major browsers
✅ Professional appearance maintained

---

**Status:** Ready for Testing
**Total Pages with Watermark:** 28+
**Logo File:** Files/jubba logo.png
**CSS File:** Content/print-header.css
