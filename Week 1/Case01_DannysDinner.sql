-- #8weeksqlchallenge with Danny Ma
-- Case Study 1: Danny's Dinner

-- Create tables
use testdb;

--CREATE TABLE sales (
--  "customer_id" VARCHAR(1),
--  "order_date" DATE,
--  "product_id" INTEGER
--);

--INSERT INTO sales
--  ("customer_id", "order_date", "product_id")
--VALUES
--  ('A', '2021-01-01', '1'),
--  ('A', '2021-01-01', '2'),
--  ('A', '2021-01-07', '2'),
--  ('A', '2021-01-10', '3'),
--  ('A', '2021-01-11', '3'),
--  ('A', '2021-01-11', '3'),
--  ('B', '2021-01-01', '2'),
--  ('B', '2021-01-02', '2'),
--  ('B', '2021-01-04', '1'),
--  ('B', '2021-01-11', '1'),
--  ('B', '2021-01-16', '3'),
--  ('B', '2021-02-01', '3'),
--  ('C', '2021-01-01', '3'),
--  ('C', '2021-01-01', '3'),
--  ('C', '2021-01-07', '3');
 
--select * from sales;


--CREATE TABLE menu (
--  "product_id" INTEGER,
--  "product_name" VARCHAR(5),
--  "price" INTEGER
--);

--INSERT INTO menu
--  ("product_id", "product_name", "price")
--VALUES
--  ('1', 'sushi', '10'),
--  ('2', 'curry', '15'),
--  ('3', 'ramen', '12');
  
--select * from menu;


--CREATE TABLE members (
--  "customer_id" VARCHAR(1),
--  "join_date" DATE
--);

--INSERT INTO members
--  ("customer_id", "join_date")
--VALUES
--  ('A', '2021-01-07'),
--  ('B', '2021-01-09');

--select * from members;


-- Case Study Questions

-- Each of the following case study questions can be answered using a single SQL statement:

-- Q1. What is the total amount each customer spent at the restaurant?
-- Q2. How many days has each customer visited the restaurant?
-- Q3. What was the first item from the menu purchased by each customer?
-- Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Q5. Which item was the most popular for each customer?
-- Q6. Which item was purchased first by the customer after they became a member?
-- Q7. Which item was purchased just before the customer became a member?
-- Q8. What is the total items and amount spent for each member before they became a member?
-- Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- Q10. In the first week after a customer joins the program (including their join date) 
--  	they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


-- Q1.  What is the total amount each customer spent at the restaurant?
-- Ans: We need to sum the total price per person
select customer_id, sum(price) as total_amt
from sales s
inner join menu m
on s.product_id = m.product_id
group by s.customer_id;

-- Q2.  How many days has each customer visited the restaurant?
-- Ans: Count the number of order dates per person
select customer_id, count(distinct(order_date)) as num_days
from sales s
group by s.customer_id;

-- Q3.  What was the first item from the menu purchased by each customer?
-- Ans: First, find the order number for all the unique orders 
--		Select the first order number only based on order_date.

with first_order as 
(	
	select s.customer_id, s.order_date, m.product_name, 
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS order_num
	from sales s, menu m
	WHERE s.product_id = m.product_id
)
select customer_id, order_date, product_name
from first_order
WHERE order_num = 1
order by order_date asc
;

-- Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Ans Count the number of times a product was ordered
select s.customer_id, s.order_date, m.product_name, 
ROW_NUMBER() OVER(PARTITION BY product_name ORDER BY product_name ASC) AS item_freq
from sales s, menu m
WHERE s.product_id = m.product_id;
GO
select product_name, count(m.product_name) as no_times_ordered
from sales s, menu m
WHERE s.product_id = m.product_id
group by product_name;

-- Q5. Which item was the most popular for each customer?
-- Ans For each customer and item pair count the no of instance of that item

select s.customer_id, product_name, count(m.product_name)
from sales s 
inner join menu m
ON s.product_id = m.product_id
group by customer_id, product_name;


-- Q6. Which item was purchased first by the customer after they became a member?

with cte as (
select 
s.customer_id, s.order_date, m.product_name, j.join_date,
ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS seq_num
from sales s 
inner join menu m
ON s.product_id = m.product_id
left join members j
ON s.customer_id = j.customer_id
WHERE j.join_date <= s.order_date
)
select customer_id, product_name
from cte
WHERE seq_num = 1
ORDER BY order_date ASC

-- Q7. Which item was purchased just before the customer became a member?

with cte as (
select 
s.customer_id, s.order_date, m.product_name, j.join_date,
ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS seq_num
from sales s 
inner join menu m
ON s.product_id = m.product_id
left join members j
ON s.customer_id = j.customer_id
WHERE s.order_date < j.join_date
)
select customer_id, order_date, product_name
from cte
WHERE seq_num = 1;

-- Q8. What is the total items and amount spent for each member before they became a member?

with cte as (
select 
s.customer_id, s.order_date, m.product_name, m.price, j.join_date,
ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS seq_num
from sales s 
inner join menu m
ON s.product_id = m.product_id
left join members j
ON s.customer_id = j.customer_id
WHERE s.order_date < j.join_date
)
select customer_id, count(product_name) as total_items, sum(price) as total_amount_spent
from cte
group by customer_id;

-- Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with points_table as (
select s.customer_id, m.product_name, points =
	CASE m.product_name
		WHEN 'sushi' THEN 20*m.price
		ELSE 10*m.price
	END	
from sales s 
inner join menu m
ON s.product_id = m.product_id
)
select customer_id, sum(points) as total_points
from points_table
group by customer_id;


-- Q10. In the first week after a customer joins the program (including their join date) 
--  	they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select *
from sales s 
inner join menu m
ON s.product_id = m.product_id
left join members j
ON s.customer_id = j.customer_id
WHERE j.customer_id IN ('A','B');
GO

with 
	before_mem as (
	select s.customer_id, m.product_name, join_pts =
		CASE m.product_name
			WHEN 'sushi' THEN 20*m.price
			ELSE 10*m.price
		END	
	from sales s 
	inner join menu m
	ON s.product_id = m.product_id
	left join members j
	ON s.customer_id = j.customer_id
	WHERE j.join_date > s.order_date
	),
	after_mem as (
	select s.customer_id, m.product_name, join_pts = 20*m.price
	from sales s 
	inner join menu m
	ON s.product_id = m.product_id
	left join members j
	ON s.customer_id = j.customer_id
	WHERE j.join_date <= s.order_date
	AND order_date < '2021-02-01'
	)
select total_pts_A =
(select sum(join_pts) from before_mem where customer_id = 'A') + (select sum(join_pts) from after_mem  where customer_id = 'A'),
 total_pts_B =
(select sum(join_pts) from before_mem where customer_id = 'B') + (select sum(join_pts) from after_mem  where customer_id = 'B');










