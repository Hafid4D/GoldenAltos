Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("dfdPicture"; "dfd"; "Pictures"; "Picture")
	$entry.setDataclass("dfd_Picture")
	$entry.setDisplayOrder(0)
	$entry.setIcon("dfd/image/entry/dfd_Picture-50x50.png")
	
	$entry.setSearchboxField("name")
	
	
	$entry.setPanel("dfd_panel_picture"; 2)
	$entry.setPanelPage(1; ""; "Definition")
	
	
	$entry.setLBItemsColumn("name"; "Name")
	
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:picture"; "unitN:pictures")
	$entry.setMainViewLabel("All pictures")
	
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	
	
	$entry.setAllowedProfiles(cs:C1710.sfw_globalParameters.me.dfd.entryPicture.allowedProfiles || "admin")
	$entry.setAllowedProfilesForCreation(cs:C1710.sfw_globalParameters.me.dfd.entryPicture.allowedProfilesForCreation || "admin")
	$entry.setAllowedProfilesForDeletion(cs:C1710.sfw_globalParameters.me.dfd.entryPicture.allowedProfilesForDeletion || "admin")
	$entry.setAllowedProfilesForModification(cs:C1710.sfw_globalParameters.me.dfd.entryPicture.allowedProfilesForModification || "admin")
	