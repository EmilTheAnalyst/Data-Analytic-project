select * from layoffs_renew;

-- we create new table because if we make wrong, we can fix easily or delete table and we will
-- work in  this new table, not main table 

CREATE TABLE `layoffs_renew_1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` bigint DEFAULT NULL,
  `row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- When we are data cleaning, these steps must be followed
-- 1) checking duplicates
-- 2) standardıze data and fıx errors
-- 3) searching null values and see them 
-- 4) remove columns and rows which are not necessary 


select * from layoffs_renew_1;

-- Remove duplicates

insert into layoffs_renew_1
select *, Row_number() over(partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs_renew;

select * from layoffs_renew_1
where `row_number` > 1;

-- Disable safe updates
SET SQL_SAFE_UPDATES = 0;

-- Run your delete statement
DELETE FROM layoffs_renew_1
WHERE `row_number` > 1;

-- Standarizing data


update layoffs_renew_1
set company = trim(company);

update layoffs_renew_1
set industry = trim(company);


select distinct industry, trim(trailing ".com" from industry) as fixing_data,
replace(industry, ".", " ") as fixing_data_2
from  layoffs_renew_1
where industry like "%com%";

update layoffs_renew_1
set industry =  trim(trailing ".com" from industry),
industry = replace(industry, ".", " ");


select  distinct location from layoffs_renew_1 
order by 1;

update layoffs_renew_1
set country = trim(country);

update layoffs_renew_1
set `date` = replace(`date`, ".", "-");

select `date`, date_format(`date`, '%m-%d-%Y')
from layoffs_renew_1; -- instead of this we can write also like this 



UPDATE layoffs_renew_1
SET `date` = STR_TO_DATE(`date`, '%d-%m-%Y');

alter table  layoffs_renew_1
modify column `date` date;

select * from layoffs_renew_1
where industry is Null or industry = " ";

select * from layoffs_renew_1
where company = "Airbnb";

update layoffs_renew_1
set industry = "Travel"
where company = "Airbnb";

select * from layoffs_renew_1 t1 
join layoffs_renew_1 t2 on t1.company = t2.company
and t1.location = t2.location
where t1.industry is null 
and t2.industry is not null;

update layoffs_renew_1 t1
join layoffs_renew_1 t2 
on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null and
t2.industry is not null; 


select * from layoffs_renew_1
where total_laid_off is null and 
percentage_laid_off is null;


delete from layoffs_renew_1
where  total_laid_off is null and 
percentage_laid_off is null;

alter table layoffs_renew_1 drop column `row_number`;


select * from layoffs_renew_1;
 

select max(`date`) from layoffs_renew_1






