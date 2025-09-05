# Retail Store Inventory Analysis

![SQL Badge](https://img.shields.io/badge/Tool-SQL-blue) 
![Excel Badge](https://img.shields.io/badge/Tool-Excel-green) 
[![Dataset Badge](https://img.shields.io/badge/Dataset-Retail_Inventory-orange)](https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset/data)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## Project Overview

This project analyzes inventory, sales, and forecast data across multiple retail stores to help managers make **data-driven decisions** regarding stock levels, promotions, and pricing. Using SQL for data analysis and Excel for visualization, the project aims to:

- Monitor inventory levels across stores and regions to prevent stockouts and overstocking  
- Identify fast-moving and slow-moving products to optimize stock allocation  
- Evaluate sales performance by product, category, store, and region  
- Measure forecast accuracy and highlight gaps between predicted and actual sales  
- Assess pricing, discount, and promotion effectiveness  
- Analyze external factors (seasonality, weather, competitor pricing) that impact demand

## Key Achievements
- Cleaned and validated 50k+ records in SQL for accuracy and completeness
- Built retail KPIs (sales, revenue, inventory turnover, forecast accuracy, stock alerts)
- Designed interactive Excel dashboards with regional, product, and sales insights
- Identified inefficiencies in promotions and forecast gaps (24% error vs. 10–20% benchmark)
- Delivered business recommendations to reduce stockouts, optimize pricing, and improve demand planning

## Important Note:
For full context, including project objectives, data preparation steps, and logic behind the analysis please refer to the [Full Project documentation](Documentation-%20Retail%20Store%20Inventory.md)

### Dashboard Preview
> [Final dashboard and reporting files](Retailers%20Store%20Dataset.xlsx)
<img width="920" height="376" alt="Screenshot 2025-09-04 203404" src="https://github.com/user-attachments/assets/e6dcb403-70af-4ba1-aa57-a9b2ef7e8951" />
<img width="916" height="376" alt="Screenshot 2025-09-04 203455" src="https://github.com/user-attachments/assets/a0fd9c61-fb65-470b-8cb8-837603d8e44c" />
<img width="919" height="375" alt="Screenshot 2025-09-04 203644" src="https://github.com/user-attachments/assets/197ea696-8332-4abf-9d71-322264a867de" />
<img width="914" height="374" alt="Screenshot 2025-09-04 203856" src="https://github.com/user-attachments/assets/cefe3378-d332-4053-8d27-92771d09e8c6" />

## Key Insights
- Inventory Turnover → Toys & Groceries move fastest, Electronics & Furniture slower → stock allocation can be optimized
- Forecast Accuracy → Error = 24.7%, highest in West region → needs improved regional modeling
- Promotions → Blanket discounts erode margin without boosting sales → recommend targeted promotions
- Regional Variations → East consistently strongest → tailor stock & pricing by region
- Seasonality → Minor seasonal effects, focus on product & region strategies

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
- **Logic:** Identify seasonal effects, growth anomalies, or missing data  
- Stable in 2022–2023; drop in 2024 (incomplete data)  

**Revenue by Product / Category**
- Toys, Furniture, Clothing, Electronics contribute most  
- Top products: P0014, P0015, P0016  

**Revenue by Region**
- **Logic:** Highlights regional strengths and informs stock allocation  
- East performs strongest; West slightly behind  

**Best/Worst Products**
- **Logic:** Prioritize high-performers and investigate low performers  
- Top 5: P0020, P0011, P0016, P0014, P0005  
- Bottom 5: P0012, P0002, P0008, P0003, P0017  

**YoY Growth**
- 2022–2023: slight growth for Clothing, Electronics, Furniture  
- 2024: -99% across categories → likely missing data  


### Inventory Health & Efficiency

**Inventory Turnover Ratio (ITR)**
- **Logic:** Identify products needing restocking vs. overstock  
- Fast movers: Toys & Groceries (ITR > 390)  
- Slow movers: Electronics & Furniture (~340)  

**Stock Alerts**
- **Logic:** Enables proactive reordering  
- Products < 270 units flagged  

**Regional Turnover**
- **Logic:** Detect regional demand variations  
- East & South slightly higher than North & West  

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
> Full [SQL Queries](Retail%20Store%20Inventory.sql)

## Conclusion
This project demonstrates how SQL and Excel can be combined to turn raw retail data into actionable business insights. By focusing on KPIs that matter — inventory turnover, forecast accuracy, and promotion effectiveness — I was able to simulate the type of analysis that directly supports retail decision-making.

## Let’s Connect

- [Read My Blog on Substack](https://substack.com/@theanalysisangle)
- [Twitter](https://x.com/Anastasia_Nmeso)  
- [FaceBook](https://www.facebook.com/share/16JoCo9x4F/)  
- [LinkedIn](www.linkedin.com/in/anastasia-nmesoma-947b20317)
