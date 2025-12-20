-- Pharmacy and Inventory Management Tables
-- Add these tables to your juba_clinick database

USE [juba_clinick]
GO

-- Pharmacy User Table
CREATE TABLE [dbo].[pharmacy_user](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](50) NULL,
 CONSTRAINT [PK_pharmacy_user] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Medicine Master Table
CREATE TABLE [dbo].[medicine](
	[medicineid] [int] IDENTITY(1,1) NOT NULL,
	[medicine_name] [varchar](250) NULL,
	[generic_name] [varchar](250) NULL,
	[manufacturer] [varchar](250) NULL,
	[unit] [varchar](50) NULL,
	[price] [float] NULL,
	[date_added] [datetime] NULL,
 CONSTRAINT [PK_medicine] PRIMARY KEY CLUSTERED 
(
	[medicineid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Medicine Inventory Table
CREATE TABLE [dbo].[medicine_inventory](
	[inventoryid] [int] IDENTITY(1,1) NOT NULL,
	[medicineid] [int] NULL,
	[quantity] [int] NULL,
	[reorder_level] [int] NULL,
	[expiry_date] [date] NULL,
	[batch_number] [varchar](50) NULL,
	[date_added] [datetime] NULL,
	[last_updated] [datetime] NULL,
 CONSTRAINT [PK_medicine_inventory] PRIMARY KEY CLUSTERED 
(
	[inventoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Medicine Dispensing Table
CREATE TABLE [dbo].[medicine_dispensing](
	[dispenseid] [int] IDENTITY(1,1) NOT NULL,
	[medid] [int] NULL,
	[medicineid] [int] NULL,
	[quantity_dispensed] [int] NULL,
	[dispensed_by] [int] NULL,
	[dispense_date] [datetime] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_medicine_dispensing] PRIMARY KEY CLUSTERED 
(
	[dispenseid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Add default values
ALTER TABLE [dbo].[medicine] ADD CONSTRAINT [DF_medicine_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[medicine_inventory] ADD CONSTRAINT [DF_medicine_inventory_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[medicine_inventory] ADD CONSTRAINT [DF_medicine_inventory_last_updated] DEFAULT (getdate()) FOR [last_updated]
GO

ALTER TABLE [dbo].[medicine_dispensing] ADD CONSTRAINT [DF_medicine_dispensing_dispense_date] DEFAULT (getdate()) FOR [dispense_date]
GO

ALTER TABLE [dbo].[medicine_dispensing] ADD CONSTRAINT [DF_medicine_dispensing_status] DEFAULT ('0') FOR [status]
GO

-- Add Pharmacy user type to usertype table (if not exists)
IF NOT EXISTS (SELECT * FROM usertype WHERE usertype = 'Pharmacy')
BEGIN
    INSERT INTO usertype (usertype) VALUES ('Pharmacy')
END
GO

