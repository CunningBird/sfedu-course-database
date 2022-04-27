--1
SELECT c.country, COUNT(cu.cust_no) AS count_of_customers, SUM(s.total_value) as total_value
FROM country c
         LEFT JOIN customer cu ON (cu.country = c.country)
         LEFT JOIN sales s ON (cu.cust_no = s.cust_no)
GROUP BY c.country;

--2
SELECT d.department, e.full_name AS manager, COUNT(ee.emp_no) AS employee_count
FROM department d
         LEFT JOIN employee e ON (d.mngr_no = e.emp_no)
         LEFT JOIN employee ee ON (ee.dept_no = d.dept_no)
GROUP by d.department, manager;

--3
SELECT j.job_title, j.job_country, j.job_grade, COUNT(e.emp_no) as emp_count, AVG(e.salary) AS avg_salary
FROM job j
         LEFT JOIN employee e
                   ON (j.job_code = e.job_code) AND (j.job_grade = e.job_grade) AND (j.job_country = e.job_country)
GROUP by j.job_title, j.job_country, j.job_grade;

--4
select g.nomenclature, gwh.quantity, g.measure
FROM goods g
         JOIN goods_wh gwh ON (g.id_goods = gwh.id_goods)
         JOIN warehouse w ON (w.id_wh = gwh.id_wh)
where w.name = 'Склад 2';

--5
SELECT o.op_date,
       CASE
           WHEN o.typeop = 'A' THEN 'привозили'
           WHEN o.typeop = 'R' THEN 'увозили'
           END              AS type,
       w.name               as wh_name,
       a.name_ag,
       o.price * o.quantity AS total_value
FROM operation o
         JOIN warehouse w ON (w.id_wh = o.id_wh)
         JOIN agent a ON (o.id_ag = a.id_ag)
         JOIN goods g ON (g.id_goods = o.id_goods)
where g.nomenclature = 'Тетрадь 12л.';

--7
SELECT g.nomenclature,
       a.name_ag,
       o.op_date,
       CASE
           WHEN o.typeop = 'A' THEN 'привозили'
           WHEN o.typeop = 'R' THEN 'увозили'
           END              AS type,
       w.name               as wh_name,
       o.quantity,
       o.price,
       o.price * o.quantity AS total_value
FROM operation o
         JOIN warehouse w ON (w.id_wh = o.id_wh)
         JOIN agent a ON (o.id_ag = a.id_ag)
         JOIN goods g ON (g.id_goods = o.id_goods)
where EXTRACT(year from o.op_date) = 2007
  and EXTRACT(month from o.op_date) < 5;

--8
SELECT a.name_ag, g.nomenclature, SUM(o.quantity) AS quantity, g.measure
FROM agent a
         LEFT join operation o ON (o.id_ag = a.id_ag)
         left JOIN goods g ON (o.id_goods = g.id_goods)
group BY a.name_ag, g.nomenclature, g.measure;

--9
SELECT a.name_ag, MIN(o.quantity * o.price) as min_value
FROM agent a
         LEFT join operation o ON (o.id_ag = a.id_ag)
group BY a.name_ag;
--10
SELECT w.name, g.nomenclature, SUM(gwh.quantity) as total_quantity, g.measure
FROM warehouse w
         LEFT join goods_wh gwh on (w.id_wh = gwh.id_wh)
         LEFT JOIN goods g ON (g.id_goods = gwh.id_goods)
GROUP BY w.name, g.nomenclature, g.measure;

