sfw_panel_formMethod()

If (Form:C1466.current_item#Null:C1517)
	
	// Set Gibraltar as default country on new record
	If (Form:C1466.type=Null:C1517)
		Form:C1466.type:="Alpha"
	End if 
	
	$objectName:="pup_type"
	$typeName:=Form:C1466.type
	Form:C1466.current_item.stmpLastModif:=cs:C1710.sfw_stmp.me.now()
	
	
	// Drawing of the button for the country
	If (sfw_checkIsInModification)
		OBJECT SET FORMAT:C236(*; $objectName; $typeName)
	Else 
		OBJECT SET FORMAT:C236(*; $objectName; $typeName)
	End if 
End if 