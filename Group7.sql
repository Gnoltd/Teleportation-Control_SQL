create database group7
use group7

create table Country
(
CountryID int primary key not null ,
CountryName varchar (50) not null,
TimeZone varchar(4) check ( TimeZone like 'UTC%')
);
create table Company
(
CompanyID int primary key not null,
CompanyName varchar(50),
CountryID int not null,
constraint fk_company foreign key (CountryID) references Country(CountryID) 
);
create table Operator
(
OperatorID int primary key not null,
OperatorName varchar(50),
CompanyID int not null,
constraint fk_operator foreign key (CompanyID) references Company(CompanyID), 
EmployeeID int not null,
);
create table Traveler
(
TravelerID int not null,
TravelerName varchar(50),
DOB date,
Gender varchar(6) check (gender in ( 'Male', 'Female')),
CompanyID int not null,
PassportID int  not null,
constraint pk_traveler primary key (TravelerID),
constraint fk_operator1 foreign key (CompanyID) references Company(CompanyID)
);

create table TeleportationLogs
(
LogID int primary key not null,	
OperatorID int  not null,
TravelerID int  not null,
FromCountryID int not null,
ToCountryID int not null,
TeleportTime date  default getdate() not null,
constraint fk1_telelog foreign key (OperatorID ) references Operator(OperatorID),
constraint fk2_telelog foreign key (TravelerID) references Traveler(TravelerID), 
constraint fk3_telelog foreign key (FromCountryID) references Country(CountryID), 
constraint fk4_telelog foreign key (ToCountryID) references Country(CountryID)
);

create table Booking
(
BookingID int primary key not null,	
BookingTime date default getdate() not null,
FromCountryID int not null,
ToCountryID int not null,
TravelerID int  not null,
constraint fk1_book foreign key (TravelerID) references Traveler(TravelerID), 
constraint fk2_book foreign key (FromCountryID) references Country(CountryID), 
constraint fk3_book foreign key (ToCountryID) references Country(CountryID)
);

create table Teleporter
(
 TeleID int primary key not null,
 statusTele VARCHAR(20) NOT NULL CHECK (statusTele IN ('activated', 'deactivated')),
 countryID int not null,
 constraint fk_Teleporter foreign key (CountryID) references Country(CountryID) 
);
-- SCHEMA1
