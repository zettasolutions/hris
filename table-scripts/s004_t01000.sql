ALTER TABLE S004.S004_T01000
 DROP PRIMARY KEY CASCADE;

DROP TABLE S004.S004_T01000 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T01000
(
  EMPL_ID_NO                NUMBER,
  EMPL_TYPE                 VARCHAR2(2 BYTE),
  EMPL_EMST_CODE            NUMBER,
  EMPL_LAST_NAME            VARCHAR2(50 BYTE),
  EMPL_FIRST_NAME           VARCHAR2(50 BYTE),
  EMPL_MIDDLE_NAME          VARCHAR2(50 BYTE),
  EMPL_NAME_EXTENSION       VARCHAR2(50 BYTE),
  EMPL_TITLE                VARCHAR2(50 BYTE),
  EMPL_BIRTHDATE            DATE,
  EMPL_BIRTHPLACE           VARCHAR2(150 BYTE),
  EMPL_GENDER               VARCHAR2(1 BYTE),
  EMPL_CIVIL_STATUS         VARCHAR2(1 BYTE),
  EMPL_HEIGHT_MTR           NUMBER,
  EMPL_WEIGHT_KG            NUMBER,
  EMPL_BLOOD_TYPE           VARCHAR2(5 BYTE),
  EMPL_CITIZENSHIP          VARCHAR2(20 BYTE),
  EMPL_RELIGION             VARCHAR2(100 BYTE),
  EMPL_WORKPLACE            VARCHAR2(1 BYTE),
  EMPL_GROUP_CODE           VARCHAR2(10 BYTE),
  EMPL_JOBP_CODE            VARCHAR2(10 BYTE),
  EMPL_SALARY_GRADE         NUMBER,
  EMPL_SALARY_STEP          NUMBER,
  EMPL_RANK                 NUMBER,
  EMPL_DATE_HIRED           DATE,
  EMPL_REGULARIZED_DATE     DATE,
  EMPL_FIRSTDAY_OF_SERVICE  DATE,
  EMPL_WITH_OLDCBA          NUMBER,
  EMPL_ONPAYROLL_LIST       VARCHAR2(1 BYTE),
  EMPL_TAX_CODE             VARCHAR2(10 BYTE),
  EMPL_PAYROLL_CODE         VARCHAR2(1 BYTE),
  EMPL_FLEXI_TIME           VARCHAR2(1 BYTE),
  EMPL_PUNCH_LOCATION_CODE  NUMBER,
  EMPL_GRANT_VL             VARCHAR2(1 BYTE),
  EMPL_GRANT_SL             VARCHAR2(1 BYTE),
  EMPL_GRANT_EL             VARCHAR2(1 BYTE),
  EMPL_EL_DAYS              NUMBER,
  EMPL_BANK_ACCT_NO         VARCHAR2(50 BYTE),
  EMPL_ATTEND_BIO           CHAR(1 BYTE),
  CREATED_BY                VARCHAR2(50 BYTE),
  DATE_CREATED              DATE,
  MODIFIED_BY               VARCHAR2(50 BYTE),
  DATE_MODIFIED             DATE,
  EMPL_PROJ_CODE            VARCHAR2(20 BYTE),
  EMPL_PASSCODE             VARCHAR2(100 BYTE),
  PAY_EFFECT_DATE           DATE
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

COMMENT ON TABLE S004.S004_T01000 IS 'EMPLOYEE MASTERFILE HEADER';

COMMENT ON COLUMN S004.S004_T01000.EMPL_CIVIL_STATUS IS 'refer to table S004_T01019';

COMMENT ON COLUMN S004.S004_T01000.EMPL_WORKPLACE IS 'F=FIELD O=OFFICE';

COMMENT ON COLUMN S004.S004_T01000.EMPL_GROUP_CODE IS 'refer to table S004_T09000';

COMMENT ON COLUMN S004.S004_T01000.EMPL_JOBP_CODE IS 'refer to table S004_T01007';

COMMENT ON COLUMN S004.S004_T01000.EMPL_RANK IS 'refer to table S004_T01010';

COMMENT ON COLUMN S004.S004_T01000.EMPL_WITH_OLDCBA IS '1=WITH OLD CBA (LAST EMPLOYEE TO AVAIL IS PARAISO, ALBERT ID NO 681)  
0=NO CBA';

COMMENT ON COLUMN S004.S004_T01000.EMPL_ONPAYROLL_LIST IS 'Y=ON PAYROLL LIST 
N=NOT ON PAYROLL LIST 
H=ON PAYROLL LIST BUT ON HOLD';

COMMENT ON COLUMN S004.S004_T01000.EMPL_TAX_CODE IS 'refer to table S004_T01019';

COMMENT ON COLUMN S004.S004_T01000.EMPL_PAYROLL_CODE IS 'D=DAILY  
M=MONTHLY';

COMMENT ON COLUMN S004.S004_T01000.EMPL_FLEXI_TIME IS 'Y=DON''T NEED TO PUNCH 
N=MUST PUNCH IN BETWEEN BREAKS';

COMMENT ON COLUMN S004.S004_T01000.EMPL_PUNCH_LOCATION_CODE IS 'REFER TO TABLE S004_T01043';

COMMENT ON COLUMN S004.S004_T01000.EMPL_GRANT_VL IS 'Y=WITH VACATION LEAVE 
N=NO  VACATION LEAVE';

COMMENT ON COLUMN S004.S004_T01000.EMPL_GRANT_SL IS 'Y=WITH SICK LEAVE 
N=NO  SICK LEAVE';

COMMENT ON COLUMN S004.S004_T01000.EMPL_GRANT_EL IS 'Y=WITH EMERGENCY LEAVE 
N=NO  EMERGENCY LEAVE';

COMMENT ON COLUMN S004.S004_T01000.EMPL_EL_DAYS IS 'DEFAULT NUMBER OF EL DAYS (REFER TO TABLE S004_T01042 - STANDARD VALUE)';

COMMENT ON COLUMN S004.S004_T01000.EMPL_TYPE IS 'refer to table S004_T01005';

COMMENT ON COLUMN S004.S004_T01000.EMPL_EMST_CODE IS 'refer to table S004_T01006';


CREATE INDEX S004.S004_T01000_CI001 ON S004.S004_T01000
(EMPL_PAYROLL_CODE)
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


CREATE UNIQUE INDEX S004.S004_T01000_PK ON S004.S004_T01000
(EMPL_ID_NO)
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


CREATE OR REPLACE TRIGGER S004."S004_T01000_TR001" 
BEFORE INSERT OR UPDATE OR DELETE
ON S004.S004_T01000 FOR EACH ROW
DECLARE
   v_dml VARCHAR2(10);
   v_ok  NUMBER:=0;
BEGIN
  IF INSERTING THEN
    :NEW.created_by   := USER;
    :NEW.date_created := SYSDATE;
  ELSIF UPDATING THEN
    :NEW.modified_by   := USER;
    :NEW.date_modified := SYSDATE;
    v_dml := 'U';
    v_ok  := 1;
  ELSIF DELETING THEN
     v_dml := 'D';
     v_ok  := 1;   
  END IF;

   if v_ok = 1 then 
           insert into s004_t01000_audit
                       (
                          EMPL_ID_NO,
                          EMPL_TYPE,
                          EMPL_EMST_CODE,
                          EMPL_LAST_NAME,
                          EMPL_FIRST_NAME,
                          EMPL_MIDDLE_NAME,
                          EMPL_NAME_EXTENSION,
                          EMPL_TITLE,
                          EMPL_BIRTHDATE,
                          EMPL_BIRTHPLACE,
                          EMPL_GENDER,
                          EMPL_CIVIL_STATUS,
                          EMPL_HEIGHT_MTR,
                          EMPL_WEIGHT_KG,
                          EMPL_BLOOD_TYPE,
                          EMPL_CITIZENSHIP,
                          EMPL_RELIGION,
                          EMPL_WORKPLACE,
                          EMPL_GROUP_CODE,
                          EMPL_JOBP_CODE,
                          EMPL_SALARY_GRADE,
                          EMPL_SALARY_STEP,
                          EMPL_RANK,
                          EMPL_DATE_HIRED,
                          EMPL_REGULARIZED_DATE,
                          EMPL_FIRSTDAY_OF_SERVICE,
                          EMPL_WITH_OLDCBA,
                          EMPL_ONPAYROLL_LIST,
                          EMPL_TAX_CODE,
                          EMPL_PAYROLL_CODE,
                          EMPL_FLEXI_TIME,
                          EMPL_PUNCH_LOCATION_CODE,
                          EMPL_GRANT_VL,
                          EMPL_GRANT_SL,
                          EMPL_GRANT_EL,
                          EMPL_EL_DAYS,
                          EMPL_BANK_ACCT_NO,
                          EMPL_DONE_BY,
                          EMPL_DONE_DATE,
                          EMPL_DML_TYPE,
                          empl_proj_code,
                          empl_passcode,
                          CREATED_BY,
                          DATE_CREATED,
                          MODIFIED_BY,
                          DATE_MODIFIED                       
                       )
                values (
                          :OLD.EMPL_ID_NO,
                          :OLD.EMPL_TYPE,
                          :OLD.EMPL_EMST_CODE,
                          :OLD.EMPL_LAST_NAME,
                          :OLD.EMPL_FIRST_NAME,
                          :OLD.EMPL_MIDDLE_NAME,
                          :OLD.EMPL_NAME_EXTENSION,
                          :OLD.EMPL_TITLE,
                          :OLD.EMPL_BIRTHDATE,
                          :OLD.EMPL_BIRTHPLACE,
                          :OLD.EMPL_GENDER,
                          :OLD.EMPL_CIVIL_STATUS,
                          :OLD.EMPL_HEIGHT_MTR,
                          :OLD.EMPL_WEIGHT_KG,
                          :OLD.EMPL_BLOOD_TYPE,
                          :OLD.EMPL_CITIZENSHIP,
                          :OLD.EMPL_RELIGION,
                          :OLD.EMPL_WORKPLACE,
                          :OLD.EMPL_GROUP_CODE,
                          :OLD.EMPL_JOBP_CODE,
                          :OLD.EMPL_SALARY_GRADE,
                          :OLD.EMPL_SALARY_STEP,
                          :OLD.EMPL_RANK,
                          :OLD.EMPL_DATE_HIRED,
                          :OLD.EMPL_REGULARIZED_DATE,
                          :OLD.EMPL_FIRSTDAY_OF_SERVICE,
                          :OLD.EMPL_WITH_OLDCBA,
                          :OLD.EMPL_ONPAYROLL_LIST,
                          :OLD.EMPL_TAX_CODE,
                          :OLD.EMPL_PAYROLL_CODE,
                          :OLD.EMPL_FLEXI_TIME,
                          :OLD.EMPL_PUNCH_LOCATION_CODE,
                          :OLD.EMPL_GRANT_VL,
                          :OLD.EMPL_GRANT_SL,
                          :OLD.EMPL_GRANT_EL,
                          :OLD.EMPL_EL_DAYS,
                          :OLD.EMPL_BANK_ACCT_NO,
                          USER,
                          SYSDATE,
                          V_DML,
                          :old.empl_proj_code,
                          :old.empl_passcode,
                          :OLD.CREATED_BY,
                          :OLD.DATE_CREATED,
                          :OLD.MODIFIED_BY,
                          :OLD.DATE_MODIFIED                       
                   );
       end if;
 END;
/


DROP PUBLIC SYNONYM S004_T01000;

CREATE PUBLIC SYNONYM S004_T01000 FOR S004.S004_T01000;


ALTER TABLE S004.S004_T01000 ADD (
  CONSTRAINT S004_T01000_PK
 PRIMARY KEY
 (EMPL_ID_NO)
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

GRANT SELECT ON S004.S004_T01000 TO HRIS_ADMIN;

GRANT SELECT ON S004.S004_T01000 TO HRIS_VIEW;

GRANT SELECT ON S004.S004_T01000 TO PAYROLL_ADMIN;

GRANT SELECT ON S004.S004_T01000 TO PUBLIC;

GRANT DELETE, INSERT, SELECT, UPDATE ON S004.S004_T01000 TO S004_201_ENCODER;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON S004.S004_T01000 TO S004_ADMIN;

GRANT SELECT ON S004.S004_T01000 TO S004_ATND_INQ;

GRANT SELECT ON S004.S004_T01000 TO S004_CHNG_RSTDAY;

GRANT SELECT ON S004.S004_T01000 TO S004_EMP_INQ;

GRANT SELECT ON S004.S004_T01000 TO S004_HRIS_ADMIN;

GRANT SELECT ON S004.S004_T01000 TO S004_LEAVE_APPL;

GRANT SELECT ON S004.S004_T01000 TO S004_OT_AUTH;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON S004.S004_T01000 TO S004_PROL_ADMIN;

GRANT SELECT ON S004.S004_T01000 TO S004_READ;

GRANT INSERT, SELECT, UPDATE ON S004.S004_T01000 TO S004_UPDATE;

GRANT SELECT ON S004.S004_T01000 TO S004_VIEWREP;

