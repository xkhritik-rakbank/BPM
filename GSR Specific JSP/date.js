/*
		Product         :       OmniFlow 7.0
		Application     :       OmniFlow Web Desktop
		Module          :       Date
		File            :       date.js
		Purpose         :       Contains the functions used for date in the project.

		Change History  :

		Problem No        Correction Date		Comments
		-----------       ----------------             ----------
                5753               14/jul/2008                 proper validation check for time was not present for hour field
                WCL_8.0_070     28/07/2009          Puneet Pahuja               Time Zone Support
*/

/**************************************************************************************************
Valid Date Formats:
					MM/DD/YYYY
					M/D/YYYY

					DD/MM/YYYY
					DD/MMM/YYYY
					D/M/YYYY

					YYYY/MM/DD
					YYYY/MMM/DD

Date Separator : "/"


functions implemented:

1.function ValidateDateFormat(val,sDateFormat)
This function validates the given value according to the dateformat

2.function isValidDate1(date) default format id DD/MM/YYYY

3.function is1Date(Day,Month,Year)
This function checks the date for its validity that if the user has input any wrong date: to be incororated in combos

4.function LocalToDB(sLocalDate,sDateFor)
This function changes the format from the local to the database format with the dateseparator ="/"

5.function DBToLocal(sDbDate,sDateFor)
This function changes dataBase Date to the local date format

6.function getCurrentDateTimeInDbFormat()
This function gets the current date and returns the date in database format ,i.e,YYYY-MM-DD HH:MM:SS

7.function getCurrentDateTimeInLocalFormat(sDateFormat)
This function gets the current date and then changes into the specified dateformat

8.function Comparedate(sDate1,SDate2,dateformat)
compares the two given dates in the given format.

**************************************************************************************************/
 
function ValidateDateFormat(val,sDateFormat)
{
	var Day;
	var Month;
	var Year;
	var Pos;
	var Pos1;
	val=Trim(val);
	if (sDateFormat=='')
	{
		sDateFormat='YYYY/MM/DD';
	}

	Pos = FindPos(val, DATESEPARATOR);
	if(Pos == -1)
	{
		alert(INVALID_FORMAT +sDateFormat); //Date should be in proper format given in 
		return 0;
	}
	
	// gets the characters from the set date format
	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf(DATESEPARATOR));

	Pos1=val.lastIndexOf(DATESEPARATOR)
	if(Pos1==-1)
	{
		alert(INVALID_FORMAT1);//"Invalid Date Format."
		return 0;
	}

	var strChar2=sDateFormat.substring(sDateFormat.indexOf(DATESEPARATOR)+1,sDateFormat.lastIndexOf(DATESEPARATOR));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf(DATESEPARATOR)+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();

	if(val != "0/0/0")
	{
		if ((strChar1=="D")||(strChar1=="DD"))
		{
			Day = val.substring(0,Pos);
			if(!IsNumericVal(Day))
			{
				alert(NON_NUMERIC_DAY);//'Day should be numeric'
				return 0;
			}
		}
		else if((strChar1=="M")||(strChar1=="MM"))
		{
			Month	= val.substring(0,Pos);
			if(!IsNumericVal(Month)) 
			{
				alert(NON_NUMERIC_MONTH);//'Month should be numeric'
				return 0;
			}
		}
		else 
		{
			Year	= val.substring(0,Pos);
			if(Year<1900 || Year.length > 4)
			{
				alert(ALERT_YEAR_LENGTH_FORMAT);//'Year should be greater than 1900 and in YYYY format'
				return 0;
			}
			if(!IsNumericVal(Year))
			{
				alert(NON_NUMERIC_YEAR);//'Year should be numeric'
				return 0;
			}
		}

		val = val.substring(Pos + 1,val.length);
		Pos = FindPos(val, DATESEPARATOR);
		if(Pos == -1)
		{
			alert(INVALID_FORMAT +sDateFormat);//"Date should be in proper format given in "
			return 0;
		}
	
			
		if ((strChar2=="D")||(strChar2=="DD"))
		{
			Day = val.substring(0,Pos);
			if(!IsNumericVal(Day))
			{
				alert(NON_NUMERIC_DAY);//'Day should be numeric'
				return 0;
			}
		}
		else if((strChar2=="MM")||(strChar2=="MMM"))
		{
			Month = val.substring(0,Pos);
			
			if (strChar2=="MMM")
			{
				Month=Month.toUpperCase();
				if(Month==JAN1)
					Month="01";
				else if(Month==FEB1)
					Month="02";
				else if(Month==MAR1)
					Month="03";
				else if(Month==APR1)
					Month="04";
				else if(Month==MAY1)
					Month="05";
				else if(Month==JUN1)
					Month="06";
				else if(Month==JUL1)
					Month="07";
				else if(Month==AUG1)
					Month="08";
				else if(Month==SEP1)
					Month="09";
				else if(Month==OCT1)
					Month="10";
				else if(Month==NOV1)
					Month="11";
				else if(Month==DEC1)
					Month="12";
				else 
				{
					alert(INVALID_MONTH_STRING+INVALID_FORMAT+sDateFormat);
					return 0;
				}
			}
			if(!IsNumericVal(Month)) 
			{
				alert(NON_NUMERIC_MONTH);//'Month should be numeric'
				return 0;
			}
		}

		var temptime="";
		if(val.indexOf(" ")!=-1)
		{
			temptime=val.substring(val.indexOf(" "),val.length);
			temptime=Trim(temptime);
			if (temptime.indexOf(":")==-1)
			{	
				alert(INVALID_TIME);//TIME should be correct format
				return 0;
			}
			var temphr=temptime.substring(0,temptime.indexOf(":"));
                        if(temphr.length>2){
                            alert(HOUR_FORAMAT_IS_HH);//'HOUR should be numeric'
			    return 0; 
                        }
			if(!IsNumericVal(temphr)||temphr>=24 ||temphr<0)
			{
				alert(NON_NUMERIC_HOUR);//'HOUR should be numeric'
				return 0;
			}

			var tempmin;
			temptime=temptime.substring(temptime.indexOf(":")+1,temptime.length);

			if (temptime.indexOf(":")!=-1)
			{
				tempmin=temptime.substring(0,temptime.indexOf(":"));
				var tempsec=temptime.substring(temptime.indexOf(":")+1,temptime.length);
                                if(tempsec.length>2){
                                     alert(SECOND_FORAMAT_IS_SS);//'HOUR should be numeric'
                                     return 0; 
                                }
				if(!IsNumericVal(tempsec)||tempsec>=60 ||tempsec<0)
				{
					alert(NON_NUMERIC_SEC);//'SEC should be numeric'
					return 0;
				}

			}
			else
				tempmin=temptime.substring(0,temptime.length);
                        if(tempmin.length>2){
                            alert(MINUTE_FORAMAT_IS_MM);//'HOUR should be numeric'
			    return 0; 
                        }
			if(!IsNumericVal(tempmin)||tempmin>=60 ||tempmin<0)
			{
				alert(NON_NUMERIC_MIN);//'MIN should be numeric'
				return 0;
			}

			val = val.substring(Pos + 1,val.indexOf(" "));
		}
		else
			val = val.substring(Pos + 1,val.length);
			
		Pos=val.length;

		if((strChar3=="D")||(strChar3=="DD"))
		{
			Day = val.substring(0,Pos);
			if(!IsNumericVal(Day))
			{
				alert(NON_NUMERIC_DAY);//'Day should be numeric'
				return 0;
			}
		}
		else
		{
			Year	= val.substring(0,Pos);
			if(Year<1900 || Year.length > 4)
			{
				alert(ALERT_YEAR_LENGTH_FORMAT);//'Year should be greater than 1900 and in YYYY format'
				return 0;
			}
			if(!IsNumericVal(Year))
			{
				alert(NON_NUMERIC_YEAR);//'Year should be numeric'
				return 0;
			}
		
		}
	}

	// Validate For Leap Year
	switch(parseInt(Month,10))
	{
		case 1 :
		case 3 :
		case 5 :
		case 7 :
		case 8 :
		case 10:
		case 12:
			if(Day > 31 || Day < 1)
			{
				alert(ALERT_VALID_DATE_31);//"Please enter valid day.\nDay should be greater than 0 and less than or equal to 31."
				return 0;
			}
			break;

		case 4 :
		case 6 :
		case 9 :
		case 11:
			if(Day > 30 || Day < 1)
			{
				alert(ALERT_VALID_DATE_30);//Please enter valid day.\nDay should be greater than 0 and less than or equal to 30.
				return 0;
			}
			break;

		case 2 :
			if((Year % 100) == 0)
				Year = parseInt(Year / 100);

			if((Year % 4) == 0)
				{
					if(Day > 29 || Day < 1)
					{
						alert(ALERT_VALID_DATE_29);//Please enter valid day.\nDay should be greater than 0 and less than or equal to 29.
						return 0;
					}
				}
			else
				{
					if(Day > 28 || Day < 1)
					{
						alert(ALERT_VALID_DATE_28);//Please enter valid day.\nDay should be greater than 0 and less than or equal to 28
						return 0;
					}
				}
				break;
			default :
				{
					alert(INVALID_DATE_MONTH);
					return 0;
				}
		}
	return 1;
}

function ValidateShortDateFormat(val,sDateFormat){
    val = Trim(val);
    if(val.indexOf(" ") != -1){
        alert(INVALID_DATE_2);
        return 0;
     }
    else
        return ValidateDateFormat(val,sDateFormat);
}

function ValidateTimeFormat(val){
    val = Trim(val);
    if (val.indexOf(":")==-1)
    {	
            alert(INVALID_TIME);
            return 0;
    }
    var temphr=val.substring(0,val.indexOf(":"));
    if(temphr=="" || !IsNumericVal(temphr)||temphr>=24 ||temphr<0)
    {
            alert(NON_NUMERIC_HOUR);//'HOUR should be numeric'
            return 0;
    }
    if(temphr.length>2){
        alert(HOUR_FORAMAT_IS_HH);//'HOUR should be numeric'
        return 0; 
    }
    var tempmin;
    val=val.substring(val.indexOf(":")+1,val.length);

    if (val.indexOf(":")!=-1)
    {
            tempmin=val.substring(0,val.indexOf(":"));
            var tempsec=val.substring(val.indexOf(":")+1,val.length);

            if(tempsec=="" || (!IsNumericVal(tempsec)) ||tempsec>=60 ||tempsec<0)
            {
                    alert(NON_NUMERIC_SEC);//'SEC should be numeric'
                    return 0;
            }
            if(tempsec.length>2){
              alert(MINUTE_FORAMAT_IS_MM);//'HOUR should be numeric'
              return 0; 
           }
    }
    else        
            tempmin=val.substring(0,val.length);
    
    if(tempmin=="" || !IsNumericVal(tempmin)||tempmin>=60 ||tempmin<0)
    {
            alert(NON_NUMERIC_MIN);//'MIN should be numeric'
            return 0;
    }
    if(tempmin.length>2){
              alert(SECOND_FORAMAT_IS_SS);//'HOUR should be numeric'
              return 0; 
    }
    return 1;
}

function isValidDate1(date)
{   // validate for numeric value of year , month and day
	if(date == '0/0/0')
		return 1;

	Pos = FindPos(date, DATESEPARATOR);
	if(Pos == -1)
	{
		alert(INVALID_FORMAT); 
		return 0;
	}

	var temp =date.substring(Pos+1,date.length);
	Pos1=temp.lastIndexOf(DATESEPARATOR);
	if(Pos1==-1)
	{
		alert(INVALID_FORMAT);//"Invalid Date Format."
		return 0;
	}

	Day = date.substring(0,date.indexOf(DATESEPARATOR));
	Month = date.substring(date.indexOf(DATESEPARATOR)+1,date.lastIndexOf(DATESEPARATOR));
	Year = date.substring(date.lastIndexOf(DATESEPARATOR)+1,date.length);
    
	if (!isInteger(Day))
	{
		alert(NON_NUMERIC_DAY);//'Day should be numeric'
		return  0;
	}
	if (!isInteger(Month))
	{
		alert(NON_NUMERIC_MONTH);//'Day should be numeric'
		return  0;
	}
	if (!isInteger(Year))
	{
		alert(NON_NUMERIC_YEAR);//'Day should be numeric'
		return  0;
	}
		
	//validate year
	if(Year<1900 || Year.length > 4)
	{
		alert(ALERT_YEAR_LENGTH_FORMAT);//'Year should be greater than 1900 and in YYYY format'
		return 0;
	}
	
	if(Day.substring(0,1)=='0')
		Day = Day.substring(1,Day.length);
	
	if(Month.substring(0,1)=='0')
		Month = Month.substring(1,Month.length);

	switch(parseInt(Month))
	{
		case 1 :
		case 3 :
		case 5 :
		case 7 :
		case 8 :
		case 10:
		case 12:
			if(Day > 31 || Day < 1)
			{
				alert(ALERT_VALID_DATE_31);
				return 0;
			}
			break;

		case 4 :
		case 6 :
		case 9 :
		case 11:
			if(Day > 30 || Day < 1)
			{
				alert(ALERT_VALID_DATE_30);
				return 0;
			}
			break;

		case 2 :
			if((Year % 4) == 0)
			{
				if((Year % 100 == 0 ) && (Year % 400 != 0))
				{
					if(Day > 28 || Day < 1)
					{
						alert(ALERT_VALID_DATE_28);
						return 0;
					}
				}
				else if(Day > 29 || Day < 1)
				{
					alert(ALERT_VALID_DATE_29);
					return 0;
				}
			}
			else
			{
				if(Day > 28 || Day < 1)
				{
					alert(ALERT_VALID_DATE_28);
					return 0;
				}
			}
			break;
		default :
		return 1;
	}
	return 1;
}



function is1Date(Day,Month,Year)
{   // validate for numeric value of year , month and day
	if (!isInteger(Day))
	{
		alert(NON_NUMERIC_DAY);//'Day should be numeric'
		return  0;
	}
	if (!isInteger(Month))
	{
		alert(NON_NUMERIC_MONTH);//'Month should be numeric'
		return  0;
	}
	if (!isInteger(Year))
	{
		alert(NON_NUMERIC_YEAR);//'Year should be numeric'
		return  0;
	}
		
	//validate year
	if(Year<1900 || Year.length > 4)
	{
		alert(ALERT_YEAR_LENGTH_FORMAT);//'Year should be greater than 1900 and in YYYY format'
		return 0;
	}
	
	if(Day.substring(0,1)=='0')
		Day = Day.substring(1,Day.length);
	
	if(Month.substring(0,1)=='0')
		Month = Month.substring(1,Month.length);


	switch(parseInt(Month))
	{
		case 1 :
		case 3 :
		case 5 :
		case 7 :
		case 8 :
		case 10:
		case 12:
			if(Day > 31 || Day < 1)
			{
				alert(ALERT_VALID_DATE_31);
				return 0;
			}
			break;

		case 4 :
		case 6 :
		case 9 :
		case 11:
			if(Day > 30 || Day < 1)
			{
				alert(ALERT_VALID_DATE_30);
				return 0;
			}
			break;

		case 2 :
			if((Year % 4) == 0)
			{
				if((Year % 100 == 0 ) && (Year % 400 != 0))
				{
					if(Day > 28 || Day < 1)
					{
						alert(ALERT_VALID_DATE_28);
						return 0;
					}
				}
				else if(Day > 29 || Day < 1)
				{
					alert(ALERT_VALID_DATE_29);
					return 0;
				}
			}
			else
			{
				if(Day > 28 || Day < 1)
				{
					alert(ALERT_VALID_DATE_28);
					return 0;
				}
			}
			break;
		default :
		return 1;
	}
	return 1;
}



function LocalToDB(sLocalDate,sDateFormat,noOffset)
{
        /*alert("iClientTimeDiff: "+iClientTimeDiff);
        alert("iServerTimeDiff: "+iServerTimeDiff);*/

        sLocalDate=Trim(sLocalDate);
	if(Trim(sLocalDate)== '')
		return '';
	var sDateSeparator=DATESEPARATOR;
	var nBegIndex=sLocalDate.indexOf(sDateSeparator);
	//Gets the value of the date from local
	var temp;
	var strtemp1 = sLocalDate.substring(0,sLocalDate.indexOf(sDateSeparator));
	var strtemp2 = sLocalDate.substring(nBegIndex+1,sLocalDate.lastIndexOf(sDateSeparator));
	var strtemp3;
	var strTime;

	if (sLocalDate.indexOf(" ")!=-1)
	{
		strtemp3 = sLocalDate.substring(sLocalDate.lastIndexOf(sDateSeparator)+1,sLocalDate.indexOf(" "));
		strTime = sLocalDate.substring(sLocalDate.indexOf(" "),sLocalDate.length);
	}
	else
	{
		strtemp3 = sLocalDate.substring(sLocalDate.lastIndexOf(sDateSeparator)+1,sLocalDate.length);
		strTime = " 00:00:00";
	}

	var strResult="";
	var strYear = "";
	var strMonth = "";
	var strDay = "";

	// gets the characters from the set date format
	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf(sDateSeparator));
	var strChar2=sDateFormat.substring(sDateFormat.indexOf(sDateSeparator)+1,sDateFormat.lastIndexOf(sDateSeparator));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf(sDateSeparator)+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();

	if ((strChar1=="D")||(strChar1=="DD"))
	{
		temp=parseInt(strtemp1,10);
		if ((strChar1=="D")&& (temp<10))
			strDay="0"+strtemp1; 
		else
			strDay=strtemp1;
	}
	else if((strChar1=="M")||(strChar1=="MM"))
	{
		temp=parseInt(strtemp1,10);
		if ((strChar1=="M")&& (temp<10))
			strMonth="0"+strtemp1;
		else
			strMonth=strtemp1;
	}
	else 
	{
		strYear=strtemp1;
	}

	if ((strChar2=="D")||(strChar2=="DD"))
	{
		temp=parseInt(strtemp2,10);
		if ((strChar2=="D")&& (temp<10))
			strDay="0"+strtemp2; 
		else
			strDay=strtemp2;
	}
	else if((strChar2=="MM")||(strChar2=="MMM"))
	{
		if (strChar2=="MMM")
		{
			strtemp2=strtemp2.toUpperCase();
			if(strtemp2==JAN1)
				strMonth="01";
			else if(strtemp2==FEB1)
				strMonth="02";
			else if(strtemp2==MAR1)
				strMonth="03";
			else if(strtemp2==APR1)
				strMonth="04";
			else if(strtemp2==MAY1)
				strMonth="05";
			else if(strtemp2==JUN1)
				strMonth="06";
			else if(strtemp2==JUL1)
				strMonth="07";
			else if(strtemp2==AUG1)
				strMonth="08";
			else if(strtemp2==SEP1)
				strMonth="09";
			else if(strtemp2==OCT1)
				strMonth="10";
			else if(strtemp2==NOV1)
				strMonth="11";
			else if(strtemp2==DEC1)
				strMonth="12";
			}
			else
				strMonth=strtemp2;
	}

	if((strChar3=="D")||(strChar3=="DD"))
	{
		temp=parseInt(strtemp3,10);
		if ((strChar3=="D")&& (temp<10))
			strDay="0"+strtemp3; 
		else
			strDay=strtemp3;
	}
	else
		strYear=strtemp3;

	strResult=strYear+"-"+strMonth+"-"+strDay+""+strTime;

        if(!noOffset && bEnableTimeZone == 'Y')
        {
            try
            {
                var timeDiff = (iServerTimeDiff-0)-(iClientTimeDiff-0);
                //alert("Original DB Date: "+strResult);
                strResult = addMinutesToDBDate(strResult,timeDiff);
            //alert("New DB Date: "+strResult);
            }
            catch(e)
            {}
        }

	return strResult;
}

function DBToLocal(sDbDate,sDateFormat,noOffset)
{
    if(!noOffset && bEnableTimeZone == 'Y')
    {
        try
        {
            var timeDiff = (iClientTimeDiff-0)-(iServerTimeDiff-0);
          //  alert("Original DB Date: "+sDbDate);
            sDbDate = addMinutesToDBDate(sDbDate,timeDiff);
        //alert("New DB Date: "+sDbDate);
        }
        catch(e)
        {}
    }

	var sDateSeparator=DATESEPARATOR;
	if(sDbDate=='')
		return ' ';
	var nBegIndex=sDbDate.indexOf(sDateSeparator);
	//Gets the value of the date from DB
	var strYear = sDbDate.substring(0,sDbDate.indexOf(sDateSeparator));
	var strMonth = sDbDate.substring(nBegIndex+1,sDbDate.lastIndexOf(sDateSeparator));
	var strDay;
	var strTime="";
	if (sDbDate.indexOf(" ")!=-1)
	{
		strDay = sDbDate.substring(sDbDate.lastIndexOf(sDateSeparator)+1,sDbDate.indexOf(" "));
		var strtimetemp=sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.length);
		var index=strtimetemp.indexOf(":");
		var lastIndex=strtimetemp.lastIndexOf(":");

		if(index==lastIndex)
			strTime=strtimetemp;
		else
			strTime = sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.lastIndexOf(":")+3);//gets the seconds as well

		if (strTime=="00:00:00")
			strTime="";
	}
	else
		strDay = sDbDate.substring(sDbDate.lastIndexOf(sDateSeparator)+1,sDbDate.length);

	var strtemp1="";
	var strtemp2="";
	var strtemp3="";
	var strResult="";
	var tempDay="";
	var tempMon="";

	// gets the characters from the set date format
	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf(sDateSeparator));
	var strChar2=sDateFormat.substring(sDateFormat.indexOf(sDateSeparator)+1,sDateFormat.lastIndexOf(sDateSeparator));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf(sDateSeparator)+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();

	if ((strChar1=="D")||(strChar1=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar1=="D")&& (tempDay<10))
			strtemp1=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp1=strDay;
	}
	else if((strChar1=="M")||(strChar1=="MM"))
	{
		tempMon=parseInt(strMonth,10);
		if ((strChar1=="M")&& (tempMon <10))
			strtemp1=strMonth.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp1=strMonth;
	}
	else
	{
		if ((strChar1=="YY")||(strChar1=="YYYY"))
		{
			if (strChar1=="YY")
				strtemp1=strYear.substring(2,strYear.length);//getting the last two
			else
				strtemp1=strYear;
		}
	}

	if ((strChar2=="D")||(strChar2=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar2=="D")&& (tempDay <10))
			strtemp2=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp2=strDay;
	}
	else if((strChar2=="MM")||(strChar2=="MMM"))
	{
		if (strChar2=="MMM")
		{
			switch(parseInt(strMonth,10))
			{
				case 1:
					strtemp2=JAN;
					break;
				case 2:
					strtemp2=FEB;
					break;
				case 3:
					strtemp2=MAR;
					break;
				case 4:
					strtemp2=APR;
					break;
				case 5:
					strtemp2=MAY;
					break;
				case 6:
					strtemp2=JUN;
					break;
				case 7:
					strtemp2=JUL;
					break;
				case 8:
					strtemp2=AUG;
					break;
				case 9:
					strtemp2=SEP;
					break;
				case 10:
					strtemp2=OCT;
					break;
				case 11:
					strtemp2=NOV;
					break;
				case 12:
					strtemp2=DEC;
					break;
			}
		}
			else
				strtemp2=strMonth;
	}


	if((strChar3=="D")||(strChar3=="DD"))
	{
		tempDay=parseInt(strDay,10);
		if ((strChar3=="D") && (tempDay < 10))
			strtemp3=strDay.substring(1,2); //getting the last value like 03 ->3
		else
			strtemp3=strDay;
	}
	else
	{
		if ((strChar3=="YY")||(strChar3=="YYYY"))
		{
			if (strChar3=="YY")
				strtemp3=strYear.substring(2,strYear.length);//getting the last two
			else
				strtemp3=strYear;
		}
	}
	if ((strtemp1=='')&&(strtemp2==''))
		return strtemp3+" "+strTime;
	else if ((strtemp3=='')&&(strtemp2==''))
		return strtemp1+" "+strTime;
	else if ((strtemp3=='')&&(strtemp1==''))
		return strtemp2+" "+strTime;
	else if (strtemp1=='')
		return strtemp2+sDateSeparator+strtemp3+" "+strTime;
	else if (strtemp2=='')
		return strtemp1+sDateSeparator+strtemp3+" "+strTime;
	else if (strtemp3=='') 
		return strtemp1+sDateSeparator+strtemp2+" "+strTime;

	strResult=strtemp1+sDateSeparator+strtemp2+sDateSeparator+strtemp3+" "+strTime;
	return strResult;
 }


function addMinutesToDBDate(sDbDate,iMinutes)
{
    if(sDbDate=='')
        return ' ';
    var nBegIndex=sDbDate.indexOf(DATESEPARATOR);
    //Gets the value of the date from DB
    var strYear = sDbDate.substring(0,sDbDate.indexOf(DATESEPARATOR));
    var strMonth = sDbDate.substring(nBegIndex+1,sDbDate.lastIndexOf(DATESEPARATOR))-1;
    var strDay;
    var strTime="";
    if (sDbDate.indexOf(" ")!=-1)
    {
        strDay = sDbDate.substring(sDbDate.lastIndexOf(DATESEPARATOR)+1,sDbDate.indexOf(" "));
        var strtimetemp=sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.length);
        var index=strtimetemp.indexOf(":");
        var lastIndex=strtimetemp.lastIndexOf(":");

        if(index==lastIndex)
            strTime=strtimetemp;
        else
            strTime = sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.lastIndexOf(":")+3);//gets the seconds as well

        if (strTime=="00:00:00")
            strTime="";
    }
    else
        strDay = sDbDate.substring(sDbDate.lastIndexOf(DATESEPARATOR)+1,sDbDate.length);

    var Hour = 0;
    var Min = 0;
    var Sec = 0;

    if(strTime.length>0)
    {
        Hour=strTime.substring(0,strTime.indexOf(":"));
        strTime=strTime.substring(strTime.indexOf(":")+1,strTime.length);

        Min=strTime.substring(0,strTime.indexOf(":"));
        Sec=strTime.substring(strTime.indexOf(":")+1,strTime.length);
    }

    var date=new Date(strYear,strMonth,strDay,Hour,Min,Sec);

    //alert(date);

    var dateMillis = date.valueOf();

    var MillisToAdd = (iMinutes-0)*60*1000;

    var newDateMillis = dateMillis+MillisToAdd;
    var newDate = new Date(newDateMillis);

    //alert(newDate);

    var newday = newDate.getDate();
    if (newday <10)
        newday= "0"+newday;

    var newmonth = newDate.getMonth() +1;
    if (newmonth <10) newmonth= "0"+newmonth;

    var newhr = newDate.getHours();
    if (newhr <10) newhr= "0"+newhr;

    var newmin = newDate.getMinutes();
    if (newmin <10) newmin= "0"+newmin;

    var nwsec = newDate.getSeconds();
    if (nwsec <10) nwsec= "0"+nwsec;

    var newDBDate = newDate.getFullYear()+ DATESEPARATOR + newmonth  + DATESEPARATOR+ newday +" " + newhr +":" +newmin +":" + nwsec ;

    return newDBDate;
}
function addMinutesToDBDate2(sDbDate,iMinutes)
{
    if(sDbDate=='')
        return ' ';
    var nBegIndex=sDbDate.indexOf("-");
    //Gets the value of the date from DB
    var strYear = sDbDate.substring(0,sDbDate.indexOf("-"));
    var strMonth = sDbDate.substring(nBegIndex+1,sDbDate.lastIndexOf("-"))-1;
    var strDay;
    var strTime="";
    if (sDbDate.indexOf(" ")!=-1)
    {
        strDay = sDbDate.substring(sDbDate.lastIndexOf("-")+1,sDbDate.indexOf(" "));
        var strtimetemp=sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.length);
        var index=strtimetemp.indexOf(":");
        var lastIndex=strtimetemp.lastIndexOf(":");

        if(index==lastIndex)
            strTime=strtimetemp;
        else
            strTime = sDbDate.substring(sDbDate.indexOf(" ")+1,sDbDate.lastIndexOf(":")+3);//gets the seconds as well

        if (strTime=="00:00:00")
            strTime="";
    }
    else
        strDay = sDbDate.substring(sDbDate.lastIndexOf("-")+1,sDbDate.length);

    var Hour = 0;
    var Min = 0;
    var Sec = 0;

    if(strTime.length>0)
    {
        Hour=strTime.substring(0,strTime.indexOf(":"));
        strTime=strTime.substring(strTime.indexOf(":")+1,strTime.length);

        Min=strTime.substring(0,strTime.indexOf(":"));
        Sec=strTime.substring(strTime.indexOf(":")+1,strTime.length);
    }

    var date=new Date(strYear,strMonth,strDay,Hour,Min,Sec);

    //alert(date);

    var dateMillis = date.valueOf();

    var MillisToAdd = (iMinutes-0)*60*1000;

    var newDateMillis = dateMillis+MillisToAdd;
    var newDate = new Date(newDateMillis);

    //alert(newDate);

    var newday = newDate.getDate();
    if (newday <10)
        newday= "0"+newday;

    var newmonth = newDate.getMonth() +1;
    if (newmonth <10) newmonth= "0"+newmonth;

    var newhr = newDate.getHours();
    if (newhr <10) newhr= "0"+newhr;

    var newmin = newDate.getMinutes();
    if (newmin <10) newmin= "0"+newmin;

    var nwsec = newDate.getSeconds();
    if (nwsec <10) nwsec= "0"+nwsec;

    var newDBDate = newDate.getFullYear()+ "-" + newmonth  + "-"+ newday +" " + newhr +":" +newmin +":" + nwsec ;

    return newDBDate;
}



function getCurrentDateTimeInDbFormat()
{
	var currentDateTime = new Date();

	var day = currentDateTime.getDate();

	if (day <10) day= "0"+day;

	var month = currentDateTime.getMonth() +1;
	if (month <10) month= "0"+month;

	var hr = currentDateTime.getHours();
	if (hr <10) hr= "0"+hr;

	var min = currentDateTime.getMinutes();
	if (min <10) min= "0"+min;

	var sec = currentDateTime.getSeconds();
	if (sec <10) sec= "0"+sec;

	var strStatusTime = currentDateTime.getFullYear()+ "-" + month  + "-"+ day +" " + hr +":" +min +":" + sec ;
	return strStatusTime;
}

//gets the current date and then changes into the given dateformat
function getCurrentDateTimeInLocalFormat(sDateFormat)
{
	var currentDateTime = new Date();
	var day = currentDateTime.getDate();
	var month = currentDateTime.getMonth() +1;
	var year=currentDateTime.getFullYear();
	var hr = currentDateTime.getHours();

	if (hr <10) hr= "0"+hr;

	var min = currentDateTime.getMinutes();
	if (min <10) min= "0"+min;

	var sec = currentDateTime.getSeconds();
	if (sec <10) sec= "0"+sec;

	var temp1;
	var temp2;
	var temp3;
	var Result;
	var DateSep=DATESEPARATOR; //date separator.

	var strChar1=sDateFormat.substring(0,sDateFormat.indexOf(DateSep));
	var strChar2=sDateFormat.substring(sDateFormat.indexOf(DateSep)+1,sDateFormat.lastIndexOf(DateSep));
	var strChar3=sDateFormat.substring(sDateFormat.lastIndexOf(DateSep)+1,sDateFormat.length);

	strChar1=strChar1.toUpperCase();
	strChar2=strChar2.toUpperCase();
	strChar3=strChar3.toUpperCase();


	if ((strChar1=="D")||(strChar1=="DD"))
	{
		if((strChar1=="DD") && (day <10))
			temp1= "0"+day;
		else
			temp1=day;
	}
	else if((strChar1=="M")||(strChar1=="MM"))
	{
		if((strChar1=="MM") && (month <10))
			  temp1= "0"+month;
		else
			temp1=month;
	}
	else 
		temp1=year;
	
	if ((strChar2=="D")||(strChar2=="DD"))
	{
		if((strChar2=="DD") && (day <10))
			temp2= "0"+day;
		else
			temp2=day;
	}
	else if((strChar2=="MM")||(strChar2=="MMM"))
	{
		if (strChar2=="MMM")
		{
			switch(parseInt(month,10))
			{
				case 1:
					temp2=JAN;
					break;
				case 2:
					temp2=FEB;
					break;
				case 3:
					temp2=MAR;
					break;
				case 4:
					temp2=APR;
					break;
				case 5:
					temp2=MAY;
					break;
				case 6:
					temp2=JUN;
					break;
				case 7:
					temp2=JUL;
					break;
				case 8:
					temp2=AUG;
					break;
				case 9:
					temp2=SEP;
					break;
				case 10:
					temp2=OCT;
					break;
				case 11:
					temp2=NOV;
					break;
				case 12:
					temp2=DEC;
					break;
			}
		}
			else
			{
			if ((strChar2=="MM") && (month<10))
				temp2="0"+month;
			else
				temp2=month;
			}
	}
	if((strChar3=="D")||(strChar3=="DD"))
	{
		if((strChar3=="DD") && (day <10))
			temp3= "0"+day;
		else
			temp3=day;
	}
	else
	{
		if ((strChar3=="YY")||(strChar3=="YYYY"))
		{
			if (strChar3=="YY")
				temp3=year.substring(2,year.length);//getting the last two
			else
				temp3=year;
		}
	}

	Result=temp1 +DateSep +temp2 +DateSep +temp3 +" "+hr +":" +min;
	return Result;
}


function Comparedate(sDate1,sDate2,sDateFormat)
{
	var Date1=LocalToDB(sDate1,sDateFormat);
	var Date2=LocalToDB(sDate2,sDateFormat);
	var Year1=Date1.substring(0,Date1.indexOf(DATESEPARATOR)); //2003-12-12 12:12:12
	var Year2=Date2.substring(0,Date2.indexOf(DATESEPARATOR));

	Date1=Date1.substring(Date1.indexOf(DATESEPARATOR)+1,Date1.length);//12-12 12:12:12
	Date2=Date2.substring(Date2.indexOf(DATESEPARATOR)+1,Date2.length);

	var Month1=Date1.substring(0,Date1.indexOf(DATESEPARATOR));
	var Month2=Date2.substring(0,Date2.indexOf(DATESEPARATOR));
	Date1=Date1.substring(Date1.indexOf(DATESEPARATOR)+1,Date1.length);//12 12:12:12
	Date2=Date2.substring(Date2.indexOf(DATESEPARATOR)+1,Date2.length);

	var Day1=Date1.substring(0,Date1.indexOf(" "));
	var Day2=Date2.substring(0,Date2.indexOf(" "));
	Date1=Date1.substring(Date1.indexOf(" ")+1,Date1.length);//12:12:12
	Date2=Date2.substring(Date2.indexOf(" ")+1,Date2.length);

	var Hour1=Date1.substring(0,Date1.indexOf(":"));
	var Hour2=Date2.substring(0,Date2.indexOf(":"));
	Date1=Date1.substring(Date1.indexOf(":")+1,Date1.length);//12:12
	Date2=Date2.substring(Date2.indexOf(":")+1,Date2.length);

	var Min1=Date1.substring(0,Date1.indexOf(":"));
	var Min2=Date2.substring(0,Date2.indexOf(":"));
	var Sec1=Date1.substring(Date1.indexOf(":")+1,Date1.length);//12
	var Sec2=Date2.substring(Date2.indexOf(":")+1,Date2.length);

//new Date(yy,mm,dd,hh,mm,ss)

	var d1=new Date(Year1,Month1,Day1,Hour1,Min1,Sec1);
	var d2=new Date(Year2,Month2,Day2,Hour2,Min2,Sec2);

	var i1 = d1.valueOf();
	var i2 = d2.valueOf();
	if(i1 > i2)
		return -1;
	else 
		return 0;
}
function getNoOfDaysInMonth(month,year)
{
	switch(parseInt(month))
	{
		case 0:
			return 31;

		case 1:
			return 31;

		case 3:
			return 31;

		case 5:
			return 31;

		case 7:
			return 31;

		case 8:
			return 31;

		case 10:
			return 31;

		case 4:
			return 30;

		case 6:
			return 30;

		case 9:
			return 30;
		
		case 11:
			return 30;
               	case 12:
			return 31;
		case 2:
			if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
				return 29;
			else
				return 28;
	} 
}

function validateDurationFormat(strDuration){

    strDuration = Trim(strDuration);
    var tokens=strDuration.split(':');
    if(tokens.length != 6){
        alert(INVALID_DURATION_FORMAT);
        return 0;
    }
        
    if(tokens[0] == '' || !IsNumericVal(tokens[0]))
    {
        alert(INVALID_YEAR_LENGTH); //Year should be numeric
	return 0;
    }
    if(tokens[0] < 0){
        alert(INVALID_YEAR_LENGTH);
        return 0;
    }

    if(tokens[1] == '' || !IsNumericVal(tokens[1]))
    {
        alert(INVALID_MONTH_LENGTH); //Month should be numeric
	return 0;
    }
    if(tokens[1] < 0 || tokens[1] > 12){
        alert(INVALID_MONTH_LENGTH);
        return 0;
    }

    if(tokens[2] == '' || !IsNumericVal(tokens[2]))
    {
        alert(INVALID_DAY_LENGTH); //Day should be numeric
	return 0;
    }
    if(tokens[2] < 0 || tokens[2] > 31){
        alert(INVALID_DAY_LENGTH);
        return 0;
    }

    if(tokens[3] == '' || !IsNumericVal(tokens[3]))
    {
        alert(INVALID_HOUR_LENGTH); //Hour should be numeric
	return 0;
    }
    if(tokens[3] < 0 || tokens[3] > 24){
        alert(INVALID_HOUR_LENGTH);
        return 0;
    }

    if(tokens[4] == '' || !IsNumericVal(tokens[4]))
    {
        alert(INVALID_MINUTE_LENGTH); //Minute should be numeric
	return 0;
    }
    if(tokens[4] < 0 || tokens[4] > 60){
        alert(INVALID_MINUTE_LENGTH);
        return 0;
    }

    if(tokens[5] == '' || !IsNumericVal(tokens[5]))
    {
        alert(INVALID_SECOND_LENGTH); //Second should be numeric
	return 0;
    }
    if(tokens[5] < 0 || tokens[5] > 60){
        alert(INVALID_SECOND_LENGTH);
        return 0;
    }
    
    return 1;
}
 function durationDBtoLocal(strDbDuration){
    if(strDbDuration=="")
        return strDbDuration;
    var strResult = "";
    var strTmpDur = "";
    var strIndex1 = strDbDuration.indexOf("P");
    var strIndex2;
    if(strIndex1 != -1){
        strTmpDur = strDbDuration.substring(1);
        strIndex1 = strTmpDur.indexOf("Y");
        if(strIndex1 != -1){
            strResult = strTmpDur.substring(0, strIndex1)+":";
            strTmpDur = strTmpDur.substring(strIndex1+1);
        }
        else
            strResult = "0:";
        strIndex1 = strTmpDur.indexOf("M");
        if(strIndex1 != -1){
            strResult += strTmpDur.substring(0, strIndex1)+":";
            strTmpDur = strTmpDur.substring(strIndex1+1);
        }
        else
            strResult += "0:";
        strIndex1 = strTmpDur.indexOf("D");
        if(strIndex1 != -1){
            strResult += strTmpDur.substring(0,strIndex1)+":";
            strTmpDur = strTmpDur.substring(strIndex1+1);
        }
        else
            strResult += "0:";
    }else{
        strTmpDur = strDbDuration;
        strResult = "0:0:0:";
    }
    strIndex1 = strTmpDur.indexOf("T");
    if(strIndex1 != -1){
        strTmpDur = strTmpDur.substring(1);
        strIndex1 = strTmpDur.indexOf("H");
        if(strIndex1 != -1){
            strResult += strTmpDur.substring(0, strIndex1)+":";
            strTmpDur = strTmpDur.substring(strIndex1+1);
        }
        else
            strResult = "0:";
        strIndex1 = strTmpDur.indexOf("M");
        if(strIndex1 != -1){
            strResult += strTmpDur.substring(0, strIndex1)+":";
            strTmpDur = strTmpDur.substring(strIndex1+1);
        }
        else
            strResult += "0:";
        strIndex1 = strTmpDur.indexOf("S");
        if(strIndex1 != -1){
            strResult += strTmpDur.substring(0,strIndex1);            
        }
        else
            strResult += "0";
    }else{
        strResult += "0:0:0";
    }
   // strResult = strDbDuration.substring(strDbDuration.indexOf("P")+,strTmpDur.indexOf("Y"));
    //strTmpDur = strTmpDur.substring(strTmpDur.indexOf("Y"));
    return strResult;
  }
  
   function durationLocaltoDb(strLocalDuration){
      if(strLocalDuration=="")
          return strLocalDuration;
      var strResult=""; 
      var tokens = strLocalDuration.split(":"); 
      strResult = "P" + getAbsolutevalue(tokens[0]) + "Y" + getAbsolutevalue(tokens[1]) + "M" + getAbsolutevalue(tokens[2]) + "DT" + getAbsolutevalue(tokens[3]) + "H" + getAbsolutevalue(tokens[4]) + "M" +getAbsolutevalue(tokens[5]) + "S";
      return strResult;  
  }
function getAbsolutevalue(token){ 

     while(token.length>1 && token.indexOf("0")==0){
      token=token.substring(1); 
     } 
 return token;
} 
