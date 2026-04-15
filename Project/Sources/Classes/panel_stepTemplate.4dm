

singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		This:C1470.loadAllTabs()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadSkills()
				This:C1470.loadTools()
				This:C1470.loadDataTables()
				This:C1470.loadPMs()
				This:C1470.loadBins()
				
			: (FORM Get current page:C276(*)=2)
				//This.loadSteps()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		//Case of 
		//: (FORM Get current page(*)=1)
		//: (FORM Get current page(*)=2)
		This:C1470.redrawAndSetVisible()
		//End case 
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
	End if 
	This:C1470.drawPup_XXX()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.displayStepLine()
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Steps ("+String:C10(Form:C1466.lb_steps.length)+")"
	End use 
	
	This:C1470.drawPup_smallLayout()
	This:C1470.drawPup_largeLayout()
	This:C1470.drawPup_division()
	This:C1470.drawPup_operation()
	Case of 
		: (FORM Get current page:C276(*)=2)  // steps
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_1"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_2"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "bkgd_lb_steps"; $left_bk_lb; $top_bk_lb; $right_bk_lb; $bottom_bk_lb)
			OBJECT GET COORDINATES:C663(*; "lb_steps"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionSteps"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			OBJECT GET COORDINATES:C663(*; "lb_stepRules"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionStepRules"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_1"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "bkgd_lb_steps"; $left_bk_lb; $top_bk_lb; $widthSubform-$offset; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_steps"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionSteps"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			OBJECT SET COORDINATES:C1248(*; "lb_stepRules"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionStepRules"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
	End case 
	
	Form:C1466.sfw.drawHTab()
	
Function bActionSkills()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add a Skill")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a Skill")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentSkill=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"windowTitle"; "Add a Skill"; \
				"inputPlaceholder"; "Skill Search ..."; \
				"lb_values"; ds:C1482.Certification.all().toCollection().extract("UUID"; "UUID"; "name"; "description")\
				)
			
			$winRef:=Open form window:C675("searchOnList_v2"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("searchOnList_v2"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1) & ($form.selectedItem#Null:C1517)
				$stepTemplateSkill:=ds:C1482.StepTemplateCertification.new()
				
				$stepTemplateSkill.UUID_Certification:=$form.selectedItem.UUID
				$stepTemplateSkill.UUID_StepTemplate:=Form:C1466.current_item.UUID
				
				$res:=$stepTemplateSkill.save()
				
				If ($res.success)
					This:C1470.loadSkills()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
			
		: ($choose="--delete")
			ALERT:C41("Remove a Skill")
	End case 
	
	
Function bActionTools()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add a Tool")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a Tool")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentTool=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"windowTitle"; "Add a Tool"; \
				"inputPlaceholder"; "Tool Search ..."; \
				"lb_values"; ds:C1482.ToolType.all().toCollection().extract("UUID"; "UUID"; "name"; "description")\
				)
			
			$winRef:=Open form window:C675("searchOnList_v2"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("searchOnList_v2"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1) & ($form.selectedItem#Null:C1517)
				$stepTemplateTool:=ds:C1482.StepTemplateTool.new()
				
				$stepTemplateTool.UUID_Tool:=$form.selectedItem.UUID
				$stepTemplateTool.UUID_StepTemplate:=Form:C1466.current_item.UUID
				
				$stepTemplateTool.order:=Form:C1466.lb_tools.length+1
				
				$res:=$stepTemplateTool.save()
				
				If ($res.success)
					This:C1470.loadTools()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
			
		: ($choose="--delete")
			ALERT:C41("Remove a Tool")
	End case 
	
	
Function bActionDataTables()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add a Data Table")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a Data Table")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentDataTable=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$dataTable:=Request:C163("Enter a Data Table :")
			
			If (ok=1)
				If (Form:C1466.current_item.dataTables=Null:C1517)
					Form:C1466.current_item.dataTables:=New object:C1471("items"; New collection:C1472())
				End if 
				
				Form:C1466.current_item.dataTables.items.push(New object:C1471("UUID"; Generate UUID:C1066; "key"; $dataTable; "value"; ""))
				
				This:C1470.loadDataTables()
				This:C1470._activate_save_cancel_button()
			End if 
		: ($choose="--delete")
			ALERT:C41("Remove a Data Table")
	End case 
	
	
Function bActionBins()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add a Bin")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a Bin")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentBin=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	
	APPEND MENU ITEM:C411($refMenu; "Modify a Bin")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--modify")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/edit.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentBin=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"binDefinition"; New object:C1471("num"; 0; "definition"; ""; "type"; ""; "action"; "add"); \
				"existingBins"; Form:C1466.lb_bins\
				)
			
			$winRef:=Open form window:C675("createBins_st"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createBins_st"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (ok=1)
				If (Form:C1466.current_item.bins=Null:C1517)
					Form:C1466.current_item.bins:=New object:C1471("items"; New collection:C1472())
				End if 
				
				Form:C1466.current_item.bins.items.push($form.binDefinition)
				
				This:C1470.loadBins()
				This:C1470._activate_save_cancel_button()
			End if 
		: ($choose="--delete")
			ALERT:C41("Remove a Bin")
			
		: ($choose="--modify")
			$form:=New object:C1471(\
				"binDefinition"; New object:C1471("num"; Form:C1466.currentBin.num; "definition"; Form:C1466.currentBin.definition; "type"; Form:C1466.currentBin.type; "action"; "modify"); \
				"existingBins"; Form:C1466.lb_bins\
				)
			
			$winRef:=Open form window:C675("createBins_st"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createBins_st"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (ok=1)
				If (Form:C1466.current_item.bins=Null:C1517)
					Form:C1466.current_item.bins:=New object:C1471("items"; New collection:C1472())
				End if 
				
				Form:C1466.currentBin.num:=$form.binDefinition.num
				Form:C1466.currentBin.definition:=$form.binDefinition.definition
				Form:C1466.currentBin.type:=$form.binDefinition.type
				
				//Form.current_item.bins.items.push($form.binDefinition)
				
				
				This:C1470._activate_save_cancel_button()
			End if 
			
	End case 
	
	
Function bActionPMs()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add a Parametric Measurement")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a Parametric Measurement")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentPM=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$pm:=Request:C163("Enter a Parametric Measurement :")
			
			If (ok=1)
				If (Form:C1466.current_item.parametricMeasurements=Null:C1517)
					Form:C1466.current_item.parametricMeasurements:=New object:C1471("items"; New collection:C1472())
				End if 
				
				Form:C1466.current_item.parametricMeasurements.items.push(New object:C1471(\
					"UUID"; Generate UUID:C1066; \
					"key"; $pm; \
					"value"; ""\
					))
				
				This:C1470.loadPMs()
				This:C1470._activate_save_cancel_button()
			End if 
		: ($choose="--delete")
			ALERT:C41("Remove a Parametric Measurement")
	End case 
	
	
Function loadAllTabs()
	This:C1470.loadSteps()
	This:C1470.loadStepRules()
	This:C1470.loadStepContainerCodes()
	
Function loadTools()
	Form:C1466.lb_tools:=ds:C1482.StepTemplateTool.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
	
Function loadSkills
	Form:C1466.lb_skills:=ds:C1482.StepTemplateCertification.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
	
Function loadDataTables
	If (Form:C1466.current_item.dataTables=Null:C1517)
		Form:C1466.current_item.dataTables:=New object:C1471("items"; New collection:C1472())
	End if 
	
	Form:C1466.lb_dataTables:=Form:C1466.current_item.dataTables.items
	
	
Function loadPMs
	If (Form:C1466.current_item.parametricMeasurements=Null:C1517)
		Form:C1466.current_item.parametricMeasurements:=New object:C1471("items"; New collection:C1472())
	End if 
	
	Form:C1466.lb_pms:=Form:C1466.current_item.parametricMeasurements.items
	
	
Function loadBins
	If (Form:C1466.current_item.bins=Null:C1517)
		Form:C1466.current_item.bins:=New object:C1471("items"; New collection:C1472())
	End if 
	
	Form:C1466.lb_bins:=Form:C1466.current_item.bins.items
	
	
Function loadSteps
	Form:C1466.selectedStepRule:=Null:C1517
	
	Form:C1466.lb_steps:=ds:C1482.Step.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
Function loadStepRules
	
	If (Form:C1466.current_item.rules#Null:C1517)
		Form:C1466.lb_stepRules:=Form:C1466.current_item.rules.items
	End if 
	
Function loadStepContainerCodes
	If (Form:C1466.current_item.containerCodes#Null:C1517)
		Form:C1466.lb_stepContainerCodes:=Form:C1466.current_item.containerCodes.items
	End if 
	
Function displayStepLine()
	OBJECT SET VISIBLE:C603(*; "label_stepLine@"; Not:C34((Form:C1466.selectedStep=Null:C1517)))
	OBJECT SET VISIBLE:C603(*; "entryField_stepLine@"; Not:C34((Form:C1466.selectedStep=Null:C1517)))
	
	
Function bActionSteps()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Create a step from template")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete a Step")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.currentPM=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"step"; ds:C1482.Step.new()\
				)
			
			$form.step.UUID_StepTemplate:=Form:C1466.current_item.UUID
			
			$winRef:=Open form window:C675("createStepFromTemplate"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createStepFromTemplate"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (ok=1)
				$step_e:=$form.step
				
				$res:=$step_e.save()
				
				If ($res.success)
					This:C1470.loadSteps()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
			
		: ($choose="--delete")
	End case 
	
	
Function bActionStepRules()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add step rule")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete step rule")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.selectedStepRule=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471
			$rules:=ds:C1482.StepTemplateRule.query("NOT(name IN :1)"; Form:C1466.current_item.rules.items.extract("name"))
			$form.data:=$rules
			$form.dataSelected:=New collection:C1472
			$winRef:=Open form window:C675("_ga_multiSelectListbox"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Select rules to add"; $winRef)
			DIALOG:C40("_ga_multiSelectListbox"; $form)
			
			If (OK=1)
				$cleanedSelectedData:=$form.dataSelected.toCollection().map(Formula:C1597(New object:C1471("description"; $1.value.description; "name"; $1.value.name)))
				
				For each ($rule; $cleanedSelectedData)
					Form:C1466.current_item.rules.items.push($rule)
				End for each 
				
				This:C1470.loadStepRules()
				This:C1470._activate_save_cancel_button()
			End if 
			
		: ($choose="--delete")
			
			Form:C1466.current_item.rules.items:=Form:C1466.current_item.rules.items.filter(Formula:C1597($1.value.name#Form:C1466.selectedStepRule.name))
			
			This:C1470.loadStepRules()
			This:C1470._activate_save_cancel_button()
			//End if 
			
			
			
	End case 
	
	
Function bActionStepContainerCodes()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add step rule")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete step rule")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.selectedStepContainerCode=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471
			$codes:=ds:C1482.ContainerCode.query("NOT(name IN :1)"; Form:C1466.current_item.containerCodes.items.extract("name"))
			$form.data:=$codes
			$form.dataSelected:=New collection:C1472
			$winRef:=Open form window:C675("_ga_multiSelectListbox"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Select container code to add"; $winRef)
			DIALOG:C40("_ga_multiSelectListbox"; $form)
			
			If (OK=1)
				$cleanedSelectedData:=$form.dataSelected.toCollection().map(Formula:C1597(New object:C1471("description"; $1.value.description; "name"; $1.value.name)))
				
				For each ($containerCode; $cleanedSelectedData)
					Form:C1466.current_item.containerCodes.items.push($containerCode)
				End for each 
				
				This:C1470.loadStepContainerCodes()
				This:C1470._activate_save_cancel_button()
			End if 
			
		: ($choose="--delete")
			
			Form:C1466.current_item.containerCodes.items:=Form:C1466.current_item.containerCodes.items.filter(Formula:C1597($1.value.name#Form:C1466.selectedStepContainerCode.name))
			
			This:C1470.loadStepContainerCodes()
			This:C1470._activate_save_cancel_button()
			//End if 
			
			
			
	End case 
	
	
	
Function drawPup_smallLayout()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("StepTemplateLayout"; "UUID"; "smallLayout_UUID"; "pup_smallLayout")
	End if 
	
Function pup_smallLayout()
	//Create pop up menu
	Form:C1466.current_item.pup("stepTemplateLayouts"; "StepTemplateLayout"; "UUID"; "smallLayout_UUID")
	This:C1470.drawPup_smallLayout()
	
	
Function drawPup_largeLayout()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("StepTemplateLayout"; "UUID"; "largeLayout_UUID"; "pup_largeLayout")
	End if 
	
Function pup_largeLayout()
	//Create pop up menu
	Form:C1466.current_item.pup("stepTemplateLayouts"; "StepTemplateLayout"; "UUID"; "largeLayout_UUID")
	This:C1470.drawPup_largeLayout()
	
Function pup_division()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.divisions=Null:C1517)
			ds:C1482.Division.cacheLoad()
		End if 
		
		For each ($eDivision; Storage:C1525.cache.divisions)
			APPEND MENU ITEM:C411($menu; $eDivision.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eDivision.UUID)
			If ($eDivision.UUID=Form:C1466.current_item.UUID_Division)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$eDivision:=ds:C1482.Division.get($choose)
				Form:C1466.current_item.UUID_Division:=$eDivision.UUID
		End case 
		
	End if 
	This:C1470.drawPup_division()
	
Function drawPup_division()
	If (Form:C1466.current_item#Null:C1517)
		$division:=ds:C1482.Division.query("UUID =:1"; Form:C1466.current_item.UUID_Division).first() || New object:C1471()
		$divisionName:=$division.name
		If ($divisionName=Null:C1517)
			$divisionName:=""
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($division.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_division"; $divisionName; $pathIcon; ($division=Null:C1517))
	End if 
	
	
	
Function pup_operation()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.operations=Null:C1517)
			ds:C1482.Operation.cacheLoad()
		End if 
		
		For each ($eOperation; Storage:C1525.cache.operations)
			APPEND MENU ITEM:C411($menu; $eOperation.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eOperation.UUID)
			If ($eOperation.UUID=Form:C1466.current_item.UUID_Operation)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$eOperation:=ds:C1482.Operation.get($choose)
				Form:C1466.current_item.UUID_Operation:=$eOperation.UUID
		End case 
		
	End if 
	This:C1470.drawPup_operation()
	
Function drawPup_operation()
	If (Form:C1466.current_item#Null:C1517)
		$operation:=ds:C1482.Operation.query("UUID =:1"; Form:C1466.current_item.UUID_Operation).first() || New object:C1471()
		$operationName:=$operation.name
		If ($operationName=Null:C1517)
			$operationName:=""
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($operation.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_operation"; $operationName; $pathIcon; ($operation=Null:C1517))
	End if 