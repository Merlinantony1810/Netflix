-- Netflix Project
--creaing 
Drop table if exists Netflix;
Create table Netflix
(
    show_id VARCHAR(6),
    type_mo varchar(10),
	title varchar(150),
	director varchar(250),
	casts varchar(1000),
	country	varchar(150),
	date_added varchar(50),
	release_year int,	
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100)
);
select * from Netflix;

select count(*) from Netflix;

--1.Which countries produce the most Netflix content?

SELECT country, COUNT(*) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;

--2.What's the distribution of Movies vs TV Shows on Netflix?

SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

--3. Is Netflix adding more content now than before?

SELECT release_year, COUNT(*) AS total_released
FROM netflix
GROUP BY release_year
ORDER BY release_year;

--4. Which directors are frequently featured?

SELECT director, COUNT(*) AS num_shows
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY num_shows DESC
LIMIT 10;


--5.What are the most common genre?

SELECT listed_in, COUNT(*) AS genre_count
FROM netflix
GROUP BY listed_in
ORDER BY total DESC
LIMIT 10;

--6. What's the average duration of Netflix movies?

SELECT 
  type_mo,
  AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_movie_duration
FROM netflix
WHERE type = 'Movie'
  AND duration ~ '^[0-9]+'
  group by type




--7.What are the oldest and newest shows on Netflix?

SELECT title, release_year
FROM netflix
ORDER BY release_year ASC
LIMIT 5;

-- Newest
SELECT title, release_year
FROM netflix
ORDER BY release_year DESC
LIMIT 5;

--8.Which countries produce the most TV Shows?

SELECT country, COUNT(*) AS total_tv
FROM netflix
WHERE type = 'TV Show'
AND country IS NOT NULL
GROUP BY country
ORDER BY total_tv DESC
LIMIT 10;


-- 9.Which TV shows have the most seasons or longest duration?
SELECT 
  title,
  CAST(SPLIT_PART(duration, ' ', 1) AS INT) AS seasons
FROM netflix
WHERE type = 'TV Show'
ORDER BY seasons DESC
LIMIT 10;

--10.What genres do top directors work with the most?

WITH genre_directors AS (
  SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    director
  FROM netflix
  WHERE director IS NOT NULL AND listed_in IS NOT NULL
)
SELECT 
  TRIM(genre) AS genre,
  director,
  COUNT(*) AS works
FROM genre_directors
GROUP BY genre, director
ORDER BY works DESC
LIMIT 20;

--12. Which directors have the most titles on Netflix?

SELECT 
  director,
  COUNT(*) AS total_titles,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS director_rank
FROM netflix
WHERE director IS NOT NULL
GROUP BY director;

--13.How many titles were released each year, and how does the total grow over time?

SELECT 
  release_year,
  COUNT(*) AS yearly_releases,
  SUM(COUNT(*)) OVER (ORDER BY release_year) AS cumulative_total
FROM netflix
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

--14. Create a view of the top 10 countries by content volume
CREATE VIEW top_countries AS
SELECT 
  country,
  COUNT(*) AS title_count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY title_count DESC
LIMIT 10;

SELECT * FROM top_countries;

-- 15. Can we create a reusable function to get the total number of titles released in a given year?

CREATE OR REPLACE FUNCTION get_titles_by_year(p_year INT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM netflix
    WHERE release_year = p_year;
    
    RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT get_titles_by_year(2020);  -- returns number of titles released in 2020

--16. Which year had the highest number of new shows added to Netflix, and what were the top 5 titles added that year?
WITH yearly_counts AS (
  SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Mon DD, YYYY')) AS year_added,
    COUNT(*) AS total_titles
  FROM netflix
  WHERE date_added IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM TO_DATE(date_added, 'Mon DD, YYYY'))
),
max_year AS (
  SELECT year_added
  FROM yearly_counts
  ORDER BY total_titles DESC
  LIMIT 1
)
SELECT title, date_added
FROM netflix
WHERE EXTRACT(YEAR FROM TO_DATE(date_added, 'Mon DD, YYYY')) = (SELECT year_added FROM max_year)
ORDER BY date_added
LIMIT 5;

--17.Which movies have the longest duration on Netflix?

SELECT title, duration
FROM netflix
WHERE type = 'Movie'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) = (
    SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INT))
    FROM netflix
    WHERE type = 'Movie'
  );

--18. Create a stored function to return the number of movies a given actor has appeared in on Netflix.
CREATE OR REPLACE FUNCTION count_actor_movies(actor_name TEXT)
RETURNS INTEGER AS $$
DECLARE
  movie_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO movie_count
  FROM netflix
  WHERE type_mo = 'Movie'
    AND casts ILIKE '%' || actor_name || '%';

  RETURN movie_count;
END;
$$ LANGUAGE plpgsql;

SELECT count_actor_movies('Salman Khan');-- example actor













