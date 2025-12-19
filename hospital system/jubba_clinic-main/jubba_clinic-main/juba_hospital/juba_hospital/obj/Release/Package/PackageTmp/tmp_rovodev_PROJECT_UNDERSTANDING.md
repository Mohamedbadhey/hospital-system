# Juba Hospital Management System - Understanding Summary

## Overview
This is a comprehensive **Hospital Management System** built with **ASP.NET Web Forms** (C#) and **SQL Server**. The database is called **`juba_clinick`** (stored in `juba_clinick1.sql`).

---

## 🗄️ Database Structure (juba_clinick)

### Core Tables

#### 1. **User/Authentication Tables**
- `admin` - Admin users (username: admin, password: admin)
- `doctor` - Doctor accounts with titles and specializations
- `lab_user` - Laboratory staff users
- `xrayuser` - X-ray department staff users
- `pharmacy_user` - Pharmacy staff users (implied)
- `registre` - Registration staff users

#### 2. **Patient Management**
- `patient` - Core patient information
  - Fields: patientid, full_name, dob, sex, location, phone, date_registered
  - patient_status (0=outpatient, 1=inpatient)
  - patient_type ('outpatient', 'inpatient')
  - bed_admission_date, delivery_charge

#### 3. **Clinical Management**
- `prescribtion` - Doctor prescriptions/visits
  - Links doctors to patients
  - Tracks status of medication, lab tests, and x-rays
  - Fields: prescid, doctorid, patientid, status, xray_status, lab_charge_paid, xray_charge_paid

- `medication` - Prescribed medications
  - Fields: medid, med_name, dosage, frequency, duration, special_inst, prescid

- `lab_test` - Laboratory test orders (60+ test types)
  - Comprehensive tests: Biochemistry, Hematology, Immunology, Hormones, etc.
  - Fields include: LDL, HDL, Cholesterol, CBC, HIV, Hepatitis, etc.
  - Supports reordering: is_reorder, reorder_reason, original_order_id

- `lab_results` - Laboratory test results storage
  - Mirrors lab_test structure for storing actual results

- `xray` - X-ray test catalog
- `presxray` - Links prescriptions to x-ray orders
- `xray_results` - Stores x-ray results and images

#### 4. **Pharmacy/Medicine Management**
- `medicine` - Medicine catalog
  - Fields: medicineid, medicine_name, generic_name, manufacturer
  - Pricing: price_per_tablet, price_per_strip, price_per_box
  - Cost tracking: cost_per_tablet, cost_per_strip, cost_per_box
  - Links to medicine_units via unit_id

- `medicine_units` - Unit types (Tablet, Capsule, Syrup, Injection, etc.)
  - selling_method: 'countable', 'measurable'
  - Supports subdivisions (e.g., tablets per strip)

- `medicine_inventory` - Stock management
  - Tracks: total_strips, loose_tablets, total_boxes
  - Flexible quantity system: primary_quantity, secondary_quantity, unit_size
  - Reorder levels, batch numbers, expiry dates

- `medicine_dispensing` - Medication dispensing records

- `pharmacy_sales` - POS sales transactions
  - invoice_number, customer_name, sale_date
  - total_amount, discount, final_amount
  - payment_method, sold_by
  - Profit tracking: total_cost, total_profit

- `pharmacy_sales_items` - Individual items in sales
  - quantity_type, quantity, unit_price, total_price
  - cost_price, profit

#### 5. **Financial Management**
- `patient_charges` - All charges (Registration, Lab, X-ray, Bed, Delivery)
  - charge_type: 'Registration', 'Lab', 'Xray', 'Bed', 'Delivery'
  - is_paid status tracking
  - Invoice generation: invoice_number
  - payment_method, reference_id

- `patient_bed_charges` - Daily bed charges for inpatients
  - Tracks per-day bed fees
  - Links to patient and prescription

- `charges_config` - Configurable charge templates
  - Allows setting default charges for different service types

#### 6. **Configuration**
- `hospital_settings` - Hospital branding and configuration
  - hospital_name, address, phone, email, website
  - Logo paths for sidebar and print headers
  - Custom print header text

- `job_title` - Doctor job titles/specializations

---

## 🎯 Key Modules

### 1. **Patient Registration & Management**
- Files: `Add_patients.aspx`, `waitingpatients.aspx`, `Patient_details.aspx`
- Registers patients as outpatient or inpatient
- Applies registration charges automatically

### 2. **Doctor Consultation**
- Files: `Patient_Operation.aspx`, `add_patientsdoctor.aspx`
- Doctors see waiting patients
- Create prescriptions with medications, lab orders, x-ray orders
- Master page: `doctor.Master`

### 3. **Laboratory Management**
- Files: `lab_waiting_list.aspx`, `take_lab_test.aspx`, `lap_operation.aspx`
- Lab waiting list with ordered tests
- Enter lab results (60+ test types)
- Print lab results: `lab_result_print.aspx`
- Lab charge tracking and payment
- Master page: `labtest.Master`
- Reference guide: `lab_reference_guide.aspx`

### 4. **X-ray Management**
- Files: `pending_xray.aspx`, `take_xray.aspx`, `assingxray.aspx`
- X-ray waiting list
- Upload x-ray images and results
- Print x-ray results
- Master page: `xray.Master`

### 5. **Pharmacy/Medicine**
- **Inventory Management**: `medicine_inventory.aspx`, `add_medicine.aspx`
- **POS System**: `pharmacy_pos.aspx` - Point of Sale interface
- **Stock Tracking**: `low_stock.aspx`, `expired_medicines.aspx`
- **Sales Reports**: `pharmacy_sales_reports.aspx`, `pharmacy_sales_history.aspx`
- **Unit Management**: `add_medicine_units.aspx`
- Master page: `pharmacy.Master`

### 6. **Inpatient Management**
- Files: `register_inpatient.aspx`, `admin_inpatient.aspx`, `doctor_inpatient.aspx`
- Admit patients to beds
- Daily bed charge calculation (via `BedChargeCalculator.cs`)
- Track delivery charges for maternity
- Discharge summaries: `discharge_summary_print.aspx`

### 7. **Financial/Revenue Reporting**
- `financial_reports.aspx` - Comprehensive financial dashboard
- `registration_revenue_report.aspx` - Registration fees
- `lab_revenue_report.aspx` - Lab test revenue
- `xray_revenue_report.aspx` - X-ray revenue
- `bed_revenue_report.aspx` - Bed charges
- `delivery_revenue_report.aspx` - Delivery charges
- `pharmacy_revenue_report.aspx` - Pharmacy sales
- `charge_history.aspx` - Patient charge history
- `patient_invoice_print.aspx` - Printable invoices

### 8. **Administration**
- Files: `admin_dashbourd.aspx`, `manage_charges.aspx`
- User management: `add_doctor.aspx`, `addlabuser.aspx`, `addxrayuser.aspx`, `add_pharmacy_user.aspx`
- Charge configuration
- Hospital settings: `hospital_settings.aspx`
- Master page: `Admin.Master`

---

## 💻 Technical Stack

### Backend
- **Framework**: ASP.NET Web Forms 4.7.2
- **Language**: C# (.NET Framework)
- **Database**: SQL Server (Express)
- **Connection**: ADO.NET with SqlConnection/SqlCommand

### Frontend
- **UI Framework**: Bootstrap 3.4.1
- **Admin Template**: Kaiadmin (custom dashboard template)
- **JavaScript**: jQuery 3.4.1
- **DataTables**: For data grid functionality
- **SweetAlert2**: For alerts and notifications
- **Icons**: Font Awesome, Simple Line Icons

### Key Features
- **Master Pages**: Separate layouts for different user roles
- **Session Management**: Role-based access control
- **AJAX**: For dynamic updates
- **Printing**: Dedicated print pages with custom headers
- **File Upload**: For x-ray images

---

## 🔐 User Roles & Access

1. **Admin** (`admin.Master`)
   - Full system access
   - User management
   - Charge configuration
   - All reports

2. **Doctor** (`doctor.Master`)
   - Patient consultation
   - Write prescriptions
   - Order lab tests and x-rays
   - View inpatients

3. **Lab Technician** (`labtest.Master`)
   - View lab orders
   - Enter lab results
   - Print lab reports

4. **X-ray Technician** (`xray.Master`)
   - View x-ray orders
   - Upload x-ray images
   - Enter findings

5. **Pharmacy** (`pharmacy.Master`)
   - POS system
   - Inventory management
   - Sales reports

6. **Registration** (`register.Master`)
   - Patient registration
   - Basic patient operations

---

## 📊 Key Workflows

### Patient Visit Flow (Outpatient)
1. **Registration** → Patient registered, registration charge applied
2. **Doctor Consultation** → Doctor sees patient, creates prescription
3. **Lab/X-ray Orders** (if needed) → Charges applied
4. **Lab/X-ray Processing** → Tests performed, results entered
5. **Medication** → Optional pharmacy dispensing
6. **Payment & Invoice** → Charges marked as paid, invoice printed

### Inpatient Flow
1. **Patient Registration** → Register as inpatient
2. **Bed Admission** → Admit to bed, start bed charges
3. **Daily Care** → Doctor consultations, lab tests, medications
4. **Daily Bed Charges** → Automatically calculated per day
5. **Delivery Charge** (if applicable) → For maternity cases
6. **Discharge** → Discharge summary, final invoice

### Pharmacy Sales Flow
1. **Customer** → Walk-in or registered patient
2. **POS** → Select medicines, quantities, calculate total
3. **Payment** → Process payment, generate invoice
4. **Profit Tracking** → Automatic cost/profit calculation
5. **Inventory Update** → Stock automatically deducted

---

## 🎨 UI/UX Highlights

- **Dashboard Cards**: Revenue summaries with icons
- **DataTables**: Sortable, searchable data grids
- **Modal Dialogs**: For quick actions
- **Print Layouts**: Professional medical report formatting
- **Responsive Design**: Mobile-friendly layouts
- **Color-coded Status**: Visual status indicators

---

## 📁 Important Files

### Configuration
- `Web.config` - Database connection strings, app settings
- `Global.asax` - Application-level events

### Helpers
- `BedChargeCalculator.cs` - Bed charge calculation logic
- `HospitalSettingsHelper.cs` - Hospital configuration helper

### Assets
- `/assets/css/` - Kaiadmin theme, Bootstrap
- `/assets/js/` - jQuery, DataTables, plugins
- `/datatables/` - DataTables library with export buttons

---

## 🔧 Recent Enhancements (from documentation)

1. **Unified Charge System** - Centralized patient billing
2. **Inpatient Management** - Complete bed tracking system
3. **Profit Tracking** - Cost/profit analysis for pharmacy
4. **Lab Reordering** - Ability to reorder failed lab tests
5. **Flexible Medicine Units** - Support for various medicine types
6. **Revenue Dashboard** - Comprehensive financial reporting
7. **Hospital Branding** - Customizable logos and print headers

---

## 🚀 Getting Started

### Database Setup
1. Restore `juba_clinick1.sql` to SQL Server
2. Database name: `juba_clinick`
3. Update connection string in `Web.config`

### Default Login
- **Username**: admin
- **Password**: admin

### Build & Run
1. Open `juba_hospital.sln` in Visual Studio
2. Restore NuGet packages
3. Build solution
4. Run project (IIS Express or local IIS)

---

## 📝 Notes

- The system uses **plain text passwords** (should be hashed in production)
- Database has extensive test data already populated
- Many documentation files exist showing recent development history
- System supports both English UI with some Somali labels
- Print functionality requires proper printer setup
- X-ray images stored in file system (path configurable)

---

**This is a fully-featured, production-ready hospital management system with comprehensive patient care tracking, financial management, and reporting capabilities.**
