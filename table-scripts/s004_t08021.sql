DROP TABLE S004.S004_T08021 CASCADE CONSTRAINTS;

drop trigger S004_T080021_BI001;

CREATE TABLE S004.S004_T08021
(
  TRAN_NO           NUMBER,
  TRAN_YEAR         NUMBER,
  TRAN_DATE         DATE,
  ID_NO             NUMBER,
  DEP_ID            NUMBER,
  AGE_BRAK_CODE     NUMBER,
  EMPL_TYPE         VARCHAR2(2 BYTE),
  COST_CENTER       VARCHAR2(10 BYTE),
  DEPARTMENT        VARCHAR2(10 BYTE),
  GROUP_CODE        VARCHAR2(10 BYTE),
  MEDPLAN_TYPE      VARCHAR2(2 BYTE),
  MEDPLAN_CODE      VARCHAR2(2 BYTE),
  MEDSERVICE_CODE   VARCHAR2(2 BYTE),
  VACCINE_CODE      NUMBER,
  BRAND             VARCHAR2(1000 BYTE),
  ROUTE             VARCHAR2(100 BYTE),
  SITE_GIVEN        VARCHAR2(100 BYTE),
  VACCINE_LOTNO     VARCHAR2(100 BYTE),
  MANUFACTURER      VARCHAR2(1000 BYTE),
  IN_HOUSE          CHAR(1 BYTE),
  NEXT_VACCINE      DATE,
  AMNT_BILLED       NUMBER,
  AMNT_COVERED      NUMBER,
  AMNT_NOT_COVERED  NUMBER,
  OR_DATE           DATE,
  OR_NUMBER         VARCHAR2(100 BYTE),
  ISSUED_BY         VARCHAR2(100 BYTE),
  FOR_REFUND        NUMBER,
  DOCTOR_CODE       NUMBER,
  REFERENCE_CODE    NUMBER,
  REMARKS           VARCHAR2(4000 BYTE),
  POST_STATUS       NUMBER,
  POST_DATE         DATE,
  CREATED_BY        VARCHAR2(100 BYTE),
  DATE_CREATED      DATE,
  MODIFIED_BY       VARCHAR2(100 BYTE),
  DATE_MODIFIED     DATE
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

COMMENT ON TABLE S004.S004_T08021 IS 'Vaccination Transaction Table';


 
/


