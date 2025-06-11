

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET TITLE:C194(*; "pup_docTypes"; String:C10(Form:C1466.code))
		
	: (Form event code:C388=On Clicked:K2:4)
		//var $hList; $hSousList : Integer
		var $hListItems : Collection
		var $hSousListItems : Collection
		$hListItems:=New collection:C1472("DocTypeChecks"; "DocTypeDeposits"; "DocTypeEquipment"; "DocTypeJob")
		$hSousListItems:=New collection:C1472(New collection:C1472("CKD Check Disbursed"); New collection:C1472("CKR Check Received"); New collection:C1472("CAL Calibration Data"); New collection:C1472("IN Customer Job-Instructions"; "RPT Reports"))
		$hList:=Create menu:C408
		
		
		$hListItemsLength:=$hListItems.length
		$k:=1
		For ($i; 0; $hListItemsLength-1)
			
			$hSousListItemsLength:=$hSousListItems[$i].length
			$hSousList:=Create menu:C408
			
			For ($j; 0; $hSousListItemsLength-1)
				
				APPEND MENU ITEM:C411($hSousList; $hSousListItems[$i][$j]; *)
				SET MENU ITEM PARAMETER:C1004($hSousList; -1; $hSousListItems[$i][$j])
			End for 
			
			APPEND MENU ITEM:C411($hList; $hListItems[$i]; $hSousList; *)
			$k:=$k+1
		End for 
		
		$choose:=Dynamic pop up menu:C1006($hList)
		RELEASE MENU:C978($hList)
		Case of 
			: ($choose#"")
				OBJECT SET TITLE:C194(*; "pup_docTypes"; $choose)
				Form:C1466.code:=$choose
		End case 
		
End case 