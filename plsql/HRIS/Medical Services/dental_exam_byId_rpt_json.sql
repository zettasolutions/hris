SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE dental_exam_byId_rpt_json (
                              p_empl_id_no         IN NUMBER,
                              p_year               IN NUMBER default EXTRACT(YEAR FROM SYSDATE),
                              p_rows               IN NUMBER default NULL,
                              p_page_no            IN NUMBER default 1,
                              p_rt                 IN VARCHAR2 default NULL) IS
/*
========================================================================
*
* Copyright (c) 2015 ZettaSolution, Inc.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification is strictly prohibited.
*
========================================================================
*/
/* Modification History
   Date       By    History
   ---------  ----  ---------------------------------------------------------------------
   16-FEB-15  GT    New
*/
--DECLARATION SECTION
l_json                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_order                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_from_date                  DATE;
l_to_date                    DATE;

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_comma                      VARCHAR2(1);

TYPE ta_cur IS REF CURSOR;
taref                ta_cur;
l_ldgr_no            S004_T08010_DENTAL_V.ldgr_no%TYPE;      
l_tran_date          S004_T08010_DENTAL_V.tran_date%TYPE;      
l_ds_desc            S004_T08010_DENTAL_V.ds_desc%TYPE;
l_ds_typedesc        S004_T08010_DENTAL_V.ds_typedesc%TYPE;      
l_ds_qty             S004_T08010_DENTAL_V.ds_qty%TYPE;   
l_ds_rate            S004_T08010_DENTAL_V.ds_rate%TYPE;
l_ds_amount          S004_T08010_DENTAL_V.ds_amount%TYPE;


BEGIN
check_login;
owa_util.mime_header('application/json');  

l_select := 'SELECT ldgr_no, tran_date, ds_desc,  ds_typedesc, ds_qty, ds_rate, ds_amount ';
l_from   := ' FROM S004_T08010_DENTAL_V ';
l_where  := ' WHERE id_no = ' || p_empl_id_no;
l_order  := ' ORDER BY seq_no ';

IF p_year IS NOT NULL THEN
   l_where := l_where || ' AND tran_year = ' || p_year;
END IF;  

l_sql := l_select || l_from || l_where || l_order;
htp.p('{"rows":[');
   OPEN taref FOR l_sql;
   LOOP
       FETCH taref INTO l_ldgr_no, l_tran_date, l_ds_desc,  l_ds_typedesc, l_ds_qty, l_ds_rate, l_ds_amount  ;
   EXIT WHEN taref%NOTFOUND;

   l_row_count := l_row_count + 1;
   l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                               ||'Ledger#:' || l_ldgr_no  || '  Tran. Date:' || l_tran_date || '","'
                                               || l_ds_desc       || '","'
                                               || l_ds_typedesc   || '","'
                                               || l_ds_qty        || '","'
                                               || zsi_lib.FormatAmount(l_ds_rate,2)      || '","'
                                               || zsi_lib.FormatAmount(l_ds_amount,2)    || '"'
   ||']}';

   htp.p(l_json);
   l_comma := ',';     
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;