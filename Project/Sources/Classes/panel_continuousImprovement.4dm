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
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.drawPup_priority()
	This:C1470.drawPup_origin()
	This:C1470.drawPup_category()
	This:C1470.drawPup_disposition()
	This:C1470.drawPup_humanFactor()
	This:C1470.drawPup_yesNoQuestion()
	This:C1470.drawPup_procedureType()
	
	If (OBJECT Get title:C1068(*; "pup_procedure")="QCAR#@")
		OBJECT SET ENTERABLE:C238(*; "entryField_action"; False:C215)
	Else 
		OBJECT SET ENTERABLE:C238(*; "entryField_action"; True:C214)
	End if 
	
	OBJECT SET ENTERABLE:C238(*; "entryField_responsible"; False:C215)
	
	OBJECT SET VISIBLE:C603(*; "bResponsibleEdit"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "bActionRefresh"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	Form:C1466.sfw.drawHTab()
	
	
	
Function drawPup_priority()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIPriority"; "priorityID"; "priority"; "pup_priority")
	End if 
	
	
Function pup_priority()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementPriorities"; "CIPriority"; "priorityID"; "priority")
	This:C1470.drawPup_priority()
	
	
Function drawPup_origin()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIOrigin"; "originID"; "origin"; "pup_origin")
	End if 
	
	
Function pup_origin()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementOrigins"; "CIOrigin"; "originID"; "origin")
	This:C1470.drawPup_origin()
	
	
Function drawPup_category()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CICategory"; "categoryID"; "category"; "pup_category")
	End if 
	
	
Function pup_category()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementCategories"; "CICategory"; "categoryID"; "category")
	This:C1470.drawPup_category()
	
	
Function drawPup_disposition()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIDisposition"; "dispositionID"; "disposition"; "pup_disposition")
	End if 
	
	
Function pup_disposition()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementDispositions"; "CIDisposition"; "dispositionID"; "disposition")
	This:C1470.drawPup_disposition()
	
	
	
Function drawPup_humanFactor()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIHumanFactor"; "factorID"; "humanFactor"; "pup_humanFactor")
	End if 
	
	
Function pup_humanFactor()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementFactors"; "CIHumanFactor"; "factorID"; "humanFactor")
	This:C1470.drawPup_humanFactor()
	
	
Function drawPup_yesNoQuestion()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("YesNoQuestion"; "responseID"; "IsAcceptable"; "pup_yesNoQuestion")
	End if 
	
	
Function pup_yesNoQuestion()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementResponses"; "YesNoQuestion"; "responseID"; "IsAcceptable")
	This:C1470.drawPup_yesNoQuestion()
	
	
Function drawPup_procedureType()
	If (Form:C1466.current_item#Null:C1517)
		If (Form:C1466.current_item.action="QCAR#@")
			OBJECT SET TITLE:C194(*; "pup_procedure"; Form:C1466.current_item.action)
			
		Else 
			OBJECT SET TITLE:C194(*; "pup_procedure"; "")
			
		End if 
		
		If (Form:C1466.sfw.checkIsInModification())
			
			OBJECT SET FORMAT:C236(*; "pup_procedure"; ";#sfw/image/skin/rainbow/icon/spacer-1x24.png;0;3;1;1;8;0;0;0;1;0;1")
		Else 
			OBJECT SET FORMAT:C236(*; "pup_procedure"; ";#sfw/image/skin/rainbow/icon/spacer-1x24.png;0;3;1;1;0;0;0;0;0;0;1")
		End if 
		
	End if 
	
	
Function pup_procedureType()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT GET COORDINATES:C663(*; "pup_procedure"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "qcarNumberRef"; \
			"lb_items"; ds:C1482.Qcar.all().toCollection().map(Formula:C1597(_ga_getQRef)); \
			"allData"; ds:C1482.Qcar.all().toCollection().map(Formula:C1597(_ga_getQRef)); \
			"dataclass"; "Qcar"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.action:=$form.item.qcarNumberRef
			cs:C1710.panel_continuousImprovement.me._activate_save_cancel_button()
		End if 
		
	End if 
	
	This:C1470.drawPup_procedureType()
	
	
Function refreshAction()
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT SET TITLE:C194(*; "pup_procedure"; "")
		Form:C1466.current_item.action:=""
		cs:C1710.panel_continuousImprovement.me._activate_save_cancel_button()
		
	End if 
	
	
Function responsibleEdit()
	If (Form:C1466.sfw.checkIsInModification())
		
		$form:=New object:C1471
		
		var $teams : cs:C1710.TeamSelection
		var $staffs : cs:C1710.StaffEntity
		var $hListItems : Collection
		var hSousListItems; $memberShips; $teamMembers : Collection
		
		$memberShips:=New collection:C1472()
		$hListItems:=New collection:C1472()
		hSousListItems:=New collection:C1472()
		$teamMembers:=New collection:C1472()
		
		$teams:=ds:C1482.Team.all()
		$hListItems:=ds:C1482.Team.all().toCollection().extract("name")
		hListItems:=New collection:C1472()
		
		For each ($team; $teams)
			$memberShips:=$team.memberships.extract("UUID_Staff")
			$staffs:=ds:C1482.Staff.query("UUID in :1"; $memberShips)
			$teamMembers:=New collection:C1472()
			For each ($staff; $staffs)
				$obj:=New object:C1471("selected"; False:C215; "staffName"; String:C10($staff.firstName+" "+$staff.lastName))
				$teamMembers.push($obj)
				
			End for each 
			hSousListItems.push($teamMembers)
		End for each 
		
		For ($i; 0; $hListItems.length-1)
			$obj:=New object:C1471("selected"; False:C215; "teamName"; $hListItems[$i]; "members"; hSousListItems[$i])
			hListItems.push($obj)
		End for 
		
		
		$responsibles:=Split string:C1554(Form:C1466.current_item.responsible; ",")
		
		For ($k; 0; $responsibles.length-1)
			
			For ($i; 0; hListItems.length-1)
				
				If (hListItems[$i].teamName=$responsibles[$k])
					
					hListItems[$i].selected:=True:C214
					
				Else 
					
					For ($j; 0; hSousListItems[$i].length-1)
						
						If (hSousListItems[$i][$j].staffName=$responsibles[$k])
							
							hSousListItems[$i][$j].selected:=True:C214
							
						End if 
						
					End for 
					
				End if 
				
			End for 
			
		End for 
		
		
		$form.teams:=hListItems
		$winRef:=Open form window:C675("_ga_staffsPerTeam"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
		DIALOG:C40("_ga_staffsPerTeam"; $form)
		
		If (OK=1)
			
			$responsables:=New collection:C1472()
			$choices:=$form.teams
			
			For ($i; 0; $choices.length-1)
				
				If ($choices[$i].selected=True:C214) & ($responsables.indexOf($choices[$i].teamName)=-1)
					$responsables.push($choices[$i].teamName)
					
				Else 
					
					For ($j; 0; $choices[$i].members.length-1)
						
						If ($choices[$i].members[$j].selected=True:C214) & ($responsables.indexOf($choices[$i].members[$j].staffName)=-1)
							$responsables.push($choices[$i].members[$j].staffName)
						End if 
						
					End for 
					
				End if 
				
			End for 
			
			
			Form:C1466.current_item.responsible:=$responsables.join(",")
			cs:C1710.panel_continuousImprovement.me._activate_save_cancel_button()
		End if 
		
	End if 
	
	