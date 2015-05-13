SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE med_inv_detail_json (
                              p_meds_code          IN VARCHAR2,                              
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
l_order                      VARCHAR2(1000);
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_ledger_no                  med_inv_ledger_v.ldgr_no%TYPE;
l_tran_date                  med_inv_ledger_v.tran_date%TYPE; 
l_tran_month                 med_inv_ledger_v.tran_month%TYPE; 
l_date                       DATE;
l_begbal_qty                 med_inv_ledger_v.begbal_qty%TYPE; 
l_debit_qty                  med_inv_ledger_v.debit_qty%TYPE;
l_credit_qty                 med_inv_ledger_v.credit_qty%TYPE;
l_balance_qty                NUMBER;
l_purchase_date              med_inv_ledger_v.purchase_date%TYPE;
l_unit_price                 med_inv_ledger_v.unit_price%TYPE;
l_expiry_date                med_inv_ledger_v.expiry_date%TYPE;
l_treatment_for              med_inv_ledger_v.treatment%TYPE;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_year                       NUMBER:= EXTRACT(YEAR FROM SYSDATE);
l_comma                      VARCHAR2(1);

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT DISTINCT ldgr_no, tran_month, tran_date, begbal_qty, nvl(debit_qty,0), nvl(credit_qty,0),  purchase_date, unit_price, expiry_date,treatment   ';
   l_from   := '  FROM med_inv_ledger_v ';
   l_where  := ' WHERE meds_code= ' || p_meds_code || ' AND tyear=' || l_year;
   l_order  := ' ORDER BY tyear, seqno DESC,  tran_date ASC';
   
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
      FETCH l_ref INTO  l_ledger_no 
                       ,l_tran_month
                       ,l_tran_date    
                       ,l_begbal_qty   
                       ,l_debit_qty    
                       ,l_credit_qty   
                       ,l_purchase_date
                       ,l_unit_price   
                       ,l_expiry_date  
                       ,l_treatment_for
                       ,l_row_no;
     
     EXIT WHEN l_ref%NOTFOUND;
       IF l_tran_month IS NOT NULL THEN
          l_balance_qty := l_begbal_qty;
          l_date := l_tran_month;
       ELSE
          l_balance_qty := (l_balance_qty + l_debit_qty) - l_credit_qty;
          l_date := l_tran_date;
       END IF;   

       l_row_count := l_row_count + 1;

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_ledger_no     || '","'
                                                   || TO_CHAR(l_date, l_date_format)    || '","'
                                                   || l_begbal_qty    || '","'
                                                   || l_debit_qty     || '","'
                                                   || l_credit_qty    || '","'
                                                   || l_balance_qty   || '","'
                                                   || TO_CHAR(l_purchase_date, l_date_format) || '","'
                                                   || l_unit_price    || '","'
                                                   || TO_CHAR(l_expiry_date, l_date_format)   || '","'
                                                   || l_treatment_for || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;