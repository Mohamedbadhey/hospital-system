-- Check if hospital settings exist
SELECT 'Hospital Settings' as TableName, COUNT(*) as RecordCount FROM hospital_settings;

-- Check if there are patients
SELECT 'Patients' as TableName, COUNT(*) as RecordCount FROM patients;

-- Check if there are prescriptions
SELECT 'Prescriptions' as TableName, COUNT(*) as RecordCount FROM prescriptions;

-- Check if there are lab orders
SELECT 'Lab Orders' as TableName, COUNT(*) as RecordCount FROM lab_orders;

-- Check if there are pharmacy sales
SELECT 'Pharmacy Sales' as TableName, COUNT(*) as RecordCount FROM pharmacy_sales;
