-- 1.
create or alter procedure Task1(
    WH_NAME type of column WAREHOUSE.NAME)
returns(
    W_NAME type of column WAREHOUSE.NAME)
as
    declare variable ID_W type of column WAREHOUSE.ID_WH;
    declare variable SUM_W type of column GOODS_WH.QUANTITY;
begin
    ID_W = (select W.ID_WH from WAREHOUSE W where W.NAME = :WH_NAME);
    if (:ID_W is NULL) then exception;
        SUM_W = (select SUM(GWH.QUANTITY) from GOODS_WH GWH where GWH.ID_WH = :ID_W);
        for select WH2.NAME
            from WAREHOUSE WH2 join GOODS_WH GWH2 using(ID_WH)
            where
                (select SUM(GWH3.QUANTITY)
                    from GOODS_WH GWH3
                    where GWH3.ID_WH != :ID_W) > :SUM_W
                group by WH2.NAME
        into :W_NAME do
    suspend;
end

EXECUTE PROCEDURE GOODSBYAGENT('????? 1');