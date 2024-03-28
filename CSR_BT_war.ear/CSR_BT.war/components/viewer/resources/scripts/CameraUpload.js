var cid,dtype,docBodyDiv;

function openCameraDiv(event){
    var w=window.innerWidth;
    var h=window.innerHeight;
    dtype=$(event.target).closest('.doc-unit-header')[0].firstElementChild.firstElementChild.id;
    cid=jQuery($(event.target).closest(".doc-list-wrapper"))[0].firstElementChild.children[1].id;
    docBodyDiv=jQuery($(event.target).closest(".doc-unit-header")).siblings(".doc-unit-body")[0];
    var divRef=document.getElementById('cameraViewer');
    divRef.style.width= (w) + "px";
    divRef.style.height=(h - 100) + "px";
    divRef.style.top= ((h-(h-120))/2) + "px";
    //divRef.style.left = ((w-(w-100))/2) + "px";
    divRef.style.display="block";
    var videoRef= document.getElementById('videoShower');
    //videoRef.style.width= (w - 200) + "px";
    videoRef.style.width="100%";
    //videoRef.style.height=(h - 200) + "px";
    videoRef.style.height="90%";
    //videoRef.style.top= "20px";
    //videoRef.style.left = ((w-(w-100))/2) + "px";
    //videoRef.style.paddingTop="25px";
    videoRef.style.display="block";
    var videoPlayerRef = document.getElementById('videoPlayer');
    if(videoPlayerRef) {
     videoPlayerRef.style.width="100%";
     videoPlayerRef.style.height="100%";
    //videoPlayerRef.style.width= (w - 200) + "px";
    //videoPlayerRef.style.height=(h - 200) + "px";
    //videoPlayerRef.style.top= ((h-(h-100))/2) + "px";
    //videoPlayerRef.style.left = ((w-(w-100))/2) + "px";
     videoPlayerRef.style.display="block";
    }
    var imageRef= document.getElementById('imageClicker');
    imageRef.style.left = (((w)/2)- 30)+ "px";
    imageRef.style.display="block";
    var autoRotate= document.getElementById('autoRotateOption');
    autoRotate.style.left = (((w)/2) + 30 )+ "px";
    autoRotate.style.display="block";
    var closeRef = document.getElementById('cameraCloser');
    closeRef.style.left = (w - 25) + "px";
    var retakeOption = document.getElementById('retakeOption');
    retakeOption.style.left = (((w)/2) - 30 )+ "px";
    retakeOption.style.display = "none";
    var canvasRef = document.getElementById('canvasShower');
    canvasRef.style.width = "100%";
    canvasRef.style.height = "90%";
    //canvasRef.style.width = (w - 200) + "px";
    //canvasRef.style.height = (h - 200) + "px";
    //canvasRef.style.top = ((h - (h - 100)) / 2) + "px";
    //canvasRef.style.left = ((w - (w - 100)) / 2) + "px";
    canvasRef.style.display = "none";
    var photoCanvas = document.getElementById('takePhotoCanvas');
    if (photoCanvas != null) {
        photoCanvas.style.width = (w - 10) + "px";
        photoCanvas.style.height = (h - 150) + "px";
        //photoCanvas.style.top = ((h - (h - 100)) / 2) + "px";
        //photoCanvas.style.left = ((w - (w - 100)) / 2) + "px";
        photoCanvas.style.paddingTop = "25px";
        photoCanvas.style.display = "none";
    }
    var uploadCameraRef= document.getElementById('uploadImageCamera');
    uploadCameraRef.style.left = (((w)/2) +30) + "px";
    uploadCameraRef.style.display="none";
    lattitude='',longitude='';
    getLocation();
}

//var ChromeSamples = {
//    log: function() {
//      var line = Array.prototype.slice.call(arguments).map(function(argument) {
//        return typeof argument === 'string' ? argument : JSON.stringify(argument);
//      }).join(' ');
//
//      document.querySelector('#log').textContent += line + '\n';
//    },
//
//    clearLog: function() {
//      document.querySelector('#log').textContent = '';
//    },
//
//    setStatus: function(status) {
//      document.querySelector('#status').textContent = status;
//    },
//
//    setContent: function(newContent) {
//      var content = document.querySelector('#content');
//      while(content.hasChildNodes()) {
//        content.removeChild(content.lastChild);
//      }
//      content.appendChild(newContent);
//    }
//  };
var imageCapture;
var cameraOption;
function onGetUserMediaButtonClick(mode) {
    try{
  cameraOption=mode;
  var divRef=document.getElementById('cameraViewer');
  var w=divRef.style.width.split("p")[0]-0;
  var h=divRef.style.height.split("p")[0]-80;
  if(typeof mode=='undefined' || mode =='back'){      
//     navigator.mediaDevices.getUserMedia({video:{ width: {exact: 640}, height: {exact: 480},facingMode: { 
//      exact: 'environment'
//    } }}).then(mediaStream => {
//    document.querySelector('video').srcObject = mediaStream;
//    const track = mediaStream.getVideoTracks()[0];
//    imageCapture = new ImageCapture(track);
//    }).catch(error =>showAlertDialog(BACK_CAMERA_ERROR,false)); 
        Webcam.set({
          width: w,
          height: h,
          image_format: 'jpeg',
          jpeg_quality: 90,
          constraints: {
             video: true,
             facingMode: "environment"
          }
        });        
  } else if(mode == 'front'){
//      navigator.mediaDevices.getUserMedia({video:{ width: {exact: 640}, height: {exact: 480},facingMode: 'user'  
//    }}).then(mediaStream => {
//    document.querySelector('video').srcObject = mediaStream;
//    const track = mediaStream.getVideoTracks()[0];
//    imageCapture = new ImageCapture(track);
//    }).catch(error =>showAlertDialog(FRONT_CAMERA_ERROR,false)); 
     Webcam.set({
          width: w,
          height: h,
          image_format: 'jpeg',
          jpeg_quality: 90,
          constraints: {
             video: true,
             facingMode: "user"
          }
        });
  }
  Webcam.attach('#videoShower');
    }catch(e){}
}

function onTakePhotoButtonClick() {
    try{
//  imageCapture.takePhoto()
//  .then(blob => createImageBitmap(blob))
//  .then(imageBitmap => {
//    const canvas = document.querySelector('#takePhotoCanvas');
//    hideShowCanvas(); 
//    drawCanvas(canvas, imageBitmap);
//    stopStreamedVideo(document.querySelector('video'));
//    updateLocation();
//  })
//  .catch(error =>showAlertDialog(CAMERA_IMAGE_ERROR,false));
      var divRef = document.getElementById('cameraViewer');
      var w = divRef.style.width.split("p")[0] - 0;
      var h = divRef.style.height.split("p")[0] - 80;
      if(document.getElementById('takePhotoCanvas')!=null){
          var divRef= document.getElementById('canvasShower');
          divRef.removeChild(document.getElementById('takePhotoCanvas'));
      }
      Webcam.snap(function(data_uri) {
        // display results in page
        document.getElementById('canvasShower').innerHTML ='<img id="takePhotoCanvas" style="position:absolute;top:30px;left:'+((w-(w-65))/2)+'px" width="'+(w-65)+'" height="'+h+'" src="' + data_uri + '"/>';
        hideShowCanvas();
        stopStreamedVideo(document.querySelector('video'));
        updateLocation();
      });      
    }catch(e){}   
}

//function drawCanvas(canvas, img) {
//  canvas.width = getComputedStyle(canvas).width.split('px')[0];
//  canvas.height = getComputedStyle(canvas).height.split('px')[0];
//  let ratio  = Math.min(canvas.width / img.width, canvas.height / img.height);
//  let x = (canvas.width - img.width * ratio) / 2;
//  let y = (canvas.height - img.height * ratio) / 2;
//  canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
//  canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height,
//      x, y, img.width * ratio, img.height * ratio);
//}

function hideShowCanvas(flag){
    if (typeof flag == "undefined"){
        try{
        var videoRef = document.getElementById('videoShower');
        if(videoRef!=null)
        videoRef.style.display = "none";
        var videoPlayerRef = document.getElementById('videoPlayer');
        if(videoPlayerRef!=null)
          videoPlayerRef.style.display = "none";
        var autoRotate = document.getElementById('autoRotateOption');
        if(autoRotate!=null)
        autoRotate.style.display = "none";
        var canvasRef = document.getElementById('canvasShower');
        if(canvasRef!=null)
        canvasRef.style.display = "block";
        var photoCanvas = document.getElementById('takePhotoCanvas');
        if(photoCanvas!=null)
          photoCanvas.style.display = "block";
        var retakeOption = document.getElementById('retakeOption');
        if(retakeOption!=null)
          retakeOption.style.display = "block";
        var imageRef= document.getElementById('imageClicker');
        if(imageRef!=null)
          imageRef.style.display = "none";
        var uploadCameraRef= document.getElementById('uploadImageCamera');
        if(uploadCameraRef!=null)
          uploadCameraRef.style.display="block";
        } catch(e) {
            alert(e);
        }
    } else if(flag=='video'){
        var videoRef = document.getElementById('videoShower');
        if(videoRef!=null)
         videoRef.style.display = "block";
        var videoPlayerRef = document.getElementById('videoPlayer');
        if(videoPlayerRef!=null)
          videoPlayerRef.style.display = "block";
        var autoRotate = document.getElementById('autoRotateOption');
        if(autoRotate!=null)
          autoRotate.style.display = "block";
        var canvasRef = document.getElementById('canvasShower');
        if(canvasRef!=null)
          canvasRef.style.display = "none";
        var photoCanvas = document.getElementById('takePhotoCanvas');
        if(photoCanvas!=null)
          photoCanvas.style.display = "none";
        var retakeOption = document.getElementById('retakeOption');
        if(retakeOption!=null)
          retakeOption.style.display = "none";
        var imageRef= document.getElementById('imageClicker');
        if(imageRef!=null)
          imageRef.style.display = "block";
        var uploadCameraRef= document.getElementById('uploadImageCamera');
        if(uploadCameraRef!=null)
          uploadCameraRef.style.display="none";
    }
    
}

function closeCameraViewer(){
    stopStreamedVideo(document.querySelector('video'));
    var divRef=document.getElementById('cameraViewer');
    divRef.style.removeProperty('width');
    divRef.style.removeProperty('height');
    divRef.style.removeProperty('top');
    divRef.style.removeProperty('left');
    divRef.style.display="none";
    var videoRef= document.getElementById('videoShower');
    videoRef.style.removeProperty('width');
    videoRef.style.removeProperty('height');
    videoRef.style.removeProperty('top');
    videoRef.style.removeProperty('left');
    videoRef.style.display="none";
    var videoPlayerRef = document.getElementById('videoPlayer');
    if(videoPlayerRef) {
     videoPlayerRef.style.removeProperty('width');
     videoPlayerRef.style.removeProperty('height');
     videoPlayerRef.style.removeProperty('top');
     videoPlayerRef.style.removeProperty('left');
     videoPlayerRef.style.display="none";
    }
    var canvasRef= document.getElementById('canvasShower');
    canvasRef.style.removeProperty('width');
    canvasRef.style.removeProperty('height');
    canvasRef.style.removeProperty('top');
    canvasRef.style.removeProperty('left');
    canvasRef.style.display="none";
    var photoCanvas= document.getElementById('takePhotoCanvas');
    photoCanvas.style.removeProperty('width');
    photoCanvas.style.removeProperty('height');
    photoCanvas.style.removeProperty('top');
    photoCanvas.style.removeProperty('left');
    photoCanvas.style.display="none";
    var imageRef= document.getElementById('imageClicker');
    imageRef.style.removeProperty('left');
    var autoRotate= document.getElementById('autoRotateOption');
    autoRotate.style.removeProperty('left');
    var closeRef = document.getElementById('cameraCloser');
    closeRef.style.removeProperty('left');
    var retakeOption = document.getElementById('retakeOption');
    retakeOption.style.removeProperty('left');
    var uploadCameraRef= document.getElementById('uploadImageCamera');
    uploadCameraRef.style.removeProperty('left');
}

function stopStreamedVideo(videoElem) {
  try{  
   var stream = videoElem.srcObject;
   if(stream!=null){
    var tracks = stream.getTracks();

    tracks.forEach(function(track) {
       track.stop();
    });

    videoElem.srcObject = null;
   }
  } catch(e) {
      
  }
}

function autoRotateCamera(){
    stopStreamedVideo(document.querySelector('video'));
    if(cameraOption=='front'){
        onGetUserMediaButtonClick('back');
    } else {
        onGetUserMediaButtonClick('front');
    }
}

function retakeImage(){
    hideShowCanvas('video');
    onGetUserMediaButtonClick(cameraOption);
}

function uploadImageFromCamera(){
    CreateIndicator('cameraUpload');
    document.getElementById('fade').style.display="block";
    //var base64Data=document.getElementById('takePhotoCanvas').toDataURL('image/jpeg', 1.0);
    var base64Data=document.getElementById('takePhotoCanvas').src;
    var docUnitDetails="";
    var file=dataURLtoFile(base64Data,"IMG_"+new Date().getDate()+new Date().getMonth()+new Date().getFullYear()+new Date().getMilliseconds()+".jpeg");
    uploadFileToOD(file,cid,dtype, function(docID){
            
           $("#spinnerdiv").hide();
            if ('name' in file) {
            var fileName = file.name; 
            var type=fileName.split('.')[fileName.split('.').length-1];
            var icon= getIcon(type);
            }
            if ('size' in file) {

                var fileSize = file.size;
                fileSize = (file.size/1024).toFixed(0) + " (KB)";
                
            }
           /* if('type' in file){
                var type = file.type.split('/')[1];
                var icon= getIcon(type);
            }*/
            docUnitDetails += "           <div class=\"col-md-12 col-sm-12 col-xs-12 doc-unit-detail\">\n" +
                               "            <div class=\"col-md-6 col-sm-8 col-xs-12 \" style=\"padding: 3px;border: 1px solid #EBEBEB;border-radius: 1px;background-color: #F9F9F9;margin-bottom:5px;\">\n";
                              if((applicationName!=null && applicationName!='') || ((mobileMode=="ios") || (mobileMode=="android")))           
              docUnitDetails +=  "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else if((window.opener!=null && typeof window.opener.applicationName!='undefined' && (window.opener.applicationName!=null && window.opener.applicationName!='')) || ((mobileMode=="ios") || (mobileMode=="android"))) 
               docUnitDetails +=  "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ; 
            else 
              docUnitDetails +=  "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"openDocInViewer(event)\">\n" ;
          
            docUnitDetails +=    "               <img src=\""+ icon +"\"> <p title=\""+fileName+"\">"+ fileName +"</p>\n" +
                                "               <p class='add-doc-size' style='font-size:10px;font-weight:400;margin-top:0px;'>"+ fileSize+"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-md-1 col-sm-1 col-xs-1 doc-unit-size\">\n" +
                                "               <p>"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-md-1 col-sm-1 col-xs-1 doc-unit-delete\">\n" +
                                "<span onclick=\"deleteItem(event,this)\" style=\"cursor:pointer;\"><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\" style=\"vertical-align: -webkit-baseline-middle;\" viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>"+DELETE+"</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg></span>"+
                                //"               <img class=\"delete-item\" src='../../components/viewer/resources/images/DeleteIconEnabled.png' onclick=\"deleteItem(event)\"  /> \n" +
                               // "        <p>Remove</p>" +
                                "             </div>\n" +
                                "             </div>\n" +
                                            "<div class=\"col-md-5 col-sm-4 col-xs-12 doc-unit-comments\">\n"+
                                            " <textarea class=\"form-control1 control-class\" style=\"resize:none;margin-bottom:0px;border-color:#ccc;width:100%;padding:5px\" spellcheck=\"true\" maxlength=\"4000\" onmouseover=\"this.title=this.value\" rows=\"2\" onchange=\"updateDocComment(this)\"  placeholder=\""+DOC_COMMENT+"....\"></textarea>\n"+
                                            "           </div>\n" +
                              "           </div>";
            docUnitDetails += "\n";                       
        

            
            var docUnitHtml = "          <div class=\"col-md-12 col-sm-12 col-xs-12 doc-detail-wrapper\">\n" + docUnitDetails + 
                                "           </div>\n";
//               docUnitHtml +=    "          <div class=\"col-md-4 col-sm-4 col-xs-4 doc-unit-comment\">\n" +
//                                "           <textarea onchange = \"updateDocComment(this)\" placeholder=\"write comments....\"></textarea>\n" +
//                                "          </div>";
                                  
            //jQuery(docBodyDiv.children[0]).hide();
            jQuery(docBodyDiv).append(docUnitHtml);  
            RemoveIndicator('cameraUpload');
            if(document.getElementById(cid+"_label")!=null){
                 $(document.getElementById(cid+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                 $(document.getElementById(cid+"_label")).addClass('mandatoryLabel');
                 $(document.getElementById(cid)).removeClass('mandatory');
                 delete ComponentValidatedMap[cid];
            }
            document.getElementById('fade').style.display="none";
            showAlertDialog(CAMERA_FILE_UPLOAD,false);
            closeCameraViewer();    
           });
    
}

//function uploadImageFromCameraToOD(file,ctrid,doctype, callback){
//    
//    var fName=doctype+Math.random(999999999)
//    	var params={
//    		pid:pid,
//    		wid:wid,
//    		tid:tid,
//                fid:fid,
//    		fileName:fName,
//    		fileData:file,
//                ctrId:ctrid,
//                docType:doctype,
//    		fileType:'image/jpeg'
//
//    	};
//    	$.post("../../DocumentUpload", $.param(params), function(response) {
//            if (response) {
//                callback(response.DocId,fName);
//            }else{
//            	alert("Error in uploading attachment please try again.")
//            }
//        });
//    
//}

function dataURLtoFile(dataurl, filename) {
 
        var arr = dataurl.split(','),
            mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(arr[1]), 
            n = bstr.length, 
            u8arr = new Uint8Array(n);
            
        while(n--){
            u8arr[n] = bstr.charCodeAt(n);
        }
        
        return new File([u8arr], filename, {type:mime});
}
