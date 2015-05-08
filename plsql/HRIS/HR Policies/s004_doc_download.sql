SET SCAN OFF
CREATE OR REPLACE
PROCEDURE s004_doc_download (p_table VARCHAR2,
                             p_field VARCHAR2,
                             p_value VARCHAR2) AS
   /*
   ========================================================================
   *
   *
   ========================================================================
   */

   /* Modification History
   Date       By    History
   ---------  ----  -------------------------------------------------------
   25-OCT-14  BD    New.
  */

   l_file_name           s004_docs.name%TYPE;
   l_mime_type           s004_docs.mime_type%TYPE;
   l_blob_content        s004_docs.blob_content%TYPE;
   l_length              s004_docs.doc_size%TYPE;
   l_sql                 VARCHAR2(1024);
   doc_cur               SYS_REFCURSOR;
BEGIN

   BEGIN

      IF p_field IS NOT NULL AND p_value IS NOT NULL THEN
         l_sql := 'SELECT b.mime_type, b.blob_content, b.name, b.doc_size '
               || ' FROM ' || p_table || ' a, s004_docs b '
               || ' WHERE a.file_name = b.name '
               || ' AND a.' || p_field || ' = ' || p_value;


         OPEN doc_cur FOR l_sql;
         FETCH doc_cur INTO l_mime_type, l_blob_content, l_file_name, l_length;
         CLOSE doc_cur;

         /* Set up HTTP Header */
         owa_util.mime_header(NVL(l_mime_type, 'application/octet'), FALSE);

         /* Set the size to indicate the browser how much to download */
         htp.p('Content-length: ' || l_length);

         /* The filename will be used by the browser if the users does a "Save As" */
         htp.p('Content-Type: ' || l_mime_type);
   --    htp.p('Content-Type: application/download');
         htp.p('Content-Disposition: filename="' || zsi_lib.GetBaseName(l_file_name) || '"');

         /* Close the Headers */
         owa_util.http_header_close;

         /* Download the BLOB content */
         wpg_docload.download_file(l_blob_content);

      END IF;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         htp.bold('Unable to find any document for this filename ' || zsi_lib.GetBaseName(l_file_name) || '. Please contact the Administrator');
         RETURN;
   END;
END;
/
SHOW ERRORS