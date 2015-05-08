CREATE TABLE S004.S004_DOCS
(
NAME                                                  VARCHAR2(128)  UNIQUE NOT NULL,
MIME_TYPE                                             VARCHAR2(128),
DOC_SIZE                                              NUMBER,
DAD_CHARSET                                           VARCHAR2(128),
LAST_UPDATED                                          DATE,
CONTENT_TYPE                                          VARCHAR2(128),
CONTENT                                               LONG RAW,
BLOB_CONTENT                                          BLOB
)
/

