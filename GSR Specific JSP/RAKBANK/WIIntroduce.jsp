<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : WIIntroduce.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Cerates WI.
//------------------------------------------------------------------------------------------------------------------------------------>
<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 22-02-2006	 Manish K. Agrawal		On session expires, introducing a request resulted in error (RLS-OF_Defect_AL_RTRL_C1_06.xls)

//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ page import="com.newgen.pci.util.EncryptionDecryption" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->




<%
	String sCabName=null;
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessName: "+ProcessName);
	
	String WI_Data="";
	WriteLog("before esapi wi data ");
	WriteLog("wi data ori GSR"+request.getParameter("WIData"));

	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("WIData", request.getParameter("WIData"), 10000, true) );
	WriteLog("input 3 esapi wi data ");
	String WIData = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: WI ESAPI changed data: "+WIData);
	
	WI_Data=WIData.replace("&amp;&#x23;x15&#x3b;","");
	WriteLog("Integration jsp: WIData replace nak: H100 "+WI_Data);
	WI_Data=WI_Data.replace("&amp;&#x23;x19&#x3b;","");
	WI_Data=WI_Data.replace("&#x2f;","/");
	WriteLog("Integration jsp: WIData / data: h3 "+WI_Data);
	WI_Data=WI_Data.replace("&#x3a;",":");
	WriteLog("Integration jsp: WIData : data:h4 "+WI_Data);
	WI_Data=WI_Data.replace("&#x2b;","+");
	WI_Data=WI_Data.replace("&#x27;","'");
	WriteLog("Integration jsp: WIData : + and  data:h4788 "+WI_Data);
	//for prod issue of special character 
	WI_Data=WI_Data.replace("&#x40;","@");
	WriteLog("Integration jsp: WIData @ data:h6 "+WI_Data);
	WI_Data=WI_Data.replace("&#x21;","!");
	WriteLog("Integration jsp: WIData ! data: h5 "+WI_Data);
	WI_Data=WI_Data.replace("&#x25;","?");
	WriteLog("Integration jsp: WIData % data:h6 "+WI_Data);
	WI_Data=WI_Data.replace("&#xf076;","?");
	WriteLog("Integration jsp: WIData ? data:h8 "+WI_Data);
	WI_Data=WI_Data.replace("&#xfffd;","?");
	WriteLog("Integration jsp: WIData ? data:h9 "+WI_Data);
	WI_Data=WI_Data.replace("&#xf0a7;","?");
	WriteLog("Integration jsp: WIData ? data:h10 "+WI_Data);
	WI_Data=WI_Data.replace("&#xf0fc;","?");
	WriteLog("Integration jsp: WIData ? data:h11 "+WI_Data);
	WI_Data=WI_Data.replace("&#xf0d8;","?");
	WriteLog("Integration jsp: WIData ? data:h12 "+WI_Data);
	WI_Data=WI_Data.replace("&#x23;","#");
	WriteLog("Integration jsp: WIData # data:h13 "+WI_Data);
	WI_Data=WI_Data.replace("&amp;lt&#x3b;","<");
	WriteLog("Integration jsp: WIData < data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x28;","(");
	WriteLog("Integration jsp: WIData ( data:h13 "+WI_Data);
	WI_Data=WI_Data.replace("&#x29;",")");
	WriteLog("Integration jsp: WIData ) data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x2a;","*");
	WriteLog("Integration jsp: WIData * data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x24;","$");
	WriteLog("Integration jsp: WIData $ data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x3f;","?");
	WriteLog("Integration jsp: WIData ? data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x5e;","^");
	WriteLog("Integration jsp: WIData ^ data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&amp;","?");
	WriteLog("Integration jsp: WIData & data:h14 "+WI_Data);
	WI_Data=WI_Data.replace("&#x3b;",";");
	WriteLog("Integration jsp: WIData ; data:h14 "+WI_Data);
	
	
	String[] WI_Data_arr=WI_Data.split("");
	WriteLog("WI_Data_arr EM:"+WI_Data_arr[1]);
	String Mo="";
	String Mo_1="";
	String wi="";
	String branchCode = "";
	String branchCodeOrg = "";
	String loanMaturityDate = "";
	String loanMaturityDateOrg = "";
	String nextInstDate = "";
	String nextInstDateOrg = "";
	for(int i = 0; i < WI_Data_arr.length ; i++)
	{
		wi=WI_Data_arr[i];

		if(wi.contains("LANDLINENO"))
		{
			String[] CC_Mono_arr = wi.split("");
			WriteLog("Key: "+CC_Mono_arr[0]+" ,length of current array: "+CC_Mono_arr.length);
			if(CC_Mono_arr.length > 1){
				WriteLog("Key:"+CC_Mono_arr[0]+"--- Value:"+CC_Mono_arr[1]);
				Mo=CC_Mono_arr[1];
			}
		}
		else if(wi.contains("MOBILENO"))
		{
			String[] CC_Mono_1_arr = wi.split("");
			WriteLog("Key: "+CC_Mono_1_arr[0]+" ,length of current array: "+CC_Mono_1_arr.length);
			if(CC_Mono_1_arr.length > 1){
				WriteLog("Key:"+CC_Mono_1_arr[0]+"--- Value:"+CC_Mono_1_arr[1]);
			    Mo_1=CC_Mono_1_arr[1];
			}
			
		}else if(wi.contains("Q_BRANCH"))
		{
			String[] branchArr = wi.split("");
			String[] finalBranchCode;
			branchCodeOrg = branchArr[1];
			WriteLog("Key: "+branchArr[0]+" ,length of current array: "+branchArr.length);
			if(branchArr.length > 1){
				//WriteLog("Key:"+branchArr[0]+"--- Value:"+branchArr[1]);
				finalBranchCode = branchArr[1].split(" ");
				WriteLog("finalBranchCode: "+finalBranchCode[0]);
				branchCode = finalBranchCode[0];
			}
			
		}else if(wi.contains("LoanMaturityDate"))
		{
			String[] maturityDateArr = wi.split("");
			WriteLog("Key: "+maturityDateArr[0]+" ,length of current array: "+maturityDateArr.length);
			loanMaturityDateOrg = maturityDateArr[1];
			if(maturityDateArr.length > 1){
				WriteLog("Key:"+maturityDateArr[0]+"--- Value:"+maturityDateArr[1]);
			    //loanMaturityDateT=maturityDateArr[1];
			}
			String[] afterSplitDate = maturityDateArr[1].split("/");
			loanMaturityDate = afterSplitDate[2]+"-"+afterSplitDate[1]+"-"+afterSplitDate[0]+" 00:00:00";
			WriteLog("loanMaturityDate: "+loanMaturityDate);
			
		}else if(wi.contains("NextInstDate"))
		{
			String[] nextInstDateArr = wi.split("");
			WriteLog("Key: "+nextInstDateArr[0]+" ,length of current array: "+nextInstDateArr.length);
			nextInstDateOrg = nextInstDateArr[1];
			if(nextInstDateArr.length > 1){
				WriteLog("Key:"+nextInstDateArr[0]+"--- Value:"+nextInstDateArr[1]);
			    //nextInstDateT=nextInstDateArr[1];
			}
			String[] afterSplitDate = nextInstDateArr[1].split("/");
			nextInstDate = afterSplitDate[2]+"-"+afterSplitDate[1]+"-"+afterSplitDate[0]+" 00:00:00";
			WriteLog("nextInstDate: "+nextInstDate);
		}
		
	}
	WriteLog("WI_Data_arr Mo :"+Mo);
	WriteLog("WI_Data_arr Mo1 :"+Mo_1);
	
	WI_Data=WI_Data.replace(loanMaturityDateOrg,loanMaturityDate);
	WriteLog("WI_Data after updating loanMaturityDate :"+WI_Data);
	
	WI_Data=WI_Data.replace(nextInstDateOrg,nextInstDate);
	WriteLog("WI_Data after updating nextInstDate :"+WI_Data);
	
	WI_Data=WI_Data.replace(branchCodeOrg,branchCode);
	WriteLog("WI_Data after updating branch code :"+WI_Data);

	String Att3="";
	String aat2 ="";
try{
	EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();

	Att3 = ed.encryptFormField(Mo,sCabName);
	aat2= ed.encryptFormField(Mo_1,sCabName);
    WriteLog("############");
	WriteLog("Encrypted Crd number Att3:"+Att3);
	WriteLog("Encrypted Crd number aat2:"+aat2);
	
	if(!Mo.equalsIgnoreCase("")){
		Mo="LANDLINENO"+Mo;
		Att3 = "LANDLINENO"+Att3;
		WI_Data=WI_Data.replace(Mo,Att3);}
	if(!Mo_1.equalsIgnoreCase("")){
		Mo_1="MOBILENO"+Mo_1;
		aat2="MOBILENO"+aat2;
		WI_Data=WI_Data.replace(Mo_1,aat2);}
		WriteLog("WI_Data aat2"+WI_Data);
    }
	catch(Exception e){
	// do nothing
		WriteLog("Exception"+e.getMessage());
	}

	
out.println(ProcessName);
out.println(request.getParameter("WIData"));

String sInputXML ="";
String sOutputXML = "";

String sSessionId = null;
String userName=null;
String UserIndex=null;
String sJtsIp = null;
String sProcessDefId="";
String sMsg="";
//int iJtsPort = 0;
String iJtsPort = "";
boolean bError=false;

String a="";
String b="";

try{
  WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabName = wDCabinetInfo.getM_strCabinetName();
		sSessionId = wDUserInfo.getM_strSessionId();
		userName = wDUserInfo.getM_strUserName();
		UserIndex = wDUserInfo.getM_strUserIndex();
		WriteLog("userName = "+userName+" : UserIndex = "+UserIndex);
		sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
		
}catch(WFException ignore){
	a=ignore.getMainCode();
	b=ignore.getSource();
}
if (a.equals("-50146") || a.equals("4002") || a.equals("11") || a.equals("4020"))
{
	//----------------------------------------------------------------------------------------------------
	// Changed By						:	Manish K. Agrawal
	// Reason / Cause (Bug No if Any)	:	On session expires, introducing a request resulted in error (RLS-OF_Defect_AL_RTRL_C1_06.xls)
	// Change Description				:	Error Handling
	//----------------------------------------------------------------------------------------------------

	bError= true;
	sMsg = "User session has been expired. Please re-login.";
}

if(!bError)
{
	String processDefIdParams="ProcessName=="+ProcessName;
	String processDefIdParamsQuery="select ProcessDefId from PROCESSDEFTABLE with (nolock) where ProcessName=:ProcessName";
	sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + processDefIdParamsQuery + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId><Params>" + processDefIdParams + "</Params></APSelectWithNamedParam_Input>";
	WriteLog("processDefIdParamsQuery: "+sInputXML);
	
	sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
	WriteLog("processDefIdParamsQuery output: "+sOutputXML);
	XMLParser xmlParserData=new XMLParser();
	xmlParserData.setInputXML(sOutputXML);
	String maincode = xmlParserData.getValueOf("MainCode");
	WriteLog("maincode: "+maincode);
	String subXML="";
	XMLParser objXmlParser = null;
	if(maincode.equals("0"))
	{
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		sProcessDefId = objXmlParser.getValueOf("ProcessDefId");
		
	}else{
		bError= true;
		sMsg = "Could Not Fetch Process Definition.";
	}
	WriteLog("Processdefinitionid--"+sProcessDefId);
	
	/*sInputXML =	"?xml version=\"1.0\"?>\n" +
		"<WMOpenProcessDefinition_Input>" +
			"<Option>WMFetchProcessDefinitions</Option>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"<SessionId>"+sSessionId+"</SessionId>" +
			"<Filter>" +
				"<Type>256</Type>" +
				"<AttributeName></AttributeName>" +
				"<Comparison>0</Comparison>" +
				"<FilterString>LOWER(RTRIM(CABINETNAME)) = '"+sCabName+"' AND UPPER(RTRIM(PROCESSNAME)) = '"+ProcessName+"'</FilterString>" +
				"<Length>0</Length>" +
			"</Filter>" +
		"</WMOpenProcessDefinition_Input>";

	
	WriteLog(sInputXML);
	//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
	out.println(sOutputXML);
	WriteLog(sOutputXML);
	if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
	{
		bError= true;
		sMsg = "Could Not Fetch Process Definition.";
	}
	else
	{
		//added by stutee.mishra on 23/10/2021 starts here.
		String[] splittedOutputXml = sOutputXML.split("</ProcessDefinition>");
		for(int x = 0; x<splittedOutputXml.length; x++){
			if(ProcessName.equalsIgnoreCase(splittedOutputXml[x].substring(splittedOutputXml[x].indexOf("<ProcessDefinitionName>")+23 , splittedOutputXml[x].indexOf("</ProcessDefinitionName>"))))
			{
				sProcessDefId=splittedOutputXml[x].substring(splittedOutputXml[x].indexOf("<ProcessDefinitionId>")+21 , splittedOutputXml[x].indexOf("</ProcessDefinitionId>"));
				break;
			}
		}
		//added by stutee.mishra on 23/10/2021 ends here.
		//sProcessDefId=sOutputXML.substring(sOutputXML.indexOf("<ProcessDefinitionId>")+21 , sOutputXML.indexOf("</ProcessDefinitionId>"));
		//sProcessDefId="1068";
		WriteLog("Processdefinitionid--"+sProcessDefId);
	}*/
	if(!bError)
	{
		sInputXML =	"<?xml version=\"1.0\"?>\n" +
			"<WFUploadWorkItem_Input>" +
			"<Option>WFUploadWorkItem</Option>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"<SessionId>"+sSessionId+"</SessionId>" +
			"<ProcessDefId>"+sProcessDefId+"</ProcessDefId>" + 
			//"<Attributes>"+request.getParameter("WIData").replaceAll("'","''")+"</Attributes>" +
			"<Attributes>"+WDUtility.Replace(WI_Data,"'","''")+"</Attributes>" +
			"</WFUploadWorkItem_Input>";
			WriteLog(sInputXML);
			//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			out.println(sOutputXML);
			WriteLog(sOutputXML);
			if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
			{
				bError = true;
				if(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")).equals("2"))
				{
					sMsg="Either Process is Disabled Or Used does not has rights to perform this operation.";
				}
				else
				{
					//sMsg="Internal Server Error.";
					sMsg=sOutputXML.substring(sOutputXML.indexOf("<Subject>")+9 , sOutputXML.indexOf("</Subject>"));
				}
			}	
			else
			{
				sMsg=sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>")) + " Created.";
			}
	}
}
out.clear();
out.print(sMsg);
%>


