Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.bins=Null:C1517)
			ds:C1482.Bin.cacheLoad()
		End if 
		Form:C1466.currentPath:=""
		If (Form:C1466.inventory_e.UUID_InventoryClassification#"") & (Form:C1466.inventory_e.UUID_InventoryClassification#String:C10("00"*16))
			$classification:=ds:C1482.InventoryClassification.query("UUID = :1"; Form:C1466.inventory_e.UUID_InventoryClassification).first()
			If ($classification#Null:C1517)
				Form:C1466.inventory_e.classification:=$classification.name
			End if 
		End if 
		If (Form:C1466.inventory_e.UUID_Location#"") & (Form:C1466.inventory_e.UUID_Location#String:C10("00"*16))
			
			Form:C1466.selectedBins:=Storage:C1525.cache.bins.query("UUID = :1"; Form:C1466.inventory_e.UUID_Location)
			If (Form:C1466.selectedBins#Null:C1517)
				Form:C1466.currentPath:=Form:C1466.selectedBins.first().binLocationPath
				OBJECT SET TITLE:C194(*; "pup_binLocation"; Form:C1466.currentPath)
				//cs.Util_binLocationPicker.me.draw("pup_binLocation"; Form.currentPath)
			End if 
			
		End if 
		
End case 
