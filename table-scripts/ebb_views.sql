CREATE OR REPLACE FORCE VIEW "S004"."EBB_GROUPS_V" AS 
  SELECT 
    group_id
   ,group_name
   ,group_desc
   ,group_level
   ,zsi_lib.GetCount('*','ebb_workstation_groups',' group_id=' ||  group_id ) as group_ws_count   
  FROM EBB_GROUPS
/


CREATE OR REPLACE FORCE VIEW "S004"."EBB_WORKSTATIONS_V" AS 
  SELECT 
    ws_id
   ,ws_name
   ,zsi_lib.GetCount('*','ebb_workstation_groups',' ws_id=' ||  ws_id ) as ws_group_count   
  FROM EBB_WORKSTATIONS
/


CREATE OR REPLACE FORCE VIEW "S004"."EBB_WORKSTATION_GROUPS_V" AS 
  SELECT 
    ws_group_id
   ,ws_id
   ,group_id
   ,zsi_lib.GetDescription('EBB_GROUPS','GROUP_NAME','group_id',group_id) AS group_name   
  FROM ebb_workstation_groups
/

CREATE OR REPLACE FORCE VIEW "S004"."EBB_JOBS_V" AS 
  SELECT 
    job_id
   ,job_date
   ,job_desc
   ,filename
   ,job_seq
   ,zsi_lib.GetCount('*','ebb_job_groups',' job_id=' ||  job_id ) as job_groups_count   
   ,zsi_lib.GetCount('','ebb_job_ws',' ws_response IS NULL AND job_id=' ||  job_id ) as job_error_count   
  FROM ebb_jobs

CREATE OR REPLACE FORCE VIEW "S004"."EBB_JOB_GROUPS_V" AS 
  SELECT 
    job_group_id
   ,job_id
   ,group_id
   ,zsi_lib.GetDescription('EBB_GROUPS','GROUP_NAME','group_id',group_id) AS group_name   
   ,zsi_lib.GetDescription('ebb_jobs','job_date','job_id',job_id) as job_date
   ,zsi_lib.GetDescription('ebb_jobs','filename','job_id',job_id) as filename
  FROM ebb_job_groups

/

CREATE OR REPLACE FORCE VIEW "S004"."EBB_JOB_WS_V" AS 
 SELECT DISTINCT
    job_id
   ,ws_id
   ,ws_response
   ,ws_url
   ,zsi_lib.GetDescription('ebb_workstations','ws_name','ws_id',ws_id) as ws_name
  FROM ebb_job_ws
/

CREATE OR REPLACE FORCE VIEW "S004"."EBB_CURR_JOBS_V" AS 
 SELECT DISTINCT
   a.job_id
  ,zsi_lib.GetDescription('ebb_jobs','action','job_id',a.job_id) as action
  ,zsi_lib.GetDescription('ebb_jobs','job_date','job_id',a.job_id) as job_date
  ,zsi_lib.GetDescription('ebb_jobs','filename','job_id',a.job_id) as filename
  ,b.ws_id
 FROM ebb_job_groups a, ebb_workstation_groups_v b
 WHERE zsi_lib.GetDescription('ebb_jobs','job_date','job_id',a.job_id) = TRUNC(SYSDATE)
   AND a.group_id = b.group_id;
/
 CREATE OR REPLACE FORCE VIEW "S004"."EBB_MODULES_V" AS 
   SELECT module_id
         ,module_name
         ,module_url
         ,module_group_id
         ,seq_no
         ,zsi_lib.GetDescription('s004_modules','module_name','module_id', module_group_id ) as module_group
  FROM EBB_MODULES;
  