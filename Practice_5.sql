--EX1:
Select a.continent, Floor(avg(b.population))
from country AS a
join city AS b
on a.code = b.countrycode
group by a.continent;
--EX2
SELECT 
Round((1.00*SUM(case when b.signup_action = 'Confirmed' then 1 else 0 END)/count(b.signup_action)),2)
FROM emails AS a
JOIN texts AS b
ON a.email_id = b.email_id;
--EX3
SELECT b.age_bucket,
round(100.00*(SUM(case when activity_type = 'send' then time_spent END))/sum(time_spent),2) AS send_perc,
round(100.00*(SUM(case when activity_type = 'open' then time_spent END))/sum(time_spent),2) AS open_perc
FROM activities AS a
JOIN age_breakdown AS b
ON a.user_id = b.user_id
where activity_type in ('open', 'send')
group by b.age_bucket;
--EX4
SELECT a.customer_id
FROM customer_contracts as a
LEFT JOIN products as b
on a.product_id = b.product_id
group by a.customer_id
having COUNT(distinct b.product_category) = (SELECT count(distinct product_category) from products);
--EX5
select a.employee_id, a.name, count(b.reports_to) as reports_count, round(avg(b.age),0) as average_age
from employees as a
left join employees as b
on a.employee_id = b.reports_to
group by a.employee_id, a.name
having count(b.reports_to) >= 1
order by a.employee_id;
--EX6
SELECT a.product_name, SUM(b.unit) as unit
FROM Products AS a
JOIN orders AS b
ON a.product_id =b.product_id
where extract(month from order_date)= 2 and extract(year from order_date)= 2020
group by a.product_name
having SUM(b.unit) >= 100;
-EX7
select page_id from pages 
where page_id not in (select page_id from page_likes)
order by page_id;
