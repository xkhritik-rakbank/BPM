<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SRM.jsp
//Author                     : Deepti Sharma
//Modified By				 : Sivakumar P
// Date written (DD/MM/YYYY) : 17-Jul-2018
//Description                : File to insert/update data in Transaction table

Updations/Modifications :
1. In order to insert/update in transaction table a procedure is called "SRM_TXN_AUDIT_LOG_GEN".
   This procedure when called first checks if any data found in the transaction table for the same workitem.
   If data not found then executes insert query else update query.
   Along with this an entry is inserted in wfcurrentroutelog table each time any datya is inserted/updated in the transaction table.


//---------------------------------------------------------------------------------------------------->
<%@ include file="../TF_Specific/Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>

<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>


<%@ include file="SaveHistory.jsp"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>


<script language="javascript" src="/webdesktop/webtop/scripts/client.js"></script>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<!--<link rel="stylesheet" type="text/css" href = "\webdesktop\webtop\en_us\css\docstyle.css">-->

<%!
	
	public static String APInsert(String strEngineName, String strSessionId, String tableName, String columns, String strValues) 
        {
			
			String sInputXML = "<?xml version=\"1.0\"?>" +
        "<APInsert_Input>" +
            "<Option>APInsert</Option>" +
            "<TableName>" + tableName + "</TableName>" +
            "<ColName>" + columns + "</ColName>" +
            "<Values>" + strValues + "</Values>" +
            "<EngineName>" + strEngineName + "</EngineName>" +
            "<SessionId>" + strSessionId + "</SessionId>" +
        "</APInsert_Input>";

			WriteLog("Inside TFDataSave.jsp APInsert sInputXML="+sInputXML);
			return sInputXML;

        }
		
	public String APUpdate(String strEngineName, String strSessionId, String tableName, String columnName, String strValues, String sWhere) 
	{
 
        String sInputXML = "<?xml version=\"1.0\"?>"
                + "<APUpdate_Input><Option>APUpdate</Option>"
                + "<TableName>" + tableName + "</TableName>"
                + "<ColName>" + columnName + "</ColName>"
                + "<Values>" + strValues + "</Values>"
                + "<WhereClause>" + sWhere + "</WhereClause>"
                + "<EngineName>" + strEngineName + "</EngineName>"
                + "<SessionId>" + strSessionId + "</SessionId>"
                + "</APUpdate_Input>";
    WriteLog("Inside SRM.jsp APUpdate sInputXML="+sInputXML);
        return sInputXML;

    }	

%>

<%


			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
			WriteLog("WINAME_Esapi Esapi---> "+WINAME_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TEMPWINAME"), 1000, true) );
			String TEMPWINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("TEMPWINAME Request.getparameter---> "+request.getParameter("TEMPWINAME"));
			WriteLog("TEMPWINAME_Esapi Esapi---> "+TEMPWINAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Application_FormCode"), 1000, true) );
			String Application_FormCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Application_FormCode Request.getparameter---> "+request.getParameter("Application_FormCode"));
			WriteLog("Application_FormCode_Esapi Esapi---> "+Application_FormCode_Esapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tr_table"), 1000, true) );
			String tr_table_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("tr_table Request.getparameter---> "+request.getParameter("tr_table"));
			WriteLog("tr_table_Esapi Esapi---> "+tr_table_Esapi);
			
			WriteLog("remarks Request.getparameter---> "+request.getParameter("remarks"));
			//String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("remarks"), 1000, true) );
			String remarks_Esapi = request.getParameter("remarks");			
			WriteLog("remarks_Esapi Esapi---> "+remarks_Esapi);
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("decisionNew"), 1000, true) );
			String decisionNew_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("decisionNew Request.getparameter---> "+request.getParameter("decisionNew"));
			WriteLog("decisionNew_Esapi Esapi---> "+decisionNew_Esapi);
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RejectReason"), 1000, true) );
			String RejectReason_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("RejectReason Request.getparameter---> "+request.getParameter("RejectReason"));
			WriteLog("RejectReason_Esapi Esapi---> "+RejectReason_Esapi);
			
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("abc"), 1000, true) );
			String abc_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("abc Request.getparameter---> "+request.getParameter("abc"));
			WriteLog("abc_Esapi Esapi---> "+abc_Esapi);
			
			String abc_Esapi_Replace = abc_Esapi.replace("&#x28;","(");
			abc_Esapi_Replace=abc_Esapi_Replace.replace("&#x29;",")");
			abc_Esapi_Replace=abc_Esapi_Replace.replace("&#x7b;","{");
			abc_Esapi_Replace=abc_Esapi_Replace.replace("&#x5b;","[");
			abc_Esapi_Replace=abc_Esapi_Replace.replace("&#x5d;","]");
			abc_Esapi_Replace=abc_Esapi_Replace.replace("&#x7d;","}");
	        WriteLog("Integration jsp: abc_Esapi esapi: after replace changes "+abc_Esapi_Replace);
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("PANno"), 1000, true) );
			String PANno_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("PANno Request.getparameter---> "+request.getParameter("PANno"));
			WriteLog("PANno_Esapi Esapi---> "+PANno_Esapi);
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WIDATA"), 1000, true) );
			String WIDATA_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("WIDATA Request.getparameter---> "+request.getParameter("WIDATA"));
			WriteLog("WIDATA_Esapi Esapi---> "+WIDATA_Esapi);
			
			String WIDATA_Esapi_Replace = WIDATA_Esapi.replace("&#x23;","#");
			WIDATA_Esapi_Replace=WIDATA_Esapi_Replace.replace("&#x7e;","~");
	        WriteLog("Integration jsp: WIDATA_Esapi_Replace esapi: after replace changes "+WIDATA_Esapi_Replace);
			
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
			WriteLog("WSNAME_Esapi Esapi---> "+WSNAME_Esapi);
			
			String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WS_LogicalName"), 1000, true) );
			String WS_LogicalName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			WriteLog("WS_LogicalName Request.getparameter---> "+request.getParameter("WS_LogicalName"));
			WriteLog("WS_LogicalName_Esapi Esapi---> "+WS_LogicalName_Esapi);
			
			String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CategoryID"), 1000, true) );
			String CategoryID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			WriteLog("CategoryID Request.getparameter---> "+request.getParameter("CategoryID"));
			WriteLog("CategoryID_Esapi Esapi---> "+CategoryID_Esapi);
			
			String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategoryID"), 1000, true) );
			String SubCategoryID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			WriteLog("SubCategoryID Request.getparameter---> "+request.getParameter("SubCategoryID"));
			WriteLog("SubCategoryID_Esapi Esapi---> "+SubCategoryID_Esapi);
			
			String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsDoneClicked"), 1000, true) );
			String IsDoneClicked_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			WriteLog("IsDoneClicked Request.getparameter---> "+request.getParameter("IsDoneClicked"));
			WriteLog("IsDoneClicked_Esapi Esapi---> "+IsDoneClicked_Esapi);
			
			String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsError"), 1000, true) );
			String IsError_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
			WriteLog("IsError Request.getparameter---> "+request.getParameter("IsError"));
			WriteLog("IsError_Esapi Esapi---> "+IsError_Esapi);
			
			String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsSaved"), 1000, true) );
			String IsSaved_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			WriteLog("IsSaved Request.getparameter---> "+request.getParameter("IsSaved"));
			WriteLog("IsSaved_Esapi Esapi---> "+IsSaved_Esapi);
			
			String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("decisionsaved"), 1000, true) );
			String decisionsaved_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
			WriteLog("decisionsaved Request.getparameter---> "+request.getParameter("decisionsaved"));
			WriteLog("decisionsaved_Esapi Esapi---> "+decisionsaved_Esapi);
			
			String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("exceptionstring"), 1000, true) );
			String exceptionstring_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
			WriteLog("exceptionstring Request.getparameter---> "+request.getParameter("exceptionstring"));
			WriteLog("exceptionstring Esapi---> "+exceptionstring_Esapi);
			
			String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Category"), 1000, true) );
			String Category_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
			WriteLog("Category Request.getparameter---> "+request.getParameter("Category"));
			WriteLog("Category_Esapi Esapi---> "+Category_Esapi);
			
			String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ProductType"), 1000, true) );
			String ProductType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
			WriteLog("ProductType Request.getparameter---> "+request.getParameter("ProductType"));
			WriteLog("ProductType_Esapi Esapi---> "+ProductType_Esapi);
			
			
	WriteLog("Inside TFDataSave.jsp");
	
	boolean blockCardNoInLogs=true;
	String mainCodeCheck="0";
	WFCustomXmlResponse mainCodeParser=null;
	String WINAME=WINAME_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String TEMPWINAME=TEMPWINAME_Esapi;
	if (TEMPWINAME != null) {TEMPWINAME=TEMPWINAME.replace("'","''");}
	String ApplicationFormCode = Application_FormCode_Esapi;
	String tr_table = tr_table_Esapi;
	if (tr_table != null) {tr_table=tr_table.replace("'","''");}
	String remarks=remarks_Esapi;
	remarks = remarks.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ").replaceAll("&amp;amp;","&amp;");
	WriteLog("remarks after : "+remarks);
	if (remarks != null) {remarks=remarks.replace("'","''");}
	String decisionNew=decisionNew_Esapi;
	if (decisionNew != null) {decisionNew=decisionNew.replace("'","''");}
	String RejectReason=RejectReason_Esapi;
	RejectReason=RejectReason.replaceAll("&#x23;","#");
	if (RejectReason != null) {RejectReason=RejectReason.replace("'","''");}

	WriteLog("ApplicationFormCode : "+ApplicationFormCode);
	WriteLog("tr_table : "+tr_table);
	WriteLog("decisionNew : "+decisionNew);
	String abc =abc_Esapi_Replace;
	if (abc != null) {abc=abc.replace("'","''");}
	WriteLog("Inside TFDataSave.jsp"+tr_table+WINAME+abc);
	
	if (true)
	{
		String PANno=PANno_Esapi.replace("ENCODEDPLUS","+");
		if (PANno != null) {PANno=PANno.replace("'","''");}
		String WIDATA=WIDATA_Esapi_Replace.replaceAll("ENCODEDPLUS","+");
		if (WIDATA != null) {WIDATA=WIDATA.replace("'","''");}
		WIDATA=WIDATA.replaceAll("CHARPERCENTAGE","%");
		WIDATA=WIDATA.replaceAll("CHARAMPERSAND","&");
		//out.println("WIDATA "+WIDATA);
		
		if(blockCardNoInLogs)
			WriteLog("WIDATA From SRM.jsp---------> "+WIDATA);
		
		String WSNAME=WSNAME_Esapi;
		WriteLog("WSNAME From form.jsp Vishnu---------> "+WSNAME);
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		String WS_LogicalName=WS_LogicalName_Esapi;
		if (WS_LogicalName != null) {WS_LogicalName=WS_LogicalName.replace("'","''");}
		String CategoryID=CategoryID_Esapi;
		if (CategoryID != null) {CategoryID=CategoryID.replace("'","''");}
		String SubCategoryID=SubCategoryID_Esapi;
		if (SubCategoryID != null) {SubCategoryID=SubCategoryID.replace("'","''");}
		String IsDoneClicked=IsDoneClicked_Esapi;  
		if (IsDoneClicked != null) {IsDoneClicked=IsDoneClicked.replace("'","''");}
		String IsError=IsError_Esapi;  
		if (IsError != null) {IsError=IsError.replace("'","''");}
		String IsSaved=IsSaved_Esapi; 
		if (IsSaved != null) {IsSaved=IsSaved.replace("'","''");}
		String decisionSaved=decisionsaved_Esapi;
		if (decisionSaved != null) {decisionSaved=decisionSaved.replace("'","''");}
		String exceptionString=exceptionstring_Esapi;
		if (exceptionString != null) {exceptionString=exceptionString.replace("'","''");}
		
		
		WriteLog("IsDoneClicked,IsError,IsSaved= "+IsDoneClicked+","+IsError+","+IsSaved);
		//out.println("WINAME "+WINAME);
		
		if (true)
		{
			WriteLog("tr_table"+tr_table);
			WriteLog("WSNAME----"+WSNAME);
			int flag=0;
			String sCabName=null;
			String sSessionId = null;

			String sJtsIp = null;
			int iJtsPort = 0;
			
			String colname="";
			String colvalues="'";
			String temp[]=null;
			String Query="";
			String inputData="";
			String outputData="";
			String mainCodeValue="";
			WFCustomXmlResponse WFCustomXmlResponseData=null;
			WFCustomXmlResponse objWFCustomXmlResponse=null;
			String subXML="";
			String WI="";
			boolean continueCode = true;
			
			int counter=0;
			
			String blankDataFlag = "Blank";
			
			if(continueCode)
			{
					int count=0;
					WIDATA	=	WIDATA.replace("#"," # ");
					WriteLog("WIDATA ::--->>"+WIDATA);
					temp= WIDATA.split("~");
					count=temp.length;
					WriteLog("count "+temp.length);
					WriteLog("temp--->"+temp);
					
					String check[]=null;
					
					for(int k=0;k<count;k++)
					{
						WriteLog("temp["+k+"]--->"+temp[k]);
						check=temp[k].split("#");
						WriteLog("colvalues"+colvalues);
						WriteLog("colname"+colname);
						WriteLog("check[0]="+check[0]);
						WriteLog("check[1]="+check[1]);
						colname+=check[0].trim()+",";
						check[1] = check[1].trim();
						/*try
						{
							check[1]=URLEncoder.encode(check[1], "UTF-8");
						}
						catch (UnsupportedEncodingException ex) 
						{             
							ex.printStackTrace();         
						}*/ //commented to save date in db without encoding on 23052017
						colvalues+=check[1]+"','";
						
						if (!check[1].equalsIgnoreCase(""))
						{
							blankDataFlag = "NotBlank";
						}
					}	
					
					colvalues=colvalues.substring(0,(colvalues.lastIndexOf(",")));

					colvalues+=",'"+WINAME+"'";
					colname+="WI_NAME";
					
					String sWiName="";
					if(WINAME==null || WINAME.equalsIgnoreCase("") || WINAME.equals(""))
						sWiName=TEMPWINAME;
					else
						sWiName=WINAME;
						
						
					String userName=customSession.getUserName();
					String Category=Category_Esapi;
					if (Category != null) {Category=Category.replace("'","''");}
					String SubCategory=ProductType_Esapi;
					if (SubCategory != null) {SubCategory=SubCategory.replace("'","''");}
					colname = colname.replaceAll(",","~");
					colvalues =colvalues.replaceAll("'","''").replaceAll(",", "~");
					WriteLog("colname:\n"+colname);
					WriteLog("colvalues check:\n"+colvalues);
					
					String param = "'"+customSession.getEngineName()+"','"+sWiName+"','"+TEMPWINAME+"','"+WSNAME+"','"+userName+"','"+Category+"','"+SubCategory+"','"+colname+"','"+colvalues+"'";
					
					WriteLog("param:\n"+param);
					
					// handled specifically for sub category 4
					String blankDataForSubcat4 = "";						
					if (WSNAME.equals("TF_Document_Approver") && SubCategoryID.equalsIgnoreCase("4") && blankDataFlag.equalsIgnoreCase("Blank"))
					{
						blankDataForSubcat4 = "Y";
					}
											
					else if(WSNAME.equals("CSO") || WSNAME.equals("TF_Maker") || WSNAME.equals("TF_Document_Approver"))
					{
						
							try	
							{							
								String sInputXML="<?xml version=\"1.0\"?>" +                                                           
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>TF_TXN_AUDIT_LOG_GEN</ProcName>"+
								"<EngineName>"+customSession.getEngineName()+"</EngineName>" +
								"<SessionID>"+customSession.getDMSSessionId()+"</SessionID>" +					                                      
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>1</NoOfCols>" +
								
								"</APProcedure2_Input>";

								WriteLog(sInputXML);
								String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
								WriteLog("sOutputXML1 : "+sOutputXML);
								WFCustomXmlResponseData=new WFCustomXmlResponse();
								WFCustomXmlResponseData.setXmlString(sOutputXML);
								if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
								{
									WriteLog("Insert in transaction table from TF_TXN_AUDIT_LOG_GEN Successful");
									
								}
								else
								{
									WriteLog("Insert in transaction table from TF_TXN_AUDIT_LOG_GEN Unsuccessful");
									mainCodeCheck=WFCustomXmlResponseData.getVal("MainCode");
									
								}	
							}
							catch(Exception e) 
							{
								WriteLog("<OutPut>Error in getting User Session.</OutPut>");
								
							}
						
					}
					
					WriteLog("mainCodeCheck-- "+mainCodeCheck);	
					WriteLog("IsDoneClicked "+IsDoneClicked);	
					
					// handled specifically for sub category 4
					if (IsDoneClicked.equals("true") && blankDataForSubcat4.equalsIgnoreCase("Y"))
						mainCodeCheck = "SUBCAT4DATABLANK";
					
					if(IsDoneClicked.equals("true") && mainCodeCheck=="0")
					{
						WriteLog("Before calling SRM_SaveHistory");
						//SRM_SaveHistory(WIDATA,CategoryID,SubCategoryID,WSNAME,WS_LogicalName,customSession,WINAME);
						//modified by shamily to insert reject reason in history
						if(SRM_SaveHistory(WIDATA,CategoryID,SubCategoryID,WSNAME,WS_LogicalName,customSession,WINAME,remarks,decisionNew,RejectReason))
						{
							WriteLog("Garg 001");	
							//out.clear();
							//out.println("Insert Successful");
							//GetCutOfftime(WINAME);
						}
						else
						{
							WriteLog("Garg 002");	
							//out.clear();
							//out.println("Insert UnSuccessful");
							mainCodeCheck="-1";
						}
					}
				//---------------------
				
			}

		}
	
	}	
%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeCheck+"~");		
%>



