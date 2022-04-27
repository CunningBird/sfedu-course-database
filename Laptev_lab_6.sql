--1
select a.name_ag
from operation o
         join goods g using (id_goods)
         join agent a using (id_ag)
where g.nomenclature = '�����';

--2
select g.nomenclature
FROM goods g
         left JOIN operation o ON (g.id_goods = o.id_goods)
where o.id is NULL
group by g.nomenclature;

--3
select a.name_ag
from operation o
         join agent a using (id_ag)
where o.id = '1';

--4
select a.name_ag
FROM operation o
         JOIN agent a ON (o.id_ag = a.id_ag)
WHERE o.typeop = 'A'
  and o.price = (select MIN(o.price)
                 FROM operation o
                          join goods g ON (o.id_goods = g.id_goods)
                 where g.nomenclature = '���������(10 ��)')
group by a.name_ag;

--5
select w.name
from warehouse w
         left join operation o using (id_wh)
where o.id is null;

--6
select a.name_ag, count(w.name)
from operation o
         join agent a using (id_ag)
         join warehouse w using (id_wh)
group by a.name_ag
having count(w.name) > '1';

--7
SELECT g.nomenclature
FROM operation o
         JOIN goods g ON (g.id_goods = o.id_goods)
where o.typeop = 'A'
GROUP BY g.nomenclature
HAVING COUNT(o.id) = 1;

--8
select g.nomenclature
from operation o
         join goods g using (id_goods)
         join agent a using (id_ag)
where a.name_ag = '��������'
  and o.price = (select max(o.price)
                 from operation o
                          join goods g using (id_goods)
                          join agent a using (id_ag)
                 where a.name_ag = '��������')

--9
select g.nomenclature
from operation o
         join goods g on (o.id_goods = g.id_goods)
group by g.nomenclature
having COUNT(o.id) = (select MAX(cc)
                      from (select COUNT(o.id) as cc
                            from operation o
                            group by o.id_goods));