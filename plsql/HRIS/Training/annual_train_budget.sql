SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE annual_train_budget (p_year  IN NUMBER default EXTRACT(YEAR FROM SYSDATE)) IS
/*
========================================================================
*
* Copyright (c) 2014 ZettaSolution, Inc.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification is strictly prohibited.
*
========================================================================
*/
/* Modification History
   Date       By    History
   ---------  ----  ---------------------------------------------------------------------
   05-NOV-14  GT    New
*/
--DECLARATION SECTION

l_pyear  NUMBER := EXTRACT(YEAR FROM SYSDATE) -1;

BEGIN

INSERT INTO S004_T07013 
      (tran_no
      ,tran_year
      ,id_no      
      ,budget_type
      ,conv_code  
      ,budget_amt   
      ,remarks)    
SELECT S004_T07013_SQ001.NEXTVAL              
      ,p_year       
      ,a.id_no        
      ,a.budget_type     
      ,a.conv_code    
      ,a.budget_amt   
      ,a.remarks      
   FROM S004_T07013 a, employee_active_v b
   WHERE a.id_no = b.empl_id_no   
   AND tran_year=l_pyear;

EXCEPTION
   WHEN OTHERS THEN
        NULL;
END;
/
SHOW ERR;