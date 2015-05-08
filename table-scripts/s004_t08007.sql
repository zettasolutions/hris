DROP TABLE S004.S004_T08007 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08007
(
  TRAN_NO        NUMBER,
  TRAN_DATE      DATE,
  MEDS_TYPE      VARCHAR2(20 BYTE),
  MEDS_CODE      NUMBER,
  QUANTITY       NUMBER,
  UNIT_PRICE     NUMBER,
  PURCHASE_DATE  DATE,
  EXPIRY_DATE    DATE,
  REMARKS        VARCHAR2(4000 BYTE),
  POST_STATUS    NUMBER,
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

COMMENT ON TABLE S004.S004_T08007 IS 'Medicine Inventory Transaction Table';


CREATE OR REPLACE TRIGGER S004."S004_T08007_BI001" 
before insert or update or delete
 ON S004.S004_T08007 for each row
begin
   if inserting then
      if :new.tran_no is null then
         select s004_t08007_sq001.nextval
         into :new.tran_no 
         from dual;
      end if; 
     :new.created_by    := user;
     :new.date_created  := sysdate;
   elsif updating then
     :new.modified_by   := user;
     :new.date_modified := sysdate;
   end if;
end;
/


