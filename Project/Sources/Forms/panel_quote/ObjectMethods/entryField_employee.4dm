


Case of 
	: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
		OBJECT GET COORDINATES:C663(*; "entryField_employee"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Screen:K27:7)
		
		
		$form:=New object:C1471()
		$form.lb_items:=ds:C1482.Employee.all()
		$form.oo:=""
		$ref:=Open form window:C675("selectContact"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectContact"; $form)
		CLOSE WINDOW:C154($ref)
		If (ok=1)
			
			Form:C1466.current_item.UUID_Employee:=$form.item.UUID
			cs:C1710.panel_quote.me._activate_save_cancel_button()
			
		End if 
		
End case 
