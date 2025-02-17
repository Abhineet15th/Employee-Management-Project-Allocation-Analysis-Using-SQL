CREATE DATABASE company;
USE company;

-- Creating a table
CREATE TABLE Employees (
EmployeeID INT PRIMARY KEY,
Name VARCHAR(50),        
Address VARCHAR(255),
Salary INT 
);

-- Inserting multiple rows
INSERT INTO Employees (EmployeeID, Name, Address, Salary)
VALUES 
(1, 'Alice Johnson', '123 Maple Street, Springfield, USA', 20000),
(2, 'Bob Smith', '456 Elm Street, Springfield, USA', 50000),
(3, 'Charlie Davis', '789 Oak Street, Springfield, USA', 40000),
(4, 'Diana Prince', '101 Pine Avenue, Metropolis, USA', 30000),
(5, 'Eve Brown', '202 Cedar Lane, Gotham, USA', 20000),
(6, 'Mike Wilson', '303 Birch Road, Star City, USA', 60000),
(7, 'Linda Taylor', '404 Redwood Street, Central City, USA', 70000),
(8, 'James Anderson', '505 Spruce Avenue, Smallville, USA', 80000),
(9, 'Sarah Moore', '606 Aspen Lane, Keystone City, USA', 20000),
(10, 'David Miller', '707 Pinecone Boulevard, Coast City, USA', 10000),
(11, 'Emily White', '808 Fir Drive, Blüdhaven, USA', 75000),
(12, 'Frank Thompson', '909 Maple Grove, Fawcett City, USA', 35000),
(13, 'Grace Hall', '1010 Cedar Trail, Opal City, USA', 40000),
(14, 'Henry Young', '1111 Birchwood Lane, Gateway City, USA', 55000),
(15, 'Irene Adams', '1212 Aspen Circle, Ivy Town, USA', 65000),
(16, 'Jack Green', '1313 Redwood Drive, Hub City, USA', 70000),
(17, 'Kathy Lee', '1414 Elm Avenue, Happy Harbor, USA', 75000),
(18, 'Liam Walker', '1515 Oak Street, Central City, USA', 45000),
(19, NULL, '1616 Pine Lane, Smallville, USA', 25000),
(20, 'Nick Carter', '1717 Spruce Court, Gotham, USA', 30000);

-- Querying data
SELECT * FROM Employees;

-- Creating the EmployeeProjects table
CREATE TABLE EmployeeProjects (
ProjectID INT PRIMARY KEY,
ProjectName VARCHAR(100),      -- Name of the project
StartDate DATE,                -- Start date of the project
EndDate DATE,                  -- End date of the project (nullable if ongoing)
EmployeeID INT,                -- Foreign Key referencing Employees table
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Inserting 20 records into EmployeeProjects table
INSERT INTO EmployeeProjects (ProjectID, ProjectName, StartDate, EndDate, EmployeeID)
VALUES 
(1, 'Project Alpha', '2025-01-01', '2025-06-30', 1),    
(2, 'Project Alpha', '2025-02-01', NULL, 2),   -- Ongoing project 
(3, NULL, '2025-03-01', '2025-09-30', 3),
(4, 'Project Delta', '2025-04-01', NULL, 4),   -- Ongoing project
(5, 'Project Epsilon', '2025-05-01', '2025-10-31', 5),
(6, 'Project Zeta', '2025-06-01', NULL, 6),     -- Ongoing project
(7, 'Project Eta', '2025-07-01', '2025-12-31', 7),
(8, 'Project Theta', '2025-08-01', '2025-12-01', 8),
(9, 'Project Alpha', '2025-09-01', NULL, 9),     -- Ongoing project
(10, 'Project Kappa', '2025-10-01', '2026-03-31', 10),
(11, 'Project Lambda', '2025-11-01', NULL, 11), -- Ongoing project
(12, 'Project Mu', '2025-12-01', '2026-05-31', 12),
(13, 'Project Nu', '2026-01-01', NULL, 13),    -- Ongoing project
(14, 'Project Xi', '2026-02-01', '2026-07-31', 14),
(15, 'Project Omicron', '2026-03-01', NULL, 15), -- Ongoing project
(16, 'Project Pi', '2026-04-01', '2026-09-30', 16), 
(17, 'Project Rho', '2026-05-01', '2026-10-31', 17),
(18, 'Project Sigma', '2026-06-01', NULL, 18),  
(19, 'Project Tau', '2026-07-01', '2026-12-31', 19),
(20, 'Project Upsilon', '2026-08-01', '2027-01-31', 20);

SELECT * FROM EmployeeProjects;


-- List all employees along with the project they are assigned to
SELECT e.Name, ep.ProjectName
FROM Employees e
-- Join the Employees table with EmployeeProjects table on EmployeeID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID;


-- List employees who do not have any project assigned
SELECT * FROM Employees e
-- LEFT JOIN to include all employees, even those without a project
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Filter to get employees with no project assigned (EmployeeID in EmployeeProjects will be NULL)
WHERE ep.ProjectName IS NULL;


-- List employees working on ongoing projects (projects with no EndDate)
SELECT e.Name, ep.ProjectName
FROM Employees e
-- Join Employees table with EmployeeProjects table
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Filter for ongoing projects (EndDate is NULL)
WHERE ep.EndDate IS NULL;


-- List employees working on projects that end in the year 2025
SELECT e.Name, ep.ProjectName, ep.EndDate
FROM Employees e
-- Join Employees and EmployeeProjects on EmployeeID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Filter for projects where the EndDate is in 2025
WHERE YEAR(ep.EndDate) = 2025;


-- Count the number of employees working on each project
SELECT ep.ProjectName, COUNT(e.EmployeeID) AS EmployeeCount
FROM EmployeeProjects ep
-- Join EmployeeProjects with Employees to count employees assigned to each project
INNER JOIN Employees e ON e.EmployeeID = ep.EmployeeID
-- Group the results by project name
GROUP BY ep.ProjectName;


-- List the highest-paid employees for each project
SELECT ep.ProjectName, e.Name, e.Salary
FROM Employees e
-- Join Employees with EmployeeProjects to match employees to their projects
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Subquery to find the employee with the highest salary for each project
WHERE e.Salary = (
    SELECT MAX(e2.Salary)
    FROM Employees e2
    -- Subquery joins EmployeeProjects to get employees assigned to the same project
    INNER JOIN EmployeeProjects ep2 ON e2.EmployeeID = ep2.EmployeeID
    WHERE ep2.ProjectID = ep.ProjectID
);


-- List all possible combinations of employees and projects
SELECT * FROM Employees e
-- Perform CROSS JOIN between Employees and EmployeeProjects tables
CROSS JOIN EmployeeProjects ep;


-- List employees working on projects lasting more than 6 months (i.e., 180 days)
SELECT e.Name, ep.ProjectName, ep.StartDate, ep.EndDate
FROM Employees e
-- Join Employees and EmployeeProjects based on EmployeeID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Filter for projects that last longer than 180 days (6 months)
WHERE DATEDIFF(ep.EndDate, ep.StartDate) > 180;


-- List employees working on projects that started in the year 2025
SELECT e.Name, ep.ProjectName, ep.StartDate
FROM Employees e
-- RIGHT JOIN ensures we get all projects that started in 2025, even if no employee is assigned
RIGHT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Filter for projects that started in 2025
WHERE YEAR(ep.StartDate) = 2025;


-- Find employees who have worked on more than one project
SELECT e.Name, COUNT(ep.ProjectID) AS ProjectCount
FROM Employees e
-- Join Employees and EmployeeProjects on EmployeeID
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
-- Group the results by employee
GROUP BY e.EmployeeID
-- Filter to include only employees with more than one project
HAVING COUNT(ep.ProjectID) > 1;

-- Fetch all employees where the salary is same - Self Join
SELECT Employees.Name, Employees.Salary, Employees_2.Name
FROM Employees
JOIN Employees AS Employees_2 
ON Employees.Salary = Employees_2.Salary 
AND Employees.EmployeeID <> Employees_2.EmployeeID;


-- Union
SELECT EmployeeID, Name, Address, Salary, NULL AS ProjectID, NULL AS ProjectName, NULL AS StartDate, NULL AS EndDate
FROM Employees
UNION
SELECT EmployeeID, NULL AS Name, NULL AS Address, NULL AS Salary, ProjectID, ProjectName, StartDate, EndDate
FROM EmployeeProjects;






