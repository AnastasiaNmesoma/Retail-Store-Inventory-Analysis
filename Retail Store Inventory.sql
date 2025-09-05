USE InventoryDB;

--===============================================================================================================================

-- A report showing all metrics of the business
SELECT 'Total Sales' AS Measure_Name, ROUND(SUM(Units_Sold * Price), 0) AS Measure_Value FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total Quantity sold', SUM(Units_Sold) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Avg selling price', ROUND(AVG(Price), 2) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total No. Orders', COUNT(Units_Ordered) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total No. Product', COUNT(DISTINCT Product_ID) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total No. Stores', COUNT(DISTINCT Store_ID) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total No. Region', COUNT(DISTINCT Region) FROM Retail_Store_Inventory
UNION ALL
SELECT 'Years', DATEDIFF(YEAR, MIN(Date), MAX(Date)) FROM Retail_Store_Inventory

--===============================================================================================================================
/*Sales & Revenue Performance*/

-- Monthly Sales & Revenue Trends
SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;



-- Revenue by Product
SELECT 
    Product_ID,
    Category,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY Product_ID, Category
ORDER BY Total_Revenue DESC;



-- Revenue by Region
SELECT 
    Region,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY Region
ORDER BY Total_Revenue DESC;



-- Top 5 Best-Selling Products
SELECT TOP 5 
    Product_ID,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue
    FROM Retail_Store_Inventory
GROUP BY Product_ID
ORDER BY Total_Revenue DESC;

-- Bottom 5 Worst-Selling Products
SELECT TOP 5 
    Product_ID,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY Product_ID
ORDER BY Total_Revenue ASC;



-- Year-over-Year Growth per Product Category
SELECT 
    Category,
    YEAR(Date) AS Year,
    ROUND(SUM(Units_Sold * Price),0) AS Total_Revenue,
    LAG(ROUND(SUM(Units_Sold * Price),0)) OVER (PARTITION BY Category ORDER BY YEAR(Date)) AS Prev_Year_Revenue,
    ( (ROUND(SUM(Units_Sold * Price),0) - 
        LAG(ROUND(SUM(Units_Sold * Price),0)) OVER (PARTITION BY Category ORDER BY YEAR(Date))
      ) * 100.0 
    / NULLIF(LAG(ROUND(SUM(Units_Sold * Price),0)) OVER (PARTITION BY Category ORDER BY YEAR(Date)),0) ) AS YoY_Growth_Percent
FROM Retail_Store_Inventory
GROUP BY Category, YEAR(Date)
ORDER BY Category, Year;

--===============================================================================================================================

/*Inventory Health & Efficiency*/

-- Inventory Turnover Ratio per Product
SELECT 
    Product_ID,
    Category,
    SUM(Units_Sold) AS Total_Units_Sold,
    AVG(Inventory_Level) AS Avg_Inventory,
    CASE 
        WHEN AVG(Inventory_Level) = 0 THEN NULL 
        ELSE ROUND(SUM(Units_Sold) * 1.0 / AVG(Inventory_Level), 2)
    END AS Inventory_Turnover_Ratio
FROM Retail_Store_Inventory
GROUP BY Product_ID, Category
ORDER BY Inventory_Turnover_Ratio DESC;



-- Rank Products by Sales Velocity
WITH ProductSales AS (
    SELECT 
        Product_ID,
        Category,
        SUM(Units_Sold) AS Total_Units_Sold
    FROM Retail_Store_Inventory
    GROUP BY Product_ID, Category
),
Ranked AS (
    SELECT 
        Product_ID,
        Category,
        Total_Units_Sold,
        NTILE(5) OVER (ORDER BY Total_Units_Sold DESC) AS Quintile
    FROM ProductSales
)
SELECT 
    Product_ID,
    Category,
    Total_Units_Sold,
    CASE 
        WHEN Quintile = 1 THEN 'Fast-Moving'
        WHEN Quintile = 5 THEN 'Slow-Moving'
        ELSE 'Medium'
    END AS Movement_Category
FROM Ranked
ORDER BY Total_Units_Sold DESC;



-- Flag Low Stock Levels
SELECT 
    Date,
    Product_ID,
    Region,
    Inventory_Level,
    CASE 
        WHEN Inventory_Level < 270 THEN 'Low Stock'
        ELSE 'OK'
    END AS Stock_Status
FROM Retail_Store_Inventory
ORDER BY Date, Product_ID;



-- Inventory Turnover by Region
SELECT 
    Region,
    SUM(Units_Sold) AS Total_Units_Sold,
    AVG(Inventory_Level) AS Avg_Inventory,
    CASE 
        WHEN AVG(Inventory_Level) = 0 THEN NULL
        ELSE ROUND(SUM(Units_Sold) * 1.0 / AVG(Inventory_Level), 2)
    END AS Inventory_Turnover_Ratio
FROM Retail_Store_Inventory
GROUP BY Region
ORDER BY Inventory_Turnover_Ratio DESC;

--===============================================================================================================================

/*Forecast Accuracy*/

-- under-forecasting (positive error) or over-forecasting (negative error).

-- Forecast Error?
SELECT
    Date,
    Product_ID,
    Region,
    Units_Sold AS Actual,
    Demand_Forecast AS Forecast,
    (ROUND(Units_Sold -Demand_Forecast, 2)) AS Forecast_Error
FROM Retail_Store_Inventory



-- Percentage Error
SELECT
    Date,
    Product_ID,
    Region,
    Units_Sold AS Actual,
    ROUND(Demand_Forecast, 2) AS Forecast,
    ROUND((Units_Sold - Demand_Forecast), 2) AS Forecast_Error,
    ROUND(
        CASE 
            WHEN Units_Sold = 0 THEN NULL 
            ELSE ((Units_Sold - Demand_Forecast) * 1.0 / Units_Sold) * 100 
        END,
    2) AS Percentage_Error
FROM Retail_Store_Inventory;



-- MAPE at Product Level (Mean Absolute Percentage Error)
SELECT
    Product_ID,
    ROUND(
        AVG(CASE 
                WHEN Units_Sold = 0 THEN NULL
                ELSE (ABS(Units_Sold - Demand_Forecast) * 1.0 / Units_Sold) * 100
            END),
    2)AS MAPE_Product
FROM Retail_Store_Inventory
GROUP BY Product_ID
ORDER BY MAPE_Product DESC; -- highest error first



-- MAPE at Region Level (Mean Absolute Percentage Error)
SELECT
    Region,
    ROUND(
        AVG(CASE 
                WHEN Units_Sold = 0 THEN NULL
                ELSE (ABS(Units_Sold - Demand_Forecast) * 1.0 / Units_Sold) * 100
            END),
    2) AS MAPE_Region
FROM Retail_Store_Inventory
GROUP BY Region
ORDER BY MAPE_Region DESC;



-- Overall MAPE (Mean Absolute Percentage Error)
SELECT
    ROUND(
        AVG(CASE 
                WHEN Units_Sold = 0 THEN NULL
                ELSE (ABS(Units_Sold - Demand_Forecast) * 1.0 / Units_Sold) * 100
            END), 
        2) AS MAPE_Overall
FROM Retail_Store_Inventory;

--===============================================================================================================================

/*Pricing & Promotions Effectiveness*/

-- Sales with vs. without Holiday Promotion
SELECT 
    Holiday_Promotion,
    ROUND(SUM(Units_Sold),0) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price),0) AS Revenue,
    ROUND(AVG(Discount),0) AS Avg_Discount
FROM Retail_Store_Inventory
GROUP BY Holiday_Promotion;



-- Did being cheaper or more expensive affect sales?
SELECT 
    CASE 
        WHEN Price < Competitor_Pricing THEN 'Undercut Competitor'
        WHEN Price > Competitor_Pricing THEN 'Over Competitor'
        ELSE 'Same as Competitor'
    END AS Pricing_Position,
    AVG(Units_Sold) AS Avg_Units_Sold,
    ROUND(AVG(Revenue),0) AS Avg_Revenue
FROM (
    SELECT *,
           Units_Sold * Price AS Revenue
    FROM Retail_Store_Inventory
) t
GROUP BY 
    CASE 
        WHEN Price < Competitor_Pricing THEN 'Undercut Competitor'
        WHEN Price > Competitor_Pricing THEN 'Over Competitor'
        ELSE 'Same as Competitor'
    END;



-- Correlation: Discount % vs Units Sold
SELECT 
    Discount,
    AVG(Units_Sold) AS Avg_Units_Sold
FROM Retail_Store_Inventory
GROUP BY Discount
ORDER BY Discount;



-- Simplified margin effect
SELECT 
    Holiday_Promotion,
    ROUND(SUM(Units_Sold * (Price - (Price * Discount/100))),0) AS Net_Revenue_After_Discount,
    ROUND(SUM(Units_Sold * Price),0) AS Gross_Revenue_No_Discount
FROM Retail_Store_Inventory
GROUP BY Holiday_Promotion;

--===============================================================================================================================

/*External & Seasonal Factors*/

-- Sales by Seasonality
SELECT 
    Seasonality,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price * (1 - Discount/100.0)),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY Seasonality
ORDER BY Total_Revenue DESC;



-- Sales by Weather Condition
SELECT 
    Weather_Condition,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price * (1 - Discount/100.0)),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY Weather_Condition
ORDER BY Total_Revenue DESC;



-- Seasonal Peaks (Quarterly Trends)
SELECT 
    DATEPART(YEAR, Date) AS Year,
    DATEPART(QUARTER, Date) AS Quarter,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price * (1 - Discount/100.0)),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY DATEPART(YEAR, Date), DATEPART(QUARTER, Date)
ORDER BY Year, Quarter;

-- Seasonal Peaks (Monthly Trends)
SELECT 
    DATEPART(YEAR, Date) AS Year,
    DATEPART(MONTH, Date) AS Month,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Units_Sold * Price * (1 - Discount/100.0)),0) AS Total_Revenue
FROM Retail_Store_Inventory
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY Year, Month;



--Top 5 worst forecasted products.
SELECT TOP 5
    Product_ID,
    ROUND(
        AVG(CASE 
                WHEN Units_Sold = 0 THEN NULL
                ELSE (ABS(Units_Sold - Demand_Forecast) * 1.0 / Units_Sold) * 100
            END),
    2) AS MAPE
FROM Retail_Store_Inventory
GROUP BY Product_ID
ORDER BY MAPE DESC;

--===============================================================================================================================
SELECT * FROM Retail_Store_Inventory