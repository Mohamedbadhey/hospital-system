-- =====================================================
-- AUTOMATED BED CHARGE CALCULATION SYSTEM
-- This creates a stored procedure that automatically
-- calculates bed charges for all active inpatients
-- =====================================================

-- Step 1: Create the stored procedure
IF OBJECT_ID('sp_CalculateAllInpatientBedCharges', 'P') IS NOT NULL
    DROP PROCEDURE sp_CalculateAllInpatientBedCharges;
GO

CREATE PROCEDURE sp_CalculateAllInpatientBedCharges
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @patientId INT;
    DECLARE @prescId INT;
    DECLARE @admissionDate DATETIME;
    DECLARE @bedChargeRate DECIMAL(18,2);
    DECLARE @numberOfDays INT;
    DECLARE @chargedDays INT;
    DECLARE @daysToCharge INT;
    DECLARE @chargeDate DATE;
    DECLARE @i INT;
    
    -- Get the current bed charge rate
    SELECT TOP 1 @bedChargeRate = amount 
    FROM charges_config 
    WHERE charge_type = 'Bed' AND is_active = 1 
    ORDER BY charge_config_id DESC;
    
    IF @bedChargeRate IS NULL OR @bedChargeRate <= 0
    BEGIN
        PRINT 'No active bed charge rate configured';
        RETURN;
    END
    
    -- Create a temporary table to hold all active inpatients
    CREATE TABLE #ActiveInpatients (
        patientid INT,
        prescid INT NULL,
        bed_admission_date DATETIME
    );
    
    -- Get all active inpatients
    INSERT INTO #ActiveInpatients (patientid, prescid, bed_admission_date)
    SELECT DISTINCT 
        p.patientid, 
        pr.prescid,
        p.bed_admission_date
    FROM patient p
    LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
    WHERE p.patient_type = 'inpatient' 
    AND p.bed_admission_date IS NOT NULL
    AND p.patient_status = 1;
    
    PRINT 'Found ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' active inpatients';
    
    -- Process each inpatient
    DECLARE inpatient_cursor CURSOR FOR 
    SELECT patientid, prescid, bed_admission_date 
    FROM #ActiveInpatients;
    
    OPEN inpatient_cursor;
    FETCH NEXT FROM inpatient_cursor INTO @patientId, @prescId, @admissionDate;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate number of days - matches doctor_inpatient.aspx.cs calculation
        -- DATEDIFF(DAY, admission_date, GETDATE()) gives calendar days (0 on admission day)
        -- We add 1 because we need to charge for admission day (Day 0 = 1 charge)
        SET @numberOfDays = DATEDIFF(DAY, @admissionDate, GETDATE()) + 1;
        IF @numberOfDays < 1 SET @numberOfDays = 1;
        
        -- Check how many days have already been charged
        SELECT @chargedDays = COUNT(DISTINCT CAST(charge_date AS DATE))
        FROM patient_bed_charges 
        WHERE patientid = @patientId;
        
        IF @chargedDays IS NULL SET @chargedDays = 0;
        
        -- Calculate only uncharged days
        SET @daysToCharge = @numberOfDays - @chargedDays;
        
        IF @daysToCharge > 0
        BEGIN
            PRINT 'Patient ' + CAST(@patientId AS VARCHAR(10)) + ': Adding ' + CAST(@daysToCharge AS VARCHAR(10)) + ' new bed charge(s)';
            
            -- Add new bed charges for uncharged days
            SET @i = 0;
            WHILE @i < @daysToCharge
            BEGIN
                SET @chargeDate = CAST(DATEADD(DAY, @chargedDays + @i, @admissionDate) AS DATE);
                
                -- Insert the bed charge record
                INSERT INTO patient_bed_charges (
                    patientid, 
                    prescid, 
                    charge_date, 
                    bed_charge_amount, 
                    is_paid, 
                    created_at
                )
                VALUES (
                    @patientId,
                    @prescId,
                    @chargeDate,
                    @bedChargeRate,
                    0,
                    GETDATE()
                );
                
                SET @i = @i + 1;
            END
        END
        
        FETCH NEXT FROM inpatient_cursor INTO @patientId, @prescId, @admissionDate;
    END
    
    CLOSE inpatient_cursor;
    DEALLOCATE inpatient_cursor;
    
    DROP TABLE #ActiveInpatients;
    
    PRINT 'Bed charge calculation completed successfully';
END
GO

-- =====================================================
-- Step 2: Test the stored procedure
-- =====================================================
-- Uncomment the line below to test manually
-- EXEC sp_CalculateAllInpatientBedCharges;

-- =====================================================
-- Step 3: Create SQL Server Agent Job (if available)
-- =====================================================
-- NOTE: This requires SQL Server Agent and sysadmin permissions
-- Run this script on your SQL Server to create the job

/*
USE msdb;
GO

-- Create the job
EXEC dbo.sp_add_job
    @job_name = N'Daily Bed Charge Calculation';
GO

-- Add a job step
EXEC sp_add_jobstep
    @job_name = N'Daily Bed Charge Calculation',
    @step_name = N'Calculate Bed Charges',
    @subsystem = N'TSQL',
    @command = N'EXEC sp_CalculateAllInpatientBedCharges',
    @database_name = N'juba_clinick', -- Change to your database name
    @retry_attempts = 3,
    @retry_interval = 5;
GO

-- Create a schedule to run daily at midnight
EXEC sp_add_schedule
    @schedule_name = N'Daily at Midnight',
    @enabled = 1,
    @freq_type = 4,           -- Daily
    @freq_interval = 1,        -- Every day
    @active_start_time = 0;    -- Midnight (00:00:00)
GO

-- Attach the schedule to the job
EXEC sp_attach_schedule
    @job_name = N'Daily Bed Charge Calculation',
    @schedule_name = N'Daily at Midnight';
GO

-- Assign the job to the local server
EXEC sp_add_jobserver
    @job_name = N'Daily Bed Charge Calculation';
GO

PRINT 'SQL Server Agent Job created successfully!';
PRINT 'The job will run daily at midnight to calculate bed charges.';
*/

-- =====================================================
-- ALTERNATIVE: Windows Task Scheduler
-- =====================================================
-- If SQL Server Agent is not available, create a batch file:
-- File: calculate_bed_charges.bat
-- Content:
--   sqlcmd -S YOUR_SERVER_NAME -d juba_clinick -Q "EXEC sp_CalculateAllInpatientBedCharges" -E
-- Then schedule it in Windows Task Scheduler to run daily at midnight

PRINT '========================================';
PRINT 'INSTALLATION COMPLETE!';
PRINT '========================================';
PRINT 'Stored procedure sp_CalculateAllInpatientBedCharges created.';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. Test manually: EXEC sp_CalculateAllInpatientBedCharges';
PRINT '2. Schedule automation (choose one):';
PRINT '   - SQL Server Agent Job (uncomment lines 120-165)';
PRINT '   - Windows Task Scheduler (see instructions above)';
PRINT '   - Keep the Page_Load method as a backup';
PRINT '';
