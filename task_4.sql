WITH cte AS (
SELECT * FROM 
(
SELECT
CAST(TRIM(regexp_substr(review,'(\s{0,2}[a-zA-Z]*\s{0,2})')) AS VARCHAR2(100)) AS slowo,
rating
FROM dw.reviews
)
PIVOT
(
COUNT(rating)
FOR rating 
IN (1 A, 2 B, 3 C, 4 D, 5 E)
))
SELECT
slowo,
A+B+C+D+E AS liczba_wystapien,
CASE WHEN A/(A+B+C+D+E)= 0 THEN Null ELSE round(A/(A+B+C+D+E),2) END "1_UDZIAL_OCEN",
CASE WHEN B/(A+B+C+D+E)= 0 THEN Null ELSE round(B/(A+B+C+D+E),2) END "2_UDZIAL_OCEN",
CASE WHEN C/(A+B+C+D+E)= 0 THEN Null ELSE round(C/(A+B+C+D+E),2) END "3_UDZIAL_OCEN",
CASE WHEN D/(A+B+C+D+E)= 0 THEN Null ELSE round(D/(A+B+C+D+E),2) END "4_UDZIAL_OCEN",
CASE WHEN E/(A+B+C+D+E)= 0 THEN Null ELSE round(E/(A+B+C+D+E),2) END "5_UDZIAL_OCEN"
FROM cte
WHERE (A+B+C+D+E)> 50
ORDER BY liczba_wystapien DESC, slowo ASC;
