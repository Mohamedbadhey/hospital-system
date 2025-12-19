-- ================================================================
-- DIAGNOSE 500 ERROR - Check Actual Data
-- ================================================================

USE [juba_clinick]
GO

PRINT '================================================================'
PRINT 'DIAGNOSING INPATIENT MANAGEMENT 500 ERROR'
PRINT '================================================================'
PRINT ''

-- Check if inpatients exist
PRINT '1. Checking for inpatients...'
SELECT COUNT(*) as InpatientCount FROM patient WHERE patient_status = 1
PRINT ''

-- Show actual inpatient data
PRINT '2. Current inpatients:'
SELECT 
    patientid,
    full_name,
    patient_status,
    bed_admission_date,
    patient_type
FROM patient 
WHERE patient_status = 1
PRINT ''

-- Check prescriptions for inpatients
PRINT '3. Checking prescriptions for inpatients:'
SELECT 
    p.patientid,
    p.full_name,
    pr.prescid,
    pr.doctorid
FROM patient p
LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
WHERE p.patient_status = 1
PRINT ''

-- Test the EXACT query from doctor_inpatient.aspx.cs
PRINT '4. Testing the EXACT query from code (for doctor ID 5):'
SELECT 
    p.patientid,
    p.full_name, 
    ISNULL(p.sex, '') AS sex,
    ISNULL(p.location, '') AS location,
    ISNULL(p.phone, '') AS phone,
    p.dob,
    p.date_registered,
    p.bed_admission_date,
    CASE WHEN p.bed_admission_date IS NOT NULL 
        THEN DATEDIFF(DAY, p.bed_admission_date, GETDATE()) 
        ELSE 0 END AS days_admitted,
    pr.prescid,
    ISNULL(pr.status, 0) AS status,
    ISNULL(pr.xray_status, 0) AS xray_status,
    ISNULL(pr.lab_charge_paid, 0) AS lab_charge_paid,
    ISNULL(pr.xray_charge_paid, 0) AS xray_charge_paid,
    d.doctorid,
    ISNULL(d.doctortitle, '') AS doctortitle,
    ISNULL(d.fullname, '') AS doctor_name,
    -- Lab test status
    CASE WHEN EXISTS(SELECT 1 FROM lab_test lt WHERE lt.prescid = pr.prescid) 
        THEN 'Ordered' ELSE 'Not Ordered' END AS lab_test_status,
    CASE WHEN EXISTS(SELECT 1 FROM lab_results lr WHERE lr.prescid = pr.prescid) 
        THEN 'Available' ELSE 'Pending' END AS lab_result_status,
    -- X-ray status  
    CASE WHEN EXISTS(SELECT 1 FROM presxray px WHERE px.prescid = pr.prescid) 
        THEN 'Ordered' ELSE 'Not Ordered' END AS xray_order_status,
    CASE WHEN EXISTS(SELECT 1 FROM xray_results xr WHERE xr.prescid = pr.prescid) 
        THEN 'Available' ELSE 'Pending' END AS xray_result_status,
    -- Medication count
    (SELECT COUNT(*) FROM medication m WHERE m.prescid = pr.prescid) AS medication_count,
    -- Charges summary from patient_charges table
    (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
     WHERE pc.patientid = p.patientid AND ISNULL(pc.is_paid, 0) = 0) AS unpaid_charges,
    (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
     WHERE pc.patientid = p.patientid AND pc.is_paid = 1) AS paid_charges,
    (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
     WHERE pc.patientid = p.patientid AND pc.charge_type = 'Bed') AS total_bed_charges
FROM 
    patient p
INNER JOIN 
    prescribtion pr ON p.patientid = pr.patientid
INNER JOIN 
    doctor d ON pr.doctorid = d.doctorid
WHERE 
    d.doctorid = 5
    AND p.patient_status = 1
ORDER BY 
    p.bed_admission_date DESC;

PRINT ''
PRINT '================================================================'
PRINT 'DIAGNOSIS COMPLETE'
PRINT '================================================================'
PRINT ''
PRINT 'If the query above returns results, the database is fine.'
PRINT 'If you still get 500 error, the issue is in the C# code or Session.'
PRINT ''
PRINT 'Next steps:'
PRINT '1. Check what doctor ID you are logged in as'
PRINT '2. Make sure Session["id"] contains a valid doctor ID'
PRINT '3. Check Visual Studio Output window for the actual error'
PRINT ''
