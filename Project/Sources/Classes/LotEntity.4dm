Class extends Entity

Function getCurrentStep()->$currentStepOrder : Integer
	$currentstep_es:=This:C1470.steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	
	If ($currentstep_es.length>0)
		$currentStepOrder:=$currentstep_es[0].order
	End if 
	
// Purpose: Drives Punch OUT hTab styling so "Bins" is disabled (grey) when no active punching step or LotStep.enableBins is false. Uses the same LotStep selection rule as cs.panel_punchOut.loadCurrentStep().
// Parameters: none (invoked as Form.current_item.punchOut_binsTabDisabled() from SFW drawHTab formulas)
// Returns: Boolean True = Bins tab should be disabled/greyed
// created by 4D/PS [2026-may-05]
Function punchOut_binsTabDisabled()-> $disabled : Boolean
	var $currentstep : cs:C1710.LotStepSelection
	// Same filter as cs.panel_punchOut.loadCurrentStep() active step candidate
	$currentstep:=This:C1470.steps.query("qtyIn # :1 AND qtyOut = :1 AND dateIn # :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	If ($currentstep.length=0)
		$disabled:=True:C214
	Else 
		$disabled:=Not:C34($currentstep[0].enableBins)
	End if 
	
local Function loadAfterCreation()
	// Purpose: Assign a unique barcode in moreData for scanner lookup on new records.
	// modified by 4D/PS [2026-june-29]
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")
	
	Case of 
		: (Form:C1466.sfw.entry.ident="customerReceivedMaterial")
			$job:=ds:C1482.Job.new()
			$res:=$job.save()
			
			If ($res.success)
				This:C1470.UUID_Job:=$job.UUID
			End if 
			
			If (This:C1470.dateIn=!00-00-00!)
				This:C1470.dateIn:=Current date:C33
			End if 
			
		Else 
			// This callback is called after creating the new item but before displaying the panel.
			If (This:C1470.lotNumber="")
				This:C1470.lotNumber:=String:C10(String:C10(ds:C1482.Lot.all().extract("lotNumber").map(Formula:C1597(Num:C11($1.value))).filter(Formula:C1597((Num:C11($1.value)#1) && (Num:C11($1.value)#0))).max()+1); "0000000000#")  //
				
				//String(Num(ds.Lot.all().max("lotNumber")+1000); "00000#")
			End if 
			If (Form:C1466.sfw.entry.ident="receiver")
				$job:=ds:C1482.Job.new()
				
				$job.jobNumber:=ds:C1482.Job.all().max("jobNumber")+1
				
				$res:=$job.save()
				
				If ($res.success)
					This:C1470.UUID_Job:=$job.UUID
				End if 
			End if 
	End case 
	
	