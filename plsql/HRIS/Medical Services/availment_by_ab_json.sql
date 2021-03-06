SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE availment_by_ab_json (
                              p_tran_month         IN NUMBER default NULL,
                              p_tran_year          IN NUMBER default NULL,
                              p_age_brak_code      IN VARCHAR2 default NULL,
                              p_medplan_code       IN VARCHAR2 default NULL,
                              p_rows               IN NUMBER default NULL,
                              p_page_no            IN NUMBER default 1,
                              p_print              IN VARCHAR2  default 'P',  /*P-per page, A-print All */
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
   12-AUG-14  XX    New
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

l_medplan_code               MedPlan_Availment_V.medplan_code%TYPE;
l_age_brak_code              MedPlan_Availment_V.age_brak_code%TYPE;
l_mpc_desc                   VARCHAR2(100);
l_ab_desc                    VARCHAR2(100);
l_case_count                 NUMBER;
l_billed_sum                 NUMBER;

l_and                        VARCHAR2(5) := '';
l_groupby                    VARCHAR2(1000);
l_groupby_sep                VARCHAR2(1) := '';


l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_ttl_cases                  NUMBER(10) := 0;
l_ttl_bill                   NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT DISTINCT age_brak_code, medplan_code, mp_code, age_bracket  ';
   l_from   := '  FROM MedPlan_Availment2_V ';
   l_where  := ' WHERE 1=1';

   IF p_tran_month IS NOT NULL THEN
      l_where := l_where || ' AND tran_month= ' || p_tran_month;
   END IF;

   IF p_tran_year IS NOT NULL THEN
      l_where := l_where || ' AND tran_year= ' || p_tran_year;
   END IF;

   IF p_age_brak_code IS NOT NULL THEN
      l_where := l_where || ' AND age_brak_code= ' || p_age_brak_code;
   END IF;

   IF p_medplan_code IS NOT NULL THEN
      l_where := l_where || ' AND medplan_code= ' || p_medplan_code;
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

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_age_brak_code
                      ,l_medplan_code
                      ,l_mpc_desc
                      ,l_ab_desc
                      ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
        
        l_where := '';
        
           l_where := 'age_brak_code = ' || l_age_brak_code ||  ' AND medplan_code = ' || l_medplan_code;
           l_and:=  ' AND ';

        IF p_tran_month IS NOT NULL THEN
           l_where := l_where || l_and || 'tran_month = ' || p_tran_month;
           l_and:=  ' AND ';
        END IF;

        IF p_tran_year IS NOT NULL THEN
           l_where := l_where || l_and || 'tran_year = ' || p_tran_year;
        END IF;
      
       l_case_count :=  zsi_lib.GetCount('*','MedPlan_Avail_doc_V',l_where);
       l_billed_sum :=  zsi_lib.GetSum('amnt_billed','MedPlan_Avail_Billed_V',l_where);
       
       l_ttl_cases := l_ttl_cases + l_case_count;
       l_ttl_bill := l_ttl_bill + NVL(l_billed_sum,0);
       
      l_row_count := l_row_count + 1;

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_mpc_desc         || '","'
                                                   || l_ab_desc          || '","'
                                                   || l_case_count       || '","'
                                                   || zsi_lib.FormatAmount(l_billed_sum,2)       || '"'
      ||']}';

      htp.p(l_json);
      l_comma := ',';      
END LOOP;
l_row_count := l_row_count + 1;
l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                   || '*Count &raquo (' || TO_NUMBER(l_row_count-1)  || ')","'
                                                   || ' '                        || '","'
                                                   || l_ttl_cases                        || '","'
                                                   || zsi_lib.FormatAmount(l_ttl_bill,2) || '"'
||']}';
htp.p(l_json);

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;