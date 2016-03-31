CREATE TABLE Author
    (   Author_ID           INTEGER,
        Author_Name         CHAR(16),
        Author_Legal_Name   CHAR(16),
        Author_Last_Name    CHAR(16),
        Pseudonym           CHAR(16),
        Birth_Place         CHAR(16),
        Birth_Date          DATE,
        Death_Date          DATE,
        Email_Address       CHAR (64),
        Author_Image        CHAR(128),   /*URL?*/
        AuthorLanguage_ID   INTEGER, 

        primary key(Author_ID),
        FOREIGN KEY (Author_Language_ID)  REFERENCES Language(Language_ID);
        FOREIGN KEY (Author_Image)        REFERENCES Webpages(URL);

CREATE TABLE WRITES
    (   pa_ID               INTEGER,
        Author_ID           INTEGER NOT NULL,
        Publication_ID      INTEGER NOT NULL,
        
        PRIMARY KEY (pa_ID),
        FOREIGN KEY (Author_ID)         REFERENCES Author(Author_ID),
        FOREIGN KEY (Publication_ID)    REFERENCES Publication(Publication_ID));

CREATE TABLE Language
    (   Language_ID         INTEGER,
        Name                CHAR(16),
        Language_Code       CHAR(8),
        Language_Script     CHAR(16),

        PRIMARY KEY (Language_ID));

CREATE TABLE Note
    (   Note_ID     INTEGER,
        Note        CHAR(256) );

CREATE TABLE Webpage
    (   Webpage_ID          INTEGER,
        URL                 CHAR(128),
        Author_ID           INTEGER,
        Pub_Serie_ID        INTEGER,
        Title_ID            INTEGER,
        Publisher_ID        INTEGER,
        Tit_sris_ID         INTEGER, 
        Award_cateID        INTEGER,
        Award_type_ID       INTEGER,
        
        PRIMARY KEY (Webpage_ID),
        FOREIGN KEY (Author_ID)     REFERENCES Author(Author_ID))
        FOREIGN KEY (Pub_Serie_ID)  REFERENCES Publication_Serie(Pub_Serie_ID)),
        FOREIGN KEY (Publisher_ID)  REFERENCES Publisher(Publisher_ID)),
        FOREIGN KEY (Title_ID)      REFERENCES Title(Title_ID)),
        FOREIGN KEY (Tit_sris_ID)   REFERENCES Title_series(Tit_sris_ID)),
        FOREIGN KEY (Award_cateID ) REFERENCES Award_categories(Award_cateID )),
        FOREIGN KEY (Award_typeID)  REFERENCES Award_types(Award_typeID));



CREATE TABLE Title(
    Title_ID                INTEGER,
    Title                   CHAR(128),
    Title_synopsis          INTEGER,       
    Series_ID               INTEGER,
    Series_num              INTEGER,
    Story_len               CHAR(32),
    Title_type              CHAR(64),
    Title_graph             CHAR(8),

    Parent              INTEGER,
    Pubc_ID             INTEGER NOT NULL,
    Review_ID           INTEGER,
    Language_ID         INTEGER NOT NULL,
    Tag_ID              INTEGER,
    Note_ID             INTEGER,      
    Title_tsltorID      INTEGER,    

    PRIMARY KEY (Title_ID),
    FOREIGN KEY (Parent)            REFERENCES Title(Title_ID),
    FOREIGN KEY (pubc_ID)           REFERENCES Publication_content(pubc_ID),
    FOREIGN KEY (Review_ID)         REFERENCES Reviews(Review_ID),
    FOREIGN KEY (Language_ID)       REFERENCES Language(Language_ID),
    FOREIGN KEY (Tag_ID)            REFERENCES Tags(Tag_ID),
    FOREIGN KEY (Note_ID)           REFERENCES Note(Note_ID),
    FOREIGN KEY (Title_synopsis)    REFERENCES Note(Note_ID),
    FOREIGN KEY (Title_tsltorID)    REFERENCES Title_translator(Title_tsltorID);)

CREATE TABLE Title_translator(
    Title_tsltorID      INTEGER,
    Title_tsltorName    CHAR(64),

    PRIMARY KEY (Title_tsltorID);   
)



CREATE TABLE Publication_content (
    pubc_ID          INTEGER,
    
    Title_ID         INTEGER,
    Publication_ID   INTEGER,

    PRIMARY KEY (pubc_ID),
    FOREIGN KEY (Title_ID)         REFERENCES Title(Title_ID),
    FOREIGN KEY (Publication_ID)   REFERENCES Publication(Publication_ID);)

/* I build the publication table for convenience when connecting title and
 publication so this table is incomplete and could be incorrect. Feel free
 to modify and delete anything */
 
CREATE TABLE Publication(
    Publication_ID     INTEGER,
    Public_title       CHAR(64),
    Public_date        CHAR(64),
    Public_pages       CHAR(32),
    Pack_type          CHAR(32),
    Public_type        CHAR(64),
    ISBN               CHAR(128),
    Price              CHAR(32),
    Pub_Serie_ID       INTEGER,
    Public_srisNum     INTEGER,

    PublisherID         INTEGER    NOT NULL,
    Public_image        CHAR(256),  /*THE URL*/
    Note_ID             INTEGER,

    PRIMARY KEY (ISBN),
    FOREIGN KEY (PublisherID)       REFERENCES Publisher(PublisherID),
    FOREIGN KEY (Public_image)      REFERENCES Webpage(URL),
    FOREIGN KEY (Note_ID)           REFERENCES Note(Note_ID),
    FOREIGN KEY (Pub_Serie_ID)      REFERENCES Publication_series(Pub_Serie_ID);)

CREATE TABLE Publication_series
    (    Pub_Serie_ID    INTEGER,
         Pub_Serie_Name  CHAR(30),
         Publication_ID  INTEGER  NOT NULL, 
         Note_ID         INTEGER,

        PRIMARY KEY (Pub_Serie_ID),
        FOREIGN KEY (Note_ID)         REFERENCES Note(Note_ID),         
        FOREIGN KEY (Publication_ID)  REFERENCES Publication (Publication_ID));

CREATE TABLE Publisher
    (   PublisherID     INTEGER,
        Publisher_Name  CHAR(30),
        Note_ID         INTEGER,
        PRIMARY KEY (PublisherID),
        FOREIGN KEY (Note_ID)        REFERENCES Note(Note_ID));

CREATE TABLE Reviews(
    Rev_ID         INTEGER,
    
    Title_ID       INTEGER,
    Review_ID      INTEGER,

    PRIMARY KEY(Rev_ID),
    FOREIGN KEY(Title_ID)    REFERENCES Title(Title_ID),
    FOREIGN KEY(Review_ID)   REFERENCES Title(Title_ID);)


CREATE TABLE Title_series(
    Tit_sris_ID        INTEGER,
    Sris_title         CHAR(128),

    Sris_parent        CHAR(128),
    Sris_note_ID       INTEGER,

    PRIMARY KEY (Tit_sris_ID),
    FOREIGN KEY (Sris_parent)   REFERENCES Title_series(Sris_title),
    FOREIGN KEY (Sris_note_ID)  REFERENCES Note(Note_ID),);

CREATE TABLE Title_tags(
    Tagmap_ID      INTEGER,
    
    Tag_ID         INTEGER,
    Title_ID       INTEGER,

    PRIMARY KEY (Tagmap_ID),
    FOREIGN KEY (Tag_ID)      REFERENCES Tags(Tag_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID);)


CREATE TABLE Tags(
    Tag_ID          INTEGER,
    Tag_name        CHAR(64),

    PRIMARY KEY (Tag_ID));

CREATE TABLE Title_awards(
    taw_ID          INTEGER,

    Award_ID        INTEGER,
    Title_ID        INTEGER,

    PRIMARY KEY (taw_ID),
    FOREIGN KEY (Award_ID)    REFERENCES Awards(Award_ID),
    FOREIGN KEY (Title_ID)    REFERENCES Title(Title_ID);)

CREATE TABLE Awards(
    Award_ID         INTEGER,
    Award_title      CHAR(256),
    Award_date       CHAR(64),
    
    Award_typeCode    CHAR(16) NOT NULL,
    Award_typeID      INTEGER  NOT NULL,
    Award_cateID      INTEGER  NOT NULL,
    Note_ID           INTEGER,

    PRIMARY KEY (Award_ID),
    FOREIGN KEY (Award_typeID)     REFERENCES Award_types(Award_typeID),
    FOREIGN KEY (Award_cateID)     REFERENCES Award_categories(Award_cateID),
    FOREIGN KEY (Note_ID)          REFERENCES Note(Note_ID); )

CREATE TABLE Award_categories(
    Award_cateID         INTEGER,
    Award_cateName       CHAR(128),
    Award_cate_typeID    INTEGER,
    Award_cateOrd        INTEGER,

    Note_ID              INTEGER,

    PRIMARY KEY (Award_cateID),
    FOREIGN KEY (Note_ID)        REFERENCES Note(Note_ID);)

CREATE TABLE Award_types(
    Award_typeID         INTEGER,
    Award_typeCode       CHAR(64),
    Award_typeName       CHAR(128),
    Award_by             CHAR(64),
    Award_for            CHAR(64),
    short_name           CHAR(64),
    poll                 CHAR(8),
    Awd_type_Non_g       CHAR(64),

    Note_ID              INTEGER,

    PRIMARY KEY (Award_typeID),
    FOREIGN KEY (Note_ID) REFERENCES Note(Note_ID);)
