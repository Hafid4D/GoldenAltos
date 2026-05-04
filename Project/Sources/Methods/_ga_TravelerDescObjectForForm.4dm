//%attributes = {}
// Purpose: Return the form object name bound to LotStep.description on each migrated traveler print form (GoldenAltos project forms use Field1 or Field2).
// Parameters: $1 Text form name (without table prefix).
// Returns: $0 Text object name for OBJECT GET COORDINATES / OBJECT MOVE.
// modified by 4D/PS [2026-april-28]

var $n : Text

$n:=Lowercase:C14($1; *)

Case of 
	: ($n="burnin_l") | ($n="pda") | ($n="ws")
		$0:="Field2"
	Else 
		$0:="Field1"
End case 
