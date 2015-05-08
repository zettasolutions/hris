SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE ape_results_byId_rpt_json (
                              p_empl_id_no         IN NUMBER,
                              p_year               IN NUMBER default EXTRACT(YEAR FROM SYSDATE),
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
   12-FEB-15  GT    New
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

TYPE ta_cur IS REF CURSOR;
taref                ta_cur;
l_result_desc        S004_T08010_RESULTS_V.result_desc%TYPE;      
l_group_desc         S004_T08010_RESULTS_V.group_desc%TYPE;   
l_exam_desc          S004_T08010_RESULTS_V.exam_desc%TYPE;
l_normal_range       S004_T08010_RESULTS_V.normal_range%TYPE;      
l_result             S004_T08010_RESULTS_V.result%TYPE;   
l_followup           S004_T08010_RESULTS_V.followup%TYPE;

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT result_desc, group_desc, exam_desc, normal_range, result, followup ';
l_from   := ' FROM S004_T08010_RESULTS_V ';
l_where  := ' WHERE medplan_code=4 AND id_no = ' || p_empl_id_no;
l_order  := ' ORDER BY seq_no ';

IF p_year IS NOT NULL THEN
   l_where := l_where || ' AND tran_year = ' || p_year;
END IF;  

l_sql := l_select || l_from || l_where || l_order;
htp.p('{"rows":[');
   OPEN taref FOR l_sql;
   LOOP
       FETCH taref INTO l_result_desc, l_group_desc, l_exam_desc, l_normal_range , l_result, l_followup;
   EXIT WHEN taref%NOTFOUND;

   l_row_count := l_row_count + 1;
   l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                               || l_result_desc  || '","'
                                               || l_group_desc   || '","'
                                               || l_exam_desc    || '","'
                                               || l_normal_range || '","'
                                               || l_result       || '"'
   ||']}';

   htp.p(l_json);
   l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;