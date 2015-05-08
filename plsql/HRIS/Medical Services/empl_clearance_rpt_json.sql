SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE empl_clearance_rpt_json (
                              p_year               IN VARCHAR2 default EXTRACT(MONTH FROM SYSDATE),
                              p_clearance_type     IN VARCHAR2 default NULL,
                              p_sport_type         IN VARCHAR2 default NULL,
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
   24-MAR-15  GT    New
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
l_tran_date          clearance_v.tran_date%TYPE;      
l_sport              clearance_v.sport%TYPE;      
l_clearance          clearance_v.clearance%TYPE;      
l_empl_name          clearance_v.emp_name%TYPE;   
l_age_bracket        clearance_v.age_bracket%TYPE;
l_emp_type           clearance_v.emp_type%TYPE;       
l_dept_abbrv         clearance_v.dept_abbrv%TYPE;      

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT tran_date, sport, clearance, emp_name, age_bracket, dept_abbrv ';
l_from   := ' FROM clearance_v';
l_where  := ' WHERE is_cleared=1 AND EXTRACT(YEAR FROM tran_date) = ' || p_year;
l_order  := ' ORDER BY sport, emp_name';

   if p_clearance_type IS NOT NULL THEN
      l_where  := l_where || ' AND clearance_type = ' || p_clearance_type;
   end if;
   
   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_tran_date, l_sport, l_clearance, l_empl_name, l_age_bracket, l_dept_abbrv;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_clearance                         || '","'
                                                   || l_sport                             || '","'
                                                   || l_tran_date                         || '","'
                                                   || utl_url.escape(l_empl_name)         || '","'
                                                   || l_age_bracket                       || '","'
                                                   || l_dept_abbrv                        || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;