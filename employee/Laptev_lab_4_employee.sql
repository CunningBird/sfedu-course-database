-- Для каждой страны из справочника COUNTRY.
-- Указать количество заказчиков из этой страны и суммарную стоимость заказов, сделанных ими
SELECT c.country, COUNT(cu.cust_no) AS count_of_customers, SUM(s.total_value) as total_value
FROM country c
         LEFT JOIN customer cu ON (cu.country = c.country)
         LEFT JOIN sales s ON (cu.cust_no = s.cust_no)
GROUP BY c.country;

-- Для каждого отдела выдать руководителя отдела и количество сотрудников в отделе
SELECT d.department, e.full_name AS manager, COUNT(ee.emp_no) AS employee_count
FROM department d
         LEFT JOIN employee e ON (d.mngr_no = e.emp_no)
         LEFT JOIN employee ee ON (ee.dept_no = d.dept_no)
GROUP by d.department, manager;

-- Для каждой вакансии (должность, страна, квалификация).
-- Выдать количество сотрудников, работающих на данной должности, и их средний оклад
SELECT j.job_title, j.job_country, j.job_grade, COUNT(e.emp_no) as emp_count, AVG(e.salary) AS avg_salary
FROM job j
         LEFT JOIN employee e
                   ON (j.job_code = e.job_code) AND (j.job_grade = e.job_grade) AND (j.job_country = e.job_country)
GROUP by j.job_title, j.job_country, j.job_grade;