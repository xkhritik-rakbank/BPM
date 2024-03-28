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
<%@ page import= "java.text.DateFormat"%>
<%@ page import= "java.text.SimpleDateFormat"%>
<%@ page import= "java.time.LocalDate"%>
<%@ page import= "java.time.format.DateTimeFormatter"%>
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

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<HTML>
<HEAD><style></style></HEAD>
<body class='EWGeneralRB'>
<%
String sInputXML ="";
String sOutputXML = "";
String sCabName="";
String userName=null;
String UserIndex=null;
String sSessionId = null;
String sJtsIp = null;
String sUserName = null;
String sUserIndex = null;
String sProcessDefId="";
String sMsg="";
//int iJtsPort = 0;
String iJtsPort = "";
boolean bError=false;
int RecordCount=0;
WFXmlResponse objWorkListXmlResponse;
WFXmlList objWorkList;

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessName: "+ProcessName);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("subProcessShortName", request.getParameter("subProcessShortName"), 1000, true) );
	String subProcessShortName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: subProcessShortName: "+subProcessShortName);
	
	String WI_DataReplace = request.getParameter("WIData");
	WriteLog("Integration jsp: WIData orignal h11 dsr"+WI_DataReplace);
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("WIData", request.getParameter("WIData"), 100000, true) );
	String WIData = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
	
	String WI_Data=WIData.replace("&amp;&#x23;x15&#x3b;","");
	WriteLog("Integration jsp: WIData replace nak: H1 "+WI_Data);
	WI_Data=WI_Data.replace("&amp;&#x23;x19&#x3b;","");
	WriteLog("Integration jsp: WIData EM data: h2 "+WI_Data);
	WI_Data=WI_Data.replace("&#x2f;","/");
	WriteLog("Integration jsp: WIData / data: h3 "+WI_Data);
	WI_Data=WI_Data.replace("&#x3a;",":");
	WriteLog("Integration jsp: WIData : data:h4 "+WI_Data);
	WI_Data=WI_Data.replace("&#x2b;","+");
	WI_Data=WI_Data.replace("&#x27;","\'");
	WriteLog("Integration jsp: WIData : + and  data:h4788 "+WI_Data);
	
	// hritik due to production print issue

WI_Data=WI_Data.replace("&#x3f;","?");
WriteLog("Integration jsp: WIData # data:h13 "+WI_Data);

WI_Data=WI_Data.replace("&#x7e;","~");
WI_Data=WI_Data.replace("&#x60;","`");

WI_Data=WI_Data.replace("&#x23;","?");
WriteLog("Integration jsp: WIData # data:h13 "+WI_Data);

WI_Data=WI_Data.replace("&#x24;","$");
WriteLog("Integration jsp: WIData $ data:h14 "+WI_Data);
	
WI_Data=WI_Data.replace("&#x25;","%");
WriteLog("Integration jsp: WIData % data:h6 "+WI_Data);

WI_Data=WI_Data.replace("&#x5e;","^");
WriteLog("Integration jsp: WIData ^ data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&amp;amp&#x3b;","&");
WriteLog("Integration jsp: WIData & data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&#x2a;","*");
WriteLog("Integration jsp: WIData * data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&#x28;","(");
WriteLog("Integration jsp: WIData ( data:h13 "+WI_Data);

WI_Data=WI_Data.replace("&#x29;",")");
WriteLog("Integration jsp: WIData ) data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&#x2b;","+");
WI_Data=WI_Data.replace("&#x3d;","=");
WI_Data=WI_Data.replace("&#x7b;","{");
WI_Data=WI_Data.replace("&#x7d;","}");
WI_Data=WI_Data.replace("&#x5b;","[");
WI_Data=WI_Data.replace("&#x5d;","]");
WI_Data=WI_Data.replace("&#x7c;","|");
WI_Data=WI_Data.replace("&#x5c;","\\");
WI_Data=WI_Data.replace("&#x22;","\"");
WI_Data=WI_Data.replace("&#x2c;",",");


WI_Data=WI_Data.replace("&amp;lt&#x3b;","<");
WriteLog("Integration jsp: WIData < data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&amp;gt&#x3b;",">");
WriteLog("Integration jsp: WIData ; data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&#x3a;",":");
WriteLog("Integration jsp: WIData : data:h4 "+WI_Data);

WI_Data=WI_Data.replace("&#x3b;",";");
WriteLog("Integration jsp: WIData ; data:h14 "+WI_Data);

WI_Data=WI_Data.replace("&#x40;","@");
WriteLog("Integration jsp: WIData @ data:h6 "+WI_Data);

WI_Data=WI_Data.replace("&#x21;","!");
WriteLog("Integration jsp: WIData ! data:h7 "+WI_Data);

WI_Data = WI_Data.replaceAll("&#x\\w*;", "?");	
WriteLog("regex replacing "+WI_Data);


	String[] WI_Data_arr=WI_Data.split("");
	WriteLog("WI_Data_arr EM:"+WI_Data_arr[1]);
	String CC_NUM="";
	String other_CC="";
	String Mo="";
	String userEmail = "";
	String pendingOptionFinal = "";
	for(int i = 0; i < WI_Data_arr.length ; i++)
	{
		String wi=WI_Data_arr[i];
		
		if(wi.contains("DCI_DebitCN")){
			String[] CC_NO_arr = wi.split("");
			WriteLog("Key:"+CC_NO_arr[0]+"--- Value:"+CC_NO_arr[1]);
			CC_NUM=CC_NO_arr[1];
		}
		else if(wi.contains("BTD_OBC_OBCNO"))
		{
			String[] CC_other_arr = wi.split("");
			WriteLog("Key:"+CC_other_arr[0]+"--- Value:"+CC_other_arr[1]);
			other_CC=CC_other_arr[1];
		}
		else if(wi.contains("DCI_MONO"))
		{
			String[] CC_Mono_arr = wi.split("");
			WriteLog("Key: "+CC_Mono_arr[0]+" ,length of current array: "+CC_Mono_arr.length);
			if(CC_Mono_arr.length > 1){
				WriteLog("Key:"+CC_Mono_arr[0]+"--- Value:"+CC_Mono_arr[1]);
				Mo=CC_Mono_arr[1];
			}
		}
		else if(wi.contains("PendingOptionsFinal"))
		{
			String[] pending_opt_arr = wi.split("");
			WriteLog("Key: "+pending_opt_arr[0]+" ,length of current array: "+pending_opt_arr.length);
			if(pending_opt_arr.length > 1){
				WriteLog("Key:"+pending_opt_arr[0]+"--- Value:"+pending_opt_arr[1]);
				pendingOptionFinal=pending_opt_arr[1];
			}
		}
		else if(wi.contains("userEmailID"))
		{
			String[] userEmail_arr = wi.split("");
			WriteLog("Key: "+userEmail_arr[0]+" ,length of current array: "+userEmail_arr.length);
			if(userEmail_arr.length > 1){
				WriteLog("Key:"+userEmail_arr[0]+"--- Value:"+userEmail_arr[1]);
				userEmail=userEmail_arr[1];
			}
		}
	}
	WriteLog("WI_Data_arr CC_NUM :"+CC_NUM);
	WriteLog("WI_Data_arr other_CC :"+other_CC);
	WriteLog("WI_Data_arr Mo :"+Mo);
	WriteLog("WI_Data_arr pendingOptionFinal :"+pendingOptionFinal);
	
	
	//Hritik 3.3.22
	String masked_CC_No="";
	try
	{
		WriteLog("Start of masking code for credit card number"+CC_NUM);
		int start_value = 6;
		int end_value = 4;
		int masklen = CC_NUM.length() - (start_value+end_value);
		WriteLog("masklen: "+masklen);
		StringBuilder sb = new StringBuilder();
		for (int j=0; j<masklen; j++)
		{
			sb.append("X");
		}
		masked_CC_No = CC_NUM.substring(0,start_value)+ sb + CC_NUM.substring(CC_NUM.length()-end_value,CC_NUM.length());
		WriteLog("masked_CC_No: "+masked_CC_No);
	}
	
	catch(Exception e)
	{
		WriteLog("Exception in masking code"+e.getMessage());
	}
	
	String mask = "mask_cc_no"+masked_CC_No+"";
	WriteLog("mask : "+mask);
	
	
	String attrValue="";
	String att2="";
	String Att3="";
try{
	WriteLog("start of encrption, java version: "+ System.getProperty("java.version"));
	EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();
    WriteLog("start of encrption 1");
	attrValue = ed.encryptFormField(CC_NUM,sCabName);
	WriteLog("start of encrption 2");
	att2 = ed.encryptFormField(other_CC,sCabName);
	WriteLog("start of encrption 3");
	Att3 = ed.encryptFormField(Mo,sCabName);
	WriteLog("WI_Data_arr CC_NUM after en :"+CC_NUM);
    WriteLog("############");
    WriteLog("Encrypted CAtt3:"+Att3);
	WriteLog("Encrypted Crd number:"+attrValue);
	WriteLog("Encrypted Crd number att2:"+att2);
	if(!CC_NUM.equalsIgnoreCase("")){
	    CC_NUM="CCI_CrdtCN"+CC_NUM;
		attrValue = "CCI_CrdtCN"+attrValue;
	    WI_Data=WI_Data.replace(CC_NUM,attrValue);
	}
	WriteLog("Encrypted WI_Data 1:"+WI_Data);
	if(!other_CC.equalsIgnoreCase(""))
	{
		other_CC="BTD_OBC_OBCNO"+other_CC;
		att2 = "BTD_OBC_OBCNO"+att2;
		WI_Data=WI_Data.replace(other_CC,att2);
	}
	WriteLog("Encrypted WI_Data 2:"+WI_Data);
	if(!Mo.equalsIgnoreCase("")) 
	{
	    Mo="CCI_MONO"+Mo;
		Att3 = "CCI_MONO"+Att3;
	    WI_Data=WI_Data.replace(Mo,Att3);
	}
	WriteLog("Encrypted WI_Data 3:"+WI_Data);
	
    }
	catch(Exception e){
	// do nothing
		WriteLog("Exception"+e.getMessage());
	}

	
	WI_Data = WI_Data+mask;
	WriteLog("mask WI data: "+WI_Data);
	
	
	
	
	
	
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
		
		/*sSessionId=wDSession.getDMSSessionId();
		sCabName=wDSession.getEngineName();
		sJtsIp=wDSession.getJtsIp();
		iJtsPort=wDSession.getJtsPort();
		userName = wDUserInfo.getM_strUserName();*/

	WriteLog("cabinetName = "+sCabName+" : sessionId = "+sSessionId+" : jtsip = "+sJtsIp+ " : jtsport "+iJtsPort);
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
		WriteLog("Manish......---"+subProcessShortName);
	//----------------------------------------------------------------------------------------------------
	// Changed By						:	Aishwarya Gupta
	// Reason / Cause (Bug No if Any)	:	To stop multiple wi creation
	// Change Description				:	Error Handling
	//----------------------------------------------------------------------------------------------------		
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		String currentDateTimeString = formatter.format(currentDateTime);
		WriteLog("current execution time of JSP=="+currentDateTimeString);
		
		sInputXML ="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>rb_multiplewicheck</ProcName>" +						
					"<Params>'"+UserIndex+"', '"+sSessionId+"', '"+currentDateTimeString+"'</Params>" +  
					"<NoOfCols>1</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"</APProcedure2_Input>";
		
		WriteLog(sInputXML);
		//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog(sOutputXML);
		if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
		{
			bError= true;
			sMsg = "Error in performing duplicate workitem validation.";
			WriteLog("Error in performing duplicate workitem validation.");
		}
		String wicreate = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
		WriteLog("result from procedure" + wicreate);
		if(!bError)
		{
			WriteLog("bError = "+bError+" Post execution of procedure");
			if(wicreate.trim().equals("1"))
			{
				WriteLog("ProcessName=="+ProcessName.toString());
				WriteLog("subProcessShortName=="+subProcessShortName.toString());	
				if(ProcessName.toString().equalsIgnoreCase("DSR_ODC")&&subProcessShortName!=null&&!request.getParameter("subProcessShortName").toString().equals(""))
				{
				sInputXML="<?xml version=1.0?><WFGetProcessProperty_Input><Option>WFGetProcessProperty</Option><EngineName>"+sCabName+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessDefId>"+sProcessDefId+"</ProcessDefId><DataFlag></DataFlag></WFGetProcessProperty_Input>";

				WriteLog("Manish0987654----"+sInputXML);
				//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("Manish0987654----"+sOutputXML);

				objWorkListXmlResponse = new WFXmlResponse("");
				objWorkListXmlResponse.setXmlString(sOutputXML);
				objWorkList = objWorkListXmlResponse.createList("ActivityList","ActivityInfo"); 
				String sInitiateFromActivityId="";
				String sInitiateFromActivityName="";
				String sSubProcessShortName=subProcessShortName.toString()+"Work Introduction";

				
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					WriteLog("ActivityName=="+objWorkList.getVal("ActivityName").toString());
					if(sSubProcessShortName.equalsIgnoreCase(objWorkList.getVal("ActivityName").toString()))
					{
						sInitiateFromActivityName=objWorkList.getVal("ActivityName").toString();
						sInitiateFromActivityId=objWorkList.getVal("ActivityId").toString();
						WriteLog("ActivityId=="+objWorkList.getVal("ActivityId").toString());
						break;
					}
					 // DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());				  		
					  WriteLog(objWorkList.getVal("ActivityId").toString()+"======="+objWorkList.getVal("ActivityName").toString());
				}

				
				sInputXML =	"?xml version=\"1.0\"?>\n" +
					"<WFUploadWorkItem_Input>" +
					"<Option>WFUploadWorkItem</Option>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"<SessionId>"+sSessionId+"</SessionId>" +
					"<ProcessDefId>"+sProcessDefId+"</ProcessDefId>" + 
					"<InitiateFromActivityId>"+sInitiateFromActivityId+"</InitiateFromActivityId>" +
					"<InitiateFromActivityName>"+sInitiateFromActivityName+"</InitiateFromActivityName>" +
					"<Attributes>"+WDUtility.Replace(WI_Data,"'","''")+"</Attributes>" +
					"</WFUploadWorkItem_Input>";
				}
				else
				{
					sInputXML =	"?xml version=\"1.0\"?>\n" +
					"<WFUploadWorkItem_Input>" +
					"<Option>WFUploadWorkItem</Option>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"<SessionId>"+sSessionId+"</SessionId>" +
					"<ProcessDefId>"+sProcessDefId+"</ProcessDefId>" + 			
					"<Attributes>"+WDUtility.Replace(WI_Data,"'","''")+"</Attributes>" +
					"</WFUploadWorkItem_Input>";		
				}
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
						String WI_No_Created = sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>"));
						WriteLog("WI_No_Created-----------> "+WI_No_Created);
						String WI_No = "";
						int index = -1;
						for (int i = 0; i<WI_No_Created.length();i++){
							WriteLog("In loop");
							String test="";
							test=test+WI_No_Created.charAt(i);
							if(Character.isDigit(WI_No_Created.charAt(i)) && !"0".equalsIgnoreCase(test)){
								WriteLog("In loop");
								index = i;	
								break;								
								}
						}	
						String split_WI_No ="";
							if(index==-1)
							{
								 WriteLog("No non zero number found");
							}
							else
							{
								String Card = WI_No_Created.substring(index);
								String Card_No[] = Card.split("-");
								split_WI_No = Card_No[0];
								WriteLog("split_WI_No----->"+split_WI_No);
							}
						sMsg=sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>")) + " Created.";
					//Mail TRIGGER by Aditya.rai  --Start 
						WriteLog("Inside mailTrigger method-----------> ");
						LocalDate today =LocalDate.now();
						LocalDate incrementedDate=today.plusDays(2);
						WriteLog("WIIntroduction jsp: incrementedDate ---=: "+incrementedDate);
						String strDate = incrementedDate.toString();
						WriteLog("WIIntroduction jsp: strDate ---=: "+strDate);
						String splitDate[] = strDate.split("-");
						String year = splitDate[0];
						String month = splitDate[1];
						String day = splitDate[2];
						strDate = day+"/"+month+"/"+year;
						//SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
						//DateTimeFormatter formatter=DateTimeFormatter.forPattern("dd/MM/yyyy");
						//String formattedIncrementedDate=incrementedDate.format(formatter);
						//declare all variable
						String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", request.getParameter("ProcessCode"), 1000, true) );
						String ProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
						WriteLog("WIIntroduction jsp: ProcessCode    =: "+ProcessCode);
						if(ProcessCode.equals("DSR_ODC") || ProcessCode.equals("DSR_MR"))
						{
							String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Amount", request.getParameter("Amount"), 1000, true) );
							String Amount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
							WriteLog("WIIntroduction jsp: Amount    =: "+Amount);
							String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Mobile_No", request.getParameter("Mobile_No"), 1000, true) );
							String Mobile_No = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
							WriteLog("WIIntroduction jsp: Mobile_No    =: "+Mobile_No);
							String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Card_No", request.getParameter("Card_No"), 1000, true) );
							String Card_No = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
							WriteLog("WIIntroduction jsp: Card_No    =: "+Card_No);
							String loggedInUser = wDSession.getM_objUserInfo().getM_strUserName();
							WriteLog("WIIntroduction jsp: loggedInUser    =: "+loggedInUser);
							String argument = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("args", request.getParameter("args"), 1000, true) );
							String stage = ESAPI.encoder().encodeForSQL(new OracleCodec(), argument!=null?argument:"");
							WriteLog("WIIntroduction jsp: stage    =: "+stage);
							String lastDigitCard_No = Card_No;
							String sProcessName = "";
							if(ProcessCode.equalsIgnoreCase("DSR_ODC"))
							{
							String subprocessname = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("subprocess", request.getParameter("subprocess"), 1000, true) );
							sProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), subprocessname!=null?subprocessname:"");
							WriteLog("WIIntroduction jsp: subprocessname    =: "+sProcessName);
							}
							String tag = "";
							if(ProcessCode.equalsIgnoreCase("DSR_ODC"))
							{
							//String input99 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("pendingfor", request.getParameter("pendingfor"), 1000, true) );
							//String PendingSubReason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input99!=null?input99:"");
							//PendingSubReason = PendingSubReason.replaceAll("&#x40;","@");
							//WriteLog("WIIntroduction jsp: PendingSubReason    =: "+PendingSubReason);
							String splitReason[] = pendingOptionFinal.split("@");
							int size = splitReason.length;
							WriteLog("WIIntroduction jsp: size    =: "+size);
							for(int i = 0; i<size; i++) {
							String reason = (String) splitReason[i];
							WriteLog("WIIntroduction jsp: reason    =: "+reason);
							tag = tag+"<p class=MsoListParagraphCxSpFirst align=center style=\"margin-bottom:0in;text-align:center;text-indent:-.25in;line-height:normal\"><span style=\"font-size:10.0pt;font-family:Symbol\">·<span style=\"font:7.0pt \"Times New Roman\"\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span><span style=\"font-size:10.0pt;font-family:\"Verdana\",sans-serif\">"+reason+"</span></p>"+"\n"; 
							}
							}
							String getTemplateQuery = "";
							//end  
							processDefIdParams="ProcessName=="+ProcessCode;
							if(ProcessCode.equalsIgnoreCase("DSR_ODC"))
							{
								getTemplateQuery="Select * From USR_0_CSR_BT_TemplateMapping where ProcessName = :ProcessName and TemplateType = '"+stage+"' and SubProcess = '"+sProcessName+"'" ;
							}
							else
							{
								getTemplateQuery="Select * From USR_0_CSR_BT_TemplateMapping where ProcessName = :ProcessName and TemplateType = '"+stage+"'";
							}
							sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + getTemplateQuery + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId><Params>" + processDefIdParams + "</Params></APSelectWithNamedParam_Input>";
							WriteLog("getTemplateQuery: "+sInputXML);
							sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
							WriteLog("getTemplateQuery output: "+sOutputXML);
							XMLParser queryParseData=new XMLParser();
							queryParseData.setInputXML(sOutputXML);
							maincode = queryParseData.getValueOf("MainCode");
							WriteLog("maincode: "+maincode);
							subXML="";
							String mailFrom = "";
							String emailBody = "";
							String mailSubject = "";
							String txtMessage = "";
							XMLParser objParserXml = null;
							if(maincode.equals("0"))
							{
								subXML = queryParseData.getNextValueOf("Record");
								objParserXml = new XMLParser(subXML);
								WriteLog("objXmlParser--------------->" + objParserXml);
								mailFrom = objParserXml.getValueOf("frommail");
								emailBody = objParserXml.getValueOf("mailtemplate");
								mailSubject = objParserXml.getValueOf("mailsubject");
								txtMessage = objParserXml.getValueOf("Smstxttemplate");
							}else{
								bError= true;
								sMsg = "Could Not Fetch Process Definition.";
							}
							if(ProcessCode.equalsIgnoreCase("DSR_ODC") && stage.equalsIgnoreCase("Pending") && (sProcessName.equalsIgnoreCase("RE-ISSUE OF PIN") || sProcessName.equalsIgnoreCase("EARLY CARD RENEWAL")))
							{
								WriteLog("No mail for this case");
							}
							else
							{
							emailBody = emailBody.replaceAll("#WI_No#",split_WI_No);
							emailBody = emailBody.replaceAll("#Amount#", Amount);
							emailBody = emailBody.replaceAll("#Card_No#", lastDigitCard_No);
							emailBody = emailBody.replaceAll("'", "''");
							emailBody = emailBody.replaceAll("#DD/MM/YYYY#", strDate);
							emailBody = emailBody.replaceAll("#SLA_TAT#", "3");
							if(ProcessCode.equalsIgnoreCase("DSR_ODC"))
							{
								emailBody = emailBody.replaceAll("#Sub_Process_Name#", sProcessName);
								emailBody = emailBody.replaceAll("#reject reason#", tag);
							}
							if(ProcessCode.equalsIgnoreCase("DSR_MR"))
							{
								emailBody = emailBody.replaceAll("#SLA_TAT#", "3");
							}
							WriteLog("emailBody after replace" + emailBody);
							String mailTo = userEmail;
							WriteLog("Mail Subject------>"+mailSubject);
							String mailContentType = "text/html;charset=UTF-8";
							int mailPriority = 1;
							int workitemId = 1;
							int noOfTrials = 1;
							int activityId = 3;
							String mailStatus = "N";
							String mailActionType = "TRIGGER";
							String tableName = "WFMAILQUEUETABLE";
							String columnName = "mailFrom,mailTo,mailCC,mailBCC,mailSubject,mailMessage,mailContentType,attachmentISINDEX,attachmentNames,attachmentExts,mailPriority,mailStatus,statusComments,lockedBy,successTime,LastLockTime,insertedBy,mailActionType,insertedTime,processDefId,processInstanceId,workitemId,activityId,noOfTrials,zipFlag,zipName,maxZipSize,alternateMessage";
							String values = "'" + mailFrom + "','" + mailTo + "',NULL,NULL,'" + mailSubject + "',N'" + emailBody + "','" + mailContentType+ "',NULL,NULL,NULL," + mailPriority + ",'" + mailStatus + "',NULL,NULL,NULL,NULL,'" + loggedInUser + "','" + mailActionType + "',getDate(),'"+ sProcessDefId+ "','"+ WI_No_Created + "'," + workitemId + "," + activityId + ","+ noOfTrials+",NULL,NULL,NULL,NULL";
								WriteLog("ProcessCode--"+ProcessCode);
								WriteLog("stage--"+stage);
							if(ProcessCode.equalsIgnoreCase("DSR_MR") && stage.equalsIgnoreCase("Pending"))
							{
								WriteLog("ProcessCode--"+ProcessCode);
								WriteLog("stage--"+stage);
							}
							else
							{
								WriteLog("ProcessCode--"+ProcessCode);
								WriteLog("stage--"+stage);
							
							String inputData="<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>"+tableName+"</TableName>" +
							"<ColName>"+columnName+"</ColName>" +
							"<Values>"+values+"</Values>" +
							"<EngineName>"+sCabName+"</EngineName>" +
							"<SessionId>"+sSessionId+"</SessionId>" +
							"</APInsert_Input>";
							String OutputData= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
							XMLParser parsDataXML=new XMLParser();
							parsDataXML.setInputXML(OutputData);
							WriteLog("Mail output Data for insertion in WFMAILQUEUETABLE : ---- "+OutputData);
							String mainCodeInsert = parsDataXML.getValueOf("MainCode");
							WriteLog("maincode: "+mainCodeInsert);
							if(mainCodeInsert.equals("0")){
								WriteLog("Mail Triggred successfuly");
							}
							else{
								WriteLog("Some ERROR in Mail Triggred");
							}
							}
						}
						//SMS trigger
							WriteLog("inside sendSMScall txtMessagessss");
							String smsLang = "EN";
							if(ProcessCode.equalsIgnoreCase("DSR_ODC") && stage.equalsIgnoreCase("Pending") && (sProcessName.equalsIgnoreCase("RE-ISSUE OF PIN") || sProcessName.equalsIgnoreCase("EARLY CARD RENEWAL")))
							{
								WriteLog("No SMS for this case");
							}
							else
							{
							WriteLog("inside sendSMScall Card_No :" + Card_No);
							txtMessage = txtMessage.replaceAll("#WI_No#", split_WI_No);
							txtMessage = txtMessage.replaceAll("#Amount#", Amount);
							txtMessage = txtMessage.replaceAll("#Card_No#", lastDigitCard_No);
							txtMessage = txtMessage.replaceAll("#DD/MM/YYYY#", strDate);
							txtMessage = txtMessage.replaceAll("#SLA_TAT#", "3");
							if(ProcessCode.equalsIgnoreCase("DSR_ODC"))
							{
								txtMessage = txtMessage.replaceAll("#Sub_Process_Name#", sProcessName);
							}
							if(ProcessCode.equalsIgnoreCase("DSR_MR"))
							{
								txtMessage = txtMessage.replaceAll("#SLA_TAT#", "3");
							}
							WriteLog("txtMessage after replace" + txtMessage);
							String tableName = "NG_RLOS_SMSQUEUETABLE";
							String ALERT_Name = stage;
							String Alert_Code = ProcessName;
							String Alert_Status = "P";
							String Workstep_Name = ProcessName+"_Intitation";
							String columnName = "ALERT_Name, Alert_Code, Alert_Status, Mobile_No, Alert_Text, WI_Name, Workstep_Name, Inserted_Date_time";
							String values = "'" + ALERT_Name + "','" + Alert_Code + "','" + Alert_Status + "','" + Mobile_No + "','" + txtMessage+ "','" + WI_No_Created + "','" + Workstep_Name + "', getdate()";
							String inputData="<?xml version=\"1.0\"?>" +
										"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>"+tableName+"</TableName>" +
										"<ColName>"+columnName+"</ColName>" +
										"<Values>"+values+"</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
										"</APInsert_Input>";
							String SMSInsertOutputData= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
							WriteLog("output of insertion into MailQueueTable-->"+SMSInsertOutputData);
							XMLParser SMSParsData=new XMLParser();
							SMSParsData.setInputXML(SMSInsertOutputData);
							maincode = SMSParsData.getValueOf("MainCode");
							WriteLog("maincode: "+maincode);
							if(maincode.equals("0")){
								WriteLog("SMS Triggred successfuly");
							}
							else{
								WriteLog("Some ERROR in SMS Triggred");
							}
							}
						}	
					}
				}
				else
					sMsg = "Request cannot be processed at this time as last request is already in progress";
			}			
	}
}
out.clear();
out.print(sMsg);
%>


