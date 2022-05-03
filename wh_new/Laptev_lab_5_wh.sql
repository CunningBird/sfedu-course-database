-- Составить список товаров, находящихся на складах с указанием города нахождения склада
select (select g.nomenclature
        from goods g
        where g.id_goods = gwh.id_goods) as nomenclature,
       (select w.town
        from warehouse w
        where w.id_wh = gwh.id_wh)       as town
FROM goods_wh gwh;

-- Составить список поставщиков, который выполняли операции с товаром «Папки»
select (select a.name_ag
        from agent a
        where a.id_ag = o.id_ag) as ag
FROM operation o
where o.id_goods = (select g.id_goods
                    from goods g
                    where g.nomenclature = 'Папки');

-- Найти поставщиков, которые в операциях со складом «Склад 1» задействовали более одного вида товара
select (select a.name_ag
        from agent a
        where a.id_ag = o.id_ag) as ag
FROM operation o
where o.id_wh = (select w.id_wh
                 from warehouse w
                 where w.name = 'Склад 1')
group by o.id_ag
having count(distinct o.id_goods) > 1;

-- Найти даты операций, когда товар «Папки» поставлялся по цене ниже
-- средней, указать название поставщика
SELECT oo.op_date,
       (select a.name_ag
        from agent a
        where a.id_ag = oo.id_ag) as ag
FROM operation oo
WHERE oo.id_goods = (select g.id_goods
                     from goods g
                     where g.nomenclature = 'Папки')
  AND oo.price < (SELECT AVG(o.price)
                  FROM operation o
                  where o.id_goods = (select g.id_goods
                                      from goods g
                                      where g.nomenclature = 'Папки'));