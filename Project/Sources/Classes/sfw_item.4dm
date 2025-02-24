Class extends sfw

Class constructor
	Super:C1705()
	
	
Function initOnLoad()
	
	var $color : Text
	
	OBJECT SET FORMAT:C236(*; "bIcon_entry"; This:C1470.entry.label+";#"+This:C1470.entry.icon+";0;0;0;1;0;0;0;0;0;0;1")
	
	$color:=This:C1470.vision.toolbar.color
	This:C1470.changeTopBarColor($color)
	
	
Function selectionChange()
	Form:C1466.current_clone:=Form:C1466.current_item.clone()
	Form:C1466.subForm.current_item:=Form:C1466.current_item
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_clone:=Form:C1466.current_item.clone()
		OBJECT GET SUBFORM:C1139(*; "detail_panel"; $table; $current_panel)
		If ($current_panel#This:C1470.entry.panel.name) && (Form:C1466.lastPanelDisplayed#This:C1470.entry.panel.name)
			This:C1470.displayItemPanel()
		Else 
			Form:C1466.subForm:=Form:C1466.subForm
		End if 
		
	Else 
		Form:C1466.current_clone:=Null:C1517
		OBJECT SET SUBFORM:C1138(*; "detail_panel"; "sfw_panel_default")
		
	End if 
	If (Form:C1466.situation.mode#"add") & (Form:C1466.situation.mode#"duplicate")
		This:C1470._change_bMode(Form:C1466.situation.mode)
	End if 
	
Function _displayHeaderTabFavorite()
	cs:C1710.sfw_favoriteManager.me._displayHeaderTabFavorite()
	
Function _displayHeaderTabComment()
	cs:C1710.sfw_commentManager.me._displayHeaderTabComment()
	
Function _displayHeaderTabEvent()
	cs:C1710.sfw_eventManager.me._displayHeaderTabEvent()