DROP TABLE S004.S004_T07017 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T07017
(
  ASSESSMENT_TYPE   NUMBER,
  ASSESSMENT_CODE   NUMBER,
  ASSESSMENT_DESC   VARCHAR2(3000 BYTE),
  ASSESSMENT_DESC2  VARCHAR2(3000 BYTE),
  MAX_ASSESSMENT    VARCHAR2(3000 BYTE),
  MIN_ASSESSMENT    VARCHAR2(3000 BYTE),
  AVE_ASSESSMENT    VARCHAR2(3000 BYTE),
  REMARKS           VARCHAR2(4000 BYTE),
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

COMMENT ON TABLE S004.S004_T07017 IS 'Trainer/Resource Speaker Assessment Maintenance Table';

COMMENT ON COLUMN S004.S004_T07017.ASSESSMENT_TYPE IS '100 = Trainer/ Resource Speaker Assessment 
200 = Training / Seminar Assessment';


CREATE OR REPLACE TRIGGER S004."S004_T07017_BI001" 
before insert or update or delete
 ON S004.S004_T07017 for each row
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


