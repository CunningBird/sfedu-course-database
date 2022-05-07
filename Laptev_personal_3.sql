-- 1.
select count(o.id), max(o.quantity * o.price)
from goods_wh gwh
         join operation o using (id_wh)
where gwh.id_wh in (select w.id_wh from warehouse w where w.name = '????? ?? ????????')
group by o.id_goods

-- 2.
select count(o.id)
from warehouse w
         left join operation o using (id_wh)
group by w.id_wh