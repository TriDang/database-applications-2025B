-- Exercise 1: SQL Queries

-- 1.1
SELECT Fname FROM Employee JOIN Department
ON Dno = Dnumber JOIN Works_on
ON Essn = Ssn
WHERE hours >= 10 AND Dname = 'Research';

-- 1.2
SELECT Emp.Fname
FROM Employee Mgr JOIN Department ON Mgr.Ssn = Mgr_ssn
JOIN Employee Emp ON Mgr.Ssn = Emp.Super_ssn
WHERE Dname = 'Research';

-- 1.3
SELECT Fname FROM Employee JOIN Department
ON Mgr_ssn = Ssn
WHERE Ssn NOT IN
  (SELECT Essn FROM works_on);

-- 1.4
SELECT Pname, SUM(Hours) AS Total_hour
FROM Project JOIN Works_on ON Pnumber = Pno
GROUP BY Pname;

-- 1.5
SELECT Fname
FROM Employee
WHERE Ssn NOT IN
(
  SELECT Essn
  FROM Project JOIN Works_on ON Pnumber = Pno
  WHERE Plocation = 'Houston'
);

-- 1.6
SELECT DISTINCT Fname
FROM Employee JOIN Works_on w_out ON Ssn = Essn
WHERE NOT EXISTS
(
  SELECT Pnumber
  FROM Project LEFT JOIN (SELECT * FROM Works_on w_in WHERE w_out.Essn = W_in.Essn) AS Prj_Emp
  ON Pnumber = Prj_Emp.Pno
  WHERE Plocation = 'Houston' AND Prj_Emp.Pno IS NULL
);

-- Explanation 1: first, the DIFFERENCE (MINUS) operator:
-- {A, B, C} DIFFERENCE {B, C, D} = {A}
-- But, MySQL doesn't support DIFFERENCE. However, we can use OUTER JOIN instead.
-- What is the result of {A, B, C} LEFT JOIN {(B, x), (C, y), (D, z)}?
-- {B, C} have matching records, but not {A}
-- So, {A, B, C} LEFT JOIN {(B, x), (C, y), (D, z)} = {(A, NULL), (B, x), (C, y)}
-- By using IS NULL condition, we can keep only (A, NULL)

-- Explanation 2: the outer query find all employees and their projects.
-- Then, for each combination of (Employee, Project), we calculate
-- (all 'Houston' projects DIFFERENCE all projects being done by this employee)
-- if the result is empty (NOT EXISTS) => this employee is working on
-- all Houston projects

-- Explanation 3: MySQL 8.0.31 added the EXCEPT operator
-- which is another name for DIFFERENCE/MINUS
-- https://dev.mysql.com/doc/refman/8.0/en/except.html

-- another solution for 1.6 using EXCEPT
-- SELECT DISTINCT Fname
-- FROM Employee JOIN Works_on w_out ON Ssn = Essn
-- WHERE NOT EXISTS
-- (
--   SELECT Pnumber
--   FROM Project
--   WHERE Plocation = 'Houston'
--   EXCEPT
--   SELECT Pno
--   FROM Works_on w_in
--   WHERE w_in.Essn = Ssn  
-- );

-- 1.7
SELECT Fname, Salary
FROM Employee
WHERE (Dno, Salary) IN
(
  SELECT Dno, Max(Salary)
  FROM Employee
  GROUP BY Dno
);

-- 1.8
SELECT Dname, COUNT(*) No_Emp
FROM Department JOIN Employee ON Dnumber = Dno
GROUP BY Dname
HAVING COUNT(*) >= 3;

-- 1.9
SELECT Supervisee.Fname, Supervisee.Bdate, Supervisor.Fname, Supervisor.Bdate
FROM Employee Supervisee JOIN Employee Supervisor ON Supervisee.Super_ssn = Supervisor.Ssn
WHERE Supervisee.Bdate <= Supervisor.Bdate;


-- Exercise 2: Normalization
Order (OrderID, CustomerID, CustomerName, CustomerPhone, Products, OrderDate)

-- An order must belong to a single customer. There can be multiple products in an order.
-- Normalize the Order relation to 1NF, 2NF, and 3NF.

-- 1NF: The relation is not 1NF because it contains a multi-valued attribute (Products).
-- To convert it to 1NF, we need to create a separate row for each product in an order.
-- The new relation will look like this:
OrderDetail (OrderID, Product, CustomerID, CustomerName, CustomerPhone, OrderDate)
The combination of OrderID and Product will be the primary key.

-- 2NF: The relation is not in 2NF because CustomerID, CustomerName, CustomerPhone, and OrderDate
-- depend only on CustomerID, not on the entire primary key (OrderID, Product).
-- To convert it to 2NF, we need to create a separate relation for OrderID and those attributes.
Order (OrderID, CustomerID, CustomerName, CustomerPhone, OrderDate)

-- The OrderDetail relation will now look like this:
OrderDetail (OrderID, Product)

-- 3NF: The relation is not in 3NF because CustomerName and CustomerPhone depend on CustomerID,
-- which is not a primary key in the Order relation.
-- To convert it to 3NF, we need to create a separate relation for Customer information.
Customer (CustomerID, CustomerName, CustomerPhone)

-- The Order relation will now look like this:
Order (OrderID, CustomerID, OrderDate)

-- Overall, the final relations after normalization are:
Order (OrderID, CustomerID, OrderDate)
OrderDetail (OrderID, Product)
Customer (CustomerID, CustomerName, CustomerPhone)
