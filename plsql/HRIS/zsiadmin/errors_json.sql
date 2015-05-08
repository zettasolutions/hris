SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE errors_json (
                              p_error_no        IN NUMBER default NULL,
                              p_url             IN VARCHAR2 default NULL,
                              p_occurence       IN NUMBER default NULL,
                              p_error_type      IN VARCHAR2 default NULL,
                              p_created_by      IN VARCHAR2 default NULL,
                              p_date_created    IN VARCHAR2 default NULL,
                              p_modified_by     IN VARCHAR2 default NULL,
                              p_date_modified   IN VARCHAR2 default NULL,
                              p_rows          IN NUMBER default NULL,
                              p_page_no       IN NUMBER default 1) IS
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
   08-FEB-15  GF    New
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
TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_error_no        ERRORS.error_no%TYPE;
l_url             ERRORS.url%TYPE;
l_error_message   ERRORS.error_message%TYPE;
l_occurence       ERRORS.occurence%TYPE;
l_error_type      ERRORS.error_type%TYPE;

l_date_created    ERRORS.date_created%TYPE;
l_created_by      ERRORS.created_by%TYPE;
l_date_modified   ERRORS.date_modified%TYPE;
l_modified_by     ERRORS.modified_by%TYPE;



l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_comma                      VARCHAR2(1);


BEGIN
   owa_util.mime_header('application/json');

   l_select := 'SELECT error_no,error_message,url,occurence,error_type,date_created,created_by,date_modified,modified_by';
   l_from   := '  FROM ERRORS ';
   l_where  := ' WHERE 1=1';
    l_order  := ' ORDER BY error_type,error_no';

   IF p_error_no IS NOT NULL THEN
      l_where := l_where || ' AND error_no= ' || p_error_no;
   END IF;

   IF p_url IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(url) LIKE '|| '''' || '%' ||  UPPER(p_url) || '%' || '''' || ' ';
   END IF;

   IF p_occurence IS NOT NULL THEN
      l_where := l_where || ' AND occurence= ' || p_occurence;
   END IF;

   IF p_error_type IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(error_type) LIKE '|| '''' || '%' ||  UPPER(p_error_type) || '%' || '''' || ' ';
   END IF;

   IF p_created_by IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(created_by) LIKE '|| '''' || '%' ||  UPPER(p_created_by) || '%' || '''' || ' ';
   END IF;

   IF p_date_created IS NOT NULL THEN
      l_where := l_where || ' AND date_created= ' || p_date_created;
   END IF;

   IF p_modified_by IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(modified_by) LIKE '|| '''' || '%' ||  UPPER(p_modified_by) || '%' || '''' || ' ';
   END IF;

   IF p_date_modified IS NOT NULL THEN
      l_where := l_where || ' AND date_modified= ' || p_date_modified;
   END IF;

   IF p_page_no = 1 AND p_rows IS NULL THEN
   l_sql := 'SELECT COUNT(*) ' || l_from || l_where;
   OPEN l_ref FOR l_sql;
      LOOP
         FETCH l_ref INTO l_rows;
         EXIT WHEN l_ref%NOTFOUND;
      END LOOP;
   CLOSE l_ref;
   ELSE
   l_rows := p_rows;
   END IF;


   l_sql := l_select  || ',0 row_number ' || l_from || l_where;
   l_sql := l_sql || l_order;
   
   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_error_no,l_error_message,l_url,l_occurence,l_error_type,l_date_created,l_created_by,l_date_modified,l_modified_by,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_error_no || ');\"> <input type=\"hidden\" name=\"p_del_e\" >';

      l_link :='<a href=\"' ||  l_url || ' \" target=\"blank\" >' || l_url ||'</a>';

      l_json:= l_comma ||'{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_error_no        || '","'
                                                   || utl_url.escape(l_error_message)   || '","'
                                                   || l_link            || '","'
                                                   || l_occurence       || '","'
                                                   || l_error_type      || '","'
                                                   || l_date_created    || '","'
                                                   || l_created_by      || '","'
                                                   || l_date_modified   || '","'
                                                   || l_modified_by     || '","'                                                   
                                                   || l_chkdel          || '"'
         ||']}'; 

      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;