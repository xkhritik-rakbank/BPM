/*
		Product         :       OmniFlow 7.0
		Application     :       OmniFlow Web Desktop
		Module          :       
		File            :       validation.js
		Purpose         :       Contains the general functions used in the project.

		Change History  :

		Problem No        Correction Date		Comments
    		-----------       ----------------      ----------
                3219            25/Jan/2008             range(15,2) validation in Float variable
*/

function IsFloatVal(val)
{
	var len = val.length;
	for(var i=0; i<=(len - 1);i++)
		if(val.charAt(i)==".")
			return 1;
	return 0;
}


function IsNumericVal(val)
{
	if (isNaN(val) || IsFloatVal(val))
		return 0;
	return 1;
}


function IntValidate(num)
{
	var val = num;
	if(val == "")
	{
		return (0);
	}
	if(!IsNumericVal(val))
	{
		return (-2);
	}
	if (val<-32768 || val>32767)
	{
		return (-3);
	}
	return (1);
}


function isString(text, len)
{
	
	//alert("text :"+text);
	var val = text;
	//Added by Amandeep for NTEXT
	if(len==-1)	return "false";
				
	if(val.length > len)
	{
		//alert("text"+text);
		//alert("len"+len);
		return (INVALID_STRING_LENGTH);
	}
    /*
	if(  (val.indexOf('<') != -1) || (val.indexOf('>') != -1) )
		return (INVALID_STRING_CHAR);
    */
	return "false";
}

function isInteger (s)
{   
	var i=0;
   if(s=='-')
	  return INVALID_NUMBER;

    if(s.charAt(0)=='-')
		i=1;

	for (; i < s.length; i++)
    {   
        var c = s.charAt(i);
        if (!isDigit(c)) 
			return INVALID_NUMBER;
    }

	if (s<-32768 || s>32767)
		return INVALID_NUMBER_RANGE;

    return "false";
}


function isLong (s)
{   
	var i=0;

    if(s.charAt(0)=='-')
		i=1;

    for (;i < s.length; i++)
    {   
        var c = s.charAt(i);
        if (!isDigit(c)) 
			return INVALID_LONG;
    }
	if (s<-2147483648 || s>2147483648 )
		return INVALID_LONG_RANGE;

    return "false";
}


function isDigit (c)
{   
	return ((c >= "0") && (c <= "9"))
}


function isFloat (s)
{   
    var i=0;
    var seenDecimalPoint = false;
    var decimalPointDelimiter = "."

    if (s == decimalPointDelimiter) 
		return INVALID_FLOAT_NUMBER;

    if(s.charAt(0)=='-')
		i=1;
    var cnt = 0;            
    for (; i < s.length; i++)
    {   var c = s.charAt(i);
        cnt++;        
        if(cnt == 14 && c != decimalPointDelimiter){
            if(!seenDecimalPoint)
                return INVALID_FLOAT_RANGE; 
        }
        if ((c == decimalPointDelimiter) && !seenDecimalPoint) 
	{
		seenDecimalPoint = true;
	}
        else if (!isDigit(c)) 
		return INVALID_FLOAT_NUMBER;
    }
    return "false";
}


function isDate (intYear, intMonth, intDay)
{   
   if (!(isInteger(intDay) == false) && (isInteger(intMonth)==false)  && (isInteger(intYear) == false)) 
		return  INVALID_DATE;
		
	//validate year
	if(year<1753)
		return INVALID_DATE_YEAR;
	if (! ((year.length == 2) || (year.length == 4)))
		return INVALID_DATE_YEAR;

	if(intMonth.length>2)
		return INVALID_DATE;

	if(intDay.length>2)
		return INVALID_DATE;
	//validate month
	if ( (intMonth < 1) || (intMonth > 12))
		return INVALID_DATE_MONTH;


    // validate date
	var monthArray=new Array(31,-1,31,30,31,30,31,31,30,31,30,31);
	var noOfDays ;
	if (intMonth == 2)
	{
		var Year;
		if((intYear % 100) == 0)
			Year = parseInt(intYear / 100);
		else
			Year = intYear ;

		if((Year % 4) == 0)
			noOfDays =29;
		else
			noOfDays =28;
	}
	else
	{
		noOfDays  = monthArray[intMonth-1];
	}
	
    if ((intDay > noOfDays ) || (intDay < 1 ) )
		return INVALID_DATE_RANGE; 

    return "false";
}


function ValidateName(Name)
{
	var i=0;
	var len = Name.length;
	while(i != len){
		chr = Name.charAt(i);
		if (chr == '|'  ||chr == ','  ||chr == '#'  || chr == ':' || chr == '<' || chr == '>' || chr == '"' || chr == '/'|| chr == '\\'|| chr == '\u2026')
			return 0;
		i++;
	}
	return 1;
}


function ValidateQueryName(Name)
{
	var i=0;
	var len = Name.length;
	while(i != len)
	{
		chr = Name.charAt(i);
		if (chr == '|'  ||chr == ','  ||chr == '#'  || chr == ':' || chr == '<' || chr == '>' || chr == '"' || chr == '/'|| chr == '\\'|| chr == '\u2026' || chr == '&' || chr == '=' ||chr == "'" || chr == "`" || chr == '(' || chr == ')' || chr == '+' || chr == '%' || chr == "*")
				return 0;
		i++;
	}
	return 1;
}


function isValidBatchSize(s)
{   
	var i=0;

    if(s.charAt(0)=='-')
		i=1;

	for (; i < s.length; i++)
    {   
		var c = s.charAt(i);
        if (!isDigit(c)) 
			return INVALID_CHAR_IN_BATCH_SIZE_FIELD;
    }
        if(strConfBatchSize!= "" && parseInt(s) > parseInt(strConfBatchSize))
		return BATCHSIZE_MAX_VALUE +" " + strConfBatchSize + ".";

	if (s< 1 || s>250)
		return INVALID_BATCH_SIZE;

    return "false";
}


function ValidateValue(val, type, len)
{
	var validationStatus;
	val = Trim(val);

	if(val == "" || val == '')
		return true;

	switch (parseInt(type))
	{
		case NG_VAR_INT:
				validationStatus = isInteger(val);
				break;

		case NG_VAR_LONG :
				validationStatus = isLong(val);
				break;

		case NG_VAR_FLOAT:
				validationStatus = isFloat(val);
				break;
		
		case NG_VAR_DATE:
				validationStatus = ValidateDateFormat(val,sDateFormat); 
				if (validationStatus == 1)
					validationStatus = "false";
				break;
               case NG_VAR_SHORTDATE:
				validationStatus = ValidateShortDateFormat(val,sDateFormat); 
				if (validationStatus == 1)
					validationStatus = "false";
				break;
                                     
                case NG_VAR_TIME:
				validationStatus = ValidateTimeFormat(val); 
				if (validationStatus == 1)
					validationStatus = "false";
				break;
		case NG_VAR_STRING :
				validationStatus = isString(val,len);
				break;
                                        
               case NG_VAR_DURATION  :
				 validationStatus = validateDurationFormat(val);
				 if (validationStatus == 1)
					validationStatus = "false";
				break;
              case NG_VAR_BOOLEAN:
                                validationStatus = "false";
                              break;
	}

	if(validationStatus == "false")
		return true;
	else
		return false;
}