select 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT (MONTH FROM job_posted_date) AS date_month,
    EXTRACT (YEAR FROM job_posted_date) AS date_year
FROM
job_postings_fact;

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
    WHERE job_title_short = 'Data Analyst'
    GROUP BY month
    ORDER BY job_posted_count desc;


SELECT
    job_schedule_type,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary_year,
    AVG(job_postings_fact.salary_hour_avg) AS avg_salary_hour
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) >= 6 
  AND EXTRACT(YEAR FROM job_posted_date) >= 2023
GROUP BY job_schedule_type;

SELECT 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_posting_count
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY month
ORDER BY month;

-- Create table for January 2023 jobs 
CREATE TABLE jan_2023_jobs AS 
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 1 AND EXTRACT(YEAR FROM job_posted_date) = 2023;
 -- Create table for February 2023 jobs 
 CREATE TABLE feb_2023_jobs AS 
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 2 AND EXTRACT(YEAR FROM job_posted_date) = 2023;
 -- Create table for March 2023 jobs 
 CREATE TABLE mar_2023_jobs AS 
    SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 3 AND EXTRACT(YEAR FROM job_posted_date) = 2023;


SELECT 
   COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY location_category
;

SELECT *
from  (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS jobs_january;

with january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    )

    SELECT *
    from january_jobs;

    SELECT 
        company_id,
        name as company_name
    from company_dim 
    WHERE company_id IN (
        SELECT company_id
        FROM job_postings_fact
        where job_no_degree_mention = true
        ORDER BY company_id
    )

select *
from top_skills
order BY top_skills.skill_num desc
limit 5;

with top_skills AS (
    SELECT skill_id, COUNT(skill_id) as skill_num
    FROM skills_job_dim
    GROUP BY skill_id
)

SELECT *
from skills_dim join top_skills ON top_skills.skill_id = skills_dim.skill_id
order BY top_skills.skill_num desc
limit 5
;


SELECT 
    sd.skill_name,
    COUNT(sjd.skill_id) AS skill_count
FROM 
    skills_job_dim sjd
JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
GROUP BY 
    sd.skill_name
ORDER BY 
    skill_count DESC
LIMIT 5;

SELECT
    skill_id,
    COUNT(skill_id) AS times_appeared
FROM 
    skills_job_dim
GROUP BY 
    skill_id
ORDER BY 
    times_appeared DESC;




SELECT
    company_id,
    company_name,
    job_count,
    CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM (
    SELECT 
        company_id,
        COUNT(job_id) AS job_count
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
) AS company_job_counts
JOIN
    company_dim USING (company_id)
ORDER BY
    job_count DESC;


with job_count AS (
    SELECT 
        company_id,
        COUNT(job_id) AS job_count
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
order BY job_count desc
)

SELECT
    company_id,
    company_name,
    job_count,
    CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category

