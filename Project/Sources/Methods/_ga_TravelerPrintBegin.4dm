//%attributes = {}
// Purpose: Initialize session context for legacy-compatible traveler printing. Call once after PRINT SETTINGS (or before the first Print form detail) so _ga_TravelerFormMethodNew and _ga_PrintTOF have paper size, margins, and page counter.
// Parameters: $1 (optional) Longint traveler header printed height (pixels); $2 (optional) Longint EPL/list row count for TravPrintList height math (replaces legacy Size of array(LBCol1)).
// Output: Resets fields on the shared object from _ga_TravelerPrintGetCtx (Storage.travelerPrintCtx).
// modified by 4D/PS [2026-april-28]
// Purpose: Apply print-area values and defaults on the shared traveler context (v20 Storage + shared object); replace interprocess <>ga_travPrintCtx.
// modified by 4D/PS [2026-april-27]

var $pw; $ph : Integer
var $ctx : Object
If (Storage:C1525.cache=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.cache:=New shared object:C1526
	End use 
End if 
$ctx:=_ga_TravelerPrintGetCtx
GET PRINTABLE AREA:C703($pw; $ph)
Use ($ctx)
	$ctx.hPaper:=$ph
	$ctx.printableWidth:=$pw
	$ctx.marginBottom:=20
	$ctx.travelerHeaderHeight:=50
	$ctx.lPage:=0
	$ctx.fireDetail:=True:C214
	$ctx.isDeviceLinked:=False:C215
	$ctx.templateMarkBit200:=False:C215
	$ctx.lbRowCount:=0
	$ctx.largeStepOrders:=New shared collection:C1527()
	$ctx.lastDesignDescHeight:=0
	$ctx.lastLayoutSize:=Null:C1517
	If (Count parameters:C259>=1)
		$ctx.travelerHeaderHeight:=$1
	End if 
	If (Count parameters:C259>=2)
		$ctx.lbRowCount:=$2
	End if 
End use 
