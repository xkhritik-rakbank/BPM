<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : picklistview
    Created on : Dec 17, 2015, 12:54:26 PM
    Author     : nancy.goyal
 * 11/03/2018           Aman Khan               Bug 75909 - Allow null, Formats, Column Total & Tool tip features are not available in column of Table
 * 27/03/2018           Aman Khan               Bug 76719 - EAP6.4+SQL: Theme color is not getting applied to date picker icon inside tabel
 * 05/04/2018           Aman Khan               Bug 76881 - Getting some database error in list view if enter integer,float,Long value more then 32767
 * 20/04/2018           Aman Khan               Bug 77176 - unable to Add row in Listview Control ,Complete formviewer screen hanged .
 * 30/04/2018           Gaurav Sharma           Bug 77363 - For Listview and Table controls combo controls list not shown properly
 * 31/10/2018           Gaurav Sharma           Bug 81107 - calender not visible properly in Grid
 * 02/11/2018           Gaurav Sharma           Bug 81188 - Datepicker onchange not working in listview
 * 26/11/2018           Abhishek Chaudhary      Bug 80935 - Arabic:-Under Listview control Add and Save changes button position should be shown properly and should be in arabic .
 * 21/02/2019           Gaurav                  Bug 83237 - mandatory validation not working while adding row in listview
 * 03/04/2019           Gaurav			Bug 83970 - done click not working in mandatory checkbox case.
 * 22/04/2019           Gaurav                  Bug 84293 - Need configuration to hide prev next button on listview overlay
 * 28/05/2019           Abhishek                Bug 84964 - Custom alert on cross icon of grid 
 * 03/06/2019           Abhishek                Bug 85050 - Close button is not coming at the end of overlay
--%>

<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.db.DatabaseUtil"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="com.newgen.iforms.EControlOption"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WorkdeskAttribute"%>
<%@page import="com.newgen.mvcbeans.model.WiAttribHashMap"%>
<%@page import="com.newgen.iforms.ETableModal"%>
<%@page import="com.newgen.iforms.designer.ColumnInfo"%>
<%@page import="com.newgen.iforms.controls.ETableControl"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.controls.EFrameControl"%>
<%@page import="com.newgen.iforms.IControl"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
Locale omnilocale = null;
try {
        if (session != null && session.getAttribute("Omniapp_Locale") != null) {
            String omniappLocale = String.valueOf(session.getAttribute("Omniapp_Locale"));
            if (omniappLocale.split("_").length > 1) {
                String localeStr = omniappLocale.split("_")[0];
                String countryStr = omniappLocale.split("_")[omniappLocale.split("_").length - 1];
                omnilocale = new Locale(localeStr, countryStr);
            } else if (omniappLocale.split("-").length > 1) {
                String localeStr = omniappLocale.split("-")[0];
                String countryStr = omniappLocale.split("-")[omniappLocale.split("-").length - 1];
                omnilocale = new Locale(localeStr, countryStr.toUpperCase());
            } else {
                omnilocale = new Locale(omniappLocale);
            }
            lbls = ResourceBundle.getBundle("ifgen", omnilocale);
        }
    } catch (Exception ex) {
        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception omniapp locale.." + ex.getMessage(), ex);
    }
%>


        <script>
            var $input = $('.form-input');
    
        var $textarea = $('.form-textarea');
        var $combo = $('select');
        if($input.attr("datatype")=="date"){
            $(this).focus({
                
                })
        }
        $input.focusout(function() {
            if($(this).val().length > 0) {
                $(this).addClass('input-focus');
                $(this).next('.form-label').addClass('input-focus-label');
            }
            else {
                $(this).removeClass('input-focus');
                $(this).next('.form-label').removeClass('input-focus-label');
            
            }
        });
    
    
        $textarea.focusout(function() {
            if($(this).val().length > 0) {
                $(this).addClass('textarea-focus');
                $(this).next('.form-label').addClass('textarea-focus-label');
            }
            else {
                $(this).removeClass('textarea-focus');
                $(this).next('.form-label').removeClass('textarea-focus-label');
            
            }
        });
        $("#listViewModalContent").draggable({
                handle: ".modal-header"
            });
        </script>
        <%
    IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
    request.setCharacterEncoding("UTF-8");
    //IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
    String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
    String rid_listviewmodal = IFormUtility.generateTokens(request,request.getRequestURI());
    response.setHeader("WD_RID", IFormUtility.removeSpecial(rid_listviewmodal));
    String controlId = IFormUtility.escapeHtml4(request.getParameter("controlId"));
    String from = IFormUtility.escapeHtml4(request.getParameter("from"));
    String tableData = request.getParameter("tabledata");
    String modifyFlag = IFormUtility.escapeHtml4(request.getParameter("modifyFlag"));
    String deleteFlag = IFormUtility.escapeHtml4(request.getParameter("deleteFlag"));
    String deviceType=request.getHeader("User-Agent");
    deviceType=deviceType.toLowerCase();
    Boolean isMobile=false;
    List<List<String>> dbResult = null;
    String dateFormat =  formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
    String dateSeparator = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();
     String dateStyleTime="";
     String dateStyle="";
     if(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateStyle().equalsIgnoreCase("1")){
        dateStyleTime="mydatetimepicker";
        dateStyle="mydatepicker";
    }
    else{
        dateStyleTime="myjquerydatetimepicker";
        dateStyle="myjquerydatepicker";
    }
     
    EControl objControl = new EControl();
    String displayModify="display:none;";
    String displayAdd="";
    objControl = (EControl) formviewer.getM_objFormDef().getFormField(controlId);
    if(objControl==null){
        objControl = (EControl) formviewer.getM_objFormDef().getSubFormField(((ERootControl)formviewer.getM_objFormDef().getM_objRootControl()).getBtnRef(), controlId);
    }
    ETableControl objTable = (ETableControl) objControl;
    List<ColumnInfo> lsCols = objTable.getObj_eTableModal().getM_arrColumnInfo();
    JSONParser parser = new JSONParser();
    JSONObject json=new JSONObject();
    String colIndex = IFormUtility.escapeHtml4(request.getParameter("colIndex"));
    String rowIndex = IFormUtility.escapeHtml4(request.getParameter("rowIndex"));
    List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
    if("yes".equalsIgnoreCase(modifyFlag))
    {   
        displayAdd="display:none;";
        displayModify="";
        if(request.getParameter("dataValue")!=null)
            json = (JSONObject) parser.parse(request.getParameter("dataValue"));
        
    }
    if(deviceType.contains("mobile") || deviceType.contains("android") || deviceType.contains("ipod") || deviceType.contains("webos") || deviceType.contains("iphone") || deviceType.contains("ipad") || deviceType.contains("blackberry") || deviceType.contains("iemobile") || deviceType.contains("opera mini")){
       
        isMobile=true;
    }
    String displayTopButtons = "";
    Boolean enormousNames = false;
    if(lbls.getString("Path").equals("de/") || lbls.getString("Path").equals("nl/") || lbls.getString("Path").equals("pt/")){
        enormousNames = true;
    }
    if((!"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment()))||isMobile == true || enormousNames){
        displayTopButtons = "display:none;";
    }
    String displayDuplicateButton = "";
    String displaySaveChanges = "";
    if("false".equals(objTable.getM_objControlStyle().getM_strDuplicateRow()))
    {
       displayDuplicateButton = "display:none";
       //displaySaveChanges = "margin-left:70px;";
    }
    ArrayList<String> classList=new ArrayList< String>();
    if( objControl.getM_strControlLabel().length() < 8 ){
        classList.add("col-md-2 col-sm-2 col-xs-2");
        classList.add("col-md-8 col-sm-8 col-xs-8");
        classList.add("col-md-2 col-sm-2 col-xs-2");
    }
    else{
        classList.add("col-md-4 col-sm-4 col-xs-4");
        classList.add("col-md-7 col-sm-7 col-xs-7");
        classList.add("col-md-1 col-sm-1 col-xs-1");
    }
    if("".equals(displayModify)){
        if("".equals(displayDuplicateButton)){
            if( objControl.getM_strControlLabel().length() < 8 ){
                classList.set(0,"col-md-2 col-sm-2 col-xs-2");
                classList.set(1,"col-md-8 col-sm-8 col-xs-8");
                classList.set(2,"col-md-2 col-sm-2 col-xs-2");
            }
            else{
                classList.add("col-md-4 col-sm-4 col-xs-4");
                classList.add("col-md-7 col-sm-7 col-xs-7");
                classList.add("col-md-1 col-sm-1 col-xs-1");
            }
        }
        else{
            classList.set(0,"col-md-4 col-sm-4 col-xs-4");
            classList.set(1,"col-md-4 col-sm-4 col-xs-4");
            classList.set(2,"col-md-4 col-sm-4 col-xs-4");
        }
    }
        %>
        <div id="listViewModalContent" class="modal-content">
            <div class="modal-header" style="padding-bottom: 9px;">
                        <div style="width:100%;">
                            <!--<%if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>
                            <button  style="margin-top:4px;" type="button" id="closeButton" class="close" onclick="disablePrevious();removerowToModify();" data-dismiss="modal">
                                <span class="glyphicon glyphicon-remove"></span>
                            </button>
                            <%}%>-->
                            <div style="height:24px">
                            <%if("".equals(displayTopButtons)){%>
                                <span class="<%= classList.get(0)%> pull-<%=lbls.getString("LEFT")%>" style="padding:0px">
                            <%}else{%>
                                <span class="col-md-11 col-sm-11 col-xs-11" style="padding:0px">
                            <%}%>
                                <%
                                    boolean showPrevNextButtons=true;
                                    if("Y".equals(objTable.getM_objControlStyle().getM_strHideListviewPrevNextBtn()))
                                        showPrevNextButtons=false;
                                %>
                                <button type="button" onclick="showNextPreviousResultTable('<%= controlId%>','previous')" id="tablelistPrevious" style="<%if(!showPrevNextButtons){%>display:none;<%}%>border-top-right-radius:4px;border:1px solid #ccc;outline:none;padding:0px;" class="pull-<%=lbls.getString("LEFT")%> nextPrevButton" disabled="">
                                 <span>
                                        <img src="./resources/<%= lbls.getString("Path")%>images/PaginationLeftEnabled.png"/>
                                    </span>
                                </button>
                                <button type="button" onclick="showNextPreviousResultTable('<%= controlId%>','next');" id="tablelistNext" style="<%if(!showPrevNextButtons){%>display:none;<%}%>border-top-right-radius:4px;border:1px solid #ccc;outline:none;padding:0px;" class="pull-<%=lbls.getString("LEFT")%> nextPrevButton" disabled="">
                                <span>
                                        <img src="./resources/<%= lbls.getString("Path")%>images/PaginationRightEnabled.png"/>
                                    </span>
                                </button>
                                <% if(isMobile==true){%>
                                <label title="<%=objControl.getM_strControlLabel()%>" class="modal-title pull-<%=lbls.getString("LEFT")%> listViewHeader labelstyledesigner" style="word-break: break-word;font-size: 16px;padding-<%=lbls.getString("LEFT")%>: 10px;display:inline-block;text-overflow:ellipsis;white-space:nowrap;text-align:<%=lbls.getString("LEFT")%>;margin-top:5px;"><%=objControl.getM_strControlLabel()%></label>  
                                <%}else{%>
                                <% if(!objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>
                                <div class="container-fluid" style="text-align:center;padding:0px;">
                                <label title="<%=objControl.getM_strControlLabel()%>" class="modal-title listViewHeader labelstyledesigner" style="word-break: break-word;font-size: 16px;padding-<%=lbls.getString("LEFT")%>: 10px;display:inline-block;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;text-align:center;"><%=objControl.getM_strControlLabel()%></label>
                                </div>
                                <%}else{%>
                                <label title="<%=objControl.getM_strControlLabel()%>" class="modal-title pull-<%=lbls.getString("LEFT")%> listViewHeader labelstyledesigner" style="word-break: break-word;font-size: 16px;padding-<%=lbls.getString("LEFT")%>: 10px;display:inline-block;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;text-align:<%=lbls.getString("LEFT")%>;"><%=objControl.getM_strControlLabel()%></label>
                                <%}}%>
                                </span>
                                <%if("".equals(displayTopButtons)){%>
                                <span class="<%= classList.get(1)%> pull-<%=lbls.getString("LEFT")%>" style="padding:0px">
                                <span class="col-md-12 col-sm-12 col-xs-12" style="text-align:center;padding:0px;<%=displayModify%>">
                                   <%
                                        if("false".equals(objTable.getM_objControlStyle().getM_strDuplicateRow()))
                                        {%>
                                                <%if("0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){%>
                                            <button style="<%=displayTopButtons%><%=displayModify%>;padding:0px 3px;min-width:100px;min-height:26px;width:100%" type="button" id="savechanges_<%=controlId%>" onclick="modifyRowTableData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle"><%=lbls.getString("SAVE_CHANGES")%></button> 
                                                <%}%>
                                        <%}else{%>
                                        
                                            <span class="col-md-6 col-sm-6 col-xs-6"  style="padding:0px">
                                                <%if("0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){%>
                                            <button style="<%=displayTopButtons%><%=displayModify%>;padding:0px 3px;min-width:100px;min-height:26px;width:100%" type="button" id="savechanges_<%=controlId%>" onclick="modifyRowTableData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle"><%=lbls.getString("SAVE_CHANGES")%></button> 
                                                <%}%>
                                            </span>

                                            <span class="col-md-6 col-sm-6 col-xs-6"  style="padding:0px">
                                                <%if("0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){%>
                                            <button style="<%=displayTopButtons%><%=displayModify%><%=displayDuplicateButton%>;padding:0px 3px;min-width:100px;min-height:26px;width:91%" type="button" id="copyrow_<%=controlId%>" onclick="copyRowData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle"><%=lbls.getString("COPY_ROW")%></button> 
                                            <%}%>
                                            </span>
                                    <%}%>
                                    
<!--                                    <span class="col-md-3 col-sm-3 col-xs-3"  style="padding:0px;"></span>-->
                                </span>
                                <span class="col-md-6 col-sm-6 col-xs-6" style="padding:0px;padding-<%=lbls.getString("LEFT")%>: 5px;<%=displayAdd%>">
                                    <%if("0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){%>
                                <button style="width:100%;;padding:0px 3px;min-width:100px;min-height:26px;<%=displayTopButtons%><%=displayAdd%>" type="button" onclick="addRowToTable('<%= controlId%>',true);" id="addrowandnext_<%= controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle"><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button>  
                                <%}%>
                                </span>
                                <span class="col-md-6 col-sm-6 col-xs-6" style="padding:0px;padding-<%=lbls.getString("LEFT")%>: 5px;<%=displayAdd%>">
                                  <%if("0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){%>
                                    <button style="width:100%;min-width:100px;<%=displayTopButtons%><%=displayAdd%>;padding:0px 3px;min-height:26px;" type="button" onclick="addRowToTable('<%= controlId%>');" id="addrow_<%= controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle"><%= lbls.getString("ADD_AND_CLOSE")%></button>
                                    <%}%>
                                </span>
                                
                                </span>
                                <%}%>
                                 <%if("".equals(displayTopButtons)){%>
                                    <span class="<%= classList.get(2)%>" style="padding:0px 3px;float:<%=lbls.getString("RIGHT")%>;text-align:<%=lbls.getString("RIGHT")%>;">   
                                 <%}else{%>
                                    <span class="col-md-1 col-sm-1 col-xs-1" style="padding:0px 3px;float:<%=lbls.getString("RIGHT")%>;text-align:<%=lbls.getString("RIGHT")%>;">
                                <%}%>
                                    <button style="<% if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>margin-top:4px;<% }else{%>margin-top:0px;<%}%>float:unset;" type="button" id="closeButton" class="close" onclick="listViewOverlay('<%= controlId%>');">
                                    
                                    <span>
                                        <img height="15px" width="15px" src="./resources/images/normal-cross.png"/>
                                    </span>
                                    </button>
                                </span>
                            </div>
                        </div>
                </div>
            <div  class="modal-body" style="height:auto;width:100%;">

                        <div class="">
        <div class="container" style="padding: 0px;width: 100%;">
            <div id="fetchedData" >
<!--                <table class="table" id="myTable">
                    <tbody>
             
    <%
    
        int rowId = Integer.parseInt(IFormUtility.escapeHtml4(request.getParameter("RowId")));
        int i = 0;
        int counter = 0;
        int id1 = 0;
        String id_control;
       // formviewer.getM_objFormDef().renderSectionStyleCSS();
        ERootControl rootcontrol = (ERootControl) formviewer.getM_objFormDef().getM_objRootControl();
         EFrameControl frameObj = null;
           IControl eframe=(IControl)objTable.getM_arrColumFrameLayoutList().get(0);
                  ((EControl)eframe).setM_bModal(true);
                   frameObj = (EFrameControl) eframe;
                   frameObj.setObj_tableControl(objTable);
                   if(rowIndex!=null)
                    frameObj.setRowIndex(rowIndex);
                   //frameObj.parseControlElement(frame);
           
           IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
           objIFormSession.setOpenedListviewDataClassName(objControl.getM_strDataClassName());//Bug 82812
         //frameObj.getRenderBlock(formviewer.getM_objFormDef(), objIFormSession, null);
        %>    
                    </tbody>
                </table>-->
            </div>
        </div>
                    
                     </div>
                     
    
                     <%= frameObj.getRenderBlock(formviewer.getM_objFormDef(), objIFormSession, null)%> 
                     <%
                         if((!"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment()))||isMobile==true || enormousNames){
                                 
                         String alignment="";
                        if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("1"))
                         alignment="right";
                      if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("2"))
                      {
                        alignment ="left"; 
                      }
                      if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("3")||isMobile==true || enormousNames)
                      {
                        alignment ="center"; 
                      }
                     %>
                     <%if(enormousNames){%>
                    <div class="modal-footer table-responsive container-fluid" style="text-align:<%=alignment%>;padding:10px;">
                        <button style="<%=displayAdd%>" type="button" onclick="addRowToTable('<%= controlId%>');" id="addrow_<%=controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("ADD_AND_CLOSE")%></button> 
                        <button style="<%=displayModify%>" type="button" id="savechanges_<%=controlId%>" onclick="modifyRowTableData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_CHANGES")%></button> 
                        <button style="<%=displayModify%>;<%=displayDuplicateButton%>" type="button" id="copyrow_<%=controlId%>" onclick="copyRowData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("COPY_ROW")%></button>
                        <button style="<%=displayAdd%>" type="button" onclick="addRowToTable('<%= controlId%>',true);" id="addrowandnext_<%=controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button>     
                    </div>    
                    <%} else if ((!"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment()))||isMobile) {%>
                    <div class="modal-footer table-responsive container-fluid" style="text-align:<%=alignment%>;padding:10px;">
                        <button style="padding-left:0px;padding-right:0px;width:138px;<%=displayAdd%>" type="button" onclick="addRowToTable('<%= controlId%>');" id="addrow_<%=controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("ADD_AND_CLOSE")%></button> 
                        <button style="padding-left:0px;padding-right:0px;width:100px;<%=displayModify%>" type="button" id="savechanges_<%=controlId%>" onclick="modifyRowTableData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_CHANGES")%></button> 
                        <button style="padding-left:0px;padding-right:0px;width:100px;<%=displayModify%>;<%=displayDuplicateButton%>" type="button" id="copyrow_<%=controlId%>" onclick="copyRowData('<%= controlId%>');" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("COPY_ROW")%></button>
                        <button style="padding-left:0px;padding-right:0px;width:138px;<%=displayAdd%>" type="button" onclick="addRowToTable('<%= controlId%>',true);" id="addrowandnext_<%=controlId%>" data-dismiss="modal" class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button>     
                    </div>  
                        <%} }%>
                    </div>
                     
<!--                    <div class="modal-footer table-responsive container-fluid">
                        <button type="button" <%=displayAdd%> onclick="addRowToTable();" data-dismiss="modal" class=" btn btn-success btn-sm ">ADD</button> 
                        <button type="button" <%=displayModify%> onclick="modifyRowTableData('<%= controlId%>');" data-dismiss="modal" class=" btn btn-success btn-sm ">Save Changes</button> 
                        <button type="button" class=" btn btn-danger btn-default btn-sm" onclick="removerowToModify();" data-dismiss="modal"><span class="glyphicon "></span>CANCEL</button>
                        <button type="button" onclick="showNextPreviousResultTable('<%= controlId%>','previous')" id="tablelistPrevious" class=" btn btn-primary btn-sm " >PREVIOUS</button>
                        <button type="button" onclick="showNextPreviousResultTable('<%= controlId%>','next');" id="tablelistNext" class="btn btn-primary pull-right btn-sm ">NEXT</button>
                    </div>-->
                </div>

