//%attributes = {}

// Purpose: Pick debit or credit CAO account for the selected journal line.
// Parameters: $side : Text — "debit" or "credit"
// Returns: nothing
// created by 4D/PS [2026-june-29]

#DECLARE($side : Text)

var $eCao : cs:C1710.CAOEntity
var $choose : Text
var $line : Object
var $idx : Integer

If (Form:C1466.journalEntryLinesSelected=Null:C1517) || (Form:C1466.journalEntryLinesSelected.length=0)
	cs:C1710.sfw_dialog.me.alert("Select a journal line first.")
	return 
End if

$line:=Form:C1466.journalEntryLinesSelected[0]
$idx:=Form:C1466.journalEntryLines.indexOf($line)
If ($idx<0)
	cs:C1710.sfw_dialog.me.alert("Select a journal line first.")
	return 
End if

// Purpose: Let 4D infer menu handle type from Create menu (Integer var caused type mismatch).
// modified by 4D/PS [2026-june-26]
$menu:=Create menu:C408
For each ($eCao; ds:C1482.CAO.activeCAOs().orderBy("accountNumber"))
	APPEND MENU ITEM:C411($menu; $eCao.displayLabel(); *)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $eCao.UUID)
End for each
$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

If ($choose#"")
	$eCao:=ds:C1482.CAO.get($choose)
	If ($eCao#Null:C1517)
		$line:=Form:C1466.journalEntryLines[$idx]
		Case of
			: ($side="debit")
				$line.UUID_CAO_debit:=$eCao.UUID
				$line.debitAccountName:=$eCao.displayLabel()
			: ($side="credit")
				$line.UUID_CAO_credit:=$eCao.UUID
				$line.creditAccountName:=$eCao.displayLabel()
		End case
		Form:C1466.journalEntryLines[$idx]:=$line
		_ga_jeTouchCollections()
	End if
End if
