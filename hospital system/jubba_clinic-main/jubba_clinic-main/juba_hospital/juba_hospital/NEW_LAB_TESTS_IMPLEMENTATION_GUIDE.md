# Implementation Guide: Adding 5 New Lab Tests

## New Tests to Add
1. **Electrolyte** - $5
2. **CRP Titer** - $10
3. **Ultra** - $13
4. **Typhoid IgG** - $3
5. **Typhoid Ag** - $5

---

## Step 1: Run Database Script ✅ READY

**File:** `ADD_NEW_LAB_TESTS.sql`

Run this script in SQL Server Management Studio to:
- Add columns to `lab_test` table
- Add columns to `lab_results` table
- Create/Update `lab_test_prices` table with new prices

---

## Step 2: Update doctor_inpatient.aspx

### A. Order Lab Tests Modal (lines ~1437-1504)

**After line 1437 (CRP test):** Add CRP Titer
```html
<div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-CRP_Titer" value="CRP_Titer"><label class="form-check-label" for="lab-CRP_Titer">CRP Titer</label></div>
```

**After line 1441 (Typhoid_hCG):** Add Typhoid IgG and Typhoid Ag
```html
<div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Typhoid_IgG" value="Typhoid_IgG"><label class="form-check-label" for="lab-Typhoid_IgG">Typhoid IgG</label></div>
<div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Typhoid_Ag" value="Typhoid_Ag"><label class="form-check-label" for="lab-Typhoid_Ag">Typhoid Ag</label></div>
```

**After line 1470 (General_stool_examination):** Add Ultra
```html
<div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Ultra" value="Ultra"><label class="form-check-label" for="lab-Ultra">Ultra</label></div>
```

**After line 1504 (Ferritin):** Add Electrolyte
```html
<div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Electrolyte" value="Electrolyte"><label class="form-check-label" for="lab-Electrolyte">Electrolyte</label></div>
```

### B. Edit Lab Order Modal (lines ~1586-1668)

**After line 1586 (CRP test in edit modal):** Add CRP Titer
```html
<div class="form-check"><input class="form-check-input" type="checkbox" id="lab-CRP_Titer" value="CRP_Titer"><label class="form-check-label" for="lab-CRP_Titer">CRP Titer</label></div>
```

**After line 1590 (Typhoid_hCG in edit modal):** Add Typhoid IgG and Typhoid Ag
```html
<div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Typhoid_IgG" value="Typhoid_IgG"><label class="form-check-label" for="lab-Typhoid_IgG">Typhoid IgG</label></div>
<div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Typhoid_Ag" value="Typhoid_Ag"><label class="form-check-label" for="lab-Typhoid_Ag">Typhoid Ag</label></div>
```

**After line 1634 (General_stool_examination in edit modal):** Add Ultra
```html
<div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Ultra" value="Ultra"><label class="form-check-label" for="lab-Ultra">Ultra</label></div>
```

**After line 1668 (Ferritin in edit modal):** Add Electrolyte
```html
<div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Electrolyte" value="Electrolyte"><label class="form-check-label" for="lab-Electrolyte">Electrolyte</label></div>
```

---

## Step 3: Update lap_operation.aspx

Find appropriate sections and add checkboxes with format:
```html
<div class="form-check">
    <input class="form-check-input" type="checkbox" id="flexCheckElectrolyte" name="Electrolyte">
    <label class="form-check-label" for="flexCheckElectrolyte">Electrolyte</label>
</div>
```

Repeat for all 5 new tests in appropriate categories.

---

## Step 4: Update lap_operation.aspx.cs

### Find the INSERT INTO lab_test statement (around lines 410-450)

**Add to column list:**
```csharp
Electrolyte, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
```

**Add to VALUES list:**
```csharp
@Electrolyte, @CRP_Titer, @Ultra, @Typhoid_IgG, @Typhoid_Ag
```

**Add parameters (around lines 480-650):**
```csharp
cmd.Parameters.AddWithValue("@Electrolyte", Request.Form["Electrolyte"] ?? "not checked");
cmd.Parameters.AddWithValue("@CRP_Titer", Request.Form["CRP_Titer"] ?? "not checked");
cmd.Parameters.AddWithValue("@Ultra", Request.Form["Ultra"] ?? "not checked");
cmd.Parameters.AddWithValue("@Typhoid_IgG", Request.Form["Typhoid_IgG"] ?? "not checked");
cmd.Parameters.AddWithValue("@Typhoid_Ag", Request.Form["Typhoid_Ag"] ?? "not checked");
```

---

## Step 5: Update LabTestPriceCalculator.cs

### Find GetTestPrice method

**Add cases:**
```csharp
case "Electrolyte":
    return 5.00m;
case "CRP_Titer":
    return 10.00m;
case "Ultra":
    return 13.00m;
case "Typhoid_IgG":
    return 3.00m;
case "Typhoid_Ag":
    return 5.00m;
```

---

## Step 6: Testing Checklist

### Database:
- [ ] Run ADD_NEW_LAB_TESTS.sql successfully
- [ ] Verify columns added to lab_test table
- [ ] Verify columns added to lab_results table
- [ ] Verify prices added to lab_test_prices table

### UI - doctor_inpatient.aspx:
- [ ] Order Lab Tests modal shows all 5 new tests
- [ ] Edit Lab Order modal shows all 5 new tests
- [ ] Can select and order new tests
- [ ] Charges are created with correct prices

### UI - lap_operation.aspx:
- [ ] All 5 new tests appear as checkboxes
- [ ] Can select and submit new tests
- [ ] Orders are saved to database correctly

### Results Entry:
- [ ] lab_waiting_list.aspx shows new tests when entering results
- [ ] Can enter results for new tests
- [ ] Results are saved to lab_results table

### Reports & Display:
- [ ] New test results appear in discharge summary
- [ ] New test results appear in lab history
- [ ] Charges appear correctly in revenue reports

---

## Quick Reference: Test Names & Prices

| Test Name (Database) | Display Name | Price |
|---------------------|--------------|-------|
| Electrolyte | Electrolyte | $5.00 |
| CRP_Titer | CRP Titer | $10.00 |
| Ultra | Ultra | $13.00 |
| Typhoid_IgG | Typhoid IgG | $3.00 |
| Typhoid_Ag | Typhoid Ag | $5.00 |

---

## Files to Update

1. ✅ **ADD_NEW_LAB_TESTS.sql** - Database schema (READY)
2. ⏳ **doctor_inpatient.aspx** - 2 modals (10 checkboxes total)
3. ⏳ **lap_operation.aspx** - Add 5 checkboxes
4. ⏳ **lap_operation.aspx.cs** - INSERT statement + parameters
5. ⏳ **LabTestPriceCalculator.cs** - Add 5 price cases

---

## Notes

- All test names use underscore format in database (e.g., `CRP_Titer`)
- Display names can use spaces (e.g., "CRP Titer")
- The dynamic approach in doctor_inpatient will automatically work once checkboxes are added
- lap_operation requires manual INSERT statement updates due to static approach

---

**Would you like me to proceed with updating these files automatically?**
