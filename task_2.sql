CREATE TABLE ZADANIE_2 AS SELECT * FROM(
SELECT
    regexp_substr(tekst, '^[^.]*')*1 AS ID,
    regexp_substr(tekst, '\w+\s\S*') AS DZIEN,
    regexp_substr(tekst, '\d{4}')*1 AS ROK,
    regexp_replace(regexp_substr(tekst, '([0-9]{4}\s)[A-Z]+[\s|-]{0,1}[A-Z]+[^K-]'),'([0-9]{4}\s)', '') AS SKOCZNIA,
    regexp_replace(regexp_substr(tekst, '[-]\d+'), '-', '')*1 AS PUNKT_K,
    CASE
        WHEN tekst LIKE '%HS-%' THEN replace(regexp_substr(tekst,'(HS-)[0-9]+'),'HS-','')*1
        ELSE Null
    END HILL_SIZE,
    regexp_substr(tekst, '[0-9]+[,][0-9]')*1 AS SKOK_1,
    CASE
        WHEN REGEXP_LIKE (tekst, '[m]\s[–]') THEN NULL
        ELSE (regexp_replace(regexp_substr(tekst, '[m]\s[0-9]+[,][0-9]\s[m]'), '[m\s]', ''))*1
    END SKOK_2,
    regexp_replace(regexp_substr(tekst, '[0-9]+[,][0-9]\s(pkt)\s\d'), '\s(pkt)\s[0-9]', '')*1 AS NOTA,
    replace(TRIM(regexp_substr(tekst, '(\s\d\.)')), '.','')*1 AS LOKATA,
    CASE
        WHEN REGEXP_LIKE (tekst, '(\d\.\s\W)') THEN Null
        ELSE regexp_replace(regexp_substr(tekst, '(\s\d\.\s[0-9]+,[0-9]+)'),('\s\d\.\s'),'')*1
    END STRATA,
    replace(replace(substr(tekst, instr(tekst,'pkt ',-1)), 'pkt ', ''),'1. –', '') AS ZWYCIEZCA
FROM DW.SKOKI);
