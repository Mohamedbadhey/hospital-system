-- ============================================
-- Hospital Settings Table
-- Stores hospital information, logos, and print header settings
-- ============================================

-- Create hospital_settings table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'hospital_settings')
BEGIN
    CREATE TABLE hospital_settings (
        id INT PRIMARY KEY IDENTITY(1,1),
        hospital_name NVARCHAR(200) NOT NULL,
        hospital_address NVARCHAR(500),
        hospital_phone NVARCHAR(50),
        hospital_email NVARCHAR(100),
        hospital_website NVARCHAR(200),
        sidebar_logo_path NVARCHAR(500),
        print_header_logo_path NVARCHAR(500),
        print_header_text NVARCHAR(1000),
        created_date DATETIME DEFAULT GETDATE(),
        updated_date DATETIME DEFAULT GETDATE()
    );

    -- Insert default settings
    INSERT INTO hospital_settings (
        hospital_name,
        hospital_address,
        hospital_phone,
        hospital_email,
        hospital_website,
        sidebar_logo_path,
        print_header_logo_path,
        print_header_text
    ) VALUES (
        'Jubba Hospital',
        'Kismayo, Somalia',
        '+252-XXX-XXXX',
        'info@jubbahospital.com',
        'www.jubbahospital.com',
        'assets/img/j.png',
        'assets/img/j.png',
        'Quality Healthcare Services'
    );

    PRINT 'hospital_settings table created and default data inserted successfully.';
END
ELSE
BEGIN
    PRINT 'hospital_settings table already exists.';
END
GO
