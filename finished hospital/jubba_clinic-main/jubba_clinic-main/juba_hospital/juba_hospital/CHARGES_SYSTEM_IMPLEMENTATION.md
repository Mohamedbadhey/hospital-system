# Charges Management System - Implementation Summary

## Overview
This document describes the charges management system that allows admin to configure charges and registrars to process payments for registration, lab, and X-ray services before technicians can proceed with their work.

## Database Tables Created

### 1. charges_config
- Stores configurable charge amounts for Registration, Lab, and Xray
- Admin can add/edit/delete charges
- Fields: charge_config_id, charge_type, charge_name, amount, is_active, date_added, last_updated

### 2. patient_charges
- Tracks individual charges applied to patients
- Fields: charge_id, patientid, prescid, charge_type, charge_name, amount, is_paid, paid_date, paid_by, invoice_number, date_added

### 3. Updates to prescribtion table
- Added: lab_charge_paid (bit) - tracks if lab charges are paid
- Added: xray_charge_paid (bit) - tracks if xray charges are paid

## Files Created/Modified

### 1. Database Script
- **charges_management_database.sql** - Creates all tables and indexes

### 2. Admin Pages
- **manage_charges.aspx** - Admin page to configure charges
- **manage_charges.aspx.cs** - Code-behind with CRUD operations
- **manage_charges.aspx.designer.cs** - Designer file

### 3. Registration Update
- **Add_patients.aspx.cs** - Updated to automatically create registration charge when patient is registered

### 4. Registrar Pages (In Progress)
- **add_lab_charges.aspx.cs** - Code-behind for processing lab charges
- **add_lab_charges.aspx** - UI for registrar to add lab charges (TODO)
- **add_xray_charges.aspx.cs** - Code-behind for processing X-ray charges (TODO)
- **add_xray_charges.aspx** - UI for registrar to add X-ray charges (TODO)

## Workflow

### Registration Charges
1. Admin configures registration charge amount in manage_charges.aspx
2. When registrar registers a patient:
   - System automatically creates patient_charges record with registration charge
   - Charge is marked as paid automatically (can be modified)
   - Invoice number is generated (REG-YYYYMMDD-XXXX)
   - Patient amount field is updated with registration charge

### Lab Charges
1. Doctor orders lab tests for a patient (take_lab_test.aspx)
2. System creates lab_test record
3. Registrar views pending lab charges in add_lab_charges.aspx
4. Registrar processes payment:
   - System creates patient_charges record
   - Marks prescribtion.lab_charge_paid = 1
   - Generates invoice number (LAB-YYYYMMDD-XXXX)
   - Receipt can be printed
5. Lab technician can only see patients with lab_charge_paid = 1 in lab_waiting_list.aspx

### X-Ray Charges
1. Doctor orders X-ray for a patient (assingxray.aspx)
2. System creates xray record
3. Registrar views pending X-ray charges in add_xray_charges.aspx
4. Registrar processes payment:
   - System creates patient_charges record
   - Marks prescribtion.xray_charge_paid = 1
   - Generates invoice number (XRAY-YYYYMMDD-XXXX)
   - Receipt can be printed
5. X-ray technician can only see patients with xray_charge_paid = 1 in pending_xray.aspx

## Invoice Number Format
- Registration: REG-YYYYMMDD-XXXX
- Lab: LAB-YYYYMMDD-XXXX
- X-Ray: XRAY-YYYYMMDD-XXXX

## Status Tracking
- prescribtion.status - Overall prescription status
- prescribtion.lab_charge_paid - Lab charge payment status (0/1)
- prescribtion.xray_charge_paid - X-ray charge payment status (0/1)
- patient_charges.is_paid - Individual charge payment status (0/1)

## Remaining Tasks

1. ✅ Create database tables
2. ✅ Create admin charges management page
3. ✅ Update patient registration to add registration charges
4. ⏳ Create add_lab_charges.aspx UI page
5. ⏳ Create add_xray_charges.aspx and .cs files
6. ⏳ Update lab_waiting_list.aspx to filter by lab_charge_paid = 1
7. ⏳ Update pending_xray.aspx to filter by xray_charge_paid = 1
8. ⏳ Add print receipt functionality for all charge types
9. ⏳ Add navigation links in master pages

## Testing Checklist

- [ ] Admin can add/edit/delete charges
- [ ] Registration automatically creates charge record
- [ ] Registrar can see pending lab charges
- [ ] Registrar can process lab charge payment
- [ ] Lab technician only sees paid patients
- [ ] Registrar can see pending X-ray charges
- [ ] Registrar can process X-ray charge payment
- [ ] X-ray technician only sees paid patients
- [ ] Receipts can be printed for all charge types
- [ ] Invoice numbers are generated correctly

## Notes

- All charges are configured by admin in manage_charges.aspx
- Charges must be paid before technicians can proceed
- Invoice numbers are auto-generated and unique
- Receipts can be printed for all charge transactions

