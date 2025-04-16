Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		$menu:=""
		
		For ($i; 1; 32)
			$menu:=$menu+Choose:C955((Form:C1466.existingBins.query("num = :1"; $i).length>0); "("; "")+String:C10($i)+";"
		End for 
		
		Form:C1466.binDefinition.num:=Pop up menu:C542($menu)
		
End case 