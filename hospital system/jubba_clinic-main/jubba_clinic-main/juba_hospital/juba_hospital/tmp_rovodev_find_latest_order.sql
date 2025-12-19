-- Find the actual latest lab order ID
SELECT TOP 5
    lt.med_id AS lab_order_id,
    pt.full_name AS patient_name,
    lt.date_taken,
    (SELECT COUNT(*) FROM patient_charges pc 
     WHERE pc.reference_id = lt.med_id 
     AND pc.charge_type = 'Lab') AS charges_count
FROM lab_test lt
INNER JOIN prescribtion p ON lt.prescid = p.prescid
INNER JOIN patient pt ON p.patientid = pt.patientid
ORDER BY lt.date_taken DESC;
