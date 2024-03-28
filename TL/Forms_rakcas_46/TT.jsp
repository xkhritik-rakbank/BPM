
<%@ include file="../TT_Specific/Log.process"%>
<!------------------------------------------------------------------------------------------------------
	//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	
	//Group						 : Application –Projects
	//Product / Project			 : RAKBank 
	//Module                     : Request-Initiation 
	//File Name					 : TL.jsp
	//Author                     : Ankit	
	// Date written (DD/MM/YYYY) : 07-Dec-2015
	//Description                : Initial Header fixed form for CIF Updates
	//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant ,com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.*;"%>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!---<jsp:useBean id="WDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/> --->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>


<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ProcessInstanceId"), 1000, true) );
			String ProcessInstanceId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkitemId"), 1000, true) );
			String WorkitemId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wdesk:wid"), 1000, true) );
			String wdeskwid_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");

	String pid = "";
	String wid = "";
	/*LinkedHashMap workitemMap;
	WorkdeskModel wdmodel;
	LinkedHashMap attributeMap;
	LinkedHashMap dynConstMap;  */
	//pid=request.getParameter("wdesk:pid");
	//wid=request.getParameter("wdesk:wid");
	 pid = ProcessInstanceId_Esapi;
	 wid = WorkitemId_Esapi;

	WriteLog("Process Instance Id   "+pid);
	WriteLog("Workitem Id   "+wid);
	 
	 
	 /*workitemMap=(LinkedHashMap)FacesContext.getCurrentInstance().getApplication().createValueBinding("#{workitems.workItems}").getValue(FacesContext.getCurrentInstance());
	 wdmodel = (WorkdeskModel)workitemMap.get(pid+"_"+wid);
	 attributeMap=wdmodel.getAttributeMap();  */
	 
	   WDWorkitems wDWorkitems = (WDWorkitems) session.getAttribute("wDWorkitems");
    LinkedHashMap workitemMap = (LinkedHashMap) wDWorkitems.getWorkItems();
	 WorkdeskModel wdmodel = (WorkdeskModel)workitemMap.get(pid+"_"+wid);//currentworkdesk
	LinkedHashMap attributeMap=wdmodel.getAttributeMap();

	 //Sample Code to Interate through Dynamic Constants and getting these values
	 //dynConstMap=wdmodel.getDynamicConstantMap();
	 LinkedHashMap dynConstMap=wdmodel.getDynamicConstantMap();
	WriteLog("dynConstMap"+dynConstMap);

	/*try
	 {
		 Set keySet = dynConstMap.keySet();
		 Iterator<String> iterator = keySet.iterator();
		 while(iterator.hasNext())
		{
			// Getting Dynamic Constant name
			String key = iterator.next();

			// Getting Dynamic Constant Value by its Name
			WFDynamicConstant value = (WFDynamicConstant)dynConstMap.get(key);

		   // System.out.println("Dynamic Constant Name =  "+key);
		   // System.out.println("Dynamic Constant Value =  "+value.getConstantValue());
		}
	 }
	 catch(Exception ex)
	 {
		WriteLog("Problem in the building the Hashmap for the fields from DB");
	 }   */
	String workstepName  = wdmodel.getWorkitem().getActivityName();
	
	
	String wi_name = wdmodel.getWorkitem().getProcessInstanceId();

	WriteLog("Workitem Name  "+wi_name);
	
	String Extwi_name = ((WorkdeskAttribute)attributeMap.get("wi_name")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("wi_name")).getValue();
	
	WriteLog("Workitem Name from external table   "+Extwi_name);
	
	
		
	//Get the current date
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");		   
	Date date = new Date();
	WriteLog("Current Date"+date);
	
	//Textarea values
	String customerAddress = ((WorkdeskAttribute)attributeMap.get("custAddress")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("custAddress")).getValue();
	//String callbackremarks1 = ((WorkdeskAttribute)attributeMap.get("remarks1")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("remarks1")).getValue();
	//String callbackremarks2 = ((WorkdeskAttribute)attributeMap.get("remarks2")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("remarks2")).getValue();
	//String callbackremarks3 = ((WorkdeskAttribute)attributeMap.get("remarks3")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("remarks3")).getValue();
		//out.print(remarks+"dddd");
	String csoDecision = ((WorkdeskAttribute)attributeMap.get("dec_CSO_Exceptions")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("dec_CSO_Exceptions")).getValue();
	
	
	String benefName = ((WorkdeskAttribute)attributeMap.get("benef_name")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("benef_name")).getValue();
	benefName = benefName.trim();
	
	DateFormat dateFormatScanDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");		   
	String tempScanDate = dateFormatScanDateTime.format(date);
	WriteLog("tempScanDate "+tempScanDate);

	String scanDate = ((WorkdeskAttribute)attributeMap.get("scanDate")).getValue();

	if(scanDate==null || scanDate == "")
		scanDate = tempScanDate;

	WriteLog("scanDate "+scanDate);
	
	//Ops_Checker Calculation
	String signMatchNeededAtChecker = "";
	if (workstepName.equals("Ops_Checker") || workstepName.equals("Ops_Checker_DB"))
	{
		String strMidRate = ((WorkdeskAttribute)attributeMap.get("midRate")).getValue() == null?"":((WorkdeskAttribute)attributeMap.get("midRate")).getValue();

		if (strMidRate!="" && strMidRate!=null && !strMidRate.equalsIgnoreCase("NULL"))
		{
		    float floatMidRate = Float.parseFloat(strMidRate);
		    // Changed by Amandeep for parametrization of Dual Authorization limit, 
			// with a fallback value in case not defined in DB
			float limitFromDB = 1000000;
     
			try{
			   String strQueryForLimit = "select top 1 CONST_FIELD_VALUE as limit from USR_0_BPM_CONSTANTS with(nolock) where CONST_FIELD_NAME='TT_DualVerificationLimit'";
     
			   String sInputXMLForLimit = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQueryForLimit + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
			  // String sOutputXMLForLimit = WFCallBroker.execute(sInputXMLForLimit,  wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), 1);
			  String sOutputXMLForLimit  = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXMLForLimit);
			   
			   limitFromDB=Float.parseFloat(sOutputXMLForLimit.substring(sOutputXMLForLimit.indexOf("<limit>")+"<limit>".length(),sOutputXMLForLimit.indexOf("</limit>")));
			   
			   strQueryForLimit=null;
			   sOutputXMLForLimit=null;
			   sInputXMLForLimit=null;
			   
			}catch(Exception e){}  
     
			WriteLog("floatMidRate "+floatMidRate);
			WriteLog("Limit From DB "+limitFromDB);
		    if (floatMidRate >= limitFromDB) //Changed as it was required to be greater than and equal to
			   signMatchNeededAtChecker = "Y";
		    else
			   signMatchNeededAtChecker = "N";
		}
		else
			signMatchNeededAtChecker = "N";
	}
	
	if (workstepName.equals("CSO_Initiate"))
		scanDate = "";

	String readOnlyFlag="";
	try{
		readOnlyFlag=wdmodel.getViewMode();//get ReadOnly or not
		WriteLog("readOnlyFlag "+readOnlyFlag);
	}catch(Exception e){}
	String strHideReadOnly="";
	String strDisableReadOnly="";
	if(readOnlyFlag!=null && readOnlyFlag.equalsIgnoreCase("R"))
	{
		strHideReadOnly="style='display:none'";
		strDisableReadOnly="disabled";
	}
		WriteLog("strHideReadOnly "+strHideReadOnly);
		WriteLog("strDisableReadOnly "+strDisableReadOnly);
%>


<html>
    <head>
	<script language="javascript">	
			document.onkeydown = mykeyhandler;
			function mykeyhandler() {
				var elementType=window.event.srcElement.type;
				var eventKeyCode=window.event.keyCode;
				var isAltKey=window.event.altKey;
				if(eventKeyCode==83 && isAltKey){
					window.parent.workdeskOperations('S');//Save Workitem
				}
				else if(eventKeyCode==73 && isAltKey){
					window.parent.workdeskOperations('I');//Introduce Workitem
				}
				else if (eventKeyCode == 116) {
					window.event.keyCode = 0;
					return false;
				}else if (eventKeyCode == 8 && elementType!='text' && elementType!='textarea' && elementType!='submit' && elementType!='password' ) {
					window.event.keyCode = 0;
					return false;
				}
			}
			
			document.MyActiveWindows= new Array;
	
			function openWindow(sUrl,sName,sProps)
			{
				document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
			}	
			
			/*function closeAllWindows()
			{
				for(var i = 0;i < document.MyActiveWindows.length; i++)
					document.MyActiveWindows[i].close();
			}*/
	
			//window.onunload = function(){closeAllWindows()};
			
		</script>
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
        <title>Outward Remittance Process</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="bootstrap.min.css">
		<link rel="stylesheet" href="css/TT.css">
    </head>
    <body onload="window.parent.checkIsFormLoaded();initForm('<%=workstepName%>','<%=wdmodel.getViewMode()%>');"  id="frmData">
	<div id="outerDiv">
		<form name="wdesk" id="wdesk" method="post">
			<style>
				@import url("/webdesktop/webtop/en_us/css/docstyle.css");
			</style>
				<div class="accordion" id="accordion1" class="accordion-group">
					<div class="accordion-group">
						<div class="accordion-heading">
							<h4 class="panel-title" style=" text-align: center; margin-top: 0.5%;color: white;">
								<b>Outward Remittance Process</b>
							</h4>
						</div>
						<div>
							<div class="accordion-inner">
								<table border='2' cellspacing='1' cellpadding='0' width=100%>									
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Date</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:requestDate" id="wdesk:requestDate" value='<%=((WorkdeskAttribute)attributeMap.get("requestDate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("requestDate")).getValue()%>'>
										</td>
										<td colspan="2" width="100%" height="100%" align="right" valign="center">
											<img src="\webdesktop\webtop\images\bank-logo.gif">
										</td>
									</tr>
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Logged In As</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<input type="text" disabled name="login_user" id="login_user" value='<%=wDSession.getM_objUserInfo().getM_strUserName()%>'>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>WorkStep</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<input type="text" disabled name="workstep_name" id="workstep_name" value='<%=workstepName%>'>
										</td>
									</tr>
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Work Item Number</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<input type='text' disabled name="wdesk:wi_name" id="wdesk:wi_name" value='<%=wdmodel.getWorkitem().getProcessInstanceId()%>'/>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>TT initiation Date</td>
										<td class='EWNormalGreenGeneral1 width25'>								
											<input type="text" disabled name="wdesk:scanDate" id="wdesk:scanDate" value='<%=((WorkdeskAttribute)attributeMap.get("scanDate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("scanDate")).getValue()%>'>
										</td>
									</tr>
									<%if(!workstepName.equalsIgnoreCase("OPS_Initiate"))
									{
										String strChannelvalue="";
										strChannelvalue=((WorkdeskAttribute)attributeMap.get("channel_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("channel_id")).getValue();
										if(strChannelvalue==null||strChannelvalue.equals(""))
											strChannelvalue="Branch/Front Office";
									%>
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Channel</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<input type="text" disabled name="wdesk:channel_id" id="wdesk:channel_id"  value='<%=strChannelvalue%>'>
										</td>
										<td class='EWNormalGreenGeneral1' colspan="2">&nbsp;</td>
									</tr>
									<%}%>
								</table>
							</div>
						</div>	
					</div>
			  </div>
<%

//Loading views according to the workstep	
WriteLog("workstepName to get form:"+workstepName);
if(workstepName.equalsIgnoreCase("CSO_Initiate"))
{
%>
	<%@ include file = "../TT_Specific/views/CSO_Initiate.jsp" %>
<%
}
else if(workstepName.equalsIgnoreCase("Treasury"))
{
%>
	<%@ include file = "../TT_Specific/views/Treasury.jsp" %>
<%
}
else if(workstepName.equalsIgnoreCase("Ops_Initiate"))
{
%>
	<%@ include file = "../TT_Specific/views/OPS_Initiate.jsp" %>
	
<%
}
else if(workstepName.equalsIgnoreCase("Ops_DataEntry"))
{
%>
	<%@ include file = "../TT_Specific/views/Ops_DataEntry.jsp" %>
<%}
else if (workstepName.equalsIgnoreCase("RemittanceHelpDesk_Checker") || workstepName.equalsIgnoreCase("RemittanceHelpDesk_Maker"))
{
%>
	<%@ include file = "../TT_Specific/views/Remittance_HelpDesk.jsp" %>
<%
}
else if(workstepName.equalsIgnoreCase("CallBack"))
{
%>
			
	<%@ include file = "../TT_Specific/views/CallBack.jsp" %>	
<%
}
else if(workstepName.equalsIgnoreCase("Comp_Check"))
{
%>
	<%@ include file = "../TT_Specific/views/Comp_Check.jsp" %>	
			
<%
}
else if(workstepName.equalsIgnoreCase("CSO_Exceptions"))
{
%>
	<%@ include file = "../TT_Specific/views/CSO_Exceptions.jsp" %>
			
<%
}
else if(workstepName.equalsIgnoreCase("PostCutOff_Init"))
{
%>
	<%@ include file = "../TT_Specific/views/PostCutOff_Init.jsp" %>
			
<%
}
else if(workstepName.equalsIgnoreCase("Ops_Maker") || workstepName.equalsIgnoreCase("Ops_Maker_DB"))
{
%>
	<%@ include file = "../TT_Specific/views/Ops_Maker.jsp" %>
	
	<%
	if(workstepName.equalsIgnoreCase("Ops_Maker_DB"))
	{
	%>
		<input type="hidden" name="wdesk:forNonComplianceEmailID" id="wdesk:forNonComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()%>' >
		<input type="hidden" name="wdesk:forComplianceEmailID" id="wdesk:forComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()%>' >
	<%
	}
	%>
	
<%
}
else if(workstepName.equalsIgnoreCase("Ops_Checker") || workstepName.equalsIgnoreCase("Ops_Checker_DB"))
{
%>
	<%@ include file = "../TT_Specific/views/Ops_Checker.jsp" %>
<%
}
else if (workstepName.equalsIgnoreCase("Error"))
{
%>
	<%@ include file = "../TT_Specific/views/Error.jsp" %>
<%
}
else
{
	
%>
	<%@ include file = "../TT_Specific/views/Others.jsp" %>
<%
}

%>
					<div class="accordion-group" >
						<div class="accordion-heading">
							<h4 class="panel-title">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel6">
									<b>Decision</b>
								</a>
							</h4>
						</div>
						<div id="panel6" class="accordion-body collapse">
							<div class="accordion-inner">
								 <table border='1' cellspacing='1' cellpadding='0' width=100% >									
									<%
									if (!(workstepName.equalsIgnoreCase("OPS_Initiate") || workstepName.equalsIgnoreCase("PostCutOff_Init")))
									{
									%>
										<tr width=100% id="memoPadV">
											<td width="10%" class='EWNormalGreenGeneral1' id="memoPadL">Memo Pad</td>
											<td width="90%" id="memoPadOuter" colspan="3"  class='EWNormalGreenGeneral1'>
												<div class="search-table-outter wrapper">
														<table id="memo_pad" class="search-table inner" border="1">
															<tr>
																<th class='EWNormalGreenGeneral1' style='width:45px !important'><b>S.No</b></th>
																<th class='EWNormalGreenGeneral1' style='min-width:170px !important'><b>Description</b></th>
															</tr>
														</table>
												</div>
											</td>
										</tr>
								
								<%
									}
									
									if (true)
									{
								%>
										<tr class="width100" id="decisionRejectReason">
											<td class='EWNormalGreenGeneral1 width25' id="decisionL">Decision
												<label class="mandatory" id="decisionM">&nbsp;*</label>
											</td>
											<td class='EWNormalGreenGeneral1 width25' id="decisionF">
												<% 
													if (workstepName.equalsIgnoreCase("Ops_Checker") || workstepName.equalsIgnoreCase("Ops_Checker_DB") || workstepName.equalsIgnoreCase("Ops_Maker") || workstepName.equalsIgnoreCase("Ops_Maker_DB")|| workstepName.equalsIgnoreCase("RemittanceHelpDesk_Checker") || workstepName.equalsIgnoreCase("RemittanceHelpDesk_Maker"))
													{
												%>
													<select <%=strDisableReadOnly%> style="width:190px" id="decisionRoute" name="decisionRoute" onchange="changeVal(this,'<%=workstepName%>')">
													</select>
												<% 
													}
													else 
													{
												%>
												
												<select <%=strDisableReadOnly%> style="width:190px" id="decisionRoute" name="decisionRoute" onchange="changeVal(this,'<%=workstepName%>')">
													<option value="--Select--">--Select--</option>
												</select>
												<%
													}
												%>
											</td>
											<td class='EWNormalGreenGeneral1 width25' id="rejectreasonL">
												<% 
													if (workstepName.equalsIgnoreCase("CSO_Initiate") || workstepName.equalsIgnoreCase("Comp_Check") || workstepName.equalsIgnoreCase("CSO_Exceptions"))
													{
												%>
														<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnRejReason" onclick="openCustomDialog('Reject Reasons','<%=workstepName%>');" value="Reject Reasons">
												<% 
													}
												%>
											</td>        		
											<td class='EWNormalGreenGeneral1 width25'>
											<%
													if (!workstepName.equalsIgnoreCase("OPS_Initiate"))
													{
												%>
													<input type="button" class='EWButtonRB' id="dec_history" value="Decision History" onclick="openCustomDialog('Save History','<%=workstepName%>')">
												<% 
													}
												%>
											</td>
											
										</tr>
										<%
											if (workstepName.equalsIgnoreCase("Error"))
											{
										%>		
											<tr class="width100" id="decisionRejectReason">
												<td class='EWNormalGreenGeneral1 width25' id="decisionL">Retry</td>
												<td class='EWNormalGreenGeneral1 width25' id="decisionL">
													<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnRetryIntegration" onclick="retryIntegration();" value="Retry">
												</td>
												<td class='EWNormalGreenGeneral1 width50' colspan="2" id="decisionL"></td>
											</tr>
										<%
											}
										%>
										
										<% 
									}
									if ( workstepName.equals("RemittanceHelpDesk_Checker") || workstepName.equals("RemittanceHelpDesk_Maker") || workstepName.equals("Ops_Maker") || workstepName.equals("Ops_Maker_DB"))
									{
								%>
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Sign Matched
											<label class="mandatory" id="SignMatchM">&nbsp;*</label>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>
											
											<%
											if (workstepName.equals("RemittanceHelpDesk_Checker"))
											{
											%>
											<select <%=strHideReadOnly%> <%=strDisableReadOnly%> id="signMatchDropDown" style="width:100%" onchange="setComboValueToTextBox(this,'wdesk:sign_matched')">
												<option value="">--Select--</option>
												<option value="Yes">Yes</option>
												<option value="No">No</option>
											</select>
											<input type='hidden' name="wdesk:sign_matched" id="wdesk:sign_matched" value='<%=((WorkdeskAttribute)attributeMap.get("sign_matched")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sign_matched")).getValue()%>' maxlength = '10'>
											<%
											}
											else {
											%>
												<input type='text' disabled name="wdesk:sign_matched" id="wdesk:sign_matched" value='<%=((WorkdeskAttribute)attributeMap.get("sign_matched")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sign_matched")).getValue()%>' maxlength = '10'>
											<%
												}
											%>											
										</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
									</tr>									
									
								<%
									}
								%>
								
								<% 								
									if ((workstepName.equals("Ops_Checker") || workstepName.equals("Ops_Checker_DB")) && signMatchNeededAtChecker.equals("Y"))
									{
								%>
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Sign Matched</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<select <%=strHideReadOnly%> <%=strDisableReadOnly%> id="signMatchDropDown" style="width:100%" onchange="setComboValueToTextBox(this,'wdesk:sign_matchedAtChecker')">
												<option value="">--Select--</option>
												<option value="Yes">Yes</option>
												<option value="No">No</option>
											</select>
											<input type='hidden' name="wdesk:sign_matchedAtChecker" id="wdesk:sign_matchedAtChecker" value='<%=((WorkdeskAttribute)attributeMap.get("sign_matchedAtChecker")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sign_matchedAtChecker")).getValue()%>' maxlength = '10'>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
									</tr>
								<%
									}
								%>
								
								<% 			
									if (workstepName.equals("RemittanceHelpDesk_Maker") || workstepName.equals("RemittanceHelpDesk_Checker") ||workstepName.equals("Comp_Check") || workstepName.equals("CSO_Exceptions"))
									{
								%>
										<tr class="width100" id="deletePaymentDiv" style="display:none;">
											<td class='EWNormalGreenGeneral1 width25'>Payment Deletion Finacle</td>
											<td class='EWNormalGreenGeneral1 width25'>
												<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnDeletePayFromFinacle" onclick="deletePaymentFromFinacle();" value="Retry - Payment Deletion">
											</td>
											<td class='EWNormalGreenGeneral1 width25'>Send to Error Queue</td>
											<td class='EWNormalGreenGeneral1 width25'>
												<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnSendToError" onclick="sendToErrorQueue();" value="Send">
											</td>
										</tr>
								<%
									}
								%>
								
								<%
									if (workstepName.equals("Ops_Maker") || workstepName.equals("Ops_Maker_DB") || workstepName.equals("Ops_Checker") || workstepName.equals("Ops_Checker_DB"))
									{
								%>
										<tr class="width100" id="deletePaymentDiv" style="display:none;">
											<td class='EWNormalGreenGeneral1 width25'>Event Notification</td>
											<td class='EWNormalGreenGeneral1 width25'>
												<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnStatusFinacle" onclick="retryIntegAtMakerChecker('<%=workstepName%>');" value="Retry - Event Notification">
											</td>
											<td class='EWNormalGreenGeneral1 width25'>Send to Error Queue</td>
											<td class='EWNormalGreenGeneral1 width25'>
												<input type="button" <%=strDisableReadOnly%>  class='EWButtonRB' id="btnSendToError" onclick="sendToErrorQueue();" value="Send">
											</td>
										</tr>
								<%
									}
								%>
								
								<%
									if (workstepName.equals("Comp_Check"))
									{
								%>
									<tr class="width100" id="assignToRow" style="display:none;">
										<td class='EWNormalGreenGeneral1 width25'>Assign To</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<select <%=strHideReadOnly%> <%=strDisableReadOnly%> id="assignToDropDown" style="width:100%" onchange="setComboValueToTextBox(this,'wdesk:assignToCompliance')">
												<option value="">--Select--</option>
											</select>
											<input type='hidden' name="wdesk:assignToCompliance" id="wdesk:assignToCompliance" value='<%=((WorkdeskAttribute)attributeMap.get("assignToCompliance")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("assignToCompliance")).getValue()%>' maxlength = '100'>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
									</tr>									
								<%
									}
								%>
								
								<%
									if (workstepName.equals("CSO_Exceptions")) 
									{
								%>
									<tr class="width100" id="assignToRow" style="display:none;">
										<td class='EWNormalGreenGeneral1 width25'>Assign To</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<select <%=strHideReadOnly%> <%=strDisableReadOnly%> id="assignToDropDown" style="width:100%" onchange="setComboValueToTextBox(this,'wdesk:assignToBusiness')">
												<option value="">--Select--</option>
											</select>
											<input type='hidden' name="wdesk:assignToBusiness" id="wdesk:assignToBusiness" value='<%=((WorkdeskAttribute)attributeMap.get("assignToBusiness")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("assignToBusiness")).getValue()%>' maxlength = '100'>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
									</tr>									
								<%
									}
								%>
								
								<%
									if (workstepName.equals("Comp_Check")) 
									{
								%>
									<tr class="width100" id="sendToRow" style="display:none;">
										<td class='EWNormalGreenGeneral1 width25'>Send To</td>
										<td class='EWNormalGreenGeneral1 width25'>
											<select <%=strHideReadOnly%> <%=strDisableReadOnly%> id="sendToDropDown" style="width:100%" onchange="setComboValueToTextBox(this,'wdesk:sendToGroup')">
												<option value="">--Select--</option>
												<option value="WMC">WM controls</option>
												<option value="SME">SME Controls</option>
												<option value="CBD">CBD RO</option>
											</select>
											<input type='hidden' name="wdesk:sendToGroup" id="wdesk:sendToGroup" value='<%=((WorkdeskAttribute)attributeMap.get("sendToGroup")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sendToGroup")).getValue()%>' maxlength = '100'>
										</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
										<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
									</tr>									
								<%
									}
								%>
								
									<tr class="width100">
										<td class='EWNormalGreenGeneral1 width25'>Remarks</td>
										<td class='EWNormalGreenGeneral1 width75' colspan="3">
											<%if (!(workstepName.equals("Archive")||workstepName.equals("Archive_Exit")||workstepName.equals("Archive_Discard")||workstepName.equals("Exit")||workstepName.equals("Discard1")))
											{%>
												<textarea style="width:100%" name="wdesk:remarks"  id="wdesk:remarks" onblur="trimLength(this.id,this.value,2000);"  onkeypress="if (this.value.length > 1999) { return false; }" rows="6" cols="50" WRAP= "HARD"  maxlength = '2000'></textarea>
											<%}
											else
											{%>
												<textarea style="width:100%" name="wdesk:remarks"  id="wdesk:remarks" disabled rows="6" cols="50" WRAP= "HARD"  maxlength = '2000'></textarea>
											<%}%>
											
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
			

				<!--Hidden fields according to the actors -->
				
				<!--dec_CSO_Branch-->
					<input type="hidden" id="wdesk:dec_CSO_Branch" name="wdesk:dec_CSO_Branch" value='<%=((WorkdeskAttribute)attributeMap.get("dec_CSO_Branch")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_CSO_Branch")).getValue()%>' maxlength = '50'>
				
				<!--dec_treasury-->
					<input type="hidden" id="wdesk:dec_treasury" name="wdesk:dec_treasury" value='<%=((WorkdeskAttribute)attributeMap.get("dec_treasury")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_treasury")).getValue()%>' maxlength = '50'>
				
				<!--dec_rem_helpdesk-->

					<input type="hidden" id="wdesk:dec_rem_helpdesk" name="wdesk:dec_rem_helpdesk" value='<%=((WorkdeskAttribute)attributeMap.get("dec_rem_helpdesk")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_rem_helpdesk")).getValue()%>' >
					
				<!--dec_rem_helpdeskMaker-->

					<input type="hidden" id="wdesk:dec_rem_helpdeskMaker" name="wdesk:dec_rem_helpdeskMaker" value='<%=((WorkdeskAttribute)attributeMap.get("dec_rem_helpdeskMaker")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_rem_helpdeskMaker")).getValue()%>' >
					
				<!--decCallBack-->

					<input type='hidden' name="wdesk:decCallBack" id="wdesk:decCallBack" value='<%=((WorkdeskAttribute)attributeMap.get("decCallBack")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("decCallBack")).getValue()%>' >
				
				<!--decCompCheck-->

					<input type='hidden' name="wdesk:complaince_sucess" id="wdesk:complaince_sucess" value='<%=((WorkdeskAttribute)attributeMap.get("complaince_sucess")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("complaince_sucess")).getValue()%>'>
					<input type='hidden' name="wdesk:decCompCheck" id="wdesk:decCompCheck" value='<%=((WorkdeskAttribute)attributeMap.get("decCompCheck")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("decCompCheck")).getValue()%>'>
				
				<!--dec_maker-->
					<input type="hidden" id="wdesk:dec_maker" name="wdesk:dec_maker" value='<%=((WorkdeskAttribute)attributeMap.get("dec_maker")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_maker")).getValue()%>'>
				
				<!--dec_checker-->
					<input type="hidden" id="wdesk:dec_checker" name="wdesk:dec_checker" value='<%=((WorkdeskAttribute)attributeMap.get("dec_checker")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_checker")).getValue()%>' >
					
				<!--dec_maker_DB-->
					<input type="hidden" id="wdesk:dec_maker_DB" name="wdesk:dec_maker_DB" value='<%=((WorkdeskAttribute)attributeMap.get("dec_maker_DB")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_maker_DB")).getValue()%>'>
				
				<!--dec_checker_DB-->
					<input type="hidden" id="wdesk:dec_checker_DB" name="wdesk:dec_checker_DB" value='<%=((WorkdeskAttribute)attributeMap.get("dec_checker_DB")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_checker_DB")).getValue()%>' >
					
				<!--CREATE_WI_STATUS-->
					<input type="hidden" id="wdesk:CREATE_WI_STATUS" name="wdesk:CREATE_WI_STATUS" value='<%=((WorkdeskAttribute)attributeMap.get("CREATE_WI_STATUS")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("CREATE_WI_STATUS")).getValue()%>' >
				
				<!--dec_CSO_Exceptions-->
					<input type="hidden" id="wdesk:dec_CSO_Exceptions" name="wdesk:dec_CSO_Exceptions" value='<%=((WorkdeskAttribute)attributeMap.get("dec_CSO_Exceptions")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_CSO_Exceptions")).getValue()%>'>
					
				<!--dec_Ops_DataEntry-->
					<input type="hidden" id="wdesk:dec_Ops_DataEntry" name="wdesk:dec_Ops_DataEntry" value='<%=((WorkdeskAttribute)attributeMap.get("dec_Ops_DataEntry")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("dec_Ops_DataEntry")).getValue()%>'>
				
				<!--dec_Ops_Hold-->
					
				<!--Error-->
					<input type="hidden" id="wdesk:decError" name="wdesk:decError" value='<%=((WorkdeskAttribute)attributeMap.get("decError")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("decError")).getValue()%>'>
				
				<table>
					<input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='<%=workstepName%>'/>	
					<input type='hidden' name="workitemId" id="workitemId" value='<%=wdeskwid_Esapi%>'/>	
					<input type="hidden" id="wdesk:H_CHECKLIST" name="wdesk:H_CHECKLIST" value='<%=((WorkdeskAttribute)attributeMap.get("H_CHECKLIST")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("H_CHECKLIST")).getValue()%>'>
					<input type="hidden" id="FlagToCheckReqDate" name="FlagToCheckReqDate"/>
					<input type="hidden" id="rejReasonCodes" name="rejReasonCodes" />
					<input type="hidden" id="wdesk:remarks1" name="wdesk:remarks1" value='<%=((WorkdeskAttribute)attributeMap.get("remarks1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remarks1")).getValue()%>'>
					<input type="hidden" id="wdesk:is_po_created" name="wdesk:is_po_created" value='<%=((WorkdeskAttribute)attributeMap.get("is_po_created")).getValue()==null?"Y":((WorkdeskAttribute)attributeMap.get("is_po_created")).getValue()%>'>
				
					<input type="hidden" id="wdesk:isRestrictedFlag" name="wdesk:isRestrictedFlag" value='<%=((WorkdeskAttribute)attributeMap.get("isRestrictedFlag")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isRestrictedFlag")).getValue()%>'>
					
					<input type="hidden" id="wdesk:isHandWritten" name="wdesk:isHandWritten" value='<%=((WorkdeskAttribute)attributeMap.get("isHandWritten")).getValue()==null?"Y":((WorkdeskAttribute)attributeMap.get("isHandWritten")).getValue()%>'>

					<input type="hidden" id="wdesk:ibanValNeeded" name="wdesk:ibanValNeeded" value=''>
					<input type="hidden" id="wdesk:ibanLength" name="wdesk:ibanLength" value=''>
					<input type="hidden" id="wdesk:acc_status" name="wdesk:acc_status" value='<%=((WorkdeskAttribute)attributeMap.get("acc_status")).getValue()	==null?"Y":((WorkdeskAttribute)attributeMap.get("acc_status")).getValue()%>'>					
					<input type="hidden" name="wdesk:Amount" id="wdesk:Amount" value=''>
					<input type="hidden" name="wdesk:isCallBackWaivedOff" id="wdesk:isCallBackWaivedOff"  value='<%=((WorkdeskAttribute)attributeMap.get("isCallBackWaivedOff")).getValue()	==null?"Y":((WorkdeskAttribute)attributeMap.get("isCallBackWaivedOff")).getValue()%>'>
	
					<input type="hidden" name="wdesk:dualAuth" id="wdesk:dualAuth" value='No'>
					<!--Use this field to check that decision history is clicked or not at maker-->
					<input type="hidden" name="flagForDecHisButton" id="flagForDecHisButton" value=''>
					<input type="text" style="display:none;" name="postCutOffTimetoDB" id="postCutOffTimetoDB" value=''>
					<input type="hidden" name="wdesk:countryCode" id="wdesk:countryCode" value='<%=((WorkdeskAttribute)attributeMap.get("countryCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("countryCode")).getValue()%>'>
					<input type="hidden" name="wdesk:prev_WS" id="wdesk:prev_WS" value='<%=((WorkdeskAttribute)attributeMap.get("prev_WS")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("prev_WS")).getValue()%>'>
					<input type="hidden" name="wdesk:currentWS" id="wdesk:currentWS" value='<%=((WorkdeskAttribute)attributeMap.get("currentWS")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("currentWS")).getValue()%>'>
					<input type="hidden" name="signMatchNeededAtChecker" id="signMatchNeededAtChecker" value='<%=signMatchNeededAtChecker%>'>
					<input type="text" style="display:none" name="wdesk:isSignatureExcepRaised" id="wdesk:isSignatureExcepRaised" value='<%=((WorkdeskAttribute)attributeMap.get("isSignatureExcepRaised")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isSignatureExcepRaised")).getValue()%>'>
					<input type="hidden" name="wdesk:IsBankEmployee" id="wdesk:IsBankEmployee" value='<%=((WorkdeskAttribute)attributeMap.get("IsBankEmployee")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("IsBankEmployee")).getValue()%>'>
					<input type="hidden" name="wdesk:isPayDelFromFinacle" id="wdesk:isPayDelFromFinacle" value=''>
					<input type="hidden" name="wdesk:isStatusSyncUp" id="wdesk:isStatusSyncUp" value=''>
					<input type="hidden" name="sendBtnClicked" id="sendBtnClicked" value=''>
					<input type="hidden" name="wdesk:isInsuffExcepRaise" id="wdesk:isInsuffExcepRaise" value='<%=((WorkdeskAttribute)attributeMap.get("isInsuffExcepRaise")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isInsuffExcepRaise")).getValue()%>'>
					<input type="hidden" name="wdesk:errorMsgFromFinacle" id="wdesk:errorMsgFromFinacle" value='<%=((WorkdeskAttribute)attributeMap.get("errorMsgFromFinacle")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("errorMsgFromFinacle")).getValue()%>'><input type="hidden" name="wdesk:failedIntegrationCall" id="wdesk:failedIntegrationCall" value='<%=((WorkdeskAttribute)attributeMap.get("failedIntegrationCall")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("failedIntegrationCall")).getValue()%>'>
					<input type="hidden" name="wdesk:isEventNotifySuccess" id="wdesk:isEventNotifySuccess" value='<%=((WorkdeskAttribute)attributeMap.get("isEventNotifySuccess")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isEventNotifySuccess")).getValue()%>'>
					<input type="hidden" name="wdesk:routeToErrorQ" id="wdesk:routeToErrorQ" value='<%=((WorkdeskAttribute)attributeMap.get("routeToErrorQ")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("routeToErrorQ")).getValue()%>'>
					<input type="hidden" name="memopadFetchSuccess" id="memopadFetchSuccess" value=''>
					<input type="hidden" name="outputAmount" id="outputAmount" value=''>
					<input type="hidden" name="outputAmountMidRate" id="outputAmountMidRate" value=''>
					<input type="hidden" name="wdesk:strCode" id="wdesk:strCode" value='<%=((WorkdeskAttribute)attributeMap.get("strCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("strCode")).getValue()%>'>
					<input type="hidden" name="wdesk:remarks3" id="wdesk:remarks3" value='<%=((WorkdeskAttribute)attributeMap.get("remarks3")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remarks3")).getValue()%>'>
					<input type="hidden" name="wdesk:remarks2" id="wdesk:remarks2" value='<%=((WorkdeskAttribute)attributeMap.get("remarks2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remarks2")).getValue()%>'>
					<input type="hidden" name="wdesk:isAnyExcepRaised" id="wdesk:isAnyExcepRaised" value='<%=((WorkdeskAttribute)attributeMap.get("isAnyExcepRaised")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isAnyExcepRaised")).getValue()%>'>
					<input type="hidden" name="wdesk:exceptionsRoutedByUsrName" id="wdesk:exceptionsRoutedByUsrName" value='<%=wDSession.getM_objUserInfo().getM_strUserName()%>'>
					<input type="hidden" name="wdesk:exceptionsRaisedForEmail" id="wdesk:exceptionsRaisedForEmail" value='<%=((WorkdeskAttribute)attributeMap.get("exceptionsRaisedForEmail")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("exceptionsRaisedForEmail")).getValue()%>'>
					<input type="hidden" name="wdesk:complaince_sucess" id="wdesk:complaince_sucess" value='<%=((WorkdeskAttribute)attributeMap.get("complaince_sucess")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("complaince_sucess")).getValue()%>'>
					<input type="hidden" name="wdesk:rateCode" id="wdesk:rateCode" value='<%=((WorkdeskAttribute)attributeMap.get("rateCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("rateCode")).getValue()%>'>
					<input type="hidden" name="call_Waiver_Remarks" id="call_Waiver_Remarks" value='<%=((WorkdeskAttribute)attributeMap.get("callbackwaiver")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("callbackwaiver")).getValue()%>'>
					
					<input type="hidden" name="wdesk:isBusinessExcp" id="wdesk:isBusinessExcp" value='<%=((WorkdeskAttribute)attributeMap.get("isBusinessExcp"))==null?"":((WorkdeskAttribute)attributeMap.get("isBusinessExcp")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isBusinessExcp")).getValue()%>'>

					<%
						if (!(workstepName.equals("Ops_Checker") || workstepName.equals("Ops_Checker_DB")))
						{
					%>
							<input type="hidden" name="wdesk:midRate" id="wdesk:midRate" value='<%=((WorkdeskAttribute)attributeMap.get("midRate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("midRate")).getValue()%>'>
					<%
						}
					%>

					<!-- Following is needed to send workitem to the Discard when Workitem is at callback and Status is Deleted-->
					<input type="hidden" name="wdesk:isRejected" id="wdesk:isRejected" value='<%=((WorkdeskAttribute)attributeMap.get("isRejected")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isRejected")).getValue()%>'>
					
					<!-- Start - Changes done for Cross Border payment CR - 13082017 -->
					<input type="hidden" name="wdesk:isRetailCust" id="wdesk:isRetailCust" value='<%=((WorkdeskAttribute)attributeMap.get("isRetailCust")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isRetailCust")).getValue()%>'>

				</table>
		</form>
</div>
<script src="jquery.min.js"></script>
		<script language="text/javascript">
			$(document).ready(function(){
				$( "input,select,textarea").hover(function() {
					$(this).attr('title', this.value);
				});
			});
		</script>
		<!-- Start - Changes done for Cross Border payment CR - 13082017 -->
		<script>
				//Below code will be executed on change of trans type
				$(document).ready(function() {
					var maxLength = 30;
					$("#transtype").change(function() {
						$('#transcode > option').text(function(i, text) {
						if (text.length > maxLength) {
							return text.substr(0, maxLength) + '...';  
							}
						});
					});
				});
				//******************************************************
				//Below code will be executed after transcode dropdown load
				var jqueryFunctionForTransCode;
				$(document).ready(function() {
				//jQuery function
					jqueryFunctionForTransCode=function()
					{
						var maxLength = 30;
						$('#transcode > option').text(function(i, text) {
						if (text.length > maxLength) {
							return text.substr(0, maxLength) + '...';  
							}
						});
					}
				});
				//************************************************************
		</script>
		<!-- End - Changes done for Cross Border payment CR - 13082017 -->
		<script src="bootstrap.min.js"></script>		
		<script>
		//Global vraiable to check that memopad has been fired once

		function addCommas(nStr)
		{
			if(nStr=="") return "";
			nStr += '';
			x = nStr.split('.');
			x1 = x[0];
			x2 = x.length > 1 ? '.' + x[1] : '.00';
			if(x2.length==1) x2=x2+'00'; 
			else if(x2.length==2) x2=x2+'0'; 
			var rgx = /(\d+)(\d{3})/;
			while (rgx.test(x1)) {
				x1 = x1.replace(rgx, '$1' + ',' + '$2');
			}
			if((x1 + x2) =="NaN.00")
				return "";
			return x1 + x2;
		}
		
		function addCommasForTransAmt(nStr,decimalPoint)
		{
			var zeroes = "";
			var dot = ".";
			var x1 = "";
			var x2 = "";
			var rgx = /(\d+)(\d{3})/;

			if(nStr=="") 
				return "";

			nStr += '';
			
			if (decimalPoint != 0) {
				for(var i=0;i<decimalPoint;i++)
					zeroes=zeroes+'0';
			}

			if (nStr.indexOf(dot) == -1) {
				x1 = nStr;				
				while (rgx.test(x1))
					x1 = x1.replace(rgx, '$1' + ',' + '$2');

				if (decimalPoint!=0)
					x2 = dot + zeroes;
				
				if (x1 =="NaN")
					return "";
			}
			else {
				var x = nStr.split('.');
				x1 = x[0];				
				while (rgx.test(x1))
					x1 = x1.replace(rgx, '$1' + ',' + '$2');
				
				//Handling of bymistake dot given at the end of input
				if (x[1] != "")
					x2 = dot + x[1];
				else if (decimalPoint!=0)
					x2 = dot + zeroes;
			}
			return x1 + x2;
		}
		
		function currencyFormatPref (object)
		{
			var validateRate = /^\d{1,3}\.?\d{1,10}$/;
			var fVal = /^\d{1,3}$/;
			var sVal = /^\d{1,10}$/;
			
			num = document.getElementById(object.id).value;
			var lng = num.length;
			if(lng >0)
			{
				if(num.indexOf(".") == -1)
				{
					if(num.length> 14 || !num.match(fVal))
					{
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						document.getElementById(object.id).focus();
						return;
					}
				}else{
					var firstPart = num.substring(0,num.indexOf("."));
					var secondPart = num.substring(num.indexOf(".")+1);

					if(firstPart.length> 3 || secondPart.length > 10||!secondPart.match(sVal))
					{
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						document.getElementById(object.id).focus();
						return;
					}
					if( !firstPart.match(fVal))
					{
						if(firstPart.length==0)	{
							document.getElementById(object.id).value = "0"+num;
							return;
						}
						if(firstPart.length==1 && firstPart=="0") {
							return;
						}
						alert("Please Enter Valid Preferential Rate. (Format: $$$.$$$$$$$$$$)");
						document.getElementById(object.id).focus();
						return;
					}
				}
			}
			calculateAmt();
		}
	
		function currencyFormat (object,decimalPoint) 
		{
			var validateRate = /^\d{1,9}\.?\d{1,2}$/;
			var fVal = /^\d{1,9}$/;
			var sVal = "";
			var x="";

			if (decimalPoint != 0) {
				sVal = new RegExp("^\\d{1," + decimalPoint + "}$", "g");
				for(var i=0;i<decimalPoint;i++)
					x=x+'$';
			}
			
			num = document.getElementById(object.id).value;
			num = num.replace(/,/g, "");
			
			var lng = num.length;
			if(lng > 0){
				if(num.indexOf(".") == -1) {
				
					if((num.length > 9 || !num.match(fVal))) {
						
						if (x=="")
							alert("Please Enter Valid Transfer Amount. (Format: $$$$$$$$$)");
						else 
							alert("Please Enter Valid Transfer Amount. (Format: $$$$$$$$$."+x+")");
						document.getElementById(object.id).value = "";
						document.getElementById(object.id).focus();
						return false;
					}
				}
				else {
					var firstPart = num.substring(0,num.indexOf("."));
					var secondPart = num.substring(num.indexOf(".")+1);
					
					firstPart = firstPart.replace(/,/g, "");

					if(firstPart.length> 9 || !firstPart.match(fVal) || secondPart.length > decimalPoint || !secondPart.match(sVal))
					{
						if (x=="")
							alert("Please Enter Valid Transfer Amount. (Format: $$$$$$$$$)");
						else
							alert("Please Enter Valid Transfer Amount. (Format: $$$$$$$$$."+x+")");
						document.getElementById(object.id).value = "";
						document.getElementById(object.id).focus();
						return false;
					}
				}
			}
			document.getElementById(object.id).value = addCommasForTransAmt(num,decimalPoint);
			return true;
		}
		//This function will fire when debit account number will be change
		function onDebitAccountChange(obj)
		{
			var strCode = document.getElementById("wdesk:strCode").value;
			if (strCode=="EMPTY" || strCode=="911" || strCode=="2033" || strCode=='1362') {
				alert("Payment Creation already timed out,please discard the case");
				return false;
			}
		
			var debitAccNumber=obj.value;
			
			if(debitAccNumber==null || debitAccNumber=="" || debitAccNumber.length==0) return;
			
			var numbers = /^[0-9]+$/;
			
			if( !(debitAccNumber.match(numbers))) {
				alert("Only numbers are allowed in Debit Card Number");
				obj.focus();
				return;    
			}
			
			if(debitAccNumber.length<13) 
			{
				alert("Debit Card Account no must have 13 digits");
				obj.focus();
				return;
			}
			
			//1) First Integration calls "Account Details Fetch"
			var getCustSuccess = getCustomerDetails();
			
			if (getCustSuccess)
			{
				//2) FCY_RATE Integration call
				var boolCal = calculateAmt();
				if (boolCal != 'Error' && boolCal!=false)
				{
					//3) ACCOUNT_BALANCE_DETAILS Integration call
					var boolSetAcc = accountBalanceDetails();
					if (boolSetAcc)
					{
						//4) MemoPad Fetching from fincale and inserting into our DB
						var boolMemo = memopad(1);
						if (boolMemo)
						{
							//Fetching from the DB and showing the memopad
							memopad(2);
						}
					}
				}
			}			
		}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           This function will fire when debit account number will be change on OPS initiate Workstep

//***********************************************************************************//				
		
		//change done on 20102016 by ankit
		function onDebitAccountChangeOnOpsInitiate(obj)
		{
			var debitAccNumber=obj.value;
			if(debitAccNumber==null || debitAccNumber=="" || debitAccNumber.length==0) return;
			
			var numbers = /^[0-9]+$/;
			
			if( !(debitAccNumber.match(numbers))) {
				alert("Only numbers are allowed in Debit Card Number");
				obj.focus();
				return;    
			}
			
			if(debitAccNumber.length<13) 
			{
				alert("Debit Card Account no must have 13 digits");
				obj.focus();
				return;
			}
			//call to set sub segment fetched freom entity details call
			getCustomerDetailsOnOpsInitiate();			
		}
		function getCustomerDetailsOnOpsInitiate()
		{
			var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
			
			
			if (debt_acc_num!=null && debt_acc_num!="")
			{
				var requestType='GET_CUSTOMER_DETAILS';
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';

				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";     
				
				var param="wi_name="+wi_name+"&debt_acc_num="+debt_acc_num+"&requestType="+requestType;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching customer details.");
						return false;
					}
					var xmlDoc;
					var parser;
					if (window.showModalDialog)
					{ // Internet Explorer
						xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async=false;
						xmlDoc.loadXML(ajaxResult);
					}
					else 
					{
						// Firefox, Chrome, Opera, etc.
						parser=new DOMParser();
						xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
					}

					/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);*/

					var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
					if(strCode == '0000')
					{
						document.getElementById("wdesk:sub_segment").value = xmlDoc.getElementsByTagName("CustomerSubSeg")[0].childNodes[0].nodeValue;
						/*document.getElementById("wdesk:sol_id").value = xmlDoc.getElementsByTagName("SrcBranch")[0].childNodes[0].nodeValue;
						if(document.getElementById("wdesk:sub_segment").value=="PBN" )
						{
							document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','segmentComplianceMail'); 
						}
						else if(document.getElementById("wdesk:sub_segment").value=="PSL" || document.getElementById("wdesk:sub_segment").value=="SME" )
						{
							document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','PSLSMEEmailForCompliance'); 
						}
						else 
						{
							document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','segmentComplianceMail');
						}
						*/
						// added to set forNonComplianceEmailID on OPSInitiate for all the segment.
						document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','IBMBNonComplianceMail');
						document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','IBMBComplianceMail');
					}
				}
				else
				{
					alert("Problem in getting customer details.");
					return false;
				}
			}
			else 
			{
				return false;
			}		
	    }
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           This function is used for fetching from the DB and showing the memopad at OPS dataentry workstep

//***********************************************************************************//
function onOPSDataEntryFetchMemo() {
			var boolMemo = memopad(1);
			if (boolMemo) {
				//Fetching from the DB and showing the memopad
				memopad(2);
			}
		}
		
		function calculateAmt()
		{
			//For getting the decimal point from the DB
			var decimalPoint = ajaxRequest('CSO_Initiate','decimalPoint');

			if (typeof decimalPoint == 'undefined' || decimalPoint=="" || decimalPoint=='undefined') 
				decimalPoint = 0;

			var transCurr = document.getElementById("wdesk:transferCurr").value;
			
			if (transCurr!="" && transCurr!="--Select--")
			{
				var remitCurr= document.getElementById("wdesk:remit_amt_curr").value;
				var returnVal = currencyFormat(document.getElementById("wdesk:trans_amt"),decimalPoint);
				
				if (returnVal == false)
					return false;

				var transAmt= document.getElementById("wdesk:trans_amt").value;
				transAmt = parseFloat(transAmt.replace(/,/g,''));
				var AccCurr= document.getElementById("acc_Curr").value;
				var FinalDebitAmount= document.getElementById("wdesk:finalAmtDebitfromAcc").value;
				var prefRate = document.getElementById("wdesk:pref_rate").value;
				var ConversionRate=1.0;
				var fcy_rate=1.0;
				
				var obj=document.getElementById("transamtcurr");
				if(typeof obj!=undefined &&  obj!=null)
					transCurr=obj.value;
				
				if(transCurr=='' || remitCurr=='' || AccCurr=='' || transCurr=='--Select--' || remitCurr=='--Select--' || AccCurr=='--Select--')
				{
					document.getElementById("wdesk:fcy_rate").value='';
					document.getElementById("wdesk:remit_amt").value='';
					document.getElementById("wdesk:remit_amt_new").value='';
					document.getElementById("wdesk:finalAmtDebitfromAcc").value='';
					document.getElementById("wdesk:finalAmtDebitfromAcc_new").value='';
					return;
				}
				else
				{
					//alert(amountToDebit);
					if(transCurr!=remitCurr && transCurr!=AccCurr)
					{
						alert("Transfer Currency should be equal to remit currency or account currency");
						document.getElementById("transamtcurr").value="--Select--";
						document.getElementById("wdesk:fcy_rate").value = "";
						document.getElementById("wdesk:finalAmtDebitfromAcc").value = "";
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value = "";
						document.getElementById("wdesk:remit_amt").value = "";
						document.getElementById("wdesk:remit_amt_new").value = "";
						document.getElementById("transamtcurr").focus();
						return;		
					}
					
					fcy_rate =  getFcyRate(2);
					if (fcy_rate == 'Error' || fcy_rate==false)
					{
						document.getElementById("wdesk:fcy_rate").value = '';				
						document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value= '';
						document.getElementById("wdesk:remit_amt").value = '';
						document.getElementById("wdesk:remit_amt_new").value = '';
						return;
					}
					
					var amountToDebit = document.getElementById("outputAmount").value;//
					amountToDebit = parseFloat(amountToDebit.replace(/,/g,''));
					amountToDebit = amountToDebit.toFixed(2);
					
					if (transCurr == AccCurr)
					{
						fcy_rate = getFcyRate(2);
						if (fcy_rate == 'Error' || fcy_rate==false)
						{
							document.getElementById("wdesk:fcy_rate").value = '';				
							document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
							document.getElementById("wdesk:finalAmtDebitfromAcc_new").value= '';
							document.getElementById("wdesk:remit_amt").value = '';
							document.getElementById("wdesk:remit_amt_new").value = '';
							return;
						}
						//document.getElementById("wdesk:fcy_rate").value = fcy_rate;
						if (transCurr==remitCurr)
						{
							document.getElementById("wdesk:remit_amt").value =  addCommas(transAmt.toFixed(2));//amountToDebit;
							document.getElementById("wdesk:remit_amt_new").value =  addCommas(transAmt.toFixed(2));//amountToDebit;
						}
						else
						{
							document.getElementById("wdesk:remit_amt").value = addCommas(amountToDebit);
							document.getElementById("wdesk:remit_amt_new").value = addCommas(amountToDebit);
						}
						document.getElementById("wdesk:finalAmtDebitfromAcc").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value = addCommas(transAmt.toFixed(2));
					}
					else if (transCurr==remitCurr)
					{
						fcy_rate = getFcyRate(2);
						if (fcy_rate == 'Error' || fcy_rate==false)
						{
							document.getElementById("wdesk:fcy_rate").value = '';				
							document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
							document.getElementById("wdesk:finalAmtDebitfromAcc_new").value= '';
							document.getElementById("wdesk:remit_amt").value = '';
							document.getElementById("wdesk:remit_amt_new").value = '';
							return;
						}
						//document.getElementById("wdesk:fcy_rate").value = fcy_rate;
						document.getElementById("wdesk:remit_amt").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:remit_amt_new").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:finalAmtDebitfromAcc").value = addCommas(amountToDebit);
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value = addCommas(amountToDebit);
					}
					else if (AccCurr==remitCurr)
					{
						fcy_rate = 1;
						document.getElementById("wdesk:fcy_rate").value = fcy_rate;
						document.getElementById("wdesk:finalAmtDebitfromAcc").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:remit_amt").value = addCommas(transAmt.toFixed(2));
						document.getElementById("wdesk:remit_amt_new").value = addCommas(transAmt.toFixed(2));
					}
				}
				//Check if pref_rate is given and it is different from the fx rate
				var prefrate = document.getElementById('wdesk:pref_rate').value;
				if (prefrate !="") {
					var fcyrate = document.getElementById("wdesk:fcy_rate").value;
					if (fcyrate!=prefrate) {
						document.getElementById("wdesk:finalAmtDebitfromAcc_new").value = '';
						document.getElementById("wdesk:remit_amt_new").value = '';
					}
				}
			}
		}
		function initForm(workstepName,sMode)
		{
			$('.accordion-body').collapse('show');
			
			if (sMode=="R") return;
			//Populate the dropdown of Decision from DB for current workstep
			if (workstepName != "Archive" && workstepName !="Archive_Exit" && workstepName !="Archive_Discard" && workstepName !="Exit" && workstepName !="Discard1")	
				ajaxRequest(workstepName,'DecisionDropDown');
			
			//Delete elements from the select if needed
			if (workstepName== 'CSO_Exceptions') {
				deleteChildsFromSelect (workstepName);
			}
			
			
			var rejectReasons=document.getElementById('wdesk:remarks1').value;
			var ws_rejectReasons="";
			
			if(rejectReasons.indexOf("~")>-1)
			{
				ws_rejectReasons=rejectReasons.substring(0,rejectReasons.indexOf("~"));
				if(ws_rejectReasons!=null && ws_rejectReasons!="" && ws_rejectReasons==workstepName )	
				{
					document.getElementById('rejReasonCodes').value=document.getElementById('wdesk:remarks1').value;
					rejectReasons=rejectReasons.substring(rejectReasons.indexOf("~")+1);					
				}
				else
					document.getElementById('wdesk:remarks1').value="";
			}
			//Populate the dropdown of Languages for CallBack
			if (workstepName == 'CallBack')
			{
				ajaxRequest(workstepName,'LangaugesDropDown');
				ajaxRequest(workstepName,'dropDownCallBackCustVerf');
				ajaxRequest(workstepName,'dropDownCallBackFailureReason');
				//Copying value of Call Back required
				document.getElementById("wdesk:callBackReqDetails").value = document.getElementById("wdesk:call_back_req").value;
				
				//Select for the below if values are present
				selectElement('dropDownCallBackCustVerf','wdesk:custCallBackVer');
				selectElement('custLanguage','wdesk:custLang');
				selectElement('dropDownCallBackFailureReason','wdesk:custCallBackFailReason');
				
				var prevWs = document.getElementById("wdesk:prev_WS").value;
				if (prevWs=='CallBack'||workstepName == 'CallBack') {
					selectElement('call_back_success1','wdesk:attempt1');
					selectElement('call_back_success2','wdesk:attempt2');
					selectElement('call_back_success3','wdesk:attempt3');
					
					if(document.getElementById("call_back_success2").value==""||document.getElementById("call_back_success2").value=="--Select--" ||document.getElementById("call_back_success2").value=="Yes" )
						document.getElementById("call_back_success3").disabled=true;
					if(document.getElementById("call_back_success1").value==""||document.getElementById("call_back_success1").value=="--Select--" ||document.getElementById("call_back_success1").value=="Yes" )
						document.getElementById("call_back_success2").disabled=true;
				}
			}
		
			if (workstepName=='CSO_Initiate')
			{
				// populate value of comboboxes name from database.
				ajaxRequest(workstepName,'CurrencyDropDown');				
				ajaxRequest(workstepName,'CountryDropDown');				
				ajaxRequest(workstepName,'dropDownBenefBankCode');
				ajaxRequest(workstepName,'dropDownTranstype');
				//hide fx and account balance get buttons.
				document.getElementById('getFxRate').style.visibility='hidden'; 
				document.getElementById('getAccBalance').style.visibility='hidden';
			}
			else if (workstepName=='Ops_DataEntry')
			{
				// populate value of country name from database.
				ajaxRequest(workstepName,'CountryDropDown');				
				ajaxRequest(workstepName,'dropDownBenefBankCode');
				ajaxRequest(workstepName,'dropDownTranstype');
				//hide fx and account balance get buttons.
				document.getElementById('view_raise_excep').style.visibility='hidden'; 
				document.getElementById('getAccBalance').style.visibility='hidden';
			}
			
			if (workstepName=='RemittanceHelpDesk_Checker'||workstepName=='RemittanceHelpDesk_Maker')
			{
				//Check if the case if of type Ruling Family
				var x = document.getElementById("wdesk:cust_type");
				var y = document.getElementById("wdesk:call_back_req");
				if (x!= null && x!="" && x.value=='Ruling Family' && y != null && y != "" && y.value=='Yes')
					alert("This customer is from Ruling Family, please remove call back exception manually");
				
				x= document.getElementById("wdesk:isRulingFamily").value;
				if(x!= null && x!="" && x=='No')
					document.getElementById("callBackSuccess").disabled=true;
				else
					document.getElementById("callBackSuccess").disabled=false;

				//shamily
				var z = document.getElementById("wdesk:requestDate").value;
				if(z== null || z=="")
					alert('Date is Blank / Handwritten. Please ensure request is not Post dated or Stale dated(10 days)');				
			}
			
			//Call Exception Window First
			if (workstepName!= 'PostCutOff_Init' &&  workstepName!='CSO_Initiate' &&  workstepName!='Ops_DataEntry' && workstepName!='Ops_Hold' && workstepName!='Ops_Hold' && workstepName!='Error' )
			{
				var wi_name = '<%=wi_name%>';
				var H_CHECKLIST = document.getElementById('wdesk:H_CHECKLIST').value;
				
				if(typeof H_CHECKLIST == 'undefined' || H_CHECKLIST== null )	
					H_CHECKLIST="";
				var isanyExcp=isAnyExcpRaised(wi_name,H_CHECKLIST);
					
				if(isanyExcp!=null && isanyExcp!="" && isanyExcp.indexOf("~[Raised")>-1)
					openCustomDialog('Exception History',workstepName);
			}

			//called for only those worksteps that has Memopad visible.
			if (workstepName=='Treasury' || workstepName=='Ops_Maker'|| workstepName=='Ops_Checker' || workstepName=='Ops_Maker_DB'|| workstepName=='Ops_Checker_DB' || workstepName=='RemittanceHelpDesk_Checker' || workstepName=='RemittanceHelpDesk_Maker' || workstepName=='CallBack' || workstepName=='Comp_Check' || workstepName=='Error'|| workstepName=='Ops_DataEntry')
				memopad(2);

			//Populate all the dropdown values from the DB at the time of onload			
			if (workstepName== 'CSO_Initiate')
			{
				selectElement('countryOfResCombo','wdesk:countryOfRes');
				selectElement('transamtcurr','wdesk:transferCurr');
				selectElement('remitamtcurr','wdesk:remit_amt_curr');
				selectElement('wdesk:chargesCombo','wdesk:charges');
				selectElement('app_received','wdesk:isOriginalReceived');
				selectElement('benefBankCntryCombo','wdesk:benefBankCntry');
				selectElement('wdesk:interBankCntryCombo','wdesk:interBankCntry');
				
				selectElement('dropDownBenefBankCode','wdesk:benefBankCode');//interbank code type
				selectElement('dropDownInterBankCode','wdesk:interBankCode');//benefbank code type
				
				selectElement('transtype','wdesk:trans_type');//Transaction type
				//ajaxRequest(workstepName,"dropDwnTranscode"); // commented - Changes done for Cross Border payment CR - 13082017
				selectElement('transcode','wdesk:trans_code');//Transaction code 
				
				
				var remit_amt_curr=document.getElementById('wdesk:remit_amt_curr').value;
				var cust_acc_curr=document.getElementById("wdesk:cust_acc_curr").value;
				
				if(remit_amt_curr!="--Select--" && cust_acc_curr!="--Select--" && remit_amt_curr!="" && cust_acc_curr!="" &&  cust_acc_curr== remit_amt_curr)
				{
					document.getElementById('wdesk:pref_rate').value="";
					document.getElementById("wdesk:pref_rate").disabled=true;
				}
				else 
				{
					document.getElementById("wdesk:pref_rate").disabled=false;
				}
				//changeTransTypeForCrossBorder('CSO_Initiate');
				// Start - Changes done for Cross Border payment CR - 13082017
				if(document.getElementById('wdesk:trans_type').value != '--Select--' && document.getElementById('wdesk:trans_type').value != '')
				{
					if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
					{
						changeTransTypeForCrossBorder('CSO_Initiate');
					}
					else
					{
						document.getElementById('transcode').value='';
						//document.getElementById('wdesk:trans_code').value = '';
						var select = document.getElementById('transcode');

						while (select.firstChild) {
						select.removeChild(select.firstChild);
						}
						ajaxRequest(workstepName,"dropDwnTranscode");
					}
				}
				selectElement('transcode','wdesk:trans_code');//Transaction code
				// End - Changes done for Cross Border payment CR - 13082017				
				if(document.getElementById("wdesk:isOriginalReceived").value == 'No'){
					document.getElementById("wdesk:channel_id").value = 'FAX';
					}
				
			}
			else if (workstepName== 'Ops_Checker')
			{
				document.getElementById("wdesk:dec_checker").value ='Submit'
			}
			else if (workstepName== 'Ops_Checker_DB')
			{
				document.getElementById("wdesk:dec_checker_DB").value ='Submit'
			}
			else if (workstepName== 'Ops_Maker')
			{
				document.getElementById("wdesk:dec_maker").value ='Submit'
			}
			else if (workstepName== 'Ops_Maker_DB')
			{
				document.getElementById("wdesk:dec_maker_DB").value ='Submit'
				setMailIdForIBMBCases();
			}
			else if (workstepName== 'Ops_DataEntry')
			{
				selectElement('countryOfResCombo','wdesk:countryOfRes');
				selectElement('wdesk:chargesCombo','wdesk:charges');
				selectElement('benefBankCntryCombo','wdesk:benefBankCntry');
				selectElement('wdesk:interBankCntryCombo','wdesk:interBankCntry');
				selectElement('dropDownBenefBankCode','wdesk:benefBankCode');//interbank code type
				selectElement('dropDownInterBankCode','wdesk:interBankCode');//benefbank code type
				
				selectElement('transtype','wdesk:trans_type');//Transaction type
				//ajaxRequest(workstepName,"dropDwnTranscode");
				// Start - Changes done for Cross Border payment CR - 13082017
				if(document.getElementById('wdesk:trans_type').value != '--Select--' && document.getElementById('wdesk:trans_type').value != '')
				{
					if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
					{
						changeTransTypeForCrossBorder('CSO_Initiate');
					}
					else
					{
						document.getElementById('transcode').value='';
						//document.getElementById('wdesk:trans_code').value = '';
						var select = document.getElementById('transcode');

						while (select.firstChild) {
						select.removeChild(select.firstChild);
						}
						ajaxRequest(workstepName,"dropDwnTranscode");
					}
				}
				selectElement('transcode','wdesk:trans_code');//Transaction code 
				// End - Changes done for Cross Border payment CR - 13082017
			}
			else if (workstepName== 'RemittanceHelpDesk_Checker')
			{
				document.getElementById("wdesk:dec_rem_helpdesk").value ='Submit';
				selectElement('callBackSuccess','wdesk:callBackSuccess');
				selectElement('signMatchDropDown','wdesk:sign_matched');
			}
			else if (workstepName== 'RemittanceHelpDesk_Maker')
			{
				document.getElementById("wdesk:dec_rem_helpdeskMaker").value ='Submit';
				selectElement('callBackSuccess','wdesk:callBackSuccess');
			}
			else if (workstepName== 'CSO_Exceptions')
			{
				var remit_amt_curr=document.getElementById('wdesk:remit_amt_curr').value;
				var cust_acc_curr=document.getElementById("wdesk:cust_acc_curr").value;
				if (document.getElementById("wdesk:dec_treasury").value == 'Rate Modification Required')
				{
					if(remit_amt_curr!="--Select--" && cust_acc_curr!="--Select--" && remit_amt_curr!="" && cust_acc_curr!="" &&  cust_acc_curr== remit_amt_curr)
					{
						document.getElementById('wdesk:pref_rate').value="";
						document.getElementById("wdesk:pref_rate").disabled=true;
					}
					else 
					{
						document.getElementById("wdesk:pref_rate").disabled=false;
					}
					
				}
			}
			
			//Integration Calls
			if (workstepName=='CSO_Initiate')
			{
				var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;

				if (debt_acc_num!=null && debt_acc_num!="")
				{
					//1) First Integration calls "Account Details Fetch"
					var getCustSuccess = getCustomerDetails();
					
					if (getCustSuccess)
					{
						//2) FCY_RATE Integration call
						var boolCal = calculateAmt();
						if (boolCal != 'Error' && boolCal!=false)
						{
							//3) ACCOUNT_BALANCE_DETAILS Integration call
							var boolSetAcc = accountBalanceDetails();
							if (boolSetAcc)
							{
								//4) MemoPad Fetching from fincale and inserting into our DB
								var boolMemo = memopad(1);
								if (boolMemo)
								{
									//Fetching from the DB and showing the memopad
									memopad(2);
								}
							}
						}
					}
				}
			}
			
			if (workstepName=='Ops_Maker')
			{
				var callbackflagFromFinacle = document.getElementById("wdesk:callbackFlgFinacle").value;
				var compflagFromFinacle = document.getElementById("wdesk:referCtryFlgFinacle").value;

				
				//fire the eventNotification call
				if(compflagFromFinacle=="Yes" || callbackflagFromFinacle=="Yes")
					eventNotification();
			}
			
			//Calling the fincale to get the latest status
			if (workstepName=='Comp_Check' || workstepName=='CallBack' || workstepName=='CSO_Exceptions' || workstepName=='Ops_Maker' || workstepName=='Ops_Checker' || workstepName=='Ops_Maker_DB' || workstepName=='Ops_Checker_DB' || workstepName=='RemittanceHelpDesk_Checker' || workstepName=='RemittanceHelpDesk_Maker')
			{
				getTTStatus();
			}
			
			//Added by siva for TT CR 10032020
			disabledecision(workstepName);
			//Added by siva for TT CR 10032020
			
			if (workstepName=='Ops_Maker_DB' || workstepName=='Ops_Checker_DB')
			{
				document.getElementById("view_sign").style.display="none";
			}
			
        }
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           This function is used to validate transaction code based on transaction type

//***********************************************************************************//
function changeTransTypeForCrossBorder(workstepName)
		{
			//change done by ankit on 28102016
			//If Remittance currency is AED and Beneficiary Bank Country is not equal to UAE
			//modified by shamily for cross board CR
			
			if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
			{	
				//Then, check if transaction type is selected or not
				if(document.getElementById('wdesk:trans_type').value!='' && document.getElementById('wdesk:trans_type').value!='--Select--')
				{
			
					// Start - Changes done for Cross Border payment CR - 13082017	
					var select = document.getElementById('transcode');

					while (select.firstChild) {
						select.removeChild(select.firstChild);
					}
					ajaxRequest(workstepName,'changeTransCodeToRem'); 
					//var a = ajaxRequest(workstepName,'changeTransCodeToRem');
					//alert('aaa '+a);
					//document.getElementById('wdesk:trans_code').value=document.getElementById('transcode').value;
					//alert("Transaction Code is changed to REM for AED payments outside UAE");
					// End - Changes done for Cross Border payment CR - 13082017
				}
			}
		}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           This function is used to open Signature,Exception,Reject reasons and decision history window

//***********************************************************************************//	
//added by stutee.mishra
	var dialogToOpenType = null;
	var popupWindow=null;
	var workstepNameHere = null;
	function setValue(val1) 
	{
	   //you can use the value here which has been returned by your child window
	   popupWindow = val1;
	   if(dialogToOpenType == 'Exception History'){
		   if(typeof popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						document.getElementById('wdesk:H_CHECKLIST').value = result[0];
						document.getElementById('wdesk:exceptionsRaisedForEmail').value = result[1];
                        window.parent.mainSave();						
					}
	   }else if(dialogToOpenType == 'Reject Reasons'){
		   if(popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					{
						//Set the response code to the input with id = rejReasonCodes
						document.getElementById('rejReasonCodes').value = popupWindow;
						document.getElementById('wdesk:remarks1').value = workstepNameHere+"~"+popupWindow;
					}
	   }
	}
	//ends here.
	
function openCustomDialog (dialogToOpen,workstepName)
		{
			dialogToOpenType = dialogToOpen;
			workstepNameHere = workstepName;
			if (workstepName!=null &&  workstepName!='')
			{
				//var popupWindow=null;
				var sOptions;
				if (dialogToOpen=='View Sign')
				{
					//Check first Debit account number is given
					var debt_acc_num = document.getElementById('wdesk:debt_acc_num').value;
					
					if (debt_acc_num!=null && debt_acc_num!='')
					{
						//var obj = [{"name":"A","value":"B"}];
						sOptions = 'left=300,top=200,width=600,height=600,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
						
						var signMatchNeededAtChecker = document.getElementById('signMatchNeededAtChecker').value;
						
						if (workstepName=='Ops_Checker' || workstepName=='Ops_Checker_DB'){
							//popupWindow = window.showModalDialog("/webdesktop/CustomForms/TT_Specific/OpenImage.jsp?workstepName="+workstepName+"&debt_acc_num="+debt_acc_num,obj,sOptions);
							
							openWindow("/webdesktop/CustomForms/TT_Specific/OpenImage.jsp?workstepName="+workstepName+"&signMatchNeededAtChecker="+signMatchNeededAtChecker+"&debt_acc_num="+debt_acc_num,"_blank",sOptions);
							//document.getElementById('wdesk:sign_matchedAtChecker').value = popupWindow.value;
							//document.getElementById('signMatchDropDown').value = popupWindow.value;
						}
						else {
							//popupWindow = window.showModalDialog("/webdesktop/CustomForms/TT_Specific/OpenImage.jsp?workstepName="+workstepName+"&debt_acc_num="+debt_acc_num,obj,sOptions);
							openWindow("/webdesktop/CustomForms/TT_Specific/OpenImage.jsp?workstepName="+workstepName+"&debt_acc_num="+debt_acc_num,'_blank',sOptions);
							//document.getElementById('wdesk:sign_matched').value = popupWindow.value;
							//document.getElementById('signMatchDropDown').value = popupWindow.value;
						}
					}
					else
						alert('Please provide the Debit A/C Number');
				}
				else if (dialogToOpen=='Exception History') {
					window.parent.mainSave();
					var wi_name = '<%=wi_name%>';
					var H_CHECKLIST = document.getElementById('wdesk:H_CHECKLIST').value;
					var ibmbCase = document.getElementById('wdesk:channel_id').value;
					
					sOptions = 'dialogWidth:850px; dialogHeight:500px; dialogLeft:250px; dialogTop:80px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						if (ibmbCase == 'IB' || ibmbCase=='MB' || ibmbCase=='YAP' || ibmbCase=='DIP') {
							popupWindow = window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&ibmbCase="+ibmbCase+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,sOptions);
							//Change null to this by saquib on 30-08-2017
						}
						else
							popupWindow = window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,sOptions);
					} else {
						if (ibmbCase == 'IB' || ibmbCase=='MB' || ibmbCase=='YAP' || ibmbCase=='DIP') {
							popupWindow = window.open('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&ibmbCase="+ibmbCase+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,windowParams);
							//Change null to this by saquib on 30-08-2017
						}
						else
							popupWindow = window.open('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					
					
					/*if (ibmbCase == 'IB' || ibmbCase=='MB' || ibmbCase=='YAP' || ibmbCase=='DIP') {
						popupWindow = window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&ibmbCase="+ibmbCase+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,sOptions);
						//Change null to this by saquib on 30-08-2017
					}
					else
						popupWindow = window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),this,sOptions);
					*/
					
					//Set the response code to the input with id = H_CHECKLIST
					if(typeof popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						document.getElementById('wdesk:H_CHECKLIST').value = result[0];
						document.getElementById('wdesk:exceptionsRaisedForEmail').value = result[1];
						window.parent.mainSave();						
					}
				}
				else if (dialogToOpen=='Reject Reasons')
				{
					var wi_name = '<%=wi_name%>';
					var username = '<%=wDSession.getM_objUserInfo().getM_strUserName()%>';
					//var rejectReasons = document.getElementById('rejReasonCodes').value;
					var rejectReasons = document.getElementById('wdesk:remarks1').value;
					if(rejectReasons.indexOf("~")>-1)
						rejectReasons=rejectReasons.substring(rejectReasons.indexOf("~")+1);
					else
						rejectReasons="";
						
					sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:no; help:no; resizable:no';
					
					//popupWindow =window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Reject_Reasons.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&username="+username+"&ReasonCodes="+encodeURIComponent(rejectReasons),null,sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow =window.showModalDialog('/webdesktop/CustomForms/TT_Specific/Reject_Reasons.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&username="+username+"&ReasonCodes="+encodeURIComponent(rejectReasons),null,sOptions);
					} else {
						popupWindow =window.open('/webdesktop/CustomForms/TT_Specific/Reject_Reasons.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&username="+username+"&ReasonCodes="+encodeURIComponent(rejectReasons),null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					if(popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					{
						//Set the response code to the input with id = rejReasonCodes
						document.getElementById('rejReasonCodes').value = popupWindow;
						document.getElementById('wdesk:remarks1').value = workstepName+"~"+popupWindow;
					}	
				}
				else if(dialogToOpen=='Save History')
				{
					var wi_name = '<%=wi_name%>';
					
					//window.showModalDialog("history.jsp?WINAME="+wi_name,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						window.showModalDialog("history.jsp?WINAME="+wi_name,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					} else {
						window.open("history.jsp?WINAME="+wi_name,"",windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					//Check if the call is for Ops_Maker and the call is for first time or not
					if (workstepName=='Ops_Maker')
						document.getElementById('flagForDecHisButton').value = 'Yes';
					if (workstepName=='Ops_Maker_DB')
						document.getElementById('flagForDecHisButton').value = 'Yes';
				}
			}			
		}
		
		function setSignMatchValues(wsname,signMatchStatus)
		{
			if(wsname=="Ops_Checker" || wsname=="Ops_Checker_DB")
				document.getElementById('wdesk:sign_matchedAtChecker').value = signMatchStatus;
			else
				document.getElementById('wdesk:sign_matched').value = signMatchStatus;
				
			document.getElementById('signMatchDropDown').value = signMatchStatus;
		}
		
		function isAnyExcpRaised(WorkitemName,H_Checklist)
		{
			var xhr;
			var ajaxResult;			
			ajaxResult="";
			var reqType = "TT_ISExceptionRaised";
			
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				 
			var url = '/webdesktop/CustomForms/TT_Specific/HandleAjaxProcedures.jsp?WorkitemName='+WorkitemName+"&reqType="+reqType+"&H_Checklist="+H_Checklist;

			 xhr.open("GET",url,false);
			 xhr.send(null);

			if (xhr.status == 200)
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				
				if(ajaxResult.indexOf("Exception")==0)
				{
					alert("Some problem in fetching account details.");
					return false;
				}
				
			}
			else
			{
				alert("Error while getting exception status");
				return "";
			}
			return ajaxResult;
		}		
		
		function ajaxRequestInsert(workstepname,winame,reqType)
		{
			var url = '/webdesktop/CustomForms/TT_Specific/AjaxRequestInsert.jsp?workstepname='+workstepname+"&winame="+encodeURIComponent(winame)+"&reqType="+reqType;
			var xhr;
			var ajaxResult;			
			var values = "";
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
			 xhr.open("GET",url,false);
			 xhr.send(null);

			if (xhr.status == 200)
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				
				if(ajaxResult.indexOf("Exception")==0)
				{
					alert("Some problem in fetching account details.");
					return false;
				}
			}			
			else
			{
				alert("Error while handling "+reqType+" for the current workstep");
				return false;
			}			
		}
		function accountBalanceDetails()
		{
			var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
			var requestType='ACCOUNT_BALANCE_DETAILS';
			var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';
			
			var xhr;
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";     
			
			var param="wi_name="+wi_name+"&debt_acc_num="+debt_acc_num+"&requestType="+requestType;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
			xhr.send(param);
			
			if (xhr.status == 200 && xhr.readyState == 4)
			{
				ajaxResult=xhr.responseText;
				ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				
				if(ajaxResult.indexOf("Exception")==0)
				{
					alert("Some problem in fetching account details.");
					return false;
				}
				var boolSetAcc = setAccountBalance(ajaxResult);
				return boolSetAcc;
			}
			else {
				alert("Problem in getting account details.");
				return false;
			}
			return true;
	    }
		
		function setAccountBalance(ajaxResult)
		{
			var xmlDoc;
			var parser;
			if (window.showModalDialog)
			{ // Internet Explorer
				xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async=false;
				xmlDoc.loadXML(ajaxResult);
			}
			else 
			{
				// Firefox, Chrome, Opera, etc.
				parser=new DOMParser();
				xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
			}
			/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(ajaxResult);*/
			
			var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
			
			if(strCode == '0000')
			{
				var isBalSufficient="No";
				try{
					var debitAmountinAccCurr = parseFloat(document.getElementById("wdesk:finalAmtDebitfromAcc").value.replaceAll(",","")).toFixed(2);
					//Amount
					//float reqdAmount=0.0;
					var amountFetched="0.0";
					
					var acctBals = xmlDoc.getElementsByTagName("AcctBal");

					for (var i = 0; i < acctBals.length; i++) {   
						var BalType = "";
						BalType = acctBals[i].getElementsByTagName("BalType")[0].childNodes[0].nodeValue;
						if(BalType=="EFFAVL")
						{
							amountFetched = acctBals[i].getElementsByTagName("Amount")[0].childNodes[0].nodeValue;
							
							//Check if the customer is of Staff or not
							if (document.getElementById("wdesk:IsBankEmployee").value == 'Y')
								document.getElementById("wdesk:acc_bal").value = 'XXXXXXXXXXXXX';
							else	
								document.getElementById("wdesk:acc_bal").value = amountFetched;
						}		
					}
					var fetchedBalanceinAccCurr=parseFloat(amountFetched).toFixed(2);
					
					if(fetchedBalanceinAccCurr-debitAmountinAccCurr>=0)
						isBalSufficient="Yes";
				}catch(Err)
				{
					isBalSufficient="No";
				}
				document.getElementById("wdesk:bal_sufficient").value=isBalSufficient;
				//alert("Account Details fetched successfully");
				return true;
			}
			else {
				//Make ajax request and get the error description
				var modWorkstepName = 'CSO_Initiate#'+strCode;
				var values = ajaxRequest(modWorkstepName,'ACCOUNT_DETAILS');
				
				if (values [1] =='Business') {
					alert(values [0]);
					document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
				}
				else {
					alert("Error in fetching A/C Balance");
					document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in fetching A/C Balance";
				}
				
				return false;
			}
		}
		
		function getCustomerDetails()
		{
			var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
			
			//Removing the previous value in account currency (if any)
			document.getElementById("wdesk:cust_acc_curr").value = "";
			
			if (debt_acc_num!=null && debt_acc_num!="")
			{
				var requestType='GET_CUSTOMER_DETAILS';
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';

				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";     
				
				var param="wi_name="+wi_name+"&debt_acc_num="+debt_acc_num+"&requestType="+requestType;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching customer details.");
						return false;
					}
					var boolCustDet = setCustomerDetailsOnForm(ajaxResult);
					return boolCustDet;
				}
				else
				{
					alert("Problem in getting customer details.");
					return false;
				}
			
				
			}
			else 
			{
				return false;
			}		
	    }
		
		function setCustomerDetailsOnForm(ajaxResult)
		{
			var xmlDoc;
			var parser;
			if (window.showModalDialog)
			{ // Internet Explorer
				xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async=false;
				xmlDoc.loadXML(ajaxResult);
			}
			else 
			{
				// Firefox, Chrome, Opera, etc.
				parser=new DOMParser();
				xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
			}
			
			/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(ajaxResult);*/

			var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
			var remit_amt_curr=document.getElementById('wdesk:remit_amt_curr').value;
			var workstep_name=document.getElementById('workstep_name').value;
			if(strCode == '0000')
			{
				var strAccStatus=xmlDoc.getElementsByTagName("AccountStatus")[0].childNodes[0].nodeValue;
				
				if(strAccStatus=="F") strAccStatus="Frozen";	
				else if(strAccStatus=="C") strAccStatus="Closed";
				else if(strAccStatus=="D") strAccStatus="Debit Frozen";
				else if(strAccStatus=="R") strAccStatus="Credit Frozen";
				else if(strAccStatus=="M") strAccStatus="Dormant";
				else if(strAccStatus=="A") strAccStatus="Active";
				else if(strAccStatus=="O") strAccStatus="Open";
				else if(strAccStatus=="I") strAccStatus="Inactive";
				else strAccStatus=="Not Available";

				document.getElementById("wdesk:acc_status").value = strAccStatus;			
				//document.getElementById("wdesk:cust_name").value = xmlDoc.getElementsByTagName("FullName")[0].childNodes[0].nodeValue;
				//changed for CR on 21102016
				document.getElementById("wdesk:cust_name").value = xmlDoc.getElementsByTagName("AccountName")[0].childNodes[0].nodeValue;
				document.getElementById("wdesk:cust_acc_curr").value = xmlDoc.getElementsByTagName("AcctCurr")[0].childNodes[0].nodeValue;
				
				
				
				
				//Check WSName
				var dec_treasury=document.getElementById("wdesk:dec_treasury").value;
				if(workstep_name=='CSO_Initiate' || (workstep_name=='CSO_Exceptions' && dec_treasury == 'Rate Modification Required'))
				cust_acc_curr= xmlDoc.getElementsByTagName("AcctCurr")[0].childNodes[0].nodeValue;
								
				if(remit_amt_curr!="--Select--" && cust_acc_curr!="--Select--" && remit_amt_curr!="" && cust_acc_curr!="" &&  cust_acc_curr== remit_amt_curr)
				{
					document.getElementById('wdesk:pref_rate').value="";
					document.getElementById("wdesk:pref_rate").disabled=true;
				}
				else 
				{
					document.getElementById("wdesk:pref_rate").disabled=false;
				}
				document.getElementById("acc_Curr").value = xmlDoc.getElementsByTagName("AcctCurr")[0].childNodes[0].nodeValue;
				document.getElementById("wdesk:cif_id").value = xmlDoc.getElementsByTagName("CIFID")[0].childNodes[0].nodeValue;
				//document.getElementById("wdesk:pref_contact1").value = xmlDoc.getElementsByTagName("PhoneNo")[0].childNodes[0].nodeValue;
				//document.getElementById("wdesk:isEliteCust").value = xmlDoc.getElementsByTagName("IsPremium")[0].childNodes[0].nodeValue;	// commented this line as part of below change - Considering B as Y, Changes done on 07112017

				//Start - Considering B as Y, Changes done on 07112017
				var IsPremium =  xmlDoc.getElementsByTagName("IsPremium")[0].childNodes[0].nodeValue;
				 if (IsPremium == "B")
				 {
					IsPremium = "Y";
				 }
				 document.getElementById("wdesk:isEliteCust").value = IsPremium;
				 //End - Considering B as Y, Changes done on 07112017
				
				document.getElementById("wdesk:sub_segment").value = xmlDoc.getElementsByTagName("CustomerSubSeg")[0].childNodes[0].nodeValue;
				
				if(document.getElementById("wdesk:isEliteCust").value=="Y")
				{
					//elite case
					document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','eliteMailOthers');
					document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','eliteMailComp');
				}
				else
				{
					//non-elite case segment wise
					if(document.getElementById("wdesk:sub_segment").value=="PBN" )
					{
						document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','PSLSMEEmailForNonCompliance'); //fetch from DB // earlier it was 'frontOfficeMail' which was changed to 'PSLSMEEmailForNonCompliance' on 25/05/2017
						document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','segmentComplianceMail'); 
					}					
					else if(document.getElementById("wdesk:sub_segment").value=="PSL" || document.getElementById("wdesk:sub_segment").value=="SME" )
					{
						document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','PSLSMEEmailForNonCompliance'); //fetch from DB
						document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','PSLSMEEmailForCompliance'); 
					}
					else 
					{
						document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','segmentNonComplianceMail');
						document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','segmentComplianceMail');
					}
				}	
				//added by aishwarya for mapping customer address, relationship manager, preferred contact name and number 1 and 2
				if( xmlDoc.getElementsByTagName("ARMName").length != 0 )
					document.getElementById("wdesk:rel_manager").value = xmlDoc.getElementsByTagName("ARMName")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("PrimaryContactName").length != 0 )
					document.getElementById("wdesk:pref_contactname1").value = xmlDoc.getElementsByTagName("PrimaryContactName")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("PrimaryContactNum").length != 0 )
					document.getElementById("wdesk:pref_contact1").value = xmlDoc.getElementsByTagName("PrimaryContactNum")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("SecondaryContactNum").length != 0 )
					document.getElementById("wdesk:pref_contact2").value = xmlDoc.getElementsByTagName("SecondaryContactNum")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("SecondaryContactName").length != 0 )
					document.getElementById("wdesk:pref_contactname2").value = xmlDoc.getElementsByTagName("SecondaryContactName")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("IsBankEmployee").length != 0 )
					document.getElementById("wdesk:IsBankEmployee").value = xmlDoc.getElementsByTagName("IsBankEmployee")[0].childNodes[0].nodeValue;
				if( xmlDoc.getElementsByTagName("ARMCode").length != 0 ) //RMCode
					document.getElementById("wdesk:RMCode").value = xmlDoc.getElementsByTagName("ARMCode")[0].childNodes[0].nodeValue;


				var addrDet = xmlDoc.getElementsByTagName("AddrDet");
				var addressFull = "";
					for (var i = 0; i < addrDet.length; i++) {
						//var addrType = "";
						//addrType = addrDet[i].getElementsByTagName("AddressType")[0].childNodes[0].nodeValue;
						//if(addrType=="OFFICE") // commented on 14032016 after dicussion with var
						var AddrPrefFlag = "";
						AddrPrefFlag = addrDet[i].getElementsByTagName("AddrPrefFlag")[0].childNodes[0].nodeValue;
						if(AddrPrefFlag=="Y")
						{							
							var addrline1="",addrline2="",addrline3="",pobox="",addresscity="",addresscountry="";
							if( typeof addrDet[i].getElementsByTagName("AddrLine1")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("AddrLine1")[0].childNodes[0] != null )
								addrline1 = addrDet[i].getElementsByTagName("AddrLine1")[0].childNodes[0].nodeValue;
							if( typeof addrDet[i].getElementsByTagName("AddrLine2")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("AddrLine2")[0].childNodes[0] != null )
								addrline2 = addrDet[i].getElementsByTagName("AddrLine2")[0].childNodes[0].nodeValue;
							if( typeof addrDet[i].getElementsByTagName("AddrLine3")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("AddrLine3")[0].childNodes[0] != null )
								addrline3 = addrDet[i].getElementsByTagName("AddrLine3")[0].childNodes[0].nodeValue;
							if( typeof addrDet[i].getElementsByTagName("POBox")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("POBox")[0].childNodes[0] != null )
								pobox = addrDet[i].getElementsByTagName("POBox")[0].childNodes[0].nodeValue;
							if( typeof addrDet[i].getElementsByTagName("City")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("City")[0].childNodes[0] != null )
								addresscity = addrDet[i].getElementsByTagName("City")[0].childNodes[0].nodeValue;
							if( typeof addrDet[i].getElementsByTagName("Country")[0].childNodes[0] != 'undefined' && addrDet[i].getElementsByTagName("Country")[0].childNodes[0] != null )
								addresscountry = addrDet[i].getElementsByTagName("Country")[0].childNodes[0].nodeValue;
							
							addressFull = addrline1+ ' ' +addrline2+ ' ' +addrline3+ ' ' +pobox+ ' ' +addresscity+ ' ' +addresscountry;
						}
					}
				document.getElementById("wdesk:custAddress").value = addressFull;
				//document.getElementById("wdesk:rel_manager").value = xmlDoc.getElementsByTagName("ARMName")[0].childNodes[0].nodeValue;
			   
				var CustTypeCode=xmlDoc.getElementsByTagName("CustomerType")[0].childNodes[0].nodeValue;
				
				var CustTypeValue="";
				//getValueForthisCodeFrom db
				//"SELECT customerType FROM USR_0_TT_CustomerTypeMaster WHERE customerCode='"+CustTypeCode+"'";
				var modWorkstepName = 'CSO_Initiate#'+CustTypeCode;
				CustTypeValue= ajaxRequest(modWorkstepName,'getCustomerType'); //getCustomerType(CustTypeCode);//;
				document.getElementById("wdesk:cust_type").value = CustTypeValue;
				if (CustTypeValue=='Ruling Family')
					document.getElementById("wdesk:isRulingFamily").value = 'Yes';
				else
					document.getElementById("wdesk:isRulingFamily").value = 'No';
					
				//alert("Customer details fetched successfully");
				
				// Start - Changes done for Cross Border payment CR - 13082017
				document.getElementById("wdesk:isRetailCust").value = xmlDoc.getElementsByTagName("IsRetailCust")[0].childNodes[0].nodeValue;
				// End - Changes done for Cross Border payment CR - 13082017
				
				//Added below by Amandeep - For JIRA Issue, Debit card Changed but memo pads not changing
				//if(memopad(1))
					//memopad(2);
				//Added above by Amandeep - For JIRA Issue, Debit card Changed but memo pads not changing 
				return true;
			}
			else {
				//Make ajax request and get the error description
				var modWorkstepName = 'CSO_Initiate#'+strCode;
				var values = ajaxRequest(modWorkstepName,'ENTITY_DETAILS');
				
				if (values [1] =='Business')
				{
					alert(values [0]);
					document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
				}
				else
				{
					alert("Error in fetching Customer details");
					document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in fetching Customer details";
				}
				return false;
			}
		}
		
		function getTTRefNum()
		{
			var TTRefNum = document.getElementById("wdesk:payment_order_id").value;

			if(TTRefNum==null || TTRefNum=="")
			{
				var requestType='PAYMENT_REQ';
				var countryCode = ajaxRequest('RemittanceHelpDesk_Checker','getCountryCode');
				var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
				var wiNo = document.getElementById("wdesk:wi_name").value;				
				var cif = document.getElementById("wdesk:cif_id").value;
				var trcry = document.getElementById("wdesk:transferCurr").value;		 	
				var chg = document.getElementById("wdesk:charges").value;			
				var tramt = document.getElementById("wdesk:trans_amt").value;
				var tramtWithoutComma = parseFloat(tramt.replace(/,/g,''));
				var dacry = document.getElementById("wdesk:cust_acc_curr").value;
				var crcry = document.getElementById("wdesk:remit_amt_curr").value;
				//var pay = document.getElementById("wdesk:purp_of_payment1").value;
				var bfname = document.getElementById("wdesk:benef_name").value;
				bfname = encodeURIComponent(bfname);
				var rateCode = document.getElementById("wdesk:rateCode").value;
				
				
				/*var bfname = bfNm.substring(0,35);
				bfname = encodeURIComponent(bfname);
				var bfAddress1 = bfNm.substring(35,70)
				bfAddress1 = encodeURIComponent(bfAddress1);
				var bfAddress2 = bfNm.substring(70,bfNm.length)
				bfAddress2 = encodeURIComponent(bfAddress2);
				if(bfNm.length < 35)
				bfAddress1 = "~";*/
				var bfAddress1 = document.getElementById("wdesk:middleName").value;
				//Start of change request CQRN-0000034057-Process,earlier ~, now *
				if(bfAddress1==null || bfAddress1=="")
					bfAddress1 = "*";//End of change request CQRN-0000034057-Process,earlier ~, now *
				else 
					bfAddress1 = encodeURIComponent(bfAddress1);
				var bfAddress2 = document.getElementById("wdesk:lastName").value;
					bfAddress2 = encodeURIComponent(bfAddress2);
				var org = document.getElementById("wdesk:isOriginalReceived").value;
				var bfCy = ajaxRequest('RemittanceHelpDesk_Checker','getCountryCodeBenfCntry');//not on form currently //BenefCountry
				var bfAc = document.getElementById("wdesk:iban").value;
				var bbbr = document.getElementById("wdesk:benefBankBranch").value;
				var bbcy = document.getElementById("wdesk:benefCityState").value;//City not on form currently
				var bbcn = document.getElementById("wdesk:benefBankCntry").value;
				var benefcity = document.getElementById("wdesk:beneficiaryCity").value; //added by ankit on 30032016
				var interBankName = document.getElementById("wdesk:interBankName").value;
				var interBankBranch = document.getElementById("wdesk:interBankBranch").value;
				var interCityState = document.getElementById("wdesk:interCityState").value;
				var interBankCntry = ajaxRequest('RemittanceHelpDesk_Checker','getCountryCodeInterCntry');
				//var interBankCntry = document.getElementById("wdesk:interBankCntry").value;
				var bbn = document.getElementById("wdesk:benefBankName").value;
				var exRate="";
				if(document.getElementById("wdesk:pref_rate").value=="") //added by ankit for PaymentReq call
					exRate = document.getElementById("wdesk:fcy_rate").value;
				else
					exRate = document.getElementById("wdesk:pref_rate").value;
				
				var pop1 =  document.getElementById("wdesk:purp_of_payment1").value;
				pop1 = encodeURIComponent(pop1);
				pop1=pop1.replace("%25","encoded");
			
				var pop2 = document.getElementById("wdesk:purp_of_payment2").value;
				pop2 = encodeURIComponent(pop2);
				pop2=pop2.replace("%25","encoded");
				var pop3 = document.getElementById("wdesk:purp_of_payment3").value;
				pop3 = encodeURIComponent(pop3);
				pop3=pop3.replace("%25","encoded");
				var txnTypeCode = document.getElementById("wdesk:trans_code").value;
				
				if(txnTypeCode.indexOf('*')>-1)
					txnTypeCode = txnTypeCode.substr(0,txnTypeCode.indexOf('*'));
				else
					txnTypeCode = txnTypeCode.substr(0,txnTypeCode.indexOf(' '));
				
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";
				
				var param="wiNo="+wiNo+"&requestType="+requestType+"&tramtWithoutComma="+tramtWithoutComma+"&trcry="+trcry+"&crcry="+crcry+"&chg="+chg+"&dacry="+dacry+"&bfAddress1="+bfAddress1+"&bfAddress2="+bfAddress2+"&bfCy="+bfCy+"&bbbr="+bbbr+"&bfAc="+bfAc+"&bbn="+bbn+"&bbcy="+bbcy+"&bbcn="+bbcn+"&org="+org+"&debt_acc_num="+debt_acc_num+"&exRate="+exRate+"&pop1="+pop1+"&pop2="+pop2+"&pop3="+pop3+"&txnTypeCode="+txnTypeCode+"&countryCode="+countryCode+"&bfname="+bfname+"&bfAddress1="+bfAddress1+"&bfAddress2="+bfAddress2+"&benefcity="+benefcity+"&interBankName="+interBankName+"&interBankBranch="+interBankBranch+"&interCityState="+interCityState+"&interBankCntry="+interBankCntry+"&rateCode="+rateCode;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
					
					if (ajaxResult=="")
					{
						document.getElementById("wdesk:strCode").value = "EMPTY";
						return false;
					}
					
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching TT Reference Number.");
						return false;
					}
					setTTRefOnForm(ajaxResult);
				}
				else
				{
					alert("Problem in getting TT Reference Number.");
					return false;
				}		
			}
			
			TTRefNum = document.getElementById("wdesk:payment_order_id").value;
				
			if(TTRefNum==null || TTRefNum=="") {
				//Do nothing
			}
			else
			{
				getTTStatus();
			}
			return true;
	    }
		
		function setTTRefOnForm(ajaxResult)
		{
			var winame = document.getElementById("wdesk:wi_name").value;
			var workstepname = document.getElementById("workstep_name").value;
			var xmlDoc;
			var parser;
			if (window.showModalDialog)
			{ // Internet Explorer
				xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async=false;
				xmlDoc.loadXML(ajaxResult);
			}
			else 
			{
				// Firefox, Chrome, Opera, etc.
				parser=new DOMParser();
				xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
			}
					
			/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(ajaxResult);*/
			
			var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
			
			//Populate the strCode in the HTML hidden input
			if (strCode == "")
				document.getElementById("wdesk:strCode").value = "EMPTY";
			else 
				document.getElementById("wdesk:strCode").value = strCode;

			if(strCode == '0000')
			{
				document.getElementById("wdesk:payment_order_id").value = xmlDoc.getElementsByTagName("HostTxnId")[0].childNodes[0].nodeValue;
				
				//alert("call back required");
				var callBackReq=xmlDoc.getElementsByTagName("CallBackRequired")[0].childNodes[0].nodeValue;
				//alert(callBackReq);
				if(callBackReq==null || callBackReq=="" ) 
					callBackReq="";
				else if(callBackReq=="N")
					callBackReq="No";
				else
					callBackReq="Yes";
				
				document.getElementById("wdesk:call_back_req").value = callBackReq;
				document.getElementById("wdesk:callbackFlgFinacle").value = callBackReq;
				
				var referredCountryFlag = xmlDoc.getElementsByTagName("ReferredCntryFlg")[0].childNodes[0].nodeValue;
				if(referredCountryFlag==null || referredCountryFlag=="") 
					referredCountryFlag="";
				else if(referredCountryFlag=="N")
					referredCountryFlag="No";
				else
					referredCountryFlag="Yes";
				
				document.getElementById("wdesk:comp_req").value = referredCountryFlag;
				document.getElementById("wdesk:referCtryFlgFinacle").value = referredCountryFlag;
				window.parent.workdeskOperations('S');//Saving Workitem - Payment Order Id/TT Ref No 

				//AutoRaising Complaince and Call Back Exceptions
				//Added by Mandeep Singh 25-02-2016
				if (referredCountryFlag == 'Yes') {
					//First Check if already raised or not
					var response = ajaxRequest(workstepname,'ComplainceAutoRaiseCheck');
					if (response==true)
						ajaxRequestInsert (workstepname,winame,"ComplainceAutoRaise");
				}
				if (callBackReq == 'Yes') {
					
					//First Check if already raised or not
					var response = ajaxRequest(workstepname,'CallBackAutoRaiseCheck');
					if (response==true)
					{
						
						ajaxRequestInsert (workstepname,winame,"CallBackAutoRaise");
					}	
				}
				if (true)
				{
					//Calling procedure.jsp for calling NG_SP_RQ_CUSTOM_PROC for mail and email triggers				
					var xhr;
					var payOrderId = document.getElementById("wdesk:payment_order_id").value;
					if(window.XMLHttpRequest)
						 xhr=new XMLHttpRequest();
					else if(window.ActiveXObject)
						 xhr=new ActiveXObject("Microsoft.XMLHTTP");
					
					var url="/webdesktop/CustomForms/TT_Specific/SendEmailToCustomer.jsp";     
					
					var param="winame="+winame+"&payOrderId="+payOrderId+"&workstepname="+workstepname;
					
					xhr.open("POST",url,false);
					xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
					xhr.send(param);
					
					if (xhr.status == 200 && xhr.readyState == 4)
					{
						ajaxResult=xhr.responseText;
						ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
						
						if(ajaxResult.indexOf("Exception")==0)
						{
							alert("Some problem in sending mail");
							return false;
						}
						else
						{
							//alert("TT Created successfully in finacle");
						}	
					}
					else
					{
						alert("Problem in sending mail");
						return false;
					}
				}
			}
			else
			{
				//Make ajax request and get the error description
				var modWorkstepName = 'ANYWORKSTEP#'+strCode;
				var values = ajaxRequest(modWorkstepName,'PAYMENT_REQ');
				
				if (values [1] =='Business')
				{
					if(values [0]=='RESTRICTED COUNTRY PAYMENT')
					{
						alert("Restricted country payment - case will move to Discard.");
						//set flag for restricted country.
						document.getElementById('wdesk:isRestrictedFlag').value="Yes";
						
						window.parent.workdeskOperations('S');//Saving Workitem - Payment Order Id/TT Ref No 
					}
					else
					{
						alert(values [0]);
						document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
						document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_REQ";
					}
				}	
				else
				{
					if(values [0]=='RESTRICTED COUNTRY PAYMENT')
					{
						alert("Restricted country payment - case will move to Discard.");
						//set flag for restricted country.
						document.getElementById('wdesk:isRestrictedFlag').value="Yes";
						window.parent.workdeskOperations('S');//Saving Workitem - Payment Order Id/TT Ref No 
					}
					else
					{
						alert("Error in Creating TT in Finacle");
						document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in Creating TT in Finacle";
						document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_REQ";
					}
				}
			}
		}
		function getTTStatus()
		{
			var TTRefNum = document.getElementById("wdesk:payment_order_id").value;
			if(TTRefNum!=null && TTRefNum!="")
			{
				var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
				var requestType='PAYMENT_DETAILS';
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';

				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";     
				
				var param="wi_name="+wi_name+"&requestType="+requestType+"&paymentRefNo="+TTRefNum+"&debt_acc_num="+debt_acc_num;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
										
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching Payment Order Status.");
						return false;
					}
					var booleanStatus = setTTStatusOnForm(ajaxResult);
					return booleanStatus;
				}
				else
				{
					alert("Problem in getting Payment Order Status.");
					return false;
				}
			}
						
			return true;
	    }
		
		function setTTStatusOnForm(ajaxResult)
		{
			var xmlDoc;
			var parser;
			if (window.showModalDialog)
			{ // Internet Explorer
				xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async=false;
				xmlDoc.loadXML(ajaxResult);
			}
			else 
			{
				// Firefox, Chrome, Opera, etc.
				parser=new DOMParser();
				xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
			}
			
			/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(ajaxResult);*/
		
			var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
			
			if(strCode == '0000')
			{
				var TTStatus=xmlDoc.getElementsByTagName("Status")[0].childNodes[0].nodeValue;
				if(TTStatus==null || TTStatus=="" ) 
					TTStatus="";
				else if(TTStatus=="N")
					TTStatus="Not Ready";
				else if(TTStatus=="P")
					TTStatus="Processed";
				else if(TTStatus=="O")
					TTStatus="Original Entity Unverified";
				else if(TTStatus=="D")
					TTStatus="Deleted";
				else if(TTStatus=="E")
					TTStatus="Error";
				else if(TTStatus=="A")
					TTStatus="Awaiting Authorization";
				else if(TTStatus=="H")
					TTStatus="Awaiting Deletion";
				else if(TTStatus=="R")
					TTStatus="Ready";

				document.getElementById("wdesk:payment_order_status").value=TTStatus;
				//alert("Finacle Status fetched successfully");
				document.getElementById('wdesk:isStatusSyncUp').value = 'Y';
				
				////246 point number
				var workstepname = document.getElementById('workstep_name').value;
				if (workstepname!='CSO_Initiate' && (TTStatus=='Deleted' || TTStatus=='Awaiting Deletion')) {
					alert("Workitem is being discarded as status is "+TTStatus);
					document.getElementById("wdesk:isRejected").value = "Yes";
					window.parent.workdeskOperations('I');
				}			
				return true;
			}
			else {
				var workstepname = document.getElementById('workstep_name').value;
				if (workstepname!='CallBack') {
					//Make ajax request and get the error description
					var modWorkstepName = 'ANYWORKSTEP#'+strCode;
					var values = ajaxRequest(modWorkstepName,'PAYMENT_DETAILS');

					if (values [1] =='Business') {
						alert(values [0]);
						document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
						document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_DETAILS";
					}
					else {
						alert("Error in obtaining Finacle Status");
						document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in obtaining Finacle Status";
						document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_DETAILS";
					}
					document.getElementById('wdesk:isStatusSyncUp').value = 'N';
					//Visible div when status failed
					if (workstepname=='Ops_Maker' || workstepname=='Ops_Checker' || workstepname=='Ops_Maker_DB' || workstepname=='Ops_Checker_DB')
						document.getElementById("deletePaymentDiv").style.display = "block";
					return false;
				}
			}
		}
		
		function eventNotification() {
		var callbackwaiver = document.getElementById("call_Waiver_Remarks").value;
			var cso_dec;
			
			if(document.getElementById("wdesk:dec_CSO_Exceptions").value=='Reject' || document.getElementById("wdesk:decCompCheck").value=='Reject')
			{
			//alert(csoDecision);
			//alert(document.getElementById("wdesk:dec_CSO_Exceptions").value+'decvalue');
			callbackwaiver='N';
			}
			var isrulingfamily = document.getElementById("wdesk:isRulingFamily").value;
			var callBackRemarks = ajaxRequest('Callback','getCallBackRemarks');
			var ttrefno = document.getElementById("wdesk:payment_order_id").value;
			var callBackSuccessFlag = document.getElementById("wdesk:callBackSuccess").value;
			var refCountrySuccessFlag = document.getElementById("wdesk:complaince_sucess").value;
			var callbackflagFromFinacle = document.getElementById("wdesk:callbackFlgFinacle").value;
			var compflagFromFinacle = document.getElementById("wdesk:referCtryFlgFinacle").value;
				//alert("callBackSuccessFlag"+callBackSuccessFlag);
				//alert("refCountrySuccessFlag"+refCountrySuccessFlag);
			if (callBackSuccessFlag=="--Select--")
				callBackSuccessFlag = "";
				
			if(callBackRemarks=="NULL" || callBackRemarks=="null" )
				callBackRemarks="";
			//if (document.getElementById("wdesk:call_back_req").value == 'Yes')
				//callBackRemarks = "";			
	
				var requestType='EVENT_NOTIFICATION';

				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";    
				
				var param="compflagFromFinacle="+compflagFromFinacle+"&callbackflagFromFinacle="+callbackflagFromFinacle+"&callBackSuccessFlag="+callBackSuccessFlag+"&callBackRemarks="+callBackRemarks+"&refCountrySuccessFlag="+refCountrySuccessFlag+"&ttrefno="+ttrefno+"&requestType="+requestType+"&callbackwaiver="+callbackwaiver+"&isrulingfamily="+isrulingfamily;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
					
					if (ajaxResult=="")
					{
						alert("Timed out for Event Notification call");
						document.getElementById("wdesk:strCode").value = "EMPTY";
						document.getElementById('wdesk:isEventNotifySuccess').value = 'N';
						return false;
					}
					
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in Event Notification");
						document.getElementById('wdesk:isEventNotifySuccess').value = 'N';
						return false;
					}
					
					var xmlDoc;
					var parser;
					if (window.showModalDialog)
					{ // Internet Explorer
						xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async=false;
						xmlDoc.loadXML(ajaxResult);
					}
					else 
					{
						// Firefox, Chrome, Opera, etc.
						parser=new DOMParser();
						xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
					}
			
					/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);*/
				
					var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
					if (strCode=="EMPTY" || strCode=="911" || strCode=="2033" || strCode=='1362') {
						alert("Respone TimeOut Error while pushing notification into the finacle");
						return false;
					}
					
					if(strCode == '0000') {
						//alert("Callback / Compliance Status Updated successfully");
						document.getElementById('wdesk:isEventNotifySuccess').value = 'Y';
						return true;
					}
					else {
						//Make ajax request and get the error description
						var modWorkstepName = 'ANYWORKSTEP#'+strCode;
						var values = ajaxRequest(modWorkstepName,'EVENT_NOTIFICATION');
						var refCountrySuccessFlag = document.getElementById("wdesk:referCtryFlgFinacle").value;
						var callBackSuccessFlag = document.getElementById("wdesk:callbackFlgFinacle").value;
						if (values [1] =='Business') {
							alert(values [0]);
							document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
							document.getElementById('wdesk:failedIntegrationCall').value = "EVENT_NOTIFICATION";
						}
						else {
							alert("Error in Callback / Compliance Status Update");							
							document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in Callback / Compliance Status Update";
							document.getElementById('wdesk:failedIntegrationCall').value = "EVENT_NOTIFICATION";
						}
						document.getElementById('wdesk:isEventNotifySuccess').value = 'N';
						if (!(refCountrySuccessFlag=='Yes' && callBackSuccessFlag=='No'))
							document.getElementById("deletePaymentDiv").style.display = "block";

						return false;
					}
				}
				else
				{
					alert("Problem in getting Event Notification.");
					return false;
				}
	    }
		
		function memopad(req) 
		{
			if (req== 1)
			{
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';
				var debt_acc_num=document.getElementById("wdesk:debt_acc_num").value;				
				var requestType='MEMOPAD_DETAILS_LIST';
				var sessionID = '<%=wDSession.getM_objUserInfo().getM_strSessionId()%>';
				var xhr;
				var ajaxResult;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");

				//var url = 'Memo.jsp?sessionID='+sessionID+"&wi_name="+wi_name;
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp?wi_name="+wi_name+"&debt_acc_num="+debt_acc_num+"&requestType="+requestType;
				
				xhr.open("GET",url,false); 
				xhr.send(null);

				if (xhr.status == 200)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
					ajaxResult=ajaxResult.replaceAll('&amp;','and');
					
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching memo pad.");
						document.getElementById("memopadFetchSuccess").value = 'N';
						return false;
					}
						
					var xmlDoc;
					var parser;
					if (window.showModalDialog)
					{ // Internet Explorer
						xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async=false;
						xmlDoc.loadXML(ajaxResult);
					}
					else 
					{
						// Firefox, Chrome, Opera, etc.
						parser=new DOMParser();
						xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
					}
					
					/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);*/
					
					var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
					if(strCode == '0000')
					{
						var acctNotes = xmlDoc.getElementsByTagName("AcctNotes");
						var createdBy = "";
						var createdDt = "";
						var expiryDate = "";
						var desc = "";
						for (var i = 0; i < acctNotes.length; i++) {   
							createdBy = createdBy + acctNotes[i].getElementsByTagName("CreatedBy")[0].childNodes[0].nodeValue + ",";
							createdDt = createdDt + acctNotes[i].getElementsByTagName("CreationDt")[0].childNodes[0].nodeValue + ",";
							expiryDate = expiryDate + acctNotes[i].getElementsByTagName("ExpiryDt")[0].childNodes[0].nodeValue + ",";
							desc = desc + acctNotes[i].getElementsByTagName("NoteText")[0].childNodes[0].nodeValue + "`";
						}

						//Now insert all values in the DB
						requestType='INSERT_MEMOPAD';
						url = '/webdesktop/CustomForms/TT_Specific/Memo.jsp?sessionID='+sessionID+"&wi_name="+wi_name+"&createdBy="+createdBy+"&createdDt="+createdDt+"&expiryDate="+expiryDate+"&desc="+desc+"&requestType=INSERT_MEMOPAD&debt_acc_num="+debt_acc_num;

						if(window.XMLHttpRequest)
							 xhr=new XMLHttpRequest();
						else if(window.ActiveXObject)
							 xhr=new ActiveXObject("Microsoft.XMLHTTP");

						 xhr.open("GET",url,false); 
						 xhr.send(null);

						if (xhr.status == 200)
						{
							ajaxResult=xhr.responseText;
							ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
						}
						else
						{
							alert("Error while inserting memopad details");
							document.getElementById("memopadFetchSuccess").value = 'N';
							return false;
						}
						document.getElementById("memopadFetchSuccess").value = 'Y';
						return true;
					}
					else {
						requestType='DELETE_MEMOPAD';
                        url = '/webdesktop/CustomForms/TT_Specific/Memo.jsp?sessionID='+sessionID+"&wi_name="+wi_name+"&requestType=DELETE_MEMOPAD&debt_acc_num="+debt_acc_num;
                        if(window.XMLHttpRequest)
                             xhr=new XMLHttpRequest();
                        else if(window.ActiveXObject)
                             xhr=new ActiveXObject("Microsoft.XMLHTTP");

                         xhr.open("GET",url,false); 
                         xhr.send(null);

                        if (xhr.status == 200)
                        {
                            //do nothing
                        }
                        else
                        {
                            //
                        }
                        
                        var tableRows=document.getElementById("memo_pad").rows.length;
                        while (tableRows > 1) {
                            document.getElementById("memo_pad").deleteRow(tableRows-1);
                            tableRows=document.getElementById("memo_pad").rows.length;
                        }
						//Make ajax request and get the error description
						var modWorkstepName = 'CSO_Initiate#'+strCode;
						var values = ajaxRequest(modWorkstepName,'MEMOPAD_DETAILS');
						
						if (values [1] =='Business')
						{
							alert(values [0]);
							document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
						}
						else
						{
							alert("Error in Fetching Memo Pad");
							document.getElementById('wdesk:errorMsgFromFinacle').value = "Error in Fetching Memo Pad";
						}
						return false;
					}
				}
				else
				{
					alert("Problem in fetching memo pad");
					document.getElementById("memopadFetchSuccess").value = 'N';
					return false;
				}
			}
			else
			{
				//First Delete incase already rows are there for the same account
				var tableHeaderRowCount = 1;
				var table = document.getElementById('memo_pad');
				var rowCount = table.rows.length;
				for (var i = tableHeaderRowCount; i < rowCount; i++)
					table.deleteRow(tableHeaderRowCount);
			
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';
				var sessionID = '<%=wDSession.getM_objUserInfo().getM_strSessionId()%>';
				var requestType='SHOW_MEMOPAD';
				var url = '/webdesktop/CustomForms/TT_Specific/Memo.jsp?sessionID='+sessionID+"&wi_name="+wi_name+"&requestType="+requestType;
				var xhr;
				var ajaxResult;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				 xhr.open("GET",url,false); 
				 xhr.send(null);

				if (xhr.status == 200)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
					
					if(ajaxResult.indexOf("Exception")==0)
				{
					alert("Some problem in fetching account details.");
					return false;
				}
					//Dom parser for ajaxResult
					var xmlDoc;
					var parser;
					if (window.showModalDialog)
					{ // Internet Explorer
						xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async=false;
						xmlDoc.loadXML(ajaxResult);
					}
					else 
					{
						// Firefox, Chrome, Opera, etc.
						parser=new DOMParser();
						xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
					}
					
					/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);*/

					var trTags = xmlDoc.getElementsByTagName("tr");
					
					for (var i = 0; i < trTags.length; i++) 
					{
						var row = document.getElementById("memo_pad").insertRow(i+1);
						
						var tdTags=trTags[i].childNodes;
						
						var cellCounter=0;
						for (var j = 0; j < tdTags.length; j++) 
						{   
							var cell = row.insertCell(j);
							cell.className="EWNormalGreenGeneral1";
							if(j==0)	
								cell.style.textAlign="center";
							cell.innerHTML = tdTags[j].childNodes[0].nodeValue;
						}
					}
				}
				else
				{
					alert("Error while fetching accounts");
					return false;
				}
			}
		}
		
		function changeVal(dropdown,workstepName)
		{
			if (workstepName == "CSO_Initiate")
				document.getElementById("wdesk:dec_CSO_Branch").value = dropdown.value;
			else if (workstepName == "Treasury")
				document.getElementById("wdesk:dec_treasury").value = dropdown.value;
			else if (workstepName == "RemittanceHelpDesk_Checker")
				document.getElementById("wdesk:dec_rem_helpdesk").value = dropdown.value;
			else if (workstepName == "RemittanceHelpDesk_Maker")
				document.getElementById("wdesk:dec_rem_helpdeskMaker").value = dropdown.value;
			else if (workstepName == "Ops_Maker")
				document.getElementById("wdesk:dec_maker").value = dropdown.value;
			else if (workstepName == "Ops_Checker")
				document.getElementById("wdesk:dec_checker").value = dropdown.value;
			else if (workstepName == "Ops_Maker_DB")
				document.getElementById("wdesk:dec_maker_DB").value = dropdown.value;
			else if (workstepName == "Ops_Checker_DB")
				document.getElementById("wdesk:dec_checker_DB").value = dropdown.value;
			else if (workstepName == "Ops_DataEntry")
				document.getElementById("wdesk:dec_Ops_DataEntry").value = dropdown.value;
			else if (workstepName == "CallBack")
				document.getElementById("wdesk:decCallBack").value = dropdown.value;
			else if (workstepName == "Comp_Check")
			{
				document.getElementById("wdesk:decCompCheck").value = dropdown.value;
				document.getElementById('wdesk:assignToCompliance').value = '';
				document.getElementById('assignToRow').style.display = 'none';
				document.getElementById('wdesk:sendToGroup').value = '';
				document.getElementById('sendToDropDown').value = '';
				document.getElementById('sendToRow').style.display = 'none';
			}
			else if (workstepName == "CSO_Exceptions")
			{
				document.getElementById("wdesk:dec_CSO_Exceptions").value = dropdown.value;
				document.getElementById('wdesk:assignToBusiness').value = '';
				document.getElementById('assignToRow').style.display = 'none';
			}
			else if (workstepName == "Error")
				document.getElementById("wdesk:decError").value = dropdown.value;
			
			//handling for refer cases
			if (workstepName=="Comp_Check" && dropdown.value =='Refer')
			{
				var select = document.getElementById('assignToDropDown');
				deleteOptionsFromSel (select);
				var opt = document.createElement('option');
				opt.value = '--Select--';
				opt.innerHTML = '--Select--';
				opt.length = 50;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
				ajaxRequest(workstepName,'assignToCompliance');
				document.getElementById('assignToRow').style.display = 'block';				
			}
			else if (workstepName=="Comp_Check" && dropdown.value =='Hold')
				document.getElementById('wdesk:assignToBusiness').value = document.getElementById('login_user').value;
			/*else if (workstepName=="Comp_Check" && dropdown.value =='Additional Documents required')
			{
				var ibmbCase = document.getElementById('channel_id').value;
				if (ibmbCase == 'IB' || ibmbCase=='MB') {
					document.getElementById('sendToRow').style.display = 'block';
				}
			}*/ //commented as part of CR on 15112016
			if (workstepName=="CSO_Exceptions" && dropdown.value =='Refer')
			{
				var select = document.getElementById('assignToDropDown');
				deleteOptionsFromSel (select);
				var opt = document.createElement('option');
				opt.value = '--Select--';
				opt.innerHTML = '--Select--';
				opt.length = 50;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
				ajaxRequest(workstepName,'assignToBusiness');
				document.getElementById('assignToRow').style.display = 'block';				
			}
		}
		//This function will delete all the options from the given select
		function deleteOptionsFromSel (selectEle) {
			 while (selectEle.options.length != 0) {
				selectEle.options.remove(selectEle.options.length - 1);
			}
		}
		function setComboValueToTextBox(dropdown,inputTextBoxId) {
		
			var inputBoxId  = document.getElementById(inputTextBoxId);
			//Set value to the textbox
			inputBoxId.value = dropdown.value;
			var cust_acc_curr = "";
			var workstep_name=document.getElementById('workstep_name').value;
			if(workstep_name != 'OPS_Initiate')
			cust_acc_curr = document.getElementById('wdesk:cust_acc_curr').value;
			//Getting the fields according to the selected value
			if (inputTextBoxId == 'wdesk:trans_type' && dropdown.value!= '--Select--')
			{
				//delete all the elements from the select "transcode" and add new according to the request
				//Adding select option
				var select = document.getElementById('transcode');
				deleteOptionsFromSel (select);
				var opt = document.createElement('option');
				opt.value = '--Select--';
				opt.innerHTML = '--Select--';
				opt.length = 10;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
				// Start - Changes done for Cross Border payment CR - 13082017
				if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
				{
					changeTransTypeForCrossBorder('CSO_Initiate');
				}
				else
				{
					
					var select = document.getElementById('transcode');

					while (select.firstChild) {
						select.removeChild(select.firstChild);
						}
					ajaxRequest (document.getElementById("workstep_name").value,'dropDwnTranscode');
				}	
				// End - Changes done for Cross Border payment CR - 13082017
			}
			//Getting the fields according to the selected value
			else if (inputTextBoxId == 'wdesk:trans_type' && dropdown.value== '--Select--')
			{
				//When selecting --Select-- delete all and add --Select--
				var select = document.getElementById('transcode');
				deleteOptionsFromSel (select);
				var opt = document.createElement('option');
				opt.value = '--Select--';
				opt.innerHTML = '--Select--';
				opt.length = 10;
				opt.className="EWNormalGreenGeneral1";
				select.appendChild(opt);
			}
			else if (inputTextBoxId == 'wdesk:transferCurr' || inputTextBoxId == 'wdesk:remit_amt_curr')
			{
				calculateAmt();
			}
			else if (inputTextBoxId == 'wdesk:benefBankCntry')
			{	
				// Start - Changes done for Cross Border payment CR - 13082017
				if(document.getElementById('wdesk:trans_type').value != '--Select--' && document.getElementById('wdesk:trans_type').value != '')
				{
					if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
					changeTransTypeForCrossBorder('CSO_Initiate');
					else
					{
						document.getElementById('transcode').value='';
						document.getElementById('wdesk:trans_code').value = '';
						var select = document.getElementById('transcode');

					while (select.firstChild) {
						select.removeChild(select.firstChild);
						}
						ajaxRequest (document.getElementById("workstep_name").value,'dropDwnTranscode');
					}
				}
				// End - Changes done for Cross Border payment CR - 13082017
			}
			
			//var dec_treasury=document.getElementById("wdesk:dec_treasury").value;
			
			if(workstep_name=='CSO_Initiate')
			{
				if(inputTextBoxId=='wdesk:remit_amt_curr')
				{
					if(dropdown.value != '--Select--' && dropdown.value != '' && cust_acc_curr != '--Select--' && cust_acc_curr != '' && dropdown.value == cust_acc_curr)
					{				
						document.getElementById("wdesk:pref_rate").disabled=true;
						document.getElementById("wdesk:pref_rate").value="";
					}
					else 
					{				
						document.getElementById("wdesk:pref_rate").disabled=false;
					}
					// Start - Changes done for Cross Border payment CR - 13082017
					if(document.getElementById('wdesk:trans_type').value != '--Select--' && document.getElementById('wdesk:trans_type').value != '')
					{
						if(document.getElementById('wdesk:remit_amt_curr').value=='AED' && document.getElementById('wdesk:benefBankCntry').value == 'UNITED ARAB EMIRATES')
						{
							changeTransTypeForCrossBorder('CSO_Initiate');
						}
						else
						{
							document.getElementById('transcode').value='';
							document.getElementById('wdesk:trans_code').value = '';
							var select = document.getElementById('transcode');

							while (select.firstChild) {
								select.removeChild(select.firstChild);
							}
							ajaxRequest (document.getElementById("workstep_name").value,'dropDwnTranscode');
						}	
					}
					// End - Changes done for Cross Border payment CR - 13082017
				}
				
				if(inputTextBoxId=="wdesk:isOriginalReceived" && document.getElementById("wdesk:isOriginalReceived").value=="No")
				{
					document.getElementById('wdesk:channel_id').value = 'FAX';
				}
				else{
					document.getElementById('wdesk:channel_id').value = 'Branch/Front Office';
				}
				
			}
		}
		
		function CustVerifDrpDwnHandler(dropdown)
		{
			var customerVerification=dropdown.value;
			var callAttempt1=document.getElementById("call_back_success1").value;
			var callAttempt2=document.getElementById("call_back_success2").value;
			var callAttempt3=document.getElementById("call_back_success3").value;
			
			if(customerVerification=='Not Verified'){
				if(document.getElementById("call_back_success3").disabled){
					if(document.getElementById("call_back_success2").disabled){
						//DO NOTHING
					}else{
						if(callAttempt2=='No' || callAttempt2=='--Select--' )	document.getElementById("wdesk:callBackSuccess").value="No";
					}
				}else{
					if(callAttempt3=='No' || callAttempt3=='--Select--' )	document.getElementById("wdesk:callBackSuccess").value="No";
				}				
			}else{
				if(document.getElementById("call_back_success3").disabled){
					if(document.getElementById("call_back_success2").disabled){
						//DO NOTHING
					}else{
						if(callAttempt2=='No' || callAttempt2=='--Select--' )	document.getElementById("wdesk:callBackSuccess").value="";
					}
				}else{
					if(callAttempt3=='--Select--' )	document.getElementById("wdesk:callBackSuccess").value="";
				}		
			}
		}
		function callBackDrpDwnHandler(dropdown,workstepName)
		{
			var prevAttempts=0;
			try{
				if(document.getElementById("wdesk:callbackAttemptsPrev")!=null)
					prevAttempts=parseInt(document.getElementById("wdesk:callbackAttemptsPrev").value);
				if (isNaN(prevAttempts)) prevAttempts=0;
			}catch(Err){}
			var dropDownCallBackCustVerf = document.getElementById("dropDownCallBackCustVerf").value;
			
			
			
			if (dropdown.id=="call_back_success1")
			{
				if(dropdown.value=="No")
				{
					document.getElementById("call_back_success2").disabled=false;
					document.getElementById("call_back_success2").selectedIndex=0;
					document.getElementById("wdesk:attempt2").value="";
					
					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("call_back_success3").disabled=true;
					document.getElementById("wdesk:attempt3").value="";
					
					if (dropDownCallBackCustVerf == 'Not Verified') {
						document.getElementById("wdesk:callBackSuccess").value="No";	
					} else{
						document.getElementById("wdesk:callBackSuccess").value="";	
					} 						
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+1);
				}
				else if(dropdown.value=="Yes")
				{

					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("call_back_success3").disabled=true;
					document.getElementById("wdesk:attempt3").value="";
					
					document.getElementById("call_back_success2").disabled=false;
					document.getElementById("call_back_success2").selectedIndex=0;
					document.getElementById("call_back_success2").disabled=true;
					document.getElementById("wdesk:attempt2").value="";
					
					document.getElementById("wdesk:callBackSuccess").value="Yes";	
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+1);	
				}
				else if(dropdown.value=="--Select--" || dropdown.value=="")
				{

					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("call_back_success3").disabled=true;
					document.getElementById("wdesk:attempt3").value="";
					
					document.getElementById("call_back_success2").disabled=false;
					document.getElementById("call_back_success2").selectedIndex=0;
					document.getElementById("call_back_success2").disabled=true;
					document.getElementById("wdesk:attempt2").value="";
					
					document.getElementById("wdesk:callBackSuccess").value="";
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts);	
				}		
			}
			else if (dropdown.id=="call_back_success2")
			{		
				try
				{
					if(document.getElementById("call_back_success1").value=="Yes" || document.getElementById("call_back_success1").value=="" || document.getElementById("call_back_success1").value=="--Select--")
					return true;
				}catch(Err){return true;}	
				
				if(dropdown.value=="No")
				{
					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("wdesk:attempt3").value="";
					
					if (dropDownCallBackCustVerf == 'Not Verified') {
						document.getElementById("wdesk:callBackSuccess").value="No";	
					} else{
						document.getElementById("wdesk:callBackSuccess").value="";	
					} 	
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+2);
				}
				else if(dropdown.value=="Yes")
				{
					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("call_back_success3").disabled=true;
					document.getElementById("wdesk:attempt3").value="";
					
					document.getElementById("wdesk:callBackSuccess").value="Yes";	
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+2);	
				}
				else if(dropdown.value=="--Select--" || dropdown.value=="")
				{
					document.getElementById("call_back_success3").disabled=false;
					document.getElementById("call_back_success3").selectedIndex=0;
					document.getElementById("call_back_success3").disabled=true;
					document.getElementById("wdesk:attempt3").value="";
					
					document.getElementById("wdesk:callBackSuccess").value="";
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+1);							
				}		
			}
			
			else if (dropdown.id=="call_back_success3")
			{	
				try
				{
					if(document.getElementById("call_back_success1").value=="Yes" || document.getElementById("call_back_success1").value=="" || document.getElementById("call_back_success1").value=="--Select--")
					return true;
					
					if(document.getElementById("call_back_success2").value=="Yes" || document.getElementById("call_back_success2").value=="" || document.getElementById("call_back_success2").value=="--Select--")
					return true;
					
				}catch(Err){return true;}	
			
			
			
				if(dropdown.value=="No")
				{
					document.getElementById("wdesk:callBackSuccess").value="No";
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+3);
				}
				else if(dropdown.value=="--Select--" || dropdown.value=="")
				{
					document.getElementById("wdesk:callBackSuccess").value="";
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+2);		
				}
				else 
				{
					document.getElementById("wdesk:callBackSuccess").value="Yes";			
					document.getElementById("wdesk:callBackAtmptMadeCount").value=""+(prevAttempts+3);			
				}	
			}		
		}
		function getFcyRate(opt)
		{
			if(opt==1)
			{
				var transCurrType = document.getElementById("wdesk:transferCurr").value;
				var remitCurrType = document.getElementById("wdesk:remit_amt_curr").value;
				if(transCurrType=="--Select--" || transCurrType=="")
				{
					alert("Please select Transfer Amount currency");
					return false;	
				}
				if(remitCurrType=="--Select--" || remitCurrType=="")
				{
					alert("Please select Remittance Amount currency");
					return false;
				}
				calculateAmt();
			}
			else
			{
				var cif = document.getElementById("wdesk:cif_id").value;
				var remitCurrType = document.getElementById("wdesk:remit_amt_curr").value;
				var transCurrType = document.getElementById("wdesk:transferCurr").value;  
				var accCurrType = document.getElementById("wdesk:cust_acc_curr").value;
				var tranAmount = document.getElementById("wdesk:trans_amt").value;
				var tranAmountWithoutComma = parseFloat(tranAmount.replace(/,/g,''));
				var debt_acc_num = document.getElementById("wdesk:debt_acc_num").value;
				var isbankemployee = document.getElementById("wdesk:IsBankEmployee").value;
				
				var fcy_rate = "";
				if(accCurrType==transCurrType && accCurrType==remitCurrType)
				{
					fcy_rate="1";
					document.getElementById("wdesk:fcy_rate").value = fcy_rate;	
					
					return fcy_rate;	
				}
		
				var requestType='EXCHANGE_RATE_INQUIRY';
				var wi_name = '<%=wdmodel.getWorkitem().getProcessInstanceId()%>';
				
				var xhr;
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
					
				var url="/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp";
				
				var param="wi_name="+wi_name+"&cif="+cif+"&remitCurrType="+remitCurrType+"&debt_acc_num="+debt_acc_num+"&transCurrType="+transCurrType+"&debitCurrType="+accCurrType+"&tranAmountWithoutComma="+tranAmountWithoutComma+"&requestType="+requestType+"&isbankemployee="+isbankemployee;
				xhr.open("POST",url,false);
				xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					ajaxResult=xhr.responseText;
					ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching FX Rate.");
						document.getElementById("wdesk:fcy_rate").value = '';				
						document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
						document.getElementById("wdesk:remit_amt").value = '';
						document.getElementById("wdesk:remit_amt_new").value = '';
						return false;
					}
					fcy_rate = parseFXRate(ajaxResult,1);
					if (fcy_rate == 'Error')
					{
						document.getElementById("wdesk:fcy_rate").value = '';				
						document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
						document.getElementById("wdesk:remit_amt").value = '';
						document.getElementById("wdesk:remit_amt_new").value = '';
					}
				}
				else
				{
					alert("Problem in getting FX Rate.");
					document.getElementById("wdesk:fcy_rate").value = '';				
					document.getElementById("wdesk:finalAmtDebitfromAcc").value= '';
					document.getElementById("wdesk:remit_amt").value = '';
					document.getElementById("wdesk:remit_amt_new").value = '';
					return false;
				}
				if(typeof opt!="undefined" && fcy_rate!='Error' && fcy_rate!=false)
				{
					if(opt!=null && opt!=1)
						document.getElementById("wdesk:fcy_rate").value = fcy_rate;	
				}
			
				return fcy_rate;
			}
		}
		
		function parseFXRate(ajaxResult,option) //Function to parse the fx rate
		{
			var xmlDoc;
			var parser;
			if (window.showModalDialog)
			{ // Internet Explorer
				xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async=false;
				xmlDoc.loadXML(ajaxResult);
			}
			else 
			{
				// Firefox, Chrome, Opera, etc.
				parser=new DOMParser();
				xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
			}
			
			/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(ajaxResult);*/
			var FXRate;
			var strCode = xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;

			if(strCode== '0000') {
				FXRate = xmlDoc.getElementsByTagName("VarCurUnits")[0].childNodes[0].nodeValue;
				//Setting the Rate Code
				
				
				if (option==1)
				{
					document.getElementById("outputAmount").value = xmlDoc.getElementsByTagName("OutputAmount")[0].childNodes[0].nodeValue;
					document.getElementById("wdesk:rateCode").value = xmlDoc.getElementsByTagName("RateCode")[0].childNodes[0].nodeValue;
				}	
				else
					document.getElementById("outputAmountMidRate").value = xmlDoc.getElementsByTagName("OutputAmount")[0].childNodes[0].nodeValue;
			}
			else {
				//Make ajax request and get the error description
				var modWorkstepName = 'CSO_Initiate#'+strCode;
				var values = ajaxRequest(modWorkstepName,'EXCHANGE_RATE_DETAILS');
				
				if (values [1] =='Business')
					alert(values[0]);
				else
					alert("Error in fetching FX Rate");
				FXRate="Error";
			}
			return FXRate;			
		}	

		function selectElement(idDropDown,idInput)
		{
			var elementDrop = document.getElementById(idDropDown);
			var elementSet = document.getElementById(idInput);

			if (elementDrop!=null && elementSet!=null)
			{
				var x = (elementSet.value).trim();
			
				if (x != "")
					elementDrop.value = x;
				else
					elementDrop.selectedIndex = "0";
			}
			else if (elementDrop!=null)
				elementDrop.selectedIndex = "0";
		}
		function sendToErrorQueue() {
			document.getElementById("sendBtnClicked").value = "Yes";
			document.getElementById("wdesk:routeToErrorQ").value = "Y";
			window.parent.workdeskOperations('I');
		}

		function charAllowed(id,value,maxLength){
			newLength=value.length;
			value=value.replace(/(\r\n|\n|\r)/gm," ");
			value=value.replace(/[!|]/g,"");

			if(newLength>=maxLength){
				value=value.substring(0,maxLength);
			}
			document.getElementById(id).value=value.trim();
		}
		
		function deletePaymentFromFinacle()
		{
			//{ Added by Amandeep 28-07-2016 Production Issue #78 - uncomment two lines to fix
   
		    if(document.getElementById('wdesk:payment_order_id').value=="")
				return true;
		  
		   // Added by Amandeep 28-07-2016 Production Issue #78 }
   
			var ibmbCase = document.getElementById('wdesk:channel_id').value;
            var isIbMbCase = false;
			var isEventNotificationNeeded = false;
            if (ibmbCase == 'IB' || ibmbCase == 'MB' || ibmbCase == 'YAP' || ibmbCase == 'DIP') 
                isIbMbCase = true;
			var callbackflagFromFinacle = document.getElementById("wdesk:callbackFlgFinacle").value;
			var compflagFromFinacle = document.getElementById("wdesk:referCtryFlgFinacle").value;	
			
			if (isIbMbCase == false) {
				if (callbackflagFromFinacle == "Yes" || compflagFromFinacle=="Yes") {
					//First call the event notification call when it is not success before deleting payment from the finacle
					//if (document.getElementById('wdesk:isEventNotifySuccess').value != 'Y') {
						isEventNotificationNeeded = true;
						if (eventNotification() != true)
							return false;
				//	}
					}
			}

			//Call delete payment call when event notification fired successfully
			if (isEventNotificationNeeded == false || document.getElementById('wdesk:isEventNotifySuccess').value == 'Y' || isIbMbCase==true) {
			//if (document.getElementById('wdesk:isEventNotifySuccess').value == 'Y' || isIbMbCase == true || (callbackflagFromFinacle != "Yes" && compflagFromFinacle!="Yes")) {
				var requestType='PAYMENT_DELETION';
				var cifid = document.getElementById('wdesk:cif_id').value;
				var ttrefno = document.getElementById('wdesk:payment_order_id').value;
				var deletionReason = "";
				var workstepname =  document.getElementById('workstep_name').value;
				
				if (workstepname=='CSO_Initiate' || workstepname=='CSO_Exceptions' || workstepname=='Comp_Check')
				{
					deletionReason = document.getElementById('rejReasonCodes').value;
					
					if(typeof deletionReason !== "undefined"  && deletionReason!=null && deletionReason!="" && deletionReason!="null" && deletionReason!="undefined")
					{
						deletionReason=ajaxRequest('AnyWorkstep','rejectReasons');					
					}
					else
						deletionReason="";
				}	
				else
					deletionReason = document.getElementById('wdesk:remarks').value;

				var url = '/webdesktop/CustomForms/TT_Specific/TTIntegration.jsp?cifid='+cifid+"&ttrefno="+ttrefno+"&deletionReason="+deletionReason+"&requestType="+requestType;
				var xhr;
				var ajaxResult;

				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				 xhr.open("GET",url,false);
				 xhr.send(null);
			 
				if (xhr.status == 200)
				{
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
					
					if(ajaxResult.indexOf("Exception")==0)
					{
						alert("Some problem in fetching account details.");
						return false;
					}
					
					var xmlDoc;
					var parser;
					if (window.showModalDialog)
					{ // Internet Explorer
						xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async=false;
						xmlDoc.loadXML(ajaxResult);
					}
					else 
					{
						// Firefox, Chrome, Opera, etc.
						parser=new DOMParser();
						xmlDoc=parser.parseFromString(ajaxResult,"text/xml"); 
					}
					/*var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);*/

					var strCode =  xmlDoc.getElementsByTagName("ReturnCode")[0].childNodes[0].nodeValue;
				
					if (strCode=="EMPTY" || strCode=="911" || strCode=="2033" || strCode=='1362') {
						alert("Respone TimeOut Error while deleting payment in finacle");
						return false;
					}
					if(strCode == '0000') {
						//alert("Payment deleted in finacle successfully");
					var POStatus=xmlDoc.getElementsByTagName("POStatus")[0].childNodes[0].nodeValue;
					if(POStatus == 'D')
						POStatus = "Deleted";
					else if(POStatus == 'P')
						POStatus = "Processed";

						document.getElementById('wdesk:isPayDelFromFinacle').value = 'Y';
						document.getElementById('wdesk:payment_order_status').value = POStatus;
						return true;
					}
					else {
						//Make ajax request and get the error description
						var modWorkstepName = 'ANYWORKSTEP#'+strCode;
						var values = ajaxRequest(modWorkstepName,'PAYMENT_DELETION');
						
						if (values [1] =='Business') {
							alert(values [0]);
							document.getElementById('wdesk:errorMsgFromFinacle').value = values [0];
							document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_DELETION";
						}
						else {
							alert("Error deleting payment in finacle");
							document.getElementById('wdesk:errorMsgFromFinacle').value = "Error deleting payment in finacle";
							document.getElementById('wdesk:failedIntegrationCall').value = "PAYMENT_DELETION";
						}
						document.getElementById('wdesk:isPayDelFromFinacle').value = 'N';
						return false;
					}
				}
				else {
					alert("Error deleting payment in finacle");
				}
			}
		}
	
		function retryIntegration() {
			var intCallName = document.getElementById('wdesk:failedIntegrationCall').value;

			if (intCallName == 'PAYMENT_REQ') {
				var strCode = document.getElementById("wdesk:strCode").value;
				if (strCode=="EMPTY" || strCode=="911" || strCode=="2033" || strCode=='1362') {
					alert("Payment Creation already timed out,please discard the case");
					return false;				
				}
				else
					getTTRefNum();
			}
			else if (intCallName == 'PAYMENT_DELETION' || intCallName == 'EVENT_NOTIFICATION')
				deletePaymentFromFinacle();
			else if (intCallName == 'PAYMENT_DETAILS')
				getTTStatus();
		}
		
		function retryIntegAtMakerChecker(workstepname)
		{
			if (workstepname == 'Ops_Checker' || workstepname == 'Ops_Checker_DB')
				getTTStatus();
			else if (workstepname == 'Ops_Maker')
			{
				//If TT not synced up
				if (document.getElementById('wdesk:isStatusSyncUp').value != 'Y')
					getTTStatus();

				//If event notification failed
				if (document.getElementById('wdesk:isEventNotifySuccess').value != 'Y')
					eventNotification();
			}
			else if (workstepname == 'Ops_Maker_DB')
			{
				//If TT not synced up
				if (document.getElementById('wdesk:isStatusSyncUp').value != 'Y')
					getTTStatus();
			}
		}
		
		function trimLength(id,value,maxLength){
			newLength=value.length;
			value=value.replace(/(\r\n|\n|\r)/gm," ");
			//value=value.replace(/[^a-zA-Z0-9_.,&:"'[]\/\]/g,"");
			value=value.replace(/[^a-zA-Z0-9_&" ',.\-\\\/]/g,"");
			if(newLength>=maxLength){
				value=value.substring(0,maxLength);		
			}
			document.getElementById(id).value=value;
		}
		
		function deleteChildsFromSelect(workstepname) {

			var channel_id = document.getElementById('wdesk:channel_id').value;
			if (workstepname=='CSO_Exceptions') {
				if (channel_id == 'IB' || channel_id=='MB' || channel_id=='YAP' || channel_id=='DIP') {
					var select = document.getElementById('decisionRoute');
					if (select.hasChildNodes()) {
						select.removeChild(select.childNodes[0]);
						select.removeChild(select.childNodes[2]);
					}
				}
			}
		}
		
		
		String.prototype.trim = function() {

			return this.replace(/^\s+|\s+$/g,"");
		}
		
		String.prototype.replaceAll = function(search, replacement) {
			var target = this;
			return target.replace(new RegExp(search, 'g'), replacement);
		};
		//Added by Saquib on 30-08-2017 for reloading document in iframe after model dialog window close
		function reloadDocument() 
		{
			if(window.parent.document.getElementById('docviewer'))
			{
			window.parent.document.getElementById('docviewer').src = window.parent.document.getElementById('wdesk:docFrameURL').value;
			}
		}
		//Added by siva for TT CR 10032020
		function disabledecision(wsname)
		{
				var x = document.getElementById("decisionRoute");				
				var CreateWIStatus=document.getElementById("wdesk:CREATE_WI_STATUS").value;	
				var channel = document.getElementById('wdesk:channel_id').value;
				var prevWs = document.getElementById("wdesk:prev_WS").value;				
				if(wsname=='Error')
				{
					if(CreateWIStatus == "Y")
					{
						for (var i = 0; i < x.options.length; i++) 
						{
							if(x.options[i].value=='Send to Ops Maker' || x.options[i].value=='Send to Ops Checker' || x.options[i].value=='Re-Integrate')
							{
								x.options[i].disabled = true;
							}
							
							if(channel == 'YAP' || channel == 'DIP')
							{
								if(x.options[i].value=='Re-Integrate' || x.options[i].value=='Send to Discard')
								{
									x.options[i].disabled = false;
								}
								else
									x.options[i].disabled = true;
							}
							
						}
					}
					else
					{
						for (var i = 0; i < x.options.length; i++) 
						{
							if(x.options[i].value=='Send to Ops Maker DB' || x.options[i].value=='Send to Ops Checker DB' || x.options[i].value=='Re-Integrate')
							{
								x.options[i].disabled = true;
							}
						}
					}					
				}				
		}
		function setMailIdForIBMBCases()
		{
			var channel = document.getElementById('wdesk:channel_id').value;
			if(channel == 'YAP')
			{
				var YAPMailID = ajaxRequest('AnyWorkstep','YAPSPOCMail');
				document.getElementById("wdesk:forNonComplianceEmailID").value=YAPMailID;
				document.getElementById("wdesk:forComplianceEmailID").value=YAPMailID;
			}
			else {
				document.getElementById("wdesk:forNonComplianceEmailID").value=ajaxRequest('AnyWorkstep','IBMBNonComplianceMail');
				document.getElementById("wdesk:forComplianceEmailID").value=ajaxRequest('AnyWorkstep','IBMBComplianceMail');
			}
		}
		
	</script>
	   <script src="/webdesktop/webtop/scripts/TT_Scripts/BigInteger.js"></script>
	   <script src="/webdesktop/webtop/scripts/TT_Scripts/HandleAjaxRequest.js"></script>	
    </body>
</html>
