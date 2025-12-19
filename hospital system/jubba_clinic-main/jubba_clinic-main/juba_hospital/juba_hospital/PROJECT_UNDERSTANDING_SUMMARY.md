# Juba Hospital Management System - Project Understanding Summary

## 📋 Executive Summary

**Project Name:** Juba Hospital Management System  
**Database Name:** `juba_clinick` (as defined in juba_clinick1.sql)  
**Technology Stack:** ASP.NET Web Forms (.NET Framework 4.7.2) + SQL Server  
**Type:** Healthcare Management System with multiple modules  

---

## 🏥 System Overview

This is a comprehensive hospital management system designed for **V-Afmadow Hospital** in Kismayo, Somalia. The system manages the complete patient care cycle from registration through discharge, including clinical, laboratory, radiology, pharmacy, and administrative functions.

---

## 🗄️ Database Structure (juba_clinick1.sql)

### Core Tables (27 tables total)

#### 1. **User Management Tables**
- `admin` - System administrators (username: admin, password: admin)
- `doctor` - Doctors with specialties and credentials
- `lab_user` - Laboratory technicians
- `xrayuser` - X-ray technicians
- `pharmacy_user` - Pharmacy staff
- `registre` - Registration desk staff
- `usertype` - User role definitions (1=Doctor, 2=Lab, 3=Register, 4=Admin, 5=Xray, 6=Pharmacy)

#### 2. **Patient Management**
- `patient` - Core patient information
  - Fields: patientid, full_name, dob, sex, location, phone, date_registered
  - `patient_status`: 0=Outpatient, 1=Inpatient
  - `patient_type`: 'outpatient' or 'inpatient'
  - `bed_admission_date`: Date admitted for inpatients
  - `delivery_charge`: For maternity cases

#### 3. **Medical Workflow**
- `prescribtion` (prescription) - Links doctor, patient, and services
  - `status`: Lab test status (0-5)
  - `xray_status`: X-ray status
  - `lab_charge_paid`: Payment tracking
  - `xray_charge_paid`: Payment tracking

- `medication` - Prescribed medications
  - Fields: med_name, dosage, frequency, duration, special_inst
  
- `lab_test` - Laboratory test orders (60+ test types)
  - Comprehensive tests: Biochemistry, Hematology, Immunology, Hormones, etc.
  - `is_reorder`: For repeat tests
  - `reorder_reason`: Why test is being repeated
  
- `lab_results` - Laboratory test results (mirrors lab_test structure)

- `xray` - X-ray orders
- `xray_results` - X-ray images and reports (stores varbinary data)
- `presxray` - Links prescriptions to x-rays

#### 4. **Pharmacy Module**
- `medicine` - Medicine catalog
  - Multi-level pricing: per_tablet, per_strip, per_box
  - Cost tracking: cost_per_tablet, cost_per_strip, cost_per_box
  
- `medicine_units` - Unit types (Tablet, Capsule, Syrup, Injection, etc.)
  - 25+ predefined units
  - Supports subdivisions (e.g., tablets per strip)
  
- `medicine_inventory` - Stock management
  - Tracks: total_strips, loose_tablets, total_boxes
  - Reorder levels and batch tracking
  - `primary_quantity`, `secondary_quantity`, `unit_size`
  
- `medicine_dispensing` - Medication dispensing records

- `pharmacy_sales` - Sales transactions
  - Invoice tracking, discounts, payment methods
  - Profit tracking: `total_cost`, `total_profit`
  
- `pharmacy_sales_items` - Individual items in each sale
  - Quantity, prices, cost, profit per item
  
- `pharmacy_customer` - Customer database

- **View:** `vw_pharmacy_sales_with_profit` - Aggregated sales with profit calculations

#### 5. **Financial Management**
- `patient_charges` - All patient charges
  - Types: Registration, Lab, Xray, Bed, Delivery
  - `is_paid`, `paid_date`, `payment_method`
  - Invoice tracking with reference_id
  
- `patient_bed_charges` - Specific tracking for inpatient bed charges
  - Daily bed charges for admitted patients
  
- `charges_config` - Configurable charge amounts
  - Current charges:
    - Registration: $10
    - Lab: $15
    - X-ray: $150
    - Bed (per night): $3
    - Delivery: $10

- `totalamount` - Legacy total amount tracking

#### 6. **System Configuration**
- `hospital_settings` - Hospital information
  - Name: "v-afmadow hospital"
  - Location: Kismayo, Somalia
  - Logo paths for sidebar and print headers
  - Contact information

---

## 👥 User Roles & Access

### 1. **Admin** (Role ID: 4)
- **Login:** username: admin, password: admin
- **Dashboard:** admin_dashbourd.aspx
- **Capabilities:**
  - View all reports and analytics
  - Manage system configuration
  - Manage users (add doctors, lab staff, pharmacy staff, etc.)
  - Access financial reports
  - Manage charges configuration
  - Oversee inpatient/outpatient operations

### 2. **Registration Staff** (Role ID: 3)
- **Landing Page:** Add_patients.aspx
- **Capabilities:**
  - Register new patients (outpatient/inpatient)
  - Update patient information
  - Process registration fees
  - Generate patient invoices
  - View patient history

### 3. **Doctor** (Role ID: 1)
- **Landing Page:** assignmed.aspx
- **Capabilities:**
  - View waiting patients
  - Create prescriptions
  - Order lab tests (60+ test types)
  - Order x-rays
  - Prescribe medications
  - Manage inpatient care
  - Track patient status

### 4. **Lab Technician** (Role ID: 2)
- **Landing Page:** lab_waiting_list.aspx
- **Capabilities:**
  - View pending lab tests
  - Enter lab results
  - Print lab reports
  - Mark tests as completed
  - Track lab test reorders

### 5. **X-ray Technician** (Role ID: 5)
- **Landing Page:** take_xray.aspx
- **Capabilities:**
  - View pending x-ray orders
  - Upload x-ray images
  - Add x-ray reports
  - Mark x-rays as completed

### 6. **Pharmacy Staff** (Role ID: 6)
- **Landing Page:** pharmacy_dashboard.aspx
- **Capabilities:**
  - Point of Sale (POS) system
  - Dispense medications
  - Manage inventory
  - Track stock levels
  - Generate pharmacy reports
  - Process sales with profit tracking

---

## 🔄 Patient Flow Workflows

### Outpatient Flow
1. **Registration** → Patient registered at registration desk
2. **Payment** → Registration fee charged ($10)
3. **Doctor Consultation** → Doctor sees patient, creates prescription
4. **Lab Tests** (if ordered) → Lab conducts tests, payment ($15)
5. **X-rays** (if ordered) → X-ray performed, payment ($150)
6. **Medication** (if prescribed) → Pharmacy dispenses medication
7. **Checkout** → Patient receives invoice and leaves

### Inpatient Flow
1. **Admission** → Patient admitted as inpatient
2. **Bed Assignment** → Patient assigned to bed
3. **Daily Bed Charges** → Automatic daily charges ($3/night)
4. **Medical Care** → Doctor provides ongoing care
5. **Lab/X-ray** → Services as needed
6. **Medication** → Medications dispensed
7. **Delivery Charges** (if maternity) → Delivery fee ($10)
8. **Discharge** → Patient discharged with summary
9. **Final Payment** → All charges settled

---

## 💰 Revenue Tracking System

The system tracks revenue from multiple sources:

### Revenue Sources
1. **Registration Fees** - $10 per patient
2. **Lab Tests** - $15 per test
3. **X-ray Imaging** - $150 per x-ray
4. **Bed Charges** - $3 per night (inpatients)
5. **Delivery Charges** - $10 per delivery
6. **Pharmacy Sales** - Variable pricing with profit tracking

### Financial Reports Available
- `registration_revenue_report.aspx` - Registration income
- `lab_revenue_report.aspx` - Lab test revenue
- `xray_revenue_report.aspx` - X-ray revenue
- `bed_revenue_report.aspx` - Bed charges revenue
- `delivery_revenue_report.aspx` - Delivery revenue
- `pharmacy_revenue_report.aspx` - Pharmacy sales and profit
- `pharmacy_sales_reports.aspx` - Detailed pharmacy analytics
- `financial_reports.aspx` - Comprehensive financial overview

---

## 📊 Key Features & Modules

### 1. Patient Management
- Patient registration (inpatient/outpatient)
- Patient search and history
- Patient status tracking
- Demographics and contact info

### 2. Doctor Module
- Waiting list management
- Prescription creation
- Lab test ordering (60+ tests)
- X-ray ordering
- Medication prescription
- Inpatient management
- Patient history review

### 3. Laboratory Module
- Comprehensive test catalog:
  - **Biochemistry**: Lipid profile, Liver function, Renal profile, Electrolytes
  - **Hematology**: Hemoglobin, CBC, Blood grouping, Malaria
  - **Immunology**: HIV, Hepatitis B/C, TPHA, Brucella
  - **Hormones**: Thyroid profile, Fertility profile
  - **Clinical Path**: Urine, Stool, Sperm examination
  - **Diabetes**: FBS, HbA1c
- Result entry and reporting
- Lab reference guide
- Test reordering capability

### 4. Radiology (X-ray) Module
- X-ray ordering
- Image upload (varbinary storage)
- X-ray report generation
- Pending/completed tracking

### 5. Pharmacy Module
- **Point of Sale (POS)**
  - Multi-unit sales (tablets, strips, boxes)
  - Discount management
  - Multiple payment methods
  - Invoice generation
  
- **Inventory Management**
  - Stock tracking (25+ medicine units)
  - Reorder level alerts
  - Batch and expiry tracking
  - Low stock warnings
  
- **Medicine Management**
  - Add/edit medicines
  - Multi-level pricing
  - Cost and profit tracking
  - Generic names and manufacturers
  
- **Sales Analytics**
  - Sales history
  - Profit/loss reports
  - Best-selling items
  - Revenue trends

### 6. Inpatient Management
- Bed admission tracking
- Daily bed charge calculation
- Discharge summary generation
- Length of stay tracking
- Total cost calculation

### 7. Charging & Billing System
- Configurable charge amounts
- Automatic charge generation
- Payment tracking (paid/unpaid)
- Invoice generation
- Payment methods (Cash, Insurance, etc.)
- Charge history by patient

### 8. Reporting & Analytics
- Patient reports (inpatient/outpatient)
- Revenue reports by service type
- Comprehensive financial reports
- Lab test statistics
- Pharmacy sales analysis
- Bed occupancy reports

---

## 🛠️ Technical Architecture

### Backend
- **Framework:** ASP.NET Web Forms (.NET 4.7.2)
- **Language:** C# (Code-behind pattern)
- **Database:** SQL Server (Express or Full)
- **Connection String:** Configured in Web.config as "DBCS"
- **ORM:** ADO.NET (SqlConnection, SqlCommand, SqlDataReader)

### Frontend
- **UI Framework:** Bootstrap 3.4.1
- **Admin Template:** Kaiadmin (custom hospital theme)
- **JavaScript Libraries:**
  - jQuery 3.4.1
  - DataTables (for grid displays)
  - SweetAlert2 (for notifications)
- **Icons:** Font Awesome, Simple Line Icons
- **Responsive:** Mobile-friendly design

### Master Pages
- `Site.Master` - Basic site layout
- `Admin.Master` - Admin dashboard layout
- `doctor.Master` - Doctor dashboard layout
- `register.Master` - Registration desk layout
- `labtest.Master` - Lab technician layout
- `xray.Master` - X-ray technician layout
- `pharmacy.Master` - Pharmacy layout
- `homepage.master` - Public homepage

### Key Helper Classes
- `HospitalSettingsHelper.cs` - Retrieves hospital settings
- `BedChargeCalculator.cs` - Calculates bed charges for inpatients

---

## 📁 Important Files & Directories

### Main Application Pages (100+ ASPX files)
Key pages include:
- `login.aspx` - User authentication
- `Add_patients.aspx` - Patient registration
- `assignmed.aspx` - Doctor's prescription page
- `lab_waiting_list.aspx` - Lab pending tests
- `pharmacy_pos.aspx` - Pharmacy point of sale
- `admin_dashbourd.aspx` - Admin dashboard
- `financial_reports.aspx` - Financial analytics

### Assets
- `/assets/css/` - Stylesheets (Bootstrap, Kaiadmin theme)
- `/assets/js/` - JavaScript files
- `/assets/img/` - Images and logos
- `/assets/fonts/` - Font files

### Documentation (90+ MD files)
Extensive documentation covering:
- Implementation guides
- Feature explanations
- Database schemas
- Troubleshooting guides
- Enhancement plans

---

## 🔐 Security Considerations

### Current Implementation
- Plain text password storage (⚠️ Security risk)
- Session-based authentication
- Role-based access control
- SQL parameters used (prevents SQL injection)

### Recommendations
- Implement password hashing (bcrypt/PBKDF2)
- Add password complexity requirements
- Implement session timeout
- Add audit logging
- Enable HTTPS
- Add CAPTCHA for login
- Implement account lockout after failed attempts

---

## 📈 Database Statistics (from juba_clinick1.sql)

### Sample Data Loaded
- **Admin Users:** 1 (admin/admin)
- **Doctors:** 5 doctors with various specialties
- **Patients:** 25+ patient records
- **Prescriptions:** 48+ prescription records
- **Lab Tests:** 70+ lab test orders
- **Lab Results:** 35+ completed lab results
- **Medications:** 47+ medication records
- **Medicines:** 10+ medicines in catalog
- **Medicine Units:** 25+ unit types
- **Pharmacy Sales:** 18+ sales transactions
- **Patient Charges:** 80+ charge records
- **Charges Config:** 5 active charge types

### Key Identities
- Patient IDs: Starting from 1025 (currently at ~1048)
- Prescription IDs: Matching patient IDs (prescid = patientid)
- Medicine IDs: Sequential from 1
- Sale IDs: Sequential from 1

---

## 🎯 System Strengths

1. **Comprehensive Coverage** - Covers entire hospital workflow
2. **Multi-Role Support** - 6 distinct user roles
3. **Financial Tracking** - Detailed revenue and profit tracking
4. **Pharmacy POS** - Full-featured point of sale with inventory
5. **Extensive Lab Tests** - 60+ laboratory test types
6. **Inpatient Management** - Robust admission/discharge system
7. **Reporting** - Multiple revenue and operational reports
8. **Flexible Charging** - Configurable charge amounts
9. **Invoice System** - Professional invoice generation
10. **Well Documented** - Extensive markdown documentation

---

## 🔧 System Requirements

### Server Requirements
- Windows Server 2012 R2 or higher
- IIS 8.0 or higher
- .NET Framework 4.7.2
- SQL Server 2012 or higher (Express Edition acceptable)
- Minimum 4GB RAM
- 20GB disk space

### Client Requirements
- Modern web browser (Chrome, Firefox, Edge)
- JavaScript enabled
- Minimum 1024x768 screen resolution
- Internet connection (for local network deployment)

---

## 🚀 Getting Started

### Database Setup
1. Open SQL Server Management Studio
2. Execute `juba_clinick1.sql` script
3. Database `juba_clinick` will be created with all tables and sample data

### Application Configuration
1. Update `Web.config` connection string:
   ```xml
   <add name="DBCS" connectionString="Data Source=YOUR_SERVER;Initial Catalog=juba_clinick;Integrated Security=True;" />
   ```

2. Build solution in Visual Studio
3. Deploy to IIS or run via Visual Studio (F5)

### Default Login Credentials
- **Admin:** username: `admin`, password: `admin`
- **Doctor:** username: `omar`, password: `1234`
- **Lab User:** username: `ali`, password: `ali`

---

## 📞 Hospital Information (from database)

- **Name:** v-afmadow hospital
- **Location:** Kismayo, Somalia
- **Phone:** +252-4544
- **Email:** info@jubbahospital.com
- **Website:** www.jubbahospital.com

---

## 🎨 User Interface Features

### Common Features Across Modules
- DataTables with search, sort, pagination
- SweetAlert2 for user notifications
- Print functionality for reports/invoices
- Date pickers for date inputs
- Real-time data updates
- Responsive mobile layout
- Professional print layouts with hospital headers

### Dashboard Widgets
- Total patients count
- Active inpatients
- Pending lab tests
- Pending x-rays
- Revenue summaries
- Low stock alerts (pharmacy)

---

## 💡 Best Practices Implemented

1. **Separation of Concerns** - Code-behind pattern
2. **Parameterized Queries** - SQL injection prevention
3. **Master Pages** - Consistent layout across roles
4. **Session Management** - User state tracking
5. **Invoice Numbering** - Unique invoice formats (REG-, LAB-, XRAY-, etc.)
6. **Audit Trail** - Date tracking (date_added, last_updated)
7. **Soft Deletes** - Status flags instead of hard deletes
8. **Configurable Settings** - charges_config, hospital_settings

---

## 📚 Additional Resources

Your project includes extensive documentation:
- Implementation guides for each module
- Database migration scripts
- Feature enhancement plans
- Troubleshooting guides
- Visual diagrams and workflows
- Medicine units guide (English & Somali)
- Cost and profit tracking guides

---

## 🎓 Understanding the Prescription Flow

The `prescribtion` table is central to the system workflow:

```
Patient → Prescription → Lab Tests/X-rays/Medications
```

- Each patient visit creates a prescription record
- `prescid` links to lab_test, xray, medication tables
- Status codes track progress through the system
- Charges are linked to prescriptions

---

## 🏁 Conclusion

This is a well-architected, feature-rich hospital management system designed specifically for healthcare delivery in a resource-constrained environment. The system balances functionality with simplicity, making it suitable for hospitals with varying levels of technical expertise.

The database (`juba_clinick1.sql`) is production-ready with comprehensive schema, sample data, and proper indexing. The application layer is built with ASP.NET Web Forms, providing a familiar development environment with extensive customization capabilities.

**Key Takeaway:** This system successfully manages patient care from registration through discharge, tracks revenue across all departments, and provides the reporting necessary for effective hospital management.

---

*Document Generated: December 2025*  
*Database Version: juba_clinick1.sql (12/1/2025)*  
*Application Version: ASP.NET 4.7.2*
