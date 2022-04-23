CREATE TABLE zadanie_2 AS SELECT * FROM(
SELECT
    regexp_substr(tekst, '^[^.]*')*1 AS ID,
    regexp_substr(tekst, '\w+\s\S*') AS dzien,
    regexp_substr(tekst, '\d{4}')*1 AS rok,
    TRIM(regexp_replace(regexp_substr(tekst, '([0-9]{4}\s)[A-Z]+[\s|-]{0,1}[A-Z]+[^K-]'),'([0-9]{4}\s)', '')) AS skocznia,
    regexp_replace(regexp_substr(tekst, '[-]\d+'), '-', '')*1 AS punkt_k,
    CASE
        WHEN tekst LIKE '%HS-%' THEN REPLACE(regexp_substr(tekst,'(HS-)[0-9]+'),'HS-','')*1
        ELSE NULL
    END hill_size,
    regexp_substr(tekst, '[0-9]+[,][0-9]')*1 AS skok_1,
    CASE
        WHEN REGEXP_LIKE (tekst, '[m]\s[–]') THEN NULL
        ELSE (regexp_replace(regexp_substr(tekst, '[m]\s[0-9]+[,][0-9]\s[m]'), '[m\s]', ''))*1
    END skok_2,
    regexp_replace(regexp_substr(tekst, '[0-9]+[,][0-9]\s(pkt)\s\d'), '\s(pkt)\s[0-9]', '')*1 AS nota,
    TRIM(REPLACE(regexp_substr(tekst, '(\s\d\.)'), '.',''))*1 AS lokata,
    CASE
        WHEN REGEXP_LIKE (tekst, '(\d\.\s\W)') THEN NULL
        ELSE regexp_replace(regexp_substr(tekst, '(\s\d\.\s[0-9]+,[0-9]+)'),('\s\d\.\s'),'')*1
    END strata,
    REPLACE(REPLACE(substr(tekst, instr(tekst,'pkt ',-1)), 'pkt ', ''),'1. –', '') AS zwyciezca
FROM dw.skoki);
