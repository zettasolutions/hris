SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE exam_result_json (
   p_exam_code        IN NUMBER default NULL,
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
   09-AUG-14  GT    New
*/
--DECLARATION SECTION
l_select                     VARCHAR2(3000);
l_from                       VARCHAR2(1000);
l_where                      VARCHAR2(4000);
l_sql                        VARCHAR2(8000);


TYPE l_cur IS REF CURSOR;
l_ref          l_cur;

l_result_type    exam_result_v.result_type%TYPE;
l_exam_group     exam_result_v.exam_group%TYPE;
l_result_desc    exam_result_v.result_desc%TYPE;
l_group_desc     exam_result_v.group_desc%TYPE;
l_normal_range   exam_result_v.normal_range%TYPE;

 
BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT result_desc, group_desc, normal_range, result_type, exam_group ';
   l_from   := '  FROM exam_result_v ';
   l_where  := ' WHERE 1=1';

   IF p_exam_code IS NOT NULL THEN
      l_where := l_where || ' AND seq_no= ' || p_exam_code;
   END IF;

   l_sql := l_select   || l_from || l_where; 

   OPEN l_ref FOR l_sql;
   FETCH l_ref INTO l_result_desc, l_group_desc, l_normal_range, l_result_type, l_exam_group;
   CLOSE l_ref;                                          

   htp.p('{"result_desc":"' || l_result_desc  || '", "group_desc":"'  || l_group_desc   || '","normal_range":"'|| l_normal_range || '","result_type":"' || l_result_type  || '","exam_group":"'  || l_exam_group   || '"   }');

END;
/
SHOW ERR;