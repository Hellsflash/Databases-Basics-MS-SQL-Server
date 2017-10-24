--Functions and Procedures Exercises

--Part I – Queries for SoftUni Database
   USE SoftUni

--Problem 1. Employees with Salary Above 35000
    GO
CREATE PROC usp_GetEmployeesSalaryAbove35000
    AS 
SELECT FirstName,
       LastName 
  FROM Employees
 WHERE Salary>35000

--Problem 2. Employees with Salary Above Number
    GO
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Salary MONEY)
    AS
SELECT FirstName,
       LastName 
  FROM Employees
 WHERE Salary>=@Salary
      
--Problem 3. Town Names Starting With
    GO
CREATE PROC usp_GetTownsStartingWith (@FirstLetter NVARCHAR(MAX))
    AS
SELECT Name AS Towns
  FROM Towns 
 WHERE Name LIKE CONCAT(@FirstLetter,'%')

--Problem 4. Employees from Town
    GO
CREATE PROC usp_GetEmployeesFromTown(@TownName NVARCHAR(MAX))
    AS
SELECT e.FirstName,
       e.LastName
  FROM Employees  AS e
  JOIN Addresses AS a
    ON a.AddressID = e.AddressID
  JOIN Towns AS t
    ON t.TownID = a.TownID
 WHERE @TownName =t.Name

--05. Salary Level Function
    GO
CREATE FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
RETURNS NVARCHAR(10)
BEGIN
	DECLARE @SalaryLevel NVARCHAR(10)
	IF(@Salary<30000)
		SET @SalaryLevel = 'Low'
	ELSE IF(@Salary BETWEEN 30000 AND 50000)
		SET @SalaryLevel = 'Average'
	ELSE 
		Set @SalaryLevel = 'High'

	RETURN @SalaryLevel
END

--Problem 6. Employees by Salary Level
   GO
CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel NVARCHAR(10))
    AS
SELECT FirstName,
       LastName
  FROM Employees
 WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

--07. Define Function
     GO
 CREATE FUNCTION ufn_IsWordComprised(@SetOfLetters NVARCHAR(MAX),@Word NVARCHAR(MAX))
RETURNS BIT
     AS
  BEGIN
      DECLARE @IsCompared BIT = 0
	  DECLARE @CurrentIndex INT = 1
	  DECLARE @CurrentChar CHAR 

      WHILE (@CurrentIndex<=LEN(@Word))
	  BEGIN
		  SET @CurrentChar = SUBSTRING(@Word,@CurrentIndex,1)
		  IF(CHARINDEX(@CurrentChar,@SetOfLetters) = 0)
		    RETURN @IsCompared
		  SET @CurrentIndex += 1 
	  END

	  RETURN @IsCompared + 1

  END 

--08. * Delete Employees and Departments

--PART II – Queries for Bank Database
USE Bank

--9. Find Full Name
    GO
CREATE PROC usp_GetHoldersFullName 
    AS
SELECT CONCAT(FirstName,' ',LastName) AS [Full Name]
  FROM AccountHolders

--10. People with Balance Higher Than
    GO
CREATE PROC usp_GetHoldersWithBalanceHigherThan (@MinBalance MONEY)
    AS
 BEGIN
     WITH CTE_MinBalanceAccountHolders  (HolderId) AS 
	 (
	    SELECT AccountHolderId
		  FROM Accounts
		 GROUP BY AccountHolderId
		HAVING SUM(Balance) > @MinBalance
	 )
   SELECT ah.FirstName AS [First Name],
          ah.LastName AS [Last Name]
     FROM CTE_MinBalanceAccountHolders AS MinBalanceHolders
	 JOIN AccountHolders AS ah
	   ON ah.Id = MinBalanceHolders.HolderId
	ORDER BY ah.LastName,ah.FirstName
   END

--11. Future Value Function
     GO
 CREATE FUNCTION ufn_CalculateFutureValue (@Sum MONEY,@AnnualIntRate FLOAT,@Years INT)
RETURNS MONEY
     AS
  BEGIN
      RETURN @Sum * POWER(1 + @AnnualIntRate,@Years)
    END	

--12. Calculating Interest
    GO
CREATE PROC usp_CalculateFutureValueForAccount(@AccountId INT,@InterestRate FLOAT)
    AS
 BEGIN
     DECLARE @Years INT = 5

	 SELECT a.Id AS [Account Id],
	        ah.FirstName AS [First Name],
			ah.LastName AS [Last Name],
			a.Balance AS [Current Balance],
			dbo.ufn_CalculateFutureValue(a.Balance,@InterestRate,@Years) AS [Balance in 5 years]
	   FROM AccountHolders AS ah
	   JOIN Accounts AS a
	     ON a.AccountHolderId =ah.Id
	  WHERE a.Id = @AccountId
  END

--PART III – Queries for Diablo Database
 GO
USE Diablo

--13. *Cash in User Games Odd Rows
     GO
 CREATE FUNCTION ufn_CashInUsersGames (@GameName NVARCHAR(MAX))
RETURNS TABLE
     AS
 RETURN
(
      WITH CTE_CashInRows(Cash,RowNumber) AS
	  (
	     SELECT ug.Cash,ROW_NUMBER() 
		   OVER (ORDER BY ug.Cash DESC)
		   FROM UsersGames AS ug
		   JOIN Games AS g
		     ON ug.GameId = g.Id
		  WHERE g.Name =@GameName
	  )
    SELECT SUM(Cash) As SumCash
	  FROM CTE_CashInRows
	 WHERE RowNumber % 2 = 1
)
