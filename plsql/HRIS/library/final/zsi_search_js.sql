SET SCAN OFF
CREATE OR REPLACE
PROCEDURE zsi_search_js  AS

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
/*
* zsi.Search v1.0.0
*=======================================================================
*
* Copyright (c) 2014 ZettaSolutions,Inc.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification is strictly prohibited.
*
========================================================================
*/

/* Modification History
Date       By    History
---------  ----  -------------------------------------------------------------------------------------------
OCT-24-14  GF    Fixed search panel position when clicked or focused.
OCT-23-14  GF    Added new functionality, that is applicable for multiple search inputs.
AUG-17-14  GF    Added autoscroll.
AUG-13-14  GF    Created AutoComplete JQuery.
*/

 BEGIN NULL;
 owa_util.mime_header('application/javascript');
htp.prn('
');
htp.prn('
');
htp.prn('

zsi.search =  function(info){
   if(!info.panel) info.panel = {id:"panel", class:"SearchPanel"};
   if(!info.grid) info.grid = {id:"grid", class:"SearchGrid"};

   this.InputSearch = $(info.input);

   zsi.search.data=null;
   zsi.search.timer;
   zsi.search.Url = info.url;
   zsi.search.Parameter = info.parameter;
   zsi.search.OnSelectedItem = info.onSelectedItem;
   zsi.search.OnLoadComplete = info.onLoadComplete;
   zsi.search.OnRequestFailed = info.onRequestFailed;
   zsi.search._currentObject=null;
   zsi.search._gridHistory=[];

   if(!info.min_characters)
      zsi.search.MinCharacters=1;
   else
      zsi.search.MinCharacters=info.min_characters;

   var html = ''<br />'';
      html += ''<div class="''+ info.panel.class + ''" >'';
      html +=''<table id="'' + info.grid.id + ''"  class="table '' + info.grid.class + ''">'';
      html +=''<thead>'';
      html +=''<tr>'';
      for(var i=0;i<info.column_names.length;i++){
      html +=''<th>'' + info.column_names[i] + ''</th>'';
      }
      html +=''</tr>'';
      html +=''</thead>'';
      html +=''</table>'';

      html +=''</div>'';
   $(html).appendTo(''body'');

   zsi.search.Panel = $("." + info.panel.class);
   zsi.search.Grid = $("." + info.grid.class);
   zsi.search.ColumnIndexes = info.column_indexes;

   setInputSearchEvent(this.InputSearch);


   zsi.search.Panel.show=function(isShow){
      setPanelPosition(zsi.search._currentObject);
      this.css("display",(isShow==true) ? "block":"none");
   }

};


zsi.search.setDataIndex = function(currentObject,i){
   if(zsi.search.OnSelectedItem){
      if(!this.data) return;
      if(this.data.rows.length>0) zsi.search.OnSelectedItem(currentObject,this.data.rows[i].data,i);
   }
}


function setPanelPosition(obj){
   /*set panel position*/
   if(obj){
      var _offset = $(obj).offset();
      zsi.search.Panel.css("left",_offset.left + "px");
      zsi.search.Panel.css("top",$(obj).outerHeight() + _offset.top + "px");
      zsi.search.Panel.css("width",$(obj).outerWidth() + "px");
   }
}


function setInputSearchEvent(inputObj){
      inputObj.each(function(){

         $(this).keyup(function(e){
               zsi.search._currentObject= this;
               var searchPanel = zsi.search.Panel;
               var searchGrid =  zsi.search.Grid;

               setPanelPosition(this);

               switch(e.keyCode){
                  case  9:break; //alt+tab
                  case 17:break; //ctrl
                  case 18:break; //alt
                  case 39:break; //Right
                  case 37:break; //Left
                  case 40://Down
                     showBox(this);
                     var trActive =searchGrid.find(''tbody > tr.active'');
                     var trs = searchGrid.find(''tbody > tr'');
                     trActive.each(function(){
                           var _index=$(this).index();
                        if(_index!= trs.length-1 ){
                           $(this).removeClass("active");
                           $(this).next().addClass("active");
                           zsi.search.setDataIndex(this,_index + 1);

                           computeScroll($(this).next(), "down");
                        }

                     });

                     if(trActive.length==0 && trs.length>0){

                        $(searchGrid.find(''tbody > tr'')[0]).addClass("active");
                        zsi.search.setDataIndex(this,0);
                        zsi.search.Panel.scrollTop(0);

                     }
                     break;

                  case 38: //Up
                     showBox(this);
                     var trActive =searchGrid.find(''tbody > tr.active'');
                     trActive.each(function(){
                        var _index=$(this).index();
                        if(_index!=0){
                           $(this).removeClass("active");
                           $(this).prev().addClass("active");
                           zsi.search.setDataIndex(this,_index-1);

                           computeScroll($(this).prev(), "up");
                        }
                     });

                     break;
                  case 13://enter
                     var trActive =searchGrid.find(''tbody > tr.active'');
                     zsi.search.setDataIndex(this,trActive.index());
                     zsi.search.Panel.show(false);
                     break;

                  default:
                     clearTimeout(zsi.search.timer);
                     var _value=this.value;
                     if(_value.length>=zsi.search.MinCharacters){
                        zsi.search.timer = setTimeout(function(){
                           zsi.search.Panel.scrollTop(0);
                           var l_params="?" + zsi.search.Parameter + "=" +  _value;
                           $.getJSON(zsi.search.Url + l_params,onSearchComplete).fail(function() {
                               if(zsi.search.OnRequestFailed) zsi.search.OnRequestFailed();
                           })

                        }, 500);

                     }
                     else{
                         zsi.search.data=null;
                         zsi.search.Panel.show(false);
                         searchGrid.clearGrid();
                     }
                  break;
               }
            }).on(''click'', function() {
               zsi.search._currentObject=this;
               if(recallTableDisplay(this)){
                 zsi.search.Panel.html(recallTableDisplay(this));
               }
               showBox(this);
            });

      });
}

   function showBox(input){
      var value=input.value;
      if(zsi.search.data && value.length>=zsi.search.MinCharacters){
         if(zsi.search.data.rows.length>0) zsi.search.Panel.show(true);
      }
   }


   $(document).click(function(event){
      var et=$(event.target);
      var clsName = "." + zsi.search.Panel.attr("class");
      if(!et.is("input") && !et.is(clsName) && !et.parents(clsName).length>0 ){
         zsi.search.Panel.show(false);
      }

   });




function computeScroll(tr,direction){
   var scrollHeight=zsi.search.Panel.prop("scrollHeight");
   var height=zsi.search.Panel.height();
   var trTop = tr.position().top;
   var trHeight = tr.height();

   if(direction=="down"){
      if (trTop > (height - trHeight)){
           zsi.search.Panel.scrollTop( zsi.search.Panel.scrollTop() + parseInt(trTop));
      }

   }else if(direction=="up"){
      if (trTop < 0 ){
           zsi.search.Panel.scrollTop( zsi.search.Panel.scrollTop() - parseInt(height  - trHeight));
      }
   }
}


onSearchComplete = function(data){
   var searchGrid = zsi.search.Grid;
   searchGrid.clearGrid();
   zsi.search.data=data;

   if(zsi.search.OnLoadComplete) zsi.search.OnLoadComplete(data);
   if(data.rows.length>0) zsi.search.Panel.show(true);

   $.each(data.rows, function () {
          var _indexes= zsi.search.ColumnIndexes;
          var r = '''';
          r += ''<tr>'';
          for(var i=0;i<_indexes.length;i++){
             this.data[_indexes[i]] = unescape(this.data[_indexes[i]]);
             r += "<td>" + this.data[_indexes[i]] + "</td>";
          }
          r += ''</tr>'';
          searchGrid.append(r);
   });


   addTableDisplayHistory(searchGrid[0].outerHTML, zsi.search._currentObject);
   setTRClickEvent();
}

function addTableDisplayHistory(grid,obj){
   var h=zsi.search._gridHistory;
   var isfound=false;
   for(var x=0;x<h.length;x++){
      if(obj==h[x].input){
        h[x]=grid;
        isfound=true;
        break;
      }
   }
   if(isfound==false){
      h.push( {grid : grid, input: obj});
   }
   console.log(h.length);
}

function recallTableDisplay(obj){
   var grid=null;
   var h=zsi.search._gridHistory;
   var isfound=false;
   for(var x=0;x<h.length;x++){
      if(obj==h[x].input){
        grid=h[x].grid;
        break;
      }
   }
   return grid;
}




function setTRClickEvent(){
   zsi.search.Grid.find(''tbody > tr'').each(function(){
       $(this).click(function(){
          var trActive =zsi.search.Grid.find(''tbody > tr.active'');
          if(trActive.length>0){
             $(trActive[0]).removeClass("active");
          }

          $(this).addClass("active");
          zsi.search.setDataIndex(zsi.search._currentObject,$(this).index());
          zsi.search.Panel.show(false);

       })
   });

}
');
 END;
/
SHOW ERRORS
