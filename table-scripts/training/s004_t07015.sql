DROP TABLE S004.S004_T07015 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T07015
(
  AGENCY_CODE    NUMBER,
  AGENCY_DESC    VARCHAR2(500 BYTE),
  REMARKS        VARCHAR2(4000 BYTE),
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

COMMENT ON TABLE S004.S004_T07015 IS 'Agency Maintenance Table for MRTC';


CREATE OR REPLACE TRIGGER S004."S004_T07015_BI001" 
before insert or update or delete
 ON S004.S004_T07015 for each row
begin
   if inserting then
      if :new.agency_code is null then
         select s004_t07015_sq001.nextval
         into :new.agency_code 
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


