SET SCAN OFF
CREATE OR REPLACE 
PROCEDURE check_login IS
   /*
   =======================================================================
   *
   * Copyright (c) 2014-2015 ZettaSolutions,Inc.  All rights reserved.
   *
   * Redistribution and use in source and binary forms, with or without
   * modification is strictly prohibited.
   *
   ========================================================================
   */

   /* Modification History
   Date       By    History
   ---------  ----  ------------------------------------------------------------------------
   05-FEB-15  GF    New
   */
   
   l_user           VARCHAR2(100);
   l_module_count   NUMBER := 0;

BEGIN
   l_user := zsi_sessions_lib.GetCookieUser;
     IF l_user IS NULL THEN
           zsi_sessions_lib.RedirectURL('errorpage');
           RETURN;
     END IF;

END;
/
SHOW ERR;