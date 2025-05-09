//%attributes = {}
//_Capitalize_text project method
//_Capitalize_text ( Text ) -> Text
//_Capitalize_text ( Source text ) -> Capitalized text

$0:=$1
$vlLen:=Length:C16($0)
If ($vlLen>0)
	$0[[1]]:=Uppercase:C13($0[[1]])
	For ($vlChar; 1; $vlLen-1)
		If (Position:C15($0[[$vlChar]]; " !&()-{}:;<>?/,.=+*")>0)
			$0[[$vlChar+1]]:=Uppercase:C13($0[[$vlChar+1]])
		End if 
	End for 
End if 