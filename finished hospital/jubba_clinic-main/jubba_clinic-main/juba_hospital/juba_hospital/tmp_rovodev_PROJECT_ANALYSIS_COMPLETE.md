# Juba Hospital Management System - Complete Analysis

## ✅ CONFIRMED: Database Information
**Your Database Name:** `juba_clinick1`  
**Current Web.config Connection:** Uses `juba_clinick` (needs update to `juba_clinick1`)

---

## 🏥 PROJECT OVERVIEW

### What This System Does
This is a **comprehensive Hospital Management System** built with **ASP.NET Web Forms** (.NET Framework 4.7.2) and **SQL Server**. It manages the complete hospital workflow from patient registration through treatment, lab tests, X-rays, pharmacy sales, and billing.

### Technology Stack
- **Backend:** ASP.NET Web Forms (C#), .NET Framework 4.7.2
- **Database:** SQL Server (currently configured for `juba_clinick`, needs to point to `juba_clinick1`)
- **Frontend:** Bootstrap 3.4.1, jQuery 3.4.1, DataTables, SweetAlert2
- **Reporting:** Server-side PDF generation, print-friendly pages

---

## 👥 USER ROLES & ACCESS

The system has **6 distinct user roles** with separate login paths:

### 1. **Admin** (Role ID: 4)
- **Login Table:** `admin` 
- **Dashboard:** `admin_dashbourd.aspx`
- **Capabilities:**
  - System-wide oversight and configuration
  - User management (add doctors, lab users, X-ray users, pharmacy users, registration staff)
  - Financial reports and revenue tracking
  - Patient management (including inpatient admissions)
  - Hospital settings configuration
  - Charge management

### 2. **Doctor** (Role ID: 1)
- **Login Table:** `doctor`
- **Dashboard:** `assignmed.aspx`
- **Capabilities:**
  - View waiting patients
  - Prescribe medications
  - Order lab tests and X-rays
  - Manage inpatient care
  - View patient history
  - Patient consultation and diagnosis

### 3. **Registration/Reception** (Role ID: 3)
- **Login Table:** `registre`
- **Dashboard:** `Add_patients.aspx`
- **Capabilities:**
  - Register new patients (outpatient/inpatient)
  - Collect registration fees
  - Schedule patient-doctor assignments
  - Patient intake and documentation

### 4. **Lab Technician** (Role ID: 2)
- **Login Table:** `lab_user`
- **Dashboard:** `lab_waiting_list.aspx`
- **Capabilities:**
  - View lab test orders
  - Perform and record lab tests
  - Generate lab results
  - Print lab reports
  - Manage lab test charges

### 5. **X-ray Technician** (Role ID: 5)
- **Login Table:** `xrayuser`
- **Dashboard:** `take_xray.aspx`
- **Capabilities:**
  - View X-ray orders
  - Capture and upload X-ray images
  - Record X-ray results
  - Manage X-ray charges

### 6. **Pharmacy Staff** (Role ID: 6)
- **Login Table:** `pharmacy_user`
- **Dashboard:** `pharmacy_dashboard.aspx`
- **Capabilities:**
  - Point of Sale (POS) system
  - Dispense medications
  - Manage medicine inventory
  - Track medicine units and pricing
  - Generate pharmacy sales reports
  - Monitor low stock and expired medicines

---

## 🔄 PATIENT WORKFLOW

### Outpatient Flow
```
1. Registration (registre) 
   ↓ Creates patient record + Registration charge
2. Doctor Consultation (doctor)
   ↓ Creates prescription + Orders tests
3. Lab Tests (lab_user) [if ordered]
   ↓ Performs tests + Records results + Lab charges
4. X-ray (xrayuser) [if ordered]
   ↓ Takes images + Records results + X-ray charges
5. Pharmacy (pharmacy_user) [if medications prescribed]
   ↓ Dispenses medication
6. Billing/Checkout
   ↓ All charges consolidated in patient_charges table
```

### Inpatient Flow
```
1. Registration as Inpatient (registre/admin)
   ↓ patient_type = 'inpatient' + bed_admission_date
2. Doctor Management (doctor)
   ↓ Ongoing care, medications, orders
3. Daily Bed Charges (automatic)
   ↓ Stored in patient_bed_charges table
4. Delivery Charges [if applicable]
   ↓ For maternity patients
5. Lab/X-ray Services (as needed)
6. Discharge
   ↓ patient_status changes
   ↓ Final billing with all accumulated charges
```

---

## 📊 DATABASE SCHEMA (Key Tables)

### Core Patient Tables
1. **`patient`** - Patient demographics and registration
   - `patientid` (PK), `full_name`, `dob`, `sex`, `location`, `phone`
   - `patient_type` ('outpatient' or 'inpatient')
   - `patient_status` (0=active, 1=discharged)
   - `bed_admission_date`, `delivery_charge`

2. **`prescribtion`** (prescription) - Doctor orders/prescriptions
   - `prescid` (PK), `doctorid`, `patientid`
   - `status` (lab test status), `xray_status`
   - `lab_charge_paid`, `xray_charge_paid`

3. **`medication`** - Prescribed medications
   - `medid` (PK), `med_name`, `dosage`, `frequency`, `duration`
   - `special_inst`, `prescid` (FK), `date_taken`

### Lab & X-ray Tables
4. **`lab_test`** - Lab test orders (linked to prescription)
   - Contains 40+ lab test fields (checkboxes for ordered tests)
   - Examples: `Hemoglobin`, `Blood_sugar`, `CBC`, `Malaria`, `HIV`, etc.

5. **`lab_results`** - Actual lab test results
   - Same structure as `lab_test` but stores actual values/results

6. **`xray`** - X-ray test catalog
   - `xrayid`, `xray_name`, `price`

7. **`presxray`** - X-ray orders (links prescription to X-rays)

8. **`xray_results`** - X-ray results and images
   - Stores X-ray images and findings

### Pharmacy Tables
9. **`medicine`** - Medicine master data
   - `medicineid`, `medicine_name`, `generic_name`, `manufacturer`
   - Pricing: `price_per_tablet`, `price_per_strip`, `price_per_box`
   - Cost tracking: `cost_per_tablet`, `cost_per_strip`, `cost_per_box`
   - Unit configuration: `tablets_per_strip`, `strips_per_box`, `unit_id`

10. **`medicine_units`** - Unit types (Tablet, Capsule, Syrup, Injection, etc.)
    - `unit_id`, `unit_name`, `unit_abbreviation`
    - `selling_method` ('countable', 'measurable', 'single_unit')
    - `allows_subdivision`, `unit_size_label`

11. **`medicine_inventory`** - Stock management
    - `inventoryid`, `medicineid`, `total_strips`, `loose_tablets`, `total_boxes`
    - `reorder_level_strips`, `expiry_date`, `batch_number`

12. **`pharmacy_sales`** - Sales transactions
    - `saleid`, `invoice_number`, `customer_name`, `sale_date`
    - `total_amount`, `discount`, `final_amount`, `payment_method`
    - Profit tracking: `total_cost`, `total_profit`

13. **`pharmacy_sales_items`** - Line items for each sale
    - `sale_item_id`, `saleid`, `medicineid`, `inventoryid`
    - `quantity_type`, `quantity`, `unit_price`, `total_price`
    - `cost_price`, `profit`

### Billing & Charges
14. **`patient_charges`** - Unified charge tracking
    - `charge_id`, `patientid`, `prescid`
    - `charge_type` ('Registration', 'Lab', 'Xray', 'Bed', 'Delivery')
    - `charge_name`, `amount`, `is_paid`, `paid_date`
    - `invoice_number`, `payment_method`, `reference_id`

15. **`patient_bed_charges`** - Inpatient bed charges
    - `bed_charge_id`, `patientid`, `prescid`, `charge_date`
    - `bed_charge_amount`, `is_paid`, `created_at`

### User Tables
16. **`admin`** - Admin users
17. **`doctor`** - Doctor users (includes `job_title`, `specialization`)
18. **`registre`** - Registration staff
19. **`lab_user`** - Lab technicians
20. **`xrayuser`** - X-ray technicians
21. **`pharmacy_user`** - Pharmacy staff
22. **`usertype`** - User role definitions

### Configuration
23. **`hospital_settings`** - Hospital configuration
    - `setting_key`, `setting_value`
    - Examples: `lab_charge_amount`, `xray_base_charge`, `registration_fee`, `bed_charge_per_day`

24. **`lab`** - Lab test catalog with prices
25. **`job_title`** - Doctor job titles/positions

---

## 🎯 KEY FEATURES

### 1. Patient Management
- ✅ Outpatient and Inpatient tracking
- ✅ Patient demographics and history
- ✅ Patient status tracking (active/discharged)
- ✅ Search and filter capabilities

### 2. Clinical Workflow
- ✅ Doctor prescriptions and orders
- ✅ Lab test ordering and results (40+ test types)
- ✅ X-ray ordering and image management
- ✅ Medication prescribing
- ✅ Inpatient care management

### 3. Pharmacy Module
- ✅ Point of Sale (POS) system
- ✅ Multi-unit inventory (tablets, strips, boxes)
- ✅ Flexible pricing (by tablet/strip/box)
- ✅ Cost and profit tracking
- ✅ Low stock alerts
- ✅ Expiry date management
- ✅ Sales history and reporting

### 4. Billing & Financial
- ✅ Unified charge system (patient_charges table)
- ✅ Registration fees
- ✅ Lab test charges
- ✅ X-ray charges
- ✅ Bed charges (daily calculation for inpatients)
- ✅ Delivery charges (maternity)
- ✅ Payment tracking (paid/unpaid)
- ✅ Invoice generation
- ✅ Multiple payment methods (Cash, Card, etc.)

### 5. Reporting & Analytics
- ✅ Financial reports by department
- ✅ Registration revenue report
- ✅ Lab revenue report
- ✅ X-ray revenue report
- ✅ Pharmacy sales reports (with profit margins)
- ✅ Bed revenue report
- ✅ Delivery revenue report
- ✅ Patient reports
- ✅ Medication reports

### 6. Printing & Documentation
- ✅ Patient invoices
- ✅ Lab result printouts
- ✅ Prescription printouts
- ✅ Visit summaries
- ✅ Discharge summaries (inpatients)

---

## 📁 KEY FILES & PAGES

### Admin Pages
- `admin_dashbourd.aspx` - Main admin dashboard
- `admin_inpatient.aspx` - Inpatient management
- `financial_reports.aspx` - Comprehensive financial analytics
- `manage_charges.aspx` - Charge configuration
- `hospital_settings.aspx` - System settings
- User management pages: `add_doctor.aspx`, `addlabuser.aspx`, `addxrayuser.aspx`, `add_pharmacy_user.aspx`, `add_registre.aspx`

### Doctor Pages
- `assignmed.aspx` - Patient waiting list and prescription
- `doctor_inpatient.aspx` - Inpatient care management
- `test_details.aspx` - Patient details and test results

### Registration Pages
- `Add_patients.aspx` - Patient registration
- `register_inpatient.aspx` - Inpatient admission
- `waitingpatients.aspx` - Patient queue

### Lab Pages
- `lab_waiting_list.aspx` - Lab test queue
- `lap_operation.aspx` - Perform lab tests
- `lap_processed.aspx` - Completed lab tests
- `lab_result_print.aspx` - Print lab results
- `add_lab.aspx`, `add_lab_charges.aspx` - Lab test catalog management

### X-ray Pages
- `take_xray.aspx` - X-ray waiting list
- `pending_xray.aspx` - Pending X-rays
- `xray_processed.aspx` - Completed X-rays
- `add_xray.aspx`, `add_xray_charges.aspx` - X-ray catalog management

### Pharmacy Pages
- `pharmacy_dashboard.aspx` - Pharmacy overview
- `pharmacy_pos.aspx` - Point of Sale
- `medicine_inventory.aspx` - Stock management
- `add_medicine.aspx` - Add new medicines
- `add_medicine_units.aspx` - Configure medicine units
- `pharmacy_sales_history.aspx` - Sales history
- `pharmacy_sales_reports.aspx` - Financial reports
- `low_stock.aspx` - Low stock alerts
- `expired_medicines.aspx` - Expiry tracking

### Report Pages
- `registration_revenue_report.aspx`
- `lab_revenue_report.aspx`
- `xray_revenue_report.aspx`
- `pharmacy_revenue_report.aspx`
- `bed_revenue_report.aspx`
- `delivery_revenue_report.aspx`
- `patient_report.aspx`
- `medication_report.aspx`

### Print Pages
- `patient_invoice_print.aspx`
- `lab_result_print.aspx`
- `visit_summary_print.aspx`
- `discharge_summary_print.aspx`
- `pharmacy_invoice.aspx`

---

## 🔧 CONFIGURATION FILES

### Web.config
- **Connection String:** Currently points to `juba_clinick` - **NEEDS UPDATE to `juba_clinick1`**
- Two connection strings defined:
  - `DBCS` (local): `Data Source=DESKTOP-GGE2JSJ\SQLEXPRESS;Initial Catalog=juba_clinick;Integrated Security=True;`
  - `DBCS6` (remote): Online database connection

### Important: Database Connection Update Required
```xml
<!-- Change this: -->
<add name="DBCS" connectionString="Data Source=DESKTOP-GGE2JSJ\SQLEXPRESS;Initial Catalog=juba_clinick;Integrated Security=True;" />

<!-- To this: -->
<add name="DBCS" connectionString="Data Source=DESKTOP-GGE2JSJ\SQLEXPRESS;Initial Catalog=juba_clinick1;Integrated Security=True;" />
```

---

## 💾 DATABASE SCRIPT

**Your database script:** `juba_hospital/juba_clinick1.sql`
- Creates database `juba_clinick` (the script name is juba_clinick1.sql but creates juba_clinick database)
- Contains all table definitions
- Includes sample data
- Has views for reporting (e.g., `vw_pharmacy_sales_with_profit`)

---

## 🎨 FRONTEND ASSETS

### CSS Frameworks
- Bootstrap 3.4.1 (responsive grid and components)
- Custom admin template (Kaiadmin theme)
- DataTables CSS (for data grids)
- SweetAlert2 (for alerts and confirmations)

### JavaScript Libraries
- jQuery 3.4.1
- Bootstrap JS
- DataTables (with export buttons: Excel, PDF, Print)
- SweetAlert2 (popup notifications)
- Custom scripts: `d.js`, `responsive.js`

### Images & Branding
- Hospital logo: `assets/img/hospital/`
- Lab icon: `assets/img/lab.png`
- Profile images and UI assets

---

## 🚀 RECENT ENHANCEMENTS

Based on the documentation files in the project:

1. **Unified Charge System** - All charges (registration, lab, X-ray, bed, delivery) in one table
2. **Inpatient Management** - Complete inpatient workflow with bed charges and discharge summaries
3. **Bed Charge Calculator** - Automatic daily bed charge calculation (BedChargeCalculator.cs)
4. **Pharmacy Cost & Profit Tracking** - Track purchase costs and calculate profit margins
5. **Medicine Unit System** - Flexible unit configurations (tablets, strips, boxes, syrups, injections, etc.)
6. **Lab Test Ordering** - Enhanced lab test workflow with charge tracking
7. **Revenue Reporting** - Comprehensive revenue reports by department
8. **Payment Status Tracking** - Track paid/unpaid charges with payment methods

---

## 📈 WORKFLOW STATUS CODES

### Lab Test Status (prescribtion.status)
- `0` - Test not ordered
- `1` - Test ordered (waiting)
- `2` - Test in progress
- `3` - Test completed

### X-ray Status (prescribtion.xray_status)
- `0` - Not ordered
- `1` - Ordered (waiting)
- `2` - Completed

### Patient Status (patient.patient_status)
- `0` - Active
- `1` - Discharged

### Charge Payment (patient_charges.is_paid)
- `0` - Unpaid
- `1` - Paid

---

## 🔐 DEFAULT LOGIN CREDENTIALS

Based on sample data in the database:

**Admin:**
- Username: `admin`
- Password: `admin`

**Lab User:**
- Username: `ali`
- Password: `ali`

**X-ray User:**
- Username: `tt`
- Password: `tt`

*(Other users will be in the respective tables)*

---

## 📝 NEXT STEPS TO GET STARTED

1. **Update Web.config** - Change database name from `juba_clinick` to `juba_clinick1`
2. **Restore Database** - Run `juba_clinick1.sql` to create your database
3. **Build Project** - Open `juba_hospital.sln` in Visual Studio and build
4. **Test Login** - Navigate to `login.aspx` and test with admin credentials
5. **Explore Modules** - Test each user role's functionality

---

## 🎯 SYSTEM STRENGTHS

✅ **Comprehensive Coverage** - Handles entire hospital workflow  
✅ **Multi-Role Support** - Separate interfaces for different users  
✅ **Financial Tracking** - Complete revenue and cost tracking  
✅ **Flexible Pharmacy** - Advanced inventory with multi-unit support  
✅ **Inpatient Support** - Full inpatient management with automatic bed charges  
✅ **Reporting** - Extensive reports for business intelligence  
✅ **User-Friendly** - Modern UI with Bootstrap and DataTables  

---

## 📞 SYSTEM MODULES SUMMARY

| Module | Pages | Key Tables | Features |
|--------|-------|------------|----------|
| **Patient Registration** | 5 pages | `patient`, `patient_charges` | Outpatient/Inpatient registration, fees |
| **Doctor Consultation** | 8 pages | `prescribtion`, `medication` | Prescriptions, orders, inpatient care |
| **Laboratory** | 10 pages | `lab_test`, `lab_results` | 40+ tests, results, charges |
| **X-ray** | 8 pages | `xray`, `xray_results`, `presxray` | Orders, images, results |
| **Pharmacy** | 12 pages | `medicine`, `medicine_inventory`, `pharmacy_sales` | POS, inventory, sales, profit tracking |
| **Billing** | 7 pages | `patient_charges`, `patient_bed_charges` | Unified billing, invoices, payment tracking |
| **Reports** | 9 pages | Multiple tables with views | Revenue reports by department |
| **Admin** | 15 pages | User tables, `hospital_settings` | User management, system config, oversight |

**Total:** ~70+ ASPX pages serving all hospital operations

---

## ✅ CONCLUSION

This is a **production-ready, feature-rich Hospital Management System** that covers:
- 👥 Patient management (outpatient + inpatient)
- 🩺 Clinical workflows (prescriptions, lab, X-ray)
- 💊 Pharmacy with advanced inventory
- 💰 Complete financial tracking and billing
- 📊 Comprehensive reporting
- 🔐 Role-based access control for 6 user types

**Current State:** Well-structured, documented, and ready for deployment once you update the database connection string to `juba_clinick1`.

---

*Analysis completed by Rovo Dev*
