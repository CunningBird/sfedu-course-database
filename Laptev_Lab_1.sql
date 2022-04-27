-- 1
SELECT *
FROM department d
WHERE d.location = 'Monterey';

--2
SELECT *
FROM department d
WHERE d.head_dept = 110;

--3
SELECT j.job_title, j.min_salary, j.max_salary, j.job_grade
FROM job j
WHERE j.job_country = 'Japan';

--4
SELECT *
FROM employee e
WHERE EXTRACT(YEAR FROM e.hire_date) BETWEEN 1992 AND 1995;

--5
SELECT *
FROM job j
WHERE j.max_salary < 150000;

--6
SELECT *
FROM sales s
WHERE s.discount > 0.2;

--7
SELECT *
FROM employee e
WHERE e.salary >= 100000
  AND e.salary <= 150000
ORDER BY e.hire_date;

--8
SELECT SUM(p.projected_budget) AS total_budget
FROM proj_dept_budget p
WHERE p.proj_id = 'MKTPR'
  AND p.fiscal_year = 1995;

--9
SELECT SUM(s.total_value) AS total_sum
FROM sales s
WHERE EXTRACT(YEAR FROM s.order_date) = 1992;

--10
SELECT MIN(e.salary) AS min_salary, AVG(e.salary) AS average_salary, MAX(e.salary) AS max_salary
FROM employee e
WHERE e.dept_no = '125';

--11
SELECT s.po_number, s.order_status, s.paid
FROM sales s
WHERE s.ship_date IS NULL;