<%@ include file="Log.process"%>
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


<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource,java.sql.PreparedStatement" %>

<%@ include file="/generic/wdcustominit.jsp"%>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
	Hashtable DataFormHT=null;
		if(request.getAttribute("DataFormHT")!=null)
		DataFormHT=(Hashtable)request.getAttribute("DataFormHT");		
%>
<%

String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
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
//	Hashtable DataFormHT=new Hashtable();
	String sBranchDetails="";
	int iCardCount=0;
	String sOutputXMLCustomerInfo ="";
	String sCustomerStatus="CustomerFound";
	String sTempCardsList="";
	Hashtable CAPDataHT=new Hashtable();
	int iCAPSCardCount=0;
	int i=1;
	String sTempCardDetails=""; String isPrimaryCard="0"; String rakCard = "";
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessInstanceId"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CrdtCN", request.getParameter("CrdtCN"), 1000, true) );
	String CrdtCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	WriteLog("Integration jsp: CrdtCN: "+CrdtCN);

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
					//Changed by Amandeep for CAPS database change
					//String sSQL = "select creditcardno,CARDTYPE,substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3)))  from capsmain where elitecustomerno=(select elitecustomerno from capsmain where creditcardno='?') and  substring(CREDITCARDNO,14,1)!='0' ";
					//String sSQL = "select creditcardno,CARDTYPE,substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy'))) from CAPSADMIN.capsmain where elitecustomerno=(select elitecustomerno from CAPSADMIN.capsmain where creditcardno=?) and  substr(CREDITCARDNO,14,1)<>'0' ";
					//new updated query.
					String sSQL = "select c.creditcardno,CARDTYPE,substr(to_char(c.EXPIRYDATE,'dd/mm/yy'),4,length(to_char(c.EXPIRYDATE,'dd/mm/yy'))),c.primarycard from CAPSADMIN.capsmain cm inner join CAPSADMIN.cards c on c.crnno=cm.crnno and c.creditcardno=cm.creditcardno where elitecustomerno=(select elitecustomerno from capsadmin.capsmain where creditcardno=?)";
  
					WriteLog("Execute Query..."+sSQL);
					stmt = conn.prepareStatement(sSQL);
					stmt.setString(1,CrdtCN);
					result = stmt.executeQuery();
					
					while (result.next()) {
						
						String sValue = result.getString(1);
                        rakCard = result.getString(1);
						WriteLog("rakCard from CAPS: "+rakCard);						
						if(sValue==null||sValue.equals("")||sValue.trim().equals(""))
							continue;
						
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
						//added by stutee.mishra to handle primary card column.
						if(CrdtCN.equalsIgnoreCase(rakCard)){
							isPrimaryCard = result.getString(4);
							WriteLog("primarycard from CAPS: "+sValue);
						}
						sTempCardDetails=sTempCardDetails+"!";
						i++;
					}					
					iCAPSCardCount=i-1;
					sTempCardDetails=iCAPSCardCount+"@"+sTempCardDetails;
					WriteLog("sTempCardDetails---|"+sTempCardDetails);
					sTempCardDetails=sTempCardDetails+"~"+isPrimaryCard;
					WriteLog("sTempCardDetails after appending primarycard val: "+sTempCardDetails);
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
		}
		else
		{				
			sOutputXMLCustomerInfoList=DataFormHT.get("cardDetails").toString();
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

   }

	
%>



<script>
var flag=0;
/*

	Product/Project :       Rak Bank
	Module          :       OCC - SSL
	File            :       CSR_OCC_SSC.jsp
	Purpose         :       To validate for the amount limit with the primary card limit
	Author			:		Saurabh Arora
	Added On		:		10/02/2009
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/084	
*/
function validateAmount(cntrl)
{
	if (cntrl.value=="")
	{
	}
	else
	{
		var url="CSR_SSC_Limit.jsp?CreditCardNo=" + window.document.forms["dataform"].CCI_CrdtCN.value;
		/*
		var features="dialogHeight:0px;dialogWidth:0px;dialogTop:0px;dialogLeft:0px;";
		var ReturnVal = window.showModalDialog(url, '', '');

		var amntVal = cntrl.value;
		amntVal = amntVal.replace(/,/, "");
		var amntVal2 = parseFloat(amntVal);
		var retVal2 = parseFloat(ReturnVal);
		if (amntVal2>retVal2)
		{
			alert("Amount cannot be greater than Primary Card Limit ("+ReturnVal+")");
			cntrl.value="";
			cntrl.focus();
			return false;
		}	*/	
	}
}
function AddPendingOptionsSSC(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsSSC');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedSSC');
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
			if(selectedValueId=='PendingOptionsSelectedSSC'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedSSC');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";
					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForSSC').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
		}
function RemovePendingOptionsSSC(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedSSC');
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
	if(selectedValueId=='PendingOptionsSelectedSSC'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelectedSSC');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForSSC').value = sDropDownValue;
	}
}
function validate(cntrl)
{
	if(cntrl.value=="")
		return false;
	if(flag==1)
	{
		flag=0;
		return false;
	}
	
	try{		
		regex=/^[0-9]{16}$/;
		if(!regex.test(replaceAll(cntrl.value,"-","")))
		{
			alert("Length Of Credit Card No Should be exactly 16 digits.");
			cntrl.value="";
			cntrl.focus();
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
			alert("Both the Credit card Numbers can't be same");
			cntrl.value="";
			cntrl.focus();
			return false;
		}
		return true;
	}catch(e){
		alert(e.message);
	}
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
	var keycode=event.keyCode;
	var cntrlValue=cntrl.value;
	if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
		cntrl.value=cntrlValue+"-";
	
}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_OCC_SSC.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
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


function validateCCNDataOnKeyUp(cntrl)
{
	var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	

	var keycode=event.keyCode;
	
	if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
		{
		flag=1;
		alert("Invalid Credit Card No. Format");
		cntrl.value="";		
		cntrl.focus();
		return false;
		}		
}
</script>

<script>
var soth_ssc_SCNo='<%=DataFormHT!=null&&DataFormHT.get("oth_ssc_SCNo")!=null?DataFormHT.get("oth_ssc_SCNo"):""%>';
</script>

<table id="SSC" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Setup Suppl. Card Limit'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Setup Suppl. Card Limit</b></td>
	</tr>
	<TR>
        <td nowrap width="155" height="16" id="oth_ssc_Amount" class="EWLabelRB">Amount Field</td>
        <td nowrap  width="150"><input type="text" name="oth_ssc_Amount" value='<%=DataFormHT!=null&&DataFormHT.get("oth_ssc_Amount")!=null?DataFormHT.get("oth_ssc_Amount"):""%>'  size="8" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_OCC_SSC') onblur="validateKeys_OnBlur(this,'CSR_OCC_SSC'); validateAmount(this)" ></td>
		  <td nowrap width="190" id="C_oth_ssc_SCNo" height="16" class="EWLabelRB">Suplementary Card No.</td>
        <td nowrap width="190">
		<select id="oth_ssc_SCNo" name="oth_ssc_SCNo" type="text">
				<option value="">--select--</option>
				<%	
				 for( i=1;i<=iCAPSCardCount;i++)
				 {
				out.println("<option value='"+CAPDataHT.get("RAKBankCard"+i)+"'>"+CAPDataHT.get("RAKBankCard"+i).toString().substring(0,4)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(4,8)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(8,12)+"-"+CAPDataHT.get("RAKBankCard"+i).toString().substring(12,16)+"</option>");
				 }				   
				%>
			</select>		
		</td>
	</tr>	
	<TR>	    
        <td nowrap width="155" height="16" id="oth_ssc_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_ssc_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_ssc_RR")!=null?DataFormHT.get("oth_ssc_RR"):""%></textarea></td>
	</tr>	
	<TR>
		<td nowrap width="160" height="30" class="EWLabelRB"  id="CSR_CCC_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsSSC" style="width: 160;" name="PendingOptionsSSC" >
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
						<input type="button" id="addButtonPendingOptionsSSC" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsSSC('PendingOptionsSSC','PendingOptionsSelectedSSC');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsSSC" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsSSC('PendingOptionsSSC','PendingOptionsSelectedSSC');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedSSC'  name='PendingOptionsSelectedSSC' multiple='multiple' style="width:150px">
						</select>
					</td>
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("")){%>
<input type=text readOnly name="cardDetails" id="cardDetails" value='<%=sTempCardDetails%>' style='display:none'>
<%}%>
