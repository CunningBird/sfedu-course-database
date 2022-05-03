-- Найти поставщиков, которые работали с товаром «Папки»
select a.name_ag
from operation o
         join goods g using (id_goods)
         join agent a using (id_ag)
where g.nomenclature = 'Папки';

-- Найти товары, с которыми не было ни одной операции
select g.nomenclature
FROM goods g
         left JOIN operation o ON (g.id_goods = o.id_goods)
where o.id is NULL
group by g.nomenclature;

-- Найти поставщиков, которые выполнили только одну поставку
select a.name_ag
from operation o
         join agent a using (id_ag)
where o.id = '1';

-- Найти поставщиков, которые поставляли (операции A ) карандаши по минимальной цене
select a.name_ag
FROM operation o
         JOIN agent a ON (o.id_ag = a.id_ag)
WHERE o.typeop = 'A'
  and o.price = (select MIN(o.price)
                 FROM operation o
                          join goods g ON (o.id_goods = g.id_goods)
                 where g.nomenclature = '���������(10 ��)')
group by a.name_ag;

-- Найти склады, с которыми не было ни одной операции
select w.name
from warehouse w
         left join operation o using (id_wh)
where o.id is null;

-- Найти поставщиков, которые работают более чем с одним складом
select a.name_ag, count(w.name)
from operation o
         join agent a using (id_ag)
         join warehouse w using (id_wh)
group by a.name_ag
having count(w.name) > '1';

-- Найти товары, для которых была выполнена только одна поставка (A)
SELECT g.nomenclature
FROM operation o
         JOIN goods g ON (g.id_goods = o.id_goods)
where o.typeop = 'A'
GROUP BY g.nomenclature
HAVING COUNT(o.id) = 1;

-- Найти товары, которые поставщик «Надежный» поставлял по наибольшей цене
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

-- Найти товары, с которыми было больше всего операций
select g.nomenclature
from operation o
         join goods g on (o.id_goods = g.id_goods)
group by g.nomenclature
having COUNT(o.id) = (select MAX(cc)
                      from (select COUNT(o.id) as cc
                            from operation o
                            group by o.id_goods));