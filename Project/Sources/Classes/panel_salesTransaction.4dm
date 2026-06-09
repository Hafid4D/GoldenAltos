// Purpose: Panel controller for Received Transactions (AR sub-ledger entry GA3-T398).
// created by 4D/PS [2026-june-08]
singleton Class constructor

Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
	End if
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of
			: (FORM Get current page:C276(*)=1)
		End case
	End if
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if

Function redrawAndSetVisible()
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	This:C1470.drawPup_customer()
	This:C1470.drawPup_type()
	This:C1470.drawPup_status()

Function selectCustomer()
	If (Form:C1466.sfw.checkIsInModification())
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorCustomers"; "customer")
		$selector.setTitle("Choose a Customer")
		$selector.setCurrentItem(Form:C1466.current_item.customer)
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		Case of
			: ($selector.isSelected())
				$itemSeleted:=$selector.getCurrentItem()
				Case of
					: ($itemSeleted=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)=False:C215)
						Form:C1466.current_item.UUID_Customer:=$itemSeleted.UUID
						If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Customer)=True:C214)
							Form:C1466.current_item.UUID_Customer:=16*"00"
						End if
				End case
				This:C1470.drawPup_customer()
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_Customer:=16*"00"
				This:C1470.drawPup_customer()
			: ($selector.needCreation())
				$selector.createANewEntity("cs.panel_lead.me.callbackAfterCreationCustomer($1)")
		End case
	End if

Function drawPup_customer()
	If (Form:C1466.current_item#Null:C1517)
		$name:=Form:C1466.current_item.customer.name || " "
		Form:C1466.sfw.drawButtonPup("pup_customer"; $name; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.customer=Null:C1517))
	End if

Function pup_type()
	var $eType : cs:C1710.TransactionTypeEntity
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.transactionType=Null:C1517)
			ds:C1482.TransactionType.cacheLoad()
		End if
		For each ($eType; Storage:C1525.cache.transactionType)
			APPEND MENU ITEM:C411($menu; $eType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eType.UUID)
			If ($eType.UUID=Form:C1466.current_item.UUID_TransactionType)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if
			End if
		End for each
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		Case of
			: ($choose#"")
				$eType:=ds:C1482.TransactionType.get($choose)
				Form:C1466.current_item.UUID_TransactionType:=$eType.UUID
				Form:C1466.current_item.applyTypeAmountSign($eType.code)
		End case
	End if
	This:C1470.drawPup_type()

Function drawPup_type()
	If (Form:C1466.current_item#Null:C1517)
		$eType:=Form:C1466.current_item.transactionType || New object:C1471
		$label:=$eType.name || "Type"
		$color:=cs:C1710.sfw_htmlColor.me.getName($eType.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_type"; $label; $pathIcon; ($eType=Null:C1517))
	End if

Function pup_status()
	var $eStatus : cs:C1710.TransactionStatusEntity
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.transactionStatus=Null:C1517)
			ds:C1482.TransactionStatus.cacheLoad()
		End if
		For each ($eStatus; Storage:C1525.cache.transactionStatus)
			APPEND MENU ITEM:C411($menu; $eStatus.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eStatus.UUID)
			If ($eStatus.UUID=Form:C1466.current_item.UUID_TransactionStatus)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if
			End if
		End for each
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		Case of
			: ($choose#"")
				$eStatus:=ds:C1482.TransactionStatus.get($choose)
				Form:C1466.current_item.UUID_TransactionStatus:=$eStatus.UUID
		End case
	End if
	This:C1470.drawPup_status()

Function drawPup_status()
	If (Form:C1466.current_item#Null:C1517)
		$eStatus:=Form:C1466.current_item.status || New object:C1471
		$label:=$eStatus.name || "Status"
		$color:=cs:C1710.sfw_htmlColor.me.getName($eStatus.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_status"; $label; $pathIcon; ($eStatus=Null:C1517))
	End if

Function btnOpenCustomer()
	Case of
		: (FORM Event:C1606.code=On Clicked:K2:4)
			If (Form:C1466.current_item#Null:C1517) && (Form:C1466.current_item.customer#Null:C1517)
				cs:C1710.sfw_entry.me.open("Customer"; Form:C1466.current_item.customer)
			End if
		: (FORM Event:C1606.code=On Mouse Enter:K2:33)
			SET CURSOR:C469(Choose:C955(OBJECT Get enabled:C1079(Self:C308->); 9000; 9019))
		: (FORM Event:C1606.code=On Mouse Leave:K2:34)
			SET CURSOR:C469()
	End case
