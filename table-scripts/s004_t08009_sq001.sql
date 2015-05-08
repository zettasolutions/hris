DROP SEQUENCE S004.S004_T08009_SQ001;

CREATE SEQUENCE S004.S004_T08009_SQ001
  START WITH 1024
  MAXVALUE 9999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM S004_T08009_SQ001;

CREATE PUBLIC SYNONYM S004_T08009_SQ001 FOR S004.S004_T08009_SQ001;


DROP PUBLIC SYNONYM S004_T08004_SQ001;

CREATE PUBLIC SYNONYM S004_T08004_SQ001 FOR S004.S004_T08009_SQ001;


