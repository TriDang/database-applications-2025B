-- Exercise 1

-- First query
SELECT * FROM Employee
WHERE Sex = 'F' AND Dno = 5;

-- Second query
SELECT * FROM Employee
WHERE Sex = 'F' OR Dno = 5;

-- Use EXPLAIN and EXPLAIN ANALYZE to check if your
-- indexes can be used to MySQL to answer a query

-- Note 1: we should create an index on a column 
-- with more unique values
-- An index on (Dno) is better than on (Sex)

-- Note 2: the condition order we specified in
-- WHERE does not matter
-- (condition1 AND condition2) is the same as
-- (condition2 AND condition1) in terms of performance

-- Note 3: The logical OR makes some indexes useless
-- In this case, individual indexes on individual columns work

-- Suggested index:
ALTER TABLE Employee
ADD INDEX idx_dno_sex (Dno, Sex);

--------------------------------------------

-- Exercise 2

SELECT fname, dname, dependent_name
FROM Employee JOIN Department
ON Dno = Dnumber
JOIN Dependent
ON Essn = Ssn;

-- MySQL provides optimizer hints
-- https://dev.mysql.com/doc/refman/8.4/en/optimizer-hints.html
-- where you can add some hints to the optimizer


--------------------------------------------

-- Exercise 3

-- First solution: IN
SELECT Dnumber, Dname
FROM Department
WHERE Dnumber IN (
  SELECT Dno
  FROM Employee
  WHERE Ssn IN (
    SELECT Essn
    FROM Dependent
  )
);

-- Second solution: EXISTS
SELECT Dnumber, Dname
FROM Department
WHERE EXISTS (
  SELECT *
  FROM Employee JOIN Dependent
  ON Ssn = Essn
  WHERE Dno = Dnumber
);

-- Third solution: JOIN
SELECT Dnumber, Dname
FROM Department JOIN Employee
ON Dnumber = Dno
JOIN Dependent
ON Ssn = Essn;

-- Use EXPLAIN or EXPLAIN ANALYZE to see the execution plan


--------------------------------------------

-- Exercise 4

-- Create an index on `Bdate` field
CREATE INDEX idx_bdate ON Employee(Bdate);

-- Get the employees whose ages are in the range of 40 to 60

-- Use YEAR() function to extract the year from `Bdate`
SELECT *
FROM Employee
WHERE YEAR(Bdate) BETWEEN YEAR(CURDATE()) - 60 AND YEAR(CURDATE()) - 40;

-- Calculate the range of years in advance and use them directly
SELECT *
FROM Employee
WHERE Bdate BETWEEN '1965-01-01' AND '1985-12-31';

-- Use EXPLAIN or EXPLAIN ANALYZE to see the execution plan
