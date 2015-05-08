/**
 * zsi.loadSequence.js 
 * @author German M. Fuentes <gm.fuentes@gmail.com>
 * @copyright 2015 ZettaSolutions, Inc. <zetta-solutions.net>
 * @license under MIT  
 **/

/* Modification History
Date       By    History
---------  ----  -------------------------------------------------------------------------------------------
FEB-25-15  GF    added errorEvent callback function.
FEB-24-15  GF    Created zsi.loadSequence
*/

if(typeof zsi==='undefined') zsi={};

zsi.loadSequence = function(o) {
	if (o.startIndex < o.files.length){
		var e=null;
		var file = o.files[o.startIndex];
		var type =file.type.toLowerCase();
		
		switch(type){
			case "text/javascript":
				e=document.createElement('script');
				e.setAttribute("type",file.type);
				e.setAttribute("src", file.url);
				break;
				
			case "text/css":
				e=document.createElement('link');
				e.setAttribute("type",file.type);
				e.setAttribute("href",file.url);
				e.setAttribute("rel","stylesheet");
				if(file.media) e.setAttribute("media", file.media);
				
			default:break;
		}
		
		function loadNextFile(){		
			o.startIndex = o.startIndex + 1;	
			var _info = {files :o.files
				 ,startIndex  :o.startIndex
				 ,onAllLoaded :o.onAllLoaded
				};
			//set optional events
			if(o.onEachLoaded) _info.onEachLoaded=o.onEachLoaded;
			if(o.onLoadingFile) _info.onLoadingFile=o.onLoadingFile;			
			if(o.onError) _info.onError=o.onError;
			
			zsi.loadSequence(_info);				
		}
		
		e.onerror =function(errorData){	
			console.log("test");
			if(o.onError) o.onError(file,errorData);
			loadNextFile();								 
		}
		e.onload = function(){
			if(o.onEachLoaded) o.onEachLoaded(file);
			loadNextFile();
		};

		if(o.onLoadingFile) o.onLoadingFile(file);		
		document.getElementsByTagName("head")[0].appendChild(e);
	}
	else {		 
		
		o.onAllLoaded();
	}
} 