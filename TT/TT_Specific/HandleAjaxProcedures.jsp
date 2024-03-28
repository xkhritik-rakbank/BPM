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
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%	
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 100000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("reqType_Esapi Request.getparameter---> "+request.getParameter("reqType"));
			WriteLog("reqType_Esapi Esapi---> "+reqType_Esapi);
			reqType_Esapi = reqType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkitemName"), 100000, true) );
			String WorkitemName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WorkitemName_Esapi Request.getparameter---> "+request.getParameter("WorkitemName"));
			WriteLog("WorkitemName_Esapi Esapi---> "+WorkitemName_Esapi);
			WorkitemName_Esapi = WorkitemName_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("remit_amt_curr"), 100000, true) );
			String remit_amt_curr_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("remit_amt_curr_Esapi Request.getparameter---> "+request.getParameter("remit_amt_curr"));
			WriteLog("remit_amt_curr_Esapi Esapi---> "+remit_amt_curr_Esapi);
			remit_amt_curr_Esapi = remit_amt_curr_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("seg"), 100000, true) );
			String seg_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("seg_Esapi Request.getparameter---> "+request.getParameter("seg"));
			WriteLog("seg_Esapi Esapi---> "+seg_Esapi);
			seg_Esapi = seg_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("scanDateTime"), 100000, true) );
			String scanDateTime_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("scanDateTime_Esapi Request.getparameter---> "+request.getParameter("scanDateTime"));
			WriteLog("scanDateTime_Esapi Esapi---> "+scanDateTime_Esapi);
			scanDateTime_Esapi = scanDateTime_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_Checklist"), 100000, true) );
			String H_Checklist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("H_Checklist_Esapi Request.getparameter---> "+request.getParameter("H_Checklist"));
			WriteLog("H_Checklist_Esapi Esapi---> "+H_Checklist_Esapi);
			H_Checklist_Esapi = H_Checklist_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			/*String H_Checklist_Esapi = request.getParameter("H_Checklist");
			String seg_Esapi = request.getParameter("seg");
			String reqType_Esapi = request.getParameter("reqType");
			String WorkitemName_Esapi = request.getParameter("WorkitemName");
			String remit_amt_curr_Esapi = request.getParameter("remit_amt_curr");
			String scanDateTime_Esapi = request.getParameter("scanDateTime");*/
			
			WriteLog("H_Checklist_Esapi Request.getparameter---> "+H_Checklist_Esapi);
			WriteLog("seg_Esapi Request.getparameter---> "+seg_Esapi);
			WriteLog("reqType_Esapi Request.getparameter---> "+reqType_Esapi);
			WriteLog("WorkitemName_Esapi Request.getparameter---> "+WorkitemName_Esapi);
			WriteLog("remit_amt_curr_Esapi Request.getparameter---> "+remit_amt_curr_Esapi);
			WriteLog("scanDateTime_Esapi Request.getparameter---> "+scanDateTime_Esapi);
			
	WriteLog("Inside check exception raised.jsp");
	
	String sInputXML="";
	String sOutputXML="";
	String reqType = reqType_Esapi;
	
	
	//Extra String declared which can be required according to the request
	String WorkitemName = "";
	String remit_amt_curr ="";
	String seg = "";
	String scanDateTime = "";
	
	WriteLog("reqType: "+reqType);
	if (reqType.equals("TT_ISExceptionRaised"))
	{
	H_Checklist_Esapi= H_Checklist_Esapi.replace("[hash]","#");
		WorkitemName = WorkitemName_Esapi;
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"TT_ISExceptionRaised"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+H_Checklist_Esapi+"'"+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionID>" +
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>" +
				"</APProcedure2_Input>";
			
			WriteLog("sInputXML: TT_IsException"+sInputXML);
		//	sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
			
			WriteLog("sOutputXML: "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	else if (reqType.equals("TT_ISExceptionRaisedDesc"))
	{
	H_Checklist_Esapi= H_Checklist_Esapi.replace("[hash]","#");
		WorkitemName = WorkitemName_Esapi;
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"TT_ISExceptionRaisedDesc"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+H_Checklist_Esapi+"'"+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionID>" +
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>" +
				"</APProcedure2_Input>";

			WriteLog("sInputXML: TT_ISExceptionRaisedDesc"+sInputXML);
			//sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
			
			WriteLog("sOutputXML: "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	else if (reqType.equals("TT_ISExcepSystemRaised"))
	{
		WorkitemName = WorkitemName_Esapi;
		H_Checklist_Esapi= H_Checklist_Esapi.replace("[hash]","#");
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"TT_ISExcepSystemRaised"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+H_Checklist_Esapi+"'"+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionID>" +
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>" +
				"</APProcedure2_Input>";

			WriteLog("sInputXML: TT_ISExcepSystemRaised"+sInputXML);
			//sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
			
			WriteLog("sOutputXML: "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	else if (reqType.equals("Sign_excep"))
	{
		WorkitemName = WorkitemName_Esapi;
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"sign_approve"+"</ProcName>"+
				
				"<Params>"+"'"+WorkitemName+"'"+"</Params>" +
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionID>" +
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>" +
				"</APProcedure2_Input>";

			WriteLog("sInputXML: sign_approve"+sInputXML);
			//sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
			
			WriteLog("sOutputXML: sign_approve"+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	else if (reqType.equals("GetCutOfftime"))
	{
		WorkitemName = WorkitemName_Esapi;
		remit_amt_curr = remit_amt_curr_Esapi;
		seg = seg_Esapi;
		scanDateTime = scanDateTime_Esapi;
		
		try
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"TT_GetCutOffTime"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+remit_amt_curr+"','"+seg+"','"+scanDateTime+"'"+"</Params>" +
				"<NoOfCols>3</NoOfCols>" +
				"<SessionID>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionID>" +
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>" +
				"</APProcedure2_Input>";

			WriteLog("sInputXML: GetCutOfftime"+sInputXML);
			//sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
			
			WriteLog("sOutputXML: "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				out.clear();				
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>") + 9, sOutputXML.indexOf("</Results>"));
				if (sOutputXML.contains("."))				
					sOutputXML =  sOutputXML.replace(".", "");
				WriteLog("sOutputXML: after updation "+sOutputXML);
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
		
	
	
				
%>				
	