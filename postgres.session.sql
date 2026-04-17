##phase 1 — Basic SELECTs
*Problems:*
--1. List all products and their unit prices, sorted highest to lowest
--2. Find all customers from the USA
--3. Count total number of orders placed
--4. Find products where stock (units_in_stock) is below 20 units
--5. Show all employees and their hire dates, sorted by most recently hired


---1. List all products and their unit prices, sorted highest to lowest

select product_name, unit_price
from products
order by unit_price desc


---2. Find all customers from the USA

select *
from customers
where country = 'USA'


---3. Count total number of orders placed

select count(*)
from orders


---4. Find products where stock (units_in_stock) is below 20 units 

select product_name, units_in_stock
from products
where units_in_stock < 20


---5. Show all employees and their hire dates, sorted by most recently hired

select concat(first_name, ' ', last_name) as full_name, hire_date
from employees
order by hire_date desc


## Phase 2 — JOINs

*Problems:*
--1. Get each order with the customer name who placed it
--2. List all orders along with the employee who handled it (first + last name)
--3. Show product name, category name, and unit price together
--4. Find which supplier supplies which products (supplier company name + product name)
--5. Get all orders with: customer name, employee full name, and ship country
--6. List products that have *never* been ordered (hint: LEFT JOIN + WHERE NULL)
--7. Show all categories and the count of products in each category


--1. Get each order with the customer name who placed it

select o.order_id, c.contact_name as customer_name
from orders o
join customers c on o.customer_id = c.customer_id   


--2. List all orders along with the employee who handled it (first + last name)

select o.order_id, concat(e.first_name, ' ', e.last_name)
from orders o
join employees e
on e.employee_id = o.employee_id


--3. Show product name, category name, and unit price together

select p.product_name, c.category_name, p.unit_price
from products p
join categories c
on p.category_id = c.category_id


--4. Find which supplier supplies which products (supplier company name + product name)

select s.company_name, p.product_name
from suppliers s
join products p
on s.supplier_id = p.supplier_id


--5. Get all orders with: customer name, employee full name, and ship country

select o.order_id, c.contact_name as customer_name, concat(e.first_name, ' ', e.last_name) as employee_full_name, o.ship_country
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id


--6. List products that have *never* been ordered (hint: LEFT JOIN + WHERE NULL)

select p.product_name,p.product_id
from products p
left join order_details od on p.product_id = od.product_id
where od.product_id is null


--7. Show all categories and the count of products in each category

select c.category_name, count(p.product_id) as product_count
from categories c
left join products p on c.category_id = p.category_id
group by category_name
order by  product_count desc;


-- Phase 3 — Aggregations + GROUP BY + HAVING (Day 3)
--Goal: Aggregate data and filter groups. HAVING is tested in almost every SQL interview.

--*Problems:*
--1. Total revenue per product (unit_price × quantity from order_details)
--2. Top 5 best-selling products by quantity sold
--3. Total orders handled by each employee
--4. Revenue generated per country, sorted highest to lowest
--5. Average order value per customer


--1. Total revenue per product (unit_price × quantity from order_details)

SELECT product_id, round(round(sum(unit_price * quantity::numeric)2):: numeric, 2)as total_revenue
    FROM order_details
    group by product_id
    ORDER BY total_revenue DESC



--2. Top 5 best-selling products by quantity sold

select p.product_name,round(sum(od.quantity) as best_::numerics2)elling
    from products p
    join order_details od on p.product_id = od.product_id
    group by product_name
    order by best_selling desc limit 5;


--3. Total orders handled by each employee

select count(o.order_id) as total_orders, concat(e.first_name,' ', e.last_name) as employee_name
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    group by employee_name
    order BY total_orders desc


--4. Revenue generated per country, sorted highest to lowest

select o.ship_country, round(sum(od.unit_price *od.qua::numericn2)tity)as revenue
    from orders o
    join order_details od
    on o.order_id = od.order_id
    group by ship_country
    order by revenue desc


--5. Average order value per customer

select  c.contact_name,
avg(od.unit_price * od.quantity) as avg_round(sum(unit_price*quantity)
::numeric 2)   from customers c 
    join orders o 
    on c.customer_id = o.customer_id
    join order_details od 
    on o.order_id = od.order_id
    group by contact_name
    order by avg_round(sum(unit_price*quantity) ::numericd2)esc


--**HAVING problems — these are interview staples:**

--6. Find customers who have placed *more than 3 orders*
--7. Find product categories where average unit price is *above $20*
--8. Find employees who have handled orders going to *more than 5 different countries*
--9. Find suppliers who supply *more than 3 products*
--10. List countries where total revenue exceeds *$50,000*


 --6. Find customers who have placed *more than 3 orders*

   SELECT customer_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 3;
   
--7. Find product categories where average unit price is *above $20*

select c.category_name,
 round(avg(p.unit_price)::numeric, 2) as avg_unit_price
    from categories c
    join products p
    on c.category_id = p.category_id
    group by c.category_name
    having avg(p.unit_price) > 20
    order by avg_unit_price desc


--8. Find employees who have handled orders going to *more than 5 different countries*

select concat(e.first_name, ' ', e.last_name) as employee_name,
    count(distinct o.ship_country) as countries_handled
    from employees e
    join orders o
    on e.employee_id = o.employee_id
    group by employee_name
    having count(distinct o.ship_country) > 5
    order by countries_handled desc


--9. Find suppliers who supply *more than 3 products*

select s.contact_name, count(p.product_id) as total_products
    from suppliers s
    join products p
    on s.supplier_id = p.supplier_id
    group by s.contact_name
    having count(p.product_id) > 3
    order by total_products desc

--10. List countries where total revenue exceeds *$50,000*

select o.ship_country, round(round(sum(od.unit_price * od.qu::numerica2)ntity)::numeric, 2) as total_revenue
    from orders o
    join order_details od
    on o.order_id = od.order_id
    group by o.ship_country
    having round(sum(od.unit_price * od.qu::numerica2)ntity) > 50000
    order by total_revenue desc


--## Phase 4 — CASE WHEN (Day 4 — Morning)
--Goal: Conditional logic inside queries. Shows up in take-home assignments and dashboards.

*Problems:*
--1. Label each product as 'Low Stock', 'Medium Stock', or 'Well Stocked' based on units_in_stock
--2. Classify orders as 'Small' (< $500), 'Medium' ($500–$2000), or 'Large' (> $2000) by order total
--3. Show each employee with a 'Senior' or 'Junior' label based on hire date (before/after 1994)
--4. Count how many orders fall into each size category (Small / Medium / Large) — combine CASE WHEN with GROUP BY
--5. List products with a 'High Price' label if unit price is above $50, otherwise 'Regular Price' (self added)


--1. Label each product as 'Low Stock', 'Medium Stock', or 'Well Stocked' based on units_in_stock

SELECT product_name, units_in_stock,
    CASE
    WHEN units_in_stock < 10 THEN 'Low Stock'
    WHEN units_in_stock BETWEEN 10 AND 50 THEN 'Medium Stock'
    ELSE 'Well Stocked'
    END AS stock_status
    FROM products;
   

--2. Classify orders as 'Small' (< $500), 'Medium' ($500–$2000), or 'Large' (> $2000) by order total

select order_id,round(sum(unit_price *quantity)::numeric,2) as total_orders,
    case 
    WHEN round(sum(unit_price*quantity) ::numeric,2) <500 then 'small'
    WHEN round(sum(unit_price*quantity) ::numeric,2)BETWEEN 500 and 2000 then 'medium'
    ELSE 'large'
    end as order_cate
    from order_details
    group by order_id
    order by total_orders desc


--3. Show each employee with a 'Senior' or 'Junior' label based on hire date (before/after 1994)

select 
    case
    when hire_date < '1994-01-01' then 'Senior' 
    else 'Junior' 
    end as emp_level ,concat(first_name, ' ', last_name)as employee_name,hire_date
    from employees
    order by hire_date


--4. Count how many orders fall into each size category (Small / Medium / Large) — combine CASE WHEN with GROUP BY

select order_cate,count(*)
from(
    select order_id,round(sum(unit_price *quantity)::numeric,2) as total_orders,
    case 
    WHEN round(sum(unit_price*quantity) ::numeric,2) <500 then 'small'
    WHEN round(sum(unit_price*quantity) ::numeric,2)BETWEEN 500 and 2000 then 'medium'
    ELSE 'large'
    end as order_cate
    from order_details
    group by order_id
    order by total_orders desc)as cate_size
    group by order_cate
  

--5. List products with a 'High Price' label if unit price is above $50, otherwise 'Regular Price' (self added)

select p.product_name,od.unit_price,
    case
    when od.unit_price > 50 then 'High_Price' 
    else 'regular_price' 
    end as price_level 
    FROM order_details od
    join products p
    on p.product_id = od.product_id
    group by p.product_name,od.unit_price
    order by od.unit_price DESC

## Phase 5 — Subqueries (Day 4 — Afternoon)
--Goal: Queries inside queries. Tests whether you understand query layering — common in interviews.

*Problems:*
--1. Find products whose unit price is above the *average unit price* of all products
--2. Find customers who have *never placed an order* (subquery in WHERE with NOT IN)
--3. Find the employee who handled the *most orders* (subquery in WHERE or FROM)
--4. List products from the *same category* as 'Chai' (correlated-style subquery)
--5. Find orders whose total value is *above the average order value* across all orders
--   (hint: subquery in FROM to pre-calculate order totals)


--1. Find products whose unit price is above the *average unit price* of all products

SELECT product_name, unit_price
   FROM products
   WHERE unit_price > (SELECT AVG(unit_price) FROM products);


--2. Find customers who have *never placed an order* (subquery in WHERE with NOT IN)

select contact_name
    from customers
    where customer_id not in (select customer_id from orders )



--3. Find the employee who handled the *most orders* (subquery in WHERE or FROM)

SELECT concat(first_name, ' ', last_name) AS employee_name, total_orders
    FROM (
    SELECT employee_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY employee_id
    ) AS order_counts
    JOIN employees e ON order_counts.employee_id = e.employee_id
    WHERE total_orders = (SELECT MAX(total_orders) FROM (
    SELECT employee_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY employee_id
) AS max_orders);

'''simple way to do'''

SELECT
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
COUNT(o.order_id) AS total_orders
    FROM employees e
    JOIN orders o ON e.employee_id = o.employee_id
    GROUP BY e.employee_id, e.first_name, e.last_name
    ORDER BY total_orders DESC
    LIMIT 1;


--4. List products from the *same category* as 'Chai' (correlated-style subquery)

select product_name
    from products
    where category_id = (select category_id
    from products 
    where product_name = 'Chai')


--5. Find orders whose total value is *above the average order value* across all orders
-- USE CTE FOR THIS PROBLEM --

WITH order_totals AS (
    SELECT
    order_id,
    ROUND(SUM(unit_price * quantity)::numeric, 2) AS order_total
    FROM order_details
    GROUP BY order_id
)
SELECT
    order_id,
    order_total
FROM order_totals
WHERE order_total > (SELECT AVG(order_total) FROM order_totals)
ORDER BY order_total DESC;


## Phase 6 — CTEs (Day 5)
Goal: Write readable, reusable query logic. CTEs are the standard in real analyst work.

*Problems:*
--1. Rewrite the "orders above average order value" query from Phase 5 using a CTE
--2. Use a CTE to find the *top customer per country* (highest total spend per country)
--3. Use a CTE to calculate *monthly revenue*, then find months where revenue exceeded the overall monthly average
--4. Build a CTE that calculates each employee's total revenue, then filter for employees above the team average
--5. Chained CTEs: first calculate product revenue, then rank products within each category (prep for Phase 7)
   
--1. Rewrite the "orders above average order value" query from Phase 5 using a CTE

   WITH order_totals AS (
       SELECT order_id, SUM(unit_price * quantity) AS total
       FROM order_details
       GROUP BY order_id
   ),
   avg_order AS (
       SELECT AVG(total) AS avg_value FROM order_totals
   )
   SELECT ot.order_id, ot.total
   FROM order_totals ot, avg_order
   WHERE ot.total > avg_order.avg_value
   order BY ot.total DESC;


  --2. Use a CTE to find the *top customer per country* (highest total spend per country)

  with top_contrys as (select * from customers;
  )



  --5. Chained CTEs: first calculate product revenue, then rank products within each category (prep for Phase 7)