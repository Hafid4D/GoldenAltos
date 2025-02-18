property ident : Text
property label : Text
property xliff : Text

Class constructor($ident : Text; $vision_ident : Variant; $labelPlurial : Text; $labelSingle : Text)
	
	This:C1470.ident:=$ident
	This:C1470.label:=$labelPlurial
	If ($labelSingle#"")
		This:C1470.labelSingle:=$labelSingle
	End if 
	This:C1470.toolbarLabel:=$labelPlurial
	This:C1470.visions:=New collection:C1472
	This:C1470.displayOrder:=0
	Case of 
		: (Value type:C1509($vision_ident)=Is text:K8:3)
			This:C1470.visions.push($vision_ident)
		: (Value type:C1509($vision_ident)=Is collection:K8:32)
			This:C1470.visions:=$vision_ident
	End case 
	This:C1470.xliff:=""
	This:C1470.searchbox:=New object:C1471("fields"; New collection:C1472; "specificSearches"; New collection:C1472)
	This:C1470.panel:=New object:C1471("name"; ""; "pages"; New collection:C1472)
	This:C1470.itemActions:=New collection:C1472
	This:C1470.itemListActions:=New collection:C1472
	This:C1470.itemListProjections:=New collection:C1472
	This:C1470.itemListOutsides:=New collection:C1472
	This:C1470.views:=New collection:C1472
	This:C1470.allowFavorite:=True:C214
	This:C1470.multiselection:=False:C215
	This:C1470.allowedProfiles:=New collection:C1472
	This:C1470.allowedProfilesForCreation:=New collection:C1472
	This:C1470.allowedProfilesForDeletion:=New collection:C1472
	This:C1470.allowedProfilesForModification:=New collection:C1472
	
Function setXliffLabel($xliff : Text)
	This:C1470.xliff:=$xliff
	
	
Function setDataclass($dataclass : Text)
	If (ds:C1482[$dataclass]=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("The dataclass "+$dataclass+" doesn't exist in the datastore.")
	Else 
		This:C1470.dataclass:=$dataclass
	End if 
	
	
Function setIcon($iconRelativePath : Text)
	This:C1470.icon:=$iconRelativePath
	
	
Function setToolBarGroup($ident : Text; $label : Text; $icon : Text; $displayOrder : Integer)
	If (This:C1470.toolBarGroup=Null:C1517)
		This:C1470.toolBarGroup:=New object:C1471
		This:C1470.toolBarGroup.ident:=$ident
		This:C1470.toolBarGroup.displayOrder:=0
	End if 
	If ($label#"")
		This:C1470.toolBarGroup.label:=$label
	End if 
	If ($icon#"")
		This:C1470.toolBarGroup.icon:=$icon
	End if 
	If ($displayOrder#0)
		This:C1470.displayOrder:=$displayOrder
	End if 
	
	
Function setToolbarLabel($label : Text)
	This:C1470.toolbarLabel:=$label
	
	
Function setDisplayOrder($order : Integer)
	This:C1470.displayOrder:=$order
	
	
Function setSearchboxField($attribute : Text;  ...  : Variant)
	var $field : Object:=New object:C1471
	
	$field.attribute:=$attribute
	
	For ($i; 2; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="placeholder")
				$field.fieldPlaceHolder:=$params[0]
		End case 
	End for 
	
	This:C1470.searchbox.fields.push($field)
	
	
Function setSearchboxSpecific($tag : Text;  ...  : Variant)
	var $specific : Object:=New object:C1471
	
	$specific.tag:=$tag
	For ($i; 2; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="queryString")
				$specific.queryString:=$params.join(":")
			: ($selector="formula")
				$specific.formula:=$params.join(":")
			: ($selector="collectionBuilder")
				$specific.collectionBuilder:=$params.join(":")
			: ($selector="inCollection")
				$specific.inCollection:=$params.join(":")
		End case 
	End for 
	This:C1470.searchbox.specificSearches.push($specific)
	
Function setPanel($panelName : Text; $currentPage : Integer)
	ARRAY TEXT:C222($_names; 0)
	FORM GET NAMES:C1167($_names)
	If (Find in array:C230($_names; $panelName)=-1)
		cs:C1710.sfw_dialog.me.alert("The panel \""+$panelName+"\" doesn't exist in the form list.")
	Else 
		This:C1470.panel.name:=$panelName
	End if 
	If (Count parameters:C259>1)
		This:C1470.panel.currentPage:=$currentPage
	End if 
	
	
Function setPanelPage($pageNum : Integer; $pict : Text; $label : Text;  ...  : Text)
	var $page : Object:=New object:C1471
	
	$page.page:=$pageNum
	$page.pict:=$pict
	If (Count parameters:C259>2)
		$page.label:=$label
	End if 
	
	For ($p; 4; Count parameters:C259)
		$params:=Split string:C1554(${$p}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="allowedProfiles")
				$page.allowedProfiles:=$params
		End case 
	End for 
	
	
	This:C1470.panel.pages.push($page)
	
	
Function setPanelDynamicPage($pageNum : Integer; $pict : Text; $label : Text; $dynamicSource : Object;  ...  : Text)
	var $page : Object:=New object:C1471
	
	This:C1470.panel.asDynamicSources:=True:C214
	$page.page:=$pageNum
	$page.pict:=$pict
	If (Count parameters:C259>2)
		$page.label:=$label
	End if 
	$page.dynamicSource:=$dynamicSource
	
	For ($p; 5; Count parameters:C259)
		$params:=Split string:C1554(${$p}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="allowedProfiles")
				$page.allowedProfiles:=$params
		End case 
	End for 
	
	
	This:C1470.panel.pages.push($page)
	
Function setLBItemsColumn($attribute : Text; $label : Text;  ...  : Text)
	
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	
	$params:=New collection:C1472
	For ($i; 1; Count parameters:C259)
		$params.push(${$i})
	End for 
	$view.setLBItemsColumn.apply($view; $params)
	
	
Function setLBItemsOrderBy($propertyPath : Text; $descending : Boolean)
	
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	
	$params:=New collection:C1472
	For ($i; 1; Count parameters:C259)
		$params.push(${$i})
	End for 
	$view.setLBItemsOrderBy.apply($view; $params)
	
Function setLBItemsCounter($format : Text;  ...  : Text)
	
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	
	$params:=New collection:C1472
	For ($i; 1; Count parameters:C259)
		$params.push(${$i})
	End for 
	$view.setLBItemsCounter.apply($view; $params)
	
Function setLBAllowedProfiles( ...  : Text)
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	
	$params:=New collection:C1472
	For ($i; 1; Count parameters:C259)
		$params.push(${$i})
	End for 
	$view.setAllowedProfiles.apply($view; $params)
	
Function setLBItemsMetaExpression($metaExpression : Text)
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	$view.setLBItemsMetaExpression($metaExpression)
	
	
Function setSubset($functionName : Text;  ...  : Variant)
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view=Null:C1517)
		$view:=cs:C1710.sfw_definitionView.new("main"; "Main view")
		This:C1470.setView($view)
	End if 
	
	$params:=New collection:C1472
	For ($i; 1; Count parameters:C259)
		$params.push(${$i})
	End for 
	$view.setSubset.apply($view; $params)
	
Function setAddable($addable : Boolean)
	If (Count parameters:C259>0)
		This:C1470.addable:=$addable
	Else 
		This:C1470.addable:=True:C214
	End if 
	
	
Function setItemAction($label : Text; $method : Text;  ...  : Text)
	var $action : Object:=New object:C1471
	
	$action.label:=$label
	$action.method:=$method
	For ($i; 3; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="xliff")
				$action.xliff:=$params[0]
			: ($selector="allowedProfiles")
				$action.allowedProfiles:=$params
			: ($selector="activateIf")
				$action.activateIf:=$params.join(":")
		End case 
	End for 
	This:C1470.itemActions.push($action)
	
	
Function setItemListAction($label : Text; $method : Text;  ...  : Text)
	var $action : Object:=New object:C1471
	
	$action.label:=$label
	$action.method:=$method
	For ($i; 3; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="xliff")
				$action.xliff:=$params[0]
			: ($selector="allowedProfiles")
				$action.allowedProfiles:=$params
		End case 
	End for 
	This:C1470.itemListActions.push($action)
	
	
Function setLinkedReferenceRecordsDataclasses( ...  : Text)
	var $i : Integer
	If (This:C1470.linkedReferenceRecordsDataclasses=Null:C1517)
		This:C1470.linkedReferenceRecordsDataclasses:=New collection:C1472
	End if 
	For ($i; 1; Count parameters:C259)
		This:C1470.linkedReferenceRecordsDataclasses.push(${$i})
	End for 
	
Function setItemListPreconfigAction($actionIdent : Text;  ...  : Text)
	var $action : Object:=New object:C1471
	$action.preconfigAction:=$actionIdent
	
	For ($i; 2; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="xliff")
				$action.xliff:=$params[0]
		End case 
	End for 
	
	Case of 
		: ($actionIdent="exportReferenceRecords") && (cs:C1710.sfw_userManager.me.canImportExportReferenceRecords())
			$action.label:="Export the reference records"
			This:C1470.itemListActions.push($action)
			
		: ($actionIdent="importReferenceRecords") && (cs:C1710.sfw_userManager.me.canImportExportReferenceRecords())
			$action.label:="Import the reference records"
			This:C1470.itemListActions.push($action)
			
		: ($actionIdent="copyItemsListToPasteboard") && (cs:C1710.sfw_userManager.me.canImportExportReferenceRecords())
			$action.label:="Copy this list to the pasteboard"
			This:C1470.itemListActions.push($action)
			
	End case 
	
	
Function setItemListProjection($label : Text; $function : Text; $entryIdent : Text; $visionIdent : Text;  ...  : Text)
	var $projection : Object:=New object:C1471
	
	$projection.label:=$label
	$projection.function:=$function
	$projection.entryIdent:=$entryIdent
	$projection.visionIdent:=$visionIdent
	For ($i; 3; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="xliff")
				$projection.xliff:=$params[0]
		End case 
	End for 
	This:C1470.itemListProjections.push($projection)
	
	
Function setPanelAfterProjection($panel : Text)
	This:C1470.panelAfterProjectionIfNoItemSelected:=$panel
	
Function setPanelIfNoItemSelected($panel : Text)
	This:C1470.panelIfNoItemSelected:=$panel
	
	
Function setItemListOutside($label : Text; $function : Text;  ...  : Text)
	var $action : Object:=New object:C1471
	
	$action.label:=$label
	$action.function:=$method
	For ($i; 3; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="xliff")
				$action.xliff:=$params[0]
		End case 
	End for 
	This:C1470.itemListOutsides.push($action)
	
	
	
Function setValidationRule($field : Text; $widget : Text;  ...  : Text)
	var $rule : Object:=New object:C1471
	
	$rule.field:=$field
	$rule.widget:=$widget
	
	For ($i; 3; Count parameters:C259)
		$params:=Split string:C1554(${$i}; ":")
		$selector:=$params.shift()
		Case of 
			: ($selector="mandatory")
				$rule.mandatory:=True:C214
			: ($selector="trimSpace")
				$rule.trimSpace:=True:C214
			: ($selector="capitalize")
				$rule.capitalize:=True:C214
			: ($selector="uppercase")
				$rule.uppercase:=True:C214
			: ($selector="unique")
				$rule.unique:=True:C214
			: ($selector="UUIDNotNull")
				$rule.UUIDNotNull:=True:C214
				
			: ($selector="message")
				$rule.message:=$params.join(":")
		End case 
	End for 
	This:C1470.validationRules:=This:C1470.validationRules || New collection:C1472
	This:C1470.validationRules.push($rule)
	
Function setWizard($panel : Text;  ...  : Text)
	This:C1470.wizard:=This:C1470.wizard || New object:C1471
	This:C1470.wizard.panel:=$panel
	For ($i; 2; Count parameters:C259)
		$param:=${$i}
		Case of 
			: ($param="palette")
				This:C1470.wizard.palette:=True:C214
		End case 
	End for 
	
Function setVirtual($type : Text)
	This:C1470.virtual:=$type
	
	Case of 
		: ($type="collection")
			This:C1470.items:=New collection:C1472
			
	End case 
	
	
Function setVirtualItem($item : cs:C1710.sfw_definitionVirtualItem)
	
	This:C1470.items.push($item)
	
Function activateComment()
	
	If (ds:C1482["sfw_Comment"]=Null:C1517)
		cs:C1710.sfw_dialog.me.alert("The table sfw_Comment is missing to use the comment managment feature.")
	End if 
	
	This:C1470.comment:=New object:C1471
	This:C1470.comment.unit0:="no comment"
	This:C1470.comment.unit1:="one comment"
	This:C1470.comment.unitN:="comments"
	
	
Function enableTransaction()
	
	This:C1470.transaction:=New object:C1471
	
	
	//mark:- Views
	
Function setView($view : cs:C1710.sfw_definitionView)
	
	This:C1470.views.push($view)
	
Function setMainViewLabel($label : Text)
	
	var $view : cs:C1710.sfw_definitionView
	$view:=This:C1470.views.query("ident = :1"; "main").first()
	If ($view#Null:C1517)
		$view.label:=$label
	End if 
	
	
	//mark:-Events
	
Function activateEvent($eventDataclass : Text; $linkedAttrribute : Text)
	This:C1470.event:=This:C1470.event || New object:C1471("attributesToTrackInModificationEvent"; New collection:C1472; "linksManyToOneToTrackInModificationEvent"; New collection:C1472; "attributeStmpToTrackInModificationEvent"; New collection:C1472)
	If (Count parameters:C259=0)
		This:C1470.event.dataclass:=This:C1470.dataclass+"Event"
		This:C1470.event.linkedAttribute:="UUID_"+This:C1470.dataclass
	Else 
		This:C1470.event.dataclass:=$eventDataclass
		This:C1470.event.linkedAttribute:=$linkedAttrribute
	End if 
	
	
Function setAttributesToTrackInModificationEvent( ...  : Text)
	For ($p; 1; Count parameters:C259)
		$param:=Split string:C1554(${$p}; " ").join(" "; ck ignore null or empty:K85:5)
		$params:=New collection:C1472
		Case of 
			: ($param="@ @")
				$part:=Split string:C1554($param; " ")
			: ($param="@,@")
				$part:=Split string:C1554($param; ",")
			: ($param="@;@")
				$part:=Split string:C1554($param; ";")
			Else 
				$params:=New collection:C1472($param)
		End case 
		For each ($param; $params)
			This:C1470.event.attributesToTrackInModificationEvent.push($param)
		End for each 
	End for 
	
Function setLinkManyToOneToTrackInModificationEvent($name : Text; $attributeForLink : Text; $linkToFollow : Text)
	$link:=New object:C1471
	$link.name:=$name
	$link.attributeForLink:=$attributeForLink
	$link.linkToFollow:=$linkToFollow
	This:C1470.event.linksManyToOneToTrackInModificationEvent.push($link)
	
Function setAttributeStmpToTrackInModificationEvent($name : Text; $attributeName : Text; $type : Integer)
	$attribute:=New object:C1471
	$attribute.name:=$name
	$attribute.attribute:=$attributeName
	$attribute.type:=$type || Is date:K8:7
	This:C1470.event.attributeStmpToTrackInModificationEvent.push($attribute)
	
Function setEventOptions( ...  : Text)
	
	For ($p; 1; Count parameters:C259)
		$param:=${$p}
		Case of 
			: ($param="dontCreateModifyEventIfNoTrackingAttribute")
				This:C1470.event.dontCreateModifyEventIfNoTrackingAttribute:=True:C214
		End case 
	End for 
	
	//mark:-Filters
Function addFilter($filter : cs:C1710.sfw_definitionFilter)
	
	This:C1470.filters:=This:C1470.filters || New collection:C1472
	This:C1470.filters.push($filter)
	
	
	//Mark:-
	
Function setSpecificAddMode($ident : Text; $label : Text; $iconpath : Text; $memberFunction : Text)
	
	This:C1470.specificAddModes:=This:C1470.specificAddModes || New collection:C1472
	
	$specificAddMode:=New object:C1471
	$specificAddMode.ident:=$ident
	$specificAddMode.label:=$label
	$specificAddMode.iconpath:=$iconpath
	$specificAddMode.memberFunction:=$memberFunction
	
	This:C1470.specificAddModes.push($specificAddMode)
	
	
	
Function activateFavorite($activate : Boolean)
	If (Count parameters:C259=0)
		This:C1470.allowFavorite:=True:C214
	Else 
		This:C1470.allowFavorite:=$activate
	End if 
	
	
Function allowMultiSelectionInLB($allow : Boolean)
	
	If (Count parameters:C259=0)
		This:C1470.multiselection:=True:C214
	Else 
		This:C1470.multiselection:=$allow
	End if 
	
	
Function setAllowedProfiles( ...  : Text)
	var $p : Integer
	For ($p; 1; Count parameters:C259)
		This:C1470.allowedProfiles.push(${$p})
	End for 
	
	
Function setAllowedProfilesForCreation( ...  : Text)
	var $p : Integer
	For ($p; 1; Count parameters:C259)
		This:C1470.allowedProfilesForCreation.push(${$p})
	End for 
	
	
Function setAllowedProfilesForDeletion( ...  : Text)
	var $p : Integer
	For ($p; 1; Count parameters:C259)
		This:C1470.allowedProfilesForDeletion.push(${$p})
	End for 
	
	
Function setAllowedProfilesForModification( ...  : Text)
	var $p : Integer
	For ($p; 1; Count parameters:C259)
		This:C1470.allowedProfilesForModification.push(${$p})
	End for 
	
	