--1
SELECT COUNT(c.customer) as count_of_costomers, c.country
FROM customer c
GROUP by c.country;

--2
SELECT EXTRACT(year FROM e.hire_date) as hire_year, e.job_code, COUNT(e.emp_no) as count_of_employees
FROM employee e
GROUP BY EXTRACT(year FROM e.hire_date), e.job_code;

--3
SELECT EXTRACT(year FROM e.hire_date) as hire_year, COUNT(e.emp_no) as count_of_eng
from employee e
WHERE e.job_code = 'Eng'
GROUP BY hire_year;

--4
SELECT p.dept_no, p.fiscal_year, SUM(p.projected_budget) as total_budget
FROM proj_dept_budget p
GROUP BY p.dept_no, p.fiscal_year;

--5
SELECT e.dept_no, SUM(e.salary) AS sum_salary, AVG(e.salary) AS avg_salary
FROM employee e
GROUP BY e.dept_no;

--6
SELECT SUBSTRING(e.full_name FROM 1 FOR 1) as first_symbol, COUNT(e.emp_no) AS count_of_employees
from employee e
group BY first_symbol;

--7
SELECT e.dept_no
FROM employee e
GROUP BY e.dept_no
HAVING COUNT(e.emp_no) <= 2;
