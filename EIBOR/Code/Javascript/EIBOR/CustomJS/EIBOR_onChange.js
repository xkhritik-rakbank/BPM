
function customCellLiborGrid(rowIndex,colIndex,ref,controlId){
	var callLog = 0;
	var noOfDays = 0;
	var aed =0;
	var row = parseInt(rowIndex);
	var stringCalLog =0;
	var sofr = 0;
	var count =0;
	
	if(colIndex=="1" && controlId=="NG_EIBOR_GRID_BB_LIBOR_FW_RATES"){
		sofr = parseFloat(ref.value);
		if(isNaN(sofr)){
			sofr = 0;
		}
		
		var bbAsk = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,2));
		if(isNaN(bbAsk)){
			bbAsk = 0;
		}
		callLog = bbAsk/10000;
		
		noOfDays = parseInt(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,4));
		if(!isNaN(noOfDays)){
			count =1;
		}
		
	}
	if(colIndex=="2" && controlId=="NG_EIBOR_GRID_BB_LIBOR_FW_RATES"){
		callLog = parseFloat(ref.value)/10000;
		if(isNaN(callLog)){
			callLog = 0;
		}
		
		sofr = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,1));
		if(isNaN(sofr)){
			sofr = 0;
		}
		noOfDays = parseInt(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,4));
		if(!isNaN(noOfDays)){
			count =1;
		}		
	}
	
	if(colIndex=="4" && controlId=="NG_EIBOR_GRID_BB_LIBOR_FW_RATES"){
		
		noOfDays = parseInt(ref.value);
		if(isNaN(noOfDays)){
			noOfDays = 0;
		}
		sofr = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,1));
		if(isNaN(sofr)){
			sofr = 0;
		}
		var bbAskk = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,2));
		if(isNaN(bbAskk)){
			bbAskk = 0;
		}
		callLog = bbAskk/10000;
		count =1;
	}
	
	stringCalLog = callLog.toFixed(6);
	var tenor = 0;
	var finalCal=0;
	
	var dataOfCUAEB =0;
	var total =0;
	var fivedayAvg=0;
	var cal = 0;
	var finalValue = 0;

	if(count ==0){
		const date = new Date();
		const day = parseInt(date.getDay());
		if(row==0){
			noOfDays = 1;
			if(day==5){
				noOfDays = 3;
			}
			
		}
		else if(row==1){
			noOfDays = 7;
				
		}else if(row==2){
			noOfDays = 30;
				
		}else if(row==3){
			noOfDays = 91;
				
		}
		else if(row==4){
			noOfDays = 182;
		}
		else if(row==5){
			noOfDays = 360;
		}
	}
	
	
	var stringNoOfDays = String(noOfDays);
	finalCal = parseFloat(callLog/3.673);
		
	cal  = finalCal*360;
	finalValue = cal/noOfDays;
	aed = finalValue*100;
	var stringAED = aed.toFixed(6);
		
		

		
	for (i=0;i<5;i++){
		dataOfCUAEB =0;
		dataOfCUAEB = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_CBUAE_RATES",i,row+1));
		if(isNaN(dataOfCUAEB)){
		dataOfCUAEB = 0;
		}	
			
		total = dataOfCUAEB+total;
	}
	fivedayAvg = (total/5).toFixed(6);
	var fivedayAvgg = String(fivedayAvg);	
	setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,7,fivedayAvgg,true);
	setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,3,stringCalLog,true);
	setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,4,stringNoOfDays,true);
	setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,5,stringAED,true);
	var eibor = sofr+aed;
	var eiborRate = eibor.toFixed(6);
	setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,6,eiborRate,true);	
	
}



/*function customCellLiborGrid(rowIndex,colIndex,ref,controlId){
	var callLog = 0;
	var noOfDays = 0;
	var aed =0;
	colIndex = parseInt(colIndex);
	
	if(controlId=="NG_EIBOR_GRID_BB_LIBOR_FW_RATES"){
		if(colIndex ==1){
			var sofr = parseFloat(ref.value);
		}
		if(colIndex==2){
			var valueAed = parseFloat(ref.value);
		}
		
		if(isNaN(sofr)){
			sofr = 0;
		}
		
		if(isNaN(valueAed)){
			valueAed = 0;
		}
		callLog = valueAed/10000;
		var stringCalLog = callLog.toFixed(6);
		var row = parseInt(rowIndex);
		var tenor = 0;
		var finalCal=0;
	
		var dataOfCUAEB =0;
		var total =0;
		var fivedayAvg=0;
		var cal = 0;
		var finalValue = 0;

		const date = new Date();
		const day = parseInt(date.getDay());
		if(row==0){
			noOfDays = 1;
			if(day==5){
				noOfDays = 3;
			}
		
		}
		else if(row==1){
			noOfDays = 7;
			
		}else if(row==2){
			noOfDays = 30;
			
		}else if(row==3){
			noOfDays = 91;
			
		}
		else if(row==4){
			noOfDays = 182;
		}
		else if(row==5){
			noOfDays = 360;
		}
		var stringNoOfDays = String(noOfDays);
		finalCal = parseFloat(callLog/3.673);
		
		cal  = finalCal*360;
		finalValue = cal/noOfDays;
		aed = finalValue*100;
		var stringAED = aed.toFixed(6);
		
		
		
		

		
		for (i=0;i<5;i++){
			dataOfCUAEB =0;
			dataOfCUAEB = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_CBUAE_RATES",i,row+1));
			if(isNaN(dataOfCUAEB)){
			dataOfCUAEB = 0;
			}	
			
			total = dataOfCUAEB+total;
		}
		fivedayAvg = (total/5).toFixed(6);
		var fivedayAvgg = String(fivedayAvg);	
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,7,fivedayAvgg,true);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,3,stringCalLog,true);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,4,stringNoOfDays,true);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,5,stringAED,true);
		var eibor = sofr+aed;
		var eiborRate = eibor.toFixed(6);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",row,6,eiborRate,true);
	}
	
	
}*/




function cellCbuaeGrid(rowIndex,colIndex,ref,controlId){
	colIndex = parseInt(colIndex);
	if(colIndex==0){
		return;
	}
	
	var total = 0;
	if(controlId=="NG_EIBOR_GRID_CBUAE_RATES"){
		var cbuaeValue =parseFloat(ref.value);
		if(isNaN(cbuaeValue)){
			cbuaeValue =0;
		}
		for(m=0;m<4;m++){
			var rowValues = parseFloat(getValueFromTableCell("NG_EIBOR_GRID_CBUAE_RATES",m,colIndex));
			total = total + rowValues;
		}
		var final = ((total + cbuaeValue)/5).toFixed(6);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",colIndex-1,7,final,true);

	}


}

function cellRepoChange(rowIndex,colIndex,ref,controlId){
	colIndex = parseInt(colIndex);
	rowIndex = parseInt(rowIndex);
	
	
	if(controlId=="NG_EIBOR_GRID_DF3" && colIndex==3){
		var repoValue = parseFloat(ref.value);
		if(isNaN(repoValue)){
			repoValue =0;
			
		}
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",rowIndex,5,repoValue,true);
		
		
	}


}


function toBeRepotedChange(rowIndex,colIndex,ref,controlId){
		
	if(controlId=="NG_EIBOR_GRID_MM" || controlId=="NG_EIBOR_GRID_DF2_DEALS"){
		var reportedValue = ref.value; 
		var control = controlId;
		var response=executeServerEvent('tobeReported','change',control,true).trim();
				
		
		
		if(response==""){
			var i=0;
			for(i =0;i<6;i++){
				var histIB = "";
				histIB = getValueFromTableCell("NG_EIBOR_GRID_History_IB_DATA",i,1);		
				setTableCellData("NG_EIBOR_GRID_DF3",i,1,histIB,true);
				setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,3,histIB,true);
					
				var custIB = "";
				custIB = getValueFromTableCell("NG_EIBOR_GRID_History_CUST_DATA",i,1);			
				setTableCellData("NG_EIBOR_GRID_DF3",i,2,custIB,true);
				setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,4,custIB,true);
				
				var df1 = "";
				df1 = getValueFromTableCell("NG_EIBOR_GRID_DF1",i,1);						
				setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,1,df1,true);
				
				var df2 = "";
				df2 = getValueFromTableCell("NG_EIBOR_GRID_DF2",i,1);						
				setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,2,df2,true);
				
				var on = "";
		
				for(j =1;j<8;j++){
					on = getValueFromTableCell("NG_EIBOR_GRID_FINAL_SUMMARY",i,j);
					if(on=="0" || on=="undefined" || j==5  || on=="")
					{
						
					}
					else{
						setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,8,on,true);
						if(j==1){
							setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,9,"DF1",true);	
							setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"DF1",true);
						}
						else if(j==2){
							setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,9,"DF2",true);
							setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"DF2",true);
						}
						else{
							setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,9,"DF3",true);
							if(j==3){
								setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"History IB Data",true);
							}
							else if(j==4){
								setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"History Cust Data",true);
							}
							else if(j==6){
								setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Observable third party transaction",true);
							}
							else{
								setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Broker Rates",true);
							}
						
						}
						
						break;
					}
				}
			}						
		}
		setColorRow();
	}
}

