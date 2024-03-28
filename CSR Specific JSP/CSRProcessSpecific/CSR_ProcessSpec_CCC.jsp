<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource,java.sql.PreparedStatement,java.util.ArrayList,java.util.List" %>


<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<script>

function numericapprovalcode(e)
{
	
	var re;
	re = /[^0-9]/g;
	if(re.test(e.value)){
   e.value ="";
  }
	
	return true;
}



function compareName()
{
	if (document.forms[0].CCI_CName.value.toUpperCase()==document.forms[0].BANEFICIARY_NAME.value.toUpperCase()){	
	  alert("Baneficiary Name and Customer Name can't be same.");
	  document.forms[0].BANEFICIARY_NAME.value='';
	  document.forms[0].BANEFICIARY_NAME.focus();
	}
}
/*

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CCC_SaveDone.js
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/069	CheckMxLength  Saurabh Arora
*/
function CheckMxLength(data,val)
{
	var issue=data.value;
	if(issue.length>=val+1)
	{
		alert("Remarks/Reasons can't be greater than 500 Characters");
		var lengthRR="";
		lengthRR=issue.substring(0,val);
		data.value=lengthRR;
		
	}
	return true;
}

function chkVerificationDet()
{
	
	if (document.forms[0].VD_MoMaidN.checked==false && document.forms[0].VD_TINCheck.checked==false)
	{
		alert("Enter Verification Details");
        document.forms[0].VD_TINCheck.focus();
    }
}

function enabledisable()
{
	
	if (document.forms[0].DELIVERTO.options[document.forms[0].DELIVERTO.selectedIndex].value.toUpperCase()=='BANK')
	{
		document.forms[0].BRANCHCODE.disabled=false;
		document.forms[0].BRANCHCODE.focus();
    }
	else
	{
		document.forms[0].BRANCHCODE.selectedIndex=0;
		document.forms[0].BRANCHCODE.disabled=true;
        
	}
} 
function AddPendingOptions(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptions');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelected');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+'Pending option is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
			if(selectedValueId=='PendingOptionsSelected'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelected');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";
					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
		}
function RemovePendingOptions(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelected');
	if(element.options.length==0)
		alert('No Pending Option to Remove');
	else if(element.selectedIndex==-1 && element.options.length!=0)
		alert('Select a Pending option to remove');
	else
	{
		var len=element.options.length;
		for(i=len-1;i>=0;i--)
		{
			if(element.options[i] != null && element.options[i].selected)
			{
				element.options[i]=null;
			}
		}
	}
	if(selectedValueId=='PODOptionsSeleceted'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelected');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
	}
}
function enabletextbox(e)
{
if (e.name=='CARDNO1'){
	if (document.forms[0].CARDNO1.options[document.forms[0].CARDNO1.selectedIndex].value.toUpperCase()!='')
	{
    document.forms[0].CHQ_AMOUNT1.disabled=false;
    document.forms[0].ApprovalCode1.disabled=false;
    }
	else {
    document.forms[0].CHQ_AMOUNT1.value='';
    document.forms[0].ApprovalCode1.value='';
	document.forms[0].CHQ_AMOUNT1.disabled=true;
    document.forms[0].ApprovalCode1.disabled=true;
	}
}
if (e.name=='CARDNO2'){
	if (document.forms[0].CARDNO2.options[document.forms[0].CARDNO2.selectedIndex].value.toUpperCase()!='')
	{
    document.forms[0].CHQ_AMOUNT2.disabled=false;
    document.forms[0].ApprovalCode2.disabled=false;
    }
	else {
    document.forms[0].CHQ_AMOUNT2.value='';
    document.forms[0].ApprovalCode2.value='';
	document.forms[0].CHQ_AMOUNT2.disabled=true;
    document.forms[0].ApprovalCode2.disabled=true;
	}
}
if (e.name=='CARDNO3'){
	if (document.forms[0].CARDNO3.options[document.forms[0].CARDNO3.selectedIndex].value.toUpperCase()!='')
	{
    document.forms[0].CHQ_AMOUNT3.disabled=false;
    document.forms[0].ApprovalCode3.disabled=false;
    }
	else {
    document.forms[0].CHQ_AMOUNT3.value='';
    document.forms[0].ApprovalCode3.value='';
	document.forms[0].CHQ_AMOUNT3.disabled=true;
    document.forms[0].ApprovalCode3.disabled=true;
	}
}
}
</script>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	String sUserName = null;
	int iJtsPort = 0;
	boolean bError=false;
	String sRAKBankCard="";
	String sCardType="";
	String sExpDate="";
	String sBTAmt="";
	String sAppCode="";
	Hashtable ht=new Hashtable();
	String sOutputXMLCustomerInfoList ="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	String sBranchDetails="";
	int iCardCount=0;
	String sOutputXMLCustomerInfo ="";
	String sTempCardsList="";

	Hashtable CAPDataHT=new Hashtable();
	int iCAPSCardCount=0;
	int i=1;
	String sTempCardDetails="";
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId CCB: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1 CCB: "+request.getParameter("ProcessInstanceId"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CrdtCN", request.getParameter("CrdtCN"), 1000, true) );
	String CrdtCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	WriteLog("Integration jsp: CrdtCN CCB: "+CrdtCN);

	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);

	
	try{
		
		WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		sSessionId    = wDUserInfo.getM_strSessionId();
		sJtsIp = wDCabinetInfo.getM_strServerIP();
		iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		sUserName = wDUserInfo.getM_strUserName()+"";
		WriteLog("suserName :"+sUserName);
	}catch(Exception ignore){
		bError=true;
		WriteLog(ignore.toString());
	}	
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
	}
	else
	{
		if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))
		{
				String sInputXML ="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>rb_get_request_status_mapp</ProcName>" +						
						"<Params>'Card Service Request - Credit Card Cheque'</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";
				String sMappOutPutXML="";
				WriteLog("manish   mmm :"+sInputXML);
				
				try
				{
					 sMappOutPutXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog(sMappOutPutXML);
					if(sMappOutPutXML.equals("") || Integer.parseInt(sMappOutPutXML.substring(sMappOutPutXML.indexOf("<MainCode>")+10 , sMappOutPutXML.indexOf("</MainCode>")))!=0)	{
						bError= true;
					}
				}catch(Exception exp){
					bError=true;
				}
				String sMapping = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<Results>")+9,sMappOutPutXML.indexOf("</Results>"));
				
				//String sSQL = "";
				//need to comment below code for Offshore and uncomment for Onshore 
				Connection conn = null;
				//Statement stmt =null;
				PreparedStatement stmt=null;
				ResultSet result=null;
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					//stmt = conn.createStatement();
					
					String sSQL = "";
/*
	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CSR_ProcessSpec_CCC.jsp
	Purpose         :       A table specifying GENSTAT of each card which will specify the only cards respective to each process that can get introduced.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/011					09/09/2008	 Saurabh Arora
*/
					if(!sMapping.equals("")){
						//Changed by Amandeep for CAPS database change
						//sSQL = "select creditcardno,CARDTYPE,substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3)))  from capsmain where elitecustomerno=(select elitecustomerno from capsmain where creditcardno='"+CrdtCN and substring(CREDITCARDNO,14,1)='0' and generalstat in ("+sMapping+")";
						
						//Replacing single qoutes from sMapping fields
						sMapping=sMapping.replaceAll("'", "");
						WriteLog("sMapping..."+sMapping);
						String[] sMappingArray=sMapping.split(",");
						List<String> cardList = new ArrayList<String>();
						for(int k=0;k<sMappingArray.length;k++)
						{
							cardList.add(sMappingArray[k]);
						}
						StringBuilder builder=new StringBuilder();
						for(int j=0;j<cardList.size();j++)
						{
							builder.append("?,");
						}
						
						
						//old query
						//sSQL = "select creditcardno,CARDTYPE,substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy')))  from CAPSADMIN.capsmain where generalstat in ("+builder.deleteCharAt(builder.length()-1).toString()+") and elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno=?) and substr(CREDITCARDNO,14,1)='0'";
						
						//new query
						sSQL = "select c.creditcardno,CARDTYPE,substr(to_char(c.EXPIRYDATE,'dd/mm/yy'),4,length(to_char(c.EXPIRYDATE,'dd/mm/yy'))) from CAPSADMIN.capsmain cm inner join CAPSADMIN.cards c on c.crnno=cm.crnno and c.creditcardno=cm.creditcardno where c.generalstat in ("+builder.deleteCharAt(builder.length()-1).toString()+") and elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno=?) and c.primarycard='1'";
						
						WriteLog("Query..."+sSQL);
						
						stmt = conn.prepareStatement(sSQL);
						int index=1;            
						for(Object o:cardList)
						{
							stmt.setObject(index++, o);
						}
						stmt.setString(index, CrdtCN);
						
					}
					else{
						//sSQL = "select creditcardno,CARDTYPE,substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3)))  from capsmain where elitecustomerno=(select elitecustomerno from capsmain where creditcardno='"+CrdtCN+"') and  substring(CREDITCARDNO,14,1)='0'";
						//old query
						//sSQL = "select creditcardno,CARDTYPE,substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy')))  from CAPSADMIN.capsmain where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno=?) and  substr(CREDITCARDNO,14,1)='0'";
						
						//new query
						sSQL = "select c.creditcardno,CARDTYPE,substr(to_char(c.EXPIRYDATE,'dd/mm/yy'),4,length(to_char(c.EXPIRYDATE,'dd/mm/yy'))) from CAPSADMIN.capsmain cm inner join CAPSADMIN.cards c on c.crnno=cm.crnno and c.creditcardno=cm.creditcardno where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno=?) and c.primarycard='1'";
						
						stmt = conn.prepareStatement(sSQL);
						stmt.setString(1, CrdtCN);
					}

					
					WriteLog("Execute Query...");
					
					
					result = stmt.executeQuery();
					
					while (result.next()) {
						String sValue = result.getString(1);					
						if(sTempCardDetails.equals(""))
							sTempCardDetails=sValue;
						else
							sTempCardDetails=sTempCardDetails+sValue;
						CAPDataHT.put("RAKBankCard"+i,sValue);
						sValue = result.getString(2);
						sTempCardDetails=sTempCardDetails+"!"+sValue;
						CAPDataHT.put("CardType"+i,sValue);					
						sValue = result.getString(3);
						sTempCardDetails=sTempCardDetails+"!"+sValue;
						CAPDataHT.put("ExpDate"+i,sValue);
						sTempCardDetails=sTempCardDetails+"!";
						i++;
					}					
					iCAPSCardCount=i-1;
					sTempCardDetails=iCAPSCardCount+"@"+sTempCardDetails;
					WriteLog("sTempCardDetails---|"+sTempCardDetails);
					if(result != null)
					{
						result.close();
						result=null;
						WriteLog("resultset Successfully closed"); 
					}
					if(stmt != null)
					{
						stmt.close();
						stmt=null;						
						WriteLog("Stmt Successfully closed"); 
					}
					if(conn != null)
					{
						conn.close();
						conn=null;	
						WriteLog("Conn Successfully closed"); 
					}
				}
				catch (Exception e)
				{
					WriteLog(e.toString());
					if(e.getClass().toString().equalsIgnoreCase("Class javax.naming.NameNotFoundException"))
					out.println("<script>alert(\"Data Source For CAPS System Not Found\")</script>");

					if(e.toString().indexOf("Operation timed out: connect:could be due to invalid address")!=-1)
					out.println("<script>alert(\"Unable to connect to CAPS System\")</script>");
				}
				finally
				{
					if(result != null)
					{
						result.close();
						result=null;
						WriteLog("resultset Successfully closed"); 
					}
					if(stmt != null)
					{
						stmt.close();
						stmt=null;						
						WriteLog("Stmt Successfully closed"); 
					}
					if(conn != null)
					{
						conn.close();
						conn=null;	
						WriteLog("Conn Successfully closed"); 
					}
				}
				
				//Below code used only for Offshore Testing******************************
				/*String sValue = "5564458554252541";					
				if(sTempCardDetails.equals(""))
					sTempCardDetails=sValue;
				else
					sTempCardDetails=sTempCardDetails+sValue;
				CAPDataHT.put("RAKBankCard"+i,sValue);
				sValue = "D";
				sTempCardDetails=sTempCardDetails+"!"+sValue;
				CAPDataHT.put("CardType"+i,sValue);					
				sValue = "01/00";
				sTempCardDetails=sTempCardDetails+"!"+sValue;
				CAPDataHT.put("ExpDate"+i,sValue);
				sTempCardDetails=sTempCardDetails+"!";
				i++;
								
				iCAPSCardCount=i-1;
				sTempCardDetails=iCAPSCardCount+"@"+sTempCardDetails;
				WriteLog("sTempCardDetails---|"+sTempCardDetails);
				WriteLog("resultset Successfully closed");
				*/
				//************************************************************************
		}
		else
		{			
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId><WorkitemId>1</WorkitemId><QueueId></QueueId><QueueType></QueueType><DocOrderBy></DocOrderBy><DocSortOrder></DocSortOrder><ObjectPreferenceList>W,D</ObjectPreferenceList><GenerateLog>Y</GenerateLog><ZipBuffer></ZipBuffer></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("MAnish1234567788909---345345345-"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
			WriteLog("strOutputXMLCat1---345345345-"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 	
			
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  				
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());				  		
				  WriteLog("testing" + objWorkList.getVal("Name").toString()+"======="+objWorkList.getVal("Value").toString());
			}
			sOutputXMLCustomerInfoList=DataFormHT.get("cardDetails").toString();
	WriteLog("testing100001111"+DataFormHT.get("cardDetails").toString() );
			int iStartIndex=0;
			int iEndIndex=sOutputXMLCustomerInfoList.indexOf("!");		
			i=0;
		WriteLog("testing1133"+sOutputXMLCustomerInfoList );	iCAPSCardCount=Integer.parseInt(sOutputXMLCustomerInfoList.substring(0,sOutputXMLCustomerInfoList.indexOf("@")));
		WriteLog("testing12" );	sOutputXMLCustomerInfoList=sOutputXMLCustomerInfoList.substring(sOutputXMLCustomerInfoList.indexOf("@")+1,sOutputXMLCustomerInfoList.length());

			WriteLog("iCAPSCardCount"+iCAPSCardCount);
			WriteLog("sOutputXMLCustomerInfoList: "+sOutputXMLCustomerInfoList);
			
			for( i=1;i<=iCAPSCardCount;i++)
			{
				if(i==1)
				{
					iStartIndex=-1;
					iEndIndex=sOutputXMLCustomerInfoList.indexOf("!");		
				}
				else
				{
					iStartIndex=iEndIndex;
					iEndIndex=sOutputXMLCustomerInfoList.indexOf("!",iStartIndex+1);		
				}
				WriteLog("saaa======="+iEndIndex);
				sRAKBankCard=sOutputXMLCustomerInfoList.substring(iStartIndex+1,iEndIndex);
				
				CAPDataHT.put("RAKBankCard"+i,sRAKBankCard);
				WriteLog("RAKBankCard"+i+"----"+sRAKBankCard);
				iStartIndex=iEndIndex;
				iEndIndex=sOutputXMLCustomerInfoList.indexOf("!",iStartIndex+1);		
				sCardType=sOutputXMLCustomerInfoList.substring(iStartIndex+1,iEndIndex);
				CAPDataHT.put("CardType"+i,sCardType);
				WriteLog("CardType"+i+"-----"+sCardType);
				iStartIndex=iEndIndex;
				iEndIndex=sOutputXMLCustomerInfoList.indexOf("!",iStartIndex+1);
				sExpDate=sOutputXMLCustomerInfoList.substring(iStartIndex+1,iEndIndex);
				CAPDataHT.put("ExpDate"+i,sExpDate);
				WriteLog("ExpDate"+i+"---"+sExpDate);			
			}		
	}		




		

		try{
			String Query="select branchid,branchname from rb_branch_details where 1=:ONE";
			String params ="ONE==1";
			String sInputXML =	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("sacs111");
			sBranchDetails= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sBranchDetails + "sacs");
			if(sBranchDetails.equals("") || Integer.parseInt(sBranchDetails.substring(sBranchDetails.indexOf("<MainCode>")+10 , sBranchDetails.indexOf("</MainCode>")))!=0)
			{
				
			}
			else{
				
			}
		}catch(Exception exp){
			WriteLog(exp.toString());
		}

%>

<%


	
%>

		<SCRIPT LANGUAGE ="javascript">
				 var currency = new Array();
				// var tempArrayValue=new Array();
			//	 var tempArrayText=new Array();
		</script>
<%
	i=0;
	for(i=1;i<=iCAPSCardCount;i++){   
%>
		<SCRIPT LANGUAGE ="javascript">
		currency[<%=i%>] = '<%=CAPDataHT.get("RAKBankCard"+i)%>' + "#" + '<%=CAPDataHT.get("CardType"+i)%>' + "#" + '<%=CAPDataHT.get("ExpDate"+i)%>' ;
		</script>
<%  }
%>
<script>



function setRelatedData(cardNo,cntrl)
{

if(cntrl.selectedIndex)
	{
	var data=currency[cntrl.selectedIndex];
	var iStartIndex=0;
	var iEndIndex=data.indexOf("#");
	var	sCustomerName=data.substring(iStartIndex,iEndIndex);
		iStartIndex=iEndIndex;
		iEndIndex=data.indexOf("#",iStartIndex+1);		
	var	sCardType=data.substring(iStartIndex+1,iEndIndex);
	if(sCardType == "L")
		{
			
			alert("RAKBANK Card Type L is not allowed.");
			if(cardNo == 1)
			{
				//alert(document.getElementById("CARDNO1").selectedIndex);
			document.getElementById("CARDNO1").selectedIndex=0;
			}else if(cardNo == 2){
				//alert(document.getElementById("CARDNO2").selectedIndex);
				document.getElementById("CARDNO2").selectedIndex=0;
			}else if(cardNo == 3){
				//alert(document.getElementById("CARDNO3").selectedIndex);
				document.getElementById("CARDNO3").selectedIndex=0;
			}
				//alert("cntrl "+ cntrl);
	            //alert("cardNo "+ cardNo);
			setRelatedData(cardNo,cntrl);
			return false;
		}
	eval("window.document.forms[\"dataform\"].CARDTYPE"+cardNo+".value="+"\""+sCardType+"\"");
		iStartIndex=iEndIndex;
		iEndIndex=data.indexOf("#",iStartIndex+1);
	var	sExpDate=data.substring(iStartIndex+1,data.length);
	eval("window.document.forms[\"dataform\"].CARDEXPIRY_DATE"+cardNo+".value="+"\""+sExpDate+"\"");	
	}else
	{
		eval("window.document.forms[\"dataform\"].CARDTYPE"+cardNo+".value="+"\"\"");
		eval("window.document.forms[\"dataform\"].CARDEXPIRY_DATE"+cardNo+".value="+"\"\"");
	}
}
</script>


<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("")){%>
<input type=text readOnly name="cardDetails" id="cardDetails" value='<%=sTempCardDetails%>' style='display:none'>
<%}%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='CCC (Credit Card Cheque) Details'>
		<td colspan=4 align=left class="EWLabelRB2"><b>CCC (Credit Card Cheque) Details </b></td>
	</tr>	

	<TR>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CSR_ProcessSpec_CCC.jsp
	Purpose         :       The beneficiary name should have a limit of 50 characters for entry into the host system.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/007					02/09/2008	 Saurabh Arora
 -->
	 <td nowrap width="140" height="16" class="EWLabelRB" id="BANEFICIARY_NAME" >Beneficiary Name</td>
	 <td nowrap  width="180" colspan=3><input type="text" name="BANEFICIARY_NAME" value='<%=DataFormHT.get("BANEFICIARY_NAME")==null?"":DataFormHT.get("BANEFICIARY_NAME")%>' size="50" maxlength=50
	 style='width:340px;' onkeyup=validateKeys(this,'CSR_CCC') onfocus=chkVerificationDet() onblur=compareName() ></td>
    </tr>

	<TR>

<!-- 

	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CSR_ProcessSpec_CCC.jsp
	Purpose         :       The delivery option dropwdown contains the item 'others' which provides no additional information. This is not needed and needs to be removed.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/004					02/09/2008	 

 -->	

         <td nowrap width="140" height="16" class="EWLabelRB" id="C_DELIVERTO">Deliver To</td>
         <td nowrap width="180">
			<select name="DELIVERTO" onblur=enabledisable()>
				<option value="">--select--</option>
				<option value="Bank">Bank</option>
				<option value="Courier">Courier</option>
				<!--<option value="Personal pickup">Personal pickup</option>-->

			</select>
		</td>
		 <td nowrap width="100" height="16" class="EWLabelRB" id="C_BRANCHCODE">Branch Name</td>
        <td nowrap  width="180" >
		<select name="BRANCHCODE" disabled>
		<option value="">--Select--</option>
		<% if(sBranchDetails.indexOf("<Record>")!=-1)
				{
					WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
					WFXmlList RecordList1;
					for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
					{
						String sBranchId=RecordList1.getVal("branchid");
						String sBranchName=RecordList1.getVal("branchname");
						out.println("<option value=\""+sBranchId+"\">"+sBranchName+"</option>");
//						WriteLog("sBranchId---"+sBranchId+"     sBranchName-----"+sBranchName);
					}
				}%>
		</select>
		<!-- <input type="text" name="BTD_OBC_BN" value='<%=DataFormHT.get("BTD_OBC_BN")==null?"":DataFormHT.get("BTD_OBC_BN")%>' size="8" maxlength=8 style='width:150px;' > --></td>

</tr>

<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="C_CARDNO1">RAKBANK card no.</td>
				
        <td nowrap  width="180">
			<select name="CARDNO1" id="CARDNO1" onblur="enabletextbox(this)" onchange="setRelatedData(1,this);">
				<option>--select--</option>				
				 <%	
				 for( i=1;i<=iCAPSCardCount;i++)
				 {
				out.println("<option value='"+CAPDataHT.get("RAKBankCard"+i)+"'>"+CAPDataHT.get("RAKBankCard"+i).toString().substring(0,4)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(4,8)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(8,12)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(12,16)+"</option>");
				 }				   
				%>  
			</select>
		</td>
		<td nowrap width="180">
		<input type="text"  style='display:none' >   
			<select  name="CARDNO2" id="CARDNO2" onblur="enabletextbox(this)" onchange="setRelatedData(2,this);">
				<option>--select--</option>
				<%	
				 for( i=1;i<=iCAPSCardCount;i++)
				 {
				out.println("<option value='"+CAPDataHT.get("RAKBankCard"+i)+"'>"+CAPDataHT.get("RAKBankCard"+i).toString().substring(0,4)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(4,8)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(8,12)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(12,16)+"</option>");
				 }			   
				%>
			</select>
		</td>
		<td nowrap  width="180">
		<input type="text" id="C_CARDNO3" style='display:none' >  
			<select   name="CARDNO3" id="CARDNO3" onblur="enabletextbox(this)" onchange="setRelatedData(3,this);">
				<option>--select--</option>
				<%	
				 for( i=1;i<=iCAPSCardCount;i++)
				 {
				out.println("<option value='"+CAPDataHT.get("RAKBankCard"+i)+"'>"+CAPDataHT.get("RAKBankCard"+i).toString().substring(0,4)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(4,8)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(8,12)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(12,16)+"</option>");
				 }			   
				%>
			</select>
		</select></td>
	</tr>


	<TR>
         <td nowrap width="140" height="1" id ="CARDTYPE1" class="EWLabelRB">Card Type</td>
        <td nowrap width="180"><input type="text"  name="CARDTYPE1" value='<%=DataFormHT.get("CARDTYPE1")==null?"":DataFormHT.get("CARDTYPE1")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>
        <td nowrap  width="180"><input type="text" name="CARDTYPE2" id ="CARDTYPE2" value='<%=DataFormHT.get("CARDTYPE2")==null?"":DataFormHT.get("CARDTYPE2")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>
		<td nowrap  width="180"><input type="text" name="CARDTYPE3" id ="CARDTYPE3" value='<%=DataFormHT.get("CARDTYPE3")==null?"":DataFormHT.get("CARDTYPE3")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>		 
	</tr>
	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="CARDEXPIRY_DATE1" >Expiry Date</td>
        <td nowrap width="180"><input type="text" name="CARDEXPIRY_DATE1"  value='<%=DataFormHT.get("CARDEXPIRY_DATE1")==null?"":DataFormHT.get("CARDEXPIRY_DATE1")%>' size="8" maxlength=5 style='width:150px;'disabled=true></td>
        <td nowrap  width="180"><input type="text" name="CARDEXPIRY_DATE2" id="CARDEXPIRY_DATE2" value='<%=DataFormHT.get("CARDEXPIRY_DATE2")==null?"":DataFormHT.get("CARDEXPIRY_DATE2")%>' size="8" maxlength=5 style='width:150px;'disabled=true></td>
		<td nowrap  width="180"><input type="text" name="CARDEXPIRY_DATE3" id="CARDEXPIRY_DATE3" value='<%=DataFormHT.get("CARDEXPIRY_DATE3")==null?"":DataFormHT.get("CARDEXPIRY_DATE3")%>' size="8" maxlength=5 style='width:150px;' disabled=true></td>		 
	</tr>
	<TR>
         <td nowrap width="100" height="16" class="EWLabelRB" id="CHQ_AMOUNT1" >Cheque Amount</td>
        <td nowrap width="180"><input type="text" name="CHQ_AMOUNT1"   value='<%=DataFormHT.get("CHQ_AMOUNT1")==null?"":DataFormHT.get("CHQ_AMOUNT1")%>' size="11" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_CCC') onblur=validateKeys_OnBlur(this,'CSR_CCC') disabled></td>
        <td nowrap  width="180"><input type="text" name="CHQ_AMOUNT2" id="CHQ_AMOUNT2" value='<%=DataFormHT.get("CHQ_AMOUNT2")==null?"":DataFormHT.get("CHQ_AMOUNT2")%>' size="11" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_CCC') onblur=validateKeys_OnBlur(this,'CSR_CCC') disabled ></td>
		<td nowrap  width="180"><input type="text" name="CHQ_AMOUNT3" id="CHQ_AMOUNT3" value='<%=DataFormHT.get("CHQ_AMOUNT3")==null?"":DataFormHT.get("CHQ_AMOUNT3")%>' size="11" maxlength=11 style='width:150px;'onkeyup=validateKeys(this,'CSR_CCC') onblur=validateKeys_OnBlur(this,'CSR_CCC') disabled ></td>		 
	</tr>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Credit Card Cheque
	File            :       CSR_ProcessSpec_CCC.jsp
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/006					02/09/2008	 

 -->
	<TR>
        <td nowrap width="100" height="16" class="EWLabelRB" id="ApprovalCode1">Approval Code</td>
        <td nowrap width="180"><input type="text"  name="ApprovalCode1"  value='<%=DataFormHT.get("ApprovalCode1")==null?"":DataFormHT.get("ApprovalCode1")%>' size="6" maxlength=6 style='width:150px;' onkeyup=numericapprovalcode(this) disabled ></td>
        <td nowrap  width="180"><input type="text" name="ApprovalCode2" id="ApprovalCode2" value='<%=DataFormHT.get("ApprovalCode2")==null?"":DataFormHT.get("ApprovalCode2")%>' size="6" maxlength=6 style='width:150px;'onkeyup=numericapprovalcode(this) disabled ></td>
		<td nowrap  width="180"><input type="text" name="ApprovalCode3" id="ApprovalCode3" value='<%=DataFormHT.get("ApprovalCode3")==null?"":DataFormHT.get("ApprovalCode3")%>' size="6" maxlength=6 style='width:150px;' onkeyup=numericapprovalcode(this) disabled ></td>		 
	</tr>
	
	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="REMARKS" >Remarks/ Reason</td> 
        <td nowrap  width="180" colspan=3><textarea name="REMARKS"  cols=50 rows=2 onKeyup="CheckMxLength(this,500);" ><%=DataFormHT.get("REMARKS")==null?"":DataFormHT.get("REMARKS")%></textarea></td>
	</tr>
	<TR>
		<td nowrap width="160" height="30" class="EWLabelRB"  id="CSR_CCC_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptions" style="width: 160;" name="PendingOptions" >
								<option value="">--select--</option>
								<option value="Travel Document">Travel Document</option>
								<option value="Medical Report">Medical Report</option>
								<option value="TT Swift Copy">TT Swift Copy</option>
								<option value="Payment Receipt">Payment Receipt</option>
								<option value="Application Screenshot">Application Screenshot</option>
								<option value="Tenancy Contract">Tenancy Contract </option>
								<option value="Salary Certificate">Salary Certificate</option>
								<option value="Bank Statement">Bank Statement</option>
								<option value="PaySlip">PaySlip</option>
								<option value="Emirates ID Copy">Emirates ID Copy</option>
								<option value="Passport Copy">Passport Copy</option>
								<option value="Visa Copy">Visa Copy</option>
								<option value="Salary Transfer Letter">Salary Transfer Letter</option>
								<option value="Labour Contract">Labour Contract</option>
								<option value="Transaction Receipt">Transaction Receipt</option>
								<option value="Lifestyle Declaration">Lifestyle Declaration</option>
								<option value="Others">Others</option>
								</select>
					</td>
					<td  nowrap='nowrap' height ='30' width = 180 class='EWNormalGreenGeneral1' valign="middle"> 
						<input type="button" id="addButtonPendingOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptions('PendingOptions','PendingOptionsSelected');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptions('PendingOptions','PendingOptionsSelected');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelected'  name='PendingOptionsSelected' multiple='multiple' style="width:150px">
						</select>
					</td>
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>

</table>
<%}%>

<%
if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){
	if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Pending"))
	{
	%>		
		<table>
			<tr>
				<td nowrap width="100" height="16" class="EWLabelRB" id="Pending_Dec">Pending Decision</td>
				<td nowrap width="180">
					<select name="Pending_Decision">
						<option value="P_Approve">Approve</option>
						<option value="P_Discard">Discard</option>
					</select>
				</td>
			</tr>
		</table>
	<%	
	}
if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS"))
{%>
		<input type=text readOnly name="Card_UserName" id="Card_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="Card_DateTime" id="Card_DateTime" value='<%=sDate%>' style='display:none'>
<%}
else if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Approver"))
{%>
		<input type=text readOnly name="BA_UserName" id="BA_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BA_DateTime" id="BA_DateTime" value='<%=sDate%>' style='display:none'>
<%}
else if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Pending")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Return"))
{%>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}
 }
 else
 {%>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}%>