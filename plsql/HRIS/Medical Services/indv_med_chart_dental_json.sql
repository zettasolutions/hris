SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE indv_med_chart_dental_json (
                              p_empl_id_no         IN NUMBER,
                              p_year               IN NUMBER default NULL,
                              p_tran_date          IN VARCHAR2 default NULL,
                              p_ds_complaint       IN VARCHAR2 default NULL,
                              p_rows               IN NUMBER default NULL,
                              p_page_no            IN NUMBER default 1,
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
   24-JAN-15  GT    Modified
   07-OCT-14  GT    New
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


l_ldgr_no              S004_T08010_DENTAL_SUM_V.ldgr_no%TYPE;
l_tran_date            S004_T08010_DENTAL_SUM_V.tran_date%TYPE;
l_tran_year            S004_T08010_DENTAL_SUM_V.tran_year%TYPE;
l_complaint            S004_T08010_DENTAL_SUM_V.complaint%TYPE;
l_diagnosis            S004_T08010_DENTAL_SUM_V.treatment%TYPE;
l_treatment            S004_T08010_DENTAL_SUM_V.treatment%TYPE;
l_no_ds                S004_T08010_DENTAL_SUM_V.no_ds%TYPE;

l_row_no               NUMBER(10);
l_rows                 NUMBER(10);
l_max_rows             NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count            NUMBER(10) := 0;
l_total_rows           NUMBER(10);

BEGIN
   check_login;
   owa_util.mime_header('application/json');
   
   IF p_empl_id_no IS NOT NULL THEN   
   l_select := 'SELECT ldgr_no 
                      ,tran_date       
                      ,tran_year            
                      ,complaint            
                      ,diagnosis            
                      ,treatment                      
                      ,no_ds ';
                     
  l_from  := ' FROM S004_T08010_DENTAL_SUM_V ';
  l_where := ' WHERE id_no = ' || p_empl_id_no ;
  l_order := ' ORDER BY ldgr_no ';
               
   IF p_year IS NOT NULL THEN
      l_where := l_where || ' AND tran_year = ' || p_year;      
   END IF;

   IF p_tran_date IS NOT NULL THEN
      l_where := l_where || ' AND tran_date = ''' || TO_DATE(p_tran_date,l_date_format) || '''';      
   END IF;

   IF p_ds_complaint IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(complaint) LIKE '|| '''' || '%' ||  UPPER(p_ds_complaint) || '%' || '''' || ' ';
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
                       ,l_tran_year 
                       ,l_complaint 
                       ,l_diagnosis 
                       ,l_treatment 
                       ,l_no_ds     
                       ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      
      l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"View Dental Services Details\" onClick=\"attachURL(''indv_med_chart_dtl?p_ldgr_no=' || l_ldgr_no || '&p_tab=4'',''Dental Services Details for Ledger No. &raquo' || l_ldgr_no || ''', 1350, 600);w1.maximize();\">' || l_ldgr_no ||'</a>';
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link           || '","'
                                                   || TO_CHAR(l_tran_date,l_date_format) || '","'
                                                   || l_tran_year          || '","'  
                                                   || l_complaint          || '","'
                                                   || l_diagnosis          || '","'
                                                   || l_treatment          || '","'
                                                   || l_no_ds              || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');
END IF;
END;
/
SHOW ERR;