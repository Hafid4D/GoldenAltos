
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Asset
	$entry:=cs:C1710.sfw_definitionEntry.new("Asset"; ["accounting"]; "Assets"; "Asset")
	$entry.setDataclass("Asset")
	$entry.setDisplayOrder(-200)
	$entry.setIcon("image/entry/asset-white-50x50.png")
	
	$entry.setSearchboxField("assetNumber")
	
	$entry.setPanel("panel_asset"; 1)
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Deprecation History")
	$entry.setSubset("main")
	
	$entry.setLBItemsColumn("assetNumber"; "Asset #"; "width:50")
	$entry.setLBItemsColumn("assetType.name"; "Type"; "width:120")
	$entry.setLBItemsColumn("description"; "Description"; "width:200")
	$entry.setLBItemsColumn("originalCost"; "Original Cost"; "width:100")
	
	$entry.setLBItemsOrderBy("assetNumber")
	$entry.setMainViewLabel("All assets")
	
	// Purpose: Item actions — operate on the currently open record (Form.current_item).
	// modified by 4D/PS [2026-june-01]
	$entry.setItemAction("View Depreciation History"; "_ga_viewDepreciationHistory")
	$entry.setItemAction("Run Manual Depreciation"; "_ga_runManualDepreciationCurrentItem")
	$entry.setItemAction("Toggle Automatic Depreciation"; "_ga_activateAutomatiqueDepreciationCurrentItem")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	
	// Purpose: List actions — batch operations on the whole view/list (Form.sfw.lb_items).
	// modified by 4D/PS [2026-june-01]
	$entry.setItemListAction("Run Manual Depreciation (Batch)"; "_ga_runManualDepreciation")
	$entry.setItemListAction("Activate Automatic Depreciation (Batch)"; "_ga_activateAutomatiqueDepreciation")
	$entry.setItemListAction("Print Asset List"; "_ga_printAssetSelection")
	$entry.setItemListAction("Export Asset List"; "_ga_exportAssetSelection")
	
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	
	
	// MARK: -Views
	
	$view:=cs:C1710.sfw_definitionView.new("fullyDepreciatedAssets"; "Assets fully Depreciated [Not Archived]"; "derivedFrom:main"; $entry)
	$view.setSubset("fullyDepreciatedAssets")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/assets-16x16.png")
	$entry.setView($view)
	
	
	$view:=cs:C1710.sfw_definitionView.new("archivedorScrappedAssets"; "Archived or Scrapped Assets"; "derivedFrom:main"; $entry)
	$view.setSubset("archivedorScrappedAssets")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/assets-16x16.png")
	$entry.setView($view)
	
Function main()->$assets : cs:C1710.AssetSelection
	// Purpose: Active assets still depreciating (not scrapped, not fully depreciated).
	// Returns: cs.AssetSelection
	// modified by 4D/PS [2026-may-19]
	$assets:=ds:C1482.Asset.newSelection()
	For each ($eAsset; ds:C1482.Asset.query("isScrapped = :1"; False:C215))
		If (Not:C34($eAsset.excludeFmDepreciationList)) & (($eAsset.life=0) | ($eAsset.monthInService<$eAsset.life))
			$assets:=$assets.add($eAsset)
		End if 
	End for each 
	
Function fullyDepreciatedAssets()->$assets : cs:C1710.AssetSelection
	// Purpose: Fully depreciated assets kept on the list until scrapped/archived.
	// Returns: cs.AssetSelection
	// modified by 4D/PS [2026-may-19]
	$assets:=ds:C1482.Asset.newSelection()
	For each ($eAsset; ds:C1482.Asset.query("isScrapped = :1"; False:C215))
		If ($eAsset.excludeFmDepreciationList) | (($eAsset.life>0) & ($eAsset.monthInService>=$eAsset.life))
			$assets:=$assets.add($eAsset)
		End if 
	End for each 
	
Function archivedorScrappedAssets()->$assets : cs:C1710.AssetSelection
	// Purpose: Scrapped / archived assets (legacy Scrapped flag).
	// Returns: cs.AssetSelection
	// modified by 4D/PS [2026-may-19]
	$assets:=ds:C1482.Asset.query("isScrapped = :1"; True:C214)
	
	
	
	