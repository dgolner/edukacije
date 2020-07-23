-- pojmovi s kategorijom - punjenje s like
insert into oglasi_pojmovi (ogl_id, poj_id)
  select ogl.id, poj.id
  from oglasi ogl join pojmovi poj on ogl.kat_id = poj.kat_id
  where ogl.aktivan = 0 and (ogl.naziv like concat('%', poj.naziv, '%') or ogl.opis_posla like concat('%', poj.naziv, '%')) and
  ogl.naziv not like '%powerpoint%' and ogl.opis_posla not like '%powerpoint%' and
  ogl.naziv not like '%enterprise%' and ogl.opis_posla not like '%enterprise%' and
  ogl.naziv not like '%erpa%' and ogl.opis_posla not like '%erpa%' and
  ogl.naziv not like '%erpe%' and ogl.opis_posla not like '%erpe%';
commit;
-- pojmovi bez kategorije - punjenje s like
insert into oglasi_pojmovi (ogl_id, poj_id)
  select ogl.id, poj.id
  from oglasi ogl, (select id, naziv from pojmovi where aktivan = 0 and kat_id is null) poj
  where ogl.aktivan = 0 and (ogl.naziv like concat('%', poj.naziv, '%') or ogl.opis_posla like concat('%', poj.naziv, '%')) and
  ogl.naziv not like '%powerpoint%' and ogl.opis_posla not like '%powerpoint%' and
  ogl.naziv not like '%enterprise%' and ogl.opis_posla not like '%enterprise%' and
  ogl.naziv not like '%erpa%' and ogl.opis_posla not like '%erpa%' and
  ogl.naziv not like '%erpe%' and ogl.opis_posla not like '%erpe%';
commit;
