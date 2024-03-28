<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>


<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	//int iJtsPort = 0;	
	String iJtsPort = null;	
	boolean bError=false;
	String sBranchDetails="";
	
	Hashtable DataFormHT=null;
	if(request.getAttribute("DataFormHT")!=null)
		DataFormHT=(Hashtable)request.getAttribute("DataFormHT");
	
	try
	{
		WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		WriteLog("sCabname :"+sCabname);
		sSessionId    = wDUserInfo.getM_strSessionId();
		WriteLog("sSessionId :"+sSessionId);
		sJtsIp = wDCabinetInfo.getM_strServerIP();
		iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
		WriteLog("iJtsPort :"+iJtsPort);
	}
	catch(Exception ignore)
	{
		bError=true;
		WriteLog(ignore.toString());
	}
	
	try
	{
		String Query="select branchid,branchname from rb_branch_details where 1=:ONE";
		String params ="ONE==1";
		String sInputXML =	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
		//sBranchDetails= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		sBranchDetails = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog(sBranchDetails);
		if(sBranchDetails.equals("") || Integer.parseInt(sBranchDetails.substring(sBranchDetails.indexOf("<MainCode>")+10 , sBranchDetails.indexOf("</MainCode>")))!=0)
		{			
		}
		else
		{
		}
	}
	catch(Exception exp)
	{
		WriteLog(exp.toString());
	}
%>
<script>

function enabledisable(cntrl)
{
	if (document.forms[0].oth_ecr_dt.options[document.forms[0].oth_ecr_dt.selectedIndex].value.toUpperCase()=="BANK")
	{
		document.forms[0].oth_ecr_bn.disabled=false;
	}
	else
	{
		document.forms[0].oth_ecr_bn.selectedIndex=0;
		document.forms[0].oth_ecr_bn.disabled=true;
	}
}

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

function AddPendingOptionsECR(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsECR');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedECR');
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
			
			if(selectedValueId=='PendingOptionsSelectedECR'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedECR');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";

					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForECR').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
			
		}

function RemovePendingOptionsECR(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedECR');

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
	
	if(selectedValueId=='PODOptionsSelecetedECR'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelectedECR');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForECR').value = sDropDownValue;
	 
	}
}

</script>
<table id="ECR" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Early Card Renewal'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Early Card Renewal (max. 3 months before the expiry date)</b></td>
	</tr>
	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_RB' class="EWLabelRB">Required by date </td>
        <td nowrap  width="150">
			<input type="text" name="oth_ecr_RB" value='<%=DataFormHT!=null&&DataFormHT.get("oth_ecr_RB")!=null?DataFormHT.get("oth_ecr_RB"):""%>'   size="8" maxlength=5 style='width:150px;' onblur=validateKeys_OnBlur(this,'DSR_OCC_ECR') >
		</td>
		<td nowrap width="190" height="16" class="EWLabelRB" colspan=2></td>
        
	</tr>	

	<tr>
		<td nowrap width="155" height="16" id='oth_ecr_DeliverTo' class="EWLabelRB">Deliver to</td>
        <td nowrap width="180">
			<select name="oth_ecr_dt" onblur= enabledisable(this)>
				<option value="">--Select--</option>
				<option value="Bank">Branch</option>
				<option value="Courier to Work Address">Courier to Work Address</option>
				<option value="Personal Pick Up">Personal Pick Up</option>
				<option value="International Address">International Address</option>
			</select>
		</td>
		<td nowrap width="100" height="16" id="oth_ecr_BranchName" class="EWLabelRB">Branch name</td>
		<td nowrap width="180">
			<select name="oth_ecr_bn" disabled>
				<option value="">--Select--</option>
		<%
			if(sBranchDetails.indexOf("<Record>")!=-1)
				{
					WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
					WFXmlList RecordList1;
					for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
					{
						String sBranchId=RecordList1.getVal("branchid");
						String sBranchName=RecordList1.getVal("branchname");
						out.println("<option value=\""+sBranchId+"\">"+sBranchName+"</option>");
					}
				}
		%>
	</tr>
	<TR>	    
        <td nowrap width="155" height="16" id="oth_ecr_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_ecr_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_ecr_RR")!=null?DataFormHT.get("oth_ecr_RR"):""%></textarea></td>
	</tr>

	
	<TR>
		<td nowrap width="140" height="30" class="EWLabelRB"  id="CSR_RR_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsECR" style="width: 160;" name="PendingOptionsECR" >
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
						<input type="button" id="addButtonPendingOptionsECR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsECR('PendingOptionsECR','PendingOptionsSelectedECR');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsECR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsCDR('PendingOptionsECR','PendingOptionsSelectedECR');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedECR'  name='PendingOptionsSelectedECR' multiple='multiple' style="width:150px">
						</select>

					</td>
					
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
