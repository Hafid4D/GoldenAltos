//%attributes = {"executedOnServer":true}
/*
_ga_notifier

*/

//var $equipment : cs.EquipmentEntity
//var $equipments : cs.EquipmentSelection

$entitySelection:=$1->
var $boolField : Text:=$2
var $notificationName : Text:=$3
var $targetDataClass : Text:=$4
var $identifier : Text:=$5


For each ($entity; $entitySelection)
	If (Not:C34(Undefined:C82($entity.moreData))) & ($entity.moreData#Null:C1517)
		
		
	Else 
		$entity.moreData:=New object:C1471
	End if 
	
	
	If (Not:C34(OB Is defined:C1231($entity.moreData; $boolField)))
		$entity.moreData[$boolField]:=False:C215
		
	Else 
		
	End if 
	
	// Purpose: Skip entities already notified; optional recipient profiles (defaults to legacy broad list).
	// modified by 4D/PS [2026-may-21]
	If (Not:C34($entity.moreData[$boolField]))
		
		$context:=New object:C1471
		$context.target:=$entity.UUID
		$context.targetDataclass:=$targetDataClass
		$context[$identifier]:=$entity[$identifier]
		
		If (Count parameters:C259>=6)
			$profiles:=$6
		Else 
			$profiles:=New collection:C1472("qm"; "qs"; "pm"; "ps"; "vp"; "gm")
		End if 
		
		$staff:=ds:C1482.Staff.query("user.userInscriptions.userProfile.ident in :1 | memberships.team.name =:2"; $profiles; "Facilities")
		
		$users:=$staff.extract("user").extract("UUID").distinct()
		cs:C1710.sfw_notificationManager.me.notify($notificationName; $users; $context)
		
		$entity.moreData[$boolField]:=True:C214
		$res:=$entity.save()
		If (Not:C34($res.success))
			//TRACE
		End if 
		
	End if 
	
	//End if 
	//End if 
End for each 

