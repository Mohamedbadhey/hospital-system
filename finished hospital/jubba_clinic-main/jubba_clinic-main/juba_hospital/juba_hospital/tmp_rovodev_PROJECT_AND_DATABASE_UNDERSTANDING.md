# Juba Hospital Management System - Complete Understanding

## 📋 Project Overview

**Project Name:** Juba Hospital Management System  
**Database Name:** `juba_clinick` (Your database file: `juba_clinick1.sql`)  
**Technology Stack:** ASP.NET Web Forms (.NET Framework 4.7.2), SQL Server, Bootstrap, jQuery  
**Project Type:** Hospital/Clinic Management System  

## 🗄️ Database Structure - Complete Analysis

### Database Connection
- **Connection String Name:** `DBCS`
- **Local Server:** `DESKTOP-GGE2JSJ\SQLEXPRESS`
- **Database:** `juba_clinick`
- **Authentication:** Integrated Security (Windows Authentication)

---

## 📊 Database Tables (27 Tables Total)

### 1️⃣ **USER MANAGEMENT TABLES**

#### `admin` - Administrator Accounts
- **Primary Key:** `userid` (INT, Identity)
- **Columns:**
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))
- **Default User:** admin/admin

#### `doctor` - Doctor/Physician Accounts
- **Primary Key:** `doctorid` (INT, Identity)
- **Columns:**
  - `doctorname` (VARCHAR(50))
  - `doctortitle` (VARCHAR(50)) - Specialization
  - `doctornumber` (VARCHAR(50))
  - `usertypeid` (INT)
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))

#### `lab_user` - Lab Technician Accounts
- **Primary Key:** `userid` (INT, Identity)
- **Columns:**
  - `fullname` (VARCHAR(50))
  - `phone` (INT)
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))

#### `xrayuser` - X-Ray Technician Accounts
- **Primary Key:** `userid` (INT, Identity)
- **Columns:**
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))
  - `phone` (INT)
  - `fullname` (VARCHAR(50))

#### `pharmacy_user` - Pharmacy Staff Accounts
- **Primary Key:** `userid` (INT, Identity)
- **Columns:**
  - `fullname` (VARCHAR(50))
  - `phone` (VARCHAR(50))
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))

#### `registre` - Registration Staff Accounts
- **Primary Key:** `userid` (INT, Identity)
- **Columns:**
  - `fullname` (VARCHAR(50))
  - `phone` (INT)
  - `username` (VARCHAR(50))
  - `password` (VARCHAR(50))
  - `usertypeid` (INT)

#### `usertype` - User Role Types
- **Primary Key:** `usertypeid` (INT, Identity)
- **Columns:**
  - `usertype` (VARCHAR(50))
- **User Types:**
  1. Doctor
  2. Lab Technician
  3. Registration Staff
  4. Admin
  5. X-Ray Technician
  6. Pharmacy Staff

---

### 2️⃣ **PATIENT MANAGEMENT TABLES**

#### `patient` - Patient Master Data
- **Primary Key:** `patientid` (INT, Identity)
- **Columns:**
  - `full_name` (VARCHAR(100))
  - `dob` (DATE) - Date of Birth
  - `amount` (FLOAT) - Registration fee/initial amount
  - `sex` (VARCHAR(50))
  - `location` (VARCHAR(50))
  - `phone` (VARCHAR(50))
  - `date_registered` (DATETIME)
  - `patient_status` (INT) - 0=Active, 1=Inactive/Discharged
  - `patient_type` (VARCHAR(20)) - 'outpatient' or 'inpatient' (Default: 'outpatient')
  - `bed_admission_date` (DATETIME)
  - `delivery_charge` (DECIMAL(10,2))

#### `prescribtion` - Doctor Prescriptions/Consultations
- **Primary Key:** `prescid` (INT, Identity)
- **Columns:**
  - `doctorid` (INT) - Foreign Key to doctor table
  - `patientid` (INT) - Foreign Key to patient table
  - `status` (INT) - Prescription status
  - `xray_status` (INT) - X-Ray order status
  - `lab_charge_paid` (BIT)
  - `xray_charge_paid` (BIT)
- **Purpose:** Central record linking patient visits to doctors

---

### 3️⃣ **MEDICATION MANAGEMENT TABLES**

#### `medication` - Prescribed Medications
- **Primary Key:** `medid` (INT, Identity)
- **Columns:**
  - `med_name` (VARCHAR(250))
  - `dosage` (VARCHAR(250))
  - `frequency` (VARCHAR(250))
  - `duration` (VARCHAR(250))
  - `special_inst` (VARCHAR(250))
  - `prescid` (INT) - Links to prescription
  - `date_taken` (DATE)

#### `medicine` - Medicine Catalog
- **Primary Key:** `medicineid` (INT, Identity)
- **Columns:**
  - `medicine_name` (VARCHAR(250))
  - `generic_name` (VARCHAR(250))
  - `manufacturer` (VARCHAR(250))
  - `unit` (VARCHAR(50))
  - `price_per_tablet` (FLOAT)
  - `price_per_strip` (FLOAT)
  - `price_per_box` (FLOAT)
  - `tablets_per_strip` (INT)
  - `strips_per_box` (INT)
  - `date_added` (DATETIME)
  - `unit_id` (INT) - Foreign Key to medicine_units
  - `cost_per_tablet` (FLOAT) - Cost price
  - `cost_per_strip` (FLOAT)
  - `cost_per_box` (FLOAT)

#### `medicine_units` - Medicine Unit Types
- **Primary Key:** `unit_id` (INT, Identity)
- **Columns:**
  - `unit_name` (VARCHAR(50)) - e.g., Tablet, Capsule, Syrup
  - `unit_abbreviation` (VARCHAR(10))
  - `is_active` (BIT)
  - `created_date` (DATETIME)
  - `selling_method` (VARCHAR(50)) - 'countable' or 'liquid'
  - `base_unit_name` (VARCHAR(20))
  - `subdivision_unit` (VARCHAR(20))
  - `allows_subdivision` (BIT)
  - `unit_size_label` (VARCHAR(50))
- **Examples:** Tablet, Capsule, Syrup, Injection, Suppository

#### `medicine_inventory` - Stock Management
- **Primary Key:** `inventoryid` (INT, Identity)
- **Columns:**
  - `medicineid` (INT)
  - `total_strips` (INT)
  - `loose_tablets` (INT)
  - `total_boxes` (INT)
  - `reorder_level_strips` (INT)
  - `expiry_date` (DATE)
  - `batch_number` (VARCHAR(50))
  - `purchase_price` (FLOAT)
  - `date_added` (DATETIME)
  - `last_updated` (DATETIME)
  - `primary_quantity` (INT)
  - `secondary_quantity` (FLOAT)
  - `unit_size` (FLOAT)

#### `medicine_dispensing` - Medicine Distribution
- **Primary Key:** `dispenseid` (INT, Identity)
- **Columns:**
  - `medid` (INT) - Links to medication (prescription)
  - `medicineid` (INT) - Links to medicine catalog
  - `quantity_dispensed` (INT)
  - `dispensed_by` (INT) - User who dispensed
  - `dispense_date` (DATETIME)
  - `status` (INT)

---

### 4️⃣ **LABORATORY MANAGEMENT TABLES**

#### `lab_test` - Lab Test Orders
- **Primary Key:** `med_id` (INT, Identity)
- **65+ Columns for Different Lab Tests:**
  - Lipid Profile: LDL, HDL, Total Cholesterol, Triglycerides
  - Liver Function: SGPT, SGOT, ALP, Bilirubin, Albumin
  - Renal Profile: Urea, Creatinine, Uric Acid
  - Electrolytes: Sodium, Potassium, Chloride, Calcium
  - Hematology: Hemoglobin, Malaria, ESR, Blood grouping, CBC
  - Immunology: HIV, HBV, HCV, TPHA, CRP, RF
  - Hormones: Thyroid (T3, T4, TSH), Fertility tests (FSH, LH, Estradiol)
  - Clinical Path: Urine, Stool, Sperm examination
- **Special Columns:**
  - `prescid` (INT) - Links to prescription
  - `date_taken` (DATETIME)
  - `is_reorder` (BIT) - For reordering tests
  - `reorder_reason` (NVARCHAR(500))
  - `original_order_id` (INT)

#### `lab_results` - Lab Test Results
- **Primary Key:** `lab_result_id` (INT, Identity)
- **Same 65+ columns as lab_test** for storing actual results
- **Additional Columns:**
  - `prescid` (INT)
  - `date_taken` (DATETIME)
  - `lab_test_id` (INT) - Links to lab_test

#### `lab` - Lab Test Catalog (Referenced but not in schema)
- Likely contains lab test definitions and prices

---

### 5️⃣ **X-RAY MANAGEMENT TABLES**

#### `xray` - X-Ray Orders/Descriptions
- **Primary Key:** `xrayid` (INT, Identity)
- **Columns:**
  - `xryname` (VARCHAR(50))
  - `xrydescribtion` (VARCHAR(250))
  - `prescid` (INT)
  - `date_taken` (DATE)
  - `type` (VARCHAR(50))

#### `xray_results` - X-Ray Images/Results
- **Primary Key:** `xray_result_id` (INT, Identity)
- **Columns:**
  - `xryimage` (VARBINARY(MAX)) - Binary image data
  - `prescid` (INT)
  - `date_taken` (DATE)
  - `type` (VARCHAR(50))

#### `presxray` - Prescription-XRay Linking
- **Primary Key:** `prescxrayid` (INT, Identity)
- **Columns:**
  - `xrayid` (INT)
  - `prescid` (INT)

---

### 6️⃣ **PHARMACY/SALES MANAGEMENT TABLES**

#### `pharmacy_sales` - Sales Transactions
- **Primary Key:** `saleid` (INT, Identity)
- **Columns:**
  - `invoice_number` (VARCHAR(50))
  - `customerid` (INT)
  - `customer_name` (VARCHAR(100))
  - `sale_date` (DATETIME)
  - `total_amount` (FLOAT)
  - `discount` (FLOAT)
  - `final_amount` (FLOAT)
  - `sold_by` (INT) - User ID of seller
  - `payment_method` (VARCHAR(50))
  - `status` (INT)
  - `total_cost` (FLOAT)
  - `total_profit` (FLOAT)
  - `sale_id` (INT) - Duplicate column

#### `pharmacy_sales_items` - Individual Sale Items
- **Primary Key:** `sale_item_id` (INT, Identity)
- **Columns:**
  - `saleid` (INT) - Links to pharmacy_sales
  - `medicineid` (INT)
  - `inventoryid` (INT)
  - `quantity_type` (VARCHAR(20)) - 'unit', 'strip', 'box'
  - `quantity` (INT)
  - `unit_price` (FLOAT)
  - `total_price` (FLOAT)
  - `cost_price` (FLOAT)
  - `profit` (FLOAT)
  - `sale_id`, `medicine_id`, `inventory_id` (INT) - Duplicate columns

#### `pharmacy_customer` - Pharmacy Customers
- **Primary Key:** `customerid` (INT, Identity)
- **Columns:**
  - `customer_name` (VARCHAR(100))
  - `phone` (VARCHAR(50))
  - `email` (VARCHAR(100))
  - `address` (VARCHAR(250))
  - `date_registered` (DATETIME)

---

### 7️⃣ **FINANCIAL/BILLING TABLES**

#### `patient_charges` - All Patient Charges
- **Primary Key:** `charge_id` (INT, Identity)
- **Columns:**
  - `patientid` (INT)
  - `prescid` (INT)
  - `charge_type` (VARCHAR(50)) - 'Registration', 'Lab', 'Xray', 'Bed', 'Delivery'
  - `charge_name` (VARCHAR(100))
  - `amount` (FLOAT)
  - `is_paid` (BIT)
  - `paid_date` (DATETIME)
  - `paid_by` (INT)
  - `invoice_number` (VARCHAR(50))
  - `date_added` (DATETIME)
  - `last_updated` (DATETIME)
  - `payment_method` (VARCHAR(50)) - 'Cash', 'Card', etc.
  - `reference_id` (INT)
- **Index:** `IX_patient_charges_reference` on reference fields

#### `patient_bed_charges` - Inpatient Bed Charges
- **Primary Key:** `bed_charge_id` (INT, Identity)
- **Columns:**
  - `patientid` (INT)
  - `prescid` (INT)
  - `charge_date` (DATE)
  - `bed_charge_amount` (DECIMAL(10,2))
  - `is_paid` (BIT)
  - `created_at` (DATETIME)

#### `charges_config` - Charge Configuration/Pricing
- **Primary Key:** `charge_config_id` (INT, Identity)
- **Columns:**
  - `charge_type` (VARCHAR(50))
  - `charge_name` (VARCHAR(100))
  - `amount` (FLOAT)
  - `is_active` (BIT)
  - `date_added` (DATETIME)
  - `last_updated` (DATETIME)
- **Default Charges:**
  - Registration: $10
  - Lab Test: $15
  - X-Ray: $150
  - Bed (per night): $3
  - Delivery: $10

#### `totalamount` - Legacy Total Amount Table
- **Primary Key:** `taid` (INT)
- **Columns:**
  - `prescxrayid` (INT)
  - `total` (INT)

---

### 8️⃣ **CONFIGURATION TABLES**

#### `hospital_settings` - Hospital Information
- **Primary Key:** `id` (INT, Identity)
- **Columns:**
  - `hospital_name` (NVARCHAR(200))
  - `hospital_address` (NVARCHAR(500))
  - `hospital_phone` (NVARCHAR(50))
  - `hospital_email` (NVARCHAR(100))
  - `hospital_website` (NVARCHAR(200))
  - `sidebar_logo_path` (NVARCHAR(500))
  - `print_header_logo_path` (NVARCHAR(500))
  - `print_header_text` (NVARCHAR(1000))
  - `created_date` (DATETIME)
  - `updated_date` (DATETIME)
- **Current Data:** 
  - Name: "v-afmadow hospital"
  - Location: Kismayo, Somalia

---

### 9️⃣ **DATABASE VIEWS**

#### `vw_pharmacy_sales_with_profit`
- Aggregates pharmacy sales with profit calculations
- Joins `pharmacy_sales` with `pharmacy_sales_items`
- Calculates total profit and total cost per sale

---

## 🔄 System Workflows

### 1. Patient Registration Flow
```
Registration Staff → Add_patients.aspx
   ↓
Creates patient record in `patient` table
   ↓
Generates charge in `patient_charges` (Registration type)
   ↓
Assigns invoice number: REG-YYYYMMDD-{patientid}
```

### 2. Doctor Consultation Flow
```
Doctor selects patient → assignmed.aspx
   ↓
Creates prescription in `prescribtion` table
   ↓
Doctor can order:
   - Medications → `medication` table
   - Lab Tests → `lab_test` table
   - X-Rays → `xray` table
```

### 3. Lab Test Workflow
```
Lab Technician → lab_waiting_list.aspx
   ↓
Views pending lab tests
   ↓
Takes test → take_lab_test.aspx
   ↓
Enters results in `lab_results` table
   ↓
Generates charge in `patient_charges` (Lab type)
   ↓
Invoice: LAB-YYYYMMDD-{patientid}
```

### 4. X-Ray Workflow
```
X-Ray Technician → pending_xray.aspx
   ↓
Views pending x-rays
   ↓
Takes x-ray → take_xray.aspx
   ↓
Uploads image to `xray_results` table (VARBINARY)
   ↓
Generates charge in `patient_charges` (Xray type)
```

### 5. Pharmacy Sales Flow
```
Pharmacy Staff → pharmacy_pos.aspx
   ↓
Creates sale in `pharmacy_sales` table
   ↓
Adds items to `pharmacy_sales_items` table
   ↓
Updates `medicine_inventory` quantities
   ↓
Generates invoice: INV-YYYYMMDD-HHMMSS
   ↓
Calculates profit (selling_price - cost_price)
```

### 6. Inpatient Management Flow
```
Admin/Doctor → register_inpatient.aspx
   ↓
Updates patient.patient_type = 'inpatient'
   ↓
Sets patient.bed_admission_date
   ↓
Daily bed charges created in `patient_bed_charges`
   ↓
Discharge → Updates patient.patient_status = 1
```

---

## 🔐 User Roles & Access

### 1. **Admin (Role ID: 4)**
- **Login Page:** login.aspx
- **Dashboard:** admin_dashbourd.aspx
- **Capabilities:**
  - Manage all users (doctors, lab, xray, pharmacy, registration staff)
  - View all reports and dashboards
  - Manage charges configuration
  - Hospital settings
  - Inpatient management
  - Financial reports

### 2. **Doctor (Role ID: 1)**
- **Dashboard:** assignmed.aspx
- **Capabilities:**
  - View waiting patients
  - Create prescriptions
  - Order medications, lab tests, x-rays
  - View patient history
  - Inpatient management

### 3. **Registration Staff (Role ID: 3)**
- **Dashboard:** Add_patients.aspx
- **Capabilities:**
  - Register new patients
  - Update patient information
  - Process payments

### 4. **Lab Technician (Role ID: 2)**
- **Dashboard:** lab_waiting_list.aspx
- **Capabilities:**
  - View pending lab tests
  - Enter lab results
  - Print lab reports
  - Lab test reference guides

### 5. **X-Ray Technician (Role ID: 5)**
- **Dashboard:** take_xray.aspx
- **Capabilities:**
  - View pending x-rays
  - Upload x-ray images
  - Process x-ray orders

### 6. **Pharmacy Staff (Role ID: 6)**
- **Dashboard:** pharmacy_dashboard.aspx
- **Capabilities:**
  - POS (Point of Sale)
  - Manage medicine inventory
  - Dispense medications
  - Track stock levels
  - Sales reports

---

## 📈 Reporting & Analytics

### Financial Reports
- **registration_revenue_report.aspx** - Registration fees collected
- **lab_revenue_report.aspx** - Lab test revenue
- **xray_revenue_report.aspx** - X-Ray revenue
- **pharmacy_revenue_report.aspx** - Pharmacy sales with profit
- **bed_revenue_report.aspx** - Inpatient bed charges
- **delivery_revenue_report.aspx** - Delivery service charges
- **financial_reports.aspx** - Consolidated financial reports

### Operational Reports
- **patient_report.aspx** - Patient statistics
- **medication_report.aspx** - Medication usage
- **pharmacy_sales_reports.aspx** - Pharmacy profit/loss
- **expired_medicines.aspx** - Expiring medicines alert
- **low_stock.aspx** - Low inventory alert

### Management Dashboards
- **admin_dashbourd.aspx** - Overall system dashboard
- **pharmacy_dashboard.aspx** - Pharmacy metrics
- **waitingpatients.aspx** - Waiting room status

---

## 🔧 Key Technical Features

### 1. **AJAX WebMethods**
- Heavy use of `[WebMethod]` for AJAX calls
- JSON serialization for data transfer
- Real-time updates without page reload

### 2. **Session Management**
```csharp
Session["UserId"] - Username
Session["UserName"] - Display name
Session["id"] - Primary ID (doctorid, userid, etc.)
Session["role_id"] - User role (1-6)
Session["admin_id"] - Admin specific
```

### 3. **Invoice Generation Patterns**
- Registration: `REG-{YYYYMMDD}-{patientid}`
- Lab: `LAB-{YYYYMMDD}-{patientid}`
- Xray: `XRAY-{YYYYMMDD}-{patientid}`
- Pharmacy: `INV-{YYYYMMDD}-{HHMMSS}`
- Delivery: `DEL-{YYYYMMDD}-{patientid}`

### 4. **File Upload Support**
- Max request length: 52,428,800 bytes (~50MB)
- Used for X-Ray images
- Stored as VARBINARY in database

### 5. **Profit Calculation System**
- Medicine: `selling_price - cost_price = profit`
- Tracked per item in `pharmacy_sales_items`
- Aggregated in `pharmacy_sales`

---

## 🗂️ Key Application Pages

### Patient Management
- `Add_patients.aspx` - Register new patients
- `Patient_details.aspx` - View patient details
- `patient_status.aspx` - Patient status management
- `waitingpatients.aspx` - Waiting room queue

### Doctor/Clinical
- `assignmed.aspx` - Doctor prescription interface
- `Patient_Operation.aspx` - Patient operations
- `doctor_inpatient.aspx` - Doctor inpatient management

### Laboratory
- `lab_waiting_list.aspx` - Lab queue
- `take_lab_test.aspx` - Enter lab results
- `lap_operation.aspx` - Lab operations
- `lap_processed.aspx` - Completed lab tests
- `pending_lap.aspx` - Pending lab tests
- `lab_reference_guide.aspx` - Lab test reference values

### Radiology/X-Ray
- `take_xray.aspx` - X-Ray interface
- `assingxray.aspx` - Assign x-ray orders
- `pending_xray.aspx` - Pending x-rays
- `xray_processed.aspx` - Completed x-rays
- `delete_xray_images.aspx` - Manage x-ray images

### Pharmacy
- `pharmacy_pos.aspx` - Point of Sale
- `pharmacy_dashboard.aspx` - Dashboard
- `medicine_inventory.aspx` - Inventory management
- `add_medicine.aspx` - Add medicines
- `add_medicine_units.aspx` - Manage units
- `expired_medicines.aspx` - Expiry alerts
- `low_stock.aspx` - Stock alerts
- `dispense_medication.aspx` - Dispense prescriptions
- `pharmacy_customers.aspx` - Customer management

### Administration
- `admin_dashbourd.aspx` - Admin dashboard
- `admin_inpatient.aspx` - Inpatient management
- `manage_charges.aspx` - Configure charges
- `hospital_settings.aspx` - Hospital configuration
- `charge_history.aspx` - Charge history

### User Management
- `add_doctor.aspx` - Add doctors
- `addlabuser.aspx` - Add lab users
- `addxrayuser.aspx` - Add xray users
- `add_pharmacy_user.aspx` - Add pharmacy users
- `add_registre.aspx` - Add registration staff
- `add_job_title.aspx` - Manage user types

### Inpatient Management
- `register_inpatient.aspx` - Admit patients
- `patient_in.aspx` - Inpatient list
- `doctor_inpatient.aspx` - Doctor inpatient interface
- `admin_inpatient.aspx` - Admin inpatient management

### Printing/Reports
- `patient_invoice_print.aspx` - Patient invoices
- `lab_result_print.aspx` - Lab results
- `visit_summary_print.aspx` - Visit summary
- `discharge_summary_print.aspx` - Discharge summary
- `pharmacy_invoice.aspx` - Pharmacy invoices

---

## 📊 Data Analysis Insights

### Current Data Status (from juba_clinick1.sql)

**Users in System:**
- Admins: 1 (admin/admin)
- Doctors: 5 active doctors
- Lab Users: 1 (mohamed/ali)
- Pharmacy Users: Present
- X-Ray Users: 2

**Patient Data:**
- Multiple patients registered
- Both outpatients and inpatients
- Sample data includes patients from 2024-2025

**Charges Configuration:**
- 5 charge types configured
- All active
- Prices set and ready to use

**Medicine Data:**
- Medicine catalog populated
- Units system implemented
- Inventory tracking active
- Cost and selling prices configured

**Lab Tests:**
- Comprehensive test catalog (65+ parameters)
- Test results recorded
- Reorder functionality available

**Financial Transactions:**
- Patient charges tracked
- Pharmacy sales recorded
- Profit/loss calculated
- Invoice numbers generated

---

## 🚀 System Capabilities

### ✅ Fully Implemented Features
1. **Multi-user role-based access control**
2. **Patient registration and management**
3. **Doctor prescription system**
4. **Laboratory test ordering and results**
5. **X-Ray ordering and image management**
6. **Pharmacy POS with inventory management**
7. **Inpatient/Outpatient management**
8. **Comprehensive billing system**
9. **Revenue reporting by department**
10. **Medicine expiry and stock alerts**
11. **Profit/loss tracking for pharmacy**
12. **Hospital branding/settings**
13. **Bed charge calculation**
14. **Delivery charge tracking**
15. **Payment method tracking**

### 🔄 Key Business Processes
1. **Patient Journey:** Registration → Consultation → Diagnosis (Lab/Xray) → Treatment → Billing
2. **Inventory Management:** Purchase → Stock → Sale → Profit Calculation
3. **Financial Tracking:** Charges → Payment → Invoice → Revenue Reports
4. **Inpatient Care:** Admission → Daily Bed Charges → Treatment → Discharge → Final Bill

---

## 🎯 System Strengths

1. **Comprehensive Coverage** - Covers all hospital departments
2. **Financial Tracking** - Detailed revenue and profit tracking
3. **Role-Based Security** - Proper user separation
4. **Flexible Charging** - Configurable charge types and amounts
5. **Inventory Management** - Full stock tracking with alerts
6. **Profit Analysis** - Cost vs selling price tracking
7. **Report Rich** - Multiple reports for different departments
8. **Audit Trail** - Date tracking on most tables

---

## 📝 Important Notes

1. **Password Security:** Passwords stored in plain text - security concern
2. **Data Relationships:** Most relationships are logical, not enforced by foreign keys
3. **Duplicate Columns:** Some tables have duplicate columns (e.g., pharmacy_sales_items)
4. **Status Codes:** Status values use integers (0, 1, 2, etc.) - documentation needed
5. **Invoice System:** Well-structured invoice numbering system
6. **Image Storage:** X-Ray images stored in database as VARBINARY

---

## 🔍 Quick Reference

### Common Status Values
- Patient Status: 0 = Active, 1 = Discharged
- Patient Type: 'outpatient', 'inpatient'
- Charge Paid: 0 = Unpaid, 1 = Paid
- Active/Inactive: BIT fields (0/1)

### Key IDs to Remember
- Registration charges: Patient ID based
- Lab charges: Prescription ID based
- Xray charges: Prescription ID based
- Pharmacy sales: Independent sale system
- Bed charges: Patient ID + Date based

---

This is your complete Juba Hospital Management System. It's a comprehensive, functional hospital management solution with patient care, laboratory, radiology, pharmacy, and financial management capabilities. The database is well-structured with proper separation of concerns across 27 tables supporting multiple user roles and complete hospital operations.
