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
	
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	Form:C1466.sfw.drawHTab()
	
	
	
Function drawPup_priority()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIPriority"; "priorityID"; "priority"; "pup_priority")
/*
$improvementPriority:=ds.CIPriority.query("priorityID= :1"; Form.current_item.priority).first() || New object()
$priorityName:=$improvementPriority.name
If ($priorityName=Null)
$priorityName:=""
End if 
$color:=cs.sfw_htmlColor.me.getName($improvementPriority.color)
$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
Form.sfw.drawButtonPup("pup_priority"; $priorityName; $pathIcon; ($improvementPriority=Null))
*/
	End if 
	
	
Function pup_priority()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementPriorities"; "CIPriority"; "priorityID"; "priority")
/*
If (Form.sfw.checkIsInModification())
$menu:=Create menu
If (Storage.cache=Null) || (Storage.cache.ImprovementPriorities=Null)
ds.CIPriority.cacheLoad()
End if 
	
For each ($eImprovementPriority; Storage.cache.ImprovementPriorities)
APPEND MENU ITEM($menu; $eImprovementPriority.name; *)
SET MENU ITEM PARAMETER($menu; -1; $eImprovementPriority.UUID)
If ($eImprovementPriority.priorityID=Form.current_item.priority)
SET MENU ITEM MARK($menu; -1; Char(18))
If (Is Windows)
SET MENU ITEM STYLE($menu; -1; Bold)
End if 
End if 
End for each 
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
	
Case of 
: ($choose#"")
$eImprovementPriority:=ds.CIPriority.get($choose)
Form.current_item.priority:=$eImprovementPriority.priorityID
End case 
	
End if 
*/
	This:C1470.drawPup_priority()
	
	
Function drawPup_origin()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIOrigin"; "originID"; "origin"; "pup_origin")
/*
$improvementOrigin:=ds.CIOrigin.query("originID= :1"; Form.current_item.origin).first() || New object()
$originName:=$improvementOrigin.name
If ($originName=Null)
$originName:=""
End if 
$color:=""  //cs.sfw_htmlColor.me.getName($improvementOrigin.color)
$pathIcon:=""  //($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
Form.sfw.drawButtonPup("pup_origin"; $originName; $pathIcon; ($improvementOrigin=Null))
*/
	End if 
	
	
Function pup_origin()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementOrigins"; "CIOrigin"; "originID"; "origin")
/*
If (Form.sfw.checkIsInModification())
$menu:=Create menu
If (Storage.cache=Null) || (Storage.cache.ImprovementOrigins=Null)
ds.CIOrigin.cacheLoad()
End if 
	
For each ($eImprovementOrigin; Storage.cache.ImprovementOrigins)
APPEND MENU ITEM($menu; $eImprovementOrigin.name; *)
SET MENU ITEM PARAMETER($menu; -1; $eImprovementOrigin.UUID)
If (Num($eImprovementOrigin.originID)=Form.current_item.origin)
SET MENU ITEM MARK($menu; -1; Char(18))
If (Is Windows)
SET MENU ITEM STYLE($menu; -1; Bold)
End if 
End if 
End for each 
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
	
Case of 
: ($choose#"")
$eImprovementOrigin:=ds.CIOrigin.get($choose)
Form.current_item.origin:=$eImprovementOrigin.originID
End case 
	
End if 
*/
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
	
	
	
	