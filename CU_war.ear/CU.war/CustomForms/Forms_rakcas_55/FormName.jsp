<%--
      WCL_9.0_063     18/04/2011    Sri Prakash     shortcut key for Save (ALT+S) and Done (ALT+I) should work in custom form.
      Bug 28001       26/08/2011    Anushree Jain   Security issue
--%> 
<%@ include file="../header.process" %>
<f:view>    
    <head>
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
        <script>
            if (typeof window.event != 'undefined'){ // IE
                document.onkeydown = function(e) // IE
                {
                    var t=event.srcElement.type;
                    var kc=event.keyCode;
                    if(event.keyCode==83 && event.altKey){
                        window.parent.workdeskOperations('S');
                    }
                    else if(event.keyCode==73 && event.altKey){
                        window.parent.workdeskOperations('I');
                    }
                    else if (kc == 116) {
                        window.event.keyCode = 0;
                        return false;
                    }
                    else
                        return ((kc != 8 ) || ( t == 'text') || (t == 'textarea') || ( t == 'submit') ||  (t == 'password'))
                }
            }
        </script>
     </head>
     <%  
         if(parameterMap != null && parameterMap.size() > 0)
             {
             %>
     <body>
         <%
             /* This is how we can call product API. */
             WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
             String outputXml = WFWorkitem.WMFetchWorkItemAttribute(jtsIP,jtsPort, debugValue, engineName, sessionId, pid,  wid, "", "", "", "", "", "", "", activityId, routeID);
             WFCustomCallBroker.generateLog(customSession.getRouteName(),outputXml);
              /* Ends */
             
             CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
             LinkedHashMap varIdMap = new LinkedHashMap();
             CustomWiAttribHashMap attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
             session = request.getSession(false);
             
             
             /* This is how we can generate logs */
             WFCustomCallBroker.generateLog(customSession.getRouteName(),"Exception/Debug message to be displayed comes here.");
             /* Ends */
              
         %>
        <form name="wdesk" id="wdesk" method="post" >
            <input type="text" name="dateTest" id="wdesk:dateTest" value='<%=((CustomWorkdeskAttribute)attributeMap.get("dateTest")).getAttribValue()%>'/><br/>
            <input type="text" name="dateTest2" id="wdesk:dateTest2" value='<%=((CustomWorkdeskAttribute)attributeMap.get("dateTest2")).getAttribValue()%>'/><br/>
            <input type="text" name="test" id="wdesk:test" value='<%=customSession.getGenRsb().getString("TITLE_DATAENTRY")%>'/><br/>
        </form>
    </body>
    <% } %>
</f:view>
</html>
