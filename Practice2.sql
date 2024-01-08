--EX1: 
select distinct city from station 
where id % 2 = 0;
--EX2:
select count(city)-count(distinct(city)) from station;
--EX3:
SELECT CEIL(AVG(Salary)-AVG(REPLACE(Salary,'0','')))
FROM  EMPLOYEES
--EX4
SELECT sum(item_count*order_occurrences)/SUM(order_occurrences) 
FROM items_per_order;
--EX5:
SELECT user_id, (date(max(post_date))-date(min(post_date))) FROM posts
group by user_id;
--EX6:
