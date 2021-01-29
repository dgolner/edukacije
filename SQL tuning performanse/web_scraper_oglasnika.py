# coding: utf-8
#
import urllib.request
from bs4 import BeautifulSoup
import requests

"""
web scraper
"""

class WebScraper(object):

    """ učitavanje """
    def __init__(self):
        foutmysql = open('web_scraper_mysql.sql', 'w', encoding='utf-8')
        foutoraclesql = open('web_scraper_oracle.sql', 'w', encoding='utf-8')
        url = []

        for i in range(1, 29):
            for j in range(1, 51):
                url.append('https://www.moj-posao.net/Pretraga-Poslova/?searchWord=&keyword=&job_title=&job_title_id=&area=&category=' + str(i) + '&page=' + str(j))

        mjesta = dict()
        mjesta_id = 0
        poslodavci = dict()
        poslodavci_id = 0
        oglasi = dict()
        oglasi_id = 0
        oglasi_mjesta = dict()
        oglasi_mjesta_id = 0
        br_linkova = 0
        br_gresaka_parse = 0
        counter = 0
        linkovi = dict()

        for link in url:
            conn = urllib.request.urlopen(link)
            start = 0
            startJob = 0
            linkOglas = None
            job_position = None
            title = None
            opis_posla = None

            t1 = str.find(link, '&category=') + len('&category=')
            t2 = str.find(link, '&page=')
            kat_id = link[t1:t2]

            for line in conn:
                tmp = line.strip().decode("utf-8")

                if len(tmp) < 4:
                    continue
                if 'javascript:void(0)' in tmp:
                    continue
                if "'<li>'" in tmp or "'<div class=\"job-data\">'" in tmp or "'<p class=\"job-title\">'" in tmp:
                    continue
                if "'<a class=\"title recommender-click-searchlist\" href=\"'" in tmp or "'<br />'" in tmp:
                    continue
                if "'<p class=\"job-company\">'" in tmp or "'<p class=\"deadline\">'" in tmp or "'</div>'" in tmp or "'</li>'" in tmp:
                    continue
                if 'rel="nofollow"' in tmp:
                    tmp = tmp.replace(' rel="nofollow"', '')
                    #continue
                # preskakanje poslova u regiji
                # if '"job type-regional"' in tmp:
                #     continue

                if 'class="featured-job"' in tmp:
                    if start == 0:
                        start = 1
                        counter = counter + 1
                if '</li>' in tmp and start == 1:
                    start = 0

                if 'class="job type-' in tmp:
                    if start == 0:
                        start = 1
                        counter = counter + 1

                if '<a href="' in tmp and start == 1:
                    t1 = str.find(tmp, '<a href="') + len('<a href="')
                    t2 = str.find(tmp, '" class="logo">')
                    linkProfil = tmp[t1:t2]

                if '<p class="job-company">' in tmp and start == 1:
                    t1 = str.find(tmp, '<a href="') + len('<a href="')
                    t2 = str.find(tmp, '/">') + 1
                    linkProfil = tmp[t1:t2]

                if 'title="' in tmp and start == 1:
                    t1 = str.find(tmp, 'title="') + len('title="')
                    t2 = str.find(tmp, '" ')
                    title = str.strip(tmp[t1:t2])
                    if len(str.strip(title)) == 0:
                        continue

                    if str.strip(title) not in poslodavci:
                        poslodavci_id = poslodavci_id + 1
                        poslodavci[str.strip(title)] = (poslodavci_id, linkProfil)

                if '<p class="job-company"><a href="' in tmp and start == 1:
                    t1 = str.find(tmp, '/">') + len('/">')
                    t2 = str.find(tmp, '</a>')
                    title = str.strip(tmp[t1:t2]).replace("'", "''")
                    if len(str.strip(title)) == 0:
                        continue

                    if str.strip(title) not in poslodavci:
                        poslodavci_id = poslodavci_id + 1
                        poslodavci[str.strip(title)] = (poslodavci_id, linkProfil)

                if title is None and '<p class="job-company">' in tmp and start == 1:
                    t1 = str.find(tmp, '">') + len('">')
                    t2 = str.find(tmp, '</p>')
                    title = str.strip(tmp[t1:t2]).replace("'", "''")
                    if len(str.strip(title)) == 0:
                        continue

                    if str.strip(title) not in poslodavci:
                        poslodavci_id = poslodavci_id + 1
                        poslodavci[str.strip(title)] = (poslodavci_id, linkProfil)

                if '<p id="client-info"><span>Poslodavac:' in tmp:
                    continue

                if (('" href="' in tmp) or ('<a href="' in tmp)) and start == 1:
                    if '" href="' in tmp:
                        t1 = str.find(tmp, '" href="') + len('" href="')
                        if '">' in tmp:
                            t2 = str.find(tmp, '">')
                        else:
                            t2 = str.find(tmp, '/"') + 1
                    else:
                        if '<a href="' in tmp and ' >' in tmp:
                            tmp = tmp.strip()
                            t1 = str.find(tmp, '<a href="') + len('<a href="')
                            t2 = str.find(tmp, '">')
                        else:
                            if '<a href="' in tmp and '/">' in tmp:
                                tmp = tmp.strip()
                                t1 = str.find(tmp, '<a href="') + len('<a href="')
                                t2 = str.find(tmp, '">')
                            else:
                                continue

                    linkOglas = tmp[t1:t2]
                    linkOglas = str.strip(linkOglas)
                    br_linkova = br_linkova + 1
                    if linkOglas not in linkovi:
                        linkovi[linkOglas] = linkOglas

                    if linkOglas is not None and len(linkOglas) > 0 and start == 1:
                        html_text = requests.get(linkOglas).text
                        soup = BeautifulSoup(html_text, 'html.parser')
                        opis_posla = None
                        for l in soup.find_all(id='job-htmlad'):
                            opis_posla = l.get_text()
                        for l in soup.find_all(id='job-description'):
                            opis_posla = l.get_text()

                        try:
                            conn2 = urllib.request.urlopen(linkOglas)
                            for line2 in conn2:
                                tmp = line2.strip().decode("utf-8")
                                if '<li class="job-company">' in tmp:
                                    t1 = str.find(tmp, '<li class="job-company">') + len('<li class="job-company">')
                                    t2 = str.find(tmp, '</li>')
                                    title = str.strip(tmp[t1:t2]).replace("'", "''")
                                    if len(str.strip(title)) == 0:
                                        continue

                                    if str.strip(title) not in poslodavci:
                                        poslodavci_id = poslodavci_id + 1
                                        poslodavci[str.strip(title)] = (poslodavci_id, linkProfil)
                                    break

                                if '<span id="client-info-incognito">' in tmp:
                                    t1 = str.find(tmp, '<span id="client-info-incognito">') + len('<span id="client-info-incognito">')
                                    t2 = str.find(tmp, ' </span>')
                                    title = str.strip(tmp[t1:t2]).replace("'", "''")
                                    if len(str.strip(title)) == 0:
                                        continue

                                    if str.strip(title) not in poslodavci:
                                        poslodavci_id = poslodavci_id + 1
                                        poslodavci[str.strip(title)] = (poslodavci_id, linkProfil)
                                    break
                        except:
                            continue

                if '<span class="job-position  ">' in tmp:
                    if startJob == 0:
                        startJob = 1
                    else:
                       startJob = 0

                if '</span>' in tmp and startJob == 1:
                    t2 = str.find(tmp, '</span>')
                    job_position = str.strip(tmp[:t2])
                    startJob = 0

                if '<p class="job-title">' in tmp:
                    if startJob == 0:
                        startJob = 1
                    else:
                       startJob = 0

                if '</a>' in tmp and startJob == 1:
                    tmp = tmp.strip()
                    t2 = str.find(tmp.strip(), '</a>')
                    job_position = str.strip(tmp[:t2])
                    startJob = 0

                if (('<span class="job-location">' in tmp) or ('<p class="job-location">' in tmp)) and start == 1:
                    if '<span class="job-location">' in tmp:
                        t1 = str.find(tmp, '<span class="job-location">') + len('<span class="job-location">')
                        t2 = str.find(tmp, '</span>')
                    else:
                        t1 = str.find(tmp, '<p class="job-location">') + len('<p class="job-location">')
                        t2 = str.find(tmp, '</p>')
                    location = tmp[t1:t2]
                    t = location.split(',')
                    for i in t:
                        if str.strip(i) not in mjesta and len(str.strip(i)) > 1:
                            mjesta_id = mjesta_id + 1
                            mjesta[str.strip(i)] = mjesta_id

                if 'class="deadline"' in tmp and start == 1:
                    datum = None
                    if '<time class="deadline" datetime="' in tmp:
                        t1 = str.find(tmp, '<time class="deadline" datetime="') + len('<time class="deadline" datetime="') + 18
                        t2 = str.find(tmp, '</time>')
                        datum = tmp[t1:t2]
                    else:
                        if '<time datetime="' in tmp:
                            t1 = str.find(tmp, '<time datetime="') + len('<time datetime="') + 18
                            t2 = str.find(tmp, '</time>')
                            datum = tmp[t1:t2]

                    # svi parametri s oglasa
                    if len(linkOglas) > 0 and linkOglas not in oglasi:
                        try:
                            oglasi_id = oglasi_id + 1
                            if opis_posla == None:
                                oglasi[linkOglas] = (oglasi_id, job_position, kat_id, poslodavci[title][0], opis_posla, datum)
                            else:
                                oglasi[linkOglas] = (oglasi_id, job_position, kat_id, poslodavci[title][0], str.strip(opis_posla.replace("'", "")), datum)
                            oglasi_mjesta[oglasi_id] = []
                            for i in t:
                                if str.strip(i) in mjesta:
                                    oglasi_mjesta_id = oglasi_mjesta_id + 1
                                    oglasi_mjesta[oglasi_id].append((oglasi_mjesta_id, mjesta[str.strip(i)]))
                            job_position = None
                            linkOglas = None
                            title = None
                            opis_posla = None
                            datum = None
                        except:
                            br_gresaka_parse = br_gresaka_parse + 1

                if '</time></p>' in tmp and start == 1:
                    start = 0

        for k, v in mjesta.items():
            sql = "insert into mjesta (id, naziv) values (" + str(v) + ", '" + k + "');"
            foutmysql.write(sql + '\n')
            foutoraclesql.write(sql + '\n')
        print("Broj slogova mjesta: " + str(len(mjesta)))

        for k, v in poslodavci.items():
            sql = "insert into poslodavci (id, naziv, url_profila) values (" + str(v[0]) + ", '" + k + "', '" + v[1] + "');"
            foutmysql.write(sql + '\n')
            foutoraclesql.write(sql + '\n')
        print("Broj slogova poslodavci: " + str(len(poslodavci)))

        for k, v in oglasi.items():
            if v[4] == None:
                sql1 = "insert into oglasi (id, naziv, kat_id, pos_id, url, opis_posla, rok_prijave) values (" + str(v[0]) + ", '" + v[1] + "', " + str(v[2]) + ", " + str(v[3]) + ", '" + k + "', null, str_to_date('" + v[5] + "', '%d.%m.%Y.'));"
                sql2 = "insert into oglasi (id, naziv, kat_id, pos_id, url, opis_posla, rok_prijave) values (" + str(v[0]) + ", '" + v[1] + "', " + str(v[2]) + ", " + str(v[3]) + ", '" + k + "', null, to_date('" + v[5] + "', 'dd.mm.yyyy.'));"
                foutmysql.write(sql1 + '\n')
                foutoraclesql.write(sql2 + '\n')
            else:
                try:
                    sql1 = "insert into oglasi (id, naziv, kat_id, pos_id, url, opis_posla, rok_prijave) values (" + str(
                        v[0]) + ", '" + v[1] + "', " + str(v[2]) + ", " + str(v[3]) + ", '" + k + "', '" + v[4] + \
                          "', str_to_date('" + v[5] + "', '%d.%m.%Y.'));"
                    foutmysql.write(sql1 + '\n')
                    if len(v[4]) > 3000:
                        sql2 = "insert into oglasi (id, naziv, kat_id, pos_id, url, opis_posla, rok_prijave) values (" + str(
                            v[0]) + ", '" + v[1] + "', " + str(v[2]) + ", " + str(v[3]) + ", '" + k + "', '" + v[4][:3000] + \
                              "', to_date('" + v[5] + "', 'dd.mm.yyyy.'));"
                        foutoraclesql.write(sql2 + '\n')
                        t = v[4][3000:]
                        while len(t) > 0:
                            sql2 = "update oglasi set opis_posla = opis_posla || '" + t[:3000] + "' where id = " + str(v[0]) + ";"
                            foutoraclesql.write(sql2 + '\n')
                            t = t[3000:]
                    else:
                        sql2 = "insert into oglasi (id, naziv, kat_id, pos_id, url, opis_posla, rok_prijave) values (" + str(
                            v[0]) + ", '" + v[1] + "', " + str(v[2]) + ", " + str(v[3]) + ", '" + k + "', '" + v[4] + \
                              "', to_date('" + v[5] + "', 'dd.mm.yyyy.'));"
                        foutoraclesql.write(sql2 + '\n')
                except:
                    continue
        print("Broj slogova oglasi: " + str(len(oglasi)))

        br_gresaka = 0
        br_slogova = 0
        for k, v in oglasi_mjesta.items():
            try:
                for i in v:
                    sql1 = "insert into oglasi_mjesta (id, ogl_id, mje_id) values (" + str(i[0]) + ", " + str(k) + ", " + str(i[1]) + ") on duplicate key update ogl_id = ogl_id;"
                    sql2 = "insert /*+ ignore_row_on_dupkey_index (oglasi_mjesta (ogl_id, mje_id)) */ into oglasi_mjesta (id, ogl_id, mje_id) values (" + str(i[0]) + ", " + str(k) + ", " + str(i[1]) + ");"
                    foutmysql.write(sql1 + '\n')
                    foutoraclesql.write(sql2 + '\n')
                    br_slogova = br_slogova + 1
            except:
                br_gresaka = br_gresaka + 1
        print("Broj slogova oglasi_mjesta: " + str(br_slogova))
        print("Broj grešaka insert into oglasi_mjesta: " + str(br_gresaka))
        print("Broj pronađenih linkova s oglasima: " + str(br_linkova))
        print("Broj grešaka u parsiranju: " + str(br_gresaka_parse))
        print("Broj pronađenih oglasa prema tagovima: " + str(counter))
        foutmysql.close()
        foutoraclesql.close()

print('---------------------')
rjecnik = WebScraper()
print('---------------------')
