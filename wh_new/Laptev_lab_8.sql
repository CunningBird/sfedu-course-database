-- Задание 1.
-- В последнем запросе, чтобы подключить дополнительную информацию из таблицы Goods пришлось выполнять join по
-- наименованию товара. Это не всегда является эффективным решением. Если предполагается использовать таблицу,
-- возвращаемую процедурой в соединении с другими таблицами, лучше предусмотреть в ней дополнительные выходные
-- параметры, подходящие для этого, например, код товара (id_goods).

-- Измените процедуру, так, чтобы она возвращала еще один параметр.
create or alter procedure GOODSBYAGENT (AGENT type of column AGENT.NAME_AG)
returns (GOODS type of column GOODS.NOMENCLATURE,
	CNT integer,
	ID_G type of column GOODS.ID_GOODS)
as
    declare variable ID type of column AGENT.ID_AG;
begin
	id = (select a.id_ag from agent a where a.name_ag=:agent);
	if (:id is null) then exception;
	for select g.nomenclature, count(o.id), G.id_goods
		from operation O join goods G using(id_goods)
		where O.id_ag = :id
		group by G.nomenclature, G.id_goods
	into :goods, :cnt, :id_g do
	suspend;
end
EXECUTE PROCEDURE GOODSBYAGENT('Надежный');



-- Задание 2. Проверьте, что будет происходить, если убрать условие выполнения команды insert в автономной транзакции
create or alter procedure GOODSBYAGENT (AGENT type of column AGENT.NAME_AG)
returns (GOODS type of column GOODS.NOMENCLATURE, CNT integer)
as
	declare variable ID type of column AGENT.ID_AG;
begin
	id = (select a.id_ag from agent a where a.name_ag=:agent);
	if (:id is null) then
		begin
			insert into log_file (inform)
			values ('в БД нет агента '||:agent);
		exception;
		end
	for select g.nomenclature, count(o.id)
	    from operation O join goods G using(id_goods)
	    where O.id_ag = id
	    group by G.nomenclature
	into :goods, :cnt do
	suspend;
end

EXECUTE PROCEDURE GOODSBYAGENT('Flex Agent');
-- Выскакивает сообщение, что в процедуре сработала ошибка, запись в log файл не добавлена.



-- Задание 3.
-- Проверьте, как работает процедура, если ввести неправильное имя таблицы.
create or alter procedure TAB_RANG (
	NAME_T char(31))
returns (
	KOL integer)
as
	declare variable OPER varchar(200);
begin
	OPER = 'select count(*) from ' || name_t;
	execute statement OPER into :KOL ;
	suspend;
end

-- Добавить d
EXECUTE PROCEDURE TAB_RANG('AGENT');
-- В качестве ответа выводит табличку с одним столбцом KOL и единственным значением <null>


-- 4. По названию поставщика выдать все товары с указанием даты последней поставки (R).
create or alter procedure AGENT_LAST_R(
    A_NAME type of column AGENT.NAME_AG)
returns (
    G_NAME type of column GOODS.NOMENCLATURE,
    DATE_R type of column OPERATION.OP_DATE)
as
    declare variable ID_A type of column AGENT.ID_AG;
begin
    ID_A = (select A.ID_AG from AGENT A where A.NAME_AG = :A_NAME);
    for select G.NOMENCLATURE, max(O.OP_DATE)
        from GOODS G join OPERATION O using(ID_GOODS)
        where O.ID_AG = :ID_A and O.TYPEOP = 'R'
        group by G.NOMENCLATURE
    into :G_NAME, :DATE_R do
    suspend;
end
execute procedure AGENT_LAST_R('Надежный');



-- 5. По паре дат выдать список товаров, поставленных за заданный период, с указанием максимальной и минимальной стоимости поставки.
create or alter procedure GOODS_ST(
	BEGIN_DATE type of column OPERATION.OP_DATE,
	END_DATE type of column OPERATION.OP_DATE)
returns (
	GOODS type of column GOODS.NOMENCLATURE,
	MIN_ST numeric(15,2),
	MAX_ST numeric(15,2))
as
begin
	for select G.NOMENCLATURE, min(O.QUANTITY*O.PRICE), max(O.QUANTITY*O.PRICE)
	    from OPERATION O join GOODS G using(ID_GOODS)
	    where O.TYPEOP = 'A' and O.OP_DATE between :BEGIN_DATE and :END_DATE
	    group by G.NOMENCLATURE
	into :GOODS, :MIN_ST, :MAX_ST do
	suspend;
end
execute procedure GOODS_ST('1.02.2006', '10.05.2008');


-- 6. По названию склада и периоду выдать список поставщиков, поставлявших товары на заданный склад в заданный период.
create or alter procedure WH_AGENTS(
	WH_NAME type of column WAREHOUSE.NAME,
	BEGIN_DATE type of column OPERATION.OP_DATE,
	END_DATE type of column OPERATION.OP_DATE)
returns(
	N_AGENT type of column AGENT.NAME_AG)
as
begin
	for select A.NAME_AG
	    from OPERATION O join AGENT A using(ID_AG)
	    where O.TYPEOP = 'A' and O.OP_DATE between :BEGIN_DATE and :END_DATE
	into :N_AGENT do
	suspend;
end
execute procedure WH_AGENTS('Склад 2', '1.02.2006', '10.05.2008');


-- 7. Выдать названия складов, для которых количество указанного товара меньше заданного.
create or alter procedure MIN_G_QUANTITY(
	G_NAME type of column GOODS.NOMENCLATURE,
	MIN_G_Q type of column GOODS_WH.QUANTITY)
returns(
	WH_NAMES type of column WAREHOUSE.NAME)
as
	declare variable ID_G type of column GOODS.ID_GOODS;
begin
	ID_G = (select G.ID_GOODS from GOODS G where G.NOMENCLATURE = :G_NAME);
	for select W.NAME
	    from GOODS_WH GWH join WAREHOUSE W using(ID_WH)
	    where GWH.ID_GOODS = :ID_G and GWH.QUANTITY < :MIN_G_Q
	into :WH_NAMES do
	suspend;
end
execute procedure MIN_G_QUANTITY('Папки', '1000');


-- 8. Выдать названия поставщиков, у которых объем поставок заданного товара меньше некоторого значения.
create or alter procedure AGENTS_WITH_MIN_Q(
    GOODS_N type of column GOODS.NOMENCLATURE,
    MIN_Q type of column OPERATION.QUANTITY)
returns(
    AGENT_N type of column AGENT.NAME_AG)
as
    declare variable ID_G type of column GOODS.ID_GOODS;
begin
    ID_G = (select G.ID_GOODS from GOODS G where G.NOMENCLATURE = :GOODS_N);
    for select A.NAME_AG
        from OPERATION O join AGENT A using(ID_AG)
        where O.TYPEOP = 'A' and O.ID_GOODS = :ID_G and O.QUANTITY < :MIN_Q
        group by A.NAME_AG
    into :AGENT_N do
    suspend;
end
execute procedure AGENTS_WITH_MIN_Q('Папки', '1000');


-- 9. Выдать список операций за заданный период с указанием названия товара, склада, поставщика. Указать стоимость каждой поставки (цена * количество).
create or alter procedure OP_INF(
	BEGIN_DATE type of column OPERATION.OP_DATE,
	END_DATE type of column OPERATION.OP_DATE)
returns(
	OP type of column OPERATION.ID,
	GOODS_N type of column GOODS.NOMENCLATURE,
	WH_N type of column WAREHOUSE.NAME,
	AGENT_N type of column AGENT.NAME_AG,
	ST numeric(15,2))
as
begin
	for select O.ID, G.NOMENCLATURE, W.NAME, A.NAME_AG, (O.QUANTITY*O.PRICE)
	    from OPERATION O join AGENT A using(ID_AG)
			     join GOODS G using(ID_GOODS)
			     join WAREHOUSE W using(ID_WH)
	    where O.OP_DATE between :BEGIN_DATE and :END_DATE
	into :OP, :GOODS_N, :WH_N, :AGENT_N, :ST do
	suspend;
end
execute procedure OP_INF('1.02.2006', '10.05.2008');


-- 10.Для заданных названия таблицы и имени столбца в таблице (столбец содержит числовые данные) найти сумму значений в этом столбце.
create or alter procedure SUM_IN_COLUMN(
	TAB_N char(31),
	COLUMN_N char(31))
returns(
	KOL numeric(15,2))
as
	declare variable OPER varchar(200);
begin
	OPER = 'select sum('|| COLUMN_N ||') from ' || TAB_N;
	execute statement OPER into :KOL;
	suspend;
end
execute procedure SUM_IN_COLUMN('OPERATION', 'QUANTITY');