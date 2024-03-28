
function saveClickOperation()
{
	
}

function insertIntoHistoryTable()
{	
	var historyTableInsert=executeServerEvent('InsertIntoHistory','introducedone','',true).trim(); 
	return historyTableInsert;
}


function email(){
	var Activity =getWorkItemData("ActivityName");
	if(Activity=="Front_Desk_Checker"){
		var decision = getValue("Decision");
		if(decision=="Submit"){
			var response=executeServerEvent('email','introducedone','',true).trim();
			return response;
		}
	}
	
}
