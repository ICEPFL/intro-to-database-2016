CREATE TABLE Language
    (   Language_ID         INTEGER,
        Name                VARCHAR(128),
        Language_Code       VARCHAR(128),
        Language_Script     VARCHAR(128),

        PRIMARY KEY (Language_ID));
        
CREATE TABLE Note
    (   noteID      INTEGER,
        NOTE        VARCHAR(512), 

        PRIMARY KEY (noteID));
        
CREATE TABLE Tags(
    Tag_ID          INTEGER,
    Tag_name        VARCHAR(128),

    PRIMARY KEY (Tag_ID));
    
CREATE TABLE Title_series(
    Tit_sris_ID        INTEGER,
    Sris_title         VARCHAR(128),
    Sris_parent        VARCHAR(128),
    Sris_noteID        INTEGER,

    PRIMARY KEY (Tit_sris_ID),
    FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Sris_title),
    FOREIGN KEY (Sris_noteID)   REFERENCES Note(noteID));

CREATE TABLE Title(
    Title_ID                INTEGER,
    Title                   VARCHAR(128),      
    Series_num              VARCHAR(128),
    Story_len               VARCHAR(64),
    Title_type              VARCHAR(64),
    Title_graph             VARCHAR(16),
    
    Title_synopsis      INTEGER, 
    Parent              INTEGER,
    Language_ID         INTEGER NOT NULL,/*BUT THE DATA HAS NONE!!*/
    noteID              INTEGER,      
    Title_tsltorID      INTEGER, 
    Series_ID           INTEGER,  
    webPageID           INTEGER, 

    PRIMARY KEY (Title_ID),
    FOREIGN KEY (Parent)            REFERENCES Title(Title_ID),
    FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID),
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Title_synopsis)    REFERENCES Note(noteID),
    FOREIGN KEY (Series_ID)         REFERENCES Title_series(Tit_sris_ID));
    
CREATE TABLE Title_tags(
    Tagmap_ID      INTEGER, 
    Tag_ID         INTEGER,
    Title_ID       INTEGER,

    PRIMARY KEY (Tag_ID, Title_ID),
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
    Award_typeCode       VARCHAR(128),
    Award_typeName       VARCHAR(128),
    Award_by             VARCHAR(128),
    Award_for            VARCHAR(128),
    short_name           VARCHAR(128),
    poll                 VARCHAR(16),
    Awd_type_Non_g       VARCHAR(64),
 
    noteID               INTEGER,

    PRIMARY KEY (Award_typeID),
    FOREIGN KEY (noteID) REFERENCES Note(noteID));
    
CREATE TABLE Award_categories(
    Award_cateID         INTEGER,
    Award_cateName       VARCHAR(128),
    Award_cate_typeID    INTEGER,
    Award_cateOrd        INTEGER,

    noteID               INTEGER,
    Award_typeID         INTEGER NOT NULL,

    PRIMARY KEY (Award_cateID, Award_typeID),
    FOREIGN KEY (Award_typeID) REFERENCES Award_types(Award_typeID) ON DELETE CASCADE,
    FOREIGN KEY (noteID)       REFERENCES Note(noteID));
    
CREATE TABLE Awards(
    Award_ID         INTEGER,
    Award_title      VARCHAR(128),
    Award_date       VARCHAR(64),
    
    Award_typeCode    VARCHAR(128),
    Award_typeID      INTEGER  NOT NULL,
    Award_cateID      INTEGER,
    noteID            INTEGER,

    PRIMARY KEY (Award_ID),
    FOREIGN KEY (Award_typeID)     REFERENCES Award_types(Award_typeID),
  /*FOREIGN KEY (Award_cateID)     REFERENCES Award_categories(Award_cateID),*/
    FOREIGN KEY (noteID)           REFERENCES Note(noteID));
    
CREATE TABLE Title_awards(
    taw_ID          INTEGER,
    Award_ID        INTEGER,
    Title_ID        INTEGER,

    PRIMARY KEY (Award_ID, Title_ID),
    FOREIGN KEY (Award_ID)    REFERENCES Awards(Award_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID));
    

CREATE TABLE Publication_series
    (    Pub_Serie_ID    INTEGER,
         Pub_Serie_Name  VARCHAR(128),
         noteID          INTEGER,
         
        PRIMARY KEY (Pub_Serie_ID),
        FOREIGN KEY (noteID)       REFERENCES Note(noteID));
        
        
CREATE TABLE WEBPAGE
    (   webPageID           INTEGER,
        URL                 VARCHAR(256),
        Author_ID           INTEGER,
        Pub_Serie_ID        INTEGER,
        Title_ID            INTEGER,
        Publisher_ID        INTEGER,
        Tit_sris_ID         INTEGER, 
        Award_cateID        INTEGER,
        Award_type_ID       INTEGER,
        
        PRIMARY KEY (webPageID),
        FOREIGN KEY (Author_ID)     REFERENCES Author(Author_ID),
        FOREIGN KEY (Pub_Serie_ID)  REFERENCES Publication_Serie(Pub_Serie_ID),
        FOREIGN KEY (Publisher_ID)  REFERENCES Publisher(Publisher_ID),
        FOREIGN KEY (Title_ID)      REFERENCES Title(Title_ID),
        FOREIGN KEY (Tit_sris_ID)   REFERENCES Title_series(Tit_sris_ID),
        FOREIGN KEY (Award_cateID ) REFERENCES Award_categories(Award_cateID),
        FOREIGN KEY (Award_typeID)  REFERENCES Award_types(Award_typeID));
        

CREATE TABLE Publisher
    (   PublisherID     INTEGER,
        Publisher_Name  VARCHAR(128),
        noteID          INTEGER,
        webPageID       INTEGER,

        PRIMARY KEY (PublisherID),
        FOREIGN KEY (noteID)       REFERENCES Note(noteID),
        FOREIGN KEY (webPageID)    REFERENCES WEBPAGE(webPageID));
    
    
CREATE TABLE Author
    (   Author_ID           INTEGER,
        Author_Name         VARCHAR(128),
        Author_Legal_Name   VARCHAR(64),
        Author_Last_Name    VARCHAR(64),
        Pseudonym           VARCHAR(128),
        Birth_Place         VARCHAR(128),
        Birth_Date          VARCHAR(32),
        Death_Date          VARCHAR(32),
        Email_Address       VARCHAR(128),   
        Language_ID         INTEGER, 
        noteID              INTEGER,
        webPageID           INTEGER,

        primary key (Author_ID),
        FOREIGN KEY (Author_Language_ID)  REFERENCES  Language(Language_ID),
        FOREIGN KEY (webPageID)           REFERENCES  WEBPAGE(webPageID),
        FOREIGN KEY (noteID)              REFERENCES  Note(noteID));


CREATE TABLE Author_lang
    (   Author_ID           INTEGER,
        Language_ID         INTEGER,
        Language_name       VARCHAR(128),
        
        PRIMARY KEY (Author_ID, Language_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID),
        FOREIGN KEY (Language_name)     REFERENCES Language(Name));


CREATE TABLE WRITES
    (   pa_ID               INTEGER,
        Author_ID           INTEGER,
        Publication_ID      INTEGER,
        
        PRIMARY KEY (Author_ID, Publication_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Publication_ID)    REFERENCES Publication(Publication_ID));


CREATE TABLE Publication(
    Publication_ID     INTEGER,
    Public_title       VARCHAR(128),
    Public_date        VARCHAR(64),
    Public_pages       VARCHAR(128),
    Pack_type          VARCHAR(128),
    Public_type        VARCHAR(128),
    ISBN               VARCHAR(128),
    Price              VARCHAR(128),
    Pub_Serie_ID       INTEGER,
    Public_srisNum     INTEGER,
    PublisherID        INTEGER,
    Public_image       VARCHAR,  
    noteID             INTEGER,
    webPageID          INTEGER,

    PRIMARY KEY (ISBN),
    FOREIGN KEY (PublisherID)       REFERENCES Publisher(PublisherID),
    FOREIGN KEY (noteID)            REFERENCES Note(noteID),
    FOREIGN KEY (Pub_Serie_ID)      REFERENCES Publication_series(Pub_Serie_ID),
    FOREIGN KEY (webPageID)         REFERENCES WEBPAGE(webPageID));


CREATE TABLE Publication_content (
    pubc_ID          INTEGER,  
    Title_ID         INTEGER,
    Publication_ID   INTEGER,

    PRIMARY KEY (Title_ID, Publication_ID),
    FOREIGN KEY (Title_ID)         REFERENCES Title(Title_ID),
    FOREIGN KEY (Publication_ID)   REFERENCES Publication(Publication_ID));








