Class extends Entity



Function getFullName()->$fullName : Text
	
	$coll:=New collection:C1472(This:C1470.civility; This:C1470.firstName; This:C1470.lastName)
	$fullName:=$coll.join(" "; ck ignore null or empty:K85:5)
	
Function get fullName()->$fullName : Text
	$fullName:=This:C1470.getFullName()
	
Function get age()->$age : Integer
	
	$age:=(Current date:C33-This:C1470.birthdate)\365  //that's just for the demo, to be tune !
	
Function get city()->$city : Text
	
	$city:=contactDetails.addresses[0].detail.city
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.fullName
	
	
local Function beforeSave()
	
local Function itemLoad()
	
local Function itemReload()
	