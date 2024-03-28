<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SRM.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 29-Mar-2014
//Description                : File to insert/update data in Transaction table

Updations/Modifications :
1. In order to insert/update in transaction table a procedure is called "SRM_TXN_AUDIT_LOG_GEN".
   This procedure when called first checks if any data found in the transaction table for the same workitem.
   If data not found then executes insert query else update query.
   Along with this an entry is inserted in wfcurrentroutelog table each time any datya is inserted/updated in the transaction table.


//---------------------------------------------------------------------------------------------------->
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>

<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>


<%@ include file="SaveHistory.jsp"%>
<%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>


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

			WriteLog("Inside SRB.jsp APInsert sInputXML="+sInputXML);
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
	WriteLog("Inside SRB.jsp");
	
	boolean blockCardNoInLogs=true;
	String mainCodeCheck="0";
	WFCustomXmlResponse mainCodeParser=null;
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );    
	String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TEMPWINAME"), 1000, true) );    
	String TEMPWINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	if (TEMPWINAME != null) {TEMPWINAME=TEMPWINAME.replace("'","''");}
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tr_table"), 1000, true) );    
	String tr_table = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	if (tr_table != null) {tr_table=tr_table.replace("'","''");}
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("remarks"), 1000, true) );    
	String remarks = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	if (remarks != null) {remarks=remarks.replace("'","''");}
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("decisionNew"), 1000, true) );    
	String decisionNew = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	if (decisionNew != null) {decisionNew=decisionNew.replace("'","''");}
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RejectReason"), 1000, true) );    
	String RejectReason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	if (RejectReason != null) {RejectReason=RejectReason.replace("'","''");}
	WriteLog("tr_table : "+tr_table);
	WriteLog("decisionNew : "+decisionNew);
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("abc"), 1000, true) );    
	String abc = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	if (abc != null) {abc=abc.replace("'","''");}
	WriteLog("Inside SRB.jsp"+tr_table+WINAME+abc);
	
	if (true)
	{
		String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("PANno").replace("ENCODEDPLUS","+"), 1000, true) );    
		String PANno = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
		if (PANno != null) {PANno=PANno.replace("'","''");}
		String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WIDATA").replaceAll("ENCODEDPLUS","+"), 1000, true) );    
		String WIDATA = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
		if (WIDATA != null) {WIDATA=WIDATA.replace("'","''");}
		WIDATA=WIDATA.replaceAll("CHARPERCENTAGE","%");
		WIDATA=WIDATA.replaceAll("CHARAMPERSAND","&");
		// out.println("WIDATA "+WIDATA);
		
		/*if(blockCardNoInLogs)
			WriteLog("WIDATA From SRM.jsp---------> "+WIDATA);*/
		String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );    
		String WSNAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WS_LogicalName"), 1000, true) );    
		String WS_LogicalName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
		if (WS_LogicalName != null) {WS_LogicalName=WS_LogicalName.replace("'","''");}
		String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CategoryID"), 1000, true) );    
		String CategoryID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
		if (CategoryID != null) {CategoryID=CategoryID.replace("'","''");}
		String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategoryID"), 1000, true) );    
		String SubCategoryID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
		if (SubCategoryID != null) {SubCategoryID=SubCategoryID.replace("'","''");}
		String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsDoneClicked"), 1000, true) );    
		String IsDoneClicked = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");		
		if (IsDoneClicked != null) {IsDoneClicked=IsDoneClicked.replace("'","''");}
		String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsError"), 1000, true) );    
		String IsError = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
		if (IsError != null) {IsError=IsError.replace("'","''");}
		String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsSaved"), 1000, true) );    
		String IsSaved = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
		if (IsSaved != null) {IsSaved=IsSaved.replace("'","''");}
		String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("decisionSaved"), 1000, true) );    
		String decisionSaved = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
		if (decisionSaved != null) {decisionSaved=decisionSaved.replace("'","''");}
		String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("exceptionString"), 1000, true) );    
		String exceptionString = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
		if (exceptionString != null) {exceptionString=exceptionString.replace("'","''");}
		
		
		WriteLog("IsDoneClicked,IsError,IsSaved= "+IsDoneClicked+","+IsError+","+IsSaved);
		//out.println("WINAME "+WINAME);
		if(CategoryID.equals("1") && SubCategoryID.equals("1") && (WSNAME.equals("Q1") || WSNAME.equals("Q2") || WSNAME.equals("Q3")) && WIDATA.indexOf("Decision")==-1)
		{
			mainCodeCheck="99";
		}
		else
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
			String splitcolumnvalue[]=null;
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
			
			if(continueCode)
			{
					int count=0;
					WIDATA	=	WIDATA.replace("#"," # ");
					//WriteLog("WIDATA ::--->>"+WIDATA);
					temp= WIDATA.split("~");
					count=temp.length;
					WriteLog("count "+temp.length);
					//WriteLog("temp--->"+temp);
					
					String check[]=null;
					
					boolean allNULLValueFlag = true;
					for(int k=0;k<count;k++)
					{
						//WriteLog("temp["+k+"]--->"+temp[k]);
						check=temp[k].split("#");
						//WriteLog("colvalues"+colvalues);
						//WriteLog("colname"+colname);
						//WriteLog("check[0]="+check[0]);
						//WriteLog("check[1]="+check[1]);
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
					}	
					
					colvalues=colvalues.substring(0,(colvalues.lastIndexOf(",")));
					//WriteLog("colvalues="+colvalues);
					
					//Added on 21-11-2018 for not saving all the null values in the transaction table
					String newcolumnvalues = colvalues.replaceAll("'NULL'", "");
				    splitcolumnvalue = newcolumnvalues.split(",");
					if(splitcolumnvalue.length==0)
						allNULLValueFlag= false;
					else
						allNULLValueFlag= true;	
					
					colvalues+=",'"+WINAME+"'";
					colname+="WI_NAME";
					
					String sWiName="";
					if(WINAME==null || WINAME.equalsIgnoreCase("") || WINAME.equals(""))
						sWiName=TEMPWINAME;
					else
						sWiName=WINAME;
						
						
					String userName=customSession.getUserName();
					String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Category"), 1000, true) );    
					String Category = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
					if (Category != null) {Category=Category.replace("'","''");}
					String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategory"), 1000, true) );    
					String SubCategory = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
					if (SubCategory != null) {SubCategory=SubCategory.replace("'","''");}
					colname = colname.replaceAll(",","~");
					colvalues =colvalues.replaceAll("'","''").replaceAll(",", "~");
					
					String param = "'"+customSession.getEngineName()+"','"+sWiName+"','"+TEMPWINAME+"','"+WSNAME+"','"+userName+"','"+Category+"','"+SubCategory+"','"+colname+"','"+colvalues+"'";
					
					//WriteLog("param:\n"+param);
					
					if(WSNAME.equals("CSO") && IsDoneClicked.equals("true")) //If Condition added by siva to avoid null data in transaction table
					{
						try	
						{
							if(allNULLValueFlag)
							{
								String sInputXML="<?xml version=\"1.0\"?>" +                                                           
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>SRB_TXN_AUDIT_LOG_GEN</ProcName>"+
								"<EngineName>"+customSession.getEngineName()+"</EngineName>" +
								"<SessionID>"+customSession.getDMSSessionId()+"</SessionID>" +					                                      
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>1</NoOfCols>" +
								
								"</APProcedure2_Input>";

								WriteLog("sInputXML Transaction table: "+sInputXML);
								String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
								WriteLog("sOutputXML Transaction table: "+sOutputXML);
								WFCustomXmlResponseData=new WFCustomXmlResponse();
								WFCustomXmlResponseData.setXmlString(sOutputXML);
								if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
								{
									WriteLog("Insert in transaction table from SRB_TXN_AUDIT_LOG_GEN Successful");
									
								}
								else
								{
									WriteLog("Insert in transaction table from SRB_TXN_AUDIT_LOG_GEN Unsuccessful");
									mainCodeCheck=WFCustomXmlResponseData.getVal("MainCode");
									
								}
							}
							else
							{
								WriteLog("None of the service request parameters are having any value");
								mainCodeCheck="-201";
							}
							
						}
						catch(Exception e) 
						{
							WriteLog("<OutPut>Error in getting User Session.</OutPut>");
							
						}
					}
					
					WriteLog("IsDoneClicked "+IsDoneClicked);	
					
					
					if(IsDoneClicked.equals("true") && !mainCodeCheck.equalsIgnoreCase("-201"))
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



