Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
	
local Function drowPup($dataClass; $queryField; $queryValue; $pupName)
	
	$entity:=ds:C1482[$dataClass].query($queryField+" =:1"; Form:C1466.current_item[$queryValue]).first() || New object:C1471()
	$name:=$entity.name
	If ($name=Null:C1517)
		$name:=""
	End if 
	If (Not:C34(Undefined:C82($entity.color)))
		$color:=cs:C1710.sfw_htmlColor.me.getName($entity.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
	Else 
		$pathIcon:=""
	End if 
	Form:C1466.sfw.drawButtonPup($pupName; $name; $pathIcon; ($entity=Null:C1517))
	
	
local Function pup($cacheCollection; $dataClass; $queryField; $queryValue)
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache[$cacheCollection]=Null:C1517)
			ds:C1482[$dataClass].cacheLoad()
		End if 
		
		For each ($eEntity; Storage:C1525.cache[$cacheCollection])
			
			// Purpose: Exclude the current account from the parent-account picker (no self-reference).
			// modified by 4D/PS [2026-may-19]
			If (Not:C34(($cacheCollection="parentAccounts") & (Form:C1466.current_item#Null:C1517) & ($eEntity.UUID=Form:C1466.current_item.UUID)))
				
				If ($cacheCollection="parentAccounts")
					$menuLabel:=$eEntity.accountNumber
					If ($eEntity.name#"")
						$menuLabel:=$menuLabel+" - "+$eEntity.name
					End if 
				Else 
					$menuLabel:=$eEntity.name
				End if 
				
				APPEND MENU ITEM:C411($menu; $menuLabel; *)
				SET MENU ITEM PARAMETER:C1004($menu; -1; $eEntity.UUID)
				If ($queryField="UUID")  //# TO BE REMOVED
					
					If ($eEntity[$queryField]=Form:C1466.current_item[$queryValue])
						SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
						If (Is Windows:C1573)
							SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
						End if 
					End if 
				Else 
					
					If (Num:C11($eEntity[$queryField])=Form:C1466.current_item[$queryValue])
						SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
						If (Is Windows:C1573)
							SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
						End if 
					End if 
					
				End if 
				
			End if 
			
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$eEntity:=ds:C1482[$dataClass].get($choose)
				Form:C1466.current_item[$queryValue]:=$eEntity[$queryField]
		End case 
		
	End if

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// created by 4D/PS [2026-june-23]
local Function loadAfterCreation()
	// Purpose: Assign a unique barcode in moreData for scanner lookup on new records.
	// modified by 4D/PS [2026-june-23]
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")
