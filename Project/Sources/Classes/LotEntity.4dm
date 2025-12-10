Class extends Entity

Function getCurrentStep()->$currentStepOrder : Integer
	$currentstep_es:=This:C1470.steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	
	If ($currentstep_es.length>0)
		$currentStepOrder:=$currentstep_es[0].order
	End if 