-- Based on the 3-table schema:
-- • departments
-- • employees
-- • projects

-- ① Create Database
CREATE DATABASE join_exercise;
USE join_exercise;

-- ② Create Tables + Insert Data

--  Table: departments
CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(1, 'HR', 'Delhi'),
(2, 'IT', 'Bangalore'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Delhi');

--  Table: projects

CREATE TABLE projects (
 project_id INT PRIMARY KEY,
 project_name VARCHAR(100),
 dept_id INT,
 budget DECIMAL(12,2),
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
(101, 'HR Portal Revamp', 1, 200000),
(102, 'Cloud Transformation', 2, 600000),
(103, 'Audit Automation', 3, 350000),
(104, 'Ad Campaign 2025', 4, 150000),
(105, 'Security Upgrade', 2, 300000);

-- Table: employees

CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(50),
 dept_id INT,
 project_id INT,
 salary DECIMAL(10,2),
 manager_id INT NULL,
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
 FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employees (emp_id, emp_name, dept_id, project_id, salary, manager_id) VALUES
(1, 'Aman', 2, 102, 60000, 3),
(2, 'Ritu', 1, 101, 45000, 4),
(3, 'Rahul', 2, 102, 90000, NULL), -- Manager in IT
(4, 'Neha', 1, 101, 85000, NULL), -- Manager in HR
(5, 'Karan', 3, 103, 50000, 6),
(6, 'Shreya', 3, 103, 95000, NULL), -- Manager in Finance
(7, 'Pooja', 4, 104, 70000, NULL), -- Marketing employee
(8, 'Vivek', NULL, NULL, 40000, NULL); -- No department and no project


-- JOIN Practice Questions TIP - Table 1 JOIN Table 2 ON matching column

-- Level 1 — Basic JOIN

-- 1. Show employee name and department name (only employees with departments).
SELECT emp_name, dept_name
FROM Employees E
INNER JOIN Departments D
ON E.dept_id = D.dept_id;

-- 2. Show employee name and project name (only employees with projects).
SELECT emp_name , project_name 
FROM Employees E
INNER JOIN Projects P
ON E.Project_id = P.Project_id;

-- 3. Show project name and department name it belongs to.
SELECT project_name, dept_name
FROM Projects P
JOIN Departments D
ON P.dept_id = D.dept_id;

-- 4. Show employees with the city location of their department.
SELECT E.emp_name, D.dept_name, D.location
FROM Employees E
INNER JOIN Departments D
ON E.dept_id = D.dept_id;

-- 5. Show all departments and employees working in them (employees can be NULL).
SELECT D.dept_name, E.emp_name
FROM Departments D
LEFT JOIN Employees E
ON D.dept_id = E.dept_id;

-- 6. Show all projects and employees working on them (employees can be NULL).
SELECT P.Project_name, E.emp_name 
FROM Projects P 
LEFT JOIN Employees E
ON P.project_id = E.project_id;

-- 7. Show employees who do not have a department.
SELECT emp_name, dept_name
FROM Employees E
LEFT JOIN Departments D
ON E.dept_id = D.dept_id
WHERE D.dept_name IS NULL;

-- 8. Show employees who do not have a project.
SELECT emp_name, project_name
FROM Employees E
LEFT JOIN Projects P 
ON E.project_id = P.project_id
WHERE P.project_name IS NULL;

-- Level 2 — JOIN + WHERE conditions

-- 9. Show all employees working in the Finance department.
SELECT emp_name, dept_name
FROM Employees E
INNER JOIN Departments D
ON E.dept_id = D.dept_id
WHERE dept_name = 'Finance';

-- 10. Show employees with a salary greater than 60,000 along with their department.
SELECT E.emp_name, E.salary, D.dept_name
FROM Employees E
INNER JOIN Departments D
ON E.dept_id = D.dept_id
WHERE E.salary > 60000;

-- 11. Show projects that belong to Delhi location departments.
SELECT P.project_name, D.location
FROM Projects P
INNER JOIN Departments D
ON P.dept_id = D.dept_id
WHERE D.location = 'Delhi';

-- 12. Show employees working on the project "Cloud Transformation".
SELECT E.emp_name, P.project_name
FROM Employees E
INNER JOIN Projects P 
ON E.project_id = P.Project_id
WHERE P.project_name = 'Cloud Transformation';

-- 13. Show employees who joined before 2021 along with their project name.

############ Adding a Date coulumn and Inserting Values in the employee table to proceed with the solution.
ALTER TABLE Employees
ADD Joining_date DATE;

INSERT INTO Employees (Joining_date)
VALUES (2020/09/01); -- ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌

SELECT * FROM Employees;
UPDATE Employees
SET Joining_date = '2020-09-01'
WHERE salary > 10000;

############ Now actual JOIN QUERY
SELECT e.emp_name, P.project_name, e.Joining_date
FROM Employees e
LEFT JOIN Projects p
ON e.project_id = p.project_id
WHERE YEAR(e.Joining_date) < '2021'; -----  explanation ??????????????????update 8 rows,,, fetched only 7 rows ????????????????????????????????????///

SELECT emp_id, emp_name, salary, joining_date
FROM Employees;

-- 14. Show departments located in Mumbai along with employee names.
SELECT d.dept_name, d.location, e.emp_name
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id
WHERE d.location = 'Mumbai';

-- Level 3 — Multi-Table JOIN (3 tables)

-- 15. Show employee name, department name, and project name.
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
INNER JOIN projects p
ON d.dept_id = p.dept_id; --------------------------------------- Confirmation needed which column neededs to be joined of 3 tables in two ON conditions

-- 16. Show project name, department name, and project budget.
SELECT p.project_name, d.dept_name, p.budget
FROM projects p
INNER JOIN departments d
ON p.dept_id = d.dept_id;

-- 17. Show employee name, manager name, and department.
SELECT e.emp_name AS Employee_name , m.emp_name AS Manager_name, d.dept_name AS Department
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id
INNER JOIN departments d
ON e.dept_id = d.dept_id;               --       Ask for explanation of joing same table..... 

-- 18. Show employee name, project name, and manager name.
SELECT e.emp_name AS Employee_Name, m.emp_name AS Manager_Name , p.project_name
FROM employees e
LEFT JOIN employees m
ON m.manager_id = e.emp_id
INNER JOIN projects p
ON e.project_id = p.project_id;

-- 19. Show employee name, department location, and project budget.
SELECT e.emp_name, d.location, p.budget
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
INNER JOIN projects p 
ON e.project_id = p.project_id;

-- 20. Show employee name, project name, and salary.
SELECT e.emp_name, p.project_name, e.salary
FROM employees e
JOIN projects p 
ON e.project_id = p.project_id;

-- Level 4  Aggregate with JOIN

-- 21. Show department name and number of employees in each department;
SELECT d.dept_name, count(e.emp_id)
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 22. Show project name and number of employees working on it.
SELECT p.project_name, count(e.emp_id) AS Total_number_of_Employees
FROM projects p
INNER JOIN employees e
ON p.project_id = e.project_id
GROUP BY p.project_name;

-- 23. Show project name and sum of salary of employees working on project.
SELECT p.project_name, sum(e.salary) AS Salary_Employees
FROM projects p 
LEFT JOIN employees e
ON p.project_id = e.project_id
GROUP BY p.project_name;

-- 24. Show department name and average salary of employees in that department.
SELECT d.dept_name, avg(e.salary) AS Average_Salary_of_Employees
FROM departments d
LEFT JOIN employees e
USING (dept_id)
GROUP BY d.dept_name;

-- 25. Show department name and highest salary within that department.
SELECT d.dept_name, max(e.salary) AS Highest_salary 
FROM departments d
LEFT JOIN employees e
USING (dept_id)
GROUP BY d.dept_name;

-- 26. Show project name and minimum salary among assigned employees.
SELECT p.project_name, min(e.salary) AS Minimum_salary
FROM projects p 
LEFT JOIN employees e
USING (project_id)
GROUP BY p.project_name;

-- Level 5 — Advanced JOIN Logic

-- 27. Show employees who earn more than their manager.
SELECT e.emp_name, e.salary, m.emp_name, m.salary
FROM employees e
INNER JOIN employees m
On e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- 28. Show managers and how many employees report to them.
SELECT m.emp_name AS Manager , count(e.emp_id) AS Employees_Reporting
FROM employees m
JOIN employees e
ON e.manager_id = m.emp_id
GROUP BY m.emp_id;

-- 29. Show departments that have no employees.
SELECT d.dept_name, e.emp_name
FROM departments d
LEFT JOIN employees e
USING (dept_id)
WHERE e.emp_id IS NULL;

-- 30. Show projects that have no employees assigned.
SELECT p.project_name, e.emp_name
FROM projects p
LEFT JOIN employees e
ON p.project_id = e.project_id
WHERE e.emp_id IS NULL;

-- 31. Show employees who work in a different department than the project’s department.
SELECT e.emp_name, p.project_name
FROM employees e
INNER JOIN projects p
USING (project_id)
WHERE p.dept_id <> e.dept_id;

-- 32. Show employees who work in the same department as their manager.
SELECT e.emp_name AS Employee_Name, d.dept_name AS Department_Name, m.emp_name AS Manager_Name
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.emp_id
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.dept_id = m.dept_id;

-- 33. Show employees who work in a different department than their manager.
SELECT e.emp_name AS Employees_Name, d1.dept_name AS Employees_Department, M.emp_name AS Manager_Name, d2.dept_name AS Manager_Department
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.emp_id
INNER JOIN departments d1
ON e.dept_id = d1.dept_id
INNER JOIN departments d2
On m.dept_id = d2.dept_id
WHERE e.dept_id <> m.dept_id;

-- Level 6 — Filtering + Sorting + Grouping

-- 34. Show top 3 highest-paid employees with their project names.
SELECT e.emp_name AS Highest_Paid_Employee, p.project_name 
FROM employees e
INNER JOIN projects p 
USING (project_id) 
ORDER BY e.salary DESC LIMIT 3;

-- 35. Show departments sorted by total employee salary descending.
SELECT d.dept_name, sum(e.salary)
FROM departments d
INNER JOIN employees e
On d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY sum(e.salary) DESC;         -- WE CAN USE GROUP BY AND ORDER BY TOGETHER. 1st GROUP THEN ORDER.

-- 36. Show projects sorted by employee count descending.
SELECT p.project_name, count(e.emp_id) AS Total_number_of_Employee
FROM projects p
INNER JOIN employees e
USING (project_id)
GROUP BY p.project_name
ORDER BY count(e.emp_id) DESC;

-- 37. Show departments with employee count greater than 2 only.
SELECT d.dept_name, count(e.emp_id) AS Total_number_of_Employees
FROM departments d
INNER JOIN employees e
USING (dept_id)
GROUP BY d.dept_id
HAVING Total_number_of_Employees > 2;

-- 38. Show projects where average salary is above 70,000.
SELECT p.project_name, avg(e.salary) Average_Salary
FROM projects p 
INNER JOIN employees e
ON p.project_id = e.project_id
GROUP BY p.project_id
HAVING avg(e.salary) >70000;

-- 39. Show employees grouped by department, sorted alphabetically by department.
SELECT d.dept_name, e.emp_name
FROM employees e
INNER JOIN departments d
USING (dept_id)
ORDER BY d.dept_name ASC, e.emp_name ASC;

-- Level 7 — Practical / Real-World Queries

-- 40. Show the total payroll cost of the entire company.
SELECT sum(salary) AS TOtal_payroll_cost
FROM employees;

-- 41. Show the most expensive project based on employee salary total.
SELECT p.project_name, sum(e.salary) AS Most_Expensive_Project
FROM projects p
LEFT JOIN  employees e
ON p.project_id = e.project_id
GROUP BY p.project_name
ORDER BY Most_Expensive_Project DESC LIMIT 1;

-- 42. Show employees whose project budget is less than their salary × 5.
SELECT e.emp_name AS Employee_name, p.budget AS Project_budget, e.salary*5 AS Five_Times_salary
From employees e
LEFT JOIN projects p
USING (project_id)
WHERE p.budget < e.salary*5;

-- 43. Show department with the highest number of projects.
Select d.dept_name AS Department_Name, count(p.project_id) AS Highest_number_of_project
FROM departments d
INNER JOIN projects p 
USING (dept_id)
GROUP BY d.dept_name
ORDER BY Highest_number_of_project DESC LIMIT 1;

-- 44. Show employee working on the most expensive project.
SELECT e.emp_name AS Employee_Name, p.project_name, P.budget AS Most_Expensive_Project_Budgets
FROM employees e
INNER JOIN projects p 
USING (project_id)
WHERE p.budget = (SELECT max(budget) FROM projects );

-- 45. Show employees who do not report to a manager and their project name.
SELECT e.emp_name AS Employee_name, e.manager_id AS Current_Manager, p.project_name
FROM employees e
INNER JOIN projects p
USING (project_id)
WHERE manager_id IS NULL; 

-- 46. Show employees who report to a manager and have the same salary as someone else in the company.
SELECT e.emp_name AS Employee_name, m.emp_name AS Manager_Name, e.salary AS Same_salary
FROM employees e
INNER JOIN employees m 
ON e.manager_id = m.emp_id
INNER JOIN employees s 
ON e.salary = s.salary  AND e.emp_id <> s.emp_id
WHERE e.manager_id IS NOT NULL;

-- 47. Show employee(s) with second highest salary along with project name.
SELECT e.emp_name AS Employee_Name, e.salary AS 2nd_Highest_salary, p.project_name
FROM employees e
INNER JOIN projects p
USING (project_id)
WHERE e.salary = (SELECT DISTINCT salary FROM employees ORDER BY e.salary DESC LIMIT 1 OFFSET 1) ;

-- 48. Show employees who share the same manager (peer coworkers).
SELECT e1.emp_name AS Employee, e2.employee AS Peer_Coworkers, m.emp_name AS MAnager
FROM employees e1 
INNER JOIN employees m
ON e.manager_id = m.emp_id AND e.emp_id <> m.emp_id
WHERE e.manager_id = m.emp_id;-------------- do it again, its wrong

-- 49. Show employees whose project department is located in a different city than their home department.
-- 50. Show all employees with their level:
-- • “Top Level” = no manager
-- • “Mid Level” = has manager but no direct reports
-- • “Manager Level” = has employees reporting

-- Bonus — Challenge Questions

-- 51. Show employees hired most recently in each department.
-- 52. Show departments ranked by salary spend (use ranking logic).
-- 53. Show employees whose salary equals the average salary of their department.
-- 54. Show managers whose subordinates earn more than them.
-- 55. Show for each department, the highest paid employee and lowest paid employee.
-- 56. Show employees whose name matches any manager’s name.
-- 57. Show employee count per department per project (matrix style).
-- 58. Show how much budget of a project remains after paying employee salaries.
-- 59. Show difference between highest and lowest salary in each department.
-- 60. Show employees working on projects with budget higher than the total salary of their department.



