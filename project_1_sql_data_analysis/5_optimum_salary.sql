/*
    What are the most optimal skills to learn? Optimal: High Demand AND High Paying
    Identify the skill in high demand and associated with high average salaries for Data analyst roles
    Concentrates on remote positions with specified salaries
    Why? Targets skills that offers job security (high demand) and financial benefits (high salaries) ,
        offering strategic insights for career developement in data analytics

*/

WITH skills_in_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills AS skills,
        COUNT(skills_job_dim.job_id) AS skills_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), high_pay_skills AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_in_demand.skill_id,
    skills_in_demand.skills,
    skills_count,
    avg_salary
FROM skills_in_demand
INNER JOIN high_pay_skills ON skills_in_demand.skill_id = high_pay_skills.skill_id
ORDER BY
    skills_count DESC,
    avg_salary DESC
LIMIT 25