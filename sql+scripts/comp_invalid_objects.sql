set pages 0;
set trimspool on;
set feedback off;
spool comp_invalid.sql
SELECT 'alter ' ||
       DECODE(object_type, 'PACKAGE BODY', 'PACKAGE', object_type ) ||
       ' ' || object_name ||
       DECODE(object_type, 'PACKAGE BODY', ' compile body;', ' compile;')
  FROM user_objects
 WHERE status      = 'INVALID'
 ORDER by object_type, object_name
/
spool off;
set pages 60;
set feedback on;

