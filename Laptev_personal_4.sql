-- 1.
create or alter procedure task1 (
 W_NAME type of column WAREHOUSE.NAME)
as
 declare variable G_SUM integer;
begin
 G_SUM = (select count(distinct gwh.id_goods)
 from goods_wh gwh
 where gwh.id_wh = (select w.id_wh from warehouse w where w.name = :W_NAME));
 insert into LOG_FILE (INFORM) values(:G_SUM);
 suspend;
end

EXECUTE PROCEDURE task1('????? 1');

-- 2.

create or alter procedure task2 (
 W_NAME type of column WAREHOUSE.NAME,
 G_NAME type of column GOODS.NOMENCLATURE,
 Q type of column GOODS_WH.QUANTITY)
as
 declare variable ID_G type of column GOODS.ID_GOODS;
 declare variable ID_W type of column WAREHOUSE.ID_WH;
begin
 ID_G = (select G.ID_GOODS from GOODS G where G.NOMENCLATURE = :G_NAME);
 if (ID_G is null ) then exception;
 ID_W = (select W.ID_WH from WAREHOUSE W where W.NAME = :W_NAME);
 if (ID_W is null ) then exception;

 if (exists(select * from goods_wh gwh where gwh.id_wh = :ID_W and gwh.id_goods = :ID_G)) then
 update goods_wh
 set quantity = quantity + :Q
 where id_wh = :ID_W and id_goods = :ID_G;
 else
 INSERT INTO goods_wh
 VALUES(GEN_ID(GEN_GOODS_WH_ID, 1),:ID_W, :ID_G, :Q);
 suspend;
end
EXECUTE PROCEDURE task2('????? 1', '?????', 20);
