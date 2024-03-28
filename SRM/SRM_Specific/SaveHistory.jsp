<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SaveHistory.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 17-Apr-2014
//Description                : File to save data in history table on the basis of category and subcategory
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%!
	public static boolean SRM_SaveHistory(String WIDATA,String CategoryID,String SubCategoryID,String WSNAME,String WS_LogicalName, com.newgen.wfdesktop.session.WFSession wfsession,String WINAME)
	
	{
		try
		{
			WriteLog("Inside SRM SaveHistory---------------");
			String sCabName=null;
			String sSessionId = null;

			String sJtsIp = null;
			int iJtsPort = 0;
			
			String colname="";
			String colvalues="'";
			String temp[]=null;
			String inputData="";
			String outputData="";
			String mainCodeValue="";
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String subXML="";
			String sInputXML="";
			String sOutputXML="";
			String mainCodeData="";
			int count2=0;
				
			sCabName=wfsession.getEngineName();	
			sSessionId = wfsession.getSessionId();		
			sJtsIp = wfsession.getJtsIp();
			iJtsPort = wfsession.getJtsPort();
			WriteLog("sCabName,sSessionId,sJtsIp,iJtsPort="+sCabName+" "+sSessionId+" "+sJtsIp+" "+iJtsPort);
			if(SubCategoryID.equals("1") || SubCategoryID.equals("3")|| SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5"))
			{	
				WriteLog("WIDATAFromSaveHistory="+WIDATA);
				String temp2[]= WIDATA.split("~");
				count2=temp2.length;
				WriteLog("count2="+temp2.length);
				String check2[]=null;
				
				String hist_table="";
				String colname2="";
				String colvalues2="";
				String procName="";
				String param="";
				String decision="";
				String remarks="";
				
				for(int t=0;t<count2;t++)
				{
					check2=temp2[t].split("#");

					if (check2[0]==null)
					{
						colname2=null;
						continue;
					}	
					else 
						colname2=check2[0].trim();
						
					
					if(colname2.toUpperCase().equals("DECISION"))
					{
						decision=check2[1].substring(check2[1].indexOf("$")+1);
						WriteLog("decision FromSaveHistory="+colname2);	
					}
					
					else if(colname2.toUpperCase().equals("REMARKS"))
					{
						remarks=check2[1].substring(check2[1].indexOf("$")+1);
						WriteLog("Remarks FromSaveHistory="+colvalues2);
					}
					else if(colname2.toUpperCase().equals("REMARKS_CONFIRM") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5")))
					{
						remarks=check2[1];
						WriteLog("Remarks for BT/CCC="+remarks);
					}
								
				}
				if(WSNAME.trim().equalsIgnoreCase("PBO"))
				{
					decision="Introduce";
				}
				
				WriteLog("decision="+decision);
				hist_table="usr_0_srm_wihistory";
				colname2="catIndex~subCatIndex~winame~wsname~actual_wsname~decision~actiondatetime~remarks~username";
				colvalues2="''"+CategoryID+"''~''"+SubCategoryID+"''~''"+WINAME+"''~''"+WSNAME+"''~''"+WS_LogicalName+"''~''"+decision+"''~getdate()~''"+remarks+"''~''"+wfsession.getUserName()+"''";
				
				if(WSNAME.trim().equalsIgnoreCase("Q4") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5")))
				{
					colname2="catIndex~subCatIndex~winame~wsname~actual_wsname~actiondatetime~remarks~username";
				colvalues2="''"+CategoryID+"''~''"+SubCategoryID+"''~''"+WINAME+"''~''"+WSNAME+"''~''"+WS_LogicalName+"''~getdate()~''"+remarks+"''~''"+wfsession.getUserName()+"''";
				}
				param="'"+WINAME+"','"+colname2+"','"+colvalues2+"'";
				WriteLog("param= "+param);
				procName="SRM_WI_HISTORY_GEN";
				try	{
					
					sInputXML="<?xml version=\"1.0\"?>" +                                                           
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>"+procName+"</ProcName>" +                                                                                  
					"<Params>"+param+"</Params>" +  
					"<NoOfCols>1</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"</APProcedure2_Input>";

					WriteLog(sInputXML);
					sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("sOutputXML1 : history"+sOutputXML);
					if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
					{
						WriteLog("Insert Successful");
						
					}
					else
					{
						WriteLog("Insert UnSuccessful");
						return false;
					}	
				}
				catch(Exception e) 
				{
					WriteLog("<OutPut>Error in getting User Session.</OutPut>");
					return false;
				}
			}
			return true;	
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return false;
		}
		
	}	
%>