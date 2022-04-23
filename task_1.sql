CREATE MATERIALIZED VIEW mv_zadanie_1 AS
SELECT
    S.time_id AS DATA,
    T.calendar_week_number AS nr_tygodnia,
    T.calendar_month_number AS nr_miesiaca,
    SUM(S.quantity_sold) AS liczba_zamowien,
    round(SUM(S.amount_sold),2) AS suma_zamowien_dzien,
    round((SUM(S.amount_sold)/SUM(SUM(S.amount_sold)) OVER (PARTITION BY T.calendar_week_number)*100), 2)|| '%' AS udzial_zamowien_tydzien,
    RANK () OVER (PARTITION BY T.calendar_month_number ORDER BY SUM(S.amount_sold)DESC) AS ranking_zamowien_miesiac,
    round(AVG(SUM(S.amount_sold)) OVER(ORDER BY S.time_id ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING), 2) AS srednia_kwota_zamowien_7_dni
FROM sh.sales S
LEFT JOIN sh.times T ON S.time_id = T.time_id
WHERE S.time_id BETWEEN ('00/01/03') AND ('00/12/31')
GROUP BY (S.time_id,T.calendar_week_number, T.calendar_month_number)
ORDER BY 1;

CREATE MATERIALIZED VIEW mv_zadanie_2 AS SELECT * FROM zadanie_1;
CREATE UNIQUE INDEX zadanie_2_idx_1 ON mv_zadanie_2(DATA);
CREATE BITMAP INDEX zadanie_2_idx_2 ON mv_zadanie_2(nr_miesiaca);

DROP MATERIALIZED VIEW mv_zadanie_1;
DROP MATERIALIZED VIEW mv_zadanie_2;
