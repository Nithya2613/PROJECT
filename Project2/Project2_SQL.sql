CREATE DATABASE retail_project;
USE retail_project;
CREATE TABLE superstore (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(20),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(150),
    Sales FLOAT,
    Quantity INT,
    Discount FLOAT,
    Profit FLOAT
);
-- Check how many nulls per column
SELECT 
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS null_Order_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_Order_Date,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_Profit
FROM superstore;

-- Remove records where essential values are missing
DELETE FROM superstore WHERE Order_ID IS NULL OR Order_Date IS NULL OR Sales IS NULL OR Profit IS NULL;

-- Optional: Remove duplicates
DELETE FROM superstore WHERE Order_ID IS NULL OR TRIM(Order_ID) = '';

#1. PROFIT BY CATEGORY
SELECT 
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Percent
FROM superstore GROUP BY Category ORDER BY Profit_Margin_Percent ASC;

#2. PROFIT BY SUB-CATEGORY
SELECT 
    Category,
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Percent
FROM superstore GROUP BY Category, Sub_Category ORDER BY Profit_Margin_Percent ASC;

#3. PROFIT BY REGION
SELECT 
    Region,
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Percent
FROM superstore GROUP BY Region, Category ORDER BY Region, Profit_Margin_Percent ASC;

#4. TOP & BOTTOM PERFORMING PRODUCTS
SELECT 
    Product_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore GROUP BY Product_Name ORDER BY Total_Profit DESC LIMIT 10;  -- Top 10 profitable products

SELECT 
    Product_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore GROUP BY Product_Name ORDER BY Total_Profit ASC LIMIT 10;  

#5. MONTHLY SALES TREND FOR SEASONAL PATTERN
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM superstore GROUP BY Month ORDER BY Month;

#6. REGION-WISE PERFORMANCE COMPARISON
SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin
FROM superstore GROUP BY Region ORDER BY Profit_Margin;

#7. SEGMENT-WISE ANALYSIS
SELECT 
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM superstore GROUP BY Segment;

#8. DISCOUNT IMPACT ON PROFITABILITY
SELECT 
    ROUND(Discount, 2) AS Discount_Rate,
    COUNT(*) AS Transactions,
    ROUND(AVG(Profit), 2) AS Avg_Profit
FROM superstore GROUP BY Discount_Rate ORDER BY Discount_Rate;

#9. SHIPPING MODE EFFICIENCY
SELECT 
    Ship_Mode,
    COUNT(*) AS Orders,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 1) AS Avg_Delivery_Days
FROM superstore GROUP BY Ship_Mode;