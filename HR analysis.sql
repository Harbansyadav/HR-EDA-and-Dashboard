
-- 1. What is the gender breakdown of employees in the company?
select gender,count(*) as Gcount
from hrdata 
where termdate = '0-0-0'
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race,count(*) as racecount
from hrdata 
where termdate = '0-0-0'
group by race;


-- 3. What is the age distribution of employees in the company?

select min(age),max(age) from hrdata;
select case
	when age >= 18 and age<=20 then '18-20'
    when age >= 21 and age<=24 then '21-24'
    when age >= 25 and age<=28 then '25-28'
    when age >= 29 and age<=31 then '29-31'
    else '32+'
    end as age_group,gender,
    count(*) Agecount
from hrdata
where termdate = '0-0-0'
group by age_group
order by age_group;    


-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) As locunt
from hrdata
where termdate = '000-00-00'
group by location;


-- 5. What is the average length of employment for employees who have been terminated?
select round(avg(datediff(termdate,hire_date))/365,0) As Avg_Employment
from hrdata
where termdate <= curdate() and termdate <> '0000-00-00';

-- 6. How does the gender distribution vary across departments and job titles?
select department,gender, count(*) As Count
from hrdata
where termdate = '0-0-0'
group by department
order by department;


-- 7. What is the distribution of job titles across the company?
select jobtitle, count(*) As Jobtitlecount
from hrdata
where termdate = '0-0-0'
group by jobtitle
order by jobtitle desc;


-- 8. Which department has the highest turnover rate?
select department, total_count,terminated_count,
terminated_count/total_count As termination_rate from(
select department,count(*) as total_count,
sum(case when termdate <> '0-0-0' and termdate <= curdate() then 1 else 0 end) As terminated_count
from hrdata
group by department) As subqery  order by termination_rate desc;

-- 9. What is the distribution of employees across locations by city and state?
select location_state, count(*) as locount
from hrdata
where termdate = '0-0-0'
group by location_state
order by locount desc;


-- 10. How has the company's employee count changed over time based on hire and term dates?
select year, hires,termination, hires-termination as net_change,
round((hires-termination)/hires * 100,2) as net_change_percent
	from(
			select year(hire_date) as year,
            count(*) as hires,
            sum(case when termdate <> '0-0-0' and termdate <>curdate() then 1 else 0 end)as termination
            from hrdata 
            group by year(hire_date)
		) as subqery
order by year asc;


-- 11. What is the tenure distribution for each department?
select department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hrdata
where termdate <> '0-0-0' and termdate <= curdate()
group by department; 