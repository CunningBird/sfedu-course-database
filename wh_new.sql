/******************************************************************************/
/***                               Generators                               ***/
/******************************************************************************/

CREATE GENERATOR GEN_GOODS_WH_ID;
SET GENERATOR GEN_GOODS_WH_ID TO 7;

CREATE GENERATOR GEN_LOG_FILE_ID;
SET GENERATOR GEN_LOG_FILE_ID TO 1;

CREATE GENERATOR GEN_OPERATION_ID;
SET GENERATOR GEN_OPERATION_ID TO 15;



/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/



CREATE TABLE AGENT (
    ID_AG    CHAR(10) NOT NULL,
    NAME_AG  CHAR(20) NOT NULL,
    TOWN     CHAR(20),
    PHONE    CHAR(10)
);

CREATE TABLE GOODS (
    ID_GOODS      CHAR(10) NOT NULL,
    NOMENCLATURE  CHAR(20) NOT NULL,
    MEASURE       CHAR(10)
);

CREATE TABLE GOODS_WH (
    ID        INTEGER NOT NULL,
    ID_WH     CHAR(10) NOT NULL,
    ID_GOODS  CHAR(10) NOT NULL,
    QUANTITY  NUMERIC(15,2)
);

CREATE TABLE LOG_FILE (
    ID         INTEGER NOT NULL,
    INFORM     VARCHAR(200),
    USER_NAME  CHAR(10),
    DDATA      DATE
);

CREATE TABLE OPERATION (
    ID        INTEGER NOT NULL,
    ID_GOODS  CHAR(10) NOT NULL,
    ID_AG     CHAR(10) NOT NULL,
    ID_WH     CHAR(10) NOT NULL,
    TYPEOP    CHAR(1) NOT NULL,
    QUANTITY  NUMERIC(15,2) NOT NULL,
    PRICE     NUMERIC(15,2),
    OP_DATE   DATE
);

CREATE TABLE WAREHOUSE (
    ID_WH  CHAR(10) NOT NULL,
    NAME   CHAR(20) NOT NULL,
    TOWN   CHAR(20)
);

INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p1        ', 'Надежный            ', 'Азов                ', '55-55-555 ');
INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p2        ', 'ООО Партнер         ', 'Ростов              ', '2-34-56-78');
INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p3        ', 'Астра               ', 'Ростов              ', '2-22-22-22');
INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p4        ', 'Танаис              ', 'Таганрог            ', '3-46-47   ');
INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p5        ', 'ОАО Лидер           ', 'Батайск             ', '123456    ');
INSERT INTO AGENT (ID_AG, NAME_AG, TOWN, PHONE) VALUES ('p6        ', 'ИММиКН              ', 'Ростов              ', NULL);

INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T1        ', 'Бумага для факсов   ', 'шт        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T2        ', 'Папки               ', 'уп        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T3        ', 'Карандаши(10 шт)    ', 'уп        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T4        ', 'Открытка            ', 'шт        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T5        ', 'Тетрадь 12л.        ', 'шт        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T6        ', 'Блокнот             ', 'шт        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T7        ', 'Сувенир - гном      ', 'шт        ');
INSERT INTO GOODS (ID_GOODS, NOMENCLATURE, MEASURE) VALUES ('T8        ', 'Тетрадь 24л.        ', 'шт        ');

INSERT INTO WAREHOUSE (ID_WH, NAME, TOWN) VALUES ('С1        ', 'Склад 1             ', 'Ростов              ');
INSERT INTO WAREHOUSE (ID_WH, NAME, TOWN) VALUES ('С2        ', 'Склад на Шолохова   ', 'Ростов              ');
INSERT INTO WAREHOUSE (ID_WH, NAME, TOWN) VALUES ('С3        ', 'Склад 2             ', 'Батайск             ');
INSERT INTO WAREHOUSE (ID_WH, NAME, TOWN) VALUES ('С4        ', 'Склад 3             ', 'Азов                ');
INSERT INTO WAREHOUSE (ID_WH, NAME, TOWN) VALUES ('C5        ', 'Склад ИП ГХР        ', 'Азов                ');

INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (1, 'С1        ', 'T2        ', 100);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (2, 'С1        ', 'T3        ', 56);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (3, 'С2        ', 'T1        ', 1000);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (4, 'С3        ', 'T2        ', 54);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (5, 'С3        ', 'T4        ', 234);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (6, 'С3        ', 'T5        ', 1500);
INSERT INTO GOODS_WH (ID, ID_WH, ID_GOODS, QUANTITY) VALUES (7, 'С3        ', 'T6        ', 34);

INSERT INTO LOG_FILE (ID, INFORM, USER_NAME, DDATA) VALUES (1, ':)', NULL, NULL);

INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (2, 'T1        ', 'p3        ', 'С3        ', 'R', 100, 349, '2006-09-10');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (3, 'T2        ', 'p2        ', 'С2        ', 'A', 1000, 120, '2006-11-25');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (4, 'T3        ', 'p4        ', 'С4        ', 'A', 150, 50, '2006-12-01');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (5, 'T6        ', 'p1        ', 'С4        ', 'A', 100, 20, '2006-12-23');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (6, 'T5        ', 'p1        ', 'С2        ', 'R', 1000, 0.8, '2007-01-12');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (7, 'T5        ', 'p3        ', 'С3        ', 'A', 500, 0.75, '2006-02-25');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (8, 'T4        ', 'p2        ', 'С4        ', 'A', 100, 20, '2007-03-03');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (9, 'T3        ', 'p5        ', 'С1        ', 'R', 100, 50, '2007-03-23');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (10, 'T5        ', 'p3        ', 'С3        ', 'R', 230, 0.9, '2007-04-11');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (11, 'T3        ', 'p1        ', 'С3        ', 'A', 500, 120, '2007-05-23');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (13, 'T2        ', 'p4        ', 'С1        ', 'A', 500, 125, '2007-06-16');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (14, 'T3        ', 'p2        ', 'С2        ', 'R', 500, 125, '2007-06-20');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (1, 'T1        ', 'p1        ', 'С1        ', 'A', 120, 400, '2006-05-12');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (12, 'T3        ', 'p1        ', 'С1        ', 'R', 100, 390, '2007-06-12');
INSERT INTO OPERATION (ID, ID_GOODS, ID_AG, ID_WH, TYPEOP, QUANTITY, PRICE, OP_DATE) VALUES (15, 'T1        ', 'p2        ', 'С2        ', 'R', 100, 350, '2007-06-20');


/******************************************************************************/
/***                              Primary keys                              ***/
/******************************************************************************/

ALTER TABLE AGENT ADD CONSTRAINT PK_AGENT PRIMARY KEY (ID_AG);
ALTER TABLE GOODS ADD CONSTRAINT PK_GOODS PRIMARY KEY (ID_GOODS);
ALTER TABLE GOODS_WH ADD CONSTRAINT PK_GOODS_WH PRIMARY KEY (ID);
ALTER TABLE LOG_FILE ADD CONSTRAINT PK_LOG_FILE PRIMARY KEY (ID);
ALTER TABLE OPERATION ADD CONSTRAINT PK_OPER PRIMARY KEY (ID);
ALTER TABLE WAREHOUSE ADD CONSTRAINT PK_WAREHOUSE PRIMARY KEY (ID_WH);


/******************************************************************************/
/***                              Foreign keys                              ***/
/******************************************************************************/

ALTER TABLE GOODS_WH ADD CONSTRAINT FK_GOODS_WH_1 FOREIGN KEY (ID_WH) REFERENCES WAREHOUSE (ID_WH);
ALTER TABLE GOODS_WH ADD CONSTRAINT FK_GOODS_WH_2 FOREIGN KEY (ID_GOODS) REFERENCES GOODS (ID_GOODS);
ALTER TABLE OPERATION ADD CONSTRAINT FK_OP_1 FOREIGN KEY (ID_GOODS) REFERENCES GOODS (ID_GOODS);
ALTER TABLE OPERATION ADD CONSTRAINT FK_OP_2 FOREIGN KEY (ID_AG) REFERENCES AGENT (ID_AG);
ALTER TABLE OPERATION ADD CONSTRAINT FK_OP_3 FOREIGN KEY (ID_WH) REFERENCES WAREHOUSE (ID_WH);


/******************************************************************************/
/***                          Triggers for tables                           ***/
/******************************************************************************/



/* Trigger: GOODS_WH_BI */
CREATE TRIGGER GOODS_WH_BI FOR GOODS_WH ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then new.id = gen_id(gen_goods_wh_id,1);
end

/* Trigger: LOG_FILE_BI */
CREATE TRIGGER LOG_FILE_BI FOR LOG_FILE
ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_log_file_id,1);
end

/* Trigger: OPERATION_BI */
CREATE TRIGGER OPERATION_BI FOR OPERATION
ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = gen_id(gen_operation_id,1);
end

