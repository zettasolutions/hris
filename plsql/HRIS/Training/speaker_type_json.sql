SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE speaker_type_json (
   p_spk_code        IN VARCHAR2 default NULL,
   p_rt              IN VARCHAR2 default NULL   
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
   25-OCT-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);


TYPE l_cur IS REF CURSOR;
l_ref          l_cur;

l_spk_type_desc   SPEAKERS_V.spk_type_desc%TYPE;
 
 
BEGIN
   --check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT spk_type_desc';
   l_from   := '  FROM SPEAKERS_V ';
   l_where  := ' WHERE 1=1';

   IF p_spk_code IS NOT NULL THEN
      l_where := l_where || ' AND spk_code= ' || '''' ||  p_spk_code || '''';
   END IF;

   l_sql := l_select   || l_from || l_where; 

   OPEN l_ref FOR l_sql;
   FETCH l_ref INTO l_spk_type_desc;
   CLOSE l_ref;                                          

   htp.p('{"spk_type_desc":"'|| l_spk_type_desc || '"}');

END;
/
SHOW ERR;