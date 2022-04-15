CREATE MATERIALIZED VIEW MV_ZADANIE_1 AS
SELECT
    s.TIME_ID AS DATA,
    t.CALENDAR_WEEK_NUMBER AS NR_TYGODNIA,
    t.CALENDAR_MONTH_NUMBER AS NR_MIESIACA,
    SUM(s.QUANTITY_SOLD) AS LICZBA_ZAMOWIEN,
    ROUND(SUM(s.AMOUNT_SOLD),2) AS SUMA_ZAMOWIEN_DZIEN,
    ROUND((SUM(s.AMOUNT_SOLD)/SUM(SUM(s.AMOUNT_SOLD)) OVER (PARTITION BY t.CALENDAR_WEEK_NUMBER)*100), 2)|| '%' AS UDZIAL_ZAMOWIEN_TYDZIEN,
    RANK () OVER (PARTITION BY t.CALENDAR_MONTH_NUMBER ORDER BY SUM(s.AMOUNT_SOLD)DESC) AS RANKING_ZAMOWIEN_MIESIAC,
    ROUND(AVG(SUM(s.AMOUNT_SOLD)) OVER(ORDER BY s.TIME_ID ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING), 2) AS SREDNIA_KWOTA_ZAMOWIEN_7_DNI
FROM SH.SALES s
LEFT JOIN SH.TIMES t ON s.TIME_ID = t.TIME_ID
WHERE s.TIME_ID BETWEEN ('00/01/03') AND ('00/12/31')
GROUP BY (s.TIME_ID,t.CALENDAR_WEEK_NUMBER, t.CALENDAR_MONTH_NUMBER)
ORDER BY 1;

CREATE MATERIALIZED VIEW ZADANIE_2 AS SELECT * FROM ZADANIE_1;
CREATE UNIQUE INDEX ZADANIE_2_IDX_1 ON MV_ZADANIE_2(DATA);
CREATE BITMAP INDEX ZADANIE_2_IDX_2 ON MV_ZADANIE_2(NR_MIESIACA);

DROP MATERIALIZED VIEW MV_ZADANIE_1;
DROP MATERIALIZED VIEW MV_ZADANIE_2;
