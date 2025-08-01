-- Exercise 1

-- Creating views

CREATE VIEW Dept_stats
AS
SELECT Dnumber, Dname, Mgr.Fname AS Manager_name, COUNT(*) AS NoOfEmp
FROM Department JOIN Employee Mgr
ON Mgr_ssn = Mgr.Ssn
JOIN Employee Emp
ON Dnumber = Emp.Dno
GROUP BY Dnumber, Dname, Manager_name;

-- Using views

SELECT * FROM Dept_stats
WHERE NoOfEmp > 3;

-- Check views updatable property

SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'Dept_stats';

--------------------------------------------

-- Exercise 2

-- Create stored procedures

DELIMITER $$$
CREATE PROCEDURE sp_update_salary(IN EmpID CHAR(9),
                                  IN IncAmt DECIMAL(5,0))
BEGIN
  UPDATE Employee SET Salary = Salary + IncAmt
  WHERE Ssn = EmpID;
END $$$
DELIMITER ;

-- Call the stored procedure
CALL sp_update_salary('111111112', 1000);

-----------------------------------

-- Exercise 3

-- Create function

DELIMITER $$
CREATE FUNCTION fn_maxSalary (department_number INT)
RETURNS CHAR(9) NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE max_sal DECIMAL(6, 0);  -- maximum salary
  DECLARE max_ssn CHAR(9);  -- SSN of employee whose salary is maximum
  
  -- get maximum salary
  SELECT MAX(Salary) INTO max_sal
  FROM Employee
  WHERE Dno = department_number;
  
  -- search for SSN
  SELECT Ssn INTO max_ssn
  FROM Employee
  WHERE Dno = department_number AND salary = max_sal;
  
  RETURN max_ssn;
END $$

DELIMITER ;

-- Use function

SELECT dnumber, dname, fname, salary
FROM department
JOIN employee
ON dnumber = dno
WHERE ssn = fn_maxSalary(dnumber);

--------------------------------------------

-- Exercise 4

-- Create materialized view

CREATE TABLE dept_avg_salary
SELECT dnumber, dname, avg(salary) AS avg_salary
FROM department JOIN employee
ON dnumber = dno
GROUP BY dnumber, dname;

-- Use trigger to sync data

DELIMITER $$
CREATE TRIGGER trg_avg_sal
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
  DECLARE avg_sal DECIMAL(9, 2);  -- updated average salary

  SELECT AVG(salary) INTO avg_sal
  FROM employee
  WHERE dno = new.dno;

  UPDATE dept_avg_salary SET avg_salary = avg_sal
  WHERE dnumber = new.dno;
END $$
DELIMITER ;

--------------------------------------------

-- Exercise 5

DELIMITER $$
CREATE TRIGGER trg_prevent_overwork
AFTER INSERT ON works_on
FOR EACH ROW
BEGIN
  DECLARE total_hour decimal(3, 1);
  SELECT sum(hours) into total_hour
  FROM works_on
  WHERE essn = new.essn;

  if total_hour > 40 then
    SIGNAL SQLSTATE '45000' SET message_text = 'Do not work too hard! Get a life';
  end if;
END $$
DELIMITER ;
