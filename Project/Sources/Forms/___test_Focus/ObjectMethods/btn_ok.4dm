// Purpose: Confirm pick — store selected list item then close dialog with OK=1.
// modified by 4D/PS [2026-july-08]

var $pos : Integer

$pos:=Selected list items:C379(Form:C1466.lbList; Form:C1466.selectedRef; Form:C1466.selectedText)
If ($pos#0)
	ACCEPT:C269
End if 
