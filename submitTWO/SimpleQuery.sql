/* Note from Yvan : I think the queries are good !, still there is some issues with query d) and e).
In query d) the public_pages from the table publication is not an INTEGER so we cannot compare them easily
also, public_page actually also contain Latin notation (like XVII) so maybe it could be good to add an attribute to the Publication table with only the Latin notation as a VARCHAR and the rest stays in public_pages but as a INT ?
IN query e) The problem comes from the Currency_amout that has type VARCHAR but we schould change it to FLOAT.*/

/* Query a) */

SELECT DISTINCT EXTRACT(YEAR FROM P.public_date) AS Year, count(P.publication_id) AS Numb_Publication
FROM Publication P, Publication_authors PA
WHERE P.publication_id=PA.publication_id
GROUP BY  EXTRACT(YEAR FROM P.public_date);


/* Query b) */
SELECT A1.author_name
FROM Author A1
WHERE A1.author_id IN ( SELECT A2.author_id
                        FROM (  SELECT DISTINCT PA.author_id
                                FROM Publication_authors PA
                                GROUP BY PA.author_id
                                ORDER BY count(*) DESC ) A2
                        WHERE ROWNUM <11 );
                        
/* Query c) */
SELECT A1.AUTHOR_NAME AS YOUNGEST, A3.AUTHOR_NAME AS OLDEST
FROM (  SELECT DISTINCT  A2.AUTHOR_NAME, EXTRACT(YEAR FROM A2.BIRTH_DATE) AS Years, EXTRACT (MONTH FROM A2.BIRTH_DATE) AS Months ,EXTRACT(DAY FROM A2.BIRTH_DATE)AS Days
        FROM AUTHOR A2, Publication_authors PA, Publication P
        WHERE A2.Author_ID = PA.author_id and PA.publication_id= P.publication_id and extract(year from P.public_date)= '2010' AND A2.BIRTH_DATE IS NOT NULL
        ORDER BY Years DESC, Months DESC, Days DESC) A1,
        (SELECT DISTINCT  A2.AUTHOR_NAME, EXTRACT(YEAR FROM A2.BIRTH_DATE) AS Years, EXTRACT (MONTH FROM A2.BIRTH_DATE) AS Months ,EXTRACT(DAY FROM A2.BIRTH_DATE)AS Days
        FROM AUTHOR A2, Publication_authors PA, Publication P
        WHERE A2.Author_ID = PA.author_id and PA.publication_id= P.publication_id and extract(year from P.public_date)= '2010' AND A2.BIRTH_DATE IS NOT NULL
        ORDER BY Years ASC, Months ASC, Days ASC) A3
WHERE ROWNUM = 1;

/* Query d) */

select count(*)
From Title T, Publication_content PC, Publication P
where T.title_id=PC.title_id and PC.publication_id= P.publication_id and T.TITLE_GRAPH = 'YES' and 
      P.public_pages < 50;

select count(*)
From Title T, Publication_content PC, Publication P
where T.title_id=PC.title_id and PC.publication_id= P.publication_id and T.TITLE_GRAPH = 'YES' and 
      P.public_pages<100;
      
select count(*)
From Title T, Publication_content PC, Publication P
where T.title_id=PC.title_id and PC.publication_id= P.publication_id and T.TITLE_GRAPH = 'YES' and 
      P.public_pages>=100;


/*Note from Jiande: 1.for question 4 I dont know how to merge them into one output at the same time;
      2.It seems that for our data type definition, we should use "DATE" for every column that contains date. */

/* Query e) */

SELECT DISTINCT P.Publisher_name, AVG(U.currency_amont)
FROM Publisher P, Publication U
WHERE P.Publisher_ID = U.Publisher_ID AND U.Public_type = 'NOVEL' AND U.currency_sign='$' GROUP BY P.Publisher_name;

/* Query f) */

SELECT a5.Author_Name
FROM Author a5
WHERE a5.AUTHOR_ID= ( SELECT pa.AUTHOR_ID
                      FROM PUBLICATION_AUTHORS pa, PUBLICATION_CONTENT pc, TITLE t1
                      WHERE pc.PUBLICATION_ID = pa.PUBLICATION_ID
                      AND pc.TITLE_ID= t1.TITLE_ID
                      AND t1.TITLE_ID IN ( SELECT t2.TITLE_ID
                                            FROM Title_tags t2, Tags al
                                            WHERE t2.TAG_ID = al.TAG_ID
                                            AND al.TAG_NAME='science fiction')
                                            GROUP BY (pa.Author_ID)
                                            HAVING count(*) = (SELECT max(count(*))
                                                                FROM PUBLICATION_AUTHORS pa2, PUBLICATION_CONTENT pc2, TITLE t3
                                                                WHERE pc2.PUBLICATION_ID = pa2.PUBLICATION_ID
                                                                AND pc2.TITLE_ID= t3.TITLE_ID
                                                                AND t3.TITLE_ID IN ( SELECT t4.TITLE_ID
                                                                FROM Title_tags t4, Tags al2
                                                                WHERE t4.TAG_ID = al2.TAG_ID
                                                                AND al2.TAG_NAME='science fiction')
                                                                GROUP BY (pa2.Author_ID)));

/* Query g) Alternative 1 */

SELECT  t.TITLE, A3.somme
FROM( SELECT A1.TITLE_ID, A1.Num2 + A2.Num AS somme
      FROM (SELECT ta.TITLE_ID, count(ta.AWARD_ID) AS Num2
            FROM TITLE_AWARDS ta
            GROUP BY ta.TITLE_ID) A1, (SELECT r1.TITLE_ID,count(r1.REVIEW_ID) AS Num
            FROM REVIEWS r1
            GROUP BY r1.TITLE_ID) A2
      WHERE A1.TITLE_ID=A2.TITLE_ID
      ORDER BY somme DESC)A3, TITLE t
WHERE A3.TITLE_ID=t.TITLE_ID AND  ROWNUM <=3;


/* Query g) Alternative 2 (I think this one is better) */

SELECT t1.TITLE, A4.SOMME
FROM (SELECT A3.TITLE_ID /*, A3.NumAward, A3.NumReview*/, A3.NumAward+A3.NumReview AS Somme
      FROM( SELECT A2.TITLE_ID, NVL(A1.Num2,0)AS NumAward, NVL(A2.Num,0) AS NumReview
            FROM (SELECT ta.TITLE_ID, count(ta.AWARD_ID) AS Num2
                  FROM TITLE_AWARDS ta
                  GROUP BY ta.TITLE_ID) A1
            FULL JOIN ( SELECT r1.TITLE_ID,count(r1.REVIEW_ID) AS Num
                        FROM REVIEWS r1
                        GROUP BY r1.TITLE_ID) A2
            ON A1.TITLE_ID = A2.TITLE_ID) A3
      ORDER BY Somme DESC) A4, TITLE t1
WHERE A4.TITLE_ID = t1.TITLE_ID AND ROWNUM <=3 ;















