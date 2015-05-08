SET SCAN OFF
CREATE OR REPLACE
PROCEDURE zsi_style_css  AS

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
AUG-17-14  GF    New.
*/

 BEGIN NULL;
 owa_util.mime_header('text/css');
htp.prn('
');
htp.prn('
');
htp.prn('

body{
 font-family: Verdana,Arial,"Verdana","Helvetica",Sans-serif;
 margin-left:1px;
 margin-right:1px;
 margin-top:0px;
 margin-bottom:0px;
 background:#f5f6f6;
}
ul
{
    list-style-type: none;
}

.leftnavpanel ul{
  margin-left: 0;
  padding-left: 5px;
}

.leftnavpanel a{

  font-size: 11px;
  font-weight: normal;
}


#footer{
 margin-top:15px;
}
#footer a{
 color:#C1E3FF;
}


#copyright{
  margin-left:15px;
}

#poweredby{
  margin-right:5px;
}

.container-full{
  margin: 0 auto;
  width: 99%;
}
.welcome-container{
  margin: 0 auto;
  width: 99%;
}

.screen-holder{
  width:661px;
}


#banner{
 background :url("/apps/s004/images/banner.jpg") no-repeat;
 height:39px;
 background-color:#99B7FD;
}


#parentId{
   position: relative; top: 0px; left: 0px;
   height: 50px;
   aborder: #B5CDE4 1px solid;
}

.head6 { font-family: trebuchet ms, verdana, arial, helvetica; font-size: 100%; padding-bottom: 2px; font-weight: bold; color: #000; margin: 0; }



.theme-dropdown .dropdown-menu {
  position: static;
  display: block;
  margin-bottom: 20px;
}

.theme-showcase > p > .btn {
  margin: 5px 0;
}

.theme-showcase .navbar .container {
  width: auto;
}
.bottomNav{

}

.buttonGroup {
  margin-top:12px;
  margin-right:20px;
  padding-left: 6px;
}

.pageholder{
  width:97.7%;

}
.pagectrl{
  padding-top: 10px;
}
.pagectrl label{
  margin-left: 5px;
}

.pagestatus{
  float: right;
  font-weight: bold;
  margin-top:-20px;
}

.userControl{
 margin-top: 10px
}

.inputDate{
   width:130px;
}
.input-group-btn button{
  margin-top: -3px;
}


.form-group .control-label{
  text-align: right;
}

/* m5= minus 5*/
.LeftAdjust-m5{
  margin-left:-5px
}

.LeftAdjust-m4{
  margin-left:-4px
}

.LeftAdjust-m3{
  margin-left:-3px
}


/*Tabs*/


.tab-pages div.tab{
  display:none;
  background-color:#fff;
  min-height:200px;
  padding-top:5px;
  padding-left:2px;
  overflow:hidden;
  border-color: transparent #ddd #ddd;
  border-style: solid;
  border-width: 1px;
}

.tab-pages div.active{
  display:block;

}
td #delete-row span{
   margin-top:7px;
}

/*end Tabs */



/*search panel*/
.SearchPanel{

   border: 1pt solid #a6a6a6;
   height: 250px;
   overflow-y: scroll;
   width: 300px;
   position: absolute;
   display:none;
}

.SearchPanel table tr.active td{

   background-color:#4285F4;
   color:#fff;
}

.SearchPanel table tr.active td a{

   color:#fff;
}

.SearchPanel table tr:hover td{

   background-color:#94bcff;
}

.SearchPanel tbody tr:nth-child(even) {background: #e5f2f8}
.SearchPanel tbody tr:nth-child(odd) {background: #fff}

/*end of search panel*/
');
 END;
/
SHOW ERRORS
