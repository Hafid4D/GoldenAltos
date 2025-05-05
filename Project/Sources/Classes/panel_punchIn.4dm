

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
	
Function loadXXX()
	//Loads and initializes a list
	
Function bActionXXX()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
Function checkForCertifications()->$valid : Boolean
	return True:C214
	
Function loadCurrentStep()
	If (This:C1470.checkForCertifications())
		Form:C1466.currentStep:=Null:C1517
		Form:C1466.currentStepOrder:=0
		$currentstep:=Form:C1466.current_item.steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
		
		If ($currentstep.length>0)
			Form:C1466.currentStep:=$currentstep[0]
			
			Form:C1466.currentStepOrder:=Form:C1466.currentStep.order
			
			OBJECT SET FORMAT:C236(*; "EntryField_comment1"; Form:C1466.currentStep.commentFormat1)
			OBJECT SET FILTER:C235(*; "EntryField_comment1"; Form:C1466.currentStep.commentFormat1)
			
			OBJECT SET FORMAT:C236(*; "EntryField_comment2"; Form:C1466.currentStep.commentFormat2)
			OBJECT SET FILTER:C235(*; "EntryField_comment2"; Form:C1466.currentStep.commentFormat2)
			
			If (Form:C1466.currentStep.tools=Null:C1517)
				Form:C1466.currentStep.tools:=New object:C1471("items"; New collection:C1472())
				
				If (Form:C1466.currentStep.stepTemplate#Null:C1517)
					For each ($stepTemplateTool; Form:C1466.currentStep.stepTemplate.stepTemplateTools)
						$tool_ob:=New object:C1471(\
							"order"; $stepTemplateTool.order; \
							"toolType"; $stepTemplateTool.toolType.name; \
							"tool"; New object:C1471("tool"; ""; "UUID_Tool"; ""); \
							"date"; !00-00-00!\
							)
					End for each 
				End if 
			End if 
			
			If (Form:C1466.currentStep.parametricMeasurements=Null:C1517)
				
			End if 
			
			If (Form:C1466.currentStep.stepInterruptions=Null:C1517)
				
			End if 
			
			If (Form:C1466.currentStep.dataTables=Null:C1517)
				
			End if 
			
			FORM GOTO PAGE:C247(1; *)
		Else 
			Form:C1466.currentStepOrder:=0
			FORM GOTO PAGE:C247(2; *)
		End if 
	Else 
		cs:C1710.sfw_dialog.me.alert("No Certification for this step !")
	End if 
	
Function loadTools()
	If (Form:C1466.currentStep#Null:C1517) && (Form:C1466.currentStep.tools#Null:C1517)
		Form:C1466.lb_tools:=Form:C1466.currentStep.tools.items
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
	If (Form:C1466.currentTool=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Tool Selected !")
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
				$form:=New object:C1471()
				
				$winRef:=Open form window:C675(""; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40(""; $form)
				CLOSE WINDOW:C154($winRef)
		End case 
	End if 
	
Function bActionStepInterruption()
	If (Form:C1466.currentStepInterruption=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Step Interruption Selected !")
	Else 
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
		End case 
	End if 
	
Function bActionDataTables()
	If (Form:C1466.currentDataTable=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Data Table Selected !")
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Add a Data TAble value")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
		If (Not:C34(Form:C1466.sfw.checkIsInModification()))
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--add")
		End case 
	End if 
	
Function bActionPMs()
	If (Form:C1466.currentPM=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("No Parametric Measurement Selected !")
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Add a Parametric Measurements")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
		If (Not:C34(Form:C1466.sfw.checkIsInModification()))
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--add")
				
		End case 
	End if 