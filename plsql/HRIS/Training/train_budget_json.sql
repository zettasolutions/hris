SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_budget_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_tran_year       IN VARCHAR2 default NULL,
                              p_id_no           IN NUMBER default NULL,
                              p_empl_type       IN VARCHAR2 default NULL,
                              p_budget_type     IN VARCHAR2 default NULL,
                              p_conv_desc       IN VARCHAR2 default NULL,
                              p_emp_name        IN VARCHAR2 default NULL,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_rt                 IN VARCHAR2 default NULL
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
   20-OCT-14  GT    Modified
   03-AUG-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_sql_count                  VARCHAR2(3000);
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_tran_no                    TrainingBudget_V.tran_no%TYPE;
l_tran_year                  TrainingBudget_V.tran_year%TYPE;
l_id_no                      TrainingBudget_V.id_no%TYPE;
l_budget_type_desc           TrainingBudget_V.budget_type_desc%TYPE;
l_conv_desc                  TrainingBudget_V.conv_desc%TYPE;
l_emp_name                   TrainingBudget_V.emp_name%TYPE;
l_dept_desc                  TrainingBudget_V.dept_desc%TYPE;
l_budget_amt                 TrainingBudget_V.budget_amt%TYPE;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('train_budget_list');

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tran_no,tran_year,budget_type_desc, conv_desc,id_no,emp_name,dept_desc, budget_amt';
   l_from   := '  FROM TrainingBudget_V ';
   l_where  := ' WHERE 1=1 ';

   IF p_tran_no IS NOT NULL THEN
      l_where := l_where || ' AND tran_no= ' || p_tran_no;
   END IF;

   IF p_tran_year IS NOT NULL THEN
      l_where := l_where || ' AND tran_year= ' || p_tran_year;
   END IF;


   IF p_budget_type IS NOT NULL THEN
      l_where := l_where || ' AND budget_type= ' || '''' || p_budget_type || '''';
   END IF;

   IF p_conv_desc IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(conv_desc) LIKE '|| '''' || '%' ||  UPPER(p_conv_desc) || '%' || '''' || ' ';
   END IF;
   
   IF p_id_no IS NOT NULL THEN
      l_where := l_where || ' AND id_no= ' || p_id_no;
   END IF;

   IF p_emp_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(emp_name) LIKE '|| '''' || '%' ||  UPPER(p_emp_name) || '%' || '''' || ' ';
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

   l_sql := l_select ||', row_number() OVER (ORDER BY tran_no) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);

   /* Get Total Rows */
   l_sql_count := 'SELECT count(*) as total_rows FROM ( SELECT  row_number() OVER (ORDER BY tran_no) rn ' || l_from || l_where || ')' || zsi_lib.GeneratePagingWhere(p_page_no);
   OPEN l_ref FOR l_sql_count;
   LOOP
       FETCH l_ref INTO l_total_rows;
       EXIT WHEN l_ref%NOTFOUND;
   END LOOP;
   /*----------------*/   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_tran_no,l_tran_year,l_budget_type_desc,l_conv_desc, l_id_no,l_emp_name,l_dept_desc,l_budget_amt, l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Training Budget\" onClick=\"parent.attachURL(''train_budget_form?p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit Training Budget &raquo' || l_tran_no || ''', 1000, 400);\">' || l_tran_no ||'</a>';
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_c\" >';
      l_json:= '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link               || '","'
                                                   || l_tran_year          || '","'
                                                   || l_budget_type_desc   || '","'
                                                   || l_conv_desc          || '","'
                                                   || l_id_no              || '","'
                                                   || utl_url.escape(l_emp_name)           || '","'
                                                   || l_dept_desc          || '","'
                                                   || zsi_lib.FormatAmount(l_budget_amt,2)  || '","'
                                                   || l_chkdel             || '"'
         ||']}';
      IF (l_row_count != l_total_rows ) THEN
         l_json:= l_json || ',';
      END IF;

      htp.p(l_json);
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;