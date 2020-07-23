--
DROP TABLE oglasi_pojmovi;
DROP TABLE oglasi_mjesta;
DROP TABLE oglasi;
DROP TABLE pojmovi;
DROP TABLE kategorije;
DROP TABLE poslodavci;
DROP TABLE mjesta;

--
DROP SEQUENCE MJE_SEQ;
CREATE SEQUENCE MJE_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE mjesta (
  id                  number(30) DEFAULT MJE_SEQ.nextval NOT NULL,
  naziv               varchar2(100) NOT NULL,
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT MJE_NAZIV_UK UNIQUE (naziv)
);

--
DROP SEQUENCE KAT_SEQ;
CREATE SEQUENCE KAT_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE kategorije (
  id                  number(30) DEFAULT KAT_SEQ.nextval NOT NULL,
  naziv               varchar2(100) NOT NULL,
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,  
  PRIMARY KEY (id),
  CONSTRAINT KAT_NAZIV_UK UNIQUE (naziv)
);

--
DROP SEQUENCE POJ_SEQ;
CREATE SEQUENCE POJ_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE pojmovi (
  id                  number(30) DEFAULT POJ_SEQ.nextval NOT NULL,
  naziv               varchar2(100) NOT NULL,
  kat_id              number(30) CONSTRAINT POJ_KAT_ID_FK REFERENCES kategorije (id),
  aktivan             number(1) DEFAULT 0 NOT NULL, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  datum_promjene      timestamp,
  PRIMARY KEY (id),
  CONSTRAINT POJ_NAZIV_UK UNIQUE (naziv)
);
CREATE INDEX POJ_KAT_ID_IDX ON pojmovi (kat_id);
CREATE INDEX POJ_AKTIVAN_IDX ON pojmovi (aktivan); 

--
DROP SEQUENCE POS_SEQ;
CREATE SEQUENCE POS_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE poslodavci (
  id                  number(30) DEFAULT POS_SEQ.nextval NOT NULL,
  naziv               varchar2(200) NOT NULL,
  adresa              varchar2(200),
  mje_id              number(30) CONSTRAINT POS_MJE_ID_FK REFERENCES mjesta (id),
  url                 varchar2(200),
  url_profila         varchar2(400),
  aktivan             number(1) DEFAULT 0 NOT NULL, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  datum_promjene      timestamp,
  PRIMARY KEY (id),
  CONSTRAINT POS_NAZIV_UK UNIQUE (naziv)  
);
CREATE INDEX POS_AKTIVAN_IDX ON poslodavci (aktivan);

--
DROP SEQUENCE OGL_SEQ;
CREATE SEQUENCE OGL_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE oglasi (
  id                  number(30) DEFAULT OGL_SEQ.nextval NOT NULL,
  naziv               varchar2(200) NOT NULL,
  kat_id              number(30) CONSTRAINT OGL_KAT_ID_FK REFERENCES kategorije (id) NOT NULL,
  pos_id              number(30) CONSTRAINT OGL_POS_ID_FK REFERENCES poslodavci (id) NOT NULL,
  url                 varchar2(200) NOT NULL,
  opis_posla          clob,
  rok_prijave         date, 
  aktivan             number(1) DEFAULT 0 NOT NULL, -- 0 - aktivan, 1 - neaktivan
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  datum_promjene      timestamp,
  PRIMARY KEY (id),
  CONSTRAINT OGL_URL_UK UNIQUE (url)
);
CREATE INDEX OGL_NAZIV_IDX ON oglasi (naziv, aktivan, rok_prijave);
CREATE INDEX OGL_AKTIVAN_IDX ON oglasi (aktivan, rok_prijave);
CREATE INDEX OGL_ROK_IDX ON oglasi (rok_prijave, aktivan);
CREATE INDEX OGL_KAT_ID_IDX ON oglasi (kat_id);
CREATE INDEX OGL_POS_ID_IDX ON oglasi (pos_id);

--
DROP SEQUENCE OGM_SEQ;
CREATE SEQUENCE OGM_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE oglasi_mjesta (
  id                  number(30) DEFAULT OGM_SEQ.nextval NOT NULL,
  ogl_id              number(30) CONSTRAINT OGM_OGL_ID_FK REFERENCES oglasi (id) NOT NULL,
  mje_id              number(30) CONSTRAINT OGM_MJE_ID_FK REFERENCES mjesta (id) NOT NULL,
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT OGM_OGL_MJE_UK UNIQUE (ogl_id, mje_id)
);

--
DROP SEQUENCE OGP_SEQ;
CREATE SEQUENCE OGP_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE oglasi_pojmovi (
  id                  number(30) DEFAULT OGP_SEQ.nextval NOT NULL,
  ogl_id              number(30) CONSTRAINT OGP_OGL_ID_FK REFERENCES oglasi (id) NOT NULL,
  poj_id              number(30) CONSTRAINT OGP_POJ_ID_FK REFERENCES pojmovi (id) NOT NULL,
  datum_kreiranja     timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT OGP_OGL_POJ_UK UNIQUE (ogl_id, poj_id)  
);
