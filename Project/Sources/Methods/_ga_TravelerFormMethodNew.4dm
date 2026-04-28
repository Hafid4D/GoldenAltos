//%attributes = {}
// Purpose: GoldenAltos port of legacy TravelerFormMethodNew (erp2020v18). On On Printing Detail, grows the LotStep description field, adjusts print markers and optional chrome (Rectangle1, VLine1/2), calls _ga_PrintTOF for pagination, and records large steps on the shared context's largeStepOrders. Requires _ga_TravelerPrintBegin before the print loop; set fireDetail to False on the shared context (Use + assign) to skip (legacy FireFormPrintDetailMethod).
// Parameters: $1 Text current method name (e.g. "[LotStep].bake"); $2 Text optional layout mode ("Tall", "Portrait", or "").
// Table / form: expects current printed record to be [LotStep:5] and form objects Field1 or Field2 for description (see _ga_TravelerDescObjectForForm).
// modified by 4D/PS [2026-april-28]
// Purpose: Use _ga_TravelerPrintGetCtx (Storage + shared object) instead of interprocess <>ga_travPrintCtx.
// modified by 4D/PS [2026-april-27]

var $tablePrefix; $formName; $mode : Text
var $left; $top; $right; $bottom : Integer
var $Lm; $Tm; $Rm; $Bm : Integer
var $MaxRows; $FooterHt; $hght : Integer
var $MarkPicExistsOnLayout : Boolean
var $IncreaseDescHt; $DetailMovement; $position : Integer
var $sl; $st; $sr; $sbb : Integer
var $final_pos : Integer
var $Rectleft; $Recttop; $Rectright; $Rectbottom : Integer
var $LineLeft; $LineTop; $LineRight; $LineBottom : Integer
var $NumberofPagesReqd : Integer
var $descObj : Text
ARRAY POINTER:C280($objNames; 0)
var $posMark : Integer
var $isDev; $tpl200 : Boolean
var $ctx : Object

$ctx:=_ga_TravelerPrintGetCtx
If ($ctx.fireDetail=False:C215)
	return 
End if 
// Lazy init: shared context defaults hPaper to 0 until _ga_TravelerPrintBegin runs
If ($ctx.hPaper=0)
	_ga_TravelerPrintBegin
End if 

$tablePrefix:="["+Table name:C256(->[LotStep:5])+"]."
$formName:=Replace string:C233($1; $tablePrefix; "")
If ($formName=$1)  // Current method name may omit table prefix in some contexts
	$formName:=Replace string:C233($formName; "["+Table name:C256(->[LotStep:5])+"]"; "")
End if 
$mode:=""
If (Count parameters:C259>1)
	$mode:=$2
End if 

Case of 
	: (Form event code:C388=On Printing Detail:K2:18) & ($ctx.fireDetail=True:C214)
		
		ARRAY TEXT:C222($objNames; 0)
		FORM GET OBJECTS:C898($objNames)
		
		OBJECT GET COORDINATES:C663(*; "@"; $left; $top; $right; $bottom)
		Use ($ctx)
			$ctx.lastLayoutSize:=$bottom-$top
		End use 
		
		$Bm:=0
		$Tm:=0
		$posMark:=Find in array:C230($objNames; "markpict")
		If ($posMark>0)
			OBJECT GET COORDINATES:C663(*; "markpict"; $Lm; $Tm; $Rm; $Bm)
		Else 
			$posMark:=Find in array:C230($objNames; "Markpict")
			If ($posMark>0)
				OBJECT GET COORDINATES:C663(*; "Markpict"; $Lm; $Tm; $Rm; $Bm)
			End if 
		End if 
		
		Case of 
			: ($mode="Tall") | ($mode="Portrait")
				$MaxRows:=16
				$FooterHt:=80
			Else 
				$MaxRows:=10
				$FooterHt:=50
		End case 
		
		$descObj:=_ga_TravelerDescObjectForForm($formName)
		$hght:=_ga_SubrGetTravDescBestSize($MaxRows; $FooterHt; $descObj)
		
		If ($Bm=0) & ($Tm=0)
			$MarkPicExistsOnLayout:=False:C215
		Else 
			$MarkPicExistsOnLayout:=True:C214
			$tpl200:=$ctx.templateMarkBit200=True:C214
			If $tpl200
				$Bm:=0
			End if 
		End if 
		
		$IncreaseDescHt:=$hght-($ctx.lastDesignDescHeight)
		$DetailMovement:=$IncreaseDescHt-$Bm
		$position:=Get print marker:C708(Form detail:K43:1)
		If ($DetailMovement>0)
			SET PRINT MARKER:C709(Form detail:K43:1; $position+$DetailMovement; *)
		End if 
		
		If ($IncreaseDescHt#0)
			OBJECT GET COORDINATES:C663(*; $descObj; $sl; $st; $sr; $sbb)
			$isDev:=$ctx.isDeviceLinked=True:C214
			$tpl200:=$ctx.templateMarkBit200=True:C214
			Case of 
				: ($isDev) & ($tpl200)
					OBJECT MOVE:C664(*; $descObj; $sl; $st; $sr; $st+$hght; *)
				Else 
					If ($mode="Tall")
						$Bm:=$Bm-20
					End if 
					OBJECT MOVE:C664(*; $descObj; $sl; $st-$Bm; $sr; $st+$hght-$Bm; *)
			End case 
			
			$final_pos:=$position+$IncreaseDescHt-$Bm
			If (Find in array:C230($objNames; "Rectangle1")>0)
				OBJECT GET COORDINATES:C663(*; "Rectangle1"; $Rectleft; $Recttop; $Rectright; $Rectbottom)
				If ($DetailMovement>0)
					OBJECT MOVE:C664(*; "Rectangle1"; $Rectleft; $Recttop; $Rectright; $Rectbottom+$IncreaseDescHt; *)
				End if 
			End if 
			If ($DetailMovement>0)
				If (Find in array:C230($objNames; "VLine1")>0)
					OBJECT GET COORDINATES:C663(*; "VLine1"; $LineLeft; $LineTop; $LineRight; $LineBottom)
					OBJECT MOVE:C664(*; "VLine1"; $LineLeft; $LineTop; $LineRight; $final_pos; *)
				End if 
				If (Find in array:C230($objNames; "VLine2")>0)
					OBJECT GET COORDINATES:C663(*; "VLine2"; $LineLeft; $LineTop; $LineRight; $LineBottom)
					OBJECT MOVE:C664(*; "VLine2"; $LineLeft; $LineTop; $LineRight; $final_pos; *)
				End if 
			End if 
		End if 
		
		$NumberofPagesReqd:=_ga_PrintTOF($mode; $ctx.lastLayoutSize)
		If ($NumberofPagesReqd>1) | ($ctx.lbRowCount>$MaxRows)
			If ($ctx.largeStepOrders.indexOf([LotStep:5]order:3)=-1)
				Use ($ctx)
					$ctx.largeStepOrders.push([LotStep:5]order:3)
				End use 
			End if 
		End if 
		
End case 
