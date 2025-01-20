USE imdb;


/*  1.	Find the total number of rows in each table of the schema  */


SELECT 'director_mapping' as Tablename,count(*)as Totalrows from director_mapping
union all
SELECT 'genre' as Tablename,count(*)as Totalrows from genre
union all
SELECT 'movie' as Tablename,count(*)as Totalrows from movie
union all
SELECT 'names' as Tablename,count(*)as Totalrows from names
union all
SELECT 'ratings' as Tablename,count(*)as Totalrows from ratings
union all
SELECT 'role_mapping' as Tablename,count(*)as Totalrows from role_mapping;



/*  2.	Which columns in the movie table have null values?  */


SELECT 'id' AS table_name, COUNT(*) AS null_count_id FROM movie WHERE id IS NULL
UNION ALL
SELECT 'title' AS table_name, COUNT(*) AS null_count_title FROM movie WHERE title IS NULL
UNION ALL
SELECT 'year' AS table_name, COUNT(*) AS null_count_year FROM movie WHERE year IS NULL
UNION ALL
SELECT 'date_published' AS table_name, COUNT(*) AS null_count_date_published FROM movie WHERE date_published IS NULL
UNION ALL
SELECT 'duration' AS table_name, COUNT(*) AS null_count_duration FROM movie WHERE duration IS NULL
UNION ALL
SELECT 'country' AS table_name, COUNT(*) AS null_count_country FROM movie WHERE country IS NULL
UNION ALL
SELECT 'worlwide_gross_income' AS table_name, COUNT(*) AS null_count_worlwide_gross_income FROM movie WHERE worlwide_gross_income IS NULL
UNION ALL
SELECT 'languages' AS table_name, COUNT(*) AS null_count_languages FROM movie WHERE languages IS NULL
UNION ALL
SELECT 'production_company' AS table_name, COUNT(*) AS null_count_production_company FROM movie WHERE production_company IS NULL;



/*  3.	Find the total number of movies released each year. How does the trend look month-wise?  */


SELECT year AS release_year, COUNT(*) AS total_movies
FROM movie
GROUP BY release_year
ORDER BY release_year;

SELECT month(date_published) AS Month, COUNT(*) AS Total_movies
FROM movie
GROUP BY month 
ORDER BY month;



/*  4.	How many movies were produced in the USA or India in the year 2019? */


select year, country, count(*) as Total_movies from movie
where country in ('USA','India') and year = 2019
group by country;



/*  5.	Find the unique list of genres present in the dataset and how many movies belong to only one genre.  */


select distinct genre from genre;

select count(movie_id) as Single_genre_movies
from (
   select movie_id, count(genre) as number_of_movies
   from genre
   group by movie_id
   having count(genre) = 1 
) as Single_genre_movies;



/*  6.	Which genre had the highest number of movies produced overall?  */


select genre, count(movie_id) as Number_of_movies
from genre 
group by genre
order by number_of_movies desc
limit 1;



/*  7.	What is the average duration of movies in each genre?  */


select g.genre, avg(m.duration) as Average_duration 
from genre g 
join movie m on m.id = g.movie_id
group by genre
order by average_duration desc;



/*  8.	Identify actors or actresses who have worked in more than three movies with an average rating below 5?  */


select n.name, count(ro.movie_id) as Low_rated_movies
from names n 
join role_mapping ro on ro.name_id = n.id
join ratings ra on ra.movie_id = ro.movie_id
where ra.avg_rating < 5
group by ro.name_id
having count(ro.movie_id) > 3
order by Low_rated_movies desc;



/*  9.	Find the minimum and maximum values in each column of the ratings table except the movie_id column.  */


select min(avg_rating) as min_rating, max(avg_rating) as max_rating,
       min(total_votes) as min_votes, max(total_votes) as max_votes,
       min(median_rating) as min_median_rating, max(median_rating) as max_median_rating
from ratings;



/*  10.	 Which are the top 10 movies based on average rating?  */


select m.title, r.avg_rating
from movie m
join ratings r on r.movie_id = m.id
order by r.avg_rating desc
limit 10;



/*  11.	Summarise the ratings table based on the movie counts by median ratings.  */


select median_rating, count(movie_id) as moviecounts
from ratings
group by median_rating
order by median_rating asc;



/*  12.	How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?  */


select g.genre, count(r.movie_id) as Totalmovies
from genre g 
join ratings r on r.movie_id = g.movie_id 
join movie m on m.id = r.movie_id
where m.date_published between '2017-03-01' and '2017-03-31'
and m.country = 'USA'and r.total_votes > 1000
group by genre
order by Totalmovies desc;



/*  13.	Find movies of each genre that start with the word ‘The ’ and which have an average rating > 8.  */


select g.genre, m.title, r.avg_rating
from genre g 
join movie m on m.id = g.movie_id
join ratings r on r.movie_id = m.id
where m.title like 'The %' and r.avg_rating > 8
order by g.genre;



/*  14.	Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?  */


select count(r.movie_id) as Totalmovies
from ratings r 
join movie m on m.id = r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01'
and median_rating = 8;



/*  15.	Do German movies get more votes than Italian movies? */


select m.country, sum(r.total_votes) as totalvotes 
from movie m 
join ratings r on r.movie_id = m.id
where m.country in ('Germany','Italy')
group by m.country;



/*  16.	Which columns in the names table have null values?  */


select 'id' as id, count(*) as null_id from names where id is null
union all
select 'name' as name, count(*) as null_name from names where name is null
union all
select 'height' as height, count(*) as null_height from names where height is null
union all
select 'date_of_birth' as date_of_birth, count(*) as null_date_of_birth from names where date_of_birth is null
union all
select 'known_for_movies' as known_for_movies, count(*) as null_known_for_movies from names where known_for_movies is null;



/*  17.	Who are the top two actors whose movies have a median rating >= 8?  */


select n.name, count(*) as totalmovies
from names n
join role_mapping ro on ro.name_id = n.id
join ratings ra on ra.movie_id = ro.movie_id
where ro.category = 'actor' and ra.median_rating >= 8
group by n.name
order by totalmovies desc 
limit 2;



/*  18.	Which are the top three production houses based on the number of votes received by their movies?  */


select m.production_company, sum(total_votes) as Totalvotes
from movie m 
join ratings r on r.movie_id = m.id
group by m.production_company
order by Totalvotes desc 
limit 3;



/*  19.	How many directors worked on more than three movies?  */


select n.name, count(n.id) as Total_movies
from names n
join director_mapping d on d.name_id = n.id
group by n.name
having count(d.movie_id) > 3
order by Total_movies desc;



/*  20.	Find the average height of actors and actresses separately.  */


select r.category, round(avg(n.height),2) as Average_height
from role_mapping r
join names n on n.id = r.name_id 
group by r.category
order by Average_height desc;



/*  21.	Identify the 10 oldest movies in the dataset along with its title, country, and director.  */


select m.title, m.country, n.name as director_name, m.date_published
from movie m
join director_mapping d on d.movie_id = m.id
join names n on n.id = d.name_id
order by m.date_published asc, m.country
limit 10;



/*  22.	List the top 5 movies with the highest total votes and their genres.  */


select m.title, g.genre, r.total_votes
from movie m
join genre g on g.movie_id = m.id
join ratings r on r.movie_id = g.movie_id
order by genre, total_votes desc 
limit 5;



/*  23.	Find the movie with the longest duration, along with its genre and production company.  */


select m.title, m.duration, g.genre, m.production_company
from movie m
join genre g on g.movie_id = m.id 
order by duration desc
limit 1;



/*  24.	Determine the total votes received for each movie released in 2018.  */


select m.title, sum(r.total_votes) as total_votes
from movie m
join ratings r on r.movie_id = m.id
where m.year = 2018
group by m.title
order by total_votes desc;



/*  25.	Find the most common language in which movies were produced.  */


select languages, count(id) as Total_movies
from movie
group by languages
order by total_movies desc
limit 1;