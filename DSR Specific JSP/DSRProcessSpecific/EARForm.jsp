<%@ page import="java.io.*,java.util.*"%>
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>

<HTML>
	<HEAD>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	</HEAD>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

var strDateFormat="<%=DateFormat%>";

function FormLoad()
{
	var dataForm=parent.window.dialogArguments;
	
	for(var i=0;i<dataForm.elements.length;i++)
	{
		if(dataForm.elements[i].type=='text'  || dataForm.elements[i].type=='textarea')
		{
			if(dataForm.elements[i].name!='Header' && dataForm.elements[i].name != 'ServiceTypeName' && dataForm.elements[i].name!='BranchNameForPrinting' && dataForm.elements[i].name != 'ProcessCode' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined )
			{
				//var svar=replaceAll(dataForm.elements[i].value,"-","-");
				var svar = dataForm.elements[i].value;
				//svar=replaceAll(dataForm.elements[i].value,",",",");						
				document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
			}
			if(dataForm.elements[i].name=="subProcessShortName")
			{
				 document.forms.dataForm.subProcessShortName.value=dataForm.elements[i].value;
			}
		}

		if(dataForm.elements[i].type=='select-one')
		{
			if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
			{
				var svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,"-","");
					svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,",","");	
				document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
			}
				
		}
		if(dataForm.elements[i].type=='checkbox')
		{
			if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
			{
				if(dataForm.elements[i].checked==true)
					document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "Y" + '\31' ;
				else
					document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "N" + '\31' ;
			}					
		}
		if(dataForm.elements[i].type=='hidden')
		{
			if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
			{
				if (dataForm.elements[i].name=='ProcessName')
				{
					document.getElementById("ProcessName").value=dataForm.elements[i].value;
				}
			}	
		}
	}
	document.forms.dataForm.submit();
}
</script>
<body onLoad='FormLoad()' class='EWGeneralRB' class='EWGeneralRB'>
	<P align=center class="EWLabelBlue">Please Wait While Introducing Workitem .....</P>
	<form name=dataForm action=EARIntroduce.jsp method=post target=frmProcess style=visibility:hidden>
		<input type="text" name="ProcessName" id="ProcessName">
		<input type='text' name='WIData'>
		<input type='text' name='subProcessShortName'>
	</form>
</body>

