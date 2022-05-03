-- Для каждой страны определить количество заказчиков, находящихся в этой стране
SELECT COUNT(c.customer) as count_of_costomers, c.country
FROM customer c
GROUP by c.country;

-- Для каждого года и каждой должности определить, сколько сотрудников было принято на работу в фирму на эту должность и в этом году
SELECT EXTRACT(year FROM e.hire_date) as hire_year, e.job_code, COUNT(e.emp_no) as count_of_employees
FROM employee e
GROUP BY EXTRACT(year FROM e.hire_date), e.job_code;

-- Для каждого года определить, сколько инженеров было принято на работу в этом году
SELECT EXTRACT(year FROM e.hire_date) as hire_year, COUNT(e.emp_no) as count_of_eng
from employee e
WHERE e.job_code = 'Eng'
GROUP BY hire_year;

-- Вывести суммарный бюджет всех проектов для каждого отдела за конкретный год
SELECT p.dept_no, p.fiscal_year, SUM(p.projected_budget) as total_budget
FROM proj_dept_budget p
GROUP BY p.dept_no, p.fiscal_year;

-- Для каждого отдела вычислить суммарную и среднюю зарплату сотрудников
SELECT e.dept_no, SUM(e.salary) AS sum_salary, AVG(e.salary) AS avg_salary
FROM employee e
GROUP BY e.dept_no;

-- Сгруппировать список сотрудников по первой букве (функция SUBSTRING()) в поле FIRST_NAME и указать для каждой буквы количество сотрудников
SELECT SUBSTRING(e.full_name FROM 1 FOR 1) as first_symbol, COUNT(e.emp_no) AS count_of_employees
from employee e
group BY first_symbol;

-- Найти отделы, в которых работает не больше чем 2 сотрудника. Для проверки сформировать список этих сотрудников
SELECT e.dept_no
FROM employee e
GROUP BY e.dept_no
HAVING COUNT(e.emp_no) <= 2;
