-- Выдать список сотрудников, работающих в Канаде и Англии с указанием их оклада.
-- Привести для справки максимальную и минимальную оплату для сотрудников в этих странах
select e.full_name,
       e.salary,
       (SELECT MAX(ee.salary)
        FROM employee ee
        WHERE ee.job_country = e.job_country)  as max_salary,
       (SELECT MIN(eee.salary)
        FROM employee eee
        WHERE eee.job_country = e.job_country) as min_salary
FROM employee e

WHERE e.job_country = 'England'
   or e.job_country = 'Canada';

-- Выдать названия отделов, бюджет которых, выше бюджета отдела номер 130
SELECT a.DEPARTMENT
FROM DEPARTMENT a
WHERE a.BUDGET > (SELECT b.BUDGET
                  FROM DEPARTMENT b
                  WHERE b.DEPT_NO = 130)
  AND NOT a.DEPT_NO = 130;

-- Вывести список сотрудников из USA, оплата у которых выше средней оплаты по той работе, которую они выполняют
-- (среднюю считать исходя из диапазона оплаты в таблице JOB)
SELECT e.full_name
from employee e
where e.job_country = 'USA'
  and e.salary > (select avg((j.max_salary + j.min_salary) / 2)
                  from job j
                  where j.job_country = 'USA'
                    and j.job_code = e.job_code
                    and j.job_grade = e.job_grade);

-- Для каждого проекта указать, какие отделы принимали участие в его выполнении в 1994 году и руководителей этих отделов.
-- Для проектов, которые не выполнялись в 1994 году вместо названия отдела указать null
SELECT P.PROJ_NAME, T.DEPT_NAME, T.mngr_name
FROM PROJECT P
         LEFT JOIN
     (SELECT PD.PROJ_ID, D.DEPARTMENT, full_name
      FROM PROJ_DEPT_BUDGET PD
               JOIN DEPARTMENT D
                    ON (PD.DEPT_NO = D.DEPT_NO)
               join employee on d.mngr_no = emp_no
      WHERE PD.FISCAL_YEAR = 1994)
         AS T (PROJ_ID, DEPT_NAME, mngr_name)
     ON (P.PROJ_ID = T.PROJ_ID);