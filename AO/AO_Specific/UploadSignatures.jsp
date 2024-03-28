<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->
<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>


<html>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.4.js"></script>
<script type="text/javascript">

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);

%>
<%
String WIName = WINAME_Esapi;
%>
var Status;
function Validate(ButtonId){
    	
	str=ButtonId;
	
	var index=str.charAt(6);
	
	var CifIdId="cifId_"+index;
	var CustSeqId="custSeqNo_"+index;
	var AccountNoID="accountNo_"+index;
	var CustomerNameID= "customerName_"+index;
	var MandatesID= "mandates_"+index;
	var StatusID= "Status_"+index;
	var CustomerName=document.getElementById(CustomerNameID).innerHTML;
	var Mandates=document.getElementById(MandatesID).innerHTML;
	var AccountNo=document.getElementById(AccountNoID).innerHTML;
	var CifId=document.getElementById(CifIdId).innerHTML;
	var CustSeqNo=document.getElementById(CustSeqId).innerHTML;
	var ItemIndex=document.getElementById("hide").value;
	Status= document.getElementById(StatusID).innerHTML;
	
	var sUrl="/webdesktop/CustomForms/AO_Specific/VerifySignature.jsp?CifId="+CifId+"&AccountNo="+AccountNo+"&CustSeqNo="+CustSeqNo+"&ItemIndex="+ItemIndex+"&CustomerName="+CustomerName+"&Mandates="+Mandates+"&WIName=<%=WIName%>";
	
	var xhr;
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	 xhr.open("GET",sUrl,false); 
	 xhr.send(null);
	
	if(xhr.status == 200 && xhr.readyState == 4)
	{
		window.location.reload();				
	}
	else
	{
		alert("Error while fetching signatures");
		return false;
	}           
}

function refresh(){
	
	if(Status=="Failure")
	{
	alert("Failed");
	}
}


</script>
<head>
	<style>
				@import url("\webdesktop\webtop\en_us\css\docstyle.css");
				body{
					bgcolor:"#FFFBF0";
				}
	</style>			
</head>
<body class="EWGeneralRB" bgcolor="#FFFBF0" onload="refresh()">


<%
try{
		
		//String sQuery = "Select cif_id,customer_seq_no, account_no, customer_name1,remarks, sigupload_status  from AO_signature_status with(nolock) where wi_name='"+WIName+ "'" ;
		//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + sQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		
		String params="WINAME=="+WIName;
		String sQuery = "Select cif_id,customer_seq_no, account_no, customer_name1,remarks, sigupload_status  from AO_signature_status with(nolock) where wi_name=:WINAME" ;
		String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + sQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
		
		WriteLog(inputXML );
		//String outputXML = WFCallBroker.execute(inputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
		WriteLog(outputXML);
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputXML);
		String mainCodeValue = xmlParserData.getValueOf("MainCode");
		int recordcount=0;
		recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		if(mainCodeValue.equals("0"))
		{
			%>
			<table width="100%" >
				<tr><td width=100% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></td></tr>				
		</table>
			<hr style=" color: #b20000; height: 3px">
			<table width="100%" border="2" style="margin: 0 auto;">
			<tr class="EWLabelRB2"><th>CIF ID</th><th>Signature#</th><th>Account Number</th><th>Customer Name</th><th>Mandates</th><th>Upload Status</th><th>Upload</th></tr>
					
			<%
			for(int k=0; k<recordcount; k++)
			{
				XMLParser objXmlParser=null;
				String subXML="";	
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				String strCifID=objXmlParser.getValueOf("cif_id");
				String strCustSeqNo=objXmlParser.getValueOf("customer_seq_no");
				String strAccountNo=objXmlParser.getValueOf("account_no");
				String strCustomerName=objXmlParser.getValueOf("customer_name1");
				String strRemarks=objXmlParser.getValueOf("remarks");
				if(strRemarks==null||strRemarks.equals("")||strRemarks.equalsIgnoreCase("null"))
					strRemarks="&nbsp;";
				String strUploadStatus=objXmlParser.getValueOf("sigupload_status");
				
				%>
				
				<tr class="EWNormalGreenGeneral1">
					<td id="cifId_<%=k%>"><%=strCifID%></td>
					<td style="text-align:center" id="custSeqNo_<%=k%>"><%=strCustSeqNo%></td>
					<td id="accountNo_<%=k%>"><%=strAccountNo%></td>
					<td id="customerName_<%=k%>"><%=strCustomerName%></td>
					<td id="mandates_<%=k%>"><%=strRemarks%></td>
					<td style="text-align:center" id="Status_<%=k%>">
				
				<%
				if(strUploadStatus.equalsIgnoreCase("F"))
				{
					%><b>Failure</b></td><td><input type="button" width="30" id="click_<%=k%>" value="Upload" onclick="Validate(this.id)" class="EWButtonRB"></td><%
				}
				else
				{
					%>Success</td><td>&nbsp;</td><%
				}
				%>
				</tr>
				<%
			}
		}	
		else
		{
			%>
				<h1>Error Fetching Data</h1>
			<%
		}
		if(recordcount==0)
		{
			%>
				<h1>No Data Found</h1>
			<%
		}
	}catch(Exception e)
	{
		out.println("error"+e.getMessage());
	}
%>
<%
try{
		
		//String sQuery = "Select ITEMINDEX from RB_AO_EXTTABLE with(nolock) where wi_name='"+WIName+ "'";
		//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + sQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		
		String params="WINAME=="+WIName;
		String sQuery = "Select ITEMINDEX from RB_AO_EXTTABLE with(nolock) where wi_name=:WINAME";
		String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + sQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
				
		WriteLog(inputXML );
		//String outputXML = WFCallBroker.execute(inputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
		WriteLog(outputXML);
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputXML);
		String newMainCode = xmlParserData.getValueOf("MainCode");
		int newRecordCount=0;
		newRecordCount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		if(newMainCode.equals("0"))
		{
			for(int k=0; k<newRecordCount; k++)
			{
				XMLParser objXmlParser=null;
				String subXML="";	
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				String strItemIndex=objXmlParser.getValueOf("ITEMINDEX");
				%>
				<input type="hidden" id="hide" value=<%=strItemIndex%> ></input>
			<%
			}
		}	
		else
		{
			%>
				<h1>Error Fetching Data</h1>
			<%
		}
		if(newRecordCount==0)
		{
			%>
				<h1>No Data Found</h1>
			<%
		}
	}catch(Exception e)
	{
		out.println("error"+e.getMessage());
	}
%>


</table>
<br><br>
<!--input type="submit" value="Upload All"  style="margin-left:45%;"-->
<div align="center"> 
	<input type="button" value="Close" onclick="window.parent.close();" class="EWButtonRB">
</div>	
</body>
</html>