-- Составить список товаров, которые есть на складе «Склад 2», указать их количество и единицы измерения.
select g.nomenclature, gwh.quantity, g.measure
FROM goods g
         JOIN goods_wh gwh ON (g.id_goods = gwh.id_goods)
         JOIN warehouse w ON (w.id_wh = gwh.id_wh)
where w.name = 'Склад 2';

-- Выдать информацию об операциях с товаром «Тетрадь 12л». Должны быть указаны:
-- дата операции,
-- тип словами (А – «привозили», R – «увозили»),
-- название склада,
-- название агента,
-- стоимость (цена*количество)
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
where g.nomenclature = 'Папки';



-- Составить отчет по операциям в 1 квартале 2007 года:
-- название товара,
-- имя поставщика,
-- название склада,
-- тип операции,
-- количество,
-- цена,
-- сумма по операции
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

-- Найти количество разных товаров, с которыми работал каждый поставщик
SELECT a.name_ag, count(distinct o.id_goods)
FROM agent a
   join operation o ON (o.id_ag = a.id_ag)
group BY a.name_ag;

-- Найти минимальную стоимость операции для каждого поставщика
SELECT a.name_ag, MIN(o.quantity * o.price) as min_value
FROM agent a
         LEFT join operation o ON (o.id_ag = a.id_ag)
group BY a.name_ag;

-- Для каждого склада определить суммарное количество хранящихся на нем товаров
SELECT w.name, g.nomenclature, SUM(gwh.quantity) as total_quantity, g.measure
FROM warehouse w
         LEFT join goods_wh gwh on (w.id_wh = gwh.id_wh)
         LEFT JOIN goods g ON (g.id_goods = gwh.id_goods)
GROUP BY w.name, g.nomenclature, g.measure;


