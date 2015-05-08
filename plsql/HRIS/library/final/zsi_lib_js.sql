SET SCAN OFF
CREATE OR REPLACE
PROCEDURE zsi_lib_js  AS

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
---------  ----  -------------------------------------------------------------------------------------------
AUG-03-14  GF    Added tab navigation.
JUL-31-14  GF    Modified SelectList function for select class or jquery "selector" having multiple elements.
JUL-26-14  GF    Added zsi.control.SelectList function.
JUL-25-14  GF    Added zsi.form.DisplayRecordPage function.
JUL-04-14  GF    Added parameter ResizeGrid.
JUL-02-14  GF    Added  zsi.table.dhtmlx.ResizeGrid function.
JUN-29-14  GF    New

*/

 BEGIN NULL;
 owa_util.mime_header('application/javascript');
htp.prn('
');
htp.prn('
');
htp.prn('

/* JS Package Names or Namespaces */
   var zsi = new function(){};
   zsi.form = new function(){};
   zsi.table = new function(){};
   zsi.table.dhtmlx = new function(){};
   zsi.page = new function(){};
   zsi.control = new function(){};
   zsi.calendar = new function(){};
/* -------------------------------*/


/* Page Initialization */

$(document).ready(function(){

   $(''[id*=date]'').datepicker({
           format: ''mm/dd/yyyy''
           ,autoclose:true
   }).on(''show'', function(e){

       var dhtmlxForm=$(".dhtmlx_skin_dhx_skyblue .form-horizontal");

        var l_dp     = $(''.datepicker'');

        if(dhtmlxForm.length>0){
           var l_window = $(parent.w1)
           var l_offset = $(this).offset();
           var l_left="";
           var l_top="";
           if(l_offset.left>l_window.width() - l_dp.width())
               l_left=parseInt(l_offset.left - l_dp.width()) + "px";
           else
               l_left=parseInt(l_offset.left) + "px";

           if(l_offset.top>l_window.height()- (l_dp.height()+100))
               l_top= parseInt(l_offset.top - l_dp.height() ) + "px";
           else
               l_top=parseInt(l_offset.top + ($(this).height()*2) ) + "px";

           l_dp.css({top:l_top, left:l_left});
        }


        var highest = -999;

        $("*").each(function() {
            var current = parseInt($(this).css("z-index"), 10);
            if(current && highest < current) highest = current;
        });

        l_dp.css("z-index",highest + 1);


   });


   /*tab navigation*/
   $(".nav-tabs li").each(function(){
      $(this).click(function(){
         $(".nav-tabs li").removeClass("active");
         $(this).addClass("active" );
          var l_a=$(this).children("a")[0];
          var l_clsTabPagesName =".tab-pages";
          var l_tab = $( l_clsTabPagesName + " #" + l_a.id);

          l_tab.parent().children().each(function(){
            $(this).removeClass("active");
          });
          l_tab.addClass("active" );
      });

   });
   /*end of tab navigation*/


   /*adjustment form with search*/
   var searchIcon=$(".form-group .glyphicon-search");
   if(searchIcon.length>0){
      $(document.body).css("margin-left","10px");
      $(document.body).css("margin-right","10px");
   }
   /*---------------------------*/


   /*----------delete record------*/
   $("a[id=delete-row]").click(function(){
      var value = $(this).attr("value");
      var table = $(this).attr("table");
      var tr = $(this.parentNode.parentNode);

      if(confirm("Are you sure you want to delete this Item?")) {
         $.post("s004_delete?p_table=" + table + "&p_field=seq_no&p_value=" + value,
            function(d){
               tr.remove();
            }).fail(function(d) {
               alert("Sorry, the curent transaction is not successfull.");
         });
      }

   });
   /*----end of delete record-----------*/

});


   zsi.table.getCheckBoxesValues = function(){
/*Example:
  [3-parameters]:
  var x= zsi.table.getCheckBoxesValues("input[name=p_cb]:checked","p_del_ds=","&");
   result: p_del_ds=1031&p_del_ds=1032&p_del_ds=1027

  [1-parameters]:
  var x= zsi.table.getCheckBoxesValues("input[name=p_cb]:checked");
  result:  ["1031", "1027"]

*/
    var args = arguments;
    var result=null;
    var _hidden= "input[type=hidden]";
    switch(args.length) {
      case 1: /* return type : Array */
                     var arrayItems = new Array();
                     var i=0;
                  var selectorCheckboxName=args[0];
                     $(selectorCheckboxName).each(function(){
                           arrayItems[i]=$(this.parentNode).children(_hidden).val();
                           i++;
                     });
                     result = arrayItems;
                  break;

      case 3: /* return type : string */
                  var params="";
                  var selectorCheckboxName=args[0];
                  var parameterValue         =args[1];
                  var separatorValue         =args[2];

                     $(selectorCheckboxName).each(function(){
                           var _value =   $(this.parentNode).children(_hidden).val();
                                 if(params!="") params = params + separatorValue;
                                 params = params + parameterValue + _value;
                     });
                     result = params;
                  break;

      default: break;
    }

   return result;
}
/*------------------------------------------------------------------------------------------*/
/*Example:
   zsi.table.dhtmlx.ResizeGrid(window,mygrid,''Y'');
*/
zsi.table.dhtmlx.ResizeGrid   = function(p_Window,p_dhtmlGrid){
   var ht=p_Window.innerHeight || p_Window.document.documentElement.clientHeight || p_Window.document.body.clientHeight;
      ht = ht - 76;
   p_dhtmlGrid.enableAutoHeight(true,ht,true);
   p_dhtmlGrid.setSizes();
}

/*Example:
   zsi.table.dhtmlx.Unescape(data,2);
   mygrid.parse(data, "json");
*/
zsi.table.dhtmlx.Unescape   = function(data,col_index){
   $.each(data.rows,function(){
      this.data[col_index]=unescape(this.data[col_index]);
   });
}

/*------------------------------------------------------------------------------------------*/
/*Example:
  <input type="checkbox" name="p_cb" onclick="zsi.table.setCheckBox(this,l_tran_no );">
*/
   zsi.table.setCheckBox = function(obj, cbValue){
   var _hidden= "input[type=hidden]";
      var _input =   $(obj.parentNode).children(_hidden);
      if(_input.attr("type")!=''hidden'') { alert(_hidden + " not found"); return;}

       if(obj.checked){
            _input.val(cbValue);
      }
      else{
            _input.val("");
      }
   }

/*------------------------------------------------------------------------------------------*/
/*Example:
   var jsonData = $.parseJSON(mygrid.xmlLoader.xmlDoc.responseText);
   zsi.page.DisplayRecordPage(jsonData.page_no,jsonData.page_rows,jsonData.row_count);
*/
zsi.page.DisplayRecordPage   = function(p_page_no,p_rows,p_numrec){
   var l_max_rows       =');
htp.prn(zsi_lib.MaxRowsInList);
htp.prn(';
   var l_last_page    = Math.ceil(p_rows/l_max_rows);
   var l_record_from    = (l_max_rows * (p_page_no-1)) + 1;
   var l_record_to      = parseInt(l_record_from) + parseInt(p_numrec) - 1;

   var l_select         = $("select[name=p_page_no]");
   l_select.clearSelect();
   for(var x=0;x<l_last_page;x++){
      var l_option;
       if (p_page_no==x+1){
             l_select.append("<option selected value=''" +  (x+1) + "''>"+ (x+1) +"</option>");
        }
        else{
             l_select.append("<option value=''" +  (x+1) + "''>"+ (x+1) +"</option>");

        }

   }

   $("#of").html('' of '' + l_last_page );
   $(".pagestatus").html("Showing records from <i>" + l_record_from + "</i> to <i>" + l_record_to + "</i>");

}
/*------------------------------------------------------------------------------------------*/
/*Example:
  SelectList("#p_vaccine_code","=l_vaccine_code","N","S004_T08005","vaccine_code","vaccine_name","");
*/
zsi.control.SelectList = function(p_selector,p_selval,p_req, p_table,p_value,p_text,p_con,p_onLoadComplete){
   var param =''?'';

   param += ''p_table='' + p_table;
   param += ''&p_value_field='' + p_value;
   param += ''&p_display_field='' + p_text;
   param += ''&p_condition='' + p_con;

   $.getJSON("zsi_lib.select_json" + param, function( data ) {
      if(p_selector instanceof jQuery)
         p_selector.fillSelect(data,p_selval,p_req,p_onLoadComplete);
      else
         $(p_selector).fillSelect(data,p_selval,p_req,p_onLoadComplete);
   });
}
/*--[zsi.calendar]------------------------------------------------------------------------------*/
zsi.calendar.LoadMonths = function(p_select){
   p_select.add(new Option(" ", ""),null);
   var monthNames = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ];
   for(var x=0;x<12;x++){
      var l_option = new Option(monthNames[x], x+1);
      p_select.add(l_option, null);
   }
}

zsi.form.checkNumber = function(e) {
   var keynum;
   var keychar;
   var numcheck;
   var allowedStr =''''

   for (i=1;i<arguments.length;i++) {
      allowedStr+=arguments[i];
   }
   if (window.event) {
      //IE
      keynum = e.keyCode;
   } else if (e.which) {
      //Netscape,Firefox,Opera
      keynum = e.which;
      if (keynum==8) return true; //backspace
      if (String.charCodeAt(keynum)=="91") return true;
   } else return true;

   keychar = String.fromCharCode(keynum);

   if (allowedStr.indexOf(keychar)!=-1) return true;
      numcheck = /\d/;
      return numcheck.test(keychar);
}

zsi.form.checkNumberFormat = function(o,e) {
   var regex = /(?=.)^\$?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\.[0-9]{1,4})?$/;
   var val = o.value;
   if (val!="") {
      var ok = regex.test(val);
       if (!ok) {
         alert("Please enter a valid number format.");
         setTimeout(function(){o.focus()}, 0);
       }
   }
}
/*Mandatory : private variables and function(s) */
zsi.form.__groupNames;
zsi.form.__groupTitles;

zsi.form.__checkMandatory=function(oGroupN, oGroupT){
var e = oGroupN.names;
var d = oGroupT.titles;
var l_irecords=[];
var l_firstArrObj;
   for(var x=0;x<e.length;x++){
      var l_obj = document.getElementsByName(e[x]);
     if(l_obj.length > 1){
         /* collect row-index if the row has a value */
         var l_index=0;
         for(var i=0;i<l_obj.length;i++){
            if(l_obj[i].type!="hidden"){
               if(!l_firstArrObj) l_firstArrObj = l_obj[i];
               if($.trim(l_obj[i].value)!="") {
                 l_irecords[l_index]=i;
                 l_index++;
               }
            }
         }

     }else{ /* single */
         if($.trim(l_obj[0].value)==""){
            l_obj[0].focus();
            alert("Enter " + d[x] + ".");
            return false;
         }
     }

   }
  /* multiple */
   if(oGroupN.type=="M"){
      if(oGroupN.required=="Y"){
         if(l_irecords.length==0){
            alert("Please enter at least 1 record.");
            if(l_firstArrObj) l_firstArrObj.focus();
            return false;
         }
      }
      for(var x=0;x<e.length;x++){
         var l_obj = document.getElementsByName(e[x]);
         if(l_obj.length > 1){
            for(var i=0;i<l_irecords.length;i++){
               if(l_obj[l_irecords[i]].type!="hidden"){
                  if($.trim(l_obj[l_irecords[i]].value)=="") {
                    l_obj[l_irecords[i]].focus();
                    alert("Enter " + d[x] + ".");
                    return false;
                  }
               }
            }
         }
      }
   }

   return true;
 }

/* Mandatory: public function(s) */
zsi.form.checkMandatory=function(){
   for(var x=0;x < zsi.form.__groupNames.length;x++){  /*loop per group objects*/
      if (!zsi.form.__checkMandatory( zsi.form.__groupNames[x], zsi.form.__groupTitles[x] ))
         return false;
   }
   return true;
}

zsi.form.markMandatory=function(groupNames,groupTitles){
zsi.form.__groupNames=groupNames;
zsi.form.__groupTitles=groupTitles;

var e;
for(var gn=0;gn< groupNames.length;gn++){  /*loop per groupNames*/
   e = groupNames[gn].names;

   var border ="solid 2px #F3961C";
 //  setTimeout(function(){
      for(var x=0;x< e.length;x++){
         var elements = document.getElementsByName(e[x]);
         if(elements.length == 1){ /* single */
            var o=$("#" + e[x]);
            changeborder(o[0],border);
            o.on(''change keyup blur'', function() {
               changeborder(this,border);
            });

         }else{ /* multiple */
         $("*[name=''" +  e[x] + "''][type!=hidden]").each(function(){
            changeborder(this,border);
            $(this).on(''change keyup blur'', function() {
               if($(this).val()!=""){
                  $("*[name=''" +  this.name + "''][type!=hidden]").each(function(){
                     $(this).css("border","solid 1px #ccc");
                  });
               }
               else{
                  /* check input elements if there''s a value */
                  var hasValue=false;
                  $("*[name=''" +  this.name + "''][type!=hidden]").each(function(){
                      if($(this).val()!="") hasValue=true;
                  });

                  /* start changing border */
                  $("*[name=''" +  this.name + "''][type!=hidden]").each(function(){
                     if(hasValue){
                        $(this).css("border","solid 1px #ccc");
                     }
                     else{
                        $(this).css("border-left",border);
                        $(this).css("border-right",border);
                     }
                  });

               }
            });

         });

         }
      }
 //  },0);


} /* end of group loop */

   function changeborder(o,border){
      jo = $(o);
      if(jo.val() == undefined || jo.val()==""){
         jo.css("border-left",border);
         jo.css("border-right",border);
      }else{
         jo.css("border","solid 1px #ccc");
      }
   }

}

/* ----[ End Mandatory ]-----  */
/*test*/



/*end test*/


 zsi.form.checkDate=function(e, d){
 var l_format_msg=" must be in [mm/dd/yyyy] format.";
    for(var x=0;x<e.length;x++){
       var l_obj = document.getElementsByName(e[x]);

      if(l_obj.length > 1){
          /* multiple */
          var l_index=0;
          for(var i=0;i<l_obj.length;i++){
             if(l_obj[i].type!="hidden"){
                if($.trim(l_obj[i].value)!=""){
                   if( isValidDate(l_obj[i].value)!=true){
                      alert(d[x] + l_format_msg);
                      l_obj[i].focus();
                      return false;
                   }
                }
             }
          }

      }
      else{ /* single */
         if($.trim(l_obj[0].value)!=""){
            if( isValidDate(l_obj[0].value)!=true){
              alert(d[x] + l_format_msg);
              l_obj[0].focus();
              return false;
            }
         }

      }

    }

    return true;
  }


 function isValidDate(l_date){
    var comp = l_date.split(''/'');
    var m = parseInt(comp[0], 10);
    var d = parseInt(comp[1], 10);
    var y = parseInt(comp[2], 10);
    var date = new Date(y,m-1,d);
    if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
      return true;
    }
    else {
      return false;
    }
}


/*----[ extended-JQuery Function ]--------------------------------------------------------------*/

$.fn.clearSelect = function() {

    if(this.length>1){
       $(this).each(function(){
           _clear(this);
       });
    }
    else if(this.length==1){
       _clear(this[0]);
    }


   function _clear(o){
       if (o) {
           if (o.tagName.toLowerCase() == "select") {
               o.options.length = 0;
           }
       }
   }

}

$.fn.fillSelect = function(data,p_selval,p_req,p_onLoadComplete) {
    this.clearSelect();

    if(this.length>1){
       $(this).each(function(){
           _load(this);
       });
    }
    else if(this.length==1){
       _load(this[0]);
    }

   function _load(ddl){
          var reqIndex=0;
       if (ddl) {
           if (ddl.tagName.toLowerCase() == ''select'') {
               if(p_req=="N"){
                  var l_option_blank = new Option("", "");
                  ddl.add(l_option_blank, null);
                  reqIndex=1;
               }
               $.each(data, function(index, optionData) {
                  var l_option = new Option(unescape(optionData.text), optionData.value);
                  ddl.add(l_option, null);
                  if(optionData.value==p_selval){
                     ddl.selectedIndex=parseInt(index + reqIndex );
                  }
               });

               var selval = $(ddl).attr("selectedvalue");
               if(selval){
                     $(ddl).children("option").each(function(i){
                        if (selval==this.value){
                           ddl.selectedIndex = i;
                           return false;
                        }
                     });
               }
               $(ddl).removeAttr("selectedvalue");

               if(p_onLoadComplete) {
                  ddl.LoadComplete = p_onLoadComplete;
                  ddl.LoadComplete();
               }

           }
       }

   }




}

$.fn.clearGrid = function() {
    var t = $($(this).children("tbody")).children("tr");
    t.each(function() {
        var th = $(this).children()[0];
        if (th.tagName.toLowerCase() != "th") {
            $(this).remove();
        }
    });
}


/*------------------------------------------------------------------------------------------*/

');
 END;
/
SHOW ERRORS
