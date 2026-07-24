// Purpose: Modal list picker — load items from a 4D List into Form.lbList on open.
// Form parameters (set by caller before DIALOG):
//   listName : Text — 4D List name (Lists theme) or empty for sample data
//   listTitle : Text — suffix shown in header (defaults to listName)
// Returns via Form: selectedText, selectedRef when OK
// created by 4D/PS [2026-july-08]

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.lbList:=New list:C375
		Form:C1466.selectedText:=""
		Form:C1466.selectedRef:=0
		
		If (Form:C1466.listName=Null:C1517)
			Form:C1466.listName:=""
		End if 
		If (Form:C1466.listTitle=Null:C1517) || (Form:C1466.listTitle="")
			Form:C1466.listTitle:=Form:C1466.listName
		End if 
		Form:C1466.headerLabel:="Items in list "+Form:C1466.listTitle
		
		__test_Focus_loadListItems(Form:C1466.listName; Form:C1466.lbList)
		
		OBJECT SET ENABLED:C1123(*; "btn_ok"; False:C215)
		
End case 
