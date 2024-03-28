<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SRM.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 29-Mar-2014
//Description                : File to insert/update data in Transaction table
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<%@ include file="SaveHistory.jsp"%>



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

			WriteLog("Inside SRM.jsp APInsert sInputXML="+sInputXML);
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
	WriteLog("Inside SRM.jsp");
	
	boolean blockCardNoInLogs=true;
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String WINAME=request.getParameter("WINAME");
	String TEMPWINAME=request.getParameter("TEMPWINAME");
	String tr_table = request.getParameter("tr_table");
	WriteLog("tr_table : "+tr_table);
	String abc = request.getParameter("abc");
	WriteLog("Inside SRM.jsp"+tr_table+WINAME+abc);
	if(tr_table!=null && tr_table.equalsIgnoreCase("USR_0_SRM_DiscardedWI"))
	{
		if(WINAME!=null)
		{
			String strRejectionRemarks=request.getParameter("WIDATA");
			//update external table
			
			if(strRejectionRemarks==null)
				strRejectionRemarks="";
			//Discard wi entry
			String histCols="catIndex,subCatIndex,winame,wsname,actual_wsname,decision,actiondatetime,remarks,username";
			String histColVals="'0','0','"+WINAME+"','PBO','PBO','Reject',getdate(),'"+strRejectionRemarks+"','"+wfsession.getUserName()+"'";
			try	{
				String sHistInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
					"<Option>APInsert</Option>" +
					"<TableName>usr_0_srm_wihistory</TableName>" +
					"<ColName>" + histCols + "</ColName>" +
					"<Values>" + histColVals + "</Values>" +
					"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
					"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
				"</APInsert_Input>";
				WriteLog(sHistInputXML);
				String sHistOutputXML= WFCallBroker.execute(sHistInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
				WriteLog("sOutputXML1"+sHistOutputXML);
				if(sHistOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					WriteLog("History Table Insert Successful");
				}
				else
				{
					WriteLog("History Table Insert UnSuccessful");
					mainCodeParser=new XMLParser();
					mainCodeParser.setInputXML(sHistOutputXML);
					mainCodeCheck = mainCodeParser.getValueOf("MainCode");
				}
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in Inserting into History Table .</OutPut>");
			}
			
			//history entry
			String discardCols="winame,discardedBy,reasons,discardedDateTime";
			String discardColVals="'"+WINAME+"','"+wfsession.getUserName()+"','"+strRejectionRemarks+"',getdate()";
			try	{
				String discardInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
					"<Option>APInsert</Option>" +
					"<TableName>USR_0_SRM_DiscardedWI</TableName>" +
					"<ColName>" + discardCols + "</ColName>" +
					"<Values>" + discardColVals + "</Values>" +
					"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
					"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
				"</APInsert_Input>";
				WriteLog(discardInputXML);
				String discardOutputXML= WFCallBroker.execute(discardInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
				WriteLog("sOutputXML1"+discardOutputXML);
				if(discardOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					WriteLog("History Table Insert Successful");
				}
				else
				{
					WriteLog("History Table Insert UnSuccessful");
					mainCodeParser=new XMLParser();
					mainCodeParser.setInputXML(discardOutputXML);
					mainCodeCheck = mainCodeParser.getValueOf("MainCode");
				}
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in Inserting into DiscardedWI Table.</OutPut>");
			}
		}
	}
	else
	{
		String PANno=request.getParameter("PANno").replace("ENCODEDPLUS","+");
		//out.println("PANno "+PANno);
		String WIDATA=request.getParameter("WIDATA").replace("ENCODEDPLUS","+");
		WIDATA=WIDATA.replaceAll("CHARPERCENTAGE","%");
		WIDATA=WIDATA.replaceAll("CHARAMPERSAND","&");
		//out.println("WIDATA "+WIDATA);
		
		if(blockCardNoInLogs)
			WriteLog("WIDATA From SRM.jsp---------> "+WIDATA);
		
		String WSNAME=request.getParameter("WSNAME");
		String WS_LogicalName=request.getParameter("WS_LogicalName");
		String CategoryID=request.getParameter("CategoryID");
		String SubCategoryID=request.getParameter("SubCategoryID");
		String IsDoneClicked=request.getParameter("IsDoneClicked");  
		String IsError=request.getParameter("IsError");  
		String IsSaved=request.getParameter("IsSaved");  
		String decisionSaved=request.getParameter("decisionsaved");
		String exceptionString=request.getParameter("exceptionstring");
		WriteLog("IsDoneClicked,IsError,IsSaved= "+IsDoneClicked+","+IsError+","+IsSaved);
		//out.println("WINAME "+WINAME);
		if(CategoryID.equals("1") && SubCategoryID.equals("1") && (WSNAME.equals("Q1") || WSNAME.equals("Q2") || WSNAME.equals("Q3")) && WIDATA.indexOf("Decision")==-1)
		{
			mainCodeCheck="99";
		}
		else
		{
			WriteLog("tr_table"+tr_table);
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
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String subXML="";
			String WI="";
			boolean continueCode = true;
			
			int counter=0;
			if(decisionSaved.equals("N") && IsDoneClicked.equals("true"))
			{
				inputData="<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
					"<Option>APInsert</Option>" +
					"<TableName>USR_0_SRM_StuckWIDebug</TableName>" +
					"<ColName>WINAME,ProcessedBy,ActionDateTime,WIDATA,exceptionstring</ColName>" +
					"<Values>'"+WINAME+"','"+wfsession.getUserName()+"',getdate(),'"+WIDATA+"','"+exceptionString+"'</Values>" +
					"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
					"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
					"</APInsert_Input>";
				outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("output of insertion into DecisionNotSaved-->"+outputData);
				xmlParserData=new XMLParser();
				xmlParserData.setInputXML(outputData);
				if(!xmlParserData.getValueOf("MainCode").equals("0"))
					continueCode=false;
				
			}
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
						try
						{
							check[1]=URLEncoder.encode(check[1], "UTF-8");
						}
						catch (UnsupportedEncodingException ex) 
						{             
							ex.printStackTrace();         
						} 
						colvalues+=check[1]+"','";
					}	
					
					colvalues=colvalues.substring(0,(colvalues.lastIndexOf(",")));
					
					colvalues+=",'"+PANno+"','"+WINAME+"','"+TEMPWINAME+"'";
					colname+="KEYID,WI_NAME,Temp_WI_NAME";
					
						 
					
					String sWiName="";
					if(WINAME==null || WINAME.equalsIgnoreCase("") || WINAME.equals(""))
						sWiName=TEMPWINAME;
					else
						sWiName=WINAME;
						
						
						
					//WSNAME=WSNAME;
					String userName=wfsession.getUserName();
					String Category=request.getParameter("Category");
					String SubCategory=request.getParameter("SubCategory");
					colname = colname.replaceAll(",","~");
					colvalues =colvalues.replaceAll("'","''").replaceAll(",", "~");
					
					String param = "'"+wfsession.getEngineName()+"','"+sWiName+"','"+TEMPWINAME+"','"+WSNAME+"','"+userName+"','"+Category+"','"+SubCategory+"','"+colname+"','"+colvalues+"'";
					
					WriteLog("param:\n"+param);
					
					try	
					{
					
						String sInputXML="<?xml version=\"1.0\"?>" +                                                           
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>SRM_TXN_AUDIT_LOG_GEN</ProcName>"+
						"<EngineName>"+wfsession.getEngineName()+"</EngineName>" +
						"<SessionID>"+wfsession.getSessionId()+"</SessionID>" +					                                      
						"<Params>"+param+"</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"</APProcedure2_Input>";

						WriteLog(sInputXML);
						String sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
						WriteLog("sOutputXML1 : "+sOutputXML);
						xmlParserData=new XMLParser();
						xmlParserData.setInputXML(sOutputXML);
						if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
						{
							WriteLog("Insert in transaction table from SRM_TXN_AUDIT_LOG_GEN Successful");
							mainCodeCheck=xmlParserData.getValueOf("MainCode");
							
						}
						else
						{
							WriteLog("Insert in transaction table from SRM_TXN_AUDIT_LOG_GEN Unsuccessful");
							mainCodeCheck=xmlParserData.getValueOf("MainCode");
							
						}	
					}
					catch(Exception e) 
					{
						WriteLog("<OutPut>Error in getting User Session.</OutPut>");
						
					}
					
				WriteLog("Prateek Garg 00001");			
					
					
					if(IsDoneClicked.equals("true") && mainCodeCheck.equalsIgnoreCase("0"))
					{
						WriteLog("Before calling SRM_SaveHistory");
						//SRM_SaveHistory(WIDATA,CategoryID,SubCategoryID,WSNAME,WS_LogicalName,wfsession,WINAME);
						if(SRM_SaveHistory(WIDATA,CategoryID,SubCategoryID,WSNAME,WS_LogicalName,wfsession,WINAME))
						{
							WriteLog("Garg 001");	
							//out.clear();
							//out.println("Insert Successful");
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



