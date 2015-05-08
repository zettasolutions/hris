SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE vaccination_rpt_json (
                              p_year               IN VARCHAR2 default EXTRACT(MONTH FROM SYSDATE),
                              p_vaccine_code       IN VARCHAR2 default NULL,
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
   27-MAR-15  GT    New
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
l_tran_date          Availed_Vaccination_v.tran_date%TYPE;      
l_vacc_name          Availed_Vaccination_v.vacc_name%TYPE;      
l_empl_name          Availed_Vaccination_v.emp_name%TYPE;      
l_dept_abbrv         Availed_Vaccination_v.dept_abbrv%TYPE;   
l_emp_type           Availed_Vaccination_v.emp_type%TYPE;       
l_age_bracket        Availed_Vaccination_v.age_bracket%TYPE;
l_or_number          Availed_Vaccination_v.or_number%TYPE;       
l_amnt_billed        Availed_Vaccination_v.amnt_billed%TYPE;

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT vacc_name, tran_date, emp_name, emp_type, dept_abbrv, or_number, amnt_billed  ';
l_from   := ' FROM Availed_Vaccination_v';
l_where  := ' WHERE EXTRACT(YEAR FROM tran_date) = ' || p_year;
l_order  := ' ORDER BY vacc_name, tran_date';

   if p_vaccine_code IS NOT NULL THEN
      l_where  := l_where || ' AND vaccine_code = ' || p_vaccine_code;
   end if;
   
   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_vacc_name, l_tran_date, l_empl_name, l_emp_type, l_dept_abbrv, l_or_number, l_amnt_billed;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_vacc_name                         || '","'
                                                   || TO_CHAR(l_tran_date,l_date_format)  || '","'
                                                   || utl_url.escape(l_empl_name)         || '","'
                                                   || l_emp_type                          || '","'
                                                   || l_dept_abbrv                        || '","'
                                                   || l_or_number                         || '","'
                                                   || zsi_lib.FormatAmount(l_amnt_billed,2) || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;