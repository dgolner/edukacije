-- select *
SELECT *
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE kat.naziv = 'IT, telekomunikacije';

-- select kolone
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE kat.naziv = 'IT, telekomunikacije' AND ogl.aktivan = 0;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR 
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE kat.naziv = 'IT, telekomunikacije' AND ogl.aktivan = 0;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- count(*)
SELECT COUNT(*)
  FROM oglasi ogl JOIN kategorije kat ON ogl.kat_id = kat.id;

-- count(1)
SELECT COUNT(1)
  FROM oglasi ogl JOIN kategorije kat ON ogl.kat_id = kat.id;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT COUNT(1)
  FROM oglasi ogl JOIN kategorije kat ON ogl.kat_id = kat.id;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));
  
  SELECT kat.id,
         kat.naziv,
         (SELECT COUNT(1)
            FROM oglasi ogl
           WHERE ogl.kat_id = kat.id) AS "Count"
    FROM kategorije kat
GROUP BY kat.id, kat.naziv
ORDER BY 3 DESC;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
  SELECT kat.id,
         kat.naziv,
         (SELECT COUNT(1)
            FROM oglasi ogl
           WHERE ogl.kat_id = kat.id) AS "Count"
    FROM kategorije kat
GROUP BY kat.id, kat.naziv
ORDER BY 3 DESC;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- where s funkcijom
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE TO_NUMBER(TO_CHAR(ogl.rok_prijave, 'yyyymmdd')) > 20201201;

SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
 WHERE TO_NUMBER(TO_CHAR(ogl.rok_prijave, 'yyyymmdd')) > 20201201;
 
-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
 WHERE TO_NUMBER(TO_CHAR(ogl.rok_prijave, 'yyyymmdd')) > 20201201;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- where bez funkcije
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.rok_prijave > '01.12.20';

SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
 WHERE ogl.rok_prijave > '01.12.20';

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl
 WHERE ogl.rok_prijave > '01.12.20';
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- union
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0
       AND (ogl.opis_posla LIKE '%HTML%' OR ogl.naziv LIKE '%HTML%');

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0
       AND (ogl.opis_posla LIKE '%HTML%' OR ogl.naziv LIKE '%HTML%');
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- union all
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION ALL
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0
       AND kat.naziv NOT LIKE 'IT%'
       AND (ogl.opis_posla LIKE '%HTML%' OR ogl.naziv LIKE '%HTML%');

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION ALL
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave",
       kat.naziv AS "Kategorija"
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0
       AND kat.naziv NOT LIKE 'IT%'
       AND (ogl.opis_posla LIKE '%HTML%' OR ogl.naziv LIKE '%HTML%');
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- max, min, subquery, order by
-- s min i max
  SELECT id,
         naziv,
         d1 AS "Najraniji datum",
         d2 AS "Najkasniji datum"
    FROM (SELECT kat.id,
                 kat.naziv,
                 (SELECT MIN(ogl.rok_prijave)
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id AND ogl.rok_prijave > SYSDATE)
                    d1,
                 (SELECT MAX(ogl.rok_prijave)
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id)
                    d2
            FROM kategorije kat) t1
ORDER BY d1 NULLS first,
         d2 DESC NULLS first,
         naziv;

-- max, subquery, order by
  SELECT id,
         naziv,
         (SELECT MAX(ogl.rok_prijave)
            FROM oglasi ogl
           WHERE ogl.kat_id = kat.id) AS "Najkasniji datum"
    FROM kategorije kat
ORDER BY "Najkasniji datum" NULLS first,
         naziv;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
  SELECT id,
         naziv,
         (SELECT MAX(ogl.rok_prijave)
            FROM oglasi ogl
           WHERE ogl.kat_id = kat.id) AS "Najkasniji datum"
    FROM kategorije kat
ORDER BY "Najkasniji datum" NULLS first,
         naziv;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- bez max, subquery, order
  SELECT id,
         naziv,
         (SELECT rok_prijave 
            FROM (SELECT ogl.rok_prijave
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id 
                ORDER BY ogl.rok_prijave DESC)
           WHERE ROWNUM < 2) AS "Najkasniji datum"
    FROM kategorije kat
ORDER BY "Najkasniji datum" NULLS first,
         naziv;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
  SELECT id,
         naziv,
         (SELECT rok_prijave 
            FROM (SELECT ogl.rok_prijave
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id 
                ORDER BY ogl.rok_prijave DESC)
           WHERE ROWNUM < 2) AS "Najkasniji datum"
    FROM kategorije kat
ORDER BY "Najkasniji datum" NULLS first,
         naziv;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- in i exists
-- bez
SELECT DISTINCT ogl.id,
                ogl.naziv AS "Radno mjesto",
                pos.naziv AS "Poslodavac",
                ogl.url AS "Link",
                ogl.rok_prijave AS "Rok prijave"
  FROM oglasi ogl
       JOIN poslodavci pos ON ogl.pos_id = pos.id
       JOIN oglasi_pojmovi ogp ON ogp.ogl_id = ogl.id
       JOIN pojmovi poj ON ogp.poj_id = poj.id
 WHERE poj.naziv NOT LIKE '%Java%';

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT DISTINCT ogl.id,
                ogl.naziv AS "Radno mjesto",
                pos.naziv AS "Poslodavac",
                ogl.url AS "Link",
                ogl.rok_prijave AS "Rok prijave"
  FROM oglasi ogl
       JOIN poslodavci pos ON ogl.pos_id = pos.id
       JOIN oglasi_pojmovi ogp ON ogp.ogl_id = ogl.id
       JOIN pojmovi poj ON ogp.poj_id = poj.id
 WHERE poj.naziv NOT LIKE '%Java%';
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- in - bolji na malom setu podataka
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.id IN
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE poj.naziv NOT LIKE '%Java%');

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "Link",
       ogl.rok_prijave AS "Rok prijave"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.id IN
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE poj.naziv NOT LIKE '%Java%');
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- exists - bolji na velikom setu podataka
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "'Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE EXISTS
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE ogp.ogl_id = ogl.id AND poj.naziv NOT LIKE '%Java%');

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
SELECT ogl.id,
       ogl.naziv AS "Radno mjesto",
       pos.naziv AS "Poslodavac",
       ogl.url AS "'Link",
       ogl.rok_prijave AS "Rok prijave",
       ogl.opis_posla AS "Opis"
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE EXISTS
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE ogp.ogl_id = ogl.id AND poj.naziv NOT LIKE '%Java%');
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));

-- with
WITH
 pojmovnik AS (
 	 SELECT poj.id, 
            poj.kat_id, 
            poj.naziv
	   FROM pojmovi poj
      WHERE poj.aktivan = 0
 ),
 it_oglasi AS (
	SELECT ogl.id, 
	       ogl.naziv AS radno_mjesto, 
	       pos.naziv AS "Poslodavac", 
	       ogl.url AS "Link", 
	       ogl.rok_prijave AS "Rok prijave", 
	       ogl.opis_posla AS "Opis"
 	  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 ),
 pretraga_pojmova AS (
	SELECT ogp.ogl_id, 
	       poj.naziv
	  FROM oglasi_pojmovi ogp JOIN pojmovnik poj ON ogp.poj_id = poj.id
 )
  SELECT ito.*, 
         prp.naziv AS "Riječ"
    FROM it_oglasi ito JOIN pretraga_pojmova prp ON ito.id = prp.ogl_id
ORDER BY prp.naziv, ito.radno_mjesto;

-- najpopularniji pojmovi
WITH
 pojmovnik AS (
    SELECT poj.id, 
           poj.naziv
      FROM pojmovi poj
     WHERE poj.aktivan = 0
 ),
 pretraga_pojmova AS (
    SELECT ogl.id,
           poj.naziv
      FROM oglasi ogl 
      JOIN oglasi_pojmovi ogp ON ogl.id = ogp.id
      JOIN pojmovnik poj ON ogp.poj_id = poj.id
     WHERE ogl.aktivan = 0
 )
  SELECT naziv, 
         COUNT(1)
    FROM pretraga_pojmova prp
GROUP BY naziv
ORDER BY COUNT(1) DESC;

-- explain plan upita
EXPLAIN PLAN SET statement_id = 'ST' FOR
WITH
 pojmovnik AS (
    SELECT poj.id, 
           poj.naziv
      FROM pojmovi poj
     WHERE poj.aktivan = 0
 ),
 pretraga_pojmova AS (
    SELECT ogl.id,
           poj.naziv
      FROM oglasi ogl 
      JOIN oglasi_pojmovi ogp ON ogl.id = ogp.id
      JOIN pojmovnik poj ON ogp.poj_id = poj.id
     WHERE ogl.aktivan = 0
 )
  SELECT naziv, 
         COUNT(1)
    FROM pretraga_pojmova prp
GROUP BY naziv
ORDER BY COUNT(1) DESC;
SELECT * FROM TABLE(dbms_xplan.Display(NULL, 'ST'));
