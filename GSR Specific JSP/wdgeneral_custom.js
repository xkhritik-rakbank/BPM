/*
		Product         :       OmniFlow
		Application     :       OmniFlow Web Desktop
		Module          :       General
		File            :       wdgeneral.js
		Purpose         :       Contains the general functions used in the project.

		Change History  :

		Problem No		Correction Date	    Changed By       Comments
		-----------		----------------    ----------	     ----------
		IT_6.1.2_WCL_002	14/01/2006		Ankur Jain		NGForm window should not be reloaded after executing DataEntry/Set Trigger
		IT_6.1.2_WCL_101  24/05/2006        Puneet Satija   Web control is not installed in the case of an applet form
		WCL_6.1.2_008		05/05/06        Himshikha		Multiple windows of same Workitem is opening
        WCL_6.1.2_030      29/05/2006       Tanay           new version  and delete add of document at import and scan
*/

var windowH = 360;
var windowW = 480;
var windowX = (window.screen.availHeight - windowH)/2;
var windowY = (window.screen.availWidth - windowW)/2;

var window1H = 480;
var window1W = 640;
var window1X = (window.screen.availHeight - window1H)/2-30;
var window1Y = (window.screen.availWidth - window1W)/2;

var window2H = 260;
var window2W = 250;
var window2X = (window.screen.availHeight - window2H)/2;
var window2Y = (window.screen.availWidth - window2W)/2;

var windowPH = 300;
var windowPW = 350;
var windowPX = (window.screen.availHeight - windowPH)/2;
var windowPY = (window.screen.availWidth - windowPW)/2;

var window3H = 490;
var window3W = 640;
var window3X = (window.screen.availHeight - window3H)/2-30;
var window3Y = (window.screen.availWidth - window3W)/2;

var window4H = 160;
var window4W = 210;
var window4X = (window.screen.availHeight - window4H)/2;
var window4Y = (window.screen.availWidth - window4W)/2;

var window5H = 500;
var window5W = 760;
var window5X = (window.screen.availHeight - window5H)/2 - 10;
var window5Y = (window.screen.availWidth - window5W)/2 - 5;

var windowMH = 200;
var windowMW = 130;

var windowVH = 180;
var windowVW = 280;

var windowQH=430;

function encode_utf8(ch)
{
	if (ENCODING.toUpperCase() != "UTF-8")
		return escape(ch);
	var i,bytes;
	var utf8 = new String();
	var temp;

	for(i=0, bytes = 0; i<ch.length; i++)
	{
		temp = ch.charCodeAt(i);
		if(temp < 0x80)
		{
			utf8 += String.fromCharCode(temp);
		}
		else if (temp < 0x0800)
		{
			utf8 += String.fromCharCode((temp>> 6 | 0xC0));
			utf8 += String.fromCharCode((temp & 0x3F | 0x80));			
		}
		else
		{
			utf8 += String.fromCharCode((temp>> 12 | 0xE0));
			utf8 += String.fromCharCode((temp>> 6 & 0x3F | 0x80));
			utf8 += String.fromCharCode((temp & 0x3F | 0x80));
		}
	}

	if (navigator.appName.indexOf("Netscape") == -1)
	{
		return escape(utf8);
	}
	var esc = new String();
	for(l=0;l<utf8.length;l++)
	{
		if(utf8.charCodeAt(l)<128)
			esc += escape(utf8[l]);
		else
		{	
			esc += "%";
			esc += hexArr[utf8.charCodeAt(l)>>4];
			esc += hexArr[utf8.charCodeAt(l) & 0xf];
		}
	}
	return esc;
}


function decode_utf8(utftextBytes)
{
	var utftext = unescape(utftextBytes);
	if (ENCODING.toUpperCase() != "UTF-8")
		return utftext;
	var plaintext = "",temp; 
	
	var i=c1=c2=c3=c4=0;
	 
	while(i<utftext.length)
	{
		c1 = utftext.charCodeAt(i);
		temp = '?';

		if (c1<0x80)
		{
			temp = String.fromCharCode(c1);
			i++;
		}
		else if( (c1>>5) ==	6) //2 bytes
		{
			c2 = utftext.charCodeAt(i+1);
			
			if( !((c2^0x80)&0xC0))
				temp = String.fromCharCode(((c1&0x1F)<<6) | (c2&0x3F));
			i+=2;
		}
		else if( (c1>>4) == 0xE)  //3 bytes
		{
			c2 = utftext.charCodeAt(i+1); c3 = utftext.charCodeAt(i+2);

			if( !(((c2^0x80)|(c3^0x80))&0xC0) )
				temp = String.fromCharCode(((c1&0xF)<<12) | ((c2&0x3F)<<6) | (c3&0x3F));				
			i+=3;
		}
		else
			i++;
		plaintext += temp;
	}
	return plaintext;
}


function MakeUniqueNumber()
{
	var tm = new Date();
	var milisecs = Date.parse(tm.toGMTString());
	return milisecs;
}

function Trim(val,character)
{
	if(typeof character=='undefined')
		character = ' ';

	val = new String(val);
	var len = val.length;

	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(0) != character)
			{
				break;
			}
			else
			{
				val = val.substr(1);
			}
		}
	}

	len = val.length;
	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(len - 1) != character)
			{
				return val;
			}
			else
			{
				len -= 1;
				val = val.substr(0,len);
			}
		}
	}

	return val;
}


function replaceUrl(jspUrl , keyName , keyValue)
{
	var finalUrl = "";
	var pos = jspUrl.indexOf(keyName);
	if (pos == -1 )
	{
		finalUrl =  jspUrl+"&"+keyName+"="+keyValue;
	}
	else
	{
		var part1 = jspUrl.substring(0,pos+keyName.length+1);
		var pos1 = jspUrl.indexOf("&",pos+keyName.length);
		var part2 = "";
		if (pos1 > -1)
			part2 = jspUrl.substring(pos1,jspUrl.length);
		finalUrl = part1+keyValue+part2;
	}
	return finalUrl;
}


function ComboMonths()
{
	  var str =appendTextAndValue("1",JAN);
	  str+=appendTextAndValue("2",FEB);
	  str+=appendTextAndValue("3",MAR);
	  str+=appendTextAndValue("4",APR);
	  str+=appendTextAndValue("5",MAY);
	  str+=appendTextAndValue("6",JUN);
	  str+=appendTextAndValue("7",JUL);
	  str+=appendTextAndValue("8",AUG);
	  str+=appendTextAndValue("9",SEP);
	  str+=appendTextAndValue("10",OCT);
	  str+=appendTextAndValue("11",NOV);
	  str+=appendTextAndValue("12",DEC);
	  return str;
}


function ComboGeneral(a,b)
{
	var str="";
	for(var i=a;i<=b;i++)
		str += "<option value=\""+i+"\">"+i+"</option>";
	return str;
}


function appendTextAndValue(str1,str2)
{
  var str3="<option value=\""+str1+"\">" +str2 +"</option>";
  return str3;
}


function getShortName(Name,size)
{
	if (Name.length > size + 5)
	{
		var Temp1 = replace(Name, ">", "&gt;");
		Temp1 = replace(Temp1, "<", "&lt;");
		Temp1 = replace(Temp1, "\"", "&quot;");
		tempName = Name.substring(0, size);
		tempName = replace(tempName, ">", "&gt;");
		tempName = replace(tempName, "<", "&lt;");
		tempName = replace(tempName, "\"", "&quot;");

		Name1 = tempName + "...&nbsp;<img align="+ABSBOTTOM+" border=0 src=\"/webtop/images/arrow1.gif\" title=\"" + Temp1 + "\">";
		return Name1;
	}
	else
	{
		var Temp1 = replace(Name, ">", "&gt;");
		Temp1 = replace(Temp1, "<", "&lt;");
		Temp1 = replace(Temp1, "\"", "&quot;");
		return Temp1;
	}
}

function replace(str, oldStr, newStr)
{
	var iPos = 0;
	var tempStr = "";
	var iOldStrLen = oldStr.length;
	str += ''; 
	while ((iPos = str.indexOf(oldStr)) != -1)
    {
    	tempStr = tempStr + str.substring(0, iPos) + newStr;
		str = str.substring(iPos + iOldStrLen);
	}
	tempStr = tempStr + str;
	return tempStr;
}

function getShortComboName(Name,size)
{
	if (Name.length > size + 5)
	{
		Name1 = Name.substring(0, size) + "...&nbsp;";
		return Name1;
	}
	return Name;
}


function getNoOfDays(m,y)
{
	noOfdays=30;

	if (m==1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12)
		noOfdays = 31;
	else if (m==2)
	{
		if (y%100 == 0)
			y = parseInt(y/100);

		if (y%4 != 0)
			noOfdays= 28;
		else
			noOfdays= 29;
	}
	return noOfdays;
}


function getNoOfYears()
{
	var curyear = new Date().getFullYear();
//	if(navigator.appName == "Netscape")
//		curyear = curyear + 1900;
	curyear = curyear + 1;
	return curyear;
}


function showDateTime()
{
	var currentDateTime = new Date();
	var strStatusTime = "<span class=EWLabelBlue>Status as on</span> <span class=ewlabel3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
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

	strStatusTime += day+ "-" + month  + "-"+ currentDateTime.getFullYear() +" " + hr +":" +min +":" + sec ;
	strStatusTime +="</span>	";
	return strStatusTime;
}


function getCurrentDateTime()
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

	var strStatusTime = day+ "-" + month  + "-"+ currentDateTime.getFullYear() +" " + hr +":" +min +":" + sec ;

	return strStatusTime;
}


function addwindow(winArray,newWindow)
{
	var i;
	for(i=0;i<winArray.length;i++)
		if(typeof winArray[i] =='undefined' || winArray[i]==null || winArray[i].closed)
			break;

	winArray[i] = newWindow;
}

//WCL_6.1.2_008
function isWindowExist(winArray,winName)
{
	var i;
	for(i=0;i<winArray.length;i++)
		if(typeof winArray[i] != 'undefined' && winArray[i] != null && !winArray[i].closed && winArray[i].name == winName)
			return true;

	return false;
}

function closewindows(winArray)
{
	var i;
	for(i=0;i<winArray.length;i++)
		if(typeof winArray[i] !='undefined' && winArray[i]!=null && !winArray[i].closed)
			winArray[i].close();
}


function replaceplus(Str)
{
	var			RetStr;
	var Pos	= FindPos(Str,"+");
	while(Pos != -1)
	{
		var RetStr	= Str.substring(0,Pos);
		Str	= Str.substring(Pos + 1,Str.length);
		Str=RetStr.concat(" ") + Str;
		Pos	= FindPos(Str,"+");
	}
	return Str;
}


function FindPos(Str,SearchStr)
{
	len = Str.length;
	for(i=0;i < len;++i)
	{
		if(Str.charAt(i) == SearchStr)
			return i;
	}
	return -1;
}


function TrimLeft(val)
{
	var len = val.length;
	if(len==1 && val == " ")
	{
		val = "";
		return val;
	}
	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(0) != " ")
				return val;
			else
				val = val.substr(1);
		}
	}
	return val;
}


function TrimRight(val)
{
	var len = val.length;
	if(len==1 && val == " ")
	{
		val = "";
		return val;
	}
	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(len - 1) != " ")
			{
				return val;
			}
			else
			{
				len -= 1;
				val = val.substr(0,len);
			}
		}
	}
	return val;
}


function ExecuteTriggerforInterface(Interfacetrigger, sourceObject)
{
	var iName1 = wi_object.wi_view_win.iName1.toLowerCase();
	var iName2 = wi_object.wi_view_win.iName2.toLowerCase();
	var formFrame = null;
	var formviewWin = null;

	var name = (iName1.toLowerCase()=='formview')?'left':(iName2.toLowerCase()=='formview')?'right':'';
	if(name!='')
		formFrame = window.wi_object.workitem_win.frames[name];
	else
		formFrame = (formviewWin!=null && !(formviewWin.closed) )?formviewWin:null ;

	if(formFrame != null)
	{
		if(typeof formFrame.frames['form_center']!= 'undefined')
		{
			formFrame.frames["form_center"].ngFormOk();
		}
		else if(typeof formFrame.frames['htmlform_center']!= 'undefined')
		{
			var status = formFrame.frames['htmlform_center'].saveHtmlForm();
			if(status != 'false')
				return false;
		}
		else
		{
			var myCustomForm = formFrame.document.forms["dataform"];

			if(typeof formFrame.isFrameLoaded == 'undefined' || formFrame.isFrameLoaded)
				customFormOk(myCustomForm);
		}
	}	
	
	var ret =TRIG_FAILIURE;
	switch(Interfacetrigger.triggerType)
	{
		case 'M':
		{
			/* WCL_5.0.1_244  Handled the case for from address */
			var fromaddress = "";
			if(Interfacetrigger.triggerObject.fromType == "C")
				fromaddress = Interfacetrigger.triggerObject.fromUser;
			else
			{
				var valfrom = eval(window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.fromUser]);
				if(typeof valfrom == 'undefined')
					fromaddress = ""	;
				else
				{
					fromaddress = window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.fromUser].value.toString();
					if (fromaddress.toString() == "")
					{
						alert(SPECIFY_FROM_EMAILID);
						return TRIG_FAILIURE;
					}
				}
			}
			
			/* WCL_5.0.1_245
			Handled the case for validity of email id 
			*/	
			if(!isEmail(fromaddress))
			{
				alert(INVALID_EMAIL_ID_From);
				return TRIG_FAILIURE;
			}

			var toaddress = "";

			if(Interfacetrigger.triggerObject.toType == "C")
				toaddress = Interfacetrigger.triggerObject.toUser;
			else
			{
				var val = eval(window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.toUser]);
				if(typeof val == 'undefined')
					toaddress = "" ;
				else
					toaddress = window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.toUser].value;
			}
			
			/* WCL_5.0.1_245
			Handled the case for validity of email id 
			*/
			if(toaddress != "" && !isEmail(toaddress))
			{
				alert(INVALID_EMAIL_ID_To);
				return TRIG_FAILIURE;
			}

			// similarly check for cctype
			// check for cctype and accordingly set the form variable "to"
			if(Interfacetrigger.triggerObject.ccType == "C")
				ccaddress = Interfacetrigger.triggerObject.ccUser;
			else
			{
				var val1 = eval(window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.ccUser]);
				if(typeof val1 == 'undefined')
					ccaddress="";
				else
					ccaddress = window.top.wi_object.attribute_list[Interfacetrigger.triggerObject.ccUser].value;
			}

			/* WCL_5.0.1_245
			Handled the case for validity of email id 
			*/
			if(ccaddress != "" && !isEmail(ccaddress))
			{
				alert(INVALID_EMAIL_ID_CC);
				return TRIG_FAILIURE;
			}

			if(toaddress == "" && ccaddress =="")
			{
				alert(BLANK_EMAILID_TO_CC);
				//set variable to failure
				return TRIG_FAILIURE;
			}

			var url = '/webdesktop/workitem/misc/mailtrigger/mail_frameset.jsp?a='+encode_utf8(Trim(Interfacetrigger.parentElement));
			var win = window.open(url,'','scrollbars=no,width='+window4W+',height='+window4H+',left='+1000+',top='+1000);
			ret = TRIG_SUCCESS;
			break;
		}

		case 'S':
		{
			// execute Data set trigger
			var triggerArray = Interfacetrigger.triggerObject;
			var arvartype2,tmp,n1="";
			var value, type, len, tmpval;

			for(var i=0;i<Interfacetrigger.triggerObject.length;i++)
			{
				tmp = Interfacetrigger.triggerObject[i];
			
				if(typeof window.top.wi_object.attribute_list[tmp.arvariableName] != 'undefined')
				{
					if(tmp.arvartype2 == "C")
						value = tmp.arvalue;
					else if(tmp.arvartype2 == "F")
						value = window.top.wi_object.dynamicConst_list[tmp.arvalue].Value;
					else if(tmp.arvartype2 == "V" || tmp.arvartype2 == "U" || tmp.arvartype2 == "I")
						value = window.top.wi_object.attribute_list[tmp.arvalue].value;
					
					type = window.top.wi_object.attribute_list[tmp.arvariableName].type;
					len = window.top.wi_object.attribute_list[tmp.arvariableName].length;

					if(type == NG_VAR_DATE)
						tmpval = DBToLocal(value, sDateFormat);
					else
						tmpval = value;

					if(!ValidateValue(tmpval, type, len))
					{
						alert(INCOMPATIBLE_VALUE_ASSIGNMENT_SET_TRIGGER);
						return TRIG_FAILIURE;
					}
					
					window.top.wi_object.attribute_list[tmp.arvariableName].setAttribute(value);
				}
			}

			if (myBrowser!="Netscape")
			{
				if(name!='')
				{
					if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
					{
						var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
						if(strFrameSrc.indexOf('ngform.jsp')!= -1)
							formElement = window.top.wi_object.workitem_win.frames[name].frames["form_center"].setParameters();//T_6.1.2_WCL_002
						else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
							formElement = window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].location.reload();
					}
				}
				else
				{
					if(window.top.formviewWin != null && !window.top.formviewWin.closed)
						window.top.formviewWin.location.reload();
				}
			}

			ret = TRIG_SUCCESS;
			break;
		}

		case 'E':  // execute class
		{
			var functionName = Interfacetrigger.triggerObject.functionName;
			var cName = functionName.substring(0,functionName.lastIndexOf("."));
			var fName = functionName.substring(functionName.lastIndexOf(".")+1);
			var url = '/webdesktop/workitem/misc/clstrigger/execute_class_frameset.jsp?a='+encode_utf8(Trim(cName))+'&b='+encode_utf8(Trim(fName));

			var list = replaceVarsWithVals(Interfacetrigger.triggerObject.args).split(' ');

			var j=0;
			for(var i=0;i<list.length;i++)
				if(list[i] != '')
				{
					url += '&M['+j+']='+Trim(list[i]);
					j++;
				}
			url += '&c='+encode_utf8(Interfacetrigger.parentElement)+'&count='+j;

			var win = window.open(url,'','scrollbars=no,width='+window4W+',height='+window4H+',left=1000,top=1000');
			ret = TRIG_SUCCESS;
			break;
		}

		case 'L':
		{
			//For WCL_6.0.2_002
			if(myBrowser != "Netscape")
			{
				if(pluginlist.indexOf("OmniFlow Web Control") == -1)
				{	
					window.showModalDialog('waitwin_web_control.jsp?rid='+MakeUniqueNumber(),'','scrollbars=no,width='+windowW+', height='+windowH+',left='+windowY+',top='+windowX+'visibility=show; status=no;');
					window.location.reload();
				}
				
				document.getElementById('BView').innerHTML = '<OBJECT ID="WDGC Control" WIDTH="1" name="wdgc" HEIGHT="1" CODEBASE='+cabPath+'/webtop/webcontrol/wdgc.cab" CLASSID="CLSID:4088F53A-CAF6-11D6-B313-0000E8001307"></object>';

				if(!installWebControl())
					return false;

				/*if (myBrowser=="Netscape")
					document.embeds[0].triggerLaunch(Interfacetrigger.triggerObject.appName,decode_utf8(replaceVarsWithVals(Interfacetrigger.triggerObject.args)));
				else*/
					document.all.wdgc.triggerLaunch(Interfacetrigger.triggerObject.appName,decode_utf8(replaceVarsWithVals(Interfacetrigger.triggerObject.args)));

				ret = TRIG_SUCCESS;	
			}
			else
				ret = TRIG_FAILIURE;
			break;
		}

		case 'D':
		{
			var url;
			if (myBrowser!="Netscape")
			{
				url = "/webdesktop/workitem/interfaces/form/htmlform.jsp?FormViewFlag=P&Type=T&SourceObject="+encode_utf8(Interfacetrigger.parentElement);
				ret = window.showModalDialog(url,wi_object,"dialogWidth:"+window1W+"px;dialogHeight:"+window1H+"px;center:yes; status=no;");
			}
			else
			{
				url = "/webdesktop/workitem/interfaces/form/htmlform.jsp?FormViewFlag=N&Type=T&SourceObject="+encode_utf8(Interfacetrigger.parentElement);
				win = window.open(url,'FormView','scrollbars=yes,width='+window1W+',height='+window1H+',left='+window1Y+',top='+window1X);
			}

			if (myBrowser!="Netscape")
			{
				if(name!='')
				{
					if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
					{
						var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
						if(strFrameSrc.indexOf('ngform.jsp')!= -1)
							formElement = window.top.wi_object.workitem_win.frames[name].frames["form_center"].setParameters(); //T_6.1.2_WCL_002
						else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
							formElement = window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].location.reload();
					}
				}
				else
				{
					if(window.top.formviewWin != null && !window.top.formviewWin.closed)
						window.top.formviewWin.location.reload();
				}
			}
			ret = TRIG_SUCCESS;
			break;
		}

		case 'X':
		{
			var excpid = Interfacetrigger.triggerObject.expid;
			var excpname = Interfacetrigger.triggerObject.expname;
			var excptype = Interfacetrigger.triggerObject.exptype;
			var excpcomments = Interfacetrigger.triggerObject.expcomments;
			var historycount="";
			
			// get the array index for the corresponding
			var Subscript = findIndex(window.top.wi_object.exception_list,excpid,'index');
			
			if(Subscript == -1)
			{
				;
			}
			else if((window.top.wi_object.exception_list[Subscript].type == "V" + excptype) && (window.top.wi_object.exception_list[Subscript].status != excptype))
			{
				if((excptype == 'R') || (excptype == 'C' && window.top.wi_object.exception_list[Subscript].status == 'R'))
				{
					window.top.wi_object.exception_list[Subscript].status= excptype;
					historycount = window.top.wi_object.exception_list[Subscript].history_list.length;
					window.top.wi_object.exception_list[Subscript].history_list[historycount]= new exception_history(((excptype == "R") ? "9" : "10"),window.top.wi_object.workstep_name,window.top.wi_object.participant,getCurrentDateTimeInDbFormat(),excpcomments);
					window.top.wi_object.exception_list[Subscript].added_flag= true;
					
					//	Handling the case for bug no WCL_5.0.1_246 start
					var AssocTrigger = window.top.wi_object.exception_list[Subscript].exception_trigger; 	
		
					if(AssocTrigger!="")	
					{
						ExecuteTriggerforInterface(AssocTrigger);
						window.focus();
					}
					//	Handling the case for bug no WCL_5.0.1_246 end

					var name=(window.top.wi_object.wi_view_win.iName1.toLowerCase() == 'exceptions')?'left':(window.top.wi_object.wi_view_win.iName2.toLowerCase() == 'exceptions')?'right':'';
					if(name!='')
					{
						var excpFrame = window.top.wi_object.workitem_win.frames[name];
						excpFrame.location.reload();
					}
				}
			}
			ret = TRIG_SUCCESS;
			break;
		}
	
		case 'G':
		{
			myBrowser = navigator.appName;
			if (myBrowser=="Netscape")
				return TRIG_FAILIURE;
			var DocTypeList = getdocTypeList();
			if(DocTypeList.length <= 0)
			{
				alert(NO_DOC_TYPE_ADDABLE);
				return TRIG_FAILIURE;
			}
			
			var uploadDocType = Interfacetrigger.triggerObject.docType;
			if(uploadDocType != '')
			{
				var flag = false;
				if (window.top.wi_object.doc_types_list.length >0)
				{
					for ( i=0; i< wi_object.doc_types_list.length; i++)
					{
						if(window.top.wi_object.doc_types_list[i].doctype_name == Interfacetrigger.triggerObject.docType)
						{
							if((window.top.wi_object.doc_types_list[i].doctype_attribute == "A" || window.top.wi_object.doc_types_list[i].doctype_attribute == "B" || window.top.wi_object.doc_types_list[i].doctype_attribute == "T") && window.top.wi_object.doc_types_list[i].doctype_name != COMBO_CONVERSATION)
							{
								flag=true;
								break;
							}
						}
					}
				}
				if(flag == false)
				{
					alert(SPECIFIED_DOC_TYPE_NOT_ADDABLE + " " +Interfacetrigger.triggerObject.docType);
					return TRIG_FAILIURE;
				}
			}
			
			if(uploadDocType == '')
			{
				uploadDocType = window.showModalDialog('doctype_gen_resp.jsp',window.top.wi_object,"dialogWidth:"+1.5*windowVW+"px;dialogHeight:"+1.5*windowVH+"px;center:yes; status=no;");
			}
			if(Trim(uploadDocType) == '')
				return TRIG_FAILIURE;
			
			var ArgList = '';
			if(Interfacetrigger.triggerObject.args != '')
			{
				var tok = Interfacetrigger.triggerObject.args.split(/&</);
				var i;
				for(i=0;i<tok.length;i++)
					tok[i] = tok[i].substring(0,tok[i].indexOf('>&'));

				for(i=0;i<tok.length;i++)
				{
					if(typeof window.top.wi_object.attribute_list[tok[i]] != 'undefined')
						ArgList += SEPERATOR1 + tok[i] + SEPERATOR2 + window.top.wi_object.attribute_list[tok[i]].value + SEPERATOR3 + window.top.wi_object.attribute_list[tok[i]].type;
				}
			}

			var genRespForm = window.document.forms['genResp'];
			genRespForm.TemplateFile.value = Interfacetrigger.triggerObject.fileName;
			genRespForm.DocType.value = uploadDocType;
			genRespForm.CreatedByAppName.value = "doc";
			genRespForm.ParentFolderId.value = folderid;
			genRespForm.ProcessDefId.value = wi_object.process_id;
			genRespForm.ArgList.value = ArgList;
			var winName = "GenResp"+MakeUniqueNumber();
			var win = window.open('',winName,'scrollbars=no,width='+windowW+',height='+windowH+',left='+windowY+',top='+windowX);
			genRespForm.target=winName;
			genRespForm.submit(); 
			
			ret = TRIG_SUCCESS;
			break;
		}

		case 'U':
		{
			var customUrl = Interfacetrigger.triggerObject.url;
			customUrl+="?UserName="+encode_utf8(loggedin_user);
			customUrl+="&Password="+encode_utf8(UserPasswd);
			customUrl+="&SessionId="+UserSessionId;
			customUrl+="&CabinetName="+encode_utf8(sEngineName);
			customUrl+="&ProcessInstanceId="+encode_utf8(wi_object.process_inst_id);
			customUrl+="&WorkitemId="+wi_object.workitem_id;
			customUrl+="&ProcessDefId="+wi_object.process_id;
			customUrl+="&ActivityId="+wi_object.activity_id;

			window.open(customUrl,'Custom');
			ret = TRIG_SUCCESS;
			break;
	    }

	}
	return ret;
}

function getVal(s,tag)
{
	var i1 = s.toUpperCase().indexOf('<'+tag.toUpperCase()+'>');
	var i2 = s.toUpperCase().indexOf('</'+tag.toUpperCase()+'>');

	if(i1==-1 || i2==-1 || i1>i2)
	{
		return '';
	}
	return s.substring(i1+tag.length+2,i2);
}

function installWebControl()
{
	var isInstalled = false;
	var isNetscape = (navigator.appName.indexOf("Netscape") !=-1)?true:false;

	if(isNetscape)
	{
		return false;
		isInstalled = (typeof navigator.mimeTypes["application/x-scanupld"] == 'undefined')?false:true;
	}
	else
		isInstalled = (typeof document.all.wdgc.isLoaded== 'undefined')?false:true;

	return isInstalled;
}


function findIndex(srcObject,value,fldName,caseSensitive)
{
	if(typeof caseSensitive=='undefined')
		caseSensitive = true;
	else if(caseSensitive==false)
		value = value.toUpperCase();

	var i;
	for(i=0; i< srcObject.length;i++)
	{
		if (typeof fldName=='undefined' || fldName =="")
		{
			if((caseSensitive && (srcObject[i]==value)) || (!caseSensitive && (srcObject[i].toUpperCase() == value)))
				break;
		}
		else if((caseSensitive && (srcObject[i][fldName]==value)) || (!caseSensitive  && (srcObject[i][fldName].toUpperCase() == value)))
		{
			break;
		}

	}
	if(i==srcObject.length)
		return -1;
	else
		return i;
}


function UserBatch(batchOption)
{
	if (batchOption =='P')
	{
		dataFrm.UserLastValue.value = StartUserValue;
		dataFrm.UserLastId.value = StartUserId;
	}
	else
	{
		dataFrm.UserLastValue.value = LastUserValue;
		dataFrm.UserLastId.value = LastUserId;
	}

	dataFrm.UserBatchOption.value = batchOption;
	dataFrm.submit();
}


function executeScanAction(wi_object,docType)
{
	var index = findIndex(wi_object.doc_types_list,docType,'doctype_name');

	if(index==-1)
		return;

	var scanactionarray, value, type, len;
	scanactionarray = wi_object.doc_types_list[index].doctype_scanactions;

	for(var i=0;i<scanactionarray.length;i++)
	{
		if(typeof wi_object.attribute_list[scanactionarray[i].parameter1] !='undefined')
		{
			if(scanactionarray[i].type2 == "C")
			{
				value = scanactionarray[i].parameter2;
				if(scanactionarray[i].type1==NG_VAR_DATE)
					value = DBToLocal(value);
			}
			else if(scanactionarray[i].type2 == "F")
				value = wi_object.dynamicConst_list[scanactionarray[i].parameter2].Value;
			else if(scanactionarray[i].type2 == "V")
				value = wi_object.attribute_list[scanactionarray[i].parameter2].value;
		}

		type = wi_object.attribute_list[scanactionarray[i].parameter1].type;
		len = wi_object.attribute_list[scanactionarray[i].parameter1].length;

		if(!ValidateValue(value, type, len))
		{
			alert(INCOMPATIBLE_VALUE_ASSIGNMENT_SCAN_ACTION);
			return;
		}
		wi_object.attribute_list[scanactionarray[i].parameter1].setAttribute(value);
	}
	return;
}


function formatJTSDate(date)
{
	var formatDate = new String(date);
	if(formatDate.lastIndexOf('.')!=-1)
		return formatDate.substring(0,formatDate.lastIndexOf('.'));
	else
		return formatDate;
}


function isDocTypeAddable(index)
{
	if ((wi_object.doc_types_list[index].doctype_attribute == "A" || 		                   				wi_object.doc_types_list[index].doctype_attribute == "B" || 									wi_object.doc_types_list[index].doctype_attribute == "T") && 									wi_object.doc_types_list[index].doctype_name != COMBO_CONVERSATION)
		return true;
	else
		return false;
}


function getdocTypeList()
{
	var docTypeList = new Array();
	var count = -1,index=0;
	docTypeList = getdocTypeListExt();

	if(!docTypeList)
	{
		docTypeList = new Array();
		if (wi_object.doc_types_list.length >0)
		{
			for ( index=0; index< wi_object.doc_types_list.length; index++)
				if(isDocTypeAddable(index))
					docTypeList[++count] = wi_object.doc_types_list[index].doctype_name;
		}
	}
	return docTypeList;
}


function doctypeCombo()
{
	var combotext ="";
	var optiontext="";
	var docTypeList = getdocTypeList();

	for( i=0; i< docTypeList.length; i++)
	{
		optiontext += "<option value=\'"+docTypeList[i]+"\'>"+ docTypeList[i]+"</option>";
	}

	if (optiontext != "")
		combotext += "<select size=\"1\" name=\"DocName\" >"+optiontext+"</select>";
	return combotext;
}


function replaceVarsWithVals(input)
{
	var startIndex=0,endIndex=0,temp,val,regex;

	do
	{
		startIndex = input.indexOf('&<',0);

		if(startIndex == -1)
			return input;

		endIndex = input.indexOf('>&',startIndex+2);

		if(endIndex == -1)
			return input;

		temp= input.substring(startIndex+2,endIndex);
		if(typeof wi_object.attribute_list[temp] != 'undefined')
		{
			val = decode_utf8(encode_utf8(wi_object.attribute_list[temp].value)); // Changed for WCL_5.0.1_323
			regex = new RegExp('&<'+temp+'>&','g');
			input = input.replace(regex,val);
		}
		else
		{
			regex = new RegExp('&<'+temp+'>&','g');
			input = input.replace(regex,'');
		}
	}while(true);
}


function displayDateFormat(inputDate)
{
	var displayDate ="";
	if (inputDate.indexOf(" ") != -1)
		inputDate = inputDate.substring(0,inputDate.indexOf(" "));
	if (inputDate.indexOf("-") != -1)
	{
		pos   = (inputDate).indexOf("-");
		year  = (inputDate).substring(0,pos);
		pos1  = (inputDate).indexOf("-",pos+1);
		day = (inputDate).substring(pos+1,pos1);
		month	  = (inputDate).substring(pos1+1,(inputDate).length);
		displayDate = day+"/"+ month+"/"+year;
	}
	else
		displayDate = inputDate;

	return displayDate;
}

function HelpClick(helpname,winArray)
{
	HelpUrl = "/webtop/"+PATH+"webhelp/"+helpname;
	win = window.open(HelpUrl,"","scrollbars=yes,resizable=yes,toolbar=no,menubar=no,status=yes,location=no,scrollbars=yes,top=15,left=285,height=480,width=500");
	addwindow(winArray,win);
}


function getShortNameWithoutImage(Name,length)
{
	if (Name.length > length)
	{
		Name1 = Name.substring(0, length-2) + "...";
		return Name1;
	}
	return Name;
}

function getsmalldateformat(sDateFormat)
{
	var temp;	
	var strChar=sDateFormat.split("/");
	var strChar1= strChar[0].substring(0,1);
	strChar1.toLowerCase();
	var strChar2= strChar[1].substring(0,1);
	strChar2.toLowerCase();
	var strChar3= strChar[2].substring(0,1);
	strChar3.toLowerCase();
	temp = strChar1 + strChar2 + strChar3;
	return temp;
}


function dateOpratFormat(formatDate,inSeparator,inFormat,outSeparator,outFormat)
{
	inFormat = inFormat.toLowerCase();
	outFormat = outFormat.toLowerCase();
	var date="",month="",year="";
	if(Trim(formatDate).indexOf(" ")!=-1)
		formatDate = formatDate.substring(0,Trim(formatDate).indexOf(" "));

	var stDate = formatDate.split(inSeparator);

	var count=0;
	var dateComponents = new Array();

	dateComponents['y'] = stDate[inFormat.indexOf('y')];
	dateComponents['m'] = stDate[inFormat.indexOf('m')];
	dateComponents['d'] = stDate[inFormat.indexOf('d')];

	if (date.length==1) dateComponents['d']  = "0"+dateComponents['d'] ;
	if (month.length==1) dateComponents['m']  = "0"+dateComponents['m'] ;

	var temp =  dateComponents[outFormat.charAt(0)] +outSeparator+ dateComponents[outFormat.charAt(1)] + outSeparator +dateComponents[outFormat.charAt(2)];

	return temp;
}


function getSizeInKB(docSize)
{
	docSize = parseInt(docSize);
	if (docSize == 0)
		docSize = "0KB";
	else
	{
		var lTempSize = docSize >> 10;
		var lRemSize  = docSize % 1024;
		if (lRemSize > 0)
			lTempSize++;
		return (lTempSize + " KB");
	}
}


function GroupBatch(batchOption)
{
	if (batchOption =='P')
	{
		dataFrm.GroupLastValue.value = StartGroupValue;
		dataFrm.GroupLastId.value = StartGroupId;
	}
	else
	{
		dataFrm.GroupLastValue.value = LastGroupValue;
		dataFrm.GroupLastId.value = LastGroupId;
	}

	dataFrm.GroupBatchOption.value = batchOption;
	dataFrm.submit();
}


function isEmail(Mail)
{
	Mail = Trim(Mail);
	var mailLength=0;
	var atIndex=-1;
	var lastDotIndex=-1;

	if (Mail=="")
		return true;

	mailLength=Mail.length;

	for(i=0; i < mailLength ; i++)
	{
		ch=Mail.substring(i,i+1);
		if (isInvalid(ch))
			return false;
		
		if(ch=="@")
		{
			if(atIndex >= 0)
				return false;
			else
			{
				atIndex=i+1;
				if((atIndex==1)||(atIndex==mailLength)||(atIndex==lastDotIndex+1))
					return false;
			}
		}
		if(ch==".")
		{
			if((i==lastDotIndex)||(i==0)||(i==mailLength-1)||(i==atIndex))
				return false;
			lastDotIndex=i+1;
		}
	}
	if((atIndex==-1)||(lastDotIndex < atIndex))
		return false;

	return true;
}


function isInvalid(ch)
{
	if((ch>='a' && ch<='z')||(ch>='A' && ch<='Z')||(ch>='0' && ch<='9')||ch=='@'||ch=='-'||ch=='_'||ch=='.')
		return false;
	else
		return true;
}

function IsNumericVal(val)
{
	if(isNaN(val))
	{
		return 0;
	}
	if(IsFloatVal(val))
	{
		return 0;
	}
	return 1;
}

function IsFloatVal(val)
{
	var len = val.length;
	var i;
	for(i=0; i<=(len - 1);i++)
	{
		if(val.charAt(i) == ".")
		{
			return 1;
		}

	}
	return 0;
}


function textareaLimiter(field, maxlimit) 
{	
	if(field.value.length > maxlimit)
	{ 
		alert(ALERT_EXCEEDING_COMMENT_LENGHT + maxlimit);	
		field.value = field.value.substring(0, maxlimit);
		if(isPaste)
			noRaise=true;
	}	
}


function isDateType(attributetype)
{
	if ((attributetype) == "8") 
		return "(" + dateFormat + ")";
	else
		return "";
}


function FormView()
{
	var ret =TRIG_FAILIURE;
	var name=(window.top.wi_object.wi_view_win.iName1.toLowerCase() == 'formview')?'left':(window.top.wi_object.wi_view_win.iName2.toLowerCase() == 'formview')?'right':'';

	if(name!='')
	{
		if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
		{
			var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
			if(strFrameSrc.indexOf('ngform.jsp')!= -1)
				window.top.wi_object.workitem_win.frames[name].frames["form_center"].saveNGForm();
			else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
				window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].saveHtmlForm();
			else // WCL_3.1.5.022
			{
				var formFrame = window.top.wi_object.workitem_win.frames[name];
				var myCustomForm = formFrame.document.forms["dataform"];

				if(typeof formFrame.isFrameLoaded == 'undefined' || formFrame.isFrameLoaded)
					customFormOk(myCustomForm);
			}
		}
	}

	var url = wi_object.interface_list["formview"].url;
	if(url.indexOf("?") != -1)
		url = url.substring(0,url.indexOf("?"));
	

	if(myBrowser!="Netscape")
	{
		url += '?FormViewFlag=P&Mode='+wi_object.view_mode+'&rid='+MakeUniqueNumber();

		if(url.indexOf("ngform") != -1 && pluginlist.indexOf("OmniFlow Web Control") == -1 && !isApplet) //IT_6.1.2_WCL_101  
		{
			ret = confirm(CONFIRM_WEB_CONTROL_INSTALLATION);
			if(ret)
			{
				window.showModalDialog('../../view/waitwin_web_control.jsp?rid='+MakeUniqueNumber(),'', 'scrollbars=no,width='+windowW+',height='+windowH+',left='+windowY+',top='+windowX+'visibility=show; status=no;');
				window.location.reload();
			}
		}

		ret = window.showModalDialog(url,wi_object,"dialogWidth:"+window1W+"px;dialogHeight:"+window1H+"px;center:yes; status=no;");
	}
	else
	{
		if(url.indexOf("ngform") != -1)
			url = '/webdesktop/workitem/interfaces/form/htmlform.jsp';

		url += '?FormViewFlag=N&Mode='+wi_object.view_mode+'&rid='+MakeUniqueNumber();
		win = window.open(url,'FormView','scrollbars=yes,width='+window1W+',height='+window1H+',left='+window1Y+',top='+window1X);
	}

	if (myBrowser!="Netscape")
	{
		if(name!='')
		{
			if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
			{
				var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
				if(strFrameSrc.indexOf('ngform.jsp')!= -1)
				formElement = window.top.wi_object.workitem_win.frames[name].frames["form_center"].setParameters(); //T_6.1.2_WCL_002
				else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
					formElement = window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].location.reload();
			}
		}
		else
		{
			if(window.top.formviewWin != null && !window.top.formviewWin.closed)
				window.top.formviewWin.location.reload();
		}
	}

	ret = TRIG_SUCCESS;
	return ret;
}


function FormView1()
{
	var ret =TRIG_FAILIURE;
	var name=(window.top.wi_object.wi_view_win.iName1.toLowerCase() == 'formview')?'left':(window.top.wi_object.wi_view_win.iName2.toLowerCase() == 'formview')?'right':'';

	if(name!='')
	{
		if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
		{
			var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
			if(strFrameSrc.indexOf('ngform.jsp')!= -1)
				window.top.wi_object.workitem_win.frames[name].frames["form_center"].saveNGForm();
			else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
				window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].saveHtmlForm();
			else
			{
				var formFrame = window.top.wi_object.workitem_win.frames[name];
				var myCustomForm = formFrame.document.forms["dataform"];
				if(typeof formFrame.isFrameLoaded == 'undefined' || formFrame.isFrameLoaded)
					customFormOk(myCustomForm);
			}
		}
	}

	var url = wi_object.interface_list["formview"].url;
	if(url.indexOf("?") != -1)
		url = url.substring(0,url.indexOf("?"));

	if(myBrowser!="Netscape")
	{
		url += '?FormViewFlag=P&Mode='+wi_object.view_mode+'&rid='+MakeUniqueNumber();
		if(url.indexOf("ngform") != -1 && pluginlist.indexOf("OmniFlow Web Control") == -1 && !isApplet)//IT_6.1.2_WCL_101  
		{
			ret = confirm(CONFIRM_WEB_CONTROL_INSTALLATION);
			if(ret)
			{
				window.showModalDialog('../../view/waitwin_web_control.jsp?rid='+MakeUniqueNumber(),'', 'scrollbars=no,width='+windowW+',height='+windowH+',left='+windowY+',top='+windowX+'visibility=show; status=no;');
				window.location.reload();
			}
		}
		ret = window.showModalDialog(url,wi_object,"dialogWidth:"+window1W+"px;dialogHeight:"+window1H+"px;center:yes; status=no;");
	}
	else
	{
		if(url.indexOf("ngform") != -1)
			url = '/webdesktop/workitem/interfaces/form/htmlform.jsp';

		url += '?FormViewFlag=N&Mode='+wi_object.view_mode+'&rid='+MakeUniqueNumber();
		win = window.open(url,'FormView','scrollbars=yes,width='+window1W+',height='+window1H+',left='+window1Y+',top='+window1X);
	}

	if (myBrowser!="Netscape")
	{
		if(name!='')
		{
			if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
			{
				var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
				if(strFrameSrc.indexOf('ngform.jsp')!= -1)
					formElement = window.top.wi_object.workitem_win.frames[name].frames["form_center"].setParameters(); //T_6.1.2_WCL_002
				else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
					formElement = window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].location.reload();
			}
		}
		else
		{
			if(window.top.formviewWin != null && !window.top.formviewWin.closed)
				window.top.formviewWin.location.reload();
		}
	}
}


function ExecuteTriggerForDataEntry()
{
	var name=(window.top.wi_object.wi_view_win.iName1.toLowerCase() == 'formview')?'left':(window.top.wi_object.wi_view_win.iName2.toLowerCase() == 'formview')?'right':'';

	if(name!='')
	{
		if(typeof window.top.wi_object.workitem_win.frames[name]!= 'undefined')
		{
			var strFrameSrc = window.top.wi_object.workitem_win.frames[name].location.href;
			if(strFrameSrc.indexOf('ngform.jsp')!= -1)
				formElement = window.top.wi_object.workitem_win.frames[name].frames["form_center"].setParameters(); //T_6.1.2_WCL_002
			else if(strFrameSrc.indexOf('htmlform.jsp')!= -1)
				formElement = window.top.wi_object.workitem_win.frames[name].frames["htmlform_center"].location.reload();
			else
				formElement = window.top.wi_object.workitem_win.frames[name].location.reload();
		}
	}
	else
	{
		if(window.top.formviewWin != null && !window.top.formviewWin.closed)
			window.top.formviewWin.location.reload();
	}
}


function appendTagAndValue(tag,value)
{
	var temp = "";
	if (value != "")
		temp = "<"+tag+">"+value+"</"+tag+">";
	return temp;
}


function doctypeComboevent()
{
	var combotext ="";
	var optiontext="";
	var docTypeList = getdocTypeList();

	for(var i=0; i< docTypeList.length; i++)
	{
		optiontext += "<option value=\'"+docTypeList[i]+"\'>"+ docTypeList[i]+"</option>";
	}

	if (optiontext != "")
		combotext += "<select size=\"1\" name=\"DocName\" onChange=\"doctypechange()\">"+optiontext+"</select>";
	return combotext;
}


function isOrgDocExist(DocName)
{
	if (wi_object.attachment_list.length >0)
	{
		for (var i=0; i< wi_object.attachment_list.length; i++)
		{
			if(wi_object.attachment_list[i] != null)
			{
				if(wi_object.attachment_list[i].name.indexOf(DocName)!= -1)
					return true;
			}
		}
		return false;		
	}
	return false;
}


function DbToLocaleValue(value,locale)
{
	var temp = value;
	if((typeof locale != 'undefined') && locale == 'lt')
	{	
		if(value != "")
		{
			value = value+"";
			if(value.indexOf(".") != -1)
				temp = replace(value,".",",");
		}
	}
	return temp;
}

function LocaleToDBValue(value,locale)
{
	var tempstr = value;
	if((typeof locale != 'undefined') && locale == 'lt')
	{
		while(tempstr.indexOf(".") != -1)
		{
			tempstr = replace(tempstr,".","");
		}
		if(tempstr.indexOf(",") != -1)
			tempstr = replace(tempstr,",",".");
	}
	return tempstr;
}


function ScriptValidate(ScriptString)
{
	var flag=true;
	for(var i =0; i<ScriptString.length; i++)
	{
		if(ScriptString.charAt(i)=='<'||ScriptString.charAt(i)=='>')
		{
			if(ScriptString.substring(i+1, i+7)=="script" ||ScriptString.substring(i+1, i+7)=="SCRIPT")
		     {
				flag=false;
			 }
		}
	}
	return flag;
}


function FindCookies(name)
{
	var bites = document.cookie.split(";");
	for(var i=0; i < bites.length; i++)
	{
		nextbite = bites[i].split("=");
		Trim(nextbite[0]);
		if(i == 0)
			nextbite[0] = nextbite[0].substring(0,nextbite[0].length);
		else
			nextbite[0] = nextbite[0].substring(1,nextbite[0].length);

		if(nextbite[0] == name)
			return nextbite[1];
	}
}