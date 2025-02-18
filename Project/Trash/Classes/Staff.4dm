Class extends DataClass



local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("staff"; "teamManagment"; "Staff")
	$entry.setDataclass("Staff")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/staff-50x50.png")
	
	$entry.setSearchboxField("firstName")
	$entry.setSearchboxField("lastName")
	$entry.setSearchboxField("contactDetails.addresses[].detail.city"; "placeholder:city")
	
	$entry.setPanel("panel_staff")
	$entry.setPanelPage(1; "biography-24x24.png"; "skills")
	$entry.setPanelPage(4; "contract-32x32.png"; "contracts")
	$entry.setPanelPage(5; "project-32x32.png"; "projects")
	$entry.setPanelPage(2; "address-32x32.png"; "address")
	$entry.setPanelPage(3; "description-32x32.png"; "resume")
	$entry.setPanelPage(6; "holidays-32x32.png"; "planning")
	$entry.setPanelPage(7; "sfw/image/skin/rainbow/btn4states/meeting-24x24.png"; "meetings")
	$entry.setPanelPage(8; "sfw/image/skin/rainbow/btn4states/settings-24x24.png"; "settings"; "allowedProfiles:admin")
	
	$entry.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("department.company.country.iso_code_2"; " "; "type:flag"; "width:30"; "orderByFormula:this.department.country.iso_code_2")
	$entry.setLBItemsColumn("department.name"; "Department"; "xliff:entry.department.field.name"; "width:160"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("userIcon"; ""; "type:picture"; "width:10")
	
	$entry.setLBItemsOrderBy("firstName")
	$entry.setLBItemsOrderBy("lastName")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:employee"; "unitN:employees")
	$entry.setLBItemsMetaExpression("this.metaViewAllEmployees")
	$entry.setMainViewLabel("All employees")
	
	$entry.setAddable()
	
	//$entry.setItemAction("alert"; "Customer_alertAction"; "allowedProfiles:admin")
	
	$entry.enableTransaction()
	
	$entry.setValidationRule("firstName"; "entryField_firstName"; "mandatory"; "trimSpace"; "capitalize"; "message:The first name is mandatory")
	$entry.setValidationRule("lastName"; "entryField_lastName"; "mandatory"; "trimSpace"; "capitalize"; "message:The last name is mandatory")
	$entry.setValidationRule("UUID_Department"; ""; "UUIDNotNull"; "message:The department must be defined")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setLinkedReferenceRecordsDataclasses("skills"; "skills.role"; "department"; "holidays")
	
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Capitalize the names"; "Staff_capitalize_all"; "allowedProfiles:admin")
	$entry.setItemListAction("Generate the email addresses"; "Staff_generateEmails_all"; "allowedProfiles:admin")
	$entry.setItemListAction("Connect Staff to Users"; "Staff_connectToUser_all"; "allowedProfiles:admin")
	
	$view:=cs:C1710.sfw_definitionView.new("staffWithoutDepartment"; "Without department")
	$view.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("contactDetails.addresses[0].detail.city"; "City"; "xliff:address.city"; "orderByFormula:this.contactDetails.addresses[0].detail.city"; "headerLeft"; "headerStroke:midnightblue"; "group:city")
	$view.setLBItemsColumn("contactDetails.addresses[0].detail.country"; "Country"; "xliff:aMacintosh HD:Applications:4D:4D v20:20R8:100161:4D 20R8 100161.app:ddress.country"; "orderByFormula:this.contactDetails.addresses[0].detail.country"; "headerLeft"; "headerStroke:midnightblue"; "group:city")
	$view.setLBItemsOrderBy("lastName")
	$view.setLBItemsOrderBy("firstName")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:employee"; "unitN:employees")
	$view.setSubset("staffWithoutDepartment")
	$view.setPictoLabel("/RESOURCES/kairos/image/picto/exclamation-diamond.png")
	$entry.setView($view)
	
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCompany")
	$filter.setDefaultTitle("All companies")
	$filter.setFilterByLinkedEntity("Company"; "department.UUID_Company"; "uuidCompany"; "department.company")
	$filter.setDynamicTitle("name"; "## companies")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterDepartment")
	$filter.setDefaultTitle("All departments")
	$filter.setFilterByLinkedEntity("Department"; "UUID_Department"; ""; "department")
	$filter.setDynamicTitle("name"; "## departments")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterRole")
	$filter.setDefaultTitle("All skills")
	$filter.setFilterByManyToManyEntity("Role"; "name"; "skills.role")
	$filter.setDynamicTitle("name"; "## roles")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	
	$entry.activateFavorite()
	$entry.activateComment()
	
	$entry.activateEvent("StaffEvent"; "UUID_Staff")
	$entry.setAttributesToTrackInModificationEvent("firstName"; "lastName")
	$entry.setLinkManyToOneToTrackInModificationEvent("department"; "UUID_Department"; "department.name")
	$entry.setEventOptions("dontCreateModifyEventIfNoTrackingAttribute")
	
	$entry.setAllowedProfilesForCreation("admin")
	$entry.setAllowedProfilesForDeletion("admin")
	
	$entry.setPanelIfNoItemSelected("panel_staff_summary")
	
	//mark:-Subsets for views
Function staffWithoutDepartment()->$es : cs:C1710.StaffSelection
	
	$es:=This:C1470.query("department = null")
	
local Function buildMenuByLetters($refMenus : Collection; $uuidStaffToInactivate : Collection)->$refMenu : Text
	var $mySelf : cs:C1710.StaffEntity
	var $eFavorite : cs:C1710.sfw_FavoriteEntity
	var $esFavorites : cs:C1710.sfw_FavoriteSelection
	var $cStaffs : Collection:=ds:C1482.Staff.all().extract("UUID"; "UUID"; "fullName"; "fullName"; "firstName"; "firstName")
	var $letters : Collection:=Split string:C1554("abcdefghijklmnopqrstuvwxyz"; "")
	
	$refMenu:=Create menu:C408
	$refMenus.push($refMenu)
	// mySelf
	$mySelf:=ds:C1482.Staff.query("UUID_User = :1"; cs:C1710.sfw_userManager.me.info.UUID).first()
	If ($mySelf#Null:C1517)
		APPEND MENU ITEM:C411($refMenu; "Myself"; *)
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "Staff:"+$mySelf.UUID)
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/picto/user.png")
		If ($uuidStaffToInactivate#Null:C1517) && ($uuidStaffToInactivate.indexOf($mySelf.UUID)#-1)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		APPEND MENU ITEM:C411($refMenu; "-")
	End if 
	// favorite
	If (cs:C1710.sfw_userManager.me.info.UUID=("00"*16))
		$esFavorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1"; Form:C1466.sfw.entry.ident)
	Else 
		$esFavorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1 and UUID_User = :2"; "staff"; cs:C1710.sfw_userManager.me.info.UUID)
	End if 
	If ($esFavorites.length>0)
		For each ($eFavorite; $esFavorites)
			$staff:=$cStaffs.query("UUID = :1"; $eFavorite.UUID_target).first()
			APPEND MENU ITEM:C411($refMenu; $staff.fullName; *)
			SET MENU ITEM PARAMETER:C1004($refMenu; -1; "Staff:"+$staff.UUID)
			SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/picto/star.png")
			If ($uuidStaffToInactivate#Null:C1517) && ($uuidStaffToInactivate.indexOf($staff.UUID)#-1)
				DISABLE MENU ITEM:C150($refMenu; -1)
			End if 
		End for each 
		APPEND MENU ITEM:C411($refMenu; "-")
	End if 
	// all staff
	For each ($letter; $letters)
		$staffs:=$cStaffs.query("firstName = :1"; $letter+"@").orderBy("fullName")
		If ($staffs.length>0)
			$refMenuLetter:=Create menu:C408
			$refMenus.push($refMenuLetter)
			For each ($staff; $staffs)
				APPEND MENU ITEM:C411($refMenuLetter; $staff.fullName; *)
				SET MENU ITEM PARAMETER:C1004($refMenuLetter; -1; "Staff:"+$staff.UUID)
				SET MENU ITEM ICON:C984($refMenuLetter; -1; "Path:/RESOURCES/sfw/image/picto/user.png")
				If ($uuidStaffToInactivate#Null:C1517) && ($uuidStaffToInactivate.indexOf($staff.UUID)#-1)
					DISABLE MENU ITEM:C150($refMenuLetter; -1)
				End if 
			End for each 
			APPEND MENU ITEM:C411($refMenu; Uppercase:C13($letter); $refMenuLetter; *)
			
		End if 
	End for each 
	
	
	
Function extractOnServer( ...  : Text)->$extraction : Collection
	
	$params:=New collection:C1472
	For ($p; 1; Count parameters:C259)
		$params.push(${$p})
	End for 
	
	$extraction:=This:C1470.extract.apply(Null:C1517; $params)