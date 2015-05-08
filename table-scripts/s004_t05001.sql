ALTER TABLE S004.S004_T05001
 DROP PRIMARY KEY CASCADE;

DROP TABLE S004.S004_T05001 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T05001
(
  USER_NAME    VARCHAR2(50 BYTE),
  DESCRIPTION  VARCHAR2(100 BYTE),
  IS_LOCK      VARCHAR2(1 BYTE)                 DEFAULT 'N'                   NOT NULL,
  CREATED_BY   VARCHAR2(50 BYTE)                DEFAULT user,
  CREATED_ON   DATE                             DEFAULT sysdate,
  MODIFIED_BY  VARCHAR2(50 BYTE),
  MODIFIED_ON  DATE
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

COMMENT ON TABLE S004.S004_T05001 IS 'MANAGE USERS - USERS';


CREATE UNIQUE INDEX S004.S004_T05001_PK ON S004.S004_T05001
(USER_NAME)
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


CREATE OR REPLACE TRIGGER S004."S004_T05001_BIU" 
before insert or update on s004_t05001
for each row
begin
   if inserting then
     :new.created_by    := user;
     :new.created_on  := sysdate;
   elsif updating then
     :new.modified_by   := user;
     :new.modified_on := sysdate;
   end if;
end;
/


DROP PUBLIC SYNONYM S004_T05001;

CREATE PUBLIC SYNONYM S004_T05001 FOR S004.S004_T05001;


ALTER TABLE S004.S004_T05001 ADD (
  CONSTRAINT S004_T05001_CK01
 CHECK (is_lock in ('Y','N')),
  CONSTRAINT S004_T05001_PK
 PRIMARY KEY
 (USER_NAME)
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

GRANT SELECT ON S004.S004_T05001 TO HRIS_ADMIN;

GRANT SELECT ON S004.S004_T05001 TO PAYROLL_ADMIN;

GRANT SELECT ON S004.S004_T05001 TO PUBLIC;

GRANT SELECT ON S004.S004_T05001 TO S004_READ;

