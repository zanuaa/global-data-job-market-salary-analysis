select * from ds_salaries;

-- 1. Check if there is any null data
select * from ds_salaries
where work_year is null
	or experience_level is null
	or employment_type is null
	or job_title is null
	or salary is null
	or salary_currency is null
	or salary_in_usd is null
	or employee_residence is null
	or remote_ratio is null
	or company_location is null
	or company_size is null;

-- 2. check what job titles are available
select distinct job_title
from ds_salaries
order by job_title; 


-- 3. What job titles are related to data analyst
select distinct job_title
from ds_salaries
where job_title like '%Data Analyst%' or job_title like '%Data Analytics%'
order by job_title;

-- 4. What is the average salary of the job?
select 
	job_title,
	experience_level,
	round(avg(salary_in_usd * 15000)/12,2) as avg_monthly_salary_in_rupiah
from ds_salaries
where job_title like '%Analyst%' or job_title like '%Analytics%'
group by job_title, experience_level
order by avg_monthly_salary_in_rupiah;

-- 5. Countries with attractive salaries for data analysts, full time, and 
-- experience levels Entry Level (EN) and Medium (Mi)
select 
    company_location,
    round(avg(salary_in_usd *15000)/12,2) as avg_salary
from ds_salaries
where job_title like '%Analyst%' and employment_type = 'FT' and experience_level in ('MI','EN')
group by company_location
having round(avg(salary_in_usd *15000)/12,2) > 50000000
order by avg_salary desc;

-- 6. In which year does the salary increase from MID to EX
-- have the highest raise for full-time positions related to data analysis?
with ds_1 as (
	select 	
		work_year,
		round(avg(salary_in_usd * 15000)/12,2) as avg_salary_ex_IDR
	from ds_salaries
	where employment_type = 'FT'
		and experience_level = 'EX'
        and job_title like '%Data Analyst%'
	group by work_year
), 
ds_2 as (
	select 	
		work_year,
		round(avg(salary_in_usd * 15000)/12,2) as avg_salary_mid_IDR
	from ds_salaries
	where employment_type = 'FT'
		and experience_level = 'MI'
        and job_title like '%Data Analyst%'
	group by work_year
), t_year as (
	select distinct work_year
    from ds_salaries
) 
select 
	y.work_year,
    d1.avg_salary_ex_IDR,
    d2.avg_salary_mid_IDR,
	round((d1.avg_salary_ex_IDR - d2.avg_salary_mid_IDR),2) as differences
from t_year y 
left join ds_1 d1 on y.work_year = d1.work_year
left join ds_2 d2 on y.work_year = d2.work_year;

