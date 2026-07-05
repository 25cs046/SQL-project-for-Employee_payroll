-- ================================================
-- PROJECT 3: EMPLOYEE PAYROLL DATABASE
-- Author: Deivanai K
-- Description: A database to manage employees,
--              departments and payroll records
-- ================================================

-- DROP existing tables
DROP TABLE IF EXISTS payroll;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- ================================================
-- CREATE TABLES
-- ================================================

CREATE TABLE departments (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL,
    manager TEXT
);

CREATE TABLE employees (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    email       TEXT,
    position    TEXT,
    dept_id     INTEGER
);

CREATE TABLE payroll (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id  INTEGER,
    month        TEXT,
    basic_pay    REAL,
    allowance    REAL,
    deductions   REAL,
    net_pay      REAL
);

-- ================================================
-- INSERT SAMPLE DATA
-- ================================================

INSERT INTO departments (name, manager) VALUES
    ('Engineering', 'Rajesh Kumar'),
    ('Marketing', 'Sunita Sharma'),
    ('Human Resources', 'Amit Patel'),
    ('Finance', 'Priya Mehta');

INSERT INTO employees (name, email, position, dept_id) VALUES
    ('Ravi Kumar', 'ravi@company.com', 'Software Engineer', 1),
    ('Priya Sharma', 'priya@company.com', 'Marketing Lead', 2),
    ('Kiran Raj', 'kiran@company.com', 'HR Manager', 3),
    ('Ananya Singh', 'ananya@company.com', 'Finance Analyst', 4),
    ('Arjun Mehta', 'arjun@company.com', 'Senior Engineer', 1),
    ('Sneha Patel', 'sneha@company.com', 'Marketing Executive', 2);

INSERT INTO payroll (employee_id, month, basic_pay, allowance, deductions, net_pay) VALUES
    (1, '2024-01', 50000, 10000, 5000, 55000),
    (2, '2024-01', 45000, 8000, 4500, 48500),
    (3, '2024-01', 40000, 7000, 4000, 43000),
    (4, '2024-01', 55000, 12000, 5500, 61500),
    (5, '2024-01', 70000, 15000, 7000, 78000),
    (6, '2024-01', 35000, 6000, 3500, 37500);

-- ================================================
-- FEATURE 1: View all employees with department
-- ================================================

SELECT 
    employees.name AS employee_name,
    employees.position,
    departments.name AS department,
    departments.manager
FROM employees
JOIN departments ON employees.dept_id = departments.id
ORDER BY departments.name, employees.name;

-- ================================================
-- FEATURE 2: Calculate net salary per employee
-- ================================================

SELECT 
    employees.name AS employee_name,
    employees.position,
    payroll.basic_pay,
    payroll.allowance,
    payroll.deductions,
    payroll.basic_pay + payroll.allowance - payroll.deductions AS calculated_net_pay,
    payroll.net_pay AS stored_net_pay
FROM payroll
JOIN employees ON payroll.employee_id = employees.id
ORDER BY calculated_net_pay DESC;

-- ================================================
-- FEATURE 3: Highest paid employees
-- ================================================

SELECT 
    employees.name AS employee_name,
    employees.position,
    departments.name AS department,
    payroll.net_pay
FROM payroll
JOIN employees ON payroll.employee_id = employees.id
JOIN departments ON employees.dept_id = departments.id
ORDER BY payroll.net_pay DESC
LIMIT 3;

-- ================================================
-- FEATURE 4: Department wise salary summary
-- ================================================

SELECT 
    departments.name AS department,
    COUNT(employees.id) AS total_employees,
    SUM(payroll.net_pay) AS total_salary,
    ROUND(AVG(payroll.net_pay), 2) AS average_salary,
    MAX(payroll.net_pay) AS highest_salary,
    MIN(payroll.net_pay) AS lowest_salary
FROM payroll
JOIN employees ON payroll.employee_id = employees.id
JOIN departments ON employees.dept_id = departments.id
GROUP BY departments.id, departments.name
ORDER BY total_salary DESC;

-- ================================================
-- FEATURE 5: Employee deduction percentage
-- ================================================

SELECT 
    employees.name AS employee_name,
    employees.position,
    departments.name AS department,
    payroll.basic_pay,
    payroll.deductions,
    ROUND((payroll.deductions / payroll.basic_pay) * 100, 2) AS deduction_percentage
FROM payroll
JOIN employees ON payroll.employee_id = employees.id
JOIN departments ON employees.dept_id = departments.id
ORDER BY deduction_percentage DESC;
