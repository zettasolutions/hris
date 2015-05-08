DROP TABLE S004.S004_T08010_DENTAL CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08010_DENTAL
(
  LDGR_NO        NUMBER,
  SEQ_NO         NUMBER,
  TRAN_YEAR      NUMBER,
  TRAN_DATE      DATE,
  ID_NO          NUMBER,
  DEP_ID         NUMBER,
  DS_CODE        NUMBER,
  DS_QTY         NUMBER,
  DS_RATE        NUMBER,
  TOTAL_AMT      NUMBER,
  IS_FOLLOWUP    NUMBER,
  NEXT_VISIT     DATE,
  REMARKS        VARCHAR2(4000 BYTE),
  POST_DATE      DATE,
  CREATED_BY     VARCHAR2(100 BYTE),
  DATE_CREATED   DATE,
  MODIFIED_BY    VARCHAR2(100 BYTE),
  DATE_MODIFIED  DATE
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

COMMENT ON TABLE S004.S004_T08010_DENTAL IS 'Medical Chart Ledger - Dental';

/


