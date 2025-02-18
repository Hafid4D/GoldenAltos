Class extends Entity



//mark:- Callbacks
local Function loadAfterCreation()
	This:C1470._loadAfterCreation()  //call on the server
	
Function _loadAfterCreation()
	var $ePhase : cs:C1710.PhaseEntity
	var $eLot : cs:C1710.LotEntity
	
	If (This:C1470.phases.length=0)
		$ePhase:=ds:C1482.Phase.new()
		$ePhase.templateProject:=This:C1470
		$ePhase.code:="FP"
		$ePhase.name:="First phase"
		$ePhase.order:=1
		$info:=$ePhase.save()
		
		$eLot:=ds:C1482.Lot.new()
		$eLot.phase:=$ePhase
		$eLot.name:="First lot"
		$eLot.order:=1
		$info:=$eLot.save()
	End if 
	This:C1470.moreData:=New object:C1471
	
	
local Function itemLoad()
	If (This:C1470.moreData=Null:C1517)
		This:C1470.moreData:=New object:C1471
	End if 
	
local Function panelUnload()
	If (Is a list:C621(Num:C11(Form:C1466.subForm.hl_lots)))
		CLEAR LIST:C377(Form:C1466.subForm.hl_lots; *)
	End if 
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
	
local Function duplicateRecord()
	var $ePhase; $eNewPhase : cs:C1710.PhaseEntity
	var $eLot; $eNewLot : cs:C1710.LotEntity
	var $eTask; $eNewTask : cs:C1710.TaskEntity
	
	Form:C1466.current_item.name+=" (copy)"
	ds:C1482.duplicatePhasesLotsTasksForProjectOrTemplate(Form:C1466.original_item.UUID; Form:C1466.current_item.UUID; "UUID_TemplateProject"; "UUID_TemplateProject")
	
	
local Function beforeSaveCreation()
	
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
	
	
	