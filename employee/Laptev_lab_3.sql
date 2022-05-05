-- Выдать список сотрудников, оклад которых ниже 50000, указав наименование их работы
SELECT DISTINCT full_name, job_title
FROM employee
         JOIN job USING (job_code)
WHERE salary < 50000;

-- Для каждого проекта выдать зарплату руководителя этого проекта
SELECT proj_name, salary as team_leader_salary
FROM project
         LEFT JOIN employee ON (team_leader = emp_no);

-- Вывести список отделов, зарплата руководителей которых выше 70000
SELECT d.*
from department d
         JOIN employee e ON (d.mngr_no = e.emp_no)
WHERE e.salary > 70000;

-- Выдать список руководителей отделов с указанием их номера телефона и оклада
SELECT e.full_name, e.phone_ext, e.salary, d.department
from department d
         JOIN employee e ON (d.mngr_no = e.emp_no);

-- Выдать историю изменения оплаты начальника отдела Field Office: East Coast
SELECT sh.*
from salary_history sh
         JOIN department d ON (d.mngr_no = sh.emp_no)
WHERE d.department = 'Field Office: East Coast';

-- Для каждого заказа выдать стоимость заказа и наименование валюты страны, где расположен заказчик
SELECT s.po_number, s.total_value, co.currency
FROM sales s
         JOIN customer c ON (s.cust_no = c.cust_no)
         JOIN country co ON (c.country = co.country);

-- Для каждого заказа указать страну, в которой находится сотрудник, оформлявший договор-заказ
SELECT s.po_number, e.job_country as emp_country
FROM sales s
         JOIN employee e ON (s.sales_rep = e.emp_no);

-- Выдать список сотрудников, работающих над проектом Video Database, с указанием их оклада, отсортировав список по убыванию оклада
SELECT e.full_name, e.salary
FROM employee e
         JOIN employee_project ep ON (e.emp_no = ep.emp_no)
         JOIN project p ON (ep.proj_id = p.proj_id)
WHERE p.proj_name = 'Video Database'
ORDER BY e.salary DESC;

-- Найти число сотрудников, работающих на должности Sales Representative
SELECT COUNT(DISTINCT e.emp_no) AS count_of_sales_representative
FROM employee e
         JOIN job j ON (e.job_code = j.job_code)
WHERE j.job_title = 'Sales Representative';



