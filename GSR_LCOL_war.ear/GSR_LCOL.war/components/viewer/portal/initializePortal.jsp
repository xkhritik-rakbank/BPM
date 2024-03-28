    <%@page import="com.newgen.iforms.xmlapi.IFormCallBroker"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
    <%@page import="com.newgen.iforms.webapp.AppConfiguration"%>
    <%@page import="java.io.File"%>
    <%-- 
        Document   : initializePortal
        Created on : Jul 30, 2019, 3:27:30 PM
        Author     : g.sharma
    --%>

    <%@page import="com.newgen.iforms.session.IFormSession"%>
    <%@page import="com.newgen.iforms.base.IFormCabinetList"%>
    <%@page import="com.newgen.iforms.util.CommonUtility"%>
    <%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
    <%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@page import="com.newgen.iforms.util.IFormUtility"%>
    <%@page import="java.net.URLEncoder"%>
    <!DOCTYPE html>
    <%
    String sessionId="";
    if(session.getAttribute("sessionId")!=null)
        sessionId=session.getAttribute("sessionId").toString();
    AppConfiguration appConf = new AppConfiguration();
    String buildPath = application.getRealPath("/");
    IFormINIConfiguration.loadConfigurationFile(buildPath);
    appConf.setWebAppLocation(buildPath);
    appConf.loadConfigurationFile();
    IFormCallBroker.setWebAppLocation(buildPath);
    IFormCallBroker.loadConfigurationFile();
    session.setAttribute("AppConfObject",appConf);
    session.setAttribute("AppConfigINI", appConf.getM_hINIHashMap());
    String cabinetName = AppTasks.getValueFromINI(IFormConstants.CABINET_NAME, request); 
    String callFrom = AppTasks.getValueFromINI(IFormConstants.CALL_FROM, request); 
    String formBufferPath="";
    String isNew = IFormUtility.escapeHtml4(request.getParameter("new"));
    String filterVal = IFormUtility.escapeHtml4(request.getParameter("FilterValue"));
    if( filterVal == null ){
        filterVal = "";
    }
    if(session.getAttribute("filterVal")!=null && !session.getAttribute("filterVal").toString().isEmpty())
        filterVal=session.getAttribute("filterVal").toString();
    if(session.getAttribute("NextRoute")==null || "Y".equals(request.getParameter("Default")))
        formBufferPath=AppTasks.getFormPath(request,appConf.getM_hINIHashMap().get("DefaultForm"),false);  
    String navigationPage=IFormUtility.escapeHtml4((request.getParameter("navigationPage") != null) ? request.getParameter("navigationPage") : ""); 
    if(!navigationPage.isEmpty() && !formBufferPath.isEmpty()){
        formBufferPath=AppTasks.getFormPath(request,navigationPage,false); 
        request.getSession().setAttribute("FormPath",formBufferPath);
    }
    String userName=AppTasks.getValueFromINI(IFormConstants.UserName, request);
    String queryString=IFormUtility.escapeHtml4Str((request.getParameter("QueryString") != null) ? URLEncoder.encode(request.getParameter("QueryString"),"UTF-8").replace("+","%20") : ""); 
    String extendSession=IFormUtility.escapeHtml4Str((request.getParameter("ExtendSession") != null) ? URLEncoder.encode(request.getParameter("ExtendSession"),"UTF-8").replace("+","%20") : "");
    String userDBId=IFormUtility.escapeHtml4Str((request.getParameter("UserDBId") != null) ? URLEncoder.encode(request.getParameter("UserDBId"),"UTF-8").replace("+","%20") : "");
    String extendUserIndex=IFormUtility.escapeHtml4Str((request.getParameter("ExtendUserIndex") != null) ? URLEncoder.encode(request.getParameter("ExtendUserIndex"),"UTF-8").replace("+","%20") : "");
    String PTId=IFormUtility.escapeHtml4Str((request.getParameter("PTId") != null) ? URLEncoder.encode(request.getParameter("PTId"),"UTF-8").replace("+","%20") : "");
    String TranscationId=IFormUtility.escapeHtml4Str((request.getParameter("TranscationId") != null) ? URLEncoder.encode(request.getParameter("TranscationId"),"UTF-8").replace("+","%20") : "");
    String redirectUrl = "/" +AppTasks.getValueFromINI("ApplicationName", request) + "/components/viewer/viewform.jsp";   
    if(extendSession != null && !"".equalsIgnoreCase(extendSession) && !"null".equalsIgnoreCase(extendSession) && "Y".equalsIgnoreCase(extendSession)){
        callFrom="NewUser";
    }
    if(callFrom != null && !"".equalsIgnoreCase(callFrom) && !"null".equalsIgnoreCase(callFrom)){
        redirectUrl += "?callFrom="+callFrom;
    }

    %>
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body onload="submitForm();">
        <form name="iform" id="iform" action="<%=redirectUrl%>" method="post" target="_self">
    <script>
    function submitForm()
    {
    var attributeFrom = window.document.forms["iform"];
    attributeFrom.submit();
    }
    </script>
    <input type="hidden" name="processInstanceId" id="processInstanceId" value="Emp001"/>
    <input type="hidden" name="CabinetName" id="CabinetName" value="<%=cabinetName%>"/>
    <input type="hidden" name="workItemId" id="workItemId" value="1"/>
    <input type="hidden" name="pid" id="pid" value="Emp001"/>
    <input type="hidden" name="wid" id="wid" value="1"/>
    <input type="hidden" name="ProcessDefId"  id="ProcessDefId" value=""/>
    <input type="hidden" name="SessionId"  id="SessionId" value="<%=sessionId%>"/>
    <input type="hidden" name="ApplicationName"  id="ApplicationName" value="<%=AppTasks.getValueFromINI("ApplicationName", request)%>"/>
    <input type="hidden" name="AttributeData" id="AttributeData" value=""/>
    <input type="hidden" name="DateFormat" id="DateFormat" value="dd/MM/yyyy"/>
    <input type="hidden" name="ProcessDataDir" id="ProcessDataDir" value=""/>
    <input type="hidden" name="FormDir" id="FormDir" value="<%=formBufferPath%>"/>
    <input type="hidden" name="ReadOnly" id="ReadOnly" value="N"/>
    <input type="hidden" name="generaldata" id="generaldata" value=""/>
    <input type="hidden" name="fid" id="fid" value="Form"/>
    <input type="hidden" name="QueryString" id="QueryString" value="<%=queryString%>"/>
    <input type="hidden" name="ExtendSession" id="ExtendSession" value="<%=extendSession%>"/>
    <input type="hidden" name="UserDBId" id="UserDBId" value="<%=userDBId%>"/>
    <input type="hidden" name="PTId" id="PTId" value="<%=PTId%>"/>
    <input type="hidden" name="TranscationId" id="TranscationId" value="<%=TranscationId%>"/>
    <input type="hidden" name="ExtendUserIndex" id="ExtendUserIndex" value="<%=extendUserIndex%>"/>
    <input type="hidden" name="username" id="username" value="<%=userName%>"/>
    <input type="hidden" name="additionalParams" id="additionalParams" value="<AdditionalParams></AdditionalParams>"/>
    <input type="hidden" name="filterValue" id="filterValue" value="<%=filterVal%>"/>
    <input type="hidden" name="isNew" id="isNew" value="<%=isNew%>"/>
    </form>
    </body>
    </html>
