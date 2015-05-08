SET SCAN OFF
CREATE OR REPLACE
PROCEDURE s004_doc_download (p_doc  IN  VARCHAR2 DEFAULT NULL,
                             p_id   IN  NUMBER   DEFAULT NULL) AS
   /*
   ========================================================================
   *
   *
   ========================================================================
   */

   /* Modification History
   Date       By    History
   ---------  ----  -------------------------------------------------------
   01-OCT-14  BD    New.
  */

   l_file_name           s004_docs.name%TYPE;
   l_mime_type           s004_docs.mime_type%TYPE;
   l_blob_content        s004_docs.blob_content%TYPE;
   l_length              s004_docs.doc_size%TYPE;
BEGIN

-- spm_login_chk;

   BEGIN

      IF p_id IS NOT NULL THEN
         SELECT mime_type, blob_content, name, doc_size
           INTO l_mime_type, l_blob_content, l_file_name, l_length
           FROM s004_docs
          WHERE name = p_doc;

         /* Set up HTTP Header */
         owa_util.mime_header(NVL(l_mime_type, 'application/octet'), FALSE);

         /* Set the size to indicate the browser how much to download */
         htp.p('Content-length: ' || l_length);

         /* The filename will be used by the browser if the users does a "Save As" */
         htp.p('Content-Type: ' || l_mime_type);
   --    htp.p('Content-Type: application/download');
         htp.p('Content-Disposition: filename="' || SUBSTR(l_file_name, INSTR(l_file_name, '/') + 1 ) || '"');

         /* Close the Headers */
         owa_util.http_header_close;

         /* Download the BLOB content */
         wpg_docload.download_file(l_blob_content);

      END IF;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         IF p_id IS NOT NULL THEN
            htp.bold('Unable to find any document for this Document Id #' || TO_CHAR(p_id) || '. Please contact the Administrator');
         ELSIF p_doc IS NOT NULL THEN
            htp.bold('Unable to find any document for this Document ' || p_doc || '. Please contact the Administrator');
         ELSE
            htp.bold('Unable to find any document. Please contact the Administrator');
         END IF;
         RETURN;
   END;
END;
/
SHOW ERRORS