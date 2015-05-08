SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE medplan_coverage_reset IS
/*
========================================================================
*
* Copyright (c) 2015 ZettaSolution, Inc.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification is strictly prohibited.
*
========================================================================
*/
/* Modification History
   Date       By    History
   ---------  ----  ---------------------------------------------------------------------
   04-FEB-15  GT    New
*/
   --DECLARATION SECTION

l_amt   NUMBER:=0;
   
BEGIN
  SELECT TO_NUMBER(REPLACE(displayed_text,',','')) INTO l_amt FROM MEDPLAN_V;
  UPDATE S004_T08001 
     SET plan_coverage = l_amt
        ,plan_curr_bal = l_amt  
        ,plan_avail_bal= l_amt        
    WHERE id_no IN (SELECT empl_id_no FROM employee_active_v);
END;
/
SHOW ERR;