//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation  6        
//File Name					 : RMTIntegrate.js       
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 22-Jan-2018
//Description                : Dedupe and Blacklist integration 
//---------------------------------------------------------------------------------------------------->
function calculateRiskScore(currWorkstep)
	{
		if(currWorkstep!='Introduction'|| currWorkstep!='Attach_Cust_Doc'){
		
			var xhr;			
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			var url = "/RMT/CustomForms/RMT_Specific/RiskScore.jsp";
			xhr.open("GET", url, false);
			xhr.send(null);
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				if (ajaxResult=='-1') 
				{
					alert("Error in fetching risk score value.");
					return false;
				}
				document.getElementById("wdesk:RISKSCORE").value =ajaxResult;				
			} 
			else 
			{
				alert("Problem in getting Risk Score Value.");
				return false;
			}
		}
	}

function DedupeCheck(user_name,wi_name)
	{
			//var user_name = '<%=customSession.getUserName()%>';
			var xhr;
			var request_type="DEDUP_SUMMARY";
			var CIF_ID=document.getElementById("custcifid").value;
			var custfirstname=document.getElementById("custfirstname").value;
			//var custmiddlename=document.getElementById("custmiddlename").value;
			var custlastname=document.getElementById("custlastname").value;
			var custnationality=document.getElementById("custnationality").value;
			var custdob=document.getElementById("custdob").value;
			var EID=document.getElementById("existcardno").value;	
			var Phone1=document.getElementById("contactmobile1").value;
			//var wi_name = '<%=WINAME%>';
			var gender = document.getElementById("custgender").value;
			var flatno = document.getElementById("res_flatvilla").value;
			var buildingno = document.getElementById("res_building").value;
			var streetno = document.getElementById("res_street").value;
			var landmark = document.getElementById("res_landmark").value;
			var city = document.getElementById("res_city").value;
			var res_zipcode = document.getElementById("res_zipcode").value;
			var res_pobox = document.getElementById("res_pobox").value;
			
			if(CIF_ID=="")
			{
				alert("Please enter CIF ID");
				document.getElementById("custcifid").focus();
				return false;
			}
			if(custfirstname=="")
			{
				alert("Please enter first name");
				document.getElementById("custfirstname").focus();
				return false;
			}
			if(custlastname=="")
			{
				alert("Please enter last name");
				document.getElementById("custlastname").focus();
				return false;
			}
			if(custnationality=="")
			{
				alert("Please enter Nationality");
				document.getElementById("custnationality").focus();
				return false;
			}
			if(custdob=="")
			{
				alert("Please enter Date Of Birth");
				document.getElementById("custdob").focus();
				return false;
			}
			if(gender=="")
			{
				alert("Please enter Gender");
				document.getElementById("gender").focus();
				return false;
			}
			
			var Dedupehidden=CIF_ID+"~"+custfirstname+"~"+custlastname+"~"+custnationality+"~"+custdob+"~"+gender;
			
			
			if(document.getElementById('wdesk:DEDUPE_VALUES').value=='' || document.getElementById('wdesk:DEDUPE_VALUES').value!=Dedupehidden)	
			{			
				
				openCustomDialogbox('Dedupe Check',wi_name,request_type);				
			}
			else
			{
				alert("Dedupe Check is already performed.");
			}
			 
	}	
	
	


/*function getcustMapFields(applicanyType)
{
	var arrayValues=['custcifid','applicanttype','custfirstname','custmiddlename','custlastname','custempstatus'];
	var table =document.getElementById("CustDetailsGrid");
	var rowCount = table.rows.length;
	var param;
	if(rowCount>1)//When no row added in grid
	{
		for (var i = 1; i < rowCount; i++) 
		{
			var currentrow = table.rows[i];
			if(currentrow.cells[1].innerHTML==applicanyType)
			{
				for(var k=0;k<arrayValues.length;k++)
				{
					if(param='')
					 param="'"+arrayValues[k]+"'="+document.getElementById(arrayValues[k]+i).innerHTML;
					else
					param=param+"&"+"'"+arrayValues[k]+"'="+document.getElementById(arrayValues[k]+i).innerHTML;		
				}
			}
		}
	}
	return param;
}*/
// function used to encode64 from chars- used for EIDA Photo added on 271202017 by Angad
function encode64(input) {

    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    //remove null characters from end of output
    input = input.replace(/\0*$/g, '');

    var output = "";
    var chr1, chr2, chr3 = "";
   var enc1, enc2, enc3, enc4 = "";
    var i = 0;

    do {
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }

        output = output +
            keyStr.charAt(enc1) +
            keyStr.charAt(enc2) +
            keyStr.charAt(enc3) +
            keyStr.charAt(enc4);
        chr1 = chr2 = chr3 = "";
        enc1 = enc2 = enc3 = enc4 = "";
    } while (i < input.length);

    var strout = ""
    output = output.split('');
    for(var c=0; c<output.length; c++) {
        if(c % 64 == 0 && c > 0) strout += '\n';
        strout += output[c];
    }
    output = output.join();

    var nulls = strout % 4;
    for(var i=0; i<nulls; i++)
        strout += '=';

    return strout;
}

// below function is used to convert HexaDecimal value to character - used to convert EIDA Photo added on 271202017 by Angad
function chars_from_hex(inputstr, delimiter) {
      var outputstr = '';
      inputstr = inputstr.replace(/^(0x)?/g, '');
      inputstr = inputstr.replace(/[^A-Fa-f0-9]/g, '');
      inputstr = inputstr.split('');
      for(var i=0; i<inputstr.length; i+=2) {
            outputstr += String.fromCharCode(parseInt(inputstr[i]+''+inputstr[i+1], 16));
      }
      return outputstr;
}
