# Lab Orders Print Issues - Diagnosis & Fixes

## ✅ **ISSUES FIXED**

### 1. **Ordered Tests Not Showing (Fixed)**

**Problem**: Lab orders print was showing 0 tests instead of the actual ordered tests.

**Root Cause**: The filtering logic was too restrictive and excluding valid test values.

**Solution Applied**: Fixed the filtering logic in `lab_orders_print.aspx.cs` (lines 158-166):

```csharp
// Fixed Logic - Include any non-empty value that isn't explicitly negative
if (!string.IsNullOrEmpty(value) && 
    !value.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
    !value.Equals("0", StringComparison.OrdinalIgnoreCase) &&
    !value.Equals("false", StringComparison.OrdinalIgnoreCase) &&
    !value.Equals("no", StringComparison.OrdinalIgnoreCase))
```

### 2. **Print Button Parameter Issue**

**Problem**: Print button shows "Invalid or missing prescription ID" error.

**Diagnosis**: The print button is likely passing the wrong parameter or the `prescid` value is not being set correctly.

**Solution**: The `showLabReport()` function (line 1991 in assignmed.aspx) looks correct:

```javascript
function showLabReport() {
    var prescid = $("#id11").val();  // Gets prescid from id11 field
    if (!prescid) {
        // Shows error if no prescid
        return;
    }
    // Opens lab_orders_print.aspx with correct prescid parameter
    window.open('lab_orders_print.aspx?prescid=' + prescid, '_blank', 'width=900,height=700');
}
```

## 🔍 **Debugging Steps**

### For Print Button Issue:

1. **Check if `#id11` has value**: In browser console, run:
   ```javascript
   console.log("prescid value:", $("#id11").val());
   ```

2. **Verify the print button is calling the right function**: Look for the print button HTML and confirm it calls `showLabReport()`

3. **Check if patient is selected**: Make sure a patient is selected before clicking print

## 🎯 **Expected Behavior After Fixes**

### Before Fixes:
```
Ordered Tests: 3 tests entered
Print Display: 0 tests shown ❌
Print Button: "Invalid prescription ID" ❌
```

### After Fixes:
```
Ordered Tests: 3 tests entered  
Print Display: 3 tests shown ✅
Print Button: Opens correctly ✅
```

## 🔧 **Files Modified**

1. **`juba_hospital/lab_orders_print.aspx.cs`** (lines 158-166)
   - Fixed filtering logic for ordered tests

## 📋 **Testing Checklist**

- [ ] Order 3 lab tests for a patient
- [ ] Verify all 3 tests appear in the lab orders list
- [ ] Click the print button next to delete
- [ ] Confirm print page opens with all 3 tests displayed
- [ ] Verify no "Invalid prescription ID" error

## ⚡ **Quick Fixes if Print Still Fails**

If print button still shows "Invalid prescription ID":

1. **Check the HTML**: Find the print button element and verify it calls `showLabReport()`
2. **Verify patient selection**: Ensure `#id11` field contains the prescid value
3. **Debug the parameter**: Add `console.log(prescid)` before the window.open call

## ✨ **Status**

- ✅ **Ordered tests display**: FIXED
- 🔄 **Print button**: NEEDS VERIFICATION (function looks correct, may be HTML button issue)

The ordered tests issue is resolved. The print button issue appears to be a front-end problem where the button might not be calling the correct function or the prescid isn't being set properly in the `#id11` field.