SET SCAN OFF
CREATE OR REPLACE
PROCEDURE manuals_json (
   p_manual_code     IN VARCHAR2 default NULL,
   p_manual_title    IN VARCHAR2 default NULL,
   p_rows            IN NUMBER default NULL,
   p_page_no         IN NUMBER default 1,
   p_rt              IN VARCHAR2 default NULL
) IS
   /*
   ========================================================================
   *
   * Copyright (c) 2014-2015 ZettaSolution, Inc.  All rights reserved.
   *
   * Redistribution and use in source and binary forms, with or without
   * modification is strictly prohibited.
   *
   ========================================================================
   */
   /* Modification History
      Date       By    History
      ---------  ----  ---------------------------------------------------------------------
      14-JAN-15  BD    Added module_id parameter to the child list/form.
      26-OCT-14  BD    Renamed section to chapter
      25-OCT-14  BD    Added section count
      19-OCT-14  BD    New
   */
   --DECLARATION SECTION
   l_select                     VARCHAR2(3000);
   l_from                       VARCHAR2(1000);
   l_where                      VARCHAR2(4000);
   l_sql                        VARCHAR2(8000);
   l_sql_count                  VARCHAR2(3000);
   l_json                       VARCHAR2(8000);
   l_chkdel                     VARCHAR2(8000);
   l_link                       VARCHAR2(8000);
   l_link2                      VARCHAR2(8000);
   l_link3                      VARCHAR2(8000);
   l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
   TYPE l_cur IS REF CURSOR;
   l_ref          l_cur;


   l_manual_code                s004_t08400.manual_code%TYPE;
   l_manual_title               s004_t08400.manual_title%TYPE;
   l_manual_summary             s004_t08400.manual_summary%TYPE;
   l_file_name                  s004_t08400.file_name%TYPE;
   l_remarks                    s004_t08400.remarks%TYPE;
   l_created_by                 s004_t08400.created_by%TYPE;
   l_date_created               s004_t08400.date_created%TYPE;
   l_modified_by                s004_t08400.modified_by%TYPE;
   l_date_modified              s004_t08400.date_modified%TYPE;
   l_chapter_count              NUMBER(10);

   l_row_no                     NUMBER(10);
   l_rows                       NUMBER(10);
   l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
   l_row_count                  NUMBER(10) := 0;
   l_total_rows                 NUMBER(10);
   l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('manuals_list');

BEGIN
   --check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT manual_code, manual_title, manual_summary, file_name, remarks, created_by, date_created, modified_by, date_modified ';
   l_from   := '  FROM s004_t08400 ';
   l_where  := ' WHERE 1=1 ';

   IF p_manual_code IS NOT NULL THEN
      l_where := l_where || ' AND manual_code = ' || p_manual_code;
   END IF;

   IF p_manual_title IS NOT NULL THEN
      l_where := l_where || ' AND manual_title LIKE ''%' || p_manual_title || '%''';
   END IF;

   IF p_page_no = 1 AND p_rows IS NULL THEN
      l_sql := 'SELECT COUNT(*) ' || l_from || l_where;
      OPEN l_ref FOR l_sql;
         LOOP
            FETCH l_ref INTO l_rows;
            EXIT WHEN l_ref%NOTFOUND;
         END LOOP;
      CLOSE l_ref;
   ELSE
      l_rows := p_rows;
      l_total_rows := p_rows;
   END IF;

   l_sql := l_select ||', row_number() OVER (ORDER BY manual_title) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);


   /*----------------*/

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_manual_code
                       ,l_manual_title
                       ,l_manual_summary
                       ,l_file_name
                       ,l_remarks
                       ,l_created_by
                       ,l_date_created
                       ,l_modified_by
                       ,l_date_modified
                       ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;

      l_json := '';
      IF (l_row_count > 1 ) THEN
         l_json:= ',';
      END IF;

      l_chapter_count := 0;
      BEGIN
         SELECT COUNT(*)
           INTO l_chapter_count
           FROM S004_T08401
          WHERE manual_code=l_manual_code;
      EXCEPTION
         WHEN OTHERS THEN l_chapter_count := 0;
      END;

      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_manual_code || ');\" value=\"'|| l_manual_code ||'\"><input type=\"hidden\">';
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Manual\" onClick=\"parent.HomeWindow=window;parent.attachURL(''manual_form?p_module_id=' || l_module_id || '&p_manual_code='|| l_manual_code || ''',''Edit Manual &raquo' || l_manual_code || ''', 700, 350);\">' || l_manual_code ||'</a>';
      l_link2 :='<a href=\"javascript:void(0)\" TITLE=\"Click here to view the manual cover page\" onClick=\"window.open(''s004_doc_download?p_table=s004_t08400&p_field=manual_code&p_value='|| l_manual_code || ''',''_ViewCoverPage'');\">' || zsi_lib.GetBaseName(l_file_name) || '</a>';
      l_link3 :='<a href=\"javascript:void(0)\" TITLE=\"Click here to go to the manual chapter(s)\" onClick=\"attachURL(''manual_chapters_list?p_module_id=' || l_module_id || '&p_manual_code='|| l_manual_code || ''',''Chapters for Manual &raquo' || l_manual_code || ' : ' || l_manual_title || ''', 800, 600);w1.maximize();\">' || l_chapter_count || '</a>';

      l_json:= l_json
            || '{ "id":'|| l_row_count ||', "data":["'
                                                   || l_link                || '","'
                                                   || utl_url.escape(l_manual_title)        || '","'
                                                   || utl_url.escape(l_manual_summary)      || '","'
                                                   || l_link2               || '","'
                                                   || l_link3               || '","'
                                                   || l_chkdel              || '"'
            ||']}';

      htp.p(l_json);
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;