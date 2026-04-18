use sakila;

-- Revenue Analysis
-- total revenue
select sum(amount) as total_revenue from payment;

-- revenue by year and month
select 
      year(payment_date) as year,
      month(payment_date) as month,
      sum(amount) as total_revenue
from payment
group by year, month
order by total_revenue desc;

-- best month achieving revenu
select 
      year(payment_date) as year,
      month(payment_date) as month,
	  sum(amount) as total_revenue
from payment 
group by year, month
order by total_revenue desc
limit 1;

-- each store revenue
select 
       s.store_id,
       sum(p.amount) as total_revenu
from payment p
inner join staff s on p.staff_id = s.staff_id
group by s.store_id
order by total_revenu desc;

-- categories revenu
select 
      c.name as categoryname,
      sum(p.amount) as totalrevenu
from category c 
inner join film_category fc on c.category_id = fc.category_id
inner join film f on fc.film_id = f.film_id
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
inner join payment p on r.rental_id = p.rental_id
group by categoryname
order by totalrevenu desc;


-- customers analysis 
-- total customers
select count(customer_id) as totalcustomer from customer;

-- top customer paying
select 
       c.customer_id,
       concat(c.first_name, ' ', c.last_name) as fullname, 
	   sum(p.amount) as totalrevenue
from customer c
inner join payment p on c.customer_id = p.customer_id
group by c.customer_id, fullname
order by totalrevenue desc;

-- the customer rent less films (less activity)
select 
       c.customer_id,
       concat(c.first_name, ' ', c.last_name) as fullname, 
	   count(r.rental_id) as rentalnum
from customer c
inner join rental r on c.customer_id = r.customer_id
group by customer_id, fullname
order by rentalnum asc;

-- customer numbers by country
select 
      co.country,
      count(cu.customer_id) as totalcustomers
from customer cu
inner join address a on cu.address_id = a.address_id
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
group by co.country
order by totalcustomers desc;



-- Film Analysis
-- top rented films
select 
      f.film_id,
      f.title as filmtitle,
      count(r.rental_id) as totalrentals
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.film_id, filmtitle
order by totalrentals desc;

-- top rented categories
select 
      c.name as categoryname,
      count(r.rental_id) as totalrentals
from category c 
inner join film_category fc on c.category_id = fc.category_id
inner join film f on fc.film_id = f.film_id
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by categoryname
order by totalrentals desc;

-- top movies achieving revenue
select 
      f.title as filmtitle,
      sum(p.amount) as totalrevenu
from payment p 
inner join rental r on p.rental_id = r.rental_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
group by filmtitle
order by totalrevenu desc;



-- rental analysis 
-- average rental time
select 
      avg(datediff(return_date, rental_date)) as avg_renta_time
from rental;

-- number of rentals for each store 
select 
	  s.store_id,
      count(r.rental_id) as totalrentals 
from store s 
inner join staff st on s.store_id = st.store_id
inner join rental r on st.staff_id = r.staff_id
group by s.store_id
order by totalrentals desc;



-- Staff Analysis
-- total revenue for each staff member
select 
      s.staff_id,
      concat(s.first_name, ' ', s.last_name) as fullname,
      sum(p.amount) as totalrevenue 
from payment p 
inner join staff s on s.staff_id = p.staff_id
group by s.staff_id, fullname
order by totalrevenue desc;

-- best staff member
select 
      s.staff_id,
      concat(s.first_name, ' ', s.last_name) as fullname,
      sum(p.amount) as totalrevenue 
from payment p 
inner join staff s on s.staff_id = p.staff_id
group by s.staff_id, fullname
order by totalrevenue desc
limit 1;




-- Customer Segmentation
select 
      c.customer_id,
      concat(c.first_name, ' ',c.last_name) as fullname,
      sum(p.amount) as total_spent,
      case 
		  when sum(p.amount) > 150 then 'High Value'
		  when sum(p.amount) > 75 then 'medium Value'
		  else 'low value'
		  end as CustomerSegmentation
from customer c 
inner join payment p on c.customer_id = p.customer_id
group by  c.customer_id, fullname
order by total_spent desc;

-- late return films
SELECT 
    f.title,
    COUNT(*) AS late_returns
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
GROUP BY f.title
ORDER BY late_returns DESC;

-- Best Store
SELECT 
    s.store_id,
    SUM(p.amount) AS revenue,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank_store
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id;

-- Active vs Inactive Customers
select 
      c.customer_id,
      concat(c.first_name, ' ', c.last_name) as fullname,
      count(r.rental_id) as totalrentals,
      case 
          when count(r.rental_id) > 25 then 'Active'
          else 'Inactive'
      end as Customers_Status
from customer c
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, fullname
order by totalrentals desc; 













