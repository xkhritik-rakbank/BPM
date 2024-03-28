<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : WIForm.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Create input XML for WIUpload() call.
//------------------------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.io.*,java.util.*"%>
<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>


<HTML>
	<HEAD>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	</HEAD>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

var strDateFormat="<%=DateFormat%>";

//----------------------------------------------------------------------------------------------------
//Function Name                    : FormLoad()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Create input XML for WIUpload() call.
//----------------------------------------------------------------------------------------------------

function FormLoad()
{
	
//	try
	{
		//parent.IntroduceData();
		var dataForm=parent.window.dialogArguments; // Returns form object from Initiate_center.jsp
		//document.forms.dataForm.ProcessName.value=dataForm.TypeID.value + '_' + dataForm.RequestID.value;
		document.forms.dataForm.ProcessName.value=dataForm.ProcessCode.value; //Get Process Code from Initiate_center.jsp
		
		
		for(var i=0;i<dataForm.elements.length;i++)
		{
			//dataForm.elements[i].value=escape(dataForm.elements[i].value);
			if(dataForm.elements[i].type=='text'  || dataForm.elements[i].type=='textarea')
			{
				//if(dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeName' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeID' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'RequestID' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].value!='')

				if(dataForm.elements[i].name!='Header' && dataForm.elements[i].name != 'ServiceTypeName' && dataForm.elements[i].name!='BranchNameForPrinting' && dataForm.elements[i].name != 'ProcessCode' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined )
				{
					//dataForm.elements[i].value=replaceAll(dataForm.elements[i].value ,"'","''");
					//if(dataForm.elements[i].id=='D')
					/*if(dataForm.elements[i].id.indexOf('Date_')!=-1)
					{
						
						//var str = replaceAll(dataForm.elements[i].value,'-','/'); //pass date in DD/MM/YYYY format
						document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + LocalToDB(dataForm.elements[i].value, strDateFormat) + '\31' ;
					}
					else
					{
						if(dataForm.elements[i].id.indexOf('F_')!=-1)
						{
					
						  dataForm.elements[i].value =replaceAll (dataForm.elements[i].value,',','') ;
						 // alert( dataForm.elements[i].value);
						}*/
						var svar=replaceAll(dataForm.elements[i].value,"-","");
						svar=replaceAll(dataForm.elements[i].value,",","");						
						document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
					//}
				}
				if(dataForm.elements[i].name=="subProcessShortName"){
//					alert("Process Found");
					 document.forms.dataForm.subProcessShortName.value=dataForm.elements[i].value;
				}
			}

			if(dataForm.elements[i].type=='select-one')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					//alert(dataForm.elements[i].name+"------"+dataForm.elements[i][dataForm.elements[i].selectedIndex].value);
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
		}
 
           // document.forms.dataForm.WIData.value +=  'q_mobileno' + '\25' + dataForm.MOBILENP.value + '\31' ;
           // document.forms.dataForm.WIData.value +=  'q_landlineno' + '\25' + dataForm.LANDLINENP.value + '\31' ;
		   //alert(document.forms.dataForm.WIData.value);
		  // alert(document.forms.dataForm.ProcessName.value);
		   // document.forms.dataForm.subProcessShortName=dataForm.getElementById("subProcessShortName").value;
		   			document.forms.dataForm.submit();
	}
//	catch(e)
	{
//		alert("got error");
//		alert(e.message);
	}
}
</script>
<body onLoad='FormLoad()' class='EWGeneralRB' class='EWGeneralRB'>
	<P align=center class="EWLabelBlue">Please Wait While Introducing Workitem .....</P>
	<form name=dataForm action=WIIntroduce.jsp method=post target=frmProcess style=visibility:hidden>
		<input type='text' name='ProcessName'> 
		<input type='text' name='WIData'>
		<input type='text' name='subProcessShortName'>
	</form>
</body>

