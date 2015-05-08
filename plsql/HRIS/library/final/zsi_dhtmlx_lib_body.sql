SET SCAN OFF
create or replace 
PACKAGE BODY zsi_dhtmlx_lib IS

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
                         p_attributes IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
   IS
      l_str            VARCHAR2(2000);
      l_i15            VARCHAR2(20);
      l_i20            VARCHAR2(20);
      l_i25            VARCHAR2(20);
      l_i30            VARCHAR2(20);
      l_i40            VARCHAR2(20);
      l_i50            VARCHAR2(20);
      l_i100           VARCHAR2(20);
      l_i200           VARCHAR2(20);
      l_i300           VARCHAR2(20);
      l_i400           VARCHAR2(20);
      l_i500           VARCHAR2(20);
      l_def            VARCHAR2(20);

   BEGIN

      IF p_value='15' THEN
         l_i15 := 'selected';
      ELSIF p_value ='20' THEN
         l_i20 := 'selected';
      ELSIF p_value ='25' THEN
         l_i25 := 'selected';
      ELSIF p_value ='30' THEN
         l_i30 := 'selected';
      ELSIF p_value ='40' THEN
         l_i40 := 'selected';
      ELSIF p_value ='50' THEN
         l_i50 := 'selected';
      ELSIF p_value ='100' THEN
         l_i100 := 'selected';
      ELSIF p_value ='200' THEN
         l_i200 := 'selected';
      ELSIF p_value ='300' THEN
         l_i300 := 'selected';
      ELSIF p_value ='400' THEN
         l_i400 := 'selected';
      ELSIF p_value ='500' THEN
         l_i500 := 'selected';
      ELSE
         l_def := 'selected';
      END IF;

      l_str := '<select name="p_rowsperpage" id="p_rowsperpage" ' || p_attributes || '>';

      l_str := l_str || '<option ' || l_i15  || ' value="15">15</option>';
      l_str := l_str || '<option ' || l_i20  || ' value="20">20</option>';
      l_str := l_str || '<option ' || l_i25  || ' value="25">25</option>';
      l_str := l_str || '<option ' || l_i30  || ' value="30">30</option>';
      l_str := l_str || '<option ' || l_i40  || ' value="40">40</option>';
      l_str := l_str || '<option ' || l_i50  || ' value="50">50</option>';
      l_str := l_str || '<option ' || l_i100 || ' value="100">100</option>';
      l_str := l_str || '<option ' || l_i200 || ' value="200">200</option>';
      l_str := l_str || '<option ' || l_i300 || ' value="300">300</option>';
      l_str := l_str || '<option ' || l_i400 || ' value="400">400</option>';
      l_str := l_str || '<option ' || l_i500 || ' value="500">500</option>';
      l_str := l_str || '<option ' || l_def  || ' value="ALL">ALL</option>';

      l_str := l_str || '</select>';

      RETURN l_str;
   END;

   FUNCTION ShowPageHeading   RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Records per Page: ';
   END;

END;
/
SHOW ERRORS