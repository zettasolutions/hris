SET SCAN OFF
CREATE OR REPLACE
PROCEDURE manual_sections_json (
   p_manual_code      IN NUMBER,
   p_chapter_code      IN NUMBER,
   p_section_code     IN NUMBER default NULL,
   p_section_title    IN VARCHAR2 default NULL,
   p_pages            IN VARCHAR2 default NULL,
   p_ammendment       IN VARCHAR2 default NULL,
   p_effectivity_date IN VARCHAR2 default NULL,
   p_rows             IN NUMBER default NULL,
   p_page_no          IN NUMBER default 1,
   p_rt                 IN VARCHAR2 default NULL
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
      26-OCT-14  BD    New
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


   l_seq_no                     s004_t08402.seq_no%TYPE;
   l_section_code               s004_t08402.section_code%TYPE;
   l_section_title              s004_t08402.section_title%TYPE;
   l_section_summary            s004_t08402.section_summary%TYPE;
   l_pages                      s004_t08402.page_no%TYPE;
   l_file_name                  s004_t08402.file_name%TYPE;
   l_ammendment                 s004_t08402.ammendment%TYPE;
   l_effectivity_date           s004_t08402.effectivity_date%TYPE;
   l_remarks                    s004_t08402.remarks%TYPE;
   l_created_by                 s004_t08402.created_by%TYPE;
   l_date_created               s004_t08402.date_created%TYPE;
   l_modified_by                s004_t08402.modified_by%TYPE;
   l_date_modified              s004_t08402.date_modified%TYPE;
   l_count_section              NUMBER(10);

   l_row_no                     NUMBER(10);
   l_rows                       NUMBER(10);
   l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
   l_row_count                  NUMBER(10) := 0;
   l_total_rows                 NUMBER(10);
   l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('manuals_list');

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT seq_no, section_code, section_title, section_summary, page_no, file_name, ammendment, effectivity_date, remarks, created_by, date_created, modified_by, date_modified ';
   l_from   := '  FROM s004_t08402 ';
   l_where  := ' WHERE manual_code =  ' || p_manual_code
            || '   AND chapter_code = ' || p_chapter_code;

   IF p_section_code IS NOT NULL THEN
      l_where := l_where || ' AND section_code = ' || p_section_code;
   END IF;

   IF p_section_title IS NOT NULL THEN
      l_where := l_where || ' AND section_title LIKE ''%' || p_section_title || '%''';
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

   l_sql := l_select ||', row_number() OVER (ORDER BY section_code) rn ' || l_from || l_where;
   l_sql := 'SELECT * FROM ( ' || l_sql || ') ' || zsi_lib.GeneratePagingWhere(p_page_no);

   /*----------------*/

   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO l_seq_no
                       ,l_section_code
                       ,l_section_title
                       ,l_section_summary
                       ,l_pages
                       ,l_file_name
                       ,l_ammendment
                       ,l_effectivity_date
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

      l_count_section := 0;
      BEGIN
         SELECT COUNT(*)
           INTO l_count_section
           FROM S004_T08402
          WHERE seq_no=l_seq_no;
      EXCEPTION
         WHEN OTHERS THEN l_count_section := 0;
      END;

      l_chkdel:='<input type=\"checkbox\" name=\"p_cb\" onclick=\"zsi.table.setCheckBox(this,' || l_seq_no || ');\" value=\"'|| l_seq_no ||'\"><input type=\"hidden\">';
      l_link :='<a href=\"javascript:void(0)\" TITLE=\"Click here to Edit Section(s)\" onClick=\"parent.parent.parent.HomeWindow=window;parent.parent.parent.attachURL(''manual_section_form?p_module_id=' || l_module_id
             || '&p_seq_no='|| l_seq_no || '&p_manual_code=' || p_manual_code || '&p_chapter_code=' || p_chapter_code
             || ''',''Edit Section &raquo' || l_section_code || ''', 700, 450);\">' || l_section_code ||'</a>';
      l_link2 :='<a href=\"javascript:void(0)\" TITLE=\"Click here to view the manual cover page\" onClick=\"window.open(''s004_doc_download?p_table=s004_t08402&p_field=seq_no&p_value='|| l_seq_no || ''',''_ViewCoverPage'');\">' || zsi_lib.GetBaseName(l_file_name) || '</a>';

      l_json:= l_json
            || '{ "id":'|| l_row_count ||', "data":["'
                                                   || l_link            || '","'
                                                   || utl_url.escape(l_section_title)   || '","'
                                                   || utl_url.escape(l_section_summary) || '","'
                                                   || l_pages           || '","'
                                                   || l_ammendment      || '","'
                                                   || TO_CHAR(l_effectivity_date,l_date_format)    || '","'
                                                   || l_link2           || '","'
                                                   || l_chkdel          || '"'
            ||']}';

      htp.p(l_json);
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;