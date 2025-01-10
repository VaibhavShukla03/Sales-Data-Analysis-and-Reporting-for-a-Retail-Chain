Create database RetailSaleDataDB;
use RetailSaleDataDB;

Create Table Sales_Data_Transactions(
customer_id VARCHAR(255),
trans_date VARCHAR(255),
tran_amount INT
);

Create Table Sales_Data_Response(
customer_id VARCHAR(255),
response INT
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Retail_Data_Transactions.csv'
INTO TABLE Sales_Data_Transactions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Retail_Data_Response.csv'
INTO TABLE Sales_Data_Response
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Showing all data
select * from sales_data_response;
select * from sales_data_transactions;

-- **## Phase 2 & 3: Data Cleaning and Preparation & Data Analysis **## --
--
EXPLAIN select * from sales_data_transactions where Customer_id = 'CS5295';

create index idx_id on sales_data_transactions(Customer_Id);



-- Handling missing values
UPDATE sales_data_transactions
SET tran_amount = 0
WHERE tran_amount IS NULL;

-- Removing outliers

DELETE FROM sales_data_transactions
WHERE tran_amount > (SELECT Q3 + 1.5 * (Q3 - Q1) FROM (
    SELECT QUANTILE(tran_amount, 0.25) AS Q1, QUANTILE(tran_amount, 0.75) AS Q3
    FROM sales_data_transactions
) AS Q);