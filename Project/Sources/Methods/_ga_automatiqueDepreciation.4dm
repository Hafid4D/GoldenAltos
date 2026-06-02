//%attributes
{"executedOnServer":true}


// Purpose: Run automatic monthly depreciation for assets flagged with automaticDepreciation in moreData.
// Can be scheduled server-side at month end. GL posting is not included yet.
// modified by 4D/PS [2026-may-19]

var $eAsset : cs:C1710.AssetEntity
var $result : Object
var $appliedCount : Integer
var $depreciationDate : Date
var $info : Object

$depreciationDate:=Current date:C33(*)
$appliedCount:=0

For each ($eAsset; ds:C1482.Asset.query("isScrapped = :1"; False:C215))
	
	// Purpose: Fix wrong Value type token ID (C1119) that 4D resolved to an invalid command.
	// modified by 4D/PS [2026-may-19]
	If (Value type:C1509($eAsset.moreData)=Is object:K8:27) && ($eAsset.moreData.automaticDepreciation=True:C214)
		$result:=$eAsset.applyManualDepreciation($depreciationDate; "Automatic")
		If ($result.success)
			$info:=$eAsset.save()
			If ($info.success)
				$appliedCount:=$appliedCount+1
			End if 
		End if 
	End if 
	
End for each 
