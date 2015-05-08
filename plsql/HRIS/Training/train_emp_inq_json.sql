SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_emp_inq_json (
                              p_empl_id_no         IN NUMBER default NULL,
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
l_spk_name                   TrainingSpeakers_V.spk_name%TYPE;
l_br                         VARCHAR2(10);

TYPE ta_cur IS REF CURSOR;
taref              ta_cur;
l_tran_no                  TrainingSchedAttend_V.tran_no%TYPE;
l_trn_code                 TrainingTrainees_V.trn_code%TYPE;  
l_trn_desc                 TrainingTrainees_V.trn_desc%TYPE;  
l_venu_name                TrainingTrainees_V.venu_name%TYPE;  
l_actual_cost              TrainingTrainees_V.actual_cost%TYPE;  
l_trn_hours                TrainingTrainees_V.trn_hours%TYPE;   
l_start_date               TrainingTrainees_V.start_date%TYPE;  
l_end_date                 TrainingTrainees_V.end_date%TYPE;     
l_spsr_name                TrainingTrainees_V.spsr_name%TYPE;     

CURSOR ts_cur(lp_tran_no IN NUMBER) IS
   SELECT * 
     FROM TrainingSpeakers_V
    WHERE tran_no = lp_tran_no;
    
BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT tran_no, trn_code, trn_desc ,venu_name, actual_cost, trn_hours ,start_date ,end_date, spsr_name ';
l_from   := ' FROM TrainingTrainees_V';
l_where  := ' WHERE empl_id_no =' ||  p_empl_id_no;
l_order  := ' ORDER BY tran_no ';
   
   l_sql := l_select || l_from || l_where || l_order;
   htp.p('{"rows":[');
      OPEN taref FOR l_sql;
      LOOP
          FETCH taref INTO l_tran_no, l_trn_code, l_trn_desc, l_venu_name, l_actual_cost, l_trn_hours, l_start_date,l_end_date,l_spsr_name;
      EXIT WHEN taref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_spk_name :='';
      l_br := '';
      FOR i IN ts_cur(l_tran_no) LOOP   
          l_spk_name := l_spk_name || l_br || i.spk_name;   
          l_br := '<br />';
      END LOOP;      

      l_ttl_th := l_ttl_th + l_trn_hours;
      l_ttl_cost := l_ttl_cost + l_actual_cost;

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_tran_no                            || '","'
                                                   || l_trn_code                           || '","'
                                                   || l_trn_desc                           || '","'
                                                   || l_venu_name                          || '","'
                                                   || TO_CHAR(l_start_date, l_date_format) || '","'
                                                   || TO_CHAR(l_end_date, l_date_format)   || '","'
                                                   || zsi_lib.FormatAmount(l_actual_cost,2)|| '","'
                                                   || l_trn_hours                          || '","'                                               
                                                   || l_spsr_name                          || '","'                                               
                                                   || l_spk_name                           || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;
l_row_count := l_row_count + 1;
l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                   || '*Count &raquo'           || '","'
                                                   || TO_NUMBER(l_row_count-1)  || '","'
                                                   || ''                        || '","'
                                                   || ''                        || '","'
                                                   || ''                        || '","'
                                                   || 'Total Cost &raquo'       || '","'
                                                   || zsi_lib.FormatAmount(l_ttl_cost,2)   || '","'
                                                   || zsi_lib.FormatAmount(l_ttl_th,0)     || '","'                                                  
                                                   || ''                        || '","'
                                                   || ''                        || '"'
||']}';
htp.p(l_json);

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;