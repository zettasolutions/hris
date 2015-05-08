SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE emp_info_json 
(
  p_by_age       IN NUMBER    default NULL,
  p_by_ab        IN VARCHAR2  default NULL,
  p_by_ws        IN VARCHAR2  default NULL,
  p_by_cs        IN VARCHAR2  default NULL, 
  p_by_rank      IN VARCHAR2  default NULL,
  p_by_et        IN VARCHAR2  default NULL,
  p_by_bt        IN VARCHAR2  default NULL,
  p_by_gender    IN VARCHAR2  default NULL,
  p_by_cc        IN NUMBER    default NULL,
  p_by_dept      IN NUMBER    default NULL,
  p_by_group     IN NUMBER    default NULL,
  p_rows         IN NUMBER    default NULL,
  p_page_no      IN NUMBER    default 1,
  p_print        IN VARCHAR2  default 'P',  /*P-per page, A-print All */
  p_rt           IN VARCHAR2 default NULL  
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
   l_empl_blood_type            employee_active_v.blood_type%TYPE;         
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
   l_emp_grouping               employee_active_v.emp_grouping%TYPE;                
   l_civil_status               employee_active_v.civil_status%TYPE;              
   l_gender                     employee_active_v.gender%TYPE;                
   l_workstation                employee_active_v.workstation%TYPE;                
   l_rank                       employee_active_v.rank%TYPE;    
   l_age_bracket                employee_active_v.age_bracket%TYPE;
   l_created_by                 employee_active_v.created_by%TYPE;              
   l_date_created               employee_active_v.date_created%TYPE;            
   l_modified_by                employee_active_v.modified_by%TYPE;             
   l_date_modified              employee_active_v.date_modified%TYPE;              

   
   l_row_no                     NUMBER(10);
   l_rows                       NUMBER(10);
   l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
   l_row_count                  NUMBER(10) := 0;
   l_dhtmlx_sort                VARCHAR2(1024);
   l_dhtmlx_filter              VARCHAR2(4096);
   l_comma                      VARCHAR2(1);
   


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
                    || ',blood_type'         
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
                    || ',emp_grouping'
                    || ',civil_status'
                    || ',gender'
                    || ',workstation'
                    || ',rank'
                    || ',age_bracket'
                    || ',created_by'              
                    || ',date_created'            
                    || ',modified_by'             
                    || ',date_modified';            
   
   l_from   := '  FROM employee_active_v ';
   l_where  := ' WHERE 1=1';


   IF p_by_age IS NOT NULL THEN
       l_where := l_where || ' AND age = ' || p_by_age;
   END IF;

   IF p_by_ab IS NOT NULL THEN
       l_where := l_where || ' AND age_brak_code = ' || p_by_ab;
   END IF;

   IF p_by_ws IS NOT NULL THEN
       l_where := l_where || ' AND empl_workplace = ' || '''' || p_by_ws || '''';
   END IF;

   IF p_by_cs IS NOT NULL THEN
       l_where := l_where || ' AND empl_civil_status = ' || '''' || p_by_cs || '''';
   END IF;

   IF p_by_rank IS NOT NULL THEN
       l_where := l_where || ' AND empl_rank = ' || p_by_rank;
   END IF;

   IF p_by_et IS NOT NULL THEN
       l_where := l_where || ' AND emp_grouping = ' || '''' || p_by_et || '''';
   END IF;

   IF p_by_bt IS NOT NULL THEN
       l_where := l_where || ' AND empl_blood_type = ' || p_by_bt;
   END IF;

   IF p_by_gender IS NOT NULL THEN
       l_where := l_where || ' AND empl_gender= ' || '''' || p_by_gender || '''';
   END IF;

   IF p_by_cc IS NOT NULL THEN
       l_where := l_where || ' AND empl_group_code= ' || p_by_cc;
   END IF;

   IF p_by_dept IS NOT NULL THEN
       l_where := l_where || ' AND department= ' || p_by_dept;
   END IF;

   IF p_by_group IS NOT NULL THEN
       l_where := l_where || ' AND group_code= ' || p_by_group;
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

   IF p_print ='P' THEN 
      l_sql := l_select ||', row_number() OVER (ORDER BY empl_name) rn ' || l_from || l_where;
      l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);


   ELSE
      l_sql := l_select  || ',0 row_number ' || l_from || l_where;
   END IF;

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
                     ,l_emp_grouping
                     ,l_civil_status
                     ,l_gender
                     ,l_workstation
                     ,l_rank
                     ,l_age_bracket
                     ,l_created_by              
                     ,l_date_created            
                     ,l_modified_by             
                     ,l_date_modified  
                     ,l_row_no;
   EXIT WHEN l_ref%NOTFOUND;
   
      l_row_count:=l_row_count+1;   

      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'       
                                                      ||  l_emp_grouping               || '","'
                                                      ||  l_empl_type                  || '","'
                                                      ||  utl_url.escape(l_empl_name)  || '","'                                                     
                                                      ||  l_empl_group_code            || '","'
                                                      ||  l_age_bracket                || '","'
                                                      ||  l_age                        || '","'
                                                      ||  l_empl_blood_type            || '","'
                                                      ||  l_workstation                || '","'
                                                      ||  l_empl_civil_status          || '","'
                                                      ||  l_empl_gender                || '","'
                                                      ||  l_rank                       || '"'
      ||']}';
      
      htp.p(l_json); 
      
      l_comma := ',';

   END LOOP;


   htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;


 