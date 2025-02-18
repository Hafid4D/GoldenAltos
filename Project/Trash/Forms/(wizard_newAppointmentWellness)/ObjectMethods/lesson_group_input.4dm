var $es : cs:C1710.GroupSelection
var $e : cs:C1710.GroupEntity

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		Form:C1466.searchGroupName:=Form:C1466.inputGroupName
		$search:=Form:C1466.searchGroupName+"@"
		
		Form:C1466.searchGroupES:=ds:C1482.Group.query("name = :1"; $search)
		If (Form:C1466.searchGroupES.length>0)
			$e:=Form:C1466.searchGroupES.first()
			Form:C1466.inputGroupName:=$e.name
			Form:C1466.UUID_Group:=$e.UUID
			Form:C1466.who:=$e.getFullName()
			
		Else 
			Form:C1466.searchGroupES:=Null:C1517
			Form:C1466.UUID_Group:="0"*32
		End if 
		wizard_newLesson_Redraw
		
End case 
