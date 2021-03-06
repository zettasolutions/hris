DROP TABLE S004.S004_T08008 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08008
(
  LDGR_NO        NUMBER,
  TRAN_NO        NUMBER,
  TRAN_MONTH     DATE,
  TRAN_DATE      DATE,
  TRAN_TYPE      CHAR(2 BYTE),
  MEDS_TYPE      VARCHAR2(20 BYTE),
  MEDS_CODE      NUMBER,
  BEGBAL_QTY     NUMBER,
  DEBIT_QTY      NUMBER,
  CREDIT_QTY     NUMBER,
  UNIT_PRICE     NUMBER,
  BALANCE        NUMBER,
  PURCHASE_DATE  DATE,
  EXPIRY_DATE    DATE,
  TREATMENT_FOR  NUMBER,
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

COMMENT ON TABLE S004.S004_T08008 IS 'Medicine Inventory Ledger';

/


