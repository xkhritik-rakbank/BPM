var NUM_CENTYEAR = 30;
var BUL_TIMECOMPONENT = false;
var BUL_YEARSCROLL = true;
var calendars = [];
var RE_NUM = /^\-?\d+$/;

function calendarfn(obj_target) 
{
	
	this.gen_date = cal_gen_date1;
	this.gen_time = cal_gen_time1;
	
	this.gen_tsmp = cal_gen_tsmp1;
	this.prs_date = cal_prs_date1;
	this.prs_time = cal_prs_time1;
	this.prs_tsmp = cal_prs_tsmp1;
	this.popup    = cal_popup1;

	if (!obj_target)
		return cal_error("Error calling the calendar: no target control specified");
	if (obj_target.value == null)
		return cal_error("Error calling the calendar: parameter specified is not valid target control");
	this.target = obj_target;
	this.time_comp = BUL_TIMECOMPONENT;
	this.year_scroll = BUL_YEARSCROLL;
	
	this.id = calendars.length;
	calendars[this.id] = this;
	
}

function cal_popup1 (str_datetime) {
	if (str_datetime) {
		this.dt_current = this.prs_tsmp(str_datetime);
	}
	else {
		this.dt_current = this.prs_tsmp(this.target.value);
		this.dt_selected = this.dt_current;
	}
	if (!this.dt_current) return;

	var obj_calwindow = window.open(
		'/RBL/webtop/scripts/RBL_Script/calendar_RBL.html?datetime=' + this.dt_current.valueOf()+ '&id=' + this.id, //
		'Calendar', 'width=200,height='+(this.time_comp ? 215 : 190)+
		',status=no,resizable=no,top=360,left=900,dependent=yes,alwaysRaised=yes'
	);
	obj_calwindow.opener = window;
	obj_calwindow.focus();
}

function cal_prs_tsmp1 (str_datetime) {
	if (!str_datetime)
		return (new Date());

	if (RE_NUM.exec(str_datetime))
		return new Date(str_datetime);
		
	var arr_datetime = str_datetime.split(' ');
	return this.prs_time(arr_datetime[1], this.prs_date(arr_datetime[0]));
}


function cal_prs_date1 (str_date) {
	var arr_date = str_date.split('/');

	if (arr_date.length != 3) return cal_error ("Invalid date format: '" + str_date + "'.\nFormat accepted is dd/mm/yyyy.");
	if (!arr_date[0]) return cal_error ("Invalid date format: '" + str_date + "'.\nNo day of month value can be found.");
	if (!RE_NUM.exec(arr_date[0])) return cal_error ("Invalid day of month value: '" + arr_date[0] + "'.\nAllowed values are unsigned integers.");
	if (!arr_date[1]) return cal_error ("Invalid date format: '" + str_date + "'.\nNo month value can be found.");
	if (!RE_NUM.exec(arr_date[1])) return cal_error ("Invalid month value: '" + arr_date[1] + "'.\nAllowed values are unsigned integers.");
	if (!arr_date[2]) return cal_error ("Invalid date format: '" + str_date + "'.\nNo year value can be found.");
	if (!RE_NUM.exec(arr_date[2])) return cal_error ("Invalid year value: '" + arr_date[2] + "'.\nAllowed values are unsigned integers.");

	var dt_date = new Date();
	dt_date.setDate(1);

	if (arr_date[1] < 1 || arr_date[1] > 12) return cal_error ("Invalid month value: '" + arr_date[1] + "'.\nAllowed range is 01-12.");
	dt_date.setMonth(arr_date[1]-1);
	 
	if (arr_date[2] < 100) arr_date[2] = Number(arr_date[2]) + (arr_date[2] < NUM_CENTYEAR ? 2000 : 1900);
	dt_date.setFullYear(arr_date[2]);

	var dt_numdays = new Date(arr_date[2], arr_date[1], 0);
	dt_date.setDate(arr_date[0]);
	if (dt_date.getMonth() != (arr_date[1]-1)) return cal_error ("Invalid day of month value: '" + arr_date[0] + "'.\nAllowed range is 01-"+dt_numdays.getDate()+".");

	return (dt_date)
}

function cal_prs_time1 (str_time, dt_date) {
	if (!dt_date) return null;
	var arr_time = String(str_time ? str_time : '').split(':');
	
	if (!arr_time[0]) dt_date.setHours(0);
	else if (RE_NUM.exec(arr_time[0]))
		if (arr_time[0] < 24) dt_date.setHours(arr_time[0]);
		else return cal_error ("Invalid hours value: '" + arr_time[0] + "'.\nAllowed range is 00-23.");
	else return cal_error ("Invalid hours value: '" + arr_time[0] + "'.\nAllowed values are unsigned integers.");
	
	if (!arr_time[1]) dt_date.setMinutes(0);
	else if (RE_NUM.exec(arr_time[1]))
		if (arr_time[1] < 60) dt_date.setMinutes(arr_time[1]);
		else return cal_error ("Invalid minutes value: '" + arr_time[1] + "'.\nAllowed range is 00-59.");
	else return cal_error ("Invalid minutes value: '" + arr_time[1] + "'.\nAllowed values are unsigned integers.");

	if (!arr_time[2]) dt_date.setSeconds(0);
	else if (RE_NUM.exec(arr_time[2]))
		if (arr_time[2] < 60) dt_date.setSeconds(arr_time[2]);
		else return cal_error ("Invalid seconds value: '" + arr_time[2] + "'.\nAllowed range is 00-59.");
	else return cal_error ("Invalid seconds value: '" + arr_time[2] + "'.\nAllowed values are unsigned integers.");

	dt_date.setMilliseconds(0);
	
	return dt_date;
}

function cal_gen_date1 (dt_datetime) {
	return (
		(dt_datetime.getDate() < 10 ? '0' : '') + dt_datetime.getDate() + "/"
		+ (dt_datetime.getMonth() < 9 ? '0' : '') + (dt_datetime.getMonth() + 1) + "/"
		+ dt_datetime.getFullYear()
	);
}

function calendarfn2(obj_target) {
	this.gen_date = cal_gen_date1;
	this.gen_time = cal_gen_time1;
	
	this.gen_tsmp = cal_gen_tsmp1;
	this.prs_date = cal_prs_date1;
	this.prs_time = cal_prs_time2;
	this.prs_tsmp = cal_prs_tsmp1;
	this.popup    = cal_popup2;

	if (!obj_target)
		return cal_error("Error calling the calendar: no target control specified");
	if (obj_target.value == null)
		return cal_error("Error calling the calendar: parameter specified is not valid target control");
	this.target = obj_target;
	this.time_comp = BUL_TIMECOMPONENT;
	this.year_scroll = BUL_YEARSCROLL;
	
	this.id = calendars.length;
	calendars[this.id] = this;
}

function cal_popup2 (str_datetime) {
	if (str_datetime) {
		this.dt_current = this.prs_tsmp(str_datetime);
	}
	else {
		this.dt_current = this.prs_tsmp(this.target.value);
		this.dt_selected = this.dt_current;
	}
	if (!this.dt_current) return;

	var obj_calwindow = window.open(
		'/RBL/webtop/scripts/calendar_CAC_DT.html?datetime=' + this.dt_current.valueOf()+ '&id=' + this.id,
		'Calendar', 'width=200,height='+(this.time_comp ? 215 : 190)+
		',status=no,resizable=no,top=200,left=200,dependent=yes,alwaysRaised=yes'
	);
	obj_calwindow.opener = window;
	obj_calwindow.focus();
}

function cal_gen_tsmp1 (dt_datetime) {
	return(this.gen_date(dt_datetime) + ' ' + this.gen_time(dt_datetime));
}

function cal_gen_time1 (dt_datetime) {
	return (
		(dt_datetime.getHours() < 10 ? '0' : '') + dt_datetime.getHours() + ":"
		+ (dt_datetime.getMinutes() < 10 ? '0' : '') + (dt_datetime.getMinutes()) + ":"
		+ (dt_datetime.getSeconds() < 10 ? '0' : '') + (dt_datetime.getSeconds())
	);
}

function cal_prs_time2 (str_time, dt_date) {
	return dt_date;
}

function cal_error (str_message) {
	alert (str_message);
	return null;
}

function DateConv(sLocalDate,sDateFormat){
	var sDateSeparator="/";
	var nBegIndex=sLocalDate.indexOf(sDateSeparator);
	
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
		strTime = "00:00:00";
	}

	var strResult="";
	var strYear = "";
	var strMonth = "";
	var strDay = "";

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

	strResult=strYear+"/"+strMonth+"/"+strDay+" "+strTime;
	return strResult;
}

function Comparedates(sDate1,sDate2,sDateFormat){
	var Date1=DateConv(sDate1,sDateFormat);
	var Date2=DateConv(sDate2,sDateFormat);
	var Year1=Date1.substring(0,Date1.indexOf("/")); //2003-12-12 12:12:12
	var Year2=Date2.substring(0,Date2.indexOf("/"));

	Date1=Date1.substring(Date1.indexOf("/")+1,Date1.length);//12-12 12:12:12
	Date2=Date2.substring(Date2.indexOf("/")+1,Date2.length);

	var Month1=Date1.substring(0,Date1.indexOf("/"));
	var Month2=Date2.substring(0,Date2.indexOf("/"));
	Date1=Date1.substring(Date1.indexOf("/")+1,Date1.length);//12 12:12:12
	Date2=Date2.substring(Date2.indexOf("/")+1,Date2.length);

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

	var d1=new Date(Year1,Month1,Day1,Hour1,Min1,Sec1);
	var d2=new Date(Year2,Month2,Day2,Hour2,Min2,Sec2);

	if((Year1 > Year2) || ((Year1 == Year2) && (Month1 > Month2)) || ((Year1 == Year2) && (Month1 == Month2) && (Day1 > Day2))  )
		return -1; //d1>d2
	else if(Year1 == Year2 && Month1 == Month2 && Day1 == Day2)
		return 1;  //d1=d2
	else
		return 0;  //d1<d2

}