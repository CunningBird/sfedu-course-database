-- 1.
select max(o.quantity * o.price)
from goods g
         join operation o using (id_goods)
group by o.id_goods

-- 2.
SELECT a.name_ag
FROM agent a
WHERE a.id_ag NOT IN
      (SELECT O.id_ag
       FROM OPERATION O)
group by a.name_ag;

-- 3.
SELECT G.NOMENCLATURE
FROM GOODS G
WHERE SINGULAR
          (SELECT *
 FROM OPERATION O
 WHERE G.ID_GOODS = O.ID_GOODS);

-- 4.
select g.nomenclature, g.measure
from goods g
         join goods_wh gwh using (id_goods)
where gwh.id_wh = (select w.id_wh from warehouse w where w.name = '????? 2')
group by g.nomenclature, g.measure

-- 5.
select g.nomenclature, a.name_ag
from goods g
         join operation o using (id_goods)
         join agent a using (id_ag)
where o.typeop = 'A'
  and o.quantity > 200