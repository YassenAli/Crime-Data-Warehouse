drop table CrimeFinalWC;
drop table CrimeDataNormalized;
drop table PremiseCodeDescription;
drop table StatusCodeDescription;
drop table WeaponCodeDescription;
drop table CrimeCodeDescription;
drop table AreaCodeDescription;
--------------------------------------
--------------------------------------
select top(200)* from CrimeFinalWC;
select top(200)* from CrimeDataNormalized;
select * from PremiseCodeDescription;
select * from StatusCodeDescription;
select * from WeaponCodeDescription;
select * from CrimeCodeDescription;
select * from AreaCodeDescription;

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CrimeDB')
BEGIN
    CREATE DATABASE CrimeDB;
END
GO

USE CrimeDB;
GO


CREATE TABLE dbo.PremiseCodeDescription (
    PremiseCode       VARCHAR(7)   NOT NULL PRIMARY KEY,
    PremiseDescription VARCHAR(255) NOT NULL,
    LastModified      DATETIME     NOT NULL 
        CONSTRAINT DF_PremiseCode_LastModified DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_PremiseCode_UpdateTimestamp
ON dbo.PremiseCodeDescription
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET LastModified = GETDATE()
    FROM dbo.PremiseCodeDescription AS p
    JOIN inserted AS i
      ON p.PremiseCode = i.PremiseCode;
END
GO


CREATE TABLE dbo.StatusCodeDescription (
    [Status]    VARCHAR(12)  NOT NULL PRIMARY KEY,
    StatusDesc  VARCHAR(255) NOT NULL,
    LastModified DATETIME    NOT NULL
        CONSTRAINT DF_Status_LastModified DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_Status_UpdateTimestamp
ON dbo.StatusCodeDescription
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE s
    SET LastModified = GETDATE()
    FROM dbo.StatusCodeDescription AS s
    JOIN inserted AS i
      ON s.[Status] = i.[Status];
END
GO



CREATE TABLE dbo.WeaponCodeDescription (
    WeaponUsedCode    VARCHAR(7)   NOT NULL PRIMARY KEY,
    WeaponDescription VARCHAR(255) NOT NULL,
    LastModified      DATETIME     NOT NULL
        CONSTRAINT DF_Weapon_LastModified DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_Weapon_UpdateTimestamp
ON dbo.WeaponCodeDescription
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE w
    SET LastModified = GETDATE()
    FROM dbo.WeaponCodeDescription AS w
    JOIN inserted AS i
      ON w.WeaponUsedCode = i.WeaponUsedCode;
END
GO



CREATE TABLE dbo.CrimeCodeDescription (
    CrimeCode            VARCHAR(7)   NOT NULL PRIMARY KEY,
    CrimeCodeDescription VARCHAR(255) NOT NULL,
    LastModified         DATETIME     NOT NULL
        CONSTRAINT DF_CrimeCode_LastModified DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_CrimeCode_UpdateTimestamp
ON dbo.CrimeCodeDescription
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE c
    SET LastModified = GETDATE()
    FROM dbo.CrimeCodeDescription AS c
    JOIN inserted AS i
      ON c.CrimeCode = i.CrimeCode;
END
GO



CREATE TABLE dbo.AreaCodeDescription (
    AreaCode     VARCHAR(7)   NOT NULL PRIMARY KEY,
    AreaName     VARCHAR(255) NOT NULL,
    LastModified DATETIME     NOT NULL
        CONSTRAINT DF_Area_LastModified DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_Area_UpdateTimestamp
ON dbo.AreaCodeDescription
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE a
    SET LastModified = GETDATE()
    FROM dbo.AreaCodeDescription AS a
    JOIN inserted AS i
      ON a.AreaCode = i.AreaCode;
END
GO

CREATE TABLE dbo.CrimeDataNormalized (
    DigitalRecordNumber VARCHAR(12) NOT NULL PRIMARY KEY,
    DateReported        DATE         NOT NULL,
    DateOfOccurrence    DATE         NOT NULL,
    TimeOfOccurrence    TIME(7)      NULL,
    AreaCode            VARCHAR(7)   NOT NULL,
    SubAreaNumber       VARCHAR(7)   NULL,
    CrimeCode           VARCHAR(7)   NOT NULL,
    PremiseCode         VARCHAR(7)   NULL,
    WeaponUsedCode      VARCHAR(7)   NOT NULL,
    [Status]            VARCHAR(12)  NOT NULL,
    VictimAge           INT          NULL,
    VictimGender        CHAR(1)      NULL CHECK (VictimGender IN ('F','M','X')),
    VictimOriginalCountry VARCHAR(255) NULL,
    Latitude            FLOAT        NULL,
    Longitude           FLOAT        NULL,
    [Location]          VARCHAR(255) NULL,
    LastModified        DATETIME     NOT NULL
        CONSTRAINT DF_CrimeData_LastModified DEFAULT GETDATE(),

    CONSTRAINT FK_CrimeData_AreaCode   FOREIGN KEY (AreaCode)          REFERENCES dbo.AreaCodeDescription(AreaCode),
    CONSTRAINT FK_CrimeData_CrimeCode  FOREIGN KEY (CrimeCode)         REFERENCES dbo.CrimeCodeDescription(CrimeCode),
    CONSTRAINT FK_CrimeData_Premise    FOREIGN KEY (PremiseCode)       REFERENCES dbo.PremiseCodeDescription(PremiseCode),
    CONSTRAINT FK_CrimeData_Weapon     FOREIGN KEY (WeaponUsedCode)    REFERENCES dbo.WeaponCodeDescription(WeaponUsedCode),
    CONSTRAINT FK_CrimeData_Status     FOREIGN KEY ([Status])          REFERENCES dbo.StatusCodeDescription([Status])
);

GO

CREATE TRIGGER trg_CrimeData_UpdateTimestamp
ON dbo.CrimeDataNormalized
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE cd
    SET LastModified = GETDATE()
    FROM dbo.CrimeDataNormalized AS cd
    JOIN inserted AS i
      ON cd.DigitalRecordNumber = i.DigitalRecordNumber;
END
GO