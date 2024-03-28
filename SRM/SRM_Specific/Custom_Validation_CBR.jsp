<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : Custom_Validation_CBR.jsp
//Author                     : Deepti Sharma, Aishwarya Gupta
// Date written (DD/MM/YYYY) : 03-Apr-2014
//Description                : Custom server side Validations. Any server side validation can be 
							   added in the file later for subsequent requests
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>


<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>


<%
//out.println("inside Custom validation cbr");
String qry="";
String inputData2="";
String outputData2="";
String mainCodeValue2="";
String params="";
XMLParser xmlParserData=null;
XMLParser objXmlParser=null;
String Cash_Back_Eligible_Amount="";
int Approved_Cash_Back_Amount=0;
String subXML="";
int counter2=0;
int recordcount2=0;
String PANno=request.getParameter("PANno").replace("ENCODEDPLUS","+");
String cardSubType = request.getParameter("cardsubtype").replace("ENCODEDPLUS","+");
String cardStatus = request.getParameter("cardstatus").replace("ENCODEDPLUS","+");
//out.println("PANno"+PANno);
String tr_table = request.getParameter("tr_table");
//out.println("tr_table"+tr_table);
WriteLog("tr_table"+tr_table);
String WINAME=request.getParameter("WINAME");
String WSNAME = request.getParameter("WSNAME");
String amount = request.getParameter("amount");
WriteLog("amount in Custom_Validation "+amount);
String isDoneClicked = request.getParameter("IsDoneClicked");
WriteLog("IsDoneClicked in Custom_Validation "+isDoneClicked);
boolean continueExecution = true;
String[] timelimit = null;
String prime="N";
String cbamount="1000";
if(WSNAME.equals("PBO"))
{
	//String primeCheckQuery = "Select FieldValue from usr_0_srm_DataCenterFlagMaster where fieldname = 'IS_PRIME_UP' and catindex = 1 and subcatindex = 1";
	//String cashbacklimitQuery = "Select FieldValue from usr_0_srm_dynamic_variable_master where fieldname = 'CASHBACKAMOUNT'";
	
	String primeCheckQuery = "Select FieldValue from usr_0_srm_DataCenterFlagMaster with (nolock) where fieldname = :IS_PRIME_UP and catindex = 1 and subcatindex = 1";
	String cashbacklimitQuery = "Select FieldValue from usr_0_srm_dynamic_variable_master with (nolock) where fieldname = :CASHBACKAMOUNT";
	
	params = "IS_PRIME_UP==IS_PRIME_UP";
	/*String input3 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + primeCheckQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	String input3 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ primeCheckQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
	
	WriteLog("Getting prime flag status input "+input3);	
	String output3 = WFCallBroker.execute(input3, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	XMLParser xPData3=new XMLParser();
	String subXML3="";
	XMLParser objXmlParser3=null;
	xPData3.setInputXML(output3);
	String maincode3 = xPData3.getValueOf("MainCode");
	int rc3=0;
	if(maincode3.equals("0"))
	{	 
		rc3= Integer.parseInt(xPData3.getValueOf("TotalRetrieved"));
		for(int k=0; k<rc3; k++)
		{	
			subXML3 = xPData3.getNextValueOf("Record");
			objXmlParser3 = new XMLParser(subXML3);
			prime = objXmlParser3.getValueOf("FieldValue");
		}
	}
	else
		WriteLog("Error in query execution for getting Prime Status");	
	
	WriteLog("Prime status at time of introduction "+prime);
	
	/*String input4 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + cashbacklimitQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	params = "CASHBACKAMOUNT==CASHBACKAMOUNT";
	String input4 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ cashbacklimitQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		
		
	WriteLog("input4 CBR"+input4);		
	String output4 = WFCallBroker.execute(input4, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	XMLParser xPData4=new XMLParser();
	String subXML4="";
	XMLParser objXmlParser4=null;
	xPData4.setInputXML(output4);
	String maincode4 = xPData4.getValueOf("MainCode");
	int rc4=0;
	if(maincode4.equals("0"))
	{	 
		rc4= Integer.parseInt(xPData4.getValueOf("TotalRetrieved"));
		for(int k=0; k<rc4; k++)
		{	
			subXML4 = xPData4.getNextValueOf("Record");
			objXmlParser4 = new XMLParser(subXML4);
			cbamount = objXmlParser4.getValueOf("FieldValue");
		}
	}
	else
		WriteLog("Error in query execution for getting CashBackLimit amount");	
	WriteLog("Cash Back Limit Amount "+cbamount);	
	
	//changes for duplicate check time limit starts
	if(isDoneClicked.equalsIgnoreCase("true"))
	{
		String input = "<?xml version='1.0'?><APProcedure2_Input><Option>APProcedure2</Option><ProcName>SRM_RESTRICT_DUPLICATE</ProcName><Params>'"+WINAME+"', '"+PANno+"', '"+amount+"'</Params><NoOfCols>3</NoOfCols><SessionID>"+wfsession.getSessionId()+"</SessionID><EngineName>"+wfsession.getEngineName()+"</EngineName></APProcedure2_Input>";
		WriteLog("input for duplicate restrict "+input);	
		String output = WFCallBroker.execute(input, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("output for duplicate restrict "+output);
		XMLParser xp=new XMLParser();
		String subxp="";
		xp.setInputXML(output);
		String mainCodeProc = xp.getValueOf("MainCode");
		String result = xp.getValueOf("Results");
		if(mainCodeProc.equals("0") && result.startsWith("1"))
		{	 
			continueExecution = false;
			timelimit = result.split("!");
			out.clear();
			out.println("RequestInvalid~"+timelimit[1]+"~0~0~"+prime+cbamount);
		}
		else if (!mainCodeProc.equals("0"))
		{
			continueExecution = false;
			out.clear();
			out.println("Error");
		}
		else if (continueExecution)
		{
			/*qry="select tr.Approved_Cash_Back_Amount from usr_0_srm_tr_cbr tr, rb_srm_exttable ext where tr.KEYID='"+PANno+"'  AND  ext.wi_name = tr.wi_name and tr.IsPrimeUpdated='N' AND  tr.IsError='N' and (charindex('Reject', tr.Decision)<=0 or tr.decision is null) and ext.isrejected is null and (ext.current_workstep is not null and ext.current_workstep !='Not Introduced')";
			
			inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + qry + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
			
			params = "KEYID=="+PANno;
			qry = "select tr.Approved_Cash_Back_Amount from usr_0_srm_tr_cbr tr with (nolock), rb_srm_exttable ext with (nolock) where tr.KEYID=:KEYID  AND  ext.wi_name = tr.wi_name and tr.IsPrimeUpdated='N' AND  tr.IsError='N' and (charindex('Reject', tr.Decision)<=0 or tr.decision is null) and ext.isrejected is null and (ext.current_workstep is not null and ext.current_workstep !='Not Introduced')";
			inputData2 = "<?xml version='1.0'?>"+
			"<APSelectWithNamedParam_Input>"+
			"<Option>APSelectWithNamedParam</Option>"+
			"<Query>"+ qry + "</Query>"+
			"<Params>"+ params + "</Params>"+
			"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
			"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
			"</APSelectWithNamedParam_Input>";
			
			
			WriteLog("duplicate check input CBR "+inputData2);		
			outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("duplicate check output CBR-->"+outputData2);
			//out.println("outputData2="+outputData2);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputData2);
			mainCodeValue2 = xmlParserData.getValueOf("MainCode");
			String tempamount = "";
			if(mainCodeValue2.equals("0"))
			{	recordcount2 = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				WriteLog("Number of records are "+recordcount2);
				for(int k=0; k<recordcount2; k++)
				{	
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					tempamount = objXmlParser.getValueOf("Approved_Cash_Back_Amount");
					if (tempamount.equalsIgnoreCase("NULL") || tempamount.equals(""))
						continue;
					if(tempamount.indexOf(".")!=-1)
						tempamount=tempamount.substring(0,tempamount.indexOf("."));
					Approved_Cash_Back_Amount+= Integer.parseInt(tempamount);
				}
			}	
			else
			{ 
				WriteLog("Duplicate check failed with maincode="+mainCodeValue2);
				continueExecution=false;
			}
		}
	}
	//changes for duplicate check time limit end
	if(continueExecution)
	{
		//code changes for Card status and Card sub type validations
		
		//String statusQuery = "select count(*) noofstatus from usr_0_srm_cbr_invalidstatus where card_status_code ='"+cardStatus+"' and IsActive = 'Y'";
		
		//String subtypeQuery = "select count(*) noofsubtype from usr_0_srm_cbr_invalidproducts where card_product ='"+cardSubType+"' and IsActive = 'Y'";
	
		String statusQuery = "select count(*) noofstatus from usr_0_srm_cbr_invalidstatus with (nolock) where card_status_code =:card_status_code and IsActive = 'Y'";
		
		String subtypeQuery = "select count(*) noofsubtype from usr_0_srm_cbr_invalidproducts with (nolock) where card_product =:card_product and IsActive = 'Y'";
	
		/*String input1 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + statusQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
		
		params="card_status_code=="+cardStatus;
		String input1 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ statusQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		
		WriteLog("input1 CBR"+input1);			
		String output1 = WFCallBroker.execute(input1, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		XMLParser xPData1=new XMLParser();
		String subXML1="";
		XMLParser objXmlParser1=null;
		xPData1.setInputXML(output1);
		String maincode1 = xPData1.getValueOf("MainCode");
		int rc1=0;
		int count1=0;
		if(maincode1.equals("0"))
		{	 
			rc1= Integer.parseInt(xPData1.getValueOf("TotalRetrieved"));
			for(int k=0; k<rc1; k++)
			{	
				subXML1 = xPData1.getNextValueOf("Record");
				objXmlParser1 = new XMLParser(subXML1);
				count1 = Integer.parseInt(objXmlParser1.getValueOf("noofstatus"));
			}
		}
		else
			WriteLog("Error in query execution for getting card status");
		WriteLog("count of records for card status "+count1);	
		
		/*String input2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + subtypeQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
		
		params="card_product=="+cardSubType;
		String input2 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ subtypeQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		
		WriteLog("input2 CBR"+input2);		
		String output2 = WFCallBroker.execute(input2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		XMLParser xPData2=new XMLParser();
		String subXML2="";
		XMLParser objXmlParser2=null;
		xPData2.setInputXML(output2);
		String maincode2 = xPData2.getValueOf("MainCode");
		int rc2=0;
		int count2=0;
		if(maincode2.equals("0"))
		{	 
			rc2= Integer.parseInt(xPData2.getValueOf("TotalRetrieved"));
			for(int k=0; k<rc2; k++)
			{	
				subXML2 = xPData2.getNextValueOf("Record");
				objXmlParser2 = new XMLParser(subXML2);
				count2 = Integer.parseInt(objXmlParser2.getValueOf("noofsubtype"));
			}
		}
		else
			WriteLog("Error in query execution for getting card sub type");	
		WriteLog("count of records for card subtype "+count2);
		
		out.clear();
		out.println(recordcount2+"~"+Approved_Cash_Back_Amount+"~"+count1+"~"+count2+"~"+prime+"~"+cbamount);
	}
}
else if (WSNAME.equals("Q1"))
{
	/*String statusQuery = "select count(*) noofstatus from usr_0_srm_cbr_invalidstatus where card_status_code ='"+cardStatus+"' and IsActive = 'Y'";
	String input = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + statusQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	String statusQuery = "select count(*) noofstatus from usr_0_srm_cbr_invalidstatus with (nolock) where card_status_code =:card_status_code and IsActive = 'Y'";
	params="card_status_code=="+cardStatus;
	String input = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ statusQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
	
	
	WriteLog("input CBR CSU Fetch "+input);	
	String output = WFCallBroker.execute(input, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	XMLParser xPData=new XMLParser();
	String subXMLCSU="";
	XMLParser objXmlParserCSU=null;
	xPData.setInputXML(output);
	String maincode = xPData.getValueOf("MainCode");
	int rc1=0;
	int count=0;
	if(maincode.equals("0"))
	{	 
		rc1= Integer.parseInt(xPData.getValueOf("TotalRetrieved"));
		for(int k=0; k<rc1; k++)
		{	
			subXMLCSU = xPData.getNextValueOf("Record");
			objXmlParserCSU = new XMLParser(subXMLCSU);
			count = Integer.parseInt(objXmlParserCSU.getValueOf("noofstatus"));
		}
		WriteLog("count of records for card status "+count);	
		//out.clear();
		//out.println(count);
	}
	else
		WriteLog("Error in query execution for getting card status at time of CSU Fetch");
	
	//Code block added by Aishwarya for Cash Back Limit Check at CSU
	String cardBin = request.getParameter("CardBin");	
	//statusQuery = "SELECT Cash_Back_Limit FROM USR_0_SRM_CARDS_BIN WHERE Parameter='"+cardBin+"'";
	statusQuery = "SELECT Cash_Back_Limit FROM USR_0_SRM_CARDS_BIN with (nolock) WHERE Parameter=:Parameter";
	params="Parameter=="+cardBin;
	/*input = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + statusQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	input = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ statusQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		
		
	WriteLog("input CBR CSU Fetch cash back limit"+input);	
	output = WFCallBroker.execute(input, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	xPData=new XMLParser();
	objXmlParserCSU=null;
	xPData.setInputXML(output);
	maincode = xPData.getValueOf("MainCode");
	rc1=0;
	String cashBackLimit="";
	if(maincode.equals("0"))
	{	 
		rc1= Integer.parseInt(xPData.getValueOf("TotalRetrieved"));
		for(int k=0; k<rc1; k++)
		{	
			subXMLCSU = xPData.getNextValueOf("Record");
			objXmlParserCSU = new XMLParser(subXMLCSU);
			cashBackLimit = objXmlParserCSU.getValueOf("Cash_Back_Limit");
		}
		WriteLog("cash back limit "+cashBackLimit);		
	
	}
	else
		WriteLog("Error in query execution for getting card status at time of CSU Fetch");
	
	out.clear();
	out.println(count+"~"+cashBackLimit);

}
%>

	