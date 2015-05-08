SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE cases_inq_stat_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_print           IN VARCHAR2  default 'P',  /*P-per page, A-print All */
                              p_rt              IN VARCHAR2 default NULL) IS
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
   09-FEB-15  GT    New
*/
--DECLARATION SECTION
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_row_id                     NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

CURSOR cs_cur IS
   SELECT *
     FROM S004_T08800_STATUS
    WHERE tran_no = p_tran_no
    ORDER BY seq_no;
    
BEGIN
   check_login;
   owa_util.mime_header('application/json'); 

   htp.p('{"rows":[');
   FOR i IN cs_cur LOOP
      l_row_count := l_row_count + 1;
      
          
               l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                            || i.seq_no                  || '","'
                                                            || i.date_endorsed           || '","'
                                                            || utl_url.escape(i.status)  ||  '"'

                ||']}';
                htp.p(l_json); 
                l_comma := ',';
        
END LOOP;
htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;