<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../TF_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String URLDecoderreqType=URLDecoder.decode(request.getParameter("reqType"));
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderreqType, 1000, true) );
			String URLDecoderreqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cifid"), 1000, true) );
			String cifid_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("Integration jsp: cifid_Esapi "+cifid_Esapi);

		String reqType =URLDecoderreqType_Esapi.replace("&amp;","&");	
		//WriteLog("reqType ---- "+reqType);
		String WSNAME="";
		//WriteLog("WSNAME ---- "+WSNAME);		
		String subCategoryCode= "";
		//WriteLog("subCategoryCode ---- "+subCategoryCode);
		String subCategory= "";
		//WriteLog("subCategory for nikita---- "+subCategory);
		String SubCategoryIndex= "";
		//WriteLog("SubCategoryIndex ---- "+SubCategoryIndex);
		String ParentCategoryIndex= "";
		//WriteLog("ParentCategoryIndex ---- "+ParentCategoryIndex);
		String cifid= cifid_Esapi;
		//WriteLog("String cifid---- "+ cifid);
		String returnValues = "";
		String query = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
				
		if (reqType.equals("Load_SubCategory_Table"))
		{
			String URLDecodersubCategory=URLDecoder.decode(request.getParameter("subCategory"));
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecodersubCategory, 1000, true) );
			String URLDecodersubCategory_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			subCategory=URLDecodersubCategory_Esapi.replace("&amp;","&");
			
			String URLDecodersubCategoryCode=URLDecoder.decode(request.getParameter("subCategoryCode"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecodersubCategoryCode, 1000, true) );
			String URLDecodersubCategoryCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			subCategoryCode=URLDecodersubCategoryCode_Esapi.replace("&amp;","&");
			query = "SELECT ParentCategoryIndex,SubCategoryIndex FROM USR_0_TF_SUBCATEGORY with(nolock) WHERE SUBCATEGORYNAME='"+subCategory+"' AND Application_FormCode='"+subCategoryCode+"'";
			//params = "Sub_Category_Name='"+subCategory+"' AND SUB_CATEGORY_CODE='"+subCategoryCode+"'";
		}
		
		
		else if (reqType.equals("Load_FormLayout_Table"))
		{			
	
			String URLDecoderCatIndex=URLDecoder.decode(request.getParameter("CatIndex"));
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderCatIndex, 1000, true) );
			String URLDecoderCatIndex_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
	
			ParentCategoryIndex=URLDecoderCatIndex_Esapi.replace("&amp;","&");
			
			String URLDecoderSubCatIndex=URLDecoder.decode(request.getParameter("SubCatIndex"));
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderSubCatIndex, 1000, true) );
			String URLDecoderSubCatIndex_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			SubCategoryIndex=URLDecoderSubCatIndex_Esapi.replace("&amp;","&");
			
			String URLDecoderWSNAME=URLDecoder.decode(request.getParameter("WSNAME"));
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWSNAME, 1000, true) );
			String URLDecoderWSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			WSNAME=URLDecoderWSNAME_Esapi.replace("&amp;","&");
			query = "SELECT LabelName,ColumnName,IsRepeatable FROM  usr_0_tf_formlayout with(nolock) where CatIndex='"+ParentCategoryIndex+"' AND SubCatIndex='"+SubCategoryIndex+"' AND Ws_Name='"+WSNAME+"' ORDER BY FieldOrder";
			//params = "ONE==1";
		}	
		
		
		
		//sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		
		
		sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
		WriteLog("\nInput XML -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML ---- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		
		int recordcount=0;
		try
		{
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		}
		catch(Exception e)	
		{
		}
		//WriteLog("recordcount -- "+recordcount);
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if (reqType.equals("Load_SubCategory_Table"))
				returnValues = returnValues + objWorkList.getVal("ParentCategoryIndex")  + "~" + objWorkList.getVal("SubCategoryIndex");	
			else if (reqType.equals("Load_FormLayout_Table"))
				returnValues = returnValues + objWorkList.getVal("LabelName")  + "~" + objWorkList.getVal("ColumnName") + "~" + objWorkList.getVal("IsRepeatable") + "~";		
		}	
		//returnValues =  returnValues.substring(0,returnValues.length()-1);
		WriteLog("returnValues -- "+returnValues);
		out.clear();
		out.print(returnValues);	
	}
	else
	{
		WriteLog("Exception in loading DataBase values -- ");
		out.clear();
		out.print("-1");
	}
	
%>