DROP TABLE S004.S004_T08021_BILLING CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08021_BILLING
(
  TRAN_NO           NUMBER,
  SEQ_NO            NUMBER,
  TRAN_YEAR         DATE,
  TRAN_DATE         DATE,
  ID_NO             NUMBER,
  DEP_ID            NUMBER,
  MEDSERVICE_CODE   VARCHAR2(2 BYTE),
  AMNT_BILLED       NUMBER,
  AMNT_COVERED      NUMBER,
  AMNT_NOT_COVERED  NUMBER,
  REMARKS           VARCHAR2(4000 BYTE),
  OR_DATE           DATE,
  OR_NUMBER         VARCHAR2(100 BYTE),
  ISSUED_BY         VARCHAR2(100 BYTE),
  FOR_REFUND        NUMBER,
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

COMMENT ON TABLE S004.S004_T08021_BILLING IS 'Vaccination - Billing';


CREATE OR REPLACE TRIGGER S004."S004_T08021_Bill_BI001" 
before insert or update or delete
 ON S004.S004_T08021_BILLING for each row
begin
   if inserting then
     :new.created_by    := user;
     :new.date_created  := sysdate;
   elsif updating then
     :new.modified_by   := user;
     :new.date_modified := sysdate;
   end if;
end;
/


