SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE user_objects_search_json (                    
                              p_object_name                IN VARCHAR2 default NULL

) IS
/*
========================================================================
*
* Copyright (c) 2014 ZettaSolution, Inc.  All rights reserved.
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
l_object_name                user_objects.object_name%TYPE;

BEGIN
   --check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT object_name ';
   l_from   := '  FROM user_objects ';
   l_where  := ' WHERE object_type=''PROCEDURE''';
   l_order  := ' ORDER BY object_name';

   IF p_object_name IS NOT NULL THEN
      l_where := l_where || ' AND object_name like  ''%' || upper(p_object_name) || '%''';
   END IF;

   l_sql := l_select || l_from || l_where || l_order;
   
htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_object_name;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_object_name  || '"'                                                   
                                                   
                                                   
         ||']}';
      htp.p(l_json);
      l_comma := ',';
   END LOOP;

htp.p(']}');

END;
/
SHOW ERR;