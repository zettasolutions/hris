DROP TABLE S004.S004_T08022 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08022
(
  SEQ_NO           NUMBER,
  LAB_STAFF_CODE   NUMBER,
  LAB_STAFF_NAME   VARCHAR2(1000 BYTE),
  LAB_DESIGNATION  VARCHAR2(500 BYTE),
  REMARKS          VARCHAR2(1000 BYTE),
  CREATED_BY       VARCHAR2(100 BYTE),
  DATE_CREATED     DATE,
  MODIFIED_BY      VARCHAR2(100 BYTE),
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

COMMENT ON TABLE S004.S004_T08022 IS 'Maintenance Table for Laboratory Personnel/Staff';


/


