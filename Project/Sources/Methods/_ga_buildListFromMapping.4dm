//%attributes = {}

// Purpose: Build a list/report Write Pro document from the generic shell template and a column mapping.
// Template contract: logo/header + "Header" description block + "Table" table placeholder.
// Header is plain text from the caller — no This.data.subject / filter fields in the template.
// Table rows use This.data.items only (datasource on the inserted table).
// Parameters:
// $templateFileName : Text — file under Resources/4DWriteProPrintTemplates/
// $mapping : Collection — { header : Text ; source : Text ; width? : Text ; align? : Text }
// $items : Object — collection or entity selection bound as This.data.items
// $headerText : Text — multiline description inserted at Header (or prepended to body if Header is missing)
// $options : Object — optional { tablePlaceholder : Text ; headerPlaceholder : Text ; allowEmpty : Boolean }
// Returns: Object — { wp : Object ; table : Object } on success, empty object on failure
// modified by 4D/PS [2026-june-08]

#DECLARE($templateFileName : Text; $mapping : Collection; $items; $headerText : Text; $options : Object) -> $result : Object

var $file : 4D:C1709.File
var $range : Object
var $table : Object
var $colDef : Object
var $colIndex : Integer
var $colCount : Integer
var $cell : Object
var $colRange : Object
var $headerRow : Object
var $dataSourceFormula : Object
var $cellFormula : Object
var $alignValue : Integer
var $width : Text
var $tablePlaceholder : Text
var $headerPlaceholder : Text
var $dataSourcePath : Text
var $sourceExpr : Text
var $context : Object
var $allowEmpty : Boolean
var $wp : Object
var $rangeFound : Boolean
var $body : Object
var $ranges : Collection
var $headerRanges : Collection
var $insertRange : Object

$colCount:=$mapping.length
$allowEmpty:=False:C215
$tablePlaceholder:="Table"
$headerPlaceholder:="Header"
$dataSourcePath:="This.data.items"

$result:=New object:C1471

If ($colCount=0)
	return $result
End if 
If ($options#Null:C1517)
	If ($options.tablePlaceholder#Null:C1517)
		$tablePlaceholder:=$options.tablePlaceholder
	End if 
	If ($options.headerPlaceholder#Null:C1517)
		$headerPlaceholder:=$options.headerPlaceholder
	End if 
	If ($options.allowEmpty#Null:C1517)
		$allowEmpty:=$options.allowEmpty
	End if 
End if 

If ($items=Null:C1517) | (($items.length=0) && (Not:C34($allowEmpty)))
	return $result
End if 

$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/"+$templateFileName)
If (Not:C34($file.exists))
	cs:C1710.sfw_dialog.me.alert("Print template not found: "+$templateFileName)
	return $result
End if 

$wp:=WP Import document:C1318($file.platformPath)

$body:=WP Get body:C1516($wp)
If ($body=Null:C1517)
	$body:=$wp
End if 

// Purpose: Insert caller-built header lines as plain text — template stays generic (Header only, no per-report formulas).
// modified by 4D/PS [2026-june-08]
If ($headerText#"")
	$headerRanges:=WP Find all:C1755($body; $headerPlaceholder; 0)
	If ($headerRanges.length>0)
		WP Find all:C1755($body; $headerPlaceholder; 0; $headerText)
	Else 
		$insertRange:=WP Text range:C1341($body; wk start text:K81:165; wk start text:K81:165)
		WP SET TEXT:C1574($insertRange; $headerText+Char:C90(Carriage return:K15:38); wk prepend:K81:178)
	End if 
End if 

$rangeFound:=False:C215
$ranges:=WP Find all:C1755($body; $tablePlaceholder; 0)
If ($ranges.length>0)
	$range:=$ranges[0]
	$rangeFound:=True:C214
End if 

If (Not:C34($rangeFound))
	cs:C1710.sfw_dialog.me.alert("Print template placeholder \""+$tablePlaceholder+"\" not found in "+$templateFileName)
	return $result
End if 

$table:=WP Insert table:C1473($range; wk replace:K81:177; wk include in range:K81:180; $colCount; 2)

For ($colIndex; 1; $colCount)
	$cell:=WP Table get cells:C1477($table; $colIndex; 1; 1; 1)
	WP SET TEXT:C1574($cell; $mapping[$colIndex-1].header; wk replace:K81:177)
End for 

For ($colIndex; 1; $colCount)
	$colDef:=$mapping[$colIndex-1]
	$sourceExpr:=$colDef.source
	If ($sourceExpr="")
		$sourceExpr:="String(This.item)"
	End if 
	$cell:=WP Table get cells:C1477($table; $colIndex; 2; 1; 1)
	$cellFormula:=Formula from string:C1601($sourceExpr)
	WP Insert formula:C1703($cell; $cellFormula; wk replace:K81:177)
End for 

WP SET ATTRIBUTES:C1342($table; wk header row count:K81:364; 1)

For ($colIndex; 1; $colCount)
	$colDef:=$mapping[$colIndex-1]
	$colRange:=WP Table get columns:C1476($table; $colIndex)
	$width:="2cm"
	If ($colDef.width#Null:C1517) && ($colDef.width#"")
		$width:=$colDef.width
	End if 
	WP SET ATTRIBUTES:C1342($colRange; wk width:K81:45; $width)
	If ($colDef.align#Null:C1517)
		Case of 
			: ($colDef.align="right")
				$alignValue:=wk right:K81:96
			: ($colDef.align="center")
				$alignValue:=wk center:K81:99
			Else 
				$alignValue:=wk left:K81:95
		End case 
		WP SET ATTRIBUTES:C1342($colRange; wk text align:K81:49; $alignValue)
	End if 
End for 

WP SET ATTRIBUTES:C1342($table; wk font size:K81:66; 9)
$headerRow:=WP Table get rows:C1475($table; 1)
WP SET ATTRIBUTES:C1342($headerRow; wk font bold:K81:68; True:C214)

$context:=New object:C1471("items"; $items)
$dataSourceFormula:=Formula from string:C1601($dataSourcePath)
WP SET DATA CONTEXT:C1786($wp; $context)
WP SET ATTRIBUTES:C1342($table; wk datasource:K81:367; $dataSourceFormula)
WP COMPUTE FORMULAS:C1707($wp)

$result:=New object:C1471("wp"; $wp; "table"; $table)
