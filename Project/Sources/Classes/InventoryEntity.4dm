Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:="INV: "+String:C10(This:C1470.inventoryID; "00000#")
	
Function get dateIn_d()->$date : Date
	$date:=cs:C1710.sfw_stmp.me.getDate(This:C1470.dateIn)
	
Function set dateIn_d($date : Date)
	This:C1470.dateIn_d:=$date
	
Function refreshDateIn_d()
	This:C1470.dateIn_d:=cs:C1710.sfw_stmp.me.getDate(This:C1470.dateIn)
	
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.inventoryID:=ds:C1482.Inventory.all().max("inventoryID")+1
	This:C1470.code:="INV"+String:C10(This:C1470.inventoryID; "00000#")
	
local Function afterCreation()
	// This callback is called after saving the new item
	
	This:C1470.availableQty:=This:C1470.initiallQty
	
	$res:=This:C1470.save()
	
	$pull:=ds:C1482.InventoryPull.new()
	
	$pull.date:=cs:C1710.sfw_stmp.me.now()
	$pull.type:="Initial Stock"
	$pull.qty:=This:C1470.initiallQty
	$pull.remaining:=This:C1470.initiallQty
	$pull.lotNumber:="N/A"
	$pull.statusIQA:="Pending"
	
	$pull.UUID_Inventory:=This:C1470.UUID
	
	$user_es:=ds:C1482.sfw_User.query("login = :1"; Current user:C182)
	
	$pull.performedBy:=($user_es.length>0) ? $user_es[0].fullName : ""
	
	$res:=$pull.save()
	