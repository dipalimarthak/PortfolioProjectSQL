Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

--=======Select Statements==========

SELECT * FROM EmployeeSalary

SELECT TOP 5 * FROM EmployeeSalary

SELECT DISTINCT(EmployeeID) from EmployeeDemographics

SELECT DISTINCT(Gender) from EmployeeDemographics

SELECT COUNT(LastName) from EmployeeDemographics

SELECT COUNT(LastName) AS LastNameCount from EmployeeDemographics

SELECT MAX(Salary) FROM EmployeeSalary

SELECT MIN(Salary) FROM EmployeeSalary

SELECT AVG(Salary) FROM EmployeeSalary

change the database from the dropdown to master and try this query

SELECT * FROM EmployeeSalary

this should now work
SELECT * FROM SQLTutorial.dbo.EmployeeSalary

--============where statements============  =, <>, <, >, And, Or, Like, Null, Not Null, In

SELECT * FROM EmployeeDemographics where Age <=32 OR Gender = 'Male'


SELECT * FROM EmployeeDemographics where LastName LIKE 'S%o%'

SELECT * FROM EmployeeDemographics where FirstName is NULL 

SELECT * FROM EmployeeDemographics where FirstName is  NOT Null

SELECT * FROM EmployeeDemographics where FirstName IN ('Jim','Michael')

--=========Group By===========

SELECT DISTINCT(Gender), COUNT(Gender) as CountGender from EmployeeDemographics
WHERE AGE > 31
GROUP by Gender
ORDER BY CountGender DESC




SELECT Gender, COUNT(Gender) as CountGender from EmployeeDemographics
WHERE AGE > 31
GROUP by Gender
ORDER BY CountGender DESC


--COUNT(Gender) is a derived column

SELECT * FROM EmployeeDemographics order by Age ASC, Gender DESC

--===you can use column name number instead to avoid using the actual column name if the tables are small

SELECT * FROM EmployeeDemographics order by 4 ASC, 5 DESC

SELECT * FROM EmployeeSalary INNER JOIN EmployeeDemographics
ON EmployeeSalary.EmployeeID = EmployeeDemographics.EmployeeID

SELECT * FROM EmployeeSalary FULL OUTER JOIN EmployeeDemographics
ON EmployeeSalary.EmployeeID = EmployeeDemographics.EmployeeID

SELECT * FROM EmployeeSalary LEFT OUTER JOIN EmployeeDemographics
ON EmployeeSalary.EmployeeID = EmployeeDemographics.EmployeeID

SELECT * FROM EmployeeSalary RIGHT OUTER JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--RESOLVING AMBIGUITY OF EmployeeID column during join

SELECT EmployeeSalary.EmployeeID, Salary, FirstName, LastName FROM EmployeeSalary RIGHT OUTER JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

SELECT EmployeeDemographics.EmployeeID, Salary, FirstName, LastName FROM EmployeeSalary RIGHT OUTER JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, Salary
from EmployeeDemographics INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE FirstName <> 'Michael'
ORDER BY Salary DESC

---FINDING AVG SALARY FOR SALESMAN

SELECT JobTitle, AVG(Salary)
from EmployeeDemographics INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--WHERE JobTitle='Salesman'
GROUP BY JobTitle


--------------union

Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')


Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)


Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')


SELECT * FROM EmployeeDemographics FULL OUTER JOIN WareHouseEmployeeDemographics
ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID

--IN ORDER TO HAVE A COMBINED VIEW , WE USE UNION INSTEAD

SELECT * FROM EmployeeDemographics
UNION
SELECT* FROM WareHouseEmployeeDemographics
ORDER BY EmployeeID


---UNION ALL WILL IGNORE ANY REDUNDANCIES
SELECT * FROM EmployeeDemographics
UNION ALL
SELECT* FROM WareHouseEmployeeDemographics
ORDER BY EmployeeID

---BELOW UNION WORKS BECAUSE THE COLUMNS HAVE SAME DATA TYPE
SELECT EmployeeID, FirstName, Age FROM EmployeeDemographics
UNION
SELECT EmployeeID, JobTitle, Salary FROM EmployeeSalary
ORDER BY EmployeeID
---- THIS IS NOT WHAT WE WANT TO DO SO BE CAREFUL OF SELECTING THE COLUMNS


--==========CASE STATEMENTS======

SELECT FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'OLD'
	WHEN Age BETWEEN 27 AND 30 THEN 'YOUNG'
	ELSE 'BABY'
END
FROM EmployeeDemographics
WHERE Age IS NOT NULL

-- NOTE THAT THE FIRST CONDITION WHICH MEETS IS TAKEN INTO CONSIDERATION
--EXEUTE BELOW TO CONFIRM

SELECT FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'OLD'
	WHEN Age = 38 THEN 'STANLEY'
	ELSE 'BABY'
END
FROM EmployeeDemographics
WHERE Age IS NOT NULL
---
SELECT FirstName, LastName, Age,
CASE
		WHEN Age = 38 THEN 'STANLEY'
		WHEN Age > 30 THEN 'OLD'
	ELSE 'BABY'
END
FROM EmployeeDemographics
WHERE Age IS NOT NULL


SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
	ELSE Salary + (Salary * .03) 
END AS SalaryAfterRaise
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID

--=========HAVING CLAUSE============

--===========error======
SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID
GROUP BY JobTitle
--===========error======
--An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.


SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID
WHERE COUNT(JobTitle) > 1
GROUP BY JobTitle
------========ERROR---HAVING HAS TO COME AFTER GROUP BY
SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID
HAVING COUNT(JobTitle) > 1
GROUP BY JobTitle

--------CORRECT
SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1

---==========ORDER BY
SELECT JobTitle, AVG(Salary)
FROM EmployeeSalary JOIN EmployeeDemographics
ON EmployeeDemographics.EmployeeID= EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)

---========DELETING/UPDATING DATA

SELECT * FROM EmployeeDemographics

--===UPDATING THE MISSING VALUES

UPDATE EmployeeDemographics
SET EmployeeID = 1012, Age = 31, Gender = 'Female'
WHERE FirstName='Holly' AND LastName = 'Flax'

--===DELETE STATEMENT

DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1005


--======ALIASING

SELECT FirstName + ' ' + LastName  AS FullName FROM EmployeeDemographics

SELECT Avg(Age) AS AvgAge FROM EmployeeDemographics

SELECT Demo.EmployeeID FROM EmployeeDemographics AS Demo
JOIN EmployeeSalary AS Sal
ON Demo.EmployeeID = Sal.EmployeeID

---====PARTITION BY DOES NOT REEUCE THE RESULT SET

SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM EmployeeDemographics AS Dem JOIN EmployeeSalary AS Sal
ON Dem.EmployeeID = Sal.EmployeeID

--====CTE Common Table Expression

--It is a named temporary result set and used to manipulate complex sub group data
--only exists within the scope and only exists in memory rather than temp db file
-- HERE WE ARE USING AGGREGATE FUNCTIONS AVG AND COUNT

WITH CTE_Employee AS (
SELECT FirstName, LastName, Gender, Salary, COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender, AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM EmployeeDemographics emp JOIN EmployeeSalary sal
ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > 45000
)
SELECT FirstName, AvgSalary FROM CTE_Employee
--IF THE SELECT STATEMENT IS NOT IMMEDIATELY AFTER THE CTE, IT WILL NOT WORK.


--=========how to use Temp Tables------------
--USE THE # SIGN

CREATE TABLE #temp_Employee(
EmployeeID INT,
JobTitle VARCHAR(100),
Salary INT
)
SELECT * FROM #temp_Employee
INSERT INTO #temp_Employee VALUES(
'1001','HR','45000'
)
--- TRICK TO INSERT IN BULK FROM EXISTING TABLE
---THIS IS ONE OF THE BIG USES OF TEMP TABLE TO AVOID LONG PROCESS
INSERT INTO #temp_Employee
SELECT * FROM EmployeeSalary

---USING TEMP TABLES
--NOTE THAT: IF WE RUN CREATE TABLE OF THE SAME NAME AGAIN, IT WILL GIVE BELOW ERROR

--Msg 2714, Level 16, State 6, Line 334
--There is already an object named '#TempEmployee2' in the database.

--SO IF YOU WISH TO AVOID THE ERROR TRY USING IN THE BEGINNING THE DROP TABLE STATEMENT

DROP TABLE IF EXISTS #temp_Employee2

CREATE TABLE #TempEmployee2 (
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSal INT
)

INSERT INTO #TempEmployee2 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics DEM JOIN EmployeeSalary SAL
ON DEM.EmployeeID=SAL.EmployeeID
GROUP BY JobTitle

SELECT * FROM #TempEmployee2


--======String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower================

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)
Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select * From EmployeeErrors

-- Using Trim, LTRIM, RTRIM
Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors

-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

--===FUZZY MATCHING USING SUBSTRING

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
--TRY ADDING SOME OF THE COLUMNS SUCH AS AGE, DOB, GENDER, SUBSTRING OF FIRST AND LAST NAME TO THE ON 	PART FOR A STRONG FUZZY MATCH


-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors


CREATE PROCEDURE TEST AS (SELECT * FROM EmployeeDemographics)

-- HAVE A LOOK INTO OBJECT EXPLORER UNDER PROGRAMMABILITY > STORED PROCEDURES AND YOU WILL FIND ITS ENTRY

--SEE HOW TO USE THE STORED PROCEDURE

EXEC TEST

--MORE COMPLEX

CREATE PROCEDURE Temp_Employee AS
DROP TABLE IF EXISTS #temp_Employee

CREATE TABLE #TempEmployee (
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSal INT
)
INSERT INTO #TempEmployee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics DEM JOIN EmployeeSalary SAL
ON DEM.EmployeeID=SAL.EmployeeID
GROUP BY JobTitle

SELECT * FROM #TempEmployee
GO;

EXEC Temp_Employee


--- NOW ALTER PROCEDURE


ALTER PROCEDURE Temp_Employee --1ST ALTER STATEMENT
@JobTitle NVARCHAR(100) ---2ND PARAMETER
AS ---3RD AS

--4TH REMOVE DROP STATEMENT
--DROP TABLE IF EXISTS #temp_Employee

CREATE TABLE #TempEmployee (
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSal INT
)
INSERT INTO #TempEmployee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics DEM JOIN EmployeeSalary SAL
ON DEM.EmployeeID=SAL.EmployeeID
WHERE JobTitle = @JobTitle --5TH PROVIDE INPUT PARAMETER
GROUP BY JobTitle

SELECT * FROM #TempEmployee
GO;

EXEC Temp_Employee @JobTitle='HR' --6TH SUPPLY PARAMETER IN EXEC STATEMENT


-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)