//%attributes = {}

// Purpose: Pick a CAO account on the deposit panel (bank, cash back, or other-funds line).
// Parameters:
// $target : Text — "bank", "cashBack", or "otherFund"
// Returns: nothing.
// created by 4D/PS [2026-june-22]

#DECLARE($target : Text)

var $eCao : cs:C1710.CAOEntity
var $choose : Text
var $line : Object
var $idx : Integer

$menu:=Create menu:C408
For each ($eCao; ds:C1482.CAO.activeCAOs().orderBy("accountNumber"))
	// modified by 4D/PS [2026-june-26]
	APPEND MENU ITEM:C411($menu; $eCao.displayLabel(); *)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $eCao.UUID)
End for each
$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

If ($choose#"")
	$eCao:=ds:C1482.CAO.get($choose)
	If ($eCao#Null:C1517)
		Case of
			: ($target="bank")
				Form:C1466.current_item.UUID_CAO_bank:=$eCao.UUID
				Form:C1466.current_item.bankAccountName:=$eCao.displayLabel()
			: ($target="cashBack")
				Form:C1466.current_item.UUID_CAO_cashBack:=$eCao.UUID
				Form:C1466.current_item.cashBackAccountName:=$eCao.displayLabel()
			: ($target="otherFund")
				$idx:=Num:C11(Form:C1466.depositOtherFundLineIndex)
				If (Form:C1466.depositOtherFundLines#Null:C1517) && ($idx>=0) && ($idx<Form:C1466.depositOtherFundLines.length)
					$line:=Form:C1466.depositOtherFundLines[$idx]
					$line.UUID_CAO:=$eCao.UUID
					$line.accountName:=$eCao.displayLabel()
					Form:C1466.depositOtherFundLines[$idx]:=$line
					_ga_depositTouchCollections()
				End if
		End case
	End if
End if
