SET PAGES       0
SET FEEDBACK  OFF
SET VERIFY    OFF
SET ECHO      OFF
SET LINESIZE  900
SET TRIMSPOOL  ON
SET TERMOUT   OFF

--SELECT 'SET SQLPROMPT ' || LOWER(USER) || '@' || UPPER(ORA_DATABASE_NAME) || '> ' FROM dual;
--SELECT 'SET SQLPROMPT ' || LOWER(USER) || '@' || SYS_CONTEXT('USERENV','INSTANCE_NAME') || '> ' FROM dual;
SPOOL mysqlprompt.sql
SELECT 'SET SQLPROMPT ' ||
       DECODE(UPPER(USER || '-' || SYS_CONTEXT('USERENV','INSTANCE_NAME')),
             'EPITDEV-ENTERPRJ1','EPITDEV',
             'EPIT-ENTERPRJ1','EPIT',
             'VCDEV-ENTERPRJ1','VCDEV',
             'EPDEV-ENTERPRJ1','EPDEV',
             'TNDEV-ENTERPRJ1','TNDEV',
             'MRDEV-ENTERPRJ1','MRDEV',
             'CSDEV-ENTERPRJ1','CSDEV',
             'SPMDEMO-REVQL06','SPMDEMO',
             'TEDRIVE-REVQL06','TEDRIVE',
             'EPIT-REVQL06','EPIT',
             'ENTERPROJ-ENTERPRJ','EP_KP',
             'ENTERPROJ-ENTERPRJ2','EP_JAC',
             'ENTERPROJ-ENTERPRJ3','EP_CS',
             'ENTERPROJ-ENTERPRJ4','EP_SI',
             'SAS-GFX','SASGFX',
             'SASTEST-GFX','SASTESTGFX',
             'SAS-ORCL','SASLOCAL',
             'S004-ORCL','SOO4L',
             'S004-MRPT','S004MCWD',
             'SQL') ||
       '¯ÿ'
       FROM DUAL;
SPOOL OFF;

SET PAGES     60
SET VERIFY    ON
SET FEEDBACK  ON
SET TRIMSPOOL OFF
SET TERMOUT   ON
SET LINESIZE 100

PROMPT
START mysqlprompt.sql
--PROMPT &_O_VERSION
CL BUFF
