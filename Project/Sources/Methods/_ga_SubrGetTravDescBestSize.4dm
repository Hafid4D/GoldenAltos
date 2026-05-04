//%attributes = {}
// Purpose: Compute best height for the LotStep description area on traveler print forms (ported from legacy SubrGetTravDescBestSize). Optionally expands TravPrintList when lbRowCount is set on the shared traveler context (_ga_TravelerPrintGetCtx).
// Parameters: $1 Longint maxRows; $2 Longint footerHt; $3 Text form object name bound to [LotStep]description (e.g. Field1).
// Returns: $0 Longint recommended description height (pixels). Also sets lastDesignDescHeight (design-time height before grow) on the shared context.
// Side effect: May prefix [LotStep:5]description:4 with a truncation warning when text exceeds one page.
// modified by 4D/PS [2026-april-28]
// Purpose: Read/write traveler context via shared object from Storage instead of interprocess variables.
// modified by 4D/PS [2026-april-27]

var $hght; $wdth : Integer
var $left; $top; $right; $bottom : Integer
var $layoutSize : Integer
var $fixedWidth; $stepDescDesignHeight : Integer
var $hPaper; $footer; $headerH; $marginB : Integer
var $objNames : Array Text
var $pos : Integer
var $rowHeight; $plTop; $plLeft; $plRight; $plBottom : Integer
var $projectedSize : Integer
var $lbRows : Integer
var $ctx : Object

$ctx:=_ga_TravelerPrintGetCtx
If ($ctx.hPaper=0)
	_ga_TravelerPrintBegin
End if 

$lbRows:=$ctx.lbRowCount
$hPaper:=$ctx.hPaper
$headerH:=$ctx.travelerHeaderHeight
$marginB:=$ctx.marginBottom

OBJECT GET COORDINATES:C663(*; "@"; $left; $top; $right; $bottom)
$layoutSize:=$bottom-$top

OBJECT GET COORDINATES:C663(*; $3; $left; $top; $right; $bottom)
$fixedWidth:=$right-$left
$stepDescDesignHeight:=$bottom-$top
Use ($ctx)
	$ctx.lastDesignDescHeight:=$stepDescDesignHeight
End use 

OBJECT GET BEST SIZE:C717(*; $3; $wdth; $hght; $fixedWidth)
$hght:=$hght+20

If ($hght>($hPaper-$2-$headerH-$marginB))
	$hght:=$hPaper-$2-$headerH-$marginB-20
	[LotStep:5]description:4:="DESCRIPTION MAY BE TRUNCATED"+Char:C90(13)+[LotStep:5]description:4
End if 

$0:=$hght

ARRAY TEXT:C222($objNames; 0)
FORM GET OBJECTS:C898($objNames)
$pos:=Find in array:C230($objNames; "TravPrintList")
If ($pos>0) & ($lbRows>0)
	$rowHeight:=16
	If ($hght<$layoutSize)
		OBJECT GET COORDINATES:C663(*; "TravPrintList"; $plLeft; $plTop; $plRight; $plBottom)
		If ($lbRows>$1)
			$projectedSize:=$rowHeight*$1
		Else 
			$projectedSize:=$rowHeight*($lbRows+2)
		End if 
		OBJECT SET COORDINATES:C1248(*; "TravPrintList"; $plLeft; $plTop; $plRight; $plTop+$projectedSize)
		If ($hght<($layoutSize+$projectedSize))
			$0:=$layoutSize+$projectedSize
		End if 
	End if 
End if 
