SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE procedure_search_json (p_url     IN VARCHAR2 default NULL

) IS
/*
========================================================================
*
* Copyright (c) 2014-2015 ZettaSolution, Inc.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification is strictly prohibited.
*
========================================================================
*/
/* Modification History
   Date       By    History
   ---------  ----  ---------------------------------------------------------------------
   02-MAR-15  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_order                      VARCHAR2(1000);
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_row_count                  NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_proc_id                    hris_modules_v.module_id%TYPE;
l_url                        hris_modules_v.module_url%TYPE;

BEGIN
   --check_login;
   owa_util.mime_header('application/json');
   l_url := utl_url.escape(p_url);  
   l_url := replace(l_url,'Ã‘','Ñ');

   l_select := 'SELECT module_id, module_url ';
   l_from   := ' FROM hris_modules_v ';
   l_where  := ' WHERE module_url IS NOT NULL';
   l_order  := ' ORDER BY module_url';

   IF p_url IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(module_url) LIKE ''%' || upper(p_url) || '%''';
   END IF;

   l_sql := l_select || l_from || l_where || l_order;

htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_proc_id
                      ,l_url;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_proc_id                   || '","'
                                                  || l_url                       || '"'                                                   
                                                   
                                                   
         ||']}';
      htp.p(l_json);
      l_comma := ',';
   END LOOP;

htp.p(']}');

END;
/
SHOW ERR;