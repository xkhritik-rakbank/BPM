<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : repeatFrames.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 02-Jun-2014
//Description                : Prints a particular frame a no. of times on form depenending upon the value selected by user.
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

<%!

public StringBuilder getDynamicHtml_second(String inputXML, Map map, String Workstep,String CategoryID,String SubCategoryID, String outputData3, String DispColCount,String temp2[][],String sMappOutPutXML)
{	
	try{
	WriteLog("inputXML"+inputXML);
	WriteLog("loadcount"+loadcount);
	WriteLog("Workstep"+Workstep);
	WriteLog("SubCategoryID"+SubCategoryID);
	WriteLog("PANno"+PANno);
	WriteLog("outputData3"+outputData3);
	WriteLog("DispColCount"+DispColCount);
	}catch(Exception e){}
	StringBuilder html = new StringBuilder();
	String mainCodeData="";
	String mainCodeData2="";
	String subXML="";
	String subXML2="";
	String tablename="";
	String WS_NAME="";
	String comboid="";
	String Value="";
	String LabelName="";
	String FieldType="";
	String FieldLength="";
	String ColumnName="";
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
	XMLParser xmlParserData2=new XMLParser();
	XMLParser objXmlParser2=null;
	int recordcount2=0;
	String params="";
	
	String inputData2="";
	String outputData2="";
	String mainCodeData3="";
	String subXML3="";
	int recordcount3=0;
	XMLParser xmlParserData3=new XMLParser();
	XMLParser objXmlParser3=null;
	String FormValue="";
	
	xmlParserData3.setInputXML((sMappOutPutXML));
	
	
	int counter=xmlParserData3.getNoOfFields("CardDetails");
	for(int r=0; r<counter; r++)
	{	
		subXML3 = xmlParserData3.getNextValueOf("CardDetails");
		objXmlParser3 = new XMLParser(subXML3);
	
		for(int j=0;j<temp2.length;j++)
		{	if(temp2[j][1].indexOf("~")>-1)
			{
				String str=objXmlParser3.getValueOf(temp2[j][0]);
				WriteLog("ResponseValue str= "+str);	
				/*String QR="select FormValue from USR_0_SRM_CARDS_DECODE where ResponseTag ='"+temp2[j][0]+"' and ResponseValue='"+str+"' and IsActive='Y'";

				inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
				
				params = "ResponseTag=="+temp2[j][0]+"~~ResponseValue=="+str;
				String QR = "select FormValue from USR_0_SRM_CARDS_DECODE with (nolock) where ResponseTag =:ResponseTag and ResponseValue=:ResponseValue and IsActive='Y'";
				inputData2 = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ QR + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
			
				WriteLog("inputData2-->"+inputData2);
				
				outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData2-->"+outputData2);
				xmlParserData2=new XMLParser();
				xmlParserData2.setInputXML((outputData2));
				mainCodeData3 = xmlParserData2.getValueOf("MainCode");
				if(mainCodeData3.equals("0"))
				{
					FormValue = xmlParserData2.getValueOf("FormValue");
					if(FormValue.indexOf("$")>-1)
					{	FormValue=FormValue.substring(FormValue.indexOf("$")+1);
						FormValue=getSessionValues(FormValue, wfsession);
						WriteLog("FormValue after function call-->"+FormValue);
					}
					map.put(temp2[j][1].replaceAll("~",""),FormValue);		
				}
			}	
			else
				map.put(temp2[j][1],objXmlParser3.getValueOf(temp2[j][0]));
				
		}
	
		XMLParser xmlParserData=new XMLParser();
		XMLParser objXmlParser=null;
		xmlParserData.setInputXML((inputXML));
		//html.append("<table border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='SRM(Service Request Module) Details'><td colspan="+((i+1)*2)+" align=center class='EWLabelRB2'><b>SRM(Service Request Module) </b></td></tr></table>");
		
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		try{
			WriteLog("Number of records are "+recordcount);
		}
		catch(Exception e)
		{
		}
		int i=Integer.parseInt(DispColCount)-1;
		mainCodeData = xmlParserData.getValueOf("MainCode");
		//out.println("mainCodeData--"+mainCodeData);
		if(mainCodeData.equals("0"))
		{	
			for(int k=0; k<recordcount; k++)
			{	
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				WS_NAME = objXmlParser.getValueOf("WS_Name");
				LabelName = objXmlParser.getValueOf("LabelName");
				try 
				{
					WriteLog("LabelName=="+LabelName);
				}
				catch(Exception e){}
				if(LabelName.indexOf("SP_")==0)
				{
					is_special=LabelName.substring(0,3);
					LabelName=LabelName.substring(3);
				}
				FieldType = objXmlParser.getValueOf("FieldType");
				FieldLength = objXmlParser.getValueOf("FieldLength");
				ColumnName = objXmlParser.getValueOf("ColumnName");
				FieldOrder = objXmlParser.getValueOf("FieldOrder");
				Frameorder = objXmlParser.getValueOf("Frameorder");
				Editable = objXmlParser.getValueOf("IsEditable");
				//logical_WS_NAME=objXmlParser.getValueOf("logical_WS_NAME");
				IsMandatory=objXmlParser.getValueOf("IsMandatory");
				Pattern=objXmlParser.getValueOf("Pattern");
				if(Pattern==null||Pattern.equals("")||Pattern.equals("null"))
					Pattern="blank";
				is_workstep_req=objXmlParser.getValueOf("is_workstep_req");
				event_function=objXmlParser.getValueOf("event_function");
				event_function=event_function.replaceAll("~"," ");
				try
				{WriteLog("ColumnName and map.get(ColumnName) ="+ColumnName+map.get(ColumnName));
				}catch(Exception e)
				{
				}
				try{
					WriteLog("FieldType: "+FieldType+" FieldOrder: "+FieldOrder+" Frameorder: "+Frameorder+" LabelName :"+LabelName);
					}catch(Exception e){}
				if(Workstep.equals(WS_NAME))
				{
					
					if(FieldType.equals("NULL")&&FieldOrder.equals("1"))
					{	
						if(!Frameorder.equals("1"))
						{	
							if(i==0)
							{
							html.append("</table><table border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><b>"+LabelName+"</b></td></tr>");
							}
							else
							{ 	try{
								WriteLog("typecheck="+typecheck);
								}catch(Exception e){}
							if(typecheck.equals("R"))
							{
							}						
							else	
							{
								for(int r=0;r<i;r++)
									html.append(
									"<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
									"<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;</td>"
									);
							}	
							html.append("</tr></table><table border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><b>"+LabelName+"</b></td></tr>");
							}
						}
						else
						{
						html.append("<table border='1' cellspacing='1' cellpadding='0' width=100% ><tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='"+LabelName+"'><td colspan="+(Integer.parseInt(DispColCount)*2)+" align=left class='EWLabelRB2'><b>"+LabelName+"</b></td></tr>");
						}
						i=0;	
							
					}
					else if(!FieldOrder.equals("1"))
					{	
						if(i!=0)
							--i;
						else
						{ 
							html.append("<TR>");
							i=Integer.parseInt(DispColCount)-1;
						}
						if(!FieldType.equals("B") && !FieldType.equals("H"))
						html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;"+LabelName+"</td>");
			
			
						if(FieldType.equals("TA"))
						{	
							if(is_special.equals("SP_"))
							{
								try{
								WriteLog("In SP_ FieldType and LabelName and Editable="+FieldType+" "+LabelName+" "+Editable);
													
								}catch(Exception e){}
								
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly'  style='overflow:scroll' "+event_function+"></textarea></td>");
									}						
									else
									{	if(map.containsKey(ColumnName))
										{	
										
											if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
												html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly' style='overflow:scroll' "+event_function+">"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"</textarea></td>");
											else
												html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly' style='overflow:scroll' "+event_function+"></textarea></td>");	
										}
										else
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly' style='overflow:scroll' "+event_function+"></textarea></td>");
									}
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' "+event_function+"></textarea></td>");
									}
									else
									{	
										if(map.containsKey(ColumnName))
										{	
											try{
											WriteLog("In map.get(ColumnName)="+map.get(ColumnName));
																
											}catch(Exception e){}
												
											if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
												
												html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' style='overflow:scroll' "+event_function+">"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"</textarea></td>");
											
											else
												html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' style='overflow:scroll' "+event_function+"></textarea></td>");	
										}
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' value = '' maxlength = '"+FieldLength+"' "+event_function+"></textarea></td>");
									}
								}
								is_special="";
							
							}
							else
							{
								try{
								WriteLog("In FieldType="+FieldType);
													
								}catch(Exception e){}
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly'  style='overflow:scroll' "+event_function+"></textarea></td>");
									}						
									else
									{	if(map.containsKey(ColumnName))
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly' style='overflow:scroll' "+event_function+">"+map.get(ColumnName)+"</textarea></td>");
										else
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' readonly='readonly' style='overflow:scroll' "+event_function+"></textarea></td>");
									}
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' "+event_function+"></textarea></td>");
									}
									else
									{	
										if(map.containsKey(ColumnName))
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' maxlength = '"+FieldLength+"' "+event_function+">"+map.get(ColumnName)+"</textarea></td>");
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><textarea class='EWNormalGreenGeneral1' rows='3' cols='75' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" onkeypress='if (this.value.length > "+FieldLength+") { return false; }' value = '' maxlength = '"+FieldLength+"' "+event_function+"></textarea></td>");
									}
								}
							}
							typecheck="TA";
							try{
								WriteLog("html="+html);
													
								}catch(Exception e){}
						}	
			
				
						if(FieldType.equals("T"))
						{ 		
							if(is_special.equals("SP_"))
							{
								try{
								WriteLog("In SP_ FieldType="+FieldType+" "+LabelName+" "+is_workstep_req);
													
								}catch(Exception e){}
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
											else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
										}
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
									}
									
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+"></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+"></td>");
											else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+"></td>");
											
										}
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+" ></td>");
									}	
									
								}
								is_special="";
							
							}
							else
							{
								try{
								WriteLog("In FieldType="+FieldType);
													
								}catch(Exception e){}
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+map.get(ColumnName)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
										}
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') readonly='readonly' disabled='disabled' "+event_function+"></td>");
									}
											
									
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+"></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+map.get(ColumnName)+"' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+"></td>");
											
										}
										else
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"'  onkeyup=validateKeys(this,'"+Pattern+"') "+event_function+" ></td>");
									}	
									
								}
							}
							typecheck="T";
							try{
								WriteLog("html="+html);
													
								}catch(Exception e){}
		
						}
						else if(FieldType.equals("P"))
						{ 	
							if(is_special.equals("SP_"))
							{	
								try{
								WriteLog("In SP_ FieldType="+FieldType+" "+LabelName+" "+is_workstep_req);
													
								}catch(Exception e){}
								html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' style='width: 150px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
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
										if(LabelName.equals(comboid))
										{
											if(!(map.get(ColumnName)==null || map.get(ColumnName).equals("null")))
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
												html.append("<option value='"+Value+"' >"+Value+"</option>");
										}
									}
								}
								
								html.append("</select></td>");
								is_special="";
							
							}
							else
							{
								try{
								WriteLog("In FieldType="+FieldType);
													
								}catch(Exception e){}
								html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1' ><select width='300' id='"+SubCategoryID+"_"+ColumnName+"' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' style='width: 170px' "+event_function+" ><option value='--Select--' >--Select--</option>");
								
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
										if(LabelName.equals(comboid))
										{
											html.append("<option value='"+Value+"' >"+Value+"</option>");
										}
									}
								}
								
								html.append("</select></td>");
							}
							typecheck="P";
							try{
								WriteLog("html="+html);
													
								}catch(Exception e){}
						}
						if(FieldType.equals("D"))
						{ 		
							try{
							WriteLog("In FieldType="+FieldType);
												
							
							
							if(is_special.equals("SP_"))
							{
							
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='' onclick = '' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly disabled='disabled' "+event_function+"><a href='' onclick = '' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></a></td>");
											}
											else{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='' onclick = '' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></a></td>");
											}
										}
										else
										{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
										}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											if(((String)map.get(ColumnName)).substring(0,((String)map.get(ColumnName)).lastIndexOf("$")).equals(Workstep))
											{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+((String)map.get(ColumnName)).substring(((String)map.get(ColumnName)).lastIndexOf("$")+1)+"' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
											else{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
											
										}
										else
											{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											}
									}	
									
								}
								is_special="";
							}
							else
							{
								if(Editable.equals("N"))
								{
									if(map.isEmpty())
									{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='' onclick = '' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{		
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly disabled='disabled' "+event_function+"><a href='' onclick = '' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0'></a></td>");
										}
										else{
										html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly disabled='disabled' "+event_function+"><a href='1' onclick ='' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' ></a></td>");
											}
											
									}
												
								}
								else
								{
									if(map.isEmpty())
									{
									html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '' readonly  "+event_function+"><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\"><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
									}
									else
									{
										if(map.containsKey(ColumnName))
										{	
											String str=map.get(ColumnName)==null?"":map.get(ColumnName).toString();
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'>");
											html.append("<input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align = 'left' maxlength='"+FieldLength+"' value = '"+str+"' readonly "+event_function+">");
											html.append("<a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" >");
											html.append("<img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
											
										}
										else
										{
											html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' size = '22' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id='"+SubCategoryID+"_"+ColumnName+"' align ='left' maxlength='"+FieldLength+"' value = '' readonly "+event_function+" ><a href='' onclick = \"initialize('"+SubCategoryID+"_"+ColumnName+"');return false;\" target=\"_blank\" ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
										}
									}	
									
								}
							}
							typecheck="D";
							try{
								WriteLog("html="+html);
													
								}catch(Exception e){}
		
						}catch(Exception e){}
					}
					else if(FieldType.equals("R"))
					{  
						try{
								WriteLog("In  FieldType="+FieldType);
													
								}catch(Exception e){}
						if(Editable.equals("N"))
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' value='"+LabelName+"' checked disabled "+event_function+" ></td>");
							else
							html.append("<td><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' value='"+LabelName+"' disabled "+event_function+" ></td>");
						}
						else
						{
							if(map.containsKey(ColumnName)&&(map.get(ColumnName).equals(LabelName)))
							html.append("<td><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' value='"+LabelName+"' checked "+event_function+" ></td>");
							else
							html.append("<td><input type='radio' name='"+SubCategoryID+"_"+ColumnName+"' id='"+SubCategoryID+"_"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' value='"+LabelName+"' "+event_function+" ></td>");
						}
						typecheck="R";
						try{
								WriteLog("html="+html);
							
						}catch(Exception e){}
						
					}
					else if(FieldType.equals("B"))
					{
						
						html.append("<td>&nbsp;&nbsp;&nbsp;&nbsp;<input name='"+LabelName+"' type='button' value='"+LabelName+"' class='EWButtonRB' style='width:60px' "+event_function+" ></td>");
						
					}
					else if(FieldType.equals("H"))
					{  
							if(map.isEmpty())
							{
							html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='hidden' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"' "+event_function+" ></td>");
							}
							else
							{	
								if(map.containsKey(ColumnName))
								html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='hidden' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '"+map.get(ColumnName)+"' maxlength = '"+FieldLength+"' "+event_function+" ></td>");
								else
								html.append("<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='hidden' name='"+Pattern+"#"+IsMandatory+"#"+LabelName+"#"+is_workstep_req+"' id="+SubCategoryID+"_"+ColumnName+" value = '' maxlength = '"+FieldLength+"' "+event_function+" ></td>");
							}
						
					}
					if(i==0)
						html.append("</tr>");
						
				}
				
				}
				
			}	
		}
	}
	if(CategoryID.equals("1"))
	{
		if(Workstep.equals("PBO")||Workstep.equals("PBR"))
		{
			return html.append("<input type=hidden name='PANno' id='PANno' value='"+PANno+"' style='visibility:hidden' ></table>");
		}
		else
		{
			return html.append("<input type=hidden name='PANno' id='PANno' value='"+PANno+"' style='visibility:hidden' ></table><table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' ></td></tr><tr/></table>");
		}
	}
	else if(CategoryID.equals("3")||CategoryID.equals("5"))
	{
		if(Workstep.equals("PBO"))
		{
			return html.append("</table>");
		}
		else
		{
			return html.append("</table><table><tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' align=center >&nbsp;&nbsp;<input name='Decision_History' type='button' value='Decision History'  onclick='HistoryCaller();' class='EWButtonRB' ></td></tr><tr/></table>");
		}
	}
	else
	{
		return html.append("</table>");
	}
}
%>


<%
String params="";
String qry="";
String inputData="";
String inputData2="";
String outputData="";
String outputData2="";
String mainCodeValue="";
String mainCodeValue2="";
XMLParser xmlParserData=null;
XMLParser objXmlParser=null;
String DispColCount="";
String subXML="";
Map<String, String> map = new HashMap<String, String>();
int repeatValue=Integer.parseInt(request.getParameter("repeatValue"));
String Frameorder = request.getParameter("Frameorder");
String CategoryID = request.getParameter("CategoryID");
String SubCategoryID = request.getParameter("SubCategoryID");
String WS = request.getParameter("WSNAME");
StringBuilder htmlcode=new StringBuilder();
/*
String QueryProcessName = "select FrmLout.Frameorder,FrmLout.WS_NAME Logical_Name,FrmLout.LabelName, FrmLout.FieldType,FrmLout.FieldLength,FrmLout.ColumnName,FrmLout.FieldOrder, rsmap.MW_RESPMAP, FrmLout.SubCatIndex, FrmLout.IsEditable, FrmLout.IsMandatory, FrmLout.Pattern, FrmLout.CatIndex, FrmLout.event_function,FrmLout.is_workstep_req, svc.Transaction_Table, dynvar.FieldValue, wrkstp.Workstep_Name WS_Name  from USR_0_SRM_FORMLAYOUT FrmLout, USR_0_SRM_CATEGORY cat, USR_0_SRM_SUBCATEGORY subcat, USR_0_SRM_INT_RSMAP rsmap,  USR_0_SRM_SERVICE svc,  USR_0_SRM_WORKSTEPS wrkstp, usr_0_srm_dynamic_variable_master dynvar where cat.CategoryIndex=FrmLout.CatIndex  and subcat.SubCategoryIndex=FrmLout.SubCatIndex  and cat.CategoryIndex=subcat.ParentCategoryIndex and upper(rsmap.FIELDNAME)='FETCH'  and   cat.CategoryIndex=rsmap.CatIndex  and subcat.SubCategoryIndex=rsmap.SubCatIndex  and cat.CategoryName ='"+CategoryID.toUpperCase()+"'  AND   subcat.SubCategoryName='"+SubCategoryID.toUpperCase()+"'  and svc.SubCatIndex=subcat.SubCategoryIndex and FrmLout.IsActive = 'Y' and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex and wrkstp.logical_name = FrmLout.ws_name and wrkstp.Workstep_NAME='"+WS.toUpperCase()+"' and cat.CategoryIndex=dynvar.CatIndex  and FrmLout.Frameorder="+Frameorder+" and subcat.SubCategoryIndex=dynvar.SubCatIndex and dynvar.FieldName='DISP_COL_COUNT' order by FrmLout.Frameorder,FrmLout.FieldOrder";
	
	inputData= "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QueryProcessName + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
params = "CategoryName=="+CategoryID.toUpperCase()+"~~SubCategoryName=="+SubCategoryID.toUpperCase()+"~~WSNAME=="+WS.toUpperCase()+"~~FrameOrder=="+Frameorder;
String QueryProcessName = "select FrmLout.Frameorder,FrmLout.WS_NAME Logical_Name,FrmLout.LabelName, FrmLout.FieldType,FrmLout.FieldLength,FrmLout.ColumnName,FrmLout.FieldOrder, rsmap.MW_RESPMAP, FrmLout.SubCatIndex, FrmLout.IsEditable, FrmLout.IsMandatory, FrmLout.Pattern, FrmLout.CatIndex, FrmLout.event_function,FrmLout.is_workstep_req, svc.Transaction_Table, dynvar.FieldValue, wrkstp.Workstep_Name WS_Name  from USR_0_SRM_FORMLAYOUT FrmLout with (nolock), USR_0_SRM_CATEGORY cat with (nolock), USR_0_SRM_SUBCATEGORY subcat with (nolock), USR_0_SRM_INT_RSMAP rsmap with (nolock),  USR_0_SRM_SERVICE svc with (nolock),  USR_0_SRM_WORKSTEPS wrkstp with (nolock), usr_0_srm_dynamic_variable_master dynvar with (nolock) where cat.CategoryIndex=FrmLout.CatIndex  and subcat.SubCategoryIndex=FrmLout.SubCatIndex  and cat.CategoryIndex=subcat.ParentCategoryIndex and upper(rsmap.FIELDNAME)='FETCH'  and   cat.CategoryIndex=rsmap.CatIndex  and subcat.SubCategoryIndex=rsmap.SubCatIndex  and cat.CategoryName =:CategoryName  AND   subcat.SubCategoryName=:SubCategoryName  and svc.SubCatIndex=subcat.SubCategoryIndex and FrmLout.IsActive = 'Y' and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex and wrkstp.logical_name = FrmLout.ws_name and wrkstp.Workstep_NAME=:WSNAME and cat.CategoryIndex=dynvar.CatIndex  and FrmLout.Frameorder=:FrameOrder and subcat.SubCategoryIndex=dynvar.SubCatIndex and dynvar.FieldName='DISP_COL_COUNT' order by FrmLout.Frameorder,FrmLout.FieldOrder";

inputData = "<?xml version='1.0'?>"+
"<APSelectWithNamedParam_Input>"+
"<Option>APSelectWithNamedParam</Option>"+
"<Query>"+ QueryProcessName + "</Query>"+
"<Params>"+ params + "</Params>"+
"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
"</APSelectWithNamedParam_Input>";
		
	outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	WriteLog("outputData-->"+outputData);
	//out.println("outputData="+outputData);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String colArray[]=new String[recordcount];
	for(int k=0; k<recordcount; k++)
	{	subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		colArray[k] = objXmlParser.getValueOf("ColumnName");
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
		CategoryID = objXmlParser.getValueOf("CatIndex");
		SubCategoryID= objXmlParser.getValueOf("SubCatIndex");
		transactionTable=objXmlParser.getValueOf("Transaction_Table");
		LogicalName=objXmlParser.getValueOf("Logical_Name");
		WriteLog("ReturnFields"+ReturnFields);
		DispColCount=objXmlParser.getValueOf("FieldValue");
		if(!ReturnFields.equals("*"))
		{
			temp= ReturnFields.split(",");
			count=temp.length;
			String check[]=null;
			temp2=new String[count][2]; 
			for(int k=0;k<count;k++)
			{
				WriteLog("temp"+temp[k]);
				check=temp[k].split("#");
				temp2[k][0]=check[0];
				temp2[k][1]=check[1];
				
			}
		}
	}	
	else
	{ //out.println("mainCodeValue="+mainCodeValue);
	}
	
	/*String qry = "select comboid,Value from USR_0_SRM_Combos cmb,USR_0_SRM_CATEGORY cat,USR_0_SRM_SUBCATEGORY subcat, USR_0_SRM_WORKSTEPS wrkstp,usr_0_srm_Service svc where cat.CategoryIndex=cmb.CatIndex and subcat.SubCategoryIndex=cmb.SubCatIndex and upper(cat.CategoryName) ='"+CategoryID.toUpperCase()+"' AND upper(subcat.SubCategoryName)='"+SubCategoryID.toUpperCase()+"' and subcat.parentcategoryindex=cat.CategoryIndex  and cmb.IsActive = 'Y' and upper(wrkstp.Workstep_Name)='"+WS.toUpperCase()+"' and cmb.Ws_Name = wrkstp.Logical_Name and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex ";
	
	inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + qry + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	params = "CategoryName=="+CategoryID.toUpperCase()+"~~SubCategoryName=="+SubCategoryID.toUpperCase()+"~~WSNAME=="+WS.toUpperCase();
		String qry = "select comboid,Value from USR_0_SRM_Combos cmb with (nolock),USR_0_SRM_CATEGORY cat with (nolock),USR_0_SRM_SUBCATEGORY subcat with (nolock), USR_0_SRM_WORKSTEPS wrkstp with (nolock),usr_0_srm_Service svc with (nolock) where cat.CategoryIndex=cmb.CatIndex and subcat.SubCategoryIndex=cmb.SubCatIndex and upper(cat.CategoryName) =:CategoryName AND upper(subcat.SubCategoryName)=:SubCategoryName and subcat.parentcategoryindex=cat.CategoryIndex  and cmb.IsActive = 'Y' and upper(wrkstp.Workstep_Name)=:WSNAME and cmb.Ws_Name = wrkstp.Logical_Name and wrkstp.SR_ID=svc.SR_ID and svc.CatIndex=cat.CategoryIndex and svc.SubCatIndex=subcat.SubCategoryIndex ";
		inputData2 = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ qry + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";

	outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	xmlParserData.setInputXML((outputData2));
	mainCodeData2 = xmlParserData.getValueOf("MainCode");
	if(mainCodeData2.equals("0"))
	{
		WriteLog("Test mainCodeData2 "+mainCodeData2);
	
	}
	if(WS.equals("PBR")&&FlagValue.equals("N"))	
	{	
		/*if(CategoryID.equals("1"))
		{	
			PANno=request.getParameter("panNo");
			PANno = encrypt(PANno);
		}
		else*/				
		repeatValue=request.getParameter("repeatValue");
		WriteLog("repeatValue"+repeatValue);
		if(!(repeatValue==null))
		{
			
			String sCatname="CARDFETCH";
			
			try
			{
				sCabname=wfsession.getEngineName();
				sSessionId = wfsession.getSessionId();
				sJtsIp = wfsession.getJtsIp();
				iJtsPort = wfsession.getJtsPort();
				WriteLog("sCabname is : "+sCabname+" sSessionId is:  "+sSessionId+" sJtsIp: "+sJtsIp);
			}
			catch(Exception ex){
				WriteLog(ex.getMessage().toString());
			}	
			String	sInputXML =	"<?xml version=\"1.0\"?>\n" +
					"<APAPMQPutGetMessage>\n" +
					"<Option>SRM_APMQPutGetMessage</Option>\n" +
					"<UserID>"+wfsession.getUserName()+"</UserID>\n" +
					"<CardNumber>"+repeatValue+"</CardNumber>\n"+ 
					"<SessionId>"+sSessionId+"</SessionId>\n"+
					"<EngineName>"+sCabname+"</EngineName>\n" +
					"<CategoryName>"+sCatname+"</CategoryName>\n" +
					"</APAPMQPutGetMessage>\n";
			String sMappOutPutXML="";
			String FormValue="";
			WriteLog("sInputXML  "+sInputXML);
			try
			{
				
				//sMappOutPutXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				
				if(CategoryID.equals("1")&&SubCategoryID.equals("2"))
				sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><card_type2>MASTER</card_type2><product_level>Titanium</product_level><card_holder_type2>1900-01-01</card_holder_type2><expiry_date>0.00</expiry_date><c_o_a>0.00</c_o_a><eligible_bt_amount>0.00</eligible_bt_amount><eligible_bt_amount_words>0.00</eligible_bt_amount_words><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><card_type2>MASTER</card_type2><product_level>Titanium</product_level><card_holder_type2>1900-01-01</card_holder_type2><expiry_date>0.00</expiry_date><c_o_a>0.00</c_o_a><eligible_bt_amount>0.00</eligible_bt_amount><eligible_bt_amount_words>0.00</eligible_bt_amount_words><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>004</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails></EE_EAI_MESSAGE>";
				
				else  if(CategoryID.equals("1")&&SubCategoryID.equals("3"))
				
				sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>12213421545546</card_number><crn>723478</crn><card_holder_name2>user1</card_holder_name2><card_type2>MASTER</card_type2><product_level>Titanium</product_level><card_holder_type2>1900-01-01</card_holder_type2><expiry_date>0.00</expiry_date><c_o_a>0.00</c_o_a><eligible_bt_amount>0.00</eligible_bt_amount><eligible_bt_amount_words>0.00</eligible_bt_amount_words><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><card_expiry_date>1900-01-01</card_expiry_date><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><card_type>Credit</card_type><CardSubType>Platinum</CardSubType><card_status>004</card_status><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><card_number>12213421545546</card_number><crn>723478</crn><card_holder_name2>user2</card_holder_name2><card_type2>MASTER</card_type2><product_level>Titanium</product_level><card_holder_type2>1900-01-01</card_holder_type2><expiry_date>0.00</expiry_date><c_o_a>0.00</c_o_a><eligible_bt_amount>0.00</eligible_bt_amount><eligible_bt_amount_words>0.00</eligible_bt_amount_words><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1200</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><card_expiry_date>1900-01-01</card_expiry_date><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><card_type>Credit</card_type><CardSubType>Platinum</CardSubType><card_status>004</card_status><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails></EE_EAI_MESSAGE>";
				
				WriteLog(sMappOutPutXML);
				
			}
			catch(Exception exp){
				//bError=true;
			}
			WriteLog("sMappOutPutXML is : "+sMappOutPutXML);
			
			/*xmlParserData.setInputXML((sMappOutPutXML));
			for(int i=0;i<count;i++)
			{	if(temp2[i][1].indexOf("~")>-1)
				{
					String str=xmlParserData.getValueOf(temp2[i][0]);
					WriteLog("ResponseValue str= "+str);
					/*String QR="select FormValue from USR_0_SRM_CARDS_DECODE where ResponseTag ='"+temp2[i][0]+"' and ResponseValue='"+str+"' and IsActive='Y'";

					inputData2 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QR + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
					
					params = "ResponseTag=="+temp2[i][0]+"~~ResponseValue=="+str;
					String QR="select FormValue from USR_0_SRM_CARDS_DECODE with (nolock) where ResponseTag =:ResponseTag and ResponseValue=:ResponseValue and IsActive='Y'";
					inputData2 = "<?xml version='1.0'?>"+
					"<APSelectWithNamedParam_Input>"+
					"<Option>APSelectWithNamedParam</Option>"+
					"<Query>"+ QR + "</Query>"+
					"<Params>"+ params + "</Params>"+
					"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
					"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
					"</APSelectWithNamedParam_Input>";
				
					WriteLog("inputData2-->"+inputData2);
					
					outputData2 = WFCallBroker.execute(inputData2, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
					WriteLog("outputData2-->"+outputData2);
					xmlParserData2=new XMLParser();
					xmlParserData2.setInputXML((outputData2));
					mainCodeData = xmlParserData2.getValueOf("MainCode");
					if(mainCodeData.equals("0"))
					{
						FormValue = xmlParserData2.getValueOf("FormValue");
						if(FormValue.indexOf("$")>-1)
						{	FormValue=FormValue.substring(FormValue.indexOf("$")+1);
							FormValue=getSessionValues(FormValue, wfsession);
							WriteLog("FormValue after function call-->"+FormValue);
						}
						map.put(temp2[i][1].replaceAll("~",""),FormValue);		
					}
				}	
				else
					map.put(temp2[i][1],xmlParserData.getValueOf(temp2[i][0]));
					
			}*/
		}
	}
	htmlcode=getDynamicHtml_second(outputData,map,WS,CategoryID,SubCategoryID,outputData2,DispColCount,temp2,sMappOutPutXML);
	WriteLog("htmlcode final-->"+htmlcode.toString());
	
	//for(int t=0;t<repeatValue;t++)
		out.println(htmlcode.toString());
	
	//out.clear();
	
	/*recordcount2 = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	WriteLog("Number of records are "+recordcount2);
	for(int k=0; k<recordcount2; k++)
	{	
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		out.println("Approved_Cash_Back_Amount"+Approved_Cash_Back_Amount);
		//out.println("objXmlParser.getValueOf('Approved_Cash_Back_Amount')="+objXmlParser.getValueOf("Approved_Cash_Back_Amount"));	
		Approved_Cash_Back_Amount+= Integer.parseInt(objXmlParser.getValueOf("Approved_Cash_Back_Amount"));
			
	}*/
%>

	