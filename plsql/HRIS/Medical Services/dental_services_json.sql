SET SCAN OFF
CREATE OR REPLACE PROCEDURE dental_services_json (p_ds_code        IN NUMBER default NULL) IS
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
   05-AUG-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);


TYPE l_cur IS REF CURSOR;
l_ref          l_cur;

l_ds_type   VARCHAR2(20);
l_ds_rate   s004_T08009.ds_rate%TYPE;


BEGIN
   owa_util.mime_header('application/json');

   l_select := 'SELECT DECODE(ds_type,0,' || '''FREE''' || ',' ||  '''CHARGE''' || ') as dstype, ds_rate';
   l_from   := '  FROM s004_T08009 ';
   l_where  := ' WHERE 1=1';

   IF p_ds_code IS NOT NULL THEN
      l_where := l_where || ' AND ds_code= ' || p_ds_code;
   END IF;

   l_sql := l_select   || l_from || l_where;

   OPEN l_ref FOR l_sql;
   FETCH l_ref INTO l_ds_type, l_ds_rate;
   CLOSE l_ref;

   htp.p('{"dstype":"'|| l_ds_type || '","ds_rate":"'|| l_ds_rate || '"}');
END; 
/
SHOW ERR;

