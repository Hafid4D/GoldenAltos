

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : CAO
	$entry:=cs:C1710.sfw_definitionEntry.new("CAO"; ["accounting"]; "CAOs"; "CAO")
	$entry.setDataclass("CAO")
	$entry.setDisplayOrder(-100)
	$entry.setIcon("image/entry/charOfAccount-white-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_CAO"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	//$entry.setLBItemsColumn("dateCreated"; "Created"; "width:100")
	// Purpose: Show legacy GLAC in the item list.
	// modified by 4D/PS [2026-may-19]
	$entry.setLBItemsColumn("accountNumber"; "Account #"; "width:80")
	//$entry.setLBItemsColumn("name"; "Name"; "width:150")
	$entry.setLBItemsColumn("type.name"; "Type"; "width:150")
	//$entry.setLBItemsColumn("typeDetail.name"; "Type Detail"; "width:100")
	$entry.setLBItemsColumn("balance"; "Balance"; "width:50")
	
	$entry.setSubset("activeCAOs")
	$entry.setLBItemsOrderBy("name")
	$entry.setMainViewLabel("All Actives Account")
	
	$entry.setItemListAction("Print Chart Of Account List"; "_ga_printCAOSelection")
	$entry.setItemListAction("Export Chart Of Account List"; "_ga_exportCAOSelection")
	
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	
	
	// MARK: -Views
	$view:=cs:C1710.sfw_definitionView.new("inactiveCAOs"; "Inactive Accounts"; "derivedFrom:main"; $entry)
	$view.setSubset("inactiveCAOs")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/caos-16x16.png")
	$entry.setView($view)
	
	
Function activeCAOs()->$caos : cs:C1710.CAOSelection
	$caos:=ds:C1482.CAO.query("isInacActive =:1 "; False:C215)
	
	
Function inactiveCAOs()->$caos : cs:C1710.CAOSelection
	$caos:=ds:C1482.CAO.query("isInacActive =:1 "; True:C214)

// Purpose: Return active CAO rows of type Bank for deposit bank-account pickers (mockup / QuickBooks-style).
// Returns: cs.CAOSelection — empty when no Bank-type accounts are configured
// created by 4D/PS [2026-june-29]
Function getActiveBankAccounts()->$caos : cs:C1710.CAOSelection
	$caos:=This:C1470.query("type.name = :1 AND isInacActive = :2"; "Bank"; False:C215)
	
// Purpose: Resolve a system GL account by legacy DefaultKey (e.g. DefaultA/R).
// Parameters: $defaultKey : Text — legacy CHART_OF_AC.DefaultKey value
// Returns: cs.CAOEntity or Null when not found
// created by 4D/PS [2026-june-26]
Function getByDefaultKey($defaultKey : Text)->$eCao : cs:C1710.CAOEntity
	$eCao:=Null:C1517
	If ($defaultKey#"")
		$eCao:=This:C1470.query("defaultKey = :1 AND isInacActive = :2"; $defaultKey; False:C215).first()
	End if

// Purpose: Resolve undeposited funds account (QuickBooks-style receive payment clearing).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-26]
Function getUndepositedFunds()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultClearingAccount")
	If ($eCao=Null:C1517)
		$eCao:=This:C1470.query("accountNumber = :1 AND isInacActive = :2"; "1030-0"; False:C215).first()
	End if

// Purpose: Resolve default accounts receivable control account.
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-26]
Function getDefaultAR()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultA/R")

// Purpose: Resolve default sales income account (legacy DefaultSales).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultSales()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultSales")

// Purpose: Resolve default sales tax payable account (legacy DefaultSalesTaxPayable).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultSalesTax()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultSalesTaxPayable")

// Purpose: Resolve default credit memos account (legacy DefaultCreditMemos).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultCreditMemos()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultCreditMemos")

// Purpose: Resolve default accounts payable control account (legacy DefaultA/P).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultAP()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultA/P")

// Purpose: Resolve default purchase discount income account (legacy DefaultDisountIncome spelling).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultDiscountIncome()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultDisountIncome")

// Purpose: Resolve default purchases expense account when a bill line has no GL account (legacy DefaultPurchases).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultPurchases()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultPurchases")

// Purpose: Resolve default vendor bill credits account (legacy DefaultBillCredits).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function getDefaultBillCredits()->$eCao : cs:C1710.CAOEntity
	$eCao:=This:C1470.getByDefaultKey("DefaultBillCredits")
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.parentAccounts=Null:C1517)
		$parentAccounts:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.parentAccounts:=$parentAccounts.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
Function _loadAsCollection()->$parentAccounts : cs:C1710.CAOSelection
	// Purpose: Load all active accounts for the parent-account popup cache.
	// Returns: Collection of { UUID, name, accountNumber, description } ordered by accountNumber.
	// modified by 4D/PS [2026-may-19]
	$parentAccounts:=ds:C1482.CAO.query("isInacActive = :1"; False:C215).orderBy("accountNumber")
	
	
	