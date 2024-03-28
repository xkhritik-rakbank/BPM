
/*function ckeditorInit(){
    if ( CKEDITOR.env.ie && CKEDITOR.env.version < 9 )
        CKEDITOR.tools.enableHtml5Elements( document );

    // The trick to keep the editor in the sample quite small
    // unless user specified own height.
    CKEDITOR.config.height = 150;
    CKEDITOR.config.width = 'auto'; 
}

function isWysiwygareaAvailable() {
    // If in development mode, then the wysiwygarea must be available.
    // Split REV into two strings so builder does not replace it :D.
    if ( CKEDITOR.revision == ( '%RE' + 'V%' ) ) {
        return true;
    }

    return !!CKEDITOR.plugins.get( 'wysiwygarea' );
}

function initCKEditor (controlName) {
    var wysiwygareaAvailable = isWysiwygareaAvailable(),
    isBBCodeBuiltIn = !!CKEDITOR.plugins.get( 'bbcode' );


    var editorElement = CKEDITOR.document.getById( controlName);

    // :(((
    if ( isBBCodeBuiltIn ) {
        editorElement.setHtml(
            'Hello world!\n\n' +
            'I\'m an instance of [url=https://ckeditor.com]CKEditor[/url].'
            );
    }

    // Depending on the wysiwygarea plugin availability initialize classic or inline editor.
    if ( wysiwygareaAvailable ) {
        CKEDITOR.replace( controlName, {
            // Define the toolbar groups as it is a more accessible solution.
            toolbarGroups: [
            {
                name: 'clipboard',   
                groups: [ 'clipboard', 'undo' ]
            },

            {
                name: 'editing',     
                groups: [ 'find', 'selection', 'spellchecker' ]
            },

            {
                name: 'links'
            },

            {
                name: 'insert'
            },

            {
                name: 'forms'
            },

            {
                name: 'tools'
            },

            {
                name: 'document',	   
                groups: [ 'mode', 'document', 'doctools' ]
            },

            {
                name: 'others'
            },
            '/',
            {
                name: 'basicstyles', 
                groups: [ 'basicstyles', 'cleanup' ]
            },

            {
                name: 'paragraph',   
                groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ]
            },

            {
                name: 'styles'
            },

            {
                name: 'colors'
            },

            {
                name: 'about'
            }
            ],
            // Remove the redundant buttons from toolbar groups defined above.
            removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
        }); 
    } else {
        editorElement.setAttribute( 'contenteditable', 'true' );
        CKEDITOR.inline(controlName);

    // TODO we can consider displaying some info box that
    // without wysiwygarea the classic editor may not work.
    }



}*/

function saveRichTextEditorData(modalId,dataValue,isCopyRow){
    var textareas;
    var ckiframes;
    var textareas = document.getElementsByClassName("richtexteditor");
    if(modalId==undefined && dataValue==undefined && isCopyRow==undefined)
        //textareas = $(".ckeditorIframe").contents().find(".richtexteditor");
        textareas = document.getElementsByClassName("richtexteditor");
    else{
        //textareas = $('#'+modalId).find(".listViewCKEditorIframe").contents().find(".richtexteditor");
        textareas = $('#'+modalId).find(".richtexteditor");
    }
    
    var textareaIframeCKEDITOR;
    var richTextEditorData=[];   
    if(window.getCustomRichTextEditorData){
        richTextEditorData=window.getCustomRichTextEditorData(textareas);
    }else{
        for(var i=(textareas.length-1);i>=0;i--){
           // if(textareas[i]!=undefined && jQuery("#"+textareas[i].id+"_ckiframe").contents().find("#"+textareas[i].id).attr("initialized")=="true"){
            if(textareas[i]!=undefined && (jQuery("#"+textareas[i].id).attr("contentChanged")=="true" || isCopyRow)){
                try{
                    //textareaIframeCKEDITOR = window.frames[textareas[i].id+"_ckiframe"].contentWindow.CKEDITOR;
                   // textareaIframeCKEDITOR = CKEDITOR.instances[textareas[i].id];
                }
                catch(ex){
                    //textareaIframeCKEDITOR = window.frames[textareas[i].id+"_ckiframe"].CKEDITOR;
                    //textareaIframeCKEDITOR = CKEDITOR.instances[textareas[i].id];
                }
                //if(textareaIframeCKEDITOR.instances[textareas[i].id].checkDirty() || isCopyRow){
                    var editorData={};
                    editorData.id=textareas[i].id;
                   // editorData.data=textareaIframeCKEDITOR.instances[textareas[i].id].getData();     
                    editorData.data=$("#"+textareas[i].id).froalaEditor('html.get', true);
                    //if(editorData.data!="")
                    if(editorData.data.length == 0)
                        editorData.data="";
                        richTextEditorData.push(editorData);
                    if(modalId=="iFrameListViewModal")
                        dataValue[formatJSONValue(textareas[i].getAttribute("labelName"))]=editorData.data;
                    else if(modalId=="iFrameAdvancedListViewModal")
                        dataValue[formatJSONValue(textareas[i].id)]=editorData.data;
               // }
               jQuery("#"+textareas[i].id).removeAttr("contentChanged");
            }
        } 
    }           
    saveRichTextEditor(richTextEditorData);
    if(dataValue!=undefined)
        return dataValue;
}

function populateRichTextEditor(richTextEditorJSON){
    if(richTextEditorJSON.length>0){
        var url = "ifhandler.jsp";
        var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&op=6&fid="+encode_utf8(fid)+"&richTextEditorJSON="+JSON.stringify(richTextEditorJSON);
        //var responseData = window.parent.iforms.ajax.processRequest(requestString, url);    
        var responseData = iforms.ajax.processRequest(requestString, url);    
        return responseData;
    }
    return "";
}

function saveRichTextEditor(richTextEditorData){
    if(richTextEditorData!=undefined && richTextEditorData.length>0){
        var url = "ifhandler.jsp";
        var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&fid="+encode_utf8(fid);
        requestString=requestString+"&op=7&richTextEditorData="+encode_utf8(JSON.stringify(richTextEditorData));
        var responseText=iforms.ajax.processRequest(requestString, url);
        if(responseText.trim()!=''){
        var jsonObj = JSON.parse(responseText.trim());
        if(jsonObj["status"]=="error"){
            showSplitMessage("",jsonObj["message"],SAVE_TITLE,"error");
        }
        else
            documentIndex=jsonObj["message"];
        }

    }
}

function expandTextareaSection(ref,textareaId){
    //var ckiframe = document.getElementById(textareaId+"_ckiframe");
    
    if(jQuery(ref).attr("state") == "collapsed")
    {
       // ckiframe.style.display="";
        jQuery("#"+textareaId+"_expandcollapseicon").attr("src","resources/images/rte-up-arrow.png");
        jQuery(ref).attr("state","expanded");
        if(jQuery(ref).attr("painted")=="false"){            
           // ckiframe.src = "texteditor.jsp?textareaId="+textareaId+"&tid="+encode_utf8(tid)+"&pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&fid="+encode_utf8(fid);
            jQuery(ref).attr("painted","true");
            viewRichTextData(textareaId);
        }else
            jQuery(ref).parent().find(".fr-box").css("display", "block");
            //$("#"+textareaId).froalaEditor('toolbar.show');
    }
    else
    {
       // ckiframe.style.display="none";
        //$("#"+textareaId).froalaEditor('toolbar.hide');
        jQuery(ref).parent().find(".fr-box").css("display", "none");
        jQuery("#"+textareaId+"_expandcollapseicon").attr("src","resources/images/rte-down-arrow.png");
        jQuery(ref).attr("state","collapsed");            
    }  
    
    
}

function viewRichTextData(id){
    var control = document.getElementById(id);
        if(useCustomIdAsControlName && (control==null || control==undefined)){
            control = document.getElementsByName(id)[0];
            if( control != null && control != undefined )
               id = control.getAttribute("id");
        }
    if(window.customRichTextEditor){
        window.customRichTextEditor();
    }else{
        //ckeditorInit();
        var richTextEditorJSON=[];
        var editor={};   
        var numOfRows;
        var textAreaRef;
       // var ckiframe = window.parent.document.getElementById(id+"_ckiframe");
        try{
            //textAreaRef = ckiframe.contentWindow.document.getElementById(id);
           // numOfRows = ckiframe.contentWindow.document.getElementById(id).getAttribute("rows");
            numOfRows = document.getElementById(id).getAttribute("rows");
        }
        catch(ex){
          //  textAreaRef = ckiframe.contentWindow.document.getElementById(id);
            //numOfRows = ckiframe.document.getElementById(id).getAttribute("rows");
            //numOfRows = document.getElementById(id).getAttribute("rows");
        }
		var fonts = {
	      'Arial,Helvetica,sans-serif': 'Arial',
	      'Arial Black,Arial Bold,Gadget, sans-serif': 'Arial Black',
	      'Arial Narrow,Arial,sans-serif': 'Arial Narrow',
	      'Georgia,serif': 'Georgia',
	      'Impact,Charcoal,sans-serif': 'Impact',
	      'Tahoma,Geneva,sans-serif': 'Tahoma',
	      'Times New Roman,Times,serif,-webkit-standard': 'Times New Roman',
	      'Verdana,Geneva,sans-serif': 'Verdana',
	      'Helvetica Neue,Helvetica,Arial,sans-serif': 'Helvetica',
              'Roboto,sans-serif': 'Roboto',
              'Oswald,sans-serif': 'Oswald',
              'Montserrat,sans-serif': 'Montserrat',
              'Open Sans Condensed,sans-serif': 'Open Sans Condensed'
	    };
        var jsonArray=getFeatureForRichTextEditor();
		 var language = (typeof iformLocale == "undefined") ? 'en_us' : iformLocale;
        language = language.replace('/', '');
        var direction = "ltr";
        if (language.startsWith("ar"))
        {
            direction = "rtl"
        }
        var locale = "";
        switch (language) {
            case "ar":
                locale = "ar";
                break;
            case "ar_sa":
                locale = "ar";
                break;
            case "de":
                locale = "de";
                break;
            case "es":
                locale = "es";
                break;
            case "es_do":
                locale = "es";
                break;
            case "fr_fr":
                locale = "fr";
                break;
            case "nl":
                locale = "nl";
                break;
            case "pt":
                locale = "pt_pt";
                break;
        }
        $("#"+id).froalaEditor({
             key: '7A5D4A3E3cA5A4D4E3E4C2E2E3D1C6vDIG1QCYRWa1GPId1f1I1==',
             toolbarSticky:false,
              //toolbarButtons: ['bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', '|', 'fontFamily', 'fontSize', 'color', 'inlineStyle', 'inlineClass', 'clearFormatting', '|', 'emoticons', 'fontAwesome', 'specialCharacters', '|', 'paragraphFormat', 'lineHeight', 'paragraphStyle', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', '|', 'insertLink', 'insertImage', 'insertVideo', 'insertFile', 'insertTable', '|', 'insertHR', 'selectAll', 'getPDF', 'print', 'help', 'html', 'fullscreen', '|', 'undo', 'redo'],
            // toolbarButtons: ['bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', 'color', 'inlineStyle', 'inlineClass', 'clearFormatting', 'emoticons', 'fontAwesome', 'specialCharacters', 'paragraphFormat', 'lineHeight', 'paragraphStyle', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote','insertLink', 'insertImage', 'insertVideo', 'insertFile', 'insertTable', 'insertHR', 'selectAll', 'getPDF', 'print', 'help', 'html', 'fullscreen', 'undo', 'redo'],
             toolbarButtons:jsonArray,
             heightMax:parseInt(numOfRows)*20,
             height: parseInt(numOfRows)*20,
             fontFamily: fonts,
             quickInsertEnabled: false,
              charCounterMax:maxCharacterLimitForRichText(id),
             direction:direction,
             language:locale
             
        })
        $("#"+id).froalaEditor('events.on', 'keydown', function (e) { 
            //console.log (e.which);
            updateSessionTimeout();
        }, false);
        $("#"+id).on('froalaEditor.contentChanged', function (e, editor) {
            jQuery("#"+id).attr("contentChanged","true");
            onChangeRTE(id);
            
        });
        $("#"+id).froalaEditor().on('froalaEditor.image.beforeUpload', function (e, editor, files) {

        if (files.length) {
          // Create a File Reader.
          var reader = new FileReader();
          // Set the reader to insert images when they are loaded.
          reader.onload = function (e) {
            var result = e.target.result;
            editor.image.insert(result, null, null, editor.image.get());
          };
          // Read image as base64.
          reader.readAsDataURL(files[0]);
        }
        editor.popups.hideAll();
        // Stop default upload chain.
        return false;

      })
       // initCKEditor(id);
        jQuery("#"+id).attr("painted","true");
        jQuery("#"+id).attr("initialized","true");        
        
        editor.id=id;
        richTextEditorJSON.push(editor);
        if(window.parent!=undefined && window.setDefaultRichTextData && window.setDefaultRichTextData(id)){
            var customData=window.setDefaultRichTextData(id);
           // CKEDITOR.instances[id].setData(customData);  
           $("#"+id).froalaEditor('html.set',customData);
        }
        else{
        var responseText=populateRichTextEditor(richTextEditorJSON);
        
        if(responseText.trim()!="")
        {   
            var jsonObj=JSON.parse(decode_utf8(responseText.trim()));
            for (var count = 0; count < jsonObj.length; count++) 
            {
                var ctrlId=jsonObj[count].id;
                var ctrlValue=jsonObj[count].value;
                $("#"+ctrlId).froalaEditor('html.set',ctrlValue.replace("base href","base hreff"));
               // CKEDITOR.instances[ctrlId].setData(ctrlValue);                   
            }
        }
        }
        
        //var richTextDiv = window.parent.document.getElementById("expandibleDiv_"+id);        
        var richTextDiv = document.getElementById("expandibleDiv_"+id);        
        
       // CKEDITOR.instances[id].config.height=parseInt(numOfRows)*20;
        //CKEDITOR.instances[id].on("instanceReady", function(event)
       // {
            if(richTextDiv.classList.contains("disabledTextarea"))
                $("#"+id).froalaEditor('edit.off');
                //ckiframe.contentWindow.CKEDITOR.instances[id].setReadOnly(true);
            else
               // ckiframe.contentWindow.CKEDITOR.instances[id].setReadOnly(false);
                $("#"+id).froalaEditor('edit.on');
           // ckiframe.height = ckiframe.contentWindow.document.body.scrollHeight;
            if(window.parent!=undefined && window.parent.onLoadRichTextEditor)
            {
                try
                {
                    if(typeof window.parent.onLoadRichTextEditor)
                        window.parent.onLoadRichTextEditor(id);
                } 
                catch(e)
                {}
            }    
       // });
    }
}

var ENCODING="UTF-8";
var hexArr = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
function encode_utf8(ch)
{
    if (ENCODING.toUpperCase() != "UTF-8")
        return escape(ch);

    return encodeURIComponent(ch);

    var i,bytes;
    var utf8 = new String();
    var temp;

    for(i=0, bytes = 0; i<ch.length; i++)
    {
        temp = ch.charCodeAt(i);
        if(temp < 0x80)
        {
            utf8 += String.fromCharCode(temp);
        }
        else if (temp < 0x0800)
        {
            utf8 += String.fromCharCode((temp>> 6 | 0xC0));
            utf8 += String.fromCharCode((temp & 0x3F | 0x80));
        }
        else
        {
            utf8 += String.fromCharCode((temp>> 12 | 0xE0));
            utf8 += String.fromCharCode((temp>> 6 & 0x3F | 0x80));
            utf8 += String.fromCharCode((temp & 0x3F | 0x80));
        }
    }

    if (navigator.appName.indexOf("Netscape") == -1)
    {
        return escape(utf8);
    }
    var esc = new String();
    for(l=0;l<utf8.length;l++)
    {
        if(utf8.charCodeAt(l)<128)
            esc += escape(utf8[l]);
        else
        {
            esc += "%";
            esc += hexArr[utf8.charCodeAt(l)>>4];
            esc += hexArr[utf8.charCodeAt(l) & 0xf];
        }
    }
    return esc;
}

function getRichTextData(textareaId){
    var textareaIframeCKEDITOR= $("#"+textareaId);
   /* try{
        textareaIframeCKEDITOR = window.frames[textareaId+"_ckiframe"].contentWindow.CKEDITOR;
    }
    catch(ex){
        textareaIframeCKEDITOR = window.frames[textareaId+"_ckiframe"].CKEDITOR;
    }*/
     return textareaIframeCKEDITOR.froalaEditor('html.get', true);   
    //return textareaIframeCKEDITOR.instances[textareaId].getData();     
}

function saveRichTextData(textareaId,HTMLData){
    $("#"+textareaId).froalaEditor('html.set',HTMLData);
    $("#"+textareaId).attr("contentChanged","true");
    valueChanged=true;
}

function toggleRichTextEditor(textareaId,state){
    var richtextFrame = document.getElementById("expandibleDiv_"+textareaId);
    if(richtextFrame!=null && richtextFrame!=undefined){
        if(state=="expanded"){
            if(richtextFrame.getAttribute("state")=="collapsed")
                richtextFrame.click();    
        }
        else if(state=="collapsed"){
            if(richtextFrame.getAttribute("state")=="expanded")
                richtextFrame.click();    
        }
    }
}

function onChangeRTE(textareaId){
    var msgRef =  document.getElementById(textareaId+"_msg");
    if(jQuery("#"+textareaId).attr("required")!=undefined){
        if(getRichTextData(textareaId)!='' ){
            delete ComponentValidatedMap[textareaId];
            toggleErrorTooltip(jQuery("#"+textareaId),msgRef,null,true,0);
        }
        else{
            ComponentValidatedMap[textareaId]=false;
            toggleErrorTooltip(jQuery("#"+textareaId),msgRef,null,true,1);
        }
    }
    valueChanged=true;
    if(window.formChangeHook)
        formChangeHook(document.getElementById(textareaId));
}