-- Query A ----------------
SELECT  *
FROM(
        SELECT CS, AVG(CA) AS AMOUNT
        FROM(
                SELECT CURRENCY_SIGN AS CS, CURRENCY_AMOUT AS CA
                FROM PUBLICATION
                INNER JOIN(
                            SELECT PUBLICATION_ID AS PID
                            FROM PUBLICATION_CONTENT
                            WHERE TITLE_ID = ( SELECT *
                                               FROM(
                                                    SELECT TITLE_ID AS TID
                                                    FROM PUBLICATION_CONTENT
                                                    GROUP BY (TITLE_ID)
                                                    ORDER BY COUNT(*) DESC)
                                               WHERE ROWNUM = 1))
                ON PUBLICATION.PUBLICATION_ID = PID)
        GROUP BY (CS))
WHERE AMOUNT > 0;

-- Query B ----------------
SELECT SRIS_TITLE
FROM TITLE_SERIES
INNER JOIN(   SELECT *
              FROM(
                  SELECT TITSERID
                  FROM(
                          SELECT TITLE.TITLE_ID, TITLE.TIT_SRIS_ID AS TITSERID, TITLE_AWARDS.AWARD_ID
                          FROM TITLE
                          INNER JOIN TITLE_AWARDS
                          ON TITLE.TITLE_ID = TITLE_AWARDS.TITLE_ID AND TITLE.TIT_SRIS_ID IS NOT NULL )
                  GROUP BY (TITSERID)
                  ORDER BY COUNT(*) DESC)
              WHERE ROWNUM < 11 )
ON TITLE_SERIES.TIT_SRIS_ID = TITSERID;

-- Query C ----------------
SELECT A.author_name
FROM Author A
WHERE A.author_id = (SELECT A1.author_id
                     FROM ( SELECT author_id
                            FROM(Awards JOIN Title_awards USING(award_id)
                                 JOIN Publication_content USING (title_id)
                                 JOIN Publication_authors USING (publication_id)
                                 JOIN Author USING (author_id))
                            WHERE award_date > death_date
                            GROUP BY author_id
                            ORDER BY count(*) DESC ) A1
                     WHERE ROWNUM <2 );
-- Query D ----------------
SELECT PUBLISHER_NAME--, PBLSID
FROM PUBLISHER
INNER JOIN  (SELECT PBLSID
                FROM(
                      SELECT PBLSID
                      FROM(
                            SELECT PUBLICATION_ID, PUBLIC_DATE, PUBLISHER_ID AS PBLSID
                            FROM PUBLICATION
                            WHERE EXTRACT(YEAR FROM PUBLICATION.PUBLIC_DATE) = 2000)
                      GROUP BY (PBLSID)
                      ORDER BY COUNT(*) DESC)
                WHERE ROWNUM < 4)
ON PUBLISHER.PUBLISHER_ID = PBLSID;

-- Query E ----------------
SELECT TITLE
FROM TITLE
WHERE TITLE_ID = (
                    SELECT TITLE_ID
                    FROM(
                            SELECT TITLE_ID, COUNT(*)
                            FROM REVIEWS
                            INNER JOIN (
                                          SELECT DISTINCT TITLE_ID PBID1
                                          FROM PUBLICATION_CONTENT
                                          INNER JOIN(
                                                      SELECT PUBLICATION_ID PBID
                                                      FROM PUBLICATION_AUTHORS
                                                      WHERE AUTHOR_ID = 3)
                                          ON PUBLICATION_CONTENT.PUBLICATION_ID = PBID)
                            ON REVIEWS.TITLE_ID = PBID1
                            GROUP BY (TITLE_ID)
                            ORDER BY COUNT(*) DESC)
                    WHERE ROWNUM = 1);
-- Query F ----------------
SELECT TITLE_TYPE, LID2, LANG_NAME, TOP
FROM LANGUAGE
INNER JOIN(
SELECT TITLE_TYPE, LANGUAGE_ID AS LID2, TOP
FROM(
SELECT  TITLE_TYPE, LANGUAGE_ID, DENSE_RANK() OVER(PARTITION BY LANGUAGE_ID ORDER BY TIMES DESC) Top
From(
        SELECT TITLE_TYPE, LANGUAGE_ID, TIMES--, RR
        FROM (
              SELECT TITLE_TYPE, LANGUAGE_ID, COUNT(*) AS TIMES
              FROM(
                    SELECT DISTINCT TITLE_ID, TITLE_TYPE, PARENT_TITLE, LANGUAGE_ID
                    FROM TITLE
                    WHERE PARENT_TITLE > 0)
              GROUP BY(TITLE_TYPE, LANGUAGE_ID)
              ORDER BY LANGUAGE_ID DESC, COUNT(*) DESC )
              )
WHERE LANGUAGE_ID IS NOT NULL
ORDER BY LANGUAGE_ID DESC )
WHERE TOP < 4)
ON LANGUAGE.LANGUAGE_ID = LID2;

-- Query G ---------------- TO BE DECIDED

SELECT YR, SUMNUM/CT
FROM(
      SELECT YR, SUM(NUM) AS SUMNUM, COUNT(DISTINCT PUBLISHER_ID) AS CT
      FROM(
            SELECT PUBLISHER_ID, YR, COUNT(*) AS NUM
            FROM(
                  SELECT PUBLICATION_ID, PUBLISHER_ID, YR, AUTHOR_ID
                  FROM PUBLICATION_AUTHORS
                  INNER JOIN (
                                SELECT * FROM(
                                              SELECT PUBLICATION_ID AS PID, PUBLISHER_ID, EXTRACT(YEAR FROM PUBLIC_DATE) AS YR
                                              FROM PUBLICATION)
                                WHERE YR IS NOT NULL AND PUBLISHER_ID IS NOT NULL)
                  ON PUBLICATION_AUTHORS.PUBLICATION_ID = PID)
            GROUP BY (PUBLISHER_ID, YR))
      GROUP BY YR)

-- Query H ----------------
SELECT A6.PUB_SERIE_NAME
FROM( SELECT pus.PUB_SERIE_NAME, count(A5.TITLE_ID) AS NUM
      FROM( SELECT pu.PUB_SERIE_ID, A4.TITLE_ID
            FROM( SELECT puc.PUBLICATION_ID, A3.TITLE_ID
                  FROM( SELECT ti.TITLE_ID
                        FROM( SELECT aw.AWARD_ID
                              FROM( SELECT awt.AWARD_TYPEID
                                    FROM AWARD_TYPES awt
                                    WHERE awt.AWARD_TYPENAME ='World Fantasy Award') A1
                              INNER JOIN AWARDS aw ON aw.AWARD_TYPEID = A1.AWARD_TYPEID) A2
                        INNER JOIN TITLE_AWARDS ti ON ti.AWARD_ID = A2.AWARD_ID) A3
                  INNER JOIN PUBLICATION_CONTENT puc ON puc.TITLE_ID = A3.TITLE_ID) A4
            INNER JOIN PUBLICATION pu ON pu.PUBLICATION_ID = A4.PUBLICATION_ID) A5
      INNER JOIN PUBLICATION_SERIES pus ON pus.PUB_SERIE_ID = A5.PUB_SERIE_ID
      GROUP BY pus.PUB_SERIE_NAME ORDER BY NUM DESC) A6
WHERE ROWNUM =1;
-- Query i ----------------
SELECT award_catename,author_name
FROM ( (SELECT award_cateid, author_id
        FROM ( SELECT award_cateid, author_id, DENSE_RANK() over (PARTITION BY award_cateid ORDER BY COUNT(author_id) DESC) As rank1
               FROM ( SELECT Award_id, author_id, award_cateid
                      FROM ((select Award_id, author_id
                            from  ((select title_id, author_id
                                    from ((select Publication_id, author_id
                                          from (Author JOIN Publication_authors USING (Author_id)))
                                                JOIN Publication_content USING (Publication_id))
                                           JOIN Title_awards USING (title_id))
                                    JOIN Title_awards USING (title_id)))
                            JOIN Awards USING (Award_id)))
               GROUP BY award_cateid, author_id )
         WHERE rank1<4 ) A1
         JOIN Award_categories USING (award_cateid)
         JOIN Author USING (author_id))

-- Query J ----------------
SELECT  DISTINCT AUTHOR_ID, AUTHOR_NAME, BIRTH_DATE --,PUBID, PUBLIC_TYPE,
FROM PUBLICATION
INNER JOIN (
            SELECT AUTHOR_ID, AUTHOR_NAME, PUBID, BIRTH_DATE
            FROM PUBLICATION_CONTENT
            INNER JOIN(
                      SELECT AUTHOR_ID, AUTHOR_NAME, PUBID, BIRTH_DATE
                      FROM AUTHOR
                      INNER JOIN(
                                    SELECT PUBID, AUTHOR_ID AS AID
                                    FROM PUBLICATION_AUTHORS
                                    INNER JOIN (    SELECT PUBLICATION_ID AS PUBID
                                                    FROM PUBLICATION   )
                                    ON PUBLICATION_AUTHORS.PUBLICATION_ID = PUBID)
                      ON AUTHOR.AUTHOR_ID = AID
                      WHERE AUTHOR.DEATH_DATE IS NULL)
            ON PUBLICATION_CONTENT.PUBLICATION_ID = PUBID )
ON PUBLICATION.PUBLICATION_ID = PUBID
WHERE PUBLIC_TYPE = 'ANTHOLOGY' AND BIRTH_DATE IS NOT NULL
ORDER BY (BIRTH_DATE) DESC;
-- THE RESULTS ARE THE SAME BUT THE SECOND ON CONSIDER MORE SCENARIOS
SELECT DISTINCT AUTHOR_ID, AUTHOR_NAME, BIRTH_DATE
FROM AUTHOR
INNER JOIN(
            SELECT AID, PID, TITLE_ID
            FROM PUBLICATION
            INNER JOIN (
                        SELECT AUTHOR_ID AID, PUBLICATION_ID AS PID, TITLE_ID
                        FROM PUBLICATION_AUTHORS
                        INNER JOIN(
                                    SELECT PUBLICATION_ID PUBID, TITLE_ID
                                    FROM PUBLICATION_CONTENT
                                    INNER JOIN(
                                              SELECT TITLE_ID AS TID
                                              FROM TITLE
                                              WHERE TITLE_TYPE = 'ANTHOLOGY')
                                    ON PUBLICATION_CONTENT.TITLE_ID = TID)
                        ON PUBLICATION_AUTHORS.PUBLICATION_ID = PUBID)
            ON PUBLICATION.PUBLICATION_ID = PID
            WHERE PUBLICATION.PUBLIC_TYPE = 'ANTHOLOGY')
ON AUTHOR.AUTHOR_ID = AID
WHERE BIRTH_DATE IS NOT NULL
ORDER BY (BIRTH_DATE) DESC;
-- Query K ----------------
SELECT AVG(TIMES)
FROM(
      SELECT PSI, COUNT(*) AS TIMES
      FROM(
            SELECT PUBLICATION_ID, PSI
            FROM PUBLICATION
            INNER JOIN(
                        SELECT PUB_SERIE_ID AS PSI
                        FROM PUBLICATION_SERIES)
            ON PUBLICATION.PUB_SERIE_ID = PSI)
      GROUP BY (PSI));

-- Query L ----------------
SELECT au.AUTHOR_NAME
FROM( SELECT pa.AUTHOR_ID, count(A2.TITLE_ID) AS NUM
      FROM( SELECT pc.PUBLICATION_ID, A1.TITLE_ID
            FROM( SELECT re.TITLE_ID
                  FROM REVIEWS re
                  INNER JOIN TITLE t ON re.TITLE_ID = t.TITLE_ID) A1
            INNER JOIN PUBLICATION_CONTENT pc ON pc.TITLE_ID = A1.TITLE_ID) A2
      INNER JOIN PUBLICATION_AUTHORS pa ON pa.PUBLICATION_ID = A2.PUBLICATION_ID
      GROUP BY pa.AUTHOR_ID ORDER BY NUM DESC) A3
INNER JOIN AUTHOR au ON au.AUTHOR_ID = A3.AUTHOR_ID
WHERE ROWNUM =1;


-- Query M ----------------
SELECT A7.LANG_NAME, au.AUTHOR_NAME
FROM (SELECT la.LANG_NAME, A6.AUTHOR_ID
      FROM( SELECT A5.LANGUAGE_ID, A5.AUTHOR_ID
            FROM( SELECT A4.LANGUAGE_ID, A4.AUTHOR_ID, DENSE_RANK() over (PARTITION BY A4.LANGUAGE_ID ORDER BY COUNT( A4.AUTHOR_ID) DESC) As RANK_1
                  FROM (SELECT A3.LANGUAGE_ID, pa.AUTHOR_ID
                        FROM( SELECT A2.LANGUAGE_ID, pu.PUBLICATION_ID
                              FROM ( SELECT t2.TITLE_ID , t2.LANGUAGE_ID
                                      FROM( SELECT t.PARENT_TITLE
                                            FROM TITLE t
                                            WHERE t.PARENT_TITLE !=0 AND t.TITLE_TYPE = 'NOVEL' AND t.LANGUAGE_ID IS NOT NULL) A1
                                      INNER JOIN TITLE t2 ON A1.PARENT_TITLE = t2.TITLE_ID) A2
                              INNER JOIN PUBLICATION_CONTENT pu ON pu.TITLE_ID = A2.TITLE_ID) A3
                        INNER JOIN PUBLICATION_AUTHORS pa ON pa.PUBLICATION_ID = A3.PUBLICATION_ID) A4
                  GROUP BY A4.LANGUAGE_ID, A4.AUTHOR_ID ) A5
                  WHERE A5.RANK_1<4) A6
      INNER JOIN LANGUAGE la ON la.LANGUAGE_ID = A6.LANGUAGE_ID) A7
INNER JOIN AUTHOR au ON au.AUTHOR_ID = A7.AUTHOR_ID ORDER BY A7.LANG_NAME;

-- Query N ----------------

SELECT Author_name
FROM (Author
      JOIN  ( SELECT Author_id
              FROM  ( SELECT Author_id, SUM(Public_pages_2) as page, SUM(currency_amout) as money
                      FROM (Publication JOIN Publication_authors USING (Publication_id)
                           JOIN Author USING (author_id))
                      WHERE Currency_sign='$'
                      GROUP BY Author_id )
              WHERE Money<>0
              ORDER BY Page/Money DESC )
      USING (Author_id))
WHERE ROWNUM < 11

-- Query O ----------------
SELECT *
FROM(
      SELECT PUBID3, COUNT(*) --, AID3, TITSRS3, PUBSHR3, PUBSEREID3
      FROM WEBPAGE
      INNER JOIN(
         SELECT DISTINCT PUBLICATION_ID AS PUBID3, AUTHOR_ID AS AID3, TIT_SRIS_ID AS TITSRS3, PUBLISHER_ID AS PUBSHR3, PUB_SERIE_ID AS PUBSEREID3
         FROM PUBLICATION
         INNER JOIN(
               SELECT PUBLICATION_ID AS PUBID2, AUTHOR_ID, TIT_SRIS_ID
               FROM PUBLICATION_AUTHORS
               INNER JOIN (
                     SELECT PUBLICATION_ID AS PUBID, TIT_SRIS_ID
                     FROM PUBLICATION_CONTENT
                     INNER JOIN (
                           SELECT TITLE_ID AS TIDWITHTS, TIT_SRIS_ID
                           FROM TITLE
                           INNER JOIN(
                                 SELECT TITLE_ID AS TID
                                 FROM TITLE_AWARDS
                                 INNER JOIN (
                                      SELECT AWARD_ID AS AID
                                      FROM AWARDS
                                      INNER JOIN (
                                            SELECT AWARD_TYPEID AS ATID
                                            FROM AWARD_TYPES
                                            WHERE AWARD_TYPECODE = 'Ne')
                                      ON AWARDS.AWARD_TYPEID = ATID)
                                 ON TITLE_AWARDS.AWARD_ID = AID)
                           ON TITLE.TITLE_ID = TID)
                     ON PUBLICATION_CONTENT.TITLE_ID = TIDWITHTS)
                ON PUBLICATION_AUTHORS.PUBLICATION_ID = PUBID)
         ON PUBLICATION.PUBLICATION_ID = PUBID2)
      ON WEBPAGE.AUTHOR_ID = AID3 OR WEBPAGE.PUBLISHER_ID = PUBSHR3 OR WEBPAGE.PUB_SERIE_ID = PUBSEREID3 OR WEBPAGE.TIT_SRIS_ID = TITSRS3
      GROUP BY (PUBID3)
      ORDER BY COUNT(*) DESC)

WHERE ROWNUM < 11;
