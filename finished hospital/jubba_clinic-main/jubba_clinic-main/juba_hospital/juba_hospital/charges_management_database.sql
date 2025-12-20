-- Charges Management System - Database Tables
-- This creates tables for managing registration, lab, and xray charges

USE [juba_clinick]
GO

-- Charges Configuration Table (Admin manages default charges)
IF OBJECT_ID('charges_config', 'U') IS NOT NULL
    DROP TABLE [charges_config];
GO

CREATE TABLE [dbo].[charges_config](
	[charge_config_id] [int] IDENTITY(1,1) NOT NULL,
	[charge_type] [varchar](50) NULL, -- 'Registration', 'Lab', 'Xray'
	[charge_name] [varchar](100) NULL, -- Description of the charge
	[amount] [float] NULL DEFAULT 0,
	[is_active] [bit] NULL DEFAULT 1,
	[date_added] [datetime] NULL,
	[last_updated] [datetime] NULL,
 CONSTRAINT [PK_charges_config] PRIMARY KEY CLUSTERED 
(
	[charge_config_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Patient Charges Table (Individual charges applied to patients)
IF OBJECT_ID('patient_charges', 'U') IS NOT NULL
    DROP TABLE [patient_charges];
GO

CREATE TABLE [dbo].[patient_charges](
	[charge_id] [int] IDENTITY(1,1) NOT NULL,
	[patientid] [int] NULL,
	[prescid] [int] NULL, -- NULL for registration charges, linked for lab/xray charges
	[charge_type] [varchar](50) NULL, -- 'Registration', 'Lab', 'Xray'
	[charge_name] [varchar](100) NULL,
	[amount] [float] NULL,
	[is_paid] [bit] NULL DEFAULT 0, -- 0=Unpaid, 1=Paid
	[paid_date] [datetime] NULL,
	[paid_by] [int] NULL, -- userid of registrar who processed payment
	[invoice_number] [varchar](50) NULL, -- Unique invoice/receipt number
	[date_added] [datetime] NULL,
	[last_updated] [datetime] NULL,
 CONSTRAINT [PK_patient_charges] PRIMARY KEY CLUSTERED 
(
	[charge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Add default values
ALTER TABLE [dbo].[charges_config] ADD CONSTRAINT [DF_charges_config_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[charges_config] ADD CONSTRAINT [DF_charges_config_last_updated] DEFAULT (getdate()) FOR [last_updated]
GO

ALTER TABLE [dbo].[patient_charges] ADD CONSTRAINT [DF_patient_charges_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[patient_charges] ADD CONSTRAINT [DF_patient_charges_last_updated] DEFAULT (getdate()) FOR [last_updated]
GO

-- Add indexes for faster queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_patientid')
    CREATE INDEX IX_patient_charges_patientid ON patient_charges(patientid);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_prescid')
    CREATE INDEX IX_patient_charges_prescid ON patient_charges(prescid);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_charge_type')
    CREATE INDEX IX_patient_charges_charge_type ON patient_charges(charge_type);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_is_paid')
    CREATE INDEX IX_patient_charges_is_paid ON patient_charges(is_paid);
GO

-- Insert default charges (can be updated by admin)
IF NOT EXISTS (SELECT * FROM charges_config WHERE charge_type = 'Registration')
BEGIN
    INSERT INTO charges_config (charge_type, charge_name, amount, is_active) 
    VALUES ('Registration', 'Patient Registration Fee', 50.00, 1)
END
GO

IF NOT EXISTS (SELECT * FROM charges_config WHERE charge_type = 'Lab')
BEGIN
    INSERT INTO charges_config (charge_type, charge_name, amount, is_active) 
    VALUES ('Lab', 'Lab Test Charges', 100.00, 1)
END
GO

IF NOT EXISTS (SELECT * FROM charges_config WHERE charge_type = 'Xray')
BEGIN
    INSERT INTO charges_config (charge_type, charge_name, amount, is_active) 
    VALUES ('Xray', 'X-Ray Imaging Charges', 150.00, 1)
END
GO

-- Add lab_charge_paid and xray_charge_paid flags to prescribtion table for quick checking
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('prescribtion') AND name = 'lab_charge_paid')
BEGIN
    ALTER TABLE prescribtion ADD lab_charge_paid [bit] NULL DEFAULT 0;
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('prescribtion') AND name = 'xray_charge_paid')
BEGIN
    ALTER TABLE prescribtion ADD xray_charge_paid [bit] NULL DEFAULT 0;
END
GO

