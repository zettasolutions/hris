ALTER TABLE S004.S004_T05010
 DROP PRIMARY KEY CASCADE;

DROP TABLE S004.S004_T05010 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T05010
(
  SESSION_ID     NUMBER                         NOT NULL,
  SESSION_DATE   DATE                           NOT NULL,
  LOGON          VARCHAR2(30 BYTE)              NOT NULL,
  IP_ADDRESS     VARCHAR2(64 BYTE),
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

COMMENT ON TABLE S004.S004_T05010 IS 'Session Table';


CREATE UNIQUE INDEX S004.S004_T05010_PK ON S004.S004_T05010
(SESSION_ID)
LOGGING
TABLESPACE HRIS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER S004."S004_T05010_BI001" 
before insert or update or delete
 ON S004.S004_T05010 for each row
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


ALTER TABLE S004.S004_T05010 ADD (
  CONSTRAINT S004_T05010_PK
 PRIMARY KEY
 (SESSION_ID)
    USING INDEX 
    TABLESPACE HRIS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

