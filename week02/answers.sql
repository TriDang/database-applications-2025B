-- Exercises
-- The purposes of those exercises are to design the index structure
-- to support fast retrieval of data and sometimes, 
-- to show that for some queries, the index structure provides no benefit.

-- When using MySQL Workbench, we can see the time it takes to execute a query
-- by looking at the "Duration/Fetch" column in the Output pane.
-- The "Duration" is the time it took to execute the query,
-- and the "Fetch" is the time it took to retrieve the results.
-- As such, we focus on the "Duration" values

-- Query 1: Find the number of products whose category is 'Books'
SELECT COUNT(*) AS number_of_books
FROM products
WHERE category = 'Books';

-- For this query, we can create an index on the category column
-- to speed up the search.

CREATE INDEX idx_category ON products(category);

-- Query 2: Find the number of products whose prices are greater than 800 AND were created in the last 100 days
SELECT COUNT(*) AS number_of_expensive_recent_products
FROM products
WHERE price > 800 AND created_at >= NOW() - INTERVAL 100 DAY;

-- For this query, we can create a index on the combination of (price and created_at)
-- columns to speed up the search.
-- We can also create two indices on separate columns.

CREATE INDEX idx_price_created_at ON products(price, created_at);

-- Query 3: Find the number of products whose prices are less than 100 OR were created in the last 50 days
SELECT COUNT(*) AS number_of_cheap_or_recent_products
FROM products
WHERE price < 100 OR created_at >= NOW() - INTERVAL 50 DAY;

-- As the logical OR operator is used, the index on the price column
-- or the created_at column will not provide any benefit.

-- Query 4: Find the number of products whose category contains the letter 'i'
SELECT COUNT(*) AS number_of_products
FROM products
WHERE category LIKE '%i%';

-- The index on category column will not provide any benefit
-- in this case, as the LIKE operator with a leading wildcard

-- Query 5: Find the 100 most expensive products
SELECT *
FROM products
ORDER BY price DESC
LIMIT 100;

-- For this query, we can create an index on the price column
-- to speed up the sorting operation.

CREATE INDEX idx_price ON products(price);


-- More exercises: FULLTEXT index

-- Create a new 'articles' table by importing the csv file

-- Create a FULLTEXT index for the text column in the articles table
CREATE FULLTEXT INDEX idx_text ON articles(text);

-- Use MATCH() AGAINST() to search the articles table
SELECT * FROM articles WHERE MATCH(text) AGAINST('Artificial Intelligence');

-- Use MATCH() AGAINST() to search the articles table with a relevance score
SELECT *, MATCH(text) AGAINST('Database Applications') AS score FROM articles;

-- Use MATCH() AGAINST() to search the articles tab in boolean mode
SELECT * FROM articles WHERE MATCH(text) AGAINST('+Artificial -Intelligence' IN BOOLEAN MODE);
