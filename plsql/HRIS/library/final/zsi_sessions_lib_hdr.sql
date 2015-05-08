SET SCAN OFF
CREATE OR REPLACE
PACKAGE zsi_SESSIONS_LIB IS

   /*
   =======================================================================
   *
   * Copyright (c) 20014-2014 by ZSI.  All rights reserved.
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

   FUNCTION IsValidUser (p_user_name IN VARCHAR2) RETURN VARCHAR2;

   PROCEDURE SetCookieUser (p_user_name  IN  VARCHAR2);

   FUNCTION GetCookieUser RETURN VARCHAR2;

   PROCEDURE RedirectURL(p_url IN VARCHAR2);

END zsi_SESSIONS_LIB;
/
SHOW ERRORS
