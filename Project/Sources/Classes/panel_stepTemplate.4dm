

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
				
			: (FORM Get current page:C276(*)=2)
				//This.loadSteps()
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadStepRules()
			: (FORM Get current page:C276(*)=4)
				This:C1470.loadBins()
				This:C1470.syncBinDraftFromSelection()
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
		Form:C1466.sfw.entry.panel.pages[2].label:="Rules ("+String:C10((Form:C1466.lb_stepRules#Null:C1517) ? Form:C1466.lb_stepRules.length : 0)+")"
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
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_1"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "bkgd_lb_steps"; $left_bk_lb; $top_bk_lb; $widthSubform-$offset; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_steps"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionSteps"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
		: (FORM Get current page:C276(*)=3)  // rules
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_1"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_stepRules"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_1"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_stepRules"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset)
			
		: (FORM Get current page:C276(*)=4)  // bins definition
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_4"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "bkgd_lb_bins"; $left_bk_lb; $top_bk_lb; $right_bk_lb; $bottom_bk_lb)
			OBJECT GET COORDINATES:C663(*; "lb_bins"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_4"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "bkgd_lb_bins"; $left_bk_lb; $top_bk_lb; $widthSubform-$offset; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_bins"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset)
			
	End case 
	
	This:C1470.drawBinInlineEditor()
	
	If (FORM Get current page:C276(*)=1)
		OBJECT SET ENTERABLE:C238(*; "List Box4"; Form:C1466.sfw.checkIsInModification())
	Else 
		OBJECT SET ENTERABLE:C238(*; "List Box4"; False:C215)
	End if 
	
	If (FORM Get current page:C276(*)=3)
		OBJECT SET ENTERABLE:C238(*; "lb_stepRules"; Form:C1466.sfw.checkIsInModification())
	Else 
		OBJECT SET ENTERABLE:C238(*; "lb_stepRules"; False:C215)
	End if 
	
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
				$stepTemplateTool:=ds:C1482.StepTemplateToolType.new()
				
				$stepTemplateTool.UUID_ToolType:=$form.selectedItem.UUID
				$stepTemplateTool.UUIDStepTemplate:=Form:C1466.current_item.UUID
				
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
	
	APPEND MENU ITEM:C411($refMenu; "Add a column")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Remove a column")
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
			$name:=Request:C163("Column name:")
			
			If (OK=1)
				$name:=cs:C1710.sfw_string.me.trimSpace($name)
				If ($name#"")
					If (Form:C1466.current_item.dataTables=Null:C1517)
						Form:C1466.current_item.dataTables:=New object:C1471("items"; New collection:C1472())
					End if 
					If (Form:C1466.current_item.dataTables.items=Null:C1517)
						Form:C1466.current_item.dataTables.items:=New collection:C1472()
					End if 
					
					$maxOrder:=0
					For each ($col; Form:C1466.current_item.dataTables.items)
						If (Num:C11($col.order)>$maxOrder)
							$maxOrder:=Num:C11($col.order)
						End if 
					End for each 
					
					Form:C1466.current_item.dataTables.items.push(New object:C1471(\
						"UUID"; Generate UUID:C1066; \
						"name"; $name; \
						"order"; $maxOrder+1; \
						"key"; $name; \
						"value"; ""\
						))
					
					This:C1470.loadDataTables()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
		: ($choose="--delete")
			If (Form:C1466.currentDataTable#Null:C1517)
				Form:C1466.current_item.dataTables.items:=Form:C1466.current_item.dataTables.items.filter(Formula:C1597($1.value.UUID#Form:C1466.currentDataTable.UUID))
				$sorted:=Form:C1466.current_item.dataTables.items.orderBy("order asc")
				$k:=1
				For each ($col; $sorted)
					$col.order:=$k
					$k:=$k+1
				End for each 
				Form:C1466.current_item.dataTables.items:=$sorted
				This:C1470.loadDataTables()
				This:C1470._activate_save_cancel_button()
			End if 
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
	
	
	// APPEND MENU ITEM($refMenu; "Modify a Bin")
	// SET MENU ITEM PARAMETER($refMenu; -1; "--modify")
	// SET MENU ITEM ICON($refMenu; -1; "Path:/RESOURCES/image/button/edit.png")
	// If (Not(Form.sfw.checkIsInModification()))
	// 	DISABLE MENU ITEM($refMenu; -1)
	// Else 
	// 	If (Form.currentBin=Null)
	// 		DISABLE MENU ITEM($refMenu; -1)
	// 	End if 
	// End if 
	
	
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
			
			// : ($choose="--modify")
			// 	$form:=New object(\
			// 		"binDefinition"; New object("num"; Form.currentBin.num; "definition"; Form.currentBin.definition; "type"; Form.currentBin.type; "action"; "modify"); \
			// 		"existingBins"; Form.lb_bins\
			// 		)
			// 	
			// 	$winRef:=Open form window("createBins_st"; Controller form window; Horizontally centered; Vertically centered)
			// 	DIALOG("createBins_st"; $form)
			// 	CLOSE WINDOW($winRef)
			// 	
			// 	If (ok=1)
			// 		If (Form.current_item.bins=Null)
			// 			Form.current_item.bins:=New object("items"; New collection())
			// 		End if 
			// 		
			// 		Form.currentBin.num:=$form.binDefinition.num
			// 		Form.currentBin.definition:=$form.binDefinition.definition
			// 		Form.currentBin.type:=$form.binDefinition.type
			// 		
			// 		This._activate_save_cancel_button()
			// 	End if 
			
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
	Form:C1466.lb_tools:=ds:C1482.StepTemplateToolType.query("UUIDStepTemplate = :1"; Form:C1466.current_item.UUID).orderBy("order asc")
	
	
Function loadSkills
	Form:C1466.lb_skills:=ds:C1482.StepTemplateCertification.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
	
Function loadDataTables
	If (Form:C1466.current_item.dataTables=Null:C1517)
		Form:C1466.current_item.dataTables:=New object:C1471("items"; New collection:C1472())
	End if 
	If (Form:C1466.current_item.dataTables.items=Null:C1517)
		Form:C1466.current_item.dataTables.items:=New collection:C1472()
	End if 
	
	For each ($col; Form:C1466.current_item.dataTables.items)
		If ($col.UUID=Null:C1517) | (String:C10($col.UUID)="")
			$col.UUID:=Generate UUID:C1066
		End if 
		$colName:=String:C10($col.name)
		If ($colName="")
			$colName:=String:C10($col.key)
		End if 
		$col.name:=$colName
		$col.key:=$colName
	End for each 
	$maxOrder:=0
	For each ($col; Form:C1466.current_item.dataTables.items)
		If (Not:C34(Undefined:C82($col.order))) & ($col.order#Null:C1517)
			If (Num:C11($col.order)>$maxOrder)
				$maxOrder:=Num:C11($col.order)
			End if 
		End if 
	End for each 
	$nextOrder:=$maxOrder+1
	For each ($col; Form:C1466.current_item.dataTables.items)
		If (Undefined:C82($col.order)) | ($col.order=Null:C1517)
			$col.order:=$nextOrder
			$nextOrder:=$nextOrder+1
		End if 
	End for each 
	
	Form:C1466.lb_dataTables:=Form:C1466.current_item.dataTables.items.orderBy("order asc").copy()
	
	
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
	This:C1470.syncBinDraftFromSelection()
	
Function lb_bins()
	Case of 
		: (Form event code:C388=On Selection Change:K2:69)
			This:C1470.syncBinDraftFromSelection()
			This:C1470.drawBinInlineEditor()
		: (Form event code:C388=On Clicked:K2:4)
			This:C1470.syncBinDraftFromSelection()
			This:C1470.drawBinInlineEditor()
	End case 
	
Function syncBinDraftFromSelection()
	$selectedBins:=This:C1470.getSelectedBins()
	If ($selectedBins.length=0)
		Form:C1466.currentBinDraft:=Null:C1517
	Else 
		If ($selectedBins.length=1)
			$bin:=$selectedBins[0]
			$type:=String:C10($bin.type)
			If ($type="")
				$type:="Not Used"
			End if 
			Form:C1466.currentBinDraft:=New object:C1471(\
				"num"; $bin.num; \
				"definition"; $bin.definition; \
				"type"; $type\
			)
		Else 
			$type:=String:C10($selectedBins[0].type)
			If ($type="")
				$type:="Not Used"
			End if 
			For each ($bin; $selectedBins)
				$binType:=String:C10($bin.type)
				If ($binType="")
					$binType:="Not Used"
				End if 
				If ($binType#$type)
					$type:=""
					Break 
				End if 
			End for each 
			Form:C1466.currentBinDraft:=New object:C1471(\
				"num"; ""; \
				"definition"; ""; \
				"type"; $type\
			)
		End if 
	End if 
	
Function drawBinInlineEditor()
	$selectionCount:=This:C1470.getSelectedBinsCount()
	$isSingleSelection:=($selectionCount=1)
	$showEditor:=(FORM Get current page:C276(*)=5) & Form:C1466.sfw.checkIsInModification() & ($selectionCount>0)
	
	OBJECT SET VISIBLE:C603(*; "rec_binEditor"; $showEditor)
	OBJECT SET VISIBLE:C603(*; "label_binEditorNum"; $showEditor & $isSingleSelection)
	OBJECT SET VISIBLE:C603(*; "entryField_binEditorNum"; $showEditor & $isSingleSelection)
	OBJECT SET VISIBLE:C603(*; "label_binEditorName"; $showEditor & $isSingleSelection)
	OBJECT SET VISIBLE:C603(*; "entryField_binEditorName"; $showEditor & $isSingleSelection)
	OBJECT SET VISIBLE:C603(*; "label_binEditorType"; $showEditor)
	OBJECT SET VISIBLE:C603(*; "pup_binEditorType"; $showEditor)
	OBJECT SET VISIBLE:C603(*; "btn_binEditorSave"; $showEditor)
	OBJECT SET VISIBLE:C603(*; "btn_binEditorCancel"; $showEditor)
	If ($showEditor)
		This:C1470.drawPup_binEditorType()
	End if 
	
Function pup_binEditorType()
	If (Form:C1466.sfw.checkIsInModification()) & (Form:C1466.currentBinDraft#Null:C1517)
		$menu:=Create menu:C408
		APPEND MENU ITEM:C411($menu; "Not Used")
		SET MENU ITEM PARAMETER:C1004($menu; -1; "Not Used")
		If (String:C10(Form:C1466.currentBinDraft.type)="Not Used")
			SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
		End if 
		
		$types:=New collection:C1472("Good"; "Rejects"; "Mechanical Rejects"; "Missing or Excluded")
		For each ($typeName; $types)
			APPEND MENU ITEM:C411($menu; $typeName; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $typeName)
			If ($typeName=Form:C1466.currentBinDraft.type)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		If ($choose#"")
			Form:C1466.currentBinDraft.type:=$choose
			This:C1470.drawPup_binEditorType()
		End if 
	End if 
	
Function drawPup_binEditorType()
	$typeName:=""
	If (Form:C1466.currentBinDraft#Null:C1517)
		$typeName:=String:C10(Form:C1466.currentBinDraft.type)
	End if 
	Form:C1466.sfw.drawButtonPup("pup_binEditorType"; $typeName; ""; ($typeName=""))
	
Function btn_binEditorSave()
	$selectedBins:=This:C1470.getSelectedBins()
	$selectionCount:=$selectedBins.length
	If ($selectionCount>0) & (Form:C1466.currentBinDraft#Null:C1517)
		If ($selectionCount=1)
			$selectedBins[0].definition:=Form:C1466.currentBinDraft.definition
			$selectedBins[0].type:=Form:C1466.currentBinDraft.type
		Else 
			For each ($bin; $selectedBins)
				$bin.type:=Form:C1466.currentBinDraft.type
			End for each 
		End if 
		
		This:C1470.loadBins()
		This:C1470._activate_save_cancel_button()
		This:C1470.drawBinInlineEditor()
	End if 
	
Function btn_binEditorCancel()
	This:C1470.syncBinDraftFromSelection()
	This:C1470.drawPup_binEditorType()
	
Function getSelectedBins()->$selectedBins : Collection
	$selectedBins:=New collection:C1472()
	If (Form:C1466.selectedBins#Null:C1517)
		$selectedBins:=Form:C1466.selectedBins
	End if 
	If ($selectedBins.length=0) & (Form:C1466.currentBin#Null:C1517)
		$selectedBins.push(Form:C1466.currentBin)
	End if 
	
Function getSelectedBinsCount()->$count : Integer
	$count:=This:C1470.getSelectedBins().length
	
	
Function loadSteps
	Form:C1466.selectedStepRule:=Null:C1517
	
	Form:C1466.lb_steps:=ds:C1482.Step.query("UUID_StepTemplate = :1"; Form:C1466.current_item.UUID)
	
Function loadStepRules
	var $rule : Object

	If (Form:C1466.current_item.rules=Null:C1517)
		Form:C1466.current_item.rules:=New object:C1471("items"; New collection:C1472())
	End if
	If (Form:C1466.current_item.rules.items=Null:C1517)
		Form:C1466.current_item.rules.items:=New collection:C1472()
	Else
		For each ($rule; Form:C1466.current_item.rules.items)
			If ($rule.enable=Null:C1517)
				$rule.enable:=False:C215
			End if
			If ($rule.id=Null:C1517)
				$rule.id:=""
			End if
			If ($rule.bit=Null:C1517)
				$rule.bit:=""
			End if
		End for each
	End if
	Form:C1466.lb_stepRules:=Form:C1466.current_item.rules.items

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
				$cleanedSelectedData:=$form.dataSelected.toCollection().map(Formula:C1597(New object:C1471(\
					"id"; $1.value.UUID; \
					"name"; $1.value.name; \
					"description"; $1.value.description; \
					"bit"; $1.value.bit; \
					"enable"; False:C215\
					)))
				
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
	If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.stepTemplateLayouts=Null:C1517)
		ds:C1482.StepTemplateLayout.cacheLoad()
	End if 
	Use (Storage:C1525.cache)
		Storage:C1525.cache.stepTemplateLayoutsSmall:=Storage:C1525.cache.stepTemplateLayouts.query("type = :1"; "small").copy(ck shared:K85:29; Storage:C1525.cache)
	End use 
	Form:C1466.current_item.pup("stepTemplateLayoutsSmall"; "StepTemplateLayout"; "UUID"; "smallLayout_UUID")
	This:C1470.drawPup_smallLayout()
	
	
Function drawPup_largeLayout()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("StepTemplateLayout"; "UUID"; "largeLayout_UUID"; "pup_largeLayout")
	End if 
	
Function pup_largeLayout()
	//Create pop up menu
	If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.stepTemplateLayouts=Null:C1517)
		ds:C1482.StepTemplateLayout.cacheLoad()
	End if 
	Use (Storage:C1525.cache)
		Storage:C1525.cache.stepTemplateLayoutsLarge:=Storage:C1525.cache.stepTemplateLayouts.query("type = :1"; "large").copy(ck shared:K85:29; Storage:C1525.cache)
	End use 
	Form:C1466.current_item.pup("stepTemplateLayoutsLarge"; "StepTemplateLayout"; "UUID"; "largeLayout_UUID")
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