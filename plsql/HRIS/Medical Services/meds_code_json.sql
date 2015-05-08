SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE meds_code_json (
   p_meds_code        IN NUMBER default NULL,
   p_rt               IN VARCHAR2 default NULL
) IS
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
   06-AUG-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);


TYPE l_cur IS REF CURSOR;
l_ref          l_cur;

l_meds_type   meds_code_v.medstype%TYPE;
 
 
BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT medstype';
   l_from   := '  FROM meds_code_v ';
   l_where  := ' WHERE 1=1';

   IF p_meds_code IS NOT NULL THEN
      l_where := l_where || ' AND meds_code= ' || p_meds_code;
   END IF;

   l_sql := l_select   || l_from || l_where; 

   OPEN l_ref FOR l_sql;
   FETCH l_ref INTO l_meds_type;
   CLOSE l_ref;                                          

   htp.p('{"meds_type":"'|| l_meds_type || '"}');

END;
/
SHOW ERR;