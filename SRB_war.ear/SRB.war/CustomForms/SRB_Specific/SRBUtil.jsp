<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="adminclient.OSASecurity" %>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
	WriteLog("Inside SRBUtil.jsp");
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );    
	String reqType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	String returnValues = "";

	if (reqType.equals("getServerDateTime"))
		returnValues = getServerDateTime ();
	
	if (reqType.equals("EncryptData"))
	{
		try
		{
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Value"), 1000, true) );    
			String str = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");

			//String encoded = DatatypeConverter.printBase64Binary(str.getBytes());
			String encoded = encrypt(str);
			WriteLog("encoded value is: " + encoded);
			returnValues = encoded;
		}
		catch (Exception e)
		{
			returnValues = "";
		}
	}
	if (reqType.equals("DecryptData"))
	{
		try
		{
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Value"), 1000, true) );    
			String str = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			//String decoded = new String(DatatypeConverter.parseBase64Binary(str));
			String decoded = decrypt(str);
			WriteLog("decoded value is \t" + decoded);
			returnValues = decoded;
		}
		catch (Exception e)
		{
			returnValues = "";
		}
	}
	
	out.clear();
	out.print(returnValues);
	
%>

<%!
	String getServerDateTime ()
	{
		 Date date = new Date();
		 DateFormat dateFormatScanDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");		   
		 String tempScanDate = dateFormatScanDateTime.format(date);
		 
		 return tempScanDate;
	}
	
	private static final char[] HEX = { 
    '0', '1', '2', '3', '4', '5', '6', '7', 
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	public static String encrypt(String text) throws Exception
	{
		byte[] byteArray = OSASecurity.encode(text.getBytes("UTF-8"));
		StringBuffer hexBuffer = new StringBuffer(byteArray.length * 2);
		for (int i = 0; i < byteArray.length; ++i)
		  for (int j = 1; j >= 0; --j)
			hexBuffer.append(HEX[(byteArray[i] >> j * 4 & 0xF)]);
		return hexBuffer.toString();
	}
	private String decrypt(String pass)
	{
		int len = pass.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(pass.charAt(i), 16) << 4)
					+ Character.digit(pass.charAt(i+1), 16));
		}
		String password=OSASecurity.decode(data,"UTF-8");
		return password;
	}
%>