function customSaveDoneChangesOnListView(controlId){
	if(controlId=='individualtesttable'){
		//var dedupeCall=executeServerEvent('testsave','click','',true).trim(); 
		return true;
	}
	return true;
}

function setAvg(){
	var j =0;
	for(i=0;i<6;i++)
	{
		
		var eibor = getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,6);
		var fiveDayAvg = getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,7);
		if(eibor==""){
			eibor=0;
		}
		if(fiveDayAvg==""){
			fiveDayAvg=0;
		}
		var total = parseFloat(eibor)+parseFloat(fiveDayAvg);
		var avg = total/2;
		var average = avg.toFixed(5);
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,8,average,true);
		
		var df3BbRate = getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,8);
		setTableCellData("NG_EIBOR_GRID_DF3",i,4,df3BbRate,true);
		
		var newRate = getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,8);
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",j,6,newRate,true);
		j++;
	}
	setGridEiborSummary();
	
	
	
}