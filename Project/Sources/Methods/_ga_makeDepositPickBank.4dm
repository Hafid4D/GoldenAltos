//%attributes = {}

// Purpose: Show a popup menu of active CAO bank accounts on the Make Deposit dialog.
// Parameters: uses Form (bankAccountUUID, bankAccountName).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $eCao : cs:C1710.CAOEntity
var $choose : Text

$menu:=Create menu:C408
For each ($eCao; ds:C1482.CAO.activeCAOs().orderBy("accountNumber"))
	APPEND MENU ITEM:C411($menu; $eCao.accountNumber+" — "+$eCao.name; *)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $eCao.UUID)
End for each
$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)
If ($choose#"")
	$eCao:=ds:C1482.CAO.get($choose)
	If ($eCao#Null:C1517)
		Form:C1466.bankAccountUUID:=$eCao.UUID
		Form:C1466.bankAccountName:=$eCao.accountNumber+" — "+$eCao.name
	End if
End if
