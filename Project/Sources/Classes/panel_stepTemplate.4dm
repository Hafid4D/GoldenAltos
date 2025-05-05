

singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
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
				This:C1470.loadSteps()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		Case of 
			: (FORM Get current page:C276(*)=1)
			: (FORM Get current page:C276(*)=2)
				This:C1470.redrawAndSetVisible()
		End case 
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
				
				Form:C1466.current_item.dataTables.items.push(New object:C1471("key"; $dataTable))
				
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
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"binDefinition"; New object:C1471("num"; 0; "definition"; ""); \
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
					"key"; $pm\
					))
				
				This:C1470.loadPMs()
				This:C1470._activate_save_cancel_button()
			End if 
		: ($choose="--delete")
			ALERT:C41("Remove a Parametric Measurement")
	End case 
	
	
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
	Form:C1466.selectedStep:=Null:C1517
	
	Form:C1466.lb_steps:=ds:C1482.Step.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
	
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
			
			$winRef:=Open form window:C675("createStepFromTemplate"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
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