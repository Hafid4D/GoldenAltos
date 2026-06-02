//%attributes = {}

// Purpose: Run manual depreciation for all assets in the current view/list (current month).
// modified by 4D/PS [2026-may-19]

If (Form:C1466.sfw.lb_items.length=0)
	cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("Info"; "No items in the list"))
Else 
	
	var $eAsset : cs:C1710.AssetEntity
	var $result : Object
	var $appliedCount : Integer
	var $skippedCount : Integer
	var $depreciationDate : Date
	var $message : Text
	var $info : Object
	
	$depreciationDate:=Current date:C33(*)
	
	If (Not:C34(cs:C1710.sfw_dialog.me.confirm("Run manual depreciation for "+String:C10(Form:C1466.sfw.lb_items.length)+" asset(s) for "+String:C10($depreciationDate; System date short:K1:1)+"?"; "yes"; "no")))
		return 
	End if 
	
	$appliedCount:=0
	$skippedCount:=0
	
	For each ($eAsset; Form:C1466.sfw.lb_items)
		$result:=$eAsset.applyManualDepreciation($depreciationDate; "Manual")
		If ($result.success)
			$info:=$eAsset.save()
			If ($info.success)
				$appliedCount:=$appliedCount+1
			Else 
				$skippedCount:=$skippedCount+1
			End if 
		Else 
			$skippedCount:=$skippedCount+1
		End if 
	End for each 
	
	Form:C1466.sfw.lb_items_search()
	
	$message:=String:C10($appliedCount)+" asset(s) depreciated"
	If ($skippedCount>0)
		$message:=$message+", "+String:C10($skippedCount)+" skipped"
	End if 
	cs:C1710.sfw_dialog.me.info($message)
	
End if 
