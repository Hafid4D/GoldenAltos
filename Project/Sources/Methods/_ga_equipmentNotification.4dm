//%attributes = {}
/*
_ga_equipmentNotification

*/

var $equipment : cs:C1710.EquipmentEntity
var $equipments : cs:C1710.EquipmentSelection
var $boolField : Text:=$2
var $notificationName : Text:=$3

$equipments:=$1->

For each ($equipment; $equipments)
	
	If ($equipment.moreData[$boolField]=False:C215)
		
		$context:=New object:C1471
		$context.target:=$equipment.UUID
		$context.targetDataclass:="Equipment"
		$context.assignedID:=$equipment.assignedID
		
		$profiles:=New collection:C1472("pm"; "ps"; "qm"; "qs"; "vp"; "gm")
		$staff:=ds:C1482.Staff.query("user.userInscriptions.userProfile.ident in :1 | memberships.team.name =:2"; $profiles; "Facilities")
		
		$users:=$staff.extract("user").extract("UUID").distinct()
		cs:C1710.sfw_notificationManager.me.notify($notificationName; $users; $context)
		
		$equipment.moreData[$boolField]:=True:C214
		$res:=$equipment.save()
		If (Not:C34($res.success))
			//TRACE
		End if 
		
	End if 
	
End for each 

