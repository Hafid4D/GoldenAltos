//%attributes = {}
$pageDefinition:=Form:C1466.sfw.entry.panel.pages.query("page = :1"; FORM Get current page:C276(*)).first()

Case of 
	: (FORM Event:C1606.objectName=("dfdSubform_"+$pageDefinition.dynamicSource.ident+"_ddPage"))
		cs:C1710.dfd_panel_document.me.redraw_preview(Form:C1466.dfd_context; "--subform")
		OBJECT SET SUBFORM:C1138(*; "dfdSubform_"+$pageDefinition.dynamicSource.ident; Form:C1466.dfd_context.formDefinition)
		
	: (FORM Event:C1606.objectName=("dfdSubform_"+$pageDefinition.dynamicSource.ident+"_bRuler"))
		cs:C1710.dfd_panel_document.me.redraw_preview(Form:C1466.dfd_context; "--subform")
		OBJECT SET SUBFORM:C1138(*; "dfdSubform_"+$pageDefinition.dynamicSource.ident; Form:C1466.dfd_context.formDefinition)
		
	: (FORM Event:C1606.objectName=("dfdSubform_"+$pageDefinition.dynamicSource.ident+"_bPDF"))
		$printPreview:=Form:C1466.eDfdDocument.moreData.settings.printPreview
		Form:C1466.eDfdDocument.moreData.settings.printPreview:=True:C214
		cs:C1710.dfd_panel_document.me.redraw_preview(Form:C1466.dfd_context; "--print")
		OBJECT SET SUBFORM:C1138(*; "dfdSubform_"+$pageDefinition.dynamicSource.ident; Form:C1466.dfd_context.formDefinition)
		Form:C1466.eDfdDocument.moreData.settings.printPreview:=$printPreview
		
	: (FORM Event:C1606.objectName=("dfdSubform_"+$pageDefinition.dynamicSource.ident+"_bPrint"))
		cs:C1710.dfd_panel_document.me.redraw_preview(Form:C1466.dfd_context; "--print")
		OBJECT SET SUBFORM:C1138(*; "dfdSubform_"+$pageDefinition.dynamicSource.ident; Form:C1466.dfd_context.formDefinition)
		
	: (FORM Event:C1606.objectName=("dfdSubform_"+$pageDefinition.dynamicSource.ident+"_ruler"))
		cs:C1710.dfd_panel_document.me.redraw_preview(Form:C1466.dfd_context; "--subform")
		OBJECT SET SUBFORM:C1138(*; "dfdSubform_"+$pageDefinition.dynamicSource.ident; Form:C1466.dfd_context.formDefinition)
		
End case 