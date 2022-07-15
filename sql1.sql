-- QUESTION 1
-- Normalising the given table into 3NF, we will get the following tables
-- employee {emp_id, emp_name}
-- department {dept_id, dept_name}
-- pay {emp_id, pay}
-- emp_dept {emp_id, dept_id}


CREATE DATABASE evaluation;
USE evaluation;

CREATE TABLE employee (
	emp_id VARCHAR(5) PRIMARY KEY,
	emp_name VARCHAR(20)
)

CREATE TABLE department (
	dept_id VARCHAR(5) PRIMARY KEY,
	dept_name VARCHAR(20)
)

CREATE TABLE pay (
	emp_id VARCHAR(5) FOREIGN KEY REFERENCES employee(emp_id) ON DELETE CASCADE,
	pay INT
)

CREATE TABLE emp_dept (
	emp_id VARCHAR(5) FOREIGN KEY REFERENCES employee(emp_id) ON DELETE CASCADE,
	dept_id VARCHAR(5) FOREIGN KEY REFERENCES department(dept_id) ON DELETE CASCADE
)

INSERT INTO employee VALUES
	('001', 'Dilip'),
	('002', 'Fahad'),
	('003', 'Lal'),
	('004', 'Nivin'),
	('005', 'Vijay'),
	('006', 'Anu'),
	('007', 'Nimisha'),
	('008', 'Praveena') 

INSERT INTO department VALUES 
	('101', 'IT'),
	('102', 'Sales'),
	('103', 'Marketing'),
	('104', 'HR')

INSERT INTO pay VALUES
	('001', 3000),
	('002', 4000),
	('003', 6000),
	('004', 2000),
	('005', 9000),
	('006', 5000),
	('007', 5000),
	('008', 8000)


INSERT INTO emp_dept VALUES
	('001', '101'),
	('002', '102'),
	('003', '103'),
	('004', '101'),
	('005', '102'),
	('006', '104'),
	('007', '102'),
	('008', '103') 

CREATE VIEW EmployeeDetails AS
	SELECT employee.emp_id, employee.emp_name, pay.pay, department.dept_name, department.dept_id as dept_id
	FROM
		employee
		INNER JOIN pay ON employee.emp_id = pay.emp_id
		INNER JOIN emp_dept ON employee.emp_id = emp_dept.emp_id
		INNER JOIN department ON emp_dept.dept_id = department.dept_id

-- 1. The total number of employees
SELECT COUNT(emp_id) FROM employee

-- 2. Total amount required to pay all employees
SELECT SUM(pay) FROM pay

-- 3. Average, minimum and maximum pay in the organization
SELECT 
	AVG(pay) AS 'Average Pay',
	MIN(pay) AS 'Minimum Pay',
	MAX(pay) AS 'Maximum Pay'
		FROM pay

-- 4. Each Department wise total pay
SELECT dept_name AS 'Department', SUM(pay) AS 'Total pay'
FROM EmployeeDetails
GROUP BY dept_name

-- 5. Average, minimum and maximum pay department wise
SELECT 
	dept_name AS 'Department', 
	AVG(pay) AS 'Average pay',
	MIN(pay) AS 'Minimum pay',
	MAX(pay) AS 'Maximim pay'
FROM EmployeeDetails
GROUP BY dept_name

-- 6. Employee details who earns the maximum pay
SELECT * FROM EmployeeDetails WHERE pay IN (SELECT MAX(pay) FROM pay)

-- 7. Employee details who is having a maximum pay in the department (CHECK BACK)


-- 9. Employee who has more pay than the average pay of his department (CHECK BACK)



-- 10. Unique departments in the company
SELECT
	dept_name AS 'Departments'
		FROM department

-- 11. Employees in increasing order of pay
SELECT
	emp_name AS 'Name',
	pay AS 'Pay'
		FROM EmployeeDetails
		ORDER BY pay

-- 12. Department in increasing order of pay
CREATE VIEW deptTotalPay AS
	SELECT
	dept_name AS 'Department',
	SUM(pay) as 'Total_pay'
	FROM EmployeeDetails
	GROUP BY dept_name

SELECT * FROM deptTotalPay ORDER BY Total_pay ASC
