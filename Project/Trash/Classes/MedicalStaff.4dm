Class extends DataClass

Function get_medicalStaff($keyword : Text; $location : Text)->$medicalStaff : Object
	
	$settings:=New object:C1471()
	$settings.parameters:=New object:C1471
	
	$col_queryString:=New collection:C1472()
	If ($keyword#"")
		$col_queryString.push("firstName == :keyword")
		$col_queryString.push("lastName == :keyword")
		$col_queryString.push("medicalCapabilities.consultationKind.name == :keyword")
		
		$settings.parameters.keyword:="@"+$keyword+"@"
	End if 
	
	If ($location#"")
		$col_queryString.push("contactDetails.addresses[].detail.street_1 == :location")
		$col_queryString.push("contactDetails.addresses[].detail.city == :location")
		
		$col_queryString.push("medicalCapabilities.medicalHouse.name == :location")
		$col_queryString.push("medicalCapabilities.medicalHouse.contactDetails.addresses[].detail.street_1 == :location")
		$col_queryString.push("medicalCapabilities.medicalHouse.contactDetails.addresses[].detail.city == :location")
		
		$settings.parameters.location:="@"+$location+"@"
	End if 
	$queryString:=$col_queryString.join(" or ")
	
	If ($queryString#"")
		$medicalStaff:=This:C1470.query($queryString; $settings)
	Else 
		$medicalStaff:=This:C1470.all()
	End if 
	
	
	
local Function getFullName()->$fullName : Text
	
	$coll:=New collection:C1472(This:C1470.civility; This:C1470.firstName; This:C1470.lastName)
	$fullName:=$coll.join(" "; ck ignore null or empty:K85:5)
	