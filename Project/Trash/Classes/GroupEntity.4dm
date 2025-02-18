Class extends Entity

Function getFullName()->$fullName : Text
	
	$coll:=New collection:C1472(This:C1470.name)
	$fullName:=$coll.join(" "; ck ignore null or empty:K85:5)