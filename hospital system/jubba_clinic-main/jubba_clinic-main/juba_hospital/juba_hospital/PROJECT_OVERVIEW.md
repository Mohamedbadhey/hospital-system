# Juba Hospital Management System - Project Overview

## 🏥 System Description

**Juba Hospital Management System** is a comprehensive web-based hospital management application built with **ASP.NET Web Forms** (C# .NET Framework 4.7.2) and **SQL Server**. It manages patient registration, doctor consultations, lab tests, X-ray imaging, pharmacy operations, and financial reporting.

---

## 🏗️ Technology Stack

### Frontend
- **ASP.NET Web Forms** with Master Pages
- **Bootstrap 3.4.1** for responsive UI
- **jQuery 3.4.1** for client-side interactivity
- **DataTables** for data grid management
- **SweetAlert2** for user notifications
- **AJAX/WebMethods** for asynchronous operations

### Backend
- **C# / ASP.NET Web Forms** (.NET Framework 4.7.2)
- **ADO.NET** with SqlConnection/SqlCommand for database access
- **WebMethods** for AJAX endpoints
- **Session-based authentication** (no ASP.NET Identity)

### Database
- **SQL Server** (SQL Express compatible)
- Database: `juba_clinick`
- Connection strings configured in `Web.config`

### Development Tools
- **Visual Studio** (2017 or later recommended)
- **SQL Server Management Studio**
- **IIS / IIS Express** for hosting

---

## 👥 User Roles & Access

The system supports **6 user roles**, each with specific dashboards and workflows:

| Role ID | Role Name | Landing Page | Primary Functions |
|---------|-----------|--------------|-------------------|
| 1 | **Doctor** | `assignmed.aspx` | View patients, write prescriptions, order lab/X-ray tests |
| 2 | **Lab Technician** | `lab_waiting_list.aspx` | Process lab tests, enter results, print reports |
| 3 | **Registration Clerk** | `Add_patients.aspx` | Register patients, manage patient records |
| 4 | **Admin** | `admin_dashbourd.aspx` | System configuration, user management, reports, revenue tracking |
| 5 | **X-ray Technician** | `take_xray.aspx` | Process X-ray orders, upload images, enter findings |
| 6 | **Pharmacy Staff** | `pharmacy_dashboard.aspx` | Manage inventory, dispense medications, POS sales |

### Login System
- **File**: `login.aspx` / `login.aspx.cs`
- **Authentication**: Username/password (plain text storage - security consideration)
- **Session Variables**: `UserId`, `UserName`, `role_id`, `id`, `admin_id`

---

## 📊 Core Database Tables

### User Management
- `admin` - Administrator accounts
- `doctor` - Doctor profiles
- `registre` - Registration clerk accounts
- `lab_user` - Lab technician accounts
- `xrayuser` - X-ray technician accounts
- `pharmacy_user` - Pharmacy staff accounts
- `usertype` - User role definitions

### Patient Management
- `patient` - Patient demographics and registration
- `prescribtion` - Doctor prescriptions (links patients to doctors)
- `medication` - Prescribed medications
- `patient_charges` - Financial charges (Registration, Lab, X-ray)

### Lab Module
- `lab` - Lab test definitions
- `lab_test` - Ordered lab tests
- `lab_results` - Lab test results (comprehensive fields for all test types)
- `add_lab_charges` - Lab test pricing

### X-ray Module
- `xray` - X-ray test definitions
- `presxray` - Ordered X-ray tests
- `xray_results` - X-ray findings and uploaded images
- `add_xray_charges` - X-ray test pricing

### Pharmacy Module
- `medicine` - Medicine master data (with cost/selling price tracking)
- `medicine_units` - Unit types (Tablet, Syrup, Injection, etc.) with selling methods
- `medicine_inventory` - Stock management with batch/expiry tracking
- `pharmacy_sales` - Sales transactions
- `pharmacy_sales_items` - Sales line items with profit tracking
- `pharmacy_customer` - Customer records
- `medicine_dispensing` - Medication dispensing to inpatients

### Financial System
- `patient_charges` - All patient charges (Registration, Lab, X-ray, Bed)
- `charges_config` - Configurable charge definitions
- `hospital_settings` - System-wide settings (hospital name, registration fee, etc.)

---

## 🔄 Core Workflows

### 1. Patient Registration Flow
1. **Registration Clerk** → `Add_patients.aspx`
2. Enter patient details (name, DOB, phone, location, sex)
3. Assign patient status (Outpatient = 0, Inpatient = 1)
4. System auto-generates patient ID
5. Registration charge automatically created in `patient_charges`
6. Patient appears in doctor's waiting list

### 2. Doctor Consultation Flow
1. **Doctor** → `assignmed.aspx` (view waiting patients)
2. Click patient → Opens prescription form
3. Write prescription with medications (name, dosage, frequency, duration)
4. Order lab tests (checkboxes for various test types)
5. Order X-rays (checkboxes for X-ray types)
6. Save prescription → Patient status updates
7. Lab/X-ray charges automatically added to `patient_charges`

### 3. Lab Test Processing Flow
1. **Lab Technician** → `lab_waiting_list.aspx`
2. View patients with pending lab orders
3. Click "Process" → `lap_operation.aspx`
4. Enter test results (extensive form with all test parameters)
5. Save results → Status updates to "Processed"
6. Print lab report → `lab_result_print.aspx`

### 4. X-ray Processing Flow
1. **X-ray Technician** → `pending_xray.aspx`
2. View patients with pending X-ray orders
3. Click "Take X-ray" → `take_xray.aspx`
4. Upload X-ray images (JPG/PNG)
5. Enter radiologist findings
6. Save → Status updates, images stored in database
7. Print X-ray report

### 5. Pharmacy POS Flow
1. **Pharmacy Staff** → `pharmacy_pos.aspx`
2. Select customer (walk-in or registered patient)
3. Search and add medicines to cart
4. System supports **unit-based selling**:
   - **Tablets/Capsules**: Sell by piece, strip, or box
   - **Syrups/Liquids**: Sell by volume (ml) or bottle
   - **Injections**: Sell by vial
5. Apply discounts (optional)
6. Complete sale → Updates inventory, calculates profit
7. Print invoice → `pharmacy_invoice.aspx`

### 6. Inpatient Medication Dispensing
1. **Pharmacy Staff** → `dispense_medication.aspx`
2. View inpatients with pending medication orders
3. Select medication from prescription
4. Dispense from inventory → Updates stock
5. Records dispensing date and staff

---

## 💰 Financial & Reporting System

### Revenue Tracking
- **Patient Charges**: Registration, Lab, X-ray, Bed charges
- **Pharmacy Sales**: Direct sales with cost/profit tracking
- **Payment Status**: Tracks paid/unpaid charges with payment method
- **Invoice System**: Auto-generated invoice numbers (REG-YYYYMMDD-ID, LAB-YYYYMMDD-ID, etc.)

### Reports Available
1. **Admin Dashboard** (`admin_dashbourd.aspx`)
   - Today's total revenue (all departments)
   - Breakdown: Registration, Lab, X-ray, Pharmacy
   - Inpatient/Outpatient counts
   - Doctor count

2. **Financial Reports** (`financial_reports.aspx`)
   - Date range filtering
   - Department-wise revenue

3. **Pharmacy Reports**
   - Sales history (`pharmacy_sales_history.aspx`)
   - Revenue report (`pharmacy_revenue_report.aspx`)
   - Profit tracking (`pharmacy_sales_reports.aspx`)
   - Low stock alerts (`low_stock.aspx`)
   - Expired medicines (`expired_medicines.aspx`)

4. **Lab Revenue Report** (`lab_revenue_report.aspx`)
5. **X-ray Revenue Report** (`xray_revenue_report.aspx`)
6. **Registration Revenue Report** (`registration_revenue_report.aspx`)

### Charge Management
- **Admin** → `manage_charges.aspx`
- Configure charges for different services
- Set default registration fee in `hospital_settings`

---

## 🎨 Master Pages (UI Templates)

| Master Page | Used By | Purpose |
|-------------|---------|---------|
| `Site.Master` | Public pages | Default site layout |
| `Admin.Master` | Admin users | Admin dashboard and management |
| `doctor.Master` | Doctors | Doctor workflow pages |
| `register.Master` | Registration clerks | Patient registration pages |
| `labtest.Master` | Lab technicians | Lab test processing |
| `xray.Master` | X-ray technicians | X-ray processing |
| `pharmacy.Master` | Pharmacy staff | Pharmacy operations |
| `homepage.master` | Home page | Landing page layout |

---

## 📁 Key Files & Their Purpose

### Core Configuration
- `Web.config` - Database connections, app settings, compilation
- `Global.asax.cs` - Application startup, routing, bundles
- `Bundle.config` - CSS/JS bundling configuration

### Helper Classes
- `HospitalSettingsHelper.cs` - Retrieves hospital settings from database
- `BedChargeCalculator.cs` - Calculates bed charges for inpatients

### Database Scripts
- `juba.sql` - Complete database schema with sample data
- `charges_management_database.sql` - Charges system tables
- `pharmacy_pos_database.sql` - Pharmacy module tables
- `unit_selling_methods_schema.sql` - Medicine unit selling system

### Documentation Files (Many!)
- `PROJECT_ANALYSIS_REPORT.md` - Comprehensive system analysis
- `COMPLETE_SYSTEM_REPORT.md` - Detailed system documentation
- `PHARMACY_MODULE_SUMMARY.md` - Pharmacy module specifics
- `IMPORTANT_SETUP_INSTRUCTIONS.md` - Setup guide for unit-based selling
- `REVENUE_SYSTEM_QUICK_START.md` - Financial system guide
- Various fix guides and implementation docs

---

## 🔧 Recent Enhancements & Fixes

### ✅ Implemented Features
1. **Unit-Based Selling System**
   - Dynamic selling methods per medicine type
   - Supports tablets, syrups, injections, creams, etc.
   - Automatic price calculation based on subdivisions

2. **Cost & Profit Tracking**
   - Cost price vs. selling price tracking
   - Profit calculation per sale
   - Profit reports and analytics

3. **Charges Management System**
   - Configurable charges for services
   - Payment status tracking
   - Multiple payment methods (Cash, Credit Card, Insurance)

4. **Invoice System**
   - Patient invoice printing
   - Pharmacy sales invoices
   - Lab and X-ray result printing

5. **Hospital Settings**
   - Configurable hospital information
   - Default charge rates
   - System-wide parameters

### 📋 Known Issues & Considerations
1. **Security**: Passwords stored in plain text (needs hashing)
2. **Authorization**: Basic role-based access (no fine-grained permissions)
3. **Data Validation**: Limited server-side validation
4. **Error Handling**: Basic try-catch blocks (needs improvement)
5. **Concurrency**: No optimistic concurrency control
6. **Audit Trail**: Limited logging of user actions

---

## 🚀 Getting Started

### Prerequisites
1. Visual Studio 2017 or later
2. SQL Server 2016 or later (or SQL Express)
3. .NET Framework 4.7.2
4. IIS Express (included with Visual Studio)

### Setup Steps
1. **Clone/Extract Project**
   - Extract to a folder (e.g., `C:\Projects\juba_hospital`)

2. **Database Setup**
   - Open SQL Server Management Studio
   - Create database: `juba_clinick`
   - Execute `juba.sql` to create schema and sample data
   - Run additional scripts as needed:
     - `charges_management_database.sql`
     - `pharmacy_pos_database.sql`
     - `unit_selling_methods_schema.sql`

3. **Configure Connection String**
   - Open `Web.config`
   - Update `DBCS` connection string with your SQL Server instance:
     ```xml
     <add name="DBCS" 
          connectionString="Data Source=YOUR_SERVER;Initial Catalog=juba_clinick;Integrated Security=True;" />
     ```

4. **Build Solution**
   - Open `juba_hospital.sln` in Visual Studio
   - Build → Build Solution (Ctrl+Shift+B)
   - Resolve any NuGet package issues

5. **Run Application**
   - Press F5 to run with debugging
   - Default URL: `http://localhost:[port]/login.aspx`

6. **Test Login**
   - Default admin: username `admin`, password `admin`
   - Create other users through Admin panel

### Configuration Checklist
- [ ] Database created and schema loaded
- [ ] Connection string updated
- [ ] Solution builds without errors
- [ ] Login page loads
- [ ] Can login with admin credentials
- [ ] Hospital settings configured
- [ ] User accounts created for each role

---

## 📦 Dependencies (NuGet Packages)

- **Antlr** 3.5.0.2
- **AspNet.ScriptManager.bootstrap** 3.4.1
- **AspNet.ScriptManager.jQuery** 3.4.1
- **bootstrap** 3.4.1
- **jQuery** 3.4.1
- **Microsoft.AspNet.FriendlyUrls** 1.0.2
- **Microsoft.AspNet.Web.Optimization** 1.1.3
- **Microsoft.AspNet.Web.Optimization.WebForms** 1.1.3
- **Microsoft.CodeDom.Providers.DotNetCompilerPlatform** 2.0.1
- **Microsoft.Web.Infrastructure** 1.0.0.0
- **Newtonsoft.Json** 12.0.2
- **WebGrease** 1.6.0

---

## 🎯 Common Tasks

### Add a New User
1. Login as Admin
2. Navigate to appropriate user management page:
   - Doctors: `add_doctor.aspx`
   - Lab Users: `addlabuser.aspx`
   - X-ray Users: `addxrayuser.aspx`
   - Pharmacy Users: `add_pharmacy_user.aspx`
   - Registration Clerks: `add_registre.aspx`

### Add Medicine to Pharmacy
1. Login as Admin or Pharmacy user
2. `add_medicine.aspx` → Add medicine details
3. Select unit type (Tablet, Syrup, etc.)
4. Set pricing (cost price, selling price)
5. `medicine_inventory.aspx` → Add stock with batch and expiry

### Configure Charges
1. Login as Admin
2. `manage_charges.aspx` → Set charge amounts
3. `hospital_settings.aspx` → Set registration fee

### Generate Reports
1. Login as Admin
2. Navigate to appropriate report page
3. Select date range
4. View/Export data

---

## 🏗️ Architecture Pattern

### Presentation Layer (ASPX Pages)
- Web Forms with code-behind (.aspx.cs)
- Master Pages for consistent UI
- Client-side validation with jQuery

### Data Access Layer
- Direct ADO.NET (SqlConnection/SqlCommand)
- No ORM (Entity Framework not used)
- Stored queries in code-behind
- WebMethods for AJAX operations

### Business Logic
- Minimal separation (mostly in code-behind)
- Helper classes for specific calculations
- Session management for authentication

### Database Layer
- SQL Server relational database
- Identity columns for primary keys
- Foreign key relationships
- Some views for complex queries

---

## 📝 Code Patterns

### WebMethod Pattern (AJAX Endpoints)
```csharp
[WebMethod]
public static DataType[] MethodName()
{
    List<DataType> details = new List<DataType>();
    string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
    using (SqlConnection con = new SqlConnection(cs))
    {
        con.Open();
        SqlCommand cmd = new SqlCommand("SQL Query", con);
        SqlDataReader dr = cmd.ExecuteReader();
        while (dr.Read())
        {
            DataType obj = new DataType();
            obj.Property = dr["Column"].ToString();
            details.Add(obj);
        }
    }
    return details.ToArray();
}
```

### Database Query Pattern
```csharp
string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
using (SqlConnection con = new SqlConnection(cs))
{
    con.Open();
    using (SqlCommand cmd = new SqlCommand("SQL Query", con))
    {
        cmd.Parameters.AddWithValue("@param", value);
        SqlDataReader dr = cmd.ExecuteReader();
        // Process results
    }
}
```

---

## 🔍 Project Statistics

- **Total ASPX Pages**: ~80+
- **Code-Behind Files (.cs)**: ~80+
- **Master Pages**: 7
- **Database Tables**: ~30+
- **SQL Scripts**: 20+
- **Documentation Files**: 30+
- **JavaScript Files**: Custom + jQuery + DataTables + SweetAlert2
- **CSS Files**: Bootstrap + Custom (kaiadmin theme)

---

## 🎓 Learning Resources

### For Developers New to This Project
1. Start with `login.aspx.cs` - Understand authentication
2. Review `Add_patients.aspx` - See basic CRUD pattern
3. Study `admin_dashbourd.aspx.cs` - Learn WebMethod pattern
4. Examine `pharmacy_pos.aspx` - Complex business logic example
5. Read documentation files for context

### ASP.NET Web Forms Resources
- Microsoft Web Forms Documentation
- ADO.NET Data Access Tutorial
- jQuery/AJAX integration guides

---

## 🤝 Contributing Guidelines

### Code Style
- Follow existing patterns in the codebase
- Use meaningful variable names
- Add comments for complex logic
- Test thoroughly before committing

### Database Changes
- Always create migration scripts
- Document schema changes
- Test with sample data
- Backup database before running scripts

### Documentation
- Update relevant .md files
- Keep PROJECT_OVERVIEW.md current
- Document new features
- Add troubleshooting guides for common issues

---

## 📞 Support & Maintenance

### Common Issues
- See `IMPORTANT_SETUP_INSTRUCTIONS.md` for setup issues
- Check `START_HERE_FIX_GUIDE.md` for quick fixes
- Review fix documentation files for specific problems

### Troubleshooting
1. **Database Connection Errors**: Check Web.config connection string
2. **Build Errors**: Restore NuGet packages
3. **Login Issues**: Verify user exists in correct table
4. **Reports Empty**: Check date ranges and data existence
5. **POS Issues**: Verify medicine_units configuration

---

## 📄 License & Credits

- **Project**: Juba Hospital Management System
- **Framework**: ASP.NET Web Forms (.NET Framework 4.7.2)
- **Database**: SQL Server
- **UI Theme**: Kaiadmin Bootstrap Template

---

## 🎯 Future Enhancement Opportunities

1. **Security Improvements**
   - Password hashing (BCrypt/SHA256)
   - Role-based authorization attributes
   - SQL injection prevention (parameterized queries everywhere)
   - Session timeout management

2. **Technical Upgrades**
   - Migrate to ASP.NET Core
   - Implement Entity Framework
   - Add API layer (RESTful)
   - Responsive mobile UI

3. **Feature Enhancements**
   - Appointment scheduling
   - SMS/Email notifications
   - Digital signatures
   - Audit trail logging
   - Advanced reporting (charts, exports)
   - Backup/restore functionality

4. **UX Improvements**
   - Modernize UI design
   - Add dashboard widgets
   - Improve search functionality
   - Real-time notifications
   - Keyboard shortcuts

---

**Last Updated**: 2025
**Version**: Current (based on latest code analysis)
**Status**: Active Development

