property ident : Text
property offsetHorizontal : Integer
property offsetVertical : Integer
property heightProperties : Integer
property gutter : Integer
property hl_icon_document : Object

Class constructor($ident : Text)
	
	This:C1470.ident:=$ident
	This:C1470.hl_icon_document:=New object:C1471
	For each ($type; Split string:C1554("folder;folderOpen;document;dfd;picture;pdf;write"; ";"))
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/image/hl/"+$type+".png")
		READ PICTURE FILE:C678($file.platformPath; $pict)
		This:C1470.hl_icon_document[$type]:=$pict
	End for each 
	
	
	
shared Function _insertDynamicDocumentsPage($formDefinition : Object; $panelPage : Object; $offsetHorizontal : Integer; $offsetVertical : Integer)
	var $pageDefinition : Object
	$dynamicSource:=$panelPage.dynamicSource
	OBJECT GET COORDINATES:C663(*; "detail_panel"; $g; $h; $d; $b)
	$widthDetailPanel:=$d-$g
	$heightDetailPanel:=$b-$h
	
	$widthLH:=300
	This:C1470.heightProperties:=150
	This:C1470.gutter:=5
	
	$pageDefinition:=$formDefinition.pages[$panelPage.page]
	
	This:C1470.offsetHorizontal:=$offsetHorizontal
	This:C1470.offsetVertical:=$offsetVertical
	
	//bkgd_hl_list
	$bkgdProperties:=New object:C1471
	$bkgdProperties.type:="rectangle"
	$bkgdProperties.top:=$offsetVertical
	$bkgdProperties.left:=$offsetHorizontal
	$bkgdProperties.width:=$widthLH
	$bkgdProperties.height:=$heightDetailPanel-$offsetVertical-This:C1470.heightProperties
	$bkgdProperties.fill:="#FDF3FC"
	$bkgdProperties.stroke:="#C0C0C0"
	$pageDefinition.objects["bkgd_hl_"+$dynamicSource.ident]:=$bkgdProperties
	
	// bAction
	$bActionproperties:=New object:C1471
	$bActionproperties.type:="button"
	$bActionproperties.text:="Actions"
	$bActionproperties.width:=80
	$bActionproperties.height:=21
	$bActionproperties.top:=$heightDetailPanel-This:C1470.gutter-$bActionproperties.height-This:C1470.heightProperties
	$marginBottom:=This:C1470.gutter+$bActionproperties.height+This:C1470.gutter
	$bActionproperties.left:=This:C1470.gutter+$offsetHorizontal
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
	$bHLProperties.height:=$heightDetailPanel-$bHLProperties.top-$marginBottom-This:C1470.heightProperties-1
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
	$bkgdProperties.top:=$offsetVertical+$heightDetailPanel-$offsetVertical-This:C1470.heightProperties
	$bkgdProperties.left:=$offsetHorizontal
	$bkgdProperties.width:=$widthLH
	$bkgdProperties.height:=This:C1470.heightProperties
	$bkgdProperties.fill:="#EDF3FC"
	$bkgdProperties.stroke:="#C0C0C0"
	$pageDefinition.objects["bkgd_properties_"+$dynamicSource.ident]:=$bkgdProperties
	
	//title_properties
	$titlePropProperties:=New object:C1471
	$titlePropProperties.type:="text"
	$titlePropProperties.text:="Properties"  //XLIFF
	$titlePropProperties.top:=$offsetVertical+$heightDetailPanel-$offsetVertical-This:C1470.heightProperties+This:C1470.gutter
	$titlePropProperties.height:=16
	$titlePropProperties.left:=This:C1470.gutter+$offsetHorizontal
	$titlePropProperties.with:=150
	$titlePropProperties.stroke:="navy"
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
	$pictPreviewProperties.pictureFormat:="proportionalCenter"
	$pictPreviewProperties.borderStyle:="none"
	$pictPreviewProperties.events:=["onClick"]
	$pictPreviewProperties.contextMenu:="none"
	$pageDefinition.objects["pictPreview_"+$dynamicSource.ident]:=$pictPreviewProperties
	
	//WArea for pdf
	$waProperties:=New object:C1471
	$waProperties.type:="webArea"
	$waProperties.top:=$offsetVertical
	$waProperties.height:=$heightDetailPanel-$offsetVertical
	$waProperties.left:=$widthLH
	$waProperties.with:=$widthDetailPanel-$widthLH
	$waProperties.dataSource:="Form.document_pdfInWA"
	$pageDefinition.objects["pdfInWA_"+$dynamicSource.ident]:=$waProperties
	
	//lb properties
	$lbPropProperties:=New object:C1471
	$lbPropProperties.type:="listbox"
	$lbPropProperties.top:=$offsetVertical+$heightDetailPanel-$offsetVertical-This:C1470.heightProperties+This:C1470.gutter+16+This:C1470.gutter
	$lbPropProperties.left:=$offsetHorizontal+This:C1470.gutter
	$lbPropProperties.width:=$widthLH-This:C1470.gutter-This:C1470.gutter
	$lbPropProperties.height:=This:C1470.heightProperties-This:C1470.gutter-16-This:C1470.gutter-This:C1470.gutter
	$lbPropProperties.listboxType:="collection"
	$lbPropProperties.dataSource:="Form.lb_properties"
	$lbPropProperties.horizontalLineStroke:="transparent"
	$lbPropProperties.verticalLineStroke:="transparent"
	$lbPropProperties.resizingMode:="legacy"
	$lbPropProperties.focusable:=False:C215
	$lbPropProperties.showHeaders:=False:C215
	$lbPropProperties.hideSystemHighlight:=True:C214
	$lbPropProperties.scrollbarHorizontal:="hidden"
	$lbPropProperties.scrollbarVertical:="hidden"
	$lbPropProperties.fill:="transparent"
	$lbPropProperties.borderStyle:="none"
	$lbPropProperties.columns:=New collection:C1472
	$column:=New object:C1471
	$column.name:="columnPropertyName"
	$column.dataSource:="This.property"
	$column.stroke:="#808080"
	$column.width:=90
	$lbPropProperties.columns.push($column)
	$column:=New object:C1471
	$column.name:="columnPropertyValue"
	$column.dataSource:="This.value"
	$lbPropProperties.columns.push($column)
	$pageDefinition.objects["lb_properties_"+$dynamicSource.ident]:=$lbPropProperties
	
	
Function _setDataSourceForDynamicPage()
	
	If (Form:C1466.hl_documents#Null:C1517) && (Is a list:C621(Form:C1466.hl_documents))
		CLEAR LIST:C377(Form:C1466.hl_documents; *)
	End if 
	
	
	
	If (Form:C1466.documentFolders=Null:C1517)
		Form:C1466.documentFolders:=ds:C1482.sfw_DocumentFolder.all().toCollection()
	End if 
	Form:C1466.documentsToDeleteOnServer:=Form:C1466.documentsToDeleteOnServer || New collection:C1472
	Form:C1466.documents:=ds:C1482.sfw_Document.query("UUID_target = :1 and Not(UUID in :2)"; Form:C1466.current_item.UUID; Form:C1466.documentsToDeleteOnServer.extract("UUID")).toCollection()
	
	OBJECT SET VISIBLE:C603(*; "pictPreview_"+This:C1470.ident; False:C215)
	OBJECT SET VISIBLE:C603(*; "pdfInWA_"+This:C1470.ident; False:C215)
	
	Form:C1466.hl_documents:=This:C1470._buildHLDocuments()
	//Form.hl_current_ref:=0
	This:C1470._reorganize()
	
Function _buildHLDocuments($uuidParent : Text)->$refList : Integer
	
	If (Count parameters:C259=0)
		Form:C1466.hl_documents_refCounter:=0
		Form:C1466.documents:=ds:C1482.sfw_Document.query("UUID_target = :1 and Not(UUID in :2) order by name"; Form:C1466.current_item.UUID; Form:C1466.documentsToDeleteOnServer.extract("UUID")).toCollection()
		Form:C1466.dfd_Document:=ds:C1482.dfd_Document.query("UUID_target = :1 order by name"; Form:C1466.current_item.UUID).toCollection("*, template.*")
		$documentFolders:=Form:C1466.documentFolders.query("UUID_ParentFolder = :1"; (16*"00"))
		$documents:=New collection:C1472
		$esDfdDocuments:=New collection:C1472
	Else 
		$documentFolders:=Form:C1466.documentFolders.query("UUID_ParentFolder = :1"; $uuidParent)
		$documents:=Form:C1466.documents.query("UUID_DocumentFolder = :1"; $uuidParent).orderBy("name")
		$esDfdDocuments:=Form:C1466.dfd_Document.query("UUID_target = :1 and template.UUID_DocumentFolder = :2"; Form:C1466.current_item.UUID; $uuidParent).orderBy("name")
	End if 
	$documentFolders:=$documentFolders.orderBy("name")
	$refList:=New list:C375
	For each ($documentFolder; $documentFolders)
		$sublist:=This:C1470._buildHLDocuments($documentFolder.UUID)
		If (Count list items:C380($sublist)=0)
			CLEAR LIST:C377($sublist)
			$sublist:=0
			$pict:=This:C1470.hl_icon_document["folder"]
		Else 
			$pict:=This:C1470.hl_icon_document["folderOpen"]
		End if 
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376($refList; $documentFolder.name; Form:C1466.hl_documents_refCounter; $sublist; True:C214)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "UUID"; $documentFolder.UUID)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "kind"; "folder")
		SET LIST ITEM PROPERTIES:C386($refList; Form:C1466.hl_documents_refCounter; False:C215; Bold:K14:2)
		SET LIST ITEM ICON:C950($refList; Form:C1466.hl_documents_refCounter; $pict)
	End for each 
	For each ($document; $documents)
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376($refList; $document.name; Form:C1466.hl_documents_refCounter)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; Additional text:K28:7; String:C10($document.date; Internal date short:K1:7))
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "UUID"; $document.UUID)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "kind"; "document")
		Case of 
			: ($document.extension=".pdf")
				$pict:=This:C1470.hl_icon_document["pdf"]
			: (Position:C15($document.extension; ".jpg;.png;.tiff")>0)
				$pict:=This:C1470.hl_icon_document["picture"]
			Else 
				$pict:=This:C1470.hl_icon_document["document"]
		End case 
		SET LIST ITEM ICON:C950($refList; Form:C1466.hl_documents_refCounter; $pict)
	End for each 
	For each ($eDfdDocument; $esDfdDocuments)
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376($refList; $eDfdDocument.name; Form:C1466.hl_documents_refCounter)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; Additional text:K28:7; String:C10($eDfdDocument.date; Internal date short:K1:7))
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "UUID"; $eDfdDocument.UUID)
		SET LIST ITEM PARAMETER:C986($refList; Form:C1466.hl_documents_refCounter; "kind"; "dfdDocument")
		$pict:=This:C1470.hl_icon_document["dfd"]
		SET LIST ITEM ICON:C950($refList; Form:C1466.hl_documents_refCounter; $pict)
	End for each 
	
Function _bAction()
	
	
	$refMenus:=New collection:C1472
	$refMenu:=Create menu:C408
	$refMenus.push($refMenu)
	
	//$refSubMenu:=Create menu
	//$refMenus.push($refSubMenu)
	//APPEND MENU ITEM($refSubMenu; "Template 1"; *)
	//APPEND MENU ITEM($refSubMenu; "Template 2"; *)
	//APPEND MENU ITEM($refSubMenu; "-")
	//APPEND MENU ITEM($refSubMenu; "Free write"; *)
	
	
	//APPEND MENU ITEM($refMenu; "Add a new document"; $refSubMenu; *)  //XLIFF
	//SET MENU ITEM PARAMETER($refMenu; -1; "--add")
	//SET MENU ITEM ICON($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/plus-circle.png")
	//If (Form.sfw.checkIsInModification()) && (Form.hl_current_ref#0) && (Form.hl_current_kind="folder")
	//Else 
	//DISABLE MENU ITEM($refMenu; -1)
	//End if 
	
	
	
	APPEND MENU ITEM:C411($refMenu; "Upload a file"; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--upload")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/upload.png")
	If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.hl_current_ref#0) && (Form:C1466.hl_current_kind="folder")
	Else 
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	If (OB Entries:C1720(ds:C1482).indices("key = :1"; "dfd_@").length>0)
		$refSubMenu:=Create menu:C408
		$refMenus.push($refSubMenu)
		$esTemplates:=ds:C1482.dfd_Template.query("UUID_DocumentFolder = :1 order by name"; Form:C1466.hl_current_uuid)
		For each ($eTemplate; $esTemplates)
			APPEND MENU ITEM:C411($refSubMenu; $eTemplate.name; *)  //XLIFF
			SET MENU ITEM ICON:C984($refSubMenu; -1; "Path:/RESOURCES/sfw/image/menu/document-template.png")
			SET MENU ITEM PARAMETER:C1004($refSubMenu; -1; "--useDfdTemplate:"+$eTemplate.UUID)
		End for each 
		APPEND MENU ITEM:C411($refMenu; "Add a new dynamic document"; $refSubMenu; *)  //XLIFF
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/plus-circle.png")
		If ($esTemplates.length=0)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "-")
	
	APPEND MENU ITEM:C411($refMenu; "Rename"; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--rename")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/pencil.png")
	If (Form:C1466.hl_current_kind="folder")
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.hl_current_ref#0) && (Form:C1466.hl_current_kind="document")
		Else 
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete"; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/minus-circle.png")
	If (Form:C1466.hl_current_kind="folder")
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.hl_current_ref#0) && (Form:C1466.hl_current_kind="document")
		Else 
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Download"; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--download")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/menu/download.png")
	If (Form:C1466.hl_current_kind="folder")
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	For each ($refMenu; $refMenus)
		RELEASE MENU:C978($refMenu)
	End for each 
	
	Case of 
		: ($choose="--add")
			This:C1470._add_document()
			
		: ($choose="--upload")
			This:C1470._uploadFile()
			
		: ($choose="--download")
			This:C1470._downloadFile()
			
		: ($choose="--delete")
			This:C1470._deleteDocument()
			
		: ($choose="--rename")
			This:C1470._renameDocument()
			
		: ($choose="--useDfdTemplate:@")
			Form:C1466.templateTuUseUUID:=Split string:C1554($choose; ":").pop()
			This:C1470._useDfdTemplate()
			
	End case 
	
	
Function _hl_document()
	
	This:C1470._load_hl_item_properties(1)
	
	Case of 
		: (FORM Event:C1606.code=On Clicked:K2:4) && (Right click:C712)
			This:C1470._bAction()
			
		: (FORM Event:C1606.code=On Clicked:K2:4)
			
	End case 
	
Function _load_hl_item_properties($option : Integer)
	var $refItem : Integer
	var $textItem : Text
	var $sublist : Integer
	var $uuid : Text
	var $kind : Text
	
	GET LIST ITEM:C378(Form:C1466.hl_documents; *; $refItem; $textItem; $sublist; $expanded)
	If ($refItem#Form:C1466.hl_current_ref) || (Count parameters:C259>0)
		Form:C1466.hl_current_ref:=$refItem
		Form:C1466.hl_current_text:=$textItem
		Form:C1466.hl_current_sublist:=$sublist
		$test:=Is a list:C621($subList)
		GET LIST ITEM PARAMETER:C985(Form:C1466.hl_documents; Form:C1466.hl_current_ref; "UUID"; $uuid)
		Form:C1466.hl_current_uuid:=$uuid
		GET LIST ITEM PARAMETER:C985(Form:C1466.hl_documents; Form:C1466.hl_current_ref; "kind"; $kind)
		Form:C1466.hl_current_kind:=$kind
		OBJECT SET VISIBLE:C603(*; "pictPreview_"+This:C1470.ident; False:C215)
		OBJECT SET VISIBLE:C603(*; "pdfInWA_"+This:C1470.ident; False:C215)
		
		Form:C1466.lb_properties:=New collection:C1472
		Case of 
			: (Form:C1466.hl_current_kind="document")
				Form:C1466.eDocument:=ds:C1482.sfw_Document.get(Form:C1466.hl_current_uuid)
				This:C1470._displayUploadedFile(Form:C1466.eDocument)
				Form:C1466.lb_properties.push({property: "File name"; value: Form:C1466.eDocument.name})
				Form:C1466.lb_properties.push({property: "extension"; value: Form:C1466.eDocument.extension})
				$size:=cs:C1710.sfw_bytes.me.getBestFormat(Form:C1466.eDocument.moreData.fileInfo.size)
				Form:C1466.lb_properties.push({property: "size"; value: $size})
				Form:C1466.lb_properties.push({property: "creation date"; value: String:C10(Form:C1466.eDocument.moreData.fileInfo.creationDate; Internal date short:K1:7)})
				Form:C1466.lb_properties.push({property: "creation time"; value: String:C10(Time:C179(Form:C1466.eDocument.moreData.fileInfo.creationTime); HH MM SS:K7:1)})
				Form:C1466.lb_properties.push({property: "modif. date"; value: String:C10(Form:C1466.eDocument.moreData.fileInfo.modificationDate; Internal date short:K1:7)})
				Form:C1466.lb_properties.push({property: "modif. time"; value: String:C10(Time:C179(Form:C1466.eDocument.moreData.fileInfo.modificationTime); HH MM SS:K7:1)})
				Form:C1466.lb_properties.push({property: "added by"; value: Form:C1466.eDocument.user.fullName})
				
			: (Form:C1466.hl_current_kind="folder")
				Form:C1466.lb_properties.push({property: "Folder name"; value: Form:C1466.hl_current_text})
				$nbSubFolders:=ds:C1482.sfw_DocumentFolder.query("UUID_ParentFolder = :1"; Form:C1466.hl_current_uuid).length
				Form:C1466.lb_properties.push({property: "Nb subfolders"; value: String:C10($nbSubFolders; "###,##0;;-")})
				$nbDocuments:=Form:C1466.documents.query("UUID_DocumentFolder = :1"; Form:C1466.hl_current_uuid).length
				Form:C1466.lb_properties.push({property: "Nb documents"; value: String:C10($nbDocuments; "###,##0;;-")})
		End case 
	End if 
	
Function _add_document()
	var $eDocument : cs:C1710.sfw_DocumentEntity
	
	
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
	$pict:=This:C1470.hl_icon_document["document"]
	SET LIST ITEM ICON:C950(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; $pict)
	SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_documents; Form:C1466.hl_documents_refCounter)
	
	This:C1470._load_hl_item_properties()
	
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	This:C1470._displayDocument()
	
Function _uploadFile()
	var $file : 4D:C1709.File
	ARRAY TEXT:C222($_file; 0)
	$fileSelected:=Select document:C905(7638; ""; "Select the file to upload"; Use sheet window:K24:11; $_file)
	If (ok=1) && (Size of array:C274($_file)>0)
		$file:=File:C1566($_file{1}; fk platform path:K87:2)
		
		$uuid_folder:=Form:C1466.hl_current_uuid
		
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
		
		If (Form:C1466.hl_current_sublist=0)
			Form:C1466.hl_current_sublist:=New list:C375
			SET LIST ITEM:C385(Form:C1466.hl_documents; Form:C1466.hl_current_ref; Form:C1466.hl_current_text; Form:C1466.hl_current_ref; Form:C1466.hl_current_sublist; True:C214)
		End if 
		
		Form:C1466.hl_documents_refCounter+=1
		APPEND TO LIST:C376(Form:C1466.hl_current_sublist; $eDocument.name; Form:C1466.hl_documents_refCounter)
		SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "UUID"; $eDocument.UUID)
		SET LIST ITEM PARAMETER:C986(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; "kind"; "document")
		$pict:=This:C1470.hl_icon_document["document"]
		SET LIST ITEM ICON:C950(Form:C1466.hl_current_sublist; Form:C1466.hl_documents_refCounter; $pict)
		SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_documents; Form:C1466.hl_documents_refCounter)
		
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		
		This:C1470._displayUploadedFile($eDocument)
	End if 
	
	
	
Function _downloadFile()
	var $blob : 4D:C1709.Blob
	var $picture : Picture
	
	If (Form:C1466.eDocument#Null:C1517)
		Case of 
			: (Form:C1466.eDocument.moreData.fileInfo#Null:C1517)
				$blob:=Form:C1466.eDocument.getStoredBlob()
				BLOB TO PICTURE:C682($blob; $picture; Form:C1466.eDocument.moreData.fileInfo.extension)
				ARRAY TEXT:C222($_file; 0)
				$fileName:=Select document:C905(Form:C1466.eDocument.moreData.fileInfo.fullName; Form:C1466.eDocument.moreData.fileInfo.extension; "Download the file:"; File name entry:K24:17+Use sheet window:K24:11; $_file)
				If (ok=1) & (Size of array:C274($_file)>0)
					$filePath:=$_file{1}
					WRITE PICTURE FILE:C680($filePath; $picture; Form:C1466.eDocument.moreData.fileInfo.extension)
				End if 
		End case 
		
	End if 
	
	
Function _deleteDocument()
	If (Form:C1466.eDocument#Null:C1517)
		//If (Form.eDocument.moreData.fileInfo#Null)
		//Form.eDocument.deleteFile()
		//End if 
		//$info:=Form.eDocument.drop()
		Form:C1466.documentsToDeleteOnServer:=Form:C1466.documentsToUpLoadOnServer || New collection:C1472
		Form:C1466.documentsToDeleteOnServer.push(Form:C1466.eDocument)
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		Form:C1466.hl_documents:=This:C1470._buildHLDocuments()
	End if 
	
	
Function _renameDocument()
	If (Form:C1466.eDocument#Null:C1517)
		$answer:=cs:C1710.sfw_dialog.me.request("Enter the new name for the document:"; Form:C1466.hl_current_text; "Rename"; "Cancel"; "trimSpace"; "notEmpty")  //XLIFF
		If ($answer.ok)
			Form:C1466.eDocument.name:=$answer.answer
			$info:=Form:C1466.eDocument.save()
			Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
			Form:C1466.hl_documents:=This:C1470._buildHLDocuments()
		End if 
	End if 
	
	
Function _useDfdTemplate()
	var $eDfdDocument : cs:C1710.dfd_DocumentEntity
	var $eDfdTemplate : cs:C1710.dfd_TemplateEntity
	
	$eDfdTemplate:=ds:C1482.dfd_Template.get(Form:C1466.templateTuUseUUID)
	$eDfdDocument:=ds:C1482.dfd_Document.buildFromTemplate($eDfdTemplate.name+"-"+String:C10(Current date:C33); $eDfdTemplate; New object:C1471; "save")
	$eDfdDocument.UUID_target:=Form:C1466.current_item.UUID
	$info:=$eDfdDocument.save()
	
	If (Form:C1466.hl_current_sublist=0)
		Form:C1466.hl_current_sublist:=New list:C375
		SET LIST ITEM:C385(Form:C1466.hl_documents; Form:C1466.hl_current_ref; Form:C1466.hl_current_text; Form:C1466.hl_current_ref; Form:C1466.hl_current_sublist; True:C214)
	End if 
	
	Form:C1466.hl_documents_refCounter+=1
	$label:=$eDfdDocument.name
	$subList:=Form:C1466.hl_current_sublist
	$test:=Is a list:C621($subList)
	APPEND TO LIST:C376($subList; $label; Form:C1466.hl_documents_refCounter; *)
	SET LIST ITEM PARAMETER:C986($subList; Form:C1466.hl_documents_refCounter; "UUID"; $eDfdDocument.UUID)
	SET LIST ITEM PARAMETER:C986($subList; Form:C1466.hl_documents_refCounter; "kind"; "dfdDocument")
	$pict:=This:C1470.hl_icon_document["dfd"]
	SET LIST ITEM ICON:C950($subList; Form:C1466.hl_documents_refCounter; $pict)
	SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_documents; Form:C1466.hl_documents_refCounter)
	
	This:C1470._load_hl_item_properties()
	
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
Function _displayDocument()
	
	
Function _displayUploadedFile($eDocument : cs:C1710.sfw_DocumentEntity)
	var $content : 4D:C1709.Blob
	var $pict : Picture
	If (Form:C1466.eDocument#Null:C1517)
		Case of 
			: (Form:C1466.eDocument.moreData.fileInfo#Null:C1517) && (Form:C1466.eDocument.moreData.fileInfo.extension=".pdf")
				$content:=Form:C1466.eDocument.getStoredBlob()
				If ($content#Null:C1517)
					$folder:=Temporary folder:C486
					$file:=Folder:C1567($folder; fk platform path:K87:2).file(Form:C1466.eDocument.UUID+".pdf")
					//If ($file.exists)
					$file.setContent($content)
					$path:=Replace string:C233($file.platformPath; Folder separator:K24:12; "/")
					
					Case of 
						: (Is Windows:C1573)
							$path:="file:///"+$path
						: (Is macOS:C1572)
							$path:="file:///Volumes/"+Replace string:C233($path; " "; "%20")
					End case 
					
					OBJECT SET VISIBLE:C603(*; "pictPreview_"+This:C1470.ident; False:C215)
					OBJECT SET VISIBLE:C603(*; "pdfInWA_"+This:C1470.ident; True:C214)
					OBJECT GET COORDINATES:C663(*; "pdfInWA_"+This:C1470.ident; $g; $h; $d; $b)
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
					OBJECT SET COORDINATES:C1248(*; "pdfInWA_"+This:C1470.ident; $g; $h; $width; $height)
					
					WA OPEN URL:C1020(*; "pdfInWA_"+This:C1470.ident; $path)
					//End if 
				End if 
			: (Form:C1466.eDocument.moreData.fileInfo#Null:C1517)
				$content:=Form:C1466.eDocument.getStoredBlob()
				BLOB TO PICTURE:C682($content; $pict; Form:C1466.eDocument.moreData.fileInfo.extension)
				Form:C1466.document_pictPreview:=$pict
				OBJECT SET VISIBLE:C603(*; "pictPreview_"+This:C1470.ident; True:C214)
				OBJECT SET VISIBLE:C603(*; "pdfInWA_"+This:C1470.ident; False:C215)
				OBJECT GET COORDINATES:C663(*; "pictPreview_"+This:C1470.ident; $g; $h; $d; $b)
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
				OBJECT SET COORDINATES:C1248(*; "pictPreview_"+This:C1470.ident; $g; $h; $width; $height)
				
			: (Form:C1466.eDocument.moreData.originalPathOnClient#Null:C1517)
				READ PICTURE FILE:C678(Form:C1466.eDocument.moreData.originalPathOnClient; $pict)
				Form:C1466.document_pictPreview:=$pict
				OBJECT SET VISIBLE:C603(*; "pictPreview_"+This:C1470.ident; True:C214)
				OBJECT SET VISIBLE:C603(*; "pdfInWA_"+This:C1470.ident; False:C215)
				OBJECT GET COORDINATES:C663(*; "pictPreview_"+This:C1470.ident; $g; $h; $d; $b)
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
				OBJECT SET COORDINATES:C1248(*; "pictPreview_"+This:C1470.ident; $g; $h; $width; $height)
			Else 
		End case 
	Else 
		Form:C1466.document_pictPreview:=$pict
	End if 
	
Function _reorganize()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	$verticalSplit:=$width\4
	$verticalSplit:=($verticalSplit>300) ? ($verticalSplit<600) ? $verticalSplit : 600 : 300
	
	$heightProperties:=$height\3
	$heightProperties:=($heightProperties>150) ? ($heightProperties<300) ? $heightProperties : 300 : 150
	
	
	OBJECT SET COORDINATES:C1248(*; "bkgd_hl_"+This:C1470.ident; This:C1470.offsetHorizontal-1; This:C1470.offsetVertical-1; $verticalSplit; $height-$heightProperties)
	OBJECT GET COORDINATES:C663(*; "bAction_"+This:C1470.ident; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "bAction_"+This:C1470.ident; This:C1470.offsetHorizontal+This:C1470.gutter; $height-$heightProperties-This:C1470.gutter-$b+$h; This:C1470.offsetHorizontal+This:C1470.gutter+$d-$g; $height-$heightProperties-This:C1470.gutter)
	OBJECT SET COORDINATES:C1248(*; "hl_"+This:C1470.ident; This:C1470.offsetHorizontal; This:C1470.offsetVertical+1; $verticalSplit; $height-$heightProperties-This:C1470.gutter-$b+$h-This:C1470.gutter)
	OBJECT SET COORDINATES:C1248(*; "bkgd_properties_"+This:C1470.ident; This:C1470.offsetHorizontal-1; $height-$heightProperties-1; $verticalSplit; $height+1)
	OBJECT GET COORDINATES:C663(*; "title_properties_"+This:C1470.ident; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "title_properties_"+This:C1470.ident; This:C1470.offsetHorizontal+This:C1470.gutter; $height-$heightProperties+This:C1470.gutter; This:C1470.offsetHorizontal+This:C1470.gutter+$d-$g; $height-$heightProperties+This:C1470.gutter+$b-$h)
	OBJECT SET COORDINATES:C1248(*; "lb_properties_"+This:C1470.ident; This:C1470.offsetHorizontal+This:C1470.gutter; $height-$heightProperties+This:C1470.gutter+16+This:C1470.gutter; $verticalSplit-This:C1470.gutter; $height-This:C1470.gutter)
	OBJECT SET COORDINATES:C1248(*; "pictPreview_"+This:C1470.ident; $verticalSplit; This:C1470.offsetVertical; $width; $height)
	OBJECT SET COORDINATES:C1248(*; "pdfInWA_"+This:C1470.ident; $verticalSplit; This:C1470.offsetVertical; $width; $height)
	
	
Function resizePanel()
	This:C1470._reorganize()
	SET TIMER:C645(5)
	
Function timerPanel()
	SET TIMER:C645(0)
	If (Form:C1466.hl_current_ref#Null:C1517)
		SELECT LIST ITEMS BY REFERENCE:C630(Form:C1466.hl_documents; Form:C1466.hl_current_ref)
		This:C1470._load_hl_item_properties(1)
	End if 
	