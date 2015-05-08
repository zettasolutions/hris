SET SCAN OFF
CREATE OR REPLACE
PROCEDURE get_doc_sig (p_doctor_code IN NUMBER) IS
  img_blob     BLOB;
  img_type     VARCHAR2(30);
  len          INTEGER;
  amount       BINARY_INTEGER := 32000;
  offset       INTEGER := 1;
  buffer       RAW(32000);
BEGIN
  SELECT signature
    INTO img_blob
    FROM s004_t08006
   WHERE doctor_code = p_doctor_code;

  owa_util.mime_header('application/octet', FALSE);

  len := dbms_lob.getlength(img_blob);
  WHILE offset < len LOOP
    dbms_lob.read
     ( lob_loc => img_blob
     , amount  => amount
     , offset  => offset
     , buffer  => buffer );

    htp.p(utl_raw.cast_to_varchar2(buffer));
    offset := offset + amount;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/
SHOW ERRORS