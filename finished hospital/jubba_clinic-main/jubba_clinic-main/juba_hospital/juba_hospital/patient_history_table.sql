-- Create patient_history table for storing patient medical history
USE [juba_clinick]
GO

-- Check if table exists and drop it if needed (for clean installation)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[patient_history]') AND type in (N'U'))
DROP TABLE [dbo].[patient_history]
GO

-- Create patient_history table
CREATE TABLE [dbo].[patient_history](
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[patientid] [int] NOT NULL,
	[prescid] [int] NULL,
	[history_text] [nvarchar](max) NOT NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NOT NULL,
	[last_updated] [datetime] NULL,
	[updated_by] [int] NULL,
 CONSTRAINT [PK_patient_history] PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Add default constraint for created_date
ALTER TABLE [dbo].[patient_history] ADD  DEFAULT (getdate()) FOR [created_date]
GO

-- Add foreign key constraint to patient table (optional, but recommended)
ALTER TABLE [dbo].[patient_history]  WITH CHECK ADD  CONSTRAINT [FK_patient_history_patient] FOREIGN KEY([patientid])
REFERENCES [dbo].[patient] ([patientid])
GO

ALTER TABLE [dbo].[patient_history] CHECK CONSTRAINT [FK_patient_history_patient]
GO

-- Add foreign key constraint to prescribtion table (optional)
ALTER TABLE [dbo].[patient_history]  WITH CHECK ADD  CONSTRAINT [FK_patient_history_prescribtion] FOREIGN KEY([prescid])
REFERENCES [dbo].[prescribtion] ([prescid])
GO

ALTER TABLE [dbo].[patient_history] CHECK CONSTRAINT [FK_patient_history_prescribtion]
GO

PRINT 'Patient history table created successfully!'
