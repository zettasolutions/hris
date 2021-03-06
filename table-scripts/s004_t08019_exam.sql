DROP TABLE S004.S004_T08019_EXAM CASCADE CONSTRAINTS;

CREATE TABLE S004.S004_T08019_EXAM
(
  SEQ_NO         NUMBER,
  RESULT_TYPE    NUMBER,
  EXAM_GROUP     NUMBER,
  EXAM_CODE      NUMBER,
  EXAM_DESC      VARCHAR2(1000 BYTE),
  NORMAL_RANGE   VARCHAR2(4000 BYTE),
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

COMMENT ON TABLE S004.S004_T08019_EXAM IS 'Examination Result - Examination Detail Maintenance Table';
/