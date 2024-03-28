<%-- 
    Document   : appTask
    Created on : Oct 20, 2019, 11:11:34 PM
    Author     : mohit.sharma
--%>

<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%
   request.setCharacterEncoding("UTF-8");
   String operation = request.getParameter("oper");
   String rid_appTask = IFormUtility.generateTokens(request,request.getRequestURI());
   response.setHeader("WD_RID", IFormUtility.removeSpecial(rid_appTask));
   AppTasks.performOperation(operation,request,response);
%>