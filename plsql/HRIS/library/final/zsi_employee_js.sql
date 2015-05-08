SET SCAN OFF
CREATE OR REPLACE
PROCEDURE zsi_employee_js  AS

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
   17-JUL-14  GF    New
*/
   l_dhtmlx_path           VARCHAR2(100) := zsi_lib.DHTMLXPath;


 BEGIN NULL;
 owa_util.mime_header('application/javascript');
htp.prn('
');
htp.prn('
');
htp.prn('

/*variable declaration*/
var ctrlSel = zsi.control.SelectList;


/*end of declaration*/



   //on page loaded
   $(document).ready(function(){
      dhtmlxWin = new dhtmlXWindows();
      dhtmlxWin.setImagePath("');
htp.prn( l_dhtmlx_path );
htp.prn('dhtmlxWindows/codebase/imgs/");

      p_empl_id_no        = $("#p_empl_id_no");
      p_empl_name         = $("#p_empl_name");
      p_empl_type_desc    = $("#p_empl_type_desc");
      p_empl_job_desc     = $("#p_empl_job_desc");
      p_empl_cc_desc      = $("#p_empl_cc_desc");
      p_empl_dept_desc    = $("#p_empl_dept_desc");
      p_empl_group_desc   = $("#p_empl_group_desc");
      p_empl_type         = $("#p_empl_type");
      p_cost_center       = $("#p_cost_center");
      p_department        = $("#p_department");
      p_group_code        = $("#p_group_code");
      p_age_brak_code     = $("#p_age_brak_code");


   });


   function attachURL(winURL,winTitle,winWidth,winHeight) {
      if (dhtmlxWin.isWindow("w1")) w1.close();
      w1 = dhtmlxWin.createWindow("w1", 10, 20, winWidth, winHeight);
      w1.setModal(true);
      w1.button("close").enable();
      w1.button("minmax1").enable();
      w1.button("minmax2").enable();
      w1.button("park").hide();
      w1.setText(winTitle);
      w1.attachURL(winURL);
   }

   function EmpLOV () {
      if (document.frmList.p_empl_name.value=="" && document.frmList.p_empl_id_no.value=="" ) {
         alert("Please enter at least 1 character in Employee Id No or Employee Name")
         return false;
      }
      var url = "employees_lov?p_form=frmList&p_empl_id_no=" + document.frmList.p_empl_id_no.value + "&p_empl_name=" + document.frmList.p_empl_name.value;
      url += "&p_out_empl_id_no=p_empl_id_no&p_out_empl_name=p_empl_name" +
             "&p_out_empl_dept_desc=p_empl_dept_desc" +
             "&p_out_empl_cc_desc=p_empl_cc_desc&p_out_empl_group_desc=p_empl_group_desc" +
             "&p_out_empl_job_desc= p_empl_job_desc";

      if(p_age_brak_code.length>0) url +="&p_out_age_brak_code= p_age_brak_code";
      if(p_empl_type.length>0) url +="&p_out_empl_type=p_empl_type";
      if(p_empl_type_desc.length>0) url +="&p_out_empl_type_desc=p_empl_type_desc";
      if(p_cost_center.length>0) url +="&p_out_cost_center=p_cost_center";
      if(p_department.length>0) url +="&p_out_department= p_department";
      if(p_group_code.length>0) url +="&p_out_group_code=p_group_code";

      attachURL(url,"Employees List",550,400);
   }


  $("#p_empl_id_no").keyup(function(){
       var ctrlId =  this.id;
      if(this.value){
         if($.trim(this.value)!=""){
            $.getJSON("employee_active_json?p_empl_id_no=" + this.value,function(jsonData){
               ClearAll(ctrlId);
               if(jsonData.rows[0]){
                  p_empl_name.val(jsonData.rows[0].data[43]);
                  p_empl_type_desc.val(jsonData.rows[0].data[44]);
                  p_empl_job_desc.val(jsonData.rows[0].data[48]);
                  p_empl_cc_desc.val(jsonData.rows[0].data[45]);
                  p_empl_dept_desc.val(jsonData.rows[0].data[46]);
                  p_empl_group_desc.val(jsonData.rows[0].data[47]);
                  p_empl_type.val(jsonData.rows[0].data[1]);
                  p_cost_center.val(jsonData.rows[0].data[18]);
                  p_department.val(jsonData.rows[0].data[41]);
                  p_group_code.val(jsonData.rows[0].data[42]);
                  p_age_brak_code.val(jsonData.rows[0].data[50]);
               }

            });
          }
       }

  });

 $("#p_empl_id_no").keypress(function(event){
   return zsi.form.checkNumber(event);
 });

$("#p_empl_name").keyup(function(){
   if(this.value.length==0){
      ClearAll(this.id);
      return false;
   }
});


function ClearAll(ctrlId){
   if(ctrlId!=p_empl_id_no.attr("id"))
         p_empl_id_no.val("");
   else
         p_empl_name.val("");

   p_empl_type_desc.val("");
   p_empl_job_desc.val("");
   p_empl_cc_desc.val("");
   p_empl_dept_desc.val("");
   p_empl_group_desc.val("");
   p_empl_type.val("");
   p_cost_center.val("");
   p_department.val("");
   p_group_code.val("");
   p_age_brak_code.val("");
}




');
 END;
/
SHOW ERRORS
