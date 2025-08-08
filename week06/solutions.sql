-- Exercise 1
START TRANSACTION;

UPDATE Department
SET Mgr_ssn = '123456789', Mgr_start_date = CURDATE()
WHERE Dnumber = 5;

UPDATE Employee
SET Salary = Salary + 2000
WHERE Ssn = '123456789';

COMMIT;

-- Exercise 2.1
-- Session #1
-- Time T1
START TRANSACTION;

-- Time T3
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- Time T6
COMMIT;

-- Session #2
-- Time T2
START TRANSACTION;

-- Time T4
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- Time T5
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- Time T7
COMMIT;

-- Experimenting with SELECT FOR UPDATE

-- Exercise 2.2
-- Session #1
-- Time T1
START TRANSACTION;

-- Time T3
SELECT * FROM Employee
WHERE Ssn = '123456789' FOR SHARE;

-- Time T5
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '333445555';

-- Time T7
COMMIT;

-- Session #2
-- Time T2
START TRANSACTION;

-- Time T4
SELECT * FROM Employee
WHERE Ssn = '333445555' FOR SHARE;

-- Time T6
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- Time T8
COMMIT;

-- Exercise 3.1 (Repeatable Read)
-- Session #1
-- Time T1
START TRANSACTION;

-- Time T3
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- Time T6
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- Time T7
COMMIT;

-- Session #2
-- Time T2
START TRANSACTION;

-- Time T4
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- Time T5
COMMIT;

-- Exercise 3.2 (Read Uncommitted)
-- Session #1
SET SESSION TRANSACTION ISOLATION LEVEL Read Uncommitted;
-- Time T1
START TRANSACTION;

-- Time T3
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- Time T6
SELECT * FROM Employee
WHERE Ssn = '123456789';

-- Time T7
COMMIT;

-- Session #2
SET SESSION TRANSACTION ISOLATION LEVEL Read Uncommitted;
-- Time T2
START TRANSACTION;

-- Time T4
UPDATE Employee
SET Salary = Salary + 1000
WHERE Ssn = '123456789';

-- Time T5
ROLLBACK;
