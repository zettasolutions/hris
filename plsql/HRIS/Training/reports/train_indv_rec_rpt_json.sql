SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_indv_rec_rpt_json (
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
   15-FEB-15  GT    New
*/
--DECLARATION SECTION
l_json                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_order                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_ttl_th                     NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

TYPE ts_cur IS REF CURSOR;
tsref              ts_cur;
l_trn_desc                 TrainingTrainees_V.trn_desc%TYPE;  
l_trn_hours                TrainingTrainees_V.trn_hours%TYPE;   
l_start_date               TrainingTrainees_V.start_date%TYPE;  
l_end_date                 TrainingTrainees_V.end_date%TYPE;     

BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT trn_desc ,trn_hours ,start_date ,end_date ';
l_from   := ' FROM TrainingTrainees_V';
l_where  := ' WHERE empl_id_no =' ||  p_empl_id_no;
l_order  := ' ORDER BY start_date desc ';

l_sql := l_select || l_from || l_where || l_order;
htp.p('{"rows":[');
      OPEN tsref FOR l_sql;
      LOOP
          FETCH tsref INTO l_trn_desc,l_trn_hours,l_start_date,l_end_date;
      EXIT WHEN tsref%NOTFOUND;

      l_row_count := l_row_count + 1;
      l_ttl_th := l_ttl_th + l_trn_hours;

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_trn_desc                           || '","'
                                                   || l_trn_hours                          || '","'
                                                   || TO_CHAR(l_start_date, l_date_format) || '","'
                                                   || TO_CHAR(l_end_date, l_date_format)   || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;
htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;