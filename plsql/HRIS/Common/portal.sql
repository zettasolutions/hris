SET SCAN OFF
CREATE OR REPLACE
PROCEDURE portal (p_user_name  IN  VARCHAR2,
                  p_sys_id     IN  VARCHAR2 default NULL) IS
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
   ---------  ----  -------------------------------------------------------
   01-JUL-14  BD    New
   */

   l_user         VARCHAR2(100);
BEGIN
     
   SELECT USER_NAME
     INTO l_user
     FROM S004_T05001
    WHERE UPPER(USER_NAME) = UPPER(p_user_name);
--    WHERE ORA_HASH(UPPER(USER_NAME)) = ZSI_LIB.DecodeStr(p_user_name);

   IF zsi_sessions_lib.IsValidUser(l_user) = 'Y' THEN
      zsi_sessions_lib.SetCookieUser(l_user);
      zsi_sessions_lib.RedirectURL('pageindex?p_sys_id=' || p_sys_id);
   ELSE
      zsi_sessions_lib.RedirectURL('errorpage');
   END IF;

EXCEPTION

   WHEN OTHERS THEN
      zsi_sessions_lib.RedirectURL('errorpage');

END;
/
SHOW ERRORS
