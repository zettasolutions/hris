CREATE OR REPLACE FORCE VIEW medicine_inventory_v AS
SELECT
tran_no
,tran_date
,meds_type
,meds_code
,quantity
,unit_price
,purchase_date
,expiry_date
,remarks
,post_status
,post_date
,created_by
,date_created
,modified_by
,date_modified
,zsi_lib.GetDescription('meds_code_v','meds_name','meds_code',meds_code) as medsname
,zsi_lib.GetDescription('meds_code_v','medstype','meds_code',meds_code) as medstype
,zsi_lib.GetDescription('meds_code_v','medsclass','meds_code',meds_code) as medsclass
,zsi_lib.GetStatus(post_status) as status
,zsi_lib.GetDescription('MEDS_V','medicine','meds_code',a.meds_code) as medicine
FROM S004_T08007;

CREATE OR REPLACE FORCE VIEW med_inv_ledger_v AS
SELECT
 ldgr_no
,tran_no
,tran_date
,tran_month
,EXTRACT(MONTH FROM DECODE(tran_month, NULL, tran_date, tran_month)) as tmonth
,EXTRACT(YEAR FROM DECODE(tran_month, NULL, tran_date, tran_month)) as tyear
,DECODE(tran_month, NULL, 0, 1) as seqno
,tran_type
,meds_type
,meds_code
,begbal_qty
,debit_qty
,credit_qty
,balance
,unit_price
,purchase_date
,expiry_date
,treatment_for
,remarks
,post_date
,created_by
,date_created
,modified_by
,date_modified
,zsi_lib.GetDescription('S004_T08003','meds_class','meds_code',meds_code ) as meds_class
,zsi_lib.GetDescription('meds_type_v','description','sele_value', meds_type ) as medsdesc
,zsi_lib.GetDescription('S004_T08003','meds_name','meds_code',meds_code) as medsname
,zsi_lib.GetDescription('S004_T08014','treatment_desc','treatment_for',treatment_for) as treatment
FROM S004_T08008;

CREATE OR REPLACE FORCE VIEW vacc_reservation_v  AS 
  SELECT 
    tran_no
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_code
   ,vaccine_code
   ,is_reserved
   ,remarks
   ,in_house
   ,post_status
   ,post_date  
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value',empl_type) as emp_type
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('S004_T08005','vaccine_name','vaccine_code',vaccine_code) as vacc_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd',cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd',department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd',group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetStatus(is_reserved) as isreserved
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as medplan
   ,zsi_lib.GetStatus(post_status) as status
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd', department) as dept_abbrv
FROM S004_T08011;

CREATE OR REPLACE FORCE VIEW CLEARANCE_V AS
SELECT tran_no
       ,tran_date
       ,id_no
       ,age_brak_code
       ,empl_type
       ,cost_center
       ,department
       ,group_code
       ,clearance_type
       ,sport_type
       ,doctor_code
       ,is_cleared
       ,remarks
       ,post_status
       ,post_date
       ,created_by
       ,date_created
       ,modified_by
       ,date_modified
       ,zsi_lib.GetDescription('clearance_types_v','displayed_text','sele_value', clearance_type) as clearance
       ,zsi_lib.GetDescription('sport_types_v','displayed_text','sele_value', sport_type) as sport
       ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
       ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type) as emp_type
       ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center) as cc_desc
       ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', department) as dept_desc
       ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', group_code) as group_desc
       ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
       ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
       ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', age_brak_code) as age_bracket
       ,zsi_lib.GetDescription('S004_T08006','doctor_name','doctor_code', doctor_code) as doctor_name          
       ,zsi_lib.GetStatus(is_cleared) as cleared
       ,zsi_lib.GetStatus(post_status) as status
  FROM S004_T08012;

CREATE OR REPLACE FORCE VIEW Accident_Cases_V  AS 
  SELECT 
    tran_no                   
   ,tran_date
   ,id_no
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,accident_date
   ,accident_time
   ,manhour_lost
   ,sick_leave
   ,accident_location
   ,current_activity
   ,accident_description
   ,accident_cause_acts
   ,accident_cause_cond
   ,direct_superior
   ,remarks
   ,post_status
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,amount
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type) as emp_type
   ,zsi_lib.GetStatus(post_status) as status
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',direct_superior) as direct_superior_name
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
FROM S004_T08013;

CREATE OR REPLACE FORCE VIEW Medicine_Maintenance_V AS 
SELECT
tran_no
,tran_date
,id_no
,age_brak_code
,empl_type
,cost_center
,department
,group_code
,medplan_type
,medplan_code
,released_date
,allowed_amt
,post_status
,post_date
,created_by
,date_created
,modified_by
,date_modified
,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value',medplan_type) as medplantype
,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as medplan
,zsi_lib.GetStatus(post_status) as status
FROM S004_T08015;

CREATE OR REPLACE FORCE VIEW Philhealth_CP_V AS 
  SELECT
   tran_no
   ,id_no
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,dependent_id
   ,jv_trandate
   ,jv_number
   ,amount
   ,remarks
   ,post_status
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dependent_id) as dep_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value',empl_type) as emp_type
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd',cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd',department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd',group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value', medplan_type) as medplantype
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value', medplan_code) as medplan
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
   ,zsi_lib.GetStatus(post_status) as status
FROM S004_T08017;

CREATE OR REPLACE FORCE VIEW Med_Maintenance_dtl_V AS 
SELECT
tran_no
,seq_no
,meds_code
,meds_qty
,meds_dosage
,created_by
,date_created
,modified_by
,date_modified
,zsi_lib.GetDescription('S004_T08003','meds_name','meds_code',meds_code) as medsname
,zsi_lib.GetDescription('MEDS_CODE_V','medsclass','meds_code',meds_code) as medsclass
FROM S004_T08015_DTL;

CREATE OR REPLACE FORCE VIEW Emp_Med_Maintenance_V AS 
SELECT
seq_no
,id_no
,meds_code
,meds_qty
,meds_dosage
,meds_instruction
,zsi_lib.GetDescription('S004_T08003','meds_name','meds_code',meds_code) as medsname
,zsi_lib.GetDescription('MEDS_CODE_V','medsclass','meds_code',meds_code) as medsclass
,zsi_lib.GetDescription('S004_T08010_ILLNESS_V','illness_name','seq_no',illness_seqno) as illness_name
FROM S004_T08010_MEDS
WHERE is_maintenance=1;

CREATE OR REPLACE FORCE VIEW MedPlan_Availment_V AS 
SELECT 
    ldgr_no 
   ,tran_no
   ,EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,complaint
   ,diagnosis
   ,treatment
   ,recom_test
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value',medplan_type) as mp_type
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as mp_code   
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as emp_type
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd',cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd',department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc  
   ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', age_brak_code) as age_bracket  
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
FROM S004_T08010;

CREATE OR REPLACE FORCE VIEW MedPlan_Availment2_V AS 
SELECT DISTINCT 
    EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,complaint
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value',medplan_type) as mp_type
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as mp_code   
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','displayed_text','sele_value', empl_type) as emp_type
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd',department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd',group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc  
   ,zsi_lib.GetDescription('age_bracket_v','displayed_text','sele_value', age_brak_code) as age_bracket  
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
FROM S004_T08010;

CREATE OR REPLACE FORCE VIEW MedPlan_Avail_ih_V AS 
SELECT
    ldgr_no 
   ,EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,doctor_code 
   ,reference_code
   ,remarks
   ,zsi_lib.GetDescription('MedPlan_Availment_V','medplan_code','ldgr_no',ldgr_no) as medplan_code
   FROM S004_T08010_DOCTOR
  WHERE reference_code IN (1,2);
   
CREATE OR REPLACE FORCE VIEW MedPlan_Avail_os_V AS 
SELECT
    ldgr_no 
   ,EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,doctor_code 
   ,reference_code
   ,remarks
   ,zsi_lib.GetDescription('MedPlan_Availment_V','medplan_code','ldgr_no',ldgr_no) as medplan_code
   FROM S004_T08010_DOCTOR
  WHERE reference_code NOT IN (1,2);

CREATE OR REPLACE FORCE VIEW MedPlan_Avail_Billed_V AS 
SELECT
    ldgr_no 
   ,EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,amnt_billed
   ,amnt_covered
   ,amnt_not_covered
   ,zsi_lib.GetDescription('MedPlan_Availment_V','medplan_code','ldgr_no',ldgr_no) as medplan_code
   ,zsi_lib.GetDescription('MedPlan_Availment_V','age_brak_code','ldgr_no',ldgr_no) as age_brak_code
   FROM S004_T08010_BILLING;
   
   
CREATE OR REPLACE FORCE VIEW MedPlan_Avail_doc_V AS 
SELECT
    ldgr_no 
   ,EXTRACT(MONTH FROM tran_date) AS tran_month
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,doctor_code 
   ,reference_code
   ,remarks
   ,zsi_lib.GetDescription('MedPlan_Availment_V','medplan_code','ldgr_no',ldgr_no) as medplan_code
   ,zsi_lib.GetDescription('MedPlan_Availment_V','age_brak_code','ldgr_no',ldgr_no) as age_brak_code
   FROM S004_T08010_DOCTOR;
   
CREATE OR REPLACE FORCE VIEW Consultation_v AS 
SELECT
   tran_no
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,complaint
   ,diagnosis
   ,treatment
   ,recom_test
   ,remarks
   ,post_status
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value', medplan_type ) as medplantype     
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as medplan
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as emp_type
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center ) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', department ) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', group_code ) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv
   ,zsi_lib.GetStatus(post_status) as status
FROM S004_T08020;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_DOCTORS_V" AS 
SELECT 
    seq_no
   ,tran_no
   ,doctor_code
   ,reference_code 
   ,remarks 
   ,created_by 
   ,date_created
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('S004_T08006','doctor_name','doctor_code',doctor_code) as doctor_name
   ,zsi_lib.GetDescription('doctors_v','doctor_specialty','doctor_code',doctor_code) as doctor_specialty
   ,zsi_lib.GetDescription('s004_T08004','reference_desc','reference_code',reference_code ) as hcp     
FROM S004_T08020_DOCTOR;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_DENTAL_V" AS 
SELECT 
    seq_no
   ,tran_no
   ,ds_code
   ,ds_rate
   ,ds_qty
   ,is_followup
   ,next_visit 
   ,remarks 
   ,date_created
   ,modified_by 
   ,date_modified
   ,ds_rate * ds_qty AS ds_amount
   ,zsi_lib.GetDescription('dental_services_v','typedesc','ds_code',ds_code ) as ds_type     
FROM S004_T08020_DENTAL;
  
CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_MEDS_V" AS 
SELECT 
    seq_no
   ,tran_no
   ,meds_code
   ,meds_qty
   ,unit_price
   ,reference_code
   ,dosage
   ,meds_instruction
   ,is_maintenance
   ,remarks
   ,date_created
   ,modified_by 
   ,date_modified
   ,meds_qty * unit_price AS meds_amount
   ,zsi_lib.GetDescription('meds_code_v','meds_name','meds_code',meds_code ) as meds_name     
   ,zsi_lib.GetDescription('MEDS_V','medicine','meds_code',a.meds_code) as medicine
   ,illness_seqno
FROM S004_T08020_MEDS;
  
CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_BILLING_V" AS 
SELECT 
   b.seq_no
  ,b.tran_no
  ,b.medservice_code
  ,b.amnt_billed        
  ,b.amnt_covered       
  ,b.amnt_not_covered   
  ,b.or_date            
  ,b.or_number          
  ,b.issued_by          
  ,b.for_refund         
  ,b.remarks
  ,b.doctor_code
  ,b.reference_code
  ,b.payment_tag
  ,b.date_created
  ,b.modified_by 
  ,b.date_modified
  ,a.id_no
  ,a.post_status
  ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', b.medservice_code ) as medservice     
  ,zsi_lib.GetDescription('reference_v','reference_desc','reference_code',b.reference_code ) reference_desc    
FROM S004_T08020_BILLING b,  S004_T08020 a
WHERE b.tran_no=a.tran_no;
  
  
CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_ILLNESS_V" AS 
SELECT 
   seq_no
  ,tran_no
  ,illness_code
  ,is_followup
  ,next_visit 
  ,remarks
  ,date_created
  ,modified_by 
  ,date_modified
  ,zsi_lib.GetDescription('S004_T08002','illness_name','illness_code',illness_code ) as illness_name     
FROM S004_T08020_ILLNESS;

  
CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_SERVICES_V" AS 
SELECT 
    seq_no
   ,tran_no
   ,medservice_code
   ,systolic
   ,diastolic
   ,remarks
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',performed_by ) as empl_name     
   ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', medservice_code ) as medservice     
FROM S004_T08020_SERVICES;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_RESULTS_HDR_V" AS 
SELECT 
    seq_no
   ,tran_no
   ,medservice_code
   ,result_type
   ,conducted_by
   ,checked_by
   ,remarks
   ,is_followup
   ,follow_up_lab
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('s004_t08022','lab_staff_name','lab_staff_code',conducted_by) as conducted_by_name    
   ,zsi_lib.GetDescription('s004_t08022','lab_staff_name','lab_staff_code',checked_by) as checked_by_name     
   ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', medservice_code ) as medservice     
   ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) as result_desc
FROM S004_T08020_RESULT_HDR;


CREATE OR REPLACE FORCE VIEW "S004"."S004_T08020_RESULTS_V" AS 
SELECT 
    d.dtl_seq_no
   ,d.hdr_seq_no
   ,d.tran_no
   ,d.exam_group
   ,d.exam_code
   ,d.result
   ,d.modified_by 
   ,d.date_modified
   ,h.seq_no
   ,h.tran_year
   ,h.tran_date
   ,h.id_no
   ,h.dep_id
   ,h.result_type
   ,h.conducted_by
   ,h.checked_by
   ,h.medservice_code
   ,h.remarks
   ,h.is_followup
   ,h.follow_up_lab
   ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',h.result_type) as result_desc
   ,zsi_lib.GetDescription('S004_T08019_GROUP','group_desc','seq_no',d.exam_group) as group_desc
   ,zsi_lib.GetDescription('s004_t08019_exam','exam_desc','seq_no',d.exam_code) as exam_desc     
   ,zsi_lib.GetDescription('s004_t08019_exam','normal_range','seq_no',d.exam_code) as normal_range     
   ,zsi_lib.GetDescription('s004_t08019_exam','ape_priority','seq_no',d.exam_code) as ape_priority     
   ,zsi_lib.GetDescription('s004_t08022','lab_staff_name','lab_staff_code',conducted_by) as conducted_by_name    
   ,zsi_lib.GetDescription('s004_t08022','lab_staff_name','lab_staff_code',checked_by) as checked_by_name     
FROM S004_T08020_RESULT d, S004_T08020_RESULT_HDR h
WHERE d.hdr_seq_no = h.seq_no;

 CREATE OR REPLACE FORCE VIEW Unposted_Billing_V AS 
 SELECT
     id_no
    ,zsi_lib.FormatAmount(sum(amnt_billed),2) unposted_amt
   FROM S004_T08020_BILLING_V
   WHERE post_status=0
   GROUP BY id_no;
   
CREATE OR REPLACE FORCE VIEW "S004"."APE_RESULTS_V" AS 
SELECT 
    dtl_seq_no
   ,tran_no
   ,result_type
   ,exam_group
   ,exam_code
   ,result
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('S004_T08019','result_desc','result_type',result_type) as result_desc
   ,zsi_lib.GetDescription('S004_T08019_GROUP','group_desc','seq_no',exam_group) as group_desc
   ,zsi_lib.GetDescription('s004_t08019_exam','exam_desc','seq_no',exam_code) as exam_desc     
   ,zsi_lib.GetDescription('s004_t08019_exam','normal_range','seq_no',exam_code) as normal_range     
   ,zsi_lib.GetDescription('s004_t08019_exam','ape_priority','seq_no',exam_code) as ape_priority     
FROM S004_T08020_RESULT;

CREATE OR REPLACE FORCE VIEW Availed_Vaccination_v AS 
SELECT
    tran_no
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,medservice_code
   ,vaccine_code
   ,brand
   ,route
   ,site_given
   ,vaccine_lotno
   ,manufacturer
   ,in_house
   ,next_vaccine
   ,amnt_billed
   ,amnt_covered
   ,amnt_not_covered
   ,or_date
   ,or_number
   ,issued_by
   ,for_refund
   ,doctor_code
   ,reference_code
   ,remarks
   ,post_status
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type) as emp_type
   ,zsi_lib.GetDescription('S004_T08005','vaccine_name','vaccine_code',vaccine_code) as vacc_name
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center) as cc_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd',department) as dept_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd',group_code) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd',department) as dept_abbrv   
   ,zsi_lib.GetDescription('AGE_BRACKET_V','displayed_text','sele_value',age_brak_code) as age_bracket   
   ,zsi_lib.GetStatus(post_status) as status
FROM S004_T08021;

CREATE OR REPLACE FORCE VIEW medplan_coverage_v  AS 
  SELECT 
    seq_no
   ,id_no
   ,plan_coverage
   ,plan_curr_bal
   ,plan_avail_bal
   ,plan_curr_bal - (NVL(zsi_lib.GetSum('amount','S004_T08023',' id_no=' || id_no || ' AND post_status=0'),0) + NVL(zsi_lib.GetSum('amnt_billed','S004_T08020_BILLING_V',' id_no=' || id_no || ' AND post_status=0'),0) + NVL(zsi_lib.GetSum('amnt_billed','Availed_Vaccination_v',' id_no=' || id_no || ' AND post_status=0'),0)) as avail_bal   
   ,NVL(zsi_lib.GetSum('amount','S004_T08023',' id_no=' || id_no || ' AND post_status=0'),0) + NVL(zsi_lib.GetSum('amnt_billed','S004_T08020_BILLING_V',' id_no=' || id_no || ' AND post_status=0'),0) + NVL(zsi_lib.GetSum('amnt_billed','Availed_Vaccination_v',' id_no=' || id_no || ' AND post_status=0'),0) as unposted_amt
   ,avail_ape
   ,avail_ade
   ,avail_eyeglass
   ,allergies
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.FormatAmount(plan_coverage,2) pc  
   ,zsi_lib.FormatAmount(plan_curr_bal,2) pcb
   ,zsi_lib.FormatAmount(plan_avail_bal,2) pab
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_active_v','empl_type','empl_id_no',id_no) as emp_type
   ,zsi_lib.GetDescription('employee_active_v','cc_desc','empl_id_no', id_no) as cc_desc
   ,zsi_lib.GetDescription('employee_active_v','dept_desc','empl_id_no',id_no) as dept_desc
   ,zsi_lib.GetDescription('employee_active_v','group_desc','empl_id_no',id_no) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('employee_active_v','dept_abbrv','empl_id_no', id_no) as dept_abbrv
FROM S004_T08001;


CREATE OR REPLACE FORCE VIEW ONCREDIT_V AS
   SELECT tran_no
          ,tran_type
          ,invoice_no
          ,invoice_date
          ,id_no
          ,amount
          ,establishment
          ,payment_tag
          ,post_status
          ,post_date
          ,created_by
          ,date_created
          ,modified_by
          ,date_modified
          ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as empl_name
          ,zsi_lib.GetStatus(post_status) as status
     FROM S004_T08023

CREATE OR REPLACE FORCE VIEW S004_T08010_v AS 
SELECT
   ldgr_no
   ,tran_no
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,age_brak_code
   ,empl_type
   ,cost_center
   ,department
   ,group_code
   ,medplan_type
   ,medplan_code
   ,complaint
   ,diagnosis
   ,treatment
   ,recom_test
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('medplan_code_v','displayed_text','sele_value',medplan_code) as medplan
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value',medplan_type) as medplantype
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_types_v','emp_type','sele_value', empl_type ) as emp_type
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dep_name
   ,zsi_lib.GetDescription('cost_center_v','ccnt_desc','ccnt_cd', cost_center ) as cc_desc
   ,zsi_lib.GetDescription('CCNT_GROUPS_V','ccnt_desc','ccnt_cd', department ) as dept_desc
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_desc','ccnt_cd', group_code ) as group_desc
   ,zsi_lib.GetDescription('employee_active_v','job_desc','empl_id_no', id_no) as job_desc
   ,zsi_lib.GetDescription('AGE_BRACKET_V','displayed_text','sele_value', age_brak_code ) as age_bracket     
   ,zsi_lib.GetDescription('CCNT_DEPT_V','ccnt_abbrv','ccnt_cd', department) as dept_abbrv
FROM S004_T08010;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_DOCTORS_V" AS 
SELECT 
    a.seq_no
   ,a.ldgr_no
   ,a.tran_date
   ,a.tran_year
   ,a.id_no
   ,a.dep_id
   ,a.doctor_code
   ,a.reference_code 
   ,a.remarks 
   ,a.created_by 
   ,a.date_created
   ,a.modified_by 
   ,a.date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',a.id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08006','doctor_name','doctor_code',a.doctor_code) as doctor_name
   ,zsi_lib.GetDescription('doctors_v','doctor_specialty','doctor_code',a.doctor_code) as doctor_specialty
   ,zsi_lib.GetDescription('s004_T08004','reference_desc','reference_code',a.reference_code ) as hcp     
   ,b.complaint
   ,b.diagnosis
   ,b.treatment
   ,b.medplan
   ,b.medplantype
   ,b.medplan_code
   ,b.medplan_type
   ,b.age_brak_code
   ,b.age_bracket
   ,b.department
   ,b.group_code   
FROM S004_T08010_DOCTOR a, S004_T08010_v b 
WHERE a.ldgr_no=b.ldgr_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_DENTAL_V" AS 
SELECT 
   a.seq_no
  ,a.ldgr_no
  ,a.tran_date
  ,a.tran_year
  ,a.id_no
  ,a.dep_id
  ,a.ds_code
  ,a.ds_rate
  ,a.ds_qty
  ,a.is_followup
  ,a.next_visit 
  ,a.remarks 
  ,a.date_created
  ,a.modified_by 
  ,a.date_modified
  ,a.ds_rate * a.ds_qty AS ds_amount
  ,zsi_lib.GetStatus(a.is_followup) as followup  
  ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',a.id_no) as emp_name
  ,zsi_lib.GetDescription('dental_services_v','ds_desc','ds_code',a.ds_code ) as ds_desc     
  ,zsi_lib.GetDescription('dental_services_v','ds_type','ds_code',a.ds_code ) as ds_type     
  ,zsi_lib.GetDescription('dental_services_v','typedesc','ds_code',a.ds_code ) as ds_typedesc     
  ,b.medplan
  ,b.medplantype
  ,b.medplan_code
  ,b.medplan_type
  ,b.age_brak_code
  ,b.age_bracket
  ,b.department
  ,b.group_code
FROM S004_T08010_DENTAL a, S004_T08010_v b 
WHERE a.ldgr_no=b.ldgr_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_BILLING_V" AS 
SELECT 
   a.seq_no
  ,a.ldgr_no
  ,a.tran_date
  ,a.tran_year
  ,a.id_no
  ,a.dep_id
  ,a.medservice_code
  ,a.amnt_billed        
  ,a.for_refund         
  ,a.remarks
  ,a.doctor_code
  ,a.reference_code
  ,a.payment_tag
  ,a.date_created
  ,a.modified_by 
  ,a.date_modified
  ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',a.id_no) as emp_name
  ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', a.medservice_code ) as medservice     
  ,zsi_lib.GetDescription('S004_T08006','doctor_name','doctor_code',a.doctor_code) as doctor_name
  ,zsi_lib.GetDescription('s004_T08004','reference_desc','reference_code',a.reference_code ) as hcp     
  ,zsi_lib.GetStatus(a.for_refund) as forrefund  
  ,zsi_lib.GetDescription('payment_tag_v','displayed_text','sele_value',a.payment_tag ) as pay_tag 
  ,b.medplan
  ,b.medplantype
  ,b.medplan_code
  ,b.medplan_type
  ,b.age_brak_code
  ,b.age_bracket
  ,b.department
  ,b.group_code
FROM S004_T08010_BILLING a, S004_T08010_v b 
WHERE a.ldgr_no=b.ldgr_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_BILL_DRUG_V" AS 
SELECT a.* FROM S004_T08010_BILLING a, S004_T08010_RESULT b
 WHERE a.ldgr_no = b.ldgr_no
   AND b.medservice_code = 10;

CREATE OR REPLACE FORCE  VIEW "S004"."S004_T08010_ILLNESS_V" AS 
SELECT 
    a.seq_no
   ,a.ldgr_no
   ,a.tran_date
   ,a.tran_year
   ,a.id_no
   ,a.dep_id
   ,a.illness_code
   ,a.is_followup
   ,a.next_visit 
   ,a.remarks
   ,a.date_created
   ,a.modified_by 
   ,a.date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',a.id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08002','illness_name','illness_code',a.illness_code ) as illness_name     
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', a.ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', a.ldgr_no ) as medplantype     
   ,zsi_lib.GetStatus(a.is_followup) as followup 
   ,b.medplan_code
   ,b.age_brak_code
   ,b.age_bracket
   ,b.department
   ,b.group_code
FROM S004_T08010_ILLNESS a, S004_T08010_v b 
WHERE a.ldgr_no=b.ldgr_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_MEDS_V" AS 
SELECT 
    seq_no
   ,ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,dep_id
   ,meds_code
   ,meds_qty
   ,dosage
   ,remarks
   ,illness_seqno
   ,date_created
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('meds_code_v','meds_name','meds_code',meds_code ) as meds_name     
   ,zsi_lib.GetDescription('meds_code_v','medstype','meds_code',meds_code ) as meds_type    
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', ldgr_no ) as medplantype     
FROM S004_T08010_MEDS;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_ILL_MEDS_V" AS 
SELECT 
   a.seq_no
   ,a.ldgr_no
   ,a.tran_date
   ,a.tran_year
   ,a.id_no
   ,a.dep_id
   ,a.illness_code
   ,a.is_followup
   ,a.next_visit 
   ,a.remarks
   ,a.date_created
   ,a.modified_by 
   ,a.date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',a.id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08002','illness_name','illness_code',a.illness_code ) as illness_name     
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', a.ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', a.ldgr_no ) as medplantype     
   ,zsi_lib.GetStatus(a.is_followup) as followup    
   ,b.meds_code
   ,b.meds_qty
   ,b.meds_dosage
   ,zsi_lib.GetDescription('meds_code_v','meds_name','meds_code',b.meds_code ) as meds_name     
   ,zsi_lib.GetDescription('meds_code_v','medstype','meds_code',meds_code ) as meds_type    
   ,zsi_lib.GetDescription('MEDS_V','medicine','meds_code',a.meds_code) as medicine
 FROM s004_t08010_illness a,s004_t08010_meds b
WHERE b.illness_seqno = a.seq_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_SERVICES_V" AS 
SELECT 
    seq_no
   ,ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,dep_id
   ,medservice_code
   ,systolic
   ,diastolic
   ,performed_by
   ,remarks
   ,modified_by 
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',performed_by ) as performedby_name     
   ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', medservice_code ) as medservice     
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', ldgr_no ) as medplantype    
FROM S004_T08010_SERVICES;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_RESULTS_V" AS 
SELECT 
    d.seq_no
   ,d.ldgr_no
   ,d.tran_date
   ,d.tran_year
   ,d.id_no
   ,d.dep_id
   ,d.medservice_code
   ,d.exam_code
   ,d.result
   ,d.remarks
   ,d.is_followup
   ,d.follow_up_lab
   ,d.modified_by 
   ,d.date_modified
   ,h.medplan_code
   ,h.medplan
   ,h.medplantype
   ,h.medplan_type
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',d.id_no) as emp_name
   ,zsi_lib.GetDescription('s004_t08019_exam','result_type','seq_no',d.exam_code ) as result_type  
   ,zsi_lib.GetDescription('exam_result_v','result_desc','seq_no',d.exam_code ) as result_desc  
   ,zsi_lib.GetDescription('exam_result_v','exam_group','seq_no',d.exam_code ) as exam_group  
   ,zsi_lib.GetDescription('exam_result_v','group_desc','seq_no',d.exam_code) as group_desc     
   ,zsi_lib.GetDescription('s004_t08019_exam','exam_desc','seq_no',d.exam_code) as exam_desc     
   ,zsi_lib.GetDescription('s004_t08019_exam','normal_range','seq_no',d.exam_code) as normal_range     
   ,zsi_lib.GetDescription('medservice_code_v','displayed_text','sele_value', d.medservice_code ) as medservice    
   ,zsi_lib.GetStatus(is_followup) as followup     
FROM S004_T08010_RESULT d, S004_T08010_v h
WHERE d.ldgr_no = h.ldgr_no;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_VACCINES_V" AS 
SELECT 
   ldgr_no
   ,seq_no
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,vaccine_code
   ,brand
   ,route
   ,site_given
   ,vaccine_lotno
   ,manufacturer
   ,remarks
   ,in_house
   ,next_vaccine
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08005','vaccine_name','vaccine_code',vaccine_code) as vacc_name
   ,zsi_lib.GetDescription('vaccines_v','vaccine_freq','vaccine_code', vaccine_code ) as frequency     
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', ldgr_no ) as medplantype     
   ,zsi_lib.GetStatus(in_house) as inhouse    
FROM S004_T08010_VACCINE;


CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_PHILHEALTH_V" AS 
SELECT 
   ldgr_no
   ,id_no
   ,dependent_id
   ,jv_trandate
   ,jv_number
   ,amount
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', ldgr_no ) as medplantype     
FROM S004_T08010_PHILHEALTH;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_RMTPATHO_V" AS 
SELECT 
   ldgr_no
   ,seq_no
   ,tran_year
   ,tran_date
   ,id_no
   ,dep_id
   ,remarks
   ,post_date
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
   ,zsi_lib.GetDescription('S004_T08010_v','medplan','ldgr_no', ldgr_no ) as medplan     
   ,zsi_lib.GetDescription('S004_T08010_v','medplantype','ldgr_no', ldgr_no ) as medplantype     
FROM S004_T08010_RMTPATHO;



CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_BILLING_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
   ,zsi_lib.GetSum('amnt_billed','S004_T08010_BILLING',' ldgr_no=' || ldgr_no || ' AND for_refund=0') as no_refund_amt
   ,zsi_lib.GetSum('amnt_billed','S004_T08010_BILLING',' ldgr_no=' || ldgr_no || ' AND for_refund=1') as refund_amt
   ,zsi_lib.GetSum('amnt_billed','S004_T08010_BILLING',' ldgr_no=' || ldgr_no ) as ttl_billed_amt
FROM S004_T08010
WHERE zsi_lib.GetSum('amnt_billed','S004_T08010_BILLING',' ldgr_no=' || ldgr_no ) IS NOT NULL;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_ILLNESSES_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
   ,zsi_lib.GetCount('ldgr_no','S004_T08010_ILLNESS',' ldgr_no=' || ldgr_no) as illnesses
   ,zsi_lib.GetCount('ldgr_no','S004_T08010_MEDS',' ldgr_no=' || ldgr_no) as meds
FROM S004_T08010 a
WHERE EXISTS (SELECT b.ldgr_no FROM S004_T08010_ILLNESS b WHERE b.ldgr_no = a.ldgr_no);

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_RESULT_GRP_V" AS 
SELECT DISTINCT 
          ldgr_no
         ,result_type 
    FROM S004_T08010_RESULT;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_LAB_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
   ,zsi_lib.GetCount('ldgr_no','S004_T08010_RESULTS_V',' ldgr_no=' || ldgr_no) as lab
FROM S004_T08010 a
WHERE medplan_code<>4 AND EXISTS (SELECT b.ldgr_no FROM S004_T08010_RESULTS_V b WHERE b.ldgr_no = a.ldgr_no AND medservice_code=3); 

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_APE_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
FROM S004_T08010 
WHERE AND medplan_code=4; 

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_DENTAL_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
   ,zsi_lib.GetCount('ldgr_no','S004_T08010_DENTAL',' ldgr_no=' || ldgr_no) as no_ds
FROM S004_T08010 
WHERE EXISTS (SELECT b.ldgr_no FROM S004_T08010_DENTAL b WHERE b.ldgr_no = a.ldgr_no); 

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_SERVICES_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,complaint
   ,diagnosis
   ,treatment
   ,zsi_lib.GetCount('ldgr_no','S004_T08010_SERVICES',' ldgr_no=' || ldgr_no) as no_ihs
FROM S004_T08010 a
WHERE EXISTS (SELECT b.ldgr_no FROM S004_T08010_SERVICES b WHERE b.ldgr_no = a.ldgr_no); 

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_PH_SUM_V" AS 
SELECT 
   ldgr_no
   ,tran_date
   ,tran_year
   ,id_no
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',dep_id) as dependent_name
   ,zsi_lib.GetDescription('S004_T08010_BILLING','amnt_billed','ldgr_no',ldgr_no) as amnt_billed
FROM S004_T08010
WHERE medplan_code=9;

CREATE OR REPLACE FORCE VIEW "S004"."S004_T08010_HOSP_V" AS 
SELECT 
    a.ldgr_no
   ,a.tran_date
   ,a.tran_year
   ,a.complaint
   ,a.diagnosis
   ,a.treatment
   ,a.id_no
   ,b.dept_abbrv
   ,b.empl_name
   ,zsi_lib.GetDescription('S004_T01029','emde_dependent_name','emde_dependent_id',a.dep_id) as dependent_name
   ,zsi_lib.GetDescription('medplan_types_v','displayed_text','sele_value',medplan_type) as medplantype
FROM S004_T08010 a, employee_v b
WHERE a.id_no = b.empl_id_no
  AND medplan_code=3;
