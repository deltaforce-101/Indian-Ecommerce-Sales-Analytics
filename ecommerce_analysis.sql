-- Indian E-commerce Sales & Customer Analytics
-- Database: ecommerce_analytics

USE ecommerce_analytics;

-- 1. Check tables
SHOW TABLES;

-- 2. Count customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 3. Count products
SELECT COUNT(*) AS total_products
FROM products;

-- 4. Count sales records
SELECT COUNT(*) AS total_sales
FROM sales;

-- 5. View sample customer records
SELECT * FROM customers
LIMIT 10;

-- 6. View sample product records
SELECT * FROM products
LIMIT 10;

-- 7. View sample sales records
SELECT * FROM sales
LIMIT 10;

-- 8. Total revenue, orders, average order value, customers
SELECT
    ROUND(SUM(Sales_Amount_INR), 2) AS total_revenue,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(AVG(Sales_Amount_INR), 2) AS average_order_value,
    COUNT(DISTINCT Customer_ID) AS customers_who_ordered
FROM sales;


-- 9. Monthly revenue
SELECT
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%Y-%m-%d'), '%Y-%m'
    ) AS order_month,
    ROUND(SUM(Sales_Amount_INR), 2) AS monthly_revenue
FROM sales
GROUP BY order_month
ORDER BY order_month;


-- 10. Revenue by product category
SELECT
    p.Category,
    ROUND(SUM(s.Sales_Amount_INR), 2) AS total_revenue
FROM sales s
INNER JOIN products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY total_revenue DESC;


-- 11. Revenue by state
SELECT
    c.State,
    ROUND(SUM(s.Sales_Amount_INR), 2) AS total_revenue
FROM sales s
INNER JOIN customers c
    ON s.Customer_ID = c.Customer_ID
GROUP BY c.State
ORDER BY total_revenue DESC;


-- 12. Revenue by payment method
SELECT
    Payment_Method,
    ROUND(SUM(Sales_Amount_INR), 2) AS total_revenue
FROM sales
GROUP BY Payment_Method
ORDER BY total_revenue DESC;


-- 13. Orders by status
SELECT
    Order_Status,
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales_Amount_INR), 2) AS total_revenue
FROM sales
GROUP BY Order_Status
ORDER BY total_revenue DESC;


-- 14. Top 10 best-selling products
SELECT
    p.Product_Name,
    SUM(s.Quantity) AS total_quantity_sold
FROM sales s
INNER JOIN products p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- 15. Top 10 customers by spending
SELECT
    c.Customer_ID,
    c.Customer_Name,
    ROUND(SUM(s.Sales_Amount_INR), 2) AS total_spent
FROM sales s
INNER JOIN customers c
    ON s.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY total_spent DESC
LIMIT 10;

-- 16. Find duplicate customer IDs
SELECT Customer_ID, COUNT(*) AS total_count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- 17. Check missing values in sales
SELECT
    SUM(Order_ID IS NULL) AS missing_order_id,
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Product_ID IS NULL) AS missing_product_id,
    SUM(Sales_Amount_INR IS NULL) AS missing_sales_amount
FROM sales;


-- 18. Order status percentages
SELECT
    Order_Status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales),
        2
    ) AS order_percentage
FROM sales
GROUP BY Order_Status
ORDER BY order_percentage DESC;


-- 19. Total quantity sold by product
SELECT
    Product_ID,
    SUM(Quantity) AS total_quantity_sold
FROM sales
GROUP BY Product_ID
ORDER BY total_quantity_sold DESC;s