Class extends Entity


Function get nameInWizard()->$name : Text
	$name:="🗄️ "+This:C1470.name
	
	
Function get nbProjects()->$nb : Integer
	$nb:=This:C1470.projects.length
	
Function get nbContracts()->$nb : Integer
	$nb:=This:C1470.contracts.length
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.name
	
	
local Function afterCreation()
	
local Function afterSave()
	// This callback is called after saving the item in the itemList
	
local Function beforeSave()
	// This callback is called before saving the item in the itemList
	
local Function beforeSaveCreation()
	
local Function duplicateRecord()
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	If (This:C1470.contactDetails=Null:C1517)
		This:C1470.contactDetails:=New object:C1471
	End if 
	If (This:C1470.contactDetails.addresses=Null:C1517)
		This:C1470.contactDetails.addresses:=New collection:C1472
	End if 
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "main").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="main"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:=This:C1470.country.iso_code_2 || "FR"
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	If (This:C1470.contactDetails.communications=Null:C1517)
		This:C1470.contactDetails.communications:=New collection:C1472
	End if 
	
	
	
	
	
	
local Function itemReload()
	
local Function loadAfterCreation()
	
local Function panelUnload()
	