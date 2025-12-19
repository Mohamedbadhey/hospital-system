-- Test the exact query being used in the code
USE juba_clinick1;
GO

PRINT '========================================';
PRINT 'TESTING DISCHARGED PATIENTS QUERY';
PRINT '========================================';
PRINT '';

-- Run the exact query from registre_discharged.aspx.cs
SELECT 
    p.patientid,
    p.full_name,
    p.dob,
    p.sex,
    p.phone,
    p.location,
    p.date_registered,
    ISNULL(p.patient_type, 
        CASE WHEN p.bed_admission_date IS NOT NULL THEN 'inpatient' ELSE 'outpatient' END
    ) as patient_type,
    p.bed_admission_date,
    GETDATE() as discharge_date,
    CASE 
        WHEN p.bed_admission_date IS NOT NULL THEN DATEDIFF(DAY, p.bed_admission_date, GETDATE())
        ELSE 0
    END as days_admitted,
    pr.prescid,
    ISNULL(SUM(pc.amount), 0) as total_charges,
    ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
    ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
FROM patient p
LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
LEFT JOIN (SELECT patientid, MAX(prescid) as prescid FROM prescribtion GROUP BY patientid) pr ON p.patientid = pr.patientid
WHERE p.patient_status = 1
GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, 
         p.date_registered, p.patient_type, p.bed_admission_date, pr.prescid
ORDER BY p.date_registered DESC;

PRINT '';
PRINT 'Check the prescid column above!';
PRINT 'If prescid = patientid, then the prescription table data is wrong.';
PRINT 'If prescid is NULL, then no prescription exists.';
PRINT 'If prescid is different, then the query is correct but JavaScript might have an issue.';
PRINT '';

-- Also test the subquery directly
PRINT '========================================';
PRINT 'TESTING PRESCRIPTION SUBQUERY';
PRINT '========================================';

SELECT patientid, MAX(prescid) as prescid 
FROM prescribtion 
GROUP BY patientid
ORDER BY patientid;

PRINT '';
PRINT 'This shows what prescid SHOULD be for each patient.';
