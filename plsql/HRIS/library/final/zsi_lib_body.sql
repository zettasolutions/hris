SET SCAN OFF
CREATE OR REPLACE
PACKAGE BODY zsi_lib IS

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
   22-OCT-24  BD    Added IsStringValid function.
   04-JUL-14  BD    Added pagination logic.
   16-JUL-14  BD    New
   */


   l_max_rows  NUMBER(10) := 25;

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
                  p_name           IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
   IS
      l_name        VARCHAR2(100);
      l_stmt        VARCHAR2(32767);
      l_df          VARCHAR2(512);
      l_vf          VARCHAR2(255);
      rue           VARCHAR2(32767);

      TYPE LOVCurType IS REF CURSOR;
      c  LOVCurType;

   BEGIN
      IF p_name IS NOT NULL THEN
         l_name := p_name;
      ELSE
         l_name := LOWER(NVL(p_param, p_value_field));
      END IF;

      IF p_multiple IS NOT NULL THEN
         rue := '<select  class="form-control" name=' || '"p_' || l_name || '" ' || p_multiple || ' SIZE=' || p_size || ' ' || p_attributes || '>';
      ELSE
         rue := '<select class="form-control" name=' || '"p_' || l_name || '" ' || p_attributes || '>';
      END IF;

      IF p_percent = '%' THEN
         rue := rue || '<option>%</option>';
      ELSIF p_percent = ' ' THEN
         rue := rue || '<option></option>';
      END IF;

      l_stmt := 'SELECT ' || p_distinct || ' ' || p_display_field || ',' || p_value_field ||
                    ' FROM ' || p_table || ' ' || p_condition;

      OPEN c FOR l_stmt;
      LOOP
         FETCH c INTO l_df, l_vf;
         EXIT WHEN c%NOTFOUND;
         IF UPPER(l_vf) = UPPER(p_value) THEN
            rue := rue || '<option value="' || l_vf || '" selected>' || l_df || '</option>';
         ELSE
            rue := rue || '<option value="' || l_vf || '">' || l_df || '</option>';
         END IF;
      END LOOP;
      CLOSE c;

      rue := rue || '</select>';

      RETURN rue;

   END;

   FUNCTION YesNo (p_field      IN  VARCHAR2,
                    p_value      IN  VARCHAR2 DEFAULT NULL,
                    p_attributes IN  VARCHAR2 DEFAULT NULL,
                    p_mandatory  IN  VARCHAR2 DEFAULT 'N') RETURN VARCHAR2
   IS
      rue            VARCHAR2(2000);
      str            VARCHAR2(2000);
   BEGIN
      rue := '<select class="form-control" name=' || '"p_' || LOWER(p_field)|| '" ' || p_attributes || '>';

      IF p_mandatory = 'N' THEN
         rue := rue || '<option value=""></option>';
      END IF;

      IF p_value = '1' THEN
         rue := rue || '<option value="1" selected>Yes</option>';
         rue := rue || '<option value="0">No</option>';
      ELSIF p_value = '0' THEN
         rue := rue || '<option value="1">Yes</option>';
         rue := rue || '<option value="0" selected>No</option>';
      ELSE
         rue := rue || '<option value="1">Yes</option>';
         rue := rue || '<option value="0">No</option>';
      END IF;

      rue := rue || '</SELECT>';

      RETURN rue;
   END;

   FUNCTION GetDescription (p_table IN VARCHAR2,
                            p_field IN VARCHAR2,
                            p_param_field IN VARCHAR2,
                            p_param_value IN VARCHAR2,
                            p_param_field2 IN VARCHAR2 DEFAULT NULL,
                            p_param_value2 IN VARCHAR2 DEFAULT NULL,
                            p_param_field3 IN VARCHAR2 DEFAULT NULL,
                            p_param_value3 IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
   IS
      return_desc  VARCHAR2(10000):= NULL;
      l_sql        VARCHAR2(4000);

   BEGIN
      IF p_param_value IS NOT NULL THEN
         l_sql := 'SELECT ' || p_field || ' FROM ' || p_table || ' WHERE upper(' || p_param_field || ')=''' || upper(p_param_value) || '''';

         if p_param_field2 IS NOT NULL THEN
            l_sql := l_sql || ' AND upper(' || p_param_field2 || ')=''' || upper(p_param_value2) || '''';
         END IF;

         if p_param_field3 IS NOT NULL THEN
            l_sql := l_sql || ' AND upper(' || p_param_field3 || ')=''' || upper(p_param_value3) || '''';
         END IF;

      EXECUTE IMMEDIATE l_sql INTO return_desc;
      END IF;
      RETURN return_desc;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RETURN NULL;

   END GetDescription;

   FUNCTION GetCount (p_cfield IN VARCHAR2 DEFAULT NULL,
                      p_table  IN VARCHAR2,
                      p_where  IN VARCHAR2 DEFAULT NULL,
                      p_gfield IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
   IS
      return_count NUMBER:=0;
      l_sql        VARCHAR2(4000);

   BEGIN
      IF p_cfield IS NULL THEN
         l_sql := 'SELECT COUNT(*) FROM ' || p_table ;
      ELSE
         l_sql := 'SELECT COUNT(' || p_cfield || ') FROM ' || p_table ;
      END IF;

      IF p_where IS NOT NULL THEN
         l_sql := l_sql || ' WHERE ' || p_where;
      END IF;

       IF p_gfield IS NOT NULL THEN
         l_sql := l_sql || ' GROUP BY ' || p_gfield;
      END IF;

      EXECUTE IMMEDIATE l_sql INTO return_count;
      RETURN return_count;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RETURN NULL;
   END GetCount;

   FUNCTION GetSum (p_sfield IN VARCHAR2,
                    p_table  IN VARCHAR2,
                    p_where  IN VARCHAR2 DEFAULT NULL,
                    p_gfield IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
   IS
      return_sum   NUMBER:=0;
      l_sql        VARCHAR2(4000);

   BEGIN
      l_sql := 'SELECT SUM(' || p_sfield || ') FROM ' || p_table;

      IF p_where IS NOT NULL THEN
         l_sql := l_sql || ' WHERE ' || p_where;
      END IF;

       IF p_gfield IS NOT NULL THEN
         l_sql := l_sql || ' GROUP BY ' || p_gfield;
      END IF;

      EXECUTE IMMEDIATE l_sql INTO return_sum;
      RETURN return_sum;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RETURN NULL;
   END GetSum;

   Function GetStatus (p_status IN VARCHAR2) RETURN VARCHAR2
   IS
      return_status VARCHAR2(100) := 'No';
   BEGIN
      IF p_status = 1 THEN
         return_status := 'Yes';
      END IF;
      RETURN return_status;
   END GetStatus;


   FUNCTION ServiceName RETURN VARCHAR2
   IS
      script_name     VARCHAR2(255) DEFAULT owa_util.get_cgi_env('SCRIPT_NAME');
   BEGIN
      RETURN SUBSTR(script_name, 1, INSTR(script_name,'/',-1));
   END ServiceName;


   FUNCTION ServerPath RETURN VARCHAR2 IS
   BEGIN
      RETURN '/apps/';
   END ServerPath;

   FUNCTION StylePath RETURN VARCHAR2 IS
   BEGIN
      RETURN '/apps/s004/css/';
   END StylePath;

   FUNCTION ImagePath RETURN VARCHAR2 IS
   BEGIN
      RETURN '/apps/s004/images/';
   END ImagePath;

   FUNCTION JSPath RETURN VARCHAR2 IS
   BEGIN
      RETURN '/apps/s004/js/';
   END JSPath;

   FUNCTION DHTMLXPath RETURN VARCHAR2 IS
   BEGIN
      RETURN '/apps/dhtmlx3.6/';
   END DHTMLXPath;

   FUNCTION MainCSS RETURN VARCHAR2 IS
   BEGIN
      RETURN 's004_main.css';
   END MainCSS;

   FUNCTION DefaultDateFormat RETURN VARCHAR2 IS
   BEGIN
      RETURN 'MM/DD/YYYY';
   END DefaultDateFormat;

   FUNCTION ClientLogo RETURN VARCHAR2 IS
   BEGIN
      RETURN 'mcwd.gif';
   END ClientLogo;


   FUNCTION ClientName RETURN VARCHAR2 IS
   BEGIN
      RETURN 'Metropolitan Cebu Water District';
   END ClientName;

   FUNCTION IsDateValid (p_date_entered  IN  VARCHAR2,
                         p_date_format   IN  VARCHAR2) RETURN VARCHAR2 IS

      l_date_format      VARCHAR2(20):= p_date_format;
      l_date_mask        VARCHAR2(20);
      l_date             DATE;
   BEGIN

      l_date := TO_DATE(p_date_entered,p_date_format);
      RETURN 'Y';

   EXCEPTION
      WHEN OTHERS THEN
         -- 'entered date should be of the given format from p_date_format'
         RETURN 'N';
   END IsDateValid;

   FUNCTION IsChanged (p_old_value IN NUMBER,
                       p_new_value IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      IF p_old_value IS NULL AND p_new_value IS NOT NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value IS NOT NULL AND p_new_value IS NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value <> p_new_value THEN
         RETURN 'Y';
      END IF;

      RETURN 'N';

   END IsChanged;

   FUNCTION IsChanged (p_old_value IN VARCHAR2,
                       p_new_value IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      IF p_old_value IS NULL AND p_new_value IS NOT NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value IS NOT NULL AND p_new_value IS NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value <> p_new_value THEN
         RETURN 'Y';
      END IF;

      RETURN 'N';

   END IsChanged;

   FUNCTION IsChanged (p_old_value IN DATE,
                       p_new_value IN DATE) RETURN VARCHAR2 IS
   BEGIN
      IF p_old_value IS NULL AND p_new_value IS NOT NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value IS NOT NULL AND p_new_value IS NULL THEN
         RETURN 'Y';
      END IF;

      IF p_old_value <> p_new_value THEN
         RETURN 'Y';
      END IF;

      RETURN 'N';

   END IsChanged;


   FUNCTION ToJSDateFormat (p_date_format IN VARCHAR2) RETURN VARCHAR2 IS
     l_js_dformat  VARCHAR2(100);
   BEGIN
     l_js_dformat := p_date_format;
     l_js_dformat := REPLACE(l_js_dformat,'MM','%m');
     l_js_dformat := REPLACE(l_js_dformat,'mm','%m');
     l_js_dformat := REPLACE(l_js_dformat,'MONTH','%F');
     l_js_dformat := REPLACE(l_js_dformat,'Month','%F');
     l_js_dformat := REPLACE(l_js_dformat,'month','%F');
     l_js_dformat := REPLACE(l_js_dformat,'MON','%M');
     l_js_dformat := REPLACE(l_js_dformat,'Mon','%M');
     l_js_dformat := REPLACE(l_js_dformat,'mon','%M');
     l_js_dformat := REPLACE(l_js_dformat,'DD','%d');
     l_js_dformat := REPLACE(l_js_dformat,'dd','%d');
     l_js_dformat := REPLACE(l_js_dformat,'YYYY','%Y');
     l_js_dformat := REPLACE(l_js_dformat,'yyyy','%Y');
     l_js_dformat := REPLACE(l_js_dformat,'YY','%y');
     l_js_dformat := REPLACE(l_js_dformat,'yy','%y');
     RETURN l_js_dformat;
   END;


   FUNCTION FormatAmount (p_amount       IN  NUMBER,
                          p_decimal      IN  NUMBER DEFAULT 2) RETURN VARCHAR2 IS

      l_format              VARCHAR2(30);
      l_output              VARCHAR2(30);
   BEGIN

      IF p_decimal > 0 THEN
         /* 16 = number of characters for the number format including comma and period*/
         l_format := RPAD('999,999,999,990.',(16+p_decimal),'0') || 'PR';
      ELSE
         l_format := '999,999,999,990PR';
      END IF;

      l_output := TO_CHAR(p_amount, l_format);
      l_output := TRANSLATE(l_output,'<>','()');

      --RETURN(TRANSLATE(l_output, ',', ' '));
      RETURN TRIM(l_output);

   END;

   FUNCTION MaxRowsInList RETURN NUMBER IS
   BEGIN
      RETURN l_max_rows;
   END;

   FUNCTION IsPaging (p_rows IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      IF p_rows > l_max_rows THEN
         RETURN 'Y';
      END IF;
      RETURN 'N';
   END;

   PROCEDURE ShowPaging (p_page_no IN NUMBER,
                         p_rows    IN NUMBER,
                         p_numrec  IN NUMBER) IS
      l_last_page   NUMBER(10);
      l_record_from NUMBER(10);
      l_record_to   NUMBER(10);
   BEGIN
      l_last_page := CEIL(p_rows/l_max_rows);
      l_record_from := (l_max_rows * (p_page_no-1)) + 1;
      l_record_to := l_record_from + p_numrec - 1;
      htp.p('<div class="pageholder">');
      htp.p('<div class="pagectrl">');
      htp.p('<label id="page">Page </label>');
      htp.p('<select name="p_page_no" onchange="gotoPage(this)">');
      FOR i IN 1..l_last_page LOOP
         IF p_page_no = i THEN
            htp.p('<option selected value="' || i || '">' || i || '</option>');
         ELSE
            htp.p('<option value="' || i || '">' || i || '</option>');
         END IF;
      END LOOP;
      htp.p('</select>');
      htp.p('<label id="of"> of ' || l_last_page ||'</label>');
      htp.p('</div>');
      htp.p('<div class="pagestatus">Showing records from <i>' || l_record_from || '</i> to <i>' || l_record_to ||'</i></div>');
      htp.p('</div>');
   END;

   FUNCTION GeneratePagingWhere (p_page_no IN NUMBER) RETURN VARCHAR2 IS
      l_record_from NUMBER(10);
      l_record_to   NUMBER(10);
   BEGIN
      l_record_to   := (p_page_no * l_max_rows);
      l_record_from := l_record_to - l_max_rows;
      RETURN (' WHERE rn BETWEEN ' || l_record_from || ' AND ' || l_record_to || ' ORDER BY rn ');
   END;


   PROCEDURE select_json (p_table IN VARCHAR2,
                          p_display_field IN VARCHAR2,
                          p_value_field IN VARCHAR2,
                          p_condition IN VARCHAR2,
                          p_distinct IN VARCHAR2 DEFAULT NULL) IS


   l_select                     VARCHAR2(3000);
   l_json                       VARCHAR2(8000):= '';
   l_value                      VARCHAR2(100);
   l_text                       VARCHAR2(1000);
   l_sql_count                  NUMBER:=0;

   TYPE cur IS REF CURSOR;

   l_ref    cur;

   BEGIN
   owa_util.mime_header('application/json');
   l_select := 'SELECT ' || p_distinct || ' ' || p_value_field || ',' || p_display_field ||
                  ' FROM ' || p_table || ' ' || p_condition;


   EXECUTE IMMEDIATE 'SELECT count(*) FROM '||  p_table || ' ' ||  p_condition into l_sql_count;



   htp.p('[');
   OPEN l_ref FOR l_select;
   LOOP
      FETCH l_ref INTO l_value, l_text;
      EXIT WHEN l_ref%NOTFOUND;


         htp.p('{"value":"' || l_value || '","text":"' ||  utl_url.escape(l_text) || '"}');

      IF (l_ref%rowcount != l_sql_count ) THEN
         htp.p(',');
      END IF;

   END LOOP;

   htp.p(']');

   END;


   PROCEDURE count_records (p_table IN VARCHAR2,
                            p_condition IN VARCHAR2 DEFAULT NULL,
                            p_t IN VARCHAR2 DEFAULT NULL) IS

      rec_count  NUMBER;

   BEGIN
      owa_util.mime_header('text/plain');
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table || ' ' ||  p_condition  INTO rec_count;
      htp.p(rec_count);
   END;


   FUNCTION GetModuleID (p_module_url IN VARCHAR2) RETURN NUMBER IS
      l_module_id    s004_modules.module_id%TYPE;
   BEGIN
      SELECT module_id
        INTO l_module_id
        FROM s004_modules
       WHERE UPPER(module_url) = UPPER(p_module_url);
      RETURN l_module_id;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;

   FUNCTION IsWrite (p_user IN VARCHAR2, p_module_id IN NUMBER) RETURN NUMBER IS
      l_is_write     s004_user_modules.is_write%TYPE;
   BEGIN
      SELECT is_write
        INTO l_is_write
        FROM s004_user_modules
       WHERE module_id = p_module_id
         AND upper(user_name) = upper(p_user);
      RETURN NVL(TO_NUMBER(l_is_write),0);
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;


   FUNCTION EnCodeStr (p_user IN VARCHAR2) RETURN VARCHAR2 IS
      l_encoded_str   VARCHAR2(100);
   BEGIN
      SELECT ORA_HASH(UPPER(p_user))
        INTO l_encoded_str
        FROM dual;
      --l_encoded_str := ORA_HASH(UPPER(p_user));
      l_encoded_str := TO_CHAR(SYSDATE,'YY') || l_encoded_str || TO_CHAR(SYSDATE,'MMDD');
      RETURN l_encoded_str;
   END;

   FUNCTION DeCodeStr (p_code IN VARCHAR2) RETURN VARCHAR2 IS
      l_user          VARCHAR2(100);
      l_strlen        NUMBER(10);
   BEGIN
      l_strlen := LENGTH(p_code);
      l_user   := SUBSTR(p_code,3,(l_strlen-6));
      RETURN l_user;
   END;


   FUNCTION IsStringValid (p_string IN VARCHAR2) RETURN VARCHAR2 IS
      l_char         VARCHAR2(4);
      l_string       VARCHAR2(32000);
      l_min          NUMBER;
      l_max          NUMBER;
      l_count        NUMBER := 0;
   BEGIN
      IF LENGTH(p_string) > 0 THEN
         l_min := 1;
         l_max := LENGTH(p_string);
      ELSE
         l_min := 0;
         l_max := 0;
      END IF;
      FOR x IN l_min..l_max LOOP
         l_char := SUBSTR(p_string,x,1);
         IF l_char IN ('''', '`', '~', '<', '>', '{', '}', '\', '+', '&', '=', '%', '#', '!', '|', '?') THEN
            RETURN 'N';
         END IF;
      END LOOP;
      RETURN 'Y';
   END;

   FUNCTION GetBaseName (p_file_name IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN SUBSTR(p_file_name, INSTR(p_file_name, '/') + 1 );
   END;


END;
/
SHOW ERRORS
