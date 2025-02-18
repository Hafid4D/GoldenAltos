Class constructor($ident : Text)
	
	This:C1470.ident:=$ident
	This:C1470.columns:=New collection:C1472
	This:C1470.actions:=New collection:C1472
	
Function setDatasource($datasource : Text)
	
	This:C1470.dataSource:=$datasource
	
Function addPredefinedAction($type : Text; $visionIdent : Text; $entryIdent : Text)
	
	$action:=New object:C1471
	$action.predefinedType:=$type
	$action.visionIdent:=$visionIdent
	$action.entryIdent:=$entryIdent
	This:C1470.actions.push($action)
	
Function addSpecificAction($ident : Text; $label : Text; $formulaToCall : 4D:C1709.Function; $formulaToActivate : 4D:C1709.Function;  ...  : Text)
	
	$action:=New object:C1471
	$action.specificAction:=True:C214
	$action.ident:=$ident
	$action.label:=$label
	$action.formulaToCall:=$formulaToCall
	$action.formulaToActivate:=$formulaToActivate || Null:C1517
	
	For ($p; 5; Count parameters:C259)
		$params:=Split string:C1554(${$p}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="needAnEntity")
				$action.needAnEntity:=True:C214
				
		End case 
	End for 
	This:C1470.actions.push($action)
	
	
Function addColumn($expression : Text;  ...  : Text)
	var $column : Object
	
	$column:=New object:C1471
	$column.expression:=$expression
	$column.dataSourceTypeHint:="text"
	
	For ($p; 2; Count parameters:C259)
		$params:=Split string:C1554(${$p}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="width")
				$column.width:=Num:C11($params[0])
			: ($selector="headerLabel")
				$column.headerLabel:=$params[0]
			: ($selector="formatNum") || ($selector="numberFormat")
				$column.numberFormat:=$params[0]
				$column.dataSourceTypeHint:="number"
		End case 
	End for 
	
	This:C1470.columns.push($column)
	