<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : viewform
    Created on : Nov 9, 2015, 5:40:56 PM
    Author     : puneet.pahuja

    09/02/2016  Rohit Kumar     Bug 58976 - Header name should be shown in middle of the form
    01/03/2016  Mohit Sharma    Bug 59374 - If set image through image url ,it does not shown properly during WI creation        
    02/03/2016  Mohit Sharma    Bug 59377 - Iphone(5s):-Create new WI through device iform screen should be fixed
    20/07/2016  Rohit Kumar     Bug 61769 - Grid structure is required in iform
    23/02/2017  Rohit Kumar     Bug 65126 - iBPS Mobile: select value from combobox complete screen is blank.
    14/04/2017                  Bug 68608
    20/04/2017  Rohit Kumar     Bug 68752 - Alignment of radio button is not correct on iform
    16/02/2017			Bug 69264
    26/03/2018  Aman Khan       Bug 76762 - List View functionality not working not able to add rows
    02/04/2018  Aman Khan       Bug 76725 - EAP6.4+SQL: Header border is not coming properly on WI creation
    11/04/2018  Aman Khan       Bug 76719 - EAP6.4+SQL: Theme color is not getting applied to date picker icon inside tabel
    18/05/2018  Gaurav          Bug 77569 - Arabic ibps 4: Alignment of scroll bar is in incorrect direction. It shoud be on left side.
    18/05/2018  Gaurav          Bug 77854 - Create WI ,Iform not loaded only blank screen shown loading icon should be shown.
    03/06/2019  Rohit Kumar     Bug 84997 - Improper display of Vietnamese character in iForms
    28/05/2019  Rohit Kumar     Bug 84965 - Preventing backspace key when form is open , is working in Chrome but form is allowing backspace key in Internet Explorer 11 and form turns blank.\
    17/07/2019  Aman Khan       Bug 85656 - requirement for password field control
    24/07/2019  Aman Khan       Bug 85728 - Textbox not taking arabic data when the special characters are not allowed
    06/08/2019  Aman Khan       Bug 85842 - Performance issue due to editable combo loading on form load
    14/08/2019  Abhishek        Bug 85972 - hide datepicker icon on disable with ini
    07/10/2019  Abhishek        Bug 87164 - Need to restrict escape key on form.
    31/10/2019  Rohit Kumar     Bug 87917 - No Logout message on session expire.
    08/11/2019  Rohit Kumar     Bug 87938 - isReadOnlyForm flag not returning correct value for readonly form.
    31/01/2020  Aman Khan       Bug 90468 - Need to show label on listview combobox instead of value
    13/03/2020  Aman Khan       Bug 91237 - Need to use up/key/tab keys in the picklist window
    16/03/2020  Deepak Singh Rawat  Bug 90690 - Need of AssignedTo user property in IForm.

--%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.iforms.custom.IFormContext"%>
<%@page import="com.newgen.iforms.custom.IFormReference"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.controls.EButtonControl"%>
<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="java.util.UUID"%>
<%@page import="com.newgen.wfdesktop.session.WDSession"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="com.newgen.wfdesktop.util.WDUtility"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.File"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.iforms.util.StringUtils"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import ="com.newgen.wfdesktop.xmlapi.WDXMLTAGS"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.nav.IFormFragInfo"%>
<%@page import="com.newgen.iforms.nav.Menu"%>
<%@page import="com.newgen.iforms.util.CommonUtility"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
%>
<!DOCTYPE html>
<html dir=<%= lbls.getString("HTML_DIR") %> >
    <head>
        <%
            request.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
            response.setHeader("Pragma", "no-cache"); //HTTP 1.0
            response.setDateHeader("Expires", -1); //prevents caching at the proxy server

			String randomId = IFormUtility.getRid();
            WorkdeskModel wdmodel = null;
            IFormSession formsession = null;
            String pid = "";
            if(request.getParameter("pid")!=null && request.getParameter("pid")!="")
                pid=IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
            String tid = IFormUtility.getIFormTaskId(request);   
            String fSessionId="";
            String pageformUID="";
            if(request.getParameter("fid")!=null)
                pageformUID=IFormUtility.escapeHtml4(request.getParameter("fid"));
            else
                pageformUID = "Form";
            //Bug 87917 
    //        if(pid == null || pid == ""){
    //            HttpSession session1=request.getSession(true);
    //        }
            pageformUID=pageformUID+"_"+pid+"_"+wid;
            if(!"".equals(tid))
                pageformUID=pageformUID+"_"+tid;
            fSessionId="i"+pageformUID+"Session";   
            
            if (session.getAttribute(fSessionId) == null) {
                formsession = new IFormSession(request);
                if (request.getParameter("CabinetName") == null) {
                        formsession.setM_strUserName(wDSession.getM_objUserInfo().getM_strUserName());
                        formsession.setM_strUserIndex(wDSession.getM_objUserInfo().getM_strUserIndex());
                        formsession.setM_strSessionId(wDSession.getM_objUserInfo().getM_strSessionId());
                        formsession.setM_iClientTimeDiff(wDSession.getM_iClientTimeDiff());
                        formsession.setM_iServerTimeDiff(wDSession.getM_iServerTimeDiff());
                        formsession.setM_strDateFormat(wDSession.getM_strDateFormat());
                        formsession.setM_strCabinetName(wDSession.getM_objCabinetInfo().getM_strCabinetName());
                    }
                    formsession.updateCabinetDetails();
                session.setAttribute(fSessionId, formsession);
            } else {
                formsession = (IFormSession) session.getAttribute(fSessionId);
            }   
            boolean isEditableComboOnLoad=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)));
            boolean isShowGridComboLabel=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));
			String isEncryptedSessioId=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_ENCRYPTED_SESSIONID);	
            boolean useCustomIdAsControlName=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USE_CUSTOM_ID_AS_CONTROL_NAME) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USE_CUSTOM_ID_AS_CONTROL_NAME)));
                        boolean isServerValidation = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION)));
						boolean isReverseButtonOrder = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT)));
            boolean isReverseButtonOrder = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT)));
            boolean autoIncrementLabelDisplay=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL)));
            String listViewCharacterLimit =IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.LISTVIEW_CHARACTER_LIMIT);
            boolean multipleRowDuplicate=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE)));										  
            boolean isGridBatchingEnabled = false;
            String dateFormat = "dd/MMM/yyyy";
			String dateDbFormat="";
            String dateSeparator="";
			boolean isReadOnlyForm = false;
            String activityName="";
            String processName="";
            String processDefId="";
            String processInstanceId = "";
            String cabinetName = "";
            String appServerIp = "";
            String appServerPort = "";
            String userName = "";
            String activityID = "";
            String isDatePicker=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.HIDE_DATEPICKER_ON_DISABLE);
            String isOverlayOpen=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.RESTRICT_CLOSE_OVERLAY);
            String disableFieldFontColor=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.DISABLE_FIELD_FONT_COLOR);
            String userIndex = "";
            String sessionID = "";
            String subTaskId = "";
            String taskName = "";
            String mobileMode = "";
            //List<String> userIndices = null;
            
            try {
                WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
                if (wisessionbean != null) {
                    LinkedHashMap workitemMap = wisessionbean.getWorkItems();                    
                    if(tid==null || tid.isEmpty()){
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                    }
                    activityName=wdmodel.getM_objGeneralData().getM_strActivityName();
                    processName=wdmodel.getM_objGeneralData().getM_strProcessName();
                    processDefId=wdmodel.getM_objGeneralData().getM_strProcessDefId();
                    processInstanceId = wdmodel.getM_objGeneralData().getM_strProcessInstanceId();
                    cabinetName = wdmodel.getM_objGeneralData().getM_strEngineName();
                    appServerIp = wdmodel.getM_objGeneralData().getM_strJTSIP();
                    appServerPort = wdmodel.getM_objGeneralData().getM_strJTSPORT();
                    userName =wdmodel.getM_objGeneralData().getM_strUserName();
                    activityID = wdmodel.getM_objGeneralData().getM_strActivityId();
                    sessionID = wdmodel.getM_objGeneralData().getM_strDMSSessionId();
					if("Y".equalsIgnoreCase(isEncryptedSessioId)) 
		         	{
			          sessionID = IFormUtility.decryptStringData(sessionID);
			        }
                    subTaskId = wdmodel.getM_objGeneralData().getSubTaskId();
                    taskName = wdmodel.getM_objGeneralData().getTaskName();
                    isReadOnlyForm = "R".equals(wdmodel.getM_objGeneralData().getM_strMode());  //Bug 87938
					String strMode = wdmodel.getM_objGeneralData().getM_strMode();	
                        if(!"R".equals(strMode)){
                            strMode = wdmodel.getWfForm().getFormViewModeForTask();  
                                 if("R".equals(strMode)){
	
                                        wdmodel.getM_objGeneralData().setM_strMode("R");
	
                                 }
						}
                                                
                        isReadOnlyForm = "R".equals(strMode);
                    isGridBatchingEnabled = (!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
                    userIndex = wdmodel.getM_objGeneralData().getM_strUserIndex();
                   // userIndices = wdmodel.getM_objGeneralData().getM_arrDocInfo();
                }
            } catch (Exception e) {
                
            }

            String formName = "", formDir = "", routeId = "";
            if(request.getParameter("FormName") != null){
                formName = request.getParameter("FormName");
                formName = IFormUtility.escapeHtml4(formName);
            } else {
                formName = wdmodel.getWfForm().getFormIndex();
            }
            
            String strActivityId = "", strRouteId = "";
            if(request.getParameter("WorkstageId") != null){
                strActivityId = request.getParameter("WorkstageId");
                strActivityId = IFormUtility.escapeHtml4(strActivityId);
            } else {
                strActivityId = wdmodel.getWorkitem().getWorkStageID();
            }
            
            if(request.getParameter("ProcessDefId") != null){
                strRouteId = request.getParameter("ProcessDefId");
            } else {
                strRouteId = wdmodel.getWorkitem().getRouteId();
            }
            
            if(request.getParameter("FormDir") != null){
                formDir = request.getParameter("FormDir");
            } else {
                formDir = wDSession.getM_objCabinetInfo().getM_strCabinetName()+"_"+strRouteId+"_"+strActivityId;
            }
            
            String applicationName="";
            if(IFormUtility.escapeHtml4(request.getParameter("appName"))!=null){
                applicationName=IFormUtility.escapeHtml4(request.getParameter("appName"));
            }
            String registeredMode="";
            if(request.getParameter("RegisteredMode")!=null){
                registeredMode=request.getParameter("RegisteredMode");
            }
            String filterValue = "";
            filterValue = IFormUtility.escapeHtml4(request.getParameter("filterValue"));        
            String formBufferPath = application.getRealPath("/") + File.separator + WDUtility.GetTempDirectory() + File.separator + formDir +File.separator+formName;            
            IFormViewer objViewer = new IFormViewer();
            objViewer.init(request, formBufferPath);
            formsession.setM_objFormViewer(objViewer); 
            dateDbFormat=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
            dateSeparator = objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();
            String ds="",df="";
            if(dateSeparator.equalsIgnoreCase("1"))
                ds = "/";
            else if(dateSeparator.equalsIgnoreCase("2"))
                ds = "-";
            else if(dateSeparator.equalsIgnoreCase("3"))
                ds = ".";	
            if(dateDbFormat.equalsIgnoreCase("1"))
            {
                df = "dd"+ds+"MM"+ds+"yyyy";
            }
            if(dateDbFormat.equalsIgnoreCase("2"))
            {
                df = "MM"+ds+"dd"+ds+"yyyy";
            }
            if(dateDbFormat.equalsIgnoreCase("3"))
            {
                df = "yyyy"+ds+"MM"+ds+"dd";
            }
            if(dateDbFormat.equalsIgnoreCase("4"))
            {
                df = "dd"+ds+"MMM"+ds+"yyyy";
            }
            formsession.setM_strDateFormat(df);	 			
            session.setAttribute("obj"+pageformUID+"Viewer", objViewer);
            if (wdmodel != null) {
                dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
            }
            
            //String rid = wDApplication.getM_strRId();
            String rid = request.getParameter("rid");
            rid = IFormUtility.escapeHtml4(rid);
            if(rid==null || rid.isEmpty()){
                rid = UUID.randomUUID().toString();
            }
            mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();
            String buttonId = request.getParameter("buttonId");
            if(buttonId!=null && !buttonId.isEmpty()){
                EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
                ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
            }
			String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
            String reqTok = (String) IFormUtility.escapeHtml4(request.getParameter("WD_RID"));
            String rid_Action = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/action.jsp");
            String rid_ActionAPI = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/action_API.jsp");
            String rid_IfHandler = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/ifhandler.jsp"); 
            String rid_listviewmodal = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/listViewModal.jsp");
            String rid_advancelistviewmodal = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/advancedListViewModal.jsp");
            String rid_picklistview = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/picklistview.jsp");
            String rid_texteditor = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/texteditor.jsp");
            String rid_webservice = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/webservice.jsp");
			String rid_appTask = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/portal/appTask.jsp");

        %>
        <title><%= lbls.getString("PREVIEW")%></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.js?rid=<%= randomId%>"></script>
        <link rel="stylesheet" href="resources/bootstrap/css/jquery-ui.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js?rid=<%= randomId%>"></script>
		<script type="text/javascript" src="resources/bootstrap/js/moment.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-multiselect.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/constants.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/iformCustomMsg.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/commonmethods.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/net.js?rid=<%= randomId%>"></script>
<!--        <script type="text/javascript" src="resources/scripts/iformclient.js"></script>-->
        <script type="text/javascript" src="resources/scripts/iformview.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/datevalidation.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/floating-labels.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/ifomstyle.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-multiselect.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.min.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/navigation.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/floating-labels.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/common.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/customcss.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead._.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datetimepicker.css?rid=<%= randomId%>">      
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datetimepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.mask.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/ajax.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/jquery.datetimepicker.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.datetimepicker.full.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/autoNumeric.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font-awesome.min.css?rid=<%= randomId%>">
		<script type="text/javascript" src="resources/bootstrap/js/bootbox.min.js?rid=<%= randomId%>"></script>
		<script type="text/javascript" src="resources/bootstrap/js/jquery.formError.js?rid=<%= randomId%>"></script>
		<script type="text/javascript" src="resources/scripts/html2canvas.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/jquery.plugin.html2canvas.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font.css?rid=<%= randomId%>">
		<script type="text/javascript" src="resources/scripts/securenumbermask.js?rid=<%= randomId%>"></script>
		<link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/jquery-ui-1.8.21.custom.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/scripts/iformclient.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/editable-select.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-editable-select.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
        <link rel="stylesheet" href="resources/bootstrap/css/jquery.scrolling-tabs.css?rid=<%= randomId%>"/>
         <script type="text/javascript" src="resources/bootstrap/js/jquery.scrolling-tabs.js?rid=<%= randomId%>"></script>
		 <script type="text/javascript" src="resources/scripts/tooltipster.bundle.min.js?rid=<%= randomId%>"></script>
         <link rel="stylesheet" href="resources/css/tooltipster.bundle.css?rid=<%= randomId%>"/>
         <link href="resources/scripts/froala_editor/css/froala_editor.pkgd.min.css?rid=<%= randomId%>" rel="stylesheet" type="text/css" />
         <link href="resources/scripts/froala_editor/css/froala_style.min.css?rid=<%= randomId%>" rel="stylesheet" type="text/css" />    
         <script type="text/javascript" src="resources/scripts/froala_editor/js/froala_editor.pkgd.min.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/iformapi.js?rid=<%= randomId%>"></script>
         <link type="text/css" rel="stylesheet" href="resources/css/nav.css?rid=<%= randomId%>">
         <script type="text/javascript" src="resources/scripts/blowfish.js?rid=<%= randomId%>"></script>
        <script>
            var useCustomIdAsControlName = <%=useCustomIdAsControlName%>;
            var pid = "<%=pid%>";
            var wid = "<%=wid%>";
            var tid = "<%=tid%>";
            var dateFormat = "<%=dateFormat%>";
            var processName = "<%=processName%>";
            var processDefId = "<%=processDefId%>";	
            var activityName = "<%=activityName%>";
            var fid = "<%=pageformUID%>";
            var isReadOnlyForm = <%=isReadOnlyForm%>;
            var processInstanceId="<%=processInstanceId%>";
            var cabinetName="<%=cabinetName%>";
            var appServerIp="<%=appServerIp%>";
            var appServerPort="<%=appServerPort%>";
            var userName = "<%=userName%>";
            var fSessionId = "<%=fSessionId%>";
            var sessionId = "<%=sessionID%>";
            var activityID = "<%=activityID%>";
            var userIndex = "<%=userIndex%>";
            var isDatePicker = "<%=isDatePicker%>";
            var isOverlayOpen = "<%=isOverlayOpen%>";
            var disableFieldFontColor = "<%=disableFieldFontColor%>";
            var subTaskId = "<%=subTaskId%>";
            var taskName = "<%=taskName%>";
            var rid = "<%=rid%>";
            var globalDateFormat="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat()%>";
            var globalDateSeparator="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator()%>";
            var mobileMode = "<%=mobileMode%>";
            var formName = "<%=objViewer.getM_objFormDef().getM_strFormAlias()%>";
            var formMode="W";//Bug 82321
            var isEditableComboOnLoad = "<%=isEditableComboOnLoad%>";
            var isGridBatchingEnabled = "<%=isGridBatchingEnabled%>";
            var autoIncrementLabelDisplay = "<%=autoIncrementLabelDisplay%>";
            var listViewCharacterLimit = "<%=listViewCharacterLimit%>";
            var multipleRowDuplicate = "<%=multipleRowDuplicate%>";
            var isServerValidation = "<%=isServerValidation%>";
			var isReverseButtonOrder = "<%=isReverseButtonOrder%>";
            var isShowGridComboLabel = "<%=isShowGridComboLabel%>";
             var filterValue = "<%=filterValue%>";
             var applicationName="<%=applicationName%>";
             var registeredMode="<%=registeredMode%>";
            var iformLocale="<%=lbls.getString("Path")%>";
            window.onresize = function (e) {
                var scrollerWidthofBrowser = getBrowserScrollSize().width;
                if(document.getElementById("headerDiv"))
                    document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                if(document.getElementById("affix_padding") && document.getElementById("headerDiv")){
                if(parseInt(window.innerHeight)>parseInt(document.getElementById("headerDiv").clientHeight*3)){
                
                    document.getElementById("affix_padding").style.paddingTop= (parseInt(document.getElementById("headerDiv").clientHeight))+"px";
                    if(document.getElementById("headerDiv").style.position!='fixed'){
                        document.getElementById("headerDiv").style.position='fixed';
                        document.getElementById("headerDiv").style.top='0';
                        document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                        }
                    
                    }
                else{
                    document.getElementById("affix_padding").style.paddingTop = "";
                    document.getElementById("headerDiv").style.position='';
                    document.getElementById("headerDiv").style.top='';
//                    document.getElementById("headerDiv").classList.remove("affix");
                   document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                    }
                }
                makeStickyTabs();
				sectionAsFooter(footerFrameName);
            }
        </script>  

        <style>
            .affix {
              top: 0;
              width: 100%;
              <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
              padding-right: 17px;
              <%}%>
            }
            .affix + .affix_padding {
                <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
                    
                <%}
                else if(StringUtils.isEmpty(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoPath())){
                     if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bShowHeader()){
                %>
                  padding-top:<%=(Integer.parseInt(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoHeight()))+52%>px;
                  <%}
                 else{%>
                  padding-top:<%=(Integer.parseInt(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoHeight()))+25%>px;
                  <%}}
                    else{%>
                  padding-top:50px;
                  <%}%>
              }
            .affix-top {
              /*width: 100%;*/
            }

            .affix-bottom {
                /*top: 0;*/
              /*width: 100%;*/
              /*position: absolute;*/
            }
            <%= objViewer.getM_objFormDef().getRenderCSS()%>		
        </style>
        <!--Bug 65126-->
		<style>
			html{
				height: 100%;
				overflow: auto;
				-webkit-overflow-scrolling: touch;
			}
			body{
				height: 100%;
				/*overflow: auto;*/
				-webkit-overflow-scrolling: auto;
                                -ms-overflow-style: scrollbar;
			}
                        .squaredTwo input[type=checkbox]:checked + label{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                         }
                       .radioTwo input[type=radio]:checked + label{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .squaredOne label:after{
                           border-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .radioOne label:after {
                             background-color: #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .squaredOne input[type=checkbox]:checked + label,.radioOne input[type=radio]:checked + label{
                           border: 2px solid #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                        .bootbox.modal {
                           z-index: 9999 !important;
                       }
                       .multiselect-container {
                            width: 100% !important;
                        }
                        <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objSectionFormStyle().isM_bRemoveMargins()){%>
                        .iform-table .radioTwo label:after{
                            top: 3px !important;
                            left: 3px !important;
                        }
                        .iform-table .radioOne label:after{
                            top: 1px !important;
                            left: 1px !important;
                        }
                        .disabledBGColor{
                            background-color: #e4e4e4 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                        }
                        .disabledTableBGColor{
                            background-color: #e4e4e438 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                        }
                        .disabledTableFont{
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                        }
                        <%}%>
						.fr-top{
                            border-top:0 !important;
                        }
        </style>
    </head>
    <body onload="doInit('form');" onunload="closeSubForm()" onkeydown="bodykeyDown(event);stopFormRefreshing(event);" onkeypress="stopFormRefreshing(event);" onbeforeunload="closeSubForm()" style="overflow:auto;" class="iBodyStyle">
        <div id="fade" class="black_overlay"></div>																	
        <script>
            CreateIndicator("application");
			document.getElementById("fade").style.display="block";																																														
        </script>
		<input type="hidden" id="sid" name="sid" value= "<%=sid%>" >
        <input type="hidden" id="rid_Action" name="rid_Action" value= "<%=rid_Action%>" >
        <input type="hidden" id="rid_ActionAPI" name="rid_ActionAPI" value= "<%=rid_ActionAPI%>" >
        <input type="hidden" id="rid_IfHandler" name="rid_IfHandler" value= "<%=rid_IfHandler%>" >
        <input type="hidden" id="rid_listviewmodal" name="rid_listviewmodal" value= "<%=rid_listviewmodal%>" >
        <input type="hidden" id="rid_advancelistviewmodal" name="rid_advancelistviewmodal" value= "<%=rid_advancelistviewmodal%>" >
        <input type="hidden" id="rid_picklistview" name="rid_picklistview" value= "<%=rid_picklistview%>" >
        <input type="hidden" id="rid_texteditor" name="rid_texteditor" value= "<%=rid_texteditor%>" >
        <input type="hidden" id="rid_webservice" name="rid_webservice" value= "<%=rid_webservice%>" >
		<input type="hidden" id="rid_appTask" name="rid_appTask" value= "<%=rid_appTask%>" >
		
		<div id="oforms_iform" style="padding-top:10px;min-height:99%;height:auto;margin:auto;margin-top:3px;" class="iFormStyle">
        <%if(!objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
        <div style="width: 100%;text-align:center" class="affix_padding"></div>
        <%}%>
        <% try{
             IFormReference objFormReference = new IFormAPIHandler(request,response,pageformUID);
            IFormServerEventHandler objCustomCodeInstance = IFormContext.getInstance(objFormReference);
            if( objCustomCodeInstance != null )        
            {    
            	formsession.setObjServerEventHandler(objCustomCodeInstance);
                formsession.setObjFormReference(objFormReference);
                objCustomCodeInstance.beforeFormLoad(objViewer.getM_objFormDef(), objFormReference);
            }
            IFormFragInfo fragmentObj = null;
                if (objViewer.getM_objFormDef().getM_objNav() != null) {
                    if (!objViewer.getM_objFormDef().getM_objNav().getObjMenuList().isEmpty()) {
                        Menu obj_menu = objViewer.getM_objFormDef().getM_objNav().getObjMenuList().get(0);
                        if (obj_menu.getM_objSubMenuList().isEmpty()) {
                            fragmentObj = obj_menu.getObjFragment();
                        } else if (!obj_menu.getM_objSubMenuList().isEmpty()) {
                            fragmentObj = obj_menu.getM_objSubMenuList().get(0).getObjFragment();
                        }
                        formsession.setM_strStage("0");
                        formsession.setM_strSubStage("0");
                        if (fragmentObj != null) {
                            try {
                                IFormUtility.populateFragmentBuffer(request, objViewer.getM_objFormDef(), fragmentObj, formsession);
                                CommonUtility.populateModelForFragment(request, objViewer.getM_objFormDef(), fragmentObj,formsession);
                            } catch (Exception e) {
                            }
                        }
                    }
                }
            }catch(Exception ex){}
            catch(Error ex){}
        %>
        <%=  objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel)%>
		</div>
        <div class="modal"  id="searchModal" role="dialog" data-backdrop="static" style="z-index:2003;" class="paddingleft10">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" id="closeButton" class="close" onclick="disablePrevious()" data-dismiss="modal">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                        <h4 class="modal-title" id="picklistHeader" style="word-break: break-word;"></h4>

                    </div>
                    <div  class="modal-body">

                        <div class="embed-responsive embed-responsive-16by9">
                            <iframe id="iFrameSearchModal" class="embed-responsive-item" src=""></iframe>
                        </div>

                    </div>                        
                    <div class="modal-footer table-responsive container-fluid">
                        <button style="width:70px;" type="button" onclick="showNextPreviousResult('previous')" id="picklistPrevious" class=" btn btn-primary btn-sm pull-left" disabled="true"> <%= lbls.getString("PREVIOUS")%></button>
                        <button style="width:70px;" type="button" onclick="showNextPreviousResult('next');" id="picklistNext" class="btn btn-primary pull-left btn-sm  "> <%= lbls.getString("NEXT")%></button>
                        <button style="width:70px;" type="button" onclick="setSelectedRow();" id="picklistOk" data-dismiss="modal" class=" btn btn-success btn-sm "> <%= lbls.getString("OK")%></button> 
                        <button style="width:70px; padding-left:2px; padding-right:2px;" type="button" id="picklistCancel" class=" btn btn-danger btn-default btn-sm" onclick="disablePrevious()" data-dismiss="modal"><span class="glyphicon "></span> <%= lbls.getString("CANCEL")%></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal"  id="listViewModal" role="dialog" data-backdrop="static" style="z-index:2002"  data-keyboard="false">
            <div id="iFrameListViewModal" class="modal-dialog modal-lg modal-md">
<!--                <div class="modal-content">
                    <div class="modal-header">
                        <button  type="button" id="closeButton" class="close" onclick="disablePrevious();removerowToModify();" data-dismiss="modal">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                        <h4 class="modal-title" id="listViewHeader" style="word-break: break-word;"></h4>

                    </div>
                    <div  class="modal-body">

                        <div class="embed-responsive embed-responsive-16by9">
                            <div id="iFrameListViewModal" ></div>
                        </div>
                        
                    </div>                        
                    
                </div>-->
            </div>
            <input id="table_id" style="display: none">
            <input id="rowCount" style="display: none">
        </div>
        <div class="modal"  id="subFormModal" role="dialog" data-backdrop="static" style="z-index:2000">
            <div id="iFrameSubFormModal" class="modal-dialog modal-lg modal-md">
            </div>
         </div>
         <div  id="LinkModal" style="display:none;">
                         <iframe id="iFrameLinkModal" style="width:100%;height:100%"></iframe>
                    </div>
                    <div class="modal" id="advancedListViewModal" role="dialog" data-backdrop="static"  data-keyboard="false">
                        <div id="iFrameAdvancedListViewModal" class="modal-dialog modal-lg modal-md">
                            
                        </div>
                        <input id="advancedListview_id" style="display: none">
                        <input id="advancedListviewRowCount" style="display: none">
                    </div>
                    <div id="fade" class="black_overlay"/>
                    <button type="button" style="display:none" onclick="saveForm(1)"/>
                     <div id="pnlDialog" title="Alert" style="display: none;">                            
                        <br/>
                        <h:graphicImage id="dlgIcon" library="images" name="warning.png" style="float:left; margin:0 7px 20px 0;width:32px;height: 32px;" />
                        <h:panelGroup id="dlgContent" layout="block" >
                        </h:panelGroup>                            
                    </div>
                    <script>
                
                $("#advancedListViewModal").on("hidden.bs.modal", function () {
                    clearAdvancedListviewMap();
                    removeAdvancedListviewrowToModify();
                });
            </script>
			<script type="text/javascript" src="resources/scripts/DocumentWidget.js?rid=<%= randomId%>"></script>
    </body>    

</html>
