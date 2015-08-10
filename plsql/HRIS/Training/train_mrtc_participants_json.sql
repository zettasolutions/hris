SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE train_mrtc_participants_json (
   p_agency_desc     IN VARCHAR2 default NULL,
   p_trainee         IN VARCHAR2 default NULL,
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
   29-OCT-14  GT    New
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
l_tran_no                  mrtc_participants_v.tran_no%TYPE;
l_trainee                  mrtc_participants_v.trainee%TYPE;     
l_job_position             mrtc_participants_v.job_position%TYPE;
l_address                  mrtc_participants_v.address%TYPE;     
l_contact_no               mrtc_participants_v.contact_no%TYPE;  
l_agency_code              mrtc_participants_v.agency_code%TYPE; 
l_agency_desc              mrtc_participants_v.agency_desc%TYPE; 
l_remarks                  mrtc_participants_v.remarks%TYPE;     

l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('train_mrtc_participants_list');

BEGIN
   --check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT agency_code, agency_desc, tran_no,trainee, job_position, address, contact_no, remarks';
   l_from   := '  FROM mrtc_participants_v ';
   l_where  := ' WHERE 1=1 ';

   IF p_agency_desc IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(agency_desc) LIKE '|| '''' || '%' ||  UPPER(p_agency_desc) || '%' || '''' || ' ';
   END IF;

   IF p_trainee IS NOT NULL THEN
      l_where := l_where || ' AND UPPER(trainee) LIKE '|| '''' || '%' ||  UPPER(p_trainee) || '%' || '''' || ' ';
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

   l_sql := l_select ||', row_number() OVER (ORDER BY tran_no) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);

   /* Get Total Rows */
   l_sql_count := 'SELECT count(*) as total_rows FROM ( SELECT  row_number() OVER (ORDER BY tran_no) rn ' || l_from || l_where || ')' || zsi_lib.GeneratePagingWhere(p_page_no);
   OPEN l_ref FOR l_sql_count;
   LOOP
       FETCH l_ref INTO l_total_rows;
       EXIT WHEN l_ref%NOTFOUND;
   END LOOP;
   /*----------------*/   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_agency_code, l_agency_desc, l_tran_no, l_trainee, l_job_position, l_address, l_contact_no, l_remarks,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;

       l_row_count := l_row_count + 1;
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit MRTC Participant\" onClick=\"parent.attachURL(''train_mrtc_participants_form?p_module_id=' || l_module_id || '&p_tran_no='|| l_tran_no || ''',''Edit MRTC Participant &raquo' || l_tran_no || ''', 1350, 600);parent.w1.maximize();\">' || l_tran_no ||'</a>';
      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_tran_no || ');\"> <input type=\"hidden\" name=\"p_del_c\" >';
      l_json:= '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link                           || '","'
                                                   || utl_url.escape(l_trainee)        || '","'
                                                   || l_agency_desc                    || '","'
                                                   || l_job_position                   || '","'
                                                   || l_address                        || '","'
                                                   || l_contact_no                     || '","'
                                                   || l_remarks                        || '","'
                                                   || l_chkdel                         || '"'
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