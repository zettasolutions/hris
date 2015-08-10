SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE cases_inq_hb_json (
                              p_seq_no          IN NUMBER default NULL,
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
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_row_id                     NUMBER(10) := 0;
l_comma                      VARCHAR2(1);
l_empl_name                  VARCHAR2(1000) := NULL;
l_br                         VARCHAR2(10) := NULL;
    
CURSOR ch_cur IS
   SELECT *
     FROM HandledBy_V
    WHERE status_seq_no = p_seq_no
    ORDER BY seq_no;    

BEGIN
   --check_login;
   owa_util.mime_header('application/json'); 

   htp.p('{"rows":[');
   FOR i IN ch_cur LOOP     
      l_empl_name := l_empl_name || l_br || i.empl_name;
      l_br := '<br />';
   END LOOP;
   l_row_count := l_row_count + 1;
               l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                           || utl_url.escape(l_empl_name)        || '"'

                ||']}';
                htp.p(l_json); 
                l_comma := ',';
        
htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;