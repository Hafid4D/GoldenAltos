//%attributes = {}

// Purpose: Enable automatic monthly depreciation for assets in the current list selection.
// modified by 4D/PS [2026-may-19]

If (Form:C1466.sfw.lb_items.length=0)
	cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("Info"; "No items in the list"))
Else 
	
	var $eAsset : cs:C1710.AssetEntity
	var $count : Integer
	var $info : Object
	
	If (Not:C34(cs:C1710.sfw_dialog.me.confirm("Activate automatic depreciation for "+String:C10(Form:C1466.sfw.lb_items.length)+" asset(s)?"; "yes"; "no")))
		return 
	End if 
	
	$count:=0
	For each ($eAsset; Form:C1466.sfw.lb_items)
		$eAsset.setAutomaticDepreciation(True:C214)
		$info:=$eAsset.save()
		If ($info.success)
			$count:=$count+1
		End if 
	End for each 
	
	cs:C1710.sfw_dialog.me.info(String:C10($count)+" asset(s) set for automatic depreciation")
	
End if 
