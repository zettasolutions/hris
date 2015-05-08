SET SCAN OFF
CREATE OR REPLACE
PACKAGE mcwd_lib IS

   /*
   =======================================================================
   *
   * Copyright (c) 20014-2015 by ZSI.  All rights reserved.
   *
   * Redistribution and use in source and binary forms, with or without
   * modification is strictly prohibited.
   *
   ========================================================================
   */

   /* Modification History
   Date       By    History
   ---------  ----  -------------------------------------------------------
   07-MAR-15  BD    Moved functions/procedure to this package from other package.
   */

   TYPE VC2_1_ARR    IS TABLE OF VARCHAR2(1)  INDEX BY BINARY_INTEGER;
   TYPE VC2_255_ARR  IS TABLE OF VARCHAR2(255)  INDEX BY BINARY_INTEGER;
   TYPE NUM10_ARR    IS TABLE OF NUMBER(10)  INDEX BY BINARY_INTEGER;
   TYPE NUM_ARR      IS TABLE OF NUMBER  INDEX BY BINARY_INTEGER;

   FUNCTION GetEmployeeByJob (p_job_desc IN VARCHAR2) RETURN VARCHAR2;
   FUNCTION GetAgeBracket (p_age IN NUMBER) RETURN NUMBER;
   FUNCTION GetMedsUnitPrice (p_meds_code IN NUMBER) RETURN NUMBER;

END mcwd_lib;
/
SHOW ERRORS
