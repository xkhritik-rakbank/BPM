<%--1 
    Document   : test
    Created on : Sep 18, 2018, 3:12:40 PM
    Author     : minakshi.sharma
27/05/2019          Gaurav          Bug 84913 - instruction and form data not showing correctly in task for process specific war
--%>

<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
       
    </head>
    <body onload="submitForm();">
        <%
            String pid=request.getParameter("wdesk:ProcessInstanceID");             
            String wid=request.getParameter("wdesk:WorkItemID");
            String tid=request.getParameter("wdesk:taskid");
            String engineName=request.getParameter("wdesk:EngineName");
            String userName=request.getParameter("wdesk:UserName");
            String userIndex=request.getParameter("wdesk:UserIndex");
            String routeId=request.getParameter("wdesk:RouteID");
            String sessionId=request.getParameter("wdesk:SessionID");
            String JTSIP=request.getParameter("wdesk:JTSIP");
            String JTSPort=request.getParameter("wdesk:JTSPort");
            String debugValue=request.getParameter("wdesk:DebugValue");
            String ActivityId=request.getParameter("wdesk:ActivityID");
            String attribData=request.getParameter("wdesk:AttributeData");
            attribData=IFormUtility.encode("UTF-8",attribData);
            String dateFormat=request.getParameter("wdesk:DateFormat");
            String workstepName=request.getParameter("wdesk:WorkStepName");
            String formName=request.getParameter("wdesk:FormName");
            String context=request.getParameter("wdesk:Context");
            String locale=request.getParameter("wdesk:Locale");
            String multiTenancyVar=request.getParameter("wdesk:MultiTenancyVar");
            String appserverName=request.getParameter("wdesk:AppServerName");
            String databaseType=request.getParameter("wdesk:DatabaseType");
            String routeName=request.getParameter("wdesk:RouteName");
            String formDir=request.getParameter("wdesk:FormDir");
            String processDataDir=request.getParameter("wdesk:ProcessDataDir");            
            String clientTimeDiff=request.getParameter("wdesk:ClientTimeDiff");   
            String serverTimeDiff=request.getParameter("wdesk:ServerTimeDiff");   
            String fid=request.getParameter("wdesk:fid");   
            String readOnly=request.getParameter("wdesk:ReadOnly");
            String subtaskid=request.getParameter("wdesk:subtaskid");
            String generaldata=request.getParameter("wdesk:generaldata");
            generaldata=IFormUtility.encode("UTF-8",generaldata);           
            
        %>
        
        <form name="iform" id="iform" action="components\viewer\viewform.jsp" method="post" target="_self">
            <script>
                function submitForm()
                {
                    var attributeFrom = window.document.forms["iform"];
                   // var value=document.getElementById("AttributeData").value;
                   // alert('value-->'+value);
                   // document.getElementById("AttributeData").value='<%=IFormUtility.encode("UTF-8",attribData)%>';    
                    //console.log('Attribute data-->'+document.getElementById("AttributeData").value);
                    //window.location='viewform.jsp';
                    attributeFrom.submit();                 
                   
                }
            
            </script>
            <input type="hidden" name="processInstanceId" id="processInstanceId" value="<%= pid%>"/>            
            <input type="hidden" name="workItemId" id="workItemId" value="<%=wid%>"/>
            <input type="hidden" name="pid" id="pid" value="<%= pid%>"/>
            <input type="hidden" name="wid" id="wid" value="<%=wid%>"/>
            <input type="hidden" name="tid" id="tid" value="<%=tid%>"/>
            <input type="hidden" name="CabinetName" id="CabinetName" value="<%= engineName%>"/>
            <input type="hidden" name="UserName" id="UserName" value="<%=userName%>"/>
            <input type="hidden" name="UserIndex" id="UserIndex" value="<%= userIndex%>"/>
            <input type="hidden" name="ProcessDefId"  id="ProcessDefId" value="<%=routeId%>"/>
            <input type="hidden" name="SessionId" id="SessionId" value="<%=sessionId%>"/>
            <input type="hidden" name="JTSIP" id="JTSIP" value="<%=JTSIP%>"/>
            <input type="hidden" name="JTSPort" id="JTSPort" value="<%=JTSPort%>"/>
            <input type="hidden" name="DebugValue" id="DebugValue" value="<%=debugValue%>"/>
            <input type="hidden" name="ActivityId" id="ActivityId" value="<%=ActivityId%>"/>
            <input type="hidden" name="AttributeData" id="AttributeData" value="<%=attribData%>"/>
            <input type="hidden" name="DateFormat" id="DateFormat" value="<%=dateFormat%>"/>
            <input type="hidden" name="workstepName" id="workstepName" value="<%=workstepName%>"/>
            <input type="hidden" name="context" id="context" value="<%=context%>"/>
            <input type="hidden" name="locale"  id="locale" value="<%=locale%>"/>
            <input type="hidden" name="multitenancyvar" id="multitenancyvar" value="<%=multiTenancyVar%>"/>
            <input type="hidden" name="appservername" id="appservername" value="<%=appserverName%>"/>
            <input type="hidden" name="databaseType" id="databaseType" value="<%=databaseType%>"/>
            <input type="hidden" name="ProcessName"  id="ProcessName" value="<%=routeName%>"/>
            <input type="hidden" name="ProcessDataDir"  id="ProcessDataDir" value="<%=processDataDir%>"/>
            <input type="hidden" name="FormDir"  id="FormDir" value="<%=formDir%>"/>
            <input type="hidden" name="fid"  id="fid" value="<%=fid%>"/>
            <input type="hidden" name="ClientTimeDiff"  id="ClientTimeDiff" value="<%=clientTimeDiff%>"/>
            <input type="hidden" name="ServerTimeDiff"  id="ServerTimeDiff" value="<%=serverTimeDiff%>"/>
            <input type="hidden" name="ReadOnly"  id="ReadOnly" value="<%=readOnly%>"/>
            <input type="hidden" name="subtaskId"  id="subtaskId" value="<%=subtaskid%>"/>
            <input type="hidden" name="generaldata"  id="generaldata" value="<%=generaldata%>"/>            
        </form>
    </body>
</html>


