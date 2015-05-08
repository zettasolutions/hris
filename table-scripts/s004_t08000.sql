

ALTER TABLE S004.S004_T08000
DROP PRIMARY KEY CASCADE;

DROP TABLE S004.S004_T08000 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08000
(
  SEQ_NO           NUMBER,
  SELE_CODE        VARCHAR2(20 BYTE),
  SELE_VALUE       VARCHAR2(20 BYTE),
  DESCRIPTION      VARCHAR2(1000 BYTE),
  DISPLAYED_TEXT   VARCHAR2(100 BYTE),
  DISPLAY_SEQ      NUMBER                       DEFAULT 0,
  CAN_BE_MODIFIED  VARCHAR2(1 BYTE)             DEFAULT 'N',
  CREATED_BY       VARCHAR2(50 BYTE)            DEFAULT user,
  DATE_CREATED     DATE                         DEFAULT sysdate,
  MODIFIED_BY      VARCHAR2(50 BYTE),
  DATE_MODIFIED    DATE
)
TABLESPACE HRIS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE S004.S004_T08000 IS 'STANDARD VALUE DETAILED TABLE FOR CLINIC';


CREATE UNIQUE INDEX S004.S004_T08000_PK ON S004.S004_T08000
(SEQ_NO)
LOGGING
TABLESPACE HRIS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX S004.S004_T08000_UK ON S004.S004_T08000
(SELE_CODE, SELE_VALUE)
LOGGING
TABLESPACE HRIS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP PUBLIC SYNONYM S004_T08000;

CREATE PUBLIC SYNONYM S004_T08000 FOR S004.S004_T08000;


ALTER TABLE S004.S004_T08000 ADD (
  CONSTRAINT S004_T08000_PK
 PRIMARY KEY
 (SEQ_NO)
    USING INDEX 
    TABLESPACE HRIS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ),
  CONSTRAINT S004_T08000_UK
 UNIQUE (SELE_CODE, SELE_VALUE)
    USING INDEX 
    TABLESPACE HRIS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));


