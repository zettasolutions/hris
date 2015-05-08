SET SCAN OFF
CREATE OR REPLACE
PACKAGE zsi_lib IS

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
   13-FEB-15  GF    Added value_exist procedure
   29-OCT-14  BD    Added GetBaseName function.
   22-OCT-14  BD    Added IsStringValid function.
   04-JUL-14  BD    Added pagination logic.
   16-JUN-14  BD    New
   */

   TYPE VC2_1_ARR    IS TABLE OF VARCHAR2(1)  INDEX BY BINARY_INTEGER;
   TYPE VC2_255_ARR  IS TABLE OF VARCHAR2(255)  INDEX BY BINARY_INTEGER;
   TYPE VC2_4K_ARR   IS TABLE OF VARCHAR2(4000)  INDEX BY BINARY_INTEGER;
   TYPE NUM10_ARR    IS TABLE OF NUMBER(10)  INDEX BY BINARY_INTEGER;
   TYPE NUM_ARR      IS TABLE OF NUMBER  INDEX BY BINARY_INTEGER;
   void_str1         VARCHAR2(100) := ' (' || '''' || ' " ` ~ < > [ ] { } / + & = % # ! ' || '|' || ' ?) ';
   void_str2         VARCHAR2(100) := ' (' || '''' || ' " ` ~ < > [ ] { } / + & = % # ! ' || '|' || ' ?) ';


   FUNCTION List (p_table          IN  VARCHAR2,
                  p_display_field  IN  VARCHAR2,
                  p_value_field    IN  VARCHAR2,
                  p_condition      IN  VARCHAR2 DEFAULT NULL,
                  p_param          IN  VARCHAR2 DEFAULT NULL,
                  p_percent        IN  VARCHAR2 DEFAULT NULL,
                  p_value          IN  VARCHAR2 DEFAULT NULL,
                  p_distinct       IN  VARCHAR2 DEFAULT NULL,
                  p_multiple       IN  VARCHAR2 DEFAULT NULL,
                  p_size           IN  VARCHAR2 DEFAULT NULL,
                  p_attributes     IN  VARCHAR2 DEFAULT NULL,
                  p_name           IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

   FUNCTION YesNo (p_field      IN  VARCHAR2,
                   p_value      IN  VARCHAR2 DEFAULT NULL,
                   p_attributes IN  VARCHAR2 DEFAULT NULL,
                   p_mandatory  IN  VARCHAR2 DEFAULT 'N') RETURN VARCHAR2;

   FUNCTION GetDescription (p_table IN VARCHAR2,
                            p_field IN VARCHAR2,
                            p_param_field IN VARCHAR2,
                            p_param_value IN VARCHAR2,
                            p_param_field2 IN VARCHAR2 DEFAULT NULL,
                            p_param_value2 IN VARCHAR2 DEFAULT NULL,
                            p_param_field3 IN VARCHAR2 DEFAULT NULL,
                            p_param_value3 IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

   FUNCTION GetCount (p_cfield IN VARCHAR2 DEFAULT NULL,
                      p_table  IN VARCHAR2,
                      p_where  IN VARCHAR2 DEFAULT NULL,
                      p_gfield IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;

   FUNCTION GetSum (p_sfield IN VARCHAR2,
                    p_table  IN VARCHAR2,
                    p_where  IN VARCHAR2 DEFAULT NULL,
                    p_gfield IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;

   FUNCTION GetStatus (p_status IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION ServerPath RETURN VARCHAR2;

   FUNCTION StylePath RETURN VARCHAR2;

   FUNCTION ImagePath RETURN VARCHAR2;

   FUNCTION JSPath RETURN VARCHAR2;

   FUNCTION DHTMLXPath RETURN VARCHAR2;

   FUNCTION MainCSS RETURN VARCHAR2;

   FUNCTION DefaultDateFormat RETURN VARCHAR2;

   FUNCTION ClientLogo  RETURN VARCHAR2;

   FUNCTION ClientName  RETURN VARCHAR2;

   FUNCTION IsDateValid (p_date_entered  IN  VARCHAR2,
                         p_date_format   IN  VARCHAR2) RETURN VARCHAR2;

   FUNCTION IsChanged (p_old_value IN NUMBER,
                       p_new_value IN NUMBER) RETURN VARCHAR2;

   FUNCTION IsChanged (p_old_value IN VARCHAR2,
                       p_new_value IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION IsChanged (p_old_value IN DATE,
                       p_new_value IN DATE) RETURN VARCHAR2;

   FUNCTION ToJSDateFormat (p_date_format IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION FormatAmount (p_amount  IN  NUMBER,
                          p_decimal IN  NUMBER DEFAULT 2) RETURN VARCHAR2;

   FUNCTION MaxRowsInList RETURN NUMBER;

   FUNCTION IsPaging (p_rows IN NUMBER) RETURN VARCHAR2;

   PROCEDURE ShowPaging (p_page_no IN NUMBER,
                         p_rows    IN NUMBER,
                         p_numrec  IN NUMBER);

   FUNCTION GeneratePagingWhere (p_page_no IN NUMBER, p_order_by IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;


   PROCEDURE select_json (p_table IN VARCHAR2,
                          p_display_field IN VARCHAR2,
                          p_value_field IN VARCHAR2,
                          p_condition IN VARCHAR2,
                          p_distinct IN VARCHAR2 DEFAULT NULL);

   PROCEDURE count_records (p_table IN VARCHAR2,
                            p_condition IN VARCHAR2 DEFAULT NULL,
                            p_t IN VARCHAR2 DEFAULT NULL);


   FUNCTION GetModuleID (p_module_url IN VARCHAR2) RETURN NUMBER;

   FUNCTION IsWrite (p_user IN VARCHAR2, p_module_id IN NUMBER) RETURN NUMBER;

   FUNCTION EnCodeStr (p_user IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION DeCodeStr (p_code IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION IsStringValid (p_string IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION GetBaseName (p_file_name IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION AMChartsPath RETURN VARCHAR2;
   
   PROCEDURE value_exist (p_table IN VARCHAR2 ,p_condition IN VARCHAR2 DEFAULT NULL);
                          
   FUNCTION GetCMonth (p_month IN NUMBER) RETURN VARCHAR2;

END zsi_lib;
/
SHOW ERRORS
