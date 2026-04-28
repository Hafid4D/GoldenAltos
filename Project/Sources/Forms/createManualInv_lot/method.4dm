Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		If (Form:C1466.readOnly=Null:C1517)
			Form:C1466.readOnly:=False:C215
		End if 
		
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
		If (Form:C1466.inventory_e.UUID_InventoryUnits#"") & (Form:C1466.inventory_e.UUID_InventoryUnits#String:C10("00"*16))
			$inventoryUnit:=ds:C1482.InventoryUnits.query("UUID = :1"; Form:C1466.inventory_e.UUID_InventoryUnits).first()
			If ($inventoryUnit#Null:C1517)
				Form:C1466.inventory_e.units:=$inventoryUnit.name
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
		
		If (Form:C1466.readOnly)
			// Visu mode: keep dialog informational only.
			OBJECT SET ENABLED:C1123(*; "Input"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input3"; False:C215)
			OBJECT SET ENABLED:C1123(*; "fld_classification"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input7"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input4"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input6"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input9"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input10"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input5"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Input13"; False:C215)
			OBJECT SET ENABLED:C1123(*; "pup_binLocation"; False:C215)
			OBJECT SET ENABLED:C1123(*; "btnDatePicker_dateIn"; False:C215)
			OBJECT SET ENABLED:C1123(*; "btnDatePicker_expirationDate"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Button1"; False:C215)
		End if 
		
End case 
