--
DROP TABLE IF EXISTS oglasi_pojmovi;
DROP TABLE IF EXISTS oglasi_mjesta;
DROP TABLE IF EXISTS oglasi;
DROP TABLE IF EXISTS pojmovi;
DROP TABLE IF EXISTS kategorije;
DROP TABLE IF EXISTS poslodavci;
DROP TABLE IF EXISTS mjesta;

--
CREATE TABLE mjesta (
  id                  int NOT NULL AUTO_INCREMENT,
  naziv               varchar(100) NOT NULL,
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY MJE_NAZIV_UK (naziv)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

--
CREATE TABLE kategorije (
  id                  int NOT NULL AUTO_INCREMENT,
  naziv               varchar(100) NOT NULL,
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  UNIQUE KEY KAT_NAZIV_UK (naziv)
) CHARACTER SET utf8mb4;

--
CREATE TABLE pojmovi (
  id                  int NOT NULL AUTO_INCREMENT,
  naziv               varchar(100) NOT NULL,
  kat_id              int,
  aktivan             int NOT NULL DEFAULT 0, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datum_promjene      datetime,
  PRIMARY KEY (id),
  UNIQUE KEY POJ_NAZIV_UK (naziv),
  KEY POJ_KAT_ID_IDX (kat_id),
  KEY POJ_AKTIVAN_IDX (aktivan),
  CONSTRAINT POJ_KAT_ID_FK FOREIGN KEY (kat_id) REFERENCES kategorije (id)
) CHARACTER SET utf8mb4;

--
CREATE TABLE poslodavci (
  id                  int NOT NULL AUTO_INCREMENT,
  naziv               varchar(200) BINARY NOT NULL,
  adresa              varchar(200) CHARACTER SET utf8mb4,
  mje_id              int,
  url                 varchar(200),
  url_profila         varchar(400),
  aktivan             int NOT NULL DEFAULT 0, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datum_promjene      datetime,
  PRIMARY KEY (id),
  UNIQUE KEY POS_NAZIV_UK (naziv),
  KEY POS_AKTIVAN_IDX (aktivan),
  CONSTRAINT POS_MJE_ID_FK FOREIGN KEY (mje_id) REFERENCES mjesta (id)
) CHARACTER SET utf8mb4;

--
CREATE TABLE oglasi (
  id                  int NOT NULL AUTO_INCREMENT,
  naziv               varchar(200) NOT NULL,
  kat_id              int NOT NULL,
  pos_id              int NOT NULL,
  url                 varchar(200) NOT NULL,
  opis_posla          varchar(15000),
  rok_prijave         date, 
  aktivan             int NOT NULL DEFAULT 0, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  datum_promjene      datetime,
  PRIMARY KEY (id),
  UNIQUE KEY OGL_URL_UK (url),
  KEY OGL_NAZIV_IDX (naziv, aktivan, rok_prijave),
  KEY OGL_AKTIVAN_IDX (aktivan, rok_prijave),
  KEY OGL_ROK_IDX (rok_prijave, aktivan),
  KEY OGL_KAT_ID_IDX (kat_id),
  KEY OGL_POS_ID_IDX (pos_id),
  CONSTRAINT OGL_KAT_ID_FK FOREIGN KEY (kat_id) REFERENCES kategorije (id),
  CONSTRAINT OGL_POS_ID_FK FOREIGN KEY (pos_id) REFERENCES poslodavci (id)
) CHARACTER SET utf8mb4;
-- ALTER TABLE oglasi ADD FULLTEXT (naziv, opis_posla);

--
CREATE TABLE oglasi_mjesta (
  id                  int NOT NULL AUTO_INCREMENT,
  ogl_id              int NOT NULL,
  mje_id              int NOT NULL,
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY OGM_OGL_MJE_UK (ogl_id, mje_id),
  CONSTRAINT OGM_OGL_ID_FK FOREIGN KEY (ogl_id) REFERENCES oglasi (id),
  CONSTRAINT OGM_MJE_ID_FK FOREIGN KEY (mje_id) REFERENCES mjesta (id)
) CHARACTER SET utf8mb4;

--
CREATE TABLE oglasi_pojmovi (
  id                  int NOT NULL AUTO_INCREMENT,
  ogl_id              int NOT NULL,
  poj_id              int NOT NULL,
  datum_kreiranja     datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY OGP_OGL_POJ_UK (ogl_id, poj_id),
  CONSTRAINT OGP_OGL_ID_FK FOREIGN KEY (ogl_id) REFERENCES oglasi (id),
  CONSTRAINT OGP_POJ_ID_FK FOREIGN KEY (poj_id) REFERENCES pojmovi (id)
) CHARACTER SET utf8mb4;
