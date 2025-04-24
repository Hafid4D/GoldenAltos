property _entry : cs:C1710.sfw_definitionEntry
property _searchbox : Text
property _queryString : Text
property _querySettings : Object
property _queryParts : Collection
property _queryStringParts : Collection
property _notToAdd : Boolean
property _tagToAdd : Text
property _partIndice : Integer
property searchHighlightParts : Collection

singleton Class constructor
	
	This:C1470._searchbox:=""
	This:C1470._queryString:=""
	This:C1470._querySettings:=New object:C1471()
	This:C1470._querySettings.parameters:=New object:C1471()
	This:C1470._querySettings.attributes:=New object:C1471()
	This:C1470._querySettings.queryPlan:=False:C215
	This:C1470._querySettings.queryPath:=False:C215
	
	
	//MARK:-Analyse the search box
Function _cleanSearchbox()  //to remove useless spaces in content of the searchbox 
	
	This:C1470._searchbox:=Split string:C1554(This:C1470._searchbox; " ").join(" "; ck ignore null or empty:K85:5)
	
	//MARK:-Build a list of criteria
Function _splitSearchboxInParts()
	
	var $rawSearchbox : Text  //the contents of the search box ready to be eaten character by character
	var $currentValue : Text  //the currentPart build char by char
	var $char : Text  //the current char to analyze
	var $positionNext : Integer  //where is the next char to be process
	var $inDoubleQuotes : Boolean  //to know if we are currently in a double quotes or not
	var $potentialTag : Text  //this value contain the name of the tag, if exist
	This:C1470._queryParts:=New collection:C1472
	$rawSearchbox:=This:C1470._searchbox
	
	$currentValue:=""
	$inDoubleQuotes:=False:C215
	This:C1470._tagToAdd:=""
	This:C1470._notToAdd:=False:C215
	While ($rawSearchbox#"")
		$char:=$rawSearchbox[[1]]
		$positionNext:=2
		Case of 
			: (($rawSearchbox="AND @") || ($rawSearchbox="AND(@")) & Not:C34($inDoubleQuotes)
				If (This:C1470._queryParts.length=0)
					This:C1470._pushCurrentValueInParts("and")
					$currentValue:=""
				Else 
					$part:=New object:C1471
					$part.type:="operator"
					$part.value:="AND"
					This:C1470._queryParts.push($part)
					This:C1470._notToAdd:=False:C215
				End if 
				$positionNext:=($rawSearchbox="AND @") ? 5 : 4
			: (($rawSearchbox="OR @") || ($rawSearchbox="OR(@")) & Not:C34($inDoubleQuotes)
				If (This:C1470._queryParts.length=0)
					This:C1470._pushCurrentValueInParts("or")
					$currentValue:=""
				Else 
					$part:=New object:C1471
					$part.type:="operator"
					$part.value:="OR"
					This:C1470._queryParts.push($part)
					This:C1470._notToAdd:=False:C215
				End if 
				$positionNext:=($rawSearchbox="AND @") ? 4 : 3
			: ($char="-") & ($currentValue="")
				This:C1470._notToAdd:=True:C214
			: ($rawSearchbox="\\s@")
				$currentValue+=" "
				$positionNext:=3
			: (($char="(") || ($char=")")) & Not:C34($inDoubleQuotes)
				This:C1470._pushCurrentValueInParts($currentValue)
				$currentValue:=""
				This:C1470._pushParenthesisParts($char)
			: ($char="\"")
				This:C1470._pushCurrentValueInParts($currentValue)
				$currentValue:=""
				$inDoubleQuotes:=Not:C34($inDoubleQuotes)
			: ($char=" ") & Not:C34($inDoubleQuotes)
				This:C1470._pushCurrentValueInParts($currentValue)
				$currentValue:=""
			: ($char=":") & Not:C34($inDoubleQuotes)
				$potentialTag:=$currentValue
				$indices:=This:C1470._entry.searchfields.indices("tag = :1 or tags[] = :1"; $potentialTag)
				If ($indices.length>0)
					This:C1470._tagToAdd:=$potentialTag
					$currentValue:=""
				Else 
					$currentValue+=$char
				End if 
			Else 
				$currentValue+=$char
		End case 
		$rawSearchbox:=Substring:C12($rawSearchbox; $positionNext)
	End while 
	This:C1470._pushCurrentValueInParts($currentValue)
	This:C1470._completeImpliciteOperator()
	
Function _pushCurrentValueInParts($currentValue : Text)
	var $part : 4D:C1709.Object
	
	$part:=(This:C1470._notToAdd) ? New object:C1471("not"; True:C214) : New object:C1471
	Case of 
		: ($currentValue="")
		: (This:C1470._tagToAdd#"")
			$part.type:="value"
			$part.tag:=This:C1470._tagToAdd
			$part.value:=$currentValue
			This:C1470._queryParts.push($part)
			This:C1470._tagToAdd:=""
			This:C1470._notToAdd:=False:C215
		Else 
			$part.type:="value"
			$part.value:=$currentValue
			This:C1470._queryParts.push($part)
			This:C1470._notToAdd:=False:C215
	End case 
	
Function _pushParenthesisParts($char : Text)
	var $parenthesisPart : Object
	
	$parenthesisPart:=(This:C1470._notToAdd) && ($char="(") ? New object:C1471("not"; True:C214) : New object:C1471
	This:C1470._notToAdd:=False:C215
	$parenthesisPart.type:="parenthesis"
	$parenthesisPart.value:=$char
	This:C1470._queryParts.push($parenthesisPart)
	
	//MARK:-Consolidate the list of criteria
	
Function _completeImpliciteOperator()
	
	var $previousPart; $part : Object
	var $queryPartsIN : Collection
	var $nbParentheses : Integer
	
	$queryPartsIN:=This:C1470._queryParts  //  copy the content of the current collection ...
	This:C1470._queryParts:=New collection:C1472  // ... before reset this collection for a full rebuild
	$previousPart:=Null:C1517
	For each ($part; $queryPartsIN)
		Case of 
			: ($previousPart.type="value") & ($part.type="value")
				This:C1470._pushANDOperator()
			: ($previousPart.type="parenthesis") & ($previousPart.value=")") & ($part.type="value")
				This:C1470._pushANDOperator()
			: ($previousPart.type="parenthesis") & ($previousPart.value=")") & ($part.type="parenthesis") & ($part.value="(")
				This:C1470._pushANDOperator()
				$nbParentheses+=1
			: ($previousPart.type="value") & ($part.type="parenthesis") & ($part.value="(")
				This:C1470._pushANDOperator()
				$nbParentheses+=1
			: ($part.type="parenthesis") & ($part.value="(")
				$nbParentheses+=1
			: ($part.type="parenthesis") & ($part.value=")")
				$nbParentheses-=1
		End case 
		This:C1470._queryParts.push($part)
		$previousPart:=$part
	End for each 
	
	Case of 
		: ($nbParentheses>0)
			For ($i; $nbParentheses; 0; -1)
				$parenthesisPart:=New object:C1471
				$parenthesisPart.type:="parenthesis"
				$parenthesisPart.value:=")"
				This:C1470._queryParts.push($parenthesisPart)
			End for 
		: ($nbParentheses<0)
			For ($i; $nbParentheses; 0)
				$parenthesisPart:=New object:C1471
				$parenthesisPart.type:="parenthesis"
				$parenthesisPart.value:="("
				This:C1470._queryParts.unshift($parenthesisPart)
			End for 
	End case 
	
Function _pushANDOperator()
	
	$operatorPart:=New object:C1471
	$operatorPart.type:="operator"
	$operatorPart.value:="AND"
	This:C1470._queryParts.push($operatorPart)
	
	
	//MARK:-Build the query elements
Function _buildQueryString()
	
	var $subQueryStringPart : Text
	var $subQueryStringParts : Collection
	var $valueToSearch : Variant
	var $field : Object
	var $parameterName : Text
	
	This:C1470._queryStringParts:=New collection:C1472
	
	This:C1470._partIndice:=0
	For each ($part; This:C1470._queryParts)
		
		Case of 
			: ($part.type="value")
				$subQueryStringParts:=New collection:C1472()
				This:C1470._partIndice+=1
				Case of 
					: ($part.tag#Null:C1517)
						$searchFields:=This:C1470._entry.searchfields.query("tag = :1 or tags[] = :1"; $part.tag)
					Else 
						$searchFields:=This:C1470._entry.searchfields.query("onlyWithTag = false or onlyWithTag = null")
				End case 
				For each ($field; $searchFields)
					$subQueryStringPart:=""
					$valueToSearch:=This:C1470._constructSearchValue($part.value; $field)
					Case of 
						: (Value type:C1509($valueToSearch)=Is collection:K8:32)
							$operator:=$valueToSearch.shift()
							Case of 
								: ($operator="in")
									$subQueryStringPart+=This:C1470._buidSubQueryStringPart($field; $valueToSearch; "in")
								: ($operator="between")
									If ($field.placeHolder#Null:C1517)
										$parameterName:=$field.placeHolder+String:C10($partIndice)+"_1"
										$subQueryStringPart+=($subQueryStringPart="") ? "( " : " OR ("
										$subQueryStringPart+=$field.path+" >= :"+$parameterName
										This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch.shift()
										$parameterName:=$field.placeHolder+String:C10($partIndice)+"_2"
										$subQueryStringPart+=" and "+$field.path+" <= :"+$parameterName+" )"
										This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch.shift()
									Else 
										$parameterName:=$field.attribute+String:C10($partIndice)+"_1"
										$subQueryStringPart+=($subQueryStringPart="") ? "( " : " OR ("
										$subQueryStringPart+=$field.attribute+" >= :"+$parameterName
										This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch.shift()
										$parameterName:=$field.attribute+String:C10($partIndice)+"_2"
										$subQueryStringPart+=" and "+$field.attribute+" <= :"+$parameterName+" )"
										This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch.shift()
									End if 
									
							End case 
						Else 
							$subQueryStringPart+=This:C1470._buidSubQueryStringPart($field; $valueToSearch; "=")
					End case 
					$subQueryStringParts.push($subQueryStringPart)
				End for each 
				
				If (Bool:C1537($part.not))
					This:C1470._queryStringParts.push("not("+$subQueryStringParts.join(" OR ")+")")
				Else 
					This:C1470._queryStringParts.push("("+$subQueryStringParts.join(" OR ")+")")
				End if 
				
			: ($part.type="operator")
				This:C1470._queryStringParts.push($part.value)
				
			: ($part.type="parenthesis")
				This:C1470._queryStringParts.push(($part.not ? "not" : "")+$part.value)
				
		End case 
		
	End for each 
	This:C1470._queryString:=This:C1470._queryStringParts.join(" ")
	This:C1470._queryString+=(This:C1470._entry.orderByDefault#Null:C1517) ? " order by "+This:C1470._entry.orderByDefault : ""
	
Function _buidSubQueryStringPart($field : Object; $valueToSearch : Variant; $operator : Text)->$subQueryStringPart : Text
	var $parameterName : Text
	
	If ($field.placeHolder#Null:C1517)
		$parameterName:=$field.placeHolder+String:C10(This:C1470._partIndice)
		$subQueryStringPart:=$field.path+" "+$operator+" :"+$parameterName
		This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch
	Else 
		$parameterName:=$field.attribute+String:C10(This:C1470._partIndice)
		$subQueryStringPart:=$field.attribute+" "+$operator+" :"+$parameterName
		This:C1470._querySettings.parameters[$parameterName]:=$valueToSearch
	End if 
	
Function _constructSearchValue($value : Text; $field : Object)->$valueToSearch : Variant
	$typeOfValue:=(Num:C11($field.type)=0) ? Is text:K8:3 : $field.type
	Case of 
		: ($typeOfValue=Is text:K8:3)
			Case of 
				: (Position:C15(";"; $value)>0)
					$valueToSearch:=New collection:C1472("in")
					For each ($valueToPush; Split string:C1554($value; ";"))
						$valueToSearch.push(This:C1470._constructSearchValue($valueToPush))
					End for each 
				: ($value="^@^")
					$valueToSearch:=Substring:C12($value; 2; Length:C16($value)-2)
				: ($value="^@")
					$valueToSearch:=Substring:C12($value; 2)+((Position:C15("@"; $value; *)>0) ? "" : "@")
				: ($value="@^")
					$valueToSearch:=((Position:C15("@"; $value; *)>0) ? "" : "@")+Substring:C12($value; 1; Length:C16($value)-1)
				: (Position:C15("@"; $value; *)>0)
					$valueToSearch:=$value
				Else 
					$valueToSearch:="@"+$value+"@"
			End case 
			This:C1470.searchHighlightParts.push($value)
			
		: ($typeOfValue=Is date:K8:7)
			Case of 
				: ($value="today")
					$valueToSearch:=Current date:C33
				: ($value="tomorrow")
					$valueToSearch:=Current date:C33+1
				: ($value="yesterday")
					$valueToSearch:=Current date:C33-1
				: ($value="7lastdays")
					$valueToSearch:=New collection:C1472("between"; Current date:C33-7; Current date:C33-1)
				: ($value="7nextdays")
					$valueToSearch:=New collection:C1472("between"; Current date:C33+1; Current date:C33+7)
				: ($value="thisWeek") || ($value="lastWeek") || ($value="nextWeek")
					$numberOfDay:=Day number:C114(Current date:C33)-1
					$numberOfDay:=(($numberOfDay=0) ? 7 : $numberOfDay)+(7*Num:C11($value="lastWeek"))-(7*Num:C11($value="nextWeek"))
					$valueToSearch:=New collection:C1472("between"; Current date:C33-$numberOfDay+1; Current date:C33-$numberOfDay+7)
				: ($value="thisMonth") || ($value="lastMonth") || ($value="nextMonth")
					$month:=Month of:C24(Current date:C33)-Num:C11($value="lastMonth")+Num:C11($value="nextMonth")
					$year:=Year of:C25(Current date:C33)
					$valueToSearch:=New collection:C1472("between"; Add to date:C393(!00-00-00!; $year; $month; 1); Add to date:C393(!00-00-00!; $year; $month+1; 1)-1)
				: ($value="thisYear") || ($value="lastYear") || ($value="nextYear")
					$year:=Year of:C25(Current date:C33)-Num:C11($value="lastYear")+Num:C11($value="nextYear")
					$valueToSearch:=New collection:C1472("between"; Add to date:C393(!00-00-00!; $year; 1; 1); Add to date:C393(!00-00-00!; $year; 12; 31))
				Else 
					$valueToSearch:=Date:C102($value)
			End case 
			
		Else 
			$valueToSearch:=This:C1470._constructSearchValue($value; New object:C1471("type"; Is text:K8:3))
	End case 
	
	//MARK: -Execute the query
Function perform($entry : Object; $rawSearchbox : Text)->$entitySelection : 4D:C1709.EntitySelection
	
	This:C1470.searchHighlightParts:=New collection:C1472
	This:C1470._entry:=$entry
	This:C1470._searchbox:=$rawSearchbox
	This:C1470._cleanSearchbox()
	If (This:C1470._searchbox="")
		$entitySelection:=This:C1470._all()
	Else 
		$entitySelection:=This:C1470._query()
	End if 
	
Function _all()->$entitySelection : 4D:C1709.EntitySelection
	
	$entitySelection:=ds:C1482[This:C1470._entry.dataclass].all()
	
	
Function _query()->$entitySelection : 4D:C1709.EntitySelection
	
	This:C1470._splitSearchboxInParts()
	This:C1470._buildQueryString()
	
	If (This:C1470._queryString="")  //in case of the analyze return a empty string
		$entitySelection:=This:C1470._all()
	Else 
		$entitySelection:=ds:C1482[This:C1470._entry.dataclass].query(This:C1470._queryString; This:C1470._querySettings)
	End if 
	
	
	