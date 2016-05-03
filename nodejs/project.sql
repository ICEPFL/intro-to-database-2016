CREATE TABLE Language
    (   Language_ID         INTEGER,
        lang_Name           VARCHAR(128),
        Language_Code       VARCHAR(128),
        Language_Script     VARCHAR(128),
        PRIMARY KEY (Language_ID));
		
        
CREATE TABLE Note
    (   noteID      INTEGER,
        NOTE        CLOB, 
        PRIMARY KEY (noteID));
		
        
CREATE TABLE Tags(
    Tag_ID          INTEGER,
    Tag_name        VARCHAR(128),
    PRIMARY KEY (Tag_ID));
	
    
CREATE TABLE Title_series(
    Tit_sris_ID        INTEGER,
    Sris_title         VARCHAR(512),
    Sris_parent        INTEGER,
    noteID             INTEGER,

    PRIMARY KEY (Tit_sris_ID),
  /*  FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Tit_sris_ID),*/
    FOREIGN KEY (noteID)   	    REFERENCES Note(noteID));

CREATE TABLE Title(
    Title_ID                INTEGER,
    Title                   VARCHAR(2048), 
    transla_lang            VARCHAR(512),
 /*   name_of_transla         VARCHAR(512),  */
    Title_synopsis          INTEGER,
    noteID                  INTEGER, 
    Tit_sris_ID             INTEGER,
    Series_num              VARCHAR(32),
    Story_len               VARCHAR(64),
    Title_type              VARCHAR(64),
    Parent_title            INTEGER,
    Language_ID             INTEGER,
    Title_graph             VARCHAR(16),

    PRIMARY KEY (Title_ID),
  /*  FOREIGN KEY (Parent_title)      REFERENCES Title(Title_ID),*/
    FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID),
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Title_synopsis)    REFERENCES Note(noteID),
    FOREIGN KEY (Tit_sris_ID)       REFERENCES Title_series(Tit_sris_ID));


    
CREATE TABLE Title_tags(
    Tagmap_ID      INTEGER, 
    Tag_ID         INTEGER,
    Title_ID       INTEGER,

    PRIMARY KEY (Tagmap_ID),
    FOREIGN KEY (Tag_ID)      REFERENCES Tags(Tag_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID));
    
CREATE TABLE Reviews(
    Rev_ID         INTEGER, 
    Title_ID       INTEGER,
    Review_ID      INTEGER,

    PRIMARY KEY(Rev_ID),
    FOREIGN KEY(Title_ID)    REFERENCES Title(Title_ID),
    FOREIGN KEY(Review_ID)   REFERENCES Title(Title_ID));

  
CREATE TABLE Award_types(
    Award_typeID         INTEGER,
    Award_typeCode       VARCHAR(512),
    Award_typeName       VARCHAR(512),
    noteID               INTEGER,   
    Award_by             VARCHAR(512),
    Award_for            VARCHAR(512),
    short_name           VARCHAR(512),
    poll                 VARCHAR(16),
    Awd_type_Non_g       VARCHAR(64),
 
    PRIMARY KEY (Award_typeID),
    FOREIGN KEY (noteID) REFERENCES Note(noteID));
    
CREATE TABLE Award_categories(
    Award_cateID         INTEGER,
    Award_cateName       VARCHAR(128),
    Award_cate_typeID    INTEGER,
    Award_cateOrd        VARCHAR(32),
    noteID               INTEGER,
 /*    Award_typeID         INTEGER NOT NULL,*/

    PRIMARY KEY (Award_cateID),
/*    FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID) ON DELETE CASCADE,*/
    FOREIGN KEY (noteID)       REFERENCES Note(noteID));
      
CREATE TABLE Awards(
    Award_ID          INTEGER,
    Award_title       VARCHAR(1024),
    Award_date        DATE,
    Award_typeCode    VARCHAR(128),
    Award_typeID      INTEGER  NOT NULL,
    Award_cateID      INTEGER,
    noteID            INTEGER,

    PRIMARY KEY (Award_ID),
    FOREIGN KEY (Award_typeID)     REFERENCES Award_types(Award_typeID),
    FOREIGN KEY (Award_cateID)     REFERENCES Award_categories(Award_cateID),
    FOREIGN KEY (noteID)           REFERENCES Note(noteID));
    
CREATE TABLE Title_awards(
    taw_ID          INTEGER,
    Award_ID        INTEGER,
    Title_ID        INTEGER,

    PRIMARY KEY (taw_ID),
    FOREIGN KEY (Award_ID)    REFERENCES Awards(Award_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID));
     
       

CREATE TABLE Publication_series
    (    Pub_Serie_ID    INTEGER,
         Pub_Serie_Name  VARCHAR(1024),
         noteID          INTEGER,
         
        PRIMARY KEY (Pub_Serie_ID),
        FOREIGN KEY (noteID)       REFERENCES Note(noteID));
        

CREATE TABLE Publisher
    (   Publisher_ID     INTEGER,
        Publisher_Name   VARCHAR(512),
        noteID           INTEGER,

        PRIMARY KEY (Publisher_ID),
        FOREIGN KEY (noteID)       REFERENCES Note(noteID));
    
    
CREATE TABLE Author
    (   Author_ID           INTEGER,
        Author_Name         VARCHAR(1024),
        Author_Legal_Name   VARCHAR(1024),
        Author_Last_Name    VARCHAR(1024),
        Pseudonym           VARCHAR(1024),
        Birth_Place         VARCHAR(1024),
        Birth_Date          DATE,
        Death_Date          DATE,
        Email_Address       VARCHAR(1024), 
        Author_image        VARCHAR(1024),
        Language_ID         INTEGER, 
        noteID              INTEGER,

        primary key (Author_ID),
        FOREIGN KEY (Language_ID)         REFERENCES  Language(Language_ID),
        FOREIGN KEY (noteID)              REFERENCES  Note(noteID));

/*CREATE TABLE Author_lang
    (   Author_ID           VARCHAR(32),
        Language_ID         VARCHAR(32),
        
        PRIMARY KEY (Author_ID, Language_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID));
*/
  
CREATE TABLE Publication(
    Publication_ID     INTEGER,
    Public_title       VARCHAR(2048),
    Public_date        DATE,
    Publisher_ID       INTEGER,
    Public_pages       VARCHAR(128),
    Pack_type          VARCHAR(128),
    Public_type        VARCHAR(128),
    ISBN               VARCHAR(128),   
    front_cover_img    VARCHAR(256),   
    currency_sign      VARCHAR(16),
    currency_amout     NUMBER,
    noteID             INTEGER,    
    Pub_Serie_ID       INTEGER,
    Public_srisNum     VARCHAR(256),

    PRIMARY KEY (Publication_ID),
    FOREIGN KEY (Publisher_ID)      REFERENCES Publisher(Publisher_ID),
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Pub_Serie_ID)      REFERENCES Publication_series(Pub_Serie_ID));

CREATE TABLE Publication_authors
    (   pa_ID               INTEGER,
        Publication_ID      INTEGER,        
        Author_ID           INTEGER,
      
        PRIMARY KEY (pa_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Publication_ID)    REFERENCES Publication(Publication_ID));

 
CREATE TABLE Publication_content(
    pubc_ID          INTEGER,  
    Title_ID         INTEGER,
    Publication_ID   INTEGER,

    PRIMARY KEY (pubc_ID),
    FOREIGN KEY (Title_ID)         REFERENCES Title(Title_ID),
    FOREIGN KEY (Publication_ID)   REFERENCES Publication(Publication_ID));


CREATE TABLE WEBPAGE
    (   webPageID           INTEGER,
        Author_ID           INTEGER,
        Publisher_ID        INTEGER,
        URL                 VARCHAR(1024),
        Pub_Serie_ID        INTEGER,
        Title_ID            INTEGER,
        Award_typeID        INTEGER,
        Tit_sris_ID         INTEGER, 
        Award_cateID        INTEGER,
        
        
        PRIMARY KEY (webPageID),
        FOREIGN KEY (Author_ID)    REFERENCES Author(Author_ID),
        FOREIGN KEY (Pub_Serie_ID) REFERENCES Publication_series(Pub_Serie_ID),
        FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID),
        FOREIGN KEY (Title_ID)     REFERENCES Title(Title_ID),
        FOREIGN KEY (Tit_sris_ID)  REFERENCES Title_series(Tit_sris_ID),
        FOREIGN KEY (Award_cateID) REFERENCES Award_categories(Award_cateID),
        FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID));

		
/* ALTER TABLE Title_series ADD CONSTRAINT fk_title_series1    FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Tit_sris_ID);*/
/*	ALTER TABLE Title ADD  CONSTRAINT fk_title1    FOREIGN KEY (Parent_title)      REFERENCES Title(Title_ID);*/
