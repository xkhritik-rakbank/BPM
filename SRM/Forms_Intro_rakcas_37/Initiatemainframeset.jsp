<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application �Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : InitiatemainFrameset.jsp
//Author                     : Deepti Sharma, Aishwarya Gupta
// Date written (DD/MM/YYYY) : 20-Mar-2014
//Description                : Initial Header fixed form for SRM Module
//---------------------------------------------------------------------------------------------------->
<%@ include file="../SRM_Specific/Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import ="java.text.DecimalFormat"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant ,com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.*;"%>

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<f:view>
<HEAD>
<style>
	@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<TITLE> RAKBANK-Service Request Module</TITLE>

<script language=JavaScript>  // This script tag contains code to disable the right click on the web page.
var message="Function Disabled!"; 
function clickIE4()
{
	if (event.button==2)
	{
		alert(message); return false;
	}
} 
 
 function clickNS4(e)
 {
	if (document.layers||document.getElementById&&!document.all)
	{
		if (e.which==2||e.which==3)
		{
			alert(message); 
			return false; 
		}
	} 
} 
if (document.layers)
{ 
	document.captureEvents(Event.MOUSEDOWN); document.onmousedown=clickNS4; 
} 
else if (document.all&&!document.getElementById)
{ 
	document.onmousedown=clickIE4; 
} 
//document.oncontextmenu=new Function("alert(message);return false") 
//document.oncontextmenu=new Function("return false") 

</script>


		 <script>
            if (typeof window.event != 'undefined'){ // IE
                document.onkeydown = function(e) // IE
                {
                    var t=event.srcElement.type;
                    var kc=event.keyCode;
                    if(event.keyCode==83 && event.altKey){
                        window.parent.workdeskOperations('S');
                    }
                    else if(event.keyCode==73 && event.altKey){
                        window.parent.workdeskOperations('I');
                    }
                    else if (kc == 116) {
                        window.event.keyCode = 0;
                        return false;
                    }
                    else
                        return ((kc != 8 ) || ( t == 'text') || (t == 'textarea') || ( t == 'submit') ||  (t == 'password'))
                }
            }
			

        </script>
		
		<script language="javascript">

	window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
	window.parent.top.moveTo(0,0);
	
</script>
</HEAD>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/aes.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/client.js"></script>
<script language="javascript">
//var encryptedcardnumber;



function whichButton(eventname, event) 
	{
		
		if(event.keyCode == 8)
		{
			event.keyCode=10; 
			return (event.keyCode);
		}
		else if(event.keyCode == 90)
		{
			if(event.ctrlKey)
			{
				event.keyCode=10; 
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 82)
		{
		
			if(event.ctrlKey)
			{
				event.returnValue = false;    
				event.keyCode = 0;
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 37 || event.keyCode == 39)
		{
			if(event.altKey)
			{
				event.returnValue = false;    
				return (event.keyCode);
			}	
		}		
	}

	
	

	
	function setPrimaryField()
	{
		
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	
		//loadOtherBankNameForCCC(iframeDocument);//CRCCC- OutBound CR-amitabh - 11012017
		loadPurposeByChannelForCCCAndSC(iframeDocument);//CRCCC- OutBound CR-amitabh - 11012017
		
		var subCat=document.getElementById("SubCategory").value;
		if(subCat=='Balance Transfer')//CRBT-amitabh
		{
			loadTypeOfBTByChannelForBT(iframeDocument);
		}
		
		if(subCat=='Smart Cash')//CRBT-amitabh
		{
			loadTypeOfSMCByChannelForSC(iframeDocument);
		}
		
		//var workstep=document.getElementById("wdesk:WS_NAME").value;	
		//if(workstep!='PBO')
		//{	
		//	var decision = iframeDocument.getElementById("1_Decision").value;
		//	alert("decision="+decision);
		//	document.getElementById("wdesk:Decision").value=decision;
		//}
		var CategoryID = iframeDocument.getElementById("CategoryID").value;
		document.getElementById("CategoryID").value=CategoryID;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		document.getElementById("SubCategoryID").value=SubCategoryID;
		var ws_name = iframeDocument.getElementById("WS_NAME").value;
		var cardNum = iframeDocument.getElementById("PANno").value;
		//encryptedcardnumber = cardNum;
		//alert(iframeDocument.getElementById("PANno").value);
		document.getElementById("wdesk:encryptedkeyid").value = cardNum;
		//alert(document.getElementById("wdesk:encryptedkeyid").value);
		var WS_LogicalName = iframeDocument.getElementById("WS_LogicalName").value;
		//alert("document.getElementById(Workstep)"+document.getElementById("Workstep"));
		document.getElementById("Workstep").innerHTML ="&nbsp;<b>"+WS_LogicalName+"</b>";
		if(ws_name=="PBO" && document.getElementById("savedFlagFromDB").value=="")
		{
			if(CategoryID==1 && (document.getElementById("d_PANno").value).indexOf("X")==-1)
			{
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,6)+"XXXXXX"+document.getElementById("d_PANno").value.substring(12,16);
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,4)+"-"+document.getElementById("d_PANno").value.substring(4,8)+"-"+document.getElementById("d_PANno").value.substring(8,12)+"-"+document.getElementById("d_PANno").value.substring(12,16);
			}
			//document.getElementById("d_PANno").readOnly=true;
		}
		else
		{
			document.getElementById("d_PANno").value=cardNum;
			//alert(document.getElementById("d_PANno").value);
			if(CategoryID==1)
			{
				document.getElementById("d_PANno").value = Decrypt(document.getElementById("d_PANno").value);
				//alert(document.getElementById("d_PANno").value);
				iframeDocument.getElementById("PANno").value = document.getElementById("d_PANno").value;
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,6)+"XXXXXX"+document.getElementById("d_PANno").value.substring(12,16);
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,4)+"-"+document.getElementById("d_PANno").value.substring(4,8)+"-"+document.getElementById("d_PANno").value.substring(8,12)+"-"+document.getElementById("d_PANno").value.substring(12,16);
			}

			document.getElementById("d_PANno").readOnly=true;
		}
		
		
		return true;
		
	}
	function setSubCategory(selectedValue,SubCategory,cat_Subcat)
	{
		//alert("Hi");
		if(selectedValue=='--Select--')
		{
			document.getElementById(SubCategory).disabled=true;
			document.getElementById(SubCategory).selectedIndex=0;
			return;
		}
		document.getElementById(SubCategory).innerHTML = "";
		//var element = document.getElementById(Category);
		//var selectedValue = element.options[element.selectedIndex].value;
		var select = document.getElementById(SubCategory);

		document.getElementById(SubCategory).disabled=false;
		var arr=cat_Subcat.split('~');
		for(var i = 0; i < arr.length; i++)
		{
			var temp=arr[i].split('#');
			var Cat=temp[0];
			var SubCat=temp[1];
			if(Cat==selectedValue)
			{
				var temp1=SubCat.split(',');
				//var select = document.getElementById(SubCategory);
				select.options[select.options.length] = new Option('--Select--', '--Select--');	
				for(var j = 0; j < temp1.length; j++)
				{	//var select = document.getElementById(SubCategory);
					if(temp1[j]!="")
						select.options[select.options.length] = new Option(temp1[j],temp1[j]);					
				}
				break;
			}
		
		}
		//Setting the values in the dropdown on th basic of selected channel.Addedon2/5/2017
		if(document.getElementById("Category").value=='Cards' && document.getElementById("MAPSERVICEREQUEST").value!='' && document.getElementById("MAPSERVICEREQUEST").value.indexOf('$')==-1)
		{
			setCategoryByChannel();
		}
		//EndAddedon2/5/2017
		
		//Addedon10/5/2017
		if(document.getElementById("Category").value=='Cards' && document.getElementById("MAPSERVICEREQUEST").value!='' && document.getElementById("MAPSERVICEREQUEST").value.indexOf('$')!=-1)
		{
			if(document.getElementById("Channel").value!='--Select--')
			setSubCategoryByChannelChange(document.getElementById("Channel"));
		}else//Addedon15/05/2017************************************
		{
			//document.getElementById("SubCategory").disabled=true;//If channel group mapping is not found then disable all the fields on forms 
		}//EndAddedon15/05/2017************************************
		
		//EndAddedon10/5/2017
	}
	//Below function for setting category by chaanel selected.Addedon2/5/2017
	function setCategoryByChannel()
	{
			document.getElementById('SubCategory').options.length=0;//To clear the dropdown before add records.
			var optSelect = document.createElement("option");
			optSelect.text = '--Select--';
			optSelect.value ='--Select--';
			document.getElementById('SubCategory').options.add(optSelect);
			var MAPSERVICEREQUEST=document.getElementById("MAPSERVICEREQUEST").value;
			var MAPSERVICEREQUESTArray=MAPSERVICEREQUEST.split(',');
			for(var j=0;j<MAPSERVICEREQUESTArray.length;j++)
			{
				var optDbValues = document.createElement("option");
				optDbValues.text = MAPSERVICEREQUESTArray[j];
				optDbValues.value =MAPSERVICEREQUESTArray[j];
				document.getElementById('SubCategory').options.add(optDbValues);
			}	
	}
	//**********************************************************************EndAddedon2/5/2017
	
	//**********************************************************************Addedon10/5/2017
	function setSubCategoryByChannelChange(obj)
	{
		//alert(obj.value);
		if(document.getElementById("Category").value=='Cards' && document.getElementById("MAPSERVICEREQUEST").value!='')
		{
				document.getElementById('SubCategory').options.length=0;//To clear the dropdown before add records.
				var optSelect = document.createElement("option");
				optSelect.text = '--Select--';
				optSelect.value ='--Select--';
				document.getElementById('SubCategory').options.add(optSelect);
				var MAPSERVICEREQUEST=document.getElementById("MAPSERVICEREQUEST").value;
				var MAPChannelSERVICEREQUESTArray=MAPSERVICEREQUEST.split('$');
				for(var j=0;j<MAPChannelSERVICEREQUESTArray.length;j++)
				{
					var ChannelServiceArray=MAPChannelSERVICEREQUESTArray[j].split('#');
					var channel=ChannelServiceArray[0];
					if(obj.value==channel)
					{
							var MAPSERVICEREQUESTArray=ChannelServiceArray[1].split(',');
							for(var k=0;k<MAPSERVICEREQUESTArray.length;k++)
							{
								var optDbValues = document.createElement("option");
								optDbValues.text = MAPSERVICEREQUESTArray[k];
								optDbValues.value =MAPSERVICEREQUESTArray[k];
								document.getElementById('SubCategory').options.add(optDbValues);
							}
							break;//If channel found then break the loop.
					}
				}
		}
	}
	//**********************************************************************EndAddedon10/5/2017
	function HistoryCaller()
	{
		//For loading history
		var hist_table="usr_0_srm_wihistory";
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
		var Category=document.getElementById("wdesk:Category").value;
		var SubCategory=document.getElementById("wdesk:SubCategory").value;
		var keyID=document.getElementById("d_PANno").value;
		//alert("keyID="+keyID);
		openWindow("../SRM_Specific/history.jsp?WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&hist_table="+hist_table+"&Category="+Category+"&SubCategory="+SubCategory+"&keyID="+keyID,'wihistory','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,resizable=no,width=800,height=600');
		//openWindow("/webdesktop/CustomForms/SRM_Specific/history.jsp?WINAME="+WINAME+"&hist_table="+hist_table+"&Category="+Category+"&SubCategory="+SubCategory+"&keyID="+keyID,'wihistory','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,resizable=no,width=800,height=600');
		
		
	}
	function validate(ColumnCopy)
	{
	
	try{	
			//alert("ColumnCopy==="+ColumnCopy);
			document.getElementById("Fetch").disabled=true;
			document.getElementById("wdesk:Category").value=document.getElementById("Category").value;
			document.getElementById("wdesk:SubCategory").value=document.getElementById("SubCategory").value;
			document.getElementById("wdesk:Channel").value=document.getElementById("Channel").value;
			var panNo=document.getElementById(ColumnCopy).value;
			var cardNo=replaceAll(panNo,"-","");
			//alert(cardNo);
			//alert(cardNo.length);
			if(document.getElementById("Category").value=="--Select--")
			{
				alert("Category is mandatory.");
				document.getElementById("Category").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if(document.getElementById("SubCategory").value=="--Select--")
			{
				alert("Sub Category is mandatory.");
				document.getElementById("SubCategory").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if(document.getElementById("Channel").value=="--Select--")
			{
				alert("Channel is mandatory.");
				document.getElementById("Channel").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if(document.getElementById(ColumnCopy).value=="")
			{
				alert("Card No. is mandatory.");
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			
			regex=/^[X0-9]/;
			if(!regex.test(cardNo))
			{	alert("Only numerics are allowed in Card No.");
				document.getElementById(ColumnCopy).value="";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled=false;	
				return false;
			}
			if(cardNo.length!=16)
			{
				alert("Length of card no. should be exactly 16 digits.");
				document.getElementById(ColumnCopy).value="";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			
		/*	regex=/^[X0-9]{16}/;
			if(!regex.test(cardNo))
			{
				alert("Length Of Card No Should be exactly 16 digits.");
				document.getElementById(ColumnCopy).value="";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}*/
			
			if(!mod10(cardNo) || cardNo=='0000000000000000' || cardNo=='8888888888888888')
			// if(!mod10(cardNo))
			{
				alert("Invalid Card No.");
				document.getElementById(ColumnCopy).value="";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			
			//showProcessingCustom();
			
			document.getElementById("Category").disabled=true;
			document.getElementById("SubCategory").disabled=true;
			document.getElementById("Channel").disabled=true;
			document.getElementById(ColumnCopy).disabled=true;
			
			//alert("ColumnCopy2");
			var WINAME=document.getElementById("wdesk:WI_NAME").value;
			var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
			//alert("TEMPWINAME BPM : "+TEMPWINAME);
			var WS=document.getElementById("wdesk:WS_NAME").value;
			var category = document.getElementById("wdesk:Category").value.split(' ').join('_');
			var subCategory  = document.getElementById("wdesk:SubCategory").value.split(' ').join('_');
			var frmData = document.getElementById("frmData");
			var maskedCardNumber = "";
			//alert("ColumnCopy3");

			if(category=='Cards')
			{	
				//alert("ColumnCopy4");
				//alert("before"+panNo);
				panNo = Encrypt(panNo);
				
				document.getElementById("wdesk:encryptedkeyid").value = panNo;
				//alert(document.getElementById("wdesk:encryptedkeyid").value);
							
				maskedCardNumber=document.getElementById("d_PANno").value.substring(0,6)+"XXXXXX"+document.getElementById("d_PANno").value.substring(12,16);
				maskedCardNumber=maskedCardNumber.substring(0,4)+"-"+maskedCardNumber.substring(4,8)+"-"+maskedCardNumber.substring(8,12)+"-"+maskedCardNumber.substring(12,16);
				//alert(maskedCardNumber);
			}
			//alert("ColumnCopy5");
			var sUrl="../SRM_Specific/BPM_CommonBlocksDebitCard.jsp?load=firstLoad&panNo="+panNo+"&WS="+WS+"&Category="+category+"&SubCategory="+subCategory+"&WINAME="+WINAME+"&FlagValue=N"+"&TEMPWINAME="+TEMPWINAME+"&CardNo_Masked="+maskedCardNumber+"&channel="+document.getElementById("Channel").value;
			//alert("ColumnCopy6");
			frmData.src = replaceUrlChars(sUrl);
			//alert("returned sUrl"+sUrl);
			
			return true;
		}
		catch(e)
		{
			alert("error=="+e.message+".");
		}
		
	}
	function ClearFields(savedFlagFromDB)
	{
		//alert("document.getElementById(IsSavedFlag).value="+document.getElementById("IsSavedFlag").value);
		if(!(savedFlagFromDB=='Y' || document.getElementById("IsSavedFlag").value=='Y'))
		{
			document.getElementById("Category").disabled=false;
			document.getElementById("Category").selectedIndex=0;
			document.getElementById("SubCategory").disabled=true;
			document.getElementById("SubCategory").selectedIndex=0;
			//Change added condition Addedon10/5/2017
			if(document.getElementById("MAPSERVICEREQUEST").value.length==0)
			{
				document.getElementById("Channel").disabled=false;
				document.getElementById("Channel").selectedIndex=0;
			} // end - Addedon10/5/2017
			document.getElementById("d_PANno").disabled=false;
			document.getElementById("d_PANno").readOnly=false;
			document.getElementById("d_PANno").value="";
			document.getElementById("Fetch").disabled=false;
			var frmData = document.getElementById("frmData");
			frmData.src="../SRM_Specific/BPM_blank.jsp";
			
			document.getElementById("Category").focus();
		}else{
		
			alert("This case has been saved. It cannot be cleared.");
			document.getElementById("Clear").disabled=true;
		}
	}
	function DiscardWI()
	{
		//alert(document.getElementById("SubCategory").value);
		if(document.getElementById("SubCategory").value!='Balance Transfer' && document.getElementById("SubCategory").value!='Credit Card Cheque'    && document.getElementById("SubCategory").value!='Blocking of Cards')
		{
			document.getElementById("wdesk:IsRejected").value="Y";
			var opener;
			if (window.dialogArguments) 
			{ 
				opener = window.dialogArguments;
			} 
			else 
			{
				if(parent)
				{
					opener=parent;
				}
				else if (window.top.opener) 
				{
					opener = window.top.opener; 
				}
			}  
			opener.introduceWI();
	}else{
	
	//alert();
	alert("Case cannot be discarded for " + document.getElementById("SubCategory").value+".");
	document.getElementById("Discard").disabled=true;
	}
	
	}
	function replaceUrlChars(sUrl)
	{	
		//alert("inside replaceUrlChars");
		return sUrl.split("+").join("ENCODEDPLUS");
	
	}
	function CallJSP(WSNAME,Flag,ViewMode)
	{
		
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
		//alert("TEMPWINAME in init:::::"+TEMPWINAME);
		
		if(WSNAME=="PBO")
			setSubCategory(document.getElementById("wdesk:Category").value, 'SubCategory', document.getElementById("cat_Subcat").value);
		//alert("Inside calljsp2");
		document.getElementById("SubCategory").value=document.getElementById("wdesk:SubCategory").value;
		document.getElementById("Category").value=document.getElementById("wdesk:Category").value;
		document.getElementById("Channel").value=document.getElementById("wdesk:Channel").value;
				
		var category = document.getElementById("wdesk:Category").value.split(' ').join('_');
		var subCategory  = document.getElementById("wdesk:SubCategory").value.split(' ').join('_');
		
		var frmData = document.getElementById("frmData");
		document.getElementById("Category").disabled=true;
		document.getElementById("SubCategory").disabled=true;
		document.getElementById("Channel").disabled=true;
		//document.getElementById("d_PANno").disabled=true;
		if(WSNAME=="PBO" && ViewMode!="R")
		document.getElementById("Fetch").disabled=true;
		frmData.src = "../SRM_Specific/BPM_CommonBlocksDebitCard.jsp?load=SecondLoad&WS="+WSNAME+"&WINAME="+WINAME+"&Category="+category+"&SubCategory="+subCategory+"&FlagValue="+Flag+"&ViewMode="+ViewMode+"&TEMPWINAME="+TEMPWINAME;
		return true;
	}
	
	function replaceAll(data,searchfortxt,replacetxt)
	{
		var startIndex=0;
		while(data.indexOf(searchfortxt)!=-1)
		{
			data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+1,data.length);
		}	
		return data;
	}
	function mod10( cardNumber ) 
	{ 	
           var clen = new Array( cardNumber.length ); 
           var n = 0,sum = 0; 
           for( n = 0; n < cardNumber.length; ++n ) 
		      { 
                      clen [n] = parseInt ( cardNumber.charAt(n) ); 
			  } 
          for( n = clen.length -2; n >= 0; n-=2 ) 
				{
					  clen [n] *= 2; 	
			          if( clen [n] > 9 ) 
				          clen [n]-=9; 
				}

	     for( n = 0; n < clen.length; ++n ) 
		        { 
					  sum += clen [n]; 
		        } 
		 return(((sum%10)==0)?true : false);
	}
	function validateCCN(cntrl)
	{	
		var keycode=event.keyCode;
		
		var cntrlValue=cntrl.value;
	
		if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
			cntrl.value=cntrlValue+"-";
		
	}

	function validateCCNDataOnKeyUp(cntrl)
	{

		var regex=/^[0-9]{16}$/;
			if(regex.test(document.getElementById(ColumnCopy).value))
			{
				var vCCN=document.getElementById(ColumnCopy).value;
				document.getElementById(ColumnCopy).value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
				return false;
			}		

		var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	

		var keycode=event.keyCode;
		if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
			{
			alert("Invalid Card No. format.");
			cntrl.value="";
			cntrl.focus();
			return false;
			}		
	}
	function formLoad()
	{
		//document.getElementById("SubCategory").disabled=true;
		document.getElementById("Category").selectedIndex=1;
		setSubCategory(document.getElementById("Category").value,'SubCategory',document.getElementById("cat_Subcat").value.replace(", ", ","));
		//Commented below line.Addedon2/5/2017
		//document.getElementById("Channel").selectedIndex=1;
		//***************************EndAddedon2/5/2017
		//alert("FormLoad TempWIName "+document.getElementById("TEMP_WI_NAME").value);
	}
	
	function tempWI()
	{	
		//alert("tempWI called.....");		
		
		var fetchURL="/webdesktop/CustomForms/SRM_Specific/tempWI.jsp";
		fetchURL = replaceUrlChars(fetchURL);
		//window.open(fetchURL);
		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		//window.open(fetchURL);
		 xhr.open("GET",fetchURL,false); 
		 xhr.send(null);
		//alert(xhr.status);		
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			var ajaxResult=xhr.responseText;
			//alert(ajaxResult);
			ajaxResult=myTrim(ajaxResult);
			
			var returnvars = ajaxResult.split("~");
			var result = returnvars[0];
			var tmpWI = returnvars[1];
									
			//alert("tmpWI : "+tmpWI);
			if(result=='0000')
			{
				document.getElementById("wdesk:TEMP_WI_NAME").value = tmpWI;
				//alert("TEMP_WI_NAME in INIITTTT "+document.getElementById("TEMP_WI_NAME").value);
			}
			else
			{
				alert("Problem in creating temporary workitem name.");
				return false;
			}
			document.getElementById("SubCategory").focus();
			
		}
		else
		{
			alert("Problem in fetching the data.");
			return false;
		}
		//document.getElementById("IsCSURefreshClicked").value="clicked";	
		
	}
	
	document.MyActiveWindows= new Array;

	function openWindow(sUrl,sName,sProps)
	{
		document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
	}

	function closeAllWindows()
	{
		//alert("hi");
		for(var i = 0;i < document.MyActiveWindows.length; i++)
			document.MyActiveWindows[i].close();
	}
	function resizeIframe(obj) 
	{
		//alert("resizing");
		try{
		//obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px'; request.getParameter("Comp_height");
		//obj.style.height = <%=request.getParameter("Comp_height")%> + 'px';
		obj.style.height = '2500px';
		}catch(err){}
	}
	
	/*function loadOtherBankNameForCCC(iframeDocument)//CRCCC- OutBound CR-amitabh - 11012017
	{
		//alert('loadOtherBankNameForCCC called');
		var subCat=document.getElementById("SubCategory").value;
		var subCatID=iframeDocument.getElementById("SubCategoryID").value;
		//alert('subCat' +subCat);
		if(subCatID == 4)
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=othBankName';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 //alert('ajaxResult'+ajaxResult);
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values");
					return false;
				 }				 
				 values = ajaxResult.split("#");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					iframeDocument.getElementById('4_other_bank_name').options.add(opt);
				 }				 
			}
			else
			{
				alert("Exception while loading dropdown values");
			}			
		}
		if(subCatID == 5)
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=othBankName';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 //alert('ajaxResult'+ajaxResult);
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values");
					return false;
				 }				 
				 values = ajaxResult.split("#");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					iframeDocument.getElementById('5_other_bank_name').options.add(opt);
				 }				 
			}
			else
			{
				alert("Exception while loading dropdown values");
			}			
		}
	}*/
	
	function loadPurposeByChannelForCCCAndSC(iframeDocument)//CRCCC- OutBound CR-amitabh - 11012017
	{
		//alert('loadPurposeByChannelForCCC called');
		var subCat=document.getElementById("SubCategory").value;
		var chhanel=document.getElementById("Channel").value;
		//alert('subCat' +subCat+'chhanel '+chhanel);
		if(subCat=='Credit Card Cheque')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=purposeByChannel&SubCat='+subCat+'&channel='+chhanel;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 //alert('ajaxResult'+ajaxResult);
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values");
					return false;
				 }				 
				 values = ajaxResult.split("#");
				 iframeDocument.getElementById('4_Purpose').options.length=0;
				 var optSelect = document.createElement("option");
				 optSelect.text ='--Select--' ;
				 optSelect.value ='--Select--' ;
				 iframeDocument.getElementById('4_Purpose').options.add(optSelect);
				 for(var j=0;j<values.length;j++)
				 {
					if (values[j] == '' || values[j] == ' ')
						break;
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					iframeDocument.getElementById('4_Purpose').options.add(opt);
				 }				 
			}
			else
			{
				alert("Exception while loading dropdown values");
			}			
		} 
		/*else if(subCat=='Smart Cash')
		{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=purposeByChannel&SubCat='+subCat+'&channel='+chhanel;
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 //alert('ajaxResult'+ajaxResult);
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values");
					return false;
				 }				 
				 values = ajaxResult.split("#");
				 iframeDocument.getElementById('5_Purpose').options.length=0;
				 var optSelect = document.createElement("option");
				 optSelect.text ='--Select--' ;
				 optSelect.value ='--Select--' ;
				 iframeDocument.getElementById('5_Purpose').options.add(optSelect);
				 for(var j=0;j<values.length;j++)
				 {
					if (values[j] == '' || values[j] == ' ')
						break;
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					iframeDocument.getElementById('5_Purpose').options.add(opt);
				 }				 
			}
			else
			{
				alert("Exception while loading dropdown values");
			}			
		}*/
	}
	
	function loadTypeOfBTByChannelForBT(iframeDocument)//CRBT-amitabh
	{
		//alert('loadTypeOfBTByChannelForBT called');
		var channel=document.getElementById("Channel").value;
		//alert('chhanel '+channel);
		var url = '';
		var xhr;
		var ajaxResult;		
		if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=TypeOfBTByChannel&channel='+channel;
		xhr.open("GET",url,false);
		xhr.send(null);
		if (xhr.status == 200)
		{
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 //alert('ajaxResult'+ajaxResult);
			 if(ajaxResult=='-1')
			 {
				alert("Error while loading dropdown values");
				return false;
			 }				 
			 values = ajaxResult.split("#");
			 iframeDocument.getElementById('2_type_of_bt').options.length=0;
			 var optSelect = document.createElement("option");
			 optSelect.text ='--Select--' ;
			 optSelect.value ='--Select--' ;
			 iframeDocument.getElementById('2_type_of_bt').options.add(optSelect);
			 for(var j=0;j<values.length;j++)
			 {
				if (values[j] == '' || values[j] == ' ')
					break;
				var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				iframeDocument.getElementById('2_type_of_bt').options.add(opt);
			 }				 
		}
		else
		{
			alert("Exception while loading dropdown values");
		}
	}
	
	function loadTypeOfSMCByChannelForSC(iframeDocument)//CRBT-amitabh
	{
		//alert('loadTypeOfSMCByChannelForSC called');
		var channel=document.getElementById("Channel").value;
		//alert('chhanel '+channel);
		var url = '';
		var xhr;
		var ajaxResult;		
		if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
		url = '/webdesktop/CustomForms/SRM_Specific/DropDownLoad.jsp?reqType=TypeOfSMCByChannel&channel='+channel;
		xhr.open("GET",url,false);
		xhr.send(null);
		if (xhr.status == 200)
		{
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 //alert('ajaxResult'+ajaxResult);
			 if(ajaxResult=='-1')
			 {
				alert("Error while loading dropdown values");
				return false;
			 }				 
			 values = ajaxResult.split("#");
			 iframeDocument.getElementById('5_type_of_smc').options.length=0;
			 var optSelect = document.createElement("option");
			 optSelect.text ='--Select--' ;
			 optSelect.value ='--Select--' ;
			 iframeDocument.getElementById('5_type_of_smc').options.add(optSelect);
			 for(var j=0;j<values.length;j++)
			 {
				if (values[j] == '' || values[j] == ' ')
					break;
				var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				iframeDocument.getElementById('5_type_of_smc').options.add(opt);
			 }				 
		}
		else
		{
			alert("Exception while loading dropdown values");
		}
	}
	
	function csufetch()
	{
		//alert("Inside CSU fetch");
		//alert("encrypted card number "+encryptedcardnumber);
		var fetchURL="/webdesktop/CustomForms/SRM_Specific/CBR_CSU_Fetch.jsp?cardnumber="+document.getElementById("wdesk:encryptedkeyid").value;
		fetchURL = replaceUrlChars(fetchURL);
		//window.open(fetchURL);
		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 xhr.open("GET",fetchURL,false); 
		 xhr.send(null);
		//alert(xhr.status);		
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			var ajaxResult=xhr.responseText;
			//alert(ajaxResult);
			ajaxResult=myTrim(ajaxResult);
			
			var returnvars = ajaxResult.split("~");
			var cardstatus = returnvars[0];
			var cbEligibleAmt = returnvars[1];
			var mobileNo = returnvars[2];
			var exception = returnvars[3];
			if(exception == '111')
			{
				alert("There is some error during refreshing the data.");
				return false;
			}
			var iframe = document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			
			iframeDocument.getElementById("1_CCI_CStatus").value=cardstatus;
			iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value=cbEligibleAmt;
			iframeDocument.getElementById("1_CCI_MONO").value=mobileNo;
			
		}
		else
		{
			alert("Problem in fetching the data.");
			return false;
		}
		document.getElementById("IsCSURefreshClicked").value="clicked";
		
	}
function myTrim(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}
	
	window.onunload = function(){closeAllWindows()};
	
</script>


 
<%
WriteLog("Start of Initiatemainframeset...");
String Query="";
String params="";
String inputData="";
String outputData="";
String maincode="";
String FlagValue="";
XMLParser xmlParserData=null;
XMLParser objXmlParser=null;
String subXML="";
//String subcategory="";
String channel="";
int counter=0;
/*Query="select count(*) as count from RB_New_SRM_EXTTABLE where WI_NAME='fd'";
		
	inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
			
	outputData = WFCallBroker.execute(inputData, wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), 1);
	WriteLog("outputData SRM-->"+outputData);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	maincode = "0";//xmlParserData.getValueOf("MainCode");
	
	if(maincode.equals("0"))
	{	counter =0;//Integer.parseInt(xmlParserData.getValueOf("count"));
		if(counter!=0)
		FlagValue ="Y";
		WriteLog("FlagValue"+FlagValue);		
	}
	//out.println("value="+wfsession.getM_strMultiTenancyVar()+"=");
*/
%>
<% /*if(!FlagValue.equals("Y"))                                               //widpid chnges  PBO Check

{*/
%>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "formLoad();tempWI();" onkeydown="whichButton('onkeydown',event)">
<%
/*
}
else
{*/
%>
<%--
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="CallJSP('PBO', '<%=FlagValue%>','W');" >        widpid chnges  getActivityName()
--%>

<%
//}
%>

<form name="wdesk" id="wdesk" method="post" visibility="hidden">
<table border='1' cellspacing='1' cellpadding='0' width=100% >
<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=center class='EWLabelRB2'><b>Service Request Module </b></td>
</tr>
<tr>
<!--td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workitem Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% value = "javascript:document.getElementById("wdesk:TEMP_WI_NAME").value;">&nbsp;&nbsp;&nbsp;&nbsp;<b></b></td-->    <%--widpid chnges  getProcessInstanceId--%>
<!--Added below hidden field Addedon2/5/2017 -->
<input type='hidden' name="MAPSERVICEREQUEST" id="MAPSERVICEREQUEST"/>
<!-- End Addedon2/5/2017 -->
<td colspan =4 width=100% align=right valign=center width = 50%><img src='\webdesktop\webtop\images\rak-logo.gif'></td></tr>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;<b><%=wDSession.getM_objUserInfo().getM_strUserName()%></b></td>						<%--widpid chnges    getUsername  --%>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Workstep"><b>&nbsp;PBO</b></label></td>
<td colspan =4 width=25% align=left valign=center><label id="Workstep" width = 25%></label></td>
</tr>

<tr>

<%
	//Query="select distinct t.[CategoryName], STUFF((SELECT distinct ', ' + convert(nvarchar(255),t1.subcategoryName) from USR_0_SRM_SUBCATEGORY t1 where t.[CategoryIndex] = t1.[parentCategoryIndex] and t1.isactive='Y' FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'),1,2,'') subcategoryName from USR_0_SRM_CATEGORY t where t.IsActive = 'Y' ";
	//Query="select CategoryName,SubCategoryName from Category_SubCategory_Map";
		
	//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="IsActive==Y";
	Query="select distinct t.[CategoryName], STUFF((SELECT distinct ', ' + convert(nvarchar(255),t1.subcategoryName) from USR_0_SRM_SUBCATEGORY t1 where t.[CategoryIndex] = t1.[parentCategoryIndex] and t1.isactive='Y' FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'),1,2,'') subcategoryName from USR_0_SRM_CATEGORY t where t.IsActive =:IsActive ";
		
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";		
	//outputData = WFCallBroker.execute(inputData, wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), 1);
	outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
	WriteLog("outputData Initiate-->"+outputData);
	
	String cat_Subcat="";
	String temp[] = null;
	ArrayList<String> category = new ArrayList<String>();
	ArrayList<String> subCategory = new ArrayList<String>();
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	maincode =xmlParserData.getValueOf("MainCode");
	int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	if(maincode.equals("0"))
	{	
		for(int k=0; k<recordcount; k++)
		{	
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			category.add(objXmlParser.getValueOf("CategoryName"));
			temp = objXmlParser.getValueOf("subcategoryName").split(",");
			cat_Subcat+=objXmlParser.getValueOf("CategoryName")+"#"+objXmlParser.getValueOf("subcategoryName")+"~";
			for(int i=0; i<temp.length; i++)
			{
				 subCategory.add(temp[i]);
			}
		}
		cat_Subcat=cat_Subcat.substring(0,(cat_Subcat.lastIndexOf("~")));
	}
WriteLog("subcat"+cat_Subcat);
%>	
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Category</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select onchange="javascript:setSubCategory(this.value,'SubCategory','<%=cat_Subcat.replaceAll(", ", ",")%>');" width='300' name='Category' id='Category' style='width:170px'><option value='--Select--'>--Select--</option><%for(int i=0; i<category.size(); i++){%><option value='<%=category.get(i)%>'><%=category.get(i)%></option>
<%}%></select></td>
<input type=hidden name="cat_Subcat" id="cat_Subcat" style="visibility:hidden" value='<%=cat_Subcat.replaceAll(", ", ",")%>'>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sub Category</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><select width='300' name='SubCategory' id='SubCategory' style='width:170px' ><option value='--Select--'>--Select--</option><%for(int j=0; j<subCategory.size(); j++){%><option value='<%=subCategory.get(j).trim()%>'><%=subCategory.get(j).trim()%></option><%}%></select></td>
</tr>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Channel</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><select width='300' name='Channel' id='Channel' style='width:170px'  onchange="setSubCategoryByChannelChange(this);"> <!--oncange function Addedon10/5/2017 -->
<option value='--Select--'>--Select--</option>
<%
	//Query="select Channel from USR_0_SRM_CHANNELMAP where IsActive='Y' order by Channel desc";
		
	//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="IsActive==Y";
	Query="select Channel from USR_0_SRM_CHANNELMAP where IsActive=:IsActive order by Channel desc";
		
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	
			
	//outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
	WriteLog("outputData SRM-->"+outputData);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	maincode = xmlParserData.getValueOf("MainCode");
	
	recordcount =Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	if(maincode.equals("0"))
	{	
		for(int p=0; p<recordcount; p++)
		{	
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			channel = objXmlParser.getValueOf("Channel");
                    
%>
<option value='<%=channel%>'><%=channel%></option>
<%
		}
	}	
%>
</select></td>

<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Card No.</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' name='PANno'  id='d_PANno' value = '' maxlength = '20' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;
<% 
if((!FlagValue.equals("Y")) )
{

%>
<input name='Fetch' type='button' id='Fetch' value='Fetch' onclick=" validate('d_PANno');" class='EWButtonRB' style='width:60px'><input name='Clear' type='button' value='Clear' id='Clear' onclick="ClearFields()" class='EWButtonRB' style='width:60px'></td>
<%
}

%>
</td>
</tr>
<%
	//Getting Logged in user groups by API.******************************************************************************Addedon2/5/2017
	String getGroupParams="UserIndex=="+wDSession.getM_objUserInfo().getM_strUserIndex()+"";
	String getUserGroupQuery="SELECT CHANNEL,MAPSERVICEREQUEST FROM PDBGroupMember PGM,PDBUser PU,PDBGroup PG,USR_0_SRM_GROUP_CHANNELMAPPING"+
							 " USRGPMAP WHERE PG.GroupIndex=PGM.GroupIndex"+
							 " AND PGM.UserIndex=PU.UserIndex AND USRGPMAP.USERGROUP=PG.GroupName AND PU.UserIndex=:UserIndex";
	String getUserGroupInfoInput = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + getUserGroupQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + getGroupParams + "</Params></APSelectWithNamedParam_Input>";
							
	WriteLog("getUserGroupInfoInput-->"+getUserGroupInfoInput);
	//String getUserGroupInfoOutPut = WFCallBroker.execute(getUserGroupInfoInput, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	String getUserGroupInfoOutPut = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), getUserGroupInfoInput);
	WriteLog("getUserGroupInfoOutPut-->"+getUserGroupInfoOutPut);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((getUserGroupInfoOutPut));
	maincode = xmlParserData.getValueOf("MainCode");
	com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "getUserGroupInfoOutPut maincode-->"+maincode);
	if(maincode.equals("0"))
	{
		recordcount =Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		if(recordcount==0)
		{
			%>
			<script>
			alert("Channel group mapping is not found for loggedin user.");
			//Addedon15/05/2017***************************************
			document.getElementById("Category").disabled=true;			
			document.getElementById("Channel").disabled=true;
			document.getElementById("d_PANno").disabled=true;			
			document.getElementById("Fetch").disabled=true;
			document.getElementById("Clear").disabled=true;
			//EndAddedon15/05/2017************************************
			document.getElementById("Fetch").disabled=true;
			</script>
			<%
		}
		else if(recordcount==1)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			String CHANNEL = objXmlParser.getValueOf("CHANNEL");
			String MAPSERVICEREQUESTValue=objXmlParser.getValueOf("MAPSERVICEREQUEST");
			WriteLog("MAPSERVICEREQUESTValue "+MAPSERVICEREQUESTValue);
			%>
			<script>
				var MAPSERVICEREQUESTValue='<%=MAPSERVICEREQUESTValue%>';
				if(MAPSERVICEREQUESTValue.length==0)
				{
					alert("Service request mapping are not defined.");
					document.getElementById("Fetch").disabled=true;
				}
				var comboId = document.getElementById("Channel");
				comboId.value='<%=CHANNEL%>';
				document.getElementById("Channel").disabled=true;
				document.getElementById("MAPSERVICEREQUEST").value='<%=MAPSERVICEREQUESTValue%>';
			</script>
			<%
		}
		else
		{
			String concatinatedChannelRequest="";
			for(int p=0; p<recordcount; p++)
			{	
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);
				String CHANNEL = objXmlParser.getValueOf("CHANNEL");
				String MAPSERVICEREQUESTValue=objXmlParser.getValueOf("MAPSERVICEREQUEST");
				WriteLog("CHANNEL "+CHANNEL);
				WriteLog("MAPSERVICEREQUESTValue "+MAPSERVICEREQUESTValue);	
				if(concatinatedChannelRequest.trim().length()==0)
				 concatinatedChannelRequest=concatinatedChannelRequest+CHANNEL+"#"+MAPSERVICEREQUESTValue;
				else
				concatinatedChannelRequest=concatinatedChannelRequest+"$"+CHANNEL+"#"+MAPSERVICEREQUESTValue;			
			}
			
			WriteLog("concatinatedChannelRequest "+concatinatedChannelRequest);
			
			%>
			<script>
				var concatinatedChannelRequest='<%=concatinatedChannelRequest%>';
				if(concatinatedChannelRequest.length==0)
				{
					alert("Service request mapping are not defined.");
					document.getElementById("Fetch").disabled=true;
				}
				document.getElementById("MAPSERVICEREQUEST").value='<%=concatinatedChannelRequest%>';
				
				document.getElementById('Channel').options.length=0;//To clear the dropdown before add records.
				var optSelect = document.createElement("option");
				optSelect.text = '--Select--';
				optSelect.value ='--Select--';
				document.getElementById('Channel').options.add(optSelect);
				var MAPSERVICEREQUEST=document.getElementById("MAPSERVICEREQUEST").value;
				var MAPChannelSERVICEREQUESTArray=MAPSERVICEREQUEST.split('$');
				for(var j=0;j<MAPChannelSERVICEREQUESTArray.length;j++)
				{
					var ChannelServiceArray=MAPChannelSERVICEREQUESTArray[j].split('#');
					var channel=ChannelServiceArray[0];
						var optDbValues = document.createElement("option");
						optDbValues.text = channel;
						optDbValues.value =channel;
						document.getElementById('Channel').options.add(optDbValues);
				}
			</script>
			<%	
		}
	}
	else
	{
		WriteLog("inside else ");
		%>
			<script>
				alert("Exception in getting channel group mapping.");
				document.getElementById("Fetch").disabled=true;
			</script>
		<%
	}	
	//*******************************************************************************************************************EndAddedon2/5/2017
%>
</table>
<iframe border=0 src="../SRM_Specific/BPM_blank.jsp" id="frmData" name="frmData" width="100%"  scrolling = "no" onload='javascript:resizeIframe(this);' onresize='javascript:resizeIframe(this);'></iframe>

<table><tr><td><input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='PBO'/></td></tr></table>
<input type='hidden' name="wdesk:Process_Name" id="wdesk:Process_Name" value='SRM'/>          <%--widpid  getRouteName()--%>

<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value=''/>     <%--widpid  getProcessInstanceId()--%>
<input type='hidden' name="wdesk:TEMP_WI_NAME" id="wdesk:TEMP_WI_NAME" value=''/>     <%--widpid  getProcessInstanceId()--%>
<input type='hidden' name="wdesk:IntoducedBy" id="wdesk:IntoducedBy" value=''/>   <%--widpid  getUserName()--%>
<input type='hidden' name="wdesk:IntegrationStatus" id="wdesk:IntegrationStatus" value=''/>   
<input type='hidden' name="CategoryID" id="CategoryID" value=''/>
<input type='hidden' name="SubCategoryID" id="SubCategoryID" value=''/>
<input type='hidden' name="savedFlagFromDB" id="savedFlagFromDB" value=''/>     
<input type='hidden' name="wdesk:SubCategory" id="wdesk:SubCategory" value=''/>    <%--widpid chnges  get("SubCategory")--%>
<input type='hidden' name="wdesk:Category" id="wdesk:Category" value=''/>    <%--widpid chnges  get("Category")--%>
<input type='hidden' name="wdesk:Channel" id="wdesk:Channel" value=''/>   <%--widpid chnges  get("Channel")--%>
<input type='hidden' name="wdesk:IsRejected" id="wdesk:IsRejected" value=''/>
<input type='hidden' name="wdesk:PBODateTime" id="wdesk:PBODateTime" />
<input type='hidden' name="wdesk:mw_errordesc" id="wdesk:mw_errordesc" value='' />
<table><tr><td><input type='hidden' name="wdesk:Decision" id="wdesk:Decision" />
<input type='hidden' name="wdesk:IsSTP" id="wdesk:IsSTP" value=''/>
<input type='hidden' name="wdesk:IsError" id="wdesk:IsError" value=''/>
<input type='hidden' name="IsSavedFlag" id="IsSavedFlag" value=''/>
<input type='hidden' name="IsCSURefreshClicked" id="IsCSURefreshClicked" value=''/>
<input type='hidden' name="wdesk:Current_Workstep" id="wdesk:Current_Workstep" value='Not Introduced'/>
<input type='hidden' name="wdesk:encryptedkeyid" id="wdesk:encryptedkeyid" value=''/>
<input type='hidden' name="wdesk:CCI_CName" id="wdesk:CCI_CName" value=''/>
</td></tr></table>

</form>

    </body>
</f:view>
</html>