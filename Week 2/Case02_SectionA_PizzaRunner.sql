USE testdb;
-- This is the solution to the Week 2 of #8WeekSQLChallenge
-- Please check out the problem statement in the link below
-- https://8weeksqlchallenge.com/case-study-2/
-- For any queries regarding the problem statement, please contact Danny Ma.

--=====================================================================================
-- SOLUTIONS
--=====================================================================================
-- Data Clean Up
---------------------------------------------------------------------------------------
-- Before we actually proceed with the solutions, there are problems in the data.
-- Data Cleanup needs to be performed before approaching the solutions.
-- This can be done via two ways:
-- 1. We can either perform the clean up activity on the table level itself
-- 2. We can perform the clean up at Common Table.
-- In this script, we shall be performing the later.

-- We have identified the following places which needs to be cleaned up

-- Table: customer_orders
-- The exclusions and extras columns will has to be cleaned up before using them.

-- Table: runner_orders
-- The pickup_time, distance, duration and cancellation columns will has to be cleaned up before using them.

-- These columns contain misprinted string entries as 'null', 'NaN' which are not the same as NULL type.
-- We will convert these string values to NULL type
-- Additionally, there are other problems in distance and duration columns in runner_orders table. It contains values with extensions specified as 'km', 'minutes', 'mins', 'minute'
-- We will deal with these issues in subsequent scripts, as they are not much required in this exercise.
-- In addition, we will also convert them to NVARCHAR(100) datatype

--=====================================================================================
-- Section A
---------------------------------------------------------------------------------------

-- 1. How many pizzas were ordered?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN' THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders)
SELECT COUNT(order_id) as NumPizzaOrdered
FROM cust_orders;

---------------------------------------------------------------------------------------

-- 2. How many unique customer orders were made?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN'  THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders)
SELECT COUNT(DISTINCT(order_id)) as UniqueOrders
FROM cust_orders;

---------------------------------------------------------------------------------------

-- 3. How many successful orders were delivered by each runner?

with
run_orders AS (
	select order_id, runner_id,
		CASE pickup_time
			WHEN 'null' THEN NULL
			ELSE CAST(pickup_time as NVARCHAR(100))
		END as pickup_time,
		CASE distance
			WHEN 'null' THEN NULL
			ELSE CAST(distance as NVARCHAR(100))
		END as distance,
		CASE duration
			WHEN 'null' THEN NULL
			ELSE CAST(duration as NVARCHAR(100))
		END as duration,
		CASE cancellation
			WHEN 'null' THEN NULL
			ELSE CAST(cancellation as NVARCHAR(100))
		END as cancellation 
	from runner_orders)
SELECT runner_id, COUNT(order_id) as num_success_orders
FROM run_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id;

---------------------------------------------------------------------------------------

-- 4. How many of each type of pizza was delivered?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN'  THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders),
run_orders AS (
	select order_id, runner_id,
		CASE pickup_time
			WHEN 'null' THEN NULL
			ELSE CAST(pickup_time as NVARCHAR(100))
		END as pickup_time,
		CASE distance
			WHEN 'null' THEN NULL
			ELSE CAST(distance as NVARCHAR(100))
		END as distance,
		CASE duration
			WHEN 'null' THEN NULL
			ELSE CAST(duration as NVARCHAR(100))
		END as duration,
		CASE cancellation
			WHEN 'null' THEN NULL
			ELSE CAST(cancellation as NVARCHAR(100))
		END as cancellation 
	from runner_orders),
succ_orders as (
	select cuso.order_id, cuso.customer_id, cuso.pizza_id,
	cuso.exclusions, cuso.extras, cuso.order_time,
	runo.runner_id, runo.pickup_time, 
	runo.distance, runo.duration, runo.cancellation
	from cust_orders cuso 
	LEFT JOIN run_orders runo
	ON cuso.order_id = runo.order_id
	WHERE runo.pickup_time IS NOT NULL),
pizza_nm as (
	select 
		CAST(pizza_id as INT) as pizza_id,
		CAST(pizza_name as NVARCHAR(100)) as pizza_name
	from pizza_names)

select pn.pizza_name, count(so.pizza_id) as NumPizzaDelivered
from succ_orders so
JOIN pizza_nm pn
ON so.pizza_id = pn.pizza_id
group by pn.pizza_name;

---------------------------------------------------------------------------------------

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

with 
cust_orders as (
	select order_id, customer_id, 
		CAST(pizza_id as INT) as pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN'  THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders),
pizza_nm as (
	select 
		CAST(pizza_id as INT) as pizza_id,
		CAST(pizza_name as NVARCHAR(100)) as pizza_name
	from pizza_names)

select co.customer_id, pn.pizza_name, count(co.pizza_id) as NumPizzaOrdered
from cust_orders co
JOIN pizza_nm pn
ON co.pizza_id = pn.pizza_id
group by co.customer_id, pn.pizza_name
order by co.customer_id;

---------------------------------------------------------------------------------------

-- 6. What was the maximum number of pizzas delivered in a single order?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN'  THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders),
run_orders AS (
	select order_id, runner_id,
		CASE pickup_time
			WHEN 'null' THEN NULL
			ELSE CAST(pickup_time as NVARCHAR(100))
		END as pickup_time,
		CASE distance
			WHEN 'null' THEN NULL
			ELSE CAST(distance as NVARCHAR(100))
		END as distance,
		CASE duration
			WHEN 'null' THEN NULL
			ELSE CAST(duration as NVARCHAR(100))
		END as duration,
		CASE cancellation
			WHEN 'null' THEN NULL
			ELSE CAST(cancellation as NVARCHAR(100))
		END as cancellation 
	from runner_orders),
succ_orders as (
	select cuso.order_id, cuso.customer_id, cuso.pizza_id,
	cuso.exclusions, cuso.extras, cuso.order_time,
	runo.runner_id, runo.pickup_time, 
	runo.distance, runo.duration, runo.cancellation
	from cust_orders cuso 
	LEFT JOIN run_orders runo
	ON cuso.order_id = runo.order_id
	WHERE runo.pickup_time IS NOT NULL)

select order_id, count(pizza_id) as maxPizOneOrder
from succ_orders 
group by order_id;

---------------------------------------------------------------------------------------

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			WHEN 'NaN'  THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders),
run_orders AS (
	select order_id, runner_id,
		CASE pickup_time
			WHEN 'null' THEN NULL
			ELSE CAST(pickup_time as NVARCHAR(100))
		END as pickup_time,
		CASE distance
			WHEN 'null' THEN NULL
			ELSE CAST(distance as NVARCHAR(100))
		END as distance,
		CASE duration
			WHEN 'null' THEN NULL
			ELSE CAST(duration as NVARCHAR(100))
		END as duration,
		CASE cancellation
			WHEN 'null' THEN NULL
			ELSE CAST(cancellation as NVARCHAR(100))
		END as cancellation 
	from runner_orders),
succ_orders as (
	select cuso.order_id, cuso.customer_id, cuso.pizza_id,
	cuso.exclusions, cuso.extras, cuso.order_time,
	runo.runner_id, runo.pickup_time, 
	runo.distance, runo.duration, runo.cancellation
	from cust_orders cuso 
	LEFT JOIN run_orders runo
	ON cuso.order_id = runo.order_id
	WHERE runo.pickup_time IS NOT NULL)

select customer_id, pizza_id, count(pizza_id) as num_piz_changes
from succ_orders 
where (ISNUMERIC(exclusions) = 1
and exclusions > 0)
or (ISNUMERIC(extras) = 1
and extras > 0)
group by customer_id, pizza_id;

---------------------------------------------------------------------------------------

-- 8. How many pizzas were delivered that had both exclusions and extras?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		order_time
	from customer_orders),
run_orders AS (
	select order_id, runner_id,
		CASE pickup_time
			WHEN 'null' THEN NULL
			ELSE CAST(pickup_time as NVARCHAR(100))
		END as pickup_time,
		CASE distance
			WHEN 'null' THEN NULL
			ELSE CAST(distance as NVARCHAR(100))
		END as distance,
		CASE duration
			WHEN 'null' THEN NULL
			ELSE CAST(duration as NVARCHAR(100))
		END as duration,
		CASE cancellation
			WHEN 'null' THEN NULL
			ELSE CAST(cancellation as NVARCHAR(100))
		END as cancellation 
	from runner_orders),
succ_orders as (
	select cuso.order_id, cuso.customer_id, cuso.pizza_id,
	cuso.exclusions, cuso.extras, cuso.order_time,
	runo.runner_id, runo.pickup_time, 
	runo.distance, runo.duration, runo.cancellation
	from cust_orders cuso 
	LEFT JOIN run_orders runo
	ON cuso.order_id = runo.order_id
	WHERE runo.pickup_time IS NOT NULL)

select customer_id, pizza_id, count(pizza_id) as num_piz_excl_extra
from succ_orders 
where (exclusions IS NOT NULL
and exclusions <> ' ')
and (extras IS NOT NULL
and extras <> ' ')
group by customer_id, pizza_id;

---------------------------------------------------------------------------------------

-- 9. What was the total volume of pizzas ordered for each hour of the day?

with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		DATEPART(HOUR, order_time) as HourofDay
	from customer_orders)
select HourofDay, COUNT(pizza_id) as PizVolbyHour
from cust_orders
group by HourofDay;

---------------------------------------------------------------------------------------

-- 10.What was the volume of orders for each day of the week?


with 
cust_orders as (
	select order_id, customer_id, pizza_id,
		CASE exclusions
			WHEN 'null' THEN NULL
			ELSE CAST(exclusions as NVARCHAR(100))
		END as exclusions,
		CASE extras
			WHEN 'null' THEN NULL
			ELSE CAST(extras as NVARCHAR(100))
		END as extras,
		DATEPART(WEEK, order_time) as NumWeek,
		DATEPART(WEEKDAY, order_time) as DayWeek
	from customer_orders)
--select *
select DayWeek, COUNT(pizza_id) as PizVolbyWeekday
from cust_orders
group by DayWeek;

--=====================================================================================