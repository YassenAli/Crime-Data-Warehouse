Drop table FactCrimeSummary;
Drop table FactVictimAnalysis;
Drop table FactCrimeTime;
Drop table FactCaseStatus;
Drop table DimArea;
Drop table DimCrimeType;
Drop table DimWeapon;
Drop table DimStatus;
Drop table DimPremise;
Drop table Temp;
Drop table DimDate;


Drop table DimTime;
select * from DimTime
----------------------------------------------creating tables----------------------------------
CREATE TABLE DimTime (
    TimeKey INT PRIMARY KEY, 
    Hour INT,
    Minute INT,
    TimeLabel VARCHAR(10), 
    PeriodOfDay VARCHAR(20) 
);
--


CREATE TABLE DimArea (
    AreaKey INT IDENTITY(1,1) PRIMARY KEY,     
    AreaCode VARCHAR(7),
    AreaName VARCHAR(255),                  
    src_date DATE,                             -- From staging (when extracted)
    inserted_at DATETIME DEFAULT GETDATE()     -- When inserted into DW
);

CREATE TABLE DimCrimeType (
    CrimeKey INT IDENTITY(1,1) PRIMARY KEY,
    CrimeCode VARCHAR(7) NOT NULL,
    CrimeCodeDescription VARCHAR(255),

    src_update_date DATETIME,
    create_timestamp DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimWeapon (
    WeaponKey INT IDENTITY(1,1) PRIMARY KEY,
    WeaponUsedCode VARCHAR(7),
    WeaponDescription VARCHAR(255),
	src_update_date DATETIME,
    create_timestamp DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimStatus (
    StatusKey INT IDENTITY(1,1) PRIMARY KEY,       
    StatusCode VARCHAR(12) NOT NULL,               
    StatusDescription VARCHAR(255) NOT NULL,       
    src_update_date DATETIME,                      
    create_timestamp DATETIME DEFAULT GETDATE()    
);

CREATE TABLE DimPremise (
    PremiseKey INT IDENTITY(1,1) PRIMARY KEY,
    PremiseCode VARCHAR(12) ,
    PremiseDescription VARCHAR(255),
    IsCurrent BIT DEFAULT 1,                  
    EffectiveDate DATETIME,                   
    ExpiryDate DATETIME NULL,                 
    src_update_date DATETIME,                 
    create_timestamp DATETIME DEFAULT GETDATE()  
);
CREATE TABLE Temp (
    DateKey INT IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE   NOT NULL,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    MonthName VARCHAR(20),
    DayName VARCHAR(20),
    DayOfWeek INT,
    IsWeekend BIT
);

 CREATE TABLE DimDate (
    DateKey INT IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE  UNIQUE NOT NULL,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    MonthName VARCHAR(20),
    DayName VARCHAR(20),
    DayOfWeek INT,
    IsWeekend BIT
);

CREATE TABLE FactCrimeSummary (
  FactCrimeSummaryKey INT IDENTITY(1,1) PRIMARY KEY,
  DateKey           INT NOT NULL,
  AreaKey           INT NOT NULL,
  CrimeTypeKey      INT NOT NULL,
  WeaponKey         INT NOT NULL,
  PremiseKey         INT NOT NULL,
  CrimeCount        INT,

  CONSTRAINT FK_FactCrimeSummary_Date FOREIGN KEY(DateKey) REFERENCES DimDate(DateKey),
  CONSTRAINT FK_FactCrimeSummary_Area FOREIGN KEY(AreaKey) REFERENCES DimArea(AreaKey),
  CONSTRAINT FK_FactCrimeSummary_Premise FOREIGN KEY(PremiseKey) REFERENCES DimPremise(PremiseKey),
  CONSTRAINT FK_FactCrimeSummary_CrimeType FOREIGN KEY(CrimeTypeKey) REFERENCES DimCrimeType(CrimeKey),
  CONSTRAINT FK_FactCrimeSummary_Weapon FOREIGN KEY(WeaponKey) REFERENCES DimWeapon(WeaponKey)
);
CREATE TABLE FactVictimAnalysis (
  FactVictimAnalysisKey INT IDENTITY(1,1) PRIMARY KEY,
  DateKey            INT     NOT NULL,
  CrimeTypeKey       INT     NOT NULL,
  VictimCount        INT     NULL,
  SumVictimAge       INT     NULL,
  AvgVictimAge       DECIMAL(5,2) NULL, -- SumVictimAge / VictimCount

  CONSTRAINT FK_FactVictim_Date      FOREIGN KEY(DateKey)      REFERENCES DimDate(DateKey),
  CONSTRAINT FK_FactVictim_CrimeType FOREIGN KEY(CrimeTypeKey) REFERENCES DimCrimeType(CrimeKey)
);

CREATE TABLE FactCrimeTime (
  FactCrimeTimeKey INT IDENTITY(1,1) PRIMARY KEY,
  DateKey          INT NOT NULL,
  TimeKey          INT NOT NULL,
  AreaKey          INT NOT NULL,
  CrimeCount       INT,

  CONSTRAINT FK_FactCrimeTime_Date FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey),
  CONSTRAINT FK_FactCrimeTime_Time FOREIGN KEY(TimeKey)  REFERENCES DimTime(TimeKey),
  CONSTRAINT FK_FactCrimeTime_Area FOREIGN KEY(AreaKey)  REFERENCES DimArea(AreaKey)
);
CREATE TABLE FactCaseStatus (
  FactCaseStatusKey INT IDENTITY(1,1) PRIMARY KEY,
  DateKey         INT     NOT NULL,
  StatusKey       INT     NOT NULL,
  AreaKey         INT     NOT NULL,
  CaseCount       INT,

  CONSTRAINT FK_FactCaseStatus_Date   FOREIGN KEY(DateKey)   REFERENCES DimDate(DateKey),
  CONSTRAINT FK_FactCaseStatus_Status FOREIGN KEY(StatusKey) REFERENCES DimStatus(StatusKey),
  CONSTRAINT FK_FactCaseStatus_Area   FOREIGN KEY(AreaKey)   REFERENCES DimArea(AreaKey)
);
--------------------------------------------select statements-----------------------
select * from DimArea ;
select * from  DimCrimeType ;
select * from DimWeapon ;
select * from DimStatus;
select * from DimPremise;
select * from Temp; 
select count(*) from DimDate;
select * from DimDate  ;
select * from DimTime;
select * from FactCrimeSummary;
select * from FactVictimAnalysis;
select * from FactCrimeTime;
select * from FactCaseStatus;