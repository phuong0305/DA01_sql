--EX1
SELECT 
count(case 
when device_type = 'laptop' then 'amount' END) as laptop_views,
count(case 
when device_type IN ('tablet', 'phone') then 'amount' END) as mobile_views
FROM viewership;
--EX2
Select x, y, z,
case
when x+y>z and x+z>y and y+z>x and x>0 and Y>0 and Z>0 then 'Yes'
else 'No'
End as triangle
from Triangle;
--EX3
select ROUND(CAST(count(case when call_category is null or call_category = 'n/a' then 1 end)/
       (SELECT COUNT(case_id) from callers) as decimal),1)
       as call_percentage
from callers;
--EX4
select name from Customer where referee_id <> 2 or referee_id is null ;
--EX5
select survived,
count(case when pclass = 1 then 1 end) as first_class,
count(case when pclass = 2 then 2 end) as second_class, 
count(case when pclass = 3 then 3 end) as third_class
from titanic
group by survived;
