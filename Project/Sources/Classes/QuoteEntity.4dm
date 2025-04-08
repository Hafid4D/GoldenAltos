Class extends Entity

Function preview()->$preview : Object
	$preview:=New object:C1471()
	
	$preview.contactFirstName:=This:C1470.contact.firstName
	$preview.contactName:=This:C1470.contact.fullName
	$preview.contactCompany:=This:C1470.contact.customer.name
	
	$preview.contactAddress:=""
	If (This:C1470.contact.contactDetails#Null:C1517) && (This:C1470.contact.contactDetails.addresses#Null:C1517) && (This:C1470.contact.contactDetails.addresses.length#0)
		$address:=This:C1470.contact.contactDetails.addresses[0]
		If (String:C10($address.detail.street_1)#"")
			$preview.contactAddress+=$address.detail.street_1+", "
		End if 
		
		If (String:C10($address.detail.street_2)#"")
			$preview.contactAddress+=$address.detail.street_2+", "
		End if 
		
		If (String:C10($address.detail.city)#"")
			$preview.contactAddress+=$address.detail.city+", "
		End if 
		
		If (String:C10($address.detail.state)#"") & (String:C10($address.detail.postcode)#"")
			$preview.contactAddress+=$address.detail.state+" "+$address.detail.postcode+", "
		End if 
		
		If (String:C10($address.detail.country)#"")
			$preview.contactAddress+=$address.detail.country
		End if 
	Else 
		$preview.contactAddress:=" - "
	End if 
	
	If (This:C1470.contact.contactDetails#Null:C1517) && (This:C1470.contact.contactDetails.communications#Null:C1517) && (This:C1470.contact.contactDetails.communications.length#0)
		$comm:=This:C1470.contact.contactDetails.communications[0]
		$preview.contactTel:=$comm.mobile
		$preview.contactExt:=String:C10($comm.ext)
		$preview.contactFax:=$comm.fax
		$preview.contactEmail:=$comm.email
	Else 
		$preview.contactTel:=""
		$preview.contactExt:=""
		$preview.contactFax:=""
		$preview.contactEmail:=""
	End if 
	
	$preview.preparerName:=This:C1470.employee.fullName
	If (This:C1470.employee.contactDetails#Null:C1517) && (This:C1470.employee.contactDetails.communications#Null:C1517) && (This:C1470.employee.contactDetails.communications.length#0)
		$comm:=This:C1470.employee.contactDetails.communications[0]
		$preview.preparerEmail:=String:C10($comm.email)
		$preview.preparerMobile:=String:C10($comm.mobile)
		$preview.preparerExt:=String:C10($comm.ext)
	Else 
		$preview.preparerEmail:=$comm.email
		$preview.preparerMobile:=$comm.mobile
		$preview.preparerExt:=$comm.ext
	End if 
	
	$preview.copyName:=""  // to get from the old database
	$preview.copyCommMeans:=""  // to get from the old database
	
	$preview.quoteNumber:=This:C1470.code
	$preview.quoteRevision:=This:C1470.revision
	$preview.quoteDate:=String:C10(cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpCreation))
	$preview.quoteSubject:=This:C1470.subject
	$preview.quoteReference:=This:C1470.reference
	
	$preview.quoteLines:=This:C1470.lines
	$preview.optionalPreliminaryTxt_wr:=This:C1470.optionalPreliminaryTxt_wr
	
	$preview.assumptions:=ds:C1482.Assumption.query("UUID in :1"; This:C1470.assumptions.UUIDs)
	
	$preview.conditions:=ds:C1482.TermCondition.query("UUID in :1"; This:C1470.termsConditions.UUIDs)
	
	