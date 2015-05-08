SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE employee_active_json 
(
  p_empl_id_no   IN NUMBER default NULL,
  p_rows         IN NUMBER default NULL,
  p_page_no      IN NUMBER default 1,
  p_rt                 IN VARCHAR2 default NULL
) 

IS 

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
   13-JUL-14   GF    New
*/
--DECLARATION SECTION
   l_select                     VARCHAR2(2000);
   l_from                       VARCHAR2(1000);
   l_where                      VARCHAR2(2000);
   l_sql                        VARCHAR2(8000);
   l_json                       VARCHAR2(8000):='';
   l_sql_count                  VARCHAR2(8000);   
   l_total_rows                 NUMBER(10); 
   
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
   l_type_desc                  employee_active_v.type_desc%TYPE;               
   l_cc_desc                    employee_active_v.cc_desc%TYPE;                 
   l_dept_desc                  employee_active_v.dept_desc%TYPE;               
   l_group_desc                 employee_active_v.group_desc%TYPE;              
   l_job_desc                   employee_active_v.job_desc%TYPE;                
   l_age                        employee_active_v.age%TYPE;                
   l_age_brak_code              employee_active_v.age_brak_code%TYPE;                
   l_created_by                 employee_active_v.created_by%TYPE;              
   l_date_created               employee_active_v.date_created%TYPE;            
   l_modified_by                employee_active_v.modified_by%TYPE;             
   l_date_modified              employee_active_v.date_modified%TYPE;              
   l_plan_coverage              employee_active_v.plan_coverage%TYPE; 
   l_plan_curr_bal              employee_active_v.plan_curr_bal%TYPE; 
   l_plan_avail_bal             employee_active_v.plan_avail_bal%TYPE;
   l_unposted_amt               employee_active_v.unposted_amt%TYPE;
   
   l_row_no                     NUMBER(10);
   l_rows                       NUMBER(10);
   l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
   l_row_count                  NUMBER(10) := 0;
   l_dhtmlx_sort                VARCHAR2(1024);
   l_dhtmlx_filter              VARCHAR2(4096);
   


BEGIN
   check_login;
   owa_util.mime_header('application/json'); 
   
   l_select := 'SELECT '   
                    || ' empl_id_no'              
                    || ',empl_type'               
                    || ',empl_emst_code'          
                    || ',empl_last_name'          
                    || ',empl_first_name'         
                    || ',empl_middle_name'        
                    || ',empl_name_extension'     
                    || ',empl_title'              
                    || ',empl_birthdate'          
                    || ',empl_birthplace'         
                    || ',empl_gender'             
                    || ',empl_civil_status'       
                    || ',empl_height_mtr'         
                    || ',empl_weight_kg'          
                    || ',empl_blood_type'         
                    || ',empl_citizenship'        
                    || ',empl_religion'           
                    || ',empl_workplace'          
                    || ',empl_group_code'         
                    || ',empl_jobp_code'          
                    || ',empl_salary_grade'       
                    || ',empl_salary_step'        
                    || ',empl_rank'               
                    || ',empl_date_hired'         
                    || ',empl_regularized_date'   
                    || ',empl_firstday_of_service'
                    || ',empl_with_oldcba'        
                    || ',empl_onpayroll_list'     
                    || ',empl_tax_code'           
                    || ',empl_payroll_code'       
                    || ',empl_flexi_time'         
                    || ',empl_punch_location_code'
                    || ',empl_grant_vl'           
                    || ',empl_grant_sl'           
                    || ',empl_grant_el'           
                    || ',empl_el_days'            
                    || ',empl_bank_acct_no'       
                    || ',empl_attend_bio'         
                    || ',empl_proj_code'          
                    || ',empl_passcode'           
                    || ',pay_effect_date'         
                    || ',department'              
                    || ',group_code'              
                    || ',empl_name'               
                    || ',type_desc'               
                    || ',cc_desc'                 
                    || ',dept_desc'               
                    || ',group_desc'              
                    || ',job_desc'   
                    || ',age' 
                    || ',age_brak_code'
                    || ',plan_coverage'
                    || ',plan_curr_bal'
                    || ',plan_avail_bal'
                    || ',unposted_amt'                   
                    || ',created_by'              
                    || ',date_created'            
                    || ',modified_by'             
                    || ',date_modified';            
   
   l_from   := '  FROM employee_active_v ';
   l_where  := ' WHERE 1=1';


   IF p_empl_id_no IS NOT NULL THEN
       l_where := l_where || ' AND empl_id_no= ' || p_empl_id_no;
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

   l_sql := l_select ||', row_number() OVER (ORDER BY empl_id_no) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);


   /* Get Total Rows */
   l_sql_count := 'SELECT count(*) as total_rows FROM ( SELECT  row_number() OVER (ORDER BY empl_id_no) rn ' || l_from || l_where || ')' || zsi_lib.GeneratePagingWhere(p_page_no);
   OPEN l_ref FOR l_sql_count;
   LOOP
       FETCH l_ref INTO l_total_rows;
       EXIT WHEN l_ref%NOTFOUND;
   END LOOP;
   /*----------------*/

   htp.p('{"rows":[');
 
   OPEN l_ref FOR l_sql;
   LOOP
       FETCH l_ref INTO 
       
                      l_empl_id_no              
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
                     ,l_empl_grant_vl           
                     ,l_empl_grant_sl           
                     ,l_empl_grant_el           
                     ,l_empl_el_days            
                     ,l_empl_bank_acct_no       
                     ,l_empl_attend_bio         
                     ,l_empl_proj_code          
                     ,l_empl_passcode           
                     ,l_pay_effect_date         
                     ,l_department              
                     ,l_group_code              
                     ,l_empl_name               
                     ,l_type_desc               
                     ,l_cc_desc                 
                     ,l_dept_desc               
                     ,l_group_desc              
                     ,l_job_desc      
                     ,l_age
                     ,l_age_brak_code
                     ,l_plan_coverage
                     ,l_plan_curr_bal
                     ,l_plan_avail_bal
                     ,l_unposted_amt
                     ,l_created_by              
                     ,l_date_created            
                     ,l_modified_by             
                     ,l_date_modified                 
                     ,l_row_no;
   EXIT WHEN l_ref%NOTFOUND;
   
      l_row_count:=l_row_count+1;   


      l_json:= '{ "id":'|| l_row_count ||', "data":["'       
                                                      ||  l_empl_id_no                 || '","' 
                                                      ||  l_empl_type                  || '","'
                                                      ||  l_empl_emst_code             || '","'
                                                      ||  utl_url.escape(l_empl_last_name)            || '","' 
                                                      ||  utl_url.escape(l_empl_first_name)            || '","'
                                                      ||  utl_url.escape(l_empl_middle_name)           || '","' 
                                                      ||  l_empl_name_extension        || '","'
                                                      ||  l_empl_title                 || '","'  
                                                      ||  l_empl_birthdate             || '","'
                                                      ||  l_empl_birthplace            || '","'
                                                      ||  l_empl_gender                || '","'
                                                      ||  l_empl_civil_status          || '","'
                                                      ||  l_empl_height_mtr            || '","'
                                                      ||  l_empl_weight_kg             || '","'
                                                      ||  l_empl_blood_type            || '","'
                                                      ||  l_empl_citizenship           || '","'
                                                      ||  l_empl_religion              || '","'
                                                      ||  l_empl_workplace             || '","'
                                                      ||  l_empl_group_code            || '","'
                                                      ||  l_empl_jobp_code             || '","'
                                                      ||  l_empl_salary_grade          || '","'
                                                      ||  l_empl_salary_step           || '","'
                                                      ||  l_empl_rank                  || '","'
                                                      ||  l_empl_date_hired            || '","'
                                                      ||  l_empl_regularized_date      || '","'
                                                      ||  l_empl_firstday_of_service   || '","'
                                                      ||  l_empl_with_oldcba           || '","'
                                                      ||  l_empl_onpayroll_list        || '","'
                                                      ||  l_empl_tax_code              || '","'
                                                      ||  l_empl_payroll_code          || '","'
                                                      ||  l_empl_flexi_time            || '","'
                                                      ||  l_empl_punch_location_code   || '","'
                                                      ||  l_empl_grant_vl              || '","'
                                                      ||  l_empl_grant_sl              || '","'
                                                      ||  l_empl_grant_el              || '","'
                                                      ||  l_empl_el_days               || '","'
                                                      ||  l_empl_bank_acct_no          || '","'
                                                      ||  l_empl_attend_bio            || '","'
                                                      ||  l_empl_proj_code             || '","'
                                                      ||  l_empl_passcode              || '","'
                                                      ||  l_pay_effect_date            || '","'
                                                      ||  l_department                 || '","'
                                                      ||  l_group_code                 || '","'
                                                      ||  utl_url.escape(l_empl_name)                  || '","'
                                                      ||  l_type_desc                  || '","'
                                                      ||  l_cc_desc                    || '","'
                                                      ||  l_dept_desc                  || '","'
                                                      ||  l_group_desc                 || '","'
                                                      ||  l_job_desc                   || '","'
                                                      ||  l_age                        || '","'
                                                      ||  l_age_brak_code              || '","'
                                                      ||  l_plan_coverage              || '","'
                                                      ||  l_plan_curr_bal              || '","'
                                                      ||  l_plan_avail_bal             || '","'
                                                      ||  l_unposted_amt               || '","'
                                                      ||  l_created_by                 || '","'
                                                      ||  l_date_created               || '","'
                                                      ||  l_modified_by                || '","'
                                                      ||  l_date_modified              || '"'
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


 