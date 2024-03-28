<%@ include file="../SRM_Specific/Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>		
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="java.security.SecureRandom"%>
<%@ page import="java.security.spec.KeySpec"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.SecretKey"%>
<%@ page import="javax.crypto.SecretKeyFactory"%>
<%@ page import="javax.crypto.spec.IvParameterSpec"%>
<%@ page import="javax.crypto.spec.PBEKeySpec"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>

<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/keyPressValidation.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/formLoad_SRM.js?"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/populateCustomValue.js"></script>
<script language="JavaScript" src="/webdesktop/webtop/scripts/calendar_SRM.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/json3.min.js"></script>
<script language="javascript" src="/webdesktop/resources/scripts/client.js"></script>

<!DOCTYPE html> 
<HTML>
<Head>	
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
</Head>

<script language=JavaScript>  // This script tag contains code to disable the right click on the web page.
var message="Function Disabled!";
function clickIE4()
{
	if (event.button==2)
	{
		alert(message); return false;
	}
} 
 
 function clickNS4(e)
 {
	if (document.layers||document.getElementById&&!document.all)
	{
		if (e.which==2||e.which==3)
		{
			alert(message); 
			return false; 
		}
	} 
} 
if (document.layers)
{ 
	document.captureEvents(Event.MOUSEDOWN); document.onmousedown=clickNS4; 
} 
else if (document.all&&!document.getElementById)
{ 
	document.onmousedown=clickIE4; 
} 

//document.oncontextmenu=new Function("alert(message);return false") 
//document.oncontextmenu=new Function("return false") 

</script>


<script type="text/javascript">

function callOnLoad()
	{
	//In this function Write Custom Validation and code	required on page load, populateCustomValue.js;
	
		customOnLoad();
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		/*if(!document.getElementById(SubCategoryID+"_verification_details").disabled)
			document.getElementById(SubCategoryID+"_verification_details").focus();*/
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false' && parent.document.getElementById("wdesk:WS_NAME").value=='PBO' )
			disableFieldsOnIntroReload();
			
		//call to set first radio in the grid on form load
		var sMode = document.getElementById("sMode").value;
		if(parent.document.getElementById("wdesk:WS_NAME").value!='PBO')
		{
			
			if(SubCategoryID==2)
			{
				
				var rowsInCardGrid = parseInt(document.getElementById('BALANCE TRANSFER DETAILS_GridTable').rows.length);
				var rowsInAuthGrid = parseInt(document.getElementById('AUTHORIZATION DETAILS_GridTable').rows.length);
				
				if(rowsInCardGrid>1 && rowsInAuthGrid>1)
				{
					//for defaulting balance transfer details to first record
					var columnList = "2_sub_ref_no, 2_rakbank_eligible_card_no, 2_bt_amt_req, 2_other_bank_card_type, 2_name_on_card, 2_other_bank_card_no, 2_type_of_bt, 2_other_bank_name, 2_remarks, 2_payment_by, 2_delivery_channel, 2_branch_name, 2_eligibility, 2_v_non_eligibility_reasons";
					populateFormFromRadio(columnList,'BALANCE TRANSFER DETAILS','',1,sMode);
					document.getElementById('BALANCE TRANSFER DETAILS_Radio_0').checked=true;
					
					//for defaulting authorization details to first record
					columnList = "2_sub_ref_no_auth, 2_card_no, 2_auth_code, 2_status, 2_bt_amount, 2_manual_blocking_action, 2_manual_blocking_action, 2_manual_blocking_action, 2_remarks_action, 2_cancel_status, 2_cancellation_remarks, 2_manual_unblocking_action, 2_manual_unblocking_action, 2_manual_unblocking_action, 2_tran_req_uid, 2_Approval_cd, 2_req_upld_status";
					populateFormFromRadio(columnList,'AUTHORIZATION DETAILS','',1,sMode);
					document.getElementById('AUTHORIZATION DETAILS_Radio_0').checked=true;
				}
				if(parent.document.getElementById("wdesk:WS_NAME").value=='Q4' && document.getElementById('2_caps_status').value=='ERROR IN ONLINE')
				{
					document.getElementById('Cancel').disabled=false;
					document.getElementById('2_cancellation_remarks').disabled=false;
				}
			}
			else if(SubCategoryID==4)
			{
				var rowsInCardGrid = parseInt(document.getElementById('CREDIT CARD CHEQUE DETAILS_GridTable').rows.length);
				var rowsInAuthGrid = parseInt(document.getElementById('AUTHORIZATION DETAILS_GridTable').rows.length);
				
				if(rowsInCardGrid>1 && rowsInAuthGrid>1)
				{
					//for defaulting balance transfer details to first record
					var columnList = "4_sub_ref_no, 4_rakbank_eligible_card_no, 4_ccc_amt_req, 4_beneficiary_name, 4_payment_by, 4_delivery_channel, 4_branch_name, 4_remarks, 4_marketing_code, 4_eligibility, 4_v_non_eligibility_reasons";
					populateFormFromRadio(columnList,'CREDIT CARD CHEQUE DETAILS','',1,sMode);
					document.getElementById('CREDIT CARD CHEQUE DETAILS_Radio_0').checked=true;
					
					//for defaulting authorization details to first record
					columnList = "4_sub_ref_no_auth, 4_card_no_1, 4_auth_code, 4_status, 4_ccc_amount, 4_manual_blocking_action, 4_manual_blocking_action, 4_manual_blocking_action, 4_remarks_action, 4_cancellation_remarks, 4_cancel_status, 4_manual_unblocking_action, 4_manual_unblocking_action, 4_manual_unblocking_action, 4_tran_req_uid, 4_Approval_cd, 4_req_upld_status";
					populateFormFromRadio(columnList,'AUTHORIZATION DETAILS','',1,sMode);
					document.getElementById('AUTHORIZATION DETAILS_Radio_0').checked=true;
				}
				if(parent.document.getElementById("wdesk:WS_NAME").value=='Q4' && document.getElementById('4_caps_status').value=='ERROR IN ONLINE')
				{
					document.getElementById('Cancel').disabled=false;
					document.getElementById('4_cancellation_remarks').disabled=false;
				}
			}
			else if(SubCategoryID==5)
			{
				var rowsInCardGrid = parseInt(document.getElementById('SMART CASH DETAILS_GridTable').rows.length);
				var rowsInAuthGrid = parseInt(document.getElementById('AUTHORIZATION DETAILS_GridTable').rows.length);
				
				if(rowsInCardGrid>1 && rowsInAuthGrid>1)
				{
					//for defaulting balance transfer details to first record
					var columnList = "5_sub_ref_no, 5_rakbank_eligible_card_no, 5_sc_amt_req, 5_type_of_smc, 5_beneficiary_name, 5_payment_by, 5_other_bank_name, 5_delivery_channel, 5_branch_name, 5_remarks, 5_marketing_code, 5_eligibility, 5_v_non_eligibility_reasons";
					populateFormFromRadio(columnList,'SMART CASH DETAILS','',1,sMode);
					document.getElementById('SMART CASH DETAILS_Radio_0').checked=true;
					
					//for defaulting authorization details to first record
					columnList = "5_sub_ref_no_auth, 5_card_no_1, 5_auth_code, 5_status, 5_sc_amount, 5_manual_blocking_action, 5_manual_blocking_action, 5_manual_blocking_action, 5_remarks_action, 5_cancellation_remarks, 5_cancel_status, 5_manual_unblocking_action, 5_manual_unblocking_action, 5_manual_unblocking_action, 5_tran_req_uid, 5_Approval_cd, 5_req_upld_status";
					populateFormFromRadio(columnList,'AUTHORIZATION DETAILS','',1,sMode);
					document.getElementById('AUTHORIZATION DETAILS_Radio_0').checked=true;
				}
				if(parent.document.getElementById("wdesk:WS_NAME").value=='Q4' && document.getElementById('5_caps_status').value=='ERROR IN ONLINE')
				{
					document.getElementById('Cancel').disabled=false;
					document.getElementById('5_cancellation_remarks').disabled=false;
				}
				
				document.getElementById("5_type_of_smc").title=document.getElementById("5_type_of_smc").value;
			
			}
					
		}
	}
	
	function disableFieldsOnIntroReload()
	{
		var inputs = document.getElementsByTagName("input");
		var selects = document.getElementsByTagName("select");
		var textareas = document.getElementsByTagName("textarea");
		var eleName2;
					
		var store="";
		var ele;
		for (x=0;x<inputs.length;x++)
		{
		
			if((inputs[x].type=='radio')) 
			{	
			
				eleName2 = inputs[x].getAttribute("name");
				if(eleName2.indexOf("verification_details")<0)
					continue;
					
				var ele = document.getElementsByName(eleName2);
				for(var i = 0; i < ele.length; i++)
				{	
					ele[i].disabled=true;
				}	
			}
			else if(inputs[x].type!='button')
			{	
				eleName2 = inputs[x].getAttribute("name");
				if(eleName2!='')
				{
					document.getElementById(eleName2).disabled = true;
				}
			}		
		}	
	}
	
	function whichButton(eventname, event) 
	{
		if(event.keyCode == 8)
		{
			event.keyCode=10; 
			return (event.keyCode);
		}
		else if(event.keyCode == 90)
		{
			if(event.ctrlKey)
			{
				event.keyCode=10; 
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 82)
		{
		
			if(event.ctrlKey)
			{
				event.returnValue = false;    
				event.keyCode = 0;
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 37 || event.keyCode == 39)
		{
			if(event.altKey)
			{
				event.returnValue = false;    
				return (event.keyCode);
			}	
		}		
	}

	function setPrimaryField()
	{
		
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		//var wsname=document.getElementById("ws_name").value;wdesk:WS_NAME changed by stutee.mishra
		var wsname=document.getElementById("WS_NAME").value;
		//var wsname2=document.getElementById("ws_name").value;
		//var wsname=document.getElementById("wdesk:WS_NAME").value;
	
	
		if((SubCategoryID=='4' || SubCategoryID=='5' || SubCategoryID=='2') && wsname!="PBO")
			document.getElementById("AUTHORIZATION DETAILS_Modify").style.visibility='visible';
		parent.setPrimaryField();
		formLoadCheck();
	}
	function HistoryCaller()
	{	
		parent.HistoryCaller();
	}
	function initialize(eleId)
	{	
		var cal = document.getElementById(eleId);
		if(cal.disabled==true){
			return false;
		}
		
		var cal1 = new calendarfn(document.getElementById(eleId));
		cal1.year_scroll = true;
		cal1.time_comp = false;
		cal1.popup();	
		
		return true;
	}
	function makeCalendarEnableDisable()
	{
	
		var CategoryID=document.getElementById("CategoryID").value;
		
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		
		if(CategoryID=='1' && SubCategoryID=='3')
		{
			if(document.getElementById('3_block_card').checked==true)
			{
				if (document.getElementById('3_type_of_block').value=='Permanent')
				{
					if(!((document.getElementById("3_reason_for_block").value=='Lost') 
					|| (document.getElementById("3_reason_for_block").value=='Stolen')
					|| document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
					|| document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
					|| (document.getElementById("3_reason_for_block").value=='Misuse')
					))			
					{
						return false;
					}
					else 
						return true;
				}
				else if (document.getElementById('3_type_of_block').value=='Temporary')
				{
					if(!(document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'))			
					{
						return false;
					}
					else 
						return true;
				}
				else
					return false;
			}
			else
			{
				return false;
			}
		}
		return true;
	}
	
	function initialize_DT(eleId)
	{	
		if(!makeCalendarEnableDisable())
			return true;
			
		var cal1 = new calendarfn2(document.getElementById(eleId));
		cal1.year_scroll = true;
		cal1.time_comp = false;
		cal1.popup();
		if(ValidateDate())
		return true;
		else
		return false;
		
	}
	function populateFormFromRadio(columnList,framename,selGridModifyBundleID,rowindex,sMode)
	{
		var CategoryID=document.getElementById("CategoryID").value;
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		selGridModifyBundleID=framename+"_"+SubCategoryID+"_"+"gridbundle_"+(rowindex-1);
		var varModifyGridBundleId = '';
		
		//if(SubCategoryID==3)
		{
			if(document.getElementById(framename+'_modifyGridBundle').value=='')
			{
				//
			}
			else
			{
				if(framename=='BALANCE TRANSFER DETAILS' && SubCategoryID==2)
				{
					//do nothing
				}
				else if(framename=='CREDIT CARD CHEQUE DETAILS' && SubCategoryID==4)
				{
					//do nothing
				}
				else if(framename=='SMART CASH DETAILS' && SubCategoryID==5)
				{
					//do nothing
				}
				else if(!ModifyGridValues(columnList,framename,SubCategoryID))
				{
					var gridBundle=document.getElementById(framename+'_modifyGridBundle').value;
					var id = gridBundle.substring(gridBundle.lastIndexOf("_")+1,gridBundle.length);
					
					document.getElementById(framename+"_Radio_"+id).checked=true;
					
					return false;
				}
				
			}
		}
		
		document.getElementById(framename+"_"+SubCategoryID+'_gridselrowindex').value=rowindex;		
		
		var gridBundleValue = (document.getElementById(selGridModifyBundleID).value).replace(/^\s+|\s+$/gm,'');
		
		if(gridBundleValue.length-1 == gridBundleValue.lastIndexOf("~"))
			gridBundleValue = gridBundleValue.substring(0,gridBundleValue.lastIndexOf("~"));

		
		
		var arrElementData=gridBundleValue.split('~');
		var namedata="";
		var len = arrElementData.length;
		
		
		for (z=0;z<len;z++)
		{
			var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
			var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
			var arrElementName=strElementName.split('#');
			var pattern=arrElementName[0];
			var isMandatory=arrElementName[1];
			var labelName=arrElementName[2];

			var arrElementColumnValue=strElementColumnValue.split('#');				
			var columnName=arrElementColumnValue[0];
			var columnValue=arrElementColumnValue[1];
			
            if(columnName.indexOf('manual_blocking_action') == -1 && columnName.indexOf('manual_unblocking_action') == -1 ){
			
				if(document.getElementById(columnName).type=='select-one')
				{
					if(columnValue==' ' || columnValue=='')
					{
						document.getElementById(columnName).value='--Select--';
					}
					else
					{	
						if(columnName=='3_reason_for_block')
						{
							setOptions(document.getElementById("3_type_of_block").value,document.getElementById("3_reason_for_block"));
						}
						document.getElementById(columnName).value=columnValue;
					}
				}
				else if(document.getElementById(columnName).type=='checkbox')
				{
					if(columnValue=='true' || columnValue=='Yes')
					{
						document.getElementById(columnName).checked=true;
					}
					else
					{
						document.getElementById(columnName).checked=false;
					}
				}
				else
				{
					document.getElementById(columnName).value=columnValue;
				}
			}else{
				if(document.getElementsByName(columnName)[0].type=='radio')
				{
					var myradio = document.getElementsByName(columnName);
					var x = 0;
					var radioButtonChecked = false;
					
					var radioButtonCheckedValue = '';
					
					for(x = 0; x < myradio.length; x++)
					{
						myradio[x].checked = false;
						if(myradio[x].value == columnValue)
						{
							myradio[x].checked = true;
						}
					}	
				}
			}			
		}	
		//In this function Write Custom Validation and code	on select of grid, populateCustomValue.js
			populateCustomValue(columnList,framename,selGridModifyBundleID,CategoryID,SubCategoryID,sMode);
		//End in this function Write Custom Validation and code	on select of grid, populateCustomValue.js
		
		document.getElementById(framename+'_modifyGridBundle').value=selGridModifyBundleID;
	}
	
	function ClearGridFields(columnList,framename)
	{
		var CategoryID=document.getElementById("CategoryID").value;
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		columnList = columnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		
		document.getElementById(framename+"_"+SubCategoryID+'_gridselrowindex').value='';
		var len = arrColumnList.length;
		for (var i = 0; i < len; i++)
		{			
			if(arrColumnList[i].indexOf('manual_blocking_action') == -1){
				if(document.getElementById(arrColumnList[i]).type=='text')
				{
					document.getElementById(arrColumnList[i]).value = "";
				}
				if(document.getElementById(arrColumnList[i]).type=='select-one')
				{
					document.getElementById(arrColumnList[i]).value='--Select--';
				}
				if(document.getElementById(arrColumnList[i]).type=='checkbox')
				{
					document.getElementById(arrColumnList[i]).checked=false;
				}		
				if(document.getElementById(arrColumnList[i]).type=='radio')
				{
					var myradio1 = document.getElementsByName(arrColumnList[i]);
					for(x = 0; x < myradio1.length; x++)
					{
						myradio1[x].checked=false;
						myradio1[x].disabled=true;
					}
				}		
				if(document.getElementById(arrColumnList[i]).type=='textarea')
				{
					document.getElementById(arrColumnList[i]).value='';
				}		


				if(document.getElementById(arrColumnList[i]).type!='radio')
				{
					var fieldName = document.getElementById(arrColumnList[i]).name;
					var fieldNameArr = fieldName.split("#");
					var arrLen=fieldNameArr.length;
					if(fieldNameArr[6]=='Y')
						document.getElementById(arrColumnList[i]).disabled = false;
					else
						document.getElementById(arrColumnList[i]).disabled = true;
				}
			}else{
				
				if(document.getElementsByName(arrColumnList[i])[0].type=='radio')
				{
					var myradio1 = document.getElementsByName(arrColumnList[i]);
					for(x = 0; x < myradio1.length; x++)
					{
						myradio1[x].checked=false;
						myradio1[x].disabled=true;
					}
				}
			}
			
			
		}
		
		document.getElementById(framename+'_modifyGridBundle').value='';
		
				
			var myradio = document.getElementsByName(framename+'_Radio');
			var x = 0;
			for(x = 0; x < myradio.length; x++)
			{
				if(SubCategoryID!='3')// nosave
					myradio[x].checked=false;
			}
			
		customClearGridFields(columnList,framename);	
	}
	
	
	
	function ModifyGridValues(columnList,frameName,SubCategoryID)
	{
		var WSName=document.getElementById("WS_NAME").value;
		var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
		var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
		var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
		var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
		
		//code added by Aishwarya for clearing frame on click of modify
		var oldGridBundleWIData=document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value;
		
		if(modifyGridBundleId==null || modifyGridBundleId=="")
		{
			alert("Please select a card.");
			return false;
		}
		if(SubCategoryID==3)
		{
			if(!document.getElementById("3_block_card").checked)
			{
			//return true;
			}
		}
		//In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js
		var CategoryID=document.getElementById("CategoryID").value;
		var valid = customValidationOnSave(columnList,frameName,CategoryID,SubCategoryID);
		if(!valid)
		{
			return valid;
		}
		
		//End In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js;
		
		var obj = JSON.parse(selGridWIData);
		
		
		columnList = columnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		var len = arrColumnList.length;
		var modifiedListBundle = "";
		var selWIElementData = "";
		var arrSelWIElementData = "";
		var modWIElementData = "";
		var modifiedWIData = "";
		var columnListName = "";
		var columnListValue = "";
		var currGridAttrValue ="";
		var radioButtonSet ="";
		
		
		for (var i = 0; i < len; i++)
		{		
			 modWIElementData = "";
			 
			
			if(arrColumnList[i].indexOf('manual_blocking_action') == -1 && arrColumnList[i].indexOf('manual_unblocking_action') == -1 )
			{
			
			columnListName = document.getElementById(arrColumnList[i]).name;
			columnListValue = document.getElementById(arrColumnList[i]).value;
			
			if(document.getElementById(arrColumnList[i]).type=='checkbox')
			{
				if(document.getElementById(arrColumnList[i]).checked==true)
				{
					columnListValue='Yes';
				}
				else
				{
					if((SubCategoryID==2 || SubCategoryID==4|| SubCategoryID==5) && frameName=='CARD DETAILS' && WSName!='PBO')
			
						columnListValue='';
					else
						columnListValue='No';
				}
			}		
			if(document.getElementById(arrColumnList[i]).type=='select-one')
			{
				if(document.getElementById(arrColumnList[i]).value=='--Select--')
				{
					columnListValue='';
				}
			}
			
			if(document.getElementById(arrColumnList[i]).type=='text')
			{
				if(columnListValue=='')
				{
					columnListValue='';
				}
			}
			
			if(document.getElementById(arrColumnList[i]).type=='radio')
			{
				if(radioButtonSet==columnListName+"_Y")
				{
					continue;
				}
				var myradio = document.getElementsByName(arrColumnList[i]);
				var x = 0;
				var radioButtonChecked = false;
				var radioButtonCheckedValue = '';
				for(x = 0; x < myradio.length; x++)
				{
					if(myradio[x].checked)
					{
						
						radioButtonChecked=true;
						radioButtonCheckedValue=myradio[x].value;
						columnListValue = radioButtonCheckedValue;
						radioButtonSet = columnListName+"_Y";
					}
				}
				if(radioButtonSet!=columnListName+"_Y")
				{
					columnListValue='';
				}
			}
		}
		else
		{
			
			if(document.getElementsByName(arrColumnList[i])[0].type=='radio')
			{
				columnListName = document.getElementsByName(arrColumnList[i])[0].name;
			columnListValue = document.getElementsByName(arrColumnList[i])[0].value;
				if(radioButtonSet==columnListName+"_Y")
				{
					continue;
				}
				var myradio = document.getElementsByName(arrColumnList[i]);
				var x = 0;
				var radioButtonChecked = false;
				var radioButtonCheckedValue = '';
				for(x = 0; x < myradio.length; x++)
				{
					if(myradio[x].checked)
					{
						
						radioButtonChecked=true;
						radioButtonCheckedValue=myradio[x].value;
						columnListValue = radioButtonCheckedValue;
						radioButtonSet = columnListName+"_Y";
					}
				}
				if(radioButtonSet!=columnListName+"_Y")
				{
					columnListValue='';
				}
			}
		}
			
			document.getElementById("grid_"+arrColumnList[i]+"_"+gridRowNum).value=columnListValue;
			selWIElementData = obj[arrColumnList[i].replace(SubCategoryID+"_","")];
			arrSelWIElementData = selWIElementData.split("@");
			arrSelWIElementData[gridRowNum]=columnListValue;
			modWIElementData=arrSelWIElementData.join("@");
			obj[arrColumnList[i].replace(SubCategoryID+"_","")]=modWIElementData;
			modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
			
			if (i<len-1){
			modifiedListBundle = modifiedListBundle +"~";
			}
			arrSelWIElementData="";
		}
		

		
		var modifiedStrJson = '';
		for(var key in obj){
			var attrName = key;
			var attrValue = obj[key];
			modifiedStrJson += attrName+"#"+attrValue+"~";
		}	
		
		var strJson = JSON.stringify(obj);
		
		modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));
		 
		 
		document.getElementById(modifyGridBundleId).value=modifiedListBundle;
		document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
		document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
		
		
		if(SubCategoryID=='2' && frameName=='BALANCE TRANSFER DETAILS')
		{
			var OtherGridsColumnList = '2_card_no,2_sub_ref_no_auth,2_auth_code,2_status,2_bt_amount';
			var primaryGridColumnList = '2_rakbank_eligible_card_no,2_sub_ref_no,2_auth_code,2_status,2_bt_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		
		if(SubCategoryID=='4' && frameName=='CREDIT CARD CHEQUE DETAILS')
		{
			var OtherGridsColumnList = '4_card_no_1,4_sub_ref_no_auth,4_auth_code,4_status,4_ccc_amount';
			var primaryGridColumnList = '4_rakbank_eligible_card_no,4_sub_ref_no,4_auth_code,4_status,4_ccc_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		if(SubCategoryID=='5' && frameName=='SMART CASH DETAILS')
		{
			var OtherGridsColumnList = '5_card_no_1,5_sub_ref_no_auth,5_auth_code,5_status,5_sc_amount';
			var primaryGridColumnList = '5_rakbank_eligible_card_no,5_sub_ref_no,5_auth_code,5_status,5_sc_amt_req';
			var targetFrame = 'AUTHORIZATION DETAILS';
			ModifyGridValuesInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrame,SubCategoryID,gridRowNum)
		}
		
			//code added by Aishwarya for clearing frame on click of modify
		var newGridBundleWIData=document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value;
		if(newGridBundleWIData!=oldGridBundleWIData && (frameName=='BALANCE TRANSFER DETAILS' || frameName=='CREDIT CARD CHEQUE DETAILS'|| frameName=='SMART CASH DETAILS') && parent.document.getElementById("wdesk:WS_NAME").value=='PBO')
			ClearGridFields(columnList,frameName);
		var iframe = parent.document.getElementById("frmData");	
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		if((SubCategoryID==2 || SubCategoryID==4|| SubCategoryID==5) && frameName=='CARD DETAILS' && WSName!='PBO')
		{
			//
		}
		else if(parent.document.getElementById("wdesk:IntegrationStatus").value!='false' && WSName=='PBO' && (SubCategoryID==2 || SubCategoryID==4|| SubCategoryID==5))
		{
			//
		}
		else
		{
			if(SubCategoryID==4 && frameName=='AUTHORIZATION DETAILS' && (WSName=='Q1' || WSName=='Q4'))
			{
				/*
				if(document.getElementById("grid_4_manual_unblocking_action_"+gridRowNum).value=='Manual UnBlocking Done')
				{
					//
					document.getElementById("AUTHORIZATION DETAILS_Modify").disabled=true;
				}
				else*/
				{
					var myradio1 = iframeDocument.getElementsByName('4_manual_unblocking_action');
					var y = 0;
					var ManualUnBlockingActionChecked = false;
					var ManualUnBlockingActionValue = '';
					for(y = 0; y < myradio1.length; y++)
					{
						if(myradio1[y].checked)
						{
							ManualUnBlockingActionChecked=true;
							ManualUnBlockingActionValue=myradio1[y].value;
						}
					}
					if(ManualUnBlockingActionValue=='Manual UnBlocking Done')
					{
						var updateForSMS="/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?WINAME="+document.getElementById('WINAME').value+"&UpdateFor=CancelRequestSMS";
					
					
						updateForSMS=replaceUrlChars(updateForSMS);			
						var ResponseList;	
						var xhr;
						if(window.XMLHttpRequest)
							 xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							 xhr=new ActiveXObject("Microsoft.XMLHTTP");
						 xhr.open("GET",updateForSMS,false); 
						 xhr.send(null);
						if (xhr.status == 200 && xhr.readyState == 4)
						{					
							var ajaxResult=Trim1(xhr.responseText);
						}
						else
						{
							alert("Problem in Sending SMS for Manual Cancellation");
							return false;
						}
					}
				}
			}
			if(SubCategoryID==5 && frameName=='AUTHORIZATION DETAILS' && (WSName=='Q1' || WSName=='Q4'))
			{
				/*
				if(document.getElementById("grid_5_manual_unblocking_action_"+gridRowNum).value=='Manual UnBlocking Done')
				{
					//
					document.getElementById("AUTHORIZATION DETAILS_Modify").disabled=true;
				}
				else*/
				{
					var myradio1 = iframeDocument.getElementsByName('5_manual_unblocking_action');
					var y = 0;
					var ManualUnBlockingActionChecked = false;
					var ManualUnBlockingActionValue = '';
					for(y = 0; y < myradio1.length; y++)
					{
						if(myradio1[y].checked)
						{
							ManualUnBlockingActionChecked=true;
							ManualUnBlockingActionValue=myradio1[y].value;
						}
					}
					if(ManualUnBlockingActionValue=='Manual UnBlocking Done')
					{
						var updateForSMS="/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?WINAME="+document.getElementById('WINAME').value+"&UpdateFor=CancelRequestSMS";
					
					
						updateForSMS=replaceUrlChars(updateForSMS);			
						var ResponseList;	
						var xhr;
						if(window.XMLHttpRequest)
							 xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							 xhr=new ActiveXObject("Microsoft.XMLHTTP");
						 xhr.open("GET",updateForSMS,false); 
						 xhr.send(null);
						if (xhr.status == 200 && xhr.readyState == 4)
						{					
							var ajaxResult=Trim1(xhr.responseText);
						}
						else
						{
							alert("Problem in Sending SMS for Manual Cancellation");
							return false;
						}
					}
				}
			}
			saveSRMData(false,"custom",parent);
		}	
		
		
		return true;
	}
	
	function ModifyGridValuesInOtherGrid(primaryGridColumnList,columnList,frameName,SubCategoryID,gridRowNum)
	{
		var modifyGridBundleId=frameName+"_"+SubCategoryID+"_gridbundle_"+gridRowNum;
		var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
		var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
		var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
		
		var obj = JSON.parse(selGridWIData);
					
		columnList = columnList.replace(/\s/g, '');
		primaryGridColumnList = primaryGridColumnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		var arrPrimaryGridColumnList = primaryGridColumnList.split(",");
		
		var len = arrColumnList.length;
		var modifiedListBundle = "";
		var selWIElementData = "";
		var arrSelWIElementData = "";
		var modWIElementData = "";
		var modifiedWIData = "";
		var columnListName = "";
		var columnListValue = "";
		var currGridAttrValue ="";
		
		for (var i = 0; i < len; i++)
		{		
			 modWIElementData = "";

			columnListName = document.getElementById(arrColumnList[i]).name;
			
			columnListValue = document.getElementById(arrPrimaryGridColumnList[i]).value;
			
			if(document.getElementById(arrColumnList[i]).type=='checkbox')
			{
				if(document.getElementById(arrColumnList[i]).checked==true)
				{
					columnListValue='Yes';
				}
				else
				{
					columnListValue='No';
				}
			}
			if(document.getElementById(arrColumnList[i]).type=='select-one')
			{
				if(document.getElementById(arrColumnList[i]).value=='--Select--')
				{
					columnListValue='';
				}
			}
			if(document.getElementById(arrColumnList[i]).type=='text')
			{
				if(columnListValue=='')
				{
					columnListValue='';
				}
			}
			
			document.getElementById("grid_"+arrColumnList[i]+"_"+gridRowNum).value=columnListValue;
			selWIElementData = obj[arrColumnList[i].replace(SubCategoryID+"_","")];
			arrSelWIElementData = selWIElementData.split("@");
			arrSelWIElementData[gridRowNum]=columnListValue;
			modWIElementData=arrSelWIElementData.join("@");
			
			obj[arrColumnList[i].replace(SubCategoryID+"_","")]=modWIElementData;
			
			modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
			
			if (i<len-1){
			modifiedListBundle = modifiedListBundle +"~";
			}
			arrSelWIElementData="";
		}
		
		
		var modifiedStrJson = '';
		for(var key in obj){
			var attrName = key;
			var attrValue = obj[key];
			modifiedStrJson += attrName+"#"+attrValue+"~";
		}	
		
		
		var strJson = JSON.stringify(obj);
		
		modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));
		 
		 
		document.getElementById(modifyGridBundleId).value=modifiedListBundle;
		document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
		document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
	}
	
function addRow(columnList,frameName,SubCategoryID ,sMode)
  {
    //var sMode = "";
	
	columnList = columnList.replace(/\s/g, '');
	var arrColumnList = columnList.split(",");
	var in_tbl_name = frameName+"_GridTable";
	var gridRowCount = document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value;
	var gridBundleClub = document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value;
	
	var modifiedListBundle='';
	var modifyGridBundleId='';
	var columnListName='';
	var columnListValue='';
	
	//In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js
		var CategoryID=document.getElementById("CategoryID").value;
			var valid = customValidationOnAdd(columnList,frameName,CategoryID,SubCategoryID);
			if(!valid){
				return valid;
			}
		
	//End In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js;
	
	
    var td='';
	var strHtml='';
	var tbody = document.getElementById(in_tbl_name).getElementsByTagName("TBODY")[0];
	var row = document.createElement("TR");
	
	var td1 = document.createElement("TD");
	var strHtml1="&nbsp;&nbsp;&nbsp;<input type='radio' style='text-align:center;'  name='"+frameName+"_Radio' id='"+frameName+"_Radio_"+gridRowCount+"' value='"+frameName+"_Radio_0'  onclick=\"javascript:populateFormFromRadio('"+columnList+"','"+frameName+"','"+frameName+"_"+SubCategoryID+"_gridbundle_"+gridRowCount+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">";
	
	td1.style.textAlign='center';
	td1.innerHTML = strHtml1;
	row.appendChild(td1);
	
	var len = arrColumnList.length;
		
	var selWIElementData = "";
	var arrSelWIElementData = "";
	var modWIElementData = "";

	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	

	var singleJson='';
	singleJson+="{";
	for(var i=0; i<len; i++)
	{
		
		strHtml='';
		td = document.createElement("TD");
		
		columnListName = document.getElementById(arrColumnList[i]).name;
		arrColumnListName = columnListName.split("#");
		columnListValue = document.getElementById(arrColumnList[i]).value;
		if(document.getElementById(arrColumnList[i]).type=='checkbox'){
			if(document.getElementById(arrColumnList[i]).checked==true){
				columnListValue='Yes';
			}else{
				columnListValue='No';
			}
		}		
		if(document.getElementById(arrColumnList[i]).type=='select-one'){
			if(columnListValue=='--Select--'){
				columnListValue='';
			}
		}
			
		if(document.getElementById(arrColumnList[i]).type=='text'){
			if(columnListValue==''){
				columnListValue='';
			}
		}			
		
		strHtml="<input type='gridrow' style='text-align:center;' readonly='readonly'  disabled='disabled' id='grid_"+arrColumnList[i]+"_"+gridRowCount+"' name='grid_"+arrColumnList[i]+"_"+gridRowCount+"' value='"+columnListValue+"'/>";
		td.style.textAlign='center';
		if(arrColumnListName[5]=='' || arrColumnListName[5]=='N' || !(arrColumnListName[5]=='Y')){
			td.style.display="none";
		}
		td.innerHTML = strHtml;
		
		row.appendChild(td);
		
		modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
		
		
		singleJson+="\""+arrColumnList[i].replace(SubCategoryID+"_","")+"\":\""+columnListValue+"\"";
		if (i<len-1){
			modifiedListBundle = modifiedListBundle +"~";
			singleJson+=",";
			}
		
	}
	
	singleJson+="}";
	gridBundleClub+="$$$$"+modifiedListBundle;
	var td2 = document.createElement("TD");
	modifyGridBundleId = frameName+"_"+SubCategoryID+"_"+"gridbundle_"+gridRowCount;
	var strHtml2="<input type='hidden' id='"+modifyGridBundleId+"' name='"+modifyGridBundleId+"' value= '"+modifiedListBundle+"' />";
	
	td2.innerHTML = strHtml2;
	row.appendChild(td2);
	
    tbody.appendChild(row);
	
	var OtherGridsColumnList = "";
	var primaryGridColumnList ="";
	var targetFrameName ="";
	
	//return false;
	if(SubCategoryID=='2' && frameName=='BALANCE TRANSFER DETAILS') // prateek
	{
		OtherGridsColumnList = '2_sub_ref_no_auth,2_card_no,2_auth_code,2_status,2_bt_amount,2_manual_blocking_action,2_remarks_action,2_tran_req_uid,2_Approval_cd';
		primaryGridColumnList = '2_sub_ref_no,2_rakbank_eligible_card_no,2_auth_code,2_status,2_bt_amt_req,2_manual_blocking_action,2_remarks_action,2_tran_req_uid,2_Approval_cd';
		targetFrameName = "AUTHORIZATION DETAILS";
		addRowInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrameName,SubCategoryID,sMode);
	}
	
	if(SubCategoryID=='4' && frameName=='CREDIT CARD CHEQUE DETAILS')
	{
		OtherGridsColumnList = '4_sub_ref_no_auth,4_card_no_1,4_auth_code,4_status,4_ccc_amount,4_manual_blocking_action,4_remarks_action,4_tran_req_uid,4_Approval_cd';
		primaryGridColumnList = '4_sub_ref_no,4_rakbank_eligible_card_no,4_auth_code,4_status,4_ccc_amt_req,4_manual_blocking_action,4_remarks_action,4_tran_req_uid,4_Approval_cd';
		targetFrameName = "AUTHORIZATION DETAILS";
		addRowInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrameName,SubCategoryID,sMode);
	}
	if(SubCategoryID=='5' && frameName=='SMART CASH DETAILS')
	{
		OtherGridsColumnList = '5_sub_ref_no_auth,5_card_no_1,5_auth_code,5_status,5_sc_amount,5_manual_blocking_action,5_remarks_action,5_tran_req_uid,5_Approval_cd';
		primaryGridColumnList = '5_sub_ref_no,5_rakbank_eligible_card_no,5_auth_code,5_status,5_sc_amt_req,5_manual_blocking_action,5_remarks_action,5_tran_req_uid,5_Approval_cd';
		targetFrameName = "AUTHORIZATION DETAILS";
		addRowInOtherGrid(primaryGridColumnList,OtherGridsColumnList,targetFrameName,SubCategoryID,sMode);
	}
	//return false;
	ClearGridFields(columnList,frameName);
	var objSingleJson = JSON.parse(singleJson);
	var obj = JSON.parse(selGridWIData);
	var modifiedStrJson = '';
	for(var key in obj){
		if(gridRowCount!=0){
			obj[key]+="@"+objSingleJson[key];
		}else{
			obj[key]=objSingleJson[key];
		}
		var attrName = key;
		var attrValue = obj[key];
		modifiedStrJson += attrName+"#"+attrValue+"~";
		
	}
	
	var strJson = JSON.stringify(obj);		
	modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));

	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;

	gridRowCount=parseInt(gridRowCount)+1;
	
	document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value = gridRowCount;
	document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value = gridBundleClub;	
	
  }	
  
  
  
  function addRowInOtherGrid(primaryGridColumnList,columnList,frameName,SubCategoryID,sMode)
  {
   	columnList = columnList.replace(/\s/g, '');
	primaryGridColumnList = primaryGridColumnList.replace(/\s/g, '');
	var arrColumnList = columnList.split(",");
	var arrPrimaryGridColumnList = primaryGridColumnList.split(",");
	
	var in_tbl_name = frameName+"_GridTable";
	var gridRowCount = document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value;
	var gridBundleClub = document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value;
	
	var modifiedListBundle='';
	var modifyGridBundleId='';
	var columnListName='';
	var columnListValue='';
	
    var td='';
	var strHtml='';
	var tbody = document.getElementById(in_tbl_name).getElementsByTagName("TBODY")[0];
	var row = document.createElement("TR");
	
	var td1 = document.createElement("TD");
	var strHtml1="&nbsp;&nbsp;&nbsp;<input type='radio' style='text-align:center;'  name='"+frameName+"_Radio' id='"+frameName+"_Radio_"+gridRowCount+"' value='"+frameName+"_Radio_0'  onclick=\"javascript:populateFormFromRadio('"+columnList+"','"+frameName+"','"+frameName+"_"+SubCategoryID+"_gridbundle_"+gridRowCount+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">";
	
	td1.style.textAlign='center';
	td1.innerHTML = strHtml1;
	row.appendChild(td1);
	var len = arrColumnList.length;
	
	var selWIElementData = "";
	var arrSelWIElementData = "";
	var modWIElementData = "";
	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	
	var singleJson='';
	singleJson+="{";
	for(var i=0; i<len; i++)
	{
		
		strHtml='';
		td = document.createElement("TD");
		if(arrColumnList[i].indexOf('manual_blocking_action') == -1)
		    columnListName = document.getElementById(arrColumnList[i]).name;
	    else
			columnListName = document.getElementsByName(arrColumnList[i])[0].id;
		
		var temp1 = document.getElementsByName(columnListName);
		var index = 0;
		for(var j = 0; j<temp1.length; j++){
			if(arrColumnList[i] == temp1[j].id)
				index = j;
		}
		
		arrColumnListName = columnListName.split("#");
		if(arrColumnList[i].indexOf('manual_blocking_action') == -1)
		   columnListValue = document.getElementById(arrPrimaryGridColumnList[i]).value;
	    else
		   columnListValue = document.getElementsByName(arrPrimaryGridColumnList[i])[0].value;
		if(arrColumnList[i].indexOf('manual_blocking_action') == -1){
			if(document.getElementById(arrColumnList[i]).type=='checkbox')
			{
				if(document.getElementById(arrColumnList[i]).checked==true)
				{
					columnListValue='Yes';
				}
				else
				{
					columnListValue='No';
				}
			}		
			if(document.getElementById(arrColumnList[i]).type=='select-one')
			{
				if(columnListValue=='--Select--')
				{
					columnListValue='';
				}
			}
				
			if(document.getElementById(arrColumnList[i]).type=='text')
			{
				if(columnListValue=='')
				{
					columnListValue='';
				}
			}
		
			if(document.getElementsByName(columnListName)[index].type=='radio')
			{
				var myradio = document.getElementsByName(columnListName);
				var x = 0;
				var radioButtonChecked = false;
				
				var radioButtonCheckedValue = '';
				
				for(x = 0; x < myradio.length; x++)
				{
					if(myradio[x].checked == false)
					{
						columnListValue = '';
					}
					
				}	
			}
		}else{
			if(document.getElementById(columnListName).type=='radio')
			{
				var myradio = document.getElementsByName(columnListName);
				var x = 0;
				var radioButtonChecked = false;
				
				var radioButtonCheckedValue = '';
				
				for(x = 0; x < myradio.length; x++)
				{
					if(myradio[x].checked == false)
					{
						columnListValue = '';
					}
					
				}	
			}
		}
		
		
		
		
		strHtml="<input type='gridrow' style='text-align:center;' readonly='readonly' disabled='disabled' id='grid_"+arrColumnList[i]+"_"+gridRowCount+"' name='grid_"+arrColumnList[i]+"_"+gridRowCount+"' value='"+columnListValue+"'/>";
		td.style.textAlign='center';
		
		td.innerHTML = strHtml;
		
		row.appendChild(td);
		
		modifiedListBundle=modifiedListBundle+columnListName+":"+arrColumnList[i]+"#"+columnListValue;
		
		
		singleJson+="\""+arrColumnList[i].replace(SubCategoryID+"_","")+"\":\""+columnListValue+"\"";
		if (i<len-1)
		{
			modifiedListBundle = modifiedListBundle +"~";
			singleJson+=",";
		}
		
	}
	
	
	singleJson+="}";
	gridBundleClub+="$$$$"+modifiedListBundle;
	var td2 = document.createElement("TD");
	modifyGridBundleId = frameName+"_"+SubCategoryID+"_"+"gridbundle_"+gridRowCount;
	var strHtml2="<input type='hidden' id='"+modifyGridBundleId+"' name='"+modifyGridBundleId+"' value= '"+modifiedListBundle+"' />";
	
	td2.innerHTML = strHtml2;
	row.appendChild(td2);
	
    tbody.appendChild(row);
	ClearGridFields(columnList,frameName);
	var objSingleJson = JSON.parse(singleJson);
	var obj = JSON.parse(selGridWIData);
	var modifiedStrJson = '';
	for(var key in obj)
	{
		if(gridRowCount!=0)
		{
			obj[key]+="@"+objSingleJson[key];
		}
		else
		{
			obj[key]=objSingleJson[key];
		}
		var attrName = key;
		var attrValue = obj[key];
		modifiedStrJson += attrName+"#"+attrValue+"~";
		
	}
	
	var strJson = JSON.stringify(obj);		
	modifiedStrJson=modifiedStrJson.substring(0,(modifiedStrJson.lastIndexOf("~")));

	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=modifiedStrJson;
	document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;

	gridRowCount=parseInt(gridRowCount)+1;
	
	document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value = gridRowCount;
	document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value = gridBundleClub;	
  }	
  
  
function deleteRow(columnList,frameName,SubCategoryID)
{

    columnList = columnList.replace(/\s/g, '');
    var in_tbl_name = frameName+"_GridTable";
    
    var rowindex = document.getElementById(frameName+"_"+SubCategoryID+'_gridselrowindex').value;
    
    if(rowindex==null || rowindex==""){
        alert("Please select a grid-row to delete.");
        return false;
    }
        
    if(confirm("Do you want to delete this row?"))
    {
        document.getElementById(in_tbl_name).deleteRow(rowindex);   
        
        var loopStartIndex = parseInt(rowindex);
        var tableLength=parseInt(document.getElementById(in_tbl_name).rows.length);
        
        for (var i=loopStartIndex ; i<tableLength ; i++)
        {
            // alert("loopStartIndex:::::"+loopStartIndex);
            var cols = columnList.split(",");
            
            for(var j=0; j<cols.length ;j++)    
            {
                document.getElementById('grid_'+cols[j]+"_"+(i)).id ='grid_'+cols[j]+'_'+(i-1);    
            }    
            
            document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_"+(i)).id=frameName+"_"+SubCategoryID+"_gridbundle_"+(i-1);
        
        }
    }else{
        return false;
    }
    

    
    document.getElementById(frameName+"_"+SubCategoryID+'_gridselrowindex').value='';
    ClearGridFields(columnList,frameName);
    
    var gridRowCount = document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value;
    gridRowCount=parseInt(gridRowCount)-1;
    document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value = gridRowCount;
    
    
    var gridBundleClubbed = document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value;
    var arrGridBundleClubbed = gridBundleClubbed.split("$$$$");
    var gridBundleDelRow=arrGridBundleClubbed[rowindex-1];
    var modGridBundleClubbed = '';
    var modifiedListBundle='';
    var columnListName='';
    var arrColumnList = columnList.split(",");
    var colListLen = arrColumnList.length;
    var len = arrGridBundleClubbed.length;
    
    for(var i=0; i< len; i++){
        if(i!=(rowindex-1)){
            modGridBundleClubbed+=arrGridBundleClubbed[i]+"$$$$";
        }
    }
    
    modGridBundleClubbed=modGridBundleClubbed.substring(0,(modGridBundleClubbed.lastIndexOf("$$$$")));
    
    document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value = modGridBundleClubbed;        
        
        
    var strJson='';
    var gridBundleJsonWiData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
        
        var obj = JSON.parse(gridBundleJsonWiData);
        var arrAttrValue = '';
    if(gridRowCount!=0){    
        
        for(var key in obj){
            var attrName = key;
            var attrValue = obj[key];
            var tempAttrValue = '';
            arrAttrValue = attrValue.split("@");
            for(var j=0; j<arrAttrValue.length;j++){
                if(j!=(rowindex-1)){
                    tempAttrValue += arrAttrValue[j]+"@";
                }
            }
            tempAttrValue=tempAttrValue.substring(0,(tempAttrValue.lastIndexOf("@")));
            obj[key]=tempAttrValue;
        }
        
        strJson = JSON.stringify(obj);        
    
    }else{
        strJson = JSON.stringify(obj);        
        for(var key in obj){
                var attrName = key;
                var attrValue = obj[key];
                var tempAttrValue = '';
                tempAttrValue += "$-$";
                obj[key]=tempAttrValue;
            }
        
        strJson = JSON.stringify(obj);
    }
    document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
    
    var gridBundleWIDATA = strJson;
    
    gridBundleWIDATA = gridBundleWIDATA.replace('{', '');
    gridBundleWIDATA = gridBundleWIDATA.replace('}', '');
    gridBundleWIDATA = gridBundleWIDATA.split("\":\"").join("#");
    gridBundleWIDATA = gridBundleWIDATA.split("\",\"").join("~");
    gridBundleWIDATA = gridBundleWIDATA.split("\"").join("");
    
    document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value=gridRowCount;
    document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=gridBundleWIDATA;
    
    if(SubCategoryID=='2' && frameName=='BALANCE TRANSFER DETAILS'){
        var OtherGridsColumnList = '2_sub_ref_no_auth,2_card_no,2_auth_code,2_status,2_bt_amount,2_manual_blocking_action,2_remarks_action,2_tran_req_uid,2_Approval_cd';
        var targetFrame = 'AUTHORIZATION DETAILS';
        deleteOtherGridRow(OtherGridsColumnList,targetFrame,SubCategoryID,rowindex);
    }
    if(SubCategoryID=='4' && frameName=='CREDIT CARD CHEQUE DETAILS'){
        var OtherGridsColumnList = '4_sub_ref_no_auth,4_card_no_1,4_auth_code,4_status,4_ccc_amount,4_manual_blocking_action,4_remarks_action,4_tran_req_uid,4_Approval_cd';
        var targetFrame = 'AUTHORIZATION DETAILS';
        deleteOtherGridRow(OtherGridsColumnList,targetFrame,SubCategoryID,rowindex);
    }
	if(SubCategoryID=='5' && frameName=='SMART CASH DETAILS'){
        var OtherGridsColumnList = '5_sub_ref_no_auth,5_card_no_1,5_auth_code,5_status,5_sc_amount,5_manual_blocking_action,5_remarks_action,5_tran_req_uid,5_Approval_cd';
        var targetFrame = 'AUTHORIZATION DETAILS';
        deleteOtherGridRow(OtherGridsColumnList,targetFrame,SubCategoryID,rowindex);
    }
}

function deleteOtherGridRow(columnList,frameName,SubCategoryID, rowindex)
{
    

    columnList = columnList.replace(/\s/g, '');
    var in_tbl_name = frameName+"_GridTable";
    
    document.getElementById(in_tbl_name).deleteRow(rowindex);
    
    
        var loopStartIndex = parseInt(rowindex);
        var tableLength=parseInt(document.getElementById(in_tbl_name).rows.length);
        
        for (var i=loopStartIndex ; i<tableLength ; i++)
        {
            var cols = columnList.split(",");
            for(var j=0; j<cols.length ;j++)    
            {
                document.getElementById('grid_'+cols[j]+"_"+(i)).id ='grid_'+cols[j]+'_'+(i-1);
                
    
            
            }    
            
            document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_"+(i)).id=frameName+"_"+SubCategoryID+"_gridbundle_"+(i-1);
        }
    
        
    document.getElementById(frameName+"_"+SubCategoryID+'_gridselrowindex').value='';
    ClearGridFields(columnList,frameName);
    
    var gridRowCount = document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value;
    gridRowCount=parseInt(gridRowCount)-1;
    document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value = gridRowCount;
    
    
    var gridBundleClubbed = document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value;
    var arrGridBundleClubbed = gridBundleClubbed.split("$$$$");
    var gridBundleDelRow=arrGridBundleClubbed[rowindex-1];
    var modGridBundleClubbed = '';
    var modifiedListBundle='';
    var columnListName='';
    var arrColumnList = columnList.split(",");
    var colListLen = arrColumnList.length;
    var len = arrGridBundleClubbed.length;
    
        for(var i=0; i< len; i++){
            if(i!=(rowindex-1)){
                modGridBundleClubbed+=arrGridBundleClubbed[i]+"$$$$";
            }
        }
        modGridBundleClubbed=modGridBundleClubbed.substring(0,(modGridBundleClubbed.lastIndexOf("$$$$")));
        
    document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value = modGridBundleClubbed;        
        
        
    var strJson='';
    var gridBundleJsonWiData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
        
        var obj = JSON.parse(gridBundleJsonWiData);
        var arrAttrValue = '';
    if(gridRowCount!=0){    
        
        for(var key in obj){
            var attrName = key;
            var attrValue = obj[key];
            var tempAttrValue = '';
            arrAttrValue = attrValue.split("@");
            for(var j=0; j<arrAttrValue.length;j++){
                if(j!=(rowindex-1)){
                    tempAttrValue += arrAttrValue[j]+"@";
                }
            }
            tempAttrValue=tempAttrValue.substring(0,(tempAttrValue.lastIndexOf("@")));
            obj[key]=tempAttrValue;
        }
        
        strJson = JSON.stringify(obj);        
    
    }else{
        strJson = JSON.stringify(obj);        
        for(var key in obj){
                var attrName = key;
                var attrValue = obj[key];
                var tempAttrValue = '';
                tempAttrValue += "$-$";
                obj[key]=tempAttrValue;
            }
        
        strJson = JSON.stringify(obj);
    }
    document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value=strJson;
    
    var gridBundleWIDATA = strJson;
    
    gridBundleWIDATA = gridBundleWIDATA.replace('{', '');
    gridBundleWIDATA = gridBundleWIDATA.replace('}', '');
    gridBundleWIDATA = gridBundleWIDATA.split("\":\"").join("#");
    gridBundleWIDATA = gridBundleWIDATA.split("\",\"").join("~");
    gridBundleWIDATA = gridBundleWIDATA.split("\"").join("");
    
    document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value=gridRowCount;
    document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value=gridBundleWIDATA;
}

function trimLength(id,value,maxLength){
	newLength=value.length;
	value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");

	//value=value.replaceAll(/(['])/,"''''");
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	document.getElementById(id).value=value;
}

function SelectHasValue(select, value)  //BTCR Amitabh
{
    obj = document.getElementById(select);
    if (obj !== null) {
        return (obj.innerHTML.indexOf('value="' + value + '"') > -1);
    } else {
        return false;
    }
}

</script>
<Form>
<BODY topmargin=0 leftmargin=0 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="setPrimaryField(); callOnLoad(); hideProcessingCustom();" onkeydown="whichButton('onkeydown',event)">
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<%!

	public String getSessionValues(String strVar, com.newgen.wfdesktop.session.WFSession wfsession) 
	{

            try{

            if(strVar.equalsIgnoreCase("JTSIP"))

                  return wfsession.getJtsIp();

            else if(strVar.equalsIgnoreCase("SESSIONID"))

                  return wfsession.getSessionId();

            else if(strVar.equalsIgnoreCase("USERNAME"))

                  return wfsession.getUserName();

            else if(strVar.equalsIgnoreCase("USERPASSWORD"))

                  return wfsession.getUserPassword();

            else if(strVar.equalsIgnoreCase("ENGINENAME"))

                  return wfsession.getEngineName();
				 
			else if(strVar.equalsIgnoreCase("USERINDEX"))

                  return String.valueOf(wfsession.getUserIndex());
				  
			else if(strVar.equalsIgnoreCase("JTSPORT"))

                  return String.valueOf(wfsession.getJtsPort());
				  
			else if(strVar.equalsIgnoreCase("USERFAMILYNAME"))

                  return wfsession.getUserFamilyName();
				  
			else if(strVar.equalsIgnoreCase("SESSIONVAL"))

                  return wfsession.getSessionVal();

            else if(strVar.equalsIgnoreCase("LOCALE"))

                  return wfsession.getLocale();
			
			else if(strVar.equalsIgnoreCase("APPSERVERNAME"))

                  return wfsession.getAppServerName();

            else if(strVar.equalsIgnoreCase("DATABASETYPE"))

                  return wfsession.getStrDatabaseType();
				  
			else if(strVar.equalsIgnoreCase("PERSONALNAME"))

                  return wfsession.getStrPersonalName();
			
			else if(strVar.equalsIgnoreCase("PERSONALANDFAMILYNAME"))

                  return wfsession.getPersonalAndFamilyName();
				  
			else if(strVar.equalsIgnoreCase("ENCODING"))

                  return wfsession.getEncoding();
				  
			else if(strVar.equalsIgnoreCase("CABTYPE"))

                  return wfsession.getCabType();
				  
				  

            /*else if(strVar.equalsIgnoreCase("DMSSESSIONID"))

                  return wfsession.getDMSSessionId();

            else if(strVar.equalsIgnoreCase("STARTFOLDERID"))

                  return wfsession.getStartFolderId();

            else if(strVar.equalsIgnoreCase("SITENAME"))

                  return wfsession.getSiteName();

            else if(strVar.equalsIgnoreCase("VOLUMEID"))

                  return wfsession.getVolumeId();

            else if(strVar.equalsIgnoreCase("VOLUMENNAME"))

                  return wfsession.getVolumeName();

            else if(strVar.equalsIgnoreCase("NOOFQUEUES"))

                  return wfsession.getNoOfQueues();

            else if(strVar.equalsIgnoreCase("EXPORTCABINETNAME"))

                  return wfsession.getExportCabinetName();

            else if(strVar.equalsIgnoreCase("EXPORTWEBSERVERNAME"))

                  return wfsession.getExportWebServerName();

            else if(strVar.equalsIgnoreCase("IMGDOCJTSIP"))

                  return wfsession.getImgDocJtsIp();

            else if(strVar.equalsIgnoreCase("IMGDOCENGINENAME"))

                  return wfsession.getImgDocEngineName();

            else if(strVar.equalsIgnoreCase("EXPORTSESSIONID"))

                  return wfsession.getExportSessionID();

            else if(strVar.equalsIgnoreCase("SITEID"))

                  return String.valueOf(wfsession.getSiteId());*/

            else  return "";

        }catch(Exception e) 
		{
			return "";
		}
		//return "";

    }
	  
	boolean blockCardNoInLogs=true;
	public List getFrameListFromXML(String inputXML) 
	{
		XMLParser xmlParserData = new XMLParser();
		xmlParserData.setInputXML(inputXML);
		List frameList = new ArrayList();
		List frameListRecord = null;
		Map<String, String> map = new HashMap<String, String>();
		Set set = new HashSet();
		XMLParser objXmlParser = null;

		String subXML = "";
		String frameorder = "";
		int recordcount = Integer.parseInt(xmlParserData
				.getValueOf("TotalRetrieved"));
		for (int i = 0; i < recordcount; i++) {
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			frameorder = objXmlParser.getValueOf("Frameorder");
			if (!set.contains(frameorder)) {
				if (frameListRecord != null) {
					frameList.add(frameListRecord);
				}
				frameListRecord = new ArrayList();
			}
			set.add(frameorder);
			frameListRecord.add(subXML);

		}
		frameList.add(frameListRecord);
		return frameList;
	}
	
public StringBuilder getDynamicHtml_FrameWise(List <List> frameList,String loadcount, List<Map> cardDetailList, String Workstep,String CategoryID,String SubCategoryID,String PANno, String outputData3, int count, String temp2[][], String DispColCount,String sMappOutPutXML,String sMode, String FlagValue,String IP,int port,String cabName,String sessionID)
{	
	StringBuilder html = new StringBuilder();
	String subXML=""; 
	
	String strDisable = "";
	String setVisible = ""; // nosave
	Map<String,List> FrameColumnListMap = new HashMap<String,List>();
	XMLParser xmlParserData2=new XMLParser();	
	String firstRecord = "";
	for(List<String> recordList: frameList)
	{
		html=html.append(parseRecord(recordList,loadcount,cardDetailList,Workstep,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode));
		
		firstRecord = recordList.get(0);
		
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML((firstRecord));
		String IsRepeatable = xmlParserData.getValueOf("IsRepeatable");
		String IsAddDelReq = xmlParserData.getValueOf("IsAddDelReq");
		//String isVisibleInGrid = xmlParserData.getValueOf("isVisibleInGrid");
		
		String frameName  = xmlParserData.getValueOf("LabelName");
		
		WriteLog("IsRepeatable0-=>"+IsRepeatable);	
		WriteLog("IsAddDelReq0-=>"+IsAddDelReq);
		
		if(IsRepeatable.equals("Y"))
		{
			WriteLog("Inside IsRepeatable-=>"+IsRepeatable);	
			if(sMode.equals("R") || !Workstep.equals("PBO"))
			{
				strDisable = " disabled=\'disabled\' ";
			}
			
			if(frameName.equals("CREDIT CARD CHEQUE DETAILS") || frameName.equals("BALANCE TRANSFER DETAILS")|| frameName.equals("SMART CASH DETAILS")){
				setVisible = " ";
			}else if(CategoryID.equals("1") && (SubCategoryID.equals("3") || SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5")) )
			{
				setVisible = " style=visibility:hidden; ";
			}
			
			List<String> columnList = getColumnList(recordList,SubCategoryID);
			FrameColumnListMap.put(frameName,columnList);
			WriteLog("Inside columnList-=>"+columnList);	
			String varColumnList = columnList.toString().replace("[","").replace("]","");
			WriteLog("Inside varColumnList-=>"+varColumnList);	
			html.append("<table border='1' cellspacing='1' cellpadding='0' width=100% >");
			if(Workstep.equals("Introduction") ||  Workstep.equals("PBO"))
			{
				WriteLog("Inside Introduction-=>");	
				//if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
				if(IsAddDelReq.equals("Y"))
				{
					if(CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5")) && frameName.equals("AUTHORIZATION DETAILS"))
					{
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='SAVE'  "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					}
					else
					{
						html.append("&nbsp;<input name='"+frameName+"_Add' type='button' id='"+frameName+"_Add' value='ADD' "+strDisable+" onclick=\"addRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"','"+sMode+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='MODIFY'  "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Delete' type='button' id='"+frameName+"_Delete' value='DELETE' "+strDisable+" onclick=\"deleteRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:70px'>");
					}
				}
				else
				{
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
				}
				
			}
			else
			{
				//if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
				if(IsAddDelReq.equals("Y"))
				{
					
					if(CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5")) && frameName.equals("AUTHORIZATION DETAILS"))
					{						
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					}else
					{
						html.append("&nbsp;<input name='"+frameName+"_Add' type='button' id='"+frameName+"_Add' value='ADD'  "+strDisable+" onclick=\"addRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='MODIFY' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Delete' type='button' id='"+frameName+"_Delete' value='DELETE' "+strDisable+"  onclick=\"deleteRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:70px'>");						
					}
				}
				else
				{
					html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
				}
			}
			
			
			WriteLog("Inside ModifyGridValues-=>");	
			if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
			{
				html.append("&nbsp;<input name='"+frameName+"_Clear' type='button' id='"+frameName+"_Clear' value='CLEAR' style='visibility:hidden;' onclick=\"ClearGridFields('"+varColumnList+"','"+frameName+"');\" class='EWButtonRB' style='width:65px'>");
			}
			
			WriteLog("Inside ClearGridFields-=>");	
			html.append("<td><input type='hidden' id='"+frameName+"_modifyGridBundle' name='"+frameName+"_modifyGridBundle' value= ''  /></td>");
			html.append("</table>");
			
			//html.append("</tr></table>");
			
			/*if(blockCardNoInLogs)
				WriteLog("Inside recordList-=>"+recordList+" and "+cardDetailList);	*/
				
			List cardDetailListSingleValMap = prepareMultiValMaptoSingleValMap(recordList,cardDetailList);
			//List cardDetailListSingleValMap =cardDetailList;
			
			if(blockCardNoInLogs)
				WriteLog("Inside cardDetailListSingleValMap-=>"+cardDetailListSingleValMap);		
				
			html.append("<div style='border:1px solid black;height:150px;width:100%;overflow-y:scroll;overflow-x:scroll;'>");
			html.append("<table id='"+frameName+"_GridTable' name='"+frameName+"_GridTable' border='1' cellspacing='1' cellpadding='0' width=100% >");
			html.append(prepareGridTH(recordList,frameName,SubCategoryID));
			html.append("<tbody>");
			html.append(prepareGridDataRows(recordList,frameName,cardDetailListSingleValMap,SubCategoryID,FlagValue,sMode, IP, port, cabName, sessionID));
			html.append("</tbody>");
			html.append("</table>");
			html.append("</div>");
			
		}
	}
	
	//if(blockCardNoInLogs)
		WriteLog("html--> "+html.toString());
		
	for (Map.Entry entry : FrameColumnListMap.entrySet())
	{
		String fieldName= entry.getKey()+ "_ColumnList";
	
		html.append("<input type=hidden name='"+fieldName+"' id='"+fieldName+"' value='"+entry.getValue()+"' style='visibility:hidden' >");
			
	}		
	if(CategoryID.equals("1"))
	{
		if(Workstep.equals("PBO"))
		{
			return html.append("<input type=hidden name='PANno' id='PANno' value='"+PANno+"' style='visibility:hidden' >");
		}
		else
		{
			return html.append("<input type=hidden name='PANno' id='PANno' value='"+PANno+"' style='visibility:hidden' ></table><table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' ></td></tr><tr/>");
		}
	
}
	else if(CategoryID.equals("3")||CategoryID.equals("5"))
	{
		if(Workstep.equals("PBO"))
		{
			//return html.append("</table>");
			return html;
		}
		else
		{
			return html.append("<table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' ></td></tr><tr/></table>");
		}
	}
	else
	{
		//return html.append("</table>");
		return html;
	}
}
	
	public String maskCardNo(String cardNo)
{
	cardNo=cardNo.substring(0,6)+"XXXXXX"+cardNo.substring(12,16);
	cardNo=cardNo.substring(0,4)+"-"+cardNo.substring(4,8)+"-"+cardNo.substring(8,12)+"-"+cardNo.substring(12,16);
	
	return cardNo;
}

//a function

public List getColumnList(List <String> recordList,String SubCategoryID){

	List<String>columnList =  new ArrayList<String>();
	
	for(String record: recordList)
	{
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML((record));
		String ColumnName = xmlParserData.getValueOf("ColumnName");
		String IsRepeatable=xmlParserData.getValueOf("IsRepeatable");
		if((!ColumnName.equals("NULL")) && IsRepeatable.equals("Y")){
			columnList.add(SubCategoryID+"_"+ColumnName);
		}
	}
	return columnList;
}

public StringBuilder prepareGridTH(List <String> recordList,String firstRecordLabelName,String SubCategoryID)
{
	WriteLog("Inside prepareGridTH method.");	
	StringBuilder html = new StringBuilder();
	html.append("<thead class='EWLabelRB2' ><th nowrap='nowrap' height ='22' >&nbsp;<b>Select</b>&nbsp;</th>");
	String radioGroupNameFlagged="";
	for(String record: recordList)
	{
	
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML((record));
		String LabelName = xmlParserData.getValueOf("LabelName");
		String FieldType = xmlParserData.getValueOf("FieldType");
		String IsRepeatable=xmlParserData.getValueOf("IsRepeatable");
		String isVisibleInGrid = xmlParserData.getValueOf("isVisibleInGrid");
		
		if(FieldType.equals("R"))
			LabelName = xmlParserData.getValueOf("RadioGroupName");
		

					
		WriteLog("isVisibleInGrid-=>"+isVisibleInGrid);	
		String displayNone ="";
		if(!isVisibleInGrid.equals("Y") )
		{
			WriteLog("Annnnnuuuuuuuuuuuu");
			displayNone="style = 'display:none'";
		}
	
		
		if(!(FieldType.equals("NULL")) && IsRepeatable.equals("Y"))
		{	
			if(FieldType.equals("R") && radioGroupNameFlagged.equals(LabelName+"_Y"))
			{
				continue;
			}
			else
			{
				if(FieldType.equals("R"))
				{
					radioGroupNameFlagged=LabelName+"_Y";
				}
				html.append("<th nowrap='nowrap' "+displayNone+" height ='22'  style='text-align:center;'  >&nbsp;<b>"+LabelName+"</b>&nbsp;</th>");
			}
		}
	}
	
	html.append("</thead>");
	return html;
}

public StringBuilder parseRecord(List <String> recordList,String loadcount, List<Map> cardDetailList, String Workstep,String CategoryID,String SubCategoryID,String PANno, String outputData3, int count, String temp2[][], String DispColCount,String sMappOutPutXML,String sMode)
{	
	String mainCodeData2="";
	String subXML="";
	String subXML2="";
	XMLParser objXmlParser=null;
	XMLParser objXmlParser2=null;
	String tablename="";
	String WS_NAME="";
	String comboid="";
	String Value="";
	String Key="";
	String LabelName="";
	String FieldType="";
	String FieldLength="";
	String ColumnName="";
	String ColumnValue="";
	String FieldOrder="";
	String Frameorder="";
	String Editable="";
	String framecount="";
	String ColumnCopy="";
	String logical_WS_NAME="";
	String IsMandatory="";
	String Pattern="";
	String is_workstep_req="";
	String event_function="";
	String is_special="";
	String typecheck="";
	boolean typecheckButR=false;
	String IsRepeatable="";
	String IsAddDelReq="";
	String isVisibleInGrid = "";
	String readOnlyDisabled="";
	int intTwiceDispColCount = Integer.parseInt(DispColCount)*2;
	float intWidth = ((float)100/(intTwiceDispColCount));
	int i=Integer.parseInt(DispColCount)-1;
	WriteLog("DispColCount----------------------->"+DispColCount);
	WriteLog("intTwiceDispColCount----------------------->"+intTwiceDispColCount);
	WriteLog("intWidth----------------------->"+intWidth);
	WriteLog("recordList.length----------------------->"+recordList.size());
	WriteLog("recordList.contains----------------------->"+recordList.contains("<FieldType>H</FieldType>"));
	WriteLog("count------------->"+count);
		
	StringBuilder html = new StringBuilder();
	XMLParser xmlParserData2=new XMLParser();
	int recordcount2=0;
	
	Map<String,String> map = new HashMap<String,String> ();
	if(cardDetailList.size()!=0){
		map = (HashMap)cardDetailList.get(0);
	}

		for(String record: recordList)
		{
			subXML = record;
			objXmlParser = new XMLParser(subXML);
			WS_NAME = objXmlParser.getValueOf("WS_Name");
			LabelName = objXmlParser.getValueOf("LabelName");
				WriteLog("LabelName=="+LabelName);
				WriteLog("I=="+i);
				WriteLog("values here");
			if(LabelName.indexOf("SP_")==0)
			{
				is_special=LabelName.substring(0,3);
				LabelName=LabelName.substring(3);
			}
			else
				is_special="";
			FieldType = objXmlParser.getValueOf("FieldType");
			FieldLength = objXmlParser.getValueOf("FieldLength");
			ColumnName = objXmlParser.getValueOf("ColumnName");
			FieldOrder = objXmlParser.getValueOf("FieldOrder");
			Frameorder = objXmlParser.getValueOf("Frameorder");
			Editable = objXmlParser.getValueOf("IsEditable");
			//logical_WS_NAME=objXmlParser.getValueOf("logical_WS_NAME");
			IsRepeatable=objXmlParser.getValueOf("IsRepeatable");
			IsAddDelReq=objXmlParser.getValueOf("IsAddDelReq");
			isVisibleInGrid=objXmlParser.getValueOf("isVisibleInGrid");
			IsMandatory=objXmlParser.getValueOf("IsMandatory");
			Pattern=objXmlParser.getValueOf("Pattern");
			if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
				Pattern="blank";
			is_workstep_req=objXmlParser.getValueOf("is_workstep_req");
			event_function=objXmlParser.getValueOf("event_function");
			event_function=event_function.replaceAll("~"," ");

				WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
				
				String nameFormElement = Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"#"+isVisibleInGrid+"#"+IsAddDelReq;
				
			if(Workstep.equals(WS_NAME))
			{	
				if(FieldType.equals("NULL")&&FieldOrder.equals("1"))
				{	
					html.append("<table border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><b>"+LabelName+"</b></td></tr>");
					i=0;		
				}
				else if(!FieldOrder.equals("1"))
				{
					
					
					if(i!=0)
					{
						if(!FieldType.equals("H")){
							WriteLog("--i Before=="+i);
							--i;
							WriteLog("--i after=="+i);
						}
					}
					else
					{ 
						if(!FieldType.equals("H")){
								html.append("<TR>");
						}
						i=Integer.parseInt(DispColCount)-1;
					}
					if(!FieldType.equals("B") && !FieldType.equals("H") && !FieldType.equals("R"))
					{
						html.append("<td width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
					}
					WriteLog("AMan Error Check=="+sMode);
					WriteLog("AMan Error Check=="+FieldType);
					
					
					if(map.containsKey(ColumnName) && (!IsRepeatable.equals("Y"))){
						ColumnValue = map.get(ColumnName).trim();
					}else{
						ColumnValue="";
					}
					readOnlyDisabled="";
					if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
					{
						WriteLog("Helooooooooooooooooooooooooooosssooooooooooooooooooooooooooo");
						WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
						readOnlyDisabled=" 'readonly' disabled='disabled' ";
					}
					if(FieldType.equals("H"))
					{
						html.append("<input type='hidden' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"' "+event_function+" >");
					}
					else if(FieldType.equals("TA") )
					{	
						
						
						{
						if(is_special.equals("SP_"))
							{
								if(map.size()!=0  && (( map.get(ColumnName))!=null ) &&((map.get(ColumnName)).lastIndexOf("$")>-1) &&  (((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))){
										html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+")  maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+">"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"</textarea></td>");
									}
								else{
										html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onblur=trimLength(this.id,this.value,"+FieldLength+")   maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+"></textarea></td>");	
										is_special="";
								  }
								
							}else{
								html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+")   maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+">"+ColumnValue+"</textarea></td>");
							}
						}
						typecheck="TA";	
					} 
					else if(FieldType.equals("T") )
					{
						if(is_special.equals("SP_"))
							{
								if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");			
								else
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+readOnlyDisabled+"></td>");
								is_special="";
								
							}else{
								html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' data-toggle='tooltip'  onmousemove='title=this.value' onmouseover='title=this.value' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");
							}
						if(typecheck!="R")
						{
							typecheck="T";
							typecheckButR = true;
						}
					}
					 else if(FieldType.equals("C") )
					 {
						if(map.containsKey(ColumnName)&&((String)map.get(ColumnName)).equals("true"))
						{
							html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+" checked  ></td>");
						}else
						{
							html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+"      ></td>");
						}
						typecheck="C";
					}else if(FieldType.equals("P"))
					{ 	
							if(is_special.equals("SP_"))
							{	

								WriteLog("In SP_ FieldType="+FieldType+" "+LabelName+" "+is_workstep_req);

								html.append("<td width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value'  style='width: 167px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
								xmlParserData2.setInputXML((outputData3));
								recordcount2 = Integer.parseInt(xmlParserData2.getValueOf("TotalRetrieved"));
								mainCodeData2 = xmlParserData2.getValueOf("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = xmlParserData2.getNextValueOf("Record");
										objXmlParser2 = new XMLParser(subXML2);
										comboid = objXmlParser2.getValueOf("comboid");
										Value = objXmlParser2.getValueOf("Value");
										Key = objXmlParser2.getValueOf("AssocVal");
										WriteLog("Key check 3333---->"+Key);
										
										if(LabelName.equals(comboid))
										{
											if(!(map.get(ColumnName)==null || map.get(ColumnName).equals("null")))
											{	
												if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) &&((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
												{
													if(((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1).equals(Value))
													html.append("<option value='"+Value+"' selected>"+Value+"</option>");
													else
													html.append("<option value='"+Value+"' >"+Value+"</option>");
												}
												else
													html.append("<option value='"+Value+"' >"+Value+"</option>");
											}
											else
												html.append("<option value='"+Value+"' >"+Value+"</option>");
										}
									}
								}
								
								html.append("</select></td>");
								is_special="";
							
							}
							else
							{

								WriteLog("In FieldType="+FieldType);
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									//html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' "+"' readonly='readonly' disabled='disabled' style='width: 167px' "+event_function+" ><option value='--Select--' >--Select--</option>");
									
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 167px' readonly='readonly' disabled='disabled' "+event_function+" ><option value='--Select--' >--Select--</option>");
									
								}else{
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 167px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								}
								
								
								xmlParserData2.setInputXML((outputData3));
								recordcount2 = Integer.parseInt(xmlParserData2.getValueOf("TotalRetrieved"));
								mainCodeData2 = xmlParserData2.getValueOf("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = xmlParserData2.getNextValueOf("Record");
										objXmlParser2 = new XMLParser(subXML2);
										comboid = objXmlParser2.getValueOf("comboid");
										Value = objXmlParser2.getValueOf("Value");
										Key = objXmlParser2.getValueOf("AssocVal");
										WriteLog("ColumnName Key check 3333---->"+ ColumnName+"   "+Key);
										WriteLog("ColumnName ColumnValue check 3333---->"+ColumnName+"   "+Key);
										
										if(Key==null || Key.equals("")){
											Key = Value;
										}
										WriteLog("Checking Exit"+ LabelName+"   "+comboid);
										if(LabelName.equals(comboid))
										{	if(CategoryID.equals("1")&&SubCategoryID.equals("1"))
											{
												try{
													WriteLog("Checking Exit"+ LabelName+" value  "+Value);
													WriteLog("Checking Exit map size"+ map.size());
													WriteLog("Checking Exit map columnname"+ ColumnName+"hi");
													
		
													if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1).equals(Value) && (Workstep.equals("Exit") || Workstep.equals("Reject")))
													{
														WriteLog("Inside Exit"+ LabelName+"   "+Value);
														html.append("<option value='"+Key+"' selected>"+Value+"</option>");
													}
													else
														html.append("<option value='"+Key+"' >"+Value+"</option>");
												}catch(Exception e){
													WriteLog("Exception caught checking exit");
												}
											}
											else if(ColumnValue.equals(Key)){
												html.append("<option value='"+Key+"' selected>"+Value+"</option>");
											}else{
												html.append("<option value='"+Key+"' >"+Value+"</option>");
											}
										}
									}
								}
								
								html.append("</select></td>");
							}
							typecheck="P";

								WriteLog("html="+html);
					}else  if(FieldType.equals("D"))
					{

							WriteLog("In FieldType="+FieldType);
							String trial=(String)map.get(ColumnName);
							WriteLog("trial"+trial);
							if(trial==null)
							trial="";					
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
									}	
									
								}
								is_special="";
							}
							else
							{
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											//if(!IsRepeatable.equals("Y"))
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'>");
											
											if(!IsRepeatable.equals("Y"))
											html.append("<input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly "+event_function+">");
											else
											html.append("<input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+">");
											
											html.append("<a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" >");
											html.append("<img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="D";
								WriteLog("html="+html);
					}else  if(FieldType.equals("DT"))
					{ 		

							WriteLog("In FieldType="+FieldType);
											
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = ''  "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
									}	
									
								}
								is_special="";
							}
							else
							{
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}
											
									}
												
								}
								else
								{
									WriteLog("Debugger 001");
									if(map.isEmpty())
									{
										WriteLog("Debugger 002");
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif'  width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										WriteLog("Debugger 003");
										if(map.containsKey(ColumnName))
										{	
											WriteLog("Debugger 004");
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'>");
											if(!IsRepeatable.equals("Y"))
												html.append("<input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"'  "+event_function+">");
											else
												html.append("<input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+">");
											
											html.append("<a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" >");
											html.append("<img src='/webdesktop/webtop/images/images/cal.gif'   width='16' height='16' border='0' alt='' ></a></td>");
											
										}
										else
										{
											WriteLog("Debugger 005 __"+SubCategoryID+"__"+ColumnName);
											
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif'  disabled='disabled' width='16' height='16' border='0' alt='' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="DT";
								WriteLog("html="+html);	
					}
					else  if(FieldType.equals("R"))
					{  
						WriteLog("In  FieldType="+FieldType);
						if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td colspan='2' width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+nameFormElement+"' value='"+LabelName+"' checked disabled "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
							else
							html.append("<td colspan='2' width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+nameFormElement+"' value='"+LabelName+"' disabled "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
						}
						else
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td colspan='2' width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+nameFormElement+"' value='"+LabelName+"' checked "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
							else
							html.append("<td colspan='2' width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+nameFormElement+"' value='"+LabelName+"' "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
						}
						typecheck="R";
						WriteLog("html="+html);					
					}
					else if(FieldType.equals("B"))
					{
					
						WriteLog("inside button dynamic field");
						if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
						{
							html.append("<td colspan='2' width='"+intWidth+"%' >&nbsp;&nbsp;&nbsp;&nbsp;<input name='"+LabelName+"' id='"+LabelName+"' type='button' value='"+LabelName+"' readonly='readonly' disabled='disabled' class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}else{
							html.append("<td colspan='2' width='"+intWidth+"%' >&nbsp;&nbsp;&nbsp;&nbsp;<input name='"+LabelName+"' id='"+LabelName+"' type='button' value='"+LabelName+"' class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}	
					} else{
							html.append("<td width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
					}
					
					WriteLog("I before ==0--->"+i);	
					if(i==0)
					{
						//if(!FieldType.equals("H")){
							html.append("</tr>");
						//}
					}
					
				}
			
			}
			WriteLog("html after appended field--->"+html);	
		}
		WriteLog("I on closure of loop--->"+i);	
		
		if(i!=0){
				if(
					typecheck.equals("R") 
					&& typecheckButR 
				)
				{
							
				}						
				else	
				{
					for(int r=0;r<i;r++){
						html.append(
						"<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
						"<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"
						);
						typecheck="";
					}
				}	
		}
		//if(!FieldType.equals("H")){
			html.append("</tr>");
		//}
			
			html.append("</table>");
					WriteLog("html Before Returning from ParseRecord="+html);						
		return html;
}

public StringBuilder prepareGridDataRows(List <String> recordList,String firstRecordLabelName,List<Map> cardDetailList, String SubCategoryID,String FlagValue ,String sMode , String IP,int port,String cabName,String sessionID)
{
	
	WriteLog("Inside prepareGridDataRows-->");
	
	if(blockCardNoInLogs)	
	    WriteLog("Map prepareGridDataRows: ::"+cardDetailList);
		
	List<String> columnList = getColumnList(recordList,SubCategoryID);
	String varColumnList = columnList.toString().replace("[","").replace("]","");
	
	
	StringBuilder html = new StringBuilder();
	Map <String,String>columnValueMap= new HashMap<String,String>();
	String bundledColumnValue="";
	String bundledWiData="";
	String mapValue= "";
	String gridBundleClubbed = "";
	
	int gridCounter=0;
	for(Map<String,String> map: cardDetailList)
	{
		String firstRecord = recordList.get(0);		
		XMLParser xmlParserData1=new XMLParser();
		xmlParserData1.setInputXML((firstRecord));
		String FristRecordIsRepeatable = xmlParserData1.getValueOf("IsRepeatable");
		String FristRecordIsAddDelReq = xmlParserData1.getValueOf("IsAddDelReq");
		WriteLog("Inside prepareGridDataRows1-->");
		
		String firstGridElement = recordList.get(1);		
		XMLParser xmlParserData2=new XMLParser();
		xmlParserData2.setInputXML((firstGridElement));
		
		String FirstRecordColumnName = xmlParserData2.getValueOf("ColumnName");
		String FirstRecordColumnValue = map.get(FirstRecordColumnName);

		bundledColumnValue="";		
				
			
			//if((FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) || (FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y")))
			
			if(FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) 
			{
				html.append("<tr>");
					html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio'  name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
			}
			else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y"))
			{
				WriteLog("Inside prepareGridDataRows4 FristRecordIsRepeatable-->"+FristRecordIsRepeatable);
				WriteLog("Inside prepareGridDataRows4 FristRecordIsAddDelReq-->"+FristRecordIsAddDelReq);
				WriteLog("Inside prepareGridDataRows4 FirstRecordColumnName-->"+FirstRecordColumnName);
				WriteLog("Inside prepareGridDataRows4 FirstRecordColumnValue-->"+FirstRecordColumnValue);
				if(FirstRecordColumnValue!=null && !FirstRecordColumnValue.equals("$-$"))
				{
					WriteLog("Inside prepareGridDataRows5-->");
					html.append("<tr>");
					html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio'  name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
				}
			}
			WriteLog("Inside prepareGridDataRows6-->");
			int recordCount=recordList.size();
			int recordCounter = 0 ;
			String radioGroupNameFlagged="";
			for(String record: recordList)
			{
				XMLParser xmlParserData=new XMLParser();
				xmlParserData.setInputXML(record);
				
				String LabelName = xmlParserData.getValueOf("LabelName");
				String FieldType = xmlParserData.getValueOf("FieldType");
				String ColumnName = xmlParserData.getValueOf("ColumnName");
				String Pattern=xmlParserData.getValueOf("Pattern");
				String IsMandatory=xmlParserData.getValueOf("IsMandatory");
				String is_workstep_req=xmlParserData.getValueOf("is_workstep_req");
				String IsRepeatable=xmlParserData.getValueOf("IsRepeatable");
				String IsAddDelReq = xmlParserData.getValueOf("IsAddDelReq");
				String isVisibleInGrid = xmlParserData.getValueOf("isVisibleInGrid");
				String encryptionRequired = xmlParserData.getValueOf("EncryptionRequired");
				String radioGroupName = xmlParserData.getValueOf("RadioGroupName");
					
				WriteLog("isVisibleInGrid-=>"+isVisibleInGrid);	
				WriteLog("radioGroupName-=>"+radioGroupName);	
				String displayNone ="";
				if(!isVisibleInGrid.equals("Y") )
				{
					displayNone="style = 'display:none'";
				}
							
				
				if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
					Pattern="blank";
				String nameFormElement = Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"#"+isVisibleInGrid+"#"+IsAddDelReq;
			
				String ColumnValue = map.get(ColumnName);
				
				WriteLog("--------- ColumnName ------: "+ColumnName);
				if(blockCardNoInLogs)
				    WriteLog("--------- ColumnValue ------: "+ColumnValue);
					
				WriteLog("--------- encryptionRequired ------: "+encryptionRequired);
				/*************************************************************
				This part of code is for decrypting the card number stored in database. This code will give exception for the new workitem because at that time we have original value of card numbers not the encrypted ones
				*****************************************************************/
				if((SubCategoryID.equals("3")  || SubCategoryID.equals("4")|| SubCategoryID.equals("5") || SubCategoryID.equals("2")) && encryptionRequired.equals("Y"))
				{
					if(ColumnValue==null||ColumnValue.equalsIgnoreCase("null"))
					{
						ColumnValue="";
					}
					else{
						String outVal ="";
						try
						{
							String inputXml="<?xml version='1.0'?><APDecryptString_Input><Option>APDecryptString</Option><EngineName>"+cabName +"</EngineName><StringValue>"+ColumnValue+"</StringValue></APDecryptString_Input>";
							
							String outputXml = WFCallBroker.execute(inputXml, IP, port, 1);
							
							if(blockCardNoInLogs)
							{
								WriteLog("Decrypt outputXml -->"+outputXml);
								WriteLog("Decrypt outputXml -->"+outputXml);
							}
							
							if(outputXml.substring(outputXml.indexOf("<MainCode>")+10,outputXml.indexOf("</MainCode>")).equals("0"))
							{
								outVal = outputXml.substring(outputXml.indexOf("<Output>")+8,outputXml.indexOf("</Output>"));
								
								if(blockCardNoInLogs)
								   WriteLog("outVal :"+outVal);
								ColumnValue = outVal;
								
								if(sMode.equals("R"))
									ColumnValue = maskCardNo(ColumnValue);
									
							}
							else
							{
								WriteLog("Decrypt Card No maincode is not 0.");
							}
							
						}
						catch(Exception e)
						{
							WriteLog("Exception in decrypt :"+e.getMessage());
						}
					}
				}
				/*************************    Code Ends  ***********************/
				
				//FirstRecordColumnValue = ColumnValue;
				if(ColumnValue==null)
				{
					ColumnValue="";
				}
				
				if(!FieldType.equals("NULL") && !FieldType.equals("B"))
				{
					if(FieldType.equals("R") )
					{
						if(radioGroupNameFlagged.equals(radioGroupName+"_Y"))
							continue;
						else
							radioGroupNameFlagged=radioGroupName+"_Y";
					}
				
					//bundledColumnValue=bundledColumnValue+ "\"" +nameFormElement +"\""+ ":" +"\""+SubCategoryID+"_"+ColumnName+"#"+ColumnValue+"\"";
					bundledColumnValue=bundledColumnValue+ nameFormElement + ":" +SubCategoryID+"_"+ColumnName+"#"+ColumnValue;
					
					if((IsRepeatable.equals("Y") && (!IsAddDelReq.equals("Y"))) || (IsRepeatable.equals("Y") && IsAddDelReq.equals("Y") && FlagValue.equals("Y")))
					{
						if(columnValueMap.containsKey(ColumnName))
						{
							mapValue = columnValueMap.get(ColumnName);
							mapValue = mapValue+"@"+ColumnValue;
							columnValueMap.put(ColumnName,mapValue);
						} 
						else
						{
							columnValueMap.put(ColumnName,ColumnValue);
						}
					}
					else
					{
						columnValueMap.put(ColumnName,"$-$");
					}
					
					WriteLog("recordCounter--> "+recordCounter);
					WriteLog("recordCount--> "+recordCount);
										
					if(FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) 
					{
						if(recordCounter<recordCount-1)
						{
								bundledColumnValue=bundledColumnValue+"~";
						}
							
						html.append("<td nowrap='nowrap' style='text-align:center;'  height='22'"+displayNone+" ><input type='gridrow' style='text-align:center;' readonly='readonly' disabled = 'disabled' id='grid_"+SubCategoryID+"_"+ColumnName+"_"+gridCounter+"' value='"+ColumnValue+"' /></td>");
																
					}
					else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y"))
					{
						if(!ColumnValue.equals("$-$"))
						{
							if(recordCounter<recordCount-1){
								bundledColumnValue=bundledColumnValue+"~";
							}
							
								html.append("<td nowrap='nowrap' height='22' "+displayNone+"><input type='gridrow' style='text-align:center;' readonly='readonly' disabled = 'disabled' id='grid_"+SubCategoryID+"_"+ColumnName+"_"+gridCounter+"' name='grid_"+SubCategoryID+"_"+ColumnName+"_"+gridCounter+"' value='"+ColumnValue+"' /></td>");
						}
					}		
				}					
				recordCounter++;
			}
			
			if(FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) 
			{
				html.append("<td><input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_"+gridCounter+"' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_"+gridCounter+"' value= '"+bundledColumnValue+"' /></td>");
					html.append("</tr>");
					gridCounter++;
			} else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y"))
			{
				WriteLog("firstRecordLabelName-----> "+firstRecordLabelName);
				WriteLog("FirstRecordColumnName-----> "+FirstRecordColumnName);
				
				if(blockCardNoInLogs)
					WriteLog("FirstRecordColumnValue-----> "+FirstRecordColumnValue);
				
				
				if(FirstRecordColumnValue!=null && !FirstRecordColumnValue.equals("$-$"))
				{
				html.append("<td><input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_"+gridCounter+"' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_"+gridCounter+"' value= '"+bundledColumnValue+"' /></td>");
					html.append("</tr>");
					gridCounter++;
				}
			}	
			
			if(gridBundleClubbed.equals("")){
			gridBundleClubbed=bundledColumnValue;
			}else{
			gridBundleClubbed=gridBundleClubbed+"$$$$"+bundledColumnValue;
			}
	}
	
	if(blockCardNoInLogs)
		WriteLog("columnValueMap--> "+columnValueMap);
		
	//html.append("<tr>");
	String strWIDATA = "";
	String strJSONWIDATA="{";
	for (Map.Entry<String, String> entry : columnValueMap.entrySet()) {
				strWIDATA+=entry.getKey() + "#" + entry.getValue()+"~";
				strJSONWIDATA+="\""+entry.getKey() +"\""+":" +"\""+entry.getValue()+"\""+",";
			}
			
	if(strWIDATA.length()!=0){
			strWIDATA=strWIDATA.substring(0,(strWIDATA.lastIndexOf("~")));
			strJSONWIDATA=strJSONWIDATA.substring(0,(strJSONWIDATA.lastIndexOf(",")));
	}
	strJSONWIDATA+="}";
	if(blockCardNoInLogs)
	{
		WriteLog("strWIDATA-------> "+strWIDATA);	
		WriteLog("strJSONWIDATA-------> "+strJSONWIDATA);	
	}
	html.append("<input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridrowCount' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridrowCount' value= '"+gridCounter+"' />");
	html.append("<input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridselrowindex' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridselrowindex' value= '' />");
	html.append("<input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundleJSON_WIDATA' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundleJSON_WIDATA' value= '"+strJSONWIDATA+"'/>");
	
	html.append("<input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_WIDATA' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_WIDATA' value= '"+strWIDATA+"' />");
	
	html.append("<input type= 'hidden' id='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_clubbed' name='"+firstRecordLabelName+"_"+SubCategoryID+"_gridbundle_clubbed' value= '"+gridBundleClubbed+"'/>");
	//html.append("</tr>");
	return html;
}

public List prepareMultiValMaptoSingleValMap(List <String> recordList,List<Map> cardDetailList)
{

	WriteLog("Inside prepareMultiValMaptoSingleValMap.. :");		
	String ColumnValueList ="";
	List list = null;
	
	//Map<String,String> mapCheck = cardDetailList.get(0);
	
	Map<String,String> mapCheck = new HashMap<String,String> ();
    if(cardDetailList.size()!=0)
	{
		mapCheck = cardDetailList.get(0);
	}
	
	if(blockCardNoInLogs)
		WriteLog("Inside mapCheck "+mapCheck);
		
	XMLParser xmlParserCheckData=new XMLParser();
	xmlParserCheckData.setInputXML(recordList.get(1));
	WriteLog("Inside recordList "+recordList.get(1));
	
	//if(blockCardNoInLogs)
		WriteLog("cardDetailsList "+cardDetailList.get(0));			
		
	String ColumnCheckName = xmlParserCheckData.getValueOf("ColumnName");
	WriteLog("Inside ColumnCheckName "+ColumnCheckName);	
	String ColumnCheckValue = mapCheck.get(ColumnCheckName);
	WriteLog("Inside ColumnCheckValue "+ColumnCheckValue);
	if(ColumnCheckValue!=null)
	{
			if(!ColumnCheckValue.contains("@")){
				WriteLog("ColumnCheckValue does not contain @");				
				return cardDetailList;
			}
	}
 
	for(Map<String,String> map: cardDetailList)
	{
		for(String record: recordList)
		{
			XMLParser xmlParserData=new XMLParser();
			xmlParserData.setInputXML(record);
			
			String ColumnName = xmlParserData.getValueOf("ColumnName");
			String IsRepeatable=xmlParserData.getValueOf("IsRepeatable");
			String ColumnValue = map.get(ColumnName);
			
			String [] arrStrColumnValue = null;
			if(IsRepeatable.equals("Y") && !(ColumnName.equals("NULL")))
			{
				if(ColumnValue==null)
				{
				ColumnValue="";
				}
				if(ColumnValue.contains("@"))
				{
					//if(blockCardNoInLogs)
						WriteLog("ColumnName in prepareMultiValMaptoSingleValMap-->"+ColumnName +"-->"+ColumnValue);
					
					arrStrColumnValue = ColumnValue.split("@");
					//if(arrStrColumnValue.length==0){
					ColumnValue = ColumnValue.replace("@"," @ ");
					arrStrColumnValue = ColumnValue.split("@");
					//}
					/*if(ColumnName.equals("date_and_time"))
					{
						WriteLog("arrStrColumnValue in prepareMultiValMaptoSingleValMap-->"+arrStrColumnValue.length+"#");
					}*/
					for(int i=0 ; i<arrStrColumnValue.length; i++)
					{
						if(i==arrStrColumnValue.length-1)
						{
							ColumnValueList = ColumnValueList + ColumnName+"::"+arrStrColumnValue[i]+"~";
						}else{
							ColumnValueList = ColumnValueList + ColumnName+"::"+arrStrColumnValue[i]+"#";
						}
					}
				}
				
			}
		}
		
	
	}
		if(blockCardNoInLogs)
			WriteLog("ColumnValueList in prepareMultiValMaptoSingleValMap-->"+ColumnValueList);
			
		if(!ColumnValueList.equals(""))
			{
			String[] strArr = ColumnValueList.split("~");
			String[] strSingleType = null;
			String[] strKeyValue = null;
			String strComma = ColumnValueList.replace("#", "~");
			String[] strArrComma = strComma.split("~");
			list = new ArrayList();
			strSingleType = strArr[0].split("#");
			int numOfRows = strSingleType.length;
			int totalRows = strArrComma.length;
			int key = 0;
			for (int l = 0; l < numOfRows; l++) 
			{
				Map tempMap = new HashMap();
				key = l;
				while (key < totalRows) {
				
					strKeyValue = strArrComma[key].split("::");
					tempMap.put(strKeyValue[0], strKeyValue[1].trim());
					key = key + numOfRows;
				}
				list.add(tempMap);
			}
		}else{
			list = cardDetailList;
		}
		
	if(blockCardNoInLogs)
		WriteLog("list in prepareMultiValMaptoSingleValMap-->"+list);
	
	
	return list;
}

%>

<%
	String loadcount = request.getParameter("load");
	String params="";
	WriteLog("loadcount   :   "+loadcount);
	Map <String, String> encryptedCardNumberMap = new HashMap<String, String>();
	
	if (loadcount==null)                                   // need to be changed
		loadcount = "firstLoad";
		
	
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
	boolean bError=false;
	String sCustomerName="";
	String sExpiryDate="";
	String sCardCRNNo="";
	String sSourceCode="";
	String sExtNo="";
	String sMobileNo="";
	String sAccessedIncome="";		
	String sCardType="";
	String sOutputXMLCustomerInfoList="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	Hashtable ht =new  Hashtable();
	String BranchName ="";
	String sProcessName ="";
	
	String branchCode="";

	String sFirstName="";
	String sMiddleName="";
	String sLastName="";
	String sGeneralStat="";
	String sEliteCustomerNo="";
	String inputData="";
	String inputData2="";
	String outputData="";
	String outputData2="";
	String mainCodeData="";
	String inputData3="";
	String outputData3="";
	String mainCodeData3="";
	String PANno="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	XMLParser xmlCardParser=null;
	XMLParser xmlCardParser1=null;
	XMLParser xmlParserData2=null;
	XMLParser xmlParserData3=null;
	String ReturnFields="";
	String sCatname="";
	String subXML="";
	String CategoryID="";
	String SubCategoryID="";
	String transactionTable = "";
	String LogicalName="";
	String DispColCount="";
	String subXML3="";
	XMLParser objXmlParser3=null;
	ArrayList<String> arrList = new ArrayList<String>();
	ArrayList<String> stringList = new ArrayList<String>();
	List<List> frameList = new ArrayList<List>();
	Map<String, String> map = new HashMap<String, String>();
	List <Map> cardDetailList = new ArrayList<Map>();
	String WS=request.getParameter("WS");
	String FlagValue=request.getParameter("FlagValue");
	String WINAME=request.getParameter("WINAME");
	String TEMPWINAME=request.getParameter("TEMPWINAME");
	String CardNo_Masked = request.getParameter("CardNo_Masked");
	String user=wfsession.getUserName();
	String cabName=wfsession.getEngineName();
	String sMode=request.getParameter("ViewMode");
	String CardNumberInitials="";
	String CashBackLimit="";
	String channel=request.getParameter("channel"); // added by amitabh CRCCC
	
	if(sMode==null)
	{
		sMode="";
	}
	
	if (bError)
	{
		out.println("<script>");
		out.println("alert('User session has expired. Please re-login.');");
		out.println("window.parent.close();"); 
		out.println("</script>");
	}
	else
	{
		try
		{
			String sCategory=request.getParameter("Category").replaceAll("_", " ");
			WriteLog("sCategory : "+sCategory);
			String sSubCategory=request.getParameter("SubCategory").replaceAll("_", " ");
			WriteLog("SubCategory : "+sSubCategory);
			//Code block for RED card change
			if(request.getParameter("WS").equals("PBO") && sCategory.equals("Cards") && sSubCategory.equals("Cash Back Redemption") && "firstLoad".equals(loadcount))
			{
				WriteLog("RED Card Initials Number " + CardNumberInitials);
				CardNumberInitials=CardNo_Masked.replace("-","").substring(0,6);
				WriteLog("RED Card Initials Number " + CardNumberInitials);
                /*String Query1="SELECT Cash_Back_Limit FROM USR_0_SRM_CARDS_BIN WHERE Parameter='"+CardNumberInitials+"'";
				String inputData4 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query1 + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
				
				String Query1="SELECT Cash_Back_Limit FROM USR_0_SRM_CARDS_BIN with (nolock) WHERE Parameter=:Parameter";
				params="Parameter=="+CardNumberInitials;
				String inputData4 = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ Query1 + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
				WriteLog("RED InputData-->"+inputData4);
                String outputData4 = WFCallBroker.execute(inputData4, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("RED OutputData-->"+outputData4);
				xmlParserData3=new XMLParser();
				xmlParserData3.setInputXML((outputData4));
				mainCodeData = xmlParserData3.getValueOf("MainCode");
				if(mainCodeData.equals("0"))
				{
					CashBackLimit = xmlParserData3.getValueOf("Cash_Back_Limit");
				}
				WriteLog("RED Cash_Back_Limit="+CashBackLimit);				
				out.println("<input type='hidden' name='CashBackLimit' id='CashBackLimit' value='"+CashBackLimit+"'/>");				
            }
			//code block end for RED card
			
			WriteLog("WS : "+request.getParameter("WS"));
			WriteLog("WINAME : "+request.getParameter("WINAME"));
			WriteLog("TEMPWINAME :::::::12345::: "+request.getParameter("TEMPWINAME"));
			
			StringBuilder htmlcode=new StringBuilder();
			StringBuilder dynamicQuery=new StringBuilder();
			int recordcount =0;
			//String QueryProcessName = "select FrmLout.Frameorder,FrmLout.WS_NAME Logical_Name,FrmLout.LabelName,FrmLout.FieldType,FrmLout.FieldLength,FrmLout.ColumnName,FrmLout.FieldOrder,rsmap.MW_RESPMAP, FrmLout.SubCatIndex, FrmLout.IsEditable, FrmLout.IsMandatory, FrmLout.Pattern, FrmLout.CatIndex, FrmLout.event_function,FrmLout.is_workstep_req, svc.Transaction_Table, dynvar.FieldValue , wrkstp.Workstep_Name WS_Name  from USR_0_SRM_FORMLAYOUT FrmLout, USR_0_SRM_CATEGORY cat, USR_0_SRM_SUBCATEGORY subcat, USR_0_SRM_INT_RSMAP rsmap,  USR_0_SRM_SERVICE svc,  USR_0_SRM_WORKSTEPS wrkstp,  usr_0_srm_dynamic_variable_master dynvar where cat.CategoryIndex=FrmLout.CatIndex  and subcat.SubCategoryIndex=FrmLout.SubCatIndex  and  upper(rsmap.FIELDNAME)='FETCH'  and cat.CategoryIndex=rsmap.CatIndex  and subcat.SubCategoryIndex=rsmap.SubCatIndex  and Upper(cat.CategoryName) ='"+sCategory.toUpperCase()+"'  AND Upper(subcat.SubCategoryName)='"+sSubCategory.toUpperCase()+"'  and svc.SubCatIndex=subcat.SubCategoryIndex and FrmLout.IsActive = 'Y' and wrkstp.SR_ID=svc.SR_ID  and wrkstp.logical_name = FrmLout.ws_name and upper(wrkstp.Workstep_NAME)='"+WS.toUpperCase()+"' and cat.CategoryIndex=dynvar.CatIndex  and subcat.SubCategoryIndex=dynvar.SubCatIndex and dynvar.FieldName='DISP_COL_COUNT' order by FrmLout.Frameorder,FrmLout.FieldOrder";
			
			
			String QueryProcessName = "select FrmLout.Frameorder,FrmLout.WS_NAME Logical_Name,FrmLout.LabelName, FrmLout.FieldType,FrmLout.FieldLength,FrmLout.ColumnName,FrmLout.FieldOrder, rsmap.MW_RESPMAP, rsmap.Req_Category, FrmLout.SubCatIndex, FrmLout.IsEditable, FrmLout.IsMandatory, FrmLout.Pattern, FrmLout.CatIndex, FrmLout.event_function,FrmLout.is_workstep_req,FrmLout.IsRepeatable,FrmLout.isVisibleInGrid,FrmLout.EncryptionRequired,FrmLout.IsAddDelReq,FrmLout.RadioGroupName, svc.Transaction_Table, dynvar.FieldValue, wrkstp.Workstep_Name WS_Name  from USR_0_SRM_FORMLAYOUT FrmLout with (nolock), USR_0_SRM_CATEGORY cat with (nolock), USR_0_SRM_SUBCATEGORY subcat with (nolock), USR_0_SRM_INT_RSMAP rsmap with (nolock),  USR_0_SRM_SERVICE svc with (nolock),  USR_0_SRM_WORKSTEPS wrkstp with (nolock), usr_0_srm_dynamic_variable_master dynvar with (nolock) where cat.CategoryIndex=FrmLout.CatIndex  and subcat.SubCategoryIndex=FrmLout.SubCatIndex  and cat.CategoryIndex=subcat.ParentCategoryIndex and upper(rsmap.FIELDNAME)='FETCH'  and   cat.CategoryIndex=rsmap.CatIndex  and subcat.SubCategoryIndex=rsmap.SubCatIndex  and cat.CategoryName =:CategoryName  AND   subcat.SubCategoryName=:SubCategoryName  and svc.SubCatIndex=subcat.SubCategoryIndex and FrmLout.IsActive = 'Y' and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex and wrkstp.logical_name = FrmLout.ws_name and wrkstp.Workstep_NAME=:Workstep_NAME and cat.CategoryIndex=dynvar.CatIndex  and subcat.SubCategoryIndex=dynvar.SubCatIndex and dynvar.FieldName='DISP_COL_COUNT' order by FrmLout.Frameorder,FrmLout.FieldOrder";
			params="CategoryName=="+sCategory.toUpperCase()+"~~SubCategoryName=="+sSubCategory.toUpperCase()+"~~Workstep_NAME=="+WS.toUpperCase();
						
			/*inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QueryProcessName + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
			
			inputData = "<?xml version='1.0'?>"+
			"<APSelectWithNamedParam_Input>"+
			"<Option>APSelectWithNamedParam</Option>"+
			"<Query>"+ QueryProcessName + "</Query>"+
			"<Params>"+ params + "</Params>"+
			"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
			"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
			"</APSelectWithNamedParam_Input>";
			
			WriteLog("inputData 83-->"+inputData);
			
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData 83-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputData));
			frameList = getFrameListFromXML(outputData);
			mainCodeData = xmlParserData.getValueOf("MainCode");
			recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			String colArray[]=new String[recordcount];
			String colArrayStr = "";
			for(int k=0; k<recordcount; k++)
			{	subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				colArray[k] = objXmlParser.getValueOf("ColumnName");
				colArrayStr = colArrayStr + ","+colArray[k];
				
			}
			WriteLog("colArray----->"+colArrayStr);
			int count=0;
			String temp[]=null;
			String temp2[][]=null;
			int t=0;
			if(mainCodeData.equals("0"))
			{	
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				ReturnFields = objXmlParser.getValueOf("MW_RESPMAP");
				sCatname = objXmlParser.getValueOf("Req_Category");
				CategoryID = objXmlParser.getValueOf("CatIndex");
				SubCategoryID= objXmlParser.getValueOf("SubCatIndex");
				transactionTable=objXmlParser.getValueOf("Transaction_Table");
				LogicalName=objXmlParser.getValueOf("Logical_Name");
				WriteLog("ReturnFields"+ReturnFields);
				DispColCount=objXmlParser.getValueOf("FieldValue");
				if(!ReturnFields.equals("*"))
				{
					temp= ReturnFields.split(",");
					count=temp.length;
					String check[]=null;
					temp2=new String[count][2]; 
					for(int k=0;k<count;k++)
					{
						WriteLog("temp"+temp[k]);
						check=temp[k].split("#");
						temp2[k][0]=check[0];
						temp2[k][1]=check[1];
						
					}
				}
				
				/*String qry = "select comboid,Value,AssocVal from USR_0_SRM_Combos cmb,USR_0_SRM_CATEGORY cat,USR_0_SRM_SUBCATEGORY subcat, USR_0_SRM_WORKSTEPS wrkstp,usr_0_srm_Service svc where cat.CategoryIndex=cmb.CatIndex and subcat.SubCategoryIndex=cmb.SubCatIndex and upper(cat.CategoryName) ='"+sCategory.toUpperCase()+"' AND upper(subcat.SubCategoryName)='"+sSubCategory.toUpperCase()+"' and subcat.parentcategoryindex=cat.CategoryIndex  and cmb.IsActive = 'Y' and upper(wrkstp.Workstep_Name)='"+WS.toUpperCase()+"' and cmb.Ws_Name = wrkstp.Logical_Name and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex ";
			
				inputData3 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + qry + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
			
				String qry = "select comboid,Value,AssocVal from USR_0_SRM_Combos cmb with (nolock),USR_0_SRM_CATEGORY cat with (nolock),USR_0_SRM_SUBCATEGORY subcat with (nolock), USR_0_SRM_WORKSTEPS wrkstp with (nolock),usr_0_srm_Service svc with (nolock) where cat.CategoryIndex=cmb.CatIndex and subcat.SubCategoryIndex=cmb.SubCatIndex and upper(cat.CategoryName) =:CategoryName AND upper(subcat.SubCategoryName)=:SubCategoryName and subcat.parentcategoryindex=cat.CategoryIndex  and cmb.IsActive = 'Y' and upper(wrkstp.Workstep_Name)=:Workstep_Name and cmb.Ws_Name = wrkstp.Logical_Name and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex ";
			
				params="CategoryName=="+sCategory.toUpperCase()+"~~SubCategoryName=="+sSubCategory.toUpperCase()+"~~Workstep_Name=="+WS.toUpperCase();
			
				inputData3 = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				WriteLog("inputData3-->"+inputData3);
				
				outputData3 = WFCallBroker.execute(inputData3, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData3-->"+outputData3);
				//outputData3=outputData3.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData3));
				mainCodeData3 = xmlParserData.getValueOf("MainCode");
				if(mainCodeData3.equals("0"))
				{
					WriteLog("Test mainCodeData3 "+mainCodeData3);
				}
				
				String sMappOutPutXML="";
				if(WS.equals("PBO")&&FlagValue.equals("N"))	
				{	
					/*if(CategoryID.equals("1"))
					{	
						PANno=request.getParameter("panNo");
						PANno = encrypt(PANno);
					}
					else*/				
					PANno=request.getParameter("panNo");
                    if(!(PANno==null))
				    { 
			
						PANno=PANno.replace("ENCODEDPLUS","+");
						
						if(blockCardNoInLogs)
							WriteLog("Plus removed PANno:"+PANno);
						
						//String sCatname="CARDFETCH";
						WriteLog("sCatname----->"+sCatname);
						
						try
						{
							sCabname=wfsession.getEngineName();
							sSessionId = wfsession.getSessionId();
							sJtsIp = wfsession.getJtsIp();
							iJtsPort = wfsession.getJtsPort();
							WriteLog("sCabname is : "+sCabname+" sSessionId is:  "+sSessionId+" sJtsIp: "+sJtsIp);
						}
						catch(Exception ex){
							WriteLog(ex.getMessage().toString());
						}
						String	sInputXML =	"<?xml version=\"1.0\"?>\n" +
							"<APAPMQPutGetMessage>\n" +
							"<Option>SRM_APMQPutGetMessage</Option>\n" +
							"<UserID>"+wfsession.getUserName()+"</UserID>\n" +
							"<CategoryID>"+CategoryID+"</CategoryID>\n" +
							"<SubCategoryID>"+SubCategoryID+"</SubCategoryID>\n" +
							"<CardNumber>"+PANno+"</CardNumber>\n"+ 
							"<SessionId>"+sSessionId+"</SessionId>\n"+
							"<EngineName>"+sCabname+"</EngineName>\n" +
							"<RequestType>"+sCatname+"</RequestType>\n" +
							"</APAPMQPutGetMessage>\n";
					
						String FormValue="";
						if(blockCardNoInLogs)
							WriteLog("sInputXML  "+sInputXML);
						try
					    {
						//uncomment below in onshore environment
						//sMappOutPutXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						//comment below in onshore environment
						
						/*if(CategoryID.equals("1")&&SubCategoryID.equals("1"))
						{
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>5546370220955089</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>2500</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>NORM</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><CustomerName>TestUser</CustomerName><MobileNo>00971500105301</MobileNo></CardDetails></EE_EAI_MESSAGE>";
						//sMappOutPutXML = "<Output><Message><?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>BPMUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>[B@2e722e72</MessageId><Extra1>REP||BPM.123</Extra1><Extra2>2014-10-22T13:27:39.027+04:00</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CIFID>0157061</CIFID><CardNumber>5124037557646009</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>025476300</CardAcctNum><LastStatementDate>2014-09-16</LastStatementDate><Purchases>0</Purchases><LatePaymentCharges>0</LatePaymentCharges><ServiceCharges>0</ServiceCharges><CashAdvances>0</CashAdvances><Payments>0</Payments><TotalAmtDue>-2469.49</TotalAmtDue><MinAmtDue>-100</MinAmtDue><PymtDueDate>2014-10-11</PymtDueDate><TotalCreditLimit>3000</TotalCreditLimit><AuthorizedNotSettled>0</AuthorizedNotSettled><AvailableCreditLimit>0</AvailableCreditLimit><TotalCashLimit>-80</TotalCashLimit><AvailableCashLimit>0</AvailableCashLimit><RewardAmount>0</RewardAmount><OverdueAmount>0</OverdueAmount><OutstandingBalance>-2469.49</OutstandingBalance><PointsOpeningBalance>0</PointsOpeningBalance><EarnedDuringMonth>0</EarnedDuringMonth><RedeemedDuringMonth>0</RedeemedDuringMonth><PointsClosingBalance>0</PointsClosingBalance><ExpiryDate>2015-03-31</ExpiryDate><PrimaryCardHolderName>firstname_258827 midname_258827 lastname_258827</PrimaryCardHolderName><CardType>Credit Card</CardType><CardSubType>MC NMC standard</CardSubType><CardStatus>NORR</CardStatus><CardIssuer></CardIssuer><Telephone></Telephone><NextStatementDate>2014-09-16</NextStatementDate><IsDisputedTran>N</IsDisputedTran><IsCashbackForfeited>N</IsCashbackForfeited><MobileNumber></MobileNumber><DispatchChannel>996</DispatchChannel><DispatchDate>2014-09-08</DispatchDate><CardCRNNumber>025476300</CardCRNNumber><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3><FreeAmount1>0</FreeAmount1><FreeAmount2>0</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails></EE_EAI_MESSAGE><CustomerName>ACCOUNT NAME FOR   0157061</CustomerName><MobileNo>+00971()500157061</MobileNo></Message><Exception><CompletionCode>0</CompletionCode><ReasonCode>0</ReasonCode><Description>success</Description></Exception></Output>";
						}
						
						else  if(CategoryID.equals("1")&&SubCategoryID.equals("3")) 
                            sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955089</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955999</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>STLC</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>STLC</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955099</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955099</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370224441111</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>5546370120967890</card_number><crn>45433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370333355098</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955098</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>4576370120967890</card_number><crn>64334643</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails></EE_EAI_MESSAGE>";
                        
						else  if(CategoryID.equals("1")&&SubCategoryID.equals("2"))
						//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>2015-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>1111111111111111</card_number><card_holder_name>Sumit Kumar1</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2015-01-01</expiry><overdue_amt>987654</overdue_amt><salary>30000000</salary><available_balance>20000000</available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><mobile_number>99999999999</mobile_number><source></source></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>2222222222222222</card_number><card_holder_name>Sumit Kumar2</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Supplementary</cardholder_type><product>88888888</product><expiry>1900-01-01</expiry><overdue_amt>987654</overdue_amt><salary>30000000</salary><available_balance>20000000</available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORR</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Supplementary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><mobile_number>99999999999</mobile_number><source></source></CardDetails></EE_EAI_MESSAGE>";	
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>2015-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER>	<CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>1111111111111111</card_number><card_holder_name>Sumit Kumar1</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2015-01-01</expiry><overdue_amt>987654</overdue_amt><salary>30000000</salary><available_balance>20000000</available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><mobile_number>99999999999</mobile_number><source></source></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>2222222222222222</card_number><card_holder_name>Sumit Kumar2</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2015-01-01</expiry><overdue_amt>987654</overdue_amt><salary>30000000</salary><available_balance>20000000</available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><mobile_number>99999999999</mobile_number><source></source></CardDetails></EE_EAI_MESSAGE>";	
						
						else  if(CategoryID.equals("1")&&SubCategoryID.equals("4"))
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>77777777</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>1111111111111111</card_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>100</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>989999999</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>2222222222222222</card_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORR</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>3333333333333333</card_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NEWR</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>99</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>4444444444444444</card_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>5555555555555555</card_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORI</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details></EE_EAI_MESSAGE>";
						
							//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>S</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>ATMR</card_status><available_balance>500</available_balance><card_type2>VISA</card_type2><product_level>ABC</product_level><expiry_date>15-06-2014</expiry_date><c_o_a>XYZ</c_o_a><eligible_bt_amount>500</eligible_bt_amount><eligible_bt_amount_words>Five Hundred</eligible_bt_amount_words><RAK_creditcardno>5678954678647276</RAK_creditcardno><customer_name>Ram</customer_name><card_holder_type>Primary</card_holder_type><crn_no>12345</crn_no><cif>54321</cif><salary>9999999</salary><mobile_number>988888888888</mobile_number><agent_network_id>7777777</agent_network_id><sales_agent_id>66666666</sales_agent_id></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>S</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>5546370120967890</card_number><crn>45433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>CD05</card_status><available_balance>500</available_balance><card_type2>VISA</card_type2><product_level>ABC</product_level><expiry_date>15-06-2014</expiry_date><c_o_a>XYZ</c_o_a><eligible_bt_amount>500</eligible_bt_amount><eligible_bt_amount_words>Five Hundred</eligible_bt_amount_words><RAK_creditcardno>5678954678647276</RAK_creditcardno><customer_name>Ram</customer_name><card_holder_type>Primary</card_holder_type><crn_no>12345</crn_no><cif>54321</cif><salary>9999999</salary><mobile_number>988888888888</mobile_number><agent_network_id>7777777</agent_network_id><sales_agent_id>66666666</sales_agent_id></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>4576370120967890</card_number><crn>64334643</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>NORN</card_status><available_balance>500</available_balance><card_type2>VISA</card_type2><product_level>ABC</product_level><expiry_date>15-06-2014</expiry_date><c_o_a>XYZ</c_o_a><eligible_bt_amount>500</eligible_bt_amount><eligible_bt_amount_words>Five Hundred</eligible_bt_amount_words><RAK_creditcardno>5678954678647276</RAK_creditcardno><customer_name>Ram</customer_name><card_holder_type>Primary</card_holder_type><crn_no>12345</crn_no><cif>54321</cif><salary>9999999</salary><mobile_number>988888888888</mobile_number><agent_network_id>7777777</agent_network_id><sales_agent_id>66666666</sales_agent_id></CardDetails></EE_EAI_MESSAGE>";				
											
											
											
						//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>abc</card_holder_name><card_holder_type>type1</card_holder_type><cif>347326</cif><mobile_number></mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>43543543564365</card_number><crn>132243</crn><card_holder_name2>abc</card_holder_name2><card_expiry_date>1900-01-01</card_expiry_date><card_holder_type2>type1</card_holder_type2><card_type>credit</card_type><card_status>004</card_status></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>S</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>abc</card_holder_name><card_holder_type>type1</card_holder_type><cif>347326</cif><mobile_number></mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>43543543564365</card_number><crn>45433443</crn><card_holder_name2>xyz</card_holder_name2><card_expiry_date>1900-01-01</card_expiry_date><card_holder_type2>type2</card_holder_type2><card_type>credit</card_type><card_status>004</card_status></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>S</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>abc</card_holder_name><card_holder_type>type1</card_holder_type><cif>347326</cif><mobile_number></mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>43543543564365</card_number><crn>45433443</crn><card_holder_name2>xyz</card_holder_name2><card_expiry_date>1900-01-01</card_expiry_date><card_holder_type2>type2</card_holder_type2><card_type>credit</card_type><card_status>004</card_status></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>S</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>abc</card_holder_name><card_holder_type>type1</card_holder_type><cif>347326</cif><mobile_number></mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>43543543564365</card_number><crn>45433443</crn><card_holder_name2>xyz</card_holder_name2><card_expiry_date>1900-01-01</card_expiry_date><card_holder_type2>type2</card_holder_type2><card_type>credit</card_type><card_status>004</card_status></CardDetails></EE_EAI_MESSAGE>";*/
						
						if(blockCardNoInLogs)
							WriteLog("sMappOutPutXML zzz : "+sMappOutPutXML);
					    }catch(Exception exp){
						//bError=true;
					    }
						
						if(blockCardNoInLogs)
						WriteLog("sMappOutPutXML is : "+sMappOutPutXML);
						
					xmlParserData.setInputXML((sMappOutPutXML));
					XMLParser validateFetchResponse = new XMLParser(sMappOutPutXML);
					String validReturnCode = validateFetchResponse.getValueOf("ReturnCode");
					String validReasonCode = validateFetchResponse.getValueOf("ReasonCode");
					WriteLog("ReasonCode is : "+validReasonCode);
					WriteLog("ReturnCode is : "+validReturnCode);
					
					if("-1".equals(validReasonCode))
					{
						out.println("<script>");
						out.println("alert('Please check the card number entered.');hideProcessingCustom();");
						out.println("</script>");
					}
					else if("Debit".equals(validReturnCode))
					{
						out.println("<script>");
						out.println("alert('Only Credit Card is allowed for this request.');hideProcessingCustom();");
						out.println("</script>");
					}
					else if(!"0000".equals(validReturnCode))
					{
						out.println("<script>");
						out.println("alert('Unable to fetch card details. Please contact administrator.');hideProcessingCustom();");
						out.println("</script>");
					}
					String strTagName="CardDetails";
					/*if(CategoryID.equals("1")&&SubCategoryID.equals("4"))
					{
						strTagName="Customer Details";
					}
					else
					{
						strTagName="CardDetails";
					}*/
					//Code starts to make card number and encrypted card number map and set in a hidden field over form
					
					
					// start - added to give alert when no CardDetails are found from Card_List call on 23072017
					
						String CheckCardDetailsTag = "CardDetails"; //value expected at onshore
						String mwResponse1=sMappOutPutXML;
						xmlCardParser1 = new XMLParser();
						
						if (mwResponse1.indexOf("<"+CheckCardDetailsTag+">")>-1)
						{
						} else {
							out.println("<script>");
							out.println("alert('No Card Details are found');hideProcessingCustom();");
							out.println("</script>");
						}
						
					// end - added to give alert when no CardDetails are found from Card_List call on 23072017
					
					if(CategoryID.equals("1") && (SubCategoryID.equals("4") || SubCategoryID.equals("2")|| SubCategoryID.equals("5")))
					{
						String repeatTag = "CardDetails"; //value expected at onshore
						String strCardNoTag="CardNumber"; //value expected at onshore
						//this block to be removed at onshore as the tags wont differ
						/*if(SubCategoryID.equals("4"))
						{
							repeatTag="Customer Details";
							strCardNoTag="card_no";
						}
						else if(SubCategoryID.equals("2"))
						{
							repeatTag="CardDetails";
							strCardNoTag="card_number";
						}*/
						String mwResponse=sMappOutPutXML;
						xmlCardParser = new XMLParser();
						WriteLog("Before  map creation  : ");
						while (mwResponse.indexOf("<"+repeatTag+">")>-1)
						{
							xmlCardParser.setInputXML(mwResponse);
							String cardNo = xmlCardParser.getValueOf(strCardNoTag);
							String encrytpedString = xmlCardParser.getValueOf("encrypted_cardno");
							encryptedCardNumberMap.put(cardNo, encrytpedString);
							
							mwResponse=mwResponse.substring(mwResponse.indexOf("</"+repeatTag+">")+("</"+repeatTag+">").length());						
						}
						String jsonStringforMap="{";
						for (Map.Entry entry : encryptedCardNumberMap.entrySet())
						{
							jsonStringforMap+="\""+entry.getKey()+"\":\""+entry.getValue()+"\",";
						}
						jsonStringforMap = jsonStringforMap.substring(0,jsonStringforMap.lastIndexOf(","));
						jsonStringforMap+="}";
						out.println("<input type='hidden' name='encryptedmap' id='encryptedmap' value='"+jsonStringforMap+"'/>");
										
						//code ends for making a json map and setting it in a hidden field on form
						
					}
					
					int counter=xmlParserData.getNoOfFields(strTagName);					
					WriteLog("counter  : "+counter);
					for(int l=0; l<counter; l++)
					{
						//map.clear();
						subXML3 = xmlParserData.getNextValueOf(strTagName);
						map= new HashMap<String,String>();
						for(int i=0;i<count;i++)
						{
							//subXML3 = xmlParserData.getNextValueOf(strTagName);
							objXmlParser3 = new XMLParser(subXML3);
							
							WriteLog("temp2[i][0]  : "+temp2[i][0]);
							WriteLog("temp2[i][1]  : "+temp2[i][1]);
							if(temp2[i][1].indexOf("~")>-1)
							{
								String str=objXmlParser3.getValueOf(temp2[i][0]);
								WriteLog("ResponseValue str= "+str);	
								/*String QR="select FormValue from USR_0_SRM_CARDS_DECODE where ResponseTag ='"+temp2[i][0]+"' and ResponseValue='"+str+"' and IsActive='Y'";

								inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
								String QR="select FormValue from USR_0_SRM_CARDS_DECODE with (nolock) where ResponseTag =:ResponseTag and ResponseValue=:ResponseValue and IsActive='Y'";
								
								if("".equals(str))
									str=temp2[i][0];
								params="ResponseTag=="+temp2[i][0]+"~~ResponseValue=="+str;
								
								inputData2 = "<?xml version='1.0'?>"+
									"<APSelectWithNamedParam_Input>"+
									"<Option>APSelectWithNamedParam</Option>"+
									"<Query>"+ QR + "</Query>"+
									"<Params>"+ params + "</Params>"+
									"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
									"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
									"</APSelectWithNamedParam_Input>";
							
								WriteLog("inputData2-->"+inputData2);
								outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
								WriteLog("outputData2-->"+outputData2);
								xmlParserData2=new XMLParser();
								xmlParserData2.setInputXML((outputData2));
								mainCodeData = xmlParserData2.getValueOf("MainCode");
								if(mainCodeData.equals("0"))
								{
									FormValue = xmlParserData2.getValueOf("FormValue");
									if(FormValue.indexOf("$")>-1)
									{	FormValue=FormValue.substring(FormValue.indexOf("$")+1);
										FormValue=getSessionValues(FormValue, wfsession);
										WriteLog("FormValue after function call-->"+FormValue);
									}
									map.put(temp2[i][1].replaceAll("~",""),FormValue);
								}
								/*if(blockCardNoInLogs)
									WriteLog("map INSIDE IF-->"+map.toString());*/
							}
							else
							{
								map.put(temp2[i][1],objXmlParser3.getValueOf(temp2[i][0]));
								
							}
							
							/*if(blockCardNoInLogs)
								WriteLog("map INSIDE ELSE-->"+map.toString());*/
						}
						if(blockCardNoInLogs)
							WriteLog("map----------------->"+map.toString());
						cardDetailList.add(map);
					}
					/*	if(blockCardNoInLogs)
						{
							WriteLog("cardDetailList-->"+cardDetailList.toString());
							WriteLog("cardDetailList First Element-->"+cardDetailList.get(0).toString());
						}*/
						
				   }
					
				 }
				 else
				{	
					String val1="";
					String val2="";
				
					/*String QR_colnames="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+transactionTable+"' AND TABLE_SCHEMA='dbo'";
					inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR_colnames + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
					
					String QR_colnames="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS with (nolock) WHERE TABLE_NAME = :TABLE_NAME AND TABLE_SCHEMA='dbo'";
				    params = "TABLE_NAME=="+transactionTable;
					
					inputData2 = "<?xml version='1.0'?>"+
					"<APSelectWithNamedParam_Input>"+
					"<Option>APSelectWithNamedParam</Option>"+
					"<Query>"+ QR_colnames + "</Query>"+
					"<Params>"+ params + "</Params>"+
					"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
					"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
					"</APSelectWithNamedParam_Input>";
					
					WriteLog("inputData2QR_colnames -->"+inputData2);
					outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
					WriteLog("outputData22QR_colnames -->"+outputData2);
					xmlParserData.setInputXML((outputData2));
					mainCodeData = xmlParserData.getValueOf("MainCode");
					int recCount= Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
					String tr_table_cols[]=new String[recCount];
					if(mainCodeData.equals("0"))
					{	
						for(int i=0;i<recCount;i++)
						{	subXML = xmlParserData.getNextValueOf("Record");
							objXmlParser = new XMLParser(subXML);
							tr_table_cols[i]=objXmlParser.getValueOf("COLUMN_NAME");
						}
					}
					String Query="select";
					for(int r=0;r<recCount;r++)
					{
						Query+=" "+tr_table_cols[r]+",";
					}
					Query=Query.substring(0,(Query.lastIndexOf(",")));
					/*Query+=" from "+transactionTable+" where WI_NAME ='"+WINAME+"' OR TEMP_WI_NAME ='"+TEMPWINAME+"'";


					inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
					
					Query+=" from "+transactionTable+" where WI_NAME =:WI_NAME OR TEMP_WI_NAME =:TEMP_WI_NAME";
					params = "WI_NAME=="+WINAME+"~~TEMP_WI_NAME=="+TEMPWINAME;
					inputData2 = "<?xml version='1.0'?>"+
						"<APSelectWithNamedParam_Input>"+
						"<Option>APSelectWithNamedParam</Option>"+
						"<Query>"+ Query + "</Query>"+
						"<Params>"+ params + "</Params>"+
						"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
						"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
						"</APSelectWithNamedParam_Input>";
				
					WriteLog("inputData2-->"+inputData2);
					
					outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
					WriteLog("outputData2-->"+outputData2);
					outputData2=outputData2.replaceAll("NULL","");
					xmlParserData.setInputXML((outputData2));
					mainCodeData = xmlParserData.getValueOf("MainCode");
					/*if((CategoryID.equals("1")))
						PANno = Decrypt(xmlParserData.getValueOf("KEYID"));
					else*/
						PANno = xmlParserData.getValueOf("KEYID");
					if(mainCodeData.equals("0"))
					{	
						for(int i=0;i<recordcount;i++)
						{	if(!xmlParserData.getValueOf(colArray[i]).equals(""))
							{	
							
								WriteLog("Values Before Decode-->"+xmlParserData.getValueOf(colArray[i]));
							
								String val="";
								try
								{
									val=URLDecoder.decode(xmlParserData.getValueOf(colArray[i]), "UTF-8");
									//below block added to show proper card number for ibmb cases
									if ((colArray[i].equalsIgnoreCase("card_no") || colArray[i].equalsIgnoreCase("rakbank_eligible_card_no") || colArray[i].equalsIgnoreCase("rak_card_no") || colArray[i].equalsIgnoreCase("card_no_1") || colArray[i].equalsIgnoreCase("card_number")) && val.contains(" "))
										val = val.replace(" ","+");
									//*********************************************************	
								}
								catch (UnsupportedEncodingException ex) 
								{             
									ex.printStackTrace();         
								} 
								map.put(colArray[i],val);
								val1=colArray[i];
								val2=xmlParserData.getValueOf(colArray[i]);
								WriteLog("Values-->"+val1+" & "+val);
							}
						}
						cardDetailList.add(map);
					}
				}
				
				if(blockCardNoInLogs)
				WriteLog("PAN NO:"+PANno);
			
				//htmlcode=getDynamicHtml_second(outputData,loadcount,map,WS,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode);
				WriteLog("cardDetailList=" +cardDetailList.toString());
				
				WriteLog("frameList=" +frameList.toString());
				if(blockCardNoInLogs)
				WriteLog("cardDetailList Maps-------->"+cardDetailList);
			
				//if(CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("1")))
				//{
				//	htmlcode=getDynamicHtml_second(outputData,loadcount,cardDetailList,WS,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode);
				//}else 
				//{
					htmlcode=getDynamicHtml_FrameWise(frameList,loadcount,cardDetailList,WS,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode,FlagValue,wfsession.getJtsIp(), wfsession.getJtsPort(),wfsession.getEngineName(), wfsession.getSessionId());
				//} 
				
				/*if(blockCardNoInLogs)
					WriteLog("htmlcode final-->"+htmlcode.toString());*/
				out.println(htmlcode.toString());
				out.println("<input type='hidden' name='tr_table' id='tr_table' value='"+transactionTable+"'/>");
				out.println("<input type='hidden' name='WS_LogicalName' id='WS_LogicalName' value='"+LogicalName+"'/>");
				out.println("<input type='hidden' name='CategoryID' id='CategoryID' value='"+CategoryID+"'/>");
				out.println("<input type='hidden' name='SubCategoryID' id='SubCategoryID' value='"+SubCategoryID+"'/>");
				out.println("<input type='hidden' name='WS_NAME' id='WS_NAME' value='"+WS+"'/>");
				out.println("<input type='hidden' name='username' id='username' value='"+user+"'/>");
				out.println("<input type='hidden' name='WINAME' id='WINAME' value='"+WINAME+"'/>");
				out.println("<input type='hidden' name='TEMPWINAME' id='TEMPWINAME' value='"+TEMPWINAME+"'/>");
				out.println("<input type='hidden' name='sMode' id='sMode' value='"+sMode+"'/>");
				out.println("<input type='hidden' name='channel' id='channel' value='"+channel+"'/>"); // added by amithabh CRCCC
				//out.println("<input type='hidden' name='iFrameOutputXML' id='iFrameOutputXML' value='"+outputData+"'/>");
				
				if(WS.equals("PBO") || WS.equals("PBR"))
				out.println("<input type='hidden' name='CardNo_Masked' id='CardNo_Masked' value='"+CardNo_Masked+"'/>");
			
			    //Code added by Aishwarya for mandatory documents check
				/*String docquery = "select doctype from usr_0_srm_document doc, usr_0_srm_worksteps ws, usr_0_srm_category cat, usr_0_srm_subcategory scat, usr_0_srm_service srv where upper(cat.categoryName) = '"+sCategory.toUpperCase()+"' and upper(scat.subcategoryName) = '"+sSubCategory.toUpperCase()+"' and srv.catindex = cat.categoryindex and srv.subcatindex = scat.subcategoryindex and srv.sr_id = doc.sr_id and srv.sr_id = ws.sr_id and upper(ws.workstep_name) = '"+WS.toUpperCase()+"' and doc.workstep = ws.logical_name";
				
				String inputxmldoc = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + docquery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
				
				String docquery = "select doctype from usr_0_srm_document doc, usr_0_srm_worksteps ws, usr_0_srm_category cat, usr_0_srm_subcategory scat, usr_0_srm_service srv where upper(cat.categoryName) = :categoryName and upper(scat.subcategoryName) = :subcategoryName and srv.catindex = cat.categoryindex and srv.subcatindex = scat.subcategoryindex and srv.sr_id = doc.sr_id and srv.sr_id = ws.sr_id and upper(ws.workstep_name) = :workstep_name and doc.workstep = ws.logical_name";
				
				params="categoryName=="+sCategory.toUpperCase()+"~~subcategoryName=="+sSubCategory.toUpperCase()+"~~workstep_name=="+WS.toUpperCase();
				String inputxmldoc = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ docquery + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
			
				WriteLog("inputxmldoc -->"+inputxmldoc);
				String outputxmldoc = WFCallBroker.execute(inputxmldoc, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputxmldoc -->"+outputxmldoc);
				xmlParserData.setInputXML(outputxmldoc);
				String mainCodeDoc = xmlParserData.getValueOf("MainCode");
				WriteLog("MaincodeDOC -->"+mainCodeDoc);
				int noOfDoc= Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				String requiredDocs = "";
				if(mainCodeDoc.equals("0"))
				{	
					if(noOfDoc>0)
					{
						for(int i=0;i<noOfDoc;i++)
						{	subXML = xmlParserData.getNextValueOf("Record");
							objXmlParser = new XMLParser(subXML);
							requiredDocs+=objXmlParser.getValueOf("doctype")+",";
						}
						requiredDocs=requiredDocs.substring(0,(requiredDocs.lastIndexOf(",")));
					}
				}
				else
				{
					out.println("Error in getting mandatory docs");
				}
				out.println("<input type='hidden' name='mandatoryDocs' id='mandatoryDocs' value='"+requiredDocs+"'/>");
			}
		}
		catch(Exception e){
			WriteLog("Exception in BPMCommonBlocks");
		//e.printStackTrace();
		}
	}

%>	
	
</BODY>
</Form>
</HTML>







