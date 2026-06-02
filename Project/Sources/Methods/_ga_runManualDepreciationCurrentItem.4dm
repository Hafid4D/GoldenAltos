//%attributes = {}

// Purpose: Run manual depreciation for the current month on the currently open asset.
// Runs as a setItemAction — operates on Form.current_item only.
// created by 4D/PS [2026-june-01]

If (Form:C1466.current_item=Null:C1517)
	cs:C1710.sfw_dialog.me.info("No asset selected")
Else 
	
	var $eAsset : cs:C1710.AssetEntity
	var $result : Object
	var $info : Object
	var $depreciationDate : Date
	
	$eAsset:=Form:C1466.current_item
	$depreciationDate:=Current date:C33(*)
	
	If (Not:C34($eAsset.canApplyManualDepreciation()))
		cs:C1710.sfw_dialog.me.info("This asset is not eligible for depreciation")
		return 
	End if 
	
	If (Not:C34(cs:C1710.sfw_dialog.me.confirm("Run manual depreciation for asset #"+String:C10($eAsset.assetNumber)+" for "+String:C10($depreciationDate; System date short:K1:1)+"?"; "yes"; "no")))
		return 
	End if 
	
	$result:=$eAsset.applyManualDepreciation($depreciationDate; "Manual")
	
	If ($result.success)
		$info:=$eAsset.save()
		If ($info.success)
			// Refresh the panel so updated values are visible
			Form:C1466.current_item:=ds:C1482.Asset.get($eAsset.UUID)
			FORM GOTO PAGE:C247(*; 2)
			cs:C1710.sfw_dialog.me.info("Depreciation recorded for "+String:C10($depreciationDate; System date short:K1:1))
		Else 
			cs:C1710.sfw_dialog.me.info("Save failed")
		End if 
	Else 
		cs:C1710.sfw_dialog.me.info("Skipped: "+$result.message)
	End if 
	
End if 
