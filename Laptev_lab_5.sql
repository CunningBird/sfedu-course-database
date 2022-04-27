--1
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

--2
SELECT a.DEPARTMENT
FROM DEPARTMENT a
WHERE a.BUDGET > (SELECT b.BUDGET
                  FROM DEPARTMENT b
                  WHERE b.DEPT_NO = 130)
  AND NOT a.DEPT_NO = 130;

--3
SELECT e.full_name
from employee e
where e.job_country = 'USA'
  and e.salary > (select avg((j.max_salary + j.min_salary) / 2)
                  from job j
                  where j.job_country = 'USA'
                    and j.job_code = e.job_code
                    and j.job_grade = e.job_grade);

--4
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


--5
select (select g.nomenclature
        from goods g
        where g.id_goods = gwh.id_goods) as nomenclature,
       (select w.town
        from warehouse w
        where w.id_wh = gwh.id_wh)       as town
FROM goods_wh gwh;

--6
select (select a.name_ag
        from agent a
        where a.id_ag = o.id_ag) as ag
FROM operation o
where o.id_goods = (select g.id_goods
                    from goods g
                    where g.nomenclature = '�����');

--7
select (select a.name_ag
        from agent a
        where a.id_ag = o.id_ag) as ag
FROM operation o
where o.id_wh = (select w.id_wh
                 from warehouse w
                 where w.name = '����� 1')
group by o.id_ag
having count(distinct o.id_goods) > 1;

--8
SELECT oo.op_date,
       (select a.name_ag
        from agent a
        where a.id_ag = oo.id_ag) as ag
FROM operation oo
WHERE oo.id_goods = (select g.id_goods
                     from goods g
                     where g.nomenclature = '�����')
  AND oo.price < (SELECT AVG(o.price)
                  FROM operation o
                  where o.id_goods = (select g.id_goods
                                      from goods g
                                      where g.nomenclature = '�����'));