<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application �Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : History.jsp
//Author                     : 
// Date written (DD/MM/YYYY) : 09-Feb-2015
//Description                : Form to fetch the data from history table on the basis of workitem id
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
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


<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->

<HTML>
<HEAD>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);

%>

<TITLE> <%=WINAME_Esapi%>: Decision History</TITLE>
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<script>
function CloseWindow()
{
	window.parent.close();
}

</script>
<%
	String WINAME=WINAME_Esapi;
	String hist_table = "USR_0_AO_WIHISTORY";
	String colname="";
	String colvalues="'";
	String strQuery="";
	String params="";
	String strInputXML="";
	String strOutputXML="";
	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";
	String wsname ="";
	String decision ="";
	Date datetime=null;
	String actiondatetime ="";
	String remarks ="";
	String rejectReasons ="";
	String username ="";
	
	//For reject reasons
	HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
	HashMap<String,String> RejectReasonDocs = new HashMap<String, String>();
		
	//strQuery="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive='Y' order by id asc";
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="IsActive==Y";
	strQuery="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive=:IsActive order by id asc";
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
		
	//strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	strOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), strInputXML);
	//WriteLog("outputXML exceptions-->"+strOutputXML);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	int records=0;
	records=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

	if(mainCodeValue.equals("0"))
	{
		for(int k=0; k<records; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			RejectReasonsMap.put(objXmlParser.getValueOf("item_code"),objXmlParser.getValueOf("Item_Desc"));	
		}			
	}
	
	
	//strQuery="select item_code,item_desc from USR_0_AO_Doc_Desc_Master with(nolock) where isactive='Y' order by cast(display_order as int) asc";
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="IsActive==Y";
	strQuery="select item_code,item_desc from USR_0_AO_Doc_Desc_Master with(nolock) where isactive=:IsActive order by cast(display_order as int) asc";
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	
	//strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	strOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), strInputXML);
		
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	records=0;
	records=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

	if(mainCodeValue.equals("0"))
	{
		for(int k=0; k<records; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			RejectReasonDocs.put(objXmlParser.getValueOf("item_code"),objXmlParser.getValueOf("Item_Desc"));	
		}			
	}	
	
	
	//strQuery="select id,wsname,decision,actiondatetime,remarks,username,checklistData from "+hist_table+" with(nolock) where WINAME=:WINAME and actiondatetime is not null order by id desc";		
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="WINAME=="+WINAME;
	strQuery="select id,wsname,decision,actiondatetime,remarks,username,checklistData from "+hist_table+" with(nolock) where WINAME=:WINAME and actiondatetime is not null order by id desc";		
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	WriteLog(strInputXML);
	
	
	//strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	strOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), strInputXML);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	WriteLog(strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>
<!--table width=100% border='1'>
	<tr width=100% >
		<td colspan = 3 align=right valign=center><img src='\webdesktop\webtop\images\rak-logo.gif'></td>
	</tr>
	<tr width=100% >
		<td class='EWNormalGreenGeneral1' width=30% align=center valign=center><b>Account Opening Request: <%=WINAME%></b></td>
	</tr>
</table-->

<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'>
		
		<td width=15% style="text-align:center" class='EWLabelRB2'><b>&nbsp;&nbsp;&nbsp;&nbsp;DateTime&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
		<td width=8% style="text-align:center" class='EWLabelRB2'><b>&nbsp;Workstep&nbsp;</b></td>
		<td width=8% style="text-align:center" class='EWLabelRB2'><b>&nbsp;User Name&nbsp;</b></td>
		<td width=8% style="text-align:center" class='EWLabelRB2'><b>&nbsp;Decision&nbsp;</b></td>
		<td width=30% style="text-align:center" class='EWLabelRB2'><b>&nbsp;Reject Reasons&nbsp;</b></td>
		<td width=35% style="text-align:center" class='EWLabelRB2'><b>Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
	</tr>
<%
		SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		
		
		
		for(int k=0; k<recordcount; k++)
		{	
			if(k!=0)
				subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			datetime = formatter.parse(objXmlParser.getValueOf("actiondatetime"));
			actiondatetime = sdf.format(datetime);
			wsname = objXmlParser.getValueOf("wsname");
			username = objXmlParser.getValueOf("username");
			decision = objXmlParser.getValueOf("decision");
			rejectReasons = objXmlParser.getValueOf("checklistData").replaceAll("&#x3a;",":");
			remarks = objXmlParser.getValueOf("remarks");
			String 	rejectReasonsinRow="";		
			if (rejectReasons==null||rejectReasons.equalsIgnoreCase("NULL")||rejectReasons.equals("")) rejectReasonsinRow="&nbsp;";
			else
			{
				if(rejectReasons.indexOf(":")>-1){
				//011:003|004|005#010:003|004|005
					String strReasons[] = rejectReasons.split("#");
					for(int count=0;count<strReasons.length;count++)
					{
						String desc=strReasons[count].split(":")[0];
						if(count==0)
							rejectReasonsinRow=RejectReasonsMap.get(desc)+" - ";
						else
							rejectReasonsinRow+="<br><br>"+RejectReasonsMap.get(desc)+" - ";
						String docs[]=strReasons[count].split(":")[1].split("\\|");
						
						for(int docscount=0;docscount<docs.length;docscount++)
						{
							WriteLog(RejectReasonDocs.get(docs[docscount]));
							if(docscount==0)
								rejectReasonsinRow+="<i><br>"+RejectReasonDocs.get(docs[docscount]);
							else							
								rejectReasonsinRow+=",<br>"+RejectReasonDocs.get(docs[docscount]);
						}
						rejectReasonsinRow+="</i>";
					}	
				}
				else{
				//015#004#018#002
					
					String strReasons[] = rejectReasons.split("#");
					for(int count=0;count<strReasons.length;count++)
					{
						String desc=strReasons[count].split(":")[0];
						if(count==0)
							rejectReasonsinRow=RejectReasonsMap.get(strReasons[count]);
						else
							rejectReasonsinRow+="<br><br>"+RejectReasonsMap.get(strReasons[count]);						
					}					
				}
			}
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")) remarks="&nbsp;";
			
%>
		<tr>
			<td width=15% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=wsname%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=username%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=decision%></b></td>
			<td width=30% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=rejectReasonsinRow%></b></td>
			<td width=35% style="text-align:center" class='EWNormalGreenGeneral1'><div float=left; style="width: 480px; height: 50px; word-wrap: break-word; overflow-x: hidden; overflow-y: auto;"><b><%=remarks%></b></div></td>
		</tr>
<%
		}
	}
	else
	{
		WriteLog("Error fetching history. Please contact Administrator.");
	}
%>
	</table>
	<br>
	<!--table>
		<tr>
			<td><input name='Close' type='button' value='Close' onclick="CloseWindow()" class='EWButtonRB' style='width:60px' ></td>
		</tr>
	</table-->
</body>
</html>

