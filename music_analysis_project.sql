-- 1. List all artists for each record label sorted by artist name.
select l.name as label  , a.name as artist 
  from record_label as l join artist as a on l.id = a.record_label_id
  order by a.name ;

-- 2. Which record labels have no artists? 

select name as lable from record_label where id not in 
(select distinct record_label_id from artist) ;


 -- 3. List the number of songs per artist in descending order
 
 select artist_name , count(*) as number_of_song from 
( select a.name  as artist_name  , ab.id  
 from artist as a join album as ab on a.id = ab.artist_id ) as a 
 join song as s on a.id = s.album_id 
 group by artist_name
 order by number_of_song desc ;
 
 -- 4. Which artist or artists have recorded the most number of songs?
 
  select artist_name , count(*) as number_of_song from 
( select a.name  as artist_name  , ab.id  
 from artist as a join album as ab on a.id = ab.artist_id ) as a 
 join song as s on a.id = s.album_id 
 group by artist_name
 order by number_of_song desc  limit 1 ;
 
-- 5. Which artist or artists have recorded the least number of songs?

with cte as 
 ( select artist_name , count(*) as number_of_song from 
( select a.name  as artist_name  , ab.id  
 from artist as a join album as ab on a.id = ab.artist_id ) as a 
 join song as s on a.id = s.album_id 
 group by artist_name ) 
 
 select artist_name from (
 select artist_name , dense_rank() over(order by  number_of_song) as dr 
 from cte ) as a where dr =1  ;



-- 6. How many artists have recorded the least number of songs?
with cte as 
 ( select artist_name , count(*) as number_of_song from 
( select a.name  as artist_name  , ab.id  
 from artist as a join album as ab on a.id = ab.artist_id ) as a 
 join song as s on a.id = s.album_id 
 group by artist_name ) 
 
 select count(*) as number_of_artist_with_least_song from (
 select artist_name , dense_rank() over(order by  number_of_song) as dr 
 from cte ) as a where dr =1  ; 
 
 -- 7. which artists have recorded songs longer than 5 minutes, and how many songs was that?

select a.name as artist  , count(*) as number_of_songs_with_duration_more_then_5  
from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id 
where duration > 5 
group by a.name  ;

-- 8. for each artist and album how many songs were less than 5 minutes long?
select a.name as artist  ,ab.name as ablum , count(*) as number_of_songs_with_duration_more_then_5  
from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id 
where duration  < 5 
group by a.name  , ab.name ;

-- 9. in which year or years were the most songs recorded?
select year , count(*) as num_of_song
from album as a join song as s on a.id = s.album_id
group by year 
order by num_of_song desc limit 1  ;

 -- 10. list the artist, song and year of the top 5 longest recorded songs
 select a.name as artist  , s.name as song_name , year as year_of_release , duration song_duration
 from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id 
order by duration desc limit 5  ; 

-- 11. Number of albums recorded for each year
select year as release_year  , count(*) as number_of_song
from song as s join album as a on s.album_id = a.id 
group by release_year ;

-- 12. What is the max number of recorded albums across all the years?
select year as release_year  , count(*) as number_of_song
from song as s join album as a on s.album_id = a.id 
group by release_year
order by  number_of_song desc limit 1 ;


-- 14. total duration of all songs recorded by each artist in descending order

 select a.name as artist  , sum(duration) as total_duration 
 from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id 
group by   a.name 
order by total_duration desc   ; 

-- 15. for which artist and album are there no songs less than 5 minutes long?

with cte as 
(select  a.id as a_id  , ab.id as ab_id 
from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id 
where duration <  5 ) 

select  a.name  , ab.name  
from artist as a join 
album as ab on a.id = ab.artist_id 
where ( a.id  , ab.id ) not in (select * from cte ) ;

-- 16. Display a table of all artists, albums, songs and song duration
--     all ordered in ascending order by artist, album and song 
select  a.name as artist_name   , ab.name as album_name , s.name as song_name  , duration   
from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id   
order by artist_name , album_name , song_name
;


-- 17. List the top 3 artists with the longest average song duration, in descending with longest average first.
select  a.name as artist_name   , round(avg(duration),2)  as avg_song_duration 
from artist as a join 
album as ab on a.id = ab.artist_id 
join song as s on s.album_id = ab.id  
group by   a.name
order by avg_song_duration desc 
limit 3 
;
 
-- 18. Total album length for all songs on the Beatles Sgt. Pepper's album - in minutes and seconds.
select a.name 
, floor(sum(duration)) as minutes , round(mod(sum(duration)*60 , 60 )) as seconds 
from song as s join album as a on a.id = s.album_id where a.name like 'Sgt. Pepper%'
group by a.name  ; 

-- 19. Which artists did not release an album during the decades of the 1980's and the 1990's?

select distinct a.name  as artist_name 
from album as  ab join artist as a on ab.artist_id = a.id 
where year not  between 1980 and 1990 
order by  artist_name ; 

-- 20. Which artists did release an album during the decades of the 1980's and the 1990's? 
select distinct a.name  as artist_name 
from album as  ab join artist as a on ab.artist_id = a.id 
where year   between 1980 and 1990 
order by  artist_name

