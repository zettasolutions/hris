SET SCAN OFF
CREATE OR REPLACE
PACKAGE BODY zsi_bs_lib IS

   /*
   =======================================================================
   *
   * Copyright (c) 20014-2014 by ZSI.  All rights reserved.
   *
   * Redistribution and use in source and binary forms, with or without
   * modification is strictly prohibited.
   *
   ===========================================================================================================================
   */

   /* Modification History
   Date       By    History
   ---------  ----  ----------------------------------------------------------------------------------------------------------
   24-NOV-14  BD    Added CMonths procedure.
   21-JUL-14  GF    Added InputTextBoxArea.
   05-JUL-14  GF    Added graphical Icon for buttons.
   05-JUL-14  GF    Added Button procedure.
   02-JUL-14  GF    Added inputTextBox procedure and selectList function
   29-JUN-14  GT    New
   */

   l_default_label_size_type  VARCHAR2(50):='xs';
   l_default_label_size       VARCHAR2(50):='2';
   l_default_input_size       VARCHAR2(50):='10';
   l_default_button_size      VARCHAR2(50):='sm';

   PROCEDURE OpenPanel (p_title IN VARCHAR2)
   IS
   BEGIN
      htp.p('<div class="panel panel-default">');
      htp.p('  <div class="panel-heading">');
      htp.p('    <h4 class="panel-title">' || p_title || '</h4>');
      htp.p('  </div>');
      htp.p('  <div class="panel-body form-horizontal">');

   END openPanel;

   PROCEDURE closePanel
   IS
   BEGIN
      htp.p('  </div>');
      htp.p('</div>');

   END closePanel;


   PROCEDURE OpenModalWindow(p_modalId IN VARCHAR2,p_title IN VARCHAR2,p_formId IN VARCHAR2,p_actionName IN VARCHAR2, p_method IN VARCHAR2 DEFAULT 'GET')
   IS
   BEGIN
      htp.p('<div class="modal fade" id="' || p_modalId || '" tabindex="-1" role="dialog" aria-labelledby="ModalTitle" aria-hidden="true">');
      htp.p('  <div class="modal-dialog">');
      htp.p('    <div class="modal-content">');
      htp.p('      <div class="modal-header">');
      htp.p('        <a class="close" data-dismiss="modal">&times;</a>');
      htp.p('         <h4 class="modal-title" id="ModalTitle">' || p_title ||'</h4>');
      htp.p('      </div>');
      htp.p('      <form id="' || p_formId || '" class="form-horizontal" method="' || p_method || '" action="' || p_actionName || '" >');
      htp.p('      <div class="modal-body">');

   END openModalWindow;



   PROCEDURE CloseModalWindow(p_buttonType IN VARCHAR2,p_buttonName IN VARCHAR2,p_btn_attributes IN VARCHAR2 DEFAULT NULL)
   IS
   l_attributes VARCHAR2(1000);
   BEGIN
      IF p_btn_attributes IS NOT NULL THEN
          l_attributes :=' ' || p_btn_attributes;
      ELSE
          l_attributes :=' ';
      END IF;

      htp.p('      </div>');
      htp.p('      <div class="modal-footer">');
      htp.p('         <button type="' || p_buttonType || '" class="btn btn-primary btn-sm" '|| l_attributes ||' >'|| GetIcon(p_buttonName)  || p_buttonName || '</button>');
      htp.p('      <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">'|| GetIcon('Close') ||'Close</button>');
      htp.p('      </div>');
      htp.p('      </form>');
      htp.p('    </div>');
      htp.p('  </div>');
      htp.p('</div>');
   END closeModalWindow;


   PROCEDURE InputHiddenBox(p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL)
   IS
   BEGIN
      htp.p('<input type="hidden" id="'|| p_inputName ||'" name="'|| p_inputName ||'" value="'|| p_inputValue ||'">');

   END InputHiddenBox;


   PROCEDURE InputTextBox(p_labelName  IN VARCHAR2 DEFAULT NULL, p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_inputSize IN NUMBER DEFAULT NULL, p_type IN VARCHAR2 DEFAULT NULL, p_placeholder IN VARCHAR2 DEFAULT NULL, p_inputclass IN VARCHAR2 DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL, p_Wrapper IN VARCHAR2 DEFAULT 'Y')
   IS
      l_inputSize       VARCHAR2(1000);
      l_inputValue      VARCHAR2(1000);
      l_placeholder     VARCHAR2(1000);
      l_attributes      VARCHAR2(1000);
      l_labelSize       VARCHAR2(1000);
      l_label           VARCHAR2(1000);
      l_type            VARCHAR2(1000);

   BEGIN
      IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;

      IF p_inputSize IS NOT NULL THEN
          l_inputSize :=' col-' || l_default_label_size_type || '-' || p_inputSize;
      ELSE
          l_inputSize :=' col-' || l_default_label_size_type || '-' || l_default_input_size;
      END IF;

      IF p_inputValue IS NOT NULL THEN
          l_inputValue :=' value="' || p_inputValue || '"';
      ELSE
          l_inputValue :=' ';
      END IF;

      IF p_type IS NOT NULL THEN
          l_type :=' type="' || p_type || '"';
      ELSE
          l_type :=' type="text"';
      END IF;

      IF p_placeholder IS NOT NULL THEN
          l_placeholder :=' placeholder="' || p_placeholder || '"';
      ELSE
          l_placeholder :=' ';
      END IF;

      IF p_attributes IS NOT NULL THEN
          l_attributes :=' ' || p_attributes;
      ELSE
          l_attributes :=' ';
      END IF;

      IF p_labelName IS NOT NULL THEN
         l_label:='  <label class="' || l_labelSize ||' control-label" >' || p_labelName || '</label>';
      ELSE
         l_label:='';
      END IF;


      htp.p(l_label);
      IF p_Wrapper='Y' THEN
         htp.p('  <div class="' || l_inputSize || '">');
      END IF;
      htp.p('    <input '|| l_type ||' class="form-control input-sm ' || p_inputclass ||  '" id="' || p_inputName || '" name="' || p_inputName || '" ' || l_inputValue || l_placeholder || l_attributes || '>');

      IF p_Wrapper='Y' THEN
         htp.p('  </div>');
      END IF;

   END inputTextBox;
   
   PROCEDURE InputIdName(p_labelSize IN NUMBER DEFAULT NULL)   
   IS
      l_labelSize       VARCHAR2(1000);    
   BEGIN
      IF p_labelSize IS NOT NULL THEN
         l_labelSize :='col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
         l_labelSize :='col-xs-1';
      END IF;
      
      htp.p('<label class="' || l_labelSize || ' control-label" for="p_empl_id_no">Id No</label>');
      htp.p('<div class="col-xs-4">');
      htp.p('   <div class="col-xs-3">');
      htp.p('      <input type="text" class="form-control input-sm col-sm-2 LeftAdjust-m5" id="p_empl_id_no" name="p_empl_id_no" autocomplete="off" placeholder="Id" >');
      htp.p('   </div>');
      htp.p('   <div class="col-xs-9 LeftAdjust-m5">');
      htp.p('      <input type="text" class="form-control input-sm" id="p_empl_name" name="p_empl_name" placeholder="Name" autocomplete="off">');
      htp.p('   </div> ');
      htp.p('</div>');
   END InputIdName;

   PROCEDURE InputTextBoxArea(p_labelName  IN VARCHAR2, p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL, p_labelSize IN NUMBER DEFAULT NULL, p_inputSize IN NUMBER DEFAULT NULL,p_RowSize IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL)
   IS
      l_labelSize        VARCHAR2(1000);
      l_inputSize        VARCHAR2(1000);
      l_inputValue       VARCHAR2(32000);
      l_RowSize          VARCHAR2(1000);
      l_attributes       VARCHAR2(1000);
      l_label            VARCHAR2(1000);

   BEGIN

     IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;


      IF p_inputSize IS NOT NULL THEN
          l_inputSize :='col-' || l_default_label_size_type || '-' || p_inputSize;
      ELSE
          l_inputSize :='col-' || l_default_label_size_type || '-10';
      END IF;

      IF p_inputValue IS NOT NULL THEN
          l_inputValue := p_inputValue ;
      ELSE
          l_inputValue :='';
      END IF;

      IF p_RowSize  IS NOT NULL THEN
           l_RowSize :=' rows="' || p_RowSize || '" ';
      ELSE
          l_RowSize :='';
      END IF;

      IF p_attributes IS NOT NULL THEN
          l_attributes :=' ' || p_attributes;
      ELSE
          l_attributes :=' ';
      END IF;

      IF p_labelName IS NOT NULL THEN
         l_label:='  <label  class="' || l_labelSize ||' control-label" >' || p_labelName || '</label>';
      ELSE
         l_label:='';
      END IF;
      htp.p(l_label);
      htp.p('  <div class="' || l_inputSize || '">');
      htp.p('    <textarea class="form-control input-sm" id="' || p_inputName || '" name="' || p_inputName || '" ' || l_RowSize || l_attributes || '>' || l_inputValue  || '</textarea>');
      htp.p('  </div>');

   END InputTextBoxArea;



   FUNCTION SelectList (
         p_table          IN  VARCHAR2,
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
         p_name           IN  VARCHAR2 DEFAULT NULL,
         p_label_name     IN  VARCHAR2 DEFAULT NULL,
         p_select_size    IN  NUMBER DEFAULT NULL

   ) RETURN VARCHAR2

   IS

      l_name        VARCHAR2(1000);
      l_stmt        VARCHAR2(32767);
      l_df          VARCHAR2(512);
      l_vf          VARCHAR2(255);
      rue           VARCHAR2(32767);

      l_openGroup    VARCHAR2(2000);
      l_closeGroup   VARCHAR2(1000);
      l_select_size  VARCHAR2(1000);
      l_label        VARCHAR2(1000);

      TYPE LOVCurType IS REF CURSOR;
      c  LOVCurType;

   BEGIN

      IF p_name IS NOT NULL THEN
          l_name := p_name;
      ELSE
          l_name := LOWER(NVL(p_param, p_value_field));
      END IF;


      IF p_select_size IS NOT NULL THEN
          l_select_size :='col-' || l_default_label_size_type || '-' || p_select_size;
      ELSE
          l_select_size :='col-' || l_default_label_size_type || '-10';
      END IF;

      IF p_label_name IS NOT NULL THEN
         l_label :='<label class="col-' || l_default_label_size_type || '-'|| l_default_label_size ||' control-label" >' || p_label_name || '</label>';
      ELSE
         l_label :='';
      END IF;

      l_openGroup :='<div class="form-group">'|| l_label ||'<div class="' || l_select_size || '">';
      l_closeGroup :='</div></div>';


      IF p_multiple IS NOT NULL THEN
          rue := l_openGroup || '<select class="form-control input-sm" id="p_'|| l_name || '" name=' || '"p_' || l_name || '" ' || p_multiple || ' SIZE=' || p_size || ' ' || p_attributes || '>';
      ELSE
          rue := l_openGroup || '<select class="form-control input-sm" id="p_'|| l_name || '" name=' || '"p_' || l_name || '" ' || p_attributes || '>';
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

      rue := rue || '</select>' || l_closeGroup;

      RETURN rue;

   END;

      FUNCTION YesNo (p_field        IN  VARCHAR2,
                       p_value       IN  VARCHAR2 DEFAULT NULL,
                       p_attributes  IN  VARCHAR2 DEFAULT NULL,
                       p_mandatory   IN  VARCHAR2 DEFAULT 'N',
                       p_label_name  IN  VARCHAR2 DEFAULT NULL,
                       p_label_size  IN  NUMBER   DEFAULT NULL,
                       p_select_size IN  NUMBER DEFAULT NULL) RETURN VARCHAR2
      IS
         rue            VARCHAR2(2000);
         str            VARCHAR2(2000);
         l_openGroup    VARCHAR2(2000);
         l_closeGroup   VARCHAR2(1000);
         l_label_size   VARCHAR2(1000);
         l_select_size  VARCHAR2(1000);
         l_label        VARCHAR2(1000);

      BEGIN

      IF p_label_size IS NOT NULL THEN
          l_label_size :=' col-' || l_default_label_size_type || '-' || p_label_size;
      ELSE
          l_label_size :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;


      IF p_select_size IS NOT NULL THEN
          l_select_size :='col-' || l_default_label_size_type || '-' || p_select_size;
      ELSE
          l_select_size :='col-' || l_default_label_size_type || '-10';
      END IF;

      IF p_label_name IS NOT NULL THEN
          l_label :='<label class="' || l_label_size ||' control-label" >' || p_label_name || '</label>';
      ELSE
          l_label :='';
      END IF;

         l_openGroup :='<div class="form-group">' || l_label || '<div class="' || l_select_size || '">';
         l_closeGroup :='</div></div>';

         rue := l_openGroup || '<select class="form-control input-sm" id="p_' || p_field || '" name="p_' || p_field || '" ' || p_attributes || '>';

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

         rue := rue || '</SELECT>' || l_closeGroup;

         RETURN rue;
      END;



      PROCEDURE YesNo (p_field        IN  VARCHAR2,
                       p_value       IN  VARCHAR2 DEFAULT NULL,
                       p_attributes  IN  VARCHAR2 DEFAULT NULL,
                       p_mandatory   IN  VARCHAR2 DEFAULT 'N',
                       p_label_name  IN  VARCHAR2 DEFAULT NULL,
                       p_label_size  IN  NUMBER   DEFAULT NULL,
                       p_select_size IN  NUMBER DEFAULT NULL,
                       p_Wrapper IN VARCHAR2 DEFAULT 'Y'
                       )

      IS
         l_openGroup    VARCHAR2(2000):='';
         l_closeGroup   VARCHAR2(1000):='';
         l_label_size   VARCHAR2(1000):='';
         l_select_size  VARCHAR2(1000):='';
         l_label        VARCHAR2(1000):='';

      BEGIN

      IF p_label_size IS NOT NULL THEN
          l_label_size :=' col-' || l_default_label_size_type || '-' || p_label_size;
      ELSE
          l_label_size :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;


      IF p_select_size IS NOT NULL THEN
          l_select_size :='col-' || l_default_label_size_type || '-' || p_select_size;
      ELSE
          l_select_size :='col-' || l_default_label_size_type || '-10';
      END IF;

      IF p_label_name IS NOT NULL THEN
          l_label :='<label class="' || l_label_size ||' control-label" >' || p_label_name || '</label>';
      ELSE
          l_label :='';
      END IF;
         htp.p(l_openGroup);
         htp.p(l_label);

      IF p_Wrapper='Y' THEN
         htp.p('<div class="' || l_select_size || '">');
      END IF;
         htp.p('<select class="form-control input-sm" id="p_' || p_field || '" name="p_' || p_field || '" ' || p_attributes || '>');

         IF p_mandatory = 'N' THEN
               htp.p('<option value=""></option>');
         END IF;

         IF p_value = '1' THEN
            htp.p('<option value="1" selected>Yes</option>');
            htp.p('<option value="0">No</option>');
         ELSIF p_value = '0' THEN
            htp.p('<option value="1">Yes</option>');
            htp.p('<option value="0" selected>No</option>');
         ELSE
            htp.p('<option value="1">Yes</option>');
            htp.p('<option value="0">No</option>');
         END IF;

         htp.p('</SELECT>');
      IF p_Wrapper='Y' THEN
         htp.p('</div>');
      END IF;
         htp.p(l_closeGroup);
      END YesNo;


   PROCEDURE ChargeType(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL)
   IS
   l_sel0 varchar(50):='';
   l_sel1 varchar(50):='';
   l_SelectSize      VARCHAR2(1000);
   l_labelSize       VARCHAR2(1000);

   BEGIN

      IF p_value=0  THEN l_sel0 := 'selected'; end if;
      IF p_value=1  THEN l_sel1 := 'selected'; end if;


      IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;

      IF p_SelectSize IS NOT NULL THEN
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || p_SelectSize;
      ELSE
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || l_default_input_size;
      END IF;


      htp.p('  <label class="' || l_labelSize || ' control-label" >Charge Type </label>');
      htp.p('  <div class="' || l_SelectSize || '">');
      htp.p('    <SELECT name="p_ds_type" class="form-control input-sm" >');
      htp.p('      <OPTION></OPTION>');
      htp.p('      <OPTION value="0" '|| l_sel0 ||' >FREE</OPTION>');
      htp.p('      <OPTION value="1" '|| l_sel1 ||' >CHARGE</OPTION>');
      htp.p('    </SELECT>');
      htp.p('  </div>');

   END ChargeType;

   PROCEDURE SysGroup(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL)
   IS
   l_sel1 varchar(50):='';
   l_sel2 varchar(50):='';
   l_sel3 varchar(50):='';
   l_sel4 varchar(50):='';
   l_SelectSize      VARCHAR2(1000);
   l_labelSize       VARCHAR2(1000);

   BEGIN

      IF p_value=1  THEN l_sel1 := 'selected'; end if;
      IF p_value=2  THEN l_sel2 := 'selected'; end if;
      IF p_value=3  THEN l_sel3 := 'selected'; end if;
      IF p_value=4  THEN l_sel4 := 'selected'; end if;


      IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;

      IF p_SelectSize IS NOT NULL THEN
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || p_SelectSize;
      ELSE
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || l_default_input_size;
      END IF;


      htp.p('  <label class="' || l_labelSize || ' control-label" >System Group </label>');
      htp.p('  <div class="' || l_SelectSize || '">');
      htp.p('    <SELECT name="p_sysgroup" class="form-control input-sm" >');
      htp.p('      <OPTION></OPTION>');
      htp.p('      <OPTION value="1" '|| l_sel1 ||' >Medical Clinic</OPTION>');
      htp.p('      <OPTION value="2" '|| l_sel2 ||' >Training</OPTION>');
      htp.p('      <OPTION value="3" '|| l_sel3 ||' >HR Policy</OPTION>');
      htp.p('      <OPTION value="4" '|| l_sel4 ||' >Employee Relations</OPTION>');
      htp.p('    </SELECT>');
      htp.p('  </div>');

   END SysGroup;

   PROCEDURE ProcType(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL)
   IS
   l_sel1 varchar(50):='';
   l_sel2 varchar(50):='';
   l_sel3 varchar(50):='';
   l_sel4 varchar(50):='';
   l_sel5 varchar(50):='';
   l_sel6 varchar(50):='';
   l_sel7 varchar(50):='';
   l_SelectSize      VARCHAR2(1000);
   l_labelSize       VARCHAR2(1000);

   BEGIN

      IF p_value='L'  THEN l_sel1 := 'selected'; end if;
      IF p_value='F'  THEN l_sel2 := 'selected'; end if;
      IF p_value='U'  THEN l_sel3 := 'selected'; end if;
      IF p_value='D'  THEN l_sel4 := 'selected'; end if;
      IF p_value='J'  THEN l_sel5 := 'selected'; end if;
      IF p_value='T'  THEN l_sel6 := 'selected'; end if;
      IF p_value='R'  THEN l_sel7 := 'selected'; end if;


      IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;

      IF p_SelectSize IS NOT NULL THEN
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || p_SelectSize;
      ELSE
          l_SelectSize :=' col-' || l_default_label_size_type || '-' || l_default_input_size;
      END IF;


      htp.p('  <label class="' || l_labelSize || ' control-label" >Procedure Type </label>');
      htp.p('  <div class="' || l_SelectSize || '">');
      htp.p('    <SELECT name="p_proc_type" class="form-control input-sm" >');
      htp.p('      <OPTION></OPTION>');
      htp.p('      <OPTION value="L" '|| l_sel1 ||' >List</OPTION>');
      htp.p('      <OPTION value="F" '|| l_sel2 ||' >Form</OPTION>');
      htp.p('      <OPTION value="U" '|| l_sel3 ||' >Update</OPTION>');
      htp.p('      <OPTION value="D" '|| l_sel4 ||' >Delete</OPTION>');
      htp.p('      <OPTION value="J" '|| l_sel5 ||' >JSON</OPTION>');
      htp.p('      <OPTION value="T" '|| l_sel6 ||' >Filter</OPTION>');
      htp.p('      <OPTION value="R" '|| l_sel7 ||' >Report</OPTION>');
      htp.p('    </SELECT>');
      htp.p('  </div>');

   END ProcType;


   PROCEDURE Button(p_Id  IN VARCHAR2, p_Name IN VARCHAR2,p_type IN VARCHAR2 DEFAULT NULL, p_onclick IN VARCHAR2 DEFAULT NULL, p_data_toggle IN VARCHAR2 DEFAULT NULL, p_data_target IN VARCHAR2 DEFAULT NULL )
   IS
      l_onclick       VARCHAR2(1000);
      l_data_toggle   VARCHAR2(1000);
      l_data_target   VARCHAR2(1000);
      l_text               varchar2(1000):=p_Name;
       l_type               VARCHAR2(1000);
   BEGIN

      IF p_type  IS NOT NULL THEN
          l_type := ' type="' || p_type || '"';
      ELSE
          l_type :='';
      END IF;

      IF p_onclick  IS NOT NULL THEN
          l_onclick := ' onclick="' || p_onclick || '"';
      ELSE
          l_onclick :='';
      END IF;

      IF p_data_toggle IS NOT NULL THEN
          l_data_toggle := ' data-toggle="' || p_data_toggle || '"';
      ELSE
          l_data_toggle :='';
      END IF;

      IF p_data_target IS NOT NULL THEN
          l_data_target := ' data-target="' || p_data_target || '"';
      ELSE
          l_data_target :='';
      END IF;


   htp.p('<button id="'|| p_Id ||'" class="btn btn-primary btn-'|| l_default_button_size ||'"'|| l_type|| l_onclick || l_data_toggle || l_data_target ||'   >');


    l_text:= GetIcon(p_Name) || p_Name;
   htp.p(l_text);
   htp.p('</button>');

   END Button;




   FUNCTION GetIcon(p_Name IN  VARCHAR2) RETURN VARCHAR2
   IS

      l_icon               VARCHAR2(1000):='<span class="glyphicon glyphicon-';
      l_text               varchar2(1000):='';
      l_Name               varchar2(1000):=p_Name;

   BEGIN
      IF UPPER(l_Name)='SEARCH' THEN
            l_text:= l_icon ||  'search"></span> ';
      END IF;
      IF UPPER(l_Name)='ADD' THEN
            l_text:= l_icon ||  'plus-sign"></span> ';
      END IF;
      IF UPPER(l_Name)='DELETE' THEN
            l_text:= l_icon ||  'trash"></span> ';
      END IF;
      IF UPPER(l_Name)='CLOSE' THEN
            l_text:= l_icon ||  'off"></span> ';
      END IF;
      IF UPPER(l_Name)='SAVE' THEN
            l_text:= l_icon ||  'floppy-disk"></span> ';
      END IF;
      IF UPPER(l_Name)='RESET' THEN
            l_text:= l_icon ||  'retweet"></span> ';
      END IF;

   RETURN l_text;

   END;


   PROCEDURE OpenFormGroup(p_additional_class IN VARCHAR2 DEFAULT NULL)
   IS
      l_additional_class varchar2(1000);

   BEGIN

      IF p_additional_class IS NOT NULL THEN
          l_additional_class := ' ' || p_additional_class || '"';
      ELSE
          l_additional_class :='';
      END IF;

      htp.p('<div class="form-group'|| l_additional_class ||'">');

   END OpenFormGroup;

   PROCEDURE CloseFormGroup
   IS
   BEGIN
         htp.p('</div>');
   END CloseFormGroup;

   PROCEDURE OpenDiv(p_class IN VARCHAR2 DEFAULT NULL)
   IS
      l_class varchar2(1000);

   BEGIN

      IF p_class IS NOT NULL THEN
          l_class := ' class="'|| p_class ||'"';
      ELSE
          l_class :='';
      END IF;

      htp.p('<div '|| l_class ||'>');

   END OpenDiv;


   PROCEDURE CloseDiv
   IS
   BEGIN
         htp.p('</div>');
   END CloseDiv;



   PROCEDURE AddEmptyColumn(p_size IN NUMBER)
   IS
   BEGIN
         htp.p('<div class="col-'|| l_default_label_size_type ||'-'|| p_size ||'"></div>');

   END AddEmptyColumn;




   PROCEDURE Label(p_Value IN VARCHAR2,p_Size IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL)
   IS
      l_Size            VARCHAR2(1000);
      l_Value           VARCHAR2(1000);
      l_attributes      VARCHAR2(1000);
      l_label           VARCHAR2(1000);

   BEGIN
      IF p_Size IS NOT NULL THEN
          l_Size :=' col-' || l_default_label_size_type || '-' || p_Size;
      ELSE
          l_Size :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;


      IF p_attributes IS NOT NULL THEN
          l_attributes :=' ' || p_attributes;
      ELSE
          l_attributes :=' ';
      END IF;


      htp.p('<label class="' || l_Size ||' control-label" >' || p_Value || '</label>');


   END Label;


   PROCEDURE OpenEntryForm
   IS
   BEGIN
      htp.p('<div class="container-fluid">');
      htp.p('<div class="form-horizontal">');
      htp.p('<div class="row col-xs-12">&nbsp;</div>');
   END OpenEntryForm;

   PROCEDURE CloseEntryForm
   IS
   BEGIN
      htp.p('</div>');
      htp.p('</div>');
   END CloseEntryForm;


   PROCEDURE SelectBox(p_labelName  IN VARCHAR2 DEFAULT NULL, p_Name IN VARCHAR2, p_labelSize IN NUMBER DEFAULT NULL, p_selectSize IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL, p_Wrapper IN VARCHAR2 DEFAULT 'Y' )
   IS
      l_selectSize      VARCHAR2(1000);
      l_attributes      VARCHAR2(1000);
      l_labelSize       VARCHAR2(1000);
      l_label           VARCHAR2(1000);

   BEGIN
      IF p_selectSize IS NOT NULL THEN
          l_selectSize :=' col-' || l_default_label_size_type || '-' || p_selectSize;
      ELSE
          l_selectSize :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
      END IF;

      IF p_labelSize IS NOT NULL THEN
          l_labelSize :=' col-' || l_default_label_size_type || '-' || p_labelSize;
      ELSE
          l_labelSize :=' col-' || l_default_label_size_type || '-' || l_default_input_size;
      END IF;

      IF p_attributes IS NOT NULL THEN
          l_attributes :=' ' || p_attributes;
      ELSE
          l_attributes :=' ';
      END IF;

      IF p_labelName IS NOT NULL THEN
         l_label:='  <label class="' || l_labelSize ||' control-label" >' || p_labelName || '</label>';
      ELSE
         l_label:='';
      END IF;


      htp.p(l_label);
      IF p_Wrapper='Y' THEN
         htp.p(' <div class="' || l_selectSize || '">');
      END IF;

      htp.p('    <select  class="form-control input-sm" id="' || p_Name || '" name="' || p_Name || '" ' || l_attributes || '></select>');

      IF p_Wrapper='Y' THEN
         htp.p('  </div>');
      END IF;

   END SelectBox;


   PROCEDURE ShowPagingCtrl
   IS
   BEGIN
      htp.p('<div class="pageholder">');
      htp.p('   <div class="pagectrl">');
      htp.p('      <label id="page">Page </label>');
      htp.p('      <select onchange="gotoPage(this)" id="p_page_no" name="p_page_no"> </select>');
      htp.p('      <label id="of"> </label>');
      htp.p('   </div>');
      htp.p('   <div class="pagestatus"></div>');
      htp.p('</div>');
   END ShowPagingCtrl;





   PROCEDURE OpenTag(p_TagName  IN VARCHAR2 DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL)
   IS

   BEGIN
         htp.p('<' || p_TagName  || ' ' || p_attributes  || '>');

   END OpenTag;


   PROCEDURE CloseTag(p_TagName  IN VARCHAR2 DEFAULT NULL)
   IS

   BEGIN

         htp.p('</' || p_TagName  || '>');

   END CloseTag;



   PROCEDURE ButtonDelete(p_Table  IN VARCHAR2 DEFAULT NULL,p_Value  IN VARCHAR2 DEFAULT NULL)
   IS

   BEGIN
         htp.p('<a id="delete-row" href="javascript:void(0);" table="' || p_Table || '" value="'  || p_Value || '"><span class="glyphicon glyphicon-trash"></span> </a>');
   END ButtonDelete;

   PROCEDURE Offset(p_Size  IN NUMBER)
   IS

   BEGIN

         htp.p('<div class="col-'|| l_default_label_size_type ||'-'|| p_Size ||'"></div>');

   END Offset;


   PROCEDURE CMonths (p_field        IN  VARCHAR2,
                      p_value       IN  VARCHAR2 DEFAULT NULL,
                      p_attributes  IN  VARCHAR2 DEFAULT NULL,
                      p_mandatory   IN  VARCHAR2 DEFAULT 'N',
                      p_label_name  IN  VARCHAR2 DEFAULT NULL,
                      p_label_size  IN  NUMBER   DEFAULT NULL,
                      p_select_size IN  NUMBER DEFAULT NULL,
                      p_Wrapper IN VARCHAR2 DEFAULT 'Y'
                      )

   IS
      l_openGroup    VARCHAR2(2000):='';
      l_closeGroup   VARCHAR2(1000):='';
      l_label_size   VARCHAR2(1000):='';
      l_select_size  VARCHAR2(1000):='';
      l_label        VARCHAR2(1000):='';
      l_date         DATE;
      l_selected     VARCHAR2(20);
   BEGIN

   IF p_label_size IS NOT NULL THEN
       l_label_size :=' col-' || l_default_label_size_type || '-' || p_label_size;
   ELSE
       l_label_size :=' col-' || l_default_label_size_type || '-' || l_default_label_size;
   END IF;


   IF p_select_size IS NOT NULL THEN
       l_select_size :='col-' || l_default_label_size_type || '-' || p_select_size;
   ELSE
       l_select_size :='col-' || l_default_label_size_type || '-10';
   END IF;

   IF p_label_name IS NOT NULL THEN
       l_label :='<label class="' || l_label_size ||' control-label" >' || p_label_name || '</label>';
   ELSE
       l_label :='';
   END IF;
      htp.p(l_openGroup);
      htp.p(l_label);

      IF p_Wrapper='Y' THEN
         htp.p('<div class="' || l_select_size || '">');
      END IF;
      htp.p('<select class="form-control input-sm" id="p_' || p_field || '" name="p_' || p_field || '" ' || p_attributes || '>');

      IF p_mandatory = 'N' THEN
            htp.p('<option value=""></option>');
      END IF;

      FOR i IN 1..12 LOOP
         l_selected := '';
         IF p_value = i THEN
            l_selected := 'selected';
         END IF;
         l_date := TO_DATE(i||'/1/2014','MM/DD/YYYY');
         htp.p('<option value="'|| i ||'" '|| l_selected ||'>'|| TO_CHAR(l_date,'Month') ||'</option>');
      END LOOP;

      htp.p('</SELECT>');
      IF p_Wrapper='Y' THEN
         htp.p('</div>');
      END IF;
      htp.p(l_closeGroup);

   END CMonths;

END;
/
SHOW ERRORS