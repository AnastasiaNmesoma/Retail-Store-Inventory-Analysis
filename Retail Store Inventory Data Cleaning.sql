CREATE DATABASE InventoryDB;
USE InventoryDB;

/*Explore all Object in the dataset*/
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

--===============================================================================================================================

-- Count of missing/null values per column
SELECT 
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Store_ID,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Product_ID,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Missing_Category,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN Inventory_Level IS NULL THEN 1 ELSE 0 END) AS Missing_Inventory,
    SUM(CASE WHEN Units_Sold IS NULL THEN 1 ELSE 0 END) AS Missing_Units_Sold,
    SUM(CASE WHEN Units_Ordered IS NULL THEN 1 ELSE 0 END) AS Missing_Units_Ordered,
    SUM(CASE WHEN Demand_Forecast IS NULL THEN 1 ELSE 0 END) AS Missing_Demand_Forecast,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Missing_Price,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS Missing_Discount,
    SUM(CASE WHEN Weather_Condition IS NULL THEN 1 ELSE 0 END) AS Missing_Weather,
    SUM(CASE WHEN Holiday_Promotion IS NULL THEN 1 ELSE 0 END) AS Missing_Holiday,
    SUM(CASE WHEN Competitor_Pricing IS NULL THEN 1 ELSE 0 END) AS Missing_Competitor,
    SUM(CASE WHEN Seasonality IS NULL THEN 1 ELSE 0 END) AS Missing_Seasonality
FROM Retail_Store_Inventory;

--===============================================================================================================================

-- Column Name
SELECT STRING_AGG(COLUMN_NAME, ', ') AS Column_List
FROM INFORMATION_SCHEMA.COLUMNS

-- Checking full row duplicate
SELECT 
    Category, Competitor_Pricing, Date, Demand_Forecast, 
    Discount, Holiday_Promotion, Inventory_Level, Price, 
    Product_ID, Region, Seasonality, Store_ID, Units_Ordered, 
    Units_Sold, Weather_Condition,
    COUNT(*) AS Duplicate_Count
FROM Retail_Store_Inventory
GROUP BY 
    Category, Competitor_Pricing, Date, Demand_Forecast, 
    Discount, Holiday_Promotion, Inventory_Level, Price, 
    Product_ID, Region, Seasonality, Store_ID, Units_Ordered, 
    Units_Sold, Weather_Condition
HAVING COUNT(*) > 1;

-- Checking Partial Duplicate
SELECT 
    Date,
    Product_ID,
    Store_ID,
    COUNT(*) AS Duplicate_Count,
    MIN(Units_Sold) AS Min_Units,
    MAX(Units_Sold) AS Max_Units,
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price
FROM Retail_Store_Inventory
GROUP BY Date, Product_ID, Store_ID
HAVING COUNT(*) > 1;

--===============================================================================================================================

-- Outliers in Price
SELECT Product_ID, Store_ID, Date, Price
FROM Retail_Store_Inventory
WHERE Price < 0 OR Price > 1000;

-- Outliers in Units_Sold
SELECT Product_ID, Store_ID, Date, Units_Sold
FROM Retail_Store_Inventory
WHERE Units_Sold < 0 OR Units_Sold > 1000;

-- Outliers in Inventory
SELECT Product_ID, Store_ID, Date, Inventory_Level
FROM Retail_Store_Inventory
WHERE Inventory_Level < 0;

--===============================================================================================================================

-- Discount should be between 0 and 100
SELECT *
FROM Retail_Store_Inventory
WHERE Discount < 0 OR Discount > 100;

-- Units_Sold should not exceed Inventory_Level
SELECT *
FROM Retail_Store_Inventory
WHERE Units_Sold > Inventory_Level;

--===============================================================================================================================

-- If Holiday_Promotion = 1, check if the date is within known holiday months
-- (Example: Dec = Christmas, Nov = Black Friday)
SELECT Date, Holiday_Promotion
FROM Retail_Store_Inventory
WHERE Holiday_Promotion = 1
  AND MONTH(Date) NOT IN (11, 12);

-- check to include other holiday months
SELECT Date, Holiday_Promotion
FROM Retail_Store_Inventory
WHERE Holiday_Promotion = 1
  AND MONTH(Date) NOT IN (1, 2, 11, 12);

-- Summarize holiday promotions to see the pattern
SELECT YEAR(Date) AS Year, MONTH(Date) AS Month, COUNT(*) AS Promo_Days
FROM Retail_Store_Inventory
WHERE Holiday_Promotion = 1
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;

--===============================================================================================================================

SELECT * FROM Retail_Store_Inventory