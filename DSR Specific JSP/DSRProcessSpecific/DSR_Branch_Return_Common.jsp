<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>


<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<script>
function CheckMxLength1(data,val)
{
	var issue=data.value;
	if(issue.length>=val+1)
	{
		alert("Remarks/Reasons can't be greater than 255 Characters");
		var lengthRR="";
		lengthRR=issue.substring(0,val);
		data.value=lengthRR;
		
	}
	return true;
}


</script>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
   // String sProcessname=null;
	boolean bError=false;
	String sRAKBankCard="";
	String sCardType="";
	String sExpDate="";
	String sBTAmt="";
	String sAppCode="";
	Hashtable ht=new Hashtable();
	String sOutputXMLCustomerInfoList ="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
//sProcessname=wfsession.getProcessName();

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	
	try{
		sCabname=wfsession.getEngineName();
		sSessionId = wfsession.getSessionId();
		sJtsIp = wfsession.getJtsIp();
		iJtsPort = wfsession.getJtsPort();
	}catch(Exception ignore){
		bError=true;
		WriteLog(ignore.toString());
	}	
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
	}
	else
	{
		String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId><WorkitemId>1</WorkitemId><QueueId></QueueId><QueueType></QueueType><DocOrderBy></DocOrderBy><DocSortOrder></DocSortOrder><ObjectPreferenceList>W,D</ObjectPreferenceList><GenerateLog>Y</GenerateLog></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("--Branch_Return_Common sInputXML1--"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
			WriteLog("--Branch_Return_Common strOutputXMLCat1--"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 	

        for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  				
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());				  		
				  WriteLog(objWorkList.getVal("Name").toString()+"=="+objWorkList.getVal("Value").toString());
			}
			

	}

	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);
	%>

<body topmargin=0 leftmargin=15 class='EWGeneralRB'>
<form name="dataform">


	
	<% if (DataFormHT.containsKey("BA_Decision")) { %>
    <table border='1' cellspacing='1' cellpadding='1' width=100% >
	<tr class='EWHeader'>	
	   <input type='text' name='Header1' readOnly size='24' style='display:none' value='Branch Approver Details'>
		<td colspan =6 align=left class='EWLabelRB3'>
		<b>Branch Approver Details<font color=blue>&nbsp;&nbsp;<%=(DataFormHT.get("BA_UserName")==null||DataFormHT.get("BA_UserName").equals(""))?wfsession.getUserName():DataFormHT.get("BA_UserName")%>&nbsp;&nbsp;<%=(DataFormHT.get("BA_DateTime")==null||DataFormHT.get("BA_DateTime").equals(""))?sDate:DataFormHT.get("BA_DateTime")%></font></b>
	   </td>
	</tr>
	 <tr>
	  <td nowrap width="150" height="16" class="EWLabelRB">Decision</td>
       <td nowrap  width="150">
	   <%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Approver")){%>
	   <select name="BA_Decision">
	   <option value="">--Select--</option>
   	   <option value="BA_CARDS">Approve</option>
	   <option value="BA_D">Discard</option>
	   <option value="BA_BR">Re-Submit to Branch</option>
	   </select>
	   <%} else {%>	   
	   <b><%
		String sBADisplayText="";
		if(DataFormHT.get("BA_Decision").toString().equalsIgnoreCase("BA_BR")) sBADisplayText="Re-Submit to Branch";
		else if(DataFormHT.get("BA_Decision").toString().equalsIgnoreCase("BA_CARDS")) sBADisplayText="Approve";
		else if(DataFormHT.get("BA_Decision").toString().equalsIgnoreCase("BA_D")) sBADisplayText="Discard";
		out.println(sBADisplayText);
		%><font color=blue></font></b>
	   <%}%>
	   </td>	   
       <td nowrap width="150" height="16" class="EWLabelRB">Remarks/Reason</td>
       <td nowrap  width="180" colspan=3><textarea name="BA_Remarks" COLS=30 ROWS=8 onKeyup="CheckMxLength1(this,255);" rows=2><%=DataFormHT.get("BA_Remarks")%></textarea></td>
      </tr>
	   </table>
	  <% } %>
    
<% if (DataFormHT.containsKey("BR_Decision")) { %> <%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Return")||((DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Query")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Work Exit1")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Discard1"))&&!DataFormHT.get("BR_Decision").toString().equals(""))) {%>
	<table border='1' cellspacing='1' cellpadding='1' width=100% >
	  <input type='text' name='Header' readOnly size='24' style='display:none' value='Branch Return Details'>  
	  <tr class='EWHeader' >
		<td colspan =6 align=left class='EWLabelRB3'>
			<b>Branch Return Details<font color=blue>&nbsp;&nbsp;<%=(DataFormHT.get("BR_UserName")==null||DataFormHT.get("BR_UserName").equals(""))?wfsession.getUserName():DataFormHT.get("BR_UserName")%>&nbsp;&nbsp;<%=(DataFormHT.get("BR_DateTime")==null||DataFormHT.get("BR_DateTime").equals(""))?sDate:DataFormHT.get("BR_DateTime")%></font></b>
		</td>
		</tr>
		  <tr>
			<td nowrap width="150" height="16" class="EWLabelRB">Decision</td>
			<td nowrap  width="150">
			<%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Return")){%>
		   <select name="BR_Decision">
		   <option value="">--Select--</option>
		   <option value="Approve">Re-Submit to CARDS</option>
		   <option value="Discard">Discard</option>
		   </select>
		   <%} else {%>	   
			<b><%
			String sCardsDisplayText="";
			if(DataFormHT.get("BR_Decision").toString().equalsIgnoreCase("APPROVE")) sCardsDisplayText="Approve";
			else sCardsDisplayText="Discard";
			out.println(sCardsDisplayText);
			%><font color=blue></font></b><%}%>
			</td>
			<td nowrap width="150" height="16" class="EWLabelRB">Remarks/Reason</td>
			<td nowrap  width="180" colspan=3><textarea name="BR_Remarks"  cols=30 onKeyup="CheckMxLength1(this,255);" rows=2><%=DataFormHT.get("BR_Remarks")==null?"":DataFormHT.get("BR_Remarks")%></textarea></td>
		  </tr>
			
		  </table>
	 <%}}%>

	<%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS")||((DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Return")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Approver")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Query")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Work Exit1")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Discard1"))&&!DataFormHT.get("Cards_Decision").toString().equals(""))) {%>
	<table border='1' cellspacing='1' cellpadding='1' width=100% >
	  <input type='text' name='Header1' readOnly size='24' style='display:none' value='Cards Details'>  
	  <tr class='EWHeader' >
		<td colspan =6 align=left class='EWLabelRB3'>
			<b>CARDS Details<font color=blue>&nbsp;&nbsp;<%=(DataFormHT.get("Card_UserName")==null||DataFormHT.get("Card_UserName").equals(""))?wfsession.getUserName():DataFormHT.get("Card_UserName")%>&nbsp;&nbsp;<%=(DataFormHT.get("Card_DateTime")==null||DataFormHT.get("Card_DateTime").equals(""))?sDate:DataFormHT.get("Card_DateTime")%></font></b>
		</td>
		</tr>
		  <tr>
			<td nowrap width="150" height="16" class="EWLabelRB">Decision</td>
			<td nowrap  width="150">
			<%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS")){%>
		   <select name="Cards_Decision">
		   <option value="">--Select--</option>		  
		   <option value="CARDS_E">Complete</option>
		    <option value="CARDS_BR">Re-Submit to Branch</option>
		   <option value="CARDS_UP">Under Process</option>
		   <option value="CARDS_D">Discard</option>
		   </select>
		   <%} else {%>	   
			<b><%
			String sCardsDisplayText="";
			if(DataFormHT.get("Cards_Decision").toString().equalsIgnoreCase("CARDS_BR")) sCardsDisplayText="Re-Submit to Branch";
			else if(DataFormHT.get("Cards_Decision").toString().equalsIgnoreCase("CARDS_E")) sCardsDisplayText="Approve";else if(DataFormHT.get("Cards_Decision").toString().equalsIgnoreCase("CARDS_D")) sCardsDisplayText="Discard";
			out.println(sCardsDisplayText);
			%><font color=blue></font></b><%}%>
			</td>
			<td nowrap width="150" height="16" class="EWLabelRB">Remarks/Reason</td>
			<td nowrap  width="180" colspan=3><textarea name="Cards_Remarks" type="text"  cols=30 onKeyup="CheckMxLength1(this,255);" rows=2><%=DataFormHT.get("Cards_Remarks")%></textarea></td>
		  </tr>
		  
			<%if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS")){%>
		  <tr>
			<td nowrap colspan=6 align="center" ><input type="button" name="PrintButton" class="EWButtonRB" Value="Print" onclick="print();" style='width:80px'></td>
		  </tr>
		  <%}%>
		  </table>
	 <%}%>

	
</form>
</body>