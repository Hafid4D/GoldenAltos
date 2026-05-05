// ============================================
// Class: panel_step
// ============================================

singleton Class constructor
	// It's a singleton class
	
	
	// ----------------------------------------------
	// _activate_save_cancel_button
	// ----------------------------------------------
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	// ----------------------------------------------
	// formMethod
	// ----------------------------------------------
Function formMethod()
	// This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  // The main body of the form method and basic sfw functionalities
	If (Form:C1466.sfw.updateOfPanelNeeded())  // The current item is changed or reloaded, so it's necessary to refresh
		This:C1470.loadStepProperties()
		This:C1470.drawPup_stepTemplate()
		This:C1470.drawPup_process()
		This:C1470.drawPup_specification()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  // A page is displayed so it's time to load the data sources
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadStepProperties()
				This:C1470.drawPup_stepTemplate()
				This:C1470.drawPup_process()
				This:C1470.drawPup_specification()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  // It's time to resize the object or set visibility
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	// ----------------------------------------------
	// redrawAndSetVisible
	// ----------------------------------------------
Function redrawAndSetVisible()
	// Adjusts the layout and visibility of form elements based on the current page and modification state to be implemented
	This:C1470.drawPup_stepTemplate()
	This:C1470.drawPup_process()
	This:C1470.drawPup_specification()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Case of 
		: (FORM Get current page:C276(*)=1)
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_stepProperties"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_stepProperties"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_stepProperties"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_stepProperties"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
	End case 
	
	If (FORM Get current page:C276(*)=1)
		OBJECT SET ENTERABLE:C238(*; "lb_stepProperties"; Form:C1466.sfw.checkIsInModification())
	Else 
		OBJECT SET ENTERABLE:C238(*; "lb_stepProperties"; False:C215)
	End if 
	
	Form:C1466.sfw.drawHTab()
	
	
Function drawPup_stepTemplate()
	If ((Form:C1466.current_item#Null:C1517) & (FORM Get current page:C276(*)=1))
		$stepTemplateName:=Form:C1466.current_item.stepTemplate.name
		Form:C1466.sfw.drawButtonPup("pup_stepTemplate"; $stepTemplateName; ""; (Form:C1466.current_item.stepTemplate=Null:C1517))
	End if 
	
Function drawPup_specification()
	var $specEnt : 4D:C1709.Entity
	var $label : Text
	var $emptyLink : Boolean
	
	If ((Form:C1466.current_item#Null:C1517) & (FORM Get current page:C276(*)=1))
		$label:=""
		If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Specification)=False:C215)
			$specEnt:=ds:C1482.Specification.query("UUID = :1"; Form:C1466.current_item.UUID_Specification).first()
			If ($specEnt#Null:C1517)
				$label:=$specEnt.spec
			End if 
		End if 
		If ($label="")
			If (Form:C1466.current_item.specification#Null:C1517)
				$label:=String:C10(Form:C1466.current_item.specification.spec)
			Else 
				If ((Form:C1466.current_item.moreData#Null:C1517) & (Not:C34(Undefined:C82(Form:C1466.current_item.moreData.controlSpecText))))
					$label:=String:C10(Form:C1466.current_item.moreData.controlSpecText)
				End if 
			End if 
		End if 
		If ($label="")
			$label:="—"
		End if 
		$emptyLink:=((cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Specification)=True:C214) & ($label="—"))
		Form:C1466.sfw.drawButtonPup("pup_specification"; $label; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; $emptyLink)
	End if 
	
Function drawPup_process()
	If ((Form:C1466.current_item#Null:C1517) & (FORM Get current page:C276(*)=1))
		$processName:=""
		If (Form:C1466.current_item.stepProcess#Null:C1517)
			$processName:=Form:C1466.current_item.stepProcess.name
		Else 
			If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_StepProcess)=False:C215)
				$process:=ds:C1482.StepProcess.query("UUID = :1"; Form:C1466.current_item.UUID_StepProcess).first()
				If ($process#Null:C1517)
					$processName:=$process.name
				End if 
			End if 
		End if 
		If ($processName="")
			If (Form:C1466.current_item.moreData#Null:C1517)
				$processName:=Form:C1466.current_item.moreData.processName
			End if 
		End if 
		Form:C1466.sfw.drawButtonPup("pup_process"; $processName; ""; ($processName=""))
	End if 
	
Function pup_process()
	If (Form:C1466.sfw.checkIsInModification())
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorOperationProcess"; "operationProcess")
		$selector.setTitle("Choose an Operation Process")
		
		If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_StepProcess)=False:C215)
			$currentProcess:=ds:C1482.StepProcess.query("UUID = :1"; Form:C1466.current_item.UUID_StepProcess).first()
			If ($currentProcess#Null:C1517)
				$selector.setCurrentItem($currentProcess)
			End if 
		End if 
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		
		Case of 
			: ($selector.isSelected())
				$itemSelected:=$selector.getCurrentItem()
				If ($itemSelected#Null:C1517)
					Form:C1466.current_item.UUID_StepProcess:=$itemSelected.UUID
					If (Form:C1466.current_item.moreData=Null:C1517)
						Form:C1466.current_item.moreData:=New object:C1471()
					End if 
					Form:C1466.current_item.moreData.processName:=$itemSelected.name
					Form:C1466.current_item.moreData.Process:=$itemSelected.name
				End if 
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_StepProcess:=16*"00"
				If (Form:C1466.current_item.moreData#Null:C1517)
					Form:C1466.current_item.moreData.processName:=""
					Form:C1466.current_item.moreData.Process:=""
				End if 
		End case 
	End if 
	
	This:C1470.drawPup_process()
	This:C1470._activate_save_cancel_button()
	
	
Function pup_specification()
	var $form : Object
	var $allSpecs : 4D:C1709.EntitySelection
	var $specEntity : 4D:C1709.Entity
	var $winRef : Integer
	
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT GET COORDINATES:C663(*; "pup_specification"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$allSpecs:=ds:C1482.Specification.all().orderBy("spec")
		
		$form:=New object:C1471(\
			"colName"; "spec"; \
			"allData"; $allSpecs; \
			"dataclass"; "Specification"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b+1)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If ((ok=1) & ($form.item#Null:C1517))
			$specEntity:=$form.item
			Form:C1466.current_item.UUID_Specification:=$specEntity.UUID
			//Form.current_item.specification:=$specEntity
		End if 
	End if 
	
	This:C1470.drawPup_specification()
	This:C1470._activate_save_cancel_button()
	
	
Function pup_stepTemplate()
	If (Form:C1466.sfw.checkIsInModification())
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorStepTemplate"; "stepTemplate")
		$selector.setTitle("Choose a Step Template")
		$selector.setCurrentItem(Form:C1466.current_item.stepTemplate)
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		
		Case of 
			: ($selector.isSelected())
				$itemSelected:=$selector.getCurrentItem()
				
				Case of 
					: ($itemSelected=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSelected.UUID)=False:C215)
						Form:C1466.current_item.UUID_StepTemplate:=$itemSelected.UUID
						If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_StepTemplate)=True:C214)
							Form:C1466.current_item.UUID_StepTemplate:=16*"00"
						End if 
				End case 
				
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_StepTemplate:=16*"00"
		End case 
	End if 
	
	This:C1470.drawPup_stepTemplate()
	
	
Function loadStepProperties
	var $property : Object
	var $stepPropertyMaster : 4D:C1709.Entity
	Form:C1466.selectedStepProperty:=Null:C1517
	If (Form:C1466.current_item=Null:C1517)
		Form:C1466.lb_stepProperties:=New collection:C1472
	Else 
		If (Form:C1466.current_item.stepProperties=Null:C1517)
			Form:C1466.current_item.stepProperties:=New object:C1471("items"; New collection:C1472)
		End if 
		If (Form:C1466.current_item.stepProperties.items=Null:C1517)
			Form:C1466.current_item.stepProperties.items:=New collection:C1472
		End if 
		If (Form:C1466.current_item.stepProperties.items.length=0)
			For each ($stepPropertyMaster; ds:C1482.StepProperty.all().orderBy("levelID"))
				Form:C1466.current_item.stepProperties.items.push(New object:C1471(\
					"id"; $stepPropertyMaster.UUID; \
					"name"; $stepPropertyMaster.name; \
					"description"; $stepPropertyMaster.description; \
					"bit"; $stepPropertyMaster.moreData.bit; \
					"enable"; False:C215\
					))
			End for each 
		End if 
		For each ($property; Form:C1466.current_item.stepProperties.items)
			If ($property.enable=Null:C1517)
				$property.enable:=False:C215
			End if 
			If ($property.id=Null:C1517)
				$property.id:=""
			End if 
			If ($property.bit=Null:C1517)
				$property.bit:=""
			End if 
		End for each 
		Form:C1466.lb_stepProperties:=Form:C1466.current_item.stepProperties.items
	End if 
	
	
Function bActionStepProperties()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add step property")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete step property")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.selectedStepProperty=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471
			$existingNames:=Form:C1466.current_item.stepProperties.items.extract("name")
			$properties:=ds:C1482.StepProperty.query("NOT(name IN :1)"; $existingNames)
			$form.data:=$properties
			$form.dataSelected:=New collection:C1472
			
			$winRef:=Open form window:C675("_ga_multiSelectListbox"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Select step properties to add"; $winRef)
			DIALOG:C40("_ga_multiSelectListbox"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1)
				
				$cleanedSelectedData:=$form.dataSelected.toCollection().map(Formula:C1597(New object:C1471("description"; $1.value.description; "name"; $1.value.name)))
				
				For each ($property; $cleanedSelectedData)  // $form.dataSelected)
					Form:C1466.current_item.stepProperties.items.push($property)
				End for each 
				
				This:C1470.loadStepProperties()
				This:C1470._activate_save_cancel_button()
			End if 
			
		: ($choose="--delete")
			Form:C1466.current_item.stepProperties.items:=Form:C1466.current_item.stepProperties.items.filter(Formula:C1597($1.value.name#Form:C1466.selectedStepProperty.name))
			
			This:C1470.loadStepProperties()
			This:C1470._activate_save_cancel_button()
	End case 
	
	