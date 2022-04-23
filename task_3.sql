CREATE VIEW v_zadanie_3 AS SELECT * FROM(
WITH tab_1 AS (
SELECT
CH.channel_desc AS kanal,
SUM(sa.amount_sold) AS udzial
FROM sh.sales PARTITION (sales_q2_1998) sa
LEFT JOIN sh.channels CH ON sa.channel_id = CH.channel_id 
LEFT JOIN sh.products pr ON sa.prod_id = pr.prod_id
WHERE sa.time_id BETWEEN '98/05/01' AND '98/05/31' AND pr.prod_id IN(46,140,137)
GROUP BY (CH.channel_desc)),
tab_2 AS (SELECT SUM(udzial) AS razem FROM tab_1)
SELECT 
kanal, 
(round(udzial/(SELECT razem FROM tab_2)*100,2)) AS udzial_procentowy FROM tab_1);
