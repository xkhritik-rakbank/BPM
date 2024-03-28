<%-- 
    Document   : redirector
    Created on : Feb 2, 2020, 11:11:34 PM
    Author     : mohit.sharma
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="java.net.URLEncoder"%>
<%
   session.invalidate();
   String url = "components/viewer/portal/initializePortal.jsp";
   if(request.getParameter("QueryString") != null){
    String QueryString = URLEncoder.encode(request.getParameter("QueryString"),"UTF-8").replace("+","%20");
    if(QueryString!=null)
        url=url+"?QueryString="+QueryString;
   }
   if(request.getParameter("ExtendSession") != null){
     String ExtendSession= URLEncoder.encode(request.getParameter("ExtendSession"),"UTF-8").replace("+","%20");
     if(ExtendSession!=null)
        url=url+"?ExtendSession="+ExtendSession; 
     if("Y".equalsIgnoreCase(ExtendSession) && request.getParameter("UserDBId") != null && request.getParameter("ExtendUserName") != null)
     {
         String UserDBId=URLEncoder.encode(request.getParameter("UserDBId"),"UTF-8").replace("+","%20");
         String ExtendUserName=URLEncoder.encode(request.getParameter("ExtendUserName"),"UTF-8").replace("+","%20");
         if(UserDBId!=null && ExtendUserName!=null)
          url=url+"&UserDBId="+UserDBId+"&ExtendUserName="+ExtendUserName; 
		if(request.getParameter("PTId") != null)
         {
             String PTId= URLEncoder.encode(request.getParameter("PTId"),"UTF-8").replace("+","%20");
            if(PTId!=null)
             url=url+"&PTId="+PTId;
            if("Y".equalsIgnoreCase(PTId) && request.getParameter("TranscationId") != null)
            {
               String TranscationId=URLEncoder.encode(request.getParameter("TranscationId"),"UTF-8").replace("+","%20"); 
               if(TranscationId != null)
               {
                   url=url+"&TranscationId="+TranscationId;
               }
              }
            
         }
     }
   }
   response.sendRedirect(IFormUtility.removeSpecial(url));
  %>