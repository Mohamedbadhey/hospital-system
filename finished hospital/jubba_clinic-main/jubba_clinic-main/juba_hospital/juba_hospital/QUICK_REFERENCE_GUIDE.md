# Juba Hospital Management System - Quick Reference Guide

## 🔑 Quick Access Information

### Database
- **Name:** `juba_clinick`
- **Script:** `juba_clinick1.sql`
- **Total Tables:** 27
- **Connection String Name:** `DBCS` (in Web.config)

### Default Login Credentials
| Role | Username | Password | Landing Page |
|------|----------|----------|--------------|
| Admin | `admin` | `admin` | admin_dashbourd.aspx |
| Doctor | `omar` | `1234` | assignmed.aspx |
| Lab User | `ali` | `ali` | lab_waiting_list.aspx |
| Registration | - | - | Add_patients.aspx |
| X-ray | `tt` | `tt` | take_xray.aspx |
| Pharmacy | - | - | pharmacy_dashboard.aspx |

---

## 📊 Database Tables Quick Map

### 👥 Users & Access (7 tables)
```
admin           → System administrators
doctor          → Medical doctors
lab_user        → Laboratory technicians
xrayuser        → Radiology technicians
pharmacy_user   → Pharmacy staff
registre        → Registration staff
usertype        → Role definitions (1-6)
```

### 🏥 Patient Care (6 tables)
```
patient         → Patient master data
prescribtion    → Prescriptions (links everything)
medication      → Prescribed medications
lab_test        → Lab test orders (60+ tests)
lab_results     → Lab test results
xray            → X-ray orders
xray_results    → X-ray images
presxray        → Prescription-Xray link
```

### 💊 Pharmacy (7 tables)
```
medicine                → Medicine catalog
medicine_units          → Unit types (Tablet, Syrup, etc.)
medicine_inventory      → Stock levels
medicine_dispensing     → Dispensing records
pharmacy_sales          → Sales transactions
pharmacy_sales_items    → Sale line items
pharmacy_customer       → Customer database
```

### 💰 Financial (4 tables)
```
patient_charges         → All charges (Registration, Lab, Xray, Bed, Delivery)
patient_bed_charges     → Daily bed charges for inpatients
charges_config          → Configurable charge amounts
totalamount            → Legacy totals
```

### ⚙️ Configuration (1 table)
```
hospital_settings       → Hospital info, logos, contact
```

---

## 💵 Current Charge Configuration

| Service Type | Charge Name | Amount |
|--------------|-------------|--------|
| Registration | Patient fee | $10 |
| Lab | Lab charges | $15 |
| X-ray | X-Ray Imaging Charges | $150 |
| Bed | Standard Bed Charge (Per Night) | $3 |
| Delivery | Delivery Service Charge | $10 |

---

## 🔄 Patient Status Codes

### patient_status (in patient table)
- `0` = Outpatient
- `1` = Inpatient

### prescription status (in prescribtion table)
- `0` = Pending
- `1` = Lab ordered
- `2` = Lab in progress
- `3` = Lab completed
- `4` = Ready for pickup
- `5` = Completed

### xray_status (in prescribtion table)
- `0` = No X-ray ordered
- `1` = X-ray ordered
- `2` = X-ray completed

---

## 📋 60+ Laboratory Tests Available

### Biochemistry
- Lipid Profile (LDL, HDL, Cholesterol, Triglycerides)
- Liver Function (SGPT/ALT, SGOT/AST, ALP, Bilirubin, Albumin)
- Renal Profile (Urea, Creatinine, Uric Acid)
- Electrolytes (Sodium, Potassium, Chloride, Calcium, Phosphorous, Magnesium)
- Pancreas (Amylase)

### Hematology
- Hemoglobin
- CBC (Complete Blood Count)
- ESR
- Blood Grouping
- Cross Matching
- Malaria Test

### Immunology & Virology
- HIV Test
- Hepatitis B (HBV)
- Hepatitis C (HCV)
- TPHA (Syphilis)
- Brucella (melitensis, abortus)
- C-Reactive Protein (CRP)
- Rheumatoid Factor (RF)
- ASO (Antistreptolysin O)
- Toxoplasmosis
- H. pylori Antibody

### Hormones
**Thyroid Profile:**
- T3 (Triiodothyronine)
- T4 (Thyroxine)
- TSH (Thyroid Stimulating Hormone)

**Fertility Profile:**
- FSH (Follicle Stimulating Hormone)
- LH (Luteinizing Hormone)
- Progesterone (Female)
- Testosterone (Male)
- Estradiol
- Prolactin
- β-HCG (Pregnancy Test)

### Clinical Pathology
- General Urine Examination
- Stool Examination
- Stool Occult Blood
- Sperm Examination
- Vaginal Swab
- H. pylori Antigen (Stool)

### Diabetes
- Fasting Blood Sugar (FBS)
- Hemoglobin A1c (HbA1c)
- Blood Sugar (Random)

---

## 🏗️ Key Relationships

```
patient (1) ──→ (many) prescribtion
prescribtion (1) ──→ (many) medication
prescribtion (1) ──→ (many) lab_test
prescribtion (1) ──→ (many) xray
patient (1) ──→ (many) patient_charges
patient (1) ──→ (many) patient_bed_charges

medicine (1) ──→ (many) medicine_inventory
medicine_units (1) ──→ (many) medicine
pharmacy_sales (1) ──→ (many) pharmacy_sales_items
```

---

## 📱 Main Application Pages

### Registration Module
- `Add_patients.aspx` - Register new patient
- `Patient_details.aspx` - View patient details
- `patient_report.aspx` - Patient listing reports
- `registre_outpatients.aspx` - Outpatient list
- `registre_inpatients.aspx` - Inpatient list
- `registre_discharged.aspx` - Discharged patients
- `register_inpatient.aspx` - Admit as inpatient

### Doctor Module
- `assignmed.aspx` - Prescribe medications
- `Patient_Operation.aspx` - Create prescription
- `waitingpatients.aspx` - Waiting list
- `doctor_inpatient.aspx` - Inpatient management
- `test_details.aspx` - Order lab tests
- `assingxray.aspx` - Order x-rays

### Lab Module
- `lab_waiting_list.aspx` - Pending tests
- `take_lab_test.aspx` - Enter results (old)
- `lap_operation.aspx` - Enter results
- `lap_processed.aspx` - Completed tests
- `pending_lap.aspx` - Pending list
- `lab_result_print.aspx` - Print results
- `lab_reference_guide.aspx` - Normal values guide
- `patient_lab_history.aspx` - Patient lab history
- `lab_comprehensive_report.aspx` - Lab reports
- `lab_revenue_report.aspx` - Lab revenue

### X-ray Module
- `take_xray.aspx` - Pending x-rays
- `take_xray_lab_test.aspx` - Upload images
- `xray_processed.aspx` - Completed x-rays
- `pending_xray.aspx` - Pending list
- `delete_xray_images.aspx` - Manage images
- `xray_revenue_report.aspx` - X-ray revenue

### Pharmacy Module
- `pharmacy_dashboard.aspx` - Dashboard
- `pharmacy_pos.aspx` - Point of Sale
- `add_medicine.aspx` - Add new medicine
- `add_medicine_units.aspx` - Manage units
- `medicine_inventory.aspx` - Stock management
- `dispense_medication.aspx` - Dispense meds
- `pharmacy_sales_history.aspx` - Sales history
- `pharmacy_sales_reports.aspx` - Analytics
- `pharmacy_revenue_report.aspx` - Revenue
- `pharmacy_invoice.aspx` - Print invoice
- `low_stock.aspx` - Low stock alert
- `expired_medicines.aspx` - Expiry tracking
- `pharmacy_customers.aspx` - Customer list

### Admin Module
- `admin_dashbourd.aspx` - Main dashboard
- `admin_inpatient.aspx` - Inpatient overview
- `financial_reports.aspx` - Financial analytics
- `manage_charges.aspx` - Configure charges
- `charge_history.aspx` - Charge history
- `hospital_settings.aspx` - Hospital config
- `add_doctor.aspx` - Add doctor
- `add_registre.aspx` - Add registration staff
- `addlabuser.aspx` - Add lab user
- `addxrayuser.aspx` - Add x-ray user
- `add_pharmacy_user.aspx` - Add pharmacy user
- `add_job_title.aspx` - Manage job titles

### Financial Reports
- `registration_revenue_report.aspx` - Registration income
- `lab_revenue_report.aspx` - Lab income
- `xray_revenue_report.aspx` - X-ray income
- `bed_revenue_report.aspx` - Bed charges income
- `delivery_revenue_report.aspx` - Delivery income
- `pharmacy_revenue_report.aspx` - Pharmacy income
- `outpatient_full_report.aspx` - Complete outpatient report
- `medication_report.aspx` - Medication dispensing

### Print & Export Pages
- `patient_invoice_print.aspx` - Patient invoice
- `lab_result_print.aspx` - Lab results
- `discharge_summary_print.aspx` - Discharge summary
- `visit_summary_print.aspx` - Visit summary
- `pharmacy_invoice.aspx` - Pharmacy receipt

---

## 🎨 Medicine Unit Types (25+ Units)

| Unit Name | Abbreviation | Selling Method | Subdivision |
|-----------|--------------|----------------|-------------|
| Tablet | Tab | Countable | Strip |
| Capsule | Cap | Countable | Strip |
| Syrup | Syr | Measurable (mL) | Bottle |
| Injection | Inj | Countable | Vial/Amp |
| Cream | Crm | Measurable (g) | Tube |
| Ointment | Oint | Measurable (g) | Tube |
| Drops | Drops | Measurable (mL) | Bottle |
| Suspension | Susp | Measurable (mL) | Bottle |
| Powder | Pwd | Measurable (g) | Sachet |
| Inhaler | Inh | Countable | - |
| Patch | Patch | Countable | - |
| Suppository | Supp | Countable | - |
| Liquid | Liq | Measurable (mL) | Bottle |
| IV Fluid | IV | Measurable (mL) | Bag |

---

## 🔧 Invoice Number Formats

The system generates unique invoice numbers for each service:

```
Registration: REG-YYYYMMDD-PatientID
Lab:         LAB-YYYYMMDD-PatientID
X-ray:       XRAY-YYYYMMDD-PatientID
Bed:         BED-YYYYMMDD-PatientID
Delivery:    DEL-YYYYMMDD-PatientID
Pharmacy:    INV-YYYYMMDD-HHMMSS
```

Example: `LAB-20251201-1046` = Lab test for patient 1046 on Dec 1, 2025

---

## 📊 Key Reports Summary

| Report Category | Page | Description |
|----------------|------|-------------|
| **Patient** | patient_report.aspx | All patients list |
| **Outpatient** | outpatient_full_report.aspx | Complete outpatient data |
| **Inpatient** | admin_inpatient.aspx | Active inpatients |
| **Discharged** | registre_discharged.aspx | Discharged patients |
| **Lab Tests** | lab_comprehensive_report.aspx | Lab statistics |
| **Pharmacy** | pharmacy_sales_reports.aspx | Sales analytics |
| **Financial** | financial_reports.aspx | Revenue by service type |
| **Medication** | medication_report.aspx | Medication dispensing |

---

## 🚦 Typical Patient Journey

### Outpatient Visit
```
1. Registration Desk
   ↓ (Register patient + Pay $10)
2. Waiting Room
   ↓
3. Doctor Consultation
   ↓ (Doctor prescribes)
4a. Lab (if ordered) → Pay $15 → Get results
4b. X-ray (if ordered) → Pay $150 → Get images
4c. Medication (if prescribed) → No charge
   ↓
5. Checkout & Invoice
```

### Inpatient Admission
```
1. Registration + Admission
   ↓ (Pay $10 + Bed assigned)
2. Inpatient Ward
   ↓ (Daily bed charges: $3/night)
3. Medical Care
   ↓ (Lab, X-ray, Medications as needed)
4. Delivery (if maternity)
   ↓ (Additional $10 charge)
5. Discharge Summary
   ↓
6. Final Bill Payment
   ↓ (All accumulated charges)
7. Discharge
```

---

## 🔐 Security Notes

⚠️ **Current Implementation:**
- Passwords stored in plain text
- Basic session authentication
- Role-based access control

⚠️ **Recommendations:**
- Implement password hashing (bcrypt)
- Add session timeout
- Enable HTTPS
- Add audit logging
- Implement password complexity rules

---

## 💾 Backup & Maintenance

### Regular Tasks
1. **Daily:** Database backup
2. **Weekly:** Check low stock alerts
3. **Monthly:** Review financial reports
4. **Quarterly:** Archive old patient records
5. **Yearly:** Update medicine pricing

### Database Maintenance
```sql
-- Backup database
BACKUP DATABASE juba_clinick TO DISK = 'C:\Backups\juba_clinick_backup.bak'

-- Check database size
EXEC sp_spaceused

-- Update statistics
EXEC sp_updatestats
```

---

## 📞 Support & Troubleshooting

### Common Issues

**Login Problems:**
- Verify username/password
- Check usertype in dropdown
- Ensure database connection

**Report Not Loading:**
- Check date range filters
- Verify data exists
- Clear browser cache

**Inventory Issues:**
- Verify medicine_inventory records exist
- Check unit_id is set correctly
- Ensure stock levels are positive

**Charge Not Applied:**
- Check charges_config is active
- Verify patient_type is set
- Check prescription status

---

## 📚 File Locations

```
juba_hospital/
├── *.aspx                  → Web pages
├── *.aspx.cs               → Code-behind files
├── Web.config              → Configuration
├── Site.Master             → Master page layouts
├── /assets/                → CSS, JS, Images
├── /bin/                   → Compiled assemblies
├── juba_clinick1.sql       → Database script
└── *.md                    → Documentation
```

---

## 🎯 Quick Start Checklist

- [ ] Install SQL Server
- [ ] Execute juba_clinick1.sql script
- [ ] Update Web.config connection string
- [ ] Open solution in Visual Studio
- [ ] Build solution (Ctrl+Shift+B)
- [ ] Run application (F5)
- [ ] Login as admin (admin/admin)
- [ ] Configure hospital settings
- [ ] Add staff users
- [ ] Start registering patients!

---

## 📞 Hospital Contact Info

**v-afmadow hospital**
- 📍 Kismayo, Somalia
- 📞 +252-4544
- 📧 info@jubbahospital.com
- 🌐 www.jubbahospital.com

---

## 📖 Additional Documentation

For detailed information, see:
- `PROJECT_UNDERSTANDING_SUMMARY.md` - Comprehensive overview
- `PROJECT_OVERVIEW.md` - System architecture
- `SYSTEM_COMPREHENSIVE_OVERVIEW.md` - Technical details
- `COMPLETE_SYSTEM_REPORT.md` - Full analysis

---

*Quick Reference Guide v1.0*  
*Last Updated: December 2025*
