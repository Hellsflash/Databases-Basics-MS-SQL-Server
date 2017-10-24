--Joins, Subqueries, CTE and Indices

USE SoftUni

--Problem 1.Employee Address
SELECT 
   TOP 5
       e.EmployeeID,
       e.JobTitle,
	   a.AddressID,
	   a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a
    ON a.AddressID =e.AddressID
 ORDER BY e.AddressID

--Problem 2.Addresses with Towns
SELECT
   TOP 50
       e.FirstName,
       e.LastName,
	   t.Name AS Town,
	   a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a
    ON a.AddressID=e.AddressID
  JOIN Towns AS t
    ON t.TownID = a.TownID
 ORDER BY FirstName,LastName

--Problem 3.Sales Employee
SELECT e.EmployeeID,
       e.FirstName,
	   e.LastName,
	   d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 WHERE d.Name = 'Sales'
 ORDER BY e.EmployeeID

--Problem 4.Employee Departments
SELECT
   TOP 5
       e.EmployeeID,
       e.FirstName,
	   e.Salary,
	   d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 WHERE e.Salary > '15000'
 ORDER BY e.DepartmentID

--Problem 5.Employees Without Project
SELECT 
   TOP 3
       e.EmployeeID,
	   e.FirstName 
  FROM Employees AS e
  LEFT OUTER JOIN EmployeesProjects AS ep
    ON ep.EmployeeID = e.EmployeeID 
 WHERE ep.EmployeeID IS NULL
 ORDER BY e.EmployeeID
  
--Problem 6.Employees Hired After
SELECT e.FirstName,
       e.LastName,
	   e.HireDate,
	   d.Name AS DeptName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID =e.DepartmentID
 WHERE d.Name ='Sales' 
    OR d.Name = 'Finance'
   AND e.HireDate >'01-01-1999'
 ORDER BY e.HireDate  
  
--Problem 7.Employees with Project
SELECT 
   TOP 5
       e.EmployeeID,
       e.FirstName,
	   p.Name AS ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep
    ON ep.EmployeeID =e.EmployeeID
  JOIN Projects as p
    ON p.ProjectID = ep.ProjectID
 WHERE p.StartDate > '2002-08-13'
   AND p.EndDate IS NULL
 ORDER BY e.EmployeeID

--Problem 8.Employee 24
SELECT e.EmployeeID,
       e.FirstName,
	   p.Name AS ProjectName
  FROM Employees AS e
  LEFT OUTER JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  LEFT OUTER JOIN Projects AS p
    ON p.ProjectID = ep.ProjectID
   AND p.StartDate < '2005-01-01'
 WHERE ep.EmployeeID = 24

--Problem 9.Employee Manager
SELECT e.EmployeeID,
       e.FirstName,
	   e.ManagerID,
	   em.FirstName AS ManagerName
  FROM Employees AS e
  JOIN Employees AS em
    ON em.EmployeeID = e.ManagerID
 WHERE em.EmployeeID = 3 
    OR em.EmployeeID = 7
 ORDER BY e.EmployeeID

--Problem 10.Employee Summary
SELECT 
   TOP 50
       e.EmployeeID,
	   e.FirstName + ' ' + e.LastName AS EmployeeName,
	   em.FirstName+ ' ' + em.LastName AS ManagerName,
	   d.Name AS DepartamentName
  FROM Employees AS e
  JOIN Employees AS em
    ON em.EmployeeID = e.ManagerID
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 ORDER BY e.EmployeeID

--Problem 11.Min Average Salary
SELECT 
   MIN(a.AverageSalary)AS MinAverageSalary
  FROM
  (
     SELECT e.DepartmentID,
	        AVG(e.Salary) AS AverageSalary
	   FROM Employees AS e
      GROUP BY e.DepartmentID
  )AS a

USE Geography

--Problem 12.Highest Peaks in Bulgaria
SELECT mc.CountryCode,
        m.MountainRange,
		p.PeakName,
		p.Elevation
  FROM MountainsCountries AS mc
  JOIN Mountains AS m
    ON m.Id = mc.MountainId
  JOIN Peaks AS p
    ON p.MountainId = m.Id
 WHERE p.Elevation > 2835 AND mc.CountryCode ='BG'
 ORDER BY Elevation DESC

--Problem 13.Count Mountain Ranges
SELECT mc.CountryCode,COUNT(m.Id) AS MountainRanges
  FROM MountainsCountries AS mc
  JOIN Mountains AS m
    ON mc.MountainId = m.Id
 GROUP BY mc.CountryCode
HAVING mc.CountryCode IN ('BG','RU','US')
 ORDER BY MountainRanges DESC

--Problem 14.Countries with Rivers
SELECT
   TOP 5
       c.CountryName,
       r.RiverName
  FROM Countries AS c
  FULL JOIN CountriesRivers as cr
    ON cr.CountryCode =c.CountryCode
  FULL JOIN Rivers as r
    ON r.Id = cr.RiverId
 WHERE c.ContinentCode = 'AF'
 ORDER BY c.CountryName

--Problem 15.*Continents and Currencies
SELECT rankedCurrencies.ContinentCode, rankedCurrencies.CurrencyCode, rankedCurrencies.[Count]
FROM 
(SELECT c.ContinentCode, c.CurrencyCode, COUNT(c.CurrencyCode) AS [Count], DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
FROM Countries AS c
GROUP BY c.ContinentCode, c.CurrencyCode) AS rankedCurrencies
WHERE rankedCurrencies.[rank] = 1 and rankedCurrencies.[Count] > 1

--Problem 16.Countries without any Mountains
SELECT COUNT(c.CountryCode) AS [CountryCode]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS m ON c.CountryCode = m.CountryCode
WHERE m.MountainId IS NULL

--Problem 17.Highest Peak and Longest River by Country
SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS [HighestPeakElevation], MAX(r.[Length]) AS [LongestRiverLength]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT OUTER JOIN Peaks AS p ON p.MountainId = mc.MountainId
LEFT OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName

--Problem 18.* Highest Peak Name and Elevation by Country
SELECT TOP (5) WITH TIES c.CountryName, ISNULL(p.PeakName, '(no highest peak)') AS 'HighestPeakName', ISNULL(MAX(p.Elevation), 0) AS 'HighestPeakElevation', ISNULL(m.MountainRange, '(no mountain)')
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
ON m.Id = p.MountainId
GROUP BY c.CountryName, p.PeakName, m.MountainRange
ORDER BY c.CountryName, p.PeakName
      
