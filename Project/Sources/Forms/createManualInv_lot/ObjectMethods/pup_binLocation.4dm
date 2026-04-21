var $value; $choice; $currentPath; $param; $candidate : Text
var $depth; $i; $idx : Integer
var $left; $top; $right; $bottom; $menuX; $menuY : Integer
var $wLeft; $wTop; $wRight; $wBottom; $btnWidth : Integer
var $stop; $isTerm : Boolean
var $parts; $options; $partsChoice; $terminalFlags; $opts : Collection
var $params : Object
var $winRef : Integer

//If (Form.selectedPath#"")
//$currentPath:=Form.selectedPath
//Else 
$currentPath:=""
//End if 

$stop:=False:C215
OBJECT GET COORDINATES:C663(*; "pup_binLocation"; $left; $top; $right; $bottom)
//$btnWidth:=$right-$left
CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
//GET WINDOW RECT($wLeft; $wTop; $wRight; $wBottom)
$menuX:=$left
$menuY:=$bottom+30
Repeat 
	$parts:=New collection:C1472
	If ($currentPath#"")
		$parts:=Split string:C1554($currentPath; "/")
	End if 
	$depth:=$parts.length
	
	$options:=New collection:C1472
	For each ($bin; Storage:C1525.cache.bins)
		$partsChoice:=Split string:C1554($bin.binLocationPath; "/")
		If ($partsChoice.length>$depth)
			$param:=""
			For ($i; 0; $depth-1)
				If ($partsChoice[$i]#$parts[$i])
					$param:="noMatch"
					$i:=$depth
				End if 
			End for 
			If ($param#"noMatch")
				$value:=$partsChoice[$depth]
				If ($options.indexOf($value)=-1)
					$options.push($value)
				End if 
			End if 
		End if 
	End for each 
	
	$terminalFlags:=New collection:C1472
	For each ($value; $options)
		If ($currentPath="")
			$candidate:=$value
		Else 
			$candidate:=$currentPath+"/"+$value
		End if 
		$isTerm:=True:C214
		For each ($bin; Storage:C1525.cache.bins) Until (Not:C34($isTerm))
			If (Length:C16($bin.binLocationPath)>=(Length:C16($candidate)+2))
				If (Substring:C12($bin.binLocationPath; 1; Length:C16($candidate)+1)=($candidate+"/"))
					$isTerm:=False:C215
				End if 
			End if 
		End for each 
		$terminalFlags.push($isTerm)
	End for each 
	
	$opts:=New collection:C1472
	$idx:=0
	For each ($value; $options)
		If ($terminalFlags[$idx])
			$opts.push(New object:C1471("label"; $value; "value"; "selectFinal|"+$value; "kind"; "green"))
		Else 
			$opts.push(New object:C1471("label"; $value; "value"; "select|"+$value; "kind"; "blue"))
		End if 
		$idx:=$idx+1
	End for each 
	
	If ($depth>0)
		//$opts.push(New object("label"; "--------------------"; "value"; ""; "kind"; "separator"))
		$opts.push(New object:C1471("label"; "<"; "value"; "back"))
		$opts.push(New object:C1471("label"; "<<"; "value"; "backToRoot"))
	End if 
	
	$params:=New object:C1471("options"; $opts; "choice"; ""; "width"; $btnWidth)
	$winRef:=Open form window:C675("_popup_binLocation"; Movable form dialog box:K39:8; $menuX; $menuY)
	SET WINDOW TITLE:C213("Select a Location"; $winRef)
	DIALOG:C40("_popup_binLocation"; $params)
	CLOSE WINDOW:C154($winRef)
	
	If (ok=1)
		$choice:=$params.choice
	Else 
		$choice:=""
	End if 
	
	If ($choice="")
		$stop:=True:C214
	Else 
		Case of 
			: ($choice="back")
				$partsChoice:=Split string:C1554($currentPath; "/")
				$currentPath:=""
				For ($i; 0; $partsChoice.length-2)
					If ($currentPath="")
						$currentPath:=$partsChoice[$i]
					Else 
						$currentPath:=$currentPath+"/"+$partsChoice[$i]
					End if 
				End for 
			: ($choice="backToRoot")
				$currentPath:=""
			: ($choice="finish")
				$stop:=True:C214
			Else 
				$partsChoice:=Split string:C1554($choice; "|")
				If ($partsChoice.length>1)
					If (($partsChoice[0]="select") | ($partsChoice[0]="selectFinal"))
						If ($currentPath="")
							$currentPath:=$partsChoice[1]
						Else 
							$currentPath:=$currentPath+"/"+$partsChoice[1]
						End if 
						If ($partsChoice[0]="selectFinal")
							$stop:=True:C214
						End if 
					End if 
				End if 
		End case 
	End if 
Until ($stop)

If ($currentPath#"")
	Form:C1466.selectedBins:=Storage:C1525.cache.bins.query("binLocationPath = :1"; $currentPath)
	If (Form:C1466.selectedBins#Null:C1517)
		Form:C1466.inventory_e.UUID_Location:=Form:C1466.selectedBins.first().UUID
	End if 
	OBJECT SET TITLE:C194(*; "pup_binLocation"; $currentPath)
End if 
