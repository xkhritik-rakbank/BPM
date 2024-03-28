<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%
		String Query2 = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		WFCustomXmlResponse objWFCustomXmlResponse=null;
		String inputXMLstate="";
		String outputXMLstate= "";
		String subXML="";
		String params="";
		String state_search="";
		String returnValue = "";
		String mainCodeValuestate = "";
		WriteLog("Inside load CIF Related Details.jsp");
		//String wiName=request.getParameter("WINAME");
		String CIF_ID=request.getParameter("CIF_ID");
		//String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 100000, true) );
		//String wiName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("CIF ID : "+CIF_ID);
		
		String[] colNames = {"WI_NAME","TL_Number","createdat"};
		
		Query2 = "SELECT WI_NAME,TL_Number,createdat FROM RB_TWC_EXTTABLE with (nolock) WHERE CIF_Id=:CIF_ID order by IntoducedAt asc";
		params="CIF_ID=="+CIF_ID;
		WriteLog("Query2");
		WriteLog("params"+params);
		
		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput Xml For Get WI Data for CIF_ID: "+CIF_ID+" -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		WriteLog("Output Xml For Get WI Data for CIF_ID: "+CIF_ID+" ---- "+outputXMLstate);
		
		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		String recordsArray="";
		String tempRowvalues="";
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		WriteLog("Total Record ---- "+totalRecord);
		
		if(mainCodeValuestate.equals("0")&&totalRecord>0)
		{
			objWorkList = xmlParserData.createList("Records","Record");
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
				if(tempRowvalues!="")
				tempRowvalues=tempRowvalues+"@@@";
				int newRow=1;
				subXML = objWorkList.getVal("Record");
				objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
				WriteLog("colNames ---- "+colNames.length);
				for(int i=0;i<colNames.length;i++)
				{
					if(tempRowvalues=="")
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==1)
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==0)
					{
						tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNames[i]);
						newRow=0;
					}
				}
								
			}
			WriteLog("temp CIF Rowvalues -- "+tempRowvalues);
			out.clear();
			out.print(tempRowvalues);
		}	
		else if(mainCodeValuestate.equals("0")&&totalRecord==0)
		{
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
		
%>