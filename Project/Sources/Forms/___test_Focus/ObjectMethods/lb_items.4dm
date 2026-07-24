// Purpose: Track list selection and accept on double-click (legacy List picker UX).
// modified by 4D/PS [2026-july-08]

var $pos : Integer

Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		$pos:=Selected list items:C379(Form:C1466.lbList; Form:C1466.selectedRef; Form:C1466.selectedText)
		OBJECT SET ENABLED:C1123(*; "btn_ok"; $pos#0)
		
	: (FORM Event:C1606.code=On Double Clicked:K2:5)
		$pos:=Selected list items:C379(Form:C1466.lbList; Form:C1466.selectedRef; Form:C1466.selectedText)
		If ($pos#0)
			ACCEPT:C269
		End if 
		
End case 
