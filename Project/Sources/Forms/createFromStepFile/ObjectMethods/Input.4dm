Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		If (Form:C1466.sf_customerSearch.selectedItem#Null:C1517)
			Form:C1466.sf_stepFileSearch:=New object:C1471(\
				"colName"; "name"; \
				"lb_values"; Form:C1466.sf_customerSearch.selectedItem.stepFiles\
				)
			
			OBJECT SET SUBFORM:C1138(*; "sf_stepFileSearch"; "searchOnList")
			OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; True:C214)
		Else 
			cs:C1710.sfw_dialog.me.alert("No Customer selected !")
		End if 
	: (FORM Event:C1606.code=On Mouse Enter:K2:33)
		SET CURSOR:C469(9000)
	: (FORM Event:C1606.code=On Mouse Leave:K2:34)
		SET CURSOR:C469()
		
End case 