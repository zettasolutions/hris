SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE medicine_search_json (p_medicine     IN VARCHAR2 default NULL

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
   09-MAR-15  GT    New
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
l_meds_code                 MEDS_V.meds_code%TYPE;
l_medicine                  MEDS_V.medicine%TYPE;

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT meds_code, medicine ';
   l_from   := ' FROM MEDS_V ';
   l_where  := ' WHERE 1=1 ';
   l_order  := ' ORDER BY medicine';

   IF p_medicine IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(medicine) LIKE ''' || upper(p_medicine) || '%''';
   END IF;

   l_sql := l_select || l_from || l_where || l_order;

htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_meds_code
                      ,l_medicine;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_meds_code                   || '","'
                                                  || l_medicine                    || '"'                                                   
                                                   
                                                   
         ||']}';
      htp.p(l_json);
      l_comma := ',';
   END LOOP;

htp.p(']}');

END;
/
SHOW ERR;