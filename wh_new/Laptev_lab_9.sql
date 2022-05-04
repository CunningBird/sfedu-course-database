-- Задание 1. Пусть одно из деловых ограничений требует, чтобы название фирмы NAME_AG, заносимое в таблицу-справочник
-- AGENT, всегда записывалось заглавными буквами. Чтобы не обременять пользователя лишними инструкциями по вводу,
-- а прикладную программу дополнительным кодом, определим триггер

create trigger BI_AGENT for AGENT
before insert position 0
as
begin
	NEW.NAME_AG = UPPER(NEW.NAME_AG);
end
-- При попытке ввести в поле значение 'дгту' была занесена записть 'ДГТУ'


-- Для полной реализации функциональности ограничений на столбцы необходимо создать два триггера BEFORE INSERT и
-- BEFORE UPDATE или объединить оба действия в одном триггере. Создайте второй триггер для реализации того же делового
-- ограничения.

CREATE OR ALTER TRIGGER BI_AGENT_UP FOR AGENT
ACTIVE BEFORE UPDATE POSITION 0
as
begin
	NEW.NAME_AG = UPPER(NEW.NAME_AG);
end









-- Задание 2. Деловые правила могут запрещать выполнять операции, нарушающие ограничения целостности.
-- Например, при редактировании поля PAY (оклад) в таблице SOTR (сотрудники) можно ввести ограничение, что оклад может
-- быть только повышен. Создайте в своей базе соответствующую простую таблицу или дополните нужными полями таблицу
-- AGENT. Создайте необходимое исключение и триггер, аналогичные описанным в примере.

create table SOTR(PAY numeric(15,2));
insert into sotr (pay) values('1000');
create exception ERROR_PAY 'Запрещено!!!';

CREATE OR ALTER TRIGGER AU_SOTR FOR SOTR
ACTIVE AFTER UPDATE POSITION 0
as
begin
    if (NEW.PAY<OLD.PAY) then
    exception ERROR_PAY;
end

-- Поле 'PAY' содержит единственное число 1000,00
-- При попытке ввести в поле 'PAY' новое значение 10,00 получили сообщение:

-- ERROR_PAY.
-- Запрещено!!!.
-- At trigger 'AU_SOTR'









-- Задание 3. Определение значения по умолчанию для поля. Поскольку большинство поставщиков, с которыми осуществляется
-- работа, расположены в Ростове-на-Дону, определим его для подстановки значения по умолчанию, если при добавлении или
-- редактировании таблицы AGENT в поле TOWN указывается значение NULL. Создайте для реализации этого делового
-- ограничения триггер.

CREATE OR ALTER TRIGGER BIU_AGENT FOR AGENT
ACTIVE BEFORE INSERT OR UPDATE POSITION 1
as
begin
if (NEW.TOWN is NULL) then
NEW.TOWN = 'Ростов-на-Дону';
end

-- Вводим нового агента, не указывая город
insert into AGENT (ID_AG, NAME_AG) values('p13', 'ООО Маяк');

-- Результат: p13 ООО Маяк Ростов-на-Дону <null>








-- Задание 4. Проверка значения в таблице на основе значений из другой таблицы. Создайте в своей базе данных две таблицы.

-- Таблица «Счет за услуги телефонной связи» ORDERS будет содержать данные:
-- номер счета ACC,
-- дата,
-- имя получателя,
-- номер телефона,
-- сумма к оплате SUMMA.
create table ORDERS(ACC integer, ORDER_DATE date, RECIP_NAME char(20), PHONE char(10), SUMMA numeric(17,2));


-- Таблица «Услуги» SERVICES будет содержать:
-- номер счета ID_ACC,
-- наименование услуги,
-- стоимость COST.
create table SERVICES(ID_ACC integer, SERV_NAME char(20), COST numeric(17,2));


CREATE OR ALTER TRIGGER BIU_ORDERS FOR ORDERS
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
as
declare variable S NUMERIC(17,2);
begin
	select sum(COST)
	from SERVICES
	where ID_ACC = NEW.ACC into :S;
	NEW.SUMMA = S;
end

-- Заполняем таблицу SERVICES:
INSERT INTO SERVICES(ID_ACC, SERV_NAME, COST)
values ('1', 'Уборка помещения', '3425');
INSERT INTO SERVICES(ID_ACC, SERV_NAME, COST)
values ('1', 'Дезинсекция', '3500');

INSERT INTO SERVICES(ID_ACC, SERV_NAME, COST)
values ('1', 'Дезинсекцияz', '6500');

-- Проверяем работу триггера, вводим новое значение в таблицу ORDERS
INSERT INTO ORDERS(ACC, ORDER_DATE, RECIP_NAME, PHONE, SUMMA)
VALUES ('1', '28.04.2022', 'Ивыанов И. И.', '+7(999)555', '0');

-- Строка в таблице ORDERS:
-- 1 28.04.2022 Ивыанов И. И. +7(999)555 6925,00

-- Триггер сработал - в поле SUMMA правильное значение.




-- Задание 5. Создайте триггер, который бы при любых изменениях в таблице SERVICES (добавление новой строки, изменение
-- суммы в существующей строке) находит нужную запись в таблице ORDERS и меняет в ней сумму. Считать в этом случае,
-- что порядок работы с таблицами другой – сначала заводится счет в таблице ORDERS , а потом в него добавляются строки
-- в таблице SERVICES.
CREATE OR ALTER TRIGGER BIU_SERVICES FOR SERVICES
ACTIVE AFTER INSERT POSITION 0
as
declare variable S NUMERIC(17,2);
begin
    select sum(S.COST)
    from SERVICES S
    where S.ID_ACC = NEW.ID_ACC into :S;
    UPDATE ORDERS
    SET SUMMA = :S
    WHERE ORDERS.acc = NEW.ID_ACC;
end

CREATE OR ALTER TRIGGER BIU_UP_SERVICES FOR SERVICES
ACTIVE AFTER UPDATE POSITION 0
as
declare variable S NUMERIC(17,2);
begin
    select sum(S.COST)
    from SERVICES S
    where S.ID_ACC = NEW.ID_ACC into :S;
    UPDATE ORDERS
    SET SUMMA = :S
    WHERE ORDERS.acc = NEW.ID_ACC;
end

-- При изменении поля COST таблицы SERVICES изменилось значение поля SUMMA таблицы ORDERS







-- Задание 6. Существующие в Firebird генераторы уникальных значений могут быть использованы для реализации
-- автоинкрементных первичных ключей. Создайте в тестовой базе данных таблицу MYTABLE, у которой поле первичного ключа
-- PK_MYTABLE. Создайте генератор и триггер для автоинкрементного заполнения поля первичного ключа. Измените триггер
-- так, чтобы он использовал генератор корректно в любой ситуации.
create table MYTABLE(PK_MYTABLE integer NOT NULL PRIMARY KEY);

create generator GEN_PK;

CREATE OR ALTER TRIGGER BI_MYTABLE FOR MYTABLE
ACTIVE BEFORE INSERT POSITION 0
as
declare variable ID integer;
begin
	if (NEW.PK_MYTABLE is NULL) then
		:ID = GEN_ID(GEN_PK,1);
	if (:ID not in (select M.PK_MYTABLE from MYTABLE M)) then
		NEW.PK_MYTABLE = :id;
	else
		NEW.PK_MYTABLE = GEN_ID(GEN_PK,1);
end









-- Задание 7. Реализуем ссылочную целостность для следующих двух таблиц.

-- Справочника (таблицы соответствия) LOOKUP
create table LOOKUP(L_ID integer NOT NULL UNIQUE);

-- И таблицы, использующей данные из справочника через ссылку на ID соответствующей строки в таблице LOOKUP.
create table REQUESTOR
(ID integer NOT NULL PRIMARY KEY,
LOOKUP_ID integer)


-- Чтобы реализовать действие NOACTION при удалении или редактировании строки в таблице LOOKUP, создадим исключение
create exception NOT_VALID 'Ошибка!!!';


-- Триггер, который проверяет ограничение ссылочной целостности на стороне дочерней таблицы,
-- в нашем случае таблицы REQUESTOR.
create trigger BA_REQ for REQUESTOR
active before INSERT OR UPDATE
as
begin
	if (NEW.LOOKUP_ID IS NOT NULL
	AND
	NOT EXISTS(
	select L_ID from LOOKUP
	where L_ID = NEW.LOOKUP_ID))
	then exception NOT_VALID;
end

-- Второй триггер проверяет возможность удалять и редактировать строки
-- в таблице соответствия LOOKUP.
create trigger BA_L for LOOKUP
active before DELETE OR UPDATE
as
begin
	if (UPDATING AND (NEW.L_ID<>OLD.L_ID)
	OR DELETING)
	then
	if (EXISTS(
	select LOOKUP_ID
	from REQUESTOR
	where LOOKUP_ID=OLD.L_ID))
	then exception NOT_VALID;
end









-- Задание 8. Реализовать возможность каскадного изменения записей в дочерней таблице при изменении первичного ключа в
-- родительской таблице. Воспользуемся в этом задании теми же таблицами, что и в предыдущем. Изменения вносим в триггер
-- для таблицы LOOKUP
create trigger BU_L for LOOKUP
active before UPDATE
as
begin
	if (NEW.L_ID<>OLD.L_ID)
	then
	if (EXISTS(
	select LOOKUP_ID
	from REQUESTOR
	where LOOKUP_ID=OLD.L_ID))
	then
	update REQUESTOR
	set LOOKUP_ID=NEW.L_ID
	where LOOKUP_ID=OLD.L_ID;
end

-- Перед тестом сделать триггер, созданный в задании 7, неактивным!!!!






-- Задание 9. Реализовать возможность каскадного удаления записей в дочерней таблице при удалении строки в родительской
-- таблице. Воспользуемся в этом задании теми же таблицы, что и в предыдущих заданиях. Изменения вносим в триггер для
-- таблицы LOOKUP.
create trigger BD_L for LOOKUP
active before DELETE
as
begin
	if (EXISTS(
	select LOOKUP_ID
	from REQUESTOR
	where LOOKUP_ID=OLD.L_ID))
	then
	delete from REQUESTOR
	where LOOKUP_ID=OLD.L_ID;
end







-- Задание 10. При каждом добавлении записи в таблицу делать запись в таблицу-журнал. Для активизации журнала
-- воспользуемся командой вызова утилиты логирования Logmanager (tools -> log manager). Появляющееся при этом окно
-- Logmanager содержит информацию обо всех настройках журнала. При первом вызове Logmanager может появиться окно,
-- сообщающее, что для ведения журналов нужно создать вспомогательные таблицы. Ответьте на сообщение в этом окне
-- согласием. Отмечаем, что нам необходим журнал по выполнению операции INSERT. Будет сгенерирован триггер аналогичный
-- следующему
CREATE TRIGGER IBE$AGENT_AI FOR AGENT
ACTIVE AFTER INSERT POSITION 32767
as
declare variable tid integer;
begin
  tid = gen_id(ibe$log_tables_gen,1);

  insert into ibe$log_tables (id, table_name, operation, date_time, user_name)
         values (:tid, 'AGENT', 'I', 'NOW', user);

  insert into ibe$log_keys (log_tables_id, key_field, key_value)
         values (:tid, 'ID_AG', new.id_ag);
end;

-- Выполните теперь вставку одной строки в таблицу AGENT. Зафиксируйте транзакцию. Запись в журнале можно посмотреть,
-- используя обыкновенный запрос к таблице ibe$log_tables. Или воспользоваться вкладкой Logging окна работы с таблицей
-- AGENT в IBExpert. Если в окне Logmanager дополнительно отметить поля таблицы, то в триггере для каждого поля
-- появится приблизительно такой оператор (для поля NAME_AG)
if (new.name_ag is not null) then
insert into ibe$log_fields (log_tables_id,
field_name, old_value, new_value)
values (:tid, 'NAME_AG', null,
new.name_ag);

Вставка: insert into AGENT(ID_AG, NAME_AG) VALUES('p14', 'ОАО Агент');

SELECT *
FROM ibe$log_tables








-- Задание 11. По аналогии с предыдущим заданием, создайте свои собственные таблицы для журналов операций, напишите и
-- проверьте соответствующие триггеры.
CREATE TABLE MY_LOGS (ID INTEGER NOT NULL UNIQUE, TABLE_NAME CHAR(20), OPERATION CHAR(2), DATE_TIME DATE, USER_NAME CHAR(20));

create generator GEN_MY_LOGS;

CREATE TRIGGER MY_LOGS_INSERT FOR OPERATION
ACTIVE AFTER INSERT POSITION 32767
as
declare variable tid integer;
begin
  tid = gen_id(GEN_MY_LOGS,1);

  insert into MY_LOGS (id, table_name, operation, date_time, user_name)
         values (:tid, 'OPERATION', 'I', 'NOW', user);
end;

CREATE TRIGGER MY_LOGS_UPDATE FOR OPERATION
ACTIVE AFTER UPDATE POSITION 32767
as
declare variable tid integer;
begin
  tid = gen_id(GEN_MY_LOGS,1);

  insert into MY_LOGS (id, table_name, operation, date_time, user_name)
         values (:tid, 'OPERATION', 'U', 'NOW', user);
end;

CREATE TRIGGER MY_LOGS_DELETE FOR OPERATION
ACTIVE AFTER DELETE POSITION 32767
as
declare variable tid integer;
begin
  tid = gen_id(GEN_MY_LOGS,1);

  insert into MY_LOGS (id, table_name, operation, date_time, user_name)
         values (:tid, 'OPERATION', 'D', 'NOW', user);
end;








-- Задание 12. Триггеры можно использовать для реализации сложных правил проверок защиты данных от несанкционированного
-- доступа. Например, можно запретить вносить изменения (INSERT, UPDATE, DELETE) в таблицу OPERATION в праздничные дни.
-- Для упрощения проверки,предположим, что нас интересует только один праздничный день – 1 января. Создайте исключение
CREATE EXCEPTION HOLIDAY 'May not change operation table during a holiday';

-- Создайте триггер (IBE ИНОГДА РУГАЕТСЯ, ЕСЛИ ПРОСИТЬ ЕГО СОЗДАТЬ ТРИГГЕР СРАЗУ ДЛЯ НЕСКОЛЬКИХ ТИПОВ ОПЕРАЦИЙ, ПОЭТОМУ СОЗДАНО 3 ТРИГГЕРА ДЛЯ 3 ТИПОВ ОПЕРАЦИЙ)

CREATE TRIGGER OPERATION_NO_IN FOR operation
ACTIVE BEFORE INSERT POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 4 and mn = 5) then
	exception HOLIDAY;
end

CREATE TRIGGER OPERATION_NO_UP FOR operation
ACTIVE BEFORE UPDATE POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 4 and mn = 5) then
	exception HOLIDAY;
end

CREATE TRIGGER OPERATION_NO_DEL FOR operation
ACTIVE BEFORE DELETE POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 4 and mn = 5) then
	exception HOLIDAY;
end

-- Для проверки работы этого триггера можно изменить дату выходного дня на любую.
-- (Например для того что бы проверить, получится ли внести изменение, месяц и день установить на текущий и попробовать
-- выполнить операцию вставку/обновление/удаление в OPERATION)

INSERT INTO OPERATION
VALUES('19', 'T9', 'p3', 'C4', 'A', '24', '320', 'NOW');

alter trigger OPERATION_NO_IN inactive;
alter trigger OPERATION_NO_UP inactive;
alter trigger OPERATION_NO_DEL inactive;








-- Задание 13. Добавьте в триггер OPERATION_ALL возможность журнализации попыток работать с таблицей OPERATION в
-- четверг (использовать для определения дня недели функцию EXTRACT). Операции записи выполнять в автономных транзакциях.

-- НИЖЕ ТРИГГЕР ДЛЯ УДАЛЕНИЯ. ДЛЯ ВСТАВКИ И ИЗМЕНЕНИЯ ОНИ АНАЛОГИЧНЫ, ТОЛЬКО ИЗМЕНИТЬ ВИД ОПЕРАЦИИ ВО 2 СТРОКЕ

CREATE OR ALTER TRIGGER OPERATION_NO_DEL FOR operation
ACTIVE BEFORE DELETE POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
declare variable tid integer;
begin
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 1 and mn = 1) then
	begin
		in autonomous transaction do
			tid = gen_id(GEN_MY_LOGS,1);
		in autonomous transaction do
			insert into MY_LOGS (id, table_name, operation, date_time, user_name)
         		values (:tid, 'OPERATION', 'D', 'NOW', user);
		exception HOLIDAY;
	end
end








-- Задание 14. Для проверки очередности срабатывания триггеров, создайте для одной из таблиц и каждой из фаз BEFORE и
-- AFTER несколько триггеров. Предусмотрите возможность нормального завершения и выбрасывания исключения в каждом из
-- триггеров. Каждый из триггеров должен в начале своей работы делать две записи в таблицу LOG_FILE, одна из которых
-- должна выполняться в автономной транзакции.


create exception GOODS_B_INS_ERR 'ERROR IN GOODS BEFORE INSERT!';
create exception GOODS_A_INS_ERR 'ERROR IN GOODS AFTER INSERT!';



CREATE OR ALTER TRIGGER GOODS_B1_INS FOR GOODS
ACTIVE BEFORE INSERT POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	insert into LOG_FILE (INFORM) values('GOODS_B1_INS');
	in autonomous transaction do
		insert into LOG_FILE (INFORM) values('GOODS_B1_INS AUTONOM');
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 27 and mn = 4) then
		exception GOODS_B_INS_ERR;
end


CREATE OR ALTER TRIGGER GOODS_B2_INS FOR GOODS
ACTIVE BEFORE INSERT POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	insert into LOG_FILE (INFORM) values('GOODS_B2_INS');
	in autonomous transaction do
		insert into LOG_FILE (INFORM) values('GOODS_B2_INS AUTONOM');
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 27 and mn = 4) then
		exception GOODS_B_INS_ERR;
end





CREATE OR ALTER TRIGGER GOODS_A1_INS FOR GOODS
ACTIVE AFTER INSERT POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	insert into LOG_FILE (INFORM) values('GOODS_A1_INS');
	in autonomous transaction do
		insert into LOG_FILE (INFORM) values('GOODS_A1_INS AUTONOM');
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 27 and mn = 4) then
		exception GOODS_A_INS_ERR;
end



CREATE OR ALTER TRIGGER GOODS_A2_INS FOR GOODS
ACTIVE AFTER INSERT POSITION 0
AS
declare variable dt integer;
declare variable mn integer;
begin
	insert into LOG_FILE (INFORM) values('GOODS_A2_INS');
	in autonomous transaction do
		insert into LOG_FILE (INFORM) values('GOODS_A2_INS AUTONOM');
	dt = extract(day from current_date);
	mn = extract(month from current_date);
	if (dt = 27 and mn = 4) then
		exception GOODS_A_INS_ERR;
end

-- При попытке вставить новую строку в таблицу goods в день, когда этого делать нельзя, в log_file появилась запись
-- GOODS_B1_INS AUTONOM, а операция завершилась сообщением об ошибке GOODS_B_INS_ERR из GOODS_B1_INS.