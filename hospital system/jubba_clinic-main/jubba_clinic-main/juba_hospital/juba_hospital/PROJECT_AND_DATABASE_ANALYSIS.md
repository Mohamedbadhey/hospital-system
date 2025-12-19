# Juba Hospital Management System - Complete Analysis

## 🏥 Project Overview

**Project Name:** Juba Hospital Management System  
**Technology:** ASP.NET Web Forms (C#), .NET Framework 4.7.2  
**Database:** SQL Server (juba_clinick)  
**Architecture:** Traditional 3-tier architecture with code-behind pattern

---

## 📊 Database Structure

### Database Name: `juba_clinick`

The database contains **27 tables** organized into several functional modules:

### 1. **User Management Tables**

#### `admin` - System Administrators
- `userid` (PK, Identity)
- `username`, `password`
- Default user: admin/admin

#### `doctor` - Medical Doctors
- `doctorid` (PK, Identity)
- `doctorname`, `doctortitle`, `doctornumber`
- `usertypeid`, `username`, `password`

#### `registre` - Registration Staff
- `userid` (PK, Identity)
- `fullname`, `phone`, `username`, `password`, `usertypeid`

#### `lab_user` - Laboratory Staff
- `userid` (PK, Identity)
- `fullname`, `phone`, `username`, `password`

#### `xrayuser` - X-ray/Radiology Staff
- `userid` (PK, Identity)
- `username`, `password`, `phone`, `fullname`

#### `pharmacy_user` - Pharmacy Staff
- `userid` (PK, Identity)
- `fullname`, `phone`, `username`, `password`

#### `usertype` - User Role Types
- `usertypeid` (PK, Identity)
- `usertype` (varchar)
- Roles: 1=Doctor, 2=Lab, 3=Register, 4=Admin, 5=Xray, 6=Pharmacy

---

### 2. **Patient Management Tables**

#### `patient` - Core Patient Information
- `patientid` (PK, Identity)
- `full_name`, `dob`, `sex`, `location`, `phone`
- `date_registered` (datetime)
- `patient_status` (int) - 0=Active, 1=Discharged
- `patient_type` (varchar) - 'outpatient' or 'inpatient'
- `bed_admission_date` (datetime)
- `delivery_charge` (decimal)
- `amount` (float) - Registration fee

#### `prescribtion` - Medical Prescriptions/Visits
- `prescid` (PK, Identity) - Links patient visits
- `doctorid`, `patientid`
- `status` (int) - Lab test status
- `xray_status` (int) - X-ray status
- `lab_charge_paid`, `xray_charge_paid` (bit)

---

### 3. **Laboratory Management Tables**

#### `lab_test` - Ordered Lab Tests
- `med_id` (PK, Identity)
- `prescid` (FK to prescribtion)
- 60+ columns for different lab tests:
  - **Biochemistry:** LDL, HDL, Cholesterol, Triglycerides
  - **Liver Function:** SGPT, SGOT, ALP, Bilirubin, Albumin
  - **Renal Profile:** Urea, Creatinine, Uric acid
  - **Electrolytes:** Sodium, Potassium, Chloride, Calcium
  - **Hematology:** Hemoglobin, CBC, ESR, Blood grouping
  - **Immunology:** HIV, Hepatitis B/C, TPHA, Brucella
  - **Hormones:** Thyroid (T3, T4, TSH), Fertility profile (FSH, LH, Estradiol)
  - **Others:** Malaria, Blood sugar, Stool/Urine examination
- `date_taken` (datetime)
- `is_reorder` (bit) - For reordering tests

#### `lab_results` - Lab Test Results
- `lab_result_id` (PK, Identity)
- Same 60+ columns as lab_test for storing results
- `prescid` (FK to prescribtion)
- `lab_test_id` (FK to lab_test)
- `date_taken` (datetime)

---

### 4. **Radiology/X-ray Tables**

#### `xray` - Ordered X-ray Tests
- `xrayid` (PK, Identity)
- `xryname`, `xrydescribtion`
- `prescid` (FK to prescribtion)
- `date_taken` (date)
- `type` (varchar)

#### `xray_results` - X-ray Results/Images
- `xray_result_id` (PK, Identity)
- `xryimage` (varbinary(max)) - Stores image data
- `prescid` (FK to prescribtion)
- `date_taken` (date)
- `type` (varchar)

#### `presxray` - Links prescriptions to X-rays
- `prescxrayid` (PK, Identity)
- `xrayid`, `prescid`

---

### 5. **Medication Management Tables**

#### `medication` - Prescribed Medications
- `medid` (PK, Identity)
- `med_name`, `dosage`, `frequency`, `duration`
- `special_inst` (special instructions)
- `prescid` (FK to prescribtion)
- `date_taken` (date)

#### `medicine` - Medicine Master Data
- `medicineid` (PK, Identity)
- `medicine_name`, `generic_name`, `manufacturer`
- `unit_id` (FK to medicine_units)
- **Pricing:**
  - `price_per_tablet`, `price_per_strip`, `price_per_box`
  - `cost_per_tablet`, `cost_per_strip`, `cost_per_box`
- **Packaging:**
  - `tablets_per_strip`, `strips_per_box`
- `date_added` (datetime)

#### `medicine_inventory` - Stock Management
- `inventoryid` (PK, Identity)
- `medicineid` (FK to medicine)
- **Stock Levels:**
  - `total_strips`, `loose_tablets`, `total_boxes`
  - `primary_quantity`, `secondary_quantity`
- `unit_size` (float)
- `reorder_level_strips` (int)
- `expiry_date` (date)
- `batch_number`, `purchase_price`
- `date_added`, `last_updated` (datetime)

#### `medicine_units` - Unit Types (Tablet, Capsule, Syrup, etc.)
- `unit_id` (PK, Identity)
- `unit_name`, `unit_abbreviation`
- `selling_method` (varchar) - 'countable', 'measurable'
- `base_unit_name` (varchar) - 'piece', 'ml', 'gm'
- `subdivision_unit` (varchar) - 'strip', 'bottle'
- `allows_subdivision` (bit)
- `unit_size_label` (varchar)
- `is_active` (bit)
- `created_date` (datetime)

#### `medicine_dispensing` - Dispensing Records
- `dispenseid` (PK, Identity)
- `medid` (FK to medication)
- `medicineid` (FK to medicine)
- `quantity_dispensed` (int)
- `dispensed_by` (int) - User ID
- `dispense_date` (datetime)
- `status` (int)

---

### 6. **Pharmacy/Sales Tables**

#### `pharmacy_sales` - Sales Transactions
- `saleid` (PK, Identity)
- `invoice_number` (varchar)
- `customerid` (FK to pharmacy_customer, nullable)
- `customer_name` (varchar) - For walk-in customers
- `sale_date` (datetime)
- `total_amount`, `discount`, `final_amount` (float)
- `sold_by` (int) - User ID
- `payment_method` (varchar) - 'Cash', 'Credit', etc.
- `status` (int)
- `total_cost`, `total_profit` (float)

#### `pharmacy_sales_items` - Sales Line Items
- `sale_item_id` (PK, Identity)
- `saleid` (FK to pharmacy_sales)
- `medicineid` (FK to medicine)
- `inventoryid` (FK to medicine_inventory)
- `quantity_type` (varchar) - 'unit', 'strip', 'box'
- `quantity` (int)
- `unit_price`, `total_price` (float)
- `cost_price`, `profit` (float)

#### `pharmacy_customer` - Customer Information
- `customerid` (PK, Identity)
- `customer_name`, `phone`, `email`, `address`
- `date_registered` (datetime)

#### `vw_pharmacy_sales_with_profit` - View for Sales Reporting
- Aggregates sales data with profit calculations

---

### 7. **Financial/Charging System Tables**

#### `patient_charges` - All Patient Charges
- `charge_id` (PK, Identity)
- `patientid` (FK to patient)
- `prescid` (FK to prescribtion, nullable)
- `charge_type` (varchar) - 'Registration', 'Lab', 'Xray', 'Bed', 'Delivery'
- `charge_name` (varchar) - Description
- `amount` (float)
- `is_paid` (bit)
- `paid_date` (datetime)
- `paid_by` (int) - User ID
- `invoice_number` (varchar) - Format: TYPE-YYYYMMDD-PATIENTID
- `payment_method` (varchar) - 'Cash', 'Credit', etc.
- `reference_id` (int) - Links to specific service
- `date_added`, `last_updated` (datetime)

#### `patient_bed_charges` - Inpatient Bed Charges
- `bed_charge_id` (PK, Identity)
- `patientid` (FK to patient)
- `prescid` (FK to prescribtion, nullable)
- `charge_date` (date)
- `bed_charge_amount` (decimal)
- `is_paid` (bit)
- `created_at` (datetime)

#### `charges_config` - Charge Configuration
- `charge_config_id` (PK, Identity)
- `charge_type` (varchar)
- `charge_name` (varchar)
- `amount` (float) - Default amount
- `is_active` (bit)
- `date_added`, `last_updated` (datetime)

---

### 8. **System Configuration Tables**

#### `hospital_settings` - Hospital Information
- `id` (PK, Identity)
- `hospital_name` (nvarchar)
- `hospital_address`, `hospital_phone`, `hospital_email`
- `hospital_website` (nvarchar)
- `sidebar_logo_path` (nvarchar) - Logo for sidebar
- `print_header_logo_path` (nvarchar) - Logo for printed reports
- `print_header_text` (nvarchar) - Header text for reports
- `created_date`, `updated_date` (datetime)

---

### 9. **Legacy/Unused Tables**

#### `totalamount` - Appears to be legacy
- `taid` (PK), `prescxrayid`, `total`

---

## 🔄 Key Workflows

### 1. **Patient Registration Flow**
```
Registration Staff → Add Patient (patient table)
                  → Create charge (patient_charges: Registration fee)
                  → Patient gets patientid
```

### 2. **Outpatient Visit Flow**
```
Doctor → Create prescription (prescribtion table)
      → Order lab tests (lab_test table)
      → Order X-rays (xray table)
      → Prescribe medications (medication table)
      → Create charges (patient_charges: Lab, Xray fees)

Lab Staff → Enter results (lab_results table)
X-ray Staff → Upload images (xray_results table)
Pharmacy → Dispense medications (medicine_dispensing table)
```

### 3. **Inpatient Flow**
```
Registration Staff → Admit patient (patient_type = 'inpatient')
                  → Set bed_admission_date

Daily Process → Generate bed charges (patient_bed_charges table)

Doctor → Treat patient (same as outpatient)

Discharge → Update patient_status = 1
         → Calculate total charges
         → Process payment
```

### 4. **Pharmacy Sales Flow**
```
Pharmacy User → Create sale (pharmacy_sales table)
              → Add items (pharmacy_sales_items table)
              → Update inventory (medicine_inventory table)
              → Calculate profit (cost vs selling price)
```

---

## 💾 Connection String

Located in `Web.config`:

```xml
<connectionStrings>
    <!-- Local Development -->
    <add name="DBCS" 
         connectionString="Data Source=DESKTOP-GGE2JSJ\SQLEXPRESS;
                          Initial Catalog=juba_clinick;
                          Integrated Security=True;" />
    
    <!-- Production (hosted) -->
    <add name="DBCS6" 
         connectionString="Data Source=SQL5111.site4now.net;
                          Initial Catalog=db_aa5963_jubaclinick;
                          User Id=db_aa5963_jubaclinick_admin;
                          Password=moha12345" />
</connectionStrings>
```

**Note:** Your database is called `juba_clinick` (with underscore), not `juba_clinick1`.

---

## 🔐 User Roles and Access

| Role ID | Role Name | Default Redirect | Table |
|---------|-----------|------------------|-------|
| 1 | Doctor | assignmed.aspx | doctor |
| 2 | Lab | lab_waiting_list.aspx | lab_user |
| 3 | Register | Add_patients.aspx | registre |
| 4 | Admin | admin_dashbourd.aspx | admin |
| 5 | Xray | take_xray.aspx | xrayuser |
| 6 | Pharmacy | pharmacy_dashboard.aspx | pharmacy_user |

---

## 📁 Key Application Pages

### Registration Module
- `Add_patients.aspx` - Register new patients
- `patient_in.aspx` - Patient admission
- `register_inpatient.aspx` - Inpatient registration

### Doctor Module
- `assignmed.aspx` - Assign medications/tests
- `waitingpatients.aspx` - View waiting patients
- `doctor_inpatient.aspx` - Manage inpatients
- `registre_discharged.aspx` - View discharged patients

### Lab Module
- `lab_waiting_list.aspx` - Pending lab tests
- `take_lab_test.aspx` - Enter lab results
- `lap_operation.aspx` - Lab operations
- `lap_processed.aspx` - Processed tests

### X-ray Module
- `pending_xray.aspx` - Pending X-rays
- `take_xray.aspx` - Upload X-ray images
- `xray_processed.aspx` - Processed X-rays

### Pharmacy Module
- `pharmacy_dashboard.aspx` - Pharmacy dashboard
- `pharmacy_pos.aspx` - Point of Sale
- `mobile_pos.aspx` - Mobile POS
- `medicine_inventory.aspx` - Inventory management
- `add_medicine.aspx` - Add new medicines
- `dispense_medication.aspx` - Dispense to patients

### Admin Module
- `admin_dashbourd.aspx` - Admin dashboard
- `manage_charges.aspx` - Manage charges configuration
- `hospital_settings.aspx` - Hospital settings
- `financial_reports.aspx` - Financial reports

### Reporting
- `patient_report.aspx` - Patient reports
- `medication_report.aspx` - Medication reports
- `lab_comprehensive_report.aspx` - Lab reports
- `pharmacy_sales_reports.aspx` - Sales reports
- `revenue_dashboard.aspx` - Revenue dashboard

---

## 🎯 Key Features

### 1. **Multi-User System**
- Role-based access control
- Separate interfaces for each department
- Session-based authentication

### 2. **Comprehensive Patient Management**
- Outpatient and Inpatient tracking
- Patient history
- Discharge management

### 3. **Integrated Charging System**
- Automated charge generation
- Multiple payment methods
- Invoice generation
- Revenue tracking by department

### 4. **Laboratory Management**
- 60+ different lab test types
- Result entry and tracking
- Lab test reordering capability

### 5. **Pharmacy/POS System**
- Medicine inventory management
- Multiple unit types (tablets, strips, boxes, liquids)
- Cost and profit tracking
- Barcode support
- Low stock alerts
- Expiry date tracking

### 6. **Reporting System**
- Patient reports
- Financial reports
- Revenue reports by department
- Pharmacy sales reports with profit analysis
- Lab reports

### 7. **Hospital Branding**
- Customizable hospital settings
- Logo management for UI and printed reports
- Professional invoice/report printing

---

## 🔧 Technical Details

### Framework
- ASP.NET Web Forms 4.7.2
- C# code-behind pattern
- SQL Server database

### Libraries/Packages
- jQuery 3.4.1
- Bootstrap 3.4.1
- DataTables (for data grids)
- SweetAlert2 (for alerts)
- WebGrease (optimization)
- Newtonsoft.Json (JSON handling)

### Master Pages
- `Site.Master` - Main site layout
- `Admin.Master` - Admin interface
- `doctor.Master` - Doctor interface
- `register.Master` - Registration interface
- `pharmacy.Master` - Pharmacy interface
- `labtest.Master` - Lab interface
- `xray.Master` - X-ray interface

---

## 📈 Business Logic Highlights

### Revenue Sources
1. **Registration Fees** - Patient registration charges
2. **Lab Tests** - Individual lab test charges
3. **X-ray Services** - Radiology charges
4. **Inpatient Bed Charges** - Daily bed charges
5. **Delivery Services** - Maternity charges
6. **Pharmacy Sales** - Medicine sales with profit tracking

### Charge Types
- `Registration` - Initial patient registration
- `Lab` - Laboratory test charges
- `Xray` - X-ray/radiology charges
- `Bed` - Inpatient bed charges (daily)
- `Delivery` - Delivery/maternity charges

### Invoice Format
- Registration: `REG-YYYYMMDD-PATIENTID`
- Lab: `LAB-YYYYMMDD-PATIENTID`
- X-ray: `XRAY-YYYYMMDD-PATIENTID`
- Pharmacy: `INV-YYYYMMDD-HHMMSS`

---

## 🚀 Recent Enhancements

Based on the documentation files, the system has been enhanced with:

1. ✅ Hospital settings management
2. ✅ Professional printed reports with hospital branding
3. ✅ Inpatient bed charge tracking
4. ✅ Delivery charge management
5. ✅ Enhanced pharmacy POS with profit tracking
6. ✅ Lab test reordering system
7. ✅ Medicine unit system with flexible selling methods
8. ✅ Cost and profit tracking for pharmacy
9. ✅ Comprehensive financial reporting
10. ✅ Patient status tracking (active/discharged)

---

## 📝 Sample Data

The database includes sample data for:
- Default admin user (admin/admin)
- Lab test configurations
- Medicine units (Tablet, Capsule, Syrup, Injection, etc.)
- Patient records
- Lab results
- Prescriptions
- Pharmacy sales

---

## 🔍 Important Notes

1. **Database Name**: `juba_clinick` (not juba_clinick1)
2. **Active Connection**: Uses "DBCS" connection string for local development
3. **Security**: Passwords are stored in plain text (consider encryption in production)
4. **Session Management**: Uses ASP.NET sessions for authentication
5. **File Uploads**: Supports X-ray image storage in database (varbinary)

---

## 📚 Documentation Available

The project includes extensive documentation:
- Project overviews and understanding documents
- Implementation guides for various features
- Database migration scripts
- User guides for different modules
- Troubleshooting guides
- Quick start guides

---

## Next Steps / Recommendations

1. **Security**: Implement password hashing
2. **Backup**: Regular database backups
3. **Testing**: Test all modules thoroughly
4. **Documentation**: Keep user manuals updated
5. **Training**: Train staff on each module

---

*Last Updated: December 2025*
