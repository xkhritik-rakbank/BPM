<%-- 
    Document   : customNewWI
    Created on : Sep 2, 2014, 10:48:45 AM
    Author     : Bhupesh Kumar    
   Problem No       Correction Date        Function Name
  --------------    ---------------     ----------------------------
   Bug 50339         22/09/2014          Need to open cutom form on click of New button in webdesktop before creating workitem in omniflow
--%>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ page import="com.newgen.mvcbeans.controller.helper.GeneralFns" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@page import="com.newgen.wfdesktop.baseclasses.*"%>
<%@page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@page import="java.io.*,java.util.*"%>
<%@page import="com.newgen.wfdesktop.components.workitem.view.WDNewCustomWorkitem"%>
<%@page import="com.newgen.wfdesktop.cabinet.*"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script language=javascript src="<%=request.getContextPath()%>/resources/scripts/wdgeneral.js"></script>
		<title><%=wfsession.getRSB().getString("TITLE_CUSTOM_NEW_WI")%></title>
    
    </head>
	
    <body onbeforeunload=" return closeAllWindows()">
	<script language="javascript" src="/webdesktop/resources/scripts/client.js"></script>
	<script language="javascript" src="/webdesktop/resources/scripts/windowhandler.js"></script>
	<script type="text/javascript">
	 
	function showProcessingCustom()
	{
		var divx= document.createElement("div");
		var imgx=document.createElement("img");
		imgx.src="/webdesktop/webtop/images/progress.gif";
		divx.appendChild(imgx);
		divx.style.position="absolute";
		divx.style.left=document.body.clientWidth-300;
		divx.style.top=1;

		document.body.appendChild(divx);
		divx.id="msgdiv"
	}
	</script>
	<%!
		private String getApplicationPath(HttpServletRequest req) {
			String path = req.getServletContext().getRealPath("/");
			if (!path.endsWith(File.separator)) {
				path += File.separator;
			}
			return path;
		}
	%>
	 <%
            
			String contextPath = request.getContextPath();
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "contextPath: "+contextPath);
			
			String strSessionId = null;
            String strEngineName = null;
            String strJtsIp = null;
            int nJtsPort=3333;
            String strQueueId = null;
            int nDebug=0;

            String strDataFlag = "Y";

            String strProcessDefId = null;
            String strActivityId = null;
            String strActivityName = null;
			String queueProcessName = null;
			String webLoc = null;

            String strDefinitionFlag = "Y";
            String strFormData = null;
            String strFormName = null;

            String mainCode = null;
            WFXmlResponse wfXmlResponse = null;

            String strUserDefFlag = "Y";
            String strAttributeData = null;
            String strurl = null;
            String isApplet = null;
            String wd_uid = "";			
			String height = request.getParameter("Comp_height");
			int iHeight = Integer.parseInt(height)+1500;
			int iframeHeight = Integer.parseInt(request.getParameter("Comp_height"))+1500;
			int iframeWidth = Integer.parseInt(request.getParameter("Comp_width"));	
	
            try {       
                strSessionId = wDSession.getM_objUserInfo().getM_strSessionId();
                strEngineName = wDSession.getM_objCabinetInfo().getM_strCabinetName();
                strJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
                nJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
                strQueueId = request.getParameter("QueueId");
                nDebug = wfsession.getDebugValue();
				wd_uid = wDSession.getM_strUniqueUserId();
				
				WDNewCustomWorkitem objCustWI = new WDNewCustomWorkitem();
                String WFGetQueueProperty_Output = objCustWI.WFGetQueueProperty(strJtsIp, nJtsPort, strEngineName, strSessionId, strQueueId, strDataFlag);
				com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WFGetQueueProperty_Output:"+WFGetQueueProperty_Output);
				//String WFGetQueueProperty_Output = WFQueue.WFGetQueueProperty(strJtsIp, nJtsPort, nDebug, strEngineName, strSessionId, strQueueId, strDataFlag);
				wfXmlResponse = new WFXmlResponse(WFGetQueueProperty_Output);
                mainCode = wfXmlResponse.getVal("MainCode");
				if (mainCode.equals("0")) {
                    strProcessDefId = wfXmlResponse.getVal("ProcessDefId");
                    strActivityId = wfXmlResponse.getVal("ActivityId");
                    strActivityName = wfXmlResponse.getVal("ActivityName");
					queueProcessName = wfXmlResponse.getVal("ProcessName");
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "strActivityId:"+strActivityId+", "+strProcessDefId);
					webLoc = wDSession.getM_objWDeskServerInfo().getM_strWDDomainURL();
					String url = null;
                    String strWIFolder = "wdtemp" + File.separator + wfsession.getRequestLocale() + File.separator + wfsession.getEngineName() + "_" + strProcessDefId + "_" + strActivityId;
                   
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "cbr issue: strWIFolder"+strWIFolder);
					//out.println("cbr issue: strWIFolder"+strWIFolder);
				   
                    File fWI = new File(strWIFolder);
					if (!fWI.exists() || !fWI.isDirectory()) {
                        fWI.mkdirs();
                    }

                    File extDataFile = new File(fWI, "extData.log");
					if (extDataFile.exists()) 
					{
						//WriteLog("Inside first if loop");
                        try {
                            String strExternalDefXml = "";
                            StringBuffer strExternalDefXmlBuff = new StringBuffer(1000);
                            int nRead = -1;
                            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(extDataFile), "UTF-8"));
                            char[] buffer = new char[1024];
                            for (;;) {
                                nRead = br.read(buffer, 0, 1024);
                                if (nRead == -1) {
                                    break;
                                }
                                strExternalDefXmlBuff.append(buffer, 0, nRead);
                                buffer = new char[1024];
                            }
                            strExternalDefXml = strExternalDefXmlBuff.toString();
                            wfXmlResponse.setXmlString(strExternalDefXml);
							//WriteLog("strExternalDefXml"+strExternalDefXml);
							com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "strExternalDefXml"+strExternalDefXml);

                        } catch (FileNotFoundException ex) {
                            //ex.printStackTrace();
                        } catch (UnsupportedEncodingException ex) {
                            //ex.printStackTrace();
                        } catch (IOException ex) {
                            //ex.printStackTrace();
                        }

                    } else 
					{
						//WriteLog("Inside first else");
                        String WFGetWorkitemDataExt_output = objCustWI.WFGetExternalData(strJtsIp, nJtsPort, strEngineName, strSessionId, strProcessDefId, strActivityId, null, null, strDefinitionFlag, null,null);
                        com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WFGetWorkitemDataExt_output: "+WFGetWorkitemDataExt_output);
						wfXmlResponse.setXmlString(WFGetWorkitemDataExt_output);
						//WriteLog("cbr issue: WFGetWorkitemDataExt_output"+WFGetWorkitemDataExt_output);
                        int nWorkitemMainCode = Integer.parseInt(wfXmlResponse.getVal("MainCode"));
                        /*if (nWorkitemMainCode > 0) {
                            throw new WFException(wfXmlResponse.getVal("MainCode"), wfXmlResponse.getVal("SubErrorCode"), wfXmlResponse.getVal("TypeOfError"), wfXmlResponse.getVal("Subject"), wfXmlResponse.getVal("Description"), "getworkitem_process.process");
                        }*/
                        try {
                            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(extDataFile), "UTF-8"));

                            bw.write(WFGetWorkitemDataExt_output, 0, WFGetWorkitemDataExt_output.length());
                            bw.flush();
                            bw.close();
                        } catch (FileNotFoundException ex) {
                            //ex.printStackTrace();
                        } catch (UnsupportedEncodingException ex) {
                            //ex.printStackTrace();
                        } catch (IOException ex) {
                            //ex.printStackTrace();
                        }

                    }
                    strFormData = wfXmlResponse.getVal("FormBuffer");
                    strFormName = wfXmlResponse.getVal("FormName");
					
					if ((queueProcessName!=null && queueProcessName.equals("SRM") || queueProcessName.equals("New_SRM"))) 
					{
						String strJspFolder = getApplicationPath(request) + "CustomForms" + File.separator + "Forms_Intro_" + strEngineName + "_" + strProcessDefId + File.separator + strFormName + ".jsp";
						//WriteLog("Jsp Folder"+strJspFolder);
						com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "strJspFolder: "+strJspFolder);
						File fj = new File(strJspFolder);
						if (fj.exists()) { 
							com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "if fj.exists() true block starts here...");
							isApplet = "N";
							strurl =  request.getContextPath()+"/CustomForms/Forms_Intro_" + strEngineName + "_" + strProcessDefId + "/" + strFormName + ".jsp";
							//WriteLog("URL"+strurl);
							com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "strurl: "+strurl);

						} /*commented below block as applet is not in ibps.
						else {
							//WriteLog("Inside second else");
							isApplet = "Y";
                            
							String strFormFolder = getApplicationPath(request) + "CustomForms" + File.separator + wfsession.getEngineName() + "_" + strProcessDefId + "_" + strActivityId;
							//WriteLog("strFormFolder"+strFormFolder);
							com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "strFormFolder: "+strFormFolder);
							File f = new File(strFormFolder);
							if (f.exists() && f.isDirectory()) {
								//out.println("Directory Already exist..."+"<BR>");
							}
							if (!f.exists() || !f.isDirectory()) {

								//out.println("Creating directory" + "<BR>"+"<BR>");
								f.mkdirs();
							}

							File formFile = new File(f, wfXmlResponse.getVal("FormIndex"));
							if (formFile.exists()) {
								//out.println("File Already Exists"+"<BR>");
							}
							if (!formFile.exists()) {
								try {

									formFile.createNewFile();
									FileOutputStream fos = new FileOutputStream(formFile);
									fos.write(EncodeImage.decodeImageData(strFormData));
									fos.close();
								} catch (FileNotFoundException ex) {
									throw new WFException("-1", "", "", "", "", "");
								} catch (UnsupportedEncodingException ex) {
									throw new WFException("-1", "", "", "", "", "");
								} catch (IOException ex) {
									throw new WFException("-1", "", "", "", "", "");
								}                            
							}

							String timeFlag = WFConfiguration.getConfValue("TimeFlag", "false", strEngineName);
							String sDateFormat;
							if (timeFlag.equalsIgnoreCase("true")) {
								sDateFormat = WFConfiguration.getConfValue1("DateFormat", strEngineName) + " HH:mm:ss";
							} else {
								sDateFormat = WFConfiguration.getConfValue1("DateFormat", strEngineName);
							}

						}*/
					} else if((queueProcessName == null || "".equals(queueProcessName))) {
						isApplet = "N";
						String customWarContext = "/custom";
						strurl = webLoc + customWarContext + "/CustomForms/Forms_Intro_" + strEngineName + "_" + strProcessDefId + "/" + strFormName + ".jsp";
					} else if(queueProcessName != null && !queueProcessName.equals("")) {
						isApplet = "N";
						//String psContext = "/" + (String) wfsession.getContextMap().get(strProcessDefId);
						//strurl = webLoc + psContext + "/CustomForms/Forms_Intro_" + strEngineName + "_" + strProcessDefId + "/" + strFormName + ".jsp";
					}
				}
				
                
			} catch (Exception e) {
				//out.println("Exception in customNewWI Jsp : " + e+"<BR>");
			}
        %>
		
		<script>
		
		var isWorkitemCreated="N"; // This flag is updated as "Y" after workitem is created
		var isCrossClicked="Y";
		
		function closeAllWindows()
		{
			if(isWorkitemCreated!="N")
			{
				
				//var fobj = frames['NewWIFRAME'].document.forms['wdesk'];
				var fobj = frames['NewWIFRAME'];
				var Process_Name="";
				try{
					Process_Name = fobj.document.getElementById("wdesk:Process_Name").value;
				}catch(err){
					Process_Name = fobj.document.getElementById("Process_Name").value;
				}
				
				if(Process_Name=="SRM"||Process_Name=="New_SRM")
				{
					try{
						var SubCategoryID=fobj.document.getElementById("SubCategoryID").value;
						var CategoryID=fobj.document.getElementById("CategoryID").value;
						if(CategoryID==1 && SubCategoryID==3)
							var isSaveSuccess = saveSRMData(true,"custom",fobj);
					}catch(err){}		
					if(isCrossClicked=="Y")
					{
						return("This Case will be lying at PBR queue.");
					}
				}
				else if(isCrossClicked=="Y")
					return("This Case will be lying at PBO queue.");
			}
			else
				return("This Case will be discarded.");
		}
		function fetchFieldValueBag()
		{
			return '<Attributes></Attributes>';
		}
		function NGF_NotifyDataLoaded(formData)
		{
		}
		////WDCabinetList.getConfValue(getCabinetName(), "InitiateAlso", "N");
        function UploadWI()
        {
			var initiateAlso='<%=WDCabinetList.getConfValue(wDSession.getM_objCabinetInfo().getM_strCabinetName(), "InitiateAlso", "N")%>'; //WDCabinetList.getConfValue(getCabinetName(), "InitiateAlso", "N");
			//var fobj = frames['NewWIFRAME'].document.forms['wdesk'];
			var fobj = frames['NewWIFRAME'];
			
			var Process_Name="";
			
			try{
				Process_Name = fobj.document.getElementById("wdesk:Process_Name").value;
			}catch(err){
				try{
					Process_Name = fobj.document.getElementById("Process_Name").value;
				}catch(err){
					try{
						Process_Name=frames['NewWIFRAME'].document.getElementById("Process_Name").value;
					}catch(err){						
					}
				}
			}
			
			try{
				if(Process_Name=="SRM"||Process_Name=="New_SRM")
				{
					if(CustomIntroduceClick(fobj,Process_Name))
					{	
						var CategoryID=fobj.document.getElementById("CategoryID").value;
						var SubCategoryID=fobj.document.getElementById("SubCategoryID").value;
						
						//var strAttribXML=getFormValuesForAjax();
						var strAttribXML=getFormValuesForAjaxNew();
						var response;
						var MainCode;
						var Subject;
						var FolderIndex;
						var ProcessInstanceId="";    
						
						if(strAttribXML!=null && strAttribXML.indexOf("<encryptedkeyid>")>-1 && strAttribXML.indexOf("</encryptedkeyid>")>-1)
						{
							var encryptedKey = strAttribXML.substring(strAttribXML.indexOf("<encryptedkeyid>")+16,strAttribXML.indexOf("</encryptedkeyid>"));
							strAttribXML = strAttribXML.substring(0,strAttribXML.indexOf("<encryptedkeyid>")+16)+encodeURIComponent(encryptedKey)+strAttribXML.substring(strAttribXML.indexOf("</encryptedkeyid>"));
							
						}
						if(fobj.document.getElementById("wdesk:WI_NAME").value =='')
						{	
							
							//added by stutee to call SRMWIIntroduce.jsp starts here.
							var xhrWi;
							if(window.XMLHttpRequest)
								xhrWi=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhrWi=new ActiveXObject("Microsoft.XMLHTTP");
							
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMWIIntroduce.jsp?ProcessDefId="+<%=strProcessDefId%>+"&WIData="+strAttribXML;
						
							
							xhrWi.open("POST",url,false); 
							xhrWi.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhrWi.send(null);
							
							if (xhrWi.status == 200 && xhrWi.readyState == 4)
							{
								ajaxResult=Trim(xhrWi.responseText);
								ProcessInstanceId = ajaxResult.split("<!")[0];
								//alert("UploadWI ajax response: "+ProcessInstanceId);
								fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
								isWorkitemCreated="Y";
							}
							else
							{
								alert("Some error occured while custom update.");
								hideProcessingCustom();
								return false;
							}
							//ends here.
							
							//
							/*var reqString='WD_UID='+<%=wd_uid%>+'&AttributeXML='+strAttribXML+'&ProcessDefId='+<%=strProcessDefId%>+'&ActivityId='+<%=strActivityId%>+'&QueueId='+<%=strQueueId%>+'&InitiateAlso='+initiateAlso;
							
													
							var ajaxReq;
							if (window.XMLHttpRequest) {
								ajaxReq= new XMLHttpRequest();
							} else if (window.ActiveXObject) {
								ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
							}
							
							var url = "/webdesktop/ajx/ajxreqhandler.jsp?AJXReqId=ajaxwiupload";
							url = appendUrlSession(url);
							ajaxReq.open("POST", url, false);
							ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							ajaxReq.send(reqString);
							if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
							{ 
								response= eval("("+ajaxReq.responseText+")");
								MainCode=response.MainCode;
								if(MainCode==0)
								{
									ProcessInstanceId=response.ProcessInstanceId;
									fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
									FolderIndex=response.FolderIndex;
									isWorkitemCreated="Y";
								}
						
							}
							else
							{
								Subject=response.FolderIndex;      
								return false;
							}*/
						}
						
						else
						{
							ProcessInstanceId=fobj.document.getElementById("wdesk:WI_NAME").value;
						}
						
						
						if(ProcessInstanceId.indexOf("-Process")<0)
						{
							alert("Your session might be expired. Please login again.");
							return false;
						}
						
						var isIntegrationCallSuccess = FireIntegrationCall(true,"custom",fobj,ProcessInstanceId);
						if(isIntegrationCallSuccess=="false")
						{
							hideProcessingCustom();
							return false;
						}
						else
						{
							isIntegrationCallSuccess = isIntegrationCallSuccess.split("$$");
						}
						
						var xhr;
							if(window.XMLHttpRequest)
								xhr=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhr=new ActiveXObject("Microsoft.XMLHTTP");
								
						var TEMPWINAME=fobj.document.getElementById("wdesk:TEMP_WI_NAME").value;
						var intCallStatus=fobj.document.getElementById("wdesk:IntegrationStatus").value;
									
						var url = "/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?UpdateFor=ExternalTable&IntegrationStatus="+intCallStatus+"&TEMP_WI_NAME="+TEMPWINAME;
						
							
						xhr.open("POST",url,false); 
						xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
						xhr.send(null);
						
						if (xhr.status == 200 && xhr.readyState == 4)
						{
							ajaxResult=Trim(xhr.responseText);
						}
						else
						{
							alert("Some error occured while custom update.");
							hideProcessingCustom();
							return false;
						}
						
						if(isIntegrationCallSuccess.length==2)
						{
							if(isIntegrationCallSuccess[0]=="false" && isIntegrationCallSuccess[1]=="false") 
							{
								hideProcessingCustom();
								return false;
							}
							
							if(isIntegrationCallSuccess[0]=="false")
							{
								alert("Workitem : "+ProcessInstanceId+" successfully created.\n\n"+isIntegrationCallSuccess[1]);
								hideProcessingCustom();
								return false;
							}
												
							var xhr;
							if(window.XMLHttpRequest)
								xhr=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhr=new ActiveXObject("Microsoft.XMLHTTP");
							
							// saving transaction table data before introducing the case
							var isSaveSuccess = saveSRMData(true,"custom",fobj);
							if(!isSaveSuccess)
							{
								hideProcessingCustom();
								return false;
								
							}
							//alert("delete");
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMCompleteWI.jsp?WINAME="+ProcessInstanceId+"&IntegrationStatus="+intCallStatus+"&TEMP_WI_NAME="+TEMPWINAME;
							
							xhr.open("POST",url,false); 
							xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhr.send(null);
							//handled by stutee.mishra for dropped temp WI cases.
							if(xhr.responseText.split('~')[0] != 'WIName not saved in transaction table'){
								if (xhr.status == 200 && xhr.readyState == 4)
								{
									alert("Workitem : "+ProcessInstanceId+" successfully created.\n\n"+isIntegrationCallSuccess[1]);
									ajaxResult=Trim(xhr.responseText);
									hideProcessingCustom();
									isCrossClicked="N";
									window.close();
								}
								else
								{
									alert("Some error occured while introducing the case.");
									hideProcessingCustom();
									return false;
								}
							}else{
								alert(xhr.responseText.split('~')[0]);
								return false;
							}
						}
						else
						{
							alert("Some error occured while integration with prime.");
							hideProcessingCustom();
							return false;
						}
					}
				}
				else 
				{
					if(CustomIntroduceClick(fobj,Process_Name))
					{	
						var strAttribXML=getFormValuesForAjax();
						var response;
						var MainCode;
						var Subject;
						var FolderIndex;
						var ProcessInstanceId="";    
						
						if(fobj.document.getElementById("wdesk:WI_NAME").value ==''){	
							
							//added by stutee to call SRMWIIntroduce.jsp starts here.
							var xhrWi;
							if(window.XMLHttpRequest)
								xhrWi=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhrWi=new ActiveXObject("Microsoft.XMLHTTP");
							
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMWIIntroduce.jsp?ProcessDefId="+<%=strProcessDefId%>+"&WIData="+strAttribXML;
						
							
							xhrWi.open("POST",url,false); 
							xhrWi.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhrWi.send(null);
							
							if (xhrWi.status == 200 && xhrWi.readyState == 4)
							{
								ajaxResult=Trim(xhrWi.responseText);
								ProcessInstanceId = ajaxResult.split("<!")[0];
								//alert("UploadWI ajax response: "+ProcessInstanceId);
								fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
								isWorkitemCreated="Y";
							}
							else
							{
								alert("Some error occured while custom update.");
								hideProcessingCustom();
								return false;
							}
							//ends here.
							
							/*var reqString='WD_UID='+<%=wd_uid%>+'&AttributeXML='+strAttribXML+'&ProcessDefId='+<%=strProcessDefId%>+'&ActivityId='+<%=strActivityId%>+'&QueueId='+<%=strQueueId%>+'&InitiateAlso='+initiateAlso;
													
							var ajaxReq;
							if (window.XMLHttpRequest) {
								ajaxReq= new XMLHttpRequest();
							} else if (window.ActiveXObject) {
								ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
							}
							
							var url = "/webdesktop/faces/ajx/ajxreqhandler.jsp?AJXReqId=ajaxwiupload";
							url = appendUrlSession(url);
							ajaxReq.open("POST", url, false);
							ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							ajaxReq.send(reqString);
							if (ajaxReq.status == 200 && ajaxReq.readyState == 4) { 
								response= eval("("+ajaxReq.responseText+")");
								MainCode=response.MainCode;
								if(MainCode==0)	{
									ProcessInstanceId=response.ProcessInstanceId;
									fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
									FolderIndex=response.FolderIndex;
									isWorkitemCreated="Y";
								}						
							}
							else{
								Subject=response.FolderIndex;      
								return false;
							}*/
						}
						else
							ProcessInstanceId=fobj.document.getElementById("wdesk:WI_NAME").value;						
						
						if(ProcessInstanceId.indexOf("-Process")<0)
						{
							alert("Your session might be expired. Please login again.");
							return false;
						}						
					
						var xhr;
						if(window.XMLHttpRequest)
							xhr = new XMLHttpRequest();
						else if(window.ActiveXObject)
							xhr = new ActiveXObject("Microsoft.XMLHTTP");
							
						var url = "/webdesktop/CustomForms/CU_Specific/SendSMSToCustomer.jsp";
						var cifId=fobj.document.getElementById("wdesk:SelectedCIF").value;
						var param = "winame=" + ProcessInstanceId + "&workstepname=PBO&SelectedCIF="+cifId;
						xhr.open("POST", url, false);
						xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
						xhr.send(param);

						if (xhr.status == 200 && xhr.readyState == 4) {
							ajaxResult = xhr.responseText;
							ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
							if (ajaxResult.indexOf("Exception") == 0) {
								alert("Some problem in sending mail");
								return false;
							}
						} else {
							alert("Problem in sending mail");
							return false;
						}
						
						if(window.XMLHttpRequest)
							xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							xhr=new ActiveXObject("Microsoft.XMLHTTP");
							
						var remarks=fobj.document.getElementById("wdesk:remarks").value;

						var url = "/webdesktop/CustomForms/CU_Specific/completeWIForCustomNewWI.jsp?WINAME="+ProcessInstanceId+"&Remarks="+remarks+"&itemindex="+FolderIndex;
						
						xhr.open("POST",url,false); 
						xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
						xhr.send(null);
						
						if (xhr.status == 200 && xhr.readyState == 4)
						{
							
							alert("Workitem : "+ProcessInstanceId+" successfully created.");
							ajaxResult=Trim(xhr.responseText);
							hideProcessingCustom();
							isCrossClicked="N";
							window.close();
						}
						else
						{
							alert("Some error occured while introducing the case.");
							hideProcessingCustom();
							return false;
						}						
					}
				}
			}
			catch(Err)
			{
				if(Process_Name=="SRM"||Process_Name=="New_SRM")
				{
					if(CustomIntroduceClick(fobj,Process_Name))
					{	
						var strAttribXML=getFormValuesForAjax();
						var response;
						var MainCode;
						var Subject;
						var FolderIndex;
						var ProcessInstanceId="";    
						
						if(fobj.document.getElementById("wdesk:WI_NAME").value =='')
						{	
							//added by stutee to call SRMWIIntroduce.jsp starts here.
							var xhrWi;
							if(window.XMLHttpRequest)
								xhrWi=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhrWi=new ActiveXObject("Microsoft.XMLHTTP");
							
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMWIIntroduce.jsp?ProcessDefId="+<%=strProcessDefId%>+"&WIData="+strAttribXML;
						
							
							xhrWi.open("POST",url,false); 
							xhrWi.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhrWi.send(null);
							
							if (xhrWi.status == 200 && xhrWi.readyState == 4)
							{
								ajaxResult=Trim(xhrWi.responseText);
								ProcessInstanceId = ajaxResult.split("<!")[0];
								//alert("UploadWI ajax response: "+ProcessInstanceId);
								fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
								isWorkitemCreated="Y";
							}
							else
							{
								alert("Some error occured while custom update.");
								hideProcessingCustom();
								return false;
							}
							//ends here.
							
							/*var reqString='WD_UID='+<%=wd_uid%>+'&AttributeXML='+strAttribXML+'&ProcessDefId='+<%=strProcessDefId%>+'&ActivityId='+<%=strActivityId%>+'&QueueId='+<%=strQueueId%>+'&InitiateAlso='+initiateAlso;
						
													
							var ajaxReq;
							if (window.XMLHttpRequest) {
								ajaxReq= new XMLHttpRequest();
							} else if (window.ActiveXObject) {
								ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
							}
							
							var url = "/webdesktop/ajx/ajxreqhandler.jsp?AJXReqId=ajaxwiupload";
							url = appendUrlSession(url);
							ajaxReq.open("POST", url, false);
							ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							ajaxReq.send(reqString);
							if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
							{ 
								response= eval("("+ajaxReq.responseText+")");
								MainCode=response.MainCode;
								if(MainCode==0)
								{
									ProcessInstanceId=response.ProcessInstanceId;
									fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
									FolderIndex=response.FolderIndex;
									isWorkitemCreated="Y";
								}
							}
							else
							{
								Subject=response.FolderIndex;      
								return false;
							}*/
						}
						else
						{
							ProcessInstanceId=fobj.document.getElementById("wdesk:WI_NAME").value;
						}
						
						
						if(ProcessInstanceId.indexOf("-Process")<0)
						{
							alert("Your session might be expired. Please login again.");
							return false;
						}
						
						var isIntegrationCallSuccess = FireIntegrationCall(true,"custom",fobj,ProcessInstanceId);
						if(isIntegrationCallSuccess=="false")
						{
							hideProcessingCustom();
							return false;
						}
						else
						{
							isIntegrationCallSuccess = isIntegrationCallSuccess.split("$$");
						}
						
						var xhr;
						if(window.XMLHttpRequest)
							xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							xhr=new ActiveXObject("Microsoft.XMLHTTP");
								
						var TEMPWINAME=fobj.document.getElementById("wdesk:TEMP_WI_NAME").value
						
						var intCallStatus=fobj.document.getElementById("wdesk:IntegrationStatus").value;
								
						var url = "/webdesktop/CustomForms/SRM_Specific/SRMCustomUpdate.jsp?UpdateFor=ExternalTable&IntegrationStatus="+intCallStatus+"&TEMP_WI_NAME="+TEMPWINAME;
							
						xhr.open("POST",url,false); 
						xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
						xhr.send(null);
						
						if (xhr.status == 200 && xhr.readyState == 4)
						{
							ajaxResult=Trim(xhr.responseText);
						}
						else
						{
							alert("Some error occured while custom update.");
							hideProcessingCustom();
							return false;
						}
						
						if(isIntegrationCallSuccess.length==2)
						{
							if(isIntegrationCallSuccess[0]=="false" && isIntegrationCallSuccess[1]=="false") 
							{
								hideProcessingCustom();
								return false;
							}
							
							if(isIntegrationCallSuccess[0]=="false")
							{
								alert("Workitem : "+ProcessInstanceId+" successfully created.\n\n"+isIntegrationCallSuccess[1]);
								hideProcessingCustom();
								return false;
							}
												
							var xhr;
							if(window.XMLHttpRequest)
								xhr=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhr=new ActiveXObject("Microsoft.XMLHTTP");
							
							// saving transaction table data before introducing the case
							var isSaveSuccess = saveSRMData(true,"custom",fobj);
							if(!isSaveSuccess)
							{
								hideProcessingCustom();
								return false;
								
							}
							
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMCompleteWI.jsp?WINAME="+ProcessInstanceId+"&IntegrationStatus="+intCallStatus+"&TEMP_WI_NAME="+TEMPWINAME;
							
							xhr.open("POST",url,false); 
							xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhr.send(null);
							
							if (xhr.status == 200 && xhr.readyState == 4)
							{
								alert("Workitem : "+ProcessInstanceId+" successfully created.\n\n"+isIntegrationCallSuccess[1]);
								ajaxResult=Trim(xhr.responseText);
								hideProcessingCustom();
								isCrossClicked="N";
								window.close();
							}
							else
							{
								alert("Some error occured while introducing the case.");
								hideProcessingCustom();
								return false;
							}
						}
						else
						{
							alert("Some error occured while integration with prime.");
							hideProcessingCustom();
							return false;
						}
					}
				}
				else{
					if(CustomIntroduceClick(fobj,Process_Name))
					{	
						var strAttribXML=getFormValuesForAjax();
						var response;
						var MainCode;
						var Subject;
						var FolderIndex;
						var ProcessInstanceId="";    
						
						if(fobj.document.getElementById("wdesk:WI_NAME").value =='')						
						{	
							//added by stutee to call SRMWIIntroduce.jsp starts here.
							var xhrWi;
							if(window.XMLHttpRequest)
								xhrWi=new XMLHttpRequest();
							else if(window.ActiveXObject)
								xhrWi=new ActiveXObject("Microsoft.XMLHTTP");
							
							var url = "/webdesktop/CustomForms/SRM_Specific/SRMWIIntroduce.jsp?ProcessDefId="+<%=strProcessDefId%>+"&WIData="+strAttribXML;
						
							
							xhrWi.open("POST",url,false); 
							xhrWi.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
							xhrWi.send(null);
							
							if (xhrWi.status == 200 && xhrWi.readyState == 4)
							{
								ajaxResult=Trim(xhrWi.responseText);
								ProcessInstanceId = ajaxResult.split("<!")[0];
								//alert("UploadWI ajax response: "+ProcessInstanceId);
								fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
								isWorkitemCreated="Y";
							}
							else
							{
								alert("Some error occured while custom update.");
								hideProcessingCustom();
								return false;
							}
							//ends here.
							
							/*var reqString='WD_UID='+<%=wd_uid%>+'&AttributeXML='+strAttribXML+'&ProcessDefId='+<%=strProcessDefId%>+'&ActivityId='+<%=strActivityId%>+'&QueueId='+<%=strQueueId%>+'&InitiateAlso='+initiateAlso;
													
							var ajaxReq;
							if (window.XMLHttpRequest) {
								ajaxReq= new XMLHttpRequest();
							} else if (window.ActiveXObject) {
								ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
							}
							
							var url = sContextPath+"/faces/ajx/ajxreqhandler.jsp?AJXReqId=ajaxwiupload";
							url = appendUrlSession(url);
							ajaxReq.open("POST", url, false);
							ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							ajaxReq.send(reqString);
							if (ajaxReq.status == 200 && ajaxReq.readyState == 4) 
							{ 
								response= eval("("+ajaxReq.responseText+")");
								MainCode=response.MainCode;
								if(MainCode==0)	{
									ProcessInstanceId=response.ProcessInstanceId;
									fobj.document.getElementById("wdesk:WI_NAME").value=ProcessInstanceId;
									FolderIndex=response.FolderIndex;
									isWorkitemCreated="Y";
								}
							}
							else{
								Subject=response.FolderIndex;      
								return false;
							}*/
						}
						else
							ProcessInstanceId=fobj.document.getElementById("wdesk:WI_NAME").value;
						
						if(ProcessInstanceId.indexOf("-Process")<0)
						{
							alert("Your session might be expired. Please login again.");
							return false;
						}
						
						var xhr;
						if(window.XMLHttpRequest)
							xhr = new XMLHttpRequest();
						else if(window.ActiveXObject)
							xhr = new ActiveXObject("Microsoft.XMLHTTP");

						var url = "/webdesktop/CustomForms/CU_Specific/SendSMSToCustomer.jsp";
						var cifId=fobj.document.getElementById("wdesk:SelectedCIF").value;
						var param = "winame=" + ProcessInstanceId + "&workstepname=PBO&SelectedCIF="+cifId;
						xhr.open("POST", url, false);
						xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
						xhr.send(param);

						if (xhr.status == 200 && xhr.readyState == 4) {
							ajaxResult = xhr.responseText;
							ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
							if (ajaxResult.indexOf("Exception") == 0) {
								alert("Some problem in sending mail");
								return false;
							}
						} else {
							alert("Problem in sending mail");
							return false;
						}
						
						if(window.XMLHttpRequest)
							xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							xhr=new ActiveXObject("Microsoft.XMLHTTP");
						
						var remarks=fobj.document.getElementById("wdesk:remarks").value;
						var url = "/webdesktop/CustomForms/CU_Specific/completeWIForCustomNewWI.jsp?WINAME="+ProcessInstanceId+"&Remarks="+remarks+"&itemindex="+FolderIndex;
						
						xhr.open("POST",url,false); 
						xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
						xhr.send(null);
						
						if (xhr.status == 200 && xhr.readyState == 4){
							alert("Workitem : "+ProcessInstanceId+" successfully created.");
							ajaxResult=Trim(xhr.responseText);
							hideProcessingCustom();
							isCrossClicked="N";
							window.close();
						}
						else{
							alert("Some error occured while introducing the case.");
							hideProcessingCustom();
							return false;
						}						
					}
				}
			}
		}
        
        function getFormValuesForAjax()
        {
            var str = "";
            var valueArr = null;
            var val = "";
            var cmd = "";
            var fobj = frames['NewWIFRAME'].document.forms['wdesk']
            if(typeof fobj == 'undefined')
                return "";
 
            var formid=fobj.id;
  
            var strAttribXML="<Attributes>";
            if(formid=='wdesk'){
			
			    for(var i = 0;i < fobj.elements.length;i++)
                {
                    switch(fobj.elements[i].type)
                    {
                        case "textarea":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
								strAttribXML=strAttribXML+"<"+fobj.elements[i].name.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">"+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"</"+fobj.elements[i].name.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">";
							break;
							
                        case "text":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
							{
								if(fobj.elements[i].name=="passportExpDate_exis" || fobj.elements[i].name=="date_join_curr_employer_exis"||fobj.elements[i].name=="visaExpDate_exis"||fobj.elements[i].name=="emiratesidexp_exis"||fobj.elements[i].name=="wheninuae_exis"||fobj.elements[i].name=="ExpiryDate_exis"||fobj.elements[i].name=="DOB_exis"||fobj.elements[i].name=="SignedDate_exis" || fobj.elements[i].name=="wdesk:passportExpDate_exis" || fobj.elements[i].name=="wdesk:date_join_curr_employer_exis"||fobj.elements[i].name=="wdesk:visaExpDate_exis"||fobj.elements[i].name=="wdesk:emiratesidexp_exis"||fobj.elements[i].name=="wdesk:wheninuae_exis"||fobj.elements[i].name=="wdesk:ExpiryDate_exis"||fobj.elements[i].name=="wdesk:DOB_exis"||fobj.elements[i].name=="wdesk:SignedDate_exis")
								{
									if(fobj.elements[i].value!=null && fobj.elements[i].value!='' && fobj.elements[i].value.length==10)
									{
										var formattedDate=fobj.elements[i].value;
										try{
											//change dd/mm/yyyy to yyyy=mm-dd
											var dateParts=formattedDate.split("/");
											formattedDate=dateParts[2]+"-"+dateParts[1]+"-"+dateParts[0];
										}catch(err){}
										strAttribXML=strAttribXML+"<"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">"+formattedDate+"</"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">";	
									}
								}
								else
									strAttribXML=strAttribXML+"<"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">"+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"</"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">";	
							}	
                            break;
                        
						case "hidden":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
							{
								if(fobj.elements[i].name=="passportExpDate_exis" || fobj.elements[i].name=="date_join_curr_employer_exis"||fobj.elements[i].name=="visaExpDate_exis"||fobj.elements[i].name=="emiratesidexp_exis"||fobj.elements[i].name=="wheninuae_exis"||fobj.elements[i].name=="ExpiryDate_exis"||fobj.elements[i].name=="DOB_exis"||fobj.elements[i].name=="SignedDate_exis" || fobj.elements[i].name=="wdesk:passportExpDate_exis" || fobj.elements[i].name=="wdesk:date_join_curr_employer_exis"||fobj.elements[i].name=="wdesk:visaExpDate_exis"||fobj.elements[i].name=="wdesk:emiratesidexp_exis"||fobj.elements[i].name=="wdesk:wheninuae_exis"||fobj.elements[i].name=="wdesk:ExpiryDate_exis"||fobj.elements[i].name=="wdesk:DOB_exis"||fobj.elements[i].name=="wdesk:SignedDate_exis")
								{
									if(fobj.elements[i].value!=null && fobj.elements[i].value!='' && fobj.elements[i].value.length==10)
									{
										var formattedDate=fobj.elements[i].value;
										try{
											//change dd/mm/yyyy to yyyy=mm-dd
											var dateParts=formattedDate.split("/");
											formattedDate=dateParts[2]+"-"+dateParts[1]+"-"+dateParts[0];
										}catch(err){}
										strAttribXML=strAttribXML+"<"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">"+formattedDate+"</"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">";	
									}
								}
								else
									strAttribXML=strAttribXML+"<"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">"+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"</"+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+">";	
							}	
							break;
					}
				}
			}
			strAttribXML=strAttribXML+"</Attributes>";
			return strAttribXML;
		}
		
		//added by stutee.mishra for UploadWI workitemData starts here
		function getFormValuesForAjaxNew()
        {
            var str = "";
            var valueArr = null;
            var val = "";
            var cmd = "";
            var fobj = frames['NewWIFRAME'].document.forms['wdesk']
            if(typeof fobj == 'undefined')
                return "";
 
            var formid=fobj.id;
  
            var strAttribXML="<Attributes>";
            if(formid=='wdesk'){
			
			    for(var i = 0;i < fobj.elements.length;i++)
                {
                    switch(fobj.elements[i].type)
                    {
                        case "textarea":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
								strAttribXML=strAttribXML+""+fobj.elements[i].name.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+""+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"";
							break;
							
                        case "text":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
							{
								if(fobj.elements[i].name=="passportExpDate_exis" || fobj.elements[i].name=="date_join_curr_employer_exis"||fobj.elements[i].name=="visaExpDate_exis"||fobj.elements[i].name=="emiratesidexp_exis"||fobj.elements[i].name=="wheninuae_exis"||fobj.elements[i].name=="ExpiryDate_exis"||fobj.elements[i].name=="DOB_exis"||fobj.elements[i].name=="SignedDate_exis" || fobj.elements[i].name=="wdesk:passportExpDate_exis" || fobj.elements[i].name=="wdesk:date_join_curr_employer_exis"||fobj.elements[i].name=="wdesk:visaExpDate_exis"||fobj.elements[i].name=="wdesk:emiratesidexp_exis"||fobj.elements[i].name=="wdesk:wheninuae_exis"||fobj.elements[i].name=="wdesk:ExpiryDate_exis"||fobj.elements[i].name=="wdesk:DOB_exis"||fobj.elements[i].name=="wdesk:SignedDate_exis")
								{
									if(fobj.elements[i].value!=null && fobj.elements[i].value!='' && fobj.elements[i].value.length==10)
									{
										var formattedDate=fobj.elements[i].value;
										try{
											//change dd/mm/yyyy to yyyy=mm-dd
											var dateParts=formattedDate.split("/");
											formattedDate=dateParts[2]+"-"+dateParts[1]+"-"+dateParts[0];
										}catch(err){}
										strAttribXML=strAttribXML+""+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+""+formattedDate+"";	
									}
								}
								else
									strAttribXML=strAttribXML+""+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+""+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"";	
							}	
                            break;
                        
						case "hidden":
							if(fobj.elements[i].name.indexOf("wdesk")>-1)
							{
								if(fobj.elements[i].name=="passportExpDate_exis" || fobj.elements[i].name=="date_join_curr_employer_exis"||fobj.elements[i].name=="visaExpDate_exis"||fobj.elements[i].name=="emiratesidexp_exis"||fobj.elements[i].name=="wheninuae_exis"||fobj.elements[i].name=="ExpiryDate_exis"||fobj.elements[i].name=="DOB_exis"||fobj.elements[i].name=="SignedDate_exis" || fobj.elements[i].name=="wdesk:passportExpDate_exis" || fobj.elements[i].name=="wdesk:date_join_curr_employer_exis"||fobj.elements[i].name=="wdesk:visaExpDate_exis"||fobj.elements[i].name=="wdesk:emiratesidexp_exis"||fobj.elements[i].name=="wdesk:wheninuae_exis"||fobj.elements[i].name=="wdesk:ExpiryDate_exis"||fobj.elements[i].name=="wdesk:DOB_exis"||fobj.elements[i].name=="wdesk:SignedDate_exis")
								{
									if(fobj.elements[i].value!=null && fobj.elements[i].value!='' && fobj.elements[i].value.length==10)
									{
										var formattedDate=fobj.elements[i].value;
										try{
											//change dd/mm/yyyy to yyyy=mm-dd
											var dateParts=formattedDate.split("/");
											formattedDate=dateParts[2]+"-"+dateParts[1]+"-"+dateParts[0];
										}catch(err){}
										strAttribXML=strAttribXML+""+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+""+formattedDate+"";	
									}
								}
								else
									strAttribXML=strAttribXML+""+fobj.elements[i].id.substring(fobj.elements[i].name.indexOf("wdesk:")+6,fobj.elements[i].name.length)+""+fobj.elements[i].value.replace(/[&“`<>]/g,'')+"";	
							}	
							break;
					}
				}
			}
			strAttribXML=strAttribXML+"</Attributes>";
			return strAttribXML;
		}
		//ends here.
        
		function UploadFormWI()
		{
			var response;
			var MainCode;
			var Subject;
			var FolderIndex;
			var ProcessInstanceId;
									   
								  
			var reqString='WD_UID='+<%=wd_uid%>+'&AttributeXML='+document.wdgc.getFieldValueBagEx()+'&ProcessDefId='+<%=strProcessDefId%>+'&ActivityId='+<%=strActivityId%>+'&QueueId='+<%=strQueueId%>;
			var ajaxReq;
			if (window.XMLHttpRequest) {
				ajaxReq= new XMLHttpRequest();
			} else if (window.ActiveXObject) {
				ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
			}
										
			var url = sContextPath+"/faces/ajx/ajxreqhandler.jsp?AJXReqId=ajaxwiupload";
			url = appendUrlSession(url);
			ajaxReq.open("POST", url, false);
			ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			ajaxReq.send(reqString);
			if (ajaxReq.status == 200&&ajaxReq.readyState == 4) { 
				response= eval("("+ajaxReq.responseText+")");
				MainCode=response.MainCode;
				if(MainCode==0)
				{
					ProcessInstanceId=response.ProcessInstanceId;
					FolderIndex=response.FolderIndex;
				}
				else
				{
					Subject=response.FolderIndex;
				}
			}
		}

        </script>
		<f:view>
		<table width=100% border="0" cellspacing="0" cellpadding="0">
			<tr width=100%>
				<td   valign="top" width="12"><img src="<%=request.getContextPath()%>/webtop/images/bar_<%=wfsession.getRSB().getString("LEFT")%>.gif" style="text-align:<%=wfsession.getRSB().getString("RIGHT")%>;" /></td>
				<td width=98% background="<%=request.getContextPath()%>/webtop/images/middle.gif" class="EWWhite"></td>         
				<td style="text-align:<%=wfsession.getRSB().getString("RIGHT")%>;" background="<%=request.getContextPath()%>/webtop/images/middle.gif">
					<button onclick="showProcessingCustom();UploadWI();" style="color:#990033;font-size:20px;font-weight: bold;cursor:pointer;" >Introduce   </button>
					
				</td>
				<td width=5% background="<%=request.getContextPath()%>/webtop/images/middle.gif" class="EWWhite">&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>    
				
				<td valign="top" width="12"><img src="<%=request.getContextPath()%>/webtop/images/bar_<%=wfsession.getRSB().getString("RIGHT")%>.gif" style="text-align:<%=wfsession.getRSB().getString("LEFT")%>;"/></td>
			</tr>                        
		</table>
  <form name="post_to_iframe" id="post_to_iframe" action="<%=strurl%>" target="NewWIFRAME" method="post">
            <input type="hidden" name="wdesk:EngineName" id="wdesk:EngineName" value='<%=strEngineName%>'/>
            <input type="hidden" name="wdesk:UserName" id="wdesk:UserName" value='<%=wfsession.getUserName()%>'/>
            <input type="hidden" name="wdesk:UserIndex" id="wdesk:UserIndex" value='<%=wfsession.getUserIndex()%>'/>
            <input type="hidden" name="wdesk:RouteID" id="wdesk:RouteID" value='<%=strProcessDefId%>'/>
            <input type="hidden" name="wdesk:SessionID" id="wdesk:SessionID" value='<%=strSessionId%>'/>
            <input type="hidden" name="wdesk:JTSIP" id="wdesk:JTSIP" value='<%=strJtsIp%>'/>
            <input type="hidden" name="wdesk:JTSPort" id="wdesk:JTSPort" value='<%=nJtsPort%>'/>
            <input type="hidden" name="wdesk:DebugValue" id="wdesk:DebugValue" value='<%=nDebug%>'/>
            <input type="hidden" name="wdesk:ActivityID" id="wdesk:ActivityID" value='<%=strActivityId%>'/>
            <input type="hidden" name="wdesk:WorkStepName" id="wdesk:WorkStepName" value='<%=strActivityName%>'/>
            <input type="hidden" name="wdesk:Locale" id="wdesk:Locale" value='<%=wfsession.getRequestLocale()%>'/>
            <input type="hidden" name="wdesk:MultiTenancyVar" id="wdesk:MultiTenancyVar" value='<%=wfsession.getM_strMultiTenancyVar()%>'/>
            <input type="hidden" name="wdesk:AppServerName" id="wdesk:AppServerName" value='<%=wfsession.getAppServerName()%>'/>
            <input type="hidden" name="wdesk:DatabaseType" id="wdesk:DatabaseType" value='<%=wfsession.getStrDatabaseType()%>'/>
            <input type="hidden" name="wdesk:BatchSize" id="wdesk:BatchSize" value='<%=wfsession.getPrefObject().getBatchSize()%>'/>
            <input type="hidden" name="wdesk:RouteName" id="wdesk:RouteName" value='<%=queueProcessName%>'/>
            <input type="hidden" name="wdesk:width" id="wdesk:width" value='<%=iframeWidth%>'/>
            <input type="hidden" name="wdesk:height" id="wdesk:height" value='<%=iframeHeight%>'/>
        </form>
        <iframe src='<%=strurl%>'  id="NewWIFRAME" name="NewWIFRAME" width='100%' height='<%=request.getParameter("Comp_height")%>'>
		</iframe>
		<script type="text/javascript">
            document.getElementById('post_to_iframe').submit();
        </script>

 
    </f:view>
	  
</body>
</html>