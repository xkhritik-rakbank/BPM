<%-- 
    Document   : sessionInvalid
    Created on : Feb 25, 2020, 4:41:20 PM
    Author     : poornima.saini
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>  
<%@page import="java.util.ResourceBundle"%>
<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="/iforms/resources/bootstrap/css/bootstrap.css"/>
        <link rel="stylesheet" href="/iforms/resources/bootstrap/css/bootstrap.min.css"/>
        <title>Session Invalid Page</title>
        <style>
            .labelbluebold {
                font: bold 11pt Arial ;
                color: #0072c6;
             }
        </style>
        <script>
            function redirectToApplication(){
                var url=window.location.toString().split('/')[0]+"//"+window.location.toString().split('/')[2]+"/"+window.location.toString().split('/')[3];
                window.location.href=url;
            }
        </script>
    </head>
    <body>
        <div align="center" style="padding-top: 10.5%;">
            <table>
               <tbody>
                   <tr>
                       <td>
                          <h4 class="labelbluebold"><font color="red"><%= lbls.getString("SESSION_EXPIRED")%></font></h4>
                       </td>
                   </tr>
                   <tr>
                        <td>
                          <h5 style="text-align:center;"><b><a onclick="redirectToApplication()" style="cursor: pointer;text-decoration: underline;"><%= lbls.getString("CLICK_HERE")%></a>&nbsp</b><%= lbls.getString("LOGIN_AGAIN")%></h5>
                        </td>
                   </tr>
                </tbody>
            </table>
         </div>
    </body>
</html>
