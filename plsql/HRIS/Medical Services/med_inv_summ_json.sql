SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE med_inv_summ_json (
                              p_meds_code          IN VARCHAR2 default NULL,
                              p_rows               IN NUMBER   default NULL,
                              p_page_no            IN NUMBER   default 1,
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
l_tran_month                 med_inv_ledger_v.tran_month%TYPE; 
l_begbal_qty                 med_inv_ledger_v.begbal_qty%TYPE; 
l_debit_qty                  med_inv_ledger_v.debit_qty%TYPE;
l_credit_qty                 med_inv_ledger_v.credit_qty%TYPE;
l_balance_qty                med_inv_ledger_v.balance%TYPE;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_year                       NUMBER:= EXTRACT(YEAR FROM SYSDATE);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT DISTINCT tran_month   ';
   l_from   := '  FROM med_inv_ledger_v ';
   l_where  := ' WHERE 1=1';

   IF p_meds_code IS NOT NULL THEN
      l_where := l_where || ' AND meds_code= ' || p_meds_code || ' AND tyear=' || l_year;
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

   l_sql := l_select ||', row_number() OVER (ORDER BY tran_month desc, tran_date, ldgr_no asc) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);

   /* Get Total Rows */
   l_sql_count := 'SELECT count(*) as total_rows FROM ( SELECT  row_number() OVER (ORDER BY tran_month desc, tran_date,ldgr_no asc) rn ' || l_from || l_where || ')' || zsi_lib.GeneratePagingWhere(p_page_no);
   OPEN l_ref FOR l_sql_count;
   LOOP
       FETCH l_ref INTO l_total_rows;
       EXIT WHEN l_ref%NOTFOUND;
   END LOOP;
   /*----------------*/   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO  l_tran_month  
                       ,l_begbal_qty   
                       ,l_debit_qty    
                       ,l_credit_qty   
                       ,l_balance_qty;  
       
     EXIT WHEN l_ref%NOTFOUND;

       l_where := 'tran_month = ' || l_tran_month || ' AND meds_code = ' || p_meds_code;

       l_begbal_qty  := zsi_lib.GetDescription('med_inv_ledger_v','begbal_qty','tran_month', '''' || l_tran_month || '''', 'meds_code', p_meds_code);
       l_debit_qty   :=  zsi_lib.GetSum('debit_qty','med_inv_ledger_v',l_where);
       l_credit_qty  :=  zsi_lib.GetSum('credit_qty','med_inv_ledger_v',l_where);
       l_balance_qty := (l_begbal_qty + l_debit_qty) - l_credit_qty;
       l_row_count := l_row_count + 1;

      l_json:= '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_tran_month    || '","'
                                                   || l_begbal_qty    || '","'
                                                   || l_debit_qty     || '","'
                                                   || l_credit_qty    || '","'
                                                   || l_balance_qty   || '"'
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