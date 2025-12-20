# Medication and Lab Test Re-order System

## Overview
This document describes the complete system for adding new medications and re-ordering lab tests for inpatients, including tracking and visual indicators for lab staff.

---

## 1. Add New Medications (Doctor Inpatient Page)

### Feature Description
Doctors can now add new medications directly from the inpatient management page without leaving the patient details view.

### How to Use

1. **Navigate to Doctor Inpatient Page**
   - Login as a doctor
   - Go to "Inpatient Management"
   - Click "View Details" on any inpatient

2. **Access Medication Tab**
   - Click on the "Medications" tab in the patient details modal
   - You'll see all currently prescribed medications in a table format

3. **Add New Medication**
   - Click the green "Add New Medication" button at the top
   - A form will appear with the following fields:
     - **Medication Name*** (Required)
     - **Dosage** (e.g., 500mg)
     - **Frequency** (e.g., 3 times daily)
     - **Duration** (e.g., 7 days)
     - **Special Instructions** (e.g., Take after meals)

4. **Submit**
   - Click "Add Medication" to save
   - The medication list will automatically refresh
   - Success message will be displayed

### Technical Details

**Backend Method:** `AddMedication`
- **File:** `doctor_inpatient.aspx.cs`
- **Parameters:** prescid, medName, dosage, frequency, duration, specialInst
- **Database:** Inserts into `medication` table
- **Validation:** Medication name is required

**Frontend Function:** `showAddMedication()`, `addNewMedication()`
- **File:** `doctor_inpatient.aspx`
- **Uses:** SweetAlert2 for modal forms
- **AJAX:** Posts to backend method

---

## 2. Re-order Lab Tests (Doctor Inpatient Page)

### Feature Description
Doctors can re-order lab tests for patients who need repeat testing. The system tracks why tests are being re-ordered and marks them specially for lab staff.

### How to Use

1. **Navigate to Lab Results Tab**
   - Open patient details in doctor inpatient page
   - Click "Lab Results" tab

2. **Click Re-order Button**
   - Click the blue "Re-order Lab Tests" button at the top
   - A comprehensive form appears with organized test categories

3. **Select Tests**
   - Tests are organized by category:
     - **Hematology**: Hemoglobin, Malaria, ESR, CBC, etc.
     - **Immunology/Virology**: HIV, Hepatitis B/C, TPHA, etc.
     - **Lipid Profile**: LDL, HDL, Cholesterol, Triglycerides
     - **Liver Function**: SGPT, SGOT, ALP, Bilirubin, etc.
     - **Renal Profile**: Urea, Creatinine, Uric Acid
     - **Electrolytes**: Sodium, Potassium, Chloride, Calcium, etc.
   - Check the boxes for tests you want to re-order

4. **Provide Reason**
   - **Reason for Re-order*** field (Required)
   - Examples:
     - "Monitor treatment progress"
     - "Abnormal previous results"
     - "Follow-up after 1 week"
     - "Patient condition changed"

5. **Submit Re-order**
   - Click "Submit Re-order"
   - Tests are immediately sent to lab queue
   - Lab staff will see special indicators

### Visual Indicators

**In Doctor View (Lab Results Tab):**
- Re-ordered tests show with **orange/warning badge**
- Display "RE-ORDER" label in red
- Show the reason for re-ordering
- Display date/time of order

**Example Display:**
```
🔄 Hemoglobin [RE-ORDER]
Reason: Monitor treatment progress
2024-01-15 14:30
```

### Technical Details

**Backend Method:** `ReorderLabTests`
- **File:** `doctor_inpatient.aspx.cs`
- **Parameters:** prescid, patientId, tests (list), reason
- **Database:** Inserts into `lab_test` table with flags:
  - `is_reorder = 1`
  - `reorder_reason = [doctor's reason]`
  - `date_taken = GETDATE()`
- **Dynamic SQL:** Builds columns based on selected tests

**Frontend Function:** `showReorderLabTests()`, `reorderLabTests()`
- **File:** `doctor_inpatient.aspx`
- **Form:** Organized checkboxes by test category
- **Validation:** At least 1 test and reason required

**Database Schema:**
```sql
ALTER TABLE lab_test ADD is_reorder BIT DEFAULT 0;
ALTER TABLE lab_test ADD reorder_reason NVARCHAR(500) NULL;
ALTER TABLE lab_test ADD original_order_id INT NULL;
```

---

## 3. Lab Staff View - Re-order Indicators

### Feature Description
Lab staff can immediately identify which tests are re-orders and understand why they were requested again.

### Visual Features in Lab Waiting List

**Page:** `lab_waiting_list.aspx`

#### Re-order Column
New column shows:
- **Badge:** Orange "RE-ORDER" badge with pulsing animation
- **Reason:** Full text of why test was re-ordered
- **Date/Time:** When the re-order was placed
- **Row Highlighting:** Entire row has yellow/cream background with orange left border

#### Priority Sorting
- Re-orders appear **at the top** of the list
- Regular orders appear below
- Within each group, sorted by date

#### Example Display

| Name | Status | **Re-order Info** | Actions |
|------|--------|-------------------|---------|
| John Doe | pending-lap | 🔄 **RE-ORDER**<br>Monitor treatment progress<br>2024-01-15 14:30 | Ordered/Results/Both |
| Jane Smith | pending-lap | Regular Order | Ordered/Results/Both |

**Visual Styling:**
- Re-order rows: Light yellow background (#fff3cd)
- Orange left border (4px solid #ff9800)
- Pulsing orange badge for attention
- Clear reason text displayed

### Technical Implementation

**Backend Changes:**
- **File:** `lab_waiting_list.aspx.cs`
- **Query Enhancement:**
  ```sql
  SELECT TOP 1 is_reorder, reorder_reason, date_taken
  FROM lab_test
  WHERE prescid = prescribtion.prescid
  ORDER BY date_taken DESC
  ```
- **Sorting:** `ORDER BY is_reorder DESC` (reorders first)

**Frontend Changes:**
- **File:** `lab_waiting_list.aspx`
- **New Column:** "Re-order Info"
- **Row Class:** `reorder-row` added to re-order rows
- **Animation:** CSS pulse effect on badges

---

## 4. Complete Workflow Example

### Scenario: Patient needs follow-up blood sugar test

**Step 1: Doctor Reviews Patient**
1. Doctor opens inpatient details
2. Clicks "Lab Results" tab
3. Reviews previous test results

**Step 2: Doctor Re-orders Test**
1. Clicks "Re-order Lab Tests"
2. Selects "Blood Sugar" checkbox
3. Enters reason: "Follow-up after 3 days of insulin treatment"
4. Submits re-order

**Step 3: System Records Re-order**
- Database entry created in `lab_test` table
- Flags: `is_reorder = 1`
- Stores reason in `reorder_reason` column
- Records timestamp

**Step 4: Lab Staff Sees Re-order**
1. Lab staff opens "Lab Waiting List"
2. Patient appears at top of list (priority)
3. Row highlighted in yellow with orange border
4. Re-order badge shows: "🔄 RE-ORDER"
5. Reason displayed: "Follow-up after 3 days of insulin treatment"
6. Date/time shown: "2024-01-15 14:30"

**Step 5: Lab Staff Processes Test**
1. Lab tech sees it's a re-order and understands context
2. Clicks "Ordered" to see which specific tests
3. Performs test and enters results
4. Results appear back in doctor's view

**Step 6: Doctor Reviews Results**
1. Doctor checks lab results tab again
2. Sees both original and re-ordered test results
3. Compares values to monitor progress

---

## 5. Database Schema

### New Columns in `lab_test` Table

```sql
-- Track if this is a re-order
is_reorder BIT DEFAULT 0

-- Reason for re-ordering
reorder_reason NVARCHAR(500) NULL

-- Link to original order (future use)
original_order_id INT NULL
```

### Migration Script
Run: `ADD_LAB_REORDER_TRACKING.sql`

This script:
- Adds columns if they don't exist
- Creates performance indexes
- Safe to run multiple times (checks existence first)

---

## 6. Key Benefits

### For Doctors
1. **Efficient Workflow:** Add medications without leaving patient view
2. **Quick Re-ordering:** Select and re-order tests in seconds
3. **Context Documentation:** Reason for re-order saved permanently
4. **Better Tracking:** See history of all orders and re-orders

### For Lab Staff
1. **Clear Priority:** Re-orders appear first
2. **Context Awareness:** Know why test is being repeated
3. **Visual Alerts:** Can't miss re-orders with yellow highlighting
4. **Better Communication:** Understand doctor's intent without asking

### For System
1. **Complete Audit Trail:** All re-orders tracked with reasons
2. **Quality Control:** Can analyze re-order patterns
3. **Better Reporting:** Separate regular vs re-order statistics
4. **Improved Communication:** Eliminates confusion about repeat tests

---

## 7. Security & Validation

### Medication Addition
- ✅ Only doctors can add medications (role check)
- ✅ Medication name is required
- ✅ Valid prescid required (linked to patient)
- ✅ Date automatically recorded

### Lab Re-ordering
- ✅ Only doctors can re-order (role check)
- ✅ At least 1 test must be selected
- ✅ Reason is mandatory
- ✅ Valid prescid and patientid required
- ✅ Timestamp automatically recorded

---

## 8. Future Enhancements

### Potential Additions
1. **Medication History:** View all medication changes over time
2. **Auto-suggest Medications:** Based on diagnosis
3. **Re-order Limits:** Alert if test re-ordered too frequently
4. **Cost Tracking:** Show costs of re-ordered tests
5. **Notification System:** Alert lab staff immediately on re-orders
6. **Comparison View:** Side-by-side comparison of original vs re-ordered results
7. **Statistical Reports:** Re-order rates by doctor/department

---

## 9. Troubleshooting

### Issue: "Add Medication" button doesn't work
- **Check:** jQuery and SweetAlert2 loaded correctly
- **Check:** Doctor is logged in with correct role_id
- **Check:** Patient has valid prescid

### Issue: Re-order reason not showing in lab
- **Check:** Database migration script was run
- **Check:** Columns `is_reorder` and `reorder_reason` exist
- **Check:** Data was saved with `is_reorder = 1`

### Issue: Re-order rows not highlighted
- **Check:** CSS styles loaded
- **Check:** JavaScript adding `reorder-row` class
- **Check:** Browser cache cleared

---

## 10. Testing Checklist

### Medication Addition
- [ ] Form appears when clicking "Add New Medication"
- [ ] Required field validation works
- [ ] Medication saves to database
- [ ] Table refreshes automatically
- [ ] Success message appears
- [ ] Empty fields handled gracefully

### Lab Re-ordering
- [ ] Form appears with all test categories
- [ ] Checkboxes work correctly
- [ ] Reason field validation works
- [ ] Re-order saves to database with flags
- [ ] Success message appears
- [ ] Lab results tab refreshes

### Lab Staff View
- [ ] Re-order column appears
- [ ] Badge shows for re-ordered tests
- [ ] Reason text displays correctly
- [ ] Rows highlighted in yellow
- [ ] Re-orders appear at top of list
- [ ] Regular orders appear below
- [ ] Animation works on badges

---

## Files Modified

### Backend
- `doctor_inpatient.aspx.cs` - Added AddMedication and ReorderLabTests methods
- `lab_waiting_list.aspx.cs` - Updated query to fetch reorder info

### Frontend
- `doctor_inpatient.aspx` - Added buttons and forms for medication/reorder
- `lab_waiting_list.aspx` - Added reorder column and styling

### Database
- `ADD_LAB_REORDER_TRACKING.sql` - Migration script for new columns

### Documentation
- `DOCTOR_INPATIENT_IMPROVEMENTS.md` - Initial improvements
- `MEDICATION_AND_LAB_REORDER_SYSTEM.md` - This comprehensive guide

---

## Support & Questions

For questions or issues:
1. Check this documentation first
2. Review the code comments in modified files
3. Test in development environment before production
4. Ensure all database migrations are applied
5. Clear browser cache after updates

---

**Last Updated:** January 2024
**Version:** 1.0
