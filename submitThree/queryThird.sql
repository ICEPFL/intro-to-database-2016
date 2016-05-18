-- Query A ----------------
SELECT CS, AVG(CA)
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
GROUP BY (CS)

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
SELECT AUTHOR_NAME, AUTHOR_ID
FROM AUTHOR
WHERE AUTHOR_ID = (
              SELECT AUTHOR_ID
              FROM(
                    SELECT AUTHOR_ID, COUNT(*)
                    FROM(
                          SELECT DISTINCT TITLE_ID, AUTHOR_ID, AWARD_ID, DEATH_DATE, AWARD_DATE
                          FROM AWARDS
                          INNER JOIN(
                                      SELECT TITLE_ID, AUTHOR_ID, AWARD_ID AS AID2, DEATH_DATE
                                      FROM TITLE_AWARDS
                                      INNER JOIN(
                                                  SELECT TITLE_ID AS TID, AUTHOR_ID, AUTHOR_NAME, PUBID, DEATH_DATE
                                                  FROM PUBLICATION_CONTENT
                                                  INNER JOIN(
                                                              SELECT AUTHOR_ID, AUTHOR_NAME, PUBID, DEATH_DATE
                                                              FROM AUTHOR
                                                              INNER JOIN(
                                                                            SELECT PUBID, AUTHOR_ID AS AID
                                                                            FROM PUBLICATION_AUTHORS
                                                                            INNER JOIN (    SELECT PUBLICATION_ID AS PUBID
                                                                                            FROM PUBLICATION   )
                                                                            ON PUBLICATION_AUTHORS.PUBLICATION_ID = PUBID)
                                                              ON AUTHOR.AUTHOR_ID = AID
                                                              WHERE AUTHOR.DEATH_DATE < TO_DATE('2016-01-01', 'YYYY-MM-DD'))
                                                  ON PUBLICATION_CONTENT.PUBLICATION_ID = PUBID )
                                      ON TITLE_AWARDS.TITLE_ID = TID)
                          ON AWARDS.AWARD_ID = AID2
                          WHERE AWARD_DATE > DEATH_DATE)
                    GROUP BY (AUTHOR_ID)
                    ORDER BY COUNT(*) DESC)
              WHERE ROWNUM = 1);

-- Query D ----------------
SELECT PUBLISHER_NAME, PBLSID
FROM PUBLISHER
INNER JOIN  (SELECT PBLSID
                FROM(
                      SELECT PBLSID
                      FROM(
                            SELECT PUBLICATION_ID, PUBLIC_DATE, PUBLISHER_ID AS PBLSID
                            FROM PUBLICATION
                            WHERE EXTRACT(YEAR FROM PUBLICATION.PUBLIC_DATE) = 2001)
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
SELECT TITLE_TYPE, LANGUAGE_ID, RR
FROM (
      SELECT TITLE_TYPE, LANGUAGE_ID, COUNT(*), ROW_NUMBER() OVER(PARTITION BY LANGUAGE_ID ORDER BY COUNT(*)) AS RR
      FROM(
            SELECT DISTINCT TITLE_ID, TITLE_TYPE, PARENT_TITLE, LANGUAGE_ID
            FROM TITLE
            WHERE PARENT_TITLE > 0)
      GROUP BY(TITLE_TYPE, LANGUAGE_ID)
      ORDER BY LANGUAGE_ID DESC, COUNT(*) DESC  );
-- Query G ----------------
SELECT YR, PUBLISHER_ID, COUNT(*)
FROM(
      SELECT AUTHOR_ID, YR, PUBLISHER_ID
      FROM PUBLICATION_AUTHORS
      INNER JOIN(
                  SELECT  PUBLICATION_ID AS PBID, EXTRACT(YEAR FROM PUBLICATION.PUBLIC_DATE) AS YR, PUBLISHER_ID
                  FROM PUBLICATION )
      ON PUBLICATION_AUTHORS.PUBLICATION_ID = PBID)
GROUP BY (YR, PUBLISHER_ID);
--- check correctness  of G ----
SELECT COUNT(*)
FROM(
      SELECT AUTHOR_ID, YR, PUBLISHER_ID
            FROM PUBLICATION_AUTHORS
            INNER JOIN(
                        SELECT  PUBLICATION_ID AS PBID, EXTRACT(YEAR FROM PUBLICATION.PUBLIC_DATE) AS YR, PUBLISHER_ID
                        FROM PUBLICATION )
            ON PUBLICATION_AUTHORS.PUBLICATION_ID = PBID)
WHERE PUBLISHER_ID = 19 AND YR = 1958

-- Query H ----------------
SELECT PUB_SERIE_NAME
FROM PUBLICATION_SERIES
INNER JOIN (
              SELECT PUB_SERIE_ID AS PSI, NUMB
              FROM(
                    SELECT PUB_SERIE_ID, COUNT(*) AS NUMB
                    FROM(
                          SELECT PUBLICATION_ID, PUB_SERIE_ID, TITLE_ID
                          FROM PUBLICATION
                          INNER JOIN(
                                      SELECT PUBLICATION_ID AS PUBID, TITLE_ID
                                      FROM PUBLICATION_CONTENT
                                      INNER JOIN(
                                                  SELECT TITLE_ID AS TID
                                                  FROM TITLE_AWARDS
                                                  INNER JOIN(
                                                                SELECT AWARD_ID AID
                                                                FROM AWARDS
                                                                INNER JOIN(
                                                                            SELECT AWARD_TYPEID AS ATID
                                                                            FROM AWARD_TYPES
                                                                            WHERE AWARD_TYPECODE = 'Wf')
                                                                ON AWARDS.AWARD_TYPEID = ATID)
                                                  ON TITLE_AWARDS.AWARD_ID = AID)
                                      ON PUBLICATION_CONTENT.TITLE_ID = TID )
                          ON PUBLICATION.PUBLICATION_ID = PUBID)
                    GROUP BY (PUB_SERIE_ID)
                    ORDER BY COUNT(*) DESC )
              WHERE ROWNUM < 3 )
ON PUBLICATION_SERIES.PUB_SERIE_ID = PSI;
-- Query i ----------------
SELECT AUTHOR_ID, ACID, COUNT(*), ROW_NUMBER() OVER(PARTITION BY ACID ORDER BY COUNT(*)) AS RR
FROM(
      SELECT DISTINCT AUTHOR_ID, AWARD_ID, ACID
      FROM PUBLICATION_AUTHORS
      INNER JOIN(
                  SELECT PUBLICATION_ID AS PBID, TITLE_ID, AWARD_ID, ACID
                  FROM PUBLICATION_CONTENT
                  INNER JOIN(

                                        SELECT TITLE_ID AS TID, AWARD_ID, ACID
                                        FROM TITLE_AWARDS
                                        INNER JOIN (
                                                    SELECT AWARD_ID AS AWID, ACID
                                                    FROM AWARDS
                                                    INNER JOIN(
                                                                SELECT AWARD_CATEID AS ACID
                                                                FROM AWARD_CATEGORIES)
                                                    ON AWARDS.AWARD_CATEID = ACID )
                                        ON TITLE_AWARDS.AWARD_ID = AWID)
                  ON PUBLICATION_CONTENT.TITLE_ID = TID)
      ON PUBLICATION_AUTHORS.PUBLICATION_ID = PBID)
GROUP BY (ACID, AUTHOR_ID)
ORDER BY ACID DESC
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
