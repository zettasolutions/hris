SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_emp_wtrain_rpt_json (
                              p_cc                 IN VARCHAR2 default NULL,
                              p_from_date          IN VARCHAR2 default NULL,
                              p_to_date            IN VARCHAR2 default NULL,
                              p_list_by            IN VARCHAR2 default NULL,
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
l_ttl_th                     NUMBER(10) := 0;
l_ttl_cost                   NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

TYPE ta_cur IS REF CURSOR;
taref              ta_cur;
l_dept_abbrv               TrainingTrainees_V.dept_abbrv%TYPE;
l_empl_name                TrainingTrainees_V.empl_name%TYPE;
l_tran_no                  TrainingTrainees_V.tran_no%TYPE;
l_trn_desc                 TrainingTrainees_V.trn_desc%TYPE;  
l_actual_cost              TrainingTrainees_V.actual_cost%TYPE;  
l_trn_hours                TrainingTrainees_V.trn_hours%TYPE;   
l_start_date               TrainingTrainees_V.start_date%TYPE;  
l_end_date                 TrainingTrainees_V.end_date%TYPE;     
l_with_cert                TrainingTrainees_V.with_cert%TYPE;  
l_trn_type_name            TrainingTrainees_V.trn_type_name%TYPE;  

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT dept_abbrv, empl_name, tran_no, trn_desc , start_date ,end_date, trn_hours, actual_cost , trn_type_name, with_cert ';
l_from   := ' FROM TrainingTrainees_V';
l_where  := ' WHERE 1 = 1';
l_order  := ' ORDER BY ' || '''' || p_list_by || '''';
   

IF p_cc IS NOT NULL THEN
   l_where := l_where || ' AND dept_code = ' || p_cc;
END IF;   

IF p_from_date IS NOT NULL THEN
   l_from_date := TO_DATE(p_from_date, l_date_format);
   l_to_date := SYSDATE;
   IF p_to_date IS NOT NULL THEN   
      l_to_date := TO_DATE(p_to_date, l_date_format);
   END IF;
   l_where := l_where || ' AND start_date between  ' || '''' ||  l_from_date || '''' || ' AND ' || '''' || l_to_date || '''';
END IF;   

   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_dept_abbrv, l_empl_name, l_tran_no, l_trn_desc , l_start_date ,l_end_date, l_trn_hours, l_actual_cost , l_trn_type_name, l_with_cert;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_dept_abbrv                         || '","'
                                                   || l_empl_name                          || '","'
                                                   || l_tran_no                            || '","'
                                                   || l_trn_desc                           || '","'                                                   
                                                   || TO_CHAR(l_start_date, l_date_format) || '","'
                                                   || TO_CHAR(l_end_date, l_date_format)   || '","'
                                                   || l_trn_hours                          || '","'                                               
                                                   || l_actual_cost                        || '","'
                                                   || l_trn_type_name                      || '","'
                                                   || l_with_cert                          || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;