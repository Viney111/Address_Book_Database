--UC1 Creating Database
CREATE DATABASE Address_Book_Service
USE Address_Book_Service;

--UC2 Adding Attributes to Table
CREATE TABLE AddressBookTable
(
FirstName VARCHAR(15) NOT NULL,
LastName VARCHAR(20),
Address VARCHAR(50) NOT NULL,
City VARCHAR(15) NOT NULL,
State VARCHAR(15) NOT NULL,
Zip CHAR(6) NOT NULL,
PhoneNo CHAR(10) NOT NULL,
Email VARCHAR(30) NOT NULL
)
SELECT * FROM AddressBookTable

ALTER TABLE AddressBookTable
ALTER COLUMN Zip INT;
ALTER TABLE AddressBookTable
ALTER COLUMN PhoneNo BIGINT;

--UC3 Inserting Values into the Table
INSERT INTO AddressBookTable(FirstName,LastName,Address,City,State,Zip,PhoneNo,Email)
VALUES
('VINEY','KHANEJA','BadaPanna,VPOKalanaur','Rohtak','Haryana',124113,7206594149,'vineykhaneja999@gmail.com'),
('VISHAL','JUNEJA','BadaPanna,VPOKalanaur','Rohtak','Haryana',124113,8950595579,'vishaljuneja999@gmail.com'),
('YASH','ARORA','ChottaPanna,VPOKalanaur','Rohtak','Haryana',124113,7015906292,'yasharora999@gmail.com');

--UC4 Updating or Editing Records by Name
UPDATE AddressBookTable SET Zip = 124001 WHERE FirstName = 'Yash';
UPDATE AddressBookTable SET City = 'Sirsa' WHERE FirstName = 'Vishal';
UPDATE AddressBookTable SET State = 'Punjab' WHERE FirstName = 'Vishal';
SELECT * FROM AddressBookTable

--UC5 Deleting a Person Contact using Name
DELETE FROM AddressBookTable WHERE FirstName = 'Yash';

--UC6 Retrieving Person Details from His state or City Name
SELECT * FROM AddressBookTable WHERE City = 'Rohtak' OR State = 'Punjab';
SELECT * FROM AddressBookTable WHERE City = 'Rohtak' AND State = 'hARYANA';


INSERT INTO AddressBookTable(FirstName,LastName,Address,City,State,Zip,PhoneNo,Email)
VALUES
('RAHUL','JUNEJA','ChottaPanna,VPOKalanaur','Rohtak','Haryana',124113,8952147891,'rahuljuneja999@gmail.com'),
('YASH','ARORA','ChottaPanna,VPOKalanaur','Rohtak','Haryana',124113,7015906292,'yasharora999@gmail.com');

--UC7 Size Of AddressBook By City & State
SELECT COUNT(*) AS CityCount,City FROM AddressBookTable GROUP BY City;

SELECT COUNT(*) AS StateCount,State FROM AddressBookTable GROUP BY State;

--UC8 Retrive Entries Sorted Alphabatically by Person's Name For Given City
SELECT * FROM AddressBookTable WHERE City = 'Rohtak' ORDER BY FirstName;

--UC9 Ability to Identify Contacts by Type & AddressBookName
ALTER TABLE AddressBookTable
ADD Type VARCHAR(15);
ALTER TABLE AddressBookTable
ADD AddressBookName VARCHAR(30);

UPDATE AddressBookTable SET Type = 'Friends' WHERE City = 'Rohtak';
UPDATE AddressBookTable SET Type = 'Family' WHERE NOT City  = 'Rohtak';
UPDATE AddressBookTable SET Type = 'Profession' WHERE FirstName  = 'Yash';
UPDATE AddressBookTable SET AddressBookName = 'Jigri Yaar' WHERE FirstName  = 'Vishal';
UPDATE AddressBookTable SET AddressBookName = 'Jigri Yaar' WHERE FirstName  = 'Viney';
UPDATE AddressBookTable SET AddressBookName = 'Normal Yaar' WHERE FirstName  = 'Yash';
UPDATE AddressBookTable SET AddressBookName = 'Normal Yaar' WHERE FirstName  = 'Rahul';

--UC10 Ability to get Number Of Contact Persons by Count By Type
SELECT Type,COUNT(Type) AS NumberOfContactPersons FROM AddressBookTable GROUP BY Type;

--UC11 Ability to Add Person to both Friend & Family
INSERT INTO AddressBookTable(FirstName,LastName,Address,City,State,Zip,PhoneNo,Email,Type)
VALUES
('VINEY','KHANEJA','BadaPanna,VPOKalanaur','Rohtak','Haryana',124113,7206594149,'vineykhaneja999@gmail.com','Family');

--UC12 Drawing ER Diagrams after identifying Entities using Normalization
--Creating Entities of AddressBookName, ConactDetails, TypeDetais & Type Manager

DROP TABLE AddressBookTable;

CREATE TABLE AddressBookNameTable
(
AddressBookId INT IDENTITY (1,1) PRIMARY KEY,
AddressBookName VARCHAR(50)
);
SELECT * FROM AddressBookNameTable;
INSERT INTO AddressBookNameTable
VALUES('JigriYaar'),('NormalYaar');

CREATE TABLE PersonContactsTable
(
PersonID INT IDENTITY (1,1) PRIMARY KEY,
FirstName VARCHAR(30),
LastName VARCHAR(50),
AddressDetails VARCHAR(150),
City VARCHAR(50),
StateName VARCHAR (50),
Zip INT,
PhoneNo BIGINT,
Email VARCHAR(60),
AddressBookSelect INT,
FOREIGN KEY (AddressBookSelect) REFERENCES AddressBookNameTable(AddressBookId)
);

SELECT * FROM PersonContactsTable

INSERT INTO PersonContactsTable
VALUES
('VINEY','KHANEJA','BadaPanna,VPOKalanaur','Rohtak','Haryana',124113,7206594149,'vineykhaneja999@gmail.com',1),
('VISHAL','JUNEJA','BadaPanna,VPOKalanaur','Sonepat','Haryana',156321,8950595579,'vishaljuneja999@gmail.com',1),
('YASH','ARORA','ChottaPanna,VPOKalanaur','Rohtak','Haryana',135001,7015906292,'yasharora999@gmail.com',2),
('RAHUL','JUNEJA','ChottaPanna,VPOKalanaur','Rohtak','Haryana',124001,8952147891,'rahuljuneja999@gmail.com',2),
('BUNNY','SARDAR','ModelTown','Hisar','Haryana',140001,9034267666,'bunnysardaar999@gmail.com',1);

CREATE TABLE TypeEntityTable
(
TypeID INT IDENTITY (1,1) PRIMARY KEY,
TypeName VARCHAR(30)
);
SELECT * FROM TypeEntityTable

INSERT INTO TypeEntityTable
VALUES ('Friend'),('Professional'),('Family'),('BusinessMan'),('College');


CREATE TABLE TypeHandler
(
TypeSelect INT,
PersonSelect INT,
FOREIGN KEY (TypeSelect) REFERENCES TypeEntityTable(TypeID),
FOREIGN KEY (PersonSelect) REFERENCES PersonContactsTable(PersonID)
)

INSERT INTO TypeHandler
VALUES (1,1),(3,1),(1,2),(3,2),(2,3),(4,4),(1,5),(3,5),(5,5);
SELECT * FROM TypeHandler

SELECT PersonID,AddressBookName,FirstName,LastName,AddressDetails,City,StateName,Zip,PhoneNo,Email,TypeName FROM AddressBookNameTable
INNER JOIN PersonContactsTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect
INNER JOIN TypeHandler ON PersonContactsTable.PersonID = TypeHandler.PersonSelect
INNER JOIN TypeEntityTable ON TypeHandler.TypeSelect = TypeEntityTable.TypeID

--UC13 Retrieving All data as Demanded in Prevoius UC's

--Retrieving Person Details from A Particular City or State
SELECT PersonID,AddressBookName,FirstName,LastName,AddressDetails,City,StateName,Zip,PhoneNo,Email,TypeName FROM AddressBookNameTable
INNER JOIN PersonContactsTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect AND City = 'Rohtak'
INNER JOIN TypeHandler ON PersonContactsTable.PersonID = TypeHandler.PersonSelect
INNER JOIN TypeEntityTable ON TypeHandler.TypeSelect = TypeEntityTable.TypeID

SELECT PersonID,AddressBookName,FirstName,LastName,AddressDetails,City,StateName,Zip,PhoneNo,Email FROM AddressBookNameTable
INNER JOIN PersonContactsTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect AND (City = 'Rohtak' AND StateName = 'Haryana')

SELECT PersonID,AddressBookName,CONCAT(FirstName,' ',LastName) AS FullName,CONCAT(AddressDetails,',',City,',',StateName,',',Zip) AS FullAddress,PhoneNo,Email FROM AddressBookNameTable
INNER JOIN PersonContactsTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect AND (City = 'Rohtak' AND StateName = 'Haryana')

SELECT COUNT(*),City FROM PersonContactsTable 
GROUP BY City

SELECT COUNT(*),City,StateName FROM PersonContactsTable 
GROUP BY City,StateName

--Sorting Alphabatically by First Name
SELECT PersonID,AddressBookName,CONCAT(FirstName,' ',LastName) AS FullName,CONCAT(AddressDetails,',',City,',',StateName,',',Zip) AS FullAddress,PhoneNo,Email,TypeName FROM PersonContactsTable
INNER JOIN AddressBookNameTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect
INNER JOIN TypeHandler ON PersonContactsTable.PersonID = TypeHandler.PersonSelect
INNER JOIN TypeEntityTable ON TypeHandler.TypeSelect = TypeEntityTable.TypeID
ORDER BY FirstName

SELECT COUNT(*) AS NoOfContacts,TypeName FROM PersonContactsTable
INNER JOIN AddressBookNameTable ON AddressBookNameTable.AddressBookId = PersonContactsTable.AddressBookSelect
INNER JOIN TypeHandler ON PersonContactsTable.PersonID = TypeHandler.PersonSelect
INNER JOIN TypeEntityTable ON TypeHandler.TypeSelect = TypeEntityTable.TypeID
GROUP BY TypeName


