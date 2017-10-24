--Exercises: Table Relations

CREATE DATABASE Exercises
USE Exercises

--Problem 1.One-To-One Relationship
CREATE TABLE Passports
(
PassportId INT NOT NULL,
PassportNumber NVARCHAR(50) NOT NULL,
)
CREATE TABLE Persons
(
PersonId INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
Salary DECIMAL(8,2),
PassportId INT NOT NULL
)

INSERT INTO Persons VALUES
(1,'Roberto',43300.00,102),
(2,'Tom',56100.00,103),
(3,'Yana',60200.00,101)

INSERT INTO Passports VALUES
(101,'N34FG21B'),
(102,'K65LO4R7'),
(103,'ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_PersonId 
PRIMARY KEY (PersonId)

ALTER TABLE Passports
ADD CONSTRAINT PK_PassportsId
PRIMARY KEY (PassportId)

ALTER TABLE Persons
ADD CONSTRAINT FK_PassportId
FOREIGN KEY (PassportId) 
REFERENCES Passports(PassportId)

--Problem 2.One-To-Many Relationship
CREATE  TABLE Models
(
	ModelID int NOT NULL,
	Name varchar(50),
	ManufacturerID int NOT NULL
)

CREATE TABLE Manufacturers
(
	ManufacturerID int NOT NULL,
	Name varchar(50),
	EstablishedOn date
)

INSERT INTO Models VALUES
(101,'X1',1),
(102,'i6',1),
(103,'Model S',2),
(104,'Model X',2),
(105,'Model 3',2),
(106,'Nova',3)

INSERT INTO Manufacturers VALUES
(1,'BMW','1916-03-07'),
(2,'Tesla','2003-01-01'),
(3,'Lada','1966-05-01')

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_ManufacterId
PRIMARY KEY (ManufacturerID)

ALTER TABLE Models 
ADD CONSTRAINT PK_ModelID
PRIMARY KEY (ModelID)

ALTER TABLE Models
ADD CONSTRAINT FK_ManufacturerID
FOREIGN KEY (ManufacturerID)
REFERENCES Manufacturers(ManufacturerID)

--Problem 3.Many-To-Many Relationship
CREATE TABLE Students
(
	StudentID int NOT NULL,
	Name varchar(50) NOT NULL,
)

CREATE TABLE Exams
(
	ExamID int NOT NULL,
	Name varchar(50) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID int NOT NULL,
	ExamID int NOT NULL
)

INSERT INTO Students VALUES
(1,'Mila'),
(2,'Toni'),
(3,'Ron')

INSERT INTO Exams VALUES
(101,'SpringMVC'),
(102,'Neo4j'),
(103,'Oracle 11g')

INSERT INTO StudentsExams VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)

ALTER TABLE Students
ADD CONSTRAINT PK_StudentID
PRIMARY KEY (StudentID)

ALTER TABLE Exams
ADD CONSTRAINT PK_ExamID
PRIMARY KEY (ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT PK_StudentID_ExamID
PRIMARY KEY (StudentID, ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentID_StudentsID
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_ExamID_ExamID
FOREIGN KEY (ExamID)
REFERENCES Exams(ExamID)

--Problem 4.Self-Referencing 
CREATE TABLE Teachers
(
	TeacherID int PRIMARY KEY IDENTITY(101,1),
	Name varchar(50) NOT NULL,
	ManagerID int
)

INSERT INTO Teachers VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

ALTER TABLE Teachers
ADD CONSTRAINT FK_TeacherID_ManagerID
FOREIGN KEY (ManagerID)
REFERENCES Teachers(TeacherID)

--Problem 5.Online Store Database
CREATE TABLE Orders
(
	OrderID int PRIMARY KEY,
	CustomerID int
)

CREATE TABLE Customers
(
	CustomerID int PRIMARY KEY,
	Name varchar(50) NOT NULL,
	Birthday date,
	CityID int
)

CREATE TABLE Cities
(
	CityID int PRIMARY KEY,
	Name varchar(50)
)

CREATE TABLE OrderItems
(
	OrderID int NOT NULL,
	ItemID int NOT NULL
)

CREATE TABLE Items
(
	ItemID int PRIMARY KEY,
	Name varchar(50),
	ItemTypeID int	
)

CREATE TABLE ItemTypes
(
	ItemTypeID int PRIMARY KEY,
	Name varchar(50)
)
ALTER TABLE OrderItems
ADD CONSTRAINT PK_OrderID_ItemID
PRIMARY KEY (OrderId, ItemID)

ALTER TABLE Orders
ADD CONSTRAINT FK_CustomerID_CustomerID
FOREIGN KEY (CustomerID)
REFERENCES Customers (CustomerID)

ALTER TABLE Customers
ADD CONSTRAINT FK_CityID_CityID
FOREIGN KEY (CityID)
REFERENCES Cities(CityID)

ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderID_OrderID
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID)

ALTER TABLE OrderItems
ADD CONSTRAINT FK_ItemID_ItemID
FOREIGN KEY (ItemID)
REFERENCES Items(ItemID)

ALTER TABLE Items
ADD CONSTRAINT FK_ItemTypeID_ItemTypeID
FOREIGN KEY (ItemTypeId)
REFERENCES ItemTypes(ItemTypeID)

--Problem 6.University Database
CREATE TABLE Majors
(
	MajorID int PRIMARY KEY,
	Name varchar(50)
)

CREATE TABLE Students
(
	StudentID int PRIMARY KEY,
	StudentNumber int,
	StudentName varchar(50),
	MajorID int
)

CREATE TABLE Payments
(
	PaymentID int PRIMARY KEY,
	PaymentDate date,
	PaymentAmount decimal(8,2),
	StudentID int
)

CREATE TABLE Agenda
(
	StudentID int NOT NULL,
	SubjectID int NOT NULL
)

CREATE TABLE Subjects
(
	SubjectID int PRIMARY KEY,
	SubjectName varchar(50)
)

ALTER TABLE Agenda
ADD CONSTRAINT PK_StudentID_SubjectID
PRIMARY KEY (StudentID, SubjectID)

ALTER TABLE Students
ADD CONSTRAINT FK_MajorID_MajorID
FOREIGN KEY (MajorID)
REFERENCES Majors(MajorID)

ALTER TABLE Payments
ADD CONSTRAINT FK_StudenID_StudentID
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_StudentID_StudentID
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_SubjectID_SubjectID
FOREIGN KEY (SubjectID)
REFERENCES Subjects(SubjectID)
