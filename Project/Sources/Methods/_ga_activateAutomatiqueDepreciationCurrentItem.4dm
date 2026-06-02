//%attributes = {}

// Purpose: Toggle automatic monthly depreciation on the currently open asset.
// Runs as a setItemAction — operates on Form.current_item only.
// created by 4D/PS [2026-june-01]

If (Form:C1466.current_item=Null:C1517)
	cs:C1710.sfw_dialog.me.info("No asset selected")
Else 
	
	var $eAsset : cs:C1710.AssetEntity
	var $info : Object
	var $currentState : Boolean
	var $newState : Boolean
	var $confirmMsg : Text
	
	$eAsset:=Form:C1466.current_item
	
	// Determine current state
	$currentState:=False:C215
	If (Value type:C1509($eAsset.moreData)=Is object:K8:27)
		If (OB Is defined:C1231($eAsset.moreData; "automaticDepreciation"))
			$currentState:=$eAsset.moreData.automaticDepreciation=True:C214
		End if 
	End if 
	
	$newState:=Not:C34($currentState)
	
	If ($newState)
		$confirmMsg:="Enable automatic depreciation for asset #"+String:C10($eAsset.assetNumber)+"?"
	Else 
		$confirmMsg:="Disable automatic depreciation for asset #"+String:C10($eAsset.assetNumber)+"?"
	End if 
	
	If (Not:C34(cs:C1710.sfw_dialog.me.confirm($confirmMsg; "yes"; "no")))
		return 
	End if 
	
	$eAsset.setAutomaticDepreciation($newState)
	$info:=$eAsset.save()
	
	If ($info.success)
		// Refresh the panel
		Form:C1466.current_item:=ds:C1482.Asset.get($eAsset.UUID)
		If ($newState)
			cs:C1710.sfw_dialog.me.info("Automatic depreciation enabled for asset #"+String:C10($eAsset.assetNumber))
		Else 
			cs:C1710.sfw_dialog.me.info("Automatic depreciation disabled for asset #"+String:C10($eAsset.assetNumber))
		End if 
	Else 
		cs:C1710.sfw_dialog.me.info("Save failed")
	End if 
	
End if 
