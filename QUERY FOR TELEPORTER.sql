create database g7test1
use g7test1
CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL,
    Timezone VARCHAR(50) NOT NULL
);

CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    Company_Location VARCHAR(100),
    CountryID INT FOREIGN KEY REFERENCES Country(CountryID)
);

CREATE TABLE Contracts (
    ContractID INT PRIMARY KEY,
    CountryID INT FOREIGN KEY REFERENCES Country(CountryID),
    CompanyID INT FOREIGN KEY REFERENCES Company(CompanyID),
    Contract_Status VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Position VARCHAR(100),
    CompanyID INT FOREIGN KEY REFERENCES Company(CompanyID)
);

CREATE TABLE Operator (
    OperatorID INT PRIMARY KEY,
    OperatorName VARCHAR(100),
    EmployeeID INT UNIQUE FOREIGN KEY REFERENCES Employee(EmployeeID)
);

CREATE TABLE Portal (
    TP_ID INT PRIMARY KEY,
    TP_Status VARCHAR(50),
    CompanyID INT FOREIGN KEY REFERENCES Company(CompanyID)
);

CREATE TABLE Traveler (
    TravelerID INT PRIMARY KEY,
    TravelerName VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    PassportNumber VARCHAR(50) UNIQUE,
	CountryID INT FOREIGN KEY REFERENCES Country(CountryID)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    BookingDate DATE,
	PaymentID INT UNIQUE,
    FromCountryID INT FOREIGN KEY REFERENCES Country(CountryID),
    ToCountryID INT FOREIGN KEY REFERENCES Country(CountryID),
    TP_ID INT FOREIGN KEY REFERENCES Portal(TP_ID),
    TravelerID INT FOREIGN KEY REFERENCES Traveler(TravelerID)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    PaymentDate DATE,
    Amount DECIMAL(10, 2),
    Method VARCHAR(50),
    PaymentStatus VARCHAR(50),
    BookingID INT UNIQUE,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

CREATE TABLE TeleportationLogs (
    Log_ID INT PRIMARY KEY,
    TP_ID INT FOREIGN KEY REFERENCES Portal(TP_ID),
    OperatorID INT FOREIGN KEY REFERENCES Operator(OperatorID),
    BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
    TeleLog_Status VARCHAR(100)
);

/*Teleports by country*/
SELECT 
    C.CountryName,
    COUNT(*) AS TeleportCount
FROM (
    SELECT FromCountryID AS CountryID FROM Booking
    UNION ALL
    SELECT ToCountryID AS CountryID FROM Booking
) AS TeleportCountry
inner JOIN Country C ON TeleportCountry.CountryID = C.CountryID
GROUP BY C.CountryName
ORDER BY TeleportCount DESC;

/*Global revenue*/
select sum(Amount) as GlobalRevenue from Payment;
select avg(amount) as AverageBookingPrice from Payment;
select count(Log_ID) AS GlobalNumberOfTeleports   from TeleportationLogs where TeleLog_Status = 'Success';
select count(BookingID) AS GlobalNumberOfBooking   from Booking

/*Payment method allocation*/
Select Method,count(PaymentStatus)as TotalStatus  from Payment group by Method;

/*Bookings by time*/
SELECT 
    DATENAME(MONTH, BookingDate) AS MonthName,
    COUNT(BookingID) AS TotalBookings
FROM Booking
GROUP BY DATENAME(MONTH, BookingDate)
ORDER BY DATEPART(MONTH, MIN(BookingDate));

/*Number of teleports per portal*/
 SELECT TP_ID,COUNT(Log_ID) AS NumberOfTeleports FROM TeleportationLogs GROUP BY TP_ID ORDER BY NumberOfTeleports DESC;


/*Top 10 companies with the most portal*/
SELECT TOP 10 CompanyID,COUNT(TP_ID) AS NumberOfPortals FROM Portal GROUP BY CompanyID ORDER BY NumberOfPortals DESC, CompanyID ASC;

/*Top 10 companies with the most teleports*/
select top 10 CompanyID,count(TP_ID) as NumbersOfTeleport from Portal group by CompanyID order by NumbersOfTeleport desc, CompanyID asc;

/*Productivity activity ratio by portal*/ 
select TP_Status,count(TP_ID) from Portal group by TP_Status



/**/





