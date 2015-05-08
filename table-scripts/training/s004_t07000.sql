DROP TABLE S004.S004_T07000 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T07000
(
  TRN_CODE       NUMBER(10),
  TRN_DESC       VARCHAR2(500 BYTE),
  REMARKS        VARCHAR2(1000 BYTE),
  CREATED_BY     VARCHAR2(100 BYTE)             DEFAULT USER,
  DATE_CREATED   DATE                           DEFAULT SYSDATE,
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

COMMENT ON TABLE S004.S004_T07000 IS 'Training Maintenance Table';


CREATE OR REPLACE TRIGGER S004."S004_T07000_BI001" 
before insert or update or delete
 ON S004.S004_T07000 for each row
begin
   if inserting then
      if :new.trn_code is null then
         select s004_t07000_sq001.nextval
         into :new.trn_code 
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


DROP PUBLIC SYNONYM S004_T07000;

CREATE PUBLIC SYNONYM S004_T07000 FOR S004.S004_T07000;


