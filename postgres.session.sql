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

SELECT product_id, sum(unit_price * quantity) as total_revenue
FROM order_details
group by product_id


--2. Top 5 best-selling products by quantity sold

select p.product_name,sum(od.quantity) as best_selling
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
