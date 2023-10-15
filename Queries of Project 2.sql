/*Case Study: E-Commerce Product Analysis

Scenario:
Cucumber Inc. is an e-commerce company that was launched in 1995. Since then, they have their a range of operations in multiple districts of the country.
They have a high-functioning team and an excellent reputation among their customers. The firm is quite interested in doing a regular analysis on multiple domains 
for a perennial health check across all domains. As they have the policy to have multiple analysts review the different aspects of their businesses, They have hired 
you as a Data Scientist in their data consulting team which offers services across various departments such as sales, customers, HR, etc. 
They have given you a sample of data from their databases. You have to work with the teams to help them with some of their pain points like pricing analysis, product growth,
 product sales, etc. as well as help them work on a new set of financial analyses and do target market/product fit analysis.*/
 
 /*Section 1
The company wants you to analyse details about its customers and also check upon the product pricing along with status of the orders.
1.	Write a SQL query to retrieve the product name, description, and price for all products that have a price less than $100, display "Cheap" for those with a price less 
than $50, and display "Affordable" for those with a price between $50 and $100.*/

SELECT
    product_name,
    product_description,
    product_price,
    CASE
        WHEN product_price < 50 THEN 'Cheap'
        WHEN product_price >= 50 AND product_price <= 100 THEN 'Affordable'
        ELSE 'Expensive'
    END AS price_label
FROM products;

/*2.	Write a SQL query to retrieve the customer's first name, last name, and email address, along with the order status (i.e., "Pending", "Shipped", or "Delivered"),
 and display "Your order is being processed" for orders that are "Pending", "Your order is on the way" for orders that are "Shipped", and "Your order has been delivered" 
 for orders that are "Delivered".*/

SELECT
    c.first_name,
    c.last_name,
    c.email,
    o.order_status,
    CASE
        WHEN o.order_status = 'Pending' THEN 'Your order is being processed'
        WHEN o.order_status = 'Shipped' THEN 'Your order is on the way'
        WHEN o.order_status = 'Delivered' THEN 'Your order has been delivered'
        ELSE 'Order status unknown'
    END AS status_message
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

/*3.	Write a SQL query to retrieve the order ID, order date, and the total amount of the order (i.e., the sum of the prices of all products in the order), and
 display "Discount Applied" for orders that have a total amount greater than $500, and "No Discount Applied" for orders that have a total amount less than or equal to $500.*/
 
SELECT
    o.order_id,
    o.order_date,
    SUM(od.price * od.quantity) AS total_amount,
    CASE
        WHEN SUM(od.price * od.quantity) > 500 THEN 'Discount Applied'
        ELSE 'No Discount Applied'
    END AS discount_message
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date;


/*Section 2
The company wants to create standard procedures for their data. Help them using the procedures, functions and views of MYSQL.
1(i). Create a procedure that calculates the total amount of sales made by a particular customer over a specified time period. 
The procedure should take inputs such as customer ID and date range. Find out What is the total sales of customers with ID 2 between March 1, 2023, and April 30, 2023?*/

DELIMITER &&
create procedure calculate_sales(in cust_id int,in start_date date,in end_date date)
begin
select sum(od.price*od.quantity) as total_sales
from order_details od
join orders o on o.order_id=od.order_id
where o.customer_id=cust_id and o.order_date between start_date and end_date ;
END &&
DELIMITER ;
call calculate_sales(2,'2023-03-01','2023-04-30');

/*(ii). Create a procedure that calculates the sales made by the customers and rank them as per their sales number. The procedure should take inputs as start date, end date and number of customers rank to return top n number of customers in that date range. Solve the following using this procedure.
a.	Who are the top 3 customers in terms of total spending for last month?*/

DELIMITER //
CREATE PROCEDURE CalculateTopCustomers(
    IN startDate DATE,
    IN endDate DATE,
    IN topN INT
)
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(od.price * od.quantity) AS total_spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    WHERE o.order_date BETWEEN startDate AND endDate
    GROUP BY c.customer_id
    ORDER BY total_spending DESC
    LIMIT topN;
END //

DELIMITER ;

CALL CalculateTopCustomers('2023-07-01', '2023-07-31', 3);

/*b.	Which customer spent the most money between March 1st and April 2nd?*/

CALL CalculateTopCustomers('2023-03-01', '2023-04-02', 1);



/*2. Create a function that calculates the total price of an order based on the order_id. Use this function to solve the following questions - 
●	Can you use this function to get the total price of order 1?*/

delimiter &&
create function calculate_order_total (od int)
returns float
deterministic
begin

declare total_price float ;
select sum(price*quantity) into total_price
from order_details od
where od.order_id=od;
return total_price;
end &&
delimiter ;
select calculate_order_total(2) as price; 

/*How can you modify this function to also calculate the total price including tax (10%)?*/
 
 delimiter &&
create function calculate_order_total(od int)
returns float
deterministic
begin
declare total_price_with_tax float;
declare total_price float ;
select sum(price*quantity) into total_price
from order_details od
where od.order_id=od;
set total_price_with_tax=total_price*(total_price*0.1);
return total_price_with_tax;
end &&
delimiter ;
select calculate_order_total(2) as price;
 
/*	Create a view that displays the top 10 customers who made the highest purchase amount in the last month. Solve the following using this view – */

create view top_customers as 
select c.customer_id,od.quantity,concat(c.first_name,' ',c.last_name) as full_name, od.order_id,sum(od.quantity*od.price) as sales 
from customers c join orders o on c.customer_id=o.customer_id
join order_details od on od.order_id=o.order_id
where o.order_date between '2023-04-01' and '2023-04-30'
group by  c.customer_id,od.order_id,od.quantity
order by sales desc
limit 10;

/*a.	What are the total sales for the  customers in the last month?*/
                               
		select sum(sales) as total_sales from top_customers;

 
 /*b.	Which customer spent the most in the last month?*/

select customer_id,max(sales) from top_customers
group by customer_id

limit 2;

/*c.	What was the total quantity of products ordered by the top 10 customers in the last month?*/
                            
select sum(quantity) as total_quantity from top_customers;

