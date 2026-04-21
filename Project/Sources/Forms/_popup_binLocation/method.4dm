var $rowHeight; $buttonBarHeight; $wantedWidth; $wantedHeight : Integer
var $maxLabelLen; $minWidth; $maxWidth; $maxHeight : Integer
var $item : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Form:C1466.options=Null:C1517)
			Form:C1466.options:=New collection:C1472
		End if 
		If (Form:C1466.choice=Null:C1517)
			Form:C1466.choice:=""
		End if 
		
		$rowHeight:=22
		$buttonBarHeight:=55
		$maxHeight:=500
		$minWidth:=260
		$maxWidth:=600
		
		$wantedHeight:=(Form:C1466.options.length*$rowHeight)+$buttonBarHeight+10
		If ($wantedHeight>$maxHeight)
			$wantedHeight:=$maxHeight
		End if 
		
		$maxLabelLen:=0
		For each ($item; Form:C1466.options)
			If (Length:C16($item.label)>$maxLabelLen)
				$maxLabelLen:=Length:C16($item.label)
			End if 
		End for each 
		$wantedWidth:=($maxLabelLen*8)+40
		
		If (Form:C1466.width#Null:C1517)
			If (Form:C1466.width>$wantedWidth)
				$wantedWidth:=Form:C1466.width
			End if 
		End if 
		If ($wantedWidth<$minWidth)
			$wantedWidth:=$minWidth
		End if 
		If ($wantedWidth>$maxWidth)
			$wantedWidth:=$maxWidth
		End if 
		
		RESIZE FORM WINDOW:C890($wantedWidth; $wantedHeight)
		
	: (Form event code:C388=On Outside Call:K2:11)
		CANCEL:C270
End case 
