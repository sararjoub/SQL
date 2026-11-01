
CREATE TABLE Departments(
 DepartmentID  int primary key,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
 );
 SELECT * FROM Departments; 

 -- (1:N Relationship)--
 create table students (
 StudentID int primary key ,
 FullName VARCHAR(100) NOT NULL, Email VARCHAR(100) UNIQUE,
 GPA DECIMAL (3,2) ,
 DepartmentID INT  REFERENCES Departments(DepartmentID)
 );

 SELECT * FROM students;


 CREATE TABLE StudentProfiles (
 ProfileID int primary key ,
 StudentID INT UNIQUE REFERENCES Students(StudentID),
    Address VARCHAR(200),
    EmergencyPhone VARCHAR(20)
);
SELECT * FROM StudentProfiles;

-- (1:M Relationship)--
create table Courses (
CourseID int primary key ,
CourseName VARCHAR(100) NOT NULL ,
Credits int ,
DepartmentID int REFERENCES Departments (DepartmentID )
);
select * from Courses;
-- junction table --

create table StudentCourses (
StudentID INT REFERENCES Students (StudentID) ,
CourseID INT REFERENCES Courses (CourseID) ,
EnrollmentDate DATE DEFAULT GETDATE() ,
PRIMARY KEY (StudentID, CourseID)
);

SELECT * FROM StudentCourses;

ALTER TABLE Students ADD Age INT ;

SELECT * FROM Students;

DROP TABLE TempInstructors;

INSERT INTO Departments (DepartmentID ,DepartmentName)
VALUES 
(1,'computer science'),
(2, 'software engineering'),
(3,'business administration');

select * from Departments;


INSERT INTO students(StudentID,FullName,Email, GPA, DepartmentID,Age)
VALUES 
(101,'Ali Smadi','ali@coursehub.com',3.80,1,22),
(102, 'Omar Ahmad', 'omar@coursehub.com', 2.90, 1, 21),
(103, 'Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23),
(104, 'Tariq Zaid', 'tariq@coursehub.com', 2.10, 3, 20);

SELECT * FROM Students
ORDER BY StudentID ASC;


INSERT INTO StudentProfiles
(ProfileID, StudentID, Address, EmergencyPhone)
VALUES
(1, 101, 'Amman, Jordan', '0791111111'),
(2, 102, 'Irbid, Jordan', '0792222222'),
(3, 103, 'Zarqa, Jordan', '0793333333');

SELECT * FROM StudentProfiles
ORDER BY ProfileID ASC;

INSERT Courses(CourseID,CourseName,Credits,DepartmentID)
values 
(201 ,'Database System',3,1),
(202,'Web DDevelopment',3,1),
(203,'Software Architecture',3,2);

SELECT * FROM Courses
ORDER BY CourseID ASC;

INSERT INTO StudentCourses(StudentID,CourseID)
values 
(101,201),
(101,202),
(102,201),
(103,203);

SELECT * FROM StudentCourses
ORDER BY StudentID, CourseID;

UPDATE students SET GPA =2.50
WHERE StudentID=104;

SELECT * FROM Students
WHERE StudentID = 104;


DELETE FROM Students
WHERE StudentID = 104;

SELECT * FROM Students
ORDER BY StudentID ASC;

-- stage 4.1 1:M --
SELECT Students.FullName,
       Students.GPA,
       Departments.DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID = Departments.DepartmentID;


-- stage 4.2--
SELECT Departments.DepartmentName,
       Students.FullName
FROM Departments
LEFT JOIN Students
ON Departments.DepartmentID = Students.DepartmentID;

--  stage 4.3 INNER JOIN (1:1 Relationship)--
SELECT Students.FullName,
       StudentProfiles.Address,
       StudentProfiles.EmergencyPhone
FROM Students
INNER JOIN StudentProfiles
ON Students.StudentID = StudentProfiles.StudentID;

-- stage 4.4--
SELECT Students.FullName,
       Courses.CourseName,
       StudentCourses.EnrollmentDate
FROM Students
INNER JOIN StudentCourses
ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses
ON StudentCourses.CourseID = Courses.CourseID;

-- Stage 5 — Task 5.1--

SELECT
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA,
    MAX(GPA) AS HighestGPA,
    MIN(GPA) AS LowestGPA
FROM Students;

-- stage 5.2 --
SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA,
    COUNT(*) AS TotalStudents
FROM Students
GROUP BY DepartmentID;

-- stage 5.3 --

SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA
FROM Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;

-- stage 5.4 --

SELECT
    DepartmentID,
    COUNT(*) AS TotalStudents
FROM Students
WHERE GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;

-- stage 6.1  --
EXEC sp_helpindex 'Students';


-- stage 6.2 --

CREATE NONCLUSTERED INDEX IX_Students_Email
ON Students(Email);

EXEC sp_helpindex 'Students';

-- stage 7 .1--

SELECT *
FROM Students
WHERE GPA > (
    SELECT AVG(GPA)
    FROM Students
);


--  7.2--
CREATE VIEW vw_StudentAcademicDetails AS
SELECT
    Students.StudentID,
    Students.FullName,
    Students.GPA,
    Departments.DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID = Departments.DepartmentID;

SELECT * FROM vw_StudentAcademicDetails;

-- 7.3--

CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM Students
    WHERE DepartmentID = @DeptID;
END;


EXEC sp_GetStudentsByDepartment @DeptID = 1;
EXEC sp_GetStudentsByDepartment @DeptID = 2;
EXEC sp_GetStudentsByDepartment @DeptID = 3;
