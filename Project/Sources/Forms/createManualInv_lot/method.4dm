Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.bins=Null:C1517)
			ds:C1482.Bin.cacheLoad()
		End if 
		$currentPath:=""
		If (Form:C1466.inventory_e.UUID_Location#"") & (Form:C1466.inventory_e.UUID_Location#String:C10("00"*16))
			
			Form:C1466.selectedBins:=Storage:C1525.cache.bins.query("UUID = :1"; Form:C1466.inventory_e.UUID_Location)
			If (Form:C1466.selectedBins#Null:C1517)
				$currentPath:=Form:C1466.selectedBins.first().binLocationPath
				OBJECT SET TITLE:C194(*; "pup_binLocation"; $currentPath)
			End if 
			
		End if 
		
End case 
