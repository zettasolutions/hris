SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE med_disp_rpt_json (
                              p_from_date         IN VARCHAR2 default NULL,
                              p_to_date           IN VARCHAR2 default NULL,
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
   18-FEB-15  GT    New
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
l_dept_abbrv         Medicine_Acquired_V.dept_abbrv%TYPE;      
l_empl_name          Medicine_Acquired_V.empl_name%TYPE;   
l_tran_date          Medicine_Acquired_V.tran_date%TYPE;   
l_meds_qty           Medicine_Acquired_V.meds_qty%TYPE;   
l_medicine           Medicine_Acquired_V.medicine%TYPE;   
l_medsdesc           Medicine_Acquired_V.medsdesc%TYPE;   
l_medsclass          Medicine_Acquired_V.medsclass%TYPE;   
l_treatment_desc     Medicine_Acquired_V.treatment_desc%TYPE;   

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT medicine, empl_name, dept_abbrv, tran_date, meds_qty,  treatment_desc ';
l_from   := ' FROM Medicine_Acquired_V';
l_where  := ' WHERE post_status=1 AND tran_date between ' || '''' || TO_DATE(p_from_date,l_date_format) || '''' || ' AND ' || '''' || TO_DATE(p_to_date,l_date_format) || '''';
l_order  := ' ORDER BY medicine, tran_date';

   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO  l_medicine,  l_empl_name, l_dept_abbrv, l_tran_date, l_meds_qty, l_treatment_desc;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_medicine                           || '","'
                                                   || utl_url.escape(l_empl_name)          || '","'
                                                   || l_dept_abbrv                         || '","'
                                                   || TO_CHAR(l_tran_date, l_date_format)  || '","'
                                                   || l_meds_qty                           || '","'
                                                   || l_treatment_desc                     || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;