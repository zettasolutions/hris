SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE indv_med_chart_json (
                              p_empl_id_no      IN NUMBER,
                              p_year            IN NUMBER default NULL,
                              p_medplan_type    IN NUMBER default NULL,
                              p_medplan_code    IN NUMBER default NULL,
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
   15-DEC-14  GT    New
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
l_comma                      VARCHAR2(1);

TYPE l_cur IS REF CURSOR;
l_ref          l_cur;


l_ldgr_no              S004_T08010_V.ldgr_no%TYPE;
l_tran_date            S004_T08010_V.tran_date%TYPE;
l_medplantype          S004_T08010_V.medplantype%TYPE;
l_medplan              S004_T08010_V.medplan%TYPE;
l_complaint            S004_T08010_V.complaint%TYPE;
l_diagnosis            S004_T08010_V.diagnosis%TYPE;
l_treatment            S004_T08010_V.treatment%TYPE;
l_row_no               NUMBER(10);
l_rows                 NUMBER(10);
l_max_rows             NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count            NUMBER(10) := 0;
l_total_rows           NUMBER(10);

BEGIN
   check_login;
   owa_util.mime_header('application/json');
   
   l_select := 'SELECT  ldgr_no         
                     ,tran_date       
                     ,medplantype                
                     ,medplan
                     ,complaint
                     ,diagnosis
                     ,treatment';
                     
  l_from  := ' FROM s004_T08010_V ';
  l_where := ' WHERE id_no = ' || p_empl_id_no ;
  l_order  := ' ORDER BY ldgr_no DESC ';
               
   IF p_year IS NOT NULL THEN
      l_where := l_where || ' AND tran_year = ' || p_year;      
   END IF;

   IF p_medplan_type IS NOT NULL THEN
      l_where := l_where || ' AND medplan_type = ' || p_medplan_type;      
   END IF;
   
   IF p_medplan_code IS NOT NULL THEN
         l_where := l_where || ' AND medplan_code = ' || p_medplan_code;      
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
      FETCH l_ref INTO  l_ldgr_no         
                       ,l_tran_date       
                       ,l_medplantype     
                       ,l_medplan
                       ,l_complaint
                       ,l_diagnosis
                       ,l_treatment                       
                       ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Ledger Details\" onClick=\"parent.attachURL(''indv_med_chart_dtl?p_ldgr_no='|| l_ldgr_no || ''',''Individual Medical Chart Ledger No. &raquo' || l_ldgr_no || ''', 1350, 800);parent.w1.maximize();\">' || l_ldgr_no ||'</a>';
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                  || l_link           || '","'
                                                  || TO_CHAR(l_tran_date,l_date_format) || '","'
                                                  || l_medplantype    || '","'  
                                                  || l_medplan        || '","'
                                                  || l_complaint      || '","'
                                                  || l_diagnosis      || '","'
                                                  || l_treatment      || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
      
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;