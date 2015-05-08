DROP TABLE S004.S004_T08020_MEDS CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08020_MEDS
(
  TRAN_NO         NUMBER,
  SEQ_NO          NUMBER,
  TRAN_YEAR       NUMBER,
  TRAN_DATE       DATE,
  ID_NO           NUMBER,
  DEP_ID          NUMBER,
  MEDS_CODE       NUMBER,
  MEDS_QTY        NUMBER,
  UNIT_PRICE      NUMBER,
  REFERENCE_CODE  NUMBER,
  DOSAGE          VARCHAR2(1000 BYTE),
  REMARKS         VARCHAR2(4000 BYTE),
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

COMMENT ON TABLE S004.S004_T08020_MEDS IS 'Consultation - Medicines';

/

