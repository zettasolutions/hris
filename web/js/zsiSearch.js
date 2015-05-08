
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
AUG-17-14  GF    Added autoscroll.
AUG-13-14  GF    Created AutoComplete JQuery.
*/

zsi.search = new function(){
   this.InputSearch;
   this.Panel;
   this.Grid;
   this.Url;
   this.Parameter;
   this.ColumnIndexes;
   this.data=null;      
   this.timer;
   this.OnLoadComplete;   
   this.OnSelectedItem;
   this.OnRequestFailed;
   this.MinCharacters;
};

zsi.search.setDataIndex = function(i){
   if(zsi.search.OnSelectedItem){
      if(!this.data) return;
      if(this.data.rows.length>0) zsi.search.OnSelectedItem(this.data.rows[i].data,i);
   }
}

zsi.search.init=function(info){  
   if(!info.panel) info.panel = {id:"panel", class:"SearchPanel"};
   if(!info.grid) info.grid = {id:"grid", class:"SearchGrid"};       
   this.InputSearch = $(info.input);
   this.Url = info.url;
   this.Parameter = info.parameter;
   this.OnSelectedItem = info.onSelectedItem;
   this.OnLoadComplete = info.onLoadComplete;
   this.OnRequestFailed = info.onRequestFailed;
   if(!info.min_characters) 
      this.MinCharacters=1; 
   else
      this.MinCharacters=info.min_characters; 
   
   var html = '<br />';
      html += '<div class="'+ info.panel.class + '" >';
      html +='<table id="' + info.grid.id + '"  class="table ' + info.grid.class + '">';
      html +='<thead>';
      html +='<tr>';      
      for(var i=0;i<info.column_names.length;i++){
      html +='<th>' + info.column_names[i] + '</th>';            
      }   
      html +='</tr>';            
      html +='</thead>';      
      html +='</table>';

      html +='</div>';
   $(html).appendTo('body');   

   this.Panel = $("." + info.panel.class);
   this.Grid = $("." + info.grid.class);
   this.ColumnIndexes = info.column_indexes; 
   
   /*set panel position*/
   var _offset = this.InputSearch.offset();      
   this.Panel.css("left",_offset.left + "px");
   this.Panel.css("top",this.InputSearch.outerHeight() + _offset.top + "px");
   this.Panel.css("width",this.InputSearch.outerWidth() + "px");   
   
   
   this.Panel.show=function(isShow){
      this.css("display",(isShow==true) ? "block":"none");
   }
           

   /*set keyup event*/         
   this.InputSearch.keyup(function(e){
      var searchPanel = zsi.search.Panel;
      var searchGrid =  zsi.search.Grid;

      switch(e.keyCode){
         case  9:break; //alt+tab
         case 17:break; //ctrl
         case 18:break; //alt
         case 39:break; //Right
         case 37:break; //Left
         case 40://Down
            showBox();
            var trActive =searchGrid.find('tbody > tr.active');        
            var trs = searchGrid.find('tbody > tr');
            trActive.each(function(){               
                  var _index=$(this).index();            
               if(_index!= trs.length-1 ){
                  $(this).removeClass("active");
                  $(this).next().addClass("active");                  
                  zsi.search.setDataIndex(_index + 1);
 
                  computeScroll($(this).next(), "down");
               }

            });

            if(trActive.length==0 && trs.length>0){

               $(searchGrid.find('tbody > tr')[0]).addClass("active");
               zsi.search.setDataIndex(0);
               zsi.search.Panel.scrollTop(0);

            }
            break; 
            
         case 38: //Up
            showBox();
            var trActive =searchGrid.find('tbody > tr.active');            
            trActive.each(function(){
               var _index=$(this).index();   
               if(_index!=0){
                  $(this).removeClass("active");
                  $(this).prev().addClass("active");                  
                  zsi.search.setDataIndex(_index-1);                  

                  computeScroll($(this).prev(), "up");
               }
            });

            break;
         case 13://enter
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
   }).focus(function(){showBox();}).click(function(){ showBox();});        

   function showBox(){
      var value=zsi.search.InputSearch.val();
      if(zsi.search.data && value.length>=zsi.search.MinCharacters){      
         if(zsi.search.data.rows.length>0) zsi.search.Panel.show(true);
      }               
   }
   

   $(document).click(function(event){

       if( $( event.target ).is("html"))
       {
         zsi.search.Panel.show(false);
       }
       
   });  

}

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
          var r = '';
          r += '<tr>';                
          for(var i=0;i<_indexes.length;i++){
             this.data[_indexes[i]] = unescape(this.data[_indexes[i]]);               
             r += "<td>" + this.data[_indexes[i]] + "</td>";               
          }                
          r += '</tr>';
          searchGrid.append(r);               
   });
   searchGrid.find('tbody > tr').each(function(){

       $(this).click(function(){
          var trActive =searchGrid.find('tbody > tr.active'); 
          if(trActive.length>0){
             $(trActive[0]).removeClass("active");
          }

          $(this).addClass("active");
          zsi.search.setDataIndex($(this).index());
          zsi.search.Panel.show(false);

       })
   });


}
