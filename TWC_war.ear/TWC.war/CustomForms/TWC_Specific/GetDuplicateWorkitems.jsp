<%@ include file="Log.process"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%
    String outputData="";
	String inputData="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	try{
		logger.info("\nInside GetDuplicateWorkitem.jsp\n");
		String wi_name = request.getParameter("WI_NAME");
		if (wi_name != null) {wi_name=wi_name.replace("'","");}
		String WSNAME = request.getParameter("WSNAME");	
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
		String TLNumber=request.getParameter("TLNumber");
		if (TLNumber != null) {TLNumber=TLNumber.replace("'","");}
		//Modified on 22/02/2019 as Sales_Attach_Doc Workstep has been removed
		//String Dec_SalesAttachDoc=request.getParameter("Dec_SalesAttachDoc");
		String Dec_CreditAnalyst=request.getParameter("Dec_CreditAnalyst");
		if (Dec_CreditAnalyst != null) {Dec_CreditAnalyst=Dec_CreditAnalyst.replace("'","");}
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String IntroductionDateTime = "";
		String intoducedBy = "";
		String SOLID = "";
		String Query="";
		String WI_NAME="";
		String params = "WI_NAME=="+wi_name;
		String temp_table="<table id='Duplicate_Workitems_Grid' width='100%' border=1><TBODY><tr width=100% class='EWLabelRB2' bgcolor= '#990033'><td colspan=4 align=center class='EWLabelRB2'><font color='white' size='4'>Duplicate Work-items</font></td></tr>";
		
		temp_table=temp_table+"<tr class='EWNormalGreenGeneral1'><th bgcolor= '#990033'><font color='white'>Work-item Number</font></th><th bgcolor= '#990033'><font color='white'>Initiated Date</font></th><th bgcolor= '#990033'><font color='white'>Initiated By</font></th><th bgcolor= '#990033'><font color='white'>SOL ID</font></th></tr>";
		
		logger.info("\nInside GetDuplicateWorkitem for wi_name "+wi_name);
		logger.info("\nWSNAME: "+WSNAME);
		//Modified on 22/02/2019 as Sales_Attach_Doc Workstep has been removed
		//logger.info("\nDec_SalesAttachDoc: "+Dec_SalesAttachDoc);
		logger.info("\nDec_CreditAnalyst: "+Dec_CreditAnalyst);
		
		//Modified on 22/02/2019 as Sales_Attach_Doc Workstep has been removed
		/*if(WSNAME.equals("Sales_Attach_Doc")&&(Dec_SalesAttachDoc.trim().equals("")||Dec_SalesAttachDoc.trim().equals("null")))
		{
			Query="SELECT DISTINCT A.WI_NAME,A.intoducedAt as IntroductionDateAndTime ,A.intoducedBy,A.Sol_Id as SOLID FROM RB_TWC_EXTTABLE A,USR_0_TWC_WIHISTORY B "+
			"WHERE A.WI_NAME=B.winame AND ((B.wsname='Exit' AND datediff(DAY,B.entrydatetime,getdate())<90) OR (B.wsname='Reject' AND datediff(YEAR,B.entrydatetime,getdate())<5) OR (B.wsname!='Exit' AND B.wsname!='Reject' AND A.TL_Number='"+TLNumber+"')) AND A.WI_NAME!=:WI_NAME ";
		
		}*/
		if(WSNAME.equals("Credit_Analyst"))
		{
			Query="SELECT DISTINCT A.WI_NAME,A.intoducedAt as IntroductionDateAndTime ,A.intoducedBy,A.Sol_Id as SOLID FROM RB_TWC_EXTTABLE A,USR_0_TWC_WIHISTORY B "+
			"WHERE A.WI_NAME=B.winame AND ((B.wsname='Exit' AND datediff(YEAR,B.entrydatetime,getdate())<5) OR (B.wsname='Reject' AND datediff(YEAR,B.entrydatetime,getdate())<5) OR (B.wsname!='Exit' AND B.wsname!='Reject' AND A.TL_Number='"+TLNumber+"')) AND A.WI_NAME!=:WI_NAME ";
		
		}
		else
		{
			Query="SELECT DUPLICATEWI_NAME AS WI_NAME ,IntroductionDateAndTime,intoducedBy,SOLID from USR_0_TWC_DUPLICATEWORKITEMS WITH (nolock) where WI_NAME=:WI_NAME";
		}
		
		inputData = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ Query + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
				
		logger.info("Query For GetDuplicateWorkitem Input for wi_name: "+wi_name+" -->"+inputData);		
		outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		logger.info("GetDuplicateWorkitem Output for wi_name: "+wi_name+" -->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");	
		int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		if(maincode.equals("0") && recordcount>0)
		{	
			objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{ 
					WI_NAME = objWorkList.getVal("WI_NAME");
					IntroductionDateTime = objWorkList.getVal("IntroductionDateAndTime");
					intoducedBy = objWorkList.getVal("intoducedBy");
					SOLID = objWorkList.getVal("SOLID");
					//logger.info("WI_NAME Is-->"+WI_NAME);
					//logger.info("IntroducedAt	-->"+IntroductionDateTime);
					//logger.info("intoducedBy-->"+intoducedBy);
					//logger.info("SOLID-->"+SOLID);
					temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'><td>"+WI_NAME+"</td><td>"+IntroductionDateTime+"</td><td>"+intoducedBy+"</td><td>"+SOLID+"</td></tr>";
				}
				temp_table=temp_table+"</TBODY></TABLE>";
				logger.info("Final Return Result "+temp_table);
				out.clear();
				//out.println(temp_table+"~"+"0");
				out.println(temp_table);
		}
		else if(maincode.equals("0") && recordcount==0)
		{
			out.clear();
			out.println("");
		}
		else
		{
			out.clear();
			out.println("-1");
		}
					
	}
	catch(Exception e)
	{
		e.printStackTrace();
		logger.info("Exception in getting duplicate workitem list "+e);
		out.clear();
		out.println("-1");
	}
%>