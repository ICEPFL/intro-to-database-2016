CREATE TABLE Language
    (   Language_ID         VARCHAR(32),
        lang_Name           VARCHAR(128),
        Language_Code       VARCHAR(128),
        Language_Script     VARCHAR(128),

        PRIMARY KEY (Language_ID));
        
CREATE TABLE Note
    (   noteID      VARCHAR(32),
        NOTE        CLOB, 

        PRIMARY KEY (noteID));
        
CREATE TABLE Tags(
    Tag_ID          VARCHAR(32),
    Tag_name        VARCHAR(128),

    PRIMARY KEY (Tag_ID));
    
CREATE TABLE Title_series(
    Tit_sris_ID        VARCHAR(32),
    Sris_title         VARCHAR(512),
    Sris_parent        VARCHAR(32),
    noteID             VARCHAR(32),

    PRIMARY KEY (Tit_sris_ID)
   /* FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Tit_sris_ID),
    FOREIGN KEY (noteID)   REFERENCES Note(noteID)*/);

CREATE TABLE Title(
    Title_ID                VARCHAR(32),
    Title                   VARCHAR(2048), 
    transla_lang            VARCHAR(512),
 /*   name_of_transla         VARCHAR(512),  */
    Title_synopsis          VARCHAR(32),
    noteID                  VARCHAR(32), 
    Tit_sris_ID             VARCHAR(32),
    Series_num              VARCHAR(32),
    Story_len               VARCHAR(64),
    Title_type              VARCHAR(64),
    Parent_title            VARCHAR(32),
    Language_ID             VARCHAR(32),
    Title_graph             VARCHAR(16),

    PRIMARY KEY (Title_ID)
    /*FOREIGN KEY (Parent_title)            REFERENCES Title(Title_ID),
    FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID),
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Title_synopsis)    REFERENCES Note(noteID),
    FOREIGN KEY (Tit_sris_ID)       REFERENCES Title_series(Tit_sris_ID)*/);


    
CREATE TABLE Title_tags(
    Tagmap_ID      VARCHAR(32), 
    Tag_ID         VARCHAR(32),
    Title_ID       VARCHAR(32),

    PRIMARY KEY (Tagmap_ID)
/*    FOREIGN KEY (Tag_ID)      REFERENCES Tags(Tag_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID)*/);
    
CREATE TABLE Reviews(
    Rev_ID         VARCHAR(32), 
    Title_ID       VARCHAR(32),
    Review_ID      VARCHAR(32),

    PRIMARY KEY(Rev_ID),
    FOREIGN KEY(Title_ID)    REFERENCES Title(Title_ID),
    FOREIGN KEY(Review_ID)   REFERENCES Title(Title_ID));

  
CREATE TABLE Award_types(
    Award_typeID         VARCHAR(32),
    Award_typeCode       VARCHAR(512),
    Award_typeName       VARCHAR(512),
    noteID               VARCHAR(32),   
    Award_by             VARCHAR(512),
    Award_for            VARCHAR(512),
    short_name           VARCHAR(512),
    poll                 VARCHAR(16),
    Awd_type_Non_g       VARCHAR(64),
 
    PRIMARY KEY (Award_typeID)
    /*FOREIGN KEY (noteID) REFERENCES Note(noteID)*/);
    
CREATE TABLE Award_categories(
    Award_cateID         VARCHAR(32),
    Award_cateName       VARCHAR(128),
    Award_cate_typeID    VARCHAR(32),
    Award_cateOrd        VARCHAR(32),
    noteID               VARCHAR(32),
 /*    Award_typeID         INTEGER NOT NULL,*/

    PRIMARY KEY (Award_cateID)
/*    FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID) ON DELETE CASCADE,
    FOREIGN KEY (noteID)       REFERENCES Note(noteID)*/);
      
CREATE TABLE Awards(
    Award_ID          VARCHAR(32),
    Award_title       VARCHAR(1024),
    Award_date        VARCHAR(128),
    Award_typeCode    VARCHAR(128),
    Award_typeID      VARCHAR(32)  NOT NULL,
    Award_cateID      VARCHAR(32),
    noteID            VARCHAR(32),

    PRIMARY KEY (Award_ID),
    FOREIGN KEY (Award_typeID)     REFERENCES Award_types(Award_typeID),
    FOREIGN KEY (Award_cateID)     REFERENCES Award_categories(Award_cateID)
    /*FOREIGN KEY (noteID)           REFERENCES Note(noteID)*/);
    
CREATE TABLE Title_awards(
    taw_ID          VARCHAR(32),
    Award_ID        VARCHAR(32),
    Title_ID        VARCHAR(32),

    PRIMARY KEY (taw_ID),
 /*   FOREIGN KEY (Award_ID)    REFERENCES Awards(Award_ID),*/
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID));
     
       

CREATE TABLE Publication_series
    (    Pub_Serie_ID    VARCHAR(32),
         Pub_Serie_Name  VARCHAR(1024),
         noteID          VARCHAR(32),
         
        PRIMARY KEY (Pub_Serie_ID)
       /* FOREIGN KEY (noteID)       REFERENCES Note(noteID)*/);
        

CREATE TABLE Publisher
    (   Publisher_ID     VARCHAR(32),
        Publisher_Name   VARCHAR(512),
        noteID           VARCHAR(32),

        PRIMARY KEY (Publisher_ID)
        /*FOREIGN KEY (noteID)       REFERENCES Note(noteID)*/);
    
    
CREATE TABLE Author
    (   Author_ID           VARCHAR(32),
        Author_Name         VARCHAR(1024),
        Author_Legal_Name   VARCHAR(1024),
        Author_Last_Name    VARCHAR(1024),
        Pseudonym           VARCHAR(1024),
        Birth_Place         VARCHAR(1024),
        Birth_Date          VARCHAR(1024),
        Death_Date          VARCHAR(1024),
        Email_Address       VARCHAR(1024), 
        Author_image        VARCHAR(1024),
        Language_ID         VARCHAR(32), 
        noteID              VARCHAR(32),

        primary key (Author_ID)
      /*  FOREIGN KEY (Language_ID)         REFERENCES  Language(Language_ID)
        FOREIGN KEY (noteID)              REFERENCES  Note(noteID)*/);

/*CREATE TABLE Author_lang
    (   Author_ID           VARCHAR(32),
        Language_ID         VARCHAR(32),
        
        PRIMARY KEY (Author_ID, Language_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID));
*/

  
CREATE TABLE Publication(
    Publication_ID     VARCHAR(32),
    Public_title       VARCHAR(2048),
    Public_date        VARCHAR(32),
    Publisher_ID       VARCHAR(32),
    Public_pages       VARCHAR(128),
    Pack_type          VARCHAR(128),
    Public_type        VARCHAR(128),
    ISBN               VARCHAR(128),   
    front_cover_img    VARCHAR(256),   
    currency_sign      VARCHAR(16),
    currency_amout     VARCHAR(64),
    noteID             VARCHAR(32),    
    Pub_Serie_ID       VARCHAR(32),
    Public_srisNum     VARCHAR(256),

    PRIMARY KEY (Publication_ID)
 /*   FOREIGN KEY (Publisher_ID)      REFERENCES Publisher(Publisher_ID)
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Pub_Serie_ID)      REFERENCES Publication_series(Pub_Serie_ID)*/);

CREATE TABLE Publication_authors
    (   pa_ID               VARCHAR(32),
        Publication_ID      VARCHAR(32),        
        Author_ID           VARCHAR(32),
      
        PRIMARY KEY (pa_ID),
       /* FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),*/
        FOREIGN KEY (Publication_ID)    REFERENCES Publication(Publication_ID));

 

CREATE TABLE Publication_content(
    pubc_ID          VARCHAR(32),  
    Title_ID         VARCHAR(32),
    Publication_ID   VARCHAR(32),

    PRIMARY KEY (pubc_ID)
/*    FOREIGN KEY (Title_ID)         REFERENCES Title(Title_ID),
    FOREIGN KEY (Publication_ID)   REFERENCES Publication(Publication_ID)*/);


CREATE TABLE WEBPAGE
    (   webPageID           VARCHAR(32),
        Author_ID           VARCHAR(32),
        Publisher_ID        VARCHAR(32),
        URL                 VARCHAR(1024),
        Pub_Serie_ID        VARCHAR(32),
        Title_ID            VARCHAR(32),
        Award_typeID        VARCHAR(32),
        Tit_sris_ID         VARCHAR(32), 
        Award_cateID        VARCHAR(32),
        
        
        PRIMARY KEY (webPageID)
       /* FOREIGN KEY (Author_ID)    REFERENCES Author(Author_ID),
        FOREIGN KEY (Pub_Serie_ID) REFERENCES Publication_series(Pub_Serie_ID),
        FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID),
        FOREIGN KEY (Title_ID)     REFERENCES Title(Title_ID),
        FOREIGN KEY (Tit_sris_ID)  REFERENCES Title_series(Tit_sris_ID),
        FOREIGN KEY (Award_cateID) REFERENCES Award_categories(Award_cateID),
        FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID)*/);

/*
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage1     FOREIGN KEY (Author_ID)    REFERENCES Author(Author_ID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage2     FOREIGN KEY (Pub_Serie_ID) REFERENCES Publication_series(Pub_Serie_ID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage3     FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage4     FOREIGN KEY (Title_ID)     REFERENCES Title(Title_ID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage5     FOREIGN KEY (Tit_sris_ID)  REFERENCES Title_series(Tit_sris_ID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage6     FOREIGN KEY (Award_cateID) REFERENCES Award_categories(Award_cateID);
ALTER TABLE WEBPAGE ADD CONSTRAINT  fk_webpage7     FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID);*/
/*
ALTER TABLE Title_series ADD CONSTRAINT fk_title_series1    FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Tit_sris_ID);
ALTER TABLE Title_series ADD CONSTRAINT fk_title_series2    FOREIGN KEY (noteID)        REFERENCES Note(noteID);*/

/*
ALTER TABLE Title ADD  CONSTRAINT fk_title1    FOREIGN KEY (Parent_title)      REFERENCES Title(Title_ID);
ALTER TABLE Title ADD  CONSTRAINT fk_title2    FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID);
ALTER TABLE Title ADD  CONSTRAINT fk_title3    FOREIGN KEY (noteID)            REFERENCES Note(noteID);
ALTER TABLE Title ADD  CONSTRAINT fk_title4    FOREIGN KEY (Title_synopsis)    REFERENCES Note(noteID);
ALTER TABLE Title ADD  CONSTRAINT fk_title5    FOREIGN KEY (Tit_sris_ID)       REFERENCES Title_series(Tit_sris_ID);*/

      
