drop table ConfigTable;
drop table stg_Premise;
drop table stg_Status;
drop table stg_Weapon ;
drop table stg_CrimeType ;
drop table stg_Area ;
drop table stg_CrimeData;
-----------------------------------------------------Configuration table-----------------------------------------------------------------
CREATE TABLE ConfigTable (
    TableName VARCHAR(255) PRIMARY KEY,
    LastExtractedDate DATETIME
);

-- Insert initial data for each table
INSERT INTO ConfigTable (TableName, LastExtractedDate)
VALUES 
    ('PremiseCodeDescription', '1900-01-01'),
    ('StatusCodeDescription', '1900-01-01'),
    ('WeaponCodeDescription', '1900-01-01'),
    ('CrimeCodeDescription', '1900-01-01'),
    ('AreaCodeDescription', '1900-01-01'),
    ('CrimeDataNormalized', '1900-01-01');

--Update ConfigTable SET LastExtractedDate = '1900-01-01' where TableName = 'CrimeDataNormalized';

----------------------------------------------------------Staging Creation----------------------------------------------------

CREATE TABLE stg_Premise (
    PremiseCode VARCHAR(7),
    PremiseDescription VARCHAR(255),

    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TABLE stg_Status (
    [Status] VARCHAR(12),
    StatusDesc VARCHAR(255),

    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TABLE stg_Weapon (
    WeaponUsedCode VARCHAR(7),
    WeaponDescription VARCHAR(255),

    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TABLE stg_CrimeType (
    CrimeCode VARCHAR(7),
    CrimeCodeDescription VARCHAR(255),

    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TABLE stg_Area (
    AreaCode VARCHAR(7),
    AreaName VARCHAR(255),
    
    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
CREATE TABLE stg_CrimeData (

    DigitalRecordNumber VARCHAR(12),
    DateReported DATE,
    DateOfOccurrence DATE,
    TimeOfOccurrence TIME(7),
    AreaCode VARCHAR(7),
    SubAreaNumber VARCHAR(7),
    CrimeCode VARCHAR(7),
    PremiseCode VARCHAR(7),
    WeaponUsedCode VARCHAR(7),
    [Status] VARCHAR(12),
    VictimAge INT,
    VictimGender CHAR(1),
    VictimOriginalCountry VARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT,
    [Location] VARCHAR(255),

    -- Tracking columns
    src_update_date DATETIME NULL,
    create_timestamp DATETIME DEFAULT GETDATE()
);
-------------------------------------------------------select statement-------------------------
select* from ConfigTable ;
select * from stg_Premise ;
select * from stg_Status;
select * from stg_Weapon;
select * from stg_CrimeType;
select * from stg_Area ;
select *  from stg_CrimeData ;