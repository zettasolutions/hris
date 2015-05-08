CREATE OR REPLACE
PACKAGE BODY zsi_SESSIONS_LIB IS


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
   01-JUL-14  BD    New
   */

   l_ck_time                VARCHAR2(20) := 'CLIENT_LOGONTIME';
   l_ck_ip                  VARCHAR2(20) := 'CLIENT_IP';
   l_ck_session             VARCHAR2(20) := 'CLIENT_SESSIONID';
   l_ck_last_logon          VARCHAR2(20) := 'CLIENT_LASTLOGON';

   FUNCTION IsValidUser (p_user_name IN VARCHAR2) RETURN VARCHAR2 IS
      l_valid  VARCHAR2(1);
   BEGIN
      SELECT 'Y'
        INTO l_valid
        FROM s004_t05001
       WHERE UPPER(user_name) = UPPER(p_user_name);
      RETURN l_valid;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 'N';
   END;


   PROCEDURE SetCookieUser (p_user_name  IN  VARCHAR2) IS
      l_session_id             NUMBER;
      l_ip                     VARCHAR2(100);
      l_session                VARCHAR2(100);
      l_last_logon             VARCHAR2(100);
      l_cookie                 OWA_COOKIE.COOKIE;
   BEGIN

      /* Get Logon Info */
      BEGIN
         SELECT SYS_CONTEXT('USERENV','IP_ADDRESS')
           INTO l_ip
           FROM dual;

         SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ||
                s004_t05010_sq001.NEXTVAL             ||
                TO_CHAR(DBMS_RANDOM.VALUE(1000000000,10000000000),'fm0000000000')
           INTO l_session_id
           FROM DUAL;

         INSERT INTO s004_t05010 (session_id, session_date, ip_address, logon)
                            VALUES (l_session_id, SYSDATE, l_ip, p_user_name);
      EXCEPTION
         WHEN OTHERS THEN
              HTP.P(SQLERRM);
              RETURN;
      END;


      /* Remove Cookies, if exists */
      l_cookie := OWA_COOKIE.GET(l_ck_time);
      IF l_cookie.num_vals > 0 THEN
         l_last_logon := l_cookie.vals(1);
         OWA_COOKIE.REMOVE(l_ck_time, NULL);
      END IF;

      l_cookie := OWA_COOKIE.GET(l_ck_ip);
      IF l_cookie.num_vals > 0 THEN
         OWA_COOKIE.REMOVE(l_ck_ip, NULL);
      END IF;

      l_cookie := OWA_COOKIE.GET(l_ck_session);
      IF l_cookie.num_vals > 0 THEN
         OWA_COOKIE.REMOVE(l_ck_session, NULL);
      END IF;


      /* Set Cookies */

      OWA_UTIL.MIME_HEADER('text/html', FALSE);
      OWA_COOKIE.SEND(l_ck_time, TO_CHAR(SYSDATE, 'YYYYMMDD HH24MISS'), NULL);
      OWA_COOKIE.SEND(l_ck_ip, l_ip, NULL);
      OWA_COOKIE.SEND(l_ck_session, l_session_id, NULL);
      OWA_COOKIE.SEND(l_ck_last_logon, l_last_logon, NULL);
      OWA_UTIL.HTTP_HEADER_CLOSE;

      /* Set the Last Logon Info */
      UPDATE s004_t05011
         SET last_logon = SYSDATE
       WHERE UPPER(TRIM(user_name)) = UPPER(TRIM(p_user_name));

      IF SQL%ROWCOUNT = 0 THEN
         INSERT INTO s004_t05011 (user_log_id,
                                  user_name  ,
                                  last_logon )
                          VALUES (s004_t05011_sq001.NEXTVAL,
                                  UPPER(TRIM(p_user_name)),
                                  SYSDATE);
      END IF;

   END;

   FUNCTION GetCookieUser RETURN VARCHAR2 IS
      l_cookie       OWA_COOKIE.COOKIE;
      l_logon        s004_t05010.logon%TYPE;
   BEGIN
      l_cookie := owa_cookie.get(l_ck_session);
      IF l_cookie.num_vals > 0 THEN
         SELECT logon
           INTO l_logon
           FROM s004_t05010
          WHERE session_id = l_cookie.vals(1);
         RETURN l_logon;
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RETURN NULL;
   END;


   PROCEDURE RedirectURL(p_url IN VARCHAR2) IS
   BEGIN
      htp.p('<html><body>');
      htp.p('<script type="text/javascript">');
      htp.p('window.top.location="' || p_url ||'";');
      htp.p('</script>');
      htp.p('</body></html>');
   END;


END zsi_SESSIONS_LIB;
/
SHOW ERRORS;