-- 1. Найти поставщиков, которые работали с товаром «Папки».
SELECT A.NAME_AG
FROM AGENT A
WHERE A.ID_AG IN
      (SELECT O.ID_AG
       FROM OPERATION O
       WHERE O.ID_GOODS IN
             (SELECT G.ID_GOODS
              FROM GOODS G
              WHERE G.NOMENCLATURE = 'Папки'));

-- 2. Найти товары, с которыми не было ни одной операции.
SELECT G.NOMENCLATURE
FROM GOODS G
WHERE G.ID_GOODS NOT IN
      (SELECT O.ID_GOODS
       FROM OPERATION O);

-- ИЛИ
SELECT G.NOMENCLATURE
FROM GOODS G
WHERE NOT EXISTS
    (SELECT *
     FROM OPERATION O
     WHERE O.ID_GOODS = G.ID_GOODS);

-- 3. Найти поставщиков, которые выполнили только одну поставку.
SELECT A.NAME_AG
FROM AGENT A
WHERE SINGULAR
          (SELECT *
	FROM OPERATION O
	WHERE A.ID_AG = O.ID_AG AND O.TYPEOP = 'A');

-- 4. Найти поставщиков, которые поставляли (операции A) карандаши по минимальной цене.
SELECT A.NAME_AG
FROM AGENT A
         JOIN OPERATION O USING (ID_AG)
         JOIN GOODS G USING (ID_GOODS)
WHERE O.TYPEOP = 'A'
  AND G.NOMENCLATURE = 'Карандаши(10 шт)'
  AND O.PRICE <=
    ALL (SELECT O2.PRICE
         FROM OPERATION O2
         WHERE O2.ID_GOODS = (SELECT G2.ID_GOODS
                              FROM GOODS G2
                              WHERE G2.NOMENCLATURE = 'Карандаши(10 шт)'));

-- 5. Найти склады, с которыми не было ни одной операции.
SELECT W.NAME
FROM WAREHOUSE W
WHERE W.ID_WH NOT IN
      (SELECT O.ID_WH
       FROM OPERATION O);

-- 6. Найти поставщиков, которые работают более чем с одним складом.
SELECT A.NAME_AG
FROM AGENT A
WHERE NOT SINGULAR
    (SELECT DISTINCT O.ID_WH
        FROM OPERATION O
        WHERE O.ID_AG = A.ID_AG AND O.TYPEOP = 'A')
  AND A.ID_AG IN
      (SELECT O2.ID_AG
       FROM OPERATION O2
       WHERE O2.TYPEOP = 'A');

-- 7. Найти товары, для которых была выполнена только одна поставка (A)
SELECT G.NOMENCLATURE
FROM GOODS G
WHERE SINGULAR(SELECT O.ID_GOODS
        FROM OPERATION O
        WHERE O.ID_GOODS = G.ID_GOODS AND O.TYPEOP = 'A');

-- 8. Найти товары, которые поставщик «Надежный» поставлял по наибольшей цене.
SELECT G.NOMENCLATURE
FROM GOODS G
         JOIN OPERATION O USING (ID_GOODS)
         JOIN AGENT A USING (ID_AG)
WHERE A.NAME_AG = 'Надежный'
  AND O.TYPEOP = 'A'
  AND O.PRICE >= ALL (SELECT O2.PRICE
                      FROM OPERATION O2
                               JOIN AGENT A2 USING (ID_AG)
                      WHERE O2.ID_GOODS = O.ID_GOODS
                        AND A2.NAME_AG
    != 'Надежный'
  AND O2.TYPEOP = 'A');


-- 9. Найти товары, с которыми было больше всего операций
SELECT G.NOMENCLATURE
FROM GOODS G
         LEFT JOIN OPERATION O USING (ID_GOODS)
WHERE (SELECT COUNT(O1.ID_GOODS)
       FROM GOODS G1
                LEFT JOIN OPERATION O1 USING (ID_GOODS)
       WHERE O1.ID_GOODS = O.ID_GOODS) >=
          ALL (SELECT COUNT(O2.ID_GOODS)
               FROM GOODS G2
                        LEFT JOIN OPERATION O2 USING (ID_GOODS)
               GROUP BY G2.NOMENCLATURE)
GROUP BY G.NOMENCLATURE;