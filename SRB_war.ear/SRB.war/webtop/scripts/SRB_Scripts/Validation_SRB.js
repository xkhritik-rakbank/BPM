/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- SRM
Application                                                      				: Service Request Module 
Module                                                            				: Custom Validations 
File Name                                                       				: Custom_Validations.js		 	
Author                                                             				: Deepti Sharma, Aishwarya Gupta	 
Date (DD/MM/YYYY)                         										: 20-Apr-2014
Description                                                      				: This file contains all generic validation functions
																				  required for every service request
-------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------
Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/
function Validate(NameData,iframeDocument,IsDoneClicked)
{
	if(IsDoneClicked)
	{
		NameData=NameData.substring(0,(NameData.lastIndexOf("~")));
		//alert("NameData :"+NameData);
		var arr=NameData.split('~');
		for(var i = 0; i < arr.length; i++)
		{
			var temp=arr[i].split('#');
			var id=temp[0];
			var pattern=temp[1];
			var isMandatory=temp[2];
			var labelName=temp[3];
			var isRepeatable=temp[5];
			var type=temp[8];
			if(isRepeatable!='Y') //changed on 30june14
			{
				if(isMandatory=='Y')
				{	
					if(!ValidateMandatory(id,labelName,iframeDocument,type))
					return false;
				}
				if(pattern=='Numeric')
				{
					if(!ValidateNumeric(id,labelName,iframeDocument))
					return false;
				}
			}
		}
	}
	return true;
	
}
/*function validateGrid()
{
		var refTab = document.getElementById("ddReferences")
		if(refTab.rows.length==0)
		{
			alert("Please add rows in grid.");
			return false;
		}
		else
		{
					for (var i = 0; i < refTab.rows.length; i++) {
					var rowFst = refTab.rows.item(i);
					for (var j = 0; j < rowFst.cells.length; j++) {
						if (j == 0) {
							var colFstmatch = rowFst.cells.item(j);
							for (var k = 0; k < refTab.rows.length; k++) {
								if (i == k)
									continue;
								var rowSnd = refTab.rows.item(k);
								for (var l = 0; l < rowSnd.cells.length; l++) {
									if (l == 0) {
										var colSndmatch = row.cells.item(l);
										if (colFstmatch.firstChild.innerText == colSndmatch.firstChild.innerText) {
											alert("Duplicate Found");
											return false;
										}
									} else
										break;
								}
							}
						}
					}
				}
		}
		return true;
}*/
function ValidateMandatory(id,labelName,iframeDocument,type)
{
	 // alert("id :"+id);
	 // alert("labelName:"+labelName);
	 // alert("type:"+type);
	if(type=='')
	{	
		var value=iframeDocument.getElementById(id).value;
		if(value=="")
		{
			alert("Please enter "+labelName);
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else 
			return true;
	}
	else if(type=="select")
	{	
		var element = iframeDocument.getElementById(id);
		
		var selectedValue = element.options[element.selectedIndex].value;
		
		if(selectedValue=='--Select--' && customform.document.getElementById("selectDecision").value!='Reject') //decision condition added by shamily to not pop up alert when decision reject
		{
			alert("Please select "+labelName);
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else 
			return true;
		
	}
	else if(type=='radio')
	{
		//alert("in radio");
		var ele = iframeDocument.getElementsByName(id);
		var eleID;
		var flag=0;
		for(var i = 0; i < ele.length; i++)
		{	
			if(ele[i].checked)
			{	
				flag=1;
			}
		}
		if(flag==0)
		{
			alert("Please select "+id.substring(2).replace('_',' ')+".");
			return false;
		}
		else
		 return true;
	
	}
	else if(type=='checkbox')
	{
		if (!iframeDocument.getElementById(id).checked)
		{
			alert("Please select "+labelName+" checkbox."); //final by Manish Grover
			iframeDocument.getElementById(id).focus();
			return false;
		}
		else
		 return true;
	}
	else
	{
		alert("No match.");
		return false;
	}
}

function ValidateNumeric(id,labelName,iframeDocument)
{
	var inputtxt=iframeDocument.getElementById(id);
	var numbers = /^[0-9]+$/; 
	if(inputtxt.value.match(numbers)) 
	return true; 
	else 
	{ 
		alert('Please input numeric characters only in '+labelName+".");
		iframeDocument.getElementById(id).value="";
		iframeDocument.getElementById(id).focus();
		return false; 
	} 

}

function ValidateGrid(iframeDocument,arrGridBundle,IsDoneClicked)
{
	
	
	
	
	if(IsDoneClicked)
	{
		//Code checks fields mandatory in formLayout table........
		var arrGridRow = arrGridBundle.split("$$$$");
		
		for (y=0;y<arrGridRow.length;y++)
		{
		
			var arrElementData=arrGridRow[y].split(',');
			var namedata="";
			var counter = y+1;
			var strStNdThAppend = '';
					if(counter>4 && counter<20){
					strStNdThAppend = 'th';
					}else
					if(counter%10==1){
						strStNdThAppend = 'st';
					}else
					if(counter%10==2){
						strStNdThAppend = 'nd';
					}else
					if(counter%10==3){
						strStNdThAppend = 'rd';
					}else				
					if(counter%10>3){
						strStNdThAppend = 'th';
					}					
			for (z=0;z<arrElementData.length;z++)
			{
				var strElementName=arrElementData[z].substring(0,arrElementData[z].indexOf(":"));
				var strElementColumnValue=arrElementData[z].substring(arrElementData[z].indexOf(":")+1);
				var temp=strElementName.split('#');
				var pattern=temp[0];
				var isMandatory=temp[1];
				var labelName=temp[2];
				if(isMandatory=='Y')
				{
					var temp1=strElementColumnValue.split('#');
					var columnName=temp1[0];
					var columnValue=temp1[1];
					if(columnValue=='' || columnValue=='--Select--' || columnValue=='blank'){
						alert(labelName+" is mandatory.\nPlease enter "+labelName+" in "+counter+strStNdThAppend+" row of grid.");
						return false; 
					}
				}
			}
		
		}
		//End Code checks fields mandatory in formLayout table........
		
	}
	return true;
}