-- 1. Создайте процедуры для добавления новых данных в таблицы AGENT и WAREHOUSE. Для AGENT:
create or alter procedure INSERT_AGENT (
    ID_AG type of column AGENT.ID_AG,
    NAME_AG type of column AGENT.name_ag,
    TOWN type of column AGENT.TOWN,
    PHONE type of column AGENT.PHONE)
as
begin
 insert into AGENT
 (ID_AG, NAME_AG, town, PHONE)
 values (:ID_AG, :NAME_AG, :town, :PHONE);
 suspend;
end
EXECUTE PROCEDURE INSERT_AGENT('p8', 'Flex agent', 'Rostov', '55-55-555');


-- Для WAREHOUSE
create or alter procedure INSERT_WAREHOUSE (
	ID_WH type of column WAREHOUSE.ID_WH,
	NAME type of column WAREHOUSE.NAME,
	TOWN type of column WAREHOUSE.TOWN)
as
begin
 insert into WAREHOUSE
 (ID_WH, NAME, TOWN)
 values (:id_wh, :name, :town);
 suspend;
end
EXECUTE PROCEDURE INSERT_WAREHOUSE('c7', 'Flew warehouse', 'Rostov');


-- 2. Создайте процедуру изменения остатка на складе. Параметры – название товара, название склада, новое количество.
-- Предположить, что параметры заданы правильно.
create or alter procedure REST_UPDATE (
    G_NAME type of column GOODS.NOMENCLATURE,
    WH_NAME type of column WAREHOUSE.NAME,
    G_QUANTITY type of column GOODS_WH.QUANTITY)
as
begin
     update goods_wh
     set QUANTITY = :G_QUANTITY
    WHERE ID_WH = (select id_wh from warehouse W where W.name=:WH_NAME)
    AND ID_GOODS = (select A.id_goods from goods A
            where A.nomenclature = :G_NAME);
    INSERT into log_file (inform) values ('Остаток обновлён');
    suspend;
end
EXECUTE PROCEDURE REST_UPDATE('Тетрадь 12л.', 'Склад 2', 2000);


-- 3. Создайте процедуру удаления остатка со склада (должна быть удалена запись из таблицы GOODS_WH). Параметры –
-- название товара, название склада. Предположить, что параметры могут быть заданы неправильно.
create or alter procedure REST_DELETE (
	G_NAME type of column GOODS.NOMENCLATURE,
	WH_NAME type of column WAREHOUSE.NAME)
as
	declare variable ID_G type of column GOODS.ID_GOODS;
	declare variable ID_W type of column WAREHOUSE.ID_WH;
begin
	ID_G = (select G.ID_GOODS from GOODS G
		where G.NOMENCLATURE = :G_NAME);
	if (ID_G is null) then
 		begin
			insert into LOG_FILE (INFORM)
			values ('Ошибка в названии товара '||:G_NAME);
 			exit;
 		end
	ID_W = (select W.ID_WH from WAREHOUSE W
			where W.NAME = :WH_NAME);
	if (ID_W is null) then
		begin
			insert into LOG_FILE (INFORM)
			values ('Ошибка в имени склада '||:WH_NAME);
			exit;
		end
	delete from GOODS_WH
	where ID_GOODS = :ID_G
	and ID_WH = :ID_W;
	suspend;
end
EXECUTE PROCEDURE REST_DELETE('Тетрадь 12л.', 'Склад 2');


-- 4. Изменить процедуру REST_INSERT так, чтобы дополнительно контролировалось условие – комбинация id_goods, id_wh в
-- таблице GOODS_WH должна быть уникальной.
create or alter procedure REST_INSERT (
	GOODS type of column GOODS.NOMENCLATURE,
	WH type of column WAREHOUSE.NAME,
	Q type of column GOODS_WH.QUANTITY)
as
	declare variable ID_G type of column GOODS.ID_GOODS;
	declare variable ID_W type of column WAREHOUSE.ID_WH;
begin
	if (Q <= 0) then
 		begin
 			insert into LOG_FILE (INFORM)
			values ('Недопустимое значение остатка '||:Q);
 			exit;
 		end
	ID_G = (select G.ID_GOODS
		from GOODS G where G.NOMENCLATURE = :GOODS);
	if (ID_G is null ) then
 		begin
			insert into LOG_FILE (INFORM)
			values ('Ошибка в названии товара '||:GOODS);
 			exit;
 		end
	ID_W = (select W.ID_WH from WAREHOUSE W where W.NAME = :WH);
	if (ID_W is null ) then
 		begin
 			insert into LOG_FILE (INFORM)
			values ('Ошибка в названии склада '||:WH);
 			exit;
 		end
	if (exists(select W2.ID
		from GOODS_WH W2
		where W2.ID_WH = :ID_W
		and W2.ID_GOODS = :ID_G)) then
			begin
 				insert into LOG_FILE (INFORM)
				values ('Комбинация не уникальна');
 				exit;
 			end
	insert into GOODS_WH values (null, :ID_W, :ID_G, :Q);
	insert into LOG_FILE (INFORM) values ('Остаток добавлен');
	suspend;
end
EXECUTE PROCEDURE REST_INSERT('Тетрадь 12л.', 'Склад 2', 8000);


-- 5. Создайте процедуру, которая для заданного (в параметре) наименования товара находила поставщиков, которые
-- выполнили максимальное количество операций с этим товаром.
-- Список поставщиков поместить в таблицу LOG_FILE.
create or alter procedure MAX_OP_AGENTS (
	G_NAME type of column GOODS.NOMENCLATURE)
as
	declare variable A_NAME type of column AGENT.NAME_AG;
begin
	for select CNT_OP.NAME_AG
	    from (select A.NAME_AG, COUNT(O.ID) AS CNT
    		  from GOODS G join OPERATION O using(ID_GOODS)
			       join AGENT A using(ID_AG)
    		  where O.TYPEOP = 'A' and G.NOMENCLATURE = :G_NAME
    		  group by A.NAME_AG) AS CNT_OP
	    where CNT_OP.CNT = (select max(CNT_OP2.CNT)
                    		from (select A2.NAME_AG, COUNT(O2.ID) AS CNT
    			  	      from GOODS G2 join OPERATION O2 using(ID_GOODS)
						    join AGENT A2 using(ID_AG)
    			  	      where O2.TYPEOP = 'A' and G2.NOMENCLATURE = :G_NAME
    			  	      group by A2.NAME_AG) AS CNT_OP2)
	into :A_NAME
	do
	insert into LOG_FILE (INFORM) values (:A_NAME);
	suspend;
end
-- Пишет в лог
EXECUTE PROCEDURE MAX_OP_AGENTS('Блокнот');


-- 6. Создайте процедуру, которая записывает в LOG_FILE в поле DDATA даты всех операций A, выполненных заданным
-- (в параметре) поставщиком.
create or alter procedure DATES_OP(
	A_NAME type of column AGENT.NAME_AG)
as
	declare variable O_DATE type of column OPERATION.OP_DATE;
begin
	for select O.OP_DATE
	    from OPERATION O join AGENT A using(ID_AG)
	    where O.TYPEOP = 'A' and A.NAME_AG = :A_NAME
	into :O_DATE
	do
	insert into LOG_FILE (DDATA) values(:O_DATE);
	suspend;
end
EXECUTE PROCEDURE DATES_OP('ООО Партнер');