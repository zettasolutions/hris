SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE employee_search_json (                    
                              p_empl_id_no                 IN NUMBER default NULL,
                              p_empl_type                  IN VARCHAR2 default NULL,
                              p_empl_emst_code             IN NUMBER default NULL,
                              p_empl_last_name             IN VARCHAR2 default NULL,
                              p_empl_first_name            IN VARCHAR2 default NULL,
                              p_empl_middle_name           IN VARCHAR2 default NULL,
                              p_empl_name_extension        IN VARCHAR2 default NULL,
                              p_empl_title                 IN VARCHAR2 default NULL,
                              p_empl_birthdate             IN VARCHAR2 default NULL,
                              p_empl_birthplace            IN VARCHAR2 default NULL,
                              p_empl_gender                IN VARCHAR2 default NULL,
                              p_empl_civil_status          IN VARCHAR2 default NULL,
                              p_empl_height_mtr            IN NUMBER default NULL,
                              p_empl_weight_kg             IN NUMBER default NULL,
                              p_empl_blood_type            IN VARCHAR2 default NULL,
                              p_empl_citizenship           IN VARCHAR2 default NULL,
                              p_empl_religion              IN VARCHAR2 default NULL,
                              p_empl_workplace             IN VARCHAR2 default NULL,
                              p_empl_group_code            IN VARCHAR2 default NULL,
                              p_empl_jobp_code             IN VARCHAR2 default NULL,
                              p_empl_salary_grade          IN NUMBER default NULL,
                              p_empl_salary_step           IN NUMBER default NULL,
                              p_empl_rank                  IN NUMBER default NULL,
                              p_empl_date_hired            IN VARCHAR2 default NULL,
                              p_empl_regularized_date      IN VARCHAR2 default NULL,
                              p_empl_firstday_of_service   IN VARCHAR2 default NULL,
                              p_empl_with_oldcba           IN NUMBER default NULL,
                              p_empl_onpayroll_list        IN VARCHAR2 default NULL,
                              p_empl_tax_code              IN VARCHAR2 default NULL,
                              p_empl_payroll_code          IN VARCHAR2 default NULL,
                              p_empl_flexi_time            IN VARCHAR2 default NULL,
                              p_empl_punch_location_code   IN NUMBER default NULL,
                              p_empl_grant_vl              IN VARCHAR2 default NULL,
                              p_empl_grant_sl              IN VARCHAR2 default NULL,
                              p_empl_grant_el              IN VARCHAR2 default NULL,
                              p_empl_el_days               IN NUMBER default NULL,
                              p_empl_bank_acct_no          IN VARCHAR2 default NULL,
                              p_empl_attend_bio            IN CHAR default NULL,
                              p_empl_proj_code             IN VARCHAR2 default NULL,
                              p_empl_passcode              IN VARCHAR2 default NULL,
                              p_pay_effect_date            IN VARCHAR2 default NULL,
                              p_department                 IN VARCHAR2 default NULL,
                              p_group_code                 IN VARCHAR2 default NULL,
                              p_empl_name                  IN VARCHAR2 default NULL,
                              p_age                        IN NUMBER default NULL,
                              p_age_brak_code              IN NUMBER default NULL,
                              p_type_desc                  IN VARCHAR2 default NULL,
                              p_cc_desc                    IN VARCHAR2 default NULL,
                              p_dept_desc                  IN VARCHAR2 default NULL,
                              p_group_desc                 IN VARCHAR2 default NULL,
                              p_job_desc                   IN VARCHAR2 default NULL,
                              p_workstation                IN VARCHAR2 default NULL,
                              p_gender                     IN VARCHAR2 default NULL,
                              p_civil_status               IN VARCHAR2 default NULL,
                              p_rank                       IN VARCHAR2 default NULL,
                              p_rt                         IN VARCHAR2 default NULL

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
l_empl_id_no                 employee_active_v.empl_id_no%TYPE;
l_empl_type                  employee_active_v.empl_type%TYPE;
l_empl_emst_code             employee_active_v.empl_emst_code%TYPE;
l_empl_last_name             employee_active_v.empl_last_name%TYPE;
l_empl_first_name            employee_active_v.empl_first_name%TYPE;
l_empl_middle_name           employee_active_v.empl_middle_name%TYPE;
l_empl_name_extension        employee_active_v.empl_name_extension%TYPE;
l_empl_title                 employee_active_v.empl_title%TYPE;
l_empl_birthdate             employee_active_v.empl_birthdate%TYPE;
l_empl_birthplace            employee_active_v.empl_birthplace%TYPE;
l_empl_gender                employee_active_v.empl_gender%TYPE;
l_empl_civil_status          employee_active_v.empl_civil_status%TYPE;
l_empl_height_mtr            employee_active_v.empl_height_mtr%TYPE;
l_empl_weight_kg             employee_active_v.empl_weight_kg%TYPE;
l_empl_blood_type            employee_active_v.empl_blood_type%TYPE;
l_empl_citizenship           employee_active_v.empl_citizenship%TYPE;
l_empl_religion              employee_active_v.empl_religion%TYPE;
l_empl_workplace             employee_active_v.empl_workplace%TYPE;
l_empl_group_code            employee_active_v.empl_group_code%TYPE;
l_empl_jobp_code             employee_active_v.empl_jobp_code%TYPE;
l_empl_salary_grade          employee_active_v.empl_salary_grade%TYPE;
l_empl_salary_step           employee_active_v.empl_salary_step%TYPE;
l_empl_rank                  employee_active_v.empl_rank%TYPE;
l_empl_date_hired            employee_active_v.empl_date_hired%TYPE;
l_empl_regularized_date      employee_active_v.empl_regularized_date%TYPE;
l_empl_firstday_of_service   employee_active_v.empl_firstday_of_service%TYPE;
l_empl_with_oldcba           employee_active_v.empl_with_oldcba%TYPE;
l_empl_onpayroll_list        employee_active_v.empl_onpayroll_list%TYPE;
l_empl_tax_code              employee_active_v.empl_tax_code%TYPE;
l_empl_payroll_code          employee_active_v.empl_payroll_code%TYPE;
l_empl_flexi_time            employee_active_v.empl_flexi_time%TYPE;
l_empl_punch_location_code   employee_active_v.empl_punch_location_code%TYPE;
l_empl_grant_vl              employee_active_v.empl_grant_vl%TYPE;
l_empl_grant_sl              employee_active_v.empl_grant_sl%TYPE;
l_empl_grant_el              employee_active_v.empl_grant_el%TYPE;
l_empl_el_days               employee_active_v.empl_el_days%TYPE;
l_empl_bank_acct_no          employee_active_v.empl_bank_acct_no%TYPE;
l_empl_attend_bio            employee_active_v.empl_attend_bio%TYPE;
l_empl_proj_code             employee_active_v.empl_proj_code%TYPE;
l_empl_passcode              employee_active_v.empl_passcode%TYPE;
l_pay_effect_date            employee_active_v.pay_effect_date%TYPE;
l_department                 employee_active_v.department%TYPE;
l_group_code                 employee_active_v.group_code%TYPE;
l_empl_name                  employee_active_v.empl_name%TYPE;
l_age                        employee_active_v.age%TYPE;
l_age_brak_code              employee_active_v.age_brak_code%TYPE;
l_type_desc                  employee_active_v.type_desc%TYPE;
l_cc_desc                    employee_active_v.cc_desc%TYPE;
l_dept_desc                  employee_active_v.dept_desc%TYPE;
l_group_desc                 employee_active_v.group_desc%TYPE;
l_job_desc                   employee_active_v.job_desc%TYPE;
l_workstation                employee_active_v.workstation%TYPE;
l_gender                     employee_active_v.gender%TYPE;
l_civil_status               employee_active_v.civil_status%TYPE;
l_rank                       employee_active_v.rank%TYPE;
l_row_count                  NUMBER(10) := 0;
l_total_rows                 NUMBER(10);
l_plan_coverage              employee_active_v.plan_coverage%TYPE;
l_plan_curr_bal              employee_active_v.plan_curr_bal%TYPE; 
l_plan_avail_bal             employee_active_v.plan_avail_bal%TYPE;
l_unposted_amt               employee_active_v.unposted_amt%TYPE;  

BEGIN
   check_login;
   owa_util.mime_header('application/json');
   l_empl_name := utl_url.escape(p_empl_name);  
   l_empl_name := replace(l_empl_name,'Ã‘','Ñ');

   l_select := 'SELECT empl_id_no, empl_type,empl_emst_code,empl_last_name,empl_first_name,empl_middle_name,empl_name_extension,empl_title,empl_birthdate,empl_birthplace,empl_gender,empl_civil_status,empl_height_mtr,empl_weight_kg,empl_blood_type,empl_citizenship,empl_religion,empl_workplace,empl_group_code,empl_jobp_code,empl_salary_grade,empl_salary_step,empl_rank,empl_date_hired,empl_regularized_date,empl_firstday_of_service,empl_with_oldcba,empl_onpayroll_list,empl_tax_code,empl_payroll_code,empl_flexi_time,empl_punch_location_code,empl_grant_vl,empl_grant_sl,empl_grant_el,empl_el_days,empl_bank_acct_no,empl_attend_bio,empl_proj_code,empl_passcode,pay_effect_date,department,group_code,empl_name,age,age_brak_code,type_desc,cc_desc,dept_desc,group_desc,job_desc,workstation,gender,civil_status,rank, plan_coverage,plan_curr_bal,plan_avail_bal,unposted_amt';
   l_from   := '  FROM EMPLOYEE_ACTIVE_V ';
   l_where  := ' WHERE 1=1';

   IF p_empl_id_no IS NOT NULL THEN
      l_where := l_where || ' AND empl_id_no= ' || p_empl_id_no;
   END IF;

   IF p_empl_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_name) LIKE '|| '''' || UPPER(p_empl_name) || '%' || '''' || ' ';
   END IF;


   IF p_empl_type IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_type) LIKE '|| '''' || '%' ||  UPPER(p_empl_type) || '%' || '''' || ' ';
   END IF;

   IF p_empl_emst_code IS NOT NULL THEN
      l_where := l_where || ' AND empl_emst_code= ' || p_empl_emst_code;
   END IF;

   IF p_empl_last_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_last_name) LIKE '|| '''' || '%' ||  UPPER(p_empl_last_name) || '%' || '''' || ' ';
   END IF;

   IF p_empl_first_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_first_name) LIKE '|| '''' || '%' ||  UPPER(p_empl_first_name) || '%' || '''' || ' ';
   END IF;

   IF p_empl_middle_name IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_middle_name) LIKE '|| '''' || '%' ||  UPPER(p_empl_middle_name) || '%' || '''' || ' ';
   END IF;

   IF p_empl_name_extension IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_name_extension) LIKE '|| '''' || '%' ||  UPPER(p_empl_name_extension) || '%' || '''' || ' ';
   END IF;

   IF p_empl_title IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_title) LIKE '|| '''' || '%' ||  UPPER(p_empl_title) || '%' || '''' || ' ';
   END IF;

   IF p_empl_birthdate IS NOT NULL THEN
      l_where := l_where || ' AND empl_birthdate= ' || p_empl_birthdate;
   END IF;

   IF p_empl_birthplace IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_birthplace) LIKE '|| '''' || '%' ||  UPPER(p_empl_birthplace) || '%' || '''' || ' ';
   END IF;

   IF p_empl_gender IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_gender) LIKE '|| '''' || '%' ||  UPPER(p_empl_gender) || '%' || '''' || ' ';
   END IF;

   IF p_empl_civil_status IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_civil_status) LIKE '|| '''' || '%' ||  UPPER(p_empl_civil_status) || '%' || '''' || ' ';
   END IF;

   IF p_empl_height_mtr IS NOT NULL THEN
      l_where := l_where || ' AND empl_height_mtr= ' || p_empl_height_mtr;
   END IF;

   IF p_empl_weight_kg IS NOT NULL THEN
      l_where := l_where || ' AND empl_weight_kg= ' || p_empl_weight_kg;
   END IF;

   IF p_empl_blood_type IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_blood_type) LIKE '|| '''' || '%' ||  UPPER(p_empl_blood_type) || '%' || '''' || ' ';
   END IF;

   IF p_empl_citizenship IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_citizenship) LIKE '|| '''' || '%' ||  UPPER(p_empl_citizenship) || '%' || '''' || ' ';
   END IF;

   IF p_empl_religion IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_religion) LIKE '|| '''' || '%' ||  UPPER(p_empl_religion) || '%' || '''' || ' ';
   END IF;

   IF p_empl_workplace IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_workplace) LIKE '|| '''' || '%' ||  UPPER(p_empl_workplace) || '%' || '''' || ' ';
   END IF;

   IF p_empl_group_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_group_code) LIKE '|| '''' || '%' ||  UPPER(p_empl_group_code) || '%' || '''' || ' ';
   END IF;

   IF p_empl_jobp_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_jobp_code) LIKE '|| '''' || '%' ||  UPPER(p_empl_jobp_code) || '%' || '''' || ' ';
   END IF;

   IF p_empl_salary_grade IS NOT NULL THEN
      l_where := l_where || ' AND empl_salary_grade= ' || p_empl_salary_grade;
   END IF;

   IF p_empl_salary_step IS NOT NULL THEN
      l_where := l_where || ' AND empl_salary_step= ' || p_empl_salary_step;
   END IF;

   IF p_empl_rank IS NOT NULL THEN
      l_where := l_where || ' AND empl_rank= ' || p_empl_rank;
   END IF;

   IF p_empl_date_hired IS NOT NULL THEN
      l_where := l_where || ' AND empl_date_hired= ' || p_empl_date_hired;
   END IF;

   IF p_empl_regularized_date IS NOT NULL THEN
      l_where := l_where || ' AND empl_regularized_date= ' || p_empl_regularized_date;
   END IF;

   IF p_empl_firstday_of_service IS NOT NULL THEN
      l_where := l_where || ' AND empl_firstday_of_service= ' || p_empl_firstday_of_service;
   END IF;

   IF p_empl_with_oldcba IS NOT NULL THEN
      l_where := l_where || ' AND empl_with_oldcba= ' || p_empl_with_oldcba;
   END IF;

   IF p_empl_onpayroll_list IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_onpayroll_list) LIKE '|| '''' || '%' ||  UPPER(p_empl_onpayroll_list) || '%' || '''' || ' ';
   END IF;

   IF p_empl_tax_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_tax_code) LIKE '|| '''' || '%' ||  UPPER(p_empl_tax_code) || '%' || '''' || ' ';
   END IF;

   IF p_empl_payroll_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_payroll_code) LIKE '|| '''' || '%' ||  UPPER(p_empl_payroll_code) || '%' || '''' || ' ';
   END IF;

   IF p_empl_flexi_time IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_flexi_time) LIKE '|| '''' || '%' ||  UPPER(p_empl_flexi_time) || '%' || '''' || ' ';
   END IF;

   IF p_empl_punch_location_code IS NOT NULL THEN
      l_where := l_where || ' AND empl_punch_location_code= ' || p_empl_punch_location_code;
   END IF;

   IF p_empl_grant_vl IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_grant_vl) LIKE '|| '''' || '%' ||  UPPER(p_empl_grant_vl) || '%' || '''' || ' ';
   END IF;

   IF p_empl_grant_sl IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_grant_sl) LIKE '|| '''' || '%' ||  UPPER(p_empl_grant_sl) || '%' || '''' || ' ';
   END IF;

   IF p_empl_grant_el IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_grant_el) LIKE '|| '''' || '%' ||  UPPER(p_empl_grant_el) || '%' || '''' || ' ';
   END IF;

   IF p_empl_el_days IS NOT NULL THEN
      l_where := l_where || ' AND empl_el_days= ' || p_empl_el_days;
   END IF;

   IF p_empl_bank_acct_no IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_bank_acct_no) LIKE '|| '''' || '%' ||  UPPER(p_empl_bank_acct_no) || '%' || '''' || ' ';
   END IF;

   IF p_empl_attend_bio IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_attend_bio) LIKE '|| '''' || '%' ||  UPPER(p_empl_attend_bio) || '%' || '''' || ' ';
   END IF;

   IF p_empl_proj_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_proj_code) LIKE '|| '''' || '%' ||  UPPER(p_empl_proj_code) || '%' || '''' || ' ';
   END IF;

   IF p_empl_passcode IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(empl_passcode) LIKE '|| '''' || '%' ||  UPPER(p_empl_passcode) || '%' || '''' || ' ';
   END IF;

   IF p_pay_effect_date IS NOT NULL THEN
      l_where := l_where || ' AND pay_effect_date= ' || p_pay_effect_date;
   END IF;

   IF p_department IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(department) LIKE '|| '''' || '%' ||  UPPER(p_department) || '%' || '''' || ' ';
   END IF;

   IF p_group_code IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(group_code) LIKE '|| '''' || '%' ||  UPPER(p_group_code) || '%' || '''' || ' ';
   END IF;

   IF p_age IS NOT NULL THEN
      l_where := l_where || ' AND age= ' || p_age;
   END IF;

   IF p_age_brak_code IS NOT NULL THEN
      l_where := l_where || ' AND age_brak_code= ' || p_age_brak_code;
   END IF;

   IF p_type_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(type_desc) LIKE '|| '''' || '%' ||  UPPER(p_type_desc) || '%' || '''' || ' ';
   END IF;

   IF p_cc_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(cc_desc) LIKE '|| '''' || '%' ||  UPPER(p_cc_desc) || '%' || '''' || ' ';
   END IF;

   IF p_dept_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(dept_desc) LIKE '|| '''' || '%' ||  UPPER(p_dept_desc) || '%' || '''' || ' ';
   END IF;

   IF p_group_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(group_desc) LIKE '|| '''' || '%' ||  UPPER(p_group_desc) || '%' || '''' || ' ';
   END IF;

   IF p_job_desc IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(job_desc) LIKE '|| '''' || '%' ||  UPPER(p_job_desc) || '%' || '''' || ' ';
   END IF;

   IF p_workstation IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(workstation) LIKE '|| '''' || '%' ||  UPPER(p_workstation) || '%' || '''' || ' ';
   END IF;

   IF p_gender IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(gender) LIKE '|| '''' || '%' ||  UPPER(p_gender) || '%' || '''' || ' ';
   END IF;

   IF p_civil_status IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(civil_status) LIKE '|| '''' || '%' ||  UPPER(p_civil_status) || '%' || '''' || ' ';
   END IF;

   IF p_rank IS NOT NULL THEN
      l_where := l_where ||' AND UPPER(rank) LIKE '|| '''' || '%' ||  UPPER(p_rank) || '%' || '''' || ' ';
   END IF;


   l_sql := l_select || l_from || l_where;
   

   /* Get Total Rows */
   l_sql_count := 'SELECT count(*) as total_rows ' || l_from || l_where; 


   OPEN l_ref FOR l_sql_count;
   LOOP
       FETCH l_ref INTO l_total_rows;
       EXIT WHEN l_ref%NOTFOUND;
   END LOOP;
   /*----------------*/   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_empl_id_no
                        ,l_empl_type
                        ,l_empl_emst_code
                        ,l_empl_last_name
                        ,l_empl_first_name
                        ,l_empl_middle_name
                        ,l_empl_name_extension
                        ,l_empl_title
                        ,l_empl_birthdate
                        ,l_empl_birthplace
                        ,l_empl_gender
                        ,l_empl_civil_status
                        ,l_empl_height_mtr
                        ,l_empl_weight_kg
                        ,l_empl_blood_type
                        ,l_empl_citizenship
                        ,l_empl_religion
                        ,l_empl_workplace
                        ,l_empl_group_code
                        ,l_empl_jobp_code
                        ,l_empl_salary_grade
                        ,l_empl_salary_step
                        ,l_empl_rank
                        ,l_empl_date_hired
                        ,l_empl_regularized_date
                        ,l_empl_firstday_of_service
                        ,l_empl_with_oldcba
                        ,l_empl_onpayroll_list
                        ,l_empl_tax_code
                        ,l_empl_payroll_code
                        ,l_empl_flexi_time
                        ,l_empl_punch_location_code
                        ,l_empl_grant_vl,l_empl_grant_sl
                        ,l_empl_grant_el,l_empl_el_days
                        ,l_empl_bank_acct_no
                        ,l_empl_attend_bio
                        ,l_empl_proj_code
                        ,l_empl_passcode
                        ,l_pay_effect_date
                        ,l_department
                        ,l_group_code
                        ,l_empl_name
                        ,l_age
                        ,l_age_brak_code
                        ,l_type_desc
                        ,l_cc_desc
                        ,l_dept_desc
                        ,l_group_desc
                        ,l_job_desc
                        ,l_workstation
                        ,l_gender
                        ,l_civil_status
                        ,l_rank
                        ,l_plan_coverage 
                        ,l_plan_curr_bal 
                        ,l_plan_avail_bal
                        ,l_unposted_amt;
                        
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      --l_link :='<a href=\"javascript:void(0)\" >' || l_empl_id_no ||'</a>';
      l_json:= '{ "id":'|| l_row_count ||', "data":["' 
                                                   || l_empl_id_no                           || '","'
                                                   || l_empl_type                            || '","'
                                                   || l_empl_emst_code                       || '","'
                                                   || utl_url.escape(l_empl_last_name)       || '","'
                                                   || utl_url.escape(l_empl_first_name)      || '","'
                                                   || utl_url.escape(l_empl_middle_name)     || '","'
                                                   || l_empl_name_extension                  || '","'
                                                   || l_empl_title                           || '","'
                                                   || l_empl_birthdate                       || '","'
                                                   || l_empl_birthplace                      || '","'
                                                   || l_empl_gender                          || '","'
                                                   || l_empl_civil_status                    || '","'
                                                   || l_empl_height_mtr                      || '","'
                                                   || l_empl_weight_kg                       || '","'
                                                   || l_empl_blood_type                      || '","'
                                                   || l_empl_citizenship                     || '","'
                                                   || l_empl_religion                        || '","'
                                                   || l_empl_workplace                       || '","'
                                                   || l_empl_group_code                      || '","'
                                                   || l_empl_jobp_code                       || '","'
                                                   || l_empl_salary_grade                    || '","'
                                                   || l_empl_salary_step                     || '","'
                                                   || l_empl_rank                            || '","'
                                                   || l_empl_date_hired                      || '","'
                                                   || l_empl_regularized_date                || '","'
                                                   || l_empl_firstday_of_service             || '","'
                                                   || l_empl_with_oldcba                     || '","'
                                                   || l_empl_onpayroll_list                  || '","'
                                                   || l_empl_tax_code                        || '","'
                                                   || l_empl_payroll_code                    || '","'
                                                   || l_empl_flexi_time                      || '","'
                                                   || l_empl_punch_location_code             || '","'
                                                   || l_empl_grant_vl                        || '","'
                                                   || l_empl_grant_sl                        || '","'
                                                   || l_empl_grant_el                        || '","'
                                                   || l_empl_el_days                         || '","'
                                                   || l_empl_bank_acct_no                    || '","'
                                                   || l_empl_attend_bio                      || '","'
                                                   || l_empl_proj_code                       || '","'
                                                   || l_empl_passcode                        || '","'
                                                   || l_pay_effect_date                      || '","'
                                                   || l_department                           || '","'
                                                   || l_group_code                           || '","'
                                                   || utl_url.escape(l_empl_name)            || '","'
                                                   || l_age                                  || '","'
                                                   || l_age_brak_code                        || '","'
                                                   || l_type_desc                            || '","'
                                                   || l_cc_desc                              || '","'
                                                   || l_dept_desc                            || '","'
                                                   || l_group_desc                           || '","'
                                                   || l_job_desc                             || '","'
                                                   || l_workstation                          || '","'
                                                   || l_gender                               || '","'
                                                   || l_civil_status                         || '","'
                                                   || l_rank                                 || '","'
                                                   || l_plan_coverage                        || '","'
                                                   || l_plan_curr_bal                        || '","'
                                                   || l_plan_avail_bal                       || '","'
                                                   || l_unposted_amt                         || '"'                                                   
                                                   
                                                   
         ||']}';
      IF (l_row_count != l_total_rows ) THEN
         l_json:= l_json || ',';
      END IF;

      htp.p(l_json);
END LOOP;

htp.p('], "total_rows":"' || l_total_rows || '"}');

END;
/
SHOW ERR;