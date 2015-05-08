SET SCAN OFF
create or replace 
PACKAGE zsi_dhtmlx_lib IS

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
   25-JUL-14  GT    New
   */
   
   FUNCTION RowsPerPage (p_value      IN  VARCHAR2 DEFAULT NULL,
                         p_attributes IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

   FUNCTION ShowPageHeading   RETURN VARCHAR2;

END;
/
SHOW ERRORS