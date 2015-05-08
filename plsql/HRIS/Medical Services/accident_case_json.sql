SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE accident_case_json (
                              p_tran_no                IN NUMBER default NULL,
                              p_rt                    IN VARCHAR2 default NULL) IS
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
   29-07-14   GF    New
*/
--DECLARATION SECTION

l_json                       VARCHAR2(8000);
l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
l_rec                        ACCIDENT_CASES_V%ROWTYPE;

BEGIN
   check_login;
   owa_util.mime_header('application/json');
   SELECT * INTO l_rec from ACCIDENT_CASES_V WHERE tran_no = p_tran_no;

   htp.p('{');
    
      l_json:= '' 
                   || '"tran_no":"'             || l_rec.tran_no                                || '",'
                   || '"direct_superior":"'     || l_rec.direct_superior                        || '",'
                   || '"tran_date":"'           || TO_CHAR(l_rec.tran_date,l_date_format)       || '",'
                   || '"accident_date":"'       || TO_CHAR(l_rec.accident_date,l_date_format)   || '",'
                   || '"accident_time":"'       || l_rec.accident_time                          || '",'
                   || '"accident_location":"'   || l_rec.accident_location                      || '",'
                   || '"manhour_lost":"'        || l_rec.manhour_lost                           || '",'
                   || '"sick_leave":"'          || l_rec.sick_leave                             || '",'
                   || '"current_activity":"'    || l_rec.current_activity                       || '",'
                   || '"accident_description":"'|| l_rec.accident_description                   || '",'
                   || '"accident_cause_cond":"' || l_rec.accident_cause_cond                    || '",'
                   || '"accident_cause_acts":"' || l_rec.accident_cause_acts                    || '",'
                   || '"remarks":"'             || l_rec.remarks                                || '",'
                   || '"post_status":"'         || l_rec.post_status                            || '"'
      || '}';
      
      htp.p(l_json);
END;
/
SHOW ERR;