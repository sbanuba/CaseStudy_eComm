-- Project: Marketing Intelligence Analyst- Case Study
-- Part 2: E-Commerce Data Analysis. SQL Queries for eComms data set: 
-- Author: Solomon Banuba
-- Review: 
-- Date: 24-07-2024

--  Tasks:
       -- Visualize the Quantity of Orders between 2015 and 2018 in Switzerland per day.
       -- Compute the daily Conversion-Rate between 2015 and 2018 in Switzerland. Visualize the daily Conversion-Rate. 
       -- Decompose the Conversion- Rate and the Order Qty and show the Trend of both variables visually. 
       -- a) What recommendations would you make to the Swiss marketing team?
       -- b) What recommendations would you make to the operational team of the Website?


-- Report: 


-- Total Orders
SELECT 
  SUM(Qty_Orders)
FROM `eCom.orders`;

-- Total Visits
SELECT 
 SUM(Qty_Visits)
FROM `eCom.visits`;

-- Visualize the Quantity of Orders between 2015 and 2018 in Switzerland per day.

SELECT 
   EXTRACT(DAY FROM PARSE_DATE('%d.%m.%Y', date)) AS day
   , SUM(Qty_Orders) AS Total_Qty_Orders
FROM `eCom.orders`
GROUP BY day;


-- Compute the daily conversion rate between 2015 and 2018 in Switzerland. Could you visualize the daily conversion rate? 

WITH visits AS (-- Getting the total daily visits 
  SELECT 
     PARSE_DATE('%d.%m.%Y', date) AS Date -- convert date to bigquery format
      , SUM(Qty_Visits) AS Total_Qty_Visits
  FROM `eCom.visits` v
  GROUP BY Date
)

, orders AS (-- Getting the total daily orders
  SELECT 
    PARSE_DATE('%d.%m.%Y', date) AS Date -- convert date to bigquery format
     , SUM(Qty_Orders) AS Total_Qty_Orders
  FROM `eCom.orders` o
  GROUP BY Date
)

SELECT 
  o.Date
    , v.Total_Qty_Visits
    , o.Total_Qty_Orders
    , ROUND((o.Total_Qty_Orders / v.Total_Qty_Visits) * 100, 2) AS conversion_rate
FROM visits v
INNER JOIN orders o ON v.Date = o.Date
ORDER BY o.Date;
