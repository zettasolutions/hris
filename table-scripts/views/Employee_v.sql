
CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_TYPES_V" AS 
  SELECT 
    sele_code
   ,sele_value
   ,description
   ,displayed_text
   ,display_seq  
   ,sele_value || ' - ' || displayed_text as emp_type
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
  FROM S004_T01043
WHERE sele_code = 'EMPLOYEE_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_CIVIL_STATUS_V" AS 
  SELECT *
    FROM S004_T01043
   WHERE sele_code = 'CIVIL_STATUS';

CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_RANK_V" AS 
  SELECT *
  FROM S004_T01043
WHERE UPPER(sele_code) = 'POSITION_RANK'
AND sele_value IN ('1','2','3','4','5');


CREATE OR REPLACE FORCE VIEW "S004"."WORK_STATION_V" AS 
  SELECT *
  FROM S004_T01043
WHERE UPPER(sele_code) = 'WORK_STATION';

CREATE OR REPLACE FORCE VIEW "S004"."GENDER_V" AS 
  SELECT *
  FROM S004_T01043
WHERE UPPER(sele_code) = 'GENDER';

CREATE OR REPLACE FORCE VIEW "S004"."EMP_GROUPING_V" AS 
  SELECT *
  FROM S004_T01043
WHERE UPPER(sele_code) = 'EMP_GROUPING';


CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_V" AS 
  SELECT   empl_id_no
   ,empl_type
   ,empl_emst_code
   ,empl_last_name
   ,empl_first_name
   ,empl_middle_name
   ,empl_name_extension
   ,empl_title
   ,empl_birthdate
   ,empl_birthplace
   ,empl_gender
   ,empl_civil_status
   ,empl_height_mtr
   ,empl_weight_kg
   ,empl_blood_type
   ,empl_citizenship
   ,empl_religion
   ,empl_workplace
   ,empl_group_code
   ,empl_jobp_code
   ,empl_salary_grade
   ,empl_salary_step
   ,empl_rank
   ,empl_date_hired
   ,empl_regularized_date
   ,empl_firstday_of_service
   ,empl_with_oldcba
   ,empl_onpayroll_list
   ,empl_tax_code
   ,empl_payroll_code
   ,empl_flexi_time
   ,empl_punch_location_code
   ,empl_grant_vl
   ,empl_grant_sl
   ,empl_grant_el
   ,empl_el_days
   ,empl_bank_acct_no
   ,empl_attend_bio
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,empl_proj_code
   ,empl_passcode
   ,pay_effect_date
   ,substr(empl_group_code,1,2) ||'0'  as department
   ,substr(empl_group_code,1,1) ||'00' as group_code
   ,empl_last_name || ', ' || empl_first_name || ' ' || empl_middle_name || ' ' || empl_name_extension  AS empl_name
   ,empl_first_name || ' ' || SUBSTR(empl_middle_name,1,1) || '. ' || empl_last_name || ' ' ||empl_name_extension  AS emp_name
   ,floor(months_between(sysdate,empl_birthdate)/12) AS age
   ,GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12)) as age_brak_code
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as type_desc
   ,zsi_lib.GetDescription('COST_CENTER_V','ccnt_desc','ccnt_cd', empl_group_code) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,1)||'00' ) as group_desc
   ,zsi_lib.GetDescription('S004_T01007','jobp_desc','jobp_code', empl_jobp_code) as job_desc
   ,zsi_lib.GetDescription('gender_v','displayed_text','sele_value', empl_gender) as gender
   ,zsi_lib.GetDescription('work_station_v','displayed_text','sele_value', empl_workplace) as workStation
   ,zsi_lib.GetDescription('employee_civil_status_v','displayed_text','sele_value', empl_civil_status) as civil_status
   ,zsi_lib.GetDescription('employee_rank_v','displayed_text','sele_value', empl_rank ) as rank
   ,CASE WHEN (empl_type IN ('PE','CT','TA','PB')) THEN 'REGULAR' ELSE 'NONREG' END AS emp_grouping
   ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12))) as age_bracket
   ,zsi_lib.GetDescription('blood_type_v','displayed_text','sele_value', empl_blood_type ) as blood_type
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_abbrv
FROM S004_T01000;
  
CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_ACTIVE_V" AS 
  SELECT   empl_id_no
   ,empl_type
   ,empl_emst_code
   ,empl_last_name
   ,empl_first_name
   ,empl_middle_name
   ,empl_name_extension
   ,empl_title
   ,empl_birthdate
   ,empl_birthplace
   ,empl_gender
   ,empl_civil_status
   ,empl_height_mtr
   ,empl_weight_kg
   ,empl_blood_type
   ,empl_citizenship
   ,empl_religion
   ,empl_workplace
   ,empl_group_code
   ,empl_jobp_code
   ,empl_salary_grade
   ,empl_salary_step
   ,empl_rank
   ,empl_date_hired
   ,empl_regularized_date
   ,empl_firstday_of_service
   ,empl_with_oldcba
   ,empl_onpayroll_list
   ,empl_tax_code
   ,empl_payroll_code
   ,empl_flexi_time
   ,empl_punch_location_code
   ,empl_grant_vl
   ,empl_grant_sl
   ,empl_grant_el
   ,empl_el_days
   ,empl_bank_acct_no
   ,empl_attend_bio
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,empl_proj_code
   ,empl_passcode
   ,pay_effect_date
   ,substr(empl_group_code,1,2) ||'0'  as department
   ,substr(empl_group_code,1,1) ||'00' as group_code
   ,empl_last_name || ', ' || empl_first_name || ' ' || empl_middle_name || ' ' || empl_name_extension  AS empl_name
   ,empl_first_name || ' ' || SUBSTR(empl_middle_name,1,1) || '. ' || empl_last_name || ' ' ||empl_name_extension  AS emp_name
   ,floor(months_between(sysdate,empl_birthdate)/12) AS age
   ,GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12)) as age_brak_code
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as type_desc
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', empl_group_code) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,1)||'00' ) as group_desc
   ,zsi_lib.GetDescription('S004_T01007','jobp_desc','jobp_code', empl_jobp_code) as job_desc
   ,zsi_lib.GetDescription('gender_v','displayed_text','sele_value', empl_gender) as gender
   ,zsi_lib.GetDescription('work_station_v','displayed_text','sele_value', empl_workplace) as workStation
   ,zsi_lib.GetDescription('employee_civil_status_v','displayed_text','sele_value', empl_civil_status) as civil_status
   ,zsi_lib.GetDescription('employee_rank_v','displayed_text','sele_value', empl_rank ) as rank
   ,CASE WHEN (empl_type IN ('PE','CT','TA','PB')) THEN 'REGULAR' ELSE 'NONREG' END AS emp_grouping
   ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12))) as age_bracket
   ,zsi_lib.GetDescription('medplan_coverage_v','pc','id_no', empl_id_no ) as plan_coverage
   ,zsi_lib.GetDescription('medplan_coverage_v','pcb','id_no', empl_id_no ) as plan_curr_bal
   ,zsi_lib.GetDescription('medplan_coverage_v','avail_bal','id_no', empl_id_no ) as plan_avail_bal
   ,zsi_lib.GetDescription('medplan_coverage_v','unposted_amt','id_no', empl_id_no ) as unposted_amt
   ,zsi_lib.GetDescription('blood_type_v','displayed_text','sele_value', empl_blood_type ) as blood_type
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_abbrv
  FROM S004_T01000
WHERE empl_emst_code IN (1,3);

CREATE OR REPLACE FORCE VIEW "S004"."EMPLOYEE_INACTIVE_V" AS 
  SELECT   empl_id_no
   ,empl_type
   ,empl_emst_code
   ,empl_last_name
   ,empl_first_name
   ,empl_middle_name
   ,empl_name_extension
   ,empl_title
   ,empl_birthdate
   ,empl_birthplace
   ,empl_gender
   ,empl_civil_status
   ,empl_height_mtr
   ,empl_weight_kg
   ,empl_blood_type
   ,empl_citizenship
   ,empl_religion
   ,empl_workplace
   ,empl_group_code
   ,empl_jobp_code
   ,empl_salary_grade
   ,empl_salary_step
   ,empl_rank
   ,empl_date_hired
   ,empl_regularized_date
   ,empl_firstday_of_service
   ,empl_with_oldcba
   ,empl_onpayroll_list
   ,empl_tax_code
   ,empl_payroll_code
   ,empl_flexi_time
   ,empl_punch_location_code
   ,empl_grant_vl
   ,empl_grant_sl
   ,empl_grant_el
   ,empl_el_days
   ,empl_bank_acct_no
   ,empl_attend_bio
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,empl_proj_code
   ,empl_passcode
   ,pay_effect_date
   ,substr(empl_group_code,1,2) ||'0'  as department
   ,substr(empl_group_code,1,1) ||'00' as group_code
   ,empl_last_name || ', ' || empl_first_name || ' ' || empl_middle_name || ' ' || empl_name_extension  AS empl_name
   ,empl_first_name || ' ' || SUBSTR(empl_middle_name,1,1) || '. ' || empl_last_name || ' ' ||empl_name_extension  AS emp_name
   ,floor(months_between(sysdate,empl_birthdate)/12) AS age
   ,GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12)) as age_brak_code
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as type_desc
   ,zsi_lib.GetDescription('COST_CENTER_V','ccnt_desc','ccnt_cd', empl_group_code) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', substr(empl_group_code,1,1)||'00' ) as group_desc
   ,zsi_lib.GetDescription('S004_T01007','jobp_desc','jobp_code', empl_jobp_code) as job_desc
   ,zsi_lib.GetDescription('gender_v','displayed_text','sele_value', empl_gender) as gender
   ,zsi_lib.GetDescription('work_station_v','displayed_text','sele_value', empl_workplace) as workStation
   ,zsi_lib.GetDescription('employee_civil_status_v','displayed_text','sele_value', empl_civil_status) as civil_status
   ,zsi_lib.GetDescription('employee_rank_v','displayed_text','sele_value', empl_rank ) as rank
   ,CASE WHEN (empl_type IN ('PE','CT','TA','PB')) THEN 'REGULAR' ELSE 'NONREG' END AS emp_grouping
   ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', GetAgeBracket(floor(months_between(sysdate,empl_birthdate)/12))) as age_bracket
   ,zsi_lib.GetDescription('blood_type_v','displayed_text','sele_value', empl_blood_type ) as blood_type
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd', substr(empl_group_code,1,2)||'0'  ) as dept_abbrv
  FROM S004_T01000
WHERE empl_emst_code NOT IN (1,3);
 
  CREATE OR REPLACE FORCE VIEW "S004"."DEPENDENTS_V" AS 
  SELECT 
      emde_id_no
     ,emde_dependent_id
     ,emde_dependent_name
     ,emde_birthdate
     ,emde_gender 
     ,emde_rela_code 
     ,created_by
     ,date_created
     ,modified_by
     ,date_modified
     ,floor(months_between(sysdate,emde_birthdate)/12) AS age
     ,GetAgeBracket(floor(months_between(sysdate,emde_birthdate)/12)) as age_brak_code
     ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', GetAgeBracket(floor(months_between(sysdate,emde_birthdate)/12))) as age_bracket
     ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',emde_id_no) as empl_name     
FROM S004_T01029;




