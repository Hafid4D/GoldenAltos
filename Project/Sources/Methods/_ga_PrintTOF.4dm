//%attributes = {}
// Purpose: Traveler print helper (ported from legacy PrintTOF). If the detail block would exceed the printable page, increments lPage and cancels the current detail print so a wrapper can re-print header/footer.
// Parameters: $1 Text mode ("Tall", "Portrait", or ""); optional $2 Longint layout height (from detail band). If omitted, uses lastLayoutSize from shared traveler context or measures *;"@".
// Returns: $0 Longint rough page count estimate (minimum 1).
// modified by 4D/PS [2026-april-28]
// Purpose: Use _ga_TravelerPrintGetCtx shared object instead of interprocess <>ga_travPrintCtx.
// modified by 4D/PS [2026-april-27]

var $detailHeight; $left; $top; $right; $bottom : Integer
var $layoutSize : Integer
var $printableW; $printableH; $lPrintedHeight : Integer
var $hPaper; $headerH; $marginB : Integer
var $ctx : Object

$ctx:=_ga_TravelerPrintGetCtx
If ($ctx.hPaper=0)
	_ga_TravelerPrintBegin
End if 

$hPaper:=$ctx.hPaper
$headerH:=$ctx.travelerHeaderHeight
$marginB:=$ctx.marginBottom

Case of 
	: ($1="Tall") | ($1="Portrait")
		$detailHeight:=83
	Else 
		$detailHeight:=53
End case 

$0:=1

If (Count parameters:C259>1)
	$layoutSize:=$2
Else 
	If ($ctx.lastLayoutSize#Null:C1517)
		$layoutSize:=$ctx.lastLayoutSize
	Else 
		OBJECT GET COORDINATES:C663(*; "@"; $left; $top; $right; $bottom)
		$layoutSize:=$bottom-$top
	End if 
End if 

GET PRINTABLE AREA:C703($printableW; $printableH)
$lPrintedHeight:=Get printed height:C702

If ($layoutSize>($hPaper-$detailHeight-$headerH-$marginB))
	$0:=Int:C8($layoutSize/($hPaper-$detailHeight-$headerH-$marginB))+1
	$layoutSize:=($hPaper-$detailHeight-$headerH-$marginB)-20
End if 

If (($lPrintedHeight+$layoutSize+$detailHeight)>=$printableH)
	Use ($ctx)
		$ctx.lPage:=$ctx.lPage+1
	End use
	CANCEL:C270
End if 
