# Retail Store Inventory Analysis

![SQL Badge](https://img.shields.io/badge/Tool-SQL-blue) 
![Excel Badge](https://img.shields.io/badge/Tool-Excel-green) 
![Dataset Badge](https://img.shields.io/badge/Dataset-Retail_Inventory-orange)

## Project Overview

This project analyzes inventory, sales, and forecast data across multiple retail stores to help managers make **data-driven decisions** regarding stock levels, promotions, and pricing. Using SQL for data analysis and Excel for visualization, the project aims to:

- Monitor inventory levels across stores and regions to prevent stockouts and overstocking  
- Identify fast-moving and slow-moving products to optimize stock allocation  
- Evaluate sales performance by product, category, store, and region  
- Measure forecast accuracy and highlight gaps between predicted and actual sales  
- Assess pricing, discount, and promotion effectiveness  
- Analyze external factors (seasonality, weather, competitor pricing) that impact demand  


## Data Source & Import

The dataset was imported into SQL using the **Flat Import method** and includes fields such as:

- Date, Store_ID, Product_ID, Category, Region  
- Inventory_Level, Units_Sold, Units_Ordered, Demand_Forecast  
- Price, Discount, Weather_Condition, Holiday_Promotion, Competitor_Pricing, Seasonality  

## Data Cleaning & Logic

### Missing Values
- **Observation:** No missing values were found.  
- **Logic:** Completeness ensures analysis and metrics are reliable.  

### Outliers
- **Price:** 0–1000, consistent with business expectations  
- **Units Sold / Inventory:** No negatives or implausible values  
- **Logic:** Confirms transactional data is consistent and usable  

### Duplicates
- Verified **full-row duplicates** and **partial duplicates** (Date + Store_ID + Product_ID)  
- **Logic:** Ensures unique transaction records to prevent inflated metrics  

### Holiday Promotion Flag
- Found across all months, not just holidays  
- **Logic:** Treated as a general promotion indicator for analysis  

**Overall Quality Assessment:** The dataset is clean, reliable, and fit for analysis.  


## Analysis & Findings

### Sales & Revenue

**Monthly Trends**
- Stable in 2022–2023; drop in 2024 (incomplete data)  
- **Logic:** Identify seasonal effects, growth anomalies, or missing data  

**Revenue by Product / Category**
- Toys, Furniture, Clothing, Electronics contribute most  
- Top products: P0014, P0015, P0016  

**Revenue by Region**
- East performs strongest; West slightly behind  
- **Logic:** Highlights regional strengths and informs stock allocation  

**Best/Worst Products**
- Top 5: P0020, P0011, P0016, P0014, P0005  
- Bottom 5: P0012, P0002, P0008, P0003, P0017  
- **Logic:** Prioritize high-performers and investigate low performers  

**YoY Growth**
- 2022–2023: slight growth for Clothing, Electronics, Furniture  
- 2024: -99% across categories → likely missing data  


### Inventory Health & Efficiency

**Inventory Turnover Ratio (ITR)**
- Fast movers: Toys & Groceries (ITR > 390)  
- Slow movers: Electronics & Furniture (~340)  
- **Logic:** Identify products needing restocking vs. overstock  

**Stock Alerts**
- Products < 270 units flagged  
- **Logic:** Enables proactive reordering  

**Regional Turnover**
- East & South slightly higher than North & West  
- **Logic:** Detect regional demand variations  


### Forecast Accuracy

- Overall MAPE = 24.72% → below ideal retail benchmarks (10–20%)  
- Product-level MAPE: highest for P0008, P0015, P0003  
- Regional MAPE: highest error in West (25.25%), lowest in South (24.36%)  
- **Logic:** Forecasts can be improved by focusing on volatile products and region-specific trends  


### Pricing & Promotions

**Promotion Effectiveness**
- Units sold & revenue nearly identical with/without promotions  
- **Insight:** Blanket promotions reduce margin without increasing sales  

**Price vs. Competitor**
- Sales insensitive to price position → low price elasticity  

**Discount Impact**
- No strong correlation between higher discount and higher units sold  
- **Logic:** Discounts should be strategically targeted  

**Margin Impact**
- Promo periods reduce net revenue → avoid blanket discounting  


### External & Seasonal Factors

- Sales relatively balanced across seasons; winter slightly higher  
- Weather influence modest (~2–3% variation)  
- Monthly peaks: March, July, October; trough: February  
- **Logic:** Minor external effects; focus remains on products & regions  


## Key Insights & Business Takeaways

1. Forecasting can be simplified by focusing on seasonality, regional patterns, and key promotions rather than raw discounting  
2. Blanket promotions erode profit → target slow movers or seasonal spikes  
3. High-turnover products require continuous monitoring to avoid stockouts  
4. Regional variations suggest tailored inventory allocation  


## Sample SQL Queries

```sql
-- Total Sales & Orders
SELECT 'Total Sales' AS Measure, ROUND(SUM(Units_Sold * Price), 0) AS Value FROM Retail_Store_Inventory
UNION ALL
SELECT 'Total Orders', COUNT(Units_Ordered) FROM Retail_Store_Inventory;

-- Inventory Turnover per Product
SELECT Product_ID, SUM(Units_Sold)/AVG(Inventory_Level) AS ITR
FROM Retail_Store_Inventory
GROUP BY Product_ID;

-- Forecast Accuracy (MAPE per Product)
SELECT Product_ID, AVG(ABS(Units_Sold - Demand_Forecast)/Units_Sold*100) AS MAPE
FROM Retail_Store_Inventory
GROUP BY Product_ID;
```
> Full SQL Queries 
