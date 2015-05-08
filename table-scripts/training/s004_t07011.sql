DROP TABLE S004.S004_T07011 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T07011
(
  SPK_CODE       NUMBER,
  SPK_NAME       VARCHAR2(300 BYTE),
  SPK_CITATIONS  VARCHAR2(4000 BYTE),
  SPK_ADDRESS    VARCHAR2(1000 BYTE),
  SPK_CONTACTNO  VARCHAR2(100 BYTE),
  SPK_TYPE       VARCHAR2(2 BYTE),
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

COMMENT ON TABLE S004.S004_T07011 IS 'Speaker/Resource Person Maintenance Table';


CREATE OR REPLACE TRIGGER S004."S004_T07011_BI001" 
before insert or update or delete
 ON S004.S004_T07011 for each row
begin
   if inserting then
      if :new.spk_code is null then
         select s004_t07011_sq001.nextval
         into :new.spk_code 
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


