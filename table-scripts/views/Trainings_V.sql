 SET SCAN OFF
 
  CREATE OR REPLACE VIEW Budget_Types_v AS
   SELECT *
   FROM S004_T08000
WHERE UPPER(sele_code) = 'BUDGET_TYPE'; '

 CREATE OR REPLACE VIEW Travel_Types_v AS
  SELECT *
  FROM S004_T08000
WHERE UPPER(sele_code) = 'TRAVEL_TYPE'; 

 CREATE OR REPLACE VIEW TRF_Status800_v AS
  SELECT trf_tranno
         ,trf_tranno as trf_tran_no
  FROM S004_T07005
WHERE trf_status = 800; 

 CREATE OR REPLACE FORCE VIEW Speakers_V AS 
   SELECT
    spk_code
   ,spk_name
   ,spk_citations
   ,spk_address
   ,spk_contactno
   ,spk_type
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,DECODE(spk_type,'I','In-House','O','Outsource') spk_type_desc
   FROM S004_T07011;
/

 CREATE OR REPLACE FORCE VIEW Assessments_V AS 
   SELECT
      seq_no
      ,assessment_type
      ,assessment_code
      ,assessment_desc
      ,assessment_desc2
      ,max_assessment
      ,min_assessment
      ,ave_assessment
      ,remarks
      ,created_by
      ,date_created
      ,modified_by
      ,date_modified
   FROM S004.S004_T07017;

 CREATE OR REPLACE FORCE VIEW TrainingBudget_V AS 
   SELECT
       tran_no         
      ,tran_year       
      ,id_no        
      ,budget_type     
      ,conv_code    
      ,budget_amt   
      ,remarks      
      ,created_by   
      ,date_created 
      ,modified_by  
      ,date_modified
      ,zsi_lib.GetDescription('Budget_Types_v','displayed_text','sele_value', budget_type ) as budget_type_desc
      ,zsi_lib.GetDescription('employee_active_v','empl_name','empl_id_no',id_no) as emp_name
      ,zsi_lib.GetDescription('employee_types_v','displayed_text','sele_value',empl_type) as emp_type
      ,zsi_lib.GetDescription('employee_active_v','cc_desc','empl_id_no',id_no) as cc_desc
      ,zsi_lib.GetDescription('employee_active_v','dept_desc','empl_id_no',id_no) as dept_desc
      ,zsi_lib.GetDescription('S004_T07010','conv_desc','conv_code', conv_code) as conv_desc
      ,zsi_lib.GetDescription('S004_T01000','empl_group_code','empl_id_no',id_no) as cc_code
   FROM S004_T07013;
/

 CREATE OR REPLACE FORCE VIEW TrainingSchedAttend_V AS 
   SELECT
       tran_no
      ,trf_tranno
      ,trn_code
      ,venu_code
      ,spsr_code
      ,start_date
      ,end_date
      ,trn_days
      ,trn_hours
      ,trn_status
      ,trn_cost
      ,trn_type
      ,conv_code
      ,reg_fee
      ,travel_type
      ,remarks
      ,created_by   
      ,date_created 
      ,modified_by  
      ,date_modified
      ,zsi_lib.GetDescription('S004_T07000','trn_desc','trn_code', trn_code ) as trn_desc
      ,zsi_lib.GetDescription('S004_T07007','type_name','trn_type', trn_type ) as trn_type_name
      ,zsi_lib.GetDescription('S004_T07008','spsr_name','spsr_code', spsr_code ) as spsr_name
      ,zsi_lib.GetDescription('S004_T07009','venu_name','venu_code', venu_code ) as venu_name
      ,zsi_lib.GetDescription('S004_T07010','conv_desc','conv_code', conv_code) as conv_desc
      ,zsi_lib.GetDescription('Travel_Types_v','displayed_text','sele_value', travel_type ) as travel_desc
   FROM S004_T07003;
/


 CREATE OR REPLACE FORCE VIEW TrainingSpeakers_V AS 
   SELECT
    tran_no
   ,seq_no
   ,spk_code
   ,topic
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified   
   ,zsi_lib.GetDescription('S004_T07011','spk_name','spk_code', spk_code ) as spk_name
   ,zsi_lib.GetDescription('Speakers_V','spk_type_desc','spk_code', spk_code ) as spk_type_desc
   FROM S004_T07003_SPEAKER; 
/

 CREATE OR REPLACE FORCE VIEW TrainingTrainees_V AS 
   SELECT
   b.tran_no
   ,b.seq_no
   ,b.empl_id_no
   ,b.attendee_type
   ,b.reg_fee
   ,b.reg_fee_charge_to
   ,b.travel_cost
   ,b.travel_cost_charge_to
   ,b.actual_cost
   ,b.with_certificate
   ,b.created_by
   ,b.date_created
   ,b.modified_by
   ,b.date_modified 
   ,a.trn_code
   ,a.trn_hours
   ,a.conv_desc
   ,a.trn_desc
   ,a.start_date
   ,a.end_date
   ,a.venu_name
   ,a.trn_type_name
   ,a.spsr_name
   ,EXTRACT(YEAR FROM a.start_date) as trn_year
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no', b.empl_id_no ) as empl_name
   ,zsi_lib.GetDescription('employee_v','department','empl_id_no',b.empl_id_no) as dept_code 
   ,zsi_lib.GetDescription('employee_v','dept_desc','empl_id_no', b.empl_id_no ) as dept_desc
   ,zsi_lib.GetDescription('employee_v','dept_abbrv','empl_id_no', b.empl_id_no ) as dept_abbrv
   ,zsi_lib.GetStatus(with_certificate) as with_cert
   FROM S004_T07003_TRAINEES b, TrainingSchedAttend_V a
   WHERE b.tran_no = a.tran_no;      
/

 CREATE OR REPLACE FORCE VIEW TrainingCosting_V AS 
   SELECT
   tran_no
   ,seq_no
   ,item_code
   ,item_amount
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified   
   FROM S004_T07003_COSTING;
/

 CREATE OR REPLACE FORCE VIEW TrainingAssessments_V AS 
   SELECT
   tran_no
   ,seq_no
   ,spk_code
   ,topic
   ,id_no
   ,assessment_type
   ,assessment_code
   ,trainee_assess_seq_no
   ,speaker_assess_seq_no
   ,rating
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,DECODE(id_no, NULL, 'Anonymous', zsi_lib.GetDescription('employee_v','empl_name','empl_id_no', id_no )) as empl_name
   ,zsi_lib.GetDescription('Assessments_v','assessment_code','seq_no', assessment_code ) as assessment_seq_no
   ,zsi_lib.GetDescription('Assessments_v','assessment_desc','seq_no', assessment_code ) as assessment_desc
   ,zsi_lib.GetDescription('Assessments_v','assessment_desc2','seq_no', assessment_code ) as assessment_desc2  
   ,zsi_lib.GetDescription('Assessments_v','max_assessment','seq_no', assessment_code ) as max_assessment
   ,zsi_lib.GetDescription('Assessments_v','min_assessment','seq_no', assessment_code ) as min_assessment  
   ,zsi_lib.GetDescription('Assessments_v','ave_assessment','seq_no', assessment_code ) as ave_assessment  
   ,zsi_lib.GetDescription('S004_T07011','spk_name','spk_code', spk_code ) as spk_name
   FROM S004_T07003_ASSESSMENT;
/

 CREATE OR REPLACE FORCE VIEW mrtc_participants_V AS 
   SELECT
    tran_no
   ,trainee
   ,job_position
   ,address
   ,contact_no
   ,agency_code
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('S004_T07015','agency_desc','agency_code', agency_code ) as agency_desc
   FROM S004_T07016; 

 CREATE OR REPLACE FORCE VIEW train_budsumm_grp_v AS 
   SELECT  
    trn_year
    ,dept_code
    ,dept_desc
    ,empl_id_no
    ,empl_name
    ,conv_desc       
   ,sum(actual_cost) as ttl_actual_cost
   ,sum(trn_hours) as ttl_trn_hours
   FROM TrainingTrainees_V 
   GROUP BY empl_id_no, conv_desc, trn_year, dept_code, dept_desc;
   
   
 CREATE OR REPLACE FORCE VIEW train_member_org_v AS 
   SELECT b.*
          ,c.empl_name
          ,c.job_desc
          ,c.dept_abbrv
          ,zsi_lib.GetDescription('S004_T07010','conv_desc','conv_code', b.conv_code) as conv_desc
   from S004_T07013 b, employee_active_v c 
   WHERE b.conv_code IS NOT NULL 
   AND b.id_no = c.empl_id_no
   AND EXISTS (SELECT EMPL_ID_NO FROM employee_active_v a where a.empl_id_no = b.id_no);    
   
 CREATE OR REPLACE FORCE VIEW empl_wo_training_v AS 
 SELECT a.* 
   FROM employee_active_v a
  WHERE NOT EXISTS (SELECT b.empl_id_no FROM S004_T07003_TRAINEES b WHERE b.empl_id_no = a.empl_id_no);
   
   
/
show err;
