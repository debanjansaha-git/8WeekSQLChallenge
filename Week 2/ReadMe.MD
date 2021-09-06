# Week 2: Pizza Runner

### Environment: Microsoft SQL Server 2019 

This contains all the solutions to [Case Study 2](https://8weeksqlchallenge.com/case-study-2/) of  [8 Weeks of SQL Challenge](https://8weeksqlchallenge.com) prepared and hosted by [Danny Ma](https://www.linkedin.com/in/datawithdanny/) 

The following is the ER Diagram \
![Pizza Runner](/xothers/images/PizzaRunner.PNG "Week 2 ERD")

It tries to attempt all the below questions
### Section A
<ol>
    <li>How many pizzas were ordered?</li>
    <li>How many unique customer orders were made?</li>
    <li>How many successful orders were delivered by each runner?</li>
    <li>How many of each type of pizza was delivered?</li>
    <li>How many Vegetarian and Meatlovers were ordered by each customer?</li>
    <li>What was the maximum number of pizzas delivered in a single order?</li>
    <li>For each customer, how many delivered pizzas had at least 1 change and how many had no changes?</li>
    <li>How many pizzas were delivered that had both exclusions and extras?</li>
    <li>What was the total volume of pizzas ordered for each hour of the day?</li>
    <li>What was the volume of orders for each day of the week?</li>
</ol>

### Section B: Runner and Customer Experience
<ol>
    <li>How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)</li>
    <li>What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?</li>
    <li>Is there any relationship between the number of pizzas and how long the order takes to prepare?</li>
    <li>What was the average distance travelled for each customer?</li>
    <li>What was the difference between the longest and shortest delivery times for all orders?</li>
    <li>What was the average speed for each runner for each delivery and do you notice any trend for these values?</li>
    <li>What is the successful delivery percentage for each runner?</li>
</ol>

### Section C: Ingredient Optimisation
<ol>
    <li>What are the standard ingredients for each pizza?</li>
    <li>What was the most commonly added extra?</li>
    <li>What was the most common exclusion?</li>
    <li>Generate an order item for each record in the customers_orders table in the format of one of the following:</li>
        <ul>
        <li>Meat Lovers</li>
        <li>Meat Lovers - Exclude Beef</li>
        <li>Meat Lovers - Extra Bacon</li>
        <li>Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers</li>
        </ul>
    <li>Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients</li>
        For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
    <li>What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?</li>
</ol>

### Section D: Pricing and Ratings
<ol>
    <li>If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?</li>
    <li>What if there was an additional $1 charge for any pizza extras?</li>
        <ul>
        <li>Add cheese is $1 extra</li>
        </ul>
    <li>The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.</li>
    <li>Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?</li>
        <ul>
            <li>customer_id</li>
            <li>order_id</li>
            <li>runner_id</li>
            <li>rating</li>
            <li>order_time</li>
            <li>pickup_time</li>
            <li>Time between order and pickup</li>
            <li>Delivery duration</li>
            <li>Average speed</li>
            <li>Total number of pizzas</li>
        </ul>
    <li>If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?</li>
</ol>


It uses the knowledge of following techniques
<ul>
    <li>Common Table Expressions</li>
    <li>Group By Aggregates</li>
    <li>Windows Functions</li>
    <li>Table Joins</li>
    <li>String transformations</li>
    <li>Dealing with null values</li>
    <li>Regular expressions</li>
</ul>

