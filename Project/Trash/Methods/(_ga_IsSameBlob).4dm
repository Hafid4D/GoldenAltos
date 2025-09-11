//%attributes = {}
C_BLOB:C604($1; $2)
C_BOOLEAN:C305($0)
If (BLOB size:C605($1)=BLOB size:C605($2))
	For ($vByte; 0; BLOB size:C605($1)-1)
		If ($1{$vByte}#$2{$vByte})
			$0:=False:C215
			$vByte:=BLOB size:C605($2)
		Else 
			$0:=True:C214
			$vByte:=BLOB size:C605($1)
		End if 
	End for 
Else 
	$0:=False:C215
End if 