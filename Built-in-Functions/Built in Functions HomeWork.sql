--Part I – Queries for SoftUni Database

USE SoftUni
--Problem 1.Find Names of All Employees by First Name
SELECT FirstName,LastName
  FROM Employees
 WHERE FirstName LIKE 'SA%'

--Problem 2.Find Names of All employees by Last Name 
SELECT  FirstName,LastName
  FROM Employees
 WHERE LastName LIKE '%EI%'

--Problem 3.Find First Names of All Employees
SELECT FirstName
  FROM Employees
 WHERE DepartmentID = 3 OR DepartmentID = 10 AND YEAR(HireDate)BETWEEN '1995' AND '2005'

--Problem 4.Find All Employees Except Engineers
SELECT FirstName,LastName
  FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%'

--Problem 5.Find Towns with Name Length
SELECT Name
  FROM Towns
 WHERE LEN(NAME)=5 OR LEN(NAME)=6
 ORDER BY Name

--Problem 6.Find Towns Starting With
SELECT TownID,Name
  FROM Towns
 WHERE Name LIKE 'M%' OR Name LIKE 'K%' OR Name LIKE 'B%' OR Name LIKE 'E%'
 ORDER BY Name

--Problem 7.Find Towns Not Starting With
SELECT TownID,Name
  FROM Towns
 WHERE Name NOT LIKE 'R%' AND Name NOT LIKE 'B%' AND Name NOT LIKE 'D%'
 ORDER BY Name

--Problem 8.Create View Employees Hired After 2000 Year
GO
CREATE VIEW V_EmployeesHiredAfter2000 
    AS
SELECT FirstName,LastName
  FROM Employees
 WHERE YEAR(HireDate)>'2000'
GO

--Problem 9.Length of Last Name
SELECT FirstName,LastName
  FROM Employees
 WHERE LEN(LastName) = 5


--Part II – Queries for Geography Database 

USE Geography

--Problem 10.Countries Holding ‘A’ 3 or More Times
SELECT CountryName,IsoCode
  FROM Countries
 WHERE CountryName LIKE '%A%A%A%'
 ORDER BY IsoCode

--Problem 11.Mix of Peak and River Names
SELECT PeakName, RiverName, LOWER(SUBSTRING(PeakName, 1, LEN(PeakName) - 1) + RiverName) AS Mix
  FROM Peaks JOIN Rivers
    ON RIGHT(Peaks.PeakName, 1) = LEFT(Rivers.RiverName, 1)
 ORDER BY Mix


--Part III – Queries for Diablo Database

USE Diablo

--Problem 12.Games from 2011 and 2012 year
SELECT TOP 50 Name,FORMAT(Start,'yyyy-MM-dd')AS Start
  FROM Games
 WHERE YEAR(Start) BETWEEN '2011' AND '2012'
 ORDER BY Start,Name

--Problem 13.User Email Providers
SELECT Username,RIGHT(Email,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider]
  FROM Users
 ORDER BY [Email Provider],Username
  
--Problem 14.Get Users with IPAdress Like Pattern
SELECT Username,IpAddress AS[IP Address]
  FROM Users
 WHERE IpAddress LIKE '___.1%.%.___'
 ORDER BY Username

--Problem 15.Show All Games with Duration and Part of the Day
SELECT Name AS Game, 
IIF(DATEPART(HH, Start) >= 18, 'Evening', 
IIF(DATEPART(HH, Start) >= 12, 'Afternoon', 'Morning')) AS [Part of the Day], 
IIF(Duration IS NULL, 'Extra Long',
IIF(Duration > 6, 'Long', 
IIF(Duration >= 4, 'Short', 'Extra Short'))) AS Duration FROM Games
ORDER BY Game, Duration, [Part of the Day]


--Part IV – Date Functions Queries

USE Orders

--Problem 16.Orders Table
SELECT ProductName,OrderDate,
DATEADD(DAY,3,OrderDate)AS[Pay Due],
DATEADD(MONTH,1,OrderDate)AS[Deliver Due]
FROM Orders