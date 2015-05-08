SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE eye_exam_rpt_json (
                              p_cmonth         IN VARCHAR2 default NULL,
                              p_year           IN VARCHAR2 default NULL,
                              p_rows           IN NUMBER default NULL,
                              p_page_no        IN NUMBER default 1,
                              p_rt             IN VARCHAR2 default NULL) IS
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
   21-APR-15  GT    New
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
l_dept_abbrv         S004_T08010_V.dept_abbrv%TYPE;      
l_empl_name          S004_T08010_V.emp_name%TYPE;   
l_tran_date          S004_T08010_V.tran_date%TYPE;   
l_complaint          S004_T08010_V.complaint%TYPE;   
l_diagnosis          S004_T08010_V.diagnosis%TYPE;   
l_treatment          S004_T08010_V.treatment%TYPE;   

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT dept_abbrv, emp_name, tran_date, complaint, diagnosis, treatment ';
l_from   := ' FROM S004_T08010_V';
l_where  := ' WHERE medplan_code=13 AND tran_year=' || p_year;
l_order  := ' ORDER BY dept_abbrv, tran_date';

IF p_cmonth IS NOT NULL THEN
   l_where := l_where || 'AND EXTRACT(MONTH FROM tran_date)= ' || p_cmonth;
END IF;

   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_dept_abbrv, l_empl_name,  l_tran_date, l_complaint, l_diagnosis, l_treatment;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_dept_abbrv                         || '","'
                                                   || utl_url.escape(l_empl_name)          || '","'
                                                   || TO_CHAR(l_tran_date, l_date_format)  || '","'
                                                   || l_complaint                          || '","'
                                                   || l_diagnosis                          || '","'
                                                   || l_treatment                          || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;