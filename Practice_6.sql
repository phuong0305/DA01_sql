--EX1
with job_id_count as
(select company_id, COUNT(distinct job_id) FROM job_listings
where title is not NULL and description is not NULL
GROUP BY (company_id)
HAVING COUNT(distinct job_id) >=2)
select COUNT(distinct company_id) from Job_id_count;
--EX2
with total_spend_sum as
(SELECT category, product, SUM(spend) as total_spend,
RANK () OVER (partition by category ORDER BY sum(spend) DESC) as rank
FROM product_spend
where EXTRACT(year from transaction_date) = 2022
group by category, product
order by category, total_spend DESC)
select category, product, total_spend
from total_spend_sum
where rank in (1,2);
--EX3
WITH count_call as
(select policy_holder_id, COUNT(case_id) 
FROM callers
group by policy_holder_id
having COUNT(case_id) >=3)
SELECT COUNT(DISTINCT policy_holder_id) as member_count
from count_call;
--EX4
select page_id from pages 
where page_id not in (select page_id from page_likes)
order by page_id;
--EX5
WITH month_7 as
(SELECT distinct(user_id), event_type, EXTRACT(MONTH FROM event_date) as month FROM user_actions
where EXTRACT(MONTH FROM event_date) = 7 AND 
EXTRACT(year FROM event_date) = 2022 AND
event_type in ('sign_in', 'like','comment')),
month_6 as
(SELECT distinct(user_id), event_type FROM user_actions
where EXTRACT(MONTH FROM event_date) = 6 AND 
EXTRACT(year FROM event_date) = 2022 AND
event_type in ('sign_in', 'like','comment'))
SELECT month_7.month as month, COUNT(distinct month_7.user_id) as monthly_active_users
from month_7
join month_6
ON month_7.user_id = month_6.user_id
group by month_7.month;
--EX6
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) in (
SELECT product_id, MIN(year) 
FROM Sales
GROUP BY product_id;
--EX7
SELECT  SUBSTR(trans_date,1,7) as month, country, count(id) as trans_count, 
SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count, SUM(amount) as trans_total_amount, 
SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount
FROM Transactions
GROUP BY month, country
--EX8
select customer_id 
from Customer 
group by customer_id
having count(distinct (product_key))=(select count(product_key) from Product )
--EX9
select a.employee_id 
from employees as a
right join employees as b 
on a.employee_id = b.manager_id
group by a.employee_id
having sum(a.salary) <30000;
--EX10
with job_id_count as
(select company_id, COUNT(distinct job_id) FROM job_listings
where title is not NULL and description is not NULL
GROUP BY (company_id)
HAVING COUNT(distinct job_id) >=2)
select COUNT(distinct company_id) from Job_id_count;
--EX11
(SELECT name AS results
FROM MovieRating JOIN Users USING(user_id)
GROUP BY name
ORDER BY COUNT(*) DESC, name
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM MovieRating JOIN Movies USING(movie_id)
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1);
--EX12
WITH all_ids AS (
SELECT ra.requester_id AS id, COUNT(*) AS cnt
FROM RequestAccepted ra
GROUP BY ra.requester_id
UNION ALL -- don't remove duplicates
SELECT ra.accepter_id AS id, COUNT(*) AS cnt 
 ROM RequestAccepted ra
 GROUP BY ra.accepter_i)

SELECT id, SUM(cnt) AS num
FROM all_ids
GROUP BY id
ORDER BY num DESC
LIMIT 1
