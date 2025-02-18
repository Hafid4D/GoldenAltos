Class extends Entity

// MARK: -nameInWizard

Function get companyNameInWizard()->$name : Text
	$name:=This:C1470.customer.company.nameInWizard
	
Function get customerNameInWizard()->$name : Text
	$name:=This:C1470.customer.nameInWizard
	
Function get nameInWizard()->$name : Text
	$name:="📦 "+This:C1470.name
	
	//mark:-
	
Function get serviceTypeName()->$name : Text
	$name:=This:C1470.serviceType.name
	
Function get serviceTypeColorPicture()->$picture : Picture
	$picture:=This:C1470.serviceType.colorPicture
	
	//mark:-
	
Function get sales()->$sales : Text
	var $teamMemberSales : cs:C1710.TeamMemberEntity
	
	$teamMemberSales:=This:C1470.teamMembers.query("role.code == :1"; "SAL").first()
	If ($teamMemberSales#Null:C1517)
		$sales:=$teamMemberSales.staff.fullName
	End if 
	
Function get pm()->$pm : Text
	var $teamMemberPM : cs:C1710.TeamMemberEntity
	
	$teamMemberPM:=This:C1470.teamMembers.query("role.code == :1"; "PMG").first()
	If ($teamMemberPM#Null:C1517)
		$pm:=$teamMemberPM.staff.fullName
	End if 
	
Function get meta()->$meta : Object
	var $eProjectStatus : cs:C1710.ProjectStatusEntity
	$meta:=New object:C1471
	$meta.cell:=New object:C1471
	$meta.cell.columnService:=New object:C1471
	$meta.cell.columnService.fill:=This:C1470.serviceType.color
	$lum:=cs:C1710.sfw_htmlColor.me.getLuminence(This:C1470.serviceType.color)
	If ($lum>=0.5)
		$meta.cell.columnService.stroke:="black"
	Else 
		$meta.cell.columnService.stroke:="white"
	End if 
	$meta.cell.columnStatus:=New object:C1471
	$eProjectStatus:=ds:C1482.ProjectStatus.query("statusID = :1"; Num:C11(This:C1470.currentStatusID)).first()
	$meta.cell.columnStatus.fill:=$eProjectStatus.color || "white"
	$lum:=cs:C1710.sfw_htmlColor.me.getLuminence($eProjectStatus.color || "white")
	If ($lum>=0.5)
		$meta.cell.columnStatus.stroke:="black"
	Else 
		$meta.cell.columnStatus.stroke:="white"
	End if 
	
local Function get dateStart()->$dateStart : Date
	$dateStart:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStartWork; True:C214)
	
local Function set dateStart($dateStart : Date)
	This:C1470.stmpStartWork:=cs:C1710.sfw_stmp.me.build($dateStart)
	
local Function getdateCreation()->$creationDate : Date
	$entry:=cs:C1710.sfw_definition.me.getEntryByIdent("project")
	$eEvent:=cs:C1710.sfw_eventManager.me.getEvent($entry; "createRecord"; This:C1470.UUID)
	If ($eEvent#Null:C1517)
		$creationDate:=cs:C1710.sfw_stmp.me.getDate($eEvent.stmp)
	End if 
	
	//local Function calculateCode()->$projectCode : Text
	//If (This.projectNo=0)
	//This.projectNo:=ds.sfw_Counter.getNextValue("projectCode")
	//End if 
	//$projectCode:=Substring(String(Year of(This.dateCreation)); 3; 2)+"_"
	//$projectCode+=This.company.country.iso_code_2+"_"
	//$projectCode+=String(This.projectNo; "0000")
	
	
local Function calculateCodeV1()->$projectCode : Text
	//If (This.projectNo=0)
	//This.projectNo:=ds.sfw_Counter.getNextValue("projectCode")
	//End if 
	
	$result:=Position:C15("_"; This:C1470.name)
	$projectNo:=Substring:C12(This:C1470.name; $result)
	
	$projectCode:=Substring:C12(String:C10(Year of:C25(This:C1470.dateStart)); 3; 2)+"_"
	$projectCode+=This:C1470.company.country.iso_code_2+"_"
	$projectCode+=String:C10($projectNo; "0000")
	
	
	
Function get currentStatus()->$status : Text
	var $eProjectStatus : cs:C1710.ProjectStatusEntity
	$eProjectStatus:=ds:C1482.ProjectStatus.query("statusID = :1"; Num:C11(This:C1470.currentStatusID)).first()
	$status:=$eProjectStatus.code || "-"
	
	//Mark:-Callbacks
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
	
local Function beforeSaveCreation()
	// This callback is called before saving the new item
	If (This:C1470.dateCreation=!00-00-00!)
		$entry:=cs:C1710.sfw_definition.me.getEntryByIdent("project")
		cs:C1710.sfw_eventManager.me.addEvent($entry; "createRecord"; This:C1470.UUID)
	End if 
	
	// Création du code projet
	This:C1470.code:=This:C1470.calculateCodeV1()
	This:C1470._saveBufferOfEvents(Form:C1466.subForm.bufferOfEvents)
	
local Function beforeSave()
	// This callback is called before saving the item in the itemList
	
	If (Form:C1466.subForm.bufferOfEvents#Null:C1517) && (Form:C1466.subForm.bufferOfEvents.length>0)
		This:C1470._saveBufferOfEvents(Form:C1466.subForm.bufferOfEvents)
		Form:C1466.subForm.bufferOfEvents:=New collection:C1472
	End if 
	
	
Function _saveBufferOfEvents($bufferOfEvents : Collection)
	For each ($buffer; $bufferOfEvents)
		$moreData:=New object:C1471
		$moreData.comment:=$buffer.label
		cs:C1710.sfw_eventManager.me.addEvent(Form:C1466.sfw.entry; $buffer.event; This:C1470.UUID; $moreData; $buffer.stmp)
	End for each 
	
	
local Function duplicateRecord()
	var $ePhase; $eNewPhase : cs:C1710.PhaseEntity
	var $eLot; $eNewLot : cs:C1710.LotEntity
	var $eTask; $eNewTask : cs:C1710.TaskEntity
	
	Form:C1466.current_item.name+=" (copy)"
	ds:C1482.duplicatePhasesLotsTasksForProjectOrTemplate(Form:C1466.original_item.UUID; Form:C1466.current_item.UUID; "UUID_Project"; "UUID_Project")
	
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	If (This:C1470.moreData=Null:C1517)
		This:C1470.moreData:=New object:C1471
	End if 
	
	If (Form:C1466.current_item.code="") && (Form:C1466.current_item#Null:C1517) && (Form:C1466.situation.mode#"add")
		Case of 
			: (Form:C1466.sfw.checkIsInModification()=False:C215)
				
			: (This:C1470.dateCreation#!00-00-00!)
				
			: (This:C1470.dateCreation=!00-00-00!) && (This:C1470.stmpStartWork#0)
				//$entry:=cs.sfw_definition.me.getEntryByIdent("project")
				$entry:=Form:C1466.sfw.entry
				cs:C1710.sfw_eventManager.me.addEvent($entry; "createRecord"; This:C1470.UUID; New object:C1471; This:C1470.stmpStartWork)
			Else 
				
				$answer:=cs:C1710.sfw_dialog.me.request("What is the starting date of the project "+Form:C1466.current_item.customer.name+" / "+Form:C1466.current_item.name+"?"; String:C10(Current date:C33))
				If ($answer.ok)
					Form:C1466.current_item.dateStart:=Date:C102($answer.answer)
					$entry:=Form:C1466.sfw.entry
					cs:C1710.sfw_eventManager.me.addEvent($entry; "createRecord"; This:C1470.UUID; New object:C1471; This:C1470.stmpStartWork)
				End if 
		End case 
		This:C1470.code:=This:C1470.calculateCodeV1()
		
	End if 
	
local Function beforeDelete()
	This:C1470._deletePhasesLotsTasksOnServer()
	
Function _deletePhasesLotsTasksOnServer()
	var $ePhase : cs:C1710.PhaseEntity
	var $eLot : cs:C1710.LotEntity
	var $eTask : cs:C1710.TaskEntity
	
	For each ($ePhase; ds:C1482.Phase.query("UUID_TemplateProject = :1"; This:C1470.UUID))
		For each ($eLot; ds:C1482.Lot.query("UUID_Phase = :1"; $ePhase.UUID))
			For each ($eTask; ds:C1482.Task.query("UUID_Lot = :1"; $eLot.UUID))
				$info:=$eTask.drop()
			End for each 
			$info:=$eLot.drop()
		End for each 
		$info:=$ePhase.drop()
	End for each 
	
	
	
local Function isDeletable()->$isDeletable : Boolean
	
	$isDeletable:=False:C215
	
	
	