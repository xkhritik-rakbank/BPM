<!----------------------------------------------------------------------------------------------------------------------------------
<!--           NEWGEN SOFTWARE TECHNOLOGIES LIMITED -->

<!-- Group						 : Application –Projects--->
<!-- Product / Project			 : RAKBank --->
<!-- Module                     : Request-Initiation     --->     
<!-- File Name					 : ProcessListing.jsp--->
<!-- Author                     : Manish K. Agrawal--->
<!-- Date written (DD/MM/YYYY) : 16-Oct-2006--->
<!-- Description                : Authenticate User.--->
<!-- 							 : Display process list branch wise.--->
<!-- ----------------------------------------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 28-11-2006	 Manish K. Agrawal		Disable Backspace button(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
//----------------------------------------------------------------------------------------------------
//
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
   
<%@page import="com.newgen.wfdesktop.util.AESEncryption"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>
<%@page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.newgen.wfdesktop.baseclasses.PMSInfo"%>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.LinkedHashMap,com.newgen.mvcbeans.controller.helper.*,com.newgen.wfdesktop.util.WDUtility"%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<HTML>
<HEAD>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	<link rel="StyleSheet" href="/webdesktop/webtop/css/dtree.css" type="text/css" />
	<script type="text/javascript" src="/webdesktop/webtop/scripts/dtree.js"></script>
</HEAD>
<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onkeydown='checkShortcut()'>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">
 
//alert("sdf");
//----------------------------------------------------------------------------------------------------
//Function Name                    : clearFrames()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Clear frames after request initiation.
//----------------------------------------------------------------------------------------------------
function clearFrames(){
	try{
		window.parent.frames['frmData'].document.location.href="CSR_blank_withLogo.jsp";
		window.parent.frames['frameProcess'].document.location.href="CSR_blank.jsp";
		window.parent.frames['frameClose'].document.location.href="CSR_blank.jsp";
	}catch(e){
		alert(e.message);
	}
}

//----------------------------------------------------------------------------------------------------
//Function Name                    : active(objLink)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : Hyperlink as object
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Change the color of selected hyperlinks.
//----------------------------------------------------------------------------------------------------
function active(objLink)
{
 //alert(document.getElementById('a(0)').innerHTML);
 list=document.getElementById('ProcessList').getElementsByTagName('a');;
 
 for(i=0;i<list.length;i++)
 {
  list[i].style.color='#990033';
 }
 //document.getElementById('b').style.color='red';
 objLink.style.color='blue';
}

</script>

		
<%

	WriteLog("inside CSR_ProcessListing JSP :");
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	String suserIndex = null;
	int iJtsPort = 0;
	boolean bError=false;
	
	try{
		WriteLog("inside try block :");
		WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		WriteLog("sCabname :"+sCabname);
        sSessionId    = wDUserInfo.getM_strSessionId();
		WriteLog("sSessionId :"+sSessionId);
		sJtsIp = wDCabinetInfo.getM_strServerIP();
        iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		WriteLog("iJtsPort :"+iJtsPort);
		suserIndex = wDUserInfo.getM_strUserIndex()+"";
		WriteLog("suserIndex :"+suserIndex);
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
	try{
		// Get Comment from PDBUser, Comment contains the branch code with delimeter of logged in user e.g. "0004~0014~..."
		String sInputXML =	"?xml version=\"1.0\"?>\n" +
		"<NGOGetUserProperty_Input>\n" +
		"<Option>NGOGetUserProperty</Option>\n" +
		"<CabinetName>"+sCabname+"</CabinetName>" +
		"<UserDBId>"+sSessionId+"</UserDBId>" +	//User session id
		"<UserIndex>"+suserIndex+"</UserIndex>\n" +
		"</NGOGetUserProperty_Input>\n";

		String sOutputXML="";
		try{
			sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog("NGOGetUserProperty Ouput :"+sOutputXML);
		}catch(Exception exp){
			WriteLog(sOutputXML);
		}
		if (sOutputXML.indexOf("Invalid session.")!=-1) {
			out.println("<script>");
			out.println("alert('User session has been expired. Please re-login.');");
			out.println("window.parent.close();"); //Close the browser
			out.println("</script>");
		}
		try{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Comment>")+9 , sOutputXML.indexOf("</Comment>"));
			WriteLog(sOutputXML);
		}catch(Exception ex){
			WriteLog("COMENT"+ex.toString());
		}
		
		if (sOutputXML.equals("") || sOutputXML.equals("Not Defined") || sOutputXML.equals("SupervisorUser")){
			out.println("<script>");
			out.println("alert('User does not have access of any branch. User can not initiate request. Please contact your system administrator.');");
			out.println("window.parent.close();"); //Close the browser
			out.println("</script>");
		}



	
		// Get All Processes list (ProcessName,Code from RB_Process_Details table)
		sInputXML ="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>RB_GetProcessDetails</ProcName>" +						
					"<Params> </Params>" +  //Pass blank. It is necessary.
					"<NoOfCols>2</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
		WriteLog(sInputXML);
		String sOutputXMLProcessList ="";
		try
		{
			sOutputXMLProcessList= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXMLProcessList);
			if(sOutputXMLProcessList.equals("") || Integer.parseInt(sOutputXMLProcessList.substring(sOutputXMLProcessList.indexOf("<MainCode>")+10 , sOutputXMLProcessList.indexOf("</MainCode>")))!=0)	{
				bError= true;
			}
		}catch(Exception exp){
			bError=true;
		}
		sOutputXMLProcessList = sOutputXMLProcessList.substring(sOutputXMLProcessList.indexOf("<Results>")+9,sOutputXMLProcessList.indexOf("</Results>"));





		WriteLog("MANSIH2:"+sOutputXMLProcessList); //It will keep all processes list 
		//e.g. "PL_IPDR!Personal Loan - Instalment Recovery / Past Due Recovery~PL_PD!Personal Loan - Postponement / Deferral~...."
		
		if (sOutputXMLProcessList.equals("")){
			out.println("<script>");
			out.println("alert('No process has found in RB_Process_Details table.');");
			out.println("window.parent.close();"); //Close the browser
			out.println("</script>");
		}

		//Get Branch List from RB_Branch_Details Table	
		sInputXML ="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>RB_GetBranchDetails</ProcName>" +						
					"<Params> </Params>" +  //Pass blank. It is necessary.
					"<NoOfCols>4</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
		String sOutputXMLBranchList ="";
		try{
			sOutputXMLBranchList= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXMLBranchList);
			if(sOutputXMLBranchList.equals("") || Integer.parseInt(sOutputXMLBranchList.substring(sOutputXMLBranchList.indexOf("<MainCode>")+10 , sOutputXMLBranchList.indexOf("</MainCode>")))!=0)	{
				bError= true;
			}
		}catch(Exception exp){
			bError=true;
		}

		// it will contain branch code/name like e.g. "0014!Al Ain~0004!Abu Dhabi~0030!........"
		sOutputXMLBranchList = sOutputXMLBranchList.substring(sOutputXMLBranchList.indexOf("<Results>")+9,sOutputXMLBranchList.indexOf("</Results>"));
		//Changed Below by Amandeep on 4 March 2011 For Fetching All Queues when user has right on more than 100 queues
		String sOutputXMLQueueList="";
		String sOutputXMLQueueList_loop="";
		String sLastValue="";
		String sLastIndex="";
		while(sOutputXMLQueueList_loop.indexOf("<MainCode>18</MainCode>") == -1)
		{
			
			// GetQueueList: retrieves only those queues on which user has rights
			sInputXML="<?xml version=\"1.0\"?>\n" +
			"<WMGetQueueList_Input>\n" +
			"<Option>WMGetQueueList</Option>\n" +
			"<EngineName>"+sCabname+"</EngineName>\n" +
			"<SessionId>" + sSessionId + "</SessionId>\n" +
			"<QueueAssociation>2</QueueAssociation>\n" +
			"<Filter></Filter>\n" +
			"<BatchInfo>\n" +
			"<SortOrder>A</SortOrder>"+
			"<OrderBy>QueueName</OrderBy>"+
			"<LastValue>"+sLastValue+"</LastValue>"+
			"<LastIndex>"+sLastIndex+"</LastIndex>"+
			"</BatchInfo>\n" +
			"<DataFlag>N</DataFlag>\n" +
			"</WMGetQueueList_Input>";

			
			try{
				sOutputXMLQueueList_loop = WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				WriteLog(sOutputXMLQueueList_loop);
				//out.println(sOutputXMLQueueList_loop);
				if(sOutputXMLQueueList_loop.equals("") || Integer.parseInt(sOutputXMLQueueList_loop.substring(sOutputXMLQueueList_loop.indexOf("<MainCode>")+10 , sOutputXMLQueueList_loop.indexOf("</MainCode>")))!=0){
					{
						bError= true;
						if(Integer.parseInt(sOutputXMLQueueList_loop.substring(sOutputXMLQueueList_loop.indexOf("<MainCode>")+10 , sOutputXMLQueueList_loop.indexOf("</MainCode>")))!=0)
							break;
					}
				}
			}catch(Exception exp){
				WriteLog(exp.toString());
			}
			//Add sOutputXMLQueueList_loop to sOutputXMLQueueList
			if(sOutputXMLQueueList_loop.indexOf("<MainCode>18</MainCode>") == -1)
			{
				try
				{
					if(!sOutputXMLQueueList.equals(""))	
					{
						sOutputXMLQueueList=sOutputXMLQueueList.substring(0,sOutputXMLQueueList.indexOf("</QueueList>"))+sOutputXMLQueueList_loop.substring(sOutputXMLQueueList_loop.indexOf("<QueueInfo>"),sOutputXMLQueueList_loop.indexOf("</QueueList>"))+sOutputXMLQueueList.substring(sOutputXMLQueueList.indexOf("</QueueList>"));
						sLastValue=sOutputXMLQueueList.substring(sOutputXMLQueueList.lastIndexOf("<Name>")+6,sOutputXMLQueueList.lastIndexOf("</Name>"));
						sLastIndex=sOutputXMLQueueList.substring(sOutputXMLQueueList.lastIndexOf("<ID>")+4,sOutputXMLQueueList.lastIndexOf("</ID>"));
					}
					else
					{
						sOutputXMLQueueList=sOutputXMLQueueList_loop;
						if(sOutputXMLQueueList.indexOf("<MainCode>18</MainCode>") != -1)
						{
							WriteLog("No Record Found.");
							out.println("<script>");
							out.println("alert('User doesn't have rights on any queue. Please contact your system administrator.');");
							out.println("window.parent.close();"); //Close the browser
							out.println("</script>");

						}
						else
						{
							sLastValue=sOutputXMLQueueList.substring(sOutputXMLQueueList.lastIndexOf("<Name>")+6,sOutputXMLQueueList.lastIndexOf("</Name>"));
							sLastIndex=sOutputXMLQueueList.substring(sOutputXMLQueueList.lastIndexOf("<ID>")+4,sOutputXMLQueueList.lastIndexOf("</ID>"));
						}
					}
				}
				catch(Exception e)
				{
					WriteLog(sOutputXMLQueueList+"+++Exception");
					WriteLog("Exception caught"+e.getMessage());
					//  e.printStackTrace();
					break;
				}	
			}
			else if(sOutputXMLQueueList_loop.indexOf("<MainCode>18</MainCode>") != -1 && sOutputXMLQueueList.equals(""))
			{
				WriteLog("No Record Found.");
				out.println("<script>");
				out.println("alert('User doesn't have rights on any queue. Please contact your system administrator.');");
				out.println("window.parent.close();"); //Close the browser
				out.println("</script>");
			}
		}
		WriteLog(sOutputXMLQueueList+"+++CHECKED");
		//Changed Above by Amandeep on 4 March 2011 For Fetching All Queues when user has right on more than 100 queues
		//Use separator as specified in the RB.properties file
		//Read Property File : Read Separator as well as Work Introduction Queue names of all processes
		
		String strSeparator="", noOfKeys="", noOfSubKeys="";
		String[] arrQueue=null;       // It will keep all the work introduction queuenames
		String[] SubQueueArr=null;       // It will keep all the CSR_OCC work introduction queuenames
		String strFilePath=request.getRealPath(request.getServletPath()); //Path of current JSP
		String fileSeparator=System.getProperty("file.separator");
		//strFilePath = strFilePath.substring(0,strFilePath.lastIndexOf("\\"));
		strFilePath = strFilePath.substring(0,strFilePath.lastIndexOf(fileSeparator));
		try{
			Properties properties = new Properties();
			//properties.load(new FileInputStream(strFilePath + "\\CSR_RB.properties"));
			properties.load(new FileInputStream(strFilePath + fileSeparator + "CSR_RB.properties"));
			strSeparator = properties.getProperty("Separator");
			noOfKeys = properties.getProperty("NoOfQueues");
			arrQueue = new String[Integer.parseInt(noOfKeys)];
			for (int i=0; i<Integer.parseInt(noOfKeys); i++){
				arrQueue[i] = properties.getProperty("Queue"+(i+1));
				//out.println(arrQueue[i]);
			}

			noOfSubKeys = properties.getProperty("NoOfSubQueues");
			SubQueueArr = new String[Integer.parseInt(noOfSubKeys)];
			for (int i=0; i<Integer.parseInt(noOfSubKeys); i++){
				SubQueueArr[i] = properties.getProperty("SubQueue"+(i+1));
			}
		}catch(Exception e){
			WriteLog(e.toString());
		}
		//Matching Queues between sOutputXMLQueueList and arrQueue
		String strProcessNameCodeList="";       // It will keep all the work introduction queuenames on which user has rights (All these queues must exist in RB.properties file)
		String sArrayTemp[]= new String[Integer.parseInt(noOfKeys)];
		try{
			WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXMLQueueList);
			WFXmlList RecordList;
			String sType="";
			for (RecordList =  xmlResponse.createList("QueueList", "QueueInfo");RecordList.hasMoreElements();){
				for (int i=0; i<Integer.parseInt(noOfKeys); i++){
					if(arrQueue[i].toUpperCase().equals(RecordList.getVal("Name").toUpperCase())){
						String strProcessName=null;
						String strProcessCode=null;
						int pos1=0,pos2=0;
						//out.println(RecordList);
						strProcessCode = arrQueue[i].substring(0,arrQueue[i].indexOf("_",arrQueue[i].indexOf("_")+1));//Get ProcessCode from queueName
						//out.println(strProcessCode);
						pos1 = sOutputXMLProcessList.indexOf(strProcessCode+"!")+(strProcessCode+"!").length();//find position of strProcessCode+"!" in sOutputXMLProcessList
						pos2 = sOutputXMLProcessList.indexOf("~",pos1+1);
						if (pos2==-1){
							pos2 = sOutputXMLProcessList.length();
						}

						strProcessName = sOutputXMLProcessList.substring(pos1,pos2);
						//out.println(strProcessName);
						if(strProcessNameCodeList.equals("")){
							strProcessNameCodeList = strProcessCode+";"+strProcessName;
						}
						else{
							strProcessNameCodeList = strProcessNameCodeList +";"+ strProcessCode+";"+strProcessName;
						}
						sArrayTemp[i]=strProcessCode+";"+strProcessName;
					}
					else if(RecordList.getVal("Name").toUpperCase().indexOf("CSR_OCC_")!=-1)
					{
						for (int j=0; j<Integer.parseInt(noOfSubKeys); j++){
							//------------------------------------
							if(SubQueueArr[j].toUpperCase().equals(RecordList.getVal("Name").toUpperCase())){
								//OCC found
								String strProcessName=null;
								String strProcessCode=null;
								int pos1=0,pos2=0;
								
								strProcessCode = arrQueue[i].substring(0,arrQueue[i].indexOf("_",arrQueue[i].indexOf("_")+1));//Get ProcessCode from queueName					
								pos1 = sOutputXMLProcessList.indexOf(strProcessCode+"!")+(strProcessCode+"!").length();//find position of strProcessCode+"!" in sOutputXMLProcessList
								
								pos2 = sOutputXMLProcessList.indexOf("~",pos1+1);
								if (pos2==-1){
									pos2 = sOutputXMLProcessList.length();
								}

								strProcessName = sOutputXMLProcessList.substring(pos1,pos2);
								if(strProcessNameCodeList.equals("")){
									strProcessNameCodeList = strProcessCode+";"+strProcessName;
								}
								else{
									strProcessNameCodeList = strProcessNameCodeList +";"+ strProcessCode+";"+strProcessName;
								}
								WriteLog("OCC found adding through new code-------"+RecordList.getVal("Name").toUpperCase());
								sArrayTemp[i]=strProcessCode+";"+strProcessName;
							}
							//--------------------------------------
						}
					}
				}
				
				RecordList.skip();
			}
		}catch(Exception ex){
				WriteLog("xxx"+ex.toString());
		}

		strProcessNameCodeList=strProcessNameCodeList+";";
		WriteLog("NOW-------------"+strProcessNameCodeList);
		String slatest= new String();
		for (int i=0; i<Integer.parseInt(noOfKeys); i++){
			if(sArrayTemp[i]!=null)
			{
				if(slatest.equals("")){
					slatest= sArrayTemp[i];
				}
				else{
					slatest = slatest+";"+ sArrayTemp[i];
				}
			}
		}

		WriteLog("slatest-------------"+slatest);
		

		String strProcessNameCodeListBackup=strProcessNameCodeList;
		strProcessNameCodeList=slatest+";";
		//Logic: 
		//sOutputXML: Contains branch id's of logged in user
		//sOutputXMLBranchList: Contains all branch id and branchName and email id
		//Branchs exist in the sOutputXML variable must be in sOutputXMLBranchList
		StringTokenizer  st = new StringTokenizer(sOutputXML, "~");
		String strBranchCode="",strBranchName="";
		String strProcessCode="",strProcessName="";
		String strCSMMailId="",strBMailId="";
		

		out.println("<div class=\"dtree\">");
		out.println("<script type=\"text/javascript\">");


		int pos,pos1;
	    sOutputXMLBranchList=sOutputXMLBranchList + "~"; //Add Separator
		
			out.println("d = new dTree('d');");
			out.println("d.add(0,-1,'Requests');");    //changed by Sachin Arora  
		int count=0;
		String sBranch_Code="";
		while(st.hasMoreTokens()) {
			strBranchCode = st.nextToken();
			sBranch_Code=sBranch_Code+"~"+strBranchCode;
			pos = sOutputXMLBranchList.indexOf(strBranchCode);
			if (pos!=-1){
				pos = pos+ (strBranchCode+"!").length();				strBranchName=strBranchName+"~"+sOutputXMLBranchList.substring(pos,sOutputXMLBranchList.indexOf("!",pos));
				pos1=sOutputXMLBranchList.indexOf("!",pos)+1;
				strCSMMailId=sOutputXMLBranchList.substring(pos1,sOutputXMLBranchList.indexOf("!",pos1));
				pos1=sOutputXMLBranchList.indexOf("!",pos1)+1;
				strBMailId=sOutputXMLBranchList.substring(pos1,sOutputXMLBranchList.indexOf("~",pos1));				
			}
		}
		WriteLog("strBranchName-------------"+strBranchName);
		WriteLog("strBranchCode-------------"+strBranchCode);
		WriteLog("sBranch_Code-------------"+sBranch_Code);
		//
			String status="0"; //Used to check whether to create a parent node or not 
			String sLocalString="54";
			int iParentID=0;
			String sChildId="";
			int localcount=0;
			while(strProcessNameCodeList.indexOf(";")!=-1){
				count++;
				strProcessCode = strProcessNameCodeList.substring(0,strProcessNameCodeList.indexOf(";"));
				pos = (strProcessCode+";").length();
				strProcessNameCodeList=strProcessNameCodeList.substring(pos,strProcessNameCodeList.length());
				strProcessName=strProcessNameCodeList.substring(0,strProcessNameCodeList.indexOf(";"));
				pos = (strProcessName+";").length();
				strProcessNameCodeList=strProcessNameCodeList.substring(pos,strProcessNameCodeList.length());

				
				String sProductName=strProcessName.substring(0,strProcessName.indexOf("-"));

				if(!sProductName.equals(sLocalString)){
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
				if(status.equals("0")){
					String sServiceName=strProcessName.substring(strProcessName.indexOf("-")+2,strProcessName.length());%>	
					<%
					
					if (sServiceName.equals("Account Payable"))
					{
					out.println("d.add("+count+","+localcount+",'"+sServiceName+"','AC_Initiate_Top.jsp?BranchName="+URLEncoder.encode(strBranchName,"UTF-8") + "&BranchCode="+URLEncoder.encode(sBranch_Code.substring(1,sBranch_Code.length()),"UTF-8") + "&ProcessCode="+strProcessCode + "&ProcessName="+strProcessName + "&strCSMMailId="+strCSMMailId+"&strBMailId="+strBMailId+"','','frmData');");
					}
					else
					{
						out.println("d.add("+count+","+localcount+",'"+sServiceName+"','CSR_Initiate_Top.jsp?BranchName="+URLEncoder.encode(strBranchName,"UTF-8") + "&BranchCode="+URLEncoder.encode(sBranch_Code.substring(1,sBranch_Code.length()),"UTF-8") + "&ProcessCode="+strProcessCode + "&ProcessName="+strProcessName + "&strCSMMailId="+strCSMMailId+"&strBMailId="+strBMailId+"','','frmData');");
					}
				}
			}	
		out.println("document.write(d);");
		out.println("</script></div>");
	}
	catch(Exception e)
	{
		//out.println(e.toString());
	}
%>

</Body>
</HTML>
