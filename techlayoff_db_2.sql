-- Here we are jsut going to explore the data and 
-- find trends or patterns or anything interesting like outliers

-- In this part, we will do some analysis.. Let's start
select * from layoffs_renew_1;


SELECT MAX(total_laid_off)
from layoffs_renew_1;

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_renew_1
WHERE  percentage_laid_off IS NOT NULL;

-- if we order by funcs_raised_millions we can see how big 
-- some of these companies were

SELECT *
FROM layoffs_renew_1
WHERE  percentage_laid_off = 1
ORDER BY funds_raised DESC;


-- Companies with the most Total Layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_renew_1
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_renew_1
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;



-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year.


WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_renew_1
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



