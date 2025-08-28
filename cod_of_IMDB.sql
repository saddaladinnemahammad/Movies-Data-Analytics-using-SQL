USE imdb;

-- Before you proceed to solve the assignment, it is a good practice to know what the data values in each table are.



-- Similarly, Write queries to see data values from all tables 


-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------


/* To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movie' and 'genre' tables. */

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
WITH row_counts AS (
    SELECT
        (SELECT COUNT(*) FROM movie) AS movie_row_count,
        (SELECT COUNT(*) FROM names) AS names_row_count,
        (SELECT COUNT(*) FROM director_mapping) AS director_map_row_count,
        (SELECT COUNT(*) FROM genre) AS genre_row_count,
        (SELECT COUNT(*) FROM ratings) AS ratings_row_count,
        (SELECT COUNT(*) FROM role_mapping) AS role_mapping_row_count
)
SELECT * FROM row_counts;

--Here most of the large data of rows contain from names.it has contain 25735 rows of data

-- Similarly, write queries to find the total number of rows in each table

-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2. Which columns in the 'movie' table have null values?
-- Type your code below:

-- Solution 1
SELECT 
    COUNT(*) AS title_nulls
FROM
    movie
WHERE title IS NULL;

SELECT 
    COUNT(*) AS year_nulls
FROM
    movie
WHERE year IS NULL;

-- These two SQL queries are designed to identify data quality issues in the movie table by counting how many records are missing critical fields


-- Similarly, write queries to find the null values of remaining columns in 'movie' table 
WITH null_counts AS (
    SELECT
        (SELECT COUNT(*) FROM movie WHERE id IS NULL) AS id_null,
        (SELECT COUNT(*) FROM movie WHERE title IS NULL) AS title_null,
        (SELECT COUNT(*) FROM movie WHERE year IS NULL) AS year_null,
        (SELECT COUNT(*) FROM movie WHERE date_published IS NULL) AS date_published_null,
        (SELECT COUNT(*) FROM movie WHERE duration IS NULL) AS duration_null,
        (SELECT COUNT(*) FROM movie WHERE country IS NULL) AS country_null,
        (SELECT COUNT(*) FROM movie WHERE worlwide_gross_income IS NULL) AS wwg_income_null,
        (SELECT COUNT(*) FROM movie WHERE languages IS NULL) AS languages_null,
        (SELECT COUNT(*) FROM movie WHERE production_company IS NULL) AS production_null
)
SELECT * FROM null_counts;

-- Solution 2
SELECT 
    COUNT(CASE
        WHEN title IS NULL THEN id
    END) AS title_nulls,
    COUNT(CASE
        WHEN year IS NULL THEN id
    END) AS year_nulls
    
     -- Add the case statements for the remaining columns
     WITH null_counts AS (
    SELECT
        COUNT(CASE WHEN id IS NULL THEN id END) AS id_null,
        COUNT(CASE WHEN title IS NULL THEN id END) AS title_null,
        COUNT(CASE WHEN year IS NULL THEN id END) AS year_null,
        COUNT(CASE WHEN date_published IS NULL THEN id END) AS date_published_null,
        COUNT(CASE WHEN duration IS NULL THEN id END) AS duration_null,
        COUNT(CASE WHEN country IS NULL THEN id END) AS country_null,
        COUNT(CASE WHEN worlwide_gross_income IS NULL THEN id END) AS wwg_income_null,
        COUNT(CASE WHEN languages IS NULL THEN id END) AS languages_null,
        COUNT(CASE WHEN production_company IS NULL THEN id END) AS production_null
    FROM movie
)
SELECT * FROM null_counts;
    
/* In Solution 2 above, id in each case statement has been used as a counter to count the number of null values. Whenever a value
   is null for a column, the id increments by 1. */

/* There are 20 nulls in country; 3724 nulls in worlwide_gross_income; 194 nulls in languages; 528 nulls in production_company.
   Notice that we do not need to check for null values in the 'id' column as it is a primary key.*/

-- As you can see, four columns of the 'movie' table have null values. Let's look at the movies released in each year. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------

-- Q3.1 Find the total number of movies released in each year.

/* Output format :

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	   2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+ */


-- Hint: Utilize the COUNT(*) function to count the number of movies.
-- Hint: Use the GROUP BY clause to group the results by the 'year' column.

-- Type your code below:

SELECT year,
    COUNT(*) AS total_movies
FROM
    movie
WHERE
    year IS NOT NULL
GROUP BY
    year
ORDER BY
    year
 
 




-- Q3.1 How does the trend look month-wise? (Output expected) 




/* Output format :
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	  1			|	    134			|
|	  2			|	    231			|
|	  .			|		 .			|
+---------------+-------------------+ */

-- Type your code below:
SELECT
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    date_published IS NOT NULL
GROUP BY
    MONTH(date_published)
ORDER BY
    month_num;
    select*from movie

/* The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the
'movies' table. 
We know that USA and India produce a huge number of movies each year. Lets find the number of movies produced by USA
or India in the last year. */
  
  -- ---------------------------------------------------------------------------------------------------------------------------------------------------
  
-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Hint: Use the LIKE operator to filter countries containing 'USA' or 'India'.

/* Output format

+---------------+
|number_of_movies|
+---------------+
|	  -		     |  */

-- Type your code below:
select count(*) as num_of_movies from movie
where year=2019 and (country like '%usa%' or country like '%india%')





/* USA and India produced more than a thousand movies (you know the exact number!) in the year 2019.
Exploring the table 'genre' will be fun, too.
Let’s find out the different genres in the dataset. */

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Q5. Find the unique list of the genres present in the data set?

/* Output format
+---------------+
|genre|
+-----+
|  -  |
|  -  |
|  -  |  */

-- Type your code below:
 select distinct genre 
 from genre 
 where genre is not null 
 order by genre




/* So, RSVP Movies plans to make a movie on one of these genres.
Now, don't you want to know in which genre were the highest number of movies produced?
Combining both the 'movie' and the 'genre' table can give us interesting insights. */

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6.Which genre had the highest number of movies produced overall?

-- Hint: Utilize the COUNT() function to count the occurrences of movie IDs for each genre.
-- Hint: Group the results by the 'genre' column using the GROUP BY clause.
-- Hint: Order the results by the count of movie IDs in descending order using the ORDER BY clause.
-- Hint: Use the LIMIT clause to restrict the result to only the top genre with the highest movie count.


/* Output format
+-----------+--------------+
|	genre	|	movie_count|
+-----------+---------------
|	  -		|	    -	   |

+---------------+----------+ */

-- Type your code below:
SELECT top 1 genre, COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC

select*from movie
select*from genre


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q7. How many movies belong to only one genre?

-- Hint: Utilize a Common Table Expression (CTE) named 'movie_genre_summary' to summarize genre counts per movie.
-- Hint: Use the COUNT() function along with GROUP BY to count the number of genres for each movie.
-- Hint: Employ COUNT(DISTINCT) to count movies with only one genre.

/* Output format
+------------------------+
|single_genre_movie_count|
+------------------------+
|           -            |*/

-- Type your code below:

WITH movie_genre_summary AS (
    SELECT movie_id, COUNT(genre) AS genre_count
    FROM genre
    GROUP BY movie_id
)
SELECT COUNT(*) AS movies_with_one_genre
FROM movie_genre_summary
WHERE genre_count = 1;
    

/* There are more than three thousand movies which have only one genre associated with them.
This is a significant number.
Now, let's find out the ideal duration for RSVP Movies’ next project.*/

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

-- Hint: Utilize a LEFT JOIN to combine the 'genre' and 'movie' tables based on the 'movie_id'.
-- Hint: Specify table aliases for clarity, such as 'g' for 'genre' and 'm' for 'movie'.
-- Hint: Employ the AVG() function to calculate the average duration for each genre.
-- Hint: GROUP BY the 'genre' column to calculate averages for each genre.


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    AVG(cast(m.duration as int)) AS avg_duration
FROM 
    genre g
LEFT JOIN 
    movie m ON g.movie_id = m.id
GROUP BY 
    g.genre;

-- here we have observe mostly action based genres are more to see like by people based on the data.
--And also morethan 10 movies outof 13 have contain avg_duration




/* Note that using an outer join is important as we are dealing with a large number of null values. Using
   an inner join will slow down query processing. */

/* Now you know that movies of genre 'Drama' (produced highest in number in 2019) have an average duration of
106.77 mins.
Let's find where the movies of genre 'thriller' lie on the basis of number of movies.*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------


    
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

-- Hint: Use a Common Table Expression (CTE) named 'summary' to aggregate counts of movie IDs for each genre.
-- Hint: Utilize the COUNT() function along with GROUP BY to count the number of movie IDs for each genre.
-- Hint: Implement the RANK() function to assign a rank to each genre based on movie count.
-- Hint: Employ LOWER() function to ensure case-insensitive comparison.


/* Output format:
+---------------+-------------------+---------------------+
|   genre		|	 movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|   -	    	|	   -			|			-		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:

WITH summary AS (
    SELECT 
        LOWER(g.genre) AS genre,
        COUNT(g.movie_id) AS movie_count
    FROM 
        genre g
    GROUP BY 
        LOWER(g.genre)
),
ranked_genres AS (
    SELECT 
        genre,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
    FROM 
        summary
)
SELECT 
    genre,
    movie_count,
    genre_rank
FROM 
    ranked_genres
WHERE 
    genre = 'thriller';




-- Thriller movies are in the top 3 among all genres in terms of the number of movies.

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* In the previous segment, you analysed the 'movie' and the 'genre' tables. 
   In this segment, you will analyse the 'ratings' table as well.
   To start with, let's get the minimum and maximum values of different columns in the table */

-- Segment 2:

-- Q10.  Find the minimum and maximum values for each column of the 'ratings' table except the movie_id column.

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- Type your code below:


    -- Type your code below to display remaining columns
    
  with min_max_ratings as(
  select min(avg_rating) as min_avg_rating,
         max(avg_rating) as max_avg_rating ,
         min(total_votes) as min_total_votes,
         max(total_votes) as max_total_votes ,
         min(median_rating) as min_median_ratings, 
         max(median_rating) as max_median_ratings 
  from ratings)
select*from min_max_ratings

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating. */

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Hint: Use a Common Table Expression (CTE) named 'top_movies' to calculate the average rating for each movie and assign a rank.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Implement the AVG() function to calculate the average rating for each movie.
-- Hint: Use the ROW_NUMBER() function along with ORDER BY to assign ranks to movies based on average rating, ordered in descending order.

/* Output format:
+---------------+-------------------+---------------------+
|     title		|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
|     Fan		|		9.6			|			5	  	  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
WITH top_movies AS (
  SELECT 
    m.title,
    AVG(r.avg_rating) AS avg_ratings,
    dense_rank() OVER (ORDER BY AVG(r.avg_rating) DESC) AS movie_rank
  FROM movie m
  LEFT JOIN ratings r ON m.id = r.movie_id
  GROUP BY m.id, m.title
)select top 10 * from top_movies
where movie_rank<=10




-- It's okay to use RANK() or DENSE_RANK() as well.

/* Do you find the movie 'Fan' in the top 10 movies with an average rating of 9.6? If not, please check your code
again.
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight. */

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q12. Summarise the ratings table based on the movie counts by median ratings.(order by median_rating)

/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select median_rating, count(median_rating) as movie_count from ratings group by median_rating order by median_rating





/* Movies with a median rating of 7 are the highest in number. 
Now, let's find out the production house with which RSVP Movies should look to partner with for its next project.*/

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- Q13. Which production house has produced the most number of hit movies (average rating > 8)?

-- Hint: Use a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on movie count.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Exclude NULL production company values using IS NOT NULL in the WHERE clause.


/* Output format:
+------------------+-------------------+----------------------+
|production_company|    movie_count	   |    prod_company_rank |
+------------------+-------------------+----------------------+
|           	   |		 		   |			 	  	  |
+------------------+-------------------+----------------------+*/

-- Type your code below:
WITH top_prod AS (
  SELECT movie.production_company, COUNT(*) AS movie_count
  FROM movie
  LEFT JOIN ratings ON movie.id = ratings.movie_id
  WHERE movie.production_company IS NOT NULL AND ratings.avg_rating > 8
  GROUP BY movie.production_company
)
select production_company,movie_count ,dense_rank() over(order by movie_count desc) as prod_comp_rank from top_prod order by movie_count desc




-- It's okay to use RANK() or DENSE_RANK() as well.
-- The answer can be either Dream Warrior Pictures or National Theatre Live or both.

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q14. How many movies released in each genre in March 2017 in the USA had more than 1,000 votes?(Split the question into parts and try to understand it.)

-- Hint: Utilize INNER JOINs to combine the 'genre', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Use the WHERE clause to apply filtering conditions based on year, month, country, and total votes.
-- Hint: Extract the month from the 'date_published' column using the MONTH() function.
-- Hint: Employ LOWER() function for case-insensitive comparison of country names.
-- Hint: Utilize COUNT() function along with GROUP BY to count movies in each genre.


/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */


-- Type your code below:
SELECT g.genre, COUNT(*) AS movie_count
FROM genre as g
INNER JOIN movie as m ON g.movie_id = m.id
INNER JOIN ratings as r ON g.movie_id = r.movie_id
WHERE YEAR(m.date_published) = 2017
  AND MONTH(m.date_published) = 3
  AND LOWER(m.country) = 'usa'
  AND r.total_votes > 1000
GROUP BY g.genre;








-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lets try analysing the 'imdb' database using a unique problem statement.

-- Q15. Find the movies in each genre that start with the characters ‘The’ and have an average rating > 8.

-- Hint: Utilize INNER JOINs to combine the 'movie', 'genre', and 'ratings' tables based on their relationships.
-- Hint: Apply filtering conditions in the WHERE clause using the LIKE operator for the 'title' column and a condition for 'avg_rating'.
-- Hint: Use the '%' wildcard appropriately with the LIKE operator for pattern matching.


/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:

SELECT 
  g.genre,
  m.title,
  AVG(r.avg_rating) AS average_rating
FROM movie AS m
INNER JOIN genre AS g ON m.id = g.movie_id
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
GROUP BY g.genre,m.title;



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- You should also try out the same for median rating and check whether the ‘median rating’ column gives any
-- significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- Hint: Use an INNER JOIN to combine the 'movie' and 'ratings' tables based on their relationship.
-- Hint: Pay attention to the date format for the BETWEEN operator and ensure it matches the format of the 'date_published' column.

/* Output format
+---------------+
|movie_count|
+-----------+
|     -     |  */

-- Type your code below:
SELECT COUNT(*) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND r.median_rating = 8;





-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Now, let's see the popularity of movies in different languages.


-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.

/* Output format:
+---------------------------+---------------------------+
| german_votes_per_movie	|	italian_votes_per_movie	|
+---------------------------+----------------------------
|	-	                    |		    -   			|
|	.			            |		.	        		|
+---------------------------+---------------------------+ */

-- Type your code below:
SELECT
  AVG(CASE WHEN LOWER(m.country) = 'germany' THEN r.total_votes END) AS german_votes_per_movie,
  AVG(CASE WHEN LOWER(m.country) = 'italy' THEN r.total_votes END) AS italian_votes_per_movie
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE LOWER(m.country) IN ('germany', 'italy');





-- Answer is Yes


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Now that you have analysed the 'movie', 'genre' and 'ratings' tables, let us analyse another table - the 'names'
table. 
Let’s begin by searching for null values in the table. */

-- Segment 3:

-- Q18. Find the number of null values in each column of the 'names' table, except for the 'id' column.

/* Hint: You can find the number of null values for individual columns or follow below output format

+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

-- Type your code below
SELECT
  COUNT(*) - COUNT(name) AS name_nulls,
  COUNT(*) - COUNT(height) AS height_nulls,
  COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
  COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;



-- Solution 2
-- use case statements to write the query to find null values of each column in names table
-- Hint: Refer question 2

-- Type your code below 
with cte as(
       select COUNT(CASE WHEN name IS NULL THEN id END) AS name_null,
        COUNT(CASE WHEN height IS NULL THEN id END) AS hight_null,
        COUNT(CASE WHEN date_of_birth IS NULL THEN id END) AS dob_null,
         COUNT(CASE WHEN known_for_movies IS NULL THEN id END) AS kfm__null  from names) select *from cte


    


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

-- Q19. Who are the top two actors whose movies have a median rating >= 8?

-- Hint: Utilize INNER JOINs to combine the 'names', 'role_mapping', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating and category.
-- Hint: Group the results by the actor's name using GROUP BY.
-- Hint: Utilize aggregate functions such as COUNT() to count the number of movies each actor has participated in.


/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christian Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:


SELECT top  2 n.name AS actor_name , COUNT(*) AS movie_count
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movie m ON rm.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = 'actor'
  AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC







/* Did you find the actor 'Mohanlal' in the list? If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q20. Which are the top three production houses based on the number of votes received by their movies?

-- Hint: Use a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on total votes.
-- Hint: Utilize a LEFT JOIN to combine the 'movie' and 'ratings' tables based on 'id' and 'movie_id' respectively.
-- Hint: Filter out NULL production company values using IS NOT NULL in the WHERE clause.
-- Hint: Utilize the SUM() function to calculate the total votes for each production company.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to production companies based on total votes, ordered in descending order.
-- Hint: Limit the number of results to the top 3 using ROW_NUMBER() and WHERE clause.


/* Output format:
+-------------------+-------------------+---------------------+
|production_company |   vote_count		|	prod_comp_rank    |
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|		.		      |
|	.				|		.			|		.		  	  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:
WITH top_prod AS (
  SELECT 
    m.production_company,
    count(r.total_votes) AS total_votes,
    ROW_NUMBER() OVER (ORDER BY SUM(r.total_votes) DESC) AS rank
  FROM movie m
  LEFT JOIN ratings r ON m.id = r.movie_id
  WHERE m.production_company IS NOT NULL
  GROUP BY m.production_company
)
SELECT production_company, total_votes,rank
FROM top_prod
WHERE rank <= 3;










-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Q21.Find the top five actresses in Hindi movies released in India based on their average ratings.
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker.)

-- Hint: Utilize a Common Table Expression (CTE) named 'actress_ratings' to aggregate data for actresses based on specific criteria.
-- Hint: Use INNER JOINs to combine the 'names', 'role_mapping', 'movie', and 'ratings' tables based on their relationships.
-- Hint: Consider which columns are necessary for the output and ensure they are selected in the SELECT clause.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for category and language.
-- Hint: Utilize aggregate functions such as SUM() and COUNT() to calculate total votes, movie count, and average rating for each actress.
-- Hint: Use GROUP BY to group the results by actress name.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to actresses based on average rating and total votes, ordered in descending order.
-- Hint: Specify the condition for selecting actresses with at least 3 movies using a WHERE clause.
-- Hint: Limit the number of results to the top 5 using LIMIT.


/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH actress_ratings AS (
  SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(*) AS movie_count,
    ROUND(SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER (
      ORDER BY 
        SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes) DESC,
        SUM(r.total_votes) DESC
    ) AS actress_rank
  FROM names n
  JOIN role_mapping rm ON n.id = rm.name_id
  JOIN movie m ON rm.movie_id = m.id
  JOIN ratings r ON m.id = r.movie_id
  WHERE rm.category = 'actress'
    AND m.country = 'India'
    AND m.languages = 'Hindi'
  GROUP BY n.name
  HAVING COUNT(*) >= 3
)
SELECT *
FROM actress_ratings
WHERE actress_rank <= 5;











-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Now let us divide all the thriller movies in the following categories and find out their numbers.
    /* Q22. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
       the following categories: 
			    Rating > 8: Superhit
			    Rating between 7 and 8: Hit
			    Rating between 5 and 7: One-time-watch
			    Rating < 5: Flop   */
            
    -- Hint: Utilize LEFT JOINs to combine the 'movie', 'ratings', and 'genre' tables based on their relationships.
    -- Hint: Use the CASE statement to categorize movies based on their average rating into 'Superhit', 'Hit', 'One time watch', and 'Flop'.
    -- Hint: Implement logical conditions within the CASE statement to define the movie categories based on rating ranges.
    -- Hint: Apply filtering conditions in the WHERE clause to select movies with a specific genre ('thriller') and a total vote count exceeding 25000.
    -- Hint: Utilize the LOWER() function to ensure case-insensitive comparison of genre names.

    /* Output format :

    +-------------------+-------------------+
    |   movie_name	    |	movie_category  |
    +-------------------+--------------------
    |	Pet Sematary	|	One time watch	|
    |       -       	|		.			|
    |	    -   		|		.			|
    +---------------+-------------------+ */


-- Type your code below:
SELECT 
  m.title,
  CASE
    WHEN r.avg_rating > 8 THEN 'Superhit'
    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
    WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One time watch'
    ELSE 'Flop'
  END AS movie_category
FROM movie m
LEFT JOIN ratings r ON m.id = r.movie_id
LEFT JOIN genre g ON m.id = g.movie_id
WHERE LOWER(g.genre) = 'thriller'
  AND r.total_votes >= 25000;











-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Let us find the top 5 movies for each year with the top 3 genres.

-- Q23. Which are the five highest-grossing movies in each year for each of the top three genres?
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH top_genres AS (
  SELECT top 3 genre
  FROM genre
  GROUP BY genre
  ORDER BY COUNT(*) DESC
),
ranked_movies AS (
  SELECT 
    g.genre,
    m.year,
    m.title,
    m.worlwide_gross_income,
    ROW_NUMBER() OVER (
      PARTITION BY g.genre, m.year
      ORDER BY m.worldwide_gross_income DESC
    ) AS movie_rank
  FROM movie m
  JOIN genre g ON m.id = g.movie_id
  WHERE g.genre IN (SELECT genre FROM top_genres)
)
SELECT *
FROM ranked_movies
WHERE movie_rank <= 5;






-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Finally, let’s find out the names of the top two production houses that have produced the highest number of hits
   among multilingual movies.
   
Q24. What are the top two production houses that have produced the highest number of hits (median rating >= 8) among
multilingual movies? */
-- Hint: Utilize a Common Table Expression (CTE) named 'top_prod' to find the top production companies based on movie count.
-- Hint: Use a LEFT JOIN to combine the 'movie' and 'ratings' tables based on their relationship.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating, production company existence, and language specification.
-- Hint: Utilize aggregate functions such as COUNT() to count the number of movies for each production company.
-- Hint: Implement the ROW_NUMBER() function along with ORDER BY to assign ranks to production companies based on movie count, ordered in descending order.
-- Hint: Apply filtering conditions in the WHERE clause using logical conditions for median rating, production company existence, and language specification.
-- Hint: Limit the number of results to the top 2 using ROW_NUMBER() and WHERE clause.
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0.
-- If there is a comma, that means the movie is of more than one language.


/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:

WITH top_prod AS (
    SELECT 
        m.production_company,
        COUNT(*) AS movie_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
    FROM movie AS m
    JOIN ratings AS r ON m.id = r.movie_id
    WHERE r.median_rating >= 8
      AND m.production_company IS NOT NULL
      AND CHARINDEX(',', m.languages) > 0   -- multilingual check
    GROUP BY m.production_company
)
SELECT production_company, movie_count, prod_comp_rank
FROM top_prod
WHERE prod_comp_rank <= 2;











-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (average rating > 8) in 'drama' genre?

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH drama_superhit_actresses AS (
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating
    FROM movie AS m
    JOIN ratings AS r ON m.id = r.movie_id
    JOIN genre AS g ON m.id = g.movie_id
    JOIN role_mapping AS rm ON m.id = rm.movie_id
    JOIN names AS n ON rm.name_id = n.id
    WHERE g.genre = 'Drama'
      AND r.avg_rating > 8
      AND rm.category = 'actress'
    GROUP BY n.name
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (ORDER BY movie_count DESC, actress_avg_rating DESC) AS actress_rank
FROM drama_superhit_actresses
WHERE movie_count > 0
ORDER BY actress_rank
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------


