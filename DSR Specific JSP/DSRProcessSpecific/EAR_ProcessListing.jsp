<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<HTML>
<HEAD>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	<link rel="StyleSheet" href="webdesktop/webtop/css/dtree.css" type="text/css" />
	<script type="text/javascript" src="/webdesktop/webtop/scripts/dtree.js"></script>
</HEAD>

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onkeydown='checkShortcut()'>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

	function clearFrames()
	{
		try
		{
			window.parent.frames['frmData'].document.location.href="EAR_blank_withLogo.jsp";
			window.parent.frames['frameProcess'].document.location.href="DSR_blank.jsp";
			window.parent.frames['frameClose'].document.location.href="DSR_blank.jsp";
		}
		catch(e)
		{
			alert(e.message);
		}
	}

	function active(objLink)
	{
		list=document.getElementById('ProcessList').getElementsByTagName('a');;

		for(i=0;i<list.length;i++)
		{
			list[i].style.color='#990033';
		}

		objLink.style.color='blue';
	}

</script>

		
<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
	boolean bError=false;
	
	try
	{
		sCabname=wfsession.getEngineName();
		sSessionId = wfsession.getSessionId();
		sJtsIp = wfsession.getJtsIp();
		iJtsPort = wfsession.getJtsPort();
	}
	catch(Exception ignore)
	{
		bError=true;
		WriteLog(ignore.toString());
	}	
	if (bError)
	{
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();");
		out.println("</script>");
	}
	try
	{
		String sInputXML =	"?xml version=\"1.0\"?>\n" +
		"<NGOGetUserProperty_Input>\n" +
		"<Option>NGOGetUserProperty</Option>\n" +
		"<CabinetName>"+sCabname+"</CabinetName>" +
		"<UserDBId>"+sSessionId+"</UserDBId>" +	
		"<UserIndex>"+wfsession.getUserIndex()+"</UserIndex>\n" +
		"</NGOGetUserProperty_Input>\n";

		String sOutputXML="";
		try
		{
			sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXML);
		}
		catch(Exception exp)
		{
			WriteLog(sOutputXML);
		}
		if (sOutputXML.indexOf("Invalid session.")!=-1)
		{
			out.println("<script>");
			out.println("alert('User session has been expired. Please re-login.');");
			out.println("window.parent.close();");
			out.println("</script>");
		}
		try
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Comment>")+9 , sOutputXML.indexOf("</Comment>"));
			WriteLog(sOutputXML);
		}
		catch(Exception ex)
		{
			WriteLog("Comment"+ex.toString());
		}
		if (sOutputXML.equals("") || sOutputXML.equals("Not Defined") || sOutputXML.equals("SupervisorUser"))
		{
			out.println("<script>");
			out.println("alert('User does not have access of any branch. User can not initiate request. Please contact your system administrator.');");
			out.println("window.parent.close();");
			out.println("</script>");
		}

		sInputXML ="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>RB_GetProcessDetails</ProcName>" +						
					"<Params> </Params>" + 
					"<NoOfCols>2</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
		WriteLog("RB_GetProcessDetails : "+sInputXML);
		String sOutputXMLProcessList ="";
		try
		{
			sOutputXMLProcessList= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			if(sOutputXMLProcessList.equals("") || Integer.parseInt(sOutputXMLProcessList.substring(sOutputXMLProcessList.indexOf("<MainCode>")+10 , sOutputXMLProcessList.indexOf("</MainCode>")))!=0)
			{
				bError= true;
			}
		}
		catch(Exception exp)
		{
			bError=true;
		}
		sOutputXMLProcessList = sOutputXMLProcessList.substring(sOutputXMLProcessList.indexOf("<Results>")+9,sOutputXMLProcessList.indexOf("</Results>"));

		WriteLog("sOutputXMLProcessList : "+sOutputXMLProcessList);
		
		if (sOutputXMLProcessList.equals("")){
			out.println("<script>");
			out.println("alert('No process has found in RB_Process_Details table.');");
			out.println("window.parent.close();");
			out.println("</script>");
		}


		sInputXML ="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>RB_GetBranchDetails</ProcName>" +						
					"<Params> </Params>" +
					"<NoOfCols>4</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
		String sOutputXMLBranchList ="";
		try
		{
			sOutputXMLBranchList= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXMLBranchList);
			if(sOutputXMLBranchList.equals("") || Integer.parseInt(sOutputXMLBranchList.substring(sOutputXMLBranchList.indexOf("<MainCode>")+10 , sOutputXMLBranchList.indexOf("</MainCode>")))!=0)	{
				bError= true;
			}
		}
		catch(Exception exp)
		{
			bError=true;
		}

		sOutputXMLBranchList = sOutputXMLBranchList.substring(sOutputXMLBranchList.indexOf("<Results>")+9,sOutputXMLBranchList.indexOf("</Results>"));

		sInputXML="<?xml version=\"1.0\"?>\n" +
		"<WMGetQueueList_Input>\n" +
		"<Option>WMGetQueueList</Option>\n" +
		"<EngineName>"+sCabname+"</EngineName>\n" +
		"<SessionId>" + sSessionId + "</SessionId>\n" +
		"<Filter>\n" +
		"<QueueAssociation>2</QueueAssociation>\n" +
		"<Filter>"+
		"</Filter>\n" +
		"<BatchInfo>\n" +
		"</BatchInfo>\n" +
		"<DataFlag>N</DataFlag>\n" +
		"</WMGetQueueList_Input>";

		String sOutputXMLQueueList="";
		try
		{
			sOutputXMLQueueList = WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXMLQueueList);
			if(sOutputXMLQueueList.equals("") || Integer.parseInt(sOutputXMLQueueList.substring(sOutputXMLQueueList.indexOf("<MainCode>")+10 , sOutputXMLQueueList.indexOf("</MainCode>")))!=0)
			{
				bError= true;
			}
		}
		catch(Exception exp)
		{
			WriteLog("Exception : "+exp.toString());
		}
		if(sOutputXMLQueueList.indexOf("<MainCode>18</MainCode>") != -1)
		{
			WriteLog("No Record Found.");
			out.println("<script>");
			out.println("alert('User doesn't have rights on any queue. Please contact your system administrator.');");
			out.println("window.parent.close();");
			out.println("</script>");

		}
		
		String strSeparator="", noOfKeys="", noOfSubKeys="";
		String[] arrQueue=null; 
		String[] SubQueueArr=null;  
		String strFilePath=request.getRealPath(request.getServletPath()); 
		strFilePath = strFilePath.substring(0,strFilePath.lastIndexOf("\\"));
		try
		{
			Properties properties = new Properties();
			properties.load(new FileInputStream(strFilePath + "\\EAR_RB.properties"));
			strSeparator = properties.getProperty("Separator");
			noOfKeys = properties.getProperty("NoOfQueues");
			arrQueue = new String[Integer.parseInt(noOfKeys)];
			for (int i=0; i<Integer.parseInt(noOfKeys); i++)
			{
				arrQueue[i] = properties.getProperty("Queue"+(i+1));
			}

			noOfSubKeys = properties.getProperty("NoOfSubQueues");
			SubQueueArr = new String[Integer.parseInt(noOfSubKeys)];
			for (int i=0; i<Integer.parseInt(noOfSubKeys); i++)
			{
				SubQueueArr[i] = properties.getProperty("SubQueue"+(i+1));
			}
		}
		catch(Exception e)
		{
			WriteLog("Exception while using properties file : "+e.toString());
		}
		String strProcessNameCodeList=""; 
		String sArrayTemp[]= new String[Integer.parseInt(noOfKeys)];
		try
		{
			WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXMLQueueList);
			WFXmlList RecordList;
			String sType="";

			for (RecordList =  xmlResponse.createList("QueueList", "QueueInfo");RecordList.hasMoreElements();)
			{
				for (int i=0; i<Integer.parseInt(noOfKeys); i++)
				{
					if(arrQueue[i].toUpperCase().equals(RecordList.getVal("Name").toUpperCase()))
					{
						String strProcessName=null;
						String strProcessCode=null;
						int pos1=0,pos2=0;
						
						strProcessCode = arrQueue[i].substring(0,arrQueue[i].indexOf("_",arrQueue[i].indexOf("_")+1));

						pos1 = sOutputXMLProcessList.indexOf(strProcessCode+"!")+(strProcessCode+"!").length();
						pos2 = sOutputXMLProcessList.indexOf("~",pos1+1);
						if (pos2==-1)
						{
							pos2 = sOutputXMLProcessList.length();
						}
						strProcessName = sOutputXMLProcessList.substring(pos1,pos2);
						if(strProcessNameCodeList.equals(""))
						{
							strProcessNameCodeList = strProcessCode+";"+strProcessName;
						}
						else
						{
							strProcessNameCodeList = strProcessNameCodeList +";"+ strProcessCode+";"+strProcessName;
						}
						sArrayTemp[i]=strProcessCode+";"+strProcessName;
					}
				}
				
				RecordList.skip();
			}
		}
		catch(Exception ex)
		{
				WriteLog("Exception : "+ex.toString());
		}

		strProcessNameCodeList=strProcessNameCodeList+";";
		String slatest= new String();
		for (int i=0; i<Integer.parseInt(noOfKeys); i++)
		{
			if(sArrayTemp[i]!=null)
			{
				if(slatest.equals(""))
				{
					slatest= sArrayTemp[i];
				}
				else
				{
					slatest = slatest+";"+ sArrayTemp[i];
				}
			}
		}

		String strProcessNameCodeListBackup=strProcessNameCodeList;
		strProcessNameCodeList=slatest+";";

		StringTokenizer  st = new StringTokenizer(sOutputXML, "~");
		String strBranchCode="",strBranchName="";
		String strProcessCode="",strProcessName="";
		String strCSMMailId="",strBMailId="";
	
		out.println("<div class=\"dtree\">");
		out.println("<script type=\"text/javascript\">");


		int pos,pos1;
	    sOutputXMLBranchList=sOutputXMLBranchList + "~";
		out.println("d = new dTree('d');");
		out.println("d.add(0,-1,'Requests');");  
		int count=0;
		String sBranch_Code="";
		while(st.hasMoreTokens())
		{
			strBranchCode = st.nextToken();
			sBranch_Code=sBranch_Code+"~"+strBranchCode;
			pos = sOutputXMLBranchList.indexOf(strBranchCode);
			if (pos!=-1)
			{
				pos = pos+ (strBranchCode+"!").length();				
				strBranchName=strBranchName+"~"+sOutputXMLBranchList.substring(pos,sOutputXMLBranchList.indexOf("!",pos));
				pos1=sOutputXMLBranchList.indexOf("!",pos)+1;
				strCSMMailId=sOutputXMLBranchList.substring(pos1,sOutputXMLBranchList.indexOf("!",pos1));
				pos1=sOutputXMLBranchList.indexOf("!",pos1)+1;
				strBMailId=sOutputXMLBranchList.substring(pos1,sOutputXMLBranchList.indexOf("~",pos1));				
			}
		}

		String status="0";
		String sLocalString="54";
		int iParentID=0;
		String sChildId="";
		int localcount=0;

		while(strProcessNameCodeList.indexOf(";")!=-1)
		{
			count++;
			strProcessCode = strProcessNameCodeList.substring(0,strProcessNameCodeList.indexOf(";"));
			pos = (strProcessCode+";").length();
			strProcessNameCodeList=strProcessNameCodeList.substring(pos,strProcessNameCodeList.length());
			strProcessName=strProcessNameCodeList.substring(0,strProcessNameCodeList.indexOf(";"));
			pos = (strProcessName+";").length();
			strProcessNameCodeList=strProcessNameCodeList.substring(pos,strProcessNameCodeList.length());

			
			String sProductName=strProcessName.substring(0,strProcessName.indexOf("-"));
			if(!sProductName.equals(sLocalString))
			{
				status="1";
				sLocalString=sProductName;
				localcount=count;
			}
			//create a parent node
			if(status.equals("1")){
			out.println("d.add("+count+",0,'"+sProductName+"');");
			status="0";
			count++;
			}
			//Add child nodess
			if(status.equals("0"))
			{
				String sServiceName=strProcessName.substring(strProcessName.indexOf("-")+2,strProcessName.length());%>	
				<%
				if (sServiceName.equals("Excess Authorization Request"))
				{
					out.println("d.add("+count+","+localcount+",'"+sServiceName+"','EAR_Process.jsp?BranchName="+URLEncoder.encode(strBranchName,"UTF-8") + "&BranchCode="+URLEncoder.encode(sBranch_Code.substring(1,sBranch_Code.length()),"UTF-8") + "&ProcessCode="+strProcessCode + "&ProcessName="+strProcessName + "&strCSMMailId="+strCSMMailId+"&strBMailId="+strBMailId+"','','frmData');");
				}
				if (sServiceName.equals("Excess Authorization Request Outside Credit Department"))
				{
					out.println("d.add("+count+","+localcount+",'"+sServiceName+"','EAR_Process_OCD.jsp?BranchName="+URLEncoder.encode(strBranchName,"UTF-8") + "&BranchCode="+URLEncoder.encode(sBranch_Code.substring(1,sBranch_Code.length()),"UTF-8") + "&ProcessCode="+strProcessCode + "&ProcessName="+strProcessName + "&strCSMMailId="+strCSMMailId+"&strBMailId="+strBMailId+"','','frmData');");
				}
			}
		}	
		out.println("document.write(d);");
		out.println("</script></div>");
	}
	catch(Exception e)
	{
		WriteLog("Exception :: "+e.toString());
	}
%>
</Body>
</HTML>
