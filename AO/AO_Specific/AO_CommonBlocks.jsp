<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Form Painitng
//File Name					 : AO_CommonBlocks.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : Dynamic Form Painting from DB Tables
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="com.newgen.mvcbeans.model.*"%>
<%@ page import="com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/keyPressValidation.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/formLoad_AO.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/populateCustomValue.js"></script>
<script language="JavaScript" src="/webdesktop/webtop/scripts/calendar_SRM.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>

<!DOCTYPE html> 
<HTML>
<Head>	
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
</Head>

</script>
<script src="//cdnjs.cloudflare.com/ajax/libs/json3/3.3.2/json3.min.js"></script>
<script type="text/javascript">

function callOnLoad(){
	//In this function Write Custom Validation and code	required on page load, populateCustomValue.js;
	 	 
	customOnLoad();
	//block added to enable default display of UID details at CBWC checker and Branch Controls
	if(document.getElementById("WS_NAME").value=="CB-WC Checker" || document.getElementById("WS_NAME").value=="Branch_Controls" || document.getElementById("WS_NAME").value=="Controls")
	{
		document.getElementById("myTable").style.display="table";
		document.getElementById("add_row").style.visibility="visible";
		document.getElementById("uidview").value="Click to Hide UIDs";
	}
	if(document.getElementById("WS_NAME").value=="OPS_Checker")
	{
		document.getElementsByName('Fetch')[0].disabled = false;
	}
	
}
function whichButton(eventname, event) {
	if(event.keyCode == 8)
	{
		event.keyCode=10; 
		return (event.keyCode);
	}
}
function setPrimaryField(){
	parent.setPrimaryField();	
	formLoadCheck();
}
function HistoryCaller(){	
	parent.HistoryCaller();
}
function initialize(eleId){	
	var cal = document.getElementById(eleId);
	if(cal.disabled==true){
		return false;
	}
	
	var cal1 = new calendarfn(document.getElementById(eleId));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();	
	return true;
}

function initialize_DT(eleId)	{	
	var cal1 = new calendarfn2(document.getElementById(eleId));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();
	if(ValidateDate())
		return true;
	else
		return false;		
}
function trimLength(id,value,maxLength){
	newLength=value.length;
	value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9_.&: ]/g,"");

	//value=value.replaceAll(/(['])/,"''''");
	//alert(value);
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	document.getElementById(id).value=value;
}
function validateNumeric(val,id)
{
	var regex = /[^0-9]/g;
	if(regex.test(val))
	{
		alert("UID can be numeric only");
		document.getElementById(id).focus();
		return false;
	}
}

function validateAlphaNumeric(val,id)
{
	var regex = /[^0-9a-zA-Z]/g;
	if(regex.test(val))
	{
		alert("UID can be alphanumeric only");
		document.getElementById(id).focus();
		return false;
	}
}

function deleteDblClick(eleId) {
	if(document.getElementById("WS_NAME").value=="OPS_Checker")
	{
		var select=document.getElementById(eleId.id);
		var addedAccounts=select.options.length;
		var selectedAcc=document.getElementById(eleId.id);
		selectedAcc.remove(selectedAcc.selectedIndex);
		if(addedAccounts==document.getElementById('1_No_of_Accounts').value)	
			document.getElementById("1_Account_No_1").disabled=false;
	}
}
function toggleTable()
{
   if (document.getElementById("myTable").style.display == "table" ) {
       document.getElementById("myTable").style.display="none";
	   document.getElementById("uidview").value="Click to View UIDs";
	   if(document.getElementById("add_row")!=undefined)
		document.getElementById("add_row").style.visibility="hidden";

   } else {
      document.getElementById("myTable").style.display="table";
	  document.getElementById("uidview").value="Click to Hide UIDs";
	  if(document.getElementById("add_row")!=undefined)
		document.getElementById("add_row").style.visibility="visible";

	}
}
function addrow()
{	

	if(document.getElementById("WS_NAME").value=="CB-WC Maker")
	{
	
		alert("Can not add row on CB-WC Maker");
	}
	else if(document.getElementById("WS_NAME").value=="CB-WC Checker")
	{
	 var table = document.getElementById("myTable");
	var lastRow = table.rows[ table.rows.length-1 ];
	var row = table.insertRow();

	
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	var cell4 = row.insertCell(3);
	
	if(lastRow.cells[0].innerHTML=='S.No')
		cell1.innerHTML = 1;
	else
	cell1.innerHTML = Number(lastRow.cells[0].innerHTML)+1;
	cell2.innerHTML="<input type='text' size='25' id='UID_"+cell1.innerHTML+"' >";
	cell3.innerHTML="<input type='text' size='50' readonly disabled=true maxlength='2000' id='Remarks_"+cell1.innerHTML+"' >";
	cell4.innerHTML = "<img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'>";
	
	}
	else if(document.getElementById("WS_NAME").value=="Branch_Controls" || document.getElementById("WS_NAME").value=="Controls")
	{
	 var table = document.getElementById("myTable");
	var lastRow = table.rows[ table.rows.length-1 ];
	var row = table.insertRow();

	
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	var cell4 = row.insertCell(3);
	
	if(lastRow.cells[0].innerHTML=='S.No')
		cell1.innerHTML = 1;
	else
		cell1.innerHTML = Number(lastRow.cells[0].innerHTML)+1;
	cell2.innerHTML="<input type='text' size='25' id='UID_"+cell1.innerHTML+"' >";
	cell3.innerHTML="<input type='text' size='60' maxlength='2000' onblur=trimLength(this.id,this.value,2000) id='Remarks_"+cell1.innerHTML+"' >";
	cell4.innerHTML = "<img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'>";
	
	}
	
}
function delRow()
{
    
	var r = confirm("Do you want to delete the row?");
	if (r == true) {
		var current = window.event.srcElement;
		current = current.parentNode.parentNode;
		current.parentNode.removeChild(current);
		
		var table = document.getElementById("myTable");
		
		for (var i = 2, row; row = table.rows[i]; i++) 
		{
			table.rows[i].cells[0].innerHTML=i-1;
		}
	} else {
		return;
	}
}
</script>

<Form>
<BODY topmargin=0 leftmargin=0 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="setPrimaryField();callOnLoad();"   onkeydown="whichButton('onkeydown',event)">
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>

<%!
	public List getFrameListFromXML(String inputXML) {
		XMLParser xmlParserData = new XMLParser();
		xmlParserData.setInputXML(inputXML);
		List frameList = new ArrayList();
		List frameListRecord = null;
		Map<String, String> map = new HashMap<String, String>();
		Set set = new HashSet();
		XMLParser objXmlParser = null;

		String subXML = "";
		String frameorder = "";
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		for (int i = 0; i < recordcount; i++) {
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			frameorder = objXmlParser.getValueOf("Frameorder");
			if (!set.contains(frameorder)) {
				if (frameListRecord != null) {
					frameList.add(frameListRecord);
				}
				frameListRecord = new ArrayList();
			}
			set.add(frameorder);
			frameListRecord.add(subXML);

		}
		frameList.add(frameListRecord);
		return frameList;
	}
	
	public StringBuilder getDynamicHtml_FrameWise(List <List> frameList,String loadcount, List<Map> fieldMapList, String Workstep,String CategoryID,String SubCategoryID,String PANno, String outputData3, int count, String temp2[][], String DispColCount,String sMappOutPutXML,String sMode, String FlagValue){	
	StringBuilder html = new StringBuilder();
	String subXML="";
	
	XMLParser xmlParserData2=new XMLParser();	
	String firstRecord = "";
				html.append("<table><tr>");
			for(List<String> recordList: frameList)
			{
				html=html.append(parseRecord(recordList,loadcount,fieldMapList,Workstep,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode));
				
				firstRecord = recordList.get(0);
				
				XMLParser xmlParserData=new XMLParser();
				xmlParserData.setInputXML((firstRecord));
			}
			return html.append("</tr></table><br>&nbsp;<input name='Decision_History' style='width:150px' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' ><br><br>");
		
	}

	public StringBuilder parseRecord(List <String> recordList,String loadcount, List<Map> fieldMapList, String Workstep,String CategoryID,String SubCategoryID,String PANno, String outputData3, int count, String temp2[][], String DispColCount,String sMappOutPutXML,String sMode){	
	
	String mainCodeData2="";
	String subXML="";
	String subXML2="";
	XMLParser objXmlParser=null;
	XMLParser objXmlParser2=null;
	String tablename="";
	String WS_NAME="";
	String comboid="";
	String Value="";
	String Key="";
	String LabelName="";
	String FieldType="";
	String FieldLength="";
	String ColumnName="";
	String ColumnValue="";
	String FieldOrder="";
	String Frameorder="";
	String Editable="";
	String framecount="";
	String ColumnCopy="";
	String logical_WS_NAME="";
	String IsMandatory="";
	String Pattern="";
	String is_workstep_req="";
	String event_function="";
	String is_special="";
	String typecheck="";
	boolean textArea=false;
	boolean typecheckButR=false;
	boolean AccoutnNoFetched=false;
	String IsRepeatable="";
	String readOnlyDisabled="";
	int intTwiceDispColCount = Integer.parseInt(DispColCount)*2;
	float intWidth = ((float)100/(intTwiceDispColCount));
	int i=Integer.parseInt(DispColCount)-1;	
	StringBuilder html = new StringBuilder();	
	XMLParser xmlParserData2=new XMLParser();	
	int recordcount2=0;	
	Map<String,String> map = new HashMap<String,String> ();
	
	if(fieldMapList.size()!=0)
	{
		map = (HashMap)fieldMapList.get(0);
	}
	
		for(String record: recordList)
		{
			
			subXML = record;
			objXmlParser = new XMLParser(subXML);
			WS_NAME = objXmlParser.getValueOf("WS_Name");
			LabelName = objXmlParser.getValueOf("LabelName");
			
			if(LabelName.indexOf("SP_")==0)
			{
				is_special=LabelName.substring(0,3);
				LabelName=LabelName.substring(3);
			}
			else
				is_special="";
			FieldType = objXmlParser.getValueOf("FieldType");
			FieldLength = objXmlParser.getValueOf("FieldLength");
			ColumnName = objXmlParser.getValueOf("ColumnName");
			FieldOrder = objXmlParser.getValueOf("FieldOrder");
			Frameorder = objXmlParser.getValueOf("Frameorder");
			Editable = objXmlParser.getValueOf("IsEditable");
			IsRepeatable="N";
			IsMandatory=objXmlParser.getValueOf("IsMandatory");
			Pattern=objXmlParser.getValueOf("Pattern");
			if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
				Pattern="blank";
			is_workstep_req=objXmlParser.getValueOf("is_workstep_req");
			event_function=objXmlParser.getValueOf("event_function");
			event_function=event_function.replaceAll("~"," ");

			//WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
			String nameFormElement = Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable;		
			
			if(Workstep.equals(WS_NAME))
			{	
				if(IsMandatory.equals("Y")){
				 
				 LabelName=LabelName+"*";
				  
				 }	
				if(FieldType.equals("NULL")&&FieldOrder.equals("1"))
				{	
					html.append("<table border='1' cellspacing='1' cellpadding='0' width=101% ><tr class='EWHeader' width=100% class='EWLabelRB2'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><b>"+LabelName+"</b></td></tr>");
					i=0;		
				}
				else if(!FieldOrder.equals("1"))
				{
					//if(textArea) html.append("<TR>");
					if(i!=0)
					{
						if(!FieldType.equals("H")){							
							--i;							
						}
						if(FieldType.equals("TA")){
							html.append("<td colspan='1'>&nbsp;</td></tr><tr>");
							i=0;
						}
					}
					else
					{ 
						if(!FieldType.equals("H")){
							html.append("<TR>");
						}
						i=Integer.parseInt(DispColCount)-1;
					}
					if(map.containsKey(ColumnName) && (!IsRepeatable.equals("Y"))){
						ColumnValue = map.get(ColumnName).trim();
					}else{
						ColumnValue="";
					}
					if(!FieldType.equals("B") && !FieldType.equals("H") && !FieldType.equals("R"))
					{
						if(WS_NAME.equalsIgnoreCase("OPS_Maker") && (ColumnValue==null || ColumnValue.equals("")) && FieldType.equals("L"))
						{
							i++;
							continue;
						}	
						html.append("<td width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
					}	
					
					readOnlyDisabled="";
					if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
					{
					
						//WriteLog("!! FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
						readOnlyDisabled=" 'readonly' disabled='disabled' ";
					}
					textArea=false;
					if(FieldType.equals("H"))
					{
						html.append("<input type='hidden' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"' "+event_function+" >");
					}
					else if(FieldType.equals("TA") )
					{
						textArea=true;
						if(is_special.equals("SP_"))
							{
								if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && (((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep)))
									html.append("<td  width='"+3*intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='5' cols='22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+") maxlength = '"+FieldLength+"' style='overflow:scroll' "+event_function+readOnlyDisabled+">"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"</textarea></td>");
								else	
									html.append("<td  width='"+3*intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='5' cols='22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onblur=trimLength(this.id,this.value,"+FieldLength+") maxlength = '"+FieldLength+"' style='overflow:scroll' "+event_function+readOnlyDisabled+"></textarea></td>");	
								is_special="";
								
							}else{
								html.append("<td  width='"+3*intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='5' cols='22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" onblur=trimLength(this.id,this.value,"+FieldLength+") maxlength = '"+FieldLength+"' style='overflow:scroll' "+event_function+readOnlyDisabled+">"+ColumnValue+"</textarea></td>");
							}
						typecheck="TA";	
					} 					
					else if(FieldType.equals("T") )
					{
						
						if(is_special.equals("SP_"))
							{
								if(map.size()!=0  && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep)){
										
										html.append("<td width='"+intWidth+"%'  style='width: 272px' nowrap='nowrap' class='EWNormalGreenGeneral1'><input  style='width: 226px' type='text' size = '25' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+(ColumnValue).substring((ColumnValue).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"' onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");			
									}
								else{
										
										html.append("<td width='"+intWidth+"%'  style='width: 272px' nowrap='nowrap' class='EWNormalGreenGeneral1'><input  style='width: 226px' type='text' size = '25' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+readOnlyDisabled+"></td>");
									}
								is_special="";
								
							}else{
								html.append("<td width='"+intWidth+"%'  style='width: 190px' nowrap='nowrap' class='EWNormalGreenGeneral1'><input  style='width: 170px'  type='text' data-toggle='tooltip'  onmousemove='title=this.value' onmouseover='title=this.value' size = '25' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"')	"+event_function+readOnlyDisabled+"></td>");
							}
							
						if(typecheck!="R")
						{
							typecheck="T";
							typecheckButR = true;
						}
					}
					else if(FieldType.equals("C") )
					{
						if(map.containsKey(ColumnName)&&((String)map.get(ColumnName)).equals("true"))
						{
							html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+" checked  ></td>");
						}else
						{
							html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='checkbox' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+LabelName+"' "+event_function+readOnlyDisabled+"      ></td>");
						}
						typecheck="C";
					}
					else if(FieldType.equals("L") )
					{
						
						html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><select type='text' style='width:173;overflow: scroll;' data-toggle='tooltip'  onmousemove='title=this.value' onmouseover='title=this.value' size = '3' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+ColumnValue+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') ondblclick=deleteDblClick(this)	"+event_function+readOnlyDisabled +">"); 
								
								if(ColumnValue!=null && !ColumnValue.equals(""))
								{
									AccoutnNoFetched=true;
									String opts[]=ColumnValue.split("\\|");
									for (int iOpts=0;iOpts<opts.length;iOpts++)
									{
										html.append("<option class='EWNormalGreenGeneral1' value='"+opts[iOpts]+"'>"+opts[iOpts]+"</option>");										
									}
								}
								html.append("</select></td>");
							
						if(typecheck!="R")
						{
							typecheck="L";
							typecheckButR = true;
						}
					}
					
					else if(FieldType.equals("P"))
					{ 	
							if(is_special.equals("SP_"))
							{	

								html.append("<td width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value'  style='width: 170px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
								xmlParserData2.setInputXML((outputData3));
								recordcount2 = Integer.parseInt(xmlParserData2.getValueOf("TotalRetrieved"));
								mainCodeData2 = xmlParserData2.getValueOf("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = xmlParserData2.getNextValueOf("Record");
										objXmlParser2 = new XMLParser(subXML2);
										comboid = objXmlParser2.getValueOf("comboid");
										Value = objXmlParser2.getValueOf("Value");
										Key = objXmlParser2.getValueOf("Key");
										
										if(Key==null || Key.equals("")){
											Key = Value;
										}
										
										if(LabelName.contains("*")){
										LabelName=LabelName.replace("*","");
										}
										if(LabelName.equals(comboid))
										{
											if(!(map.get(ColumnName)==null || map.get(ColumnName).equals("null")))
											{
												try{													
												if(((String)map.get(ColumnName)).lastIndexOf("$") != -1)
												{													
													if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
													{													
														if(((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1).equals(Value))
															html.append("<option value='"+Value+"' selected>"+Value+"</option>");
														else
															html.append("<option value='"+Value+"' >"+Value+"</option>");	
													}											
													else	
														html.append("<option value='"+Value+"' >"+Value+"</option>");
												}
												else 
												{
													if(ColumnValue.equals(Key)) //Added for setting db value to dropdown	
														html.append("<option value='"+Key+"' selected>"+Value+"</option>");
													
													else
														html.append("<option value='"+Value+"' >"+Value+"</option>");
												}											
												
												}catch(Exception e)
												{
													html.append("<option value='"+Value+"' >"+Value+"</option>");
												}												
											}
											else
												html.append("<option value='"+Value+"' >"+Value+"</option>");
										}
									}
								}
								
								html.append("</select></td>");
								is_special="";							
							}
							else
							{

								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' readonly='readonly' disabled='disabled' "+event_function+" ><option value='--Select--' >--Select--</option>");
									
								}else{
									html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' data-toggle='tooltip' onselect='title=this.value'   onmousemove='title=this.value' onmouseover='title=this.value' style='width: 170px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								}	
								xmlParserData2.setInputXML((outputData3));
								recordcount2 = Integer.parseInt(xmlParserData2.getValueOf("TotalRetrieved"));
								mainCodeData2 = xmlParserData2.getValueOf("MainCode");
								if(mainCodeData2.equals("0"))
								{	
									for(int j=0; j<recordcount2; j++)
									{	
										subXML2 = xmlParserData2.getNextValueOf("Record");
										objXmlParser2 = new XMLParser(subXML2);
										comboid = objXmlParser2.getValueOf("comboid");
										Value = objXmlParser2.getValueOf("Value");
										Key = objXmlParser2.getValueOf("Key");
										
											if(LabelName.contains("*")){
										LabelName=LabelName.replace("*","");
										}
										if(LabelName.equals(comboid))
										{	if(CategoryID.equals("1")&&SubCategoryID.equals("1"))
											{
											if(((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1).equals(Value)&&Workstep.equals("Exit"))
												html.append("<option value='"+Key+"' selected>"+Value+"</option>");
											else
												html.append("<option value='"+Key+"' >"+Value+"</option>");
											}
											else if(ColumnValue.equals(Key)){
												html.append("<option value='"+Key+"' selected>"+Value+"</option>");
											}else{
												html.append("<option value='"+Key+"' >"+Value+"</option>");
											}
										}
									}
								}								
								html.append("</select></td>");
							}
							typecheck="P";								
					} 
					else if(FieldType.equals("D"))
					{
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0 && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}											
									}												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0 && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}											
										}
										else
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
									}										
								}
								is_special="";
							}
							else
							{
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}											
									}												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'>");
											
											if(!IsRepeatable.equals("Y"))
												html.append("<input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly "+event_function+">");
											else
												html.append("<input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+">");
											
											html.append("<a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" >");
											html.append("<img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
										}
									}										
								}
							}
							typecheck="D";								
					}  
					else if(FieldType.equals("DT"))
					{ 													
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(map.size()!=0 && map.get(ColumnName)!=null && ((map.get(ColumnName)).lastIndexOf("$")>-1) && ((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
											else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											}
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}											
									}												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = ''  "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
											else{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
									}										
								}
								is_special="";
							}
							else
							{
								if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
								{
									if(map.isEmpty())
									{
										html.append("<td width='"+intWidth+"%'  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											if(!IsRepeatable.equals("Y"))
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
											else
												html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></td>");
										}
										else{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}											
									}												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+"><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'>");
											if(!IsRepeatable.equals("Y"))
												html.append("<input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"'  "+event_function+">");
											else
												html.append("<input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' "+event_function+">");
											
											html.append("<a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" >");
											html.append("<img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											
										}
										else
										{
											html.append("<td  width='"+intWidth+"%' nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' "+event_function+" ><a href='' onclick = \"initialize_DT('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="DT";								
					}  
					else if(FieldType.equals("R"))
					{  						
						if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td  width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' value='"+LabelName+"' checked disabled "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
							else
							html.append("<td  width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' value='"+LabelName+"' disabled "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
						}
						else
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td  width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' value='"+LabelName+"' checked "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
							else
							html.append("<td  width='"+intWidth+"%' class='EWNormalGreenGeneral1'><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"#"+IsRepeatable+"' value='"+LabelName+"' "+event_function+" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
						}
						typecheck="R";			
					}  
					else if(FieldType.equals("B"))
					{
						String disabled="";
						if(AccoutnNoFetched && LabelName.equals("Fetch"))
							disabled="readonly='readonly' disabled='disabled' ";
							
						if(Editable.equals("N") || (sMode !=null && sMode.equalsIgnoreCase("R")))
						{
							html.append("<td  width='"+2*intWidth+"%' colspan='2'>&nbsp;&nbsp;<input name='"+LabelName+"' type='button' value='"+LabelName+"' readonly='readonly' disabled='disabled' class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}else{
							html.append("<td  width='"+2*intWidth+"%' colspan='2'>&nbsp;&nbsp;<input name='"+LabelName+"' type='button' value='"+LabelName+"' "+disabled+"class='EWButtonRB' style='width:150px' "+event_function+" ></td>");
						}	
					} 
					if(i==0)
					{
						//WriteLog("Closing tr--->"+i);	
					}					
				}			
			}
		}		
		//WriteLog("Closing tr second>"+i);				
		return html;
	}
	
%>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
			WriteLog("WINAME_Esapi Esapi---> "+WINAME_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("load"), 1000, true) );
			String load_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("load Request.getparameter---> "+request.getParameter("load"));
			WriteLog("load_Esapi Esapi---> "+load_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WS"), 1000, true) );
			String WS_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("WS Request.getparameter---> "+request.getParameter("WS"));
			WriteLog("WS_Esapi Esapi---> "+WS_Esapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FlagValue"), 1000, true) );
			String FlagValue_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("FlagValue Request.getparameter---> "+request.getParameter("FlagValue"));
			WriteLog("FlagValue_Esapi Esapi---> "+FlagValue_Esapi);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ViewMode"), 1000, true) );
			String ViewMode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("ViewMode Request.getparameter---> "+request.getParameter("ViewMode"));
			WriteLog("ViewMode_Esapi Esapi---> "+ViewMode_Esapi);

	String loadcount = load_Esapi;
	
	if (loadcount==null)                                   // need to be changed
		loadcount = "firstLoad";
		
	String sCustomerName="";
	String sExpiryDate="";
	String sCardCRNNo="";
	String sSourceCode="";
	String sExtNo="";
	String sMobileNo="";
	String sAccessedIncome="";		
	String sCardType="";
	String sOutputXMLCustomerInfoList="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	Hashtable ht =new  Hashtable();
	String BranchName ="";
	String sProcessName ="";	
	String branchCode="";
	String sFirstName="";
	String sMiddleName="";
	String sLastName="";
	String sGeneralStat="";
	String sEliteCustomerNo="";
	String inputData="";
	String inputData2="";
	String outputData="";
	String outputData2="";
	String mainCodeData="";
	String inputData3="";
	String outputData3="";
	String mainCodeData3="";
	String PANno="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	XMLParser xmlParserData2=null;
	String ReturnFields="";
	String sCatname="";
	String subXML="";
	String CategoryID="";
	String SubCategoryID="";
	String transactionTable = "";
	String LogicalName="";
	String DispColCount="";
	String subXML3="";
	XMLParser objXmlParser3=null;
	List<List> frameList = new ArrayList<List>();
	Map<String, String> map = new HashMap<String, String>();
	List <Map> fieldMapList = new ArrayList<Map>();
	String WS=WS_Esapi;
	String FlagValue=FlagValue_Esapi;
	String WINAME=WINAME_Esapi;
	//String user=wDSession.getUserName();
	String user=wDSession.getM_objUserInfo().getM_strUserName();
	String sMode=ViewMode_Esapi;	
	StringBuilder htmlcode=new StringBuilder();
	StringBuilder dynamicQuery=new StringBuilder();
	int recordcount =0;
				
	
	String frmQuery = "select Frameorder,WS_NAME Logical_Name,LabelName, FieldType,FieldLength,ColumnName,FieldOrder ,'*' as MW_RESPMAP, SubCatIndex, IsEditable, IsMandatory, Pattern, CatIndex, event_function, is_workstep_req, 'AO_TXN_TABLE' as Transaction_Table, 1 as FieldValue,ws_name WS_Name,null,null   from USR_0_AO_FORMLAYOUT  with(nolock) where IsActive = 'Y'   and  ws_name ='"+WS.toUpperCase()+"'  order by Frameorder,FieldOrder";
	
	inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + frmQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId()+ "</SessionId></APSelectWithColumnNames_Input>";
	

	//outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
	
	
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	frameList = getFrameListFromXML(outputData);
	mainCodeData = xmlParserData.getValueOf("MainCode");
	recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String colArray[]=new String[recordcount];
	String colArrayStr = "";
	for(int k=0; k<recordcount; k++)
	{	subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		colArray[k] = objXmlParser.getValueOf("ColumnName");
		colArrayStr = colArrayStr + ","+colArray[k];		
	}
		
	int count=0;
	String temp[]=null;
	String temp2[][]=null;
	int t=0;
	if(mainCodeData.equals("0"))
	{	
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		ReturnFields = objXmlParser.getValueOf("MW_RESPMAP");
		sCatname = "";
		CategoryID = objXmlParser.getValueOf("CatIndex");
		SubCategoryID= objXmlParser.getValueOf("SubCatIndex");
		transactionTable=objXmlParser.getValueOf("Transaction_Table");
		LogicalName=objXmlParser.getValueOf("Logical_Name");
		
		DispColCount=objXmlParser.getValueOf("FieldValue");
		if(!ReturnFields.equals("*"))
		{
			temp= ReturnFields.split(",");
			count=temp.length;
			String check[]=null;
			temp2=new String[count][2]; 
			for(int k=0;k<count;k++)
			{				
				check=temp[k].split("#");
				temp2[k][0]=check[0];
				temp2[k][1]=check[1];				
			}
		}
	}	
	
	String qry = "select comboid,Value,[Key] from USR_0_AO_COMBOS with(nolock) where IsActive = 'Y' and Ws_Name = '"+WS.toUpperCase()+"' order by value";
	inputData3 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + qry + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId()+ "</SessionId></APSelectWithColumnNames_Input>";
	//outputData3 = WFCallBroker.execute(inputData3, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	outputData3 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData3);
		
	xmlParserData.setInputXML((outputData3));
	mainCodeData3 = xmlParserData.getValueOf("MainCode");
	if(mainCodeData3.equals("0"))
	{
		//WriteLog("Test mainCodeData3 "+mainCodeData3);
	}
	String sMappOutPutXML="";
	//WriteLog("WS>"+WS);
	//WriteLog("FlagValue>"+FlagValue);
	
	String val1="";
	String val2="";

	String QR_colnames="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS with(nolock) WHERE TABLE_NAME = '"+transactionTable+"' AND TABLE_SCHEMA='dbo'";
	inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR_colnames + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	outputData2 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData2);
	
	xmlParserData.setInputXML((outputData2));
	mainCodeData = xmlParserData.getValueOf("MainCode");
	int recCount= Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String tr_table_cols[]=new String[recCount];
	if(mainCodeData.equals("0"))
	{	
		for(int i=0;i<recCount;i++)
		{	subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			tr_table_cols[i]=objXmlParser.getValueOf("COLUMN_NAME");
		}
	}
	
	String Query="select";
	for(int r=0;r<recCount;r++)
	{
		Query+=" "+tr_table_cols[r]+",";
	}
	Query=Query.substring(0,(Query.lastIndexOf(",")));
	Query+=" from "+transactionTable+" with(nolock) where WI_NAME ='"+WINAME+"'";


	inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";

	outputData2 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData2);
	
	outputData2=outputData2.replaceAll("NULL","");
	xmlParserData.setInputXML((outputData2));
	mainCodeData = xmlParserData.getValueOf("MainCode");
	PANno = xmlParserData.getValueOf("KEYID");
	
	if(mainCodeData.equals("0"))
	{	
		for(int i=0;i<recordcount;i++)
		{	if(!xmlParserData.getValueOf(colArray[i]).equals(""))
			{	
			
				
			
				String val="";
				try
				{
					val=URLDecoder.decode(xmlParserData.getValueOf(colArray[i]), "UTF-8");
				}
				catch (UnsupportedEncodingException ex) 
				{             
					ex.printStackTrace();         
				} 
				map.put(colArray[i],val);
				val1=colArray[i];
				val2=xmlParserData.getValueOf(colArray[i]);
				
			}
		}
		fieldMapList.add(map);
	}	
	htmlcode=getDynamicHtml_FrameWise(frameList,loadcount,fieldMapList,WS,CategoryID,SubCategoryID,PANno,outputData3,count,temp2,DispColCount,sMappOutPutXML,sMode,FlagValue);
	
	
	if(WS.equalsIgnoreCase("CB-WC Checker") || WS.equalsIgnoreCase("Branch_Controls") || WS.equalsIgnoreCase("Controls"))
	{
		
		htmlcode.append("&nbsp;<input type = 'button' class='EWButtonRB' id = 'uidview' value='Click to View UIDs' onclick = 'toggleTable();'>&nbsp;<input type = 'button' class='EWButtonRB' id = 'add_row' value='Add Row' onclick = 'addrow();' style='visibility:hidden'><table border='2' id ='myTable' style='display:none'><thead><tr><td colspan=4 class='EWLabelRB2' width = '100%'>UID Details</td></tr><tr><td width = 10% class='EWLabelRB2'>S.No</td><td width = '30%' class='EWLabelRB2'>UID</td><td width = '60%' class='EWLabelRB2'>Remarks</td><td class='EWLabelRB2'></td></tr></thead><tbody>");
	}
	else 
	{
		
		htmlcode.append("&nbsp;<input type = 'button' class='EWButtonRB' id = 'uidview' value='Click to View UIDs' onclick = 'toggleTable();'><table border='2' id ='myTable' style='display:none'><thead><tr><td colspan=4 class='EWLabelRB2' width = '100%'>UID Details</td></tr><tr><td width = 10% class='EWLabelRB2'>S.No</td><td width = '30%' class='EWLabelRB2'>UID</td><td width = '60%' class='EWLabelRB2'>Remarks</td><td class='EWLabelRB2'></td></tr></thead><tbody>");
	}
	
	String Query1="";
	String inputData4="";
	String outputData4="";
	String mainCodeData2="";
	String subXML1="";
	String UIDValue="";
	String RemarksValue="";
	String UIDAddedAt="";
	String UIDAddedBy="";

	
	Query1="select UID,Remarks,UIDAddedBy,UIDAddedAt from  USR_0_AO_UIDDetails with(nolock) where WIName='"+WINAME+"'";
	inputData4="<?xml version=\"1.0\"?>"
				+ "<APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option>"
				+ "<Query>" + Query1 + "</Query>"
				+ "<EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName>"
				+ "<SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId>"
				+ "</APSelectWithColumnNames_Input>";
			
	WriteLog("InputXML: "+inputData4);
	outputData4 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData4);
    WriteLog("OutputXML: "+outputData4);
	xmlParserData.setInputXML((outputData4));
	mainCodeData2 = xmlParserData.getValueOf("MainCode");
	int recordcount3 = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	if(recordcount3==0)
	{
		int i;
		 for(i=1;i<=8;i++)
		 {
			if(WS.equalsIgnoreCase("CB-WC Checker"))
			{	 
				htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' maxlength='20' onblur='validateAlphaNumeric(this.value, this.id)'></td><td><input type='text' size='50' id='Remarks_"+i+"' value='' readonly disabled=true maxlength='2000'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'   ></td></tr>");
			}
			else if(WS.equalsIgnoreCase("Branch_Controls") || WS.equalsIgnoreCase("Controls"))
			{
				htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' maxlength='20' onblur='validateAlphaNumeric(this.value, this.id)'></td><td><input type='text' size='60' id='Remarks_"+i+"' value=''  maxlength='2000' onblur = 'trimLength(this.id,this.value,2000)'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'   ></td></tr>");
			}
			else 
			{
				htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' readonly disabled=true></td><td><input type='text' size='40' id='Remarks_"+i+"' value='' readonly disabled=true maxlength='2000' ></td><td></td></tr>");
			}
		 }
	
	}
	else
	{
		
		if(mainCodeData2.equals("0"))
		{
			int k;	
	
			for( k=1; k<=recordcount3; k++)
			{
				subXML1 = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML1);
				UIDValue=objXmlParser.getValueOf("UID");
				RemarksValue=objXmlParser.getValueOf("Remarks");
				UIDAddedBy=objXmlParser.getValueOf("UIDAddedBy");
				UIDAddedAt=objXmlParser.getValueOf("UIDAddedAt");
		
		
				if(WS.equalsIgnoreCase("CB-WC Checker"))
				{
		 
					if(user.equalsIgnoreCase(UIDAddedBy) && UIDAddedAt.equalsIgnoreCase("CB-WC Checker") )
					 {
					 htmlcode.append("<tr><td>"+k+"</td><td><input type='text' size='25' id='UID_"+k+"' value='"+UIDValue+"' maxlength='20' onblur='validateNumeric(this.value, this.id)'></td><td><input type='text' size='50' readonly disabled=true id='Remarks_"+k+"' value='"+RemarksValue+"'  maxlength='2000'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();' ></td></tr>");
					 }
					 else
					 {
					 
					htmlcode.append("<tr><td>"+k+"</td><td><input type='text' size='25' id='UID_"+k+"' value='"+UIDValue+"' readonly disabled=true maxlength='20' ></td><td><input type='text' size='50' readonly  disabled=true id='Remarks_"+k+"' value='"+RemarksValue+"'  maxlength='2000'></td><td></td></tr>");
					}
				}
				else if(WS.equalsIgnoreCase("Branch_Controls") || WS.equalsIgnoreCase("Controls"))
				{
					if( (UIDAddedAt.equalsIgnoreCase("Branch_Controls") || UIDAddedAt.equalsIgnoreCase("Controls")) &&  user.equalsIgnoreCase(UIDAddedBy))
					{
						htmlcode.append("<tr><td>"+k+"</td><td><input type='text' size='25' id='UID_"+k+"' value='"+UIDValue+"' maxlength='20' onblur='validateNumeric(this.value, this.id)'></td><td><input type='text' size='60' id='Remarks_"+k+"' value='"+RemarksValue+"' maxlength='2000' onblur = 'trimLength(this.id,this.value,2000)'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();' ></td></tr>");
					}
					else
					{
						htmlcode.append("<tr><td>"+k+"</td><td><input type='text' size='25' id='UID_"+k+"' value='"+UIDValue+"' readonly disabled=true maxlength='20' ></td><td><input type='text' size='60' id='Remarks_"+k+"' value='"+RemarksValue+"' maxlength='2000' onblur = 'trimLength(this.id,this.value,2000)'></td><td></td></tr>");
					}
				}
				else
				{
					htmlcode.append("<tr><td>"+k+"</td><td><input type='text' size='25' id='UID_"+k+"' value='"+UIDValue+"' readonly disabled=true maxlength='20' ></td><td><input type='text' size='40' id='Remarks_"+k+"' value='"+RemarksValue+"' readonly disabled=true  maxlength='2000'></td><td></td></tr>");
				}
	
			}
			if(k!=8)
			{
			 int i;
			 for(i=k;i<=8;i++)
			 {
				 if(WS.equalsIgnoreCase("CB-WC Checker"))
				 {	 
					htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' maxlength='20' onblur='validateAlphaNumeric(this.value, this.id)'></td><td><input type='text' size='50' id='Remarks_"+k+"' value='' readonly disabled=true maxlength='2000'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'   ></td></tr>");
				 }
				 else if(WS.equalsIgnoreCase("Branch_Controls") || WS.equalsIgnoreCase("Controls"))
				 {
					htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' maxlength='20' onblur='validateAlphaNumeric(this.value, this.id)'></td><td><input type='text' size='60' id='Remarks_"+k+"' value=''  maxlength='2000' onblur = 'trimLength(this.id,this.value,2000)'></td><td><img src='/webdesktop/webtop/images/delete_doc.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'   ></td></tr>");
				 }
				 else 
				 {
					htmlcode.append("<tr><td>"+i+"</td><td><input type='text' size='25' id='UID_"+i+"' value='' readonly disabled=true maxlength='20' ></td><td><input type='text' size='40' id='Remarks_"+k+"' value='' readonly disabled=true maxlength='2000' ></td><td></td></tr>");
				 }
			 }
			
			}
  
		}
	}	 
	 htmlcode.append("</tbody></table>");
	out.println(htmlcode.toString());
	
	out.println("<input type='hidden' name='tr_table' id='tr_table' value='"+transactionTable+"'/>");
	out.println("<input type='hidden' name='WS_LogicalName' id='WS_LogicalName' value='"+LogicalName+"'/>");
	out.println("<input type='hidden' name='CategoryID' id='CategoryID' value='"+CategoryID+"'/>");
	out.println("<input type='hidden' name='SubCategoryID' id='SubCategoryID' value='"+SubCategoryID+"'/>");
	out.println("<input type='hidden' name='WS_NAME' id='WS_NAME' value='"+WS+"'/>");
	out.println("<input type='hidden' name='username' id='username' value='"+user+"'/>");
	out.println("<input type='hidden' name='WINAME' id='WINAME' value='"+WINAME+"'/>");
	
%>


</BODY>
</Form>
</HTML>
