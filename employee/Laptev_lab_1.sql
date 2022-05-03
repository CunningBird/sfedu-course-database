-- Выдать информацию обо всех отделениях, расположенных в Monterey
SELECT *
FROM department d
WHERE d.location = 'Monterey';

-- Выдать информацию обо всех отделениях, входящих в отдел номер 110
SELECT *
FROM department d
WHERE d.head_dept = 110;

-- Получить список названий работ, предлагаемых в Японии, указать квалификацию и диапазон оплаты
SELECT j.job_title, j.min_salary, j.max_salary, j.job_grade
FROM job j
WHERE j.job_country = 'Japan';

-- Найти сотрудников, которые поступили на работу с 1992 по 1995 год
SELECT *
FROM employee e
WHERE EXTRACT(YEAR FROM e.hire_date) BETWEEN 1992 AND 1995;

-- Выдать список заказов, сидка на которые больше 20%
SELECT *
FROM sales s
WHERE s.discount > 0.2;

-- Найти сотрудников, у которых оклад от 100000 до 150000, упорядочив его по дате поступления на работу
SELECT *
FROM employee e
WHERE e.salary >= 100000
  AND e.salary <= 150000
ORDER BY e.hire_date;

-- Для заданного проекта (MKTPR) вычислить его суммарный бюджет в 1995 году
SELECT SUM(p.projected_budget) AS total_budget
FROM proj_dept_budget p
WHERE p.proj_id = 'MKTPR'
  AND p.fiscal_year = 1995;

-- Вычислить суммарную стоимость заказов, сделанных в 1992 году
SELECT SUM(s.total_value) AS total_sum
FROM sales s
WHERE EXTRACT(YEAR FROM s.order_date) = 1992;

-- Выдать среднюю, минимальную и максимальную зарплату сотрудников указанного отдела (125)
SELECT MIN(e.salary) AS min_salary, AVG(e.salary) AS average_salary, MAX(e.salary) AS max_salary
FROM employee e
WHERE e.dept_no = '125';

-- Найти номера заказов, у которых отсутствует дата SHEEP_DATE, выдать для них состояние заказа и признак «оплачен»
SELECT s.po_number, s.order_status, s.paid
FROM sales s
WHERE s.ship_date IS NULL;