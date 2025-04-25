Class constructor($ident : Text)
	
	This:C1470.ident:=$ident
	
	
	
	
	
Function _insertDynamicDocumentsPage($formDefinition : Object; $panelPage : Object; $offsetHorizontal : Integer; $offsetVertical : Integer)
	var $pageDefinition : Object
	$dynamicSource:=$panelPage.dynamicSource
	OBJECT GET COORDINATES:C663(*; "detail_panel"; $g; $h; $d; $b)
	$widthDetailPanel:=$d-$g
	$heightDetailPanel:=$b-$h
	
	$widthLH:=300
	$heightProperties:=150
	
	$pageDefinition:=$formDefinition.pages[$panelPage.page]
	$gutter:=5
	
	
	//bkgd_hl_list
	$bkgdProperties:=New object:C1471
	$bkgdProperties.type:="rectangle"
	$bkgdProperties.top:=$offsetVertical
	$bkgdProperties.left:=$offsetHorizontal
	$bkgdProperties.width:=$widthLH
	$bkgdProperties.height:=$heightDetailPanel-$offsetVertical-$heightProperties
	$bkgdProperties.fill:="#FDF3FC"
	$bkgdProperties.stroke:="#C0C0C0"
	$pageDefinition.objects["bkgd_hl_"+$dynamicSource.ident]:=$bkgdProperties
	
	// bAction
	$bActionproperties:=New object:C1471
	$bActionproperties.type:="button"
	$bActionproperties.text:="Actions"
	$bActionproperties.width:=80
	$bActionproperties.height:=21
	$bActionproperties.top:=$heightDetailPanel-$gutter-$bActionproperties.height-$heightProperties
	$marginBottom:=$gutter+$bActionproperties.height+$gutter
	$bActionproperties.left:=$gutter+$offsetHorizontal
	$bActionproperties.events:=["onClick"]
	$bActionproperties.style:="custom"
	$bActionproperties.popupPlacement:="linked"
	$bActionproperties.icon:="/RESOURCES/sfw/image/picto/gear.png"
	$bActionproperties.textPlacement:="right"
	$bActionproperties.method:="sfw_dynamicPage_bAction"
	$bActionproperties.sizingY:="move"
	$pageDefinition.objects["bAction_"+$dynamicSource.ident]:=$bActionproperties
	
	//HL List
	$bHLProperties:=New object:C1471
	$bHLProperties.type:="list"
	$bHLProperties.top:=$offsetVertical+1
	$bHLProperties.left:=$offsetHorizontal
	$bHLProperties.width:=$widthLH
	$bHLProperties.height:=$heightDetailPanel-$bHLProperties.top-$marginBottom-$heightProperties-1
	$bHLProperties.events:=["onSelectionChange"; "onClick"]
	$bHLProperties.scrollbarHorizontal:="hidden"
	$bHLProperties.borderStyle:="none"
	$bHLProperties.fill:="transparent"
	$bHLProperties.enterable:=False:C215
	$bHLProperties.focusable:=False:C215
	$bHLProperties.dataSource:="Form.hl_documents"
	$bHLProperties.sizingY:="grow"
	$bHLProperties.method:="sfw_dynamicPage_hl_document"
	$pageDefinition.objects["hl_"+$dynamicSource.ident]:=$bHLProperties
	
	//bkgd_properties
	$bkgdProperties:=New object:C1471
	$bkgdProperties.type:="rectangle"
	$bkgdProperties.top:=$offsetVertical+$heightDetailPanel-$offsetVertical-$heightProperties
	$bkgdProperties.left:=$offsetHorizontal
	$bkgdProperties.width:=$widthLH
	$bkgdProperties.height:=$heightProperties
	$bkgdProperties.fill:="#EDF3FC"
	$bkgdProperties.stroke:="#C0C0C0"
	$pageDefinition.objects["bkgd_properties_"+$dynamicSource.ident]:=$bkgdProperties
	
	//title_properties
	$titlePropProperties:=New object:C1471
	$titlePropProperties.type:="text"
	$titlePropProperties.text:="Properties"  //XLIFF
	$titlePropProperties.top:=$offsetVertical+$heightDetailPanel-$offsetVertical-$heightProperties+$gutter
	$titlePropProperties.height:=16
	$titlePropProperties.left:=$gutter+$offsetHorizontal
	$titlePropProperties.with:=150
	$titlePropProperties.stroke:="#808080"
	$pageDefinition.objects["title_properties_"+$dynamicSource.ident]:=$titlePropProperties
	
	//pictPreview
	$pictPreviewProperties:=New object:C1471
	$pictPreviewProperties.type:="input"
	$pictPreviewProperties.top:=$offsetVertical
	$pictPreviewProperties.height:=$heightDetailPanel-$offsetVertical
	$pictPreviewProperties.left:=$widthLH
	$pictPreviewProperties.with:=$widthDetailPanel-$widthLH
	$pictPreviewProperties.enterable:=False:C215
	$pictPreviewProperties.focusable:=False:C215
	$pictPreviewProperties.dataSource:="Form.document_pictPreview"
	$pictPreviewProperties.dataSourceTypeHint:="picture"
	$pictPreviewProperties.sizingY:="grow"
	$pictPreviewProperties.sizingX:="grow"
	$pictPreviewProperties.pictureFormat:="truncatedCenter"
	$pictPreviewProperties.borderStyle:="none"
	$pictPreviewProperties.events:=["onClick"]
	$pictPreviewProperties.contextMenu:="none"
	$pageDefinition.objects["pictPreview_"+$dynamicSource.ident]:=$pictPreviewProperties
	
	
	
Function _setDataSourceForDynamicPage()
	
	If (Form:C1466.hl_documents#Null:C1517) && (Is a list:C621(Form:C1466.hl_documents))
		CLEAR LIST:C377(Form:C1466.hl_documents; *)
	End if 
	
	If (Form:C1466.hl_icon_folder=Null:C1517)
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/image/hl/folder-horizontal.png")
		READ PICTURE FILE:C678($file.platformPath; $pict)
		Form:C1466.hl_icon_folder:=$pict
	End if 
	If (Form:C1466.hl_icon_document=Null:C1517)
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/image/hl/document.png")
		READ PICTURE FILE:C678($file.platformPath; $pict)
		Form:C1466.hl_icon_document:=$pict
	End if 
	
	If (Form:C1466.documentFolders=Null:C1517)
		Form:C1466.documentFolders:=ds:C1482.sfw_DocumentFolder.all().toCollection()
	End if 
	Form:C1466.documents:=ds:C1482.sfw_Document.query("UUID_target = :1"; Form:C1466.current_item.UUID).toCollection()
	
	Form:C1466.hl_documents:=This:C1470._buildHLDocuments()
	Form:C1466.hl_current_ref:=0
	
Function _buildHLDocuments($uuidParent : Text)->$refList : Integer
	
	If (Count parameters:C259=0)
		Form:C1466.hl_documents_refCounter:=0
		$documentFolders:=Form:C1466.documentFolders.query("UUID_ParentFolder = :1"; (16*"00"))
		$documents:=New collection:C1472
	Else 
		$documentFolders:=Form:C1466.documentFolders.query("UUID_ParentFolder = :1"; $uuidParent)
		$documents:=Form:C1466.documents.query("UUID_DocumentFolder = :1 order by name"; $uuidParent)
		
	End if 
	$documentFolders:=$documentFolders.orderBy("name")
	$refList:=New list:C375
	For each ($documentFolder; $documentFolders)
		$sublist:=This:C1470._buildHLDocuments($documentFolder.UUID)
		If (Count list items:C380($sublist)=0)
			CLEAR LIST:C377($sublist)
			$sublist:=0
		End if 
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376($refList; $documentFolder.name; Form:C1466.hl_documents_refCounter; $sublist; True:C214)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "UUID"; $documentFolder.UUID)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "kind"; "folder")
		SET LIST ITEM PROPERTIES:C386($refList; Form:C1466.hl_documents_refCounter; False:C215; Bold:K14:2)
		$pict:=Form:C1466.hl_icon_folder
		SET LIST ITEM ICON:C950($refList; Form:C1466.hl_documents_refCounter; $pict)
	End for each 
	For each ($document; $documents)
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376($refList; $document.name; Form:C1466.hl_documents_refCounter)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; Additional text:K28:7; String:C10($document.date; Internal date short:K1:7))
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "UUID"; $document.UUID)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "kind"; "document")
		$pict:=Form:C1466.hl_icon_document
		SET LIST ITEM ICON:C950($refList; Form:C1466.hl_documents_refCounter; $pict)
	End for each 
	
	
Function _bAction()
	
	
	$refMenus:=New collection:C1472
	$refMenu:=Create menu:C408
	$refMenus.push($refMenu)
	
	$refSubMenu:=Create menu:C408
	$refMenus.push($refSubMenu)
	APPEND MENU ITEM:C411($refSubMenu; "Template 1"; *)
	APPEND MENU ITEM:C411($refSubMenu; "Template 2"; *)
	APPEND MENU ITEM:C411($refSubMenu; "-")
	APPEND MENU ITEM:C411($refSubMenu; "Free write"; *)
	
	
	APPEND MENU ITEM:C411($refMenu; "Add a new document"; $refSubMenu; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/plus-circle.png")
	If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.hl_current_ref#0) && (Form:C1466.hl_current_kind="folder")
	Else 
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Upload a file"; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--upload")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/upload.png")
	If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.hl_current_ref#0) && (Form:C1466.hl_current_kind="folder")
	Else 
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "-")
	
	APPEND MENU ITEM:C411($refMenu; "Delete"; *)  //XLIFF
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/minus-circle.png")
	If (Form:C1466.hl_current_kind="folder")
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Download"; *)  //XLIFF
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/download.png")
	
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	For each ($refMenu; $refMenus)
		RELEASE MENU:C978($refMenu)
	End for each 
	
	Case of 
		: ($choose="--add")
			This:C1470._add_document()
			
		: ($choose="--upload")
			This:C1470._uploadFile()
	End case 
	
	
Function _hl_document()
	
	
	GET LIST ITEM:C378(Form:C1466.hl_documents; *; $refItem; $textItem; $sublist)
	Form:C1466.hl_current_ref:=$refItem
	Form:C1466.hl_current_text:=$textItem
	Form:C1466.hl_current_sublist:=$sublist
	GET LIST ITEM PARAMETER:C985(Form:C1466.hl_documents; Form:C1466.hl_current_ref; "UUID"; $uuid)
	Form:C1466.hl_current_uuid:=$uuid
	GET LIST ITEM PARAMETER:C985(Form:C1466.hl_documents; Form:C1466.hl_current_ref; "kind"; $kind)
	Form:C1466.hl_current_kind:=$kind
	
	Case of 
		: (FORM Event:C1606.code=On Clicked:K2:4) && (Right click:C712)
			This:C1470._bAction()
			
	End case 
	
	
	
	
Function _add_document()
	var $eDocument : cs:C1710.sfw_DocumentEntity
	
	$uuid_folder:=Form:C1466.hl_current_uuid
	
	$eDocument:=ds:C1482.sfw_Document.new()
	$eDocument.UUID:=Generate UUID:C1066
	$eDocument.UUID_DocumentFolder:=$uuid_folder
	$eDocument.UUID_target:=Form:C1466.current_item.UUID
	$eDocument.UUID_User:=cs:C1710.sfw_userManager.me.info.UUID
	$eDocument.name:=Replace string:C233("New ##1## document"; "##1##"; Form:C1466.hl_current_text)  //XLIFF
	$eDocument.stmp:=cs:C1710.sfw_stmp.me.now()
	$eDocument.moreData:=New object:C1471
	$info:=$eDocument.save()
	
	If (Form:C1466.hl_current_sublist=0)
		Form:C1466.hl_current_sublist:=New list:C375
		SET LIST ITEM:C385(Form:C1466.hl_documents; Form:C1466.hl_current_ref; Form:C1466.hl_current_text; Form:C1466.hl_current_ref; Form:C1466.hl_current_sublist; True:C214)
	End if 
	
	Form:C1466.hl_documents_refCounter+=1
	APPEND TO LIST:C376(Form:C1466.hl_current_sublist; $eDocument.name; Form:C1466.hl_documents_refCounter)
	SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "UUID"; $eDocument.UUID)
	SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "kind"; "document")
	$pict:=Form:C1466.hl_icon_document
	SET LIST ITEM ICON:C950(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; $pict)
	SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter)
	
	
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	This:C1470._displayDocument()
	
Function _uploadFile()
	var $file : 4D:C1709.File
	ARRAY TEXT:C222($_file; 0)
	$fileSelected:=Select document:C905(7638; ""; "Select the file to upload"; Use sheet window:K24:11; $_file)
	If (ok=1) && (Size of array:C274($_file)>0)
		$file:=File:C1566($_file{1}; fk platform path:K87:2)
		
		$eDocument:=ds:C1482.sfw_Document.new()
		$eDocument.UUID:=Generate UUID:C1066
		$eDocument.UUID_DocumentFolder:=$uuid_folder
		$eDocument.UUID_target:=Form:C1466.current_item.UUID
		$eDocument.UUID_User:=cs:C1710.sfw_userManager.me.info.UUID
		$eDocument.name:=$file.name
		$eDocument.extension:=$file.extension
		$eDocument.stmp:=cs:C1710.sfw_stmp.me.now()
		$eDocument.moreData:=New object:C1471
		$eDocument.moreData.originalPathOnClient:=$file.platformPath
		$info:=$eDocument.save()
		
		Form:C1466.documentsToUpLoadOnServer:=Form:C1466.documentsToUpLoadOnServer || New collection:C1472
		Form:C1466.documentsToUpLoadOnServer.push($eDocument)
		
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376(Form:C1466.hl_current_sublist; $eDocument.name; Form:C1466.hl_documents_refCounter)
		SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "UUID"; $eDocument.UUID)
		SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "kind"; "document")
		$pict:=Form:C1466.hl_icon_document
		SET LIST ITEM ICON:C950(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; $pict)
		SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter)
		
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		
		
		This:C1470._displayUploadedFile()
	End if 
	
Function _displayDocument()
	
Function _displayUploadedFile()
	