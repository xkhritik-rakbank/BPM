<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : subFormViewer
    Created on : 19 Jun, 2018, 12:30:17 PM
    Author     : aman.khan


24/10/2018  Aman Khan       Bug 80988 - Reduction in size of ListView Modal in IForm
16/11/2018  Aman Khan       Bug 81386 - Need to show message box on top of grid form
04/12/2018  Aman Khan       Bug 80799 - Android device:-subform functionality not working on form .
03/06/2019  Rohit Kumar     Bug 84997 - Improper display of Vietnamese character in iForms
06/08/2019  Aman Khan       Bug 85842 - Performance issue due to editable combo loading on form load
17/07/2019  Aman Khan       Bug 85656 - requirement for password field control
29/04/2020  Aman Khan       Bug 92246 - Data Duplication in Advanced List View

--%>

<%@page import="com.newgen.iforms.controls.EButtonControl"%>
<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="java.util.Locale"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.iforms.util.StringUtils"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.ResourceBundle"%>


<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
  request.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
            response.setHeader("Pragma", "no-cache"); //HTTP 1.0
            response.setDateHeader("Expires", -1); //prevents caching at the proxy server
            
            WorkdeskModel wdmodel = null;
            String fSessionId = IFormUtility.getIFormSessionUID(request);   
            IFormSession formsession = (IFormSession) session.getAttribute(fSessionId);
            boolean isEditableComboOnLoad=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)));
            boolean useCustomIdAsControlName=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USE_CUSTOM_ID_AS_CONTROL_NAME) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USE_CUSTOM_ID_AS_CONTROL_NAME)));
            String disableFieldFontColor=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.DISABLE_FIELD_FONT_COLOR);
            boolean isReadOnlyForm = formsession.isReadOnlyForm();     
            boolean isGridBatchingEnabled = false;                        
            String pid = "";
            if(request.getParameter("pid")!=null && request.getParameter("pid")!="")
                pid=IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
            String tid = IFormUtility.getIFormTaskId(request);   
            String dateFormat = "dd/MMM/yyyy";
            String activityName="";
            String processName="";
            String processInstanceId = "";
            String cabinetName = "";
            String appServerIp = "";
            String appServerPort = "";
            String userName = "";
            String activityID = "";
            String userIndex = "";
            String sessionID = "";
            String mobileMode = "";
            String subTaskId = "";
            String taskName = "";
            
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
                    processInstanceId = wdmodel.getM_objGeneralData().getM_strProcessInstanceId();
                    cabinetName = wdmodel.getM_objGeneralData().getM_strEngineName();
                    appServerIp = wdmodel.getM_objGeneralData().getM_strJTSIP();
                    appServerPort = wdmodel.getM_objGeneralData().getM_strJTSPORT();
                    userName =wdmodel.getM_objGeneralData().getM_strUserName();
                    activityID = wdmodel.getM_objGeneralData().getM_strActivityId();
                    sessionID = wdmodel.getM_objGeneralData().getM_strDMSSessionId();
                    subTaskId = wdmodel.getM_objGeneralData().getSubTaskId();
                    taskName = wdmodel.getM_objGeneralData().getTaskName();
                    isGridBatchingEnabled = (!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
                }
            } catch (Exception e) {
               
            }
             
            String iformVSessionUID = IFormUtility.getIFormVSessionUID(request);
            IFormViewer objViewer = (IFormViewer)session.getAttribute(iformVSessionUID);
            if (wdmodel != null) {
                dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
            }
            mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();

            boolean isMobileMode=("ios".equalsIgnoreCase(mobileMode)||"android".equalsIgnoreCase(mobileMode))?true:false;

            String buttonId = IFormUtility.escapeHtml4(request.getParameter("buttonId"));
            EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
             if(buttonControl.getControlSetInfo()!=null)
            objViewer.getM_objFormDef().parseControlGroupInfo(buttonControl.getControlSetInfo(), "subform", buttonId);
            //for(int i=0;i<buttonControl.getFrameList().size();i++){
              //((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).getM_arrFrameControls().add(buttonControl.getFrameList().get(i));
           // }
          ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
%>
<%if(isMobileMode){%>
<div class="modal-content">
            <div class="modal-header" style="padding-top:0px;padding-bottom:0px;border-bottom:0px;">
                <div style="width:100%;">
                        <span style="padding:0px 3px;float:right;text-align:end;">   
                            <button  style="margin-top:4px; float:<%=lbls.getString("RIGHT")%> " type="button" id="closeButton" class="close" data-dismiss="modal">
                                <span class="glyphicon glyphicon-remove"></span>
                            </button>
                        </span>
                </div>
            </div>
            <div class="modal-body" style="height:auto;padding-top:0px;padding:0px;">
               <%=objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel)%>
            </div>

</div>
<%}else{%>
<!DOCTYPE html>
<html dir=<%=lbls.getString("HTML_DIR")%>
    <head>

        <title><%= buttonControl.getM_strControlLabel() %></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,EmulateIE9,EmulateIE10,EmulateIE11" />
        <script type="text/javascript" src="resources/bootstrap/js/jquery-3.4.1.js"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css">
<!--        <link rel="stylesheet" href="resources/bootstrap/css/jquery-ui.css">-->
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-multiselect.css">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery-editable-select.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.formError.js"></script>        
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.min.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-multiselect.js"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/constants.js"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/iformCustomMsg.js"></script>
        <script type="text/javascript" src="resources/scripts/commonmethods.js"></script>
        <script type="text/javascript" src="resources/scripts/net.js"></script>
        <script type="text/javascript" src="resources/scripts/iformview.js"></script>
        <script type="text/javascript" src="resources/scripts/iformclient.js"></script>
        <script type="text/javascript" src="resources/scripts/floating-labels.js"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/editable-select.css">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/ifomstyle.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.min.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/navigation.css">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/floating-labels.css">
        <link type="text/css" rel="stylesheet" href="resources/css/common.css">
        <link type="text/css" rel="stylesheet" href="resources/css/customcss.css">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.min.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead._.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/moment.js"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datetimepicker.css">      
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.mask.js"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/jquery.datetimepicker.css">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.datetimepicker.full.min.js"></script>
        <script type="text/javascript" src="resources/scripts/autoNumeric.js"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font-awesome.min.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font.css">
        <script type="text/javascript" src="resources/scripts/securenumbermask.js"></script>
        <script type="text/javascript" src="resources/scripts/html2canvas.js"></script>
        <script type="text/javascript" src="resources/scripts/jquery.plugin.html2canvas.js"></script>
        <script type="text/javascript" src="resources/scripts/ajax.js"></script>
         <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/jquery-ui-1.8.21.custom.css">
         <script type="text/javascript" src="resources/bootstrap/js/bootbox.min.js"></script>
         <script type="text/javascript" src="resources/scripts/rte.js"></script>
         <link rel="stylesheet" href="resources/bootstrap/css/jquery.scrolling-tabs.css"/>
         <script type="text/javascript" src="resources/bootstrap/js/jquery.scrolling-tabs.js"></script>
		 <script type="text/javascript" src="resources/scripts/tooltipster.bundle.min.js"></script>
         <link rel="stylesheet" href="resources/css/tooltipster.bundle.css"/>
         <link href="resources/scripts/froala_editor/css/froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />
         <link href="resources/scripts/froala_editor/css/froala_style.min.css" rel="stylesheet" type="text/css" />    
         <script type="text/javascript" src="resources/scripts/froala_editor/js/froala_editor.pkgd.min.js"></script>
         <script type="text/javascript" src="resources/scripts/rte.js"></script>
         <script type="text/javascript" src="resources/scripts/iformapi.js"></script>
         <script type="text/javascript" src="resources/scripts/blowfish.js"></script>
         <script>
           
            var useCustomIdAsControlName = <%=useCustomIdAsControlName%>;
            var pid = "<%=pid%>";
            var wid = "<%=wid%>";
            var tid = "<%=tid%>";
            var dateFormat = "<%=dateFormat%>";
            var processName = "<%=processName%>";
            var activityName = "<%=activityName%>";
            var fid = "<%=IFormUtility.getIFormUID(request)%>";
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
            var mobileMode = "<%=mobileMode%>";
            var subTaskId = "<%=subTaskId%>";
            var taskName = "<%=taskName%>";
            var globalDateFormat="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat()%>";
            var globalDateSeparator="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator()%>";
            var formName = "<%=objViewer.getM_objFormDef().getM_strFormAlias()%>";
            var disableFieldFontColor = "<%=disableFieldFontColor%>";
            var iformLocale="<%=lbls.getString("Path")%>";
            var isEditableComboOnLoad = "<%=isEditableComboOnLoad%>";
            var isGridBatchingEnabled = "<%=isGridBatchingEnabled%>";
            
            
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
            }
        </script>  
         <style>
                    <%= objViewer.getM_objFormDef().getRenderCSS()%>		
			html,body{
                                margin:0;
                                padding:0;
                                height:100%;
                                width:100;
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
                       #oforms_iform{
                           margin: 0 auto;
                           padding:0px 0px 50px 0px;
                       }
                       .bootbox.modal {
                           z-index: 9999 !important;
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
                       <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objSectionFormStyle().isM_bRemoveMargins()){%>
                        .iform-table .radioTwo label:after{
                            top: 3px !important;
                            left: 3px !important;
                        }
                        .iform-table .radioOne label:after{
                            top: 1px !important;
                            left: 1px !important;
                        }
                        <%}%>
						.fr-top{
                            border-top:0 !important;
                        }
        </style>
    </head>
    <body onload="doInit('subForm','<%=buttonId%>');" onkeydown="bodykeyDown(event);">
         <script>
            CreateIndicator("application");
        </script>
         <div id="oforms_iform" style="padding-top:10px;">
           <%=objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel)%>
         </div>
         <div id="subformbtndiv">
             <button id="SubFormDone" onclick="subformDone('<%=buttonId%>');" type="button" class="btn btn-primary btn-sm" style="border-radius: 3px;"  data-dismiss="modal">DONE</button>
         </div>
         <div class="modal"  id="searchModal" role="dialog" data-backdrop="static" style="z-index:2001;">
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
                        <button style="width:70px;" type="button" onclick="setSelectedRow();" data-dismiss="modal" class=" btn btn-success btn-sm "> <%= lbls.getString("OK")%></button> 
                        <button style="width:70px;" type="button" class=" btn btn-danger btn-default btn-sm" onclick="disablePrevious()" data-dismiss="modal"><span class="glyphicon "></span> <%= lbls.getString("CANCEL")%></button>
                    </div>
                </div>
            </div>
        </div>
                    
        <div class="modal"  id="listViewModal" role="dialog" data-backdrop="static"  style="z-index:2000">
            <div id="iFrameListViewModal" class="modal-dialog modal-lg modal-md">

            </div>
            <input id="table_id" style="display: none">
            <input id="rowCount" style="display: none">
        </div>
                    <div class="modal" id="advancedListViewModal" role="dialog" data-backdrop="static">
                        <div id="iFrameAdvancedListViewModal" class="modal-dialog modal-lg">
                            
                        </div>
                        <input id="advancedListview_id" style="display: none">
                        <input id="advancedListviewRowCount" style="display: none">
                    </div>
                    <div id="fade" class="black_overlay"/>
                    <button type="button" style="display:none" onclick="saveForm(1)"/>
<!--                    <div id="pnlDialog" title="Alert" style="padding-top:10px;display: none;">                            
                        <br/>
                        <img src ="./resources/images/warning.png" style="margin:0 7px 20px 0;width:32px;height: 32px;"/>
                        <h:graphicImage id="dlgIcon" library="images" name="warning.png" style="margin:0 7px 20px 0;width:32px;height: 32px;" />
                        <div id="dlgContent" style="float:right;" layout="block" >
                        </div>                     
                    </div>-->

              
            <script>
                $("#advancedListViewModal").on("hidden.bs.modal", function () {
                    clearAdvancedListviewMap();
                    removeAdvancedListviewrowToModify();
                });
            </script>        
    </body>
</html>
<%}%>
<script>
if(window.opener == null)
{
window.location.href= '/iforms/error/nofound.jsp';
}
</script>