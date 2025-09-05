## **Documentation: Retail Store Inventory**

**Tool:** SQL & Excel  
**Dataset:** [Retail Store Inventory](https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset/data)

### **Project Objective**

The objective of this project is to design a Stock & Inventory Management Analysis system that helps retail managers make data-driven decisions about inventory, pricing, and promotions. Using SQL for data analysis and Excel for reporting and visualization, the project aims to:

* Track and monitor inventory levels across stores and regions to prevent stockouts and overstocking.  
* Identify fast-moving and slow-moving products to optimize stock allocation.  
* Evaluate sales performance by product, category, store, and region.  
* Measure demand forecast accuracy and highlight gaps between actual sales and predictions.  
* Assess the effectiveness of pricing, discounts, and promotions in driving sales.  
* Analyze external factors such as weather, seasonality, and competitor pricing that impact demand.

### **Data Source and import**

This dataset was imported into SQL using the Flat Import method. It contains over 70,000 records, including fields such as Date, Store\_ID, Product\_ID, Category, Region, Inventory\_Level, Units\_Sold, Units\_Ordered, Demand\_Forecast, Price, Discount, Weather\_Condition, Holiday\_Promotion, Competitor\_Pricing, Seasonality.

### **EDA and Data Cleaning (SQL)**

#### **Missing Values**

* No missing values were found across all columns

**Logic:** Completeness of data ensures that subsequent analysis will not be biased by gaps in reporting.

#### **Outlier Detection**

* **Price:** All product prices fall within a valid range (0–1000).  
* **Units\_Sold:** No values below zero or unreasonably high counts (above 1000).  
* **Inventory\_Level:** No negative inventory values were observed.

**Logic:** This indicates that transactional and inventory data are consistent with business expectations.

#### **Business Logic Checks**

* **Discount:** All discount values lie within the logical range of 0–100%.  
* **Units Sold vs. Inventory:** No cases where Units\_Sold exceeded Inventory\_Level, meaning stock levels align with recorded sales.

#### **Checked for full row duplicate:** Verified that no two rows in the dataset were completely identical across all columns.

* Full row duplicates would artificially inflate business metrics such as total sales and inventory levels.

#### **Checked for partial duplicates:** Verified that there were no repeated records based on key identifiers (Date \+ Store\_ID \+ Product\_ID), which should uniquely represent one product sold in one store on a given day.

* Partial duplicates would suggest data entry or system errors (e.g., the same product being logged twice for the same store and date).

**Logic:** Ensuring the absence of duplicates gives confidence that further analysis (e.g., sales trends, forecast accuracy, inventory health) will be based on **accurate, reliable data**.

#### **Holiday Promotion Flag**

* The Holiday\_Promotion flag is present across all months, not just holiday periods (Nov–Dec, Jan–Feb).  
* This suggests that the field represents general promotional activity (e.g., seasonal discounts, weekend offers) rather than strictly holiday-based campaigns.

**Logic:** For analysis, this flag will be treated as a general promotion indicator rather than a holiday-only variable.

**Overall Data Quality Assessment**  
No missing values, duplicates, or unreasonable outliers were detected, and all key business rules (discount limits, stock vs. sales alignment) were satisfied.   
The only adjustment is interpretive: the ‘Holiday\_Promotion; field should be considered as a general promotion indicator rather than strictly tied to holiday events. Overall, the dataset is deemed reliable and fit for accurate business analysis.

### **A report showing all business metrics**

* **Total Sales:** 550,228,885  
* **Total Quantity Sold:** 9,975,582  
* **Avg Selling Price:** 55.14  
* **Total Orders:** 73,100  
* **Unique Products:** 20  
* **Stores:** 5  
* **Regions:** 4  
* **Years:** 2

### **Sales & Revenue Analysis**

#### **Monthly Sales & Revenue Trends**

Aggregated total units sold and revenue per month across 2022–2024.

* Logic: This helps track seasonality, growth trends, and anomalies in sales volume and revenue.  
* Key Findings:  
- Sales and revenue were relatively stable in 2022 and 2023\.  
- A sharp decline is visible in 2024 (only January data available so far), which might indicate incomplete data or missing records.

#### **Revenue by Product**

Summarized revenue contribution by product ID and category.

* Logic: Identifies which products and categories are the highest revenue drivers.  
* Key Findings:  
- Toys, Furniture, Clothing, and Electronics contributed almost equally to overall revenue.  
- Products P0014, P0016, and P0015 were consistently top performers.

#### **Revenue by Region**

Calculated total revenue by region (East, South, North, West).

* Logic: Regional performance highlights geographical strengths and weaknesses.  
* Key Findings:  
- Revenue was almost evenly distributed across all regions.  
- The East region generated the highest sales, while the West region lagged slightly behind.

#### **Best & Worst Performing Products**

Ranked products by total units sold and revenue.

* Logic: Helps identify “star” products (high performers) and “laggards” (low performers).  
* Key Findings:  
- Top 5 Products: P0020, P0011, P0016, P0014, and P0005.  
- Bottom 5 Products: P0012, P0002, P0008, P0003, and P0017.

#### **Year-over-Year Growth per Product Category**

Measured annual revenue by category and calculated YoY growth.

* Logic: Tracks category performance over time and highlights growth or decline.  
* Key Findings:  
- Between 2022–2023, Clothing, Electronics, and Furniture saw slight growth; Groceries and Toys saw a decline.  
- 2024 shows massive drops (-99%) across all categories, strongly suggesting missing/incomplete data rather than actual business decline.

### **Inventory Health & Efficiency**

#### **Inventory Turnover Ratio (ITR)**

* Logic: Calculated as Units Sold ÷ Avg Inventory for each product.  
* Findings:  
- Most products have high turnover (in the 300–390 range).  
- Toys (P0014, P0020) and Groceries (P0016) top the list with fast movement (ITR \> 390).  
- Electronics (P0019, P0009) show slower turnover at the bottom end (\~340).

Insight: High ITR indicates products that sell quickly but may risk frequent stockouts. Lower ITR items could be overstocked.

#### **Fast vs. Slow Movers**

* Logic: Used quintile ranking (top 20% \= Fast-Moving, bottom 20% \= Slow-Moving).  
* Findings:  
- Fast-movers include toys, groceries, and some electronics.  
- Slow-movers are concentrated in electronics, furniture, and clothing.

Insight: Business can prioritize replenishment cycles for fast-movers and review demand forecasting for slow-movers.

#### **Low Stock Alerts**

* Logic: Compared current inventory levels against the average stock threshold (270 units).  
* Findings:  
- Products below 270 units flagged as Low Stock.  
- This allows proactive reordering before stockouts occur.

Insight: Setting dynamic safety thresholds (per category/region) may refine accuracy.

#### **Regional Inventory Efficiency**

* Logic: Aggregated turnover ratio by region.  
* Findings:  
- East & South regions lead with 9,130 ITR.  
- North & West slightly lower but still healthy (9,070).

Insight: No critical red flags, but differences suggest regional demand variations worth monitoring.

### **Forecast Accuracy**

#### **Forecast Error & MAPE**

* Logic: Calculated Forecast Error as (Units\_Sold – Demand\_Forecast) and Absolute Percentage Error (APE) as ABS(Error) ÷ Units\_Sold × 100\.

Mean Absolute Percentage Error (MAPE) was then averaged across all products, regions, and overall.

* Findings:  
- Overall MAPE \= 24.72%.  
- Interpretation: Forecasts deviate by 25% from actual sales on average.  
- Benchmark: Retail forecasts typically aim for 10–20% MAPE. Current accuracy is below ideal standards.

#### **Product-Level Forecast Accuracy**

* Logic: Calculated MAPE per product to identify which items had the most accurate vs. least accurate forecasts.  
* Findings:  
- Highest Error: P0008 (27.49%), P0015 (26.98%), P0003 (26.88%).  
- Lowest Error: P0016 (21.50%), P0018 (22.42%), P0006 (22.78%).  
* Volatile products (e.g., P0008) may be influenced by seasonality, promotions, or competitor pricing.

Products with higher error should be prioritized for improved forecasting models.

#### **Regional Forecast Accuracy**

* Logic: Grouped results by region to measure how forecasts perform geographically.  
* Findings:  
- West \= 25.25% (highest error, weakest performance).  
- South \= 24.36% (lowest error, best performance).  
- North and East are mid-range (24.6%).

Insight: Regional demand patterns are not uniform; the West region may require customized forecasting adjustments.

#### **Overall Insight**

* Logic: Combined all findings to evaluate forecast performance across products and regions.

Findings:

* Forecasts are systematically off by 25%, indicating room for model improvement.  
* Certain products and regions contribute disproportionately to error.

Enhancing forecast accuracy (by 5–10%) could reduce stockouts and overstock costs significantly.

### **Pricing & Promotions Effectiveness**

#### **Sales During Promotions vs. Non-Promotions**

* Logic: Compared units sold and revenue between periods with promotions (Holiday\_Promotion \= 1\) vs. without (Holiday\_Promotion \= 0).  
* Findings:  
- Units Sold were nearly the same: 5.0M with promo vs. 5.02M without promo.  
- Revenue was also nearly identical: $273.8M with promo vs. $276.5M without promo.  
- Average discount rate stayed constant at 10% in both cases.

Insight: Promotions did not significantly increase sales volume or revenue, suggesting discounts may be reducing Profit without driving meaningful uplift.

#### **Price Competitiveness vs. Sales**

* Logic: Classified pricing position relative to competitors (Price vs. Competitor\_Pricing).   
* Findings:Sales were almost the same regardless of position:  
- Same as Competitor → 137 units avg  
- Undercut Competitor → 136 units avg  
- Over Competitor → 136 units avg  
* Revenue followed a very similar pattern.

Insight: Pricing relative to competitors had minimal effect on sales performance, indicating customers may not be highly price-sensitive (possibly loyal, or other factors like brand/promo drive sales more).

#### **Discount vs. Units Sold (Elasticity)**

* Logic: Analyzed average units sold at different discount levels.  
* Findings:  
- Across discount levels (0%, 5%, 10%, 15%, 20%), units sold remained constant at \~135–136 units.  
- No strong correlation between higher discounts and higher sales was observed.

Insight: This suggests low price elasticity – cutting prices further is not materially increasing demand.

#### **Margin Impact of Promotions**

* Logic: Compared gross revenue (no discount) vs. net revenue after discount for promo vs. non-promo periods.  
* Findings:  
- Non-promo net revenue: $248.7M vs. gross potential $276.5M.  
- Promo net revenue: $246.2M vs. gross potential $273.8M.  
- Both promo and non-promo periods lose margin due to discounts (10%).

Insight: Promotions do not improve sales, but they erode Profit. Business could reconsider blanket discounting and instead target promotions more strategically (e.g., seasonal spikes, slow-moving products).

### **Connecting Promotions, Pricing & Forecast Accuracy**

#### **Context**

Forecast accuracy was measured earlier using MAPE:

* Product-level errors ranged 21%–27%.  
* At the date-level, the highest error was only \~20%, meaning forecasts were relatively stable.

Now, with the pricing & promotions analysis:

* Sales volumes barely changed across promotions, competitor pricing positions, and discounts.  
* Demand remained flat regardless of price changes or promotions.

#### **Integrated Insight**

* Stable demand despite pricing shifts explains why forecast errors were moderate but consistent:  
  * If demand doesn’t respond strongly to discounts/promotions, then simple forecasts (based on historical averages or seasonality) will already be quite accurate.  
  * The 21–27% product-level MAPE is likely driven by other factors (e.g., seasonality, competitor campaigns, or external shocks like weather) rather than the pricing strategy.  
* Low price elasticity also means forecasting models don’t need to weigh pricing variables heavily, since sales volumes are not materially impacted by discounts or competitor prices.  
* However, for certain volatile products (e.g., P0008 with \~27.5% error), the issue is less about price and more likely tied to seasonal demand or external events.

### **Business Takeaway**

* Forecasting models can be simplified: focus more on seasonality, regional demand patterns, and promotions timing, not raw discounts.  
* Blanket promotions erode profit without lifting sales → should be restructured to target slow-moving items instead of being applied across the board.  
* Aligning inventory planning \+ pricing strategy can reduce waste:  
- No need to overstock for promos (since sales don’t spike).  
- Inventory allocation should focus on products and regions that actually show demand volatility.

### **External & Seasonal Factors**

#### **Sales by Seasonality**

* Logic: Grouped sales by the Seasonality column to see how different seasons affect demand.  
* Findings:  
- Winter (2.50M units, $124.36M revenue) slightly edges out other seasons.  
- Sales are fairly balanced across seasons, with \<3% variation in both units and revenue.

This suggests products are not heavily seasonal, though winter has a small uplift.

#### **Sales by Weather Condition**

* Logic: Compared total units sold and revenue under different Weather\_Condition values.  
* Findings:  
- Sunny weather drives the highest sales (2.52M units, $125.11M revenue).  
- Snowy weather shows the weakest sales (2.48M units, $122.17M revenue).  
- Weather has an impact, but the difference is modest (\~2–3%).

Suggests weather influences shopping patterns (sunny days encourage more purchases), but doesn’t radically shift demand.

#### **Quarterly & Monthly Seasonal Peaks**

* Logic: Aggregated sales by quarter and month (DATEPART) to identify peaks and dips.  
* Findings:  
- **Quarterly:** Sales are remarkably consistent across quarters, averaging 1.23M–1.26M units per quarter.  
- **Monthly:**  
- Stronger months: March (426K+ units, $21.5M), July (438K units, $21.3M), October (426K units, $21.1M).  
- Weaker months: February (385K units, $19.2M).  
* Clear pattern: slight dips in February (post-holiday slowdown) and small surges in mid-year and pre-holiday periods.

#### **Forecast Accuracy by Product (Worst 5\)**

* Logic: Ranked products by MAPE (Mean Absolute Percentage Error) to see which are hardest to predict.  
* Findings:  
- Highest errors: P0008 (27.49%), P0015 (26.98%), P0003 (26.88%).  
- These products show more volatility (possibly promotion-driven, seasonal, or price-sensitive).  
- Products like P0016 (\~21.5%) had lower errors, meaning demand was more stable and easier to forecast.

### **Executive Takeaways**

* Seasonality: Demand is relatively balanced year-round, but winter and certain months (March, July, October) bring modest uplifts.  
* Weather: Sunny conditions improve sales slightly, but weather is not a major driver.  
* Forecasting Challenge: A few products (P0008, P0015, P0003) are hard to forecast accurately and should be reviewed for promotional or seasonal effects.