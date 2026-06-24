//%attributes = {}

// Purpose: Print a list selection using the generic shell template and a column mapping.
// Parameters:
// $templateFileName : Text — file name under Resources/4DWriteProPrintTemplates/
// $mapping : Collection — column mapping (see _ga_buildListFromMapping)
// $items : Object — collection or entity selection bound as This.data.items
// $headerText : Text — multiline description (title, count, filters, …) built by the caller
// Returns: Boolean — True when print was launched
// modified by 4D/PS [2026-june-08]

// Purpose: Accept Collection or entity selection as items (strict Object typing rejected Collection).
// modified by 4D/PS [2026-june-23]
#DECLARE($templateFileName : Text; $mapping : Collection; $items; $headerText : Text) -> $printed : Boolean

var $built : Object
var $options : Object

$printed:=False:C215
$options:=New object:C1471("allowEmpty"; False:C215)
$built:=_ga_buildListFromMapping($templateFileName; $mapping; $items; $headerText; $options)

If ($built#Null:C1517) && ($built.wp#Null:C1517)
	SET PRINT OPTION:C733(Orientation option:K47:2; 1)
	PRINT SETTINGS:C106(2)
	WP PRINT:C1343($built.wp)
	$printed:=True:C214
End if 
