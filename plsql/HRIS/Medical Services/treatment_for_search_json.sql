SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE treatment_for_search_json (p_treatment_desc     IN VARCHAR2 default NULL

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
l_treatment_for             S004_T08014.treatment_for%TYPE;
l_treatment_desc            S004_T08014.treatment_desc%TYPE;

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT treatment_for, treatment_desc ';
   l_from   := ' FROM S004_T08014 ';
   l_where  := ' WHERE 1=1 ';
   l_order  := ' ORDER BY treatment_desc';

   IF p_treatment_desc IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(treatment_desc) LIKE ''' || upper(p_treatment_desc) || '%''';
   END IF;

   l_sql := l_select || l_from || l_where || l_order;

htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_treatment_for
                      ,l_treatment_desc;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_treatment_for                   || '","'
                                                  || l_treatment_desc                    || '"'                                                   
                                                   
                                                   
         ||']}';
      htp.p(l_json);
      l_comma := ',';
   END LOOP;

htp.p(']}');

END;
/
SHOW ERR;