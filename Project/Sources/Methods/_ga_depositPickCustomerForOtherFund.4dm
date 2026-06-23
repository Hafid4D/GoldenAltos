//%attributes = {}

// Purpose: Pick a customer for the selected other-funds line on the deposit panel.
// modified by 4D/PS [2026-june-22]

var $selector : cs:C1710.sfw_definitionSelector
var $itemSeleted : Object
var $line : Object
var $idx : Integer

$idx:=Num:C11(Form:C1466.depositOtherFundLineIndex)
If (Form:C1466.depositOtherFundLines=Null:C1517) || ($idx<0) || ($idx>=Form:C1466.depositOtherFundLines.length)
	return 
End if

$selector:=cs:C1710.sfw_definitionSelector.new("selectorCustomers"; "customer")
$selector.setTitle("Choose a customer")
$selector.setOptions("noCutLink")
$selector.openSelector()

Case of
	: ($selector.isSelected())
		$itemSeleted:=$selector.getCurrentItem()
		If ($itemSeleted#Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)))
			$line:=Form:C1466.depositOtherFundLines[$idx]
			$line.UUID_Customer:=$itemSeleted.UUID
			$line.customerName:=$itemSeleted.name
			Form:C1466.depositOtherFundLines[$idx]:=$line
			_ga_depositTouchCollections()
		End if
	: ($selector.asCutTheLink())
		$line:=Form:C1466.depositOtherFundLines[$idx]
		$line.UUID_Customer:=""
		$line.customerName:=""
		Form:C1466.depositOtherFundLines[$idx]:=$line
		_ga_depositTouchCollections()
End case
