Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("user"; "userManagement"; "Users")
	//$entry.setXliffLabel("entry.users")
	$entry.setDataclass("sfw_User")
	$entry.setIcon("sfw/entry/users-50x50.png")
	//$entry.setDisplayOrder(-1000)
	$entry.setSearchboxField("firstName")
	$entry.setSearchboxField("lastName")
	$entry.setSearchboxField("login")
	$entry.setPanel("sfw_panel_user")
	$entry.setPanelPage(1; "address-32x32.png"; "Profiles")
	$entry.setLBItemsColumn("firstName"; "First name")
	$entry.setLBItemsColumn("lastName"; "Last name")
	$entry.setLBItemsColumn("login"; "Login")
	$entry.setLBItemsOrderBy("firstName")
	$entry.setLBItemsOrderBy("lastName")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:user"; "unitN:users")
	
	$entry.setValidationRule("firstName"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("lastName"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("login"; "entryField_name"; "unique"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setLinkedReferenceRecordsDataclasses("userInscriptions"; "userInscriptions.userProfile"; "iuserInscriptionsGiven")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Capitalize the names"; "sfw_User_capitalize_all")
	
	$entry.enableTransaction()
	
	
	
Function getActiveUsers()->$esUsers : cs:C1710.sfw_UserSelection
	var $eRelated : 4D:C1709.Entity
	
	$esUsers:=ds:C1482.sfw_User.newSelection()
	
	For each ($eUser; ds:C1482.sfw_User.query("isInactive != True"))
		Try
			$eRelated:=ds:C1482[cs:C1710.sfw_definition.me.globalParameters.users.linkedDataclass].query("UUID_User = :1"; $eUser.UUID).first()
			If ($eRelated#Null:C1517)
				$esUsers.add($eUser)
			End if 
		Catch
			
		End try
		
		
	End for each 
	