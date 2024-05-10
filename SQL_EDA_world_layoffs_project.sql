-- Exploratory Data Analysis (EDA)

/*This project utilizes SQL to analyze data on employee layoffs within a company. 
Here we are going to explore the data and find trends or patterns or anything interesting like outliers. 
One will gain experience in:

•	Identifying trends and patterns in workforce data.
•	Communicating data-driven insights and recommendations.*/

-- ========================================================================================================================== --


-- This query retrieves the data of a table.

Select *
from layoffs_staging2;



/*This query provides you to find the peak instance of employee layoffs within the timeframe covered by the data.
This can indicate the most severe period of workforce reduction.*/

Select MAX(total_laid_off)
from layoffs_staging2;



/*This query provides you to find the highest number of employees laid off within a dataset 
when the percentage of employee layoffs is 100%*/
 
Select MAX(total_laid_off) 
from layoffs_staging2
where percentage_laid_off =1;



-- Looking at Percentage to see how big these layoffs were

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;



/*This query provides you to find the specific layoffs 
where 1 (representing 100%) of employees were laid off from a company 
where the entire workforce was laid off.*/

Select *
from layoffs_staging2
where percentage_laid_off =1
order by total_laid_off desc;



-- This query provides you to find the date range of employee layoffs in the given data.

Select min(`date`), max(`date`)
from layoffs_staging2;



/*This query provides you to find the total number of employees laid off at each company and 
shows which companies experienced the most overall layoffs.*/

Select Company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

/*This query provides you to find the total number of employees laid off within each industry sector and 
shows which industries experienced the most overall layoffs.*/

Select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;



/*This query provides you to find the total number of employees laid off within each country and 
shows which countries experienced the most overall layoffs.*/

Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;



/*This query groups layoffs by the year they occurred and 
calculates the total number of employees laid off for each year.*/

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;



-- The given SQL query provides insights into layoff trends monthly within your dataset.

select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 2 desc;



/*This query shows the accumulation of layoffs over time.
Rolling Total of Layoffs Per Month with CTE*/

with Rolling_Total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;



-- This query shows which companies had the most layoffs in a particular year.

Select Company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;



-- This query identifies the companies with the top 5 highest layoff totals within each year.

with company_year(company, years, total_laid_off) as 
(
Select Company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from Company_Year_Rank
where ranking <= 5;



























