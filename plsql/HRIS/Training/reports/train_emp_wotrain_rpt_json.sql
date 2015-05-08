SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_emp_wotrain_rpt_json (
                              p_cc                 IN VARCHAR2 default NULL,
                              p_year               IN NUMBER default NULL,
                              p_year2              IN NUMBER default NULL,
                              p_rows               IN NUMBER default NULL,
                              p_page_no            IN NUMBER default 1,
                              p_rt                 IN VARCHAR2 default NULL) IS
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
   05-FEB-15  GT    New
*/
--DECLARATION SECTION
l_json                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_order                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_from_date                  DATE;
l_to_date                    DATE;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_comma                      VARCHAR2(1);
l_count                      NUMBER := 0;

TYPE ta_cur IS REF CURSOR;
taref              ta_cur;
l_dept_abbrv       employee_active_v.dept_abbrv%TYPE;      
l_empl_name        employee_active_v.empl_name%TYPE;   
l_empl_salary_grade  employee_active_v.empl_salary_grade%TYPE;
l_type_desc        employee_active_v.type_desc%TYPE;       
l_empl_date_hired  employee_active_v.empl_date_hired%TYPE; 

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT e.dept_abbrv, e.empl_name, empl_salary_grade, e.type_desc, e.empl_date_hired ';
l_from   := ' FROM employee_active_v e';
l_where  := ' WHERE 1=1 ';
l_order  := ' ORDER BY e.dept_desc, e.empl_name';


   

IF p_cc IS NOT NULL THEN
   l_where := l_where || ' AND e.department = ' || p_cc;
END IF;   
 
IF p_year IS NOT NULL THEN
   l_where := l_where || ' AND NOT EXISTS (SELECT b.empl_id_no FROM TrainingTrainees_V b WHERE b.empl_id_no = e.empl_id_no AND trn_year = ' || p_year;
END IF;   

IF p_year2 IS NOT NULL THEN
   l_where := l_where || ' AND trn_year = ' || p_year2;
END IF; 
 l_where := l_where || ') ';
 
   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_dept_abbrv, l_empl_name, l_empl_salary_grade, l_type_desc , l_empl_date_hired;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_dept_abbrv                         || '","'
                                                   || utl_url.escape(l_empl_name)          || '","'
                                                   || l_empl_salary_grade                  || '","'
                                                   || l_type_desc                          || '","'
                                                   || TO_CHAR(l_empl_date_hired, l_date_format) || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;