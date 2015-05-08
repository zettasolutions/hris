SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE table_view_json (p_tv_name     IN VARCHAR2 default NULL

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
   08-MAR-15  GT    New
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
l_tv_name                    TABLES_VIEWS_V.tv_name%TYPE;
l_type                       TABLES_VIEWS_V.type%TYPE;

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tv_name, type ';
   l_from   := ' FROM TABLES_VIEWS_V ';
   l_where  := ' WHERE 1=1 ';
   l_order  := ' ORDER BY 1';

   IF p_tv_name IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(tv_name) LIKE ''' || upper(p_tv_name) || '%''';
   END IF;

   l_sql := l_select || l_from || l_where || l_order;

htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_tv_name
                      ,l_type;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_tv_name                   || '","'
                                                  || l_type                       || '"'                                                   
                                                   
                                                   
         ||']}';
      htp.p(l_json);
      l_comma := ',';
   END LOOP;

htp.p(']}');

END;
/
SHOW ERR;