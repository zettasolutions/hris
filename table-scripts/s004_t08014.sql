DROP TABLE S004.S004_T08014 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08014
(
  SEQ_NO          NUMBER,
  TREATMENT_FOR   NUMBER,
  TREATMENT_DESC  VARCHAR2(1000 BYTE),
  REMARKS         VARCHAR2(1000 BYTE),
  CREATED_BY      VARCHAR2(100 BYTE),
  DATE_CREATED    DATE,
  MODIFIED_BY     VARCHAR2(100 BYTE),
  DATE_MODIFIED   DATE
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

COMMENT ON TABLE S004.S004_T08014 IS 'Maintenance Table for Applied Treatment';


/


