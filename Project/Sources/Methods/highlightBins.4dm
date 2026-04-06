//%attributes = {}
//BackgroundColor lb_bins baesd on bin type
//"Good"; "Rejects"; "Mechanical Rejects"; "Missing or Excluded"

Case of 
		
	: (This:C1470.type="Good")
		$0:="#66CDAA"
	: (This:C1470.type="Rejects")
		$0:="#FF0000"
	: (This:C1470.type="Mechanical Rejects")
		$0:="#FF0000"
	: (This:C1470.type="Missing or Excluded")
		$0:="#FF8C00"
	Else 
		$0:="transparent"
End case 
