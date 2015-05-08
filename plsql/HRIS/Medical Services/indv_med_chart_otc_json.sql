SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE indv_med_chart_otc_json (
                              p_empl_id_no      IN NUMBER default NULL,
                              p_year            IN NUMBER default NULL,
                              p_tran_date       IN VARCHAR2 default NULL,
                              p_meds_code       IN NUMBER default NULL,
                              p_treatment_for   IN NUMBER default NULL,
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
   24-JAN-15  GT    New
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


l_ldgr_no              Medicine_Acquired_V.ldgr_no%TYPE;
l_tran_date            Medicine_Acquired_V.tran_date%TYPE;
l_tran_year            Medicine_Acquired_V.tran_year%TYPE;
l_medsdesc             Medicine_Acquired_V.medsdesc%TYPE;
l_medstype             Medicine_Acquired_V.medstype%TYPE;        
l_medsclass            Medicine_Acquired_V.medsclass%TYPE;        
l_meds_qty             Medicine_Acquired_V.meds_qty%TYPE;   
l_treatment_desc       Medicine_Acquired_V.treatment_desc%TYPE;

l_row_no               NUMBER(10);
l_rows                 NUMBER(10);
l_max_rows             NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count            NUMBER(10) := 0;
l_total_rows           NUMBER(10);

BEGIN
   check_login;
   owa_util.mime_header('application/json');
   IF p_empl_id_no IS NOT NULL THEN     
   l_select := 'SELECT  ldgr_no         
                     ,tran_date   
                     ,tran_year
                     ,medsdesc
                     ,medstype
                     ,medsclass
                     ,meds_qty
                     ,treatment_desc';
                     
  l_from  := ' FROM Medicine_Acquired_V ';
  l_where := ' WHERE post_status=1 AND id_no = ' || p_empl_id_no ;
  l_order := ' ORDER BY ldgr_no ';

   IF p_year IS NOT NULL THEN
      l_where := l_where || ' AND tran_year = ' || p_year;      
   END IF;

   IF p_tran_date IS NOT NULL THEN
      l_where := l_where || ' AND tran_date = ''' || TO_DATE(p_tran_date,l_date_format) || '''';      
   END IF;

   IF p_meds_code IS NOT NULL THEN
      l_where := l_where || ' AND meds_code = ' || p_meds_code;      
   END IF;
   
   IF p_treatment_for IS NOT NULL THEN
      l_where := l_where || ' AND treatment_for = ' || p_treatment_for;      
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
                       ,l_medsdesc      
                       ,l_medstype      
                       ,l_medsclass     
                       ,l_meds_qty       
                       ,l_treatment_desc
                       ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      
      l_row_count := l_row_count + 1;
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_ldgr_no           || '","'
                                                   || TO_CHAR(l_tran_date,l_date_format) || '","'
                                                   || l_tran_year         || '","' 
                                                   || l_medsdesc        || '","'  
                                                   || l_medstype        || '","'
                                                   || l_medsclass       || '","'
                                                   || l_meds_qty        || '","'
                                                   || l_treatment_desc  || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');
END IF;
END;
/
SHOW ERR;