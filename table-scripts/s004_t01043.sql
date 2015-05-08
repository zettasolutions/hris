ALTER TABLE S004.S004_T01043
 DROP PRIMARY KEY CASCADE;
DROP SEQUENCE S004_T01043_SQ001;
DROP TABLE S004.S004_T01043 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T01043
(
  SELE_CODE        VARCHAR2(20 BYTE),
  SELE_VALUE       VARCHAR2(20 BYTE),
  DESCRIPTION      VARCHAR2(1000 BYTE),
  DISPLAYED_TEXT   VARCHAR2(100 BYTE)           NOT NULL,
  DISPLAY_SEQ      NUMBER                       DEFAULT 0                     NOT NULL,
  CAN_BE_MODIFIED  VARCHAR2(1 BYTE)             DEFAULT 'N'                   NOT NULL,
  CREATED_BY       VARCHAR2(50 BYTE)            DEFAULT user,
  DATE_CREATED     DATE                         DEFAULT sysdate,
  MODIFIED_BY      VARCHAR2(50 BYTE),
  DATE_MODIFIED    DATE,
  SEQ_NO           NUMBER
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

COMMENT ON TABLE S004.S004_T01043 IS 'STANDARD VALUE DETAILED TABLE';

/
