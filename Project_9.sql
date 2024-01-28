--EX1:
alter table sales_dataset_rfm_prj 
alter column priceeach type numeric using (trim (priceeach):: numeric);
--EX2
Select *
From sales_dataset_rfm_prj 
Where (ORDERNUMBER is null or ORDERNUMBER = '')

Select *
From sales_dataset_rfm_prj 
Where (QUANTITYORDERED is null or QUANTITYORDERED = '')

Select *
From sales_dataset_rfm_prj 
Where (PRICEEACH is null or PRICEEACH = '')

Select *
From sales_dataset_rfm_prj 
Where (ORDERLINENUMBER is null or ORDERLINENUMBER = '')

Select *
From sales_dataset_rfm_prj 
Where (SALES is null or SALES = '')

Select *
From sales_dataset_rfm_prj 
Where (ORDERDATE is null or ORDERDATE = '')

--EX3
alter table sales_dataset_rfm_prj 
add column contactfirstname varchar
  
insert into sales_dataset_rfm_prj 
(contactfirstname)
with cft as
(select substring (contactfullname from (position('-' in contactfullname)+1)
for length (contactfullname) - position('-' in contactfullname)) as contactfirstname
from sales_dataset_rfm_prj)
select upper(left(contactfirstname, 1)) || right(contactfirstname,length(contactfirstname)-1) from cft;

alter table sales_dataset_rfm_prj 
add column contactlastname varchar

insert into sales_dataset_rfm_prj 
(contactlastname)
with clt as
(select left(contactfullname, position('-' in contactfullname)-1) as contactlastname
from sales_dataset_rfm_prj)
select upper(left(contactlastname, 1)) || right(contactlastname,length(contactlastname)-1) from clt;

--EX4:
alter table sales_dataset_rfm_prj 
add column MONTH_ID varchar

insert into sales_dataset_rfm_prj 
(MONTH_ID)
select extract (month from orderdate) from sales_dataset_rfm_prj 

alter table sales_dataset_rfm_prj 
add column YEAR_ID varchar


insert into sales_dataset_rfm_prj 
(YEAR_ID)
select extract (YEAR from orderdate) from sales_dataset_rfm_prj 


alter table sales_dataset_rfm_prj 
add column QTR_ID varchar


insert into sales_dataset_rfm_prj 
(QTR_ID)
select extract (quarter from orderdate) from sales_dataset_rfm_prj 

--EX5:
alter table sales_dataset_rfm_prj 
alter column quantityordered type numeric using (trim (quantityordered):: numeric)

with CTE as
(select Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
from
(select 
percentile_cont(0.25) within group (order by quantityordered) as Q1,
percentile_cont(0.75) within group (order by quantityordered) as Q3,
((percentile_cont(0.75) within group (order by quantityordered)) 
- (percentile_cont(0.25) within group (order by quantityordered))) as IQR
from sales_dataset_rfm_prj) as a)
select * from sales_dataset_rfm_prj 
where quantityordered < (select min_value from cte)
and quantityordered > (select max_value from cte)

C2:

with cte2 as
(select quantityordered, (select avg(quantityordered) from sales_dataset_rfm_prj) as avg,
  (select stddev(quantityordered) from sales_dataset_rfm_prj ) as std
from sales_dataset_rfm_prj)
select quantityordered, (quantityorderd - avg)/std as z_core
from CTE2
where ABS ((quantityordered-avg)/std)>3;
