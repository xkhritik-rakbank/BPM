 


<html>
<head>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
</head>
<body topmargin=0  class='EWGeneralRB'   >

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

function clearFrames()
{
//alert("CD");
window.parent.frames['frameProcess'].document.location.href="DSR_blank.jsp"; window.parent.frames['frameClose'].document.location.href="DSR_blank.jsp";
return false;
}

function exit()
{
window.parent.close();
return false;
}

function save(args)
{
	if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="DSR_MR"){
		if(args=="Pending"){
			if(window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value==""){
					alert("Please select a Pending For reason");
				}
			else{
				if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}
			}	
		}
		else if(args=="Introduce"){
			window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";
			if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}
		}
		else{
			if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
			}
		}
	}
		else if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()=="DSR_ODC"){
		if(args=="Pending"){
			if((!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCDR.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForECR.value=="")) || (!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForCR.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForRIP.value=="")) ||(!(window.parent.frames['frameProcess'].document.forms['dataform'].PendingForTD.value==""))){
					
					if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}
				}
			else{
				alert("Please select a Pending For reason");
			}	
		}
		else if(args=="Introduce"){
			window.parent.frames['frameProcess'].document.forms['dataform'].PendingOptionsFinal.value="";
			if (window.parent.frames['frameProcess'].introduce(args)!=false ){
					if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
					{
						window.parent.frames['frmProcessList'].clearFrames();
					}
					else 
					{
						window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
						window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
					}
				}
		}
		else{
			if (window.parent.frames['frameProcess'].introduce(args)!=false ){
				if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
				{
					window.parent.frames['frmProcessList'].clearFrames();
				}
				else 
				{
					window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
					window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
				}
			}
		}
	}
	
	else{
		if (window.parent.frames['frameProcess'].introduce(args)!=false ){
			if(window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()!="DSR_ODC")
			{
				window.parent.frames['frmProcessList'].clearFrames();
			}
			else 
			{
				window.parent.frames['frameProcess'].document.forms[0].request_type.selectedIndex=0;
				window.parent.frames['frameProcess'].showSubProcess(window.parent.frames['frameProcess'].document.forms[0].request_type);
			}
		}
	}
	
	
}
	
function disableprint()
{
 if(  (window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value).toUpperCase()=="PL_IPDR")
       window.document.forms[0].Print.disabled=true;
	window.document.forms['templateForm'].ProcessName.value=window.parent.frames['frmData'].document.forms['dataform'].ProcessCode.value.toUpperCase()
}

function PrintTemplate()
{
	var topFrame=window.parent.frames['frmData'];
	var dataform=window.parent.frames['frameProcess'].document.forms[0];
	var localForm=window.document.forms["templateForm"];
	var args="";
	localForm.Args.value="";
	for(var i=0;i<dataform.elements.length;i++)
	{
		args=args+"&<"+dataform.elements[i].name+">&"+dataform.elements[i].value+"@10";
	}
	args=args+"&<BranchName>&"+topFrame.jsBranchName+"@10";
	args=args+"&<Today>&"+topFrame.jsToday+"@10";

	localForm.Args.value=args;
	
	localForm.submit();

}

</script>

<form >
<table border=1 cellspacing=1 cellpadding=1 width=100%>
	<tr width=100%>
		<td align="center" width=100%>
			<input name ='Introduce' type=button onclick="save('Introduce')" value="Introduce" class="EWButtonRB" style='width:80px'>
			<input name ='Pending' type=button onclick="save('Pending')" value="Pending" class="EWButtonRB" style='width:80px'>
			<input name = 'Clear' type=button  value="Clear" class="EWButtonRB" onclick="clearFrames()" style='width:80px'>
			<input name = 'Exit' type=button  value="Exit" class="EWButtonRB" onclick="exit()" style='width:80px'>
            
			
		</td>
	</tr>
</table>


</form>

<form name="templateForm" action="/webdesktop/servlet/testTemplateServlet" target="_Default" method="post">
<input type="hidden" name="Args">
<input type="hidden" name="ProcessName" value="">
</form>

</body>
<script>
  
</script>
</html>