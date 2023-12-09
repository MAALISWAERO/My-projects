CREATE TABLE apple_store_description_combined As
SELECT* from appleStore_description1
UNION ALL
SELECT* from appleStore_description2
UNION ALL
SELECT* from appleStore_description3
UNION ALL
SELECT* from appleStore_description4;
Select * from apple_store_description_combined;
SELECT * from AppleStore;

** Exploratory Data Analysis **
--Now, we have two tables
--To check the number of unique apps in both tables 
SELECT  count(DISTINCT id) as unique_ids from AppleStore ;
SELECT  count(DISTINCT id) as unique_ids froM apple_store_description_combined;

--check for missing values in key fieds
SELECT COUNT(*) as Missing_values from AppleStore where track_name is null or 
user_rating is NULL or prime_genre is null ;
SELECT COUNT(*) as Missing_values from apple_store_description_combined where app_desc is null;

-- find out the number of apps per genre-
SELECT prime_genre, COUNT(*) as Numapps
from AppleStore
GROUP by prime_genre order by Numapps Desc;

-- get an overview of apps rating
SELECT min(user_rating) as Min_rating,
       max(user_rating) as Max_rating,
       avg(user_rating) as Avg_rating
from AppleStore;

**Data analysis**

--  whether the paids have higher rating than free apps 


SELECT case 
           when price > 0 then "Paid"
           else "Free" 
           End as app_type,
           avg(user_rating)
           from AppleStore
           Group by app_type;
           
 -- check if apps with more supported languages have higher languages
 select case 
  when lang_num < 10 then " <10 languges"
  when lang_num BETWEEN 10 and 30 then "10-30 languges"
       Else ">30 languges"
       End as Languges,
       avg(user_rating) as avg_ratings
       FROM AppleStore
       Group by Languges order by avg_ratings desc
       
   
       -- check genre with low ratings
 SELECT prime_genre, avg(user_rating) as avg_rating
 from AppleStore
 group by prime_genre order by  avg_rating
 LIMIT 10;
           
           
-- check whether their is correlation between length of the app decription and user rating      
SELECT case 
           when length(b.app_desc)< 500 then "Short"
           When length (b.app_desc) BETWEEN 500 and 1000 then "Medium"        
           Else "Long"
           End as length_app_desc,
           avg(a.user_rating) as avg_rating
from 
     AppleStore as a
JOIN
     apple_store_description_combined as b
ON 
     a.id = b.id           
Group by length_app_desc
Order by  avg_rating desc


-- chcek the top rated apps divided by each genre
SELECT
prime_genre, track_name, user_rating 
From ( SELECT
      prime_genre, track_name, user_rating,
      RANK() OVER(PARTITION by prime_genre ORDER by user_rating desc , rating_count_tot desc ) rank 
       From  AppleStore ) as a
where a.rank = 1