--Exercises: Data Aggregation

USE Gringotts

--Problem 1.Records’ Count
SELECT Max(ID)
 FROM WizzardDeposits
 
--Problem 2.Longest Magic Wand
SELECT MAX(MagicWandSize) AS [LongestMagicWand]
  FROM WizzardDeposits

--Problem 3.Longest Magic Wand per Deposit Groups
SELECT DepositGroup,
   MAX(MagicWandSIze) AS [LongestMagicWand]
  FROM WizzardDeposits
GROUP BY DepositGroup

--Problem 4.*Smallest Deposit Group per Magic Wand Size
SELECT DepositGroup
FROM WizzardDeposits
GROUP BY [DepositGroup]
HAVING AVG(MagicWandSize) <
(
    SELECT AVG(MagicWandSize) 
	  FROM WizzardDeposits
)

--Problem 5.Deposits Sum
SELECT DepositGroup,SUM(DepositAmount)AS TotalSum
  FROM WizzardDeposits
 GROUP BY DepositGroup

--Problem 6.Deposits Sum for Ollivander Family
SELECT DepositGroup,SUM(DepositAmount)AS TotalSum
  FROM WizzardDeposits
  GROUP BY MagicWandCreator,DepositGroup
 HAVING (MagicWandCreator ='Ollivander family')

 --Problem 7.Deposits Filter
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] 
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
 GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
 ORDER BY [TotalSum] DESC

--Problem 8.Deposit Charge
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge)
  FROM WizzardDeposits
 GROUP BY DepositGroup , MagicWandCreator

--Problem 9.Age Groups
SELECT 
CASE
	WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	WHEN Age BETWEEN 51 AND 60 THEN '[51-60]' 
	ELSE '[61+]'
END AS [AgeGoup],
COUNT(*) AS [WizardsCount]
FROM WizzardDeposits
GROUP BY
CASE
	WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	WHEN Age BETWEEN 51 AND 60 THEN '[51-60]' 
	ELSE '[61+]'
END

--Problem 10.First Letter
SELECT LEFT(FirstName,1) AS [FirstLetter]
  FROM WizzardDeposits
 WHERE DepositGroup = 'Troll Chest'
 GROUP BY LEFT(FirstName,1)
 ORDER BY [FirstLetter]

--Problem 11.Average Interest 
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) AS [AverageInterest]
  FROM WizzardDeposits
 WHERE DepositStartDate >'01/01/1985'
 GROUP BY DepositGroup,IsDepositExpired
 ORDER BY DepositGroup DESC,IsDepositExpired

--Problem 12.* Rich Wizard, Poor Wizard
SELECT SUM(HostWizardAmount - GuestWizardAmount)AS [SumDifference] FROM
(
 SELECT DepositAmount AS [HostWizardAmount],
   LEAD(DepositAmount) OVER (ORDER BY Id) AS [GuestWizardAmount]
   FROM WizzardDeposits
)AS SQ

USE SoftUni

--Problem 13.Departments Total Salaries
SELECT DepartmentID,SUM(Salary)AS [TotalSalary]
  FROM Employees
 GROUP BY DepartmentID
 ORDER BY DepartmentID

--Problem 14.Employees Minimum Salaries
SELECT DepartmentID,MIN(Salary)AS [MinimumSalary]
 FROM Employees
WHERE DepartmentID = 2 OR DepartmentID = 5 OR  DepartmentID = 7 AND HireDate>'01/01/2000'
GROUP BY DepartmentID

--Problem 15.	Employees Average Salaries
SELECT *
  INTO EmployeesCopy
  FROM Employees
 WHERE Salary > 30000 
 
DELETE
  FROM EmployeesCopy
 WHERE ManagerID =42

UPDATE EmployeesCopy
   SET Salary +=5000
 WHERE DepartmentID = 1

SELECT DepartmentID,AVG(Salary) AS [AverageSalary]
  FROM EmployeesCopy
 GROUP BY DepartmentID

--Employees Maximum Salaries
SELECT DepartmentID,MAX(Salary) AS [MaxSalary]
  FROM Employees
 GROUP BY DepartmentID
HAVING NOT MAX(Salary) BETWEEN 30000 AND 70000
 
--Problem 17.Employees Count Salaries
SELECT COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

--Problem 18.*3rd Highest Salary
SELECT DepartmentID, Salary AS [ThirdHighestSalary] FROM
(
SELECT DepartmentID,Salary,RANK()OVER(PARTITION BY DepartmentID ORDER BY SALARY DESC)AS[Rank]
  FROM Employees
 GROUP BY DepartmentID,Salary
)    
    AS RankingTable
 WHERE [Rank] = 3

--Problem 19.**Salary Challenge
SELECT TOP (10) FirstName,LastName,DepartmentID
  FROM Employees AS e
 WHERE Salary >
 (
       SELECT AVG(Salary)[AvarageSalary]
	     FROM Employees
	    WHERE DepartmentID = e.DepartmentID
	    GROUP BY DepartmentID
 )
 ORDER BY DepartmentID