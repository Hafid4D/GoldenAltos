//%attributes = {}
/*
_ga_generateCofC

Author : Medard /4D PS
Date :15-October-2025
Purpose : Generate certificate of compliance
*/


If (Form:C1466.current_item#Null:C1517)
	
	
	var $context : Object
	
	$context:=New object:C1471()
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/COfCTemplate.4wp")
	$template:=WP Import document:C1318($file.platformPath)
	
	$context.user:=Current machine:C483
	$context.lot:=Form:C1466.current_item
	
	SET PRINT OPTION:C733(Orientation option:K47:2; 1)
	
	
	
	WP SET DATA CONTEXT:C1786($template; $context)
	
	PRINT SETTINGS:C106(2)
	//WP COMPUTE FORMULAS($template)
	WP PRINT:C1343($template)  //; wk do not recompute expressions)
	
Else 
	cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("Info"; "No items in the list to print"))
	
End if 