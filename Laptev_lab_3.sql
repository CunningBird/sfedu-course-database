--1
SELECT DISTINCT full_name, job_title
FROM employee
         JOIN job USING (job_code)
WHERE salary < 50000;

--2
SELECT proj_name, salary as team_leader_salary
FROM project
         LEFT JOIN employee ON (team_leader = emp_no);

--3
SELECT d.*
from department d
         JOIN employee e ON (d.mngr_no = e.emp_no)
WHERE e.salary > 70000;

--4
SELECT e.full_name, e.phone_ext, e.salary, d.department
from department d
         JOIN employee e ON (d.mngr_no = e.emp_no);

--5
SELECT sh.*
from salary_history sh
         JOIN department d ON (d.mngr_no = sh.emp_no)
WHERE d.department = 'Field Office: East Coast';

--6
SELECT s.po_number, s.total_value, co.currency
FROM sales s
         LEFT JOIN customer c ON (s.cust_no = c.cust_no)
         LEFT JOIN country co ON (c.country = co.country);

--7
SELECT s.po_number, e.job_country as emp_country
FROM sales s
         LEFT JOIN employee e ON (s.sales_rep = e.emp_no);

--8
SELECT e.full_name, e.salary
FROM employee e
         JOIN employee_project ep ON (e.emp_no = ep.emp_no)
         JOIN project p ON (ep.proj_id = p.proj_id)
WHERE p.proj_name = 'Video Database'
ORDER BY e.salary DESC;

--9
SELECT COUNT(DISTINCT e.emp_no) AS count_of_sales_representative
FROM employee e
         JOIN job j ON (e.job_code = j.job_code)
WHERE j.job_title = 'Sales Representative';



