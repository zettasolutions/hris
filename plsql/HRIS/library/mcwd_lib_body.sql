SET SCAN OFF
CREATE OR REPLACE
PACKAGE BODY mcwd_lib IS

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

   FUNCTION GetEmployeeByJob (p_job_desc IN VARCHAR2) RETURN VARCHAR2 IS
      l_empl_name VARCHAR2(256);
   BEGIN
      SELECT empl_name
        INTO l_empl_name
        FROM employee_v
       WHERE UPPER(job_desc) like '%' || p_job_desc  ||'%';
      RETURN l_empl_name;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN l_empl_name;
   END;

   FUNCTION GetAgeBracket (p_age IN NUMBER) RETURN NUMBER IS
   BEGIN
      CASE
         WHEN p_age < 11 THEN RETURN 1;
         WHEN p_age < 21 THEN RETURN 2;
         WHEN p_age < 31 THEN RETURN 3;
         WHEN p_age < 41 THEN RETURN 4;
         WHEN p_age < 51 THEN RETURN 5;
         WHEN p_age < 61 THEN RETURN 6;
         WHEN p_age < 71 THEN RETURN 7;
         WHEN p_age < 81 THEN RETURN 8;
         WHEN p_age < 91 THEN RETURN 9;
         ELSE RETURN 10;
      END CASE;
   END;

   FUNCTION GetMedsUnitPrice (p_meds_code IN NUMBER) RETURN NUMBER IS
      l_unit_price   NUMBER;
   BEGIN
      SELECT unit_price
        INTO l_unit_price
        FROM med_inv_ledger_v
       WHERE meds_code = p_meds_code
        AND  tran_date IN (SELECT MAX(tran_date)
                           FROM med_inv_ledger_v
                          WHERE meds_code = p_meds_code);
      RETURN l_unit_price;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN l_unit_price;
   END;

END;
/
SHOW ERRORS
