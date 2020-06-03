-- upiti bez cachea
SHOW VARIABLES LIKE 'query_cache_type';
SET SESSION query_cache_type = OFF;
SHOW VARIABLES LIKE 'query_cache_type';

-- select *
SELECT *
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE kat.naziv = 'IT, telekomunikacije';

-- select kolone
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE kat.naziv = 'IT, telekomunikacije' AND ogl.aktivan = 0;

-- count(*)
SELECT COUNT(*)
  FROM oglasi ogl JOIN kategorije kat ON ogl.kat_id = kat.id;

-- count(1)
SELECT COUNT(1)
  FROM oglasi ogl JOIN kategorije kat ON ogl.kat_id = kat.id;

  SELECT kat.id,
         kat.naziv,
         (SELECT COUNT(1)
            FROM oglasi ogl
           WHERE ogl.kat_id = kat.id) AS "Count"
    FROM kategorije kat
GROUP BY kat.id, kat.naziv
ORDER BY 3 DESC;

-- where s funkcijom
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE DATE_FORMAT(ogl.rok_prijave, '%Y%m%d') > 20200601;

SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
 WHERE DATE_FORMAT(ogl.rok_prijave, '%Y%m%d') > 20200601;

-- where bez funkcije
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.rok_prijave > 20200601;

SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
 WHERE ogl.rok_prijave > 20200601;

-- full-text
-- prije
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE (   ogl.opis_posla LIKE '%javascript%'
        OR ogl.opis_posla LIKE '%sql%'
        OR ogl.naziv LIKE '%javascript%'
        OR ogl.naziv LIKE '%sql%');

-- dodavanje full-text na kolone
ALTER TABLE oglasi
   ADD FULLTEXT (naziv, opis_posla);

-- nakon
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE     ogl.aktivan = 0
       AND (   (MATCH (ogl.opis_posla, ogl.naziv) AGAINST ('javascript' ) )
            OR (MATCH (ogl.opis_posla, ogl.naziv) AGAINST ('sql' ) ));

-- union
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE     ogl.aktivan = 0
       AND MATCH (ogl.opis_posla, ogl.naziv) AGAINST ('HTML' );

-- union all
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.aktivan = 0 AND kat.naziv LIKE 'IT%'
UNION ALL
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       kat.naziv AS 'Kategorija',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN kategorije kat ON ogl.kat_id = kat.id
       JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE     ogl.aktivan = 0
       AND kat.naziv NOT LIKE 'IT%'
       AND MATCH (ogl.opis_posla, ogl.naziv) AGAINST ('HTML' );

-- max, min, order by
-- s min i max
  SELECT id,
         naziv,
         d1 AS "Najraniji datum",
         d2 AS "Najkasniji datum"
    FROM (SELECT kat.id,
                 kat.naziv,
                 (SELECT MIN(ogl.rok_prijave)
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id AND ogl.rok_prijave > SYSDATE())
                    d1,
                 (SELECT MAX(ogl.rok_prijave)
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id)
                    d2
            FROM kategorije kat) t1
ORDER BY ISNULL(d1),
         d1,
         ISNULL(d2),
         d2 DESC,
         naziv;

-- min i order
  SELECT id, naziv, d1 AS "datum"
    FROM (SELECT kat.id,
                 kat.naziv,
                 (SELECT MIN(ogl.rok_prijave)
                    FROM oglasi ogl
                   WHERE ogl.kat_id = kat.id AND ogl.rok_prijave > SYSDATE()) d1
            FROM kategorije kat) t1
ORDER BY ISNULL(d1), d1, naziv;

-- bez min i max sa subquery
  SELECT kat.id,
         kat.naziv,
         t1.rok_prijave,
         t2.rok_prijave
    FROM kategorije kat
         LEFT OUTER JOIN
         (SELECT ogl.kat_id,
                 ogl.rok_prijave,
                 ROW_NUMBER()
                    OVER(PARTITION BY ogl.kat_id ORDER BY ogl.rok_prijave) row_num
            FROM oglasi ogl
           WHERE ogl.rok_prijave > SYSDATE()) t1
            ON kat.id = t1.kat_id
         LEFT OUTER JOIN
         (SELECT ogl.kat_id,
                 ogl.rok_prijave,
                 ROW_NUMBER()
                    OVER(PARTITION BY ogl.kat_id ORDER BY ogl.rok_prijave DESC) row_num
            FROM oglasi ogl) t2
            ON kat.id = t2.kat_id
   WHERE    (t1.row_num = 1 AND t2.row_num = 1)
         OR (t1.row_num IS NULL)
         OR (t2.row_num IS NULL)
ORDER BY t1.rok_prijave, t2.rok_prijave DESC, kat.naziv;

-- bez min, subquery, order
  SELECT id, naziv, rok_prijave
    FROM (SELECT kat.id, kat.naziv, t1.rok_prijave
            FROM kategorije kat
                 LEFT OUTER JOIN
                 (SELECT ogl.kat_id,
                         ogl.rok_prijave,
                         ROW_NUMBER()
                         OVER(PARTITION BY ogl.kat_id ORDER BY ogl.rok_prijave) row_num
                    FROM oglasi ogl
                   WHERE ogl.rok_prijave > SYSDATE()) t1
                    ON kat.id = t1.kat_id
           WHERE t1.row_num = 1 OR t1.row_num IS NULL) t2
ORDER BY ISNULL(rok_prijave), rok_prijave, naziv;

-- in i exists
-- bez
SELECT DISTINCT ogl.id,
                ogl.naziv AS 'Radno mjesto',
                pos.naziv AS 'Poslodavac',
                ogl.url AS 'Link',
                ogl.rok_prijave AS 'Rok prijave',
                ogl.opis_posla AS 'Opis'
  FROM oglasi ogl
       JOIN poslodavci pos ON ogl.pos_id = pos.id
       JOIN oglasi_pojmovi ogp ON ogp.ogl_id = ogl.id
       JOIN pojmovi poj ON ogp.poj_id = poj.id
 WHERE poj.naziv NOT LIKE '%java';

-- in - bolji na malom setu podataka
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE ogl.id IN
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE poj.naziv NOT LIKE '%java');

-- exists - bolji na velikom setu podataka
SELECT ogl.id,
       ogl.naziv AS 'Radno mjesto',
       pos.naziv AS 'Poslodavac',
       ogl.url AS 'Link',
       ogl.rok_prijave AS 'Rok prijave',
       ogl.opis_posla AS 'Opis'
  FROM oglasi ogl JOIN poslodavci pos ON ogl.pos_id = pos.id
 WHERE EXISTS
          (SELECT ogp.ogl_id
             FROM oglasi_pojmovi ogp JOIN pojmovi poj ON ogp.poj_id = poj.id
            WHERE ogp.ogl_id = ogl.id AND poj.naziv NOT LIKE '%java');

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
         prp.naziv AS 'Riječ'
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
