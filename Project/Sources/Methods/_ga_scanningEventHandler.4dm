//%attributes = {}

var $asciiCode : Integer
var $char : Text

$asciiCode:=KeyCode

Use (Storage:C1525.scanner)
	If ($asciiCode#0)
		$char:=Char:C90($asciiCode)
		
		If ($asciiCode=Character code:C91("\n")) | ($asciiCode=Character code:C91("\r"))
			// Purpose: Fast wedge scan auto-closes; slow but complete scan also closes; short Enter clears buffer for retry.
			// modified by 4D/PS [2026-june-08]
			If (Length:C16(Storage:C1525.scanner.scanBuffer)=10)
				CALL FORM:C1391(Storage:C1525.scanner.currentWindow; "_ga_closeWindow")
			Else 
				Storage:C1525.scanner.scanBuffer:=""
			End if 
			
		Else 
			
			If ($asciiCode>=32)
				
				Storage:C1525.scanner.scanBuffer:=Storage:C1525.scanner.scanBuffer+$char
				
			End if 
		End if 
		
	End if 
	
End use 


