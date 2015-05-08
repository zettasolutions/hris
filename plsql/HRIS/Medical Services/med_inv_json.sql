SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE med_inv_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_tran_date       IN VARCHAR2 default NULL,
                              p_meds_type       IN VARCHAR2 default NULL,
                              p_meds_code       IN NUMBER default NULL,
                              p_post_status     IN NUMBER default 0,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_rt              IN VARCHAR2 default NULL
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
   02-08-14   GF    New
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
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('availed_vaccination_list');
l_comma                      VARCHAR2(1);

TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_tran_no                    medicine_inventory_v.tran_no%TYPE;
l_tran_date                  medicine_inventory_v.tran_date%TYPE;
l_quantity                   medicine_inventory_v.quantity%TYPE;
l_expiry_date                medicine_inventory_v.expiry_date%TYPE;
l_medstype                   medicine_inventory_v.medstype%TYPE;
l_medsname                   medicine_inventory_v.medsname%TYPE;
l_medsclass                  medicine_inventory_v.medsclass%TYPE;
l_status                     medicine_inventory_v.status%TYPE;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tran_no,tran_date,quantity,expiry_date,medstype,medsname,medsclass, status';
   l_from   := '  FROM medicine_inventory_v ';
   l_where  := ' WHERE 1=1';
   l_order  := ' ORDER BY tran_no';

   IF p_tran_no IS NOT NULL THEN
      l_where := l_where || ' AND tran_no= ' || p_tran_no;
   END IF;

   IF p_tran_date IS NOT NULL THEN
      l_where := l_where || ' AND tran_date= ''' || TO_DATE(p_tran_date, l_date_format) || '''';
   END IF;

   IF p_meds_type IS NOT NULL THEN
      l_where := l_where || ' AND meds_type= ' || p_meds_type;
   END IF;

   IF p_meds_code IS NOT NULL THEN
      l_where := l_where || ' AND meds_code= ' || p_meds_code;
   END IF;

   IF p_post_status IS NOT NULL THEN
      l_where := l_where || ' AND post_status= ' || p_post_status;
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
      FETCH l_ref INTO l_tran_no,l_tran_date,l_quantity,l_expiry_date,l_medstype,l_medsname,l_medsclass, l_status,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Medicine Inventory List\" onClick=\"parent.attachURL(''med_inv_form?p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit Medicine Inventory &raquo' || l_tran_no || ''', 1350, 600);parent.w1.maximize();\">' || l_tran_no ||'</a>';
   IF l_status = 'No' THEN
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_mi\" >';
   END IF;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link            || '","'
                                                   || TO_CHAR(l_tran_date, l_date_format)   || '","'
                                                   || l_medstype        || '","'
                                                   || l_medsname        || '","'
                                                   || l_medsclass       || '","'
                                                   || l_quantity        || '","'
                                                   || TO_CHAR(l_expiry_date, l_date_format) || '","'
                                                   || l_status          || '","'
                                                   || l_chkdel          || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;