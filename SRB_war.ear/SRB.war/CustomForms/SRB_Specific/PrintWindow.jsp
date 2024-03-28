<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>




<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%!

// below function added to decrypt card number
private String decrypt(String pass)
{
	int len = pass.length();
	byte[] data = new byte[len / 2];
	for (int i = 0; i < len; i += 2) {
		data[i / 2] = (byte) ((Character.digit(pass.charAt(i), 16) << 4)
				+ Character.digit(pass.charAt(i+1), 16));
	}
	//String password=OSASecurity.decode(data,"UTF-8");
	String password="123456";
	return password;
}

public String maskCardNo(String cardNo)
{
	cardNo=cardNo.substring(0,6)+"XXXXXX"+cardNo.substring(12,16);
	cardNo=cardNo.substring(0,4)+"-"+cardNo.substring(4,8)+"-"+cardNo.substring(8,12)+"-"+cardNo.substring(12,16);
	
	return cardNo;
}

%>

<%
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );    
		String reqType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("reqType ---- "+reqType);
		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Ws_Name"), 1000, true) );    
		String WSNAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		WriteLog("WSNAME ---- "+WSNAME);		
		String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("subCategoryCode"), 1000, true) );    
		String subCategoryCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		WriteLog("subCategoryCode ---- "+subCategoryCode);
		String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("subCategory"), 1000, true) );    
		String subCategory = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
		subCategory = subCategory.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
		WriteLog("subCategory for nikita---- "+subCategory);
		String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCatIndex"), 1000, true) );    
		String SubCategoryIndex = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
		WriteLog("SubCategoryIndex ---- "+SubCategoryIndex);
		String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CatIndex"), 1000, true) );    
		String ParentCategoryIndex = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
		WriteLog("ParentCategoryIndex ---- "+ParentCategoryIndex);
		String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cifid"), 1000, true) );    
		String cifid = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
		WriteLog("String cifid---- "+ cifid);
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
			query = "SELECT ParentCategoryIndex,SubCategoryIndex FROM USR_0_SRB_SUBCATEGORY with(nolock) WHERE SUBCATEGORYNAME='"+subCategory+"' AND Application_FormCode='"+subCategoryCode+"'";
			//params = "Sub_Category_Name='"+subCategory+"' AND SUB_CATEGORY_CODE='"+subCategoryCode+"'";
		}
		
		
		else if (reqType.equals("Load_FormLayout_Table"))
		{
			if(WSNAME.equalsIgnoreCase("Q6"))
				WSNAME="Print and Dispatch";
			
			query = "SELECT LabelName,ColumnName,IsRepeatable FROM  usr_0_srb_formlayout with(nolock) where CatIndex='"+ParentCategoryIndex+"' AND SubCatIndex='"+SubCategoryIndex+"' AND Ws_Name='"+WSNAME+"' and ColumnName != '' ORDER BY FieldOrder";
			//params = "ONE==1";
		}	
		
		else if (reqType.equals("Load_ModeOfDelivery"))
		{
			query = "SELECT Mode_Of_Delivery FROM  USR_0_SRB_SUBCATEGORY with(nolock) where SubCategoryName='"+subCategory+"'";
			//params = "ONE==1";
		}
		else if (reqType.equals("Load_StaleDateRestriction"))
		{
			query = "SELECT StaleDateRestriction FROM  USR_0_SRB_SUBCATEGORY with(nolock) where SubCategoryName='"+subCategory+"'";
			//params = "ONE==1";
		}
		
		else if (reqType.equals("Load_Dynamicfieldwi"))
		{
		query = "SELECT distinct wi_name FROM RB_SRB_EXTTABLE E  with(nolock), QUEUEVIEW Q with (nolock) WHERE E.WI_NAME IN (SELECT winame FROM usr_0_srb_wihistory WHERE wsname ='Q6' AND decision IN ('Sent by Courier','Sent by Post')) and Q.activityname = 'Exit' AND E.SubCategory='"+subCategory+"' AND E.CifId='"+cifid+"'";
		//query = "SELECT wi_name FROM RB_srb_EXTTABLE with(nolock) WHERE wi_name IN (SELECT winame FROM usr_0_srb_wihistory WHERE wsname ='Q6' AND decision IN ('Sent by Courier','Sent by Post')) AND WS_NAME = 'Exit'  AND SubCategory='"+subCategory+"' AND CifId='"+cifid+"'";
			//params = "ONE==1";
		
		}
		else if (reqType.equals("getDataFromTransactionTable"))
		{
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SRCode"), 1000, true) );    
			String ServiceRequestCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );    
			String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			query = "Select * from USR_0_SRB_TR_"+ServiceRequestCode+" with (nolock) where WI_NAME = '"+WINAME+"'";
			//params = "ONE==1";
		
		}
		
		
		//sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		
		
		sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
		WriteLog("\nInput XML from PrintWindow for ReqType: "+reqType+" -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML from PrintWindow for ReqType: "+reqType+" ---- "+sOutputXML);

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
			{
				String LabelName = objWorkList.getVal("LabelName");
				if (LabelName.equalsIgnoreCase(""))
					LabelName = "-";
				returnValues = returnValues + LabelName  + "~" + objWorkList.getVal("ColumnName") + "~" + objWorkList.getVal("IsRepeatable") + "`";		
			}else if (reqType.equals("Load_ModeOfDelivery"))
				returnValues = returnValues + objWorkList.getVal("Mode_Of_Delivery") + "~";	
			else if (reqType.equals("Load_StaleDateRestriction"))
				returnValues = returnValues + objWorkList.getVal("StaleDateRestriction") + "~";	
			else if (reqType.equals("Load_Dynamicfieldwi"))
				returnValues = returnValues + objWorkList.getVal("wi_name") + "~";
			else if (reqType.equals("getDataFromTransactionTable"))
			{
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("AccountNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("AccountNumber");	
				} catch (Exception e){}				
				try{
					String CreditCardNum = objWorkList.getVal("CreditCardNumber");
					if (!CreditCardNum.equalsIgnoreCase("") && CreditCardNum != null)
					{
						if (CreditCardNum.length() > 16)
						{	
							CreditCardNum = decrypt(CreditCardNum);
						}
						if (!CreditCardNum.equalsIgnoreCase(""))
							CreditCardNum = maskCardNo(CreditCardNum);	
					}
					if (returnValues.equalsIgnoreCase(""))
						returnValues = CreditCardNum;
					else
						returnValues = returnValues+ ", " + CreditCardNum;
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("CreditAccountNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("CreditAccountNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("DebitAccountNumber");
					if (!returnValues.equalsIgnoreCase(""))
						returnValues = returnValues+ ", " + objWorkList.getVal("DebitAccountNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("CreditBenAccountNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("CreditBenAccountNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("CardNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("CardNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("Loanaccountnumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("Loanaccountnumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("AgreementNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("AgreementNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("FDAccountNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("FDAccountNumber");
				} catch (Exception e){}
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("AutoLoanAgreementNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("AutoLoanAgreementNumber");
				} catch (Exception e){}	
				try{
					if (returnValues.equalsIgnoreCase(""))
						returnValues = objWorkList.getVal("RDAccountNumber");
					else
						returnValues = returnValues+ ", " + objWorkList.getVal("RDAccountNumber");
				} catch (Exception e){}
			}			
		}	
		
		if (reqType.equals("getDataFromTransactionTable"))
		{
			returnValues = returnValues.replace(",",""); 
			returnValues = returnValues.replace("@",", "); 
			returnValues = returnValues.replace("%40",", "); 
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