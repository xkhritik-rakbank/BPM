


function getIcon(type){
    if( type )
 type= type.toLowerCase();

 switch(type){

  case "pdf":
    return "resources/images/Icons/Group 7.png";
  case "png":
    return  "resources/images/Icons/Group 5.png";
  case "jpeg":
  case "jpg":
    return "resources/images/Icons/Group 6.png";
  case "docx":
  case "doc":
    return "resources/images/Icons/Group 7 Copy 2.png";
  case "xlsx":
  case "xls":
    return "resources/images/Icons/Group 8.png";
  case "pptx": 
  case "ppt":
    return "resources/images/Icons/Group 9.png";
  default:
    return "resources/images/Icons/Group 7 Copy 3.png"      
 }

}

 /* $(document).on('click','.doc-unit-name', function(event){

    var docID = $(event.target).parent().attr("data-docID");
    //"/omnidocs/integration/foldView/viewFoldList.jsp
    var url = "/omnidocs/integration/foldView/viewDocsMain.jsp?Application=DocView&cabinetName="+cabinetName+"&sessionIndexSet=false&DocId="+docID+"&Userdbid="+sessionId;
    //window.open('dowloadAttachment.jsp?docID='+ docID +'&Userdbid='+ sessionId);
    var ScreenHeight=screen.height;
    var ScreenWidth=screen.width;
    var windowH=450;
    var windowW=950;
    var WindowHeight=windowH-100;
    var WindowWidth=windowW;
    var WindowLeft=parseInt(ScreenWidth/2)-parseInt(WindowWidth/2);
    var WindowTop=parseInt(ScreenHeight/2)-parseInt(WindowHeight/2)-50;
    var wiWindowRef = window.open(url, 'DocView', 'scrollbars=yes,left='+WindowLeft+',top='+WindowTop+',height='+windowH+',width='+windowW+',resizable=yes')

    
  });

  $(document).off().on('click','.delete-item', function(event){

    var itemToDelete = $(event.target).parent().parent();
    if(itemToDelete.siblings().length === 0){
      
      var unitBodyDiv = $(itemToDelete).parent().parent();    
      $(itemToDelete).remove();
      $(unitBodyDiv).children(':visible').remove();
      $(unitBodyDiv).children(".no-doc-div").show();
    
    }else{

      $(itemToDelete).remove();      
    }
     
  });


   $(document).off().on('change','.unit-attach-file',function(event){
    var id = $(event.target).attr("id");
    var x = document.getElementById(id);// element id
    //var docUnitDiv = $("[data-id='"+ id +"']");
    var docUnitDiv = $(this).closest(".doc-unit-header").siblings(".doc-unit-body");
    var emptyUnit = true, docUnitDetails="";
    if(docUnitDiv.find(".doc-unit-detail").length>0){
      emptyUnit = false;
    }
    if ('files' in x) {
      if (x.files.length == 0) {
        alert("Please select a file."); // alert for no file selected
      } else {
        
          var file = x.files[0];
          var controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
          var doctype = jQuery(x).parents(".doc-unit-header").children()[0].childNodes[1].id;
          // $("#spinnerdiv").show();
           uploadFileToOD(file,controlid,doctype, function(docID){
            
            $("#spinnerdiv").hide();
            if ('name' in file) {
            var fileName = file.name; 
            }
            if ('size' in file) {

                var fileSize = file.size;
                if((file.size/1024) < 1024)
                  fileSize = (file.size/1024).toFixed(4) + "KB";
                else
                  fileSize = ((file.size/1024)/1024).toFixed(4) + "MB"; 
            }
            if('type' in file){
                var type = file.type.split('/')[1];
                var icon= getIcon(type);
            }
            docUnitDetails += "           <div class=\"col-md-12 doc-unit-detail\">\n" +
                              "             <div class=\"doc-unit-name\"data-docID=\""+ docID +"\">\n" +
                                "               <img src=\""+ icon +"\"> <p>"+ fileName +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"doc-unit-size\">\n" +
                                "               <p>"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"doc-unit-delete\">\n" +
                                "               <i class=\"far fa-trash-alt delete-item\"></i>\n" +
                                "             </div>\n" +
                              "           </div>";
            docUnitDetails += "\n";                  
        

            if(emptyUnit){
              var docUnitHtml = "          <div class=\"col-md-8 doc-detail-wrapper\">\n" +
                                  docUnitDetails + 
                                  "          </div>\n" +
                                  "          <div class=\"col-md-4 doc-unit-comment\">\n" +
                                  "            <textarea placeholder=\"write comments....\"></textarea>\n" +
                                    "          </div>"
            docUnitDiv.children(".no-doc-div").hide();
            docUnitDiv.append(docUnitHtml);                  
        
            }else{

              var docDetailWrapper = docUnitDiv.find(".doc-detail-wrapper");
              docDetailWrapper.append(docUnitDetails);
            }         
           });

      }
    } 
    else { // handling cases when files property isnt supported
      if (x.value == "") {
         alert("Please select a file.");
      } else {
        alert("The files property is not supported by your browser!");
      }
    }
  });


  $(document).off().on('click','.unit-attach-drop',function(event){
    $(this).parent().parent().siblings(".unit-attach-dropdown").toggle();
  });
      
  $(document).off().on('click','.unit-attach-option',function(event){
    $(this).parent(".unit-attach-dropdown").children(".unit-attach-option").children(".hollow-star").show();
    $(this).parent(".unit-attach-dropdown").children(".unit-attach-option").children(".solid-star").hide();
    $(this).children(".solid-star").show();
    $(this).children(".hollow-star").hide();
    $(this).parent(".unit-attach-dropdown").hide();
  });  */



function getIcon(type){
 if( type )
    type= type.toLowerCase();

 switch(type){

  case "pdf":
    return "resources/images/Icons/Group 7.png";
  case "png":
    return  "resources/images/Icons/Group 5.png";
  case "jpeg":
  case "jpg":
    return "resources/images/Icons/Group 6.png";
 case "docx": 
 case "doc":
    return "resources/images/Icons/Group 7 Copy 2.png";
case "xlsx":  
case "xls":
    return "resources/images/Icons/Group 8.png";
case "pptx":
case "ppt":
    return "resources/images/Icons/Group 9.png";
  default:
    return "resources/images/Icons/Group 7 Copy 3.png"      
 }

}

function uploadFileToOD(file,ctrid,doctype, callback){
      CreateIndicator('cameraUpload');
      var formData = new FormData();
      formData.append('filesData',file,encode_utf8(file.name));
      formData.append('fileName',encode_utf8(file.name));
      if ('name' in file) {
                   var fileName = file.name; 
                   var type=fileName.split('.')[fileName.split('.').length-1];
                   formData.append('fileType',type);
      }
      else{
      formData.append('fileType',file.type.split('/')[1]);
      }
      formData.append('pid',encode_utf8(pid));
      formData.append('wid',wid);
      formData.append('tid',tid);
      formData.append('fid',encode_utf8(fid));
      formData.append('ctrId',encode_utf8(ctrid));
      formData.append('docType',encode_utf8(doctype));
      formData.append('Latitude',lattitude);
      formData.append('Longitude',longitude);
      jQuery.ajax({
        url: '../../DocumentUpload',
        data: formData,
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST', // For jQuery < 1.9
        success: function(response){
             if (response) {
                 if(response.errorFlag == false)
                    callback(response.DocId);
                 else
                 {
                     showAlertDialog(response.errorMessage,false);
                     RemoveIndicator('browseUpload');
                 }
            }else{
            	showAlertDialog(DOC_ERROR,false);
                RemoveIndicator('browseUpload');
            }
        },
        complete:function(){
            RemoveIndicator('cameraUpload');
            //closeCameraViewer();
        }
    });
}




 /* $(document).on('click','.doc-unit-name', function(event){

    var docID = $(event.target).parent().attr("data-docID");
    //"/omnidocs/integration/foldView/viewFoldList.jsp
    var url = "/omnidocs/integration/foldView/viewDocsMain.jsp?Application=DocView&cabinetName="+cabinetName+"&sessionIndexSet=false&DocId="+docID+"&Userdbid="+sessionId;
    //window.open('dowloadAttachment.jsp?docID='+ docID +'&Userdbid='+ sessionId);
    var ScreenHeight=screen.height;
    var ScreenWidth=screen.width;
    var windowH=450;
    var windowW=950;
    var WindowHeight=windowH-100;
    var WindowWidth=windowW;
    var WindowLeft=parseInt(ScreenWidth/2)-parseInt(WindowWidth/2);
    var WindowTop=parseInt(ScreenHeight/2)-parseInt(WindowHeight/2)-50;
    var wiWindowRef = window.open(url, 'DocView', 'scrollbars=yes,left='+WindowLeft+',top='+WindowTop+',height='+windowH+',width='+windowW+',resizable=yes')

    
  });

  $(document).off().on('click','.delete-item', function(event){

    var itemToDelete = $(event.target).parent().parent();
    if(itemToDelete.siblings().length === 0){
      
      var unitBodyDiv = $(itemToDelete).parent().parent();    
      $(itemToDelete).remove();
      $(unitBodyDiv).children(':visible').remove();
      $(unitBodyDiv).children(".no-doc-div").show();
    
    }else{

      $(itemToDelete).remove();      
    }
     
  });


   $(document).off().on('change','.unit-attach-file',function(event){
    var id = $(event.target).attr("id");
    var x = document.getElementById(id);// element id
    //var docUnitDiv = $("[data-id='"+ id +"']");
    var docUnitDiv = $(this).closest(".doc-unit-header").siblings(".doc-unit-body");
    var emptyUnit = true, docUnitDetails="";
    if(docUnitDiv.find(".doc-unit-detail").length>0){
      emptyUnit = false;
    }
    if ('files' in x) {
      if (x.files.length == 0) {
        alert("Please select a file."); // alert for no file selected
      } else {
        
          var file = x.files[0];
          var controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
          var doctype = jQuery(x).parents(".doc-unit-header").children()[0].childNodes[1].id;
          // $("#spinnerdiv").show();
           uploadFileToOD(file,controlid,doctype, function(docID){
            
            $("#spinnerdiv").hide();
            if ('name' in file) {
            var fileName = file.name; 
            }
            if ('size' in file) {

                var fileSize = file.size;
                if((file.size/1024) < 1024)
                  fileSize = (file.size/1024).toFixed(4) + "KB";
                else
                  fileSize = ((file.size/1024)/1024).toFixed(4) + "MB"; 
            }
            if('type' in file){
                var type = file.type.split('/')[1];
                var icon= getIcon(type);
            }
            docUnitDetails += "           <div class=\"col-md-12 doc-unit-detail\">\n" +
                              "             <div class=\"doc-unit-name\"data-docID=\""+ docID +"\">\n" +
                                "               <img src=\""+ icon +"\"> <p>"+ fileName +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"doc-unit-size\">\n" +
                                "               <p>"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"doc-unit-delete\">\n" +
                                "               <i class=\"far fa-trash-alt delete-item\"></i>\n" +
                                "             </div>\n" +
                              "           </div>";
            docUnitDetails += "\n";                  
        

            if(emptyUnit){
              var docUnitHtml = "          <div class=\"col-md-8 doc-detail-wrapper\">\n" +
                                  docUnitDetails + 
                                  "          </div>\n" +
                                  "          <div class=\"col-md-4 doc-unit-comment\">\n" +
                                  "            <textarea placeholder=\"write comments....\"></textarea>\n" +
                                    "          </div>"
            docUnitDiv.children(".no-doc-div").hide();
            docUnitDiv.append(docUnitHtml);                  
        
            }else{

              var docDetailWrapper = docUnitDiv.find(".doc-detail-wrapper");
              docDetailWrapper.append(docUnitDetails);
            }         
           });

      }
    } 
    else { // handling cases when files property isnt supported
      if (x.value == "") {
         alert("Please select a file.");
      } else {
        alert("The files property is not supported by your browser!");
      }
    }
  });


  $(document).off().on('click','.unit-attach-drop',function(event){
    $(this).parent().parent().siblings(".unit-attach-dropdown").toggle();
  });
      
  $(document).off().on('click','.unit-attach-option',function(event){
    $(this).parent(".unit-attach-dropdown").children(".unit-attach-option").children(".hollow-star").show();
    $(this).parent(".unit-attach-dropdown").children(".unit-attach-option").children(".solid-star").hide();
    $(this).children(".solid-star").show();
    $(this).children(".hollow-star").hide();
    $(this).parent(".unit-attach-dropdown").hide();
  });  */


function docUnitName(event){
    try{
	var dbid = "";
    var url = "portal/appTask.jsp";
    var queryString = "oper=GetDBId&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    dbid = iforms.ajax.processRequest(queryString, url);
    var docID = $(event.target).parent().attr("data-docID");
    var fileName = $(event.target).parent().find("p").get(0).title;
    var url = "../../docDownload?pid=" + pid + "&wid=" + wid + "&tid=" + tid + "&fid=" + fid + "&cabinetName=" + cabinetName + "&DocId=" + docID + "&DocName=" + fileName + "&Userdbid=" + dbid;
    if (typeof iosDtype!='undefined' && iosDtype && (typeof mobileMode!='undefined' && mobileMode==='')) {
        var aTag = document.getElementById("docDowloada");
        if (aTag === null) {
            aTag = document.createElement("a");
            aTag.id = "docDownloadhi";
            aTag.style.display = "none";
            document.getElementById("oforms_iform").appendChild(aTag);
            $('#docDowloada').attr('target', '_blank');
        }
        aTag.href = url;
        aTag.click();
    } else {
        var iframess = document.getElementById("docDownloadhi");
        if (iframess === null) {
            iframess = document.createElement("iframe");
            iframess.id = "docDownloadhi";
            iframess.style.display = "none";
            document.getElementById("oforms_iform").appendChild(iframess);
        }
        iframess.src = url;
    }
    
    } catch(e){
    }
    
}
var globalref=null;
function deleteItem(event,ref){
    var fileName = $($(ref).parent().parent().find('.doc-unit-name p')[0]).text();  
    globalref=ref;
    var msg = DELETE_DOC_MSG+ fileName + " ?";
    var btns = {
        confirm: {
            label: YES_REMOVE,
            className: 'btn-success'
        },
        cancel: {
            label: CANCEL,
            className: 'btn-danger'
        }
    }
    var callback = function (result) {
        if (result) {
            var itemToDelete = $(globalref).parent().parent().parent();   
            var docid =  itemToDelete.find(".doc-unit-name").attr("data-docid");
            var ctrid = jQuery(itemToDelete.parents(".doc-list-body")[0]).attr("id");
            deletedoc(ctrid,docid);
              var unitBodyDiv = $(itemToDelete).parent().parent();   
        //      $(itemToDelete).parent().next().remove();
              $(itemToDelete).parent().remove();
//              if( $(unitBodyDiv).width() > 760 && unitBodyDiv.children().length === 1)
//                    $(unitBodyDiv).children(".no-doc-div").show();
    
        }
    }
    showConfirmDialog(msg, btns, callback);
//    var itemToDelete = $(event.target).parent().parent();   
//    var docid =  itemToDelete.find(".doc-unit-name").attr("data-docid");
//    var ctrid = jQuery(itemToDelete.parents(".doc-list-body")[0]).attr("id");
//    deletedoc(ctrid,docid);
//      var unitBodyDiv = $(itemToDelete).parent().parent();   
////      $(itemToDelete).parent().next().remove();
//      $(itemToDelete).parent().remove();
//      if(unitBodyDiv.children().length === 1)
//            $(unitBodyDiv).children(".no-doc-div").show();
//    
    
}

function attachmentDropdownToggle(event){
    var dropdown = $(event.target).parent().parent().siblings(".unit-attach-dropdown");
    if(dropdown.is(":visible")){
        dropdown.hide();
    }else{
        dropdown.show();
    }
    //$(event.target).parent().parent().siblings(".unit-attach-dropdown").toggle();
}

function attachmentOptionToggle(event){
    var that = $(event.target);
    that.parent(".unit-attach-dropdown").children(".unit-attach-option").children(".hollow-star").show();
    that.parent(".unit-attach-dropdown").children(".unit-attach-option").children(".solid-star").hide();
    that.children(".solid-star").show();
    that.children(".hollow-star").hide();
    that.parent(".unit-attach-dropdown").hide();
}

function pickDocumentListFiles(event){
    var id = $(event.target).attr("id");
    var x = document.getElementById(id);// element id
    //var docUnitDiv = $("[data-id='"+ id +"']");
     lattitude='',longitude='';
    var docUnitDiv = $(event.target).closest(".doc-unit-header").siblings(".doc-unit-body");
    var emptyUnit = true, docUnitDetails="";
    if(docUnitDiv.find(".doc-unit-detail").length>0){
      emptyUnit = false;
    }
    if ('files' in x) {
      if (x.files.length == 0) {
        //alert("Please select a file."); // alert for no file selected
      } else {
        
          var file = x.files[0];
          var controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
          var doctype = jQuery(x).parents(".doc-unit-header").children()[0];
           doctype=doctype.getElementsByClassName("identifer");
                  doctype=$(doctype).attr("id");
                  // $("#spinnerdiv").show();
           if(window.validateDocumentConfiguration)
           {
               var type;
               if ('name' in file) {
                   var fileName = file.name; 
                   type=fileName.split('.')[fileName.split('.').length-1];
                   
                }
                else
                {
                    type=file.type.split('/')[1];
                }
                  if(!validateDocumentConfiguration(controlid,doctype,file.size,type))
                  {
                       return false;
                  }
           }
           else
           {
               if('size' in file)
                {
                    var fileSize = file.size;
                    fileSize = (file.size/1024).toFixed(4);
                    if(fileSize>10240)
                    {
                        showAlertDialog(MAX_FILE_SIZE_ERROR,false);
                        return false;
                     }
                 }
                
           }
            var file = x.files[0];
                 var controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
                  var doctype = jQuery(x).parents(".doc-unit-header").children()[0];
                 doctype=doctype.getElementsByClassName("identifer");
                 doctype=$(doctype).attr("id");
          CreateIndicator('browseUpload');
		  var isRestrictMultipleDocUpload=false;
          if(window.restrictMultipleDocUpload)
          {
              isRestrictMultipleDocUpload=restrictMultipleDocUpload(controlid,doctype);
              if(isRestrictMultipleDocUpload === true && emptyUnit==false)
              {
                  var docid=$(docUnitDiv.find(".doc-unit-detail")).find(".doc-unit-name").attr("data-docid");
                  deletedoc(controlid,docid);
                  $(docUnitDiv.find(".doc-unit-detail")).parent().remove();
              }
          }
           uploadFileToOD(file,controlid,doctype, function(docID){
            
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
            /*if('type' in file){
                var type = file.type.split('/')[1];
                var icon= getIcon(type);
            }*/
            docUnitDetails += "           <div class=\"col-md-12 col-sm-12 col-xs-12 doc-unit-detail\">\n" +
                               "            <div class=\"col-md-6 col-sm-8 col-xs-12 \" style=\"padding: 3px;padding-top:10px;border: 1px solid #EBEBEB;border-radius: 1px;background-color: #F9F9F9;margin-bottom:5px;\">\n";
            if((applicationName!=null && applicationName!='') || ((mobileMode=="ios") || (mobileMode=="android")))           
              docUnitDetails +=   "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else if((window.opener!=null && typeof window.opener.applicationName!='undefined' && (window.opener.applicationName!=null && window.opener.applicationName!='')) || ((mobileMode=="ios") || (mobileMode=="android"))) 
              docUnitDetails +=   "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else
              docUnitDetails +=   "             <div class=\"col-md-10 col-sm-10 col-xs-10 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"openDocInViewer(event)\">\n" ; 
              
               docUnitDetails +=  "               <img src=\""+ icon +"\"> <p title=\""+fileName+"\">"+ fileName +"</p>\n" +
                                "               <p class='add-doc-size' style='font-size:10px;font-weight:400;margin-top:0px;'>"+ fileSize+"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-md-1 col-sm-1 col-xs-1 doc-unit-size\">\n" +
                                "               <p>"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-md-1 col-sm-1 col-xs-1 doc-unit-delete\" >\n" +
                                "<span  onclick=\"deleteItem(event,this)\" style=\"cursor:pointer;\" ><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\" style=\"vertical-align: -webkit-baseline-middle;\" viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>"+DELETE+"</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg></span>"+
                                //"               <img class=\"delete-item\" src='../../components/viewer/resources/images/DeleteIconEnabled.png' onclick=\"deleteItem(event)\"  /> \n" +
                               // "        <p>Remove</p>" +
                                "             </div>\n" +
                                "             </div>\n" +
                                            "<div class=\"col-md-5 col-sm-4 col-xs-12 doc-unit-comments errorMessageHoverDiv\">\n"+
                                            "<textarea class=\"form-textarea form-input control-class\" style=\"resize:none;margin-bottom:12px;border-color:#ccc;width:100%;padding:5px;padding-top: 12px;padding-bottom: 0px;\" maxlength=\"4000\" onmouseover=\"this.title=this.value\" rows=\"2\" onchange=\"updateDocComment(this)\" id=\"textarea_"+docID+"\" datatype=\"textarea\" type=\"textarea\"";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
            docUnitDetails +=" required";    
            docUnitDetails +="                                ></textarea>\n"+
                                            "<label style=\"position:absolute;top:80px; \"  class=\"form-label control-label inputLabelStyle ";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
                docUnitDetails +=" mandatoryLabel";
               docUnitDetails +="\"  id=\"textarea_"+docID+"_label\">"+Doc_Comments_label+"</label>\n"+"<div class=\"mandatoryMessageDiv mndErrorMsgDiv\" id=\"textarea_"+docID+"_msg\" style=\"display:none;\">"+Doc_Comments_Msg+"</div>           </div>\n" +
                              "           </div>";
            docUnitDetails += "\n";                  
        

            
              var docUnitHtml = "          <div class=\"col-md-12 col-sm-12 col-xs-12 doc-detail-wrapper\">\n" + docUnitDetails + 
                                "           </div>\n";
//               docUnitHtml +=    "          <div class=\"col-md-4 col-sm-4 col-xs-4 doc-unit-comment\">\n" +
//                                "           <textarea onchange = \"updateDocComment(this)\" placeholder=\"write comments....\"></textarea>\n" +
//                                "          </div>";
                                  
//            docUnitDiv.children(".no-doc-div").hide();
            docUnitDiv.append(docUnitHtml); 
            
            initFloatingMessagesForPrimitiveFields('.errorMessageHoverDiv');
            initializeTextArea();
            if(document.getElementById(controlid+"_"+doctype+"_label")!=null){
                 $(document.getElementById(controlid+"_"+doctype+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                 $(document.getElementById(controlid+"_"+doctype+"_label")).addClass('mandatoryLabel');
                 document.getElementById(controlid+"_"+doctype+"_msg").removeAttribute("showMessage");
                 $(document.getElementById(controlid+"_"+doctype)).removeClass('mandatory');
                 delete ComponentValidatedMap[controlid+"_"+doctype];
            }
           RemoveIndicator('browseUpload');
                 
           });
        x.value="";      
      }
    } 
    else { // handling cases when files property isnt supported
      if (x.value == "") {
         alert("Please select a file.");
      } else {
        alert("The files property is not supported by your browser!");
      }
    }
}
function initializeTextArea()
{
    var $input = $('.form-input');
    var $textarea = $('.form-textarea');
    $input.focusout(function() {
                if($(this).val().length > 0) {
                    $(this).addClass('input-focus');
                    $(this).next('.form-label').addClass('input-focus-label');
                }
                else {
                    $(this).removeClass('input-focus');
                    $(this).next('.form-label').removeClass('input-focus-label');

                }
            });


            $textarea.focusout(function() {
                if($(this).val().length > 0) {
                    $(this).addClass('textarea-focus');
                    $(this).next('.form-label').addClass('textarea-focus-label');
                }
                else {
                    $(this).removeClass('textarea-focus');
                    $(this).next('.form-label').removeClass('textarea-focus-label');

                }
            });
}


function triggerLabelClick(event){
	if(window.customizeAllowedDocType)
    {
       var id = $(event.target).attr("id");
       if(id != undefined)
       {
       var x = document.getElementById(id);
       var controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
        var doctype = jQuery(x).parents(".doc-unit-header").children()[0];
       doctype=doctype.getElementsByClassName("identifer");
       doctype=$(doctype).attr("id");var str=customizeAllowedDocType(controlid,doctype);
        document.getElementById(id).accept=str;
       }
    }
    $(event.target).nextAll("input").trigger("click");
}

var lattitude,longitude;    
function getLocation() {
  lattitude='',longitude='';  
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition, showError);
  } 
}

function updateLocation(){
    lattitude='',longitude=''; 
    if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
    } 
}

function showPosition(position) {
   lattitude=position.coords.latitude;
   longitude=position.coords.longitude;
}

function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
      showAlertDialog(ACCESS_DENIED_LOCATION,false);
      break;
    case error.POSITION_UNAVAILABLE:
      showAlertDialog(LOCATION_UNAVILABLE,false);
      break;
    case error.TIMEOUT:
      showAlertDialog(TIME_OUT_LOCATION,false);
      break;
    case error.UNKNOWN_ERROR:
      showAlertDialog(ERROR_OCCURRED,false);
      break;
  }
}

function openDocInViewer(event){
	 var dbid = "";
    var url = "portal/appTask.jsp";
    var queryString = "oper=GetDBId&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    dbid = iforms.ajax.processRequest(queryString, url);
    var docID;
    if($(event.target).parent().attr("data-docid")==undefined){
        docID = $(event.target).attr("data-docid");
    }else{
        docID = $(event.target).parent().attr("data-docid");
    }
    //"/omnidocs/integration/foldView/viewFoldList.jsp
    var url = "/omnidocs/WebApiRequestRedirection?Application=DocView&cabinetName="+cabinetName+"&sessionIndexSet=false&DocumentId="+docID+"&Userdbid="+dbid+"&S=S&enableDCInfo=true";
    //window.open('dowloadAttachment.jsp?docID='+ docID +'&Userdbid='+ sessionId);
    var ScreenHeight=screen.height;
    var ScreenWidth=screen.width;
    var windowH=450;
    var windowW=950;
    var WindowHeight=windowH-100;
    var WindowWidth=windowW;
    var WindowLeft=parseInt(ScreenWidth/2)-parseInt(WindowWidth/2);
    var WindowTop=parseInt(ScreenHeight/2)-parseInt(WindowHeight/2)-50;
    var wiWindowRef = window.open(url, 'DocView', 'scrollbars=yes,left='+WindowLeft+',top='+WindowTop+',height='+windowH+',width='+windowW+',resizable=yes')
     // var url = "docviewer.jsp";
     // var requestString= "cabinetName="+cabinetName+"&DocumentId="+docID+"&Userdbid="+sessionId;
      //var contentLoaderRef = new net.ContentLoader(url, documentViewerHandler, documentViewerErrorHandler, "POST", requestString, true);
     
}

function documentViewerHandler(){
    
}

function documentViewerErrorHandler(){
    
}