var $refMenus : Collection  // a collection to store the references of menus to be able to release later
var $mainLevel; $tagMenu : Text  //references of menus
var $tags : Collection  // a collection of all the available tags
var $tag : Text  // a tag
var $field : Object  // a object to describe the field
var $choose : Text  // the parameter selected in the popup menu
var $startSel; $endSel : Integer  // positions for the selection in the searchbox

If (Form:C1466.sfw.entry.searchfields#Null:C1517)
	$refMenus:=New collection:C1472()
	
	$mainLevel:=Create menu:C408()
	$refMenus.push($mainLevel)
	
	$tagMenu:=Create menu:C408()
	$refMenus.push($tagMenu)
	
	$tags:=New collection:C1472()
	For each ($field; Form:C1466.sfw.entry.searchfields)
		If ($field.tag#Null:C1517)
			$tags.push($field.tag)
		End if 
		If ($field.tags#Null:C1517)
			$tags:=$tags.combine($field.tags)
		End if 
	End for each 
	$tags:=$tags.distinct()  // remember than distinct will order your result collection
	For each ($tag; $tags)
		APPEND MENU ITEM:C411($tagMenu; $tag; *)
		SET MENU ITEM PARAMETER:C1004($tagMenu; -1; "--tag:"+$tag)
	End for each 
	APPEND MENU ITEM:C411($mainLevel; "tags"; $tagMenu)
	
	$indices:=Form:C1466.sfw.entry.searchfields.indices("type = :1"; Is date:K8:7)
	If ($indices.length>0)
		$dateMenu:=Create menu:C408()
		$refMenus.push($dateMenu)
		$dates:=Split string:C1554("today;tomorrow;yesterday;7lastdays;7nextdays;thisWeek;lastWeek;nextWeek;thisMonth;lastMonth;nextMonth;thisYear;lastYear;nextYear"; ";").orderBy()
		For each ($date; $dates)
			APPEND MENU ITEM:C411($dateMenu; $date; *)
			SET MENU ITEM PARAMETER:C1004($dateMenu; -1; "--date:"+$date)
		End for each 
		APPEND MENU ITEM:C411($mainLevel; "dates"; $dateMenu)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainLevel)
	For each ($refMenu; $refMenus)
		RELEASE MENU:C978($refMenu)  //don't forget to release all the menu and submenus created
	End for each 
	
	Case of 
		: ($choose="--tag:@")
			$tag:=Substring:C12($choose; 7)+":"
			GET HIGHLIGHT:C209(*; "searchbox"; $startSel; $endSel)
			Form:C1466.sfw.searchbox:=Substring:C12(Form:C1466.sfw.searchbox; 1; $startSel-1)+$tag+Substring:C12(Form:C1466.sfw.searchbox; $endSel)
			HIGHLIGHT TEXT:C210(*; "searchbox"; $startSel+Length:C16($tag); $startSel+Length:C16($tag))
			Form:C1466.sfw.lb_items_search()
			
		: ($choose="--date:@")
			$date:=Substring:C12($choose; 8)
			GET HIGHLIGHT:C209(*; "searchbox"; $startSel; $endSel)
			Form:C1466.sfw.searchbox:=Substring:C12(Form:C1466.sfw.searchbox; 1; $startSel-1)+$date+Substring:C12(Form:C1466.sfw.searchbox; $endSel)
			HIGHLIGHT TEXT:C210(*; "searchbox"; $startSel+Length:C16($date); $startSel+Length:C16($date))
			Form:C1466.sfw.lb_items_search()
			
	End case 
End if 