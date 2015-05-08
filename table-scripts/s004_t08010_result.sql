DROP TABLE S004.S004_T08010_RESULT CASCADE CONSTRAINTS;
DROP TRIGGER S004_T08010_Result_BI001;

CREATE TABLE S004.S004_T08010_RESULT
(
  LDGR_NO          NUMBER,
  SEQ_NO           NUMBER,
  TRAN_YEAR        NUMBER,
  TRAN_DATE        DATE,
  ID_NO            NUMBER,
  DEP_ID           NUMBER,
  MEDSERVICE_CODE  NUMBER,
  RESULT_TYPE      NUMBER,
  EXAM_GROUP       NUMBER,
  EXAM_CODE        NUMBER,
  RESULT           NUMBER,
  REMARKS          VARCHAR2(4000 BYTE),
  IS_FOLLOWUP      NUMBER,
  FOLLOW_UP_LAB    DATE,
  POST_DATE        DATE,
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

COMMENT ON TABLE S004.S004_T08010_RESULT IS 'Medical Chart Ledger - Result';
/


