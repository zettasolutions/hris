SET SCAN OFF
CREATE OR REPLACE
PACKAGE zsi_bs_lib IS


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


      PROCEDURE OpenPanel (p_title VARCHAR2);
      PROCEDURE ClosePanel;
      PROCEDURE OpenModalWindow(p_modalId IN VARCHAR2,p_title IN VARCHAR2,p_formId IN VARCHAR2,p_actionName IN VARCHAR2, p_method IN VARCHAR2 DEFAULT 'GET');
      PROCEDURE CloseModalWindow(p_buttonType IN VARCHAR2,p_buttonName IN VARCHAR2,p_btn_attributes IN VARCHAR2 DEFAULT NULL);
      PROCEDURE InputHiddenBox(p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL);
      PROCEDURE InputTextBox(p_labelName  IN VARCHAR2 DEFAULT NULL, p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_inputSize IN NUMBER DEFAULT NULL,p_type IN VARCHAR2 DEFAULT NULL, p_placeholder IN VARCHAR2 DEFAULT NULL,p_inputclass IN VARCHAR2 DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL, p_Wrapper IN VARCHAR2 DEFAULT 'Y');
      PROCEDURE InputTextBoxArea(p_labelName  IN VARCHAR2, p_inputName IN VARCHAR2, p_inputValue IN VARCHAR2 DEFAULT NULL, p_labelSize IN NUMBER DEFAULT NULL, p_inputSize IN NUMBER DEFAULT NULL,p_RowSize IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL);
      PROCEDURE InputIdName(p_labelSize IN NUMBER DEFAULT NULL);      
      PROCEDURE OpenFormGroup(p_additional_class IN VARCHAR2 DEFAULT NULL);
      PROCEDURE CloseFormGroup;
      PROCEDURE OpenDiv(p_class VARCHAR2 DEFAULT NULL);
      PROCEDURE CloseDiv;
      PROCEDURE AddEmptyColumn(p_size NUMBER);
      PROCEDURE Label(p_Value IN VARCHAR2,p_Size IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL);
      PROCEDURE OpenEntryForm;
      PROCEDURE CloseEntryForm;

    FUNCTION SelectList (p_table          IN  VARCHAR2,
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
            p_label_name       IN  VARCHAR2 DEFAULT NULL,
            p_select_size   IN  NUMBER DEFAULT NULL
      ) RETURN VARCHAR2;

   FUNCTION YesNo (p_field      IN  VARCHAR2,
                   p_value      IN  VARCHAR2 DEFAULT NULL,
                   p_attributes IN  VARCHAR2 DEFAULT NULL,
                   p_mandatory  IN  VARCHAR2 DEFAULT 'N',
                   p_label_name  IN  VARCHAR2 DEFAULT NULL,
                   p_label_size   IN  NUMBER   DEFAULT NULL,
                   p_select_size IN  NUMBER DEFAULT NULL

      ) RETURN VARCHAR2;


   PROCEDURE YesNo (p_field      IN  VARCHAR2,
                   p_value      IN  VARCHAR2 DEFAULT NULL,
                   p_attributes IN  VARCHAR2 DEFAULT NULL,
                   p_mandatory  IN  VARCHAR2 DEFAULT 'N',
                   p_label_name  IN  VARCHAR2 DEFAULT NULL,
                   p_label_size   IN  NUMBER   DEFAULT NULL,
                   p_select_size IN  NUMBER DEFAULT NULL,
                   p_Wrapper IN VARCHAR2 DEFAULT 'Y'
      );


   PROCEDURE ChargeType(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL);
   PROCEDURE SysGroup(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL);
   PROCEDURE ProcType(p_value IN  VARCHAR2 DEFAULT NULL,p_labelSize IN NUMBER DEFAULT NULL, p_SelectSize IN NUMBER DEFAULT NULL);
   PROCEDURE Button(p_Id  IN VARCHAR2, p_Name IN VARCHAR2, p_type IN VARCHAR2 DEFAULT NULL, p_onclick IN VARCHAR2 DEFAULT NULL, p_data_toggle IN VARCHAR2 DEFAULT NULL, p_data_target IN VARCHAR2 DEFAULT NULL );
   FUNCTION GetIcon(p_Name IN  VARCHAR2) RETURN VARCHAR2;
   PROCEDURE SelectBox(p_labelName  IN VARCHAR2 DEFAULT NULL, p_Name IN VARCHAR2, p_labelSize IN NUMBER DEFAULT NULL, p_selectSize IN NUMBER DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL, p_Wrapper IN VARCHAR2 DEFAULT 'Y' );
   PROCEDURE ShowPagingCtrl;
   PROCEDURE OpenTag(p_TagName  IN VARCHAR2 DEFAULT NULL, p_attributes IN VARCHAR2 DEFAULT NULL);
   PROCEDURE CloseTag(p_TagName  IN VARCHAR2 DEFAULT NULL);

   PROCEDURE ButtonDelete(p_Table IN VARCHAR2 DEFAULT NULL,p_Value  IN VARCHAR2 DEFAULT NULL);
   PROCEDURE Offset(p_Size  IN NUMBER);

   PROCEDURE CMonths (p_field       IN  VARCHAR2,
                      p_value       IN  VARCHAR2 DEFAULT NULL,
                      p_attributes  IN  VARCHAR2 DEFAULT NULL,
                      p_mandatory   IN  VARCHAR2 DEFAULT 'N',
                      p_label_name  IN  VARCHAR2 DEFAULT NULL,
                      p_label_size  IN  NUMBER   DEFAULT NULL,
                      p_select_size IN  NUMBER DEFAULT NULL,
                      p_Wrapper     IN VARCHAR2 DEFAULT 'Y'
                      );

END zsi_bs_lib;
/