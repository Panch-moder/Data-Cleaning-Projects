SELECT *
FROM messy_employee_dataset;

CREATE TABLE messy_employee_dataset2
LIKE messy_employee_dataset;

INSERT INTO messy_employee_dataset2
SELECT *
FROM messy_employee_dataset;

-- Duplicates

WITH duplicate_cte AS
(
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY Employee_ID, First_Name,
    Last_Name, Age, Department_Region, `Status`, Join_Date,
    Salary, Email, Phone, Performance_Score, Remote_Work) AS row_num
FROM messy_employee_dataset2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT Employee_ID, COUNT(*)
FROM messy_employee_dataset2
GROUP BY Employee_ID;

-- Typo

SELECT Employee_ID
FROM messy_employee_dataset2
WHERE Employee_ID REGEXP '[[:space:]]{2,}';

SELECT First_Name
FROM messy_employee_dataset2
WHERE NOT First_Name REGEXP '^[[:alpha:]]+$';

SELECT Last_Name
FROM messy_employee_dataset2
WHERE NOT Last_Name REGEXP '^[[:alpha:]]+$';

SELECT Age
FROM messy_employee_dataset2
WHERE NOT Age REGEXP '[0-9]';

SELECT Department_Region
FROM messy_employee_dataset2
GROUP BY Department_Region;

SELECT `Status`
FROM messy_employee_dataset2
GROUP BY `Status`;

SELECT `Status`
FROM messy_employee_dataset2
GROUP BY `Status`;

SELECT Join_Date
FROM messy_employee_dataset2
WHERE NOT Join_Date REGEXP '[[0-9/]]+$';

SELECT Salary
FROM messy_employee_dataset2
WHERE NOT Salary REGEXP '[[0-9.]]+$';

SELECT Performance_Score
FROM messy_employee_dataset2
GROUP BY Performance_Score;

SELECT Remote_Work
FROM messy_employee_dataset2
GROUP BY Remote_Work;

-- Deleting Useles Data

SELECT *
FROM messy_employee_dataset2;

SELECT *
FROM messy_employee_dataset2
WHERE Age = '';

DELETE
FROM messy_employee_dataset2
WHERE Age = '';

ALTER TABLE messy_employee_dataset2
DROP COLUMN Phone;

-- Date Logic

SELECT *
FROM messy_employee_dataset2
WHERE Join_Date > NOW();

SELECT *
FROM messy_employee_dataset2
WHERE Join_Date < (
	SELECT Join_Date
    FROM messy_employee_dataset2
    ORDER BY Join_Date ASC
    LIMIT 1
);

-- Casting Columns to the Correct Type

SELECT Join_Date, STR_TO_DATE(Join_Date, '%m/%d/%Y') 
FROM messy_employee_dataset2;

UPDATE messy_employee_dataset2
SET Join_Date = STR_TO_DATE(Join_Date, '%m/%d/%Y');

ALTER TABLE messy_employee_dataset2
MODIFY COLUMN Age INT;

ALTER TABLE messy_employee_dataset2
MODIFY COLUMN Salary DECIMAL(10,2);

SELECT *
FROM messy_employee_dataset2
WHERE Salary LIKE '%._';

SELECT *
FROM messy_employee_dataset2;

