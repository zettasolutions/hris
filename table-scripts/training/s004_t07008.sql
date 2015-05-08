DROP TABLE S004.S004_T07008 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T07008
(
  SPSR_CODE      NUMBER,
  SPSR_NAME      VARCHAR2(500 BYTE),
  SPSR_ADDRESS   VARCHAR2(500 BYTE),
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

COMMENT ON TABLE S004.S004_T07008 IS 'Training Sponsor Maintenance Table';


CREATE OR REPLACE TRIGGER S004."S004_T07008_BI001" 
before insert or update or delete
 ON S004.S004_T07008 for each row
begin
   if inserting then
      if :new.spsr_code is null then
         select s004_t07008_sq001.nextval
         into :new.spsr_code 
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


