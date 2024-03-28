<%-- 
    Document   : set
    Created on : May 2, 2014, 12:35:56 PM
    Author     : dinkar.kad
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/general/header.process" %>  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
        <% 
        String CheckfileExsts = request.getParameter("CheckFileExists");
        if(!(CheckfileExsts != null && CheckfileExsts.equalsIgnoreCase("Y")))
        {  %>
            <body>
            <script language=javascript src="<%=sContextPath%>/webtop/scripts/client.js"></script>
            <% if(!wfsession.getM_strMultiTenancyVar().equals("")){ %>
            <script language=javascript src="<%=customContext%>/webtop/scripts/client<%=wfsession.getM_strMultiTenancyVar()%>.js"></script>
            <% }  %>
            <h2>customworklist code goes here...</h2>
            </body>
     <% } %>
</html>
