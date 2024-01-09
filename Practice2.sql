--EX1: 
select distinct city from station 
where id % 2 = 0;
--EX2:
select count(city)-count(distinct(city)) from station;
--EX3:
SELECT CEIL(AVG(Salary)-AVG(REPLACE(Salary,'0','')))
FROM  EMPLOYEES
--EX4
SELECT cast(sum(item_count*order_occurrences)/SUM(order_occurrences) as decimal(3,1))
FROM items_per_order;
--EX5:
select candidate_id 
FROM (SELECT distinct candidate_id, skill FROM candidates 
where skill in ('Python','Tableau','PostgreSQL')) as CAD
group by candidate_id HAVING count(candidate_id) =3
order by candidate_id ASC;
--EX6:
SELECT 
user_id,
EXTRACT(day FROM (max(post_date) - MIN(post_date))) AS days_between
FROM posts
WHERE EXTRACT(year FROM post_date) = '2021'
GROUP BY user_id
HAVING count(post_id) > 1;
--EX7
SELECT distinct card_name,
Max(issued_amount) OVER(partition by card_name) - Min(issued_amount) OVER(partition by card_name)
from monthly_cards_issued
--EX8:
SELECT manufacturer, count(drug) as drug_count, abs(sum (total_sales - cogs)) as total_loss
FROM pharmacy_sales
where (total_sales - cogs) <= 0
group by manufacturer
order by total_loss DESC;
--EX9
