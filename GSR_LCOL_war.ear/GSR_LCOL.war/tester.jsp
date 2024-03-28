<%@page import="java.io.Reader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body onload="submitForm();">
<form name="iform" id="iform" action="\ProcessSpecific\components\viewer\viewform.jsp" method="post" target="_self">
<script>
function submitForm()
{
var attributeFrom = window.document.forms["iform"];
attributeFrom.submit();
}
</script>

<%
    request.setCharacterEncoding("UTF-8");
    String value = "";
try
        {
            Reader reader1 = new InputStreamReader(new FileInputStream("D:\\NGForm\\attrdata.xml"), "utf-8");
            BufferedReader reader = new BufferedReader(reader1);
            StringBuilder stringBuilder = new StringBuilder();
            String line = null;
            String ls = System.getProperty("line.separator");
            while ((line = reader.readLine()) != null) {
                    stringBuilder.append(line);
                    stringBuilder.append(ls);
            }                   
            stringBuilder.deleteCharAt(stringBuilder.length() - 1);
            reader.close();            
            
            value=URLEncoder.encode(stringBuilder.toString(),"UTF-8");
    }
        catch(Exception ex){
            
        }
    
    %>

<input type="hidden" name="processInstanceId" id="processInstanceId" value="processInstanceId"/>
<input type="hidden" name="workItemId" id="workItemId" value="1"/>
<input type="hidden" name="pid" id="pid" value="processInstanceId"/>
<input type="hidden" name="wid" id="wid" value="1"/>
<input type="hidden" name="AttributeData" id="AttributeData" value="<%= value %>"/>
<input type="hidden" name="DateFormat" id="DateFormat" value="dd/MM/yyyy"/>
<input type="hidden" name="ProcessDataDir" id="ProcessDataDir" value="D://NGForm//procdata.xml"/>
<input type="hidden" name="FormDir" id="FormDir" value="D://NGForm//Lead_V2.xml"/>
<input type="hidden" name="ReadOnly" id="ReadOnly" value="N"/>
<input type="hidden" name="generaldata" id="generaldata" value="<GeneralData></GeneralData>"/>
<input type="hidden" name="fid" id="fid" value="Form"/>
<input type="hidden" name="CabinetName" id="CabinetName" value="dev"/>
<input type="hidden" name="EngineName" id="EngineName" value="dev"/>
<input type="hidden" name="mobileMode" id="mobileMode" value=""/>
<input type="hidden" name="additionalParams" id="additionalParams" value="<AdditionalParams></AdditionalParams>"/>
<input type="hidden" name="FromApplication" id="FromApplication" value="pms"/>
</form>
</body>
</html>