CREATE OR REPLACE FORCE VIEW "S004"."MEDPLAN_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MEDPLAN_COVERAGE';

CREATE OR REPLACE FORCE VIEW "S004"."SPEAKER_TYPE_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'SPEAKER_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."CLEARANCE_TYPES_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'CLEARANCE_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."CASE_TYPES_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'CASE_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."ON_CREDIT_TYPES_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'ON_CREDIT_TRANS';

CREATE OR REPLACE FORCE VIEW "S004"."PAYMENT_TAG_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'PAYMENT_TAG';

CREATE OR REPLACE FORCE VIEW "S004"."DOCTOR_SPECIALTY_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'DOCTOR_SPECIALTY';

CREATE OR REPLACE FORCE VIEW "S004"."CHARGE_TO_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'CHARGE_TO';

CREATE OR REPLACE FORCE VIEW "S004"."DENTAL_SERVICES_V" AS 
  SELECT 
    ds_code
   ,ds_desc
   ,ds_type
   ,ds_rate
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,DECODE(ds_type,0, 'FREE','CHARGE') AS typedesc
  FROM S004_T08009;
 
CREATE OR REPLACE FORCE VIEW "S004"."FREQUENCY_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'FREQUENCY';

CREATE OR REPLACE FORCE VIEW "S004"."ILLNESSES_V" AS 
  SELECT *
  FROM S004_T08002;

CREATE OR REPLACE FORCE VIEW "S004"."MEDS_TYPE_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MEDS_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."MEDPLAN_CODE_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MEDPLAN_CODE';

CREATE OR REPLACE FORCE VIEW "S004"."MEDPLAN_CODE_MC_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MEDPLAN_CODE'
  AND SELE_VALUE NOT IN (2,4,6,8,9);


CREATE OR REPLACE FORCE VIEW "S004"."MEDPLAN_TYPES_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MEDPLAN_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."MEDSERVICE_CODE_V" AS 
  SELECT *
  FROM S004_T08000 
WHERE UPPER(sele_code) = 'MEDSERVICE_CODE';

CREATE OR REPLACE FORCE VIEW "S004"."MEDS_CLASS_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'MED_CLASS';

CREATE OR REPLACE FORCE VIEW "S004"."REFERRAL_TYPE_V" AS 
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'REFERRAL_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."SPORT_TYPES_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'SPORT_TYPE';

CREATE OR REPLACE FORCE VIEW "S004"."AGE_BRACKET_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'AGE_BRACKET';

CREATE OR REPLACE FORCE VIEW "S004"."BLOOD_TYPE_V" AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'BLOOD_TYPE';


CREATE OR REPLACE FORCE VIEW "S004"."Cost_Center_V" AS 
  SELECT *
  FROM S004_T09000
WHERE ccnt_status = 'A';

CREATE OR REPLACE FORCE VIEW "S004"."CCNT_GROUPS_V" AS 
  SELECT *
  FROM S004_T09000
 WHERE CCNT_CD = SUBSTR(CCNT_CD,1,1) ||'00'
   AND ccnt_status = 'A';
 
CREATE OR REPLACE FORCE VIEW "S004"."CCNT_DEPT_V" AS 
  SELECT a.*, SUBSTR(CCNT_CD,1,1) as ccnt_group_no
  FROM S004_T09000 a
 WHERE CCNT_CD = SUBSTR(CCNT_CD,1,2) ||'0'
   AND ccnt_status = 'A';

CREATE OR REPLACE FORCE VIEW "S004"."MEDS_CODE_V" AS 
  SELECT meds_code
        ,meds_name
        ,meds_class
        ,meds_type
        ,unit_price
        ,remarks
        ,zsi_lib.GetDescription('meds_class_v','displayed_text','seq_no', meds_class ) as medsclass
        ,zsi_lib.GetDescription('meds_type_v','displayed_text','seq_no', meds_type) as medstype
  FROM S004_T08003;

CREATE OR REPLACE FORCE VIEW "S004"."MEDS_V" AS 
  SELECT meds_code
        ,meds_name || DECODE(medsclass,'', DECODE(medstype,'','','(' || medsclass || ')'), ' (' || medsclass || DECODE(medstype,'',')',' / ' || medstype || ')')) as medicine
      FROM MEDS_CODE_V;   


CREATE OR REPLACE FORCE VIEW "S004"."REFERENCE_V" AS 
  SELECT 
    reference_code 
   ,reference_desc
   ,referral_type
   ,account_no 
   ,address
   ,remarks 
   ,created_by
   ,date_created
   ,modified_by 
   ,date_modified 
   ,zsi_lib.GetDescription('referral_type_v','displayed_text','seq_no', referral_type) as hcp
  FROM S004_T08004;
  
 
 CREATE OR REPLACE FORCE VIEW "S004"."VACCINES_V" AS 
   SELECT 
     vaccine_code
    ,vaccine_name
    ,frequency
    ,remarks
    ,created_by
    ,date_created
    ,modified_by
    ,date_modified
    ,zsi_lib.GetDescription('frequency_v','displayed_text','seq_no',frequency) as vaccine_freq
   FROM S004_T08005;


 CREATE OR REPLACE FORCE VIEW "S004"."RESULT_GROUP_V" AS 
   SELECT 
       seq_no
      ,result_type
      ,group_code 
      ,group_desc
      ,remarks
      ,ape_priority
      ,created_by
      ,date_created
      ,modified_by
      ,date_modified
      ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) as result_desc
 FROM S004_T08019_GROUP;

 CREATE OR REPLACE FORCE VIEW "S004"."RESULT_GROUP_EXAM_V" AS 
   SELECT 
       seq_no
      ,result_type
      ,exam_group 
      ,exam_code 
      ,exam_desc
      ,normal_range 
      ,remarks
      ,mininum_result
      ,maximum_result
      ,ape_priority
      ,created_by
      ,date_created
      ,modified_by
      ,date_modified
      ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) as result_desc
      ,zsi_lib.GetDescription('S004_T08019_group','group_desc','seq_no',exam_group) as group_desc
      ,exam_desc || ' [' ||zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) || ' / ' || zsi_lib.GetDescription('S004_T08019_group','group_desc','seq_no',exam_group) || ' / ' || normal_range || ']' as exam
 FROM S004_T08019_EXAM;
 
 CREATE OR REPLACE VIEW "S004"."EXAM_RESULT_V" AS
 SELECT 
    seq_no
   ,result_type
   ,exam_group 
   ,exam_code
   ,exam_desc 
   ,normal_range
   ,remarks
   ,minimum_result
   ,maximum_result
   ,ape_priority
   ,created_by 
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) as result_desc
   ,zsi_lib.GetDescription('S004_T08019_GROUP','group_desc','seq_no',exam_group) as group_desc
   FROM S004_T08019_EXAM;
  
CREATE OR REPLACE FORCE VIEW "S004"."LOA_SIGNATORY_V" AS 
  SELECT a.*, zsi_lib.GetDescription('employee_active_v','emp_name','empl_id_no', to_number(a.sele_value) ) as emp_name
  FROM S004_T08000 a
WHERE UPPER(a.sele_code) = 'SIGNATORY_LOA';


 CREATE OR REPLACE FORCE VIEW "S004"."HRIS_MODULES_V" AS 
   SELECT module_id
         ,module_name
         ,module_url
         ,module_group_id
         ,sys_group_id
         ,decode(sys_group_id,1,'Medical Clinic',2,'Training',3,'HR Policy',4,'Employee Relations') as sysgroup
         ,seq_no
         ,zsi_lib.GetDescription('s004_modules','module_name','module_id', module_group_id ) as module_group
         ,ismenu
         ,proc_type
         ,decode(proc_type,'L','List','F','Form','U','Update','D','Delete','J','JSON','T','Filter','I','Inquiry','R','Report','B','Batch Process') as proctype
         ,module_desc
         ,proc_desc
         ,zsi_lib.GetCount('*','s004_user_modules',' module_id=' || module_id) as user_count
         ,zsi_lib.GetCount('*','s004_module_procs',' module_id=' || module_id) as proc_count
  FROM S004_MODULES;
 
  CREATE OR REPLACE FORCE VIEW "S004"."MODULE_PROCS_V" AS 
   SELECT p.module_proc_id 
         ,p.module_id
         ,p.proc_id
         ,p.table_view
         ,p.type
         ,m.module_url
         ,m.proctype
  FROM S004_MODULE_PROCS p, HRIS_MODULES_V m
  WHERE p.proc_id = m.module_id;`
  
   CREATE OR REPLACE FORCE VIEW "S004"."HRIS_USERS_V" AS 
     SELECT user_name
           ,description
           ,is_lock
           ,zsi_lib.GetCount('*','s004_user_modules',' user_name=' || '''' || user_name || '''') as module_count
  FROM S004_T05001;
  
   CREATE OR REPLACE FORCE VIEW "S004"."HRIS_USER_MODULES_V" AS 
     SELECT user_module_id
           ,a.user_name
           ,a.module_id
           ,a.is_write
           ,b.module_group_id
           ,b.module_url
           ,b.module_name
           ,b.seq_no
           ,b.sys_group_id
           ,b.ismenu
  FROM S004_USER_MODULES a, S004_MODULES b
  WHERE a.module_id = b.module_id;
  
  CREATE OR REPLACE FORCE VIEW "S004"."TABLES_VIEWS_V" AS 
   select table_name as tv_name, 'table' as type from user_tables
   UNION
   select view_name as tv_name, 'view' as type from user_views;


   
   /
 