-- Exercise 1

-- Queries

-- Total sale amount from 2024-12-01 to 2025-07-03
SELECT SUM(amount) AS total_sales
FROM sales
WHERE sale_date BETWEEN '2024-12-01' AND '2025-07-03';

-- First 100 sales in that date range
SELECT *
FROM sales
WHERE sale_date BETWEEN '2024-12-01' AND '2025-07-03'
ORDER BY sale_date
LIMIT 100;

-- Add partitions
ALTER TABLE sales
PARTITION BY RANGE COLUMNS(sale_date) (
  PARTITION p2020 VALUES LESS THAN ('2021-01-01'),
  PARTITION p2021 VALUES LESS THAN ('2022-01-01'),
  PARTITION p2022 VALUES LESS THAN ('2023-01-01'),
  PARTITION p2023 VALUES LESS THAN ('2024-01-01'),
  PARTITION p2024 VALUES LESS THAN ('2025-01-01'),
  PARTITION p2025 VALUES LESS THAN ('2026-01-01')
);


-- Exercise 2

-- Create table
CREATE TABLE students (
  id INT,
  full_name VARCHAR(100),
  start_date DATETIME,
  campus CHAR(10)
);

-- Insert sample data
INSERT INTO students (id, full_name, start_date, campus) VALUES
(1, 'Alice', '2023-02-15', 'City'),
(2, 'Bob', '2024-03-10', 'Brunswick'),
(3, 'Carol', '2025-06-01', 'HN'),
(4, 'David', '2022-09-20', 'SGS'),
(5, 'Emma', '2023-07-01', 'Bundoora'),
(6, 'Frank', '2024-12-12', 'SGS'),
(7, 'Grace', '2025-05-05', 'HN');

-- Query
SELECT *
FROM students
WHERE campus = 'SGS' AND start_date BETWEEN '2023-01-01' AND '2025-07-02';

-- Add partitioning
ALTER TABLE students
PARTITION BY LIST COLUMNS(campus) (
  PARTITION p_city VALUES IN ('City'),
  PARTITION p_brunswick VALUES IN ('Brunswick'),
  PARTITION p_bundoora VALUES IN ('Bundoora'),
  PARTITION p_sgs VALUES IN ('SGS'),
  PARTITION p_hn VALUES IN ('HN')
);

-- Exercise 3

-- Because the goal is even distribution based on a positive integer customer_id
-- the most suitable solution is to use HASH partitioning on customer_id

CREATE TABLE transactions (
  transaction_id INT,
  customer_id INT,
  transaction_date DATE,
  amount DECIMAL(10,2)
)
PARTITION BY HASH(customer_id)
PARTITIONS 4;

-- Insert sample data
INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 1, '2024-07-01', 200.00),
(2, 2, '2024-07-02', 150.00),
(3, 3, '2024-07-03', 300.00),
(4, 4, '2024-07-04', 500.00),
(5, 5, '2024-07-05', 120.00),
(6, 6, '2024-07-06', 220.00),
(7, 7, '2024-07-07', 340.00),
(8, 8, '2024-07-08', 180.00);

-- Check data distribution in partitions
SELECT partition_name, table_rows
FROM information_schema.partitions
WHERE table_name = 'transactions';
