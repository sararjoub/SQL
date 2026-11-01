create Database TechWorldHRDB 
create Table TemporaryStaff(
     staffID INT,
    StaffName VARCHAR(50),
    HireDate DATE
    );
    SELECT * FROM TemporaryStaff;
     DROP TABLE TemporaryStaff;

    create Table Departments(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO Departments
(DepartmentID, DepartmentName)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

create Table  Employees (
	EmployeeID INT PRIMARY KEY ,
    FullName VARCHAR(100) NOT NULL ,
    Email VARCHAR(100) UNIQUE ,
    Salary DECIMAL (10,2),
    DepartmentID INT
    );

    ALTER TABLE Employees ADD PhoneNumber VARCHAR(20);


    INSERT INTO Employees
(EmployeeID, FullName, Email, Salary, DepartmentID, PhoneNumber)
VALUES
(1, 'Ahmad Ali', 'ahmad@techworld.com', 1200.00, 1, '0791111111'),
(2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
(3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333'),
(4, 'Mona Khaled', 'mona@techworld.com', 800.00, 3, '0794444444');

UPDATE Employees SET Salary = 1350.00 WHERE EmployeeID=1;

DELETE FROM Employees
WHERE EmployeeID = 4;

   SELECT * FROM Employees;


   SELECT FullName, Salary
FROM Employees;

SELECT SUM(Salary) AS TotalSalaries
FROM Employees;

SELECT AVG(Salary) AS AverageSalary
FROM Employees;

SELECT
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employees;

SELECT COUNT(*) AS TotalEmployees
FROM Employees;

    SELECT * FROM Departments;

   


   CREATE TABLE AccessCards (
   CardID int primary key ,
   CardNumber VARCHAR(50)  NOT NULL UNIQUE,
   EmployeeID int NOT NULL UNIQUE FOREIGN KEY REFERENCES Employees (EmployeeID) );

   INSERT INTO AccessCards ( CardID , CardNumber , EmployeeID )
   values (1 ,'101',1) ,(2,'102',2) ,(3,'103',3);

   SELECT * FROM AccessCards;

   create table Projects (
   ProjectID  int PRIMARY KEY ,
   ProjectName VARCHAR(100) NOT NULL ,
   );

   INSERT INTO Projects(ProjectID ,ProjectName )
   VALUES ( 1, 'AI & Security Training' ) ,
   (2,'Cloud Migration');


   SELECT * FROM Projects;

-- JUNCTION TABLE --
create table EmployeeProjects(
EmployeeID  int REFERENCES Employees (EmployeeID),
ProjectID  int REFERENCES Projects (ProjectID),
   AssignedDate DATE,


   -- composit primary key --
    PRIMARY KEY (EmployeeID, ProjectID) );

    INSERT INTO EmployeeProjects (EmployeeID ,ProjectID ,AssignedDate)
    values (1, 1, '2026-10-01'),
            (1, 2, '2026-10-02'),
             (2, 1, '2026-10-03'),
              (3, 2, '2026-10-04');
    SELECT * FROM EmployeeProjects;


    -- one to many relationship --
    SELECT Employees.FullName ,Employees.Salary , Departments.DepartmentName 
    FROM Employees INNER JOIN Departments ON Employees.DepartmentID= Departments.DepartmentID;


     -- null because fainance on department and should be apper in left join  but mona was deleted in employee table   --
     SELECT Departments.DepartmentName,Employees.FullName 
     FROM Departments LEFT JOIN Employees ON Departments.DepartmentID= Employees.DepartmentID;


     -- one to one relationship --
     SELECT Employees.FullName, AccessCards.CardNumber
     FROM Employees INNER JOIN AccessCards ON 
     Employees.EmployeeID=AccessCards.EmployeeID;


    -- ahmad ali will apper two time because he was shared in two projects this many to many relatioship--
    SELECT Employees.FullName ,Projects.ProjectName,EmployeeProjects.AssignedDate
    FROM Employees INNER JOIN EmployeeProjects ON Employees.EmployeeID=EmployeeProjects.EmployeeID
    INNER JOIN Projects ON EmployeeProjects.ProjectID= Projects.ProjectID;


    SELECT DepartmentID ,SUM(salary) AS TotalSalary,
    COUNT(*) AS EmployeeCount FROM Employees GROUP BY DepartmentID;

   
   SELECT DepartmentID ,Avg(salary) AS AvgSalary 
   FROM Employees GROUP BY DepartmentID HAVING 
   AVG(salary)> 1000.00;

   -- Subquery--
   
SELECT *FROM Employees WHERE Salary > ( SELECT AVG(Salary)  FROM Employees);


CREATE VIEW vw_EmployeeDetails AS
SELECT
    Employees.EmployeeID,
    Employees.FullName,
    Employees.Email,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;


SELECT * FROM vw_EmployeeDetails;


CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DeptID INT AS
      BEGIN
    SELECT *
    FROM Employees
    WHERE DepartmentID = @DeptID;
   END;
   -- لو بدنا نعرض موظفي قسم ال it --
   EXEC sp_GetEmployeesByDepartment @DeptID = 1;

   -- لو بدنا نعرض موظفي قسم hr --
   EXEC sp_GetEmployeesByDepartment @DeptID = 2;

   -- لو بدنا موظفي قسم Finance--
   EXEC sp_GetEmployeesByDepartment @DeptID = 3;


   
CREATE TABLE EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);



CREATE TRIGGER trg_EmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, Action, ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
END;


INSERT INTO Employees
(EmployeeID, FullName, Email, Salary, DepartmentID, PhoneNumber)
VALUES
(99, 'Test Employee', 'test99@techworld.com', 500.00, 1, '0799999999');

DELETE FROM Employees
WHERE EmployeeID = 99;

SELECT * FROM EmployeeAudit;  