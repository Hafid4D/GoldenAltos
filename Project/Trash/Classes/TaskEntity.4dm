Class extends Entity


Alias project lot.phase.project

// MARK: -nameInWizard

Function get companyNameInWizard()->$name : Text
	$name:=This:C1470.lot.phase.project.company.nameInWizard
	
Function get customerNameInWizard()->$name : Text
	$name:=This:C1470.lot.phase.project.customer.nameInWizard
	
Function get projectNameInWizard()->$name : Text
	$name:=This:C1470.lot.phase.project.nameInWizard
	
Function get phaseNameInWizard()->$name : Text
	$name:=This:C1470.lot.phase.nameInWizard
	
Function get lotNameInWizard()->$name : Text
	$name:=This:C1470.lot.nameInWizard
	
Function get nameInWizard()->$name : Text
	$name:="🗒️ "+This:C1470.name
	
	
	
	// MARK: -computed attributes
local Function get meta()->$meta : Object
	$meta:=New object:C1471
	If (This:C1470.spentHours>This:C1470.estimatedHours)
		$meta.stroke:="red"
		$meta.fontStyle:="bold"
	Else 
		$meta.stroke:="automatic"
		$meta.fontStyle:="automatic"
	End if 
	
local Function get dateStart()->$startDate : Date
	$startDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStart; True:C214)
	
local Function set dateStart($startDate : Date)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build($startDate)
	
local Function get dateDue()->$dateDue : Date
	$dateDue:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpDue; True:C214)
	
local Function set dateDue($dateDue : Date)
	This:C1470.stmpDue:=cs:C1710.sfw_stmp.me.build($dateDue)
	
local Function get colorPicture()->$img : Picture
	$colorName:=cs:C1710.taskStatusManager.me.getColorByID(This:C1470.currentStatusID)
	$img:=cs:C1710.sfw_htmlColor.me.getColorPictureByName($colorName)
	
local Function get status()->$status : Text
	$status:=cs:C1710.taskStatusManager.me.getStatusByID(This:C1470.currentStatusID)
	
local Function get spentHours()->$hours : Real
	SET DATABASE PARAMETER:C642(28; 5)
	$hours:=This:C1470.affectations.taskTimes.sum("stmpDuration")/3600
	SET DATABASE PARAMETER:C642(28; 0)
	
local Function get leftHours()->$hours : Real
	$hours:=This:C1470.estimatedHours-This:C1470.spentHours
	
	// MARK:-Function called in the panel_task form
local Function addNewTaskTime()
	$context:=New object:C1471
	$context.UUID_task:=Form:C1466.current_item.UUID
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$context.UUID_Staff:=cs:C1710.sfw_userManager.me.staff.UUID
		If (Form:C1466.current_item.affectations.query("UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID).length=0)
			$context.bAutoAffectation:=1
		End if 
	End if 
	cs:C1710.wizard_newTaskTime.me.openWizard($context)
	
	Form:C1466.lbTaskTimes:=ds:C1482.TaskTime.query("affectation.task.UUID = :1 order by stmpStart desc, affectation.staff.fullName asc"; Form:C1466.current_item.UUID)
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
	
	// MARK: - Callbacks for item displaying
local Function afterCreation()
	
local Function afterSave()
	// This callback is called after saving the item in the itemList
	
local Function beforeSave()
	// This callback is called before saving the item in the itemList
	
local Function beforeSaveCreation()
	
local Function duplicateRecord()
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	// With this callback you return the name to displayed in the title of the window for the current item
	$nameInWindowTitle:=This:C1470.name
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	
local Function itemReload()
	
local Function loadAfterCreation()
	
local Function panelUnload()
	