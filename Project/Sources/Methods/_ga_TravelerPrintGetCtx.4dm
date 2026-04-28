//%attributes = {}
// Purpose: Return the singleton traveler print context as a shared object (4D v20), registered under Storage.travelerPrintCtx for use from any process. Lazy-initializes default scalar properties, shared largeStepOrders, and lastLayoutSize (Null).
// Parameters: none
// Returns: Object — shared object with hPaper, printableWidth, marginBottom, travelerHeaderHeight, lPage, fireDetail, isDeviceLinked, templateMarkBit200, lbRowCount, largeStepOrders (shared collection), lastDesignDescHeight, lastLayoutSize.
// created by 4D/PS [2026-april-27]

var $ctx : Object
var $lc : Collection

If (Undefined:C82(Storage:C1525.travelerPrintCtx)) | (Storage:C1525.travelerPrintCtx=Null:C1517)
	Use (Storage:C1525)
		If (Undefined:C82(Storage:C1525.travelerPrintCtx)) | (Storage:C1525.travelerPrintCtx=Null:C1517)
			$lc:=New shared collection:C1527()
			$ctx:=New shared object:C1526
			Use ($ctx)
				$ctx.hPaper:=0
				$ctx.printableWidth:=0
				$ctx.marginBottom:=20
				$ctx.travelerHeaderHeight:=50
				$ctx.lPage:=0
				$ctx.fireDetail:=True:C214
				$ctx.isDeviceLinked:=False:C215
				$ctx.templateMarkBit200:=False:C215
				$ctx.lbRowCount:=0
				$ctx.largeStepOrders:=$lc
				$ctx.lastDesignDescHeight:=0
				$ctx.lastLayoutSize:=Null:C1517
			End use
			Storage:C1525.travelerPrintCtx:=$ctx
		End if
	End use
End if
$0:=Storage:C1525.travelerPrintCtx
