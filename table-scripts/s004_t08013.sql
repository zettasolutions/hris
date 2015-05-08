DROP TABLE S004.S004_T08013 CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08013
(
  TRAN_NO               NUMBER,
  TRAN_DATE             DATE,
  ID_NO                 NUMBER,
  AGE_BRAK_CODE         NUMBER,
  EMPL_TYPE             VARCHAR2(2 BYTE),
  COST_CENTER           VARCHAR2(10 BYTE),
  DEPARTMENT            VARCHAR2(10 BYTE),
  GROUP_CODE            VARCHAR2(10 BYTE),
  ACCIDENT_DATE         DATE,
  ACCIDENT_TIME         VARCHAR2(100 BYTE),
  MANHOUR_LOST          NUMBER,
  SICK_LEAVE            NUMBER,
  ACCIDENT_LOCATION     VARCHAR2(1000 BYTE),
  CURRENT_ACTIVITY      VARCHAR2(4000 BYTE),
  ACCIDENT_DESCRIPTION  VARCHAR2(4000 BYTE),
  ACCIDENT_CAUSE_ACTS   VARCHAR2(4000 BYTE),
  ACCIDENT_CAUSE_COND   VARCHAR2(4000 BYTE),
  DIRECT_SUPERIOR       NUMBER,
  REMARKS               VARCHAR2(4000 BYTE),
  POST_STATUS           NUMBER,
  POST_DATE             DATE,
  CREATED_BY            VARCHAR2(100 BYTE),
  DATE_CREATED          DATE,
  MODIFIED_BY           VARCHAR2(100 BYTE),
  DATE_MODIFIED         DATE
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

COMMENT ON TABLE S004.S004_T08013 IS 'Accident Report Transaction Table';


CREATE OR REPLACE TRIGGER S004."S004_T08013_BI001" 
before insert or update or delete
 ON S004.S004_T08013 for each row
begin
   if inserting then
      if :new.tran_no is null then
         select s004_t08013_sq001.nextval
         into :new.tran_no 
         from dual;
      end if; 
      if :new.cost_center is null then
         select empl_group_code,
                substr(empl_group_code,1,2)||'0',
                substr(empl_group_code,1,1)||'00'
         into  :new.cost_center,
               :new.department,
               :new.group_code 
         from   s004_t01000
         where  empl_id_no = :new.id_no;
      end if;
      if :new.empl_type is null then
         select empl_type
         into  :new.empl_type
         from   s004_t01000
         where  empl_id_no = :new.id_no;
      end if;
      if :new.age_brak_code is null then
          select s004.get_age_bracket(empl_birthdate)
          into   :new.age_brak_code
          from   s004_t01000
          where  empl_id_no = :new.id_no;
      end if;
     :new.created_by    := user;
     :new.date_created  := sysdate;
   elsif updating then
     :new.modified_by   := user;
     :new.date_modified := sysdate;
   end if;
end;
/


