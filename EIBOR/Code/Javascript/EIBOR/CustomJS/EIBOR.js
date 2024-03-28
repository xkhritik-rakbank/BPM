var EIBOR_Common = document.createElement('script');
EIBOR_Common.src = '/EIBOR/EIBOR/CustomJS/EIBOR_Common.js';
document.head.appendChild(EIBOR_Common);

var EIBOR_onLoad = document.createElement('script');
EIBOR_onLoad.src = '/EIBOR/EIBOR/CustomJS/EIBOR_onLoad.js';
document.head.appendChild(EIBOR_onLoad);
	
var EIBOR_onSaveDone = document.createElement('script');
EIBOR_onSaveDone.src = '/EIBOR/EIBOR/CustomJS/EIBOR_onSaveDone.js';
document.head.appendChild(EIBOR_onSaveDone);
	
var EIBOR_mandatory = document.createElement('script');
EIBOR_mandatory.src = '/EIBOR/EIBOR/CustomJS/EIBOR_MandatoryFieldValidations.js';
document.head.appendChild(EIBOR_mandatory);

var EIBOR_click = document.createElement('script');
EIBOR_click.src = '/EIBOR/EIBOR/CustomJS/EIBOR_click.js';
document.head.appendChild(EIBOR_click);

var EIBOR_onChange = document.createElement('script');
EIBOR_onChange.src = '/EIBOR/EIBOR/CustomJS/EIBOR_onChange.js';
document.head.appendChild(EIBOR_onChange);


function setCommonVariables()
{
	
	user= getWorkItemData("username");


	setValue("Username",user);	
	
	
	
	
	//setControlValue("Username",user);
	viewMode=window.parent.wiViewMode;
	
}

function afterFormload()
{
	setCommonVariables();
	var response = executeServerEvent("afterformload","FORMLOAD",rowCount,true);
	
	validationCBUAEGrid();
	setGridDF3();
	setGridEiborSummary();
	repetetiveVisible();
	setColorRow();
	setBBFwdRates();
	columnEnable();
	
}
function columnEnable(){
	
	var ActivityName =getWorkItemData("ActivityName");
	
	if(ActivityName=='Initiation' || ActivityName=='OPS_Maker' || ActivityName=='OPS_Checker'){
		setColumnDisable("NG_EIBOR_GRID_MM",11,"false",true);
	
		setColumnDisable("NG_EIBOR_GRID_DF2_DEALS",10,"false",true);
	
		setColumnDisable("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",1,"false",true);
		setColumnDisable("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",2,"false",true);
		setColumnDisable("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",4,"false",true);
	
		setColumnDisable("NG_EIBOR_GRID_DF3",4,"false",true);
		setColumnDisable("NG_EIBOR_GRID_DF3",3,"false",true);
		setRowStyle("NG_EIBOR_GRID_CBUAE_RATES",4,"disable","false");
	}

}

function setColorRow(){
	var rowCount = getGridRowCount("NG_EIBOR_GRID_MM");
	var rowCountDF2 = getGridRowCount("NG_EIBOR_GRID_DF2_DEALS");
	
	for(i=0;i<rowCount;i++){
		var toBeReported = getValueFromTableCell("NG_EIBOR_GRID_MM",i,11);
		if(toBeReported=="Yes"){
			var dueDate = getValueFromTableCell("NG_EIBOR_GRID_MM",i,5);
			var depoDateTime = getValueFromTableCell("NG_EIBOR_GRID_MM",i,1);
			let dateTime = new Date(depoDateTime);
			
			let todayDateTime = new Date();
			todayDateTime.setHours(11,0,0,0);
			
			var yesterdayDate = new Date();
			yesterdayDate.setDate(yesterdayDate.getDate()-1);
			if(yesterdayDate.getDay()==0){
				yesterdayDate.setDate(yesterdayDate.getDate()-1);
			}
			var dd = String(yesterdayDate.getDate()).padStart(2,'0');
			var mm = String(yesterdayDate.getMonth() + 1).padStart(2,'0');
			var yyyy = String(yesterdayDate.getFullYear());
	
			var today = yyyy + '-' + mm + '-' + dd;
			
			yesterdayDate.setHours(11,0,0,0);
			
			if(dueDate==today){
				setRowColorInListView("NG_EIBOR_GRID_MM",i,"add8e6");
			}
			else{
				setRowColorInListView("NG_EIBOR_GRID_MM",i,"ffd6d7");
			}
			if((dateTime < todayDateTime) && (dateTime > yesterdayDate))
			{
				setRowColorInListView("NG_EIBOR_GRID_MM",i,"add8e6");
			}
			else{
				setRowColorInListView("NG_EIBOR_GRID_MM",i,"ffd6d7");
			}
			
		}
		else{
			setRowColorInListView("NG_EIBOR_GRID_MM",i,"ffffff");
		}
	}
	
	
	for(j=0;j<rowCountDF2;j++){
		var toBeReporteddf2 = getValueFromTableCell("NG_EIBOR_GRID_DF2_DEALS",j,10);
		if(toBeReporteddf2=="Yes"){
			var dueDateDF2 = getValueFromTableCell("NG_EIBOR_GRID_DF2_DEALS",j,2);
			
			var yesterdayDatee = new Date();
			yesterdayDatee.setDate(yesterdayDatee.getDate()-1);
			if(yesterdayDatee.getDay()==0){
				yesterdayDatee.setDate(yesterdayDatee.getDate()-1);
			}
			var dd = String(yesterdayDatee.getDate()).padStart(2,'0');
			var mm = String(yesterdayDatee.getMonth() + 1).padStart(2,'0');
			var yyyy = String(yesterdayDatee.getFullYear());
	
			var todaydf2 = yyyy + '-' + mm + '-' + dd;
			if(dueDateDF2==todaydf2){
				setRowColorInListView("NG_EIBOR_GRID_DF2_DEALS",j,"add8e6");
			}
			else{
				setRowColorInListView("NG_EIBOR_GRID_DF2_DEALS",j,"ffd6d7");
			}
			
		}
		else{
			setRowColorInListView("NG_EIBOR_GRID_DF2_DEALS",j,"ffffff");
		}
	}
}


function repetetiveVisible(){
	if(ActivityName!='Initiation'){
		var i = 0;
		var repetitve =["NG_EIBOR_GRID_DF1_REPETETIVE","NG_EIBOR_GRID_DF1_REPETETIVE_OW","NG_EIBOR_GRID_DF1_REPETETIVE_OM","NG_EIBOR_GRID_DF1_REPETETIVE_TM","NG_EIBOR_GRID_DF1_REPETETIVE_SM","NG_EIBOR_GRID_DF1_REPETETIVE_OY","NG_EIBOR_GRID_DF2_REPETETIVE","NG_EIBOR_GRID_DF2_REPETETIVE_OW","NG_EIBOR_GRID_DF2_REPETETIVE_OM","NG_EIBOR_GRID_DF2_REPETETIVE_TM","NG_EIBOR_GRID_DF2_REPETETIVE_SM","NG_EIBOR_GRID_DF2_REPETETIVE_OY","Q_NG_EIBOR_GRID_HIST_IB_ON","Q_NG_EIBOR_GRID_HIST_IB_OW","Q_NG_EIBOR_GRID_HIST_IB_OM","Q_NG_EIBOR_GRID_HIST_IB_TM","Q_NG_EIBOR_GRID_HIST_IB_SM","Q_NG_EIBOR_GRID_HIST_IB_OY","Q_NG_EIBOR_GRID_HIST_CUST_ON","Q_NG_EIBOR_GRID_HIST_CUST_OW","Q_NG_EIBOR_GRID_HIST_CUST_OM","Q_NG_EIBOR_GRID_HIST_CUST_TM","Q_NG_EIBOR_GRID_HIST_CUST_SM","Q_NG_EIBOR_GRID_HIST_CUST_OY"];
		for(i=0;i<24;i++){
			
			var row = getGridRowCount(repetitve[i]);
			if(row>0){
				setStyle(repetitve[i],"visible","true");
			}
		}
		
	}
}

function validationCBUAEGrid(){
	
	var today = new Date();
	today.setDate(today.getDate()-1);
	if(today.getDay()==0){
		today.setDate(today.getDate()-2);
	}
	
	var dd = String(today.getDate()).padStart(2,'0');
	var mm = String(today.getMonth() + 1).padStart(2,'0');
	var yyyy = String(today.getFullYear());
	
	today = dd + '/' + mm + '/' + yyyy;
	
	var rowCount = 0;
	rowCount = getGridRowCount("NG_EIBOR_GRID_CBUAE_RATES");
	if(rowCount==4){
		addBlankRowToTable("NG_EIBOR_GRID_CBUAE_RATES");
		setTableCellData("NG_EIBOR_GRID_CBUAE_RATES",4,0,today,true);
		
	}
		

}


function customValidationsBeforeSaveDone(op)
{
	if(op=="S")
	{
		if(saveClickOperation()==false)
		{
			return false;
		}
		return true;
	}
	else if (op=="I" || op=="D"){	
			
		var Activity =getWorkItemData("ActivityName");
		if(Activity=="Front_Desk_Checker"){
			var res = email();
		}
			
		var status = insertIntoHistoryTable();
		saveWorkItem();
		return true;
				
		
	}
	else
	{
		return false;
	}

}

function customAddRowPostHook(tableId){
	if(tableId=='individualtesttable'){
		var dedupeCall=executeServerEvent('testsave','click','',true).trim(); 
	}
	 
}



function eventDispatched(controlObj,eventObj)
{
	var controlId=controlObj.id;
	var controlEvent=eventObj.type;
	var ControlIdandEvent = controlId+'_'+controlEvent;

	switch(ControlIdandEvent)
	{
		case 'testsave_click' : 
		var SNo = getValueFromTableCell("individualtesttable",1,0);
		//var SNo = getValueFromTableCell("ng_EIBOR_gr_testSave",1,0);
		var dedupeCall=executeServerEvent('testsave','click','',true).trim(); 
		saveWorkItem();
		refreshFrame("IndividualFrame");
		break;	
		
	}
}
	
function customTableCellChange(rowIndex,colIndex,ref,controlId){
	
	if(controlId =="NG_EIBOR_GRID_BB_LIBOR_FW_RATES"){
		customCellLiborGrid(rowIndex,colIndex,ref,controlId);
	}
	if(controlId =="NG_EIBOR_GRID_CBUAE_RATES"){
		cellCbuaeGrid(rowIndex,colIndex,ref,controlId);
	}
	if(controlId =="NG_EIBOR_GRID_DF3"){
		cellRepoChange(rowIndex,colIndex,ref,controlId);
	}

	if(controlId =="NG_EIBOR_GRID_MM"){
		toBeRepotedChange(rowIndex,colIndex,ref,controlId);
	}
	if(controlId =="NG_EIBOR_GRID_DF2_DEALS"){
		toBeRepotedChange(rowIndex,colIndex,ref,controlId);
	}
	
	

}


function bbLiborGridAverage(){
	setAvg();
}




function setGridDF3(){
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
				
		var repo = "0";				
		setTableCellData("NG_EIBOR_GRID_DF3",i,3,repo,true);	
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,5,repo,true);
				
		var bbSource = "";
		bbSource = getValueFromTableCell("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,8);	
		setTableCellData("NG_EIBOR_GRID_DF3",i,4,bbSource,true);
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,6,bbSource,true);
		
		
				
		var thirdParty = "";
		thirdParty = getValueFromTableCell("NG_EIBOR_GRID_THIRD_PARTY_QUOTES",i,3);		
		if(thirdParty==undefined){
			setTableCellData("NG_EIBOR_GRID_DF3",i,5,'0',true);
			setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,7,'0',true);
		}
		else{
			setTableCellData("NG_EIBOR_GRID_DF3",i,5,thirdParty,true);
			setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,7,thirdParty,true);
		}
		
	}
}

function setBBFwdRates(){
	var tenor = ["O/N SOFR","Donia 1W","TRMSOFR 1M","TRMSOFR 3M","TRMSOFR 6M","TRMSOFR 12M"]
	for(i=0;i<6;i++){
		setTableCellData("NG_EIBOR_GRID_BB_LIBOR_FW_RATES",i,0,tenor[i],true);
	}
}

function setGridEiborSummary(){
	var i=0;
	var eiborDate = getValue("CreatedAt").substring(0,10);
	setValues({"EiborSumarryDate":eiborDate},"true");
	for(i =0;i<6;i++){
		var dF1 = "";
		dF1 = getValueFromTableCell("NG_EIBOR_GRID_DF1",i,1);		
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,1,dF1,true);
				
		var dF2 = "";
		dF2 = getValueFromTableCell("NG_EIBOR_GRID_DF2",i,1);			
		setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,2,dF2,true);
		
		
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
						setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Hist IB Data",true);
					}
					else if(j==4){
						setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Hist Cust Data",true);
					}
					else if(j==6){
						setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Observable third party transactions",true);
					}
					else{
						setTableCellData("NG_EIBOR_GRID_FINAL_SUMMARY",i,10,"Broker rates",true);
					}
				
				}
				
				break;
			}
			
		}
		
		
				
	}
					
}
	
/*function duplicate(){
	var rowCount = getGridRowCount("NG_EIBOR_GRID_DF2_DEALS");
	const list = [];
	for(int i=0;i<rowCount;i++){		
		String counterParty = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 0);
		String accountNo = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 5);
		String sourceName = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", i, 10);
		for(int j=1;j<row;j++){
			String cptyCode = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 0);
			String acc = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 5);
			String source = ifr.getTableCellValue("NG_EIBOR_GRID_DF2_DEALS", j, 10);
			
			if(counterParty.equalsIgnoreCase(cptyCode) && accountNo.equalsIgnoreCase(acc)){
				if(sourceName.contains("DF2") && source.contains("Finacle")){
					list.add(i);
				}
				else if(sourceName.contains("Finacle")&&source.contains("DF2")){
					list.add(j);
				}
			}
		}
	}
}*/
