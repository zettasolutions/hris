DROP SEQUENCE S004.S004_T08019_SQ001;

CREATE SEQUENCE S004.S004_T08019_SQ001
  START WITH 8
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM S004_T08019_SQ001;

CREATE PUBLIC SYNONYM S004_T08019_SQ001 FOR S004.S004_T08019_SQ001;


