Class extends Entity

local Function getFullName()->$fullName : Text
	
	$coll:=New collection:C1472(This:C1470.civility; This:C1470.firstName; This:C1470.lastName)
	$fullName:=$coll.join(" "; ck ignore null or empty:K85:5)
	