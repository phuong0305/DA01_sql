--EX1
select name 
from students where marks >75
order by right(name,3), ID;
--EX2 (xem giúp mình đang báo lỗi missing right parenthesis)
select user_id, conact(uppper(left(name,1)),lower(substring(name from 2))) as name
from users order by user_id;
--EX3
SELECT manufacturer, concat('$',ROUND((sum(total_sales)/1000000),0),' ','million') as sale
FROM pharmacy_sales
group by manufacturer
ORDER BY sum(total_sales) DESC, manufacturer ;
--EX4
SELECT EXTRACT(Month from submit_date) as mth, product_id, round(AVG(stars),2) as avg_stars
FROM reviews
group by product_id, EXTRACT(month from submit_date)
ORDER BY mth,product_id;
--EX5
SELECT sender_id, COUNT(message_id) AS count_messages
FROM messages
where EXTRACT (month from sent_date) = 8 AND
EXTRACT (year from sent_date) = 2022
group by sender_id
ORDER BY count_messages DESC
limit 2;
--EX6
Select tweet_id
from Tweets
where length(content) >15;
--EX7
Select activity_date as day, count(distinct(user_id)) as active_users
from activity
where  activity_date between '2019-06-28' and'2019-07-27'
group by activity_date
having count(distinct(user_id)) >=1;
--EX8
select count(distinct(id))
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022;
--EX9
select position('a' in first_name) from worker
where first_name ='Amitah';
--EX10
select substring(title from (length(winery)+2) for 4)
from winemag_p2
where country = 'Macedonia';
