<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Common to All
//File Name					 : CommonJsp.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 03-Nov-2006
//Description                : Reads date format from webdesktop.ini
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//Function Name                    : ReadDateFormat()
//Date Written (DD/MM/YYYY)        : 03-Nov-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Read date format format webdesktop.ini
//---------------------------------------------------------------------------------------------------->


<%!  public String ReadDateFormat()
        {              
                FileInputStream out=null; 
				DataInputStream in=null;
				String tempStr=null;
				StringBuffer FileName = new StringBuffer(50);
                try
                {
                        FileName.append(System.getProperty("user.dir"));
						FileName.append(File.separatorChar);
						//FileName.append("applications");
						//FileName.append(File.separatorChar);
						FileName.append("omnniflowconfiguration");
						FileName.append(File.separatorChar);
						FileName.append("webdesktopconf");
						FileName.append(File.separatorChar);
						FileName.append("webdesktop.ini");


                        out = new FileInputStream(FileName.toString());
                        in = new DataInputStream(out);
						while (in.available() !=0)
						{
                            tempStr="";
							tempStr=in.readLine();
							if(tempStr.indexOf("DateFormat")!=-1)
							{
								break;
							}
							
						}
                }
                catch (Exception e)
                {
					return "";
					//return "Error"+e.toString();
                }
				tempStr=tempStr.substring(tempStr.indexOf("=")+1);
				return tempStr;
        }
%>

<%
	String DateFormat=ReadDateFormat();
	System.out.println("DateFormat : ---"+DateFormat);
%>
