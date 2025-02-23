Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("setting"; "administration"; "Settings")
	$entry.setDataclass("sfw_Setting")
	$entry.setDisplayOrder(-10000)
	$entry.setIcon("image/entry/settings-50x50.png")
	$entry.setSearchboxField("ident")
	$entry.setSearchboxField("name")
	$entry.setPanel("sfw_panel_setting"; 2)
	
	
	$entry.setValidationRule("ident"; "entryField_ident"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$view:=cs:C1710.sfw_definitionView.new("allVisibleSettings"; "All visible settings")
	$view.setLBItemsColumn("ident"; "Identifier"; "width:100")
	$view.setLBItemsColumn("name"; "Name"; "width:200")
	$view.setLBItemsOrderBy("ident")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:setting"; "unitN:settings")
	$view.setSubset("allVisibleSettings")
	$entry.setView($view)
	
	
Function allVisibleSettings()->$es : cs:C1710.sfw_SettingSelection
	
	$es:=This:C1470.query("data.hidden = null or data.hidden = :1"; False:C215)
	