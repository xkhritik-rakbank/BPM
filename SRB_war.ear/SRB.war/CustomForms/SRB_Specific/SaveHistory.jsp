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
<%!
	public static boolean SRM_SaveHistory(String WIDATA,String CategoryID,String SubCategoryID,String WSNAME,String WS_LogicalName, com.newgen.custom.wfdesktop.session.WFCustomSession wfsession,String WINAME,String remarks,String decisionNew,String RejectReason)	

	{
		try
		{
			WriteLog("Inside SRB SaveHistory---------------");
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
			WFCustomXmlResponse WFCustomXmlResponseData=null;
			WFCustomXmlResponse objWFCustomXmlResponse=null;
			String subXML="";
			String sInputXML="";
			String sOutputXML="";
			String mainCodeData="";
			int count2=0;
				
			sCabName=wfsession.getEngineName();	
			sSessionId = wfsession.getDMSSessionId();		
			sJtsIp = wfsession.getJtsIp();
			iJtsPort = wfsession.getJtsPort();
			WriteLog("sCabName,sSessionId,sJtsIp,iJtsPort="+sCabName+" "+sSessionId+" "+sJtsIp+" "+iJtsPort);

			
			
			if(true)
			{	
				//WriteLog("WIDATAFromSaveHistory="+WIDATA);
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
						

					//WriteLog("colname2="+colname2+"=");	
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
					else if(colname2.toUpperCase().equals("REMARKS_CONFIRM") && (SubCategoryID.equals("2") || SubCategoryID.equals("4")))
					{
						remarks=check2[1];
						WriteLog("Remarks for BT/CCC="+remarks);
					}
								
				}
				if(WSNAME.trim().equalsIgnoreCase("CSO"))
				{
					decision="Introduce";
				}

				WriteLog("decision="+decision);
				WriteLog("CategoryID="+CategoryID);
				WriteLog("SubCategoryID="+SubCategoryID);
				WriteLog("WINAME="+WINAME);
				WriteLog("WSNAME="+WSNAME);
				WriteLog("WS_LogicalName="+WS_LogicalName);
				WriteLog("remarks="+remarks);
				WriteLog("RejectReason="+RejectReason);
				WriteLog("decisionNew="+decisionNew);
				hist_table="usr_0_srb_wihistory";
				RejectReason=RejectReason.replaceAll("&#x23;","#");
				WriteLog("RejectReason after replace="+RejectReason);
				colname2="catIndex~subCatIndex~winame~wsname~actual_wsname~decision~actiondatetime~remarks~username~RejectReasons";
				colvalues2="''"+CategoryID+"''~''"+SubCategoryID+"''~''"+WINAME+"''~''"+WSNAME+"''~''"+WS_LogicalName+"''~''"+decisionNew+"''~getdate()~''"+remarks+"''~''"+wfsession.getUserName()+"''~''"+RejectReason+"''";
				colvalues2=colvalues2.replaceAll("&#x23;","#");
				
				WriteLog("colvalues2 save history2---"+colvalues2);
				WriteLog("WSNAME---"+WSNAME);
				param="'"+WSNAME+"','"+WINAME+"','"+colname2+"','"+colvalues2+"'";
				WriteLog("param= "+param);
				procName="SRB_WI_HISTORY_GEN";
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
					sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
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
					
					/*sInputXML="<?xml version=\"1.0\"?>" +                                                           
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>SRB_GetCutOffTime</ProcName>" +                                                                                  
					"<Params>'"+WINAME+"'</Params>" +  
					"<NoOfCols>1</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"</APProcedure2_Input>";

					WriteLog(sInputXML);
					sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("sOutputXML1 : history"+sOutputXML);
					if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1 || sOutputXML.indexOf("<MainCode>15</MainCode>")>-1)
					{
						WriteLog("Insert SRB_GetCutOffTime Successful");
						
					}
					else
					{
						WriteLog("Insert UnSuccessful");
						return false;
					}	*/
					
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