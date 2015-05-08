CREATE OR REPLACE FORCE VIEW "S004"."CASES_V" AS 
SELECT 
    tran_no
   ,tran_year
   ,seq_no
   ,case_type
   ,case_no
   ,charges
   ,respondents
   ,pi_date
   ,remarks
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('case_types_v','displayed_text','sele_value',case_type) as case_type_desc
   ,zsi_lib.GetCount('','S004_T08800_RESPONDENTS','tran_no=' || tran_no) as resp_count
   ,zsi_lib.GetCount('','S004_T08800_HANDLEDBY','tran_no=' || tran_no) as hand_count
   ,zsi_lib.GetCount('','S004_T08800_STATUS','tran_no=' || tran_no) as stat_count   
FROM S004_T08800;

CREATE OR REPLACE FORCE VIEW "S004"."RESPONDENTS_V" AS 
SELECT 
    tran_no
   ,seq_no
   ,id_no
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',id_no) as empl_name
FROM S004_T08800_RESPONDENTS;

CREATE OR REPLACE FORCE VIEW "S004"."HANDLEDBY_V" AS 
SELECT 
    tran_no
   ,seq_no
   ,status_seq_no
   ,handled_by
   ,created_by
   ,date_created
   ,modified_by
   ,date_modified
   ,zsi_lib.GetDescription('employee_v','empl_name','empl_id_no',handled_by) as empl_name
FROM S004_T08800_HANDLEDBY;

