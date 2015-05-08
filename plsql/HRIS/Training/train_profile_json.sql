SET SCAN OFF
CREATE OR REPLACE
PROCEDURE train_profile_json (
                              p_trn_desc        IN VARCHAR2 default NULL,
                              p_spsr_name       IN VARCHAR2 default NULL,
                              p_spk_name        IN VARCHAR2 default NULL,
                              p_venu_name       IN VARCHAR2 default NULL,
                              p_rows            IN NUMBER default NULL,
                              p_page_no         IN NUMBER default 1,
                              p_rt               IN VARCHAR2 default NULL
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
   10-DEC-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);
l_json                       VARCHAR2(8000);
l_chkdel                     VARCHAR2(8000);
l_link                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('train_profile');

TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_tran_no                    TrainingSchedAttend_V.tran_no%TYPE;
l_trn_code                   TrainingSchedAttend_V.trn_code%TYPE;
l_start_date                 TrainingSchedAttend_V.start_date%TYPE;
l_end_date                   TrainingSchedAttend_V.start_date%TYPE;
l_trn_desc                   TrainingSchedAttend_V.trn_desc%TYPE;
l_trn_type_name              TrainingSchedAttend_V.trn_type_name%TYPE;
l_spsr_name                  TrainingSchedAttend_V.spsr_name%TYPE;
l_venu_name                  TrainingSchedAttend_V.venu_name%TYPE;
l_travel_desc                TrainingSchedAttend_V.travel_desc%TYPE;
l_reg_fee                    TrainingSchedAttend_V.reg_fee%TYPE;
l_trn_hours                  TrainingSchedAttend_V.trn_hours%TYPE;
l_ttl_reg_fee                NUMBER(10) := 0;
l_ttl_trn_hours              NUMBER(10) := 0;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_spk_name                   TrainingSpeakers_V.spk_name%TYPE;
l_br                         VARCHAR2(10);
l_comma                      VARCHAR2(1);

CURSOR ts_cur(lp_tran_no IN NUMBER) IS
   SELECT *
     FROM TrainingSpeakers_V
    WHERE tran_no = lp_tran_no;


BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT a.tran_no, a.trn_code, a.trn_desc, a.venu_name, a.start_date,a.end_date, a.reg_fee, a.trn_hours, a.spsr_name ';
   l_from   := '  FROM TrainingSchedAttend_V a';
   l_where  := ' WHERE 1=1 ';


   IF p_trn_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.trn_desc) LIKE '|| '''' || '%' ||  UPPER(p_trn_desc) || '%' || '''' || ' ';
   END IF;

   IF p_spk_name IS NOT NULL THEN
      l_from := l_from || ', TrainingSpeakers_V b';
      l_where := l_where || ' AND b.tran_no = a.tran_no ';
      l_where := l_where || ' AND UPPER(b.spk_name) LIKE '|| '''' || '%' ||  UPPER(p_spk_name) || '%' || '''' || ' ';

   END IF;

   IF p_spsr_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.spsr_name) LIKE '|| '''' || '%' ||  UPPER(p_spsr_name) || '%' || '''' || ' ';
   END IF;

   IF p_venu_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.venu_name) LIKE '|| '''' || '%' ||  UPPER(p_venu_name) || '%' || '''' || ' ';
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

   l_sql := l_select ||', row_number() OVER (ORDER BY a.tran_no) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_tran_no,l_trn_code, l_trn_desc, l_venu_name, l_start_date,l_end_date, l_reg_fee, l_trn_hours, l_spsr_name ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_ttl_reg_fee := l_ttl_reg_fee + l_reg_fee;
      l_ttl_trn_hours := l_ttl_trn_hours + l_trn_hours;

     l_spk_name :='';
     l_br := '';
     FOR i IN ts_cur(l_tran_no) LOOP
          l_spk_name := l_spk_name || l_br || i.spk_name;
          l_br := '<br />';
     END LOOP;

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                   || l_tran_no          || '","'
                                                   || l_trn_code          || '","'
                                                   || l_trn_desc         || '","'
                                                   || l_venu_name        || '","'
                                                   || TO_CHAR(l_start_date,l_date_format)    || '","'
                                                   || TO_CHAR(l_end_date,l_date_format)      || '","'
                                                   || zsi_lib.FormatAmount(l_reg_fee,2)          || '","'
                                                   || zsi_lib.FormatAmount(l_trn_hours,2)       || '","'
                                                   || utl_url.escape(l_spk_name)         || '","'
                                                   || utl_url.escape(l_spsr_name)        || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;
l_row_count := l_row_count + 1;
l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                   || 'Count : (' || TO_NUMBER(l_row_count-1)  || ')","'
                                                   || ' '                        || '","'
                                                   || ' '                        || '","'
                                                   || ' '                        || '","'
                                                   || ' '                        || '","'
                                                   || 'Total(s)'                    || '","'
                                                   || zsi_lib.FormatAmount(l_ttl_reg_fee,2)  || '","'
                                                   || zsi_lib.FormatAmount(l_ttl_trn_hours,2)|| '","'
                                                   || ' '   || '","'
                                                   || ' '   || '"'
||']}';
htp.p(l_json);

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;