Class extends Entity

Function getCurrentStep()->$currentStepOrder : Integer
	$currentstep_es:=This:C1470.steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	
	If ($currentstep_es.length>0)
		$currentStepOrder:=$currentstep_es[0].order
	End if 
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	If (This:C1470.lotNumber="")
		This:C1470.lotNumber:=String:C10(String:C10(ds:C1482.Lot.all().extract("lotNumber").map(Formula:C1597(Num:C11($1.value))).filter(Formula:C1597((Num:C11($1.value)#1) && (Num:C11($1.value)#0))).max()+1); "0000000000#")  //
		
		//String(Num(ds.Lot.all().max("lotNumber")+1000); "00000#")
		
	End if 