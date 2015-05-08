SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE clearance_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_tran_date       IN VARCHAR2 default NULL,
                              p_id_no           IN NUMBER default NULL,
                              p_clearance_type  IN VARCHAR2 default NULL,
                              p_post_status     IN NUMBER default 0,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_rt              IN VARCHAR2 default NULL) IS
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
   24-DEC-14  GT    Removed other params.
   03-AUG-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_order                      VARCHAR2(1000);
l_sql                        VARCHAR2(8000);
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_tran_no                    clearance_v.tran_no%TYPE;
l_tran_date                  clearance_v.tran_date%TYPE;
l_id_no                      clearance_v.id_no%TYPE;
l_clearance                  clearance_v.clearance%TYPE;
l_emp_name                   clearance_v.emp_name%TYPE;
l_status                     clearance_v.status%TYPE;
l_cleared                    clearance_v.cleared%TYPE;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('clearance_list');
l_comma                      VARCHAR2(1);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tran_no,tran_date, clearance,cleared, status';
   l_from   := '  FROM clearance_v ';
   l_where  := ' WHERE post_status =' || NVL(p_post_status,0);

   IF p_tran_no IS NOT NULL THEN
      l_where := l_where || ' AND tran_no= ' || p_tran_no;
   END IF;

   IF p_tran_date IS NOT NULL THEN
      l_where := l_where || ' AND tran_date= ''' || TO_DATE(p_tran_date,l_date_format) || '''';
   END IF;

   IF p_id_no IS NOT NULL THEN
      l_where := l_where || ' AND id_no= ' || p_id_no;
   END IF;

   IF p_clearance_type IS NOT NULL THEN
      l_where := l_where || ' AND clearance_type= ' || p_clearance_type;
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
      FETCH l_ref INTO l_tran_no,l_tran_date,l_clearance,l_cleared, l_status,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Accident Cases\" onClick=\"attachURL(''clearance_form?p_id_no=' || p_id_no || '&p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit Clearance Transaction No. &raquo' || l_tran_no || ''', 1350, 600);w1.maximize();\">' || l_tran_no ||'</a>';
   IF l_status = 'No' THEN
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_c\" >';
   END IF;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link          || '","'
                                                   || to_char(l_tran_date,l_date_format)      || '","'
                                                   || l_clearance       || '","'
                                                   || l_cleared         || '","'
                                                   || l_status          || '","'
                                                   || l_chkdel        || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;