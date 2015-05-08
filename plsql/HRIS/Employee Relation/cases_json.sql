SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE cases_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_case_type       IN VARCHAR2 default NULL,
                              p_case_no         IN NUMBER default NULL,
                              p_respondents     IN VARCHAR2 default NULL,
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
   14-NOV-14  GT    New
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
l_tran_no                    cases_v.tran_no%TYPE;
l_case_type_desc             cases_v.case_type_desc%TYPE;
l_case_no                    cases_v.case_no%TYPE;
l_tran_year                  cases_v.tran_year%TYPE;
l_seq_no                     cases_v.seq_no%TYPE;
l_charges                    cases_v.charges%TYPE;
l_respondents                cases_v.respondents%TYPE;
l_pi_date                    cases_v.pi_date%TYPE;
l_resp_count                 NUMBER := 0;
l_hand_count                 NUMBER := 0;
l_stat_count                 NUMBER := 0;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('cases_list');
l_comma                      VARCHAR2(1);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tran_no,tran_year, seq_no, case_type_desc,case_no,charges, respondents, pi_date';
   l_from   := '  FROM cases_v ';
   l_where  := ' WHERE 1=1 ';
   l_order  := ' ORDER BY tran_no DESC ';

   IF p_tran_no IS NOT NULL THEN
      l_where := l_where || ' AND tran_no= ' || p_tran_no;
   END IF;

   IF p_case_type IS NOT NULL THEN
      l_where := l_where || ' AND case_type= ' || p_case_type;
   END IF;

   IF p_case_no IS NOT NULL THEN
      l_where := l_where || ' AND case_no= ' || p_case_no;
   END IF;

   IF p_respondents IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(respondents) LIKE '|| '''' || '%' ||  UPPER(p_respondents) || '%' || '''' || ' ';
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
   l_sql := l_select  || ',0 row_number ' || l_from || l_where;

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_tran_no,l_tran_year,l_seq_no,l_case_type_desc,l_case_no,l_charges, l_respondents, l_pi_date, l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Case\" onClick=\"attachURL(''cases_form?p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit Case &raquo' || l_tran_no || ''', 1350, 600);w1.maximize();\">' || l_tran_no ||'</a>';
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_c\" >';
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link               || '","'
                                                   || l_tran_year          || '","'
                                                   || l_seq_no             || '","'
                                                   || l_case_type_desc     || '","'
                                                   || l_case_no            || '","'
                                                   || l_charges            || '","'
                                                   || l_respondents        || '","'
                                                   || TO_CHAR(l_pi_date,l_date_format) || '","'
                                                   || l_chkdel             || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;