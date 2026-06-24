//%attributes = {}

// Purpose: Format a numeric deposit amount as a display Text value (avoids String(format) type errors).
// Parameters: $amount : Variant — raw amount (Real, Longint, Null, …)
// Returns: Text — formatted as ###,###,##0.00
// created by 4D/PS [2026-june-23]

#DECLARE($amount : Variant) -> $text : Text

$text:=String:C10(Num:C11($amount); "###,###,##0.00")

return $text
