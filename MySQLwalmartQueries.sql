
USE walmart_db;

## Q1: Different payment method, and how many tansactions and items were sold with each method??

SELECT payment_method,
COUNT(payment_method),
SUM(quantity)
FROM walmart_db
GROUP BY payment_method;

## Q2: Which category received the highest average ratings in each branch??

WITH CTE as
(SELECT branch,
category,
AVG(rating),
RANK() OVER(partition by branch ORDER BY AVG(rating) DESC) AS Rank_rating
FROM walmart_db
GROUP BY branch, category
ORDER BY branch)
SELECT * FROM CTE
WHERE Rank_rating = 1; 

## Q3: Busiest day of the week for each branch based on transaction volume?

WITH cte AS(
SELECT branch,
DAYNAME(date) AS day,
COUNT(*) AS No_of_tansactions,
RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_over_trans
FROM walmart_db
GROUP BY branch, DAYNAME(date)
ORDER BY branch, DAYNAME(date))
SELECT * FROM cte
WHERE rank_over_trans = 1;

## Q4: How many items were sold through each payment method?

SELECT SUM(quantity),
payment_method
FROM walmart_db
GROUP BY payment_method;

SELECT * FROM walmart_db LIMIT 10;

## Q5: What are the average, minimum, and maximum ratings for each category in each city?

SELECT AVG(rating),
MAX(rating),
MIN(rating),
category,
city
FROM walmart_db
GROUP BY city,category;

## Q6: What is the total profit of each category, ranked from highest to lowest

SELECT category, 
SUM(quantity*profit_margin) AS total_profit,
RANK() OVER(ORDER BY SUM(quantity*profit_margin) DESC)
FROM walmart_db
GROUP BY category;

## Q7: Most frequently used payment method in each branch

WITH cte AS(
SELECT branch,
payment_method,
COUNT(*) AS No_of_trans,
RANK() OVER(partition by branch ORDER BY COUNT(*) DESC) AS rank_over_trans
FROM walmart_db
GROUP BY branch, payment_method)
SELECT *
FROM cte
WHERE rank_over_trans = 1;

## Q8: How many transaction occur in each shift across branches?

WITH cte AS(
SELECT branch,
payment_method,
time,
CASE
    WHEN time BETWEEN '00:00:00' AND '07:59:59'
    THEN 'Morning Shift'
    WHEN time BETWEEN '08:00:00' AND '15:59:59'
    THEN 'Evening Shift'
    ELSE 'Night Shift'
END AS Shifts
FROM walmart_db)
SELECT COUNT(Shifts)
Shifts
FROM cte
GROUP BY Shifts;

