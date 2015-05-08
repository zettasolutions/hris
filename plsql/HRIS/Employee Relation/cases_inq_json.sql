SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE cases_inq_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_case_type       IN VARCHAR2 default NULL,
                              p_case_no         IN NUMBER default NULL,
                              p_respondents     IN VARCHAR2 default NULL,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_print           IN VARCHAR2  default 'P',  /*P-per page, A-print All */
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
l_cr_name                    Respondents_V.empl_name%TYPE;
l_ch_name                    HandledBy_V.empl_name%TYPE;
l_cs_name                    S004_T08800_STATUS.status%TYPE;

l_br                         VARCHAR2(10);
l_br2                        VARCHAR2(10);
l_sep                        VARCHAR2(10);
l_comma                      VARCHAR2(1);

CURSOR cr_cur(lp_tran_no IN NUMBER) IS
   SELECT *
     FROM Respondents_V
    WHERE tran_no = lp_tran_no;

CURSOR ch_cur(lp_status_seq_no IN NUMBER) IS
   SELECT *
     FROM HandledBy_V
    WHERE status_seq_no = lp_status_seq_no;
    
CURSOR cs_cur(lp_tran_no IN NUMBER) IS
   SELECT *
     FROM S004_T08800_STATUS
    WHERE tran_no = lp_tran_no;

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT tran_no,tran_year, seq_no, case_type_desc,case_no,charges, respondents, pi_date, resp_count, hand_count, stat_count';
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
   l_sql := 'SELECT COUNT(*) ' || l_from || l_where || l_order;
   OPEN l_ref FOR l_sql;
      LOOP
         FETCH l_ref INTO l_rows;
         EXIT WHEN l_ref%NOTFOUND;
      END LOOP;
   CLOSE l_ref;
   ELSE
   l_rows := p_rows;
   END IF;

   IF p_print ='P' THEN 
   l_sql := l_select ||', row_number() OVER (ORDER BY tran_no DESC) rn ' || l_from || l_where || l_order;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);
   ELSE
      l_sql := l_select  || ',0 row_number ' || l_from || l_where || l_order;
   END IF;

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_tran_no,l_tran_year,l_seq_no,l_case_type_desc,l_case_no,l_charges, l_respondents, l_pi_date,l_resp_count, l_hand_count, l_stat_count, l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      
      l_cr_name :='';
      l_br := '';
      FOR i IN cr_cur(l_tran_no) LOOP
         l_cr_name := l_cr_name || l_br || i.empl_name;
         l_br := '<br />';
      END LOOP;

      l_cs_name :='';
      l_br := '';
      l_sep := '';

      FOR i IN cs_cur(l_tran_no) LOOP
         l_cs_name := l_cs_name || l_br || i.date_endorsed || ' ' ||  i.status;
         l_br2 := '<br />';
         l_cs_name := l_cs_name || l_br2 || 'Handled By:';
         l_br2 := '';
         FOR j IN ch_cur(i.seq_no) LOOP
            l_cs_name :=   l_cs_name || l_sep || l_br2 || j.empl_name;
            l_br2 := '<br />';
            l_sep := ' / ';
         END LOOP;
         l_br := '<br />';
      END LOOP;
     
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_tran_no            || '","'
                                                   || l_tran_year          || '","'
                                                   || l_seq_no             || '","'
                                                   || l_case_type_desc     || '","'
                                                   || l_case_no            || '","'
                                                   || l_charges            || '","'
                                                   || utl_url.escape(l_respondents)    || '","'
                                                   || TO_CHAR(l_pi_date,l_date_format) || '","'
                                                   || utl_url.escape(l_cr_name)        || '","'
                                                   || utl_url.escape(l_cs_name)        || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;
l_row_count := l_row_count + 1;
l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                   || 'Count : (' || TO_NUMBER(l_row_count-1)  || ')","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '","'
                                                   || ' '   || '"'
||']}';
htp.p(l_json);

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;