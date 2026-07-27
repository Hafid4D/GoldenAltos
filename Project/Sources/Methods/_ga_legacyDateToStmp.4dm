//%attributes = {}

// Purpose: Convert a legacy JSON date value to an sfw_stmp integer for catalog date fields.
// Parameters: $value : Variant — legacy date field from export JSON
// Returns: Integer — 0 when conversion fails
// created by 4D/PS [2026-june-29]

#DECLARE($value : Variant) -> $stmp : Integer

var $date : Date

$stmp:=0
$date:=_ga_parseLegacyDepositDate($value)
If ($date#!00-00-00!)
	$stmp:=cs:C1710.sfw_stmp.me.build($date)
End if
