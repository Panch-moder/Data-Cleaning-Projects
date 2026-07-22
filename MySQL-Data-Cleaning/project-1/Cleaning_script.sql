SELECT *
FROM ecommerce_sales;

CREATE TABLE ecommerce_sales_staging
LIKE ecommerce_sales;

INSERT ecommerce_sales_staging
SELECT *
FROM ecommerce_sales;

SELECT *
FROM ecommerce_sales_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ID, Customer_Name, Order_ID, 
Order_Date, Product, Category, Quantity, Price, Payment_Method, `Status`, Total) AS row_num
FROM ecommerce_sales_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `ecommerce_sales_staging2` (
  `ID` int DEFAULT NULL,
  `Customer_Name` text,
  `Order_ID` text,
  `Order_Date` text,
  `Product` text,
  `Category` text,
  `Quantity` int DEFAULT NULL,
  `Price` text,
  `Payment_Method` text,
  `Status` text,
  `Total` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO ecommerce_sales_staging2
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY ID, Customer_Name, Order_ID, 
Order_Date, Product, Category, Quantity, Price, Payment_Method, `Status`, Total) AS row_num
FROM ecommerce_sales_staging;

SELECT *
FROM ecommerce_sales_staging2;

SELECT *
FROM ecommerce_sales_staging2
WHERE row_num > 1;

DELETE
FROM ecommerce_sales_staging2
WHERE row_num > 1;

SELECT Product
FROM ecommerce_sales_staging2
GROUP BY Product;

SELECT Category
FROM ecommerce_sales_staging2
GROUP BY Category;

SELECT Category, CONCAT(UPPER(SUBSTRING(Category, 1, 1)), 
SUBSTRING(Category, 2)) AS up_Category
FROM ecommerce_sales_staging2;

UPDATE ecommerce_sales_staging2
SET Category = CONCAT(UPPER(SUBSTRING(Category, 1, 1)), 
SUBSTRING(Category, 2));

SELECT Category
FROM ecommerce_sales_staging2
WHERE Category LIKE '%electronic%';

UPDATE ecommerce_sales_staging2
SET Category = 'Electronics'
WHERE Category LIKE '%electronic%';

SELECT *
FROM ecommerce_sales_staging2
WHERE Category LIKE 'nan';

SELECT *
FROM ecommerce_sales_staging2
WHERE Product LIKE 'Biography';

UPDATE ecommerce_sales_staging2
SET Category = 'Books'
WHERE Product LIKE 'Biography';

SELECT *
FROM ecommerce_sales_staging2
WHERE Product LIKE 'Smartphone';

UPDATE ecommerce_sales_staging2
SET Category = 'Electronics'
WHERE Product LIKE 'Smartphone';

SELECT *
FROM ecommerce_sales_staging2;

SELECT *
FROM ecommerce_sales_staging2
WHERE Quantity LIKE '-%'
AND Total LIKE '-%';

DELETE
FROM ecommerce_sales_staging2
WHERE Quantity LIKE '-%'
AND Total LIKE '-%';

DELETE
FROM ecommerce_sales_staging2
WHERE Total LIKE '-300';

-- Category, Price, Total

SELECT *
FROM ecommerce_sales_staging2
WHERE Category = '' ;

SELECT *
FROM ecommerce_sales_staging2 t1
JOIN ecommerce_sales_staging2 t2
	ON t1.Product = t2.Product
WHERE (t1.Category IS NULL OR t1.Category = '')
AND t2.Category != '';

UPDATE ecommerce_sales_staging2 t1
JOIN ecommerce_sales_staging2 t2
	ON t1.Product = t2.Product
SET t1.Category = t2.Category
WHERE (t1.Category IS NULL OR t1.Category = '')
AND t2.Category != '';

SELECT *
FROM ecommerce_sales_staging2;

SELECT *
FROM ecommerce_sales_staging2
WHERE Price = '' OR TRIM(Price) REGEXP '^[[:alpha:] ]+$';

DELETE
FROM ecommerce_sales_staging2
WHERE Price = '' OR TRIM(Price) REGEXP '^[[:alpha:] ]+$';

SELECT *
FROM ecommerce_sales_staging2
WHERE Total = '';

DELETE
FROM ecommerce_sales_staging2
WHERE Total = '';

SELECT *
FROM ecommerce_sales_staging2;

-- Data formatting (Order_Date, Price, Total)

SELECT Order_Date, 
STR_TO_DATE(Order_Date, '%m/%d/%Y')
FROM ecommerce_sales_staging2
WHERE Order_Date REGEXP '^[[0-9/] ]+$';

UPDATE ecommerce_sales_staging2
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y')
WHERE Order_Date REGEXP '^[[0-9/] ]+$';

SELECT Order_Date, 
STR_TO_DATE(Order_Date, '%b %e %Y')
FROM ecommerce_sales_staging2
WHERE Order_Date NOT REGEXP '^[[0-9-] ]+$';

UPDATE ecommerce_sales_staging2 
SET Order_Date = STR_TO_DATE(Order_Date, '%b %e %Y')
WHERE Order_Date NOT REGEXP '^[[0-9-] ]+$';

SELECT *
FROM ecommerce_sales_staging2;

ALTER TABLE ecommerce_sales_staging2
MODIFY COLUMN Order_Date DATE;

ALTER TABLE ecommerce_sales_staging2
MODIFY COLUMN Price DECIMAL(10,2);

ALTER TABLE ecommerce_sales_staging2
MODIFY COLUMN Total DECIMAL(10,2);

SELECT Price, Total
FROM ecommerce_sales_staging2;

-- Final check

SELECT ID, COUNT(*) 
FROM ecommerce_sales_staging2
GROUP BY ID
HAVING COUNT(*) > 1;

DELETE
FROM ecommerce_sales_staging2
WHERE ID IN (
	SELECT ID FROM (
		SELECT ID
		FROM ecommerce_sales_staging2
		GROUP BY ID
		HAVING COUNT(*) > 1 
	) AS tmp
)
AND Total != (Price*Quantity);

ALTER TABLE ecommerce_sales_staging2
DROP COLUMN row_num;

SELECT GROUP_CONCAT(
	CONCAT('`', COLUMN_NAME, '` IS NULL OR `', COLUMN_NAME, '` = \'\' OR `', COLUMN_NAME, '` IN (\'N/A\', \'none\', \'null\')')
    SEPARATOR ' OR \n') AS generated_sql
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'data_cleaning'
AND TABLE_NAME = 'ecommerce_sales_staging2';

SELECT *
FROM ecommerce_sales_staging2
WHERE (`ID` IS NULL OR `ID` = '' OR `ID` IN ('N/A', 'none', 'null') OR 
`Customer_Name` IS NULL OR `Customer_Name` = '' OR `Customer_Name` IN ('N/A', 'none', 'null') OR 
`Order_ID` IS NULL OR `Order_ID` = '' OR `Order_ID` IN ('N/A', 'none', 'null') OR 
`Product` IS NULL OR `Product` = '' OR `Product` IN ('N/A', 'none', 'null') OR 
`Category` IS NULL OR `Category` = '' OR `Category` IN ('N/A', 'none', 'null') OR 
`Quantity` IS NULL OR `Quantity` = '' OR `Quantity` IN ('N/A', 'none', 'null') OR 
`Price` IS NULL OR `Price` = '' OR `Price` IN ('N/A', 'none', 'null') OR 
`Payment_Method` IS NULL OR `Payment_Method` = '' OR `Payment_Method` IN ('N/A', 'none', 'null') OR 
`Status` IS NULL OR `Status` = '' OR `Status` IN ('N/A', 'none', 'null') OR 
`Total` IS NULL OR `Total` = '' OR `Total` IN ('N/A', 'none', 'null'));

SELECT ID, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY ID;

SELECT Order_ID, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Order_ID;

SELECT Order_Date, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Order_Date;

SELECT Product, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Product;

SELECT Category, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Category;

SELECT Quantity, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Quantity;

SELECT Payment_Method, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY Payment_Method;

SELECT `Status`, COUNT(*)
FROM ecommerce_sales_staging2
GROUP BY `Status`;

SELECT *
FROM ecommerce_sales_staging2
WHERE Price < 0 OR Total < 0;

SELECT *
FROM ecommerce_sales_staging2
WHERE Total != (Price*Quantity);

UPDATE ecommerce_sales_staging2
SET Total = (Price*Quantity)
WHERE Total != (Price*Quantity);

SELECT *
FROM ecommerce_sales_staging2
WHERE Order_Date > NOW();

SELECT *
FROM ecommerce_sales_staging2
WHERE Order_Date < (
	SELECT Order_Date
    FROM ecommerce_sales_staging2
    ORDER BY Order_Date ASC
    LIMIT 1
);

SELECT *
FROM ecommerce_sales_staging2;
