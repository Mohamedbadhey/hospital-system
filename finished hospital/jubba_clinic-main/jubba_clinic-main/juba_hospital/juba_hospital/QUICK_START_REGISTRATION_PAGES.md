# 🚀 Quick Start Guide - Registration Patient Pages

## ✅ What's New

Three new pages have been added to the **Registration** role:

1. **Inpatients List** - View all active inpatients
2. **Outpatients List** - View all active outpatients  
3. **Discharged Patients** - View all discharged patient records

---

## 🔐 How to Access

1. **Login** to the system as a **Registration** user
2. Look at the left sidebar menu
3. Click on **"Patient"** to expand the menu
4. You'll see three NEW options:
   - 🏥 **Inpatients List**
   - 🚶 **Outpatients List**
   - ✅ **Discharged Patients**

---

## 📋 What Each Page Does

### 🏥 Inpatients List
**Shows:** All patients currently admitted to the hospital

**Information Displayed:**
- Patient name, ID, contact info
- Days admitted
- Total charges (paid/unpaid breakdown)
- All medications, lab tests, X-rays
- Bed charges

**Actions You Can Do:**
- 🔍 Search patients
- 💰 Filter by payment status
- 👁️ View complete details
- 🖨️ Print summary
- 📄 Print invoice
- 📋 Print discharge summary
- 📑 Print all inpatients

---

### 🚶 Outpatients List
**Shows:** All patients registered for outpatient care

**Information Displayed:**
- Patient name, ID, contact info
- Registration date
- Total charges (paid/unpaid breakdown)
- All medications, lab tests, X-rays

**Actions You Can Do:**
- 🔍 Search patients
- 💰 Filter by payment status
- 📅 Filter by date
- 👁️ View complete details
- 🖨️ Print summary
- 📄 Print invoice
- 📑 Print all outpatients

---

### ✅ Discharged Patients
**Shows:** All patients who have been discharged (historical records)

**Information Displayed:**
- Patient type (inpatient/outpatient)
- Registration and discharge dates
- Total charges (paid/unpaid breakdown)
- Complete medical history
- All medications, lab tests, X-rays

**Actions You Can Do:**
- 🔍 Search patients
- 🏥 Filter by patient type (inpatient/outpatient)
- 💰 Filter by payment status
- 📅 Filter by date range
- 👁️ View complete details
- 🖨️ Print all available documents
- 📑 Print all discharged patients

---

## 🎯 Common Use Cases

### 1. Find a Specific Patient
1. Go to the appropriate page (Inpatients/Outpatients/Discharged)
2. Type patient name, phone, or ID in the **search box**
3. Results filter instantly

### 2. Check Unpaid Charges
1. Go to any of the three pages
2. Select **"Has Unpaid"** in the payment filter dropdown
3. See only patients with unpaid charges
4. Click **"View Details"** to see charge breakdown

### 3. Print Patient Invoice
1. Find the patient
2. Click **"Print Invoice"** button
3. Invoice opens in new window
4. Print or save as PDF

### 4. Review Patient Medical History
1. Find the patient
2. Click **"View Details"** button
3. Scroll through sections:
   - 💰 Charges Breakdown
   - 💊 Medications
   - 🔬 Lab Tests
   - 🩻 X-rays
4. Click print buttons for specific items

### 5. Print All Patients on a Page
1. Apply any filters you want
2. Click **"Print All"** button at top
3. All visible patient cards will print

---

## 📊 Understanding the Display

### Patient Card Colors
- 🔵 **Blue Badge** = Patient ID
- 🟢 **Green Badge** = Inpatient / Paid / Completed
- 🔴 **Red Text** = Unpaid amount
- 🟢 **Green Text** = Paid amount
- ⚪ **Gray Badge** = Discharged

### Test Status Badges
**Lab Tests:**
- ⚪ Not Ordered
- 🟡 Pending
- 🔵 In Progress
- 🟢 Completed

**X-rays:**
- ⚪ Not Ordered
- 🟡 Pending
- 🟢 Completed

---

## 💡 Pro Tips

1. **Use Multiple Filters:** Combine search + payment filter + date filter for precise results
2. **Bookmark Pages:** Add frequently used pages to your browser favorites
3. **Print Smart:** Use individual print buttons for specific documents, or "Print All" for batch printing
4. **Check Daily:** Review inpatients list each morning for new admissions
5. **Monitor Payments:** Use payment filters to follow up on unpaid charges

---

## 🖨️ Print Options Explained

### For Each Patient:

**Print Summary** (📄)
- Opens: `visit_summary_print.aspx`
- Contains: Patient info, visit details, medications, tests

**Print Invoice** (📄)
- Opens: `patient_invoice_print.aspx`
- Contains: Itemized charges, payment status, total amount

**Print Discharge Summary** (📋) - *Inpatients only*
- Opens: `discharge_summary_print.aspx`
- Contains: Admission summary, treatment, discharge instructions

**Print Lab Results** (🔬)
- Opens: `lab_result_print.aspx`
- Contains: Complete lab test results with values

### Batch Printing:

**Print All** (📑)
- Uses: Browser's print function
- Prints: All patient cards currently visible on the page
- Tip: Apply filters first to print only what you need

---

## ❓ Quick FAQ

**Q: Why don't I see any patients?**
A: Check if there are patients in the database with the correct status (active/discharged).

**Q: Can I edit patient information from these pages?**
A: No, these are view-only pages. Use "Add Patients" or "Patient Details" to edit.

**Q: How do I mark charges as paid?**
A: Use the "Patient Payment Status" page to process payments.

**Q: Can I see discharged inpatients and outpatients together?**
A: Yes! The "Discharged Patients" page shows both types. Use the filter to separate them.

**Q: Why doesn't "View Details" show anything?**
A: Make sure the patient has prescriptions, charges, or tests ordered. New patients may have no data yet.

**Q: Can I export data to Excel?**
A: Use "Print All" and then save as PDF, or use the browser's print to PDF option.

---

## 🔄 Page Refresh

If data seems outdated:
1. Click the **refresh button** in your browser (F5)
2. Or re-navigate to the page from the menu

Data loads fresh from the database each time!

---

## 📱 Mobile Access

All three pages work on mobile devices:
- Responsive card layout
- Touch-friendly buttons
- Scrollable tables
- Mobile print options

---

## ✅ You're All Set!

These pages give you complete visibility into:
- ✅ Who is currently in the hospital (inpatients)
- ✅ Who visited today/recently (outpatients)
- ✅ Historical patient records (discharged)
- ✅ Payment status for all patients
- ✅ Complete medical history and charges

**Navigate to the Patient menu and start exploring!** 🎉

---

*Questions? Check the full documentation in `REGISTRATION_PAGES_COMPLETE.md`*
