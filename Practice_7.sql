--EX1:
SELECT EXTRACT(year from transaction_date) as year,
product_id, SUM(spend) as curr_year_spend,
LAG (SUM(spend)) OVER(PARTITION BY PRODUCT_ID) as prev_year_spend,
round((SUM(spend) - LAG (SUM(spend)) OVER(PARTITION BY PRODUCT_ID order by EXTRACT(year from transaction_date)))*100.00/LAG (SUM(spend)) OVER(PARTITION BY PRODUCT_ID),2) as yoy_rate
FROM user_transactions
GROUP BY product_id, EXTRACT(year from transaction_date);
--EX2:
with monthly_rank as
(SELECT *,
row_number() OVER(PARTITION BY card_name ORDER By issue_year)
FROM monthly_cards_issued)
select card_name, issued_amount
from monthly_rank
where row_number = 1
order by issued_amount DESC ;
--EX3
with trans as
(SELECT *,
row_number() OVER(PARTITION BY user_id ORDER BY transaction_date)
FROM transactions)
select user_id, spend, transaction_date
from trans
WHERE row_number = 3;
--EX4
WITH trans AS
(SELECT transaction_date,user_id, COUNT(product_id) as purchase_count,
ROW_NUMBER () OVER(PARTITION BY user_id ORDER BY transaction_date DESC)
FROM user_transactions
group by transaction_date,user_id)
select transaction_date, user_id, purchase_count
from trans
WHERE row_number = 1
ORDER BY transaction_date;
--EX5
WITH twts as
(SELECT user_id, tweet_date, tweet_count,
lag(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) as tweet_count_1,
lag(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as tweet_count_2,
row_number() OVER(PARTITION BY user_id ORDER BY tweet_date) as row
FROM tweets)
select user_id, tweet_date,
CASE
WHEN row = 1 THEN ROUND(tweet_count*1.00,2)
WHEN row = 2 THEN ROUND((tweet_count+tweet_count_1)*1.00/2,2)
else round((tweet_count_1+tweet_count_2+tweet_count)*1.00/3,2)
END as rolling_avg_3d
FROM twts;
--EX6
WITH payments AS (
  SELECT 
    merchant_id, 
    EXTRACT(EPOCH FROM transaction_timestamp - 
      LAG(transaction_timestamp) OVER(
        PARTITION BY merchant_id, credit_card_id, amount 
        ORDER BY transaction_timestamp)
    )/60 AS minute_difference 
  FROM transactions) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10;
--EX7
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
--EX8
WITH top_10_cte AS (
  SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;
