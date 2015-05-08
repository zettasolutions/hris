SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE medplan_coverage_json (
                              p_id_no          IN NUMBER default NULL,
                              p_empl_type      IN VARCHAR2 default NULL,
                              p_cost_center    IN VARCHAR2 default NULL,
                              p_emp_name       IN VARCHAR2 default NULL,
                              p_rows           IN NUMBER default NULL,
                              p_page_no        IN NUMBER default 1,
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
   29-07-14   GF    New
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
l_link_ac                    VARCHAR2(8000);
l_link_vr                    VARCHAR2(8000);
l_link_av                    VARCHAR2(8000);
l_link_cl                    VARCHAR2(8000);
l_link_mc                    VARCHAR2(8000);
l_link_ape                   VARCHAR2(8000);
l_link_om                    VARCHAR2(8000);
l_link_mm                    VARCHAR2(8000);
l_link_ph                    VARCHAR2(8000);
l_medplan_coverage           VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_ac                         NUMBER(10) := 0;
l_vr                         NUMBER(10) := 0;
l_av                         NUMBER(10) := 0;
l_cl                         NUMBER(10) := 0;
l_mc                         NUMBER(10) := 0;
l_ape                        NUMBER(10) := 0;
l_om                         NUMBER(10) := 0;
l_mm                         NUMBER(10) := 0;
l_ph                         NUMBER(10) := 0;
l_link_info                  VARCHAR2(8000);

l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('medplan_coverage_list');
TYPE l_cur IS REF CURSOR;
l_ref          l_cur;
l_id_no                      MEDPLAN_COVERAGE_V.id_no%TYPE;
l_plan_coverage              MEDPLAN_COVERAGE_V.plan_coverage%TYPE;
l_plan_curr_bal              MEDPLAN_COVERAGE_V.plan_curr_bal%TYPE;
l_plan_avail_bal             MEDPLAN_COVERAGE_V.avail_bal%TYPE;
l_emp_name                   MEDPLAN_COVERAGE_V.emp_name%TYPE;
l_emp_type                   MEDPLAN_COVERAGE_V.emp_type%TYPE;
l_cc_desc                    MEDPLAN_COVERAGE_V.cc_desc%TYPE;
l_row_no                     NUMBER(10);
l_rows                       NUMBER(10);
l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_comma                      VARCHAR2(1);

BEGIN
check_login;
owa_util.mime_header('application/json');

l_select := 'SELECT id_no,plan_coverage,plan_curr_bal, avail_bal,emp_name,emp_type,cc_desc';
l_from   := '  FROM MEDPLAN_COVERAGE_V ';
l_where  := ' WHERE 1=1';

IF p_id_no IS NOT NULL THEN
    l_where := l_where || ' AND id_no= ' || p_id_no;
END IF;

IF p_empl_type IS NOT NULL THEN
l_where := l_where ||' AND UPPER(empl_type) LIKE '|| '''' || '%' ||  UPPER(p_empl_type) || '%' || '''' || ' ';
END IF;

IF p_cost_center IS NOT NULL THEN
l_where := l_where ||' AND UPPER(cost_center) LIKE '|| '''' || '%' ||  UPPER(p_cost_center) || '%' || '''' || ' ';
END IF;

IF p_emp_name IS NOT NULL THEN
l_where := l_where ||' AND UPPER(emp_name) LIKE '|| '''' || '%' ||  UPPER(p_emp_name) || '%' || '''' || ' ';
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
    FETCH l_ref INTO l_id_no
          ,l_plan_coverage
          ,l_plan_curr_bal
          ,l_plan_avail_bal
          ,l_emp_name
          ,l_emp_type
          ,l_cc_desc
          ,l_row_no;
EXIT WHEN l_ref%NOTFOUND;
l_row_count := l_row_count + 1;
l_medplan_coverage := 'Plan Coverage:' || to_char(zsi_lib.FormatAmount(l_plan_coverage,2)) || '<br>' || 'Curr. Bal.:' || TO_CHAR(zsi_lib.FormatAmount(l_plan_curr_bal,2)) || '<br>' || 'Avail. Bal.:' ||TO_CHAR(zsi_lib.FormatAmount(l_plan_avail_bal,2));
l_ac := 0;
l_vr := 0;
l_av := 0;
l_cl := 0;
l_mc := 0;
l_ape := 0;
l_om := 0;
l_mm := 0;
l_ph := 0;
l_ac :=  zsi_lib.GetCount('*','S004_T08013','Id_no = ' || l_id_no || ' AND post_status=0' );
l_vr :=  zsi_lib.GetCount('*','S004_T08011','Id_no = ' || l_id_no || ' AND post_status=0' );
l_av :=  zsi_lib.GetCount('*','S004_T08021','Id_no = ' || l_id_no || ' AND post_status=0' );
l_cl :=  zsi_lib.GetCount('*','S004_T08012','Id_no = ' || l_id_no || ' AND post_status=0' );
l_mc :=  zsi_lib.GetCount('*','S004_T08020','Id_no = ' || l_id_no || ' AND medplan_code<>4 AND post_status=0' );
l_om :=  zsi_lib.GetCount('*','S004_T08016','Id_no = ' || l_id_no || ' AND post_status=0 ' );
l_ape :=  zsi_lib.GetCount('*','S004_T08020','Id_no = ' || l_id_no || ' AND medplan_code=4 AND medplan_type=1 AND post_status=0' );
l_ph :=  zsi_lib.GetCount('*','S004_T08017','Id_no = ' || l_id_no || ' AND post_status=0'  );
l_mm :=  zsi_lib.GetCount('*','Emp_Med_Maintenance_V','Id_no = ' || l_id_no );

   l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Medplan Coverage\" onClick=\"parent.attachURL(''medplan_coverage_form?p_module_id=' || l_module_id || '&p_id_no='|| l_id_no || ''',''Edit Medical Coverage for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_id_no ||'</a>';
   l_link_ac :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Accident Cases\" onClick=\"parent.attachURL(''accident_cases_list?p_id_no='|| l_id_no || ''',''Accident Case(s) Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_ac ||'</a>';
   l_link_vr :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Vaccine Reservations\" onClick=\"parent.attachURL(''vacc_reserve_list?p_id_no='|| l_id_no || ''',''Vaccine Reservation(s) Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_vr ||'</a>';
   l_link_av :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Availed Vaccinations\" onClick=\"parent.attachURL(''availed_vaccination_list?p_id_no='|| l_id_no || ''',''Availed Vaccination(s) Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_av ||'</a>';
   l_link_cl :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Clearances\" onClick=\"parent.attachURL(''clearance_list?p_id_no='|| l_id_no || ''',''Clearances Transaction(s) for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_cl ||'</a>';
   l_link_mc :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Medical Chart\" onClick=\"parent.attachURL(''consultation_list?p_id_no='|| l_id_no || ''',''Medical Chart(s) Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_mc ||'</a>';
   l_link_ape :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Medical Chart\" onClick=\"parent.attachURL(''ape_list?p_id_no='|| l_id_no || ''',''Annual Physical Exam for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_ape ||'</a>';  
   l_link_om :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View OTC Medicines\" onClick=\"parent.attachURL(''medacquired_clinic_list?p_id_no='|| l_id_no || ''',''OTC Medicine Transaction(s) for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_om ||'</a>';
   l_link_mm :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Medicine Maintenance\" onClick=\"parent.attachURL(''med_maintenance_list?p_id_no='|| l_id_no || ''',''Medicine Maintenance(s) Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_mm ||'</a>';
   l_link_ph :='<a href=\"javascript:void(0)\" TITLE=\"Click here to View Philhealth Counterparts\" onClick=\"parent.attachURL(''philhealth_cp_list?p_id_no='|| l_id_no || ''',''Philhealth Counterpart Transactions for Id No. &raquo' || l_id_no || ''', 1000, 450);parent.w1.maximize();\">' || l_ph ||'</a>';
   l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_id_no || ');\"> <input type=\"hidden\" name=\"p_del_mc\" >';

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_link           || '","'
                                                   || utl_url.escape(l_emp_name)        || '","'
                                                   || l_emp_type       || '","'
                                                   || l_medplan_coverage  || '","'
                                                   || l_link_ac  || '","'
                                                   || l_link_vr  || '","'
                                                   || l_link_av  || '","'
                                                   || l_link_cl  || '","'
                                                   || l_link_mc  || '","'
                                                   || l_link_ape || '","'
                                                   || l_link_om  || '","'
                                                   || l_link_mm  || '","'
                                                   || l_link_ph  || '","'
                                                   || l_chkdel         || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;
      htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');
END;
/
SHOW ERR;