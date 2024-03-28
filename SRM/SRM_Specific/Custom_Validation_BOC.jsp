<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : Custom_Validation_BOC.jsp
//Author                     : Deepti Sharma, Ravinder Partap
// Date written (DD/MM/YYYY) : 03-July-2014
//Description                : Custom server side Validations. Any server side validation can be 
							   added in the file later for subsequent requests
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>


<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>


<%
String qry="";
String inputData2="";
String outputData2="";
String mainCodeValue2="";
XMLParser xmlParserData=null;
XMLParser objXmlParser=null;
String tempBlock="";
String permBlock="";
String typeOfBlock="";
String subXML="";
String params="";
int counter2=0;
int recordcount2=0;
String CARDSTATUS=request.getParameter("cardStatus");
//String tr_table = request.getParameter("tr_table");
//WriteLog("tr_table"+tr_table);
//String WINAME=request.getParameter("WINAME");
	//qry="select TEMPORARY,PERMANENT,TYPEOFBLOCK from USR_0_SRM_BOC_CARDS_STATUS where ISACTIVE='Y' and CARDSTATUS='"+CARDSTATUS+"'";
	
	qry="select TEMPORARY,PERMANENT,TYPEOFBLOCK from USR_0_SRM_BOC_CARDS_STATUS with (nolock) where ISACTIVE='Y' and CARDSTATUS=:CARDSTATUS";
	params="CARDSTATUS=="+CARDSTATUS;


	/*inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + qry + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	inputData2 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ qry + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		
		
	//WriteLog("inputData2 BOC"+inputData2);	
	outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	//WriteLog("outputData2 BOC-->"+outputData2);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData2));
	mainCodeValue2 = xmlParserData.getValueOf("MainCode");
	if(mainCodeValue2.equals("0"))
	{	recordcount2 = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		//WriteLog("Number of records are "+recordcount2);
		tempBlock = xmlParserData.getValueOf("TEMPORARY");
		permBlock = xmlParserData.getValueOf("PERMANENT");
		typeOfBlock = xmlParserData.getValueOf("TYPEOFBLOCK");
		
		
		/*for(int k=0; k<recordcount2; k++)
		{	
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			//out.println("Approved_Cash_Back_Amount"+Approved_Cash_Back_Amount);
			//out.println("objXmlParser.getValueOf('Approved_Cash_Back_Amount')="+objXmlParser.getValueOf("Approved_Cash_Back_Amount"));	
			Approved_Cash_Back_Amount+= Integer.parseInt(objXmlParser.getValueOf("Approved_Cash_Back_Amount"));
				
		}
		*/
	}	
	else
	{ out.println("mainCodeValue2="+mainCodeValue2);
	}
	out.clear();
	out.println(tempBlock+"~"+permBlock+"~"+typeOfBlock);
	
%>

	