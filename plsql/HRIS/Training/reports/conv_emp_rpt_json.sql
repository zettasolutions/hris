SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE conv_emp_rpt_json (
                              p_month              IN NUMBER default NULL,
                              p_year               IN NUMBER default NULL,
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
   31-MAR-15  GT    New
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
l_spsr_name                TrainingTrainees_V.spsr_name%TYPE;
l_venu_name                TrainingTrainees_V.venu_name%TYPE;
l_tran_no                  TrainingTrainees_V.tran_no%TYPE;
l_trn_desc                 TrainingTrainees_V.trn_desc%TYPE;  
l_no_pax                   NUMBER:=0;
l_trn_hours                TrainingTrainees_V.trn_hours%TYPE;   
l_start_date               TrainingTrainees_V.start_date%TYPE;  
l_end_date                 TrainingTrainees_V.end_date%TYPE;     
l_trn_type_name            TrainingTrainees_V.trn_type_name%TYPE;  

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := ' SELECT tran_no, trn_desc, venu_name, start_date ,end_date, trn_hours,  zsi_lib.GetCount(''tran_no'', ''S004_T07003_TRAINEES'',''tran_no='' || tran_no ), trn_type_name, spsr_name';
l_from   := ' FROM TrainingTrainees_V';
l_where  := ' WHERE EXTRACT(MONTH FROM start_date) =' || p_month || ' AND EXTRACT(YEAR FROM start_date) =' || p_year;
l_order  := ' ORDER BY tran_no';
   
   l_sql := l_select || l_from || l_where || l_order;
   
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_tran_no, l_trn_desc , l_venu_name, l_start_date ,l_end_date, l_trn_hours, l_no_pax , l_trn_type_name, l_spsr_name;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_tran_no                            || '","'
                                                   || l_trn_desc                           || '","'                                                   
                                                   || l_venu_name                          || '","'
                                                   || TO_CHAR(l_start_date, l_date_format) || '","'
                                                   || TO_CHAR(l_end_date, l_date_format)   || '","'
                                                   || l_no_pax                             || '","'
                                                   || l_trn_hours                          || '","'                                               
                                                   || l_trn_type_name                      || '","'
                                                   || l_spsr_name                          || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;