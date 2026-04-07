//%attributes = {}
//BackgroundColor lb_bins baesd on bin type
//"Good"; "Rejects"; "Mechanical Rejects"; "Missing or Excluded"

Case of 
		
	: (This:C1470.type="Good")
		$0:="#66CDAA"
	: (This:C1470.type="Rejects")
		$0:="#FA8072"
	: (This:C1470.type="Mechanical Rejects")
		$0:="#FA8072"
	: (This:C1470.type="Missing or Excluded")
		$0:="#FFA500"
	Else 
		$0:="transparent"
End case 
