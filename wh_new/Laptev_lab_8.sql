-- Задание 1.
-- В последнем запросе, чтобы подключить дополнительную информацию из таблицы Goods пришлось выполнять join по
-- наименованию товара. Это не всегда является эффективным решением. Если предполагается использовать таблицу,
-- возвращаемую процедурой в соединении с другими таблицами, лучше предусмотреть в ней дополнительные выходные
-- параметры, подходящие для этого, например, код товара (id_goods).
-- TODO переписать с новым условием
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


