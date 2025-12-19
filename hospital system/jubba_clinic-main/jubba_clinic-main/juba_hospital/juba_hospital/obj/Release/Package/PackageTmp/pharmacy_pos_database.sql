-- Pharmacy POS System - Standalone Database Tables
-- This creates a complete POS system for pharmacy

USE [juba_clinick]
GO

-- Medicine Master Table (Updated for POS with strips/boxes)
IF OBJECT_ID('medicine', 'U') IS NOT NULL
    DROP TABLE [medicine];
GO

CREATE TABLE [dbo].[medicine](
	[medicineid] [int] IDENTITY(1,1) NOT NULL,
	[medicine_name] [varchar](250) NULL,
	[generic_name] [varchar](250) NULL,
	[manufacturer] [varchar](250) NULL,
	[unit] [varchar](50) NULL, -- Tablet, Capsule, Bottle, etc.
	[price_per_tablet] [float] NULL, -- Price per individual tablet
	[price_per_strip] [float] NULL, -- Price per strip
	[price_per_box] [float] NULL, -- Price per box
	[tablets_per_strip] [int] NULL DEFAULT 10, -- Number of tablets in one strip
	[strips_per_box] [int] NULL DEFAULT 10, -- Number of strips in one box
	[date_added] [datetime] NULL,
 CONSTRAINT [PK_medicine] PRIMARY KEY CLUSTERED 
(
	[medicineid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Medicine Inventory Table (Updated for strips/boxes)
IF OBJECT_ID('medicine_inventory', 'U') IS NOT NULL
    DROP TABLE [medicine_inventory];
GO

CREATE TABLE [dbo].[medicine_inventory](
	[inventoryid] [int] IDENTITY(1,1) NOT NULL,
	[medicineid] [int] NULL,
	[total_strips] [int] NULL DEFAULT 0, -- Total strips in stock
	[loose_tablets] [int] NULL DEFAULT 0, -- Loose tablets (not in strips)
	[total_boxes] [int] NULL DEFAULT 0, -- Total boxes
	[reorder_level_strips] [int] NULL DEFAULT 10, -- Reorder level in strips
	[expiry_date] [date] NULL,
	[batch_number] [varchar](50) NULL,
	[purchase_price] [float] NULL, -- Purchase price for this batch
	[date_added] [datetime] NULL,
	[last_updated] [datetime] NULL,
 CONSTRAINT [PK_medicine_inventory] PRIMARY KEY CLUSTERED 
(
	[inventoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Customer Table (for invoicing)
IF OBJECT_ID('pharmacy_customer', 'U') IS NOT NULL
    DROP TABLE [pharmacy_customer];
GO

CREATE TABLE [dbo].[pharmacy_customer](
	[customerid] [int] IDENTITY(1,1) NOT NULL,
	[customer_name] [varchar](100) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[address] [varchar](250) NULL,
	[date_registered] [datetime] NULL,
 CONSTRAINT [PK_pharmacy_customer] PRIMARY KEY CLUSTERED 
(
	[customerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Sales Transaction Table
IF OBJECT_ID('pharmacy_sales', 'U') IS NOT NULL
    DROP TABLE [pharmacy_sales];
GO

CREATE TABLE [dbo].[pharmacy_sales](
	[saleid] [int] IDENTITY(1,1) NOT NULL,
	[invoice_number] [varchar](50) NULL, -- Unique invoice number (INV-YYYYMMDD-001)
	[customerid] [int] NULL, -- NULL for walk-in customers
	[customer_name] [varchar](100) NULL, -- For walk-in customers
	[sale_date] [datetime] NULL,
	[total_amount] [float] NULL,
	[discount] [float] NULL DEFAULT 0,
	[final_amount] [float] NULL,
	[sold_by] [int] NULL, -- pharmacy_user userid
	[payment_method] [varchar](50) NULL, -- Cash, Card, Mobile Payment
	[status] [int] NULL DEFAULT 1, -- 1=Completed, 0=Cancelled
 CONSTRAINT [PK_pharmacy_sales] PRIMARY KEY CLUSTERED 
(
	[saleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Sales Items Table (Items in each sale)
IF OBJECT_ID('pharmacy_sales_items', 'U') IS NOT NULL
    DROP TABLE [pharmacy_sales_items];
GO

CREATE TABLE [dbo].[pharmacy_sales_items](
	[sale_item_id] [int] IDENTITY(1,1) NOT NULL,
	[saleid] [int] NULL,
	[medicineid] [int] NULL,
	[inventoryid] [int] NULL, -- Which batch was sold
	[quantity_type] [varchar](20) NULL, -- 'strips', 'tablets', 'boxes'
	[quantity] [int] NULL, -- Number of strips/tablets/boxes
	[unit_price] [float] NULL, -- Price per unit at time of sale
	[total_price] [float] NULL,
 CONSTRAINT [PK_pharmacy_sales_items] PRIMARY KEY CLUSTERED 
(
	[sale_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Pharmacy User Table (Keep existing if exists, otherwise create)
IF OBJECT_ID('pharmacy_user', 'U') IS NULL
BEGIN
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
END
GO

-- Add default values
ALTER TABLE [dbo].[medicine] ADD CONSTRAINT [DF_medicine_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[medicine_inventory] ADD CONSTRAINT [DF_medicine_inventory_date_added] DEFAULT (getdate()) FOR [date_added]
GO

ALTER TABLE [dbo].[medicine_inventory] ADD CONSTRAINT [DF_medicine_inventory_last_updated] DEFAULT (getdate()) FOR [last_updated]
GO

ALTER TABLE [dbo].[pharmacy_customer] ADD CONSTRAINT [DF_pharmacy_customer_date_registered] DEFAULT (getdate()) FOR [date_registered]
GO

ALTER TABLE [dbo].[pharmacy_sales] ADD CONSTRAINT [DF_pharmacy_sales_sale_date] DEFAULT (getdate()) FOR [sale_date]
GO

-- Create indexes for faster queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_inventory_expiry')
    CREATE INDEX IX_medicine_inventory_expiry ON medicine_inventory(expiry_date);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_date')
    CREATE INDEX IX_pharmacy_sales_date ON pharmacy_sales(sale_date);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_invoice')
    CREATE INDEX IX_pharmacy_sales_invoice ON pharmacy_sales(invoice_number);
GO

-- Add Pharmacy user type to usertype table (if not exists)
IF NOT EXISTS (SELECT * FROM usertype WHERE usertype = 'Pharmacy')
BEGIN
    INSERT INTO usertype (usertype) VALUES ('Pharmacy')
END
GO
