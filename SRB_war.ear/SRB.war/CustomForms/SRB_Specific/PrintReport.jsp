<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAK Bank 
//Module                     : Request-Screen Form Painitng
//File Name					 : RejectReasons.jsp          
//Author                     : Mandeep Singh
// Date written (DD/MM/YYYY) : 27-Jan-2016
//Description                : Reject Reasons
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>


<%@ include file="../SRB_Specific/Log.process"%>

<script language="javascript" src="/SRB/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/SRB/webtop/scripts/jquery.autocomplete.js"></script>
<script src="/SRB/webtop/scripts/jquery.min.js"></script>
<script src="/SRB/webtop/scripts/bootstrap.min.js"></script>
<script src="/SRB/webtop/scripts/jquery-ui.js"></script> 



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<HTML>
<f:view>
<HEAD>
<link rel="stylesheet" href="..\..\webtop\scripts\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<style>
	@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>

<TITLE> RAKBANK-Service Request Module</TITLE>
	<%
try
	{		
	/*
			String WINAME = request.getParameter("wi_name");
			String WSNAME=request.getParameter("workstepcode");
			String username= request.getParameter("USERNAME");
			String solid=request.getParameter("SOLID");
			String Category = request.getParameter("CATEGORY");
			String TEMPWINAME = request.getParameter("TEMPWINAME");
			String frmData = request.getParameter("frmData");
			String subCategoryCode = request.getParameter("subCategoryCode");
			String CifId = request.getParameter("CifIdnumber");
			String Name = request.getParameter("Name");
			String SubSegment = request.getParameter("SubSegment");
			String ARMCode = request.getParameter("ARMCode");
			String RAKElite = request.getParameter("RAKElite");
			String Channel = request.getParameter("Channel");
			String EmiratesIDHeader = request.getParameter("EmiratesIDHeader");
			String EmratesIDExpDate = request.getParameter("EmratesIDExpDate");
			String TLIDHeader = request.getParameter("TLIDHeader");
			String TLIDExpDate = request.getParameter("TLIDExpDate");
			String PrimaryEmailId = request.getParameter("PrimaryEmailId");
			String ApplicationDate = request.getParameter("ApplicationDate");
			String cat_Subcat = request.getParameter("Subcat");
			String workstepName = request.getParameter("workstepName");
			String modeofdelivery = request.getParameter("modeofdelivery");
			String doccollectionbranch = request.getParameter("doccollectionbranch");
			String branchDeliveryMethod = request.getParameter("branchDeliveryMethod");
			String CourierAWBNumber = request.getParameter("CourierAWBNumber");
			String CourierCompName = request.getParameter("CourierCompName");
			String Decision = request.getParameter("Decision");
		*/
			
			//String WINAME = request.getParameter("wi_name");
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );    
			String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			//String WSNAME=request.getParameter("workstepcode");
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepcode"), 1000, true) );    
			String WSNAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			//String username= request.getParameter("USERNAME");
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("USERNAME"), 1000, true) );    
			String username = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			//String solid=request.getParameter("SOLID");
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SOLID"), 1000, true) );    
			String solid = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			//String Category = request.getParameter("CATEGORY");
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CATEGORY"), 1000, true) );    
			String Category = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			//String TEMPWINAME = request.getParameter("TEMPWINAME");
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TEMPWINAME"), 1000, true) );    
			String TEMPWINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			//String frmData = request.getParameter("frmData");
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("frmData"), 1000, true) );    
			String frmData = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			//String subCategoryCode = request.getParameter("subCategoryCode");
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("subCategoryCode"), 1000, true) );    
			String subCategoryCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			//String CifId = request.getParameter("CifIdnumber");
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CifIdnumber"), 1000, true) );    
			String CifId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			//String Name = request.getParameter("Name");
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Name"), 1000, true) );    
			String Name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			//String SubSegment = request.getParameter("SubSegment");
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubSegment"), 1000, true) );    
			String SubSegment = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			//String ARMCode = request.getParameter("ARMCode");
			String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ARMCode"), 1000, true) );    
			String ARMCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			//String RAKElite = request.getParameter("RAKElite");
			String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RAKElite"), 1000, true) );    
			String RAKElite = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			//String Channel = request.getParameter("Channel");
			String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Channel"), 1000, true) );    
			String Channel = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			//String EmiratesIDHeader = request.getParameter("EmiratesIDHeader");
			String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("EmiratesIDHeader"), 1000, true) );    
			String EmiratesIDHeader = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			//String EmratesIDExpDate = request.getParameter("EmratesIDExpDate");
			String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("EmratesIDExpDate"), 1000, true) );    
			String EmratesIDExpDate = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
			//String TLIDHeader = request.getParameter("TLIDHeader");
			String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TLIDHeader"), 1000, true) );    
			String TLIDHeader = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			//String TLIDExpDate = request.getParameter("TLIDExpDate");
			String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TLIDExpDate"), 1000, true) );    
			String TLIDExpDate = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
			//String PrimaryEmailId = request.getParameter("PrimaryEmailId");
			String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("PrimaryEmailId"), 1000, true) );    
			String PrimaryEmailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
			//String ApplicationDate = request.getParameter("ApplicationDate");
			String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ApplicationDate"), 1000, true) );    
			String ApplicationDate = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
			//String cat_Subcat = request.getParameter("Subcat");
			String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Subcat"), 1000, true) );    
			String cat_Subcat = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
			//String workstepName = request.getParameter("workstepName");
			String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepName"), 1000, true) );    
			String workstepName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
			//String modeofdelivery = request.getParameter("modeofdelivery");
			String input23 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("modeofdelivery"), 1000, true) );    
			String modeofdelivery = ESAPI.encoder().encodeForSQL(new OracleCodec(), input23!=null?input23:"");
			//String doccollectionbranch = request.getParameter("doccollectionbranch");
			String input24 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("doccollectionbranch"), 1000, true) );    
			String doccollectionbranch = ESAPI.encoder().encodeForSQL(new OracleCodec(), input24!=null?input24:"");
			//String branchDeliveryMethod = request.getParameter("branchDeliveryMethod");
			String input25 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("branchDeliveryMethod"), 1000, true) );    
			String branchDeliveryMethod = ESAPI.encoder().encodeForSQL(new OracleCodec(), input25!=null?input25:"");
			//String CourierAWBNumber = request.getParameter("CourierAWBNumber");
			String input26 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CourierAWBNumber"), 1000, true) );    
			String CourierAWBNumber = ESAPI.encoder().encodeForSQL(new OracleCodec(), input26!=null?input26:"");
			//String CourierCompName = request.getParameter("CourierCompName");
			String input27 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CourierCompName"), 1000, true) );    
			String CourierCompName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input27!=null?input27:"");
			//String Decision = request.getParameter("Decision");
			String input28 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Decision"), 1000, true) );    
			String Decision = ESAPI.encoder().encodeForSQL(new OracleCodec(), input28!=null?input28:"");
	
%>
<script>
function takescreenshot()
{
	alert("lkasldjasdlkja");
	html2canvas(document.querySelector("#container")).then(canvas => {
    document.body.appendChild(canvas)
	});
	alert("234243424234");
}

</script>
<script language="JavaScript"> 


function resizeIframe(obj) 
	{
		try{
		obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
		//obj.style.height ='50px';
		}catch(err){}
	}
	
function setPrimaryField()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	
		var CategoryID = iframeDocument.getElementById("CategoryID").value;
		document.getElementById("CategoryID").value=CategoryID;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		document.getElementById("SubCategoryID").value=SubCategoryID;
		var ws_name = iframeDocument.getElementById("WS_NAME").value;
		var cardNum = iframeDocument.getElementById("PANno").value;
		document.getElementById("wdesk:encryptedkeyid").value = cardNum;
		var WS_LogicalName = iframeDocument.getElementById("WS_LogicalName").value; 	
		document.getElementById("Workstep").innerHTML ="&nbsp;<b>"+WS_LogicalName+"</b>";
        
		//Added below for Dynamic Title of webpage
		var readOnly = "";
		if((parent.document.title).indexOf("(read only)")>0)
			readOnly="(read only)";
		
		parent.document.title = 'Workdesk - '+document.getElementById("wdesk:WI_NAME").value+" ["+WS_LogicalName+"]  "+readOnly;
		
		if(ws_name=="Introduction" && document.getElementById("savedFlagFromDB").value=="")
		{
			if(CategoryID==1 && (document.getElementById("d_PANno").value).indexOf("X")==-1)
			{
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,6)+"XXXXXX"+document.getElementById("d_PANno").value.substring(12,16);
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,4)+"-"+document.getElementById("d_PANno").value.substring(4,8)+"-"+document.getElementById("d_PANno").value.substring(8,12)+"-"+document.getElementById("d_PANno").value.substring(12,16);
			}
		}
		else
		{
			if(CategoryID==1)
			{
				document.getElementById("d_PANno").value=iframeDocument.getElementById(SubCategoryID+"_Cardno_Masked").value;
			}

			document.getElementById("d_PANno").readOnly=true;
		}
		
		
		return true;
		
	}

	function validate(ColumnCopy)
	{
		try{
			var category = '<%=Category%>';	
			var CIF_ID='<%=CifId%>';
			var WINAME='<%=WINAME%>';
			var TEMPWINAME='<%=TEMPWINAME%>';
			var WS='<%=WSNAME%>';
			var subCategory  = '<%=cat_Subcat%>';
			var subCategoryCode  = '<%=subCategoryCode%>';
			var panNo= 'cardno';
			
			if(category=='Cards')
			{	
				panNo = Encrypt(panNo);
				document.getElementById("wdesk:encryptedkeyid").value = panNo;
				//alert(panNo);
			}
		
			var sUrl="../SRB_Specific/BPM_CommonBlocksDebitCard.jsp?load=firstLoad&panNo="+panNo+"&WS="+WS+"&Category="+category+"&SubCategory="+subCategory+"&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&FlagValue=N"+"&subCategoryCode="+subCategoryCode;
		
			var frmData = document.getElementById("frmData");
			frmData.style.display ='block';
			frmData.src = replaceUrlChars(sUrl);
			
			return true;
		}
		catch(e)
		{
			alert("error=="+e.message);
			return false;
		}
		
	}
	
	function replaceUrlChars(sUrl)
	{	
		//alert("inside replaceUrlChars");
		return sUrl.split("+").join("ENCODEDPLUS");
	}

	function loadAllHiddenParamForServiceRequest()
	{
			var xhr;
			var param = "";
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			var ServiceRequestType=document.getElementById("SubCategory").value;
			param = "ServiceRequest="+ServiceRequestType;
			try
			{
					var url = "GetAllHiddenParamsForRequest.jsp";
					xhr.open("POST", url, false);
					xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
					xhr.send(param);
					if (xhr.status == 200 && xhr.readyState == 4) 
					{
						ajaxResult = xhr.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
						//alert("ajaxResult"+ajaxResult);
						//alert("ajaxResult indexOf"+ajaxResult.indexOf("0"));
						var arrayAjaxResult=ajaxResult.split("#");
						
						if (arrayAjaxResult[0]!="0") 
						{
							alert("Problem in reading service request parameters.");
							return false;
						}
						else
						{
								var parameters=arrayAjaxResult[1];
								var arrayParameters=parameters.split("~");
								document.getElementById("DubplicateWorkitemVisible").value=arrayParameters[0];
								document.getElementById("wdesk:printDispatchRequired").value=arrayParameters[1];
								document.getElementById("wdesk:CSMApprovalRequire").value=arrayParameters[2];
								document.getElementById("wdesk:CardSettlementProcessingRequired").value=arrayParameters[3];
								document.getElementById("wdesk:OriginalRequiredatOperations").value=arrayParameters[4];
								document.getElementById("DuplicateCheckLogic").value=arrayParameters[5];
								document.getElementById("AccountIndicator").value=arrayParameters[6];
								document.getElementById("FetchClosedAcct").value=arrayParameters[7];
								document.getElementById("wdesk:OriginalRequiredbyOPSforProcessing").value=arrayParameters[8];
								var archivalPathInMaster=arrayParameters[9];
								document.getElementById("wdesk:isSMSMailToBeSend").value=arrayParameters[10];
								document.getElementById("AccToBeFetched").value=arrayParameters[11];
								document.getElementById("wdesk:ServiceRequestCode").value=arrayParameters[12];
								document.getElementById("isEMIDExpiryChkReq").value=arrayParameters[13];
								document.getElementById("wdesk:MANDATE_NONMANDATE").value=arrayParameters[14];
								document.getElementById("wdesk:ROUTECATEGORY").value=arrayParameters[15];
								if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
								document.getElementById("dispatchHeader").style.display="block";
								
								if(archivalPathInMaster=='path1')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\CentralOperation\\&<CifId>&\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\CentralOperation\\&<CifId>&\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else if(archivalPathInMaster=='path2')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\FinancialFolder\\&<CifId>&\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\FinancialFolder\\&<CifId>&\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else if(archivalPathInMaster=='path3')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\FinancialFolder\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\FinancialFolder\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else
								{
								 alert("Archival path is not cinfigured in master.");
								 return false;
								}
								
								return true;
						}
					} 
					else 
					{
						alert("Exception in reading service request parameters from jsp.");
						return false;
					}
			}
			catch(e)
			{
				alert("Exception in reading service request parameters.");
				return false;
			}
	}
	</script>
</head>

<body topmargin=0  class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "validate('cardno');" onkeydown="">

<form name="wdesk" id="wdesk" method="post">

<div id="container">
		<div id="header">
		<table border='1' id = "TAB_SRB" cellspacing='1' cellpadding='0' width=100% >
		<tr  id = "SRB_Header" width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=center class='EWLabelRB2'><b>Service Request Module </b></td>
		</tr>

	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
		<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;&nbsp;<%=username%></b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>

		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Workstep"><b>&nbsp;<%=workstepName%></b></label></td>
		</tr>

		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workitem Name</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=WINAME%></b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=solid%></b></td>
		</tr>
		

		<%
			
		
		%>
			<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" disabled name="wdesk:CifId" id="wdesk:CifId" value='<%=CifId%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Customer Name</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:Name" id="wdesk:Name" value ='<%=Name%>'/></td>
		</tr>

		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sub Segment</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:SubSegment" id="wdesk:SubSegment" value='<%=SubSegment%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>ARM Code</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:ARMCode" id="wdesk:ARMCode" value = '<%=ARMCode%>'/></td>
		</tr>

		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Rak Elite</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="5" disabled name="wdesk:RAKElite" id="wdesk:RAKElite" value = '<%=RAKElite%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Channel</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="5" disabled name="Channel" id="Channel" value = '<%=Channel%>'/></td>
		</tr>

		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:EmiratesIDHeader" id="wdesk:EmiratesIDHeader" value = '<%=EmiratesIDHeader%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID Expiry Date</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:EmratesIDExpDate" id="wdesk:EmratesIDExpDate" value = '<%=EmratesIDExpDate%>'/></td>
		</tr>
		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Trade License</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:TLIDHeader" id="wdesk:TLIDHeader" value = '<%=TLIDHeader%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Trade License Expiry Date</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:TLIDExpDate" id="wdesk:TLIDExpDate" value = '<%=TLIDExpDate%>'/></td>
		</tr>
		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Primary Email Id</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="wdesk:PrimaryEmailId" id="wdesk:PrimaryEmailId" value = '<%=PrimaryEmailId%>'/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b> Application Date</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input class = 'NGReadOnlyView' type='text' size="22" maxlength="100"  name="wdesk:ApplicationDate" id="wdesk:ApplicationDate" value = '<%=ApplicationDate%>'/>
		<img class = 'NGReadOnlyView' id = 'CalApplicationDate' style="cursor:pointer" src='/SRB/webtop/images/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:ApplicationDate');" width='16' height='16' border='0' alt=''></td>
		</tr>

		</table>
		</div>
		
	<div id="reqdtls">
	<table id = "Req_details" border='1' cellspacing='1' cellpadding='0' width=100% >
		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Request Details</b></td>
		</tr>
	<tr>

	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Request Category</b></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="Category" id="Category" value = '<%=Category%>'/></td>
			
				
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Request Type</b></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=cat_Subcat%>'/></td>
		
								
	</tr>
								
	</table>
	</div>
	<div>

	<iframe border=0 src="../SRB_Specific/BPM_blank.jsp" id="frmData" name="frmData" width="100%" scrolling = "no" onload='javascript:resizeIframe(this);' onresize='javascript:resizeIframe(this);'></iframe> 
	
	</div>
	<div id="dispatchdtls">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id="dispatchHeader" style="">
		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><b>Dispatch Details</b></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Mode of Delivery</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=modeofdelivery%>'/></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Document Collection Branch</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=doccollectionbranch%>'/></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Branch Delivery Method</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=branchDeliveryMethod%>'/></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Courier AWB Number
			</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input class = 'NGReadOnlyView' type='text' name='wdesk:CourierAWBNumber' disabled  id='wdesk:CourierAWBNumber' value='<%=CourierAWBNumber%>' maxlength='100' style='width:160px' onkeyup="ValidateAlphaNumeric('wdesk:CourierAWBNumber','Courier AWB Number');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Courier Company Name
			</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=CourierCompName%>'/></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 2%></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>
		</tr>
	</table>
	</div>


		<div id="decision" style='display:block'> 
			<table border='1' cellspacing='1' cellpadding='0' width=100% id = "decisiondetails" >
				<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Decision</b></td>
				</tr>
				<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Decision </td>
				<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="cat_Subcat" id="cat_Subcat" value = '<%=Decision%>'/></td>
				<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
				<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='PrintReport' id="PrintReport" type='button' value='Print Report' onclick="takescreenshot();" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
			<!--	<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%></td>-->
				</tr>
				</table>
		</div>
		
</div>
<%
}
	catch(Exception e)
	{
		e.printStackTrace();
		WriteLog("in catch");
	}
    
%>		


</form>
</body>	
</html>