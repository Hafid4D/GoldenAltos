Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("lots"; ["customerService"]; "Lots"; "Lot")
	$entry.setDataclass("Lot")
	$entry.setDisplayOrder(-300)
	$entry.setIcon("image/entry/lots-white-50x50.png")
	
	$entry.setSearchboxField("lotNumber")
	
	
	$entry.setPanel("panel_lot")
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Main")
	$entry.setPanelPage(2; "lot-steps-32x32.png"; "Lot Steps")
	$entry.setPanelPage(3; ""; "Customer Provided Material")
	
	
	$entry.setLBItemsColumn("lotNumber"; "Lot #"; "width:100")
	$entry.setLBItemsColumn("device"; "Device"; "width:200")
	$entry.setLBItemsColumn("dateIn"; "Date IN"; "width:75"; "center")
	$entry.setLBItemsColumn("dateOut"; "Date OUT"; "width:75"; "center")
	
	$view:=cs:C1710.sfw_definitionView.new("readyToShip"; "Lots Ready to Ship"; "derivedFrom:main"; $entry)
	$view.setSubset("readyToShip")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/terminated-user-16x16.png")
	$entry.setView($view)
	
	$entry.setLBItemsOrderBy("lotNumber")
	
	$entry.setItemAction("Split Lot"; "lot_split")
	
	$entry.enableTransaction()
	
Function onlyPunchIn()->$punchIN_es : cs:C1710.LotStepSelection
	$punchIN_es:=ds:C1482.Lot.query("steps.qtyIn = :1 AND steps.qtyOut = :1 AND steps.dateIn = :2 AND steps.dateOut = :2"; 0; !00-00-00!).orderBy("lotNumber asc")
	
Function readyToShip()->$lots : cs:C1710.LotSelection
	$lots:=ds:C1482.Lot.query("dateOut = :1 AND readyToShipDate # :1"; !00-00-00!)
	[Lot:118]readyToShipDate:30
	