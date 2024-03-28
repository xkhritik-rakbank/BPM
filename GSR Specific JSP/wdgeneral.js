/*
		Product         :       OmniFlow 7.0
		Application     :       OmniFlow Web Desktop
		Module          :
		File            :       wdgeneral.js
		Purpose         :       Contains the functions related to General Functions

		Change History  :

        Problem No	Correction Date	 Changed By	Comments
	----------	---------------	---------	--------
        3999            20/Mar/2008     Himshikha       doument size checking at client end
        5826             23/July/2009   Himshikha       on relogin with same user at same machine, session of both window get expires automatically
        WCL_7.1_003      12/Sep/2008    Himshikha      Error while clicking user list button in search
        7554            1/Jan/2009      Himshikha         value of duration variable to getting set in ngform from set and DE trigger
        WCL_8.0_189       12/02/2010    Puneet Pahuja               File upload type Restricted
        12819           14/05/2010      Himshikha          problem in generatePostrequeest method in mozilla.
        Bug 27591       20/07/2011      Anushree Jain       Resolution support for the webdesktop
        Bug 28001       26/08/2011      Anushree Jain    Security issue
*       25/06/2012      Bug 32773                       - Requirement for keeping the Web and DB session active forcefully through client.js
	Bug 40434       27/06/2013    Dinkar Kad         Slowness issue because of ajax phase listener.

        Bug 42170       24/09/2013                       Issue while importing document in webdesktop in IE10.
        Bug 42182       28/08/2013                       Sensitive information passed as GET parameter (e,g jsessionid)
        Bug 46906       01/07/2014      Jaseem Ansari              - All the request in omniflow containing wd_uid as a parameter should be sent as a post request
        Bug 46510 -     10/06/2014      Dinesh Verma       Support of IE11 in Webdesktop
        Bug 51071       21/10/2014                         Support of dual monitor in webdesktop
		Bug 51867		12/11/2014		Dinkar Kad			 - Changes required in webdesktop and processmanager for handling specific changes made corresponding to actionId 75 in Omniflow 10
                Bug 54005 -     23/02/2015      Jaseem Ansari    WebApplication security reported in webdesktop
*/
function textareaLimiter(field, maxlimit) {
    if (field.value.length > maxlimit){
        alert(ALERT_EXCEEDING_COMMENT_LENGTH + " " + maxlimit + " " + CHARS);
        field.value = field.value.substring(0, maxlimit);
    }
}
function escapeHTML(html) {
   /* var escape1 = document.createElement('textarea1234');
    escape1.innerHTML = html;
    return escape1.innerHTML;*/
    return  String(html)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
             
}

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

var window6H = 175;
var window6W = 250;
var window6X = (window.screen.availHeight - window6H)/2;
var window6Y = (window.screen.availWidth - window6W)/2;

var window5H = 500;
var window5W = 760;
var window5X = (window.screen.availHeight - window5H)/2 - 10;
var window5Y = (window.screen.availWidth - window5W)/2 - 5;

var windowMH = 200;
var windowMW = 130;

var windowVH = 180;
var windowVW = 280;

var windowQH=430;
var winW=window.screen.availWidth ;
var winH=window.screen.availHeight;

var window5H = 150;
var window5W = 400;
var window5X = (window.screen.availHeight - window5H)/2;
var window5Y = (window.screen.availWidth - window5W)/2;

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

		Name1 = tempName + "...&nbsp;<img align="+ABSBOTTOM+" border=0 src=\""+sContextPath+"/webtop/images/arrow1.gif\" title=\"" + Temp1 + "\">";
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
			c2 = utftext.charCodeAt(i+1);c3 = utftext.charCodeAt(i+2);

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

function getShortComboName(Name,size,spc)
{
	if (Name.length > size + 5)
	{
		if(spc)
                    Name1 = Name.substring(0, size) + "... ";
                else
                    Name1 = Name.substring(0, size) + "...&nbsp;";
		return Name1;
	}
	return Name;
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

		Name1 = tempName + "...&nbsp;<img align="+ABSBOTTOM+" border=0 src=\""+sContextPath+"/webtop/images/arrow1.gif\" title=\"" + Temp1 + "\">";
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

function getShortNameTest(Name,size)
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

		Name1 = tempName + "...";//&nbsp;<img align="+ABSBOTTOM+" border=0 src=\"/webdesktop/webtop/images/arrow1.gif\" title=\"" + Temp1 + "\">";
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
function MakeUniqueNumber()
{
	var tm = new Date();
	var milisecs = Date.parse(tm.toGMTString());
	return milisecs;
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
var ENCODING="UTF-8";
var hexArr = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');


function MakeUniqueNumber()
{
	var tm = new Date();
	var milisecs = Date.parse(tm.toGMTString());
	return milisecs;
}
function executeScanAction(loc, pid, wid, docType)
{
    var xbReq;
    if (window.XMLHttpRequest){
        xbReq = new XMLHttpRequest();
    } else if (window.ActiveXObject){
       xbReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
   // var url = 'ajaxscanAction';
     var url =sContextPath+'/faces/ajx/ajxreqhandler.jsp?AJXReqId=ajaxscanAction';
    url = appendUrlSession(url);
    var requestString = 'wid='+wid+'&pid='+pid+'&DocType='+docType+'&WD_UID='+wd_uid;
    xbReq.open("POST", url, false);
    xbReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xbReq.send(requestString);
    var response = xbReq.responseText;
    var scanAction = eval("("+response+")");
    if(typeof loc !='undefined')
    {
        for(var k =0;k<scanAction.length;k++)
        {
            if(scanAction[k].ScanAct == 'Success')
            {
                var valSetter = scanAction[k];
                loc.setFormValue(valSetter.name,valSetter.value,valSetter.type);
                // var dataField = loc.document.getElementById('wdesk:'+valSetter.name);
               //if(dataField)
               //  dataField.value=valSetter.value;
            }
            else if(scanAction[k].ScanAct == 'Failure')
            {
                alert(INCOMPATIBLE_VALUE_ASSIGNMENT_SCAN_ACTION);
                return;
            }
        }
    }
}

function showWait()
{
var ret = new msg.Message('waitDia','<table border="0" width="100%" cellpadding="4"><tr><td><img src="'+sContextPath+'/webtop/'+PATH+'images/progress.gif"></td></tr></table>',wratio*5,hratio*5);
}
function hideWait()
{
msg.hideDialog();
}
function resizeDiv(){
var contentDiv=documant.getElementById("contentDiv");
contentDiv.style.height=window.document.body.clientHeight-70;
}



//extra arry function
Array.prototype.append=function(obj,nodup){
  if (!(nodup && this.contains(obj))){
    this[this.length]=obj;
  }
}

/*
return index of element in the array
*/
Array.prototype.indexOf=function(obj){
  var result=-1;
  for (var i=0;i<this.length;i++){
    if (this[i]==obj){
      result=i;
      break;
    }
  }
  return result;
}

/*
return true if element is in the array
*/
Array.prototype.contains=function(obj){
  return (this.indexOf(obj)>=0);
}

/*
empty the array
*/
Array.prototype.clear=function(){
  this.length=0;
}

/*
insert element at given position in the array, bumping all
subsequent members up one index
*/
Array.prototype.insertAt=function(index,obj){
  this.splice(index,0,obj);
}

/*
remove element at given index
*/
Array.prototype.removeAt=function(index){
  this.splice(index,1);
}

/*
return index of element in the array
*/
Array.prototype.remove=function(obj){
  var index=this.indexOf(obj);
  if (index>=0){
    this.removeAt(index);
  }
}
function isUndefined(v) {
    var undef;
    return v===undef;
}
function clickLink(source,linkId,param)
{
    strRemovefrommap='N';
    if(!linkId)
    linkId="wdesk:controller";
    if(typeof param == 'undefined')
        param = "";
    var optionValue=document.getElementById("Option");
    if(optionValue)
         document.getElementById("Option").value=source;



    var ngParamObj = document.getElementById("ngParam");
    if(ngParamObj)
         document.getElementById("ngParam").value=param;

    var fireOnThis = document.getElementById(linkId)
    if (document.createEvent)
    {
        var evObj = document.createEvent('MouseEvents')
        evObj.initEvent( 'click', true, false );
        fireOnThis.dispatchEvent(evObj)
    }
    else if (document.createEventObject)
    {
        fireOnThis.fireEvent('onclick');
    }

	if(source=="INTRODUCE" && param.indexOf("wdesk%3ACategory=Cards")>-1 && param.indexOf("SubCategory=Cash%20Back%20Redemption")>-1 && param.indexOf("IsRejected=Y")==-1 && param.indexOf("IsError=N")>-1  )
	{
		if(param.indexOf("IsSTP=Y")>-1 )
			alert("Your request has been submitted successfully.");
		else
			alert("Dear "+decodeURIComponent(param).substring(decodeURIComponent(param).indexOf("CCI_CName=")+10,decodeURIComponent(param).lastIndexOf("&"))+", we have taken your request for cash back which will be reviewed in 3 working days.");
						
	}
if(source=='DONE' && (processName=='AO' || processName=='TL' || processName=='TT' || processName=='CU'))
		alert("The request has been submitted successfully.");
}
function getFormValuesForAjax(workdeskform)
{
    var str = "";
    var valueArr = null;
    var val = "";
    var cmd = "";
    var fobj = workdeskform;
	if(typeof fobj == 'undefined')
	    return "";
    var stateName = "com.sun.faces.VIEW";
    var formid=fobj.id;
    //Omniflow 5.0 support using wi_object 
    if(WIObjectSupport.toUpperCase()=='Y'){

        for(var i in wi_object.attribute_list)
        {

            if(wi_object.attribute_list[i].modified_flag ==  true)
            {
                str += encodeURIComponent("wdesk:"+wi_object.attribute_list[i].name) +  "=" + encodeURIComponent(Trim(wi_object.attribute_list[i].value)) + "&";
            }
            else
            {
                if(fobj.elements[wi_object.attribute_list[i].name])
                    str += encodeURIComponent("wdesk:"+wi_object.attribute_list[i].name) +  "=" + encodeURIComponent(Trim(fobj.elements[wi_object.attribute_list[i].name].value)) + "&";
            }
        }
    } 
   if(formid=='wdesk'){
        for(var i = 0;i < fobj.elements.length;i++)
        {
            switch(fobj.elements[i].type)
            {
                case "textarea":
                case "text":
                    str += encodeURIComponent(fobj.elements[i].name) +  "=" + encodeURIComponent(Trim(fobj.elements[i].value)) + "&";
                    break;
                case "select-one":
                    if(fobj.elements[i].selectedIndex!=-1)
                        str += encodeURIComponent(fobj.elements[i].name) + "=" + encodeURIComponent(fobj.elements[i].options[fobj.elements[i].selectedIndex].value) + "&";
                    break;
                case "checkbox":
                    if(fobj.elements[i].checked)
                    {
                        str += encodeURIComponent(fobj.elements[i].name) + "=" +encodeURIComponent(fobj.elements[i].value) + "&";
                    }
                    break;
                case "hidden":
                    if(!(fobj.elements[i].name== stateName))
                    {
                        str +=encodeURIComponent(fobj.elements[i].name) +  "=" + encodeURIComponent(fobj.elements[i].value) + "&";
                    }
                    break;
            }
        }
    }
return str;
}

function appendUrlSession(url){
    if(cookieFlag == 'N' && sessionVal!="" )
    {
        if(url.indexOf('?') != '-1')
            url = url.substring(0,url.indexOf('?'))+sessionVal+url.substring(url.indexOf('?'));
        else
            url = url + sessionVal;
    }
    if(typeof url != 'undefined'){
        if(url.indexOf('?') != '-1'){
            //url = url + '&wnwd='+ reqSession;

            url=url+'&rid='+ MakeUniqueNumber();
        }else{
            //url = url + '?wnwd=' + reqSession;
            url=url+'?rid='+ MakeUniqueNumber();
        }
    }
    return url;

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







function isIE(){
   var UAString = navigator.userAgent;
   return ((navigator.appName=='Netscape' ) &  !(UAString.indexOf("Trident") !== -1 && UAString.indexOf("rv:11") !== -1)?false:true);




}

function getIEVersion()
// Returns the version of Windows Internet Explorer or a -1
// (indicating the use of another browser).
{
   var rv = -1; // Return value assumes failure.
   var UAString = navigator.userAgent;
   if ((navigator.appName == 'Microsoft Internet Explorer') || (UAString.indexOf("Trident") !== -1 && UAString.indexOf("rv:11") !== -1))
   {
      if(navigator.appName == 'Microsoft Internet Explorer'){
      var ua = navigator.userAgent;
      var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
      if (re.exec(ua) != null)
         rv = parseFloat( RegExp.$1 );
      } else 
         rv = 11;
   }
   return rv;
}

function HelpClick(helpname)

{
  if(helpname=="")
            return;
	HelpUrl = sContextPath+"/webtop/"+PATH+"webhelp/"+helpname;
	win = window.open(HelpUrl,"","scrollbars=yes,resizable=yes,toolbar=no,menubar=no,status=yes,location=no,scrollbars=yes,top="+15/hratio+",left="+285/wratio+",height="+hratio*480+",width="+wratio*500);
    if(typeof theChild!='undefined'){ 
        theChildCount++;
        theChild[theChildCount]= win;
      }else if(window.opener &&  typeof window.opener.theChild!='undefined'){ 
        window.opener.theChildCount++;
        window.opener.theChild[window.opener.theChildCount]= win;
      }else if(typeof customChild!='undefined'){ 
        customChildCount++;
        customChild[customChildCount]= win;
      }else if(window.opener &&  typeof window.opener.customChild!='undefined'){ 
        window.opener.customChildCount++;
        window.opener.customChild[window.opener.customChildCount]= win;
      }

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
function addURLParam(sURL,sparam,sparamvalue){
    sURL+=sURL.indexOf("?")==-1?"?":"&";
    sURL+=encodeURIComponent(sparam)+"="+encodeURIComponent(sparamvalue);
    return sURL;
}

function checkFile(size)
{
	size = size/1024;
        if(size > 1024)	{
		size = size/1024;
		if(size > uploadLimit)
			return false;
		else
			return true;
	}
	else
		return true;
}


function generatePostRequest(winRef,sURL,listParameters)
{
    var formElement=winRef.document.getElementById("postSubmit");
    if(formElement!= undefined)
        winRef.document.body.removeChild(formElement);
    formElement = winRef.document.createElement("form");
    formElement =winRef.document.body.appendChild(formElement);
    formElement.action=sURL;
    formElement.encoding='application/x-www-form-urlencoded';
    formElement.method="post";
    formElement.id='postSubmit';
    for(var iCount=0;iCount<listParameters.length;iCount++)
    {
        var param=listParameters[iCount];
        var srcInput = winRef.document.createElement("input");
        srcInput.setAttribute("type", "hidden");
        srcInput.setAttribute("name", param[0]);
        srcInput.setAttribute("id", param[0]);
        srcInput.setAttribute("value", param[1]);
        formElement.appendChild(srcInput);
    }
    winRef.document.forms['postSubmit'].submit();
}
function encode_ParamValue(param)
{
        return param;
}
function decode_ParamValue(param)
{
    var tempParam =param.replace(/\+/g,' ');
    tempParam = decodeURIComponent(tempParam);

    return tempParam;
}
function getInputParamListFromURL(sURL)
{
    var ibeginingIndex=sURL.indexOf("?");
    var listParam=new Array();
    if (ibeginingIndex == -1)
        return listParam;
    var tempList=sURL.substring(ibeginingIndex+1,sURL.length);

    if(tempList.length>0)
     {
        var arrValue =tempList.split("&");
        for(var iCount=0;iCount<arrValue.length;iCount++)
        {
            var arrTempParam=arrValue[iCount].split("=");
            try
            {
                listParam.push(new Array(decode_ParamValue(arrTempParam[0]),decode_ParamValue(arrTempParam[1])));
            }catch(ex)
            {

            }
        }
    }
    return listParam;
}
function getActionUrlFromURL(sURL)
{
    var ibeginingIndex=sURL.indexOf("?");
    if (ibeginingIndex == -1)
        return sURL;
    else
        return sURL.substring(0,ibeginingIndex);
 }

 function valUploadDocRestriction(FileExt,UplCheck,jsonFileObj)
{
    var bFileExtCheck = true;
    FileExt = Trim(FileExt);
    FileExt = FileExt.toUpperCase();
    if(FileExt.length>0 && UplCheck &&  UplCheck.toUpperCase() == 'Y' && jsonFileObj && jsonFileObj.Files.length>0)
    {
        bFileExtCheck = false;
        var fExt = "";
        for(var count=0;count<jsonFileObj.Files.length;count++){
            fExt = jsonFileObj.Files[count];
            if(fExt == FileExt)
            {
                bFileExtCheck = true;
                break;
            }
        }
    }
    return bFileExtCheck;
}

/*window.open overriding function starts*/

/*window.open_=window.open;


window.open=function(m_url,m_name,m_properties)
{
	if(m_url.indexOf("?")>0)
	{
		m_url=m_url + "&WD_UID="+ wd_uid;
	}
	else
	{
		m_url=m_url + "?WD_UID="+ wd_uid;
	}

    var actionURL=getActionUrlFromURL(m_url);
    var listParam=getInputParamListFromURL(m_url);
    var win = openNewWindow(actionURL, m_name, m_properties, true,"Ext1","Ext2","Ext3","Ext4",listParam);
    return win;
}*/

//window.open function overridding starts
window.open_=window.open;

window.open=function(m_url,m_name,m_properties)
{   
    var actionURL=getActionUrlFromURL(m_url);
    var listParam=getInputParamListFromURL(m_url);
    var win = openNewWindow(actionURL, m_name, m_properties, true,"Ext1","Ext2","Ext3","Ext4",listParam);
    //addWindows(win);
    return win;
}


function openNewWindow(sURL, sName, sFeatures, bReplace,Ext1,Ext2,Ext3,Ext4,listParameters)
{
  /*  if(sURL.indexOf("?")>0)
	{
		sURL=sURL + "&WD_UID="+ wd_uid;
	}
	else
	{
		sURL=sURL + "?WD_UID="+ wd_uid;
	}
  */
  if(typeof sFeatures=='undefined')
	sFeatures='';
   var arrValue =sFeatures.split(",");
        var sf="";
        for(var iCount=0;iCount<arrValue.length;iCount++)
        {
            var arrTempParam=arrValue[iCount].split("=");
            try
            {
               if(arrTempParam[0]=="left"){
                   var left = getMainScreenLeft();  
                    if(left<0){
                        left = 0;
                    }

                    var intWidth=parseInt(arrTempParam[1])+left;
                    arrTempParam[1]=intWidth;
                }
                sf=sf+arrTempParam[0]+"="+arrTempParam[1]+",";
             //   listParam.push(new Array(decode_ParamValue(arrTempParam[0]),decode_ParamValue(arrTempParam[1])));
            }catch(ex)
            {

            }
        } 
    var strFeatures=sf.substring(0,sf.lastIndexOf(",")); 
    var popup = window.open_('',sName,strFeatures,bReplace);
    popup.document.write("<HTML><HEAD><TITLE></TITLE></HEAD><BODY>");
    popup.document.write("<form id='postSubmit' method='post' action='"+sURL+"' enctype='application/x-www-form-urlencoded'>");
    for(var iCount=0;iCount<listParameters.length;iCount++)
    {

        var param=listParameters[iCount];
        popup.document.write("<input type='hidden' id='"+param[0]+"' name='"+param[0]+"'/>");
        popup.document.getElementById(param[0]).value=param[1];//handle single quotes etc
    }
    popup.document.write("<input type='hidden' id='WD_UID' name='WD_UID' value='"+wd_uid+"' />");
    popup.document.write("</FORM></BODY></HTML>");
    popup.document.close();
    popup.document.forms[0].submit();
    return popup;
}

function getActionUrlFromURL(sURL)
{
    var ibeginingIndex=sURL.indexOf("?");
    if (ibeginingIndex == -1)
        return sURL;
    else
        return sURL.substring(0,ibeginingIndex);
 }

 function getInputParamListFromURL(sURL)
{
    var ibeginingIndex=sURL.indexOf("?");
    var listParam=new Array();
    if (ibeginingIndex == -1)
        return listParam;
    var tempList=sURL.substring(ibeginingIndex+1,sURL.length);

    if(tempList.length>0)
     {
        var arrValue =tempList.split("&");
        for(var iCount=0;iCount<arrValue.length;iCount++)
        {
            var arrTempParam=arrValue[iCount].split("=");
            try
            {
                listParam.push(new Array(decode_ParamValue(arrTempParam[0]),decode_ParamValue(arrTempParam[1])));
            }catch(ex)
            {

            }
        }
    }
    return listParam;
}

function decode_ParamValue(param)
{
    var tempParam =param.replace(/\+/g,' ');
    tempParam = decodeURIComponent(tempParam);

    return tempParam;
}


/*window.open overriding function ends*/

function ajaxCheckIsAdmin(interval)
{    
    var checkIsAdmin =new net.ContentLoader(sContextPath+'/faces/ajx/ajxreqhandler.jsp?AJXReqId=ajaxCheckIsAdmin',ajaxCheckIsAdminHandler,null,"POST",'rid='+Math.random()+'&WD_UID='+wd_uid);
    function ajaxCheckIsAdminHandler()
    {
        var isAdmin = this.req.responseText        
        var switchInterval = (interval-0)*1000;
        checkIsAdminTimer = setTimeout("ajaxCheckIsAdmin("+interval+")",switchInterval);
    }
}

var checkIsAdminTimer;

function StartCheckIsAdminTimer(interval)
{
    clearTimeout(checkIsAdminTimer);

    var switchInterval = (interval-0)*1000;
    checkIsAdminTimer = setTimeout("ajaxCheckIsAdmin("+interval+")",switchInterval);
}

function StopCheckIsAdminTimer()
{
    clearTimeout(checkIsAdminTimer);
}
function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

function setPrintPref(value){
    createCookie("PrintPref",value,28);
}
function fetchPrintPref(){
    var printPref=readCookie("PrintPref"); 
    if(printPref==null || printPref=='null' || printPref==''){
        printPref="0"
    }
    return printPref;
}

 function getQueueShortNameTest(Name,totalWidth)
{        
        document.getElementById("queueNameHidden").style.display="inline";
        document.getElementById("queueNameHidden").innerHTML="";
        document.getElementById("queueNameHidden").innerHTML=Name;
        var actualWidth=document.getElementById("queueNameHidden").offsetWidth;
        var charSize=actualWidth/Name.length;       
            var actualCharSize=(totalWidth-50)/charSize+"";            
            if(actualCharSize.indexOf(".") != -1)
            actualCharSize = actualCharSize.substring(0,actualCharSize.indexOf("."));            
            var tempName="";
            if(Name.length-3 > actualCharSize) {
            tempName = Name.substring(0, parseInt(actualCharSize));
            
            tempName = replace(tempName, ">", "&gt;");
            tempName = replace(tempName, "<", "&lt;");
            tempName = replace(tempName, "\"", "&quot;");
            
            tempName = tempName + "...";
            } else {
                tempName = replace(Name, ">", "&gt;");
		tempName = replace(tempName, "<", "&lt;");
		tempName = replace(tempName, "\"", "&quot;");   
            }
            document.getElementById("queueNameHidden").innerHTML="";
            document.getElementById("queueNameHidden").style.display="none";
            return tempName;
        
}
function FindLeftWindowBoundry()
{
	// In Internet Explorer window.screenLeft is the window's left boundry
	if (window.screenLeft)
	{
		return window.screenLeft;
	}
	
	// In Firefox window.screenX is the window's left boundry
	if (window.screenX)
		return window.screenX;
		
	return 0;
}
function getMainScreenLeft()
{ 
    var winLocation = window.location.href;
    if (winLocation.indexOf('/main/main.jsp') > -1)
    {
        if (window.screenLeft)
        {
            return window.screenLeft;
        }
        // In Firefox window.screenX is the window's left boundry
        if (window.screenX)
            return window.screenX;
    }
    else if (window.opener != undefined)
    {
        return window.opener.getMainScreenLeft();
    }
    else if (window.top != undefined)
    {
       return window.top.getMainScreenLeft();
    }
return 0;
}

function openMessageAttributeScreen(fieldId)
{
    fieldId = document.getElementById('fieldId').value;
    var url = sContextPath+'/faces/workitem/view/attributeMessage.jsp?FieldId='+fieldId+'&rid='+MakeUniqueNumber()+"&WD_UID="+wd_uid;
    url = appendUrlSession(url);
    var win =  link_popup(url,'attribute','resizable=no,scrollbars=auto,width='+(wratio*windowW)+',height='+(hratio*windowH)+',left='+windowY/wratio+',top='+windowX/hratio+',resize=yes',windowList,false);
}