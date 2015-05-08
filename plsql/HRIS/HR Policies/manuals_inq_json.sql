SET SCAN OFF
CREATE OR REPLACE
PROCEDURE manuals_inq_json (p_manual_code      IN NUMBER default NULL,
                            p_manual_title     IN VARCHAR2 default NULL,
                            p_chapter_code     IN NUMBER default NULL,
                            p_chapter_title    IN VARCHAR2 default NULL,
                            p_rows             IN NUMBER default NULL,
                            p_page_no          IN NUMBER default 1) IS
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
      29-OCT-14  BD    New
   */
   --DECLARATION SECTION
   l_select                     VARCHAR2(3000);
   l_from                       VARCHAR2(1000);
   l_where                      VARCHAR2(4000);
   l_sql                        VARCHAR2(8000);
   l_order                      VARCHAR2(1000);
   l_json                       VARCHAR2(8000);
   l_link2                      VARCHAR2(8000);
   l_date_format                VARCHAR2(20):= zsi_lib.DefaultDateFormat;
   l_comma                      VARCHAR2(1);
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
   l_chapter_title              s004_t08401.chapter_title%TYPE;

   l_row_no                     NUMBER(10);
   l_rows                       NUMBER(10);
   l_max_rows                   NUMBER(10) := zsi_lib.MaxRowsInList;
   l_row_count                  NUMBER(10) := 0;
   l_total_rows                 NUMBER(10);
   l_module_id                  s004_modules.module_id%TYPE := zsi_lib.GetModuleID('manuals_list');

BEGIN
   check_login;
   owa_util.mime_header('application/json');

   l_select := 'SELECT seq_no, section_code, section_title, section_summary, page_no, file_name, ammendment, effectivity_date, chapter_title ';
   l_from   := ' FROM Manual_Sections_V  ';
   l_where  := ' WHERE 1=1 ';



   IF p_manual_code IS NOT NULL OR p_chapter_code IS NOT NULL OR p_manual_title IS NOT NULL  OR p_chapter_title IS NOT NULL THEN

      IF p_manual_code IS NOT NULL THEN
         l_where := l_where || '  AND manual_code = ' || p_manual_code;
      END IF;

      IF p_manual_title IS NOT NULL THEN
         l_where := l_where || ' AND UPPER(manual_title) LIKE ''%' || UPPER(p_manual_title) || '%''';
      END IF;

      IF p_chapter_code IS NOT NULL THEN
         l_where := l_where || ' AND chapter_code = ' || p_chapter_code;
      END IF;

      IF p_chapter_title IS NOT NULL THEN
         l_where := l_where || ' AND UPPER(chapter_title) LIKE ''%' || UPPER(p_chapter_title) || '%''';
      END IF;
/*
      IF LENGTH(l_where) > 0 THEN
         l_where := l_where || ' AND ( ' || SUBSTR(l_where,4) || ' ) ';
      END IF;
*/
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

   l_sql := l_select  || ',0 row_number ' || l_from || l_where;
   l_sql := l_sql || l_order;
   
   htp.p('{"rows":[');
   OPEN l_ref FOR l_sql;
   LOOP
      FETCH l_ref INTO  l_seq_no
                       ,l_section_code
                       ,l_section_title
                       ,l_section_summary
                       ,l_pages
                       ,l_file_name
                       ,l_ammendment
                       ,l_effectivity_date
                       ,l_chapter_title
                       ,l_row_no;
      EXIT WHEN l_ref%NOTFOUND;
      l_row_count := l_row_count + 1;
      l_link2 :='<a href=\"javascript:void(0)\" TITLE=\"Click here to view the page content\" onClick=\"window.open(''s004_doc_download?p_table=s004_t08402&p_field=seq_no&p_value='|| l_seq_no || ''',''_ViewCoverPage'');\">' || zsi_lib.GetBaseName(l_file_name) || '</a>';
      l_json:= l_comma || '{ "id":'|| l_row_count ||', "data":["'
                                                    || l_chapter_title    || '","'
                                                    || l_section_code    || '","'
                                                   || utl_url.escape(l_section_title)   || '","'
                                                   || utl_url.escape(l_section_summary) || '","'
                                                   || l_pages           || '","'
                                                   || l_ammendment      || '","'
                                                   || TO_CHAR(l_effectivity_date,l_date_format)    || '","'
                                                   || l_link2           || '"'
         ||']}';
      htp.p(l_json);
      l_comma := ',';
END LOOP;

htp.p('], "page_no":"'|| p_page_no ||'","page_rows":"'|| l_rows ||'","row_count":"' || l_row_count || '"}');

END;
/
SHOW ERR;