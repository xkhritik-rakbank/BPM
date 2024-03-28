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

<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>



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
						sDropDownValue = sDropDownValue + opt.value + "|";
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
	if (document.forms[0].BTD_OBC_DT.options[document.forms[0].BTD_OBC_DT.selectedIndex].value.toUpperCase()=='BANK')
	{
		document.forms[0].BTD_OBC_BN.disabled=false;
		document.forms[0].BTD_OBC_BN.focus();
    }
	else
	{
		document.forms[0].BTD_OBC_BN.selectedIndex=0;
		document.forms[0].BTD_OBC_BN.disabled=true;
	}

	if(document.forms[0].BTD_OBC_CT.options[document.forms[0].BTD_OBC_CT.selectedIndex].value.toUpperCase()=="OTHERS"||document.forms[0].BTD_OBC_OBN.options[document.forms[0].BTD_OBC_OBN.selectedIndex].value.toUpperCase()=="OTHERS")
	{
		document.forms[0].BTD_OBC_OBNO.disabled=false;		
	}
	else
	{
		document.forms[0].BTD_OBC_OBNO.value="";
		document.forms[0].BTD_OBC_OBNO.disabled=true;		
	}
}

var flag=0;



function validate(cntrl)
{
	if(cntrl.value=="")
	return false;
	if(flag==1)
	{
		flag=0;
		return false;
	}
//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 29-Feb-2008
//Description                : This field Other Bank Card must accept 15 as well as 16 digits as Amex Cards are 15 digit cards .
//------------------------------------------------------------------------------------------------------------------------------------>
	try{	
		//alert("len "+replaceAll(cntrl.value,"-","").length)
		if(replaceAll(cntrl.value,"-","").length==15)
		{
				regex=/^[0-9]{15}$/;
			//alert("1 "+regex.test(replaceAll(cntrl.value,"-","")))
				//alert("2  "+regex.test(cntrl.value))
				//alert("!mod10( replaceAll(cntrl.value,"-","")) "+!mod10( replaceAll(cntrl.value,"-","")))
				//alert("replaceAll(cntrl.value,"-","") "+replaceAll(cntrl.value,"-",""))
				//alert("window.document.forms["dataform"].CCI_CrdtCN.value "+window.document.forms["dataform"].CCI_CrdtCN.value)
			if(!regex.test(replaceAll(cntrl.value,"-","")))
			{
				alert("Length Of Credit Card No Should be exactly 15 or 16 digits.");
				cntrl.value="";
				cntrl.focus();
				return false;
			}

			var regex=/^[0-9]{15}$/;
			if(regex.test(cntrl.value))
			{
				//alert("Only Numerics are allowed in Credit Card No");

				var vCCN=cntrl.value;
				cntrl.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,15);
				return false;
			}	
			
			regex=/^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}$/;
			if(!regex.test(cntrl.value))
			{
				alert("Invalid Credit Card No Format");
				cntrl.value="";
				cntrl.focus();
				return false;
			}
			if(!mod10( replaceAll(cntrl.value,"-","")))
			{
				alert("Invalid Credit Card No.");
				cntrl.value="";			
				cntrl.focus();
				return false;
			}		
			if(replaceAll(cntrl.value,"-","")==window.document.forms["dataform"].CCI_CrdtCN.value)
			{
				alert("Both the Credit Card Numbers can't be same");
				cntrl.value="";
				cntrl.focus();
				return false;
			}
		}
		else
		{
				regex=/^[0-9]{16}$/;
			//alert("1 "+regex.test(replaceAll(cntrl.value,"-","")))
				//alert("2  "+regex.test(cntrl.value))
				//alert("!mod10( replaceAll(cntrl.value,"-","")) "+!mod10( replaceAll(cntrl.value,"-","")))
				//alert("replaceAll(cntrl.value,"-","") "+replaceAll(cntrl.value,"-",""))
				//alert("window.document.forms["dataform"].CCI_CrdtCN.value "+window.document.forms["dataform"].CCI_CrdtCN.value)
			if(!regex.test(replaceAll(cntrl.value,"-","")))
			{
				alert("Length Of Credit Card No Should be exactly 15 or 16 digits.");
				cntrl.value="";
				cntrl.focus();
				return false;
			}

			var regex=/^[0-9]{16}$/;
			if(regex.test(cntrl.value))
			{
				//alert("Only Numerics are allowed in Credit Card No");

				var vCCN=cntrl.value;
				cntrl.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
				return false;
			}	
			
			regex=/^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/;
			if(!regex.test(cntrl.value))
			{
				alert("Invalid Credit Card No Format");
				cntrl.value="";
				cntrl.focus();
				return false;
			}
			if(!mod10( replaceAll(cntrl.value,"-","")))
			{
				alert("Invalid Credit Card No.");
				cntrl.value="";			
				cntrl.focus();
				return false;
			}		
			if(replaceAll(cntrl.value,"-","")==window.document.forms["dataform"].CCI_CrdtCN.value)
			{
				alert("Both the Credit Card Numbers can't be same");
				cntrl.value="";
				cntrl.focus();
				return false;
			}
		}

/*
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       RAKBANK card is being accepted for Balance Transfer and should not be allowed for this functionality.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/002					05/09/2008	 Saurabh Arora
*/
		if (cntrl.value=="")
		{
		}
		else
		{
			var url="CSR_Rak_BT.jsp?rakCard=" + cntrl.value;
			var features="dialogHeight:0px;dialogWidth:0px;dialogTop:0px;dialogLeft:0px;";
			var ReturnVal = window.showModalDialog(url, '', features);
			if (ReturnVal.toUpperCase()=="FAIL")
			{
				alert("Rak Bank Cards are not allowed in Other Bank Card No. Field");
				cntrl.value="";
				cntrl.focus();
				return false;
			}		
		}
		
		return true;
	}catch(e){
		alert(e.message);
	}

}
/*

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/068				   Saurabh Arora
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
function mod10( cardNumber ) 
{ 	
           var clen = new Array( cardNumber.length ); 
           var n = 0,sum = 0; 
           for( n = 0; n < cardNumber.length; ++n ) 
		      { 
                      clen [n] = parseInt ( cardNumber.charAt(n) ); 
			  } 
          for( n = clen.length -2; n >= 0; n-=2 ) 
				{
					  clen [n] *= 2; 	
			          if( clen [n] > 9 ) 
				          clen [n]-=9; 
				}
	     for( n = 0; n < clen.length; ++n ) 
		        { 
					  sum += clen [n]; 
		        } 
		 return(((sum%10)==0)?true : false);
}

function validateCCN(cntrl)
{
	//alert("2"+cntrl.value);
	var keycode=event.keyCode;
	var cntrlValue=cntrl.value;
	if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
		cntrl.value=cntrlValue+"-";
}
function validateCCNDataOnKeyUp(cntrl)
{
//alert("keyup "+cntrl.value);
	var regex=/^[0-9]{16}$/;
		if(regex.test(cntrl.value))
		{
			//alert("Only Numerics are allowed in Credit Card No");

			var vCCN=cntrl.value;
			cntrl.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
			return false;
		}	


	var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	
	var keycode=event.keyCode;	if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
		{
		flag=1;
		alert("Invalid Credit Card No. Format");
		cntrl.value="";		
		cntrl.focus();
		return false;
		}		
}
function replaceAll(data,searchfortxt,replacetxt)
{
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+1,data.length);
	}	
	return data;
}

</script>

<%
	WriteLog("Inside CSR_ProcessSpec_BT.jsp");
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
	WriteLog("Integration jsp: ProcessInstanceId BT: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1 BT: "+request.getParameter("ProcessInstanceId"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CrdtCN", request.getParameter("CrdtCN"), 1000, true) );
	String CrdtCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	WriteLog("Integration jsp: CrdtCN BT: "+CrdtCN);

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
		out.println("window.parent.close();"); 
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
						"<Params>'Card Service Request - Balance Transfer'</Params>" +  
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

				WriteLog("kaushal verma  mmm :"+sMappOutPutXML);
				
				//need to comment below code for Offshore and uncomment for Onshore 
				Connection conn = null;
				Statement stmt =null;
				ResultSet result=null;
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					stmt = conn.createStatement();
/*
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       A table specifying GENSTAT of each card which will specify the only cards respective to each process that can get introduced.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/010					09/09/2008	 Saurabh Arora
*/
					String sSQL = "";
					if(!sMapping.equals("")){
						//Changed by Amandeep for CAPS database change
						//sSQL = "select creditcardno,CARDTYPE,substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3)))  from capsmain where elitecustomerno=(select elitecustomerno from capsmain where creditcardno='"+CrdtCN+"') and substring(CREDITCARDNO,14,1)='0' and generalstat in ("+sMapping+")";
						//old query
						//sSQL = "select creditcardno,CARDTYPE,substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy')))  from CAPSADMIN.capsmain where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno='"+CrdtCN+"') and substr(CREDITCARDNO,14,1)='0' and generalstat in ("+sMapping+")";
						
						//new query
						sSQL = "select c.creditcardno,CARDTYPE,substr(to_char(c.EXPIRYDATE,'dd/mm/yy'),4,length(to_char(c.EXPIRYDATE,'dd/mm/yy'))) from CAPSADMIN.capsmain cm inner join CAPSADMIN.cards c on c.crnno=cm.crnno and c.creditcardno=cm.creditcardno where c.generalstat in ("+sMapping+") and elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno='"+CrdtCN+"') and c.primarycard='1'";
					}
					else{
						//Changed by Amandeep for CAPS database change
						//sSQL = "select creditcardno,CARDTYPE,substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3)))  from capsmain where elitecustomerno=(select elitecustomerno from capsmain where creditcardno='"+CrdtCN+"') and substring(CREDITCARDNO,14,1)='0'";
						//old query
						//sSQL = "select creditcardno,CARDTYPE,substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy')))  from CAPSADMIN.capsmain where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno='"+CrdtCN+"') and substr(CREDITCARDNO,14,1)='0'";
						
						//new query
						sSQL = "select c.creditcardno,CARDTYPE,substr(to_char(c.EXPIRYDATE,'dd/mm/yy'),4,length(to_char(c.EXPIRYDATE,'dd/mm/yy'))) from CAPSADMIN.capsmain cm inner join CAPSADMIN.cards c on c.crnno=cm.crnno and c.creditcardno=cm.creditcardno where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno='"+CrdtCN+"') and c.primarycard='1'";
					}
					
					WriteLog("Execute Query...");
					result = stmt.executeQuery(sSQL);
					
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
			WriteLog("MAnish1234567788909---3333-"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
			WriteLog("strOutputXMLCat1---345345345-"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 	
			
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  				
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());				  		
				  WriteLog(objWorkList.getVal("Name").toString()+"======="+objWorkList.getVal("Value").toString());
			}
			sOutputXMLCustomerInfoList=DataFormHT.get("cardDetails").toString();
			WriteLog("manish ---"+sOutputXMLCustomerInfoList);
			WriteLog("manish ---"+sOutputXMLCustomerInfo);
		
			int iStartIndex=0;
			int iEndIndex=sOutputXMLCustomerInfoList.indexOf("!");		
			i=0;
			iCAPSCardCount=Integer.parseInt(sOutputXMLCustomerInfoList.substring(0,sOutputXMLCustomerInfoList.indexOf("@")));
			sOutputXMLCustomerInfoList=sOutputXMLCustomerInfoList.substring(sOutputXMLCustomerInfoList.indexOf("@")+1,sOutputXMLCustomerInfoList.length());

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
			WriteLog("Input XML BranchDetails"+sInputXML);
			sBranchDetails= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog("Output XML sBranchDetails"+sBranchDetails);
			if(sBranchDetails.equals("") || Integer.parseInt(sBranchDetails.substring(sBranchDetails.indexOf("<MainCode>")+10 , sBranchDetails.indexOf("</MainCode>")))!=0)
			{
			}
			else{
			}
		}catch(Exception exp){
			WriteLog(exp.toString());
		}

%>
		<SCRIPT LANGUAGE ="javascript">
				 var currency = new Array();
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
	//alert("sCardType  "+sCardType);
	if(sCardType == "L")
		{
			
			alert("RAKBANK Card Type L is not allowed.");
			if(cardNo == 1)
			{
			document.getElementById("BTD_RBC_RBCN1").selectedIndex=0;
			}else if(cardNo == 2){
				document.getElementById("BTD_RBC_RBCN2").selectedIndex=0;
			}else if(cardNo == 3){
				document.getElementById("BTD_RBC_RBCN3").selectedIndex=0;
			}
				//alert("cntrl "+ cntrl);
	            //alert("cardNo "+ cardNo);
			setRelatedData(cardNo,cntrl);
			return false;
		}
	eval("window.document.forms[\"dataform\"].BTD_RBC_CT"+cardNo+".value="+"\""+sCardType+"\"");
		iStartIndex=iEndIndex;
		iEndIndex=data.indexOf("#",iStartIndex+1);
	var	sExpDate=data.substring(iStartIndex+1,data.length);
	eval("window.document.forms[\"dataform\"].BTD_RBC_ExpD"+cardNo+".value="+"\""+sExpDate+"\"");
	}else
	{
		eval("window.document.forms[\"dataform\"].BTD_RBC_CT"+cardNo+".value="+"\"\"");
		eval("window.document.forms[\"dataform\"].BTD_RBC_ExpD"+cardNo+".value="+"\"\"");
	}
	if(cntrl.options[cntrl.selectedIndex].value=="")
	{
		eval("window.document.forms[\"dataform\"].BTD_RBC_BTA"+cardNo+".value="+"\"\"");
		eval("window.document.forms[\"dataform\"].BTD_RBC_AppC"+cardNo+".value="+"\"\"");
		eval("window.document.forms[\"dataform\"].BTD_RBC_BTA"+cardNo+".disabled=true;");
		eval("window.document.forms[\"dataform\"].BTD_RBC_AppC"+cardNo+".disabled=true;");
	}
	else
	{
		eval("window.document.forms[\"dataform\"].BTD_RBC_BTA"+cardNo+".disabled=false;");
		eval("window.document.forms[\"dataform\"].BTD_RBC_AppC"+cardNo+".disabled=false;");
	}
}
</script>
<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("")){%>
<input type=text readOnly name="cardDetails" id="cardDetails" value='<%=sTempCardDetails%>' style='display:none'>
<%}%>
<body >
<table border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='BT (Balance Transfer) Details'>
		<td colspan=4 align=left class="EWLabelRB2"><b>BT (Balance Transfer) Details </b></td>
	</tr>

	<tr class="EWHeader" width=100% class="EWLabelRB2">
		<td colspan=4 align=left class="EWLabelRB3"><b>Other Bank Card Details</b></td>
	</tr>
	

	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB"  id="C_BTD_OBC_CT">Card Type</td>
        <td nowrap  width="180">
			<select name="BTD_OBC_CT" onfocus=chkVerificationDet() onchange="enabledisable();">
				<option value="">--select--</option>
				<option value="Visa">Visa</option>
				<option value="Master">Master</option>
				<option value="Amex">Amex</option>
				<option value="Others">Others</option>
			</select>
		</td>
		  <td nowrap width="100" height="16" class="EWLabelRB" id="C_BTD_OBC_OBN">Other Bank Name</td>
        <td nowrap width="180">
			<select name="BTD_OBC_OBN" onchange="enabledisable();">
				<option value="">--select--</option>
				<option value="ADCB">ADCB</option>
				<option value="MASHREQ">MASHREQ</option>
				<option value="FIRST GULF">FIRST GULF</option>
				<option value="Others">Others</option>
			</select>
		</td>
	</tr>
	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_OBC_OBNO">Others (Pls. Specify)</td>
        <td nowrap  width="180"><input type="text" name="BTD_OBC_OBNO" value='<%=DataFormHT.get("BTD_OBC_OBNO")==null?"":DataFormHT.get("BTD_OBC_OBNO")%>' size="8" maxlength=50 style='width:150px;' disabled></td>
        <td nowrap width="100" height="16" class="EWLabelRB" id="BTD_OBC_OBCNO">Other Bank Card No.</td>
        <td nowrap width="180"><input type="text" name="BTD_OBC_OBCNO" onKeyUp="validateCCNDataOnKeyUp(this);"    
 onkeydown="validateCCN(this);" value='<%=DataFormHT.get("BTD_OBC_OBCNO")==null?"":DataFormHT.get("BTD_OBC_OBCNO")%>' onblur="validate(this);" size="8" maxlength=19 style='width:150px;' ></td><!--onblur="validate(this)"-->
	</tr>

	<TR>
        <td nowrap width="100" height="16" class="EWLabelRB" id="BTD_OBC_NOOC">Name on Other Card</td> 
        <td nowrap  width="180"><input type="text" name="BTD_OBC_NOOC" value='<%=DataFormHT.get("BTD_OBC_NOOC")==null?"":DataFormHT.get("BTD_OBC_NOOC")%>' size="8" maxlength=50 style='width:150px;' onkeyup=validateKeys(this,'CSR_BT')></td>
		<td nowrap width="100" height="16" class="EWLabelRB" id="C_BTD_OBC_DT">Deliver To</td>
        <td nowrap width="180">

<!-- 

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       The delivery option dropwdown contains the item 'others' which provides no additional information. This is not needed and needs to be removed.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/003					02/09/2008	 

 -->			
				<select name="BTD_OBC_DT" onblur=enabledisable()>
				<option value="">--select--</option>
				<option value="Bank">Bank</option>
				<option value="Courier">Courier</option>
				<!--<option value="Personal pickup">Personal pickup</option>-->
			</select>
		</td>
	</tr>
	<TR>
        <td nowrap width="100" height="16" class="EWLabelRB" id="C_BTD_OBC_BN">Branch Name</td>
        <td nowrap  width="180" colspan=3>
		<select name="BTD_OBC_BN" disabled style='width:150px;'>
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
					}
				}%>
		</select>
		</td>
	</tr>
	
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type="text" name="Header" readOnly size="24" style='display:none' value='RAKBANK Card Details'>
		<td colspan=4 align=left class="EWLabelRB3"><b>RAKBANK Card Details</b></td>
	</tr>


	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="C_BTD_RBC_RBCN1">RAKBANK card no.</td>
				
        <td nowrap  width="180">
			<select  name="BTD_RBC_RBCN1"  onchange="setRelatedData(1,this);">
				<option>--select--</option>				
				 <%	

				 for( i=1;i<=iCAPSCardCount;i++)
				 {
				out.println("<option value='"+CAPDataHT.get("RAKBankCard"+i)+"'>"+CAPDataHT.get("RAKBankCard"+i).toString().substring(0,4)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(4,8)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(8,12)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(12,16)+"</option>");
				 }	
			
				%>  
			</select>
		</td>
		<input type="text" id="C_BTD_RBC_RBCN2" style='display:none' >
		<td nowrap  width="180">
			<select id="BTD_RBC_RBCN2" name="BTD_RBC_RBCN2"  onchange="setRelatedData(2,this);">
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
		<input type="text" id="C_BTD_RBC_RBCN3" style='display:none' >
			<select id="BTD_RBC_RBCN3" name="BTD_RBC_RBCN3"  onchange="setRelatedData(3,this);">
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
        <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_RBC_CT1">Card Type</td>
        <td nowrap width="180"><input type="text" name="BTD_RBC_CT1"  value='<%=DataFormHT.get("BTD_RBC_CT1")==null?"":DataFormHT.get("BTD_RBC_CT1")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>
        <td nowrap  width="180"><input type="text" name="BTD_RBC_CT2" id="BTD_RBC_CT2" value='<%=DataFormHT.get("BTD_RBC_CT2")==null?"":DataFormHT.get("BTD_RBC_CT2")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>
		<td nowrap  width="180"><input type="text" name="BTD_RBC_CT3" id="BTD_RBC_CT3" value='<%=DataFormHT.get("BTD_RBC_CT3")==null?"":DataFormHT.get("BTD_RBC_CT3")%>' size="8" maxlength=20 style='width:150px;'disabled=true></td>		 
	</tr>
	<TR>
         <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_RBC_ExpD1">Expiry Date</td>
        <td nowrap width="180"><input type="text" name="BTD_RBC_ExpD1"  value='<%=DataFormHT.get("BTD_RBC_ExpD1")==null?"":DataFormHT.get("BTD_RBC_ExpD1")%>' size="8" maxlength=5 style='width:150px;'disabled=true></td>
        <td nowrap  width="180"><input type="text" name="BTD_RBC_ExpD2" id="BTD_RBC_ExpD2" value='<%=DataFormHT.get("BTD_RBC_ExpD2")==null?"":DataFormHT.get("BTD_RBC_ExpD2")%>'  size="8" maxlength=5 style='width:150px;'disabled=true></td>
		<td nowrap  width="180"><input type="text" name="BTD_RBC_ExpD3" id="BTD_RBC_ExpD3" value='<%=DataFormHT.get("BTD_RBC_ExpD3")==null?"":DataFormHT.get("BTD_RBC_ExpD3")%>'  size="8" maxlength=5 style='width:150px;' disabled=true></td>		 
	</tr>
	<TR>
         <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_RBC_BTA1" >BT Amount(AED)</td>
        <td nowrap width="180"><input type="text" name="BTD_RBC_BTA1"  value='<%=DataFormHT.get("BTD_RBC_BTA1")==null?"":DataFormHT.get("BTD_RBC_BTA1")%>' size="8" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_BT') onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>
        <td nowrap  width="180"><input type="text" name="BTD_RBC_BTA2" id="BTD_RBC_BTA2" value='<%=DataFormHT.get("BTD_RBC_BTA2")==null?"":DataFormHT.get("BTD_RBC_BTA2")%>' size="8" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_BT') onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>
		<td nowrap  width="180"><input type="text" name="BTD_RBC_BTA3" id="BTD_RBC_BTA3" value='<%=DataFormHT.get("BTD_RBC_BTA3")==null?"":DataFormHT.get("BTD_RBC_BTA3")%>' size="8" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_BT') onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>		 
	</tr>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       Approval code should be mandated to 6 digits. It is currently accepting 5 digits
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/005					02/09/2008	 
 -->
	<TR>
         <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_RBC_AppC1">Approval Code</td>
        <td nowrap width="180"><input type="text" name="BTD_RBC_AppC1"  value='<%=DataFormHT.get("BTD_RBC_AppC1")==null?"":DataFormHT.get("BTD_RBC_AppC1")%>' size="6" maxlength=6 style='width:150px;' onkeyup=numericapprovalcode(this) onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>
        <td nowrap  width="180"><input type="text" name="BTD_RBC_AppC2" id="BTD_RBC_AppC2" value='<%=DataFormHT.get("BTD_RBC_AppC2")==null?"":DataFormHT.get("BTD_RBC_AppC2")%>' size="6" maxlength=6 style='width:150px;' onkeyup=numericapprovalcode(this) onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>
		<td nowrap  width="180"><input type="text" name="BTD_RBC_AppC3" id="BTD_RBC_AppC3" value='<%=DataFormHT.get("BTD_RBC_AppC3")==null?"":DataFormHT.get("BTD_RBC_AppC3")%>' size="6" maxlength=6 style='width:150px;' onkeyup=numericapprovalcode(this)  onblur=validateKeys_OnBlur(this,'CSR_BT') disabled=true></td>		 
	</tr>
	
	<TR>
        <td nowrap width="140" height="16" class="EWLabelRB" id="BTD_RBC_RR">Remarks/ Reason</td> 
        <td nowrap  width="180" colspan=3><textarea name="BTD_RBC_RR"  cols=50  rows=2  onKeyup="CheckMxLength(this,500);" ><%=DataFormHT.get("BTD_RBC_RR")==null?"":DataFormHT.get("BTD_RBC_RR")%></textarea></td>
	</tr>
	<TR>
		<td nowrap width="140" height="30" class="EWLabelRB"  id="BTD_RBC_PRL">Pending For</td>
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

</BODY>