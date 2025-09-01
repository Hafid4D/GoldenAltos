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
		This:C1470.loadCurrentStep()
		This:C1470.displayBannerLotOnHold()
		
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
				This:C1470.loadTools()
				This:C1470.loadPMs()
				This:C1470.loadStepInterruptions()
				This:C1470.loadDataTables()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
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
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
		: (FORM Get current page:C276(*)=1)  // Main page
			OBJECT GET COORDINATES:C663(*; "banner_lotOnHold_page"+String:C10(FORM Get current page:C276(*)); $left; $top; $right; $bottom)
			
			$width:=$right-$left
			$height:=$bottom-$top
			
			OBJECT SET COORDINATES:C1248(*; "banner_lotOnHold_page"+String:C10(FORM Get current page:C276(*)); $widthSubform-$width; $heightSubform-$height; $widthSubform; $heightSubform)
	End case 
	
Function checkForCertifications()->$valid : Boolean
	$staff_es:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first().staffs
	
	If ($staff_es.length>0)
		$staff_e:=$staff_es[0]
		
		$missingCertifications:=New collection:C1472()
		
		If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.requitedCertifications#Null:C1517)
			$certifications:=Form:C1466.currentStep.requitedCertifications.items
			
			For each ($certification; $certifications)
				$assignments:=$staff_e.assignments.query("UUID_Certification = :1"; $certification.UUID_Certification)
				
				If ($assignments.length=0)
					$missingCertifications.push($certification)
				End if 
			End for each 
		End if 
		
		$valid:=($missingCertifications.length=0)
	End if 
	
Function loadCurrentStep()
	
	Form:C1466.currentStep:=Null:C1517
	Form:C1466.currentStepOrder:=0
	$currentstep:=Form:C1466.current_item.steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	
	If ($currentstep.length>0)
		Form:C1466.currentStep:=$currentstep[0]
		
		If (This:C1470.checkForCertifications())
			Form:C1466.currentStepOrder:=Form:C1466.currentStep.order
			
			OBJECT SET FORMAT:C236(*; "EntryField_comment1"; Form:C1466.currentStep.commentFormat1)
			OBJECT SET FILTER:C235(*; "EntryField_comment1"; Form:C1466.currentStep.commentFormat1)
			
			OBJECT SET FORMAT:C236(*; "EntryField_comment2"; Form:C1466.currentStep.commentFormat2)
			OBJECT SET FILTER:C235(*; "EntryField_comment2"; Form:C1466.currentStep.commentFormat2)
			
			OBJECT SET PLACEHOLDER:C1295(*; "EntryField_comment1"; Replace string:C233(Form:C1466.currentStep.commentFormat1; "#"; "_"))
			OBJECT SET PLACEHOLDER:C1295(*; "EntryField_comment2"; Replace string:C233(Form:C1466.currentStep.commentFormat2; "#"; "_"))
			
			//If (Form.currentStep.tools=Null)
			//Form.currentStep.tools:=New object("items"; New collection())
			
			//If (Form.currentStep.stepTemplate#Null)
			//For each ($stepTemplateTool; Form.currentStep.stepTemplate.stepTemplateTools)
			//$tool_ob:=New object(\
				"order"; $stepTemplateTool.order; \
				"toolType"; $stepTemplateTool.toolType.name; \
				"tool"; New object("tool"; ""; "UUID_Tool"; ""); \
				"date"; !00-00-00!\
				)
			//End for each 
			//End if 
			//End if 
			
			//If (Form.currentStep.parametricMeasurements=Null)
			
			//End if 
			
			//If (Form.currentStep.stepInterruptions=Null)
			//Form.currentStep.stepInterruptions:=New object("items"; New collection())
			//End if 
			
			//If (Form.currentStep.dataTables=Null)
			
			//End if 
			
			FORM GOTO PAGE:C247(1; *)
		Else 
			Form:C1466.currentStepOrder:=0
			FORM GOTO PAGE:C247(3; *)
			//cs.sfw_dialog.me.alert("Some certifications are required for this lotStep !")
		End if 
	Else 
		Form:C1466.currentStepOrder:=0
		FORM GOTO PAGE:C247(2; *)
	End if 
	
	
Function loadTools()
	If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.tools#Null:C1517)
		Form:C1466.lb_tools:=Form:C1466.currentStep.tools.items
	Else 
		Form:C1466.lb_tools:=New collection:C1472()
	End if 
	
	
Function loadPMs()
	If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.parametricMeasurements#Null:C1517)
		Form:C1466.lb_pms:=Form:C1466.currentStep.parametricMeasurements.items
	Else 
		Form:C1466.lb_pms:=New collection:C1472()
	End if 
	
	
Function loadStepInterruptions()
	If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.stepInterruptions#Null:C1517)
		Form:C1466.lb_stepInterruptions:=Form:C1466.currentStep.stepInterruptions.items
	Else 
		Form:C1466.lb_stepInterruptions:=New collection:C1472()
	End if 
	
	
Function loadDataTables()
	If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.dataTables#Null:C1517)
		Form:C1466.lb_dataTables:=Form:C1466.currentStep.dataTables.items
	Else 
		Form:C1466.lb_dataTables:=New collection:C1472()
	End if 
	
Function displayBannerLotOnHold
	var $pict : Picture
	
	If (Form:C1466.current_item.onHold)
		OBJECT SET VISIBLE:C603(*; "banner_lotOnHold"; True:C214)
		$bannerMessage:="Lot On Hold"
		
		$svg:=SVG_New(285; 184)
		$group:=SVG_New_group($svg; "onHold")
		$rect:=SVG_New_rect($group; 0; 0; 500; 30; 0; 0; "green:50"; "orangered:50"; 1)
		$text:=SVG_New_text($group; $bannerMessage; 175; 7; "helvetica"; 10; Bold:K14:2; 3)
		SVG_SET_TRANSFORM_ROTATE($group; -30; 250; 20)
		SVG_SET_TRANSFORM_TRANSLATE($group; -50; 50)
		SVG EXPORT TO PICTURE:C1017($svg; $pict)
		SVG_CLEAR($svg)
	Else 
		OBJECT SET VISIBLE:C603(*; "banner_lotOnHold"; False:C215)
	End if 
	Form:C1466.bannerOnHold:=$pict
	
Function bActionChooseSkill()
	If (Form:C1466.currentToolType=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Tool Type Selected !")
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Choose a tool")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--choose")
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
		If (Not:C34(Form:C1466.sfw.checkIsInModification()))
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--choose")
				$form:=New object:C1471(\
					"toolType"; Form:C1466.currentToolType; \
					"lb_tools"; ds:C1482.Tool.query("UUID_ToolType = :1"; Form:C1466.currentToolType.UUID)\
					)
				
				$winRef:=Open form window:C675("chooseTool_punchIn"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("chooseTool_punchIn"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.currentToolType.tool.UUID:=$form.selectedTool.UUID
					Form:C1466.currentToolType.tool.name:=$form.selectedTool.name
					Form:C1466.currentToolType.tool.date:=$form.selectedTool.date
					
					$res:=Form:C1466.currentStep.save()
					
					If (Not:C34($res.success))
						Form:C1466.currentToolType.tool.UUID:=""
						Form:C1466.currentToolType.tool.name:=""
					End if 
					
					This:C1470.loadTools()
					
					This:C1470._activate_save_cancel_button()
				End if 
		End case 
	End if 
	
Function bActionStepInterruption()
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add an Interruption")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471(\
				"stepInterruption"; New object:C1471(\
				"startDate"; !00-00-00!; \
				"startTime"; ?00:00:00?; \
				"endDate"; !00-00-00!; \
				"endTime"; ?00:00:00?; \
				"engineer"; ""; \
				"description"; ""\
				))
			
			$winRef:=Open form window:C675("createStepInterruption_punchIn"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createStepInterruption_punchIn"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (ok=1)
				Form:C1466.currentStep.stepInterruptions.items.push($form.stepInterruption)
				
				$res:=Form:C1466.currentStep.save()
				
				If ($res.success)
					This:C1470.loadStepInterruptions()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
			
	End case 
	
	
Function bActionDataTables()
	If (Form:C1466.currentDataTable=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Data Table Selected !")
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Add a Data Table value")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
		If (Not:C34(Form:C1466.sfw.checkIsInModification()))
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--add")
				$value:=Request:C163("Add a Data Table value to "+Form:C1466.currentDataTable.key+" :")
				
				If (ok=1)
					Form:C1466.currentDataTable.value:=$value
					
					$res:=Form:C1466.currentStep.save()
					
					If ($res.success)
						This:C1470._activate_save_cancel_button()
					End if 
				End if 
		End case 
	End if 
	
Function bActionPMs()
	If (Form:C1466.currentPM=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Parametric Measurement Selected !")
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Add a Parametric Measurement value")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
		If (Not:C34(Form:C1466.sfw.checkIsInModification()))
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--add")
				$value:=Request:C163("Add a Parametric Measurement value to "+Form:C1466.currentPM.key+" :")
				
				If (ok=1)
					Form:C1466.currentPM.value:=$value
					
					$res:=Form:C1466.currentStep.save()
					
					If ($res.success)
						This:C1470._activate_save_cancel_button()
					End if 
				End if 
		End case 
	End if 