<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : BPM_CommonBlocksDebitCard.jsp
//Author                     : Deepti Sharma, Aishwarya Gupta
//Date written (DD/MM/YYYY)  : 21-Mar-2014
//Description                : Dymanic form painting after fetching configurations from MDM
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
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

<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>


<script language="javascript" src="/TF/webtop/scripts/TF_Script/json3.min.js"></script>
<script language="javascript" src="/TF/webtop/scripts/clientTF.js"></script>
<script language="javascript" src="/TF/webtop/scripts/TF_Script/Validation_TF.js"></script>
<script language="javascript" src="/TF/webtop/scripts/TF_Script/FieldValidation.js"></script>
<script language="javascript" src="/TF/webtop/scripts/TF_Script/keyPressValidation.js"></script>
<script language="javascript" src="/TF/webtop/scripts/TF_Script/populateCustomValue.js"></script>
<!DOCTYPE html> 
<HTML>
<Head>	
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
</Head>

<script language=JavaScript>
  // This script tag contains code to disable the right click on the web page.

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

// document.oncontextmenu=new Function("alert(message);return false") 
// document.oncontextmenu=new Function("return false") 
</script>
<script type="text/javascript">

	

	function callOnLoad()
	{
	//In this function Write Custom Validation and code	required on page load, populateCustomValue.js;
		customOnLoad();
		var SubCategoryID=document.getElementById("SubCategoryID").value;
		//alert("Subcategory is "+SubCategoryID);
		//var islamic_value = document.getElementById(actualSubCatId+"_IslamicOrConventional").value;
		//alert("islamic_value"+islamic_value);
		
		
		if(!document.getElementById(SubCategoryID+"_verification_details").disabled)
			document.getElementById(SubCategoryID+"_verification_details").focus();
		if(parent.document.getElementById("wdesk:IntegrationStatus").value=='false' && parent.document.getElementById("wdesk:WS_NAME").value=='CSO' )
			disableFieldsOnIntroReload();
			
		//call to set first radio in the grid on form load
		var sMode = document.getElementById("sMode").value;
		if(parent.document.getElementById("wdesk:WS_NAME").value!='CSO'||parent.document.getElementById("wdesk:WS_NAME").value!='CM_Introduction')
		{
			
			if(SubCategoryID==2)
			{
				
				var rowsInCardGrid = parseInt(document.getElementById('BALANCE TRANSFER DETAILS_GridTable').rows.length);
				
				if(rowsInCardGrid>1)
				{
					//for defaulting balance transfer details to first record
					var columnList = "2_sub_ref_no, 2_rakbank_eligible_card_no, 2_bt_amt_req, 2_other_bank_card_type, 2_name_on_card, 2_other_bank_card_no, 2_type_of_bt, 2_other_bank_name, 2_remarks, 2_payment_by, 2_delivery_channel, 2_branch_name, 2_eligibility, 2_v_non_eligibility_reasons";
					populateFormFromRadio(columnList,'BALANCE TRANSFER DETAILS','',1,sMode);
					document.getElementById('BALANCE TRANSFER DETAILS_Radio_0').checked=true;	
				}
			}
		}
	}
	function ValidateNumericInCommonJsp(Object)
	{
		parent.ValidateNumericInCommonJsp(Object); 
	}
	
	function validateSpecialCharacters(Object)
	{
		parent.validateSpecialCharacters(Object); 
	}
	
	function validateSpecialCharactersForRef(Object)
	{
		parent.validateSpecialCharactersForRef(Object); 
	}
	
	function validateWINumber(Object)
	{
		parent.validateWINumber(Object); 
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
		var wsname=document.getElementById("ws_name").value;
	
		if((SubCategoryID=='4' || SubCategoryID=='2') && wsname!="CSO")
			document.getElementById("AUTHORIZATION DETAILS_Modify").style.visibility='visible';
		//else if((SubCategoryID=='4' || SubCategoryID=='2') && wsname=="Q1")
			//document.getElementById("AUTHORIZATION DETAILS_Modify").style.visibility='hidden';
					
		//parent.setPrimaryField();
		formLoadCheck();
	}
	function HistoryCaller()
	{	
		parent.HistoryCaller();
	}
	function showDivForRadioAfterSavedCaller()
	{	
		parent.showDivForRadioAfterSaved();
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
		
		//commented by ankit below for JIRA BRSTB-109
		//if(SubCategoryID==3)
		/*{
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
				else if(!ModifyGridValues(columnList,framename,SubCategoryID))
				{
					var gridBundle=document.getElementById(framename+'_modifyGridBundle').value;
					var id = gridBundle.substring(gridBundle.lastIndexOf("_")+1,gridBundle.length);
					
					document.getElementById(framename+"_Radio_"+id).checked=true;
					
					return false;
				}
				
			}
		}*/
		document.getElementById(framename+"_"+SubCategoryID+'_gridselrowindex').value=rowindex;		
		
		var gridBundleValue = (document.getElementById(selGridModifyBundleID).value).replace(/^\s+|\s+$/gm,'');
		
		if(gridBundleValue.length-1 == gridBundleValue.lastIndexOf("~"))
			gridBundleValue = gridBundleValue.substring(0,gridBundleValue.lastIndexOf("~"));

		
		
		var arrElementData=gridBundleValue.split('~');
		var namedata="";
		var len = arrElementData.length;
		
		showDivForRadioAfterSavedCaller();
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
			else if(document.getElementById(columnName).type=='radio')
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
			else
			{
				document.getElementById(columnName).value=columnValue;
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
		//if(framename!='CARD DETAILS')
		document.getElementById(framename+"_"+SubCategoryID+'_gridselrowindex').value='';
		var len = arrColumnList.length;
		for (var i = 0; i < len; i++)
		{			
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
				//alert("fieldName "+fieldName);
				var fieldNameArr = fieldName.split("#");
				var arrLen=fieldNameArr.length;
				//alert("fieldNameArr[6] "+fieldNameArr[6]);
				/*if(fieldNameArr[6]=='Y')
					document.getElementById(arrColumnList[i]).disabled = false;
				else
					document.getElementById(arrColumnList[i]).disabled = true;*/
			}
			
		}
		
		document.getElementById(framename+'_modifyGridBundle').value='';
		
				
			var myradio = document.getElementsByName(framename+'_Radio');
			var x = 0;
			for(x = 0; x < myradio.length; x++)
			{
				if(SubCategoryID!='3' )//&& framename!='CARD DETAILS')// nosave
					myradio[x].checked=false;
			}
		customClearGridFields(columnList,framename);	
	}
	
	function pupulateAccDts(Object)
	{
		parent.pupulateAccDts(Object); 
	}
	//added by badri for CRN number
	function pupulateAccDtsforcards(Object)
	{
		parent.pupulateAccDtsforcards(Object); 
	}
	
	function populateservicerequest()
	{
		parent.populateservicerequest(); 
	}
	
	function islamic()
	{
		parent.islamic(); 
	}
	
	function islamicval()
	{
		parent.islamicval();
	}	
	function setCurrency()
	{
		parent.setCurrency();
	}
	function getCurrency()
	{
		parent.getCurrency();
	}
	function getwiname()
	{
		parent.getwiname(); 
	}
	
	function onBlurForAmount(Object)
	{
		parent.onBlurForAmount(Object); 
	}
	
	function openwi(Object)
	{
		parent.openwi(Object); 
	}
	
	//below function added for handling decimal value to a given numbers
	function insertDecimal(Object)
	{
		parent.insertDecimal(Object); 
	}
	
	//below function added for calculating Exchange Rate field from dynamic service requests
	function calExchangeRate(Object)
	{
		parent.calExchangeRate(Object); 
	}
	
	// below function added only for Service Request - Request to transfer the excess balance/issuance of mangers cheque
	function onBlurForAmountlessthan(Object)
	{
		parent.onBlurForAmountlessthan(Object); 
	}
	
	//added by badri for account no validation
	function onBlurForaccountnumber(Object)
	{
		parent.onBlurForaccountnumber(Object); 
	}
	
	//added to set dynamic value in exttable
	function setValOnBlur(Object,FieldType)
	{
		parent.setValOnBlur(Object,FieldType); 
	}
	
	//Added by badri to validate card number for prepaid card services
	function onBlurForcardnumber(Object)
	{
		parent.onBlurForcardnumber(Object); 
	}
	
	//Added by badri to validate card pack ID for prepaid card services
	function onBlurForcardpackID(Object)
	{
		parent.onBlurForcardpackID(Object); 
	}
	
	
	function validateChequeDate(field,value,Object)
	{
		parent.validateChequeDate(field,value,Object); 
	}
	
	function ModifyGridValues(columnList,frameName,SubCategoryID)
	{
		var WSName=document.getElementById("ws_name").value;
		var in_tbl_name = frameName+"_GridTable";
		columnList = columnList.replace(/\s/g, '');
		var arrColumnList = columnList.split(",");
		
		var modifyGridBundleId = document.getElementById(frameName+'_modifyGridBundle').value;
		var tempElementName = frameName+"_"+SubCategoryID+"_gridbundle_";
		var gridRowNum = modifyGridBundleId.substring(tempElementName.length);
		var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
		
		//code added by Aishwarya for clearing frame on click of modify
		var oldGridBundleWIData=document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value;
		
		
		if(modifyGridBundleId==null || modifyGridBundleId=="")
		{
			alert("Please select account to modify.");
			return false;
		}
		
		if(SubCategoryID==3)
		{
			if(!document.getElementById("3_block_card").checked)
			{
			//return true;
			}
		}
		//added by ankit for JIRA BRSTB-109
		var NameData=getNameDataInCommonJsp();		
		if(!ValidateCommonJsp(NameData))
		return false;
		
		if(!ValidateduplicateAccountNoOnModifyButton(in_tbl_name,arrColumnList,gridRowNum))
		return false;
		
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
					if((SubCategoryID==2 || SubCategoryID==4) && frameName=='CARD DETAILS' && WSName!='CSO')
			
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
		
		//code added by Aishwarya for clearing frame on click of modify
		var newGridBundleWIData=document.getElementById(frameName+"_"+SubCategoryID+'_gridbundle_WIDATA').value;
		if(newGridBundleWIData!=oldGridBundleWIData && (frameName=='BALANCE TRANSFER DETAILS' || frameName=='CREDIT CARD CHEQUE DETAILS') && parent.document.getElementById("wdesk:WS_NAME").value=='CSO')
			ClearGridFields(columnList,frameName);
			
		var iframe = parent.document.getElementById("frmData");	
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		
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
			
		var NameData=getNameDataInCommonJsp();		
		if(!ValidateCommonJsp(NameData))
		return false;
		
		if(!ValidateduplicateAccountNo(in_tbl_name,arrColumnList))
		return false;
	//End In this function Write Custom Validation and code	on change of data of grid, populateCustomValue.js;
	
	
    var td='';
	var strHtml='';
	var tbody = document.getElementById(in_tbl_name).getElementsByTagName("TBODY")[0];
	var row = document.createElement("TR");
	
	var td1 = document.createElement("TD");
	var strHtml1="<input type='radio' style='text-align:center;'  name='"+frameName+"_Radio' id='"+frameName+"_Radio_"+gridRowCount+"' value='"+frameName+"_Radio_0'  onclick=\"javascript:populateFormFromRadio('"+columnList+"','"+frameName+"','"+frameName+"_"+SubCategoryID+"_gridbundle_"+gridRowCount+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">";
	
	td1.style.textAlign='center';
	td1.innerHTML = strHtml1;
	row.appendChild(td1);
	
	var len = arrColumnList.length;
		
	var selWIElementData = "";
	var arrSelWIElementData = "";
	var modWIElementData = "";

	var selGridWIData = document.getElementById(frameName+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
	//alert("3");

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
		td.style.textAlign='left';
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












	//alert("4");
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
	//alert("5");
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
	//return false;
	ClearGridFields(columnList,frameName);
	var objSingleJson = JSON.parse(singleJson);
	var obj = JSON.parse(selGridWIData);
	var modifiedStrJson = '';
	for(var key in obj)
	{
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
function ValidateduplicateAccountNo(in_tbl_name,arrColumnList)
{
		var refTab = document.getElementById(in_tbl_name);
		var flag=true;
		if(refTab.rows.length==1)
		return true;
		for (var i = 0; i < refTab.rows.length; i++) {
			if(i==0)
			continue;			
			  for(var j=0;j<arrColumnList.length;j++)
			  {
					var valueInGrid=document.getElementById('grid_'+arrColumnList[j]+'_'+(i-1)).value;
					var valueGoingToAdd=document.getElementById(arrColumnList[j]).value;
					if(valueInGrid==valueGoingToAdd)
						flag=false;
					else
					{
						flag=true;//if any not match found in any for any column then break the loop because then it is not duplicate
						break;
					}
			  }
			  if(!flag)
			  {
					alert("Duplicate Row is not allowed in grid.");
					return false;
			  }
		}
		return true;
}
function ValidateduplicateAccountNoOnModifyButton(in_tbl_name,arrColumnList,gridRowNum)
{
		gridRowNum=parseInt(gridRowNum)+1;//adding one because ist row is header in grid
		var refTab = document.getElementById(in_tbl_name);
		var flag=true;
		if(refTab.rows.length==1)
		return true;
		for (var i = 0; i < refTab.rows.length; i++) 
		{
			if(i==0)
			continue;		
			if(gridRowNum==i)
			continue;			
			  for(var j=0;j<arrColumnList.length;j++)
			  {
					var valueInGrid=document.getElementById('grid_'+arrColumnList[j]+'_'+(i-1)).value;
					var valueGoingToAdd=document.getElementById(arrColumnList[j]).value;
					if(valueInGrid==valueGoingToAdd)
					flag=false;
					else
					{
						flag=true;//if values does not match in any for any column then break the loop because then it is not duplicate
						break;
					}
			  }
			  if(!flag)
			  {
					alert("Duplicate Row is not allowed in grid.");
					return false;
			  }
		}
		return true;
}
function getNameDataInCommonJsp()
{	//var customform = '';
	//var formWindow = getWindowHandler(windowList, "formGrid");
	//customform = formWindow.frames['customform'];
	//var iframe = customform.document.getElementById("frmData");
	//var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
    var CategoryID = document.getElementById("CategoryID").value;
	var NameData = "";
    var myname;
    var WS_LogicalName;
    var eleValue;
    var eleName;
    var eleName2;
    var eleName3;
    var check;
    var inputs = document.getElementsByTagName("input");
    var textareas = document.getElementsByTagName("textarea");
    var selects = document.getElementsByTagName("select");
    var store = "";
    var arrGridBundle = "";
    var singleGridBundle = "";
	
	try 
	{
        for (x = 0; x < inputs.length; x++) {
            myname = inputs[x].getAttribute("id");
            if (myname == null)
                continue;
            if (!(myname.indexOf("_gridbundle_clubbed") == -1)) {
                singleGridBundle = document.getElementById(myname).value;
                if (arrGridBundle == "")
                    arrGridBundle = singleGridBundle;
                else
                    arrGridBundle += "$$$$" + singleGridBundle;
            }

            if (myname.indexOf(SubCategoryID + "_") == 0) {
                if ((inputs[x].type == 'radio')) {
                    eleName = inputs[x].getAttribute("name");
                    //alert("eleName:"+eleName);
                    if (store != eleName) {
                        store = eleName;
                        var ele = document.getElementsByName(eleName);
                        for (var i = 0; i < ele.length; i++) {

                            eleName2 = ele[i].id;
                            //alert("eleName2:"+eleName2);

                            eleName2 += "#radio";
                            //alert("eleName2:::"+eleName2);
                            NameData += eleName + "#" + eleName2 + "~";
                            //alert("NameData:"+NameData);
                        }
                    }
                } else if (inputs[x].type == 'checkbox') {
                    eleName3 = inputs[x].getAttribute("name");
                    eleName3 += "#checkbox";
                    NameData += myname + "#" + eleName3 + "~";
                } else if (!(inputs[x].type == 'radio')) {
                    eleName2 = inputs[x].getAttribute("name");
                    eleName2 += "#";
                    NameData += myname + "#" + eleName2 + "~";
                }

            }
            //Added by Aishwarya 14thApril2014
            else if (myname.indexOf("tr_") == 0) {
                tr_table = document.getElementById(myname).value;
            } else if (myname.indexOf("WS_LogicalName") == 0) {
                WS_LogicalName = document.getElementById(myname).value;
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < selects.length; x++) {
            eleName2 = selects[x].getAttribute("name");
            if (eleName2 == null)
                continue;
            eleName2 += "#select";
            myname = selects[x].getAttribute("id");
            if (myname == null)
                continue;
            var e = document.getElementById(myname);
            if (e.selectedIndex != -1) {
                var Value = e.options[e.selectedIndex].value;
                if (myname.indexOf(SubCategoryID + "_") == 0) {
                    NameData += myname + "#" + eleName2 + "~";
                }
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	
	try 
	{
        for (x = 0; x < textareas.length; x++) 
		{
            myname = textareas[x].getAttribute("id");
            if (myname == null)
                continue;
            if (myname.indexOf(SubCategoryID + "_") == 0) {
                eleName2 = textareas[x].getAttribute("name");
                eleName2 += "#";
                NameData += myname + "#" + eleName2 + "~";
            }

        }
    } 
	catch (err) 
	{
        return "exception";
    }
	return NameData;
}

function ValidateCommonJsp(NameData)
{
	if(true)
	{
		NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
		//alert("NameData :"+NameData);
		var arr=NameData.split('~');
		for(var i = 0; i < arr.length; i++)
		{
			var temp=arr[i].split('#');
			var id=temp[0];
			var pattern=temp[1];
			var isMandatory=temp[2];
			var labelName=temp[3];
			var isRepeatable=temp[5];
			var type=temp[8];
			//if(isRepeatable!='Y') //changed on 30june14
			//{
				if(isMandatory=='Y')
				{	
					if(!ValidateMandatoryForCommonJsp(id,labelName,type))
					return false;
				}
				/*if(pattern=='Numeric')
				{
					if(!ValidateNumeric(id,labelName,iframeDocument))
					return false;
				}*/
			//}
		}
	}
	return true;
	
}

function ValidateMandatoryForCommonJsp(id,labelName,type)
{
	 // alert("id :"+id);
	 // alert("labelName:"+labelName);
	if(type=='')
	{	
		var value=document.getElementById(id).value;
		if(value=="")
		{
			alert("Please enter "+labelName);
			document.getElementById(id).focus();
			return false;
		}
		else 
			return true;
	}
	else if(type=="select")
	{	
		var element = document.getElementById(id);
		
		var selectedValue = element.options[element.selectedIndex].value;
		
		if(selectedValue=='--Select--')
		{
			alert("Please select "+labelName);
			document.getElementById(id).focus();
			return false;
		}
		else 
			return true;
		
	}
	else if(type=='radio')
	{
		//alert("in radio");
		var ele = document.getElementsByName(id);
		var eleID;
		var flag=0;
		for(var i = 0; i < ele.length; i++)
		{	
			if(ele[i].checked)
			{	
				flag=1;
			}
		}
		if(flag==0)
		{
			alert("Please select "+id.substring(2).replace('_',' ')+".");
			return false;
		}
		else
		 return true;
	
	}
	else if(type=='checkbox')
	{
		if (!document.getElementById(id).checked)
		{
			alert("Please select "+labelName+" checkbox.");
			document.getElementById(id).focus();
			return false;
		}
		else
		 return true;
	}
	else
	{
		alert("No match.");
		return false;
	}
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
		columnListName = document.getElementById(arrColumnList[i]).name;
		arrColumnListName = columnListName.split("#");
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
		
		
		
		strHtml="<input type='gridrow' style='text-align:center;' readonly='readonly' disabled='disabled' id='grid_"+arrColumnList[i]+"_"+gridRowCount+"'  name='grid_"+arrColumnList[i]+"_"+gridRowCount+"' value='"+columnListValue+"'/>";
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
	
		// alert(in_tbl_name);
		// alert(rowindex);
		// alert(document.getElementById(in_tbl_name).rows.length);
		// alert("gridcount :"+document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value);
		
		// alert(columnList);     
		
		var loopStartIndex = parseInt(rowindex);
		var tableLength=parseInt(document.getElementById(in_tbl_name).rows.length);
		
		// alert("loopStartIndex:"+loopStartIndex);
		// alert("tableLength :"+tableLength);
		for (var i=loopStartIndex ; i<tableLength ; i++)
		{
			// alert("loopStartIndex:::::"+loopStartIndex);
			var cols = columnList.split(",");
			
			for(var j=0; j<cols.length ;j++)	
			{
				//alert("Old Id::::"+'grid_'+cols[j]+"_"+loopStartIndex);
				document.getElementById('grid_'+cols[j]+"_"+(i)).id ='grid_'+cols[j]+'_'+(i-1);
				
				
				//document.getElementById(frameName+"_"+SubCategoryID+'_gridselrowindex').value=
				//alert("done");
				//alert("New Id: "+document.getElementById('grid_'+cols[j]+"_"+loopStartIndex).id);
				
			}	
			
			document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_"+(i)).id=frameName+"_"+SubCategoryID+"_gridbundle_"+(i-1);
		
		}
	}else{
		return false;
	}
	
//alert("here");	
	
	document.getElementById(frameName+"_"+SubCategoryID+'_gridselrowindex').value='';
	ClearGridFields(columnList,frameName);
	
	var gridRowCount = document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value;
	gridRowCount=parseInt(gridRowCount)-1;
	document.getElementById(frameName+"_"+SubCategoryID+"_gridrowCount").value = gridRowCount;
	
	
	var gridBundleClubbed = document.getElementById(frameName+"_"+SubCategoryID+"_gridbundle_clubbed").value;
	//alert(gridBundleClubbed);
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
}




function deleteOtherGridRow(columnList,frameName,SubCategoryID, rowindex)
{
	//alert("Inside deleteOtherGridRow");

	columnList = columnList.replace(/\s/g, '');
	var in_tbl_name = frameName+"_GridTable";
	
	document.getElementById(in_tbl_name).deleteRow(rowindex);
	
	//alert("columnList:"+columnList);
		var loopStartIndex = parseInt(rowindex);
		var tableLength=parseInt(document.getElementById(in_tbl_name).rows.length);
		
		for (var i=loopStartIndex ; i<tableLength ; i++)
		{
			var cols = columnList.split(",");
			for(var j=0; j<cols.length ;j++)	
			{
				document.getElementById('grid_'+cols[j]+"_"+(i)).id ='grid_'+cols[j]+'_'+(i-1);
				
				//document.getElementById('grid_'+cols[j]+"_"+(i)).id ='grid_'+cols[j]+'_'+(i-1);
			
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
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	document.getElementById(id).value=value;
}

</script>

<Form>
<BODY topmargin=0 leftmargin=0 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onkeydown="whichButton('onkeydown',event)">
<style>
			@import url("/SRB/webtop/en_us/css/docstyle.css");
</style>


<%!
	WFCustomXmlList objWorkList=null;
	boolean blockCardNoInLogs=true;	
	
	public List getFrameListFromXML(String inputXML) 
	{
		WriteLog("getFrameListFromXML-->");
		WFCustomXmlResponse WFCustomXmlResponseData = new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString(inputXML);
		List frameList = new ArrayList();
		List frameListRecord = null;
		Map<String, String> map = new HashMap<String, String>();
		Set set = new HashSet();
		WFCustomXmlResponse objWFCustomXmlResponse = null;

		String subXML = "";
		String frameorder = "";
		int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		
		WriteLog("recordcount-->"+recordcount);
		
		objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			subXML=objWorkList.getVal("Record");
			
			//WriteLog("subXML-->"+subXML);
			
			frameorder = objWorkList.getVal("Frameorder");
			
			//WriteLog("frameorder Amitabh-->"+frameorder);
			
			//WriteLog("set.contains(frameorder)-->"+set.contains(frameorder));
			
			if (!set.contains(frameorder)) 
			{
				//WriteLog("frameListRecord--> in if loop "+frameListRecord);
				if (frameListRecord != null) 
				{
					frameList.add(frameListRecord);
				}
				frameListRecord = new ArrayList();
			}
			set.add(frameorder);
			
			//WriteLog("After subXML-->"+subXML);
			
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
	WFCustomXmlResponse WFCustomXmlResponseData2=new WFCustomXmlResponse();	
	String firstRecord = "";
	//WriteLog("list.size-=>"+frameList.size());
	for(List<String> recordList: frameList)
	{
		html=html.append(parseRecord(recordList,loadcount,cardDetailList,Workstep,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode));
		
		firstRecord = recordList.get(0);
		
		//WriteLog("firstRecord-=>"+firstRecord);	
		
		WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((firstRecord));
		String IsRepeatable = WFCustomXmlResponseData.getVal("IsRepeatable");
		String IsAddDelReq = WFCustomXmlResponseData.getVal("IsAddDelReq");
		//String isVisibleInGrid = WFCustomXmlResponseData.getVal("isVisibleInGrid");
		
		String frameName  = WFCustomXmlResponseData.getVal("LabelName");
		
		WriteLog("IsRepeatable0-=>"+IsRepeatable);	
		WriteLog("IsAddDelReq0-=>"+IsAddDelReq);
		WriteLog("Workstep-=>"+Workstep);
		WriteLog("sMode-=>"+sMode);
		if(IsRepeatable.equals("Y"))
		{
			//WriteLog("Inside IsRepeatable-=>"+IsRepeatable);	
			if(sMode.equals("R") || (!Workstep.equals("CSO") && !Workstep.equals("TF_Maker") && !Workstep.equals("TF_Document_Approver")))
			{
				//WriteLog("inside disable ");
				strDisable = " disabled=\'disabled\' ";
			}
			
			if(frameName.equals("CREDIT CARD CHEQUE DETAILS") || frameName.equals("BALANCE TRANSFER DETAILS")){
				setVisible = " ";
			}
			else if(CategoryID.equals("1") && (SubCategoryID.equals("3") || SubCategoryID.equals("2") || SubCategoryID.equals("4")) )
			{
				setVisible = " style=visibility:hidden; ";
			}
			
			List<String> columnList = getColumnList(recordList,SubCategoryID);
			FrameColumnListMap.put(frameName,columnList);
			WriteLog("FrameColumnListMap--"+FrameColumnListMap);	
			WriteLog("Inside columnList-=>"+columnList);	
			String varColumnList = columnList.toString().replace("[","").replace("]","");
			WriteLog("Inside varColumnList-=>"+varColumnList);	
			html.append("<table id = 'acc_numsearch' border='1' cellspacing='1' cellpadding='0' width=100% >");
			if(Workstep.equals("CSO"))
			{
				//WriteLog("Inside CSO-=>");	
				//if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
				if(IsAddDelReq.equals("Y"))
				{

					if(CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")) && frameName.equals("AUTHORIZATION DETAILS"))
					{
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='SAVE'  "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					}
					else
					{
						WriteLog("Inside else paint amitabh"+varColumnList);	
						html.append("&nbsp;<input name='"+frameName+"_Add' type='button' id='"+frameName+"_Add' name='"+frameName+"_Add' value='ADD' "+strDisable+" onclick=\"addRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"','"+sMode+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='MODIFY'  "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Delete' type='button' id='"+frameName+"_Delete' name='"+frameName+"_Delete' value='DELETE' "+strDisable+" onclick=\"deleteRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:70px'>");
					}
				}
				else
				{
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
				}				
			}
			else
			{
				//if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
				if(IsAddDelReq.equals("Y"))
				{
				
					
					
					if(CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")) && frameName.equals("AUTHORIZATION DETAILS"))
					{						
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					}else
					{
						html.append("&nbsp;<input name='"+frameName+"_Add' type='button' id='"+frameName+"_Add' name='"+frameName+"_Add' value='ADD'  "+strDisable+" onclick=\"addRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='MODIFY' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
						html.append("&nbsp;<input name='"+frameName+"_Delete' type='button' id='"+frameName+"_Delete' name='"+frameName+"_Delete' value='DELETE' "+strDisable+"  onclick=\"deleteRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:70px'>");						
					}
				}
				else
				{
					//html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='SAVE' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					
					html.append("&nbsp;<input name='"+frameName+"_Add' type='button' id='"+frameName+"_Add' name='"+frameName+"_Add' value='ADD'  "+strDisable+" onclick=\"addRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					html.append("&nbsp;<input name='"+frameName+"_Modify' type='button' id='"+frameName+"_Modify' name='"+frameName+"_Modify' value='MODIFY' "+strDisable+" "+setVisible+" onclick=\"ModifyGridValues('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:65px'>");
					html.append("&nbsp;<input name='"+frameName+"_Delete' type='button' id='"+frameName+"_Delete' name='"+frameName+"_Delete' value='DELETE' "+strDisable+"  onclick=\"deleteRow('"+varColumnList+"','"+frameName+"','"+SubCategoryID+"')\" class='EWButtonRB' style='width:70px'>");	
				}
			}
			
			
			//WriteLog("Inside ModifyGridValues-=>");	
			/* if(CategoryID.equals("1") && !SubCategoryID.equals("3"))
			{
				html.append("&nbsp;<input name='"+frameName+"_Clear' type='button' id='"+frameName+"_Clear' name='"+frameName+"_Clear' value='CLEAR' style='visibility:hidden;' onclick=\"ClearGridFields('"+varColumnList+"','"+frameName+"');\" class='EWButtonRB' style='width:65px'>");
			} */
			
			//WriteLog("Inside ClearGridFields-=>");	
			html.append("<td><input type='hidden' id='"+frameName+"_modifyGridBundle'  name='"+frameName+"_modifyGridBundle' value= ''  /></td>");
			html.append("</table>");
			
			//html.append("</tr></table>");
			
			if(blockCardNoInLogs)
				WriteLog("Inside recordList-=>"+recordList+" and "+cardDetailList);	
				
			List cardDetailListSingleValMap = prepareMultiValMaptoSingleValMap(recordList,cardDetailList);
			//List cardDetailListSingleValMap =cardDetailList;
			
			if(blockCardNoInLogs)
				WriteLog("Inside cardDetailListSingleValMap-=>"+cardDetailListSingleValMap);	
				
			html.append("<div style='border:1px solid black;height:150px;width:100%;overflow-y:scroll;overflow-x:scroll;'>");
			html.append("<table id='"+frameName+"_GridTable' name='"+frameName+"_GridTable' border='1' cellspacing='1' cellpadding='0' width=100% >");
			html.append(prepareGridTH(recordList,frameName,SubCategoryID));
			html.append("<tbody>");
			html.append(prepareGridDataRows(recordList,frameName,cardDetailListSingleValMap,SubCategoryID,FlagValue,sMode, IP, port, cabName, sessionID,Workstep));
			html.append("</tbody>");
			html.append("</table>");
			html.append("</div>");
			
		}
	}
	
	/*if(blockCardNoInLogs)
		WriteLog("html--> "+html.toString());*/
				
	for (Map.Entry entry : FrameColumnListMap.entrySet())
	{
		String fieldName= entry.getKey()+ "_ColumnList";
	
		html.append("<input type=hidden name='"+fieldName+"' id='"+fieldName+"' name='"+fieldName+"' value='"+entry.getValue()+"' style='visibility:hidden' >");
			
	}			
		
	if(CategoryID.equals("1"))
	{
		if(Workstep.equals("CSO"))
		{
			return html.append("<input type=hidden name='PANno' id='PANno' name='PANno' value='"+PANno+"' style='visibility:hidden' >");
		}
		else
		{
			return html.append("<input type=hidden name='PANno' id='PANno' name='PANno' value='"+PANno+"' style='visibility:hidden' ></table><table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' style='display:none'></td></tr><tr/>");
		}
	
	}
	else if(CategoryID.equals("5")||CategoryID.equals("7")||CategoryID.equals("8"))
	{
		if(Workstep.equals("CSO")||Workstep.equals("CM_Introduction"))
		{
			//return html.append("</table>");
			return html;
		}
		else
		{
			//return html.append("<table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' style='display:none' ></td></tr><tr/></table>");
			return html;
		}
	}
	else
	{
	
	
	
		//return html.append("</table>");
		return html;
	}
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
				
			WFCustomXmlResponse WFCustomXmlResponseCheckData=new WFCustomXmlResponse();
			WFCustomXmlResponseCheckData.setXmlString(recordList.get(1));
			WriteLog("Inside recordList "+recordList.get(1));
			
			if(blockCardNoInLogs)
				WriteLog("cardDetailsList "+cardDetailList.get(0));			
				
			String ColumnCheckName = WFCustomXmlResponseCheckData.getVal("ColumnName");
			//WriteLog("Inside ColumnCheckName "+ColumnCheckName);	
			String ColumnCheckValue = mapCheck.get(ColumnCheckName);
			//WriteLog("Inside ColumnCheckValue "+ColumnCheckValue);
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
			WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString(record);
			
			String ColumnName = WFCustomXmlResponseData.getVal("ColumnName");
			String IsRepeatable=WFCustomXmlResponseData.getVal("IsRepeatable");
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
					if(blockCardNoInLogs)
						WriteLog("ColumnName in prepareMultiValMaptoSingleValMap-->"+ColumnName +"-->"+ColumnValue);
					
					arrStrColumnValue = ColumnValue.split("@");
					//if(arrStrColumnValue.length==0){
					ColumnValue = ColumnValue.replace("@"," @ ");
					arrStrColumnValue = ColumnValue.split("@");
					//}
					if(ColumnName.equals("date_and_time"))
					{
						WriteLog("arrStrColumnValue in prepareMultiValMaptoSingleValMap-->"+arrStrColumnValue.length+"#");
					}
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

public String maskCardNo(String cardNo)
{
	cardNo=cardNo.substring(0,6)+"XXXXXX"+cardNo.substring(12,16);
	cardNo=cardNo.substring(0,4)+"-"+cardNo.substring(4,8)+"-"+cardNo.substring(8,12)+"-"+cardNo.substring(12,16);
	
	return cardNo;
}

public StringBuilder prepareGridDataRows(List <String> recordList,String firstRecordLabelName,List<Map> cardDetailList, String SubCategoryID,String FlagValue ,String sMode , String IP,int port,String cabName,String sessionID, String Workstep)
{
	
	WriteLog("Inside prepareGridDataRows-->"+cardDetailList);
	
	if(blockCardNoInLogs)
		WriteLog("Map : ::"+cardDetailList);
		
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
		WFCustomXmlResponse WFCustomXmlResponseData1=new WFCustomXmlResponse();
		WFCustomXmlResponseData1.setXmlString((firstRecord));
		String FristRecordIsRepeatable = WFCustomXmlResponseData1.getVal("IsRepeatable");
		String FristRecordIsAddDelReq = WFCustomXmlResponseData1.getVal("IsAddDelReq");
		WriteLog("FristRecordIsRepeatable"+FristRecordIsRepeatable+"FristRecordIsAddDelReq "+FristRecordIsAddDelReq+"FlagValue "+FlagValue);
		
		String firstGridElement = recordList.get(1);		

		WFCustomXmlResponse WFCustomXmlResponseData2=new WFCustomXmlResponse();
		WFCustomXmlResponseData2.setXmlString((firstGridElement));
		
		String FirstRecordColumnName = WFCustomXmlResponseData2.getVal("ColumnName");
		String FirstRecordColumnValue = map.get(FirstRecordColumnName);



		bundledColumnValue="";		
				
			
			//if((FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) || (FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y")))
			
			if(FristRecordIsRepeatable.equals("Y") && (!FristRecordIsAddDelReq.equals("Y"))) 
			{

				html.append("<tr>");
				if (Workstep.equals("CSO")){
					html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio'  name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
				} else {


					html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio' disabled='disabled' name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
				}
			}	
			else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y"))
			{
				//WriteLog("Inside prepareGridDataRows4 FristRecordIsRepeatable-->"+FristRecordIsRepeatable);
				//WriteLog("Inside prepareGridDataRows4 FristRecordIsAddDelReq-->"+FristRecordIsAddDelReq);
				//WriteLog("Inside prepareGridDataRows4 FirstRecordColumnName-->"+FirstRecordColumnName);
				WriteLog("Inside prepareGridDataRows4 FirstRecordColumnValue-->"+FirstRecordColumnValue);
			
				
				
				if(FirstRecordColumnValue!=null && !FirstRecordColumnValue.equals("$-$") && !FirstRecordColumnValue.equals("") && !FirstRecordColumnValue.equals("null"))
				{
					if (Workstep.equals("CSO"))
					{
						html.append("<tr>");
						html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio' name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
					}
					else
					{
						WriteLog("Inside prepareGridDataRows5-->");
						html.append("<tr>");
						html.append("<td class='EWNormalGreenGeneral1'  style='text-align:center;'  ><input type='radio' disabled='disabled' name='"+firstRecordLabelName+"_Radio' id='"+firstRecordLabelName+"_Radio_"+gridCounter+"' value='"+firstRecordLabelName+"_Radio_"+gridCounter+"'  onclick=\"javascript:populateFormFromRadio('"+varColumnList+"','"+firstRecordLabelName+"','"+firstRecordLabelName+"_"+SubCategoryID+"_"+"gridbundle_"+gridCounter+"',this.parentNode.parentNode.rowIndex,'"+sMode+"')\">&nbsp;"+"</td>");
					}
				}
			}
			//WriteLog("Inside prepareGridDataRows6-->");
			int recordCount=recordList.size();
			int recordCounter = 0 ;
			String radioGroupNameFlagged="";

			for(String record: recordList)
			{
				WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
				WFCustomXmlResponseData.setXmlString(record);
				
				String LabelName = WFCustomXmlResponseData.getVal("LabelName");
				String FieldType = WFCustomXmlResponseData.getVal("FieldType");
				String ColumnName = WFCustomXmlResponseData.getVal("ColumnName");
				String Pattern=WFCustomXmlResponseData.getVal("Pattern");
				String IsMandatory=WFCustomXmlResponseData.getVal("IsMandatory");
				String is_workstep_req=WFCustomXmlResponseData.getVal("is_workstep_req");
				String IsRepeatable=WFCustomXmlResponseData.getVal("IsRepeatable");
				String IsAddDelReq = WFCustomXmlResponseData.getVal("IsAddDelReq");
				String isVisibleInGrid = WFCustomXmlResponseData.getVal("isVisibleInGrid");
				String encryptionRequired = WFCustomXmlResponseData.getVal("EncryptionRequired");
				String radioGroupName = WFCustomXmlResponseData.getVal("RadioGroupName");
					
				//WriteLog("isVisibleInGrid-=>"+isVisibleInGrid);	
				//WriteLog("radioGroupName-=>"+radioGroupName);	
				String displayNone ="";
				if(!isVisibleInGrid.equals("Y") )
				{
					displayNone="style = 'display:none'";
				}
							
				
				if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
					Pattern="blank";
				String nameFormElement = Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"#"+isVisibleInGrid+"#"+IsAddDelReq;
			
				String ColumnValue = map.get(ColumnName);
				
				//WriteLog("--------- ColumnName ------: "+ColumnName);
				if(blockCardNoInLogs)
					WriteLog("--------- ColumnValue ------: "+ColumnValue);
					
				WriteLog("--------- encryptionRequired ------: "+encryptionRequired);
				/*************************************************************
				This part of code is for decrypting the card number stored in database. This code will give exception for the new workitem because at that time we have original value of card numbers not the encrypted ones
				*****************************************************************/
				/*if((SubCategoryID.equals("3")  || SubCategoryID.equals("4") || SubCategoryID.equals("2")) && encryptionRequired.equals("Y"))
				{
					if(ColumnValue==null||ColumnValue.equalsIgnoreCase("null"))
					{
						ColumnValue="";
					}
					else
					{
						String outVal ="";
						try
						{
							String inputXml="<?xml version='1.0'?><APDecryptString_Input><Option>APDecryptString</Option><EngineName>"+cabName +"</EngineName><StringValue>"+ColumnValue+"</StringValue></APDecryptString_Input>";
							
							String outputXml = WFCustomCallBroker.execute(inputXml, IP, port, 1);
							
							if(blockCardNoInLogs)
								WriteLog("Decrypt outputXml -->"+outputXml);
							
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
				}*/
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
					
					if((IsRepeatable.equals("Y") && (!IsAddDelReq.equals("Y"))) || (IsRepeatable.equals("Y") && IsAddDelReq.equals("Y") && FlagValue.equals("Y") && !Workstep.equalsIgnoreCase("CSO")))
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


						WriteLog("ColumnValue check step 0: "+ColumnValue);

							
						html.append("<td nowrap='nowrap' style='text-align:center;'  height='22'"+displayNone+" ><input type='gridrow' style='text-align:center;' readonly='readonly' disabled = 'disabled' id='grid_"+SubCategoryID+"_"+ColumnName+"_"+gridCounter+"' name='grid_"+SubCategoryID+"_"+ColumnName+"_"+gridCounter+"' value='"+ColumnValue+"' /></td>");
						



																
					}
					else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y") && !Workstep.equalsIgnoreCase("CSO"))
					{
						if(!ColumnValue.equals("$-$"))
						{
							if(recordCounter<recordCount-1){
								bundledColumnValue=bundledColumnValue+"~";
							}
							WriteLog("ColumnValue check step 1: "+ColumnValue);
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
			} else if(FristRecordIsRepeatable.equals("Y") && FristRecordIsAddDelReq.equals("Y") && FlagValue.equals("Y") && !Workstep.equalsIgnoreCase("CSO"))
			{
				//WriteLog("firstRecordLabelName-----> "+firstRecordLabelName);
				//WriteLog("FirstRecordColumnName-----> "+FirstRecordColumnName);
				
				//if(blockCardNoInLogs)
					WriteLog("FirstRecordColumnValue check-----> "+FirstRecordColumnValue);
				
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

public List getColumnList(List <String> recordList,String SubCategoryID){

	List<String>columnList =  new ArrayList<String>();
	
	for(String record: recordList)
	{
		WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((record));
		String ColumnName = WFCustomXmlResponseData.getVal("ColumnName");
		String IsRepeatable=WFCustomXmlResponseData.getVal("IsRepeatable");
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
	
		WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((record));
		String LabelName = WFCustomXmlResponseData.getVal("LabelName");
		String FieldType = WFCustomXmlResponseData.getVal("FieldType");
		String IsRepeatable=WFCustomXmlResponseData.getVal("IsRepeatable");
		String isVisibleInGrid = WFCustomXmlResponseData.getVal("isVisibleInGrid");
		
		if(FieldType.equals("R"))
			LabelName = WFCustomXmlResponseData.getVal("RadioGroupName");

					
		WriteLog("isVisibleInGrid-=>"+isVisibleInGrid+"FieldType "+FieldType);	
		String displayNone ="";
		if(!isVisibleInGrid.equals("Y") )
		{
			//WriteLog("Annnnnuuuuuuuuuuuu");
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
	WFCustomXmlResponse objWFCustomXmlResponse=null;
	WFCustomXmlResponse objWFCustomXmlResponse2=null;
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
	//WriteLog("DispColCount----------------------->"+DispColCount);
	//WriteLog("intTwiceDispColCount----------------------->"+intTwiceDispColCount);
	//WriteLog("intWidth----------------------->"+intWidth);
	WriteLog("recordList.length----------------------->"+recordList.size());
	//WriteLog("recordList.contains----------------------->"+recordList.contains("<FieldType>H</FieldType>"));
	//WriteLog("count------------->"+count);
		
	StringBuilder html = new StringBuilder();
	WFCustomXmlResponse WFCustomXmlResponseData2=new WFCustomXmlResponse();
	int recordcount2=0;
	
	Map<String,String> map = new HashMap<String,String> ();
	if(cardDetailList.size()!=0){
		map = (HashMap)cardDetailList.get(0);
	}

		for(String record: recordList)
		{
			subXML = record;
			objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
			WS_NAME = objWFCustomXmlResponse.getVal("WS_Name");
			LabelName = objWFCustomXmlResponse.getVal("LabelName");
				WriteLog("LabelName=="+LabelName);
				//WriteLog("I=="+i);
				//WriteLog("values here");
			if(LabelName.indexOf("SP_")==0)
			{
				is_special=LabelName.substring(0,3);
				LabelName=LabelName.substring(3);
			}
			else
				is_special="";
			FieldType = objWFCustomXmlResponse.getVal("FieldType");
			FieldLength = objWFCustomXmlResponse.getVal("FieldLength");
			ColumnName = objWFCustomXmlResponse.getVal("ColumnName");
			FieldOrder = objWFCustomXmlResponse.getVal("FieldOrder");
			Frameorder = objWFCustomXmlResponse.getVal("Frameorder");
			Editable = objWFCustomXmlResponse.getVal("IsEditable");
			//logical_WS_NAME=objWFCustomXmlResponse.getVal("logical_WS_NAME");
			IsRepeatable=objWFCustomXmlResponse.getVal("IsRepeatable");
			IsAddDelReq=objWFCustomXmlResponse.getVal("IsAddDelReq");
			isVisibleInGrid=objWFCustomXmlResponse.getVal("isVisibleInGrid");
			IsMandatory=objWFCustomXmlResponse.getVal("IsMandatory");
			Pattern=objWFCustomXmlResponse.getVal("Pattern");
			if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
				Pattern="blank";
			
			is_workstep_req=objWFCustomXmlResponse.getVal("is_workstep_req");
			event_function=objWFCustomXmlResponse.getVal("event_function");
			event_function=event_function.replaceAll("~"," ");

				WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
				
				String nameFormElement = Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"#"+isVisibleInGrid+"#"+IsAddDelReq;
				
			WriteLog("Workstep: "+Workstep+"WS_NAME "+WS_NAME+"FieldType "+FieldType+"FieldOrder "+FieldOrder);	
				
			if(Workstep.equals(WS_NAME))
			{	
				//if(FieldType.equals("NULL")&&FieldOrder.equals("1"))//commented by amitabh to handle NULL not checking issue while prepare of service request header on 10/03/2017
				
				//if((FieldType.equals("NULL")||FieldType.equals(""))&&FieldOrder.equals("1"))
				//if(FieldType.equals("NULL")&&FieldOrder.equals("1") && !LabelName.equals("Service Request Type: Fixed Deposit Beneficiary Nomination Form") )
				if(FieldType.equals("NULL")&&FieldOrder.equals("1")) 
				
				{	
					WriteLog("Inside Frame table");
					html.append("<table  id = 'accountdet11' border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><input type='text' name='Header' id='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><b>"+LabelName+"</b></td></tr>");
					i=0;		
				}
				else if(!FieldOrder.equals("1"))
				{
					
					
					if(i!=0)
					{
						if(!FieldType.equals("H")){
							//WriteLog("--i Before=="+i);
						--i;
							//WriteLog("--i after=="+i);
							}
					}
					else
					{ 
						if(!FieldType.equals("H")){
								html.append("<TR>");
						}
						// below condition added to make AccountNumber field disply none for "Fixed Deposit Beneficiary Nomination Form" request
						/*if(!FieldType.equals("H") && WS_NAME.equalsIgnoreCase("CSO") && ColumnName.equalsIgnoreCase("AccountNumber") && CategoryID.equals("4") && SubCategoryID.equals("1")){
							html.append("<TR style='display:none'>");
						}*/
						i=Integer.parseInt(DispColCount)-1;
					}
					if(!FieldType.equals("B") && !FieldType.equals("H") && !FieldType.equals("R"))
					{
						html.append("<td width='"+intWidth+"%' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
					}
					//WriteLog("AMan Error Check=="+sMode);
					//WriteLog("AMan Error Check=="+FieldType);
					//WriteLog("AMan ColumnName=="+ColumnName);
					
					
					if(map.containsKey(ColumnName) && (!IsRepeatable.equals("Y"))){
					
						ColumnValue = map.get(ColumnName).trim();
						//WriteLog("AMan ColumnValue=="+ColumnValue);
					}else{
						//WriteLog("Testo ColumnValue=="+ColumnValue);
						ColumnValue = "";
					}
					readOnlyDisabled="";
					
					//WriteLog("FieldType Amitabh"+FieldType);
					
					if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
					{
						//WriteLog("Heloo");
						//WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
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
										html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+")  maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+">"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"</textarea></td>");
									}
								else{
										html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onblur=trimLength(this.id,this.value,"+FieldLength+")  maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+"></textarea></td>");	
										is_special="";
								  }
								
							}else{
								html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='29' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+")  maxlength = '"+FieldLength+"' "+event_function+readOnlyDisabled+">"+ColumnValue+"</textarea></td>");
							}
						}
						typecheck="TA";	
					} 
					else if(FieldType.equals("T") )
					{
						WriteLog("Amitabh Field Type Is Text:is_special "+is_special);
						if(is_special.equals("SP_"))
							{
								
								WriteLog("map.size() "+map.size());
								WriteLog("map.get(ColumnName) "+map.get(ColumnName));
								
								if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' style='width: 167px' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");			
								else
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' style='width: 167px' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+readOnlyDisabled+"></td>");
								is_special="";
								
							}
							else
							{
								//WriteLog("````````````````````````````````````` :"+ColumnName+"--"+ColumnValue);
								html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' data-toggle='tooltip'  onmousemove='title=this.value' onmouseover='title=this.value' style='width: 167px' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");
							}
						if(typecheck!="R")
						{
							typecheck="T";
							typecheckButR = true;
						}
					}
					
					//Added By Nikita for the dynamic searchable texfield for the two service request start on 09042018
					else if(FieldType.equals("ST"))
					{
						WriteLog("Nikita Field Type Is Text:is_special "+is_special);
						if(is_special.equals("SP_"))
							{
								WriteLog("map.size() "+map.size());
								WriteLog("map.get(ColumnName) "+map.get(ColumnName));
								
								if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
								{
									
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' style='width: 167px'  size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");
								}									
								else
								{
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' style='width: 167px' size = '22'  name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+readOnlyDisabled+"></td>");
								is_special="";
								}
								
							}
							else
							{
								//WriteLog("````````````````````````````````````` :"+ColumnName+"--"+ColumnValue);
								html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' style='width: 167px' size = '22' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");
							}
						if(typecheck!="R")
						{
							typecheck="T";
							typecheckButR = true;
						}
					}
					
					//Added By Nikita for the dynamic searchable texfield for the two service request end on 09042018
					
					 else if(FieldType.equals("C") )
					 {
						if(map.containsKey(ColumnName)&&((String)map.get(ColumnName)).equals("true"))
						{
							html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+" checked  ></td>");
						}else
						{
							html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+nameFormElement+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+"      ></td>");
						}
						typecheck="C";
					}
					
					else if(FieldType.equals("M"))
					{ 	
							//WriteLog("Inside M Type ");
							WriteLog("is_special "+is_special);
							if(is_special.equals("SP_"))
							{	
								WriteLog("In SP_ FieldType="+FieldType+" "+LabelName+" "+is_workstep_req);

								html.append("<td width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1' ><select multiple width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value'  style='width: 167px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
								WFCustomXmlResponseData2.setXmlString((outputData3));
								recordcount2 = Integer.parseInt(WFCustomXmlResponseData2.getVal("TotalRetrieved"));
								mainCodeData2 = WFCustomXmlResponseData2.getVal("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = WFCustomXmlResponseData2.getVal("Record");
										objWFCustomXmlResponse2 = new WFCustomXmlResponse(subXML2);
										comboid = objWFCustomXmlResponse2.getVal("comboid");
										Value = objWFCustomXmlResponse2.getVal("Value");
										Key = objWFCustomXmlResponse2.getVal("AssocVal");
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
									//WriteLog("In amit=");
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1' ><select multiple width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' readonly='readonly' disabled='disabled' "+event_function+" ><option value='--Select--' >--Select--</option>");
									
								}else{
									html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1' ><select multiple width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' "+event_function+" ><option value='--Select--' selected >--Select--</option>");
								}
								
								WriteLog("outputData3 Amitabh="+outputData3);
							
								WFCustomXmlResponseData2.setXmlString(outputData3);
							
								recordcount2 = Integer.parseInt(WFCustomXmlResponseData2.getVal("TotalRetrieved"));
								mainCodeData2 = WFCustomXmlResponseData2.getVal("MainCode");
								
								if(mainCodeData2.equals("0"))
								{
									if(WS_NAME.equals("CSO") || WS_NAME.equals("TF_Maker") || WS_NAME.equals("TF_Document_Approver"))
									{
										objWorkList = WFCustomXmlResponseData2.createList("Records","Record");
										for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
										{ 
											//WriteLog("The for block ");
											//subXML2 = WFCustomXmlResponseData2.getVal("Record");
											//objWFCustomXmlResponse2 = new WFCustomXmlResponse(subXML2);
											comboid = objWorkList.getVal("comboid");
											Value = objWorkList.getVal("Value");
											Key = objWorkList.getVal("AssocVal");
											
											
											//WriteLog("ColumnValue---->"+ColumnValue);
											
											if(Key==null || Key.equals("")){
												Key = Value;
											}
											//WriteLog("LabelName---->"+LabelName+"  comboid  "+comboid);
											//WriteLog("ColumnValue Saved"+ColumnValue);
											//WriteLog("Key Got"+Key);
											
											WriteLog("Index Amitabh"+ColumnValue.indexOf(Key));
											
											if(LabelName.equals(comboid))
											{	if(CategoryID.equals("1")&&SubCategoryID.equals("1"))
												{
													try
													{
														if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1).equals(Value) && (Workstep.equals("Exit") || Workstep.equals("Reject")))
														html.append("<option value='"+Key+"' selected>"+Value+"</option>");
														else
														html.append("<option value='"+Key+"' >"+Value+"</option>");
													}
													catch(Exception e)
													{
													WriteLog("Exception caught checking exit");
													}
												}
												//Added by amitabh to handle multiselect document value
												
											else if(ColumnValue.indexOf(Key)>=0)//Means dropdown is multiselect
												{
														html.append("<option value='"+Key+"' selected>"+Value+"</option>");
												}
												else{
													html.append("<option value='"+Key+"' >"+Value+"</option>");
												}
												/*else if(ColumnValue.equals(Key))
												{
													html.append("<option value='"+Key+"' selected>"+Value+"</option>");
												}
												else
												{
													WriteLog("Exception Inside Else Amitabh" +Key+" Value "+Value);
													html.append("<option value='"+Key+"' >"+Value+"</option>");
												}*/
											}
											
										}
									}
									else
									{
										WriteLog("WS_NAME--"+WS_NAME+"LabelName is--"+LabelName+"recordcount--"+recordcount2);
										recordcount2=0;
									}
								}
								if(mainCodeData2.equals("0") && recordcount2==0)
								{
									WriteLog("Going to populate dropdown values when data not found in combos table");
									//WriteLog("ColumnValue"+ColumnValue);
									if(ColumnValue.length()!=0)
									{
										String[] valueAray=ColumnValue.split("@");
										for(int m=0;m<valueAray.length;m++)
										{
											html.append("<option value='"+valueAray[m]+"' selected>"+valueAray[m]+"</option>");
										}
									}
								}
								html.append("</select></td>");
							}
							typecheck="P";

							//WriteLog("html="+html);
					}
					
					else if(FieldType.equals("P"))
					{ 	
							//WriteLog("Inside P Type ");
							WriteLog("is_special "+is_special);
							if(is_special.equals("SP_"))
							{	

								WriteLog("In SP_ FieldType="+FieldType+" "+LabelName+" "+is_workstep_req);

								html.append("<td width='"+intWidth+"%' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value'  style='width: 167px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
								WFCustomXmlResponseData2.setXmlString((outputData3));
								recordcount2 = Integer.parseInt(WFCustomXmlResponseData2.getVal("TotalRetrieved"));
								mainCodeData2 = WFCustomXmlResponseData2.getVal("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = WFCustomXmlResponseData2.getVal("Record");
										objWFCustomXmlResponse2 = new WFCustomXmlResponse(subXML2);
										comboid = objWFCustomXmlResponse2.getVal("comboid");
										Value = objWFCustomXmlResponse2.getVal("Value");
										Key = objWFCustomXmlResponse2.getVal("AssocVal");
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
									html.append("<td width='"+intWidth+"%'  class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' readonly='readonly' disabled='disabled' "+event_function+" ><option value='--Select--' >--Select--</option>");
									
								}else{
									html.append("<td width='"+intWidth+"%'  class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+nameFormElement+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								}
								
								//WriteLog("outputData34 Amitabh="+outputData3);
								WFCustomXmlResponseData2.setXmlString((outputData3));
								recordcount2 = Integer.parseInt(WFCustomXmlResponseData2.getVal("TotalRetrieved"));
								mainCodeData2 = WFCustomXmlResponseData2.getVal("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									//Loading Islamic / Conventional field from SRBCombos table only on Q23 WS
									//if(LabelName.equals("Islamic / Conventional") && WS_NAME.equals("Q23")) //Q23 is Loan Services Maker Queue
									
									if(WS_NAME.equals("CSO") || WS_NAME.equals("TF_Maker") || WS_NAME.equals("TF_Document_Approver"))
									{
										WriteLog("LabelName is-- "+LabelName+"WS_NAME--"+WS_NAME+"recordcount2-"+recordcount2);								
										objWorkList = WFCustomXmlResponseData2.createList("Records","Record"); 
										for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
										{ 
											//subXML2 = WFCustomXmlResponseData2.getVal("Record");
											//objWFCustomXmlResponse2 = new WFCustomXmlResponse(subXML2);
											comboid = objWorkList.getVal("comboid");
											Value = objWorkList.getVal("Value");
											
											Key = objWorkList.getVal("AssocVal");
											
											
											//WriteLog("ColumnName Key check 3333---->"+ ColumnName+"   "+Key);
											//WriteLog("ColumnName ColumnValue check 3333---->"+ColumnValue+"   "+Key);
											//WriteLog("comboid comboid check 3333---->"+comboid+"   "+Value);
											
											if(Key==null || Key.equals("")){
												Key = Value;
											}
											WriteLog("LabelName---->"+LabelName+"  comboid  "+comboid);
											if(LabelName.equals(comboid))
											{	if(ColumnValue.equals(Key))
												{
													
													html.append("<option value='"+Key+"' selected>"+Value+"</option>");
												}
												else
												{
													html.append("<option value='"+Key+"' >"+Value+"</option>");
												}
											}
											
										}
									}
									else
									{
										WriteLog("WS_NAME--"+WS_NAME+"LabelName is--"+LabelName+"recordcount--"+recordcount2);
										recordcount2=0;
									}
								}
								if(mainCodeData2.equals("0") && recordcount2==0)
								{
									WriteLog("Going to populate dropdown values when data not found in combos table");
									//WriteLog("ColumnValue"+ColumnValue);
									if(ColumnValue.length()!=0)
									html.append("<option value='"+ColumnValue+"' selected>"+ColumnValue+"</option>");
								}
								
								html.append("</select></td>");
							}
							typecheck="P";

							//WriteLog("html="+html);
					}
					else  if(FieldType.equals("D"))
					{

							WriteLog("In FieldType="+FieldType);
							String trial=(String)map.get(ColumnName);
							//WriteLog("trial"+trial);
							if(trial==null)
							trial="";					
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%'  class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
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
										html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
											html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
											html.append("<td  width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
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
											html.append("<img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="D";
								//WriteLog("html="+html);
					}else  if(FieldType.equals("DT"))
					{ 		

							WriteLog("In FieldType="+FieldType);
											
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = ''  "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='' ></a></td>");
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
										html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/CAC/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}
											
									}
												
								}
								else
								{
									WriteLog("Debugger 001");
									if(map.isEmpty())
									{
										WriteLog("Debugger 002");
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/CAC/webtop/images/images/cal.gif'  width='16' height='16' border='0' alt='' ></a></td>");
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
											html.append("<img src='/CAC/webtop/images/images/cal.gif'   width='16' height='16' border='0' alt='' ></a></td>");
											
										}
										else
										{
											WriteLog("Debugger 005 __"+SubCategoryID+"__"+ColumnName);
											
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+nameFormElement+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/CAC/webtop/images/images/cal.gif'  disabled='disabled' width='16' height='16' border='0' alt='' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="DT";
								//WriteLog("html="+html);	
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
						//WriteLog("html="+html);					
					}
					else if(FieldType.equals("B"))
					{
						if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
						{
							html.append("<td colspan='2' width='"+intWidth+"%' >&nbsp;&nbsp;&nbsp;&nbsp;<input name='"+LabelName+"' type='button' value='"+LabelName+"' readonly='readonly' disabled='disabled' class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}else{
							html.append("<td colspan='2' width='"+intWidth+"%' >&nbsp;&nbsp;&nbsp;&nbsp;<input name='"+LabelName+"' type='button' value='"+LabelName+"' class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}	
					} else{
							html.append("<td width='"+intWidth+"%' nowrap='' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
					}
					
					//WriteLog("I before ==0--->"+i);	
					if(i==0)
					{
						//if(!FieldType.equals("H")){
							html.append("</tr>");
						//}
					}
					
				}
			
			}
			//WriteLog("html after appended field--->"+html);	
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
						"<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
						"<td width='"+intWidth+"%'  nowrap='' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"
						);
						typecheck="";
					}
				}	
		}
		//if(!FieldType.equals("H")){
			html.append("</tr>");
		//}
			
			html.append("</table>");
					//WriteLog("html Before Returning from ParseRecord="+html);								
		return html;
}


%>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("load"), 1000, true) );
			String loadcount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: loadcount: "+loadcount);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("panNo"), 1000, true) );
			String PANnoEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: PANnoEsapi: "+PANnoEsapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WS"), 1000, true) );
			String WS = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: WS: "+WS);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FlagValue"), 1000, true) );
			String FlagValue = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: FlagValue: "+FlagValue);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("Integration jsp: WINAME "+WINAME);
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CardNo_Masked"), 1000, true) );
			String CardNo_Masked = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("Integration jsp: CardNo_Masked "+CardNo_Masked);
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ViewMode"), 1000, true) );
			String sModeEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("Integration jsp: ViewMode "+sModeEsapi);
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TEMPWINAME"), 1000, true) );
			String TEMPWINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("Integration jsp: ViewMode "+TEMPWINAME);
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ProductCategory"), 1000, true) );
			String ProductCategoryEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("Integration jsp: ViewMode "+ProductCategoryEsapi);
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ProductType"), 1000, true) );
			String ProductTypeEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("Integration jsp: ViewMode "+ProductTypeEsapi);
			
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("subCategoryCode"), 1000, true) );
			String subCategoryCodeEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			WriteLog("Integration jsp: ViewMode "+subCategoryCodeEsapi);
			
			
			
	//String loadcount = request.getParameter("load");
	if (loadcount != null) {loadcount=loadcount.replace("'","''");}
	String params="";
	WriteLog("loadcount   :   "+loadcount);
	Map <String, String> encryptedCardNumberMap = new HashMap<String, String>();
	
	if (loadcount==null)                                   // need to be changed
		loadcount = "firstLoad";
		
	
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 2809;
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
	WFCustomXmlResponse objWorkListXmlResponse;
	WFCustomXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	Hashtable ht =new  Hashtable();
	String BranchName ="";
	String sProcessName ="";
	
	String branchCode="";
	String islamic="";
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
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlResponse objWFCustomXmlResponse=null;
	WFCustomXmlResponse xmlCardParser=null;
	WFCustomXmlResponse WFCustomXmlResponseData2=null;
	WFCustomXmlResponse WFCustomXmlResponseData3=null;
	String ReturnFields="";
	String sCatname="";
	String subXML="";
	String CategoryID="";
	String SubCategoryID="";
	String transactionTable = "";
	String LogicalName="";
	String DispColCount="";
	String subXML3="";
	WFCustomXmlResponse objWFCustomXmlResponse3=null;
	ArrayList<String> arrList = new ArrayList<String>();
	ArrayList<String> stringList = new ArrayList<String>();
	List<List> frameList = new ArrayList<List>();
	Map<String, String> map = new HashMap<String, String>();
	List <Map> cardDetailList = new ArrayList<Map>();
	//String WS=request.getParameter("WS");
	if (WS != null) {WS=WS.replace("'","''");}
	//String FlagValue=request.getParameter("FlagValue");	
	if (FlagValue != null) {FlagValue=FlagValue.replace("'","''");}
	//String WINAME=request.getParameter("WINAME");
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	//String TEMPWINAME=request.getParameter("TEMPWINAME");
	if (TEMPWINAME != null) {TEMPWINAME=TEMPWINAME.replace("'","''");}
	//String CardNo_Masked = request.getParameter("CardNo_Masked");
	if (CardNo_Masked != null) {CardNo_Masked=CardNo_Masked.replace("'","''");}
	String user=customSession.getUserName();
	String cabName=customSession.getEngineName();
	String sMode=sModeEsapi;
	if (sMode != null) {sMode=sMode.replace("'","''");}
	//String actualSubCatId =request.getParameter("actualSubCatId"); 
	//if (actualSubCatId != null) {actualSubCatId=actualSubCatId.replace("'","''");}
	String CardNumberInitials="";
	String CashBackLimit="";
	
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
			String sCategory=ProductCategoryEsapi.replaceAll("_", " ");
			if (sCategory != null) {sCategory=sCategory.replace("'","''");}
			WriteLog("sCategory : "+sCategory);
			
			String sSubCategory=ProductTypeEsapi.replaceAll("_", " ");
			if (sSubCategory != null) {sSubCategory=sSubCategory.replace("'","''");}
			WriteLog("SubCategory : "+sSubCategory);
			
			String ServiceRequestCode=subCategoryCodeEsapi;
			if (ServiceRequestCode != null) {ServiceRequestCode=ServiceRequestCode.replace("'","''");}
			WriteLog("ServiceRequestCode : "+ServiceRequestCode);
			
			WriteLog("WS : "+WS);
			WriteLog("WINAME : "+WINAME);
			WriteLog("TEMPWINAME :"+TEMPWINAME);
			//WriteLog("SubCategoryID by Nikita----- :"+actualSubCatId);
			//islamic = actualSubCatId+"_IslamicOrConventional";
			//WriteLog("Field value by Nikita----- :"+islamic);
				
			StringBuilder htmlcode=new StringBuilder();
			StringBuilder dynamicQuery=new StringBuilder();
			int recordcount =0;
		
			
			String QueryProcessName = "select FrmLout.Frameorder,FrmLout.WS_NAME Logical_Name,FrmLout.LabelName, FrmLout.FieldType,FrmLout.FieldLength,FrmLout.ColumnName,FrmLout.FieldOrder, rsmap.MW_RESPMAP, rsmap.Req_Category, FrmLout.SubCatIndex, FrmLout.IsEditable, FrmLout.IsMandatory, FrmLout.Pattern, FrmLout.CatIndex, FrmLout.event_function,FrmLout.is_workstep_req,FrmLout.IsRepeatable,FrmLout.isVisibleInGrid,FrmLout.EncryptionRequired,FrmLout.IsAddDelReq,FrmLout.RadioGroupName, svc.Transaction_Table, dynvar.FieldValue, wrkstp.Workstep_Name WS_Name  from usr_0_tf_formlayout FrmLout with (nolock), usr_0_TF_category cat with (nolock), usr_0_TF_subcategory subcat with (nolock), USR_0_TF_INT_RSMAP rsmap with (nolock),  USR_0_TF_SERVICE svc with (nolock),  USR_0_TF_WORKSTEPS wrkstp with (nolock), usr_0_TF_dynamic_variable_master dynvar with (nolock) where cat.CategoryIndex=FrmLout.CatIndex  and subcat.SubCategoryIndex=FrmLout.SubCatIndex  and cat.CategoryIndex=subcat.ParentCategoryIndex and upper(rsmap.FIELDNAME)=:FIELDNAME1  and   cat.CategoryIndex=rsmap.CatIndex  and subcat.SubCategoryIndex=rsmap.SubCatIndex  and cat.CategoryName =:CategoryName  AND   subcat.Application_FormCode=:Application_FormCode  and svc.SubCatIndex=subcat.SubCategoryIndex and FrmLout.IsActive =:IsActive and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex and wrkstp.logical_name = FrmLout.ws_name and wrkstp.Workstep_NAME=:Workstep_NAME and cat.CategoryIndex=dynvar.CatIndex  and subcat.SubCategoryIndex=dynvar.SubCatIndex and dynvar.FieldName=:FieldName2 order by FrmLout.Frameorder,FrmLout.FieldOrder";
			params="CategoryName=="+sCategory.toUpperCase()+"~~Application_FormCode=="+ServiceRequestCode.toUpperCase()+"~~Workstep_NAME=="+WS.toUpperCase()+"~~FIELDNAME1==FETCH"+"~~IsActive==Y"+"~~FieldName2==DISP_COL_COUNT";
			

			inputData = "<?xml version='1.0'?>"+
			"<APSelectWithNamedParam_Input>"+
			"<Option>APSelectWithNamedParam</Option>"+
			"<Query>"+ QueryProcessName + "</Query>"+
			"<Params>"+ params + "</Params>"+
			"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
			"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
			"</APSelectWithNamedParam_Input>";
			
			//WriteLog("Input Xml For Getting Fields Details From Layout And Others Table-->"+inputData);
			
			outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
			//WriteLog("Output Xml For Getting Fields Details From Layout And Others Table-->"+outputData);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString((outputData));
			frameList = getFrameListFromXML(outputData);
			mainCodeData = WFCustomXmlResponseData.getVal("MainCode");
			recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
			String colArray[]=new String[recordcount];
			String colArrayStr = "";
			if(mainCodeData.equals("0"))
			{
					objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
					for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
					{ 	
					
						//for(int k=0; k<recordcount; k++)
						//{	
							subXML = objWorkList.getVal("Record");
							objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
							//colArray[k] = objWFCustomXmlResponse.getVal("ColumnName");
							if(colArrayStr=="")
								colArrayStr = objWFCustomXmlResponse.getVal("ColumnName");
							else 
							{
								colArrayStr = colArrayStr + ","+objWFCustomXmlResponse.getVal("ColumnName");	
							}								
						//}						
					}
					colArray=colArrayStr.split(",");
			
			}
			
			/*for(int k=0; k<recordcount; k++)
			{	
				subXML = WFCustomXmlResponseData.getVal("Record");
				objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
				colArray[k] = objWFCustomXmlResponse.getVal("ColumnName");
				colArrayStr = colArrayStr + ","+colArray[k];
				
			}*/
			
			WriteLog("colArray----->"+colArrayStr);
			int count=0;
			String temp[]=null;
			String temp2[][]=null;
			int t=0;
			if(mainCodeData.equals("0"))
			{	
				subXML = WFCustomXmlResponseData.getVal("Record");
				objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
				ReturnFields = objWFCustomXmlResponse.getVal("MW_RESPMAP");
				sCatname = objWFCustomXmlResponse.getVal("Req_Category");
				CategoryID = objWFCustomXmlResponse.getVal("CatIndex");
				SubCategoryID= objWFCustomXmlResponse.getVal("SubCatIndex");
				transactionTable=objWFCustomXmlResponse.getVal("Transaction_Table");
				LogicalName=objWFCustomXmlResponse.getVal("Logical_Name");
				//WriteLog("ReturnFields"+ReturnFields);
				DispColCount=objWFCustomXmlResponse.getVal("FieldValue");
				if(!ReturnFields.equals("*"))
				{
					temp= ReturnFields.split(",");
					count=temp.length;
					String check[]=null;
					temp2=new String[count][2]; 
					for(int k=0;k<count;k++)
					{
						//WriteLog("temp"+temp[k]);
						check=temp[k].split("#");
						temp2[k][0]=check[0];
						temp2[k][1]=check[1];
						
					}
				}
			}	
			
			
				String qry = "select comboid,Value, [KEY] as AssocVal from USR_0_TF_Combos cmb with (nolock),usr_0_tf_category cat with (nolock),usr_0_tf_subcategory subcat with (nolock), USR_0_tf_WORKSTEPS wrkstp with (nolock),usr_0_tf_Service svc with (nolock) where cat.CategoryIndex=cmb.CatIndex and subcat.SubCategoryIndex=cmb.SubCatIndex and upper(cat.CategoryName) =:CategoryName AND upper(subcat.Application_FormCode)=:Application_FormCode and subcat.parentcategoryindex=cat.CategoryIndex and cmb.IsActive =:IsActive and upper(wrkstp.Workstep_Name)=:Workstep_Name and cmb.Ws_Name = wrkstp.Logical_Name and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex";
				
				//WriteLog("Query is "+qry);
			
				params="CategoryName=="+sCategory.toUpperCase()+"~~Application_FormCode=="+ServiceRequestCode.toUpperCase()+"~~Workstep_Name=="+WS.toUpperCase()+"~~IsActive==Y";
				//WriteLog("Params in BPMCommon Block is "+params);
				inputData3 = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				//WriteLog("inputData3-->"+inputData3);
				
				outputData3 = WFCustomCallBroker.execute(inputData3, customSession.getJtsIp(), customSession.getJtsPort(), 1);
				//WriteLog("outputData3-->"+outputData3);
				WFCustomXmlResponseData.setXmlString((outputData3));
				mainCodeData3 = WFCustomXmlResponseData.getVal("MainCode");
				if(mainCodeData3.equals("0"))
				{
					WriteLog("Test mainCodeData3 "+mainCodeData3);
				}
		
			String sMappOutPutXML="";
			if(WS.equals("CSO")&&FlagValue.equals("N"))	
			{	
								
				PANno=PANnoEsapi;
				if (PANno != null) {PANno=PANno.replace("'","''");}
				if(!(PANno==null))
				{
					PANno=PANno.replace("ENCODEDPLUS","+");
					
					if(blockCardNoInLogs)
						WriteLog("Plus removed PANno:"+PANno);
					
					//WriteLog("sCatname----->"+sCatname);
					
					try
					{
						sCabname=customSession.getEngineName();
						sSessionId = customSession.getDMSSessionId();
						sJtsIp = customSession.getJtsIp();
						iJtsPort = customSession.getJtsPort();
						//WriteLog("sumit is : "+sCabname+" sSessionId is:  "+sSessionId+" sJtsIp: "+iJtsPort);
					}
					catch(Exception ex){
						WriteLog(ex.getMessage().toString());
					}	
					String	sInputXML =	"<?xml version=\"1.0\"?>\n" +
							"<APAPMQPutGetMessage>\n" +
							"<Option>SRM_APMQPutGetMessage</Option>\n" +
							"<UserID>"+customSession.getUserName()+"</UserID>\n" +
							"<CategoryID>"+CategoryID+"</CategoryID>\n" +
							"<SubCategoryID>"+SubCategoryID+"</SubCategoryID>\n" +
							"<CardNumber>"+PANno+"</CardNumber>\n"+ 
							"<SessionId>"+sSessionId+"</SessionId>\n"+
							"<EngineName>"+sCabname+"</EngineName>\n" +
							"<RequestType>"+sCatname+"</RequestType>\n" +
							"</APAPMQPutGetMessage>\n";
					
					String FormValue="";
					/*if(blockCardNoInLogs)
						WriteLog("sInputXML  "+sInputXML);*/
					try
					{
						
						//sMappOutPutXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						
						/*if(CategoryID.equals("1")&&SubCategoryID.equals("1"))
						{
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>5546370220955089</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>10000</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>NORM</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><CustomerName>ACCOUNT NAME FOR    &amp;  0409013XXXXX</CustomerName><MobileNo>8376909658</MobileNo></CardDetails></EE_EAI_MESSAGE>";
						
						
						}
						
						else  if(CategoryID.equals("1")&&SubCategoryID.equals("3"))

						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955089</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955999</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>STLC</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>STLC</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370220955099</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955099</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate>< >0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>VISA</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>1234567</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>7533370120967890</card_number><crn>34433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Primary</card_holder_type2><card_type>VISA</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370224441111</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>ATMR</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>5546370120967890</card_number><crn>45433443</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>5546370333355098</card_number><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955098</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>15-06-2014</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>MASTER</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><card_holder_name>Sumit Kumar</card_holder_name><card_holder_type>Primary</card_holder_type><cif>347326</cif><mobile_number>9564832543</mobile_number><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><card_number>4576370120967890</card_number><crn>64334643</crn><card_holder_name2>Sumit Kumar</card_holder_name2><card_expiry_date>15-06-2014</card_expiry_date><card_holder_type2>Supplementary</card_holder_type2><card_type>MASTER</card_type><card_status>ATMR</card_status><available_balance></available_balance></CardDetails></EE_EAI_MESSAGE>";

						else  if(CategoryID.equals("1")&&(SubCategoryID.equals("2") ||SubCategoryID.equals("10")))
							
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>2015-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER>	<CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>1111111111111111</card_number><encrypted_cardno>lxPPRz8luaKvM9n/3Nhnk+UWOr+FXaVTM65XGN6fkRA=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>Sumit Kumar1</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2018-01-01</expiry><overdue_amt>987654</overdue_amt><salary>30000000</salary><available_balance></available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORI</card_status><agent_network_id>aishwarya</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><mobile_number>99999999999</mobile_number><source></source></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>2222222222222222</card_number><encrypted_cardno>gBXFWekP1NQxhiydxjgk/nJ/5M4ZX1A36LTfRtylRkU=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>Sumit Kumar2</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Secondary</cardholder_type><product>88888888</product><expiry>2018-01-01</expiry><overdue_amt>987654AASDDDSAAWDFDSS</overdue_amt><salary>4999Assdeqeewdwwwdwddeq</salary><available_balance></available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Secondary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><c_crn_no>1234</c_crn_no><mobile_number>99999999999</mobile_number><source></source></CardDetails>						<CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>3333333333333333</card_number><encrypted_cardno>VgsxQEdvTwa0mJye2bz1g0uLd4N+Wepk2uwkkYMMciw=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>Sumit Kumar2</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2018-01-01</expiry><overdue_amt>987654</overdue_amt><salary>4999</salary><available_balance></available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><c_crn_no>1234</c_crn_no><mobile_number>99999999999</mobile_number><source></source></CardDetails>						<CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>4444444444444444</card_number><encrypted_cardno>f8zxEDd3nE8FslWsYHKMZxst6lpt3PD5jX3qZfsNoM4=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>Sumit Kumar2</card_holder_name><card_type>PERMANENT</card_type><cardholder_type>Primary</cardholder_type><product>88888888</product><expiry>2018-01-01</expiry><overdue_amt>987654</overdue_amt><salary>4999</salary><available_balance></available_balance><card_eligibility></card_eligibility><eligible_amount>5000000</eligible_amount><non_eligibility_reasons></non_eligibility_reasons><card_status>NORM</card_status><agent_network_id>5000000</agent_network_id><card_holder_type>Primary</card_holder_type><cif>547568758</cif><crn_no>5000000</crn_no><customer_name>ANONYMOUS</customer_name><c_crn_no>1234</c_crn_no><mobile_number>99999999999</mobile_number><source></source></CardDetails></EE_EAI_MESSAGE>";	

						else  if(CategoryID.equals("1")&&SubCategoryID.equals("4"))
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>1111111111111111</card_number><c_crn_no>1234</c_crn_no><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>aishwarya</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>1111111111111111</card_no><encrypted_cardno>lxPPRz8luaKvM9n/3Nhnk+UWOr+FXaVTM65XGN6fkRA=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>100</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>989999999</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>2222222222222222</card_no><encrypted_cardno>gBXFWekP1NQxhiydxjgk/nJ/5M4ZX1A36LTfRtylRkU=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORR</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>3333333333333333</card_no><encrypted_cardno>VgsxQEdvTwa0mJye2bz1g0uLd4N+Wepk2uwkkYMMciw=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NEWR</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>99</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>4444444444444444</card_no><encrypted_cardno>f8zxEDd3nE8FslWsYHKMZxst6lpt3PD5jX3qZfsNoM4=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><c_crn_no>1234</c_crn_no><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>5555555555555555</card_no><encrypted_cardno>5S8s5thV8KMuR+4wVZiMiPWeYHQKtaO2Ra+YPHS55RU=</encrypted_cardno><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORI</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details>						<Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>4545454545454545</card_no><encrypted_cardno>xXKIf8CtFDMElIn3HrhEqB87NJ8OSznXZWkYLV4zxS8=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details>						<Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>5454545454545454</card_no><encrypted_cardno>lhtklB0bPQirBZNBh60tYP/nj0uAVGSrz3HWxc+zJu4=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details></EE_EAI_MESSAGE>";						
						
						else  if(CategoryID.equals("1")&&SubCategoryID.equals("10"))
						sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>1111111111111111</card_number><c_crn_no>1234</c_crn_no><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>aishwarya</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>1111111111111111</card_no><encrypted_cardno>lxPPRz8luaKvM9n/3Nhnk+UWOr+FXaVTM65XGN6fkRA=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>100</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>989999999</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>2222222222222222</card_no><encrypted_cardno>gBXFWekP1NQxhiydxjgk/nJ/5M4ZX1A36LTfRtylRkU=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORR</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>3333333333333333</card_no><encrypted_cardno>VgsxQEdvTwa0mJye2bz1g0uLd4N+Wepk2uwkkYMMciw=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Supplementary</card_holder_type2><card_status>NEWR</card_status><product>FKJHGKRJH</product><expiry>2015-01-01</expiry><overdue_amt>99</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>4444444444444444</card_no><encrypted_cardno>f8zxEDd3nE8FslWsYHKMZxst6lpt3PD5jX3qZfsNoM4=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details><Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><c_crn_no>1234</c_crn_no><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>5555555555555555</card_no><encrypted_cardno>5S8s5thV8KMuR+4wVZiMiPWeYHQKtaO2Ra+YPHS55RU=</encrypted_cardno><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORI</card_status><product>FKJHGKRJH</product><expiry>1900-01-01</expiry><overdue_amt>101</overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details>						<Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>4545454545454545</card_no><encrypted_cardno>xXKIf8CtFDMElIn3HrhEqB87NJ8OSznXZWkYLV4zxS8=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details>						<Customer Details><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>88888888</card_number><customer_name>ZZZZZZZZZ</customer_name><cif>767575676</cif><mobile_number>999999999</mobile_number><card_holder_type>PERMANENT</card_holder_type><agent_network_id>6567465</agent_network_id><crn_no>65767657</crn_no><sales_agent_id>576577876</sales_agent_id><source_code></source_code><card_no>5454545454545454</card_no><encrypted_cardno>lhtklB0bPQirBZNBh60tYP/nj0uAVGSrz3HWxc+zJu4=</encrypted_cardno><c_crn_no>1234</c_crn_no><card_holder_name>MAGGRLFGJ</card_holder_name><card_type>MASTER</card_type><card_holder_type2>Primary</card_holder_type2><card_status>NORM</card_status><product>FKJHGKRJH</product><expiry>2019-01-01</expiry><overdue_amt></overdue_amt><salary>7777777</salary><available_balance></available_balance><Purpose></Purpose></Customer Details></EE_EAI_MESSAGE>";						
						*/
						
						if(blockCardNoInLogs)
							WriteLog("sMappOutPutXML zzz : "+sMappOutPutXML);
						
					}
					catch(Exception exp){
						//bError=true;
					}
					
					
					if(blockCardNoInLogs)
						//WriteLog("sMappOutPutXML is : "+sMappOutPutXML);
						
					WFCustomXmlResponseData.setXmlString((sMappOutPutXML));
					WFCustomXmlResponse validateFetchResponse = new WFCustomXmlResponse(sMappOutPutXML);
					String validReturnCode = validateFetchResponse.getVal("ReturnCode");
					String validReasonCode = validateFetchResponse.getVal("ReasonCode");
					WriteLog("ReasonCode is : "+validReasonCode);
					WriteLog("ReturnCode is : "+validReturnCode);
					if("-1".equals(validReasonCode))
					{
						out.println("<script>");
						out.println("alert('Please check the card number entered.')");
						out.println("</script>");
					}
					else if("Debit".equals(validReturnCode))
					{
						out.println("<script>");
						out.println("alert('Only Credit Card is allowed for this request.')");
						out.println("</script>");
					}
					else if(!"0000".equals(validReturnCode))
					{
						/*out.println("<script>");
						out.println("alert('Unable to fetch card details. Please contact administrator.')");
						out.println("</script>");*/
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
					/*if(CategoryID.equals("1") && (SubCategoryID.equals("4")  || SubCategoryID.equals("2")))
					{
						String repeatTag = "CardDetails"; //value expected at onshore
						String strCardNoTag="CardNumber"; //value expected at onshore
						
						String mwResponse=sMappOutPutXML;
						xmlCardParser = new WFCustomXmlResponse();
						//WriteLog("Before  map creation  : ");
						while (mwResponse.indexOf("<"+repeatTag+">")>-1)
						{
							xmlCardParser.setXmlString(mwResponse);
							String cardNo = xmlCardParser.getVal(strCardNoTag);
							String encrytpedString = xmlCardParser.getVal("encrypted_cardno");
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
					}*/

					int counter=10;;	
					for(int l=0; l<counter; l++)
					{
							//map.clear();
							subXML3 = WFCustomXmlResponseData.getVal(strTagName);
							map= new HashMap<String,String>();
						for(int i=0;i<count;i++)
						{	
							//subXML3 = WFCustomXmlResponseData.getVal(strTagName);
							objWFCustomXmlResponse3 = new WFCustomXmlResponse(subXML3);
							
							if(temp2[i][1].indexOf("~")>-1)
							{
								String QR="";
								String str=objWFCustomXmlResponse3.getVal(temp2[i][0]);
								WriteLog("ResponseValue str= "+str);	
								/*String QR="select FormValue from USR_0_SRM_CARDS_DECODE where ResponseTag ='"+temp2[i][0]+"' and ResponseValue='"+str+"' and IsActive='Y'";





								inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
								

								//String QR="select FormValue from USR_0_SRM_CARDS_DECODE with (nolock) where ResponseTag =:ResponseTag and ResponseValue=:ResponseValue and IsActive=:IsActive";
								


								if("".equals(str))
									str=temp2[i][0];
								params="ResponseTag=="+temp2[i][0]+"~~ResponseValue=="+str+"~~IsActive==Y";
								
								inputData2 = "<?xml version='1.0'?>"+
									"<APSelectWithNamedParam_Input>"+
									"<Option>APSelectWithNamedParam</Option>"+
									"<Query>"+ QR + "</Query>"+
									"<Params>"+ params + "</Params>"+
									"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
									"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
									"</APSelectWithNamedParam_Input>";
							
								WriteLog("inputData2-->"+inputData2);
								
								outputData2 = WFCustomCallBroker.execute(inputData2, customSession.getJtsIp(), customSession.getJtsPort(), 1);
								WriteLog("outputData2-->"+outputData2);
								WFCustomXmlResponseData2=new WFCustomXmlResponse();
								WFCustomXmlResponseData2.setXmlString((outputData2));
								mainCodeData = WFCustomXmlResponseData2.getVal("MainCode");
								if(mainCodeData.equals("0"))
								{
									FormValue = WFCustomXmlResponseData2.getVal("FormValue");
									if(FormValue.indexOf("$")>-1)
									{	FormValue=FormValue.substring(FormValue.indexOf("$")+1);
										
										WriteLog("FormValue after function call-->"+FormValue);
									}
									map.put(temp2[i][1].replaceAll("~",""),FormValue);		
								}
								
								if(blockCardNoInLogs)
									WriteLog("map INSIDE IF-->"+map.toString());
							}	
							else
							{
								map.put(temp2[i][1],objWFCustomXmlResponse3.getVal(temp2[i][0]));
								
							}
							
							if(blockCardNoInLogs)
								WriteLog("map INSIDE ELSE-->"+map.toString());
						}
						/*if(blockCardNoInLogs)
							WriteLog("map----------------->"+map.toString());*/
						cardDetailList.add(map);
					}
					
						if(blockCardNoInLogs)
						{
							//WriteLog("cardDetailList-->"+cardDetailList.toString());
							//WriteLog("cardDetailList First Element-->"+cardDetailList.get(0).toString());
						}
				}
			}
			else
			{	
				String val1="";
				String val2="";
			
				/*String QR_colnames="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+transactionTable+"' AND TABLE_SCHEMA='dbo'";
				inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR_colnames + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
				

				String QR_colnames="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS with (nolock) WHERE TABLE_NAME = :TABLE_NAME AND TABLE_SCHEMA=:TABLE_SCHEMA";
				params = "TABLE_NAME=="+transactionTable+"~~TABLE_SCHEMA==dbo";
				
				inputData2 = "<?xml version='1.0'?>"+
					"<APSelectWithNamedParam_Input>"+
					"<Option>APSelectWithNamedParam</Option>"+
					"<Query>"+ QR_colnames + "</Query>"+
					"<Params>"+ params + "</Params>"+
					"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
					"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
					"</APSelectWithNamedParam_Input>";
		
				
				
				outputData2 = WFCustomCallBroker.execute(inputData2, customSession.getJtsIp(), customSession.getJtsPort(), 1);
				WriteLog("inputData2QR_colnames -->"+inputData2);
				
				WriteLog("outputData2QR_colnames -->"+outputData2);
				
				WFCustomXmlResponseData.setXmlString((outputData2));
				mainCodeData = WFCustomXmlResponseData.getVal("MainCode");
				int recCount= Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
				//String tr_table_cols[]=new String[recCount];
				String tr_table_colsString="";
				if(mainCodeData.equals("0"))
				{	
				
					objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
					for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
						{ 
						
						    if(tr_table_colsString=="")
							tr_table_colsString=objWorkList.getVal("COLUMN_NAME");
							else
							tr_table_colsString=tr_table_colsString+","+objWorkList.getVal("COLUMN_NAME");
						}
				}
				WriteLog("tr_table_colsString -->"+tr_table_colsString);
				String tr_table_cols[]=tr_table_colsString.split(",");
				String Query="select";
				for(int r=0;r<tr_table_cols.length;r++)
				{
					Query+=" "+tr_table_cols[r]+",";
				}
				Query=Query.substring(0,(Query.lastIndexOf(",")));
				
				/*Query+=" from "+transactionTable+" where WI_NAME ='"+WINAME+"' OR TEMP_WI_NAME ='"+TEMPWINAME+"'";


				inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
				
				//Query+=" from "+transactionTable+" where WI_NAME =:WI_NAME OR TEMP_WI_NAME =:TEMP_WI_NAME";
				Query+=" from "+transactionTable+" where WI_NAME =:WI_NAME";
				//params = "WI_NAME=="+WINAME+"~~TEMP_WI_NAME=="+TEMPWINAME;
				
				params = "WI_NAME=="+WINAME;
				
				inputData2 = "<?xml version='1.0'?>"+
					"<APSelectWithNamedParam_Input>"+
					"<Option>APSelectWithNamedParam</Option>"+
					"<Query>"+ Query + "</Query>"+
					"<Params>"+ params + "</Params>"+
					"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
					"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
					"</APSelectWithNamedParam_Input>";
				
				WriteLog("Input XML For Getting Column Values For Transaction Table-->"+inputData2);
				
				outputData2 = WFCustomCallBroker.execute(inputData2, customSession.getJtsIp(), customSession.getJtsPort(), 1);
				WriteLog("Output XML For Getting Column Values For Transaction Table-->"+outputData2);				
				outputData2=outputData2.replaceAll("NULL","");
				WriteLog("Output XML For Getting Column Values For Transaction Table aftr replace-->"+outputData2);
				WFCustomXmlResponseData.setXmlString((outputData2));
				mainCodeData = WFCustomXmlResponseData.getVal("MainCode");
				/*if((CategoryID.equals("1")))
					PANno = Decrypt(WFCustomXmlResponseData.getVal("KEYID"));
				else*/
					PANno = WFCustomXmlResponseData.getVal("KEYID");
				
				if(mainCodeData.equals("0"))
				{	
					WriteLog("recordcount in amitabh"+recordcount);
					try
					{
						for(int i=0;i<recordcount;i++)
						{
							//WriteLog("check test");
							try
							{
								//WriteLog("check before: "+colArray[i]);
								WriteLog("inside loop in amitabh"+WFCustomXmlResponseData.getVal(colArray[i]));
								//WriteLog("check after: "+colArray[i]);
								if(!WFCustomXmlResponseData.getVal(colArray[i]).equals(""))
								{	
								
									WriteLog("Values Before Decode-->"+WFCustomXmlResponseData.getVal(colArray[i]));
								
									String val="";
									try
									{
										val=URLDecoder.decode(WFCustomXmlResponseData.getVal(colArray[i]), "UTF-8");
									}
									catch (Exception ex) 
									{             
										//ex.printStackTrace();  
										StringWriter errors = new StringWriter();
										ex.printStackTrace(new PrintWriter(errors));
										WriteLog("Values Exception-->"+errors.toString());
										//return errors.toString();								
									} 
																
									map.put(colArray[i],val);
									val1=colArray[i];
									val2=WFCustomXmlResponseData.getVal(colArray[i]);
									WriteLog("Values-->"+val1+" & "+val);
								}
							}
							catch (Exception ex) 
							{
								WriteLog("Check 111: "+ex.getMessage().toString());
							}
						}
					}
					catch (Exception ex) 
					{
						WriteLog("Check 112: "+ex.getMessage().toString());
					}
					WriteLog("hgfhedjfjhsjhat 880");
					
						cardDetailList.add(map);
					
				}					

			}
			
			if(blockCardNoInLogs)
				WriteLog("PAN NO at 880"+PANno);
			
		
			
			//WriteLog("frameList=" +frameList.toString());
			
			if(blockCardNoInLogs)
				WriteLog("cardDetailList Maps-------->"+cardDetailList);
					
				htmlcode=getDynamicHtml_FrameWise(frameList,loadcount,cardDetailList,WS,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode,FlagValue,customSession.getJtsIp(), customSession.getJtsPort(),customSession.getEngineName(), customSession.getDMSSessionId());
			
			if(blockCardNoInLogs)
				WriteLog("htmlcode final-->"+htmlcode.toString());
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
			//out.println("<input type='hidden' name='iFrameOutputXML' id='iFrameOutputXML' value='"+outputData+"'/>");
			
			if(WS.equals("CSO") || WS.equals("PBR"))
			out.println("<input type='hidden' name='CardNo_Masked' id='CardNo_Masked' value='"+CardNo_Masked+"'/>");
			
			//Code added by Aishwarya for mandatory documents check
			/*String docquery = "select doctype from usr_0_srm_document doc, usr_0_srm_worksteps ws, usr_0_srb_category cat, usr_0_srb_subcategory scat, usr_0_srm_service srv where upper(cat.categoryName) = '"+sCategory.toUpperCase()+"' and upper(scat.subcategoryName) = '"+sSubCategory.toUpperCase()+"' and srv.catindex = cat.categoryindex and srv.subcatindex = scat.subcategoryindex and srv.sr_id = doc.sr_id and srv.sr_id = ws.sr_id and upper(ws.workstep_name) = '"+WS.toUpperCase()+"' and doc.workstep = ws.logical_name";


			
			String inputxmldoc = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + docquery + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
			
			//String docquery = "select doctype from usr_0_srB_document doc, usr_0_srb_worksteps ws, usr_0_srb_category cat, usr_0_srb_subcategory scat, usr_0_srb_service srv where upper(cat.categoryName) = :categoryName and upper(scat.subcategoryName) = :subcategoryName and srv.catindex = cat.categoryindex and srv.subcatindex = scat.subcategoryindex and srv.sr_id = doc.sr_id and srv.sr_id = ws.sr_id and upper(ws.workstep_name) = :workstep_name and doc.workstep = ws.logical_name";
			
			String docquery="select doctype from USR_0_TF_DOCUMENT doc,USR_0_TF_WORKSTEPS ws,USR_0_TF_SUBCATEGORY scat where upper(ws.workstep_name) = :workstep_name and doc.workstep = ws.Workstep_Name and doc.IsMandatory=:IsMandatory and upper(scat.Application_FormCode) =:Application_FormCode and scat.Application_FormCode=doc.SR_ID";
			
			WriteLog("workstep_name-->"+WS.toUpperCase());
			params = "workstep_name=="+WS.toUpperCase()+"~~Application_FormCode=="+ServiceRequestCode.toUpperCase()+"~~IsMandatory==Y";

			String inputxmldoc = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ docquery + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
			WriteLog("inputxmldoc -->"+inputxmldoc);	
			
			String outputxmldoc = WFCustomCallBroker.execute(inputxmldoc, customSession.getJtsIp(), customSession.getJtsPort(), 1);
			WriteLog("outputxmldoc -->"+outputxmldoc);
			WFCustomXmlResponseData.setXmlString(outputxmldoc);
			String mainCodeDoc = WFCustomXmlResponseData.getVal("MainCode");
			int noOfDoc= Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
			String requiredDocs = "";
			if(mainCodeDoc.equals("0"))
			{	
				if(noOfDoc>0)
				{
					objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
					for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
					{ 
						requiredDocs+=objWorkList.getVal("doctype")+",";
						
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
		catch(Exception e){WriteLog("Exception in BPMCommonBlocks");e.printStackTrace();}
	}
	
	
	
	
%>

</BODY>
</Form>
</HTML>