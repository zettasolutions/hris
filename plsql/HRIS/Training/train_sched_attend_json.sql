SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_sched_attend_json (
                              p_tran_no         IN NUMBER default NULL,
                              p_trn_desc        IN VARCHAR2 default NULL,
                              p_trn_type_name   IN VARCHAR2 default NULL,
                              p_spsr_name       IN VARCHAR2 default NULL,
                              p_spk_name        IN VARCHAR2 default NULL,
                              p_venu_name       IN VARCHAR2 default NULL,
                              p_travel_desc     IN VARCHAR2 default NULL,
                              p_start_date      IN VARCHAR2 default NULL,
                              p_rows            IN NUMBER default NULL,                             
                              p_page_no         IN NUMBER default 1,
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
   04-AUG-14  XX    New
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
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('train_sched_attend_list');

TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_tran_no                    TrainingSchedAttend_V.tran_no%TYPE;
l_start_date                 TrainingSchedAttend_V.start_date%TYPE;
l_end_date                   TrainingSchedAttend_V.start_date%TYPE;
l_trn_desc                   TrainingSchedAttend_V.trn_desc%TYPE;
l_trn_type_name              TrainingSchedAttend_V.trn_type_name%TYPE;
l_spsr_name                  TrainingSchedAttend_V.spsr_name%TYPE;
l_venu_name                  TrainingSchedAttend_V.venu_name%TYPE;
l_travel_desc                TrainingSchedAttend_V.travel_desc%TYPE;
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
   --check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT a.tran_no,a.start_date,a.end_date,a.trn_desc, a.trn_type_name,a.spsr_name ,a.venu_name,a.travel_desc ';
   l_from   := '  FROM TrainingSchedAttend_V a';
   l_where  := ' WHERE 1=1 ';

   IF p_tran_no IS NOT NULL THEN
      l_where := l_where || ' AND a.tran_no= ' || p_tran_no;
   END IF;

   IF p_start_date IS NOT NULL THEN
      l_where := l_where || ' AND a.start_date= ''' || TO_DATE(p_start_date, l_date_format) || '''';
   END IF;

   IF p_trn_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.trn_desc) LIKE '|| '''' || '%' ||  UPPER(p_trn_desc) || '%' || '''' || ' ';
   END IF;

   IF p_trn_type_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.trn_type_name) LIKE '|| '''' || '%' ||  UPPER(p_trn_type_name) || '%' || '''' || ' ';
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

   IF p_travel_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(a.travel_desc) LIKE '|| '''' || '%' ||  UPPER(p_travel_desc) || '%' || '''' || ' ';
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
      FETCH l_ref INTO l_tran_no,l_start_date,l_end_date,l_trn_desc, l_trn_type_name, l_spsr_name ,l_venu_name,l_travel_desc,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      
     l_spk_name :='';
     l_br := '';
     FOR i IN ts_cur(l_tran_no) LOOP   
          l_spk_name := l_spk_name || l_br || i.spk_name;   
          l_br := '<br />';
     END LOOP;      
      
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Training Schedule and Attendance\" onClick=\"parent.attachURL(''train_sched_attend_form?p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit Training Schedule and Attendance. &raquo' || l_tran_no || ''', 1350, 600);parent.w1.maximize();\">' || l_tran_no ||'</a>';
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_c\" >';
      
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link          || '","'
                                                   || TO_CHAR(l_start_date,l_date_format)    || '","'
                                                   || TO_CHAR(l_end_date,l_date_format)      || '","'
                                                   || utl_url.escape(l_trn_desc)         || '","'
                                                   || l_trn_type_name    || '","'
                                                   || l_spsr_name        || '","'
                                                   || l_venu_name        || '","'                                                  
                                                   || l_travel_desc      || '","'                                              
                                                   || l_spk_name         || '","'
                                                   || l_chkdel           || '"'
         ||']}';

      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;