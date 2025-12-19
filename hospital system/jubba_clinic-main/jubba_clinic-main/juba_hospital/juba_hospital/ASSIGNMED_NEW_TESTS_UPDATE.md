# assignmed.aspx - New Lab Tests Update

## Overview
Successfully added 14 new laboratory tests to the `assignmed.aspx` page (doctor's patient management page with lab ordering functionality).

## Files Modified

### `assignmed.aspx`

#### 1. HTML Form - Lab Test Checkboxes
**Location:** Modal `#staticBackdrop11` (after line 1827)

**Added 14 new checkboxes:**
```html
<!-- New Cardiac Markers -->
<input id="flexCheckTroponinI" /> Troponin I (Cardiac marker)
<input id="flexCheckCKMB" /> CK-MB (Creatine Kinase-MB)

<!-- New Coagulation Tests -->
<input id="flexCheckAPTT" /> aPTT (Activated Partial Thromboplastin Time)
<input id="flexCheckINR" /> INR (International Normalized Ratio)
<input id="flexCheckDDimer" /> D-Dimer

<!-- New Vitamins and Minerals -->
<input id="flexCheckVitaminD" /> Vitamin D
<input id="flexCheckVitaminB12" /> Vitamin B12
<input id="flexCheckFerritin" /> Ferritin (Iron storage)

<!-- New Infectious Disease Tests -->
<input id="flexCheckVDRL" /> VDRL (Syphilis test)
<input id="flexCheckDengueFever" /> Dengue Fever (IgG/IgM)
<input id="flexCheckGonorrheaAg" /> Gonorrhea Ag

<!-- New Tumor Markers -->
<input id="flexCheckAFP" /> AFP (Alpha-fetoprotein)
<input id="flexCheckTotalPSA" /> Total PSA (Prostate-Specific Antigen)

<!-- New Fertility Test -->
<input id="flexCheckAMH" /> AMH (Anti-Müllerian Hormone)
```

#### 2. JavaScript - Submit Lab Test Function
**Location:** `submitLabTest()` function (around line 5279)

**Added to data object before closing brace:**
```javascript
flexCheckTroponinI: getCheckVal('flexCheckTroponinI'),
flexCheckCKMB: getCheckVal('flexCheckCKMB'),
flexCheckAPTT: getCheckVal('flexCheckAPTT'),
flexCheckINR: getCheckVal('flexCheckINR'),
flexCheckDDimer: getCheckVal('flexCheckDDimer'),
flexCheckVitaminD: getCheckVal('flexCheckVitaminD'),
flexCheckVitaminB12: getCheckVal('flexCheckVitaminB12'),
flexCheckFerritin: getCheckVal('flexCheckFerritin'),
flexCheckVDRL: getCheckVal('flexCheckVDRL'),
flexCheckDengueFever: getCheckVal('flexCheckDengueFever'),
flexCheckGonorrheaAg: getCheckVal('flexCheckGonorrheaAg'),
flexCheckAFP: getCheckVal('flexCheckAFP'),
flexCheckTotalPSA: getCheckVal('flexCheckTotalPSA'),
flexCheckAMH: getCheckVal('flexCheckAMH')
```

#### 3. JavaScript - Edit Lab Test AJAX Call
**Location:** AJAX call to `lap_operation.aspx/updateLabTest` (around line 5200)

**Added to data string:**
```javascript
'flexCheckTroponinI':'" + flexCheckTroponinI + "',
'flexCheckCKMB':'" + flexCheckCKMB + "',
'flexCheckAPTT':'" + flexCheckAPTT + "',
'flexCheckINR':'" + flexCheckINR + "',
'flexCheckDDimer':'" + flexCheckDDimer + "',
'flexCheckVitaminD':'" + flexCheckVitaminD + "',
'flexCheckVitaminB12':'" + flexCheckVitaminB12 + "',
'flexCheckFerritin':'" + flexCheckFerritin + "',
'flexCheckVDRL':'" + flexCheckVDRL + "',
'flexCheckDengueFever':'" + flexCheckDengueFever + "',
'flexCheckGonorrheaAg':'" + flexCheckGonorrheaAg + "',
'flexCheckAFP':'" + flexCheckAFP + "',
'flexCheckTotalPSA':'" + flexCheckTotalPSA + "',
'flexCheckAMH':'" + flexCheckAMH + "'
```

#### 4. JavaScript - Column Name to Element ID Mapping
**Location:** `getElementIdFromColumnName()` function (around line 5088)

**Added case statements:**
```javascript
case "Troponin_I": return "flexCheckTroponinI";
case "CK_MB": return "flexCheckCKMB";
case "aPTT": return "flexCheckAPTT";
case "INR": return "flexCheckINR";
case "D_Dimer": return "flexCheckDDimer";
case "Vitamin_D": return "flexCheckVitaminD";
case "Vitamin_B12": return "flexCheckVitaminB12";
case "Ferritin": return "flexCheckFerritin";
case "VDRL": return "flexCheckVDRL";
case "Dengue_Fever_IgG_IgM": return "flexCheckDengueFever";
case "Gonorrhea_Ag": return "flexCheckGonorrheaAg";
case "AFP": return "flexCheckAFP";
case "Total_PSA": return "flexCheckTotalPSA";
case "AMH": return "flexCheckAMH";
```

## How assignmed.aspx Works

### Page Purpose
`assignmed.aspx` is the doctor's patient management page that displays a list of patients and allows the doctor to:
1. View patient details
2. Order medications
3. Order lab tests
4. Order X-rays
5. View patient history

### Lab Test Ordering Workflow

1. **Doctor clicks "Send to Lab" button** (line 1025)
   - Calls `showlab()` function
   - Opens modal `#staticBackdrop11` with lab test checkboxes

2. **Doctor selects tests**
   - Checks boxes for required tests (including the 14 new ones)
   - Can view which tests were previously ordered

3. **Doctor saves order**
   - Calls `submitLabTest()` function
   - Collects all checkbox values using `getCheckVal()`
   - Sends data to `lap_operation.aspx/submitdata` via AJAX

4. **Backend processes order**
   - `lap_operation.aspx.cs` receives all test parameters
   - Inserts into `lab_test` table
   - Creates charge in `patient_charges` table
   - Updates prescription status

### Edit Lab Test Workflow

1. **Doctor clicks "Edit" on existing lab order**
   - Loads current test selections from database
   - Populates checkboxes using `getElementIdFromColumnName()` mapping
   - New tests will show if they were previously ordered

2. **Doctor modifies selections**
   - Changes which tests are checked
   - Can add the 14 new tests to existing order

3. **Doctor saves changes**
   - Sends updated data to `lap_operation.aspx/updateLabTest` via AJAX
   - Backend updates `lab_test` table record

## Key Functions

### `showlab()`
- Opens the lab test modal
- Loads patient information
- Prepares form for new lab order

### `submitLabTest()`
- Collects all checkbox values
- Creates data object with all test parameters
- Sends AJAX request to create new lab order

### `getCheckVal(elementId)`
- Helper function to get checkbox state
- Returns label text if checked, "not checked" if unchecked
- Used by `submitLabTest()` to collect data

### `getElementIdFromColumnName(columnName)`
- Maps database column names to HTML element IDs
- Used when editing existing orders to populate checkboxes
- Critical for dynamic test display

## Integration with Other Pages

### Relationship to lap_operation.aspx
- `assignmed.aspx` sends data to `lap_operation.aspx` backend methods
- Uses same method signatures: `submitdata()` and `updateLabTest()`
- Shares same element ID naming convention
- Both pages updated to support 14 new tests

### Backend Processing
- `lap_operation.aspx.cs` handles both pages' lab orders
- Single source of truth for lab test database operations
- `submitdata()` - Creates new orders
- `updateLabTest()` - Modifies existing orders

## Testing Checklist

### New Lab Order Testing
- [ ] Log in as doctor
- [ ] Navigate to `assignmed.aspx`
- [ ] Select a patient
- [ ] Click "Send to Lab"
- [ ] Verify modal opens with all 14 new tests visible
- [ ] Check several new tests (e.g., Troponin I, Vitamin D, AFP)
- [ ] Submit the order
- [ ] Verify success message
- [ ] Check database: `lab_test` table has new record with new tests marked

### Edit Lab Order Testing
- [ ] Create a lab order with some new tests
- [ ] Click "Edit" on the lab order
- [ ] Verify previously checked new tests are selected
- [ ] Change selections (check/uncheck new tests)
- [ ] Save changes
- [ ] Verify database updated correctly

### Dynamic Display Testing
- [ ] Order tests including new ones
- [ ] Navigate to lab waiting list
- [ ] Click "View Ordered Tests"
- [ ] Verify new tests display when ordered
- [ ] Verify they don't show when not ordered

## Compatibility Notes

### Element ID Convention
- No "1" suffix (unlike `test_details.aspx`)
- Matches `lap_operation.aspx` convention
- Example: `flexCheckTroponinI` (not `flexCheckTroponinI1`)

### Database Column Names
- Exact match with database columns
- Underscores separate words: `Troponin_I`, `Vitamin_D`
- Case-sensitive matching in JavaScript

### AJAX Data Format
- String concatenation format (legacy style)
- Must match backend parameter names exactly
- Order doesn't matter but all parameters must be present

## Common Issues and Solutions

### Issue: New tests not showing in modal
**Solution:** Clear browser cache and reload page

### Issue: "Parameter not found" error
**Solution:** Verify parameter names in AJAX match backend method signature

### Issue: Tests show as "not checked" when should be checked
**Solution:** Check `getElementIdFromColumnName()` mapping for typos

### Issue: Edit doesn't load new test selections
**Solution:** Verify case statement added to `getElementIdFromColumnName()`

## Summary

✅ **HTML:** Added 14 new test checkboxes to modal  
✅ **JavaScript (Submit):** Added 14 parameters to data object  
✅ **JavaScript (Edit):** Added 14 parameters to AJAX data string  
✅ **JavaScript (Mapping):** Added 14 case statements for dynamic display  

**Status:** Complete and Ready for Testing  
**Backend:** Already updated in lap_operation.aspx.cs (previous changes)  
**Database:** Columns already exist (confirmed in SQL script)

---

**Updated:** December 2024  
**Page:** assignmed.aspx (Doctor Patient Management)  
**Backend:** lap_operation.aspx.cs (shared with lap_operation.aspx)
