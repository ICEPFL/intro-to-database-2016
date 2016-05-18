


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
                     
