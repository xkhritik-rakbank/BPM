<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank TF
//Module                     : Service Request Other 
//File Name					 : richText.jsp
//Author                     : Sajan 
// Date written (DD/MM/YYYY) : 12-10-2018
//Description                : File to save data in history table on the basis of category and subcategory
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ page import ="org.w3c.dom.*"%>
<%@ include file="Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Rich Text</title>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE11" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0"/>
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\font-awesome.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\froala_editor.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\froala_style.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\code_view.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\colors.css">
<!--<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\emoticons.css">-->
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\image_manager.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\image.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\line_breaker.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\table.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\char_counter.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\video.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\fullscreen.css">
<!--<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\file.css">-->
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\quick_insert.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\codemirror.min.css">


 <!--<script src="/TF/webtop/scripts/TF_Script/jquery.min.map"></script>-->
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/jquery.min.js"></script>
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/json3.min.js"></script>-->
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/codemirror.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/xml.min.js"></script>

<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/froala_editor.min.js" ></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/align.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/char_counter.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/code_beautifier.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/code_view.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/colors.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/draggable.min.js"></script>
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/emoticons.min.js"></script>-->
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/entities.min.js"></script>
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/file.min.js"></script>-->
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/font_size.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/font_family.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/fullscreen.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/image.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/image_manager.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/line_breaker.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/inline_style.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/link.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/lists.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/paragraph_format.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/paragraph_style.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/quick_insert.min.js"></script>
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/quote.min.js"></script>-->
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/table.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/save.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/url.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/video.min.js"></script>
  <script>
	/*$(document).ready(function(){	  
		var strRemarks=window.opener.document.getElementById("wdesk:Remarks").contentWindow.document.body.innerHTML;
		if(strRemarks != null && strRemarks !="")
		{
			$(".fr-placeholder").remove();
			document.getElementsByClassName('fr-element fr-view')[0].innerHTML=strRemarks;
		}
		else
		{					
			document.getElementsByClassName('fr-element fr-view')[0].innerHTML="";					
		}
	  
	  });*/
	  
    $(function(){
      $('#edit').froalaEditor()
        .on('froalaEditor.image.beforeUpload', function (e, editor, files) {
          if (files.length) {
            var reader = new FileReader();
            reader.onload = function (e) {
              var result = e.target.result;

              editor.image.insert(result, null, null, editor.image.get());
            };

            reader.readAsDataURL(files[0]);
          }

          return false;
        })
    });
  </script>
  <script>
	function setRichText() //For populating richtext from remarks
	{
		var strRemarks=window.opener.document.getElementById("remarks").value;
						
			strRemarks=strRemarks.replace(/lt;/g, '<');
			strRemarks=strRemarks.replace(/gt;/g, '>');
			//strRemarks=strRemarks.replace(/AMPNDCHAR/g,'&');
			//strRemarks=strRemarks.replace(/\PPPLUSSS/g,'');
			//strRemarks = strRemarks.split("CCCOMMAAA").join(",");
			//strRemarks = strRemarks.split("PPPERCENTTT").join("%");
		if(strRemarks != null && strRemarks !="")
		{
			document.getElementsByClassName('fr-placeholder')[0].innerHTML="";
			document.getElementsByClassName('fr-element fr-view')[0].innerHTML=strRemarks;			
		}
		else
		{					
			document.getElementsByClassName('fr-element fr-view')[0].innerHTML="";					
		}
	}
	function addToRemarks() //For populating remarks from richtext
	{
		var richTextNodeValue = document.getElementsByClassName('fr-element fr-view');
		var i;
		for(i=0;i<richTextNodeValue.length;i++)
		{
			//setting border for table
			var flag=false;
			var tabletag=true;
			var str='border ="1" ';
			var richTextFinalValue='';
			var word=richTextNodeValue[i].innerHTML;
			if(word.indexOf("<table") != -1)
			{
				for(var k=0;k<word.length;k++)
				{
					if(!flag)
					{
						if(word[k] == ' ')
						{
							flag=true;
						}
						richTextFinalValue = richTextFinalValue+word[k];
					}
					else if(flag && tabletag)
					{
						for(var j=0;j<str.length;j++)
						{
							richTextFinalValue = richTextFinalValue+str[j];
						}
						richTextFinalValue = richTextFinalValue+word[k];
						flag=false;
						tabletag=false;
					}
					else
					{
						richTextFinalValue = richTextFinalValue+word[k];
					}
				}
			}
			if(richTextFinalValue == '')
				richTextFinalValue=word;
				
			richTextFinalValue=richTextFinalValue.replace(/</g, 'lt;');
			richTextFinalValue=richTextFinalValue.replace(/>/g, 'gt;');
		/*	richTextFinalValue=richTextFinalValue.replace(/&/g,'AMPNDCHAR');
			richTextFinalValue=richTextFinalValue.replace(/\+/g,'PPPLUSSS');
			richTextFinalValue = richTextFinalValue.split(",").join("CCCOMMAAA");
			richTextFinalValue = richTextFinalValue.split("%").join("PPPERCENTTT");   */
	//******************************************
			window.opener.document.getElementById("remarks").value=richTextFinalValue;
			
		}
		
		window.close();
	}
	function hideLine() //For hiding the license copy
	{
		//alert(event.type);
		var NodeValue = document.getElementsByTagName('a');
		var i;
		for(i=0;i<NodeValue.length;i++)
		{
			if(NodeValue[i].innerHTML == "Unlicensed copy of the Froala Editor. Use it legally by purchasing a license.")
				NodeValue[i].style.visibility="hidden";				
		}
	}

  </script>

  <style>
      body 
	  {
		  width: 100%;
          margin: auto;
          text-align: center;
      }

      div#editor
	  {
          width: 85%;
          margin: auto;
          text-align: left;
      }

      .class1 
	  {
        border-radius: 50%;
        border: 2px solid #efefef;
      }

      .class2 
	  {
        opacity: 0.5;
      }	 
  </style>
</head>

<body onload="hideLine();setRichText();">
	
	
  <div id="editor">
    <div id='edit' style="margin-top: 30px;">
	</div>
  </div>
  <br>
  </br>
	<div>
			<button onclick="addToRemarks();" id="OK" align=center>OK</button>
	</div>
</html>
</body>
