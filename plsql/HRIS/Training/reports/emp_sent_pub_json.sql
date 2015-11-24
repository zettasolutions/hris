SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE emp_sent_pub_json (
                              p_start_date         IN VARCHAR2 default NULL,
                              p_end_date           IN VARCHAR2 default NULL,
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
   24-NOV-15  GT    Modified.
   12-NOV-15  GT    New
*/
--DECLARATION SECTION
l_json                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_group                      VARCHAR2(4000);
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
l_empl_name                TrainingTrainees_V.empl_name%TYPE;
l_dept_abbrv               TrainingTrainees_V.dept_abbrv%TYPE;
l_no_train                 NUMBER(10) := 0;
l_actual_cost              TrainingTrainees_V.actual_cost%TYPE;     

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := ' SELECT empl_name, dept_abbrv, count(empl_name) as no_train_attended, sum(actual_cost) as train_act_cost ';
l_from   := ' FROM PubTrainTrainees_V';
l_where  := ' WHERE (start_date BETWEEN ''' || TO_DATE(p_start_date,'mm/dd/yyyy') || ''' AND ''' || TO_DATE(p_end_date,'mm/dd/yyyy') || ''')';
l_where  := l_where  || ' AND (end_date BETWEEN ''' || TO_DATE(p_start_date,'mm/dd/yyyy') || ''' AND ''' || TO_DATE(p_end_date,'mm/dd/yyyy') || ''')';
l_group  := ' GROUP BY empl_name, dept_abbrv '; 
l_order  := ' ORDER BY ' || p_list_by;
   
l_sql := l_select || l_from || l_where || l_group || l_order;

   
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_empl_name, l_dept_abbrv , l_no_train, l_actual_cost;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || utl_url.escape(l_empl_name)           || '","'
                                                   || l_dept_abbrv                          || '","'                                                   
                                                   || l_no_train                            || '","'
                                                   || zsi_lib.FormatAmount(l_actual_cost,2) ||  '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;