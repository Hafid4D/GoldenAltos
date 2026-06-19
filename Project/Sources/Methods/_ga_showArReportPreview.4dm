//%attributes = {}

// Purpose: Open a Write Pro preview dialog for an A/R report document.
// Parameters:
// $wp : Object — Write Pro area
// $title : Text — window / report title
// Returns: nothing
// created by 4D/PS [2026-june-08]

#DECLARE($wp : Object; $title : Text)

var $form : Object
var $winRef : Integer

$form:=New object:C1471("wp"; $wp; "title"; $title)
$winRef:=Open form window:C675("_ga_arReportPreview"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
SET WINDOW TITLE:C213($title; $winRef)
DIALOG:C40("_ga_arReportPreview"; $form)
CLOSE WINDOW:C154($winRef)
